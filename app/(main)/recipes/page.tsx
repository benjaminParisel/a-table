import Link from "next/link";
import { Plus } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Button } from "@/components/ui/button";
import { RecipeList } from "@/components/recipes/recipe-list";
import { RecipeFilters } from "@/components/recipes/recipe-filters";
import { getCategories, getTags } from "@/lib/cache";
import type { RecipeWithRelations, Recipe, Category, Tag } from "@/types";

interface SearchParams {
  search?: string;
  category?: string;
  tags?: string;
  prepTimeMax?: string;
}

interface RecipeData extends Recipe {
  category: Category;
  tags: { tag: Tag }[];
}

export default async function RecipesPage({
  searchParams,
}: {
  searchParams: Promise<SearchParams>;
}) {
  const params = await searchParams;

  // Fetch categories and tags
  const [categories, tags] = await Promise.all([
    getCategories(),
    getTags(),
  ]);

  // Fetch recipes with authenticated client
  const supabase = await createClient();
  let query = supabase
    .from("recipes")
    .select(
      `
      *,
      category:categories(*),
      tags:recipe_tags(tag:tags(*))
    `
    )
    .order("created_at", { ascending: false });

  // Apply filters
  if (params.search) {
    query = query.or(
      `title.ilike.%${params.search}%,ingredients.ilike.%${params.search}%`
    );
  }

  if (params.category) {
    const cat = categories?.find((c) => c.slug === params.category);
    if (cat) {
      query = query.eq("category_id", cat.id);
    }
  }

  if (params.prepTimeMax) {
    const maxTime = parseInt(params.prepTimeMax);
    if (maxTime === 61) {
      query = query.gt("prep_time", 60);
    } else {
      query = query.lte("prep_time", maxTime);
    }
  }

  const { data: recipesRaw } = await query;

  // Transform recipes to include proper tag structure
  let recipes: RecipeWithRelations[] = ((recipesRaw as RecipeData[]) || []).map((r) => ({
    id: r.id,
    title: r.title,
    slug: r.slug,
    description: r.description,
    ingredients: r.ingredients,
    instructions: r.instructions,
    prep_time: r.prep_time,
    cook_time: r.cook_time,
    servings: r.servings,
    image_url: r.image_url,
    category_id: r.category_id,
    created_by: r.created_by,
    created_at: r.created_at,
    updated_at: r.updated_at,
    category: r.category,
    tags: r.tags.map((t) => t.tag),
    author: null,
  }));

  // Filter by tags (client-side since it's a many-to-many relation)
  if (params.tags) {
    const tagSlugs = params.tags.split(",");
    recipes = recipes.filter((r) =>
      tagSlugs.some((slug) => r.tags.some((t) => t.slug === slug))
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold">Toutes les recettes</h1>
        <Button asChild>
          <Link href="/recipes/new">
            <Plus className="mr-2 h-4 w-4" />
            Nouvelle recette
          </Link>
        </Button>
      </div>

      <RecipeFilters
        categories={categories || []}
        tags={tags || []}
      />

      <RecipeList recipes={recipes} />
    </div>
  );
}
