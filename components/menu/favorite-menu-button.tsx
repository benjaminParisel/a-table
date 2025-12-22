"use client";

import { useState } from "react";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";

interface FavoriteMenuButtonProps {
  recipeIds: string[];
  isFavorited?: boolean;
  onSaved?: () => void;
}

export function FavoriteMenuButton({
  recipeIds,
  isFavorited: initialFavorited = false,
  onSaved,
}: FavoriteMenuButtonProps) {
  const [isFavorited, setIsFavorited] = useState(initialFavorited);
  const [isLoading, setIsLoading] = useState(false);

  const handleSave = async () => {
    setIsLoading(true);

    try {
      const res = await fetch("/api/menu/favorite", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ recipe_ids: recipeIds }),
      });

      if (!res.ok) {
        throw new Error("Erreur lors de la sauvegarde");
      }

      setIsFavorited(true);
      toast.success(
        initialFavorited
          ? "Menu favori mis à jour !"
          : "Menu sauvegardé en favori !"
      );
      onSaved?.();
    } catch {
      toast.error("Erreur lors de la sauvegarde du menu");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={handleSave}
      disabled={isLoading}
      title={isFavorited ? "Menu favori" : "Sauvegarder en favori"}
      className="h-11 w-11 touch-manipulation active:scale-110 transition-transform"
    >
      <Star
        className={`h-6 w-6 ${
          isFavorited ? "fill-yellow-400 text-yellow-400" : ""
        }`}
      />
    </Button>
  );
}
