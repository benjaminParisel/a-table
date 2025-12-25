import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { RecipeForm } from "@/components/recipes/recipe-form";
import type { Recipe, Tag, Category } from "@/types";

interface RecipeWithTags extends Recipe {
  tags: { tag: Tag }[];
}

export default async function EditRecipePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const [recipeResult, categoriesResult, tagsResult, profilesResult] = await Promise.all([
    supabase
      .from("recipes")
      .select(
        `
        *,
        tags:recipe_tags(tag:tags(*))
      `
      )
      .eq("id", id)
      .single(),
    supabase.from("categories").select("*").order("display_order"),
    supabase.from("tags").select("*").order("name"),
    supabase.from("profiles").select("id, display_name, email").order("display_name"),
  ]);

  const recipe = recipeResult.data as RecipeWithTags | null;
  const categories = categoriesResult.data as Category[] | null;
  const tags = tagsResult.data as Tag[] | null;
  const authors = profilesResult.data as { id: string; display_name: string | null; email: string }[] | null;

  if (!recipe) {
    notFound();
  }

  const recipeWithTags = {
    id: recipe.id,
    title: recipe.title,
    slug: recipe.slug,
    description: recipe.description,
    ingredients: recipe.ingredients,
    instructions: recipe.instructions,
    prep_time: recipe.prep_time,
    cook_time: recipe.cook_time,
    servings: recipe.servings,
    image_url: recipe.image_url,
    category_id: recipe.category_id,
    created_by: recipe.created_by,
    created_at: recipe.created_at,
    updated_at: recipe.updated_at,
    tags: recipe.tags.map((t) => t.tag),
  };

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <h1 className="text-3xl font-bold">Modifier la recette</h1>
      <RecipeForm
        categories={categories || []}
        tags={tags || []}
        authors={authors || []}
        recipe={recipeWithTags}
      />
    </div>
  );
}
