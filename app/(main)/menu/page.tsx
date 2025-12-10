import { createClient } from "@/lib/supabase/server";
import { MenuGenerator } from "@/components/menu/menu-generator";
import type { Category } from "@/types";

interface CategoryWithRecipes extends Category {
  recipes: { count: number }[];
}

export default async function MenuPage() {
  const supabase = await createClient();

  // Get categories with recipe count
  const { data } = await supabase
    .from("categories")
    .select("*, recipes(count)")
    .order("display_order");

  const categories = data as CategoryWithRecipes[] | null;

  const categoriesWithCount =
    categories?.map((c) => ({
      id: c.id,
      name: c.name,
      slug: c.slug,
      display_order: c.display_order,
      created_at: c.created_at,
      recipe_count: c.recipes?.[0]?.count || 0,
    })) || [];

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="text-center space-y-2">
        <h1 className="text-3xl font-bold">Générateur de Menu</h1>
        <p className="text-muted-foreground">
          Laissez le hasard vous inspirer pour votre prochain repas !
        </p>
      </div>

      <MenuGenerator categories={categoriesWithCount} />
    </div>
  );
}
