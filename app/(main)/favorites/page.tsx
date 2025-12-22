import { Heart } from "lucide-react";
import { createClient, getUser } from "@/lib/supabase/server";
import { RecipeList } from "@/components/recipes/recipe-list";
import type { RecipeWithRelations, Category, Tag } from "@/types";
import { redirect } from "next/navigation";

export default async function FavoritesPage() {
  const user = await getUser();

  if (!user) {
    redirect("/login");
  }

  const supabase = await createClient();

  // Get favorite recipe IDs
  const { data: favorites } = await supabase
    .from("favorite_recipes")
    .select("recipe_id")
    .eq("user_id", user.id);

  const recipeIds = favorites?.map((f) => f.recipe_id) || [];

  let recipes: RecipeWithRelations[] = [];

  if (recipeIds.length > 0) {
    const { data: recipesData } = await supabase
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

    recipes = (recipesData || []).map((r) => ({
      ...r,
      category: r.category as Category,
      tags: (r.tags as { tag: Tag }[]).map((t) => t.tag),
      author: null,
    }));
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-2">
        <Heart className="h-8 w-8 text-red-500 fill-red-500" />
        <h1 className="text-3xl font-bold">Mes favoris</h1>
      </div>

      {recipes.length === 0 ? (
        <div className="text-center py-12">
          <Heart className="h-16 w-16 mx-auto text-muted-foreground mb-4" />
          <h2 className="text-xl font-semibold mb-2">Aucune recette favorite</h2>
          <p className="text-muted-foreground">
            Cliquez sur le coeur des recettes pour les ajouter à vos favoris.
          </p>
        </div>
      ) : (
        <>
          <p className="text-muted-foreground">
            {recipes.length} recette{recipes.length > 1 ? "s" : ""} favorite{recipes.length > 1 ? "s" : ""}
          </p>
          <RecipeList recipes={recipes} />
        </>
      )}
    </div>
  );
}
