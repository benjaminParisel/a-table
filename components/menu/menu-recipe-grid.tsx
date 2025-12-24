"use client";

import { RecipeCard } from "@/components/recipes/recipe-card";
import type { RecipeWithRelations } from "@/types";

interface MenuRecipeGridProps {
  recipes: RecipeWithRelations[];
}

export function MenuRecipeGrid({ recipes }: MenuRecipeGridProps) {
  return (
    <div className="grid gap-x-4 gap-y-8 grid-cols-1 min-[480px]:grid-cols-2 lg:grid-cols-3 pb-4">
      {recipes.map((recipe) => (
        <div key={recipe.id} className="space-y-2 min-w-0">
          <h3 className="text-sm font-medium text-muted-foreground uppercase text-center">
            {recipe.category.name}
          </h3>
          <RecipeCard recipe={recipe} />
        </div>
      ))}
    </div>
  );
}
