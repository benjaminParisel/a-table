import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser } from "@/lib/supabase/server";
import { z } from "zod";
import type { Category, Tag, RecipeWithRelations } from "@/types";

const favoriteSchema = z.object({
  recipe_id: z.string().uuid(),
});

// GET - Fetch all favorite recipes for current user
export async function GET() {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    // Get favorite recipe IDs
    const { data: favorites, error: favError } = await supabase
      .from("favorite_recipes")
      .select("recipe_id")
      .eq("user_id", user.id);

    if (favError) {
      throw favError;
    }

    if (!favorites || favorites.length === 0) {
      return NextResponse.json({ recipes: [], recipe_ids: [] });
    }

    const recipeIds = favorites.map((f) => f.recipe_id);

    // Get full recipe data
    const { data: recipes, error: recipeError } = await supabase
      .from("recipes")
      .select(
        `
        *,
        category:categories(*),
        tags:recipe_tags(tag:tags(*))
      `
      )
      .in("id", recipeIds)
      .order("created_at", { ascending: false });

    if (recipeError) {
      throw recipeError;
    }

    const transformedRecipes: RecipeWithRelations[] = (recipes || []).map(
      (r) => ({
        ...r,
        category: r.category as Category,
        tags: (r.tags as { tag: Tag }[]).map((t) => t.tag),
        author: null,
      })
    );

    return NextResponse.json({
      recipes: transformedRecipes,
      recipe_ids: recipeIds,
    });
  } catch {
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

// POST - Add a recipe to favorites
export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = favoriteSchema.parse(body);

    // Check if recipe exists
    const { data: recipe } = await supabase
      .from("recipes")
      .select("id")
      .eq("id", validated.recipe_id)
      .single();

    if (!recipe) {
      return NextResponse.json({ error: "Recipe not found" }, { status: 404 });
    }

    // Add to favorites
    const { error } = await supabase.from("favorite_recipes").insert({
      user_id: user.id,
      recipe_id: validated.recipe_id,
    });

    if (error) {
      if (error.code === "23505") {
        // Already favorited
        return NextResponse.json({ message: "Already in favorites" });
      }
      throw error;
    }

    return NextResponse.json({ message: "Added to favorites" });
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

// DELETE - Remove a recipe from favorites
export async function DELETE(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = favoriteSchema.parse(body);

    const { error } = await supabase
      .from("favorite_recipes")
      .delete()
      .eq("user_id", user.id)
      .eq("recipe_id", validated.recipe_id);

    if (error) {
      throw error;
    }

    return NextResponse.json({ message: "Removed from favorites" });
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
