"use client";

import { useState } from "react";
import { Heart } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface FavoriteButtonProps {
  recipeId: string;
  initialFavorited?: boolean;
  onToggle?: (isFavorited: boolean) => void;
}

export function FavoriteButton({
  recipeId,
  initialFavorited = false,
  onToggle,
}: FavoriteButtonProps) {
  const [isFavorited, setIsFavorited] = useState(initialFavorited);
  const [isLoading, setIsLoading] = useState(false);

  const toggleFavorite = async (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    setIsLoading(true);

    try {
      const method = isFavorited ? "DELETE" : "POST";
      const res = await fetch("/api/recipes/favorites", {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ recipe_id: recipeId }),
      });

      if (res.ok) {
        const newState = !isFavorited;
        setIsFavorited(newState);
        onToggle?.(newState);
      }
    } catch {
      // Silent fail
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Button
      variant="ghost"
      size="icon"
      className={cn(
        "h-8 w-8 rounded-full bg-background/80 backdrop-blur-sm hover:bg-background",
        isFavorited && "text-red-500 hover:text-red-600"
      )}
      onClick={toggleFavorite}
      disabled={isLoading}
    >
      <Heart
        className={cn("h-4 w-4", isFavorited && "fill-current")}
      />
      <span className="sr-only">
        {isFavorited ? "Retirer des favoris" : "Ajouter aux favoris"}
      </span>
    </Button>
  );
}
