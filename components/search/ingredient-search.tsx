"use client";

import { useState } from "react";
import { Search, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ChipInput } from "@/components/ui/chip-input";
import { RecipeCard } from "@/components/recipes/recipe-card";
import type { IngredientSearchResult } from "@/types";

export function IngredientSearch() {
  const [ingredients, setIngredients] = useState<string[]>([]);
  const [results, setResults] = useState<IngredientSearchResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [hasSearched, setHasSearched] = useState(false);

  const handleSearch = async () => {
    if (ingredients.length === 0) {
      setError("Ajoutez au moins un ingrédient");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const res = await fetch("/api/recipes/search-by-ingredients", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ingredients }),
      });

      if (!res.ok) {
        throw new Error("Erreur lors de la recherche");
      }

      const data = await res.json();
      setResults(data.data || []);
      setHasSearched(true);
    } catch {
      setError("Erreur lors de la recherche");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-8">
      <div className="space-y-4">
        <p className="text-muted-foreground">
          Entrez les ingrédients que vous avez sous la main. La recherche
          affichera les recettes qui contiennent <strong>tous</strong> ces
          ingrédients.
        </p>
        <ChipInput
          value={ingredients}
          onChange={setIngredients}
          placeholder="Ajouter un ingrédient (Entrée pour valider)..."
          disabled={loading}
        />
      </div>

      <div className="flex justify-center">
        <Button
          onClick={handleSearch}
          disabled={loading || ingredients.length === 0}
          size="lg"
        >
          {loading ? (
            <>
              <RefreshCw className="mr-2 h-4 w-4 animate-spin" />
              Recherche...
            </>
          ) : (
            <>
              <Search className="mr-2 h-4 w-4" />
              Rechercher
            </>
          )}
        </Button>
      </div>

      {error && <p className="text-center text-destructive">{error}</p>}

      {hasSearched && results.length === 0 && (
        <p className="text-center text-muted-foreground">
          Aucune recette ne contient tous ces ingrédients.
        </p>
      )}

      {results.length > 0 && (
        <div className="space-y-4">
          <h2 className="text-xl font-semibold text-center">
            {results.length} recette{results.length > 1 ? "s" : ""} trouvée
            {results.length > 1 ? "s" : ""}
          </h2>
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {results.map(({ recipe }) => (
              <RecipeCard key={recipe.id} recipe={recipe} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
