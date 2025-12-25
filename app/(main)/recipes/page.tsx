import Link from "next/link";
import { Plus } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Button } from "@/components/ui/button";
import { RecipeList } from "@/components/recipes/recipe-list";
import { RecipeFilters } from "@/components/recipes/recipe-filters";
import { getCategories, getTags } from "@/lib/cache";
import type { RecipeWithRelations, Recipe, Category, Tag, Profile } from "@/types";

interface SearchParams {
  search?: string;
  categories?: string;
  tags?: string;
  prepTimeMax?: string;
  cookTimeMax?: string;
  authors?: string;
}

interface RecipeData extends Recipe {
  category: Category;
  tags: { tag: Tag }[];
  author: Profile | null;
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

  // Fetch authors (profiles who have created recipes)
  const { data: recipeCreators } = await supabase
    .from("recipes")
    .select("created_by")
    .not("created_by", "is", null);

  const creatorIds = [...new Set(recipeCreators?.map((r) => r.created_by).filter(Boolean) || [])];

  const { data: authors } = creatorIds.length > 0
    ? await supabase
        .from("profiles")
        .select("id, display_name, email")
        .in("id", creatorIds)
        .order("display_name")
    : { data: [] };

  let query = supabase
    .from("recipes")
    .select(
      `
      *,
      category:categories(*),
      tags:recipe_tags(tag:tags(*)),
      author:profiles!recipes_created_by_fkey(id, display_name, email)
    `
    )
    .order("created_at", { ascending: false });

  // Apply filters
  if (params.search) {
    query = query.or(
      `title.ilike.%${params.search}%,ingredients.ilike.%${params.search}%`
    );
  }

  if (params.categories) {
    const categorySlugs = params.categories.split(",");
    const categoryIds = categories
      ?.filter((c) => categorySlugs.includes(c.slug))
      .map((c) => c.id) || [];
    if (categoryIds.length > 0) {
      query = query.in("category_id", categoryIds);
    }
  }

  if (params.prepTimeMax) {
    if (params.prepTimeMax.endsWith("+")) {
      // Format "60+" pour > 60 min
      const minTime = parseInt(params.prepTimeMax.slice(0, -1));
      query = query.gt("prep_time", minTime);
    } else if (params.prepTimeMax.includes("-")) {
      // Format "15-30" pour une plage
      const [min, max] = params.prepTimeMax.split("-").map(Number);
      query = query.gte("prep_time", min).lt("prep_time", max);
    }
  }

  if (params.cookTimeMax) {
    if (params.cookTimeMax.endsWith("+")) {
      // Format "60+" pour > 60 min
      const minTime = parseInt(params.cookTimeMax.slice(0, -1));
      query = query.gt("cook_time", minTime);
    } else if (params.cookTimeMax.includes("-")) {
      // Format "15-30" pour une plage
      const [min, max] = params.cookTimeMax.split("-").map(Number);
      query = query.gte("cook_time", min).lt("cook_time", max);
    }
  }

  if (params.authors) {
    const authorIds = params.authors.split(",");
    query = query.in("created_by", authorIds);
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
    author: r.author,
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
        <div>
          <h1 className="text-3xl font-bold">Toutes les recettes</h1>
          <p className="text-sm text-muted-foreground">
            {recipes.length} {recipes.length <= 1 ? "recette" : "recettes"}
          </p>
        </div>
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
        authors={authors || []}
      />

      <RecipeList recipes={recipes} />
    </div>
  );
}
