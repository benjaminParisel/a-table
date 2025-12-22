import Link from "next/link";
import Image from "next/image";
import { Clock, CookingPot, Users } from "lucide-react";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { formatTime } from "@/lib/utils";
import type { RecipeWithRelations } from "@/types";

interface RecipeCardProps {
  recipe: RecipeWithRelations;
}

export function RecipeCard({ recipe }: RecipeCardProps) {
  return (
    <Link href={`/recipes/${recipe.id}`}>
      <Card className="h-full overflow-hidden transition-shadow hover:shadow-lg">
        <div className="relative aspect-video bg-muted">
          {recipe.image_url ? (
            <Image
              src={recipe.image_url}
              alt={recipe.title}
              fill
              className="object-cover"
            />
          ) : (
            <div className="flex h-full items-center justify-center text-muted-foreground">
              <span className="text-4xl">🍽️</span>
            </div>
          )}
        </div>
        <CardHeader className="pb-2">
          <h3 className="font-semibold leading-tight line-clamp-2">
            {recipe.title}
          </h3>
          <p className="text-sm text-muted-foreground">
            {recipe.category.name}
          </p>
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
