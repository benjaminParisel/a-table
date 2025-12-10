"use client";

import { useState } from "react";
import { Dices, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { RecipeCard } from "@/components/recipes/recipe-card";
import type { Category, RecipeWithRelations } from "@/types";

interface MenuGeneratorProps {
  categories: (Category & { recipe_count: number })[];
}

export function MenuGenerator({ categories }: MenuGeneratorProps) {
  const [selectedCategories, setSelectedCategories] = useState<string[]>(
    categories
      .filter((c) => ["starter", "main", "dessert"].includes(c.slug))
      .map((c) => c.slug)
  );
  const [generatedMenu, setGeneratedMenu] = useState<RecipeWithRelations[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const toggleCategory = (slug: string) => {
    setSelectedCategories((prev) =>
      prev.includes(slug)
        ? prev.filter((s) => s !== slug)
        : [...prev, slug]
    );
  };

  const generateMenu = async () => {
    if (selectedCategories.length === 0) {
      setError("Sélectionnez au moins une catégorie");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const res = await fetch("/api/menu/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ categories: selectedCategories }),
      });

      if (!res.ok) {
        throw new Error("Erreur lors de la génération");
      }

      const data = await res.json();
      setGeneratedMenu(data.recipes);
    } catch {
      setError("Erreur lors de la génération du menu");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-8">
      <div className="space-y-4">
        <h2 className="text-lg font-semibold">
          Sélectionnez les catégories à inclure :
        </h2>
        <div className="flex flex-wrap gap-4">
          {categories.map((category) => (
            <div key={category.id} className="flex items-center space-x-2">
              <Checkbox
                id={`cat-${category.slug}`}
                checked={selectedCategories.includes(category.slug)}
                onCheckedChange={() => toggleCategory(category.slug)}
                disabled={category.recipe_count === 0}
              />
              <Label
                htmlFor={`cat-${category.slug}`}
                className={`cursor-pointer ${
                  category.recipe_count === 0
                    ? "text-muted-foreground line-through"
                    : ""
                }`}
              >
                {category.name}
                {category.recipe_count === 0 && " (aucune recette)"}
              </Label>
            </div>
          ))}
        </div>
      </div>

      <div className="flex justify-center">
        <Button
          onClick={generateMenu}
          disabled={loading || selectedCategories.length === 0}
          size="lg"
        >
          {loading ? (
            <>
              <RefreshCw className="mr-2 h-4 w-4 animate-spin" />
              Génération...
            </>
          ) : generatedMenu.length > 0 ? (
            <>
              <RefreshCw className="mr-2 h-4 w-4" />
              Régénérer
            </>
          ) : (
            <>
              <Dices className="mr-2 h-4 w-4" />
              Générer un menu
            </>
          )}
        </Button>
      </div>

      {error && <p className="text-center text-destructive">{error}</p>}

      {generatedMenu.length > 0 && (
        <div className="space-y-4">
          <h2 className="text-xl font-semibold text-center">Votre menu :</h2>
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {generatedMenu.map((recipe) => (
              <div key={recipe.id} className="space-y-2">
                <h3 className="text-sm font-medium text-muted-foreground uppercase text-center">
                  {recipe.category.name}
                </h3>
                <RecipeCard recipe={recipe} />
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
