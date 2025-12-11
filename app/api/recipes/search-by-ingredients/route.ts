import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser } from "@/lib/supabase/server";
import { z } from "zod";
import type { Category, Tag, RecipeWithRelations, IngredientSearchResult } from "@/types";

const searchSchema = z.object({
  ingredients: z.array(z.string().min(1)).min(1),
});

function normalizeText(text: string): string {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .trim();
}

function ingredientContains(ingredientLine: string, searchTerm: string): boolean {
  const normalizedLine = normalizeText(ingredientLine);
  const normalizedSearch = normalizeText(searchTerm);
  return normalizedLine.includes(normalizedSearch);
}

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = searchSchema.parse(body);

    const { data: recipes, error } = await supabase
      .from("recipes")
      .select(
        `
        *,
        category:categories(*),
        tags:recipe_tags(tag:tags(*))
      `
      );

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    if (!recipes || recipes.length === 0) {
      return NextResponse.json({ data: [] });
    }

    const results: IngredientSearchResult[] = [];

    for (const recipe of recipes) {
      if (!recipe.ingredients) continue;

      const recipeIngredients: string[] = recipe.ingredients.split("\n").filter(Boolean);
      const matchedIngredients: string[] = [];

      for (const searchIngredient of validated.ingredients) {
        const found = recipeIngredients.some((line) =>
          ingredientContains(line, searchIngredient)
        );
        if (found) {
          matchedIngredients.push(searchIngredient);
        }
      }

      if (matchedIngredients.length === validated.ingredients.length) {
        const recipeWithRelations: RecipeWithRelations = {
          ...recipe,
          category: recipe.category as Category,
          tags: (recipe.tags as { tag: Tag }[]).map((t) => t.tag),
          author: null,
        };

        results.push({
          recipe: recipeWithRelations,
          matchedIngredients,
          matchCount: matchedIngredients.length,
        });
      }
    }

    results.sort((a, b) => {
      const aIngredientCount = a.recipe.ingredients?.split("\n").filter(Boolean).length || 0;
      const bIngredientCount = b.recipe.ingredients?.split("\n").filter(Boolean).length || 0;
      return aIngredientCount - bIngredientCount;
    });

    return NextResponse.json({ data: results });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({ error: error.issues }, { status: 400 });
    }
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
