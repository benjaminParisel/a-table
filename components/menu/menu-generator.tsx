"use client";

import { useState, useCallback } from "react";
import { Dices, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";
import { RecipeCard } from "@/components/recipes/recipe-card";
import { FavoriteMenuButton } from "@/components/menu/favorite-menu-button";
import {
  FavoriteMenuDisplay,
  useFavoriteMenu,
} from "@/components/menu/favorite-menu-display";
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
  const [generatedMenus, setGeneratedMenus] = useState<RecipeWithRelations[][]>([]);
  const [menuCount, setMenuCount] = useState(1);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [refreshKey, setRefreshKey] = useState(0);

  const { isCurrentMenuFavorite, setFavoriteRecipeIds } = useFavoriteMenu();

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
        body: JSON.stringify({ categories: selectedCategories, count: menuCount }),
      });

      if (!res.ok) {
        throw new Error("Erreur lors de la génération");
      }

      const data = await res.json();
      setGeneratedMenus(data.menus);
    } catch {
      setError("Erreur lors de la génération du menu");
    } finally {
      setLoading(false);
    }
  };

  const handleFavoriteSaved = useCallback((menuIndex: number) => {
    const recipeIds = generatedMenus[menuIndex]?.map((r) => r.id) || [];
    setFavoriteRecipeIds(recipeIds);
    setRefreshKey((k) => k + 1);
  }, [generatedMenus, setFavoriteRecipeIds]);

  const handleFavoriteDeleted = useCallback(() => {
    setFavoriteRecipeIds([]);
    setRefreshKey((k) => k + 1);
  }, [setFavoriteRecipeIds]);

  const getMenuRecipeIds = (menuIndex: number) =>
    generatedMenus[menuIndex]?.map((r) => r.id) || [];

  const isMenuFavorited = (menuIndex: number) =>
    isCurrentMenuFavorite(getMenuRecipeIds(menuIndex));

  return (
    <div className="space-y-8">
      <FavoriteMenuDisplay key={refreshKey} onDeleted={handleFavoriteDeleted} />

      <div className="space-y-4">
        <h2 className="text-lg font-semibold">
          Sélectionnez les catégories à inclure :
        </h2>
        <div className="flex flex-wrap gap-2">
          {categories.map((category) => (
            <div
              key={category.id}
              className={`flex items-center space-x-2 p-3 rounded-lg border touch-manipulation transition-colors ${
                category.recipe_count === 0
                  ? "opacity-50"
                  : selectedCategories.includes(category.slug)
                  ? "bg-primary/10 border-primary"
                  : "active:bg-muted/50"
              }`}
              onClick={() => category.recipe_count > 0 && toggleCategory(category.slug)}
            >
              <Checkbox
                id={`cat-${category.slug}`}
                checked={selectedCategories.includes(category.slug)}
                onCheckedChange={() => toggleCategory(category.slug)}
                disabled={category.recipe_count === 0}
                className="h-5 w-5"
              />
              <Label
                htmlFor={`cat-${category.slug}`}
                className={`cursor-pointer text-base ${
                  category.recipe_count === 0
                    ? "text-muted-foreground line-through"
                    : ""
                }`}
              >
                {category.name}
                {category.recipe_count === 0 && " (vide)"}
              </Label>
            </div>
          ))}
        </div>
      </div>

      <div className="space-y-4">
        <h2 className="text-lg font-semibold">
          Nombre de menus à générer : {menuCount}
        </h2>
        <div className="max-w-sm">
          <Slider
            value={[menuCount]}
            onValueChange={(value) => setMenuCount(value[0])}
            min={1}
            max={5}
            step={1}
            className="py-2"
          />
          <div className="flex justify-between text-sm text-muted-foreground mt-2">
            <span>1</span>
            <span>2</span>
            <span>3</span>
            <span>4</span>
            <span>5</span>
          </div>
        </div>
      </div>

      <div className="flex justify-center px-4">
        <Button
          onClick={generateMenu}
          disabled={loading || selectedCategories.length === 0}
          size="lg"
          className="w-full sm:w-auto h-14 sm:h-12 text-base"
        >
          {loading ? (
            <>
              <RefreshCw className="mr-2 h-4 w-4 animate-spin" />
              Génération...
            </>
          ) : generatedMenus.length > 0 ? (
            <>
              <RefreshCw className="mr-2 h-4 w-4" />
              Régénérer
            </>
          ) : (
            <>
              <Dices className="mr-2 h-4 w-4" />
              Générer {menuCount > 1 ? `${menuCount} menus` : "un menu"}
            </>
          )}
        </Button>
      </div>

      {error && <p className="text-center text-destructive">{error}</p>}

      {generatedMenus.length > 0 && (
        <div className="space-y-8">
          {generatedMenus.map((menu, menuIndex) => (
            <div key={menuIndex} className="space-y-4 rounded-lg border p-4 sm:p-6">
              <div className="flex items-center justify-center gap-3">
                <h2 className="text-xl font-semibold">
                  {generatedMenus.length > 1 ? `Menu ${menuIndex + 1}` : "Votre menu"}
                </h2>
                <FavoriteMenuButton
                  recipeIds={getMenuRecipeIds(menuIndex)}
                  isFavorited={isMenuFavorited(menuIndex)}
                  onSaved={() => handleFavoriteSaved(menuIndex)}
                />
              </div>
              <div className="grid gap-4 grid-cols-1 min-[480px]:grid-cols-2 lg:grid-cols-3">
                {menu.map((recipe) => (
                  <div key={recipe.id} className="space-y-2">
                    <h3 className="text-sm font-medium text-muted-foreground uppercase text-center">
                      {recipe.category.name}
                    </h3>
                    <RecipeCard recipe={recipe} />
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
