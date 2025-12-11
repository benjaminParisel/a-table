import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser } from "@/lib/supabase/server";
import { z } from "zod";
import type { Category, Tag, FavoriteMenuWithRecipes, RecipeWithRelations } from "@/types";

const favoriteSchema = z.object({
  recipe_ids: z.array(z.string().uuid()).min(1),
});

export async function GET() {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data: favorite, error } = await supabase
    .from("favorite_menus")
    .select("*")
    .eq("user_id", user.id)
    .single();

  if (error && error.code !== "PGRST116") {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  if (!favorite) {
    return NextResponse.json({ data: null });
  }

  const { data: recipes, error: recipesError } = await supabase
    .from("recipes")
    .select(
      `
      *,
      category:categories(*),
      tags:recipe_tags(tag:tags(*))
    `
    )
    .in("id", favorite.recipe_ids);

  if (recipesError) {
    return NextResponse.json({ error: recipesError.message }, { status: 500 });
  }

  const orderedRecipes: RecipeWithRelations[] = [];
  for (const id of favorite.recipe_ids as string[]) {
    const recipe = recipes?.find((r) => r.id === id);
    if (recipe) {
      orderedRecipes.push({
        ...recipe,
        category: recipe.category as Category,
        tags: (recipe.tags as { tag: Tag }[]).map((t) => t.tag),
        author: null,
      });
    }
  }

  const result: FavoriteMenuWithRecipes = {
    id: favorite.id,
    user_id: favorite.user_id,
    recipes: orderedRecipes,
    created_at: favorite.created_at,
    updated_at: favorite.updated_at,
  };

  return NextResponse.json({ data: result });
}

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = favoriteSchema.parse(body);

    const { data: existingRecipes, error: checkError } = await supabase
      .from("recipes")
      .select("id")
      .in("id", validated.recipe_ids);

    if (checkError) {
      return NextResponse.json({ error: checkError.message }, { status: 500 });
    }

    if (!existingRecipes || existingRecipes.length !== validated.recipe_ids.length) {
      return NextResponse.json(
        { error: "Some recipes do not exist" },
        { status: 400 }
      );
    }

    const { data, error } = await supabase
      .from("favorite_menus")
      .upsert(
        {
          user_id: user.id,
          recipe_ids: validated.recipe_ids,
          updated_at: new Date().toISOString(),
        },
        {
          onConflict: "user_id",
        }
      )
      .select()
      .single();

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ data });
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

export async function DELETE() {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { error } = await supabase
    .from("favorite_menus")
    .delete()
    .eq("user_id", user.id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}
