import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser } from "@/lib/supabase/server";
import { z } from "zod";
import type { Category, Tag, RecipeWithRelations } from "@/types";

const menuSchema = z.object({
  categories: z.array(z.string()).min(1),
  count: z.number().min(1).max(5).default(1),
});

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = menuSchema.parse(body);

    // Get category IDs from slugs
    const { data: categories } = await supabase
      .from("categories")
      .select("id, slug")
      .in("slug", validated.categories);

    if (!categories || categories.length === 0) {
      return NextResponse.json(
        { error: "No valid categories found" },
        { status: 400 }
      );
    }

    // Fetch all recipes for each category once
    const recipesByCategory = new Map<string, RecipeWithRelations[]>();

    for (const category of categories) {
      const { data: categoryRecipes } = await supabase
        .from("recipes")
        .select(
          `
          *,
          category:categories(*),
          tags:recipe_tags(tag:tags(*))
        `
        )
        .eq("category_id", category.id);

      if (categoryRecipes && categoryRecipes.length > 0) {
        const transformedRecipes = categoryRecipes.map((r) => ({
          ...r,
          category: r.category as Category,
          tags: (r.tags as { tag: Tag }[]).map((t) => t.tag),
          author: null,
        }));
        recipesByCategory.set(category.slug, transformedRecipes);
      }
    }

    // Get category display order for sorting
    const { data: allCategories } = await supabase
      .from("categories")
      .select("slug, display_order");

    const orderMap = new Map(
      allCategories?.map((c) => [c.slug, c.display_order]) || []
    );

    // Generate multiple menus
    const menus: RecipeWithRelations[][] = [];
    const menuCount = validated.count;

    for (let i = 0; i < menuCount; i++) {
      const menu: RecipeWithRelations[] = [];

      for (const category of categories) {
        const categoryRecipes = recipesByCategory.get(category.slug);
        if (categoryRecipes && categoryRecipes.length > 0) {
          const randomIndex = Math.floor(Math.random() * categoryRecipes.length);
          menu.push(categoryRecipes[randomIndex]);
        }
      }

      // Sort by category display order
      menu.sort(
        (a, b) =>
          (orderMap.get(a.category.slug) || 0) -
          (orderMap.get(b.category.slug) || 0)
      );

      menus.push(menu);
    }

    return NextResponse.json({
      menus,
      generated_at: new Date().toISOString(),
    });
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
