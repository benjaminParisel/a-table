"use client";

import { useEffect, useState } from "react";
import { Trash2, Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { RecipeCard } from "@/components/recipes/recipe-card";
import { toast } from "sonner";
import type { FavoriteMenuWithRecipes } from "@/types";

interface FavoriteMenuDisplayProps {
  onDeleted?: () => void;
}

export function FavoriteMenuDisplay({ onDeleted }: FavoriteMenuDisplayProps) {
  const [favoriteMenu, setFavoriteMenu] =
    useState<FavoriteMenuWithRecipes | null>(null);
  const [loading, setLoading] = useState(true);
  const [deleting, setDeleting] = useState(false);

  const fetchFavorite = async () => {
    try {
      const res = await fetch("/api/menu/favorite");
      if (res.ok) {
        const data = await res.json();
        setFavoriteMenu(data.data);
      }
    } catch {
      // Silently fail
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchFavorite();
  }, []);

  const handleDelete = async () => {
    setDeleting(true);

    try {
      const res = await fetch("/api/menu/favorite", {
        method: "DELETE",
      });

      if (!res.ok) {
        throw new Error("Erreur lors de la suppression");
      }

      setFavoriteMenu(null);
      toast.success("Menu favori supprimé");
      onDeleted?.();
    } catch {
      toast.error("Erreur lors de la suppression");
    } finally {
      setDeleting(false);
    }
  };

  if (loading || !favoriteMenu) {
    return null;
  }

  return (
    <Card className="border-yellow-200 dark:border-yellow-800">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="flex items-center gap-2 text-lg">
          <Star className="h-5 w-5 fill-yellow-400 text-yellow-400" />
          Mon menu favori
        </CardTitle>
        <Button
          variant="ghost"
          size="icon"
          onClick={handleDelete}
          disabled={deleting}
          title="Supprimer le menu favori"
        >
          <Trash2 className="h-4 w-4 text-destructive" />
        </Button>
      </CardHeader>
      <CardContent>
        <div className="flex flex-wrap justify-center gap-4">
          {favoriteMenu.recipes.map((recipe) => (
            <div key={recipe.id} className="w-full max-w-xs space-y-2">
              <h3 className="text-sm font-medium text-muted-foreground uppercase text-center">
                {recipe.category.name}
              </h3>
              <RecipeCard recipe={recipe} />
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}

export function useFavoriteMenu() {
  const [favoriteRecipeIds, setFavoriteRecipeIds] = useState<string[]>([]);

  useEffect(() => {
    const fetchFavorite = async () => {
      try {
        const res = await fetch("/api/menu/favorite");
        if (res.ok) {
          const data = await res.json();
          if (data.data) {
            setFavoriteRecipeIds(
              data.data.recipes.map((r: { id: string }) => r.id)
            );
          }
        }
      } catch {
        // Silently fail
      }
    };

    fetchFavorite();
  }, []);

  const isCurrentMenuFavorite = (recipeIds: string[]) => {
    if (
      favoriteRecipeIds.length === 0 ||
      recipeIds.length !== favoriteRecipeIds.length
    ) {
      return false;
    }
    return recipeIds.every((id) => favoriteRecipeIds.includes(id));
  };

  return { favoriteRecipeIds, isCurrentMenuFavorite, setFavoriteRecipeIds };
}
