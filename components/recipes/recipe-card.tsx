"use client";

import Link from "next/link";
import Image from "next/image";
import { Clock, CookingPot, Heart, Users } from "lucide-react";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { formatTime } from "@/lib/utils";
import { useFavorites } from "@/components/recipes/favorites-provider";
import { useUserPreferences } from "@/components/profile/user-preferences-provider";
import { cn } from "@/lib/utils";
import type { RecipeWithRelations } from "@/types";

interface RecipeCardProps {
  recipe: RecipeWithRelations;
  showFavoriteButton?: boolean;
}

export function RecipeCard({ recipe, showFavoriteButton = true }: RecipeCardProps) {
  const { isFavorite, toggleFavorite } = useFavorites();
  const { preferences, isLoading } = useUserPreferences();
  const favorited = isFavorite(recipe.id);

  const handleFavoriteClick = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    toggleFavorite(recipe.id);
  };

  // Ne pas afficher les images tant que les préférences ne sont pas chargées
  const shouldShowImageSection = isLoading ? false : preferences.showImages;
  const showImage = shouldShowImageSection && recipe.image_url;

  return (
    <Link href={`/recipes/${recipe.id}`}>
      <Card className="h-full overflow-hidden transition-shadow hover:shadow-lg">
        {shouldShowImageSection && (
          <div className="relative aspect-video bg-muted">
            {showImage ? (
              <Image
                src={recipe.image_url!}
                alt={recipe.title}
                fill
                className="object-cover"
              />
            ) : (
              <div className="flex h-full items-center justify-center text-muted-foreground">
                <span className="text-4xl">🍽️</span>
              </div>
            )}
            {showFavoriteButton && (
              <Button
                variant="ghost"
                size="icon"
                className={cn(
                  "absolute top-2 right-2 h-8 w-8 rounded-full bg-background/80 backdrop-blur-sm hover:bg-background",
                  favorited && "text-red-500 hover:text-red-600"
                )}
                onClick={handleFavoriteClick}
              >
                <Heart className={cn("h-4 w-4", favorited && "fill-current")} />
                <span className="sr-only">
                  {favorited ? "Retirer des favoris" : "Ajouter aux favoris"}
                </span>
              </Button>
            )}
          </div>
        )}
        <CardHeader className="pb-2">
          <div className="flex items-start justify-between gap-2">
            <div className="flex-1 min-w-0">
              <h3 className="font-semibold leading-tight line-clamp-2">
                {recipe.title}
              </h3>
              <p className="text-sm text-muted-foreground">
                {recipe.category.name}
              </p>
            </div>
            {showFavoriteButton && !shouldShowImageSection && (
              <Button
                variant="ghost"
                size="icon"
                className={cn(
                  "h-8 w-8 shrink-0",
                  favorited && "text-red-500 hover:text-red-600"
                )}
                onClick={handleFavoriteClick}
              >
                <Heart className={cn("h-4 w-4", favorited && "fill-current")} />
              </Button>
            )}
          </div>
        </CardHeader>
        <CardContent className="pt-0">
          <div className="flex items-center gap-4 text-sm text-muted-foreground">
            {recipe.prep_time != null && (
              <div className="flex items-center gap-1" title="Temps de préparation">
                <Clock className="h-4 w-4" />
                <span>{formatTime(recipe.prep_time)}</span>
              </div>
            )}
            {recipe.cook_time != null && (
              <div className="flex items-center gap-1" title="Temps de cuisson">
                <CookingPot className="h-4 w-4" />
                <span>{formatTime(recipe.cook_time)}</span>
              </div>
            )}
            {recipe.servings && (
              <div className="flex items-center gap-1">
                <Users className="h-4 w-4" />
                <span>{recipe.servings}</span>
              </div>
            )}
          </div>
          {recipe.tags.length > 0 && (
            <div className="mt-2 flex flex-wrap gap-1">
              {recipe.tags.slice(0, 3).map((tag) => (
                <Badge key={tag.id} variant="secondary" className="text-xs">
                  {tag.name}
                </Badge>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </Link>
  );
}
