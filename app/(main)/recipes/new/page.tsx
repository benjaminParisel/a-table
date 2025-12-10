import { createClient } from "@/lib/supabase/server";
import { RecipeForm } from "@/components/recipes/recipe-form";

export default async function NewRecipePage() {
  const supabase = await createClient();

  const [{ data: categories }, { data: tags }] = await Promise.all([
    supabase.from("categories").select("*").order("display_order"),
    supabase.from("tags").select("*").order("name"),
  ]);

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <h1 className="text-3xl font-bold">Nouvelle recette</h1>
      <RecipeForm categories={categories || []} tags={tags || []} />
    </div>
  );
}
