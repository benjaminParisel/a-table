import { redirect } from "next/navigation";
import { isAdmin, createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { AddCategoryForm } from "@/components/categories/add-category-form";
import { DeleteCategoryButton } from "@/components/categories/delete-category-button";

interface CategoryWithCount {
  id: string;
  name: string;
  slug: string;
  display_order: number;
  created_at: string;
  recipes: { count: number }[];
}

export default async function AdminCategoriesPage() {
  const admin = await isAdmin();

  if (!admin) {
    redirect("/recipes");
  }

  const supabase = await createClient();
  const { data } = await supabase
    .from("categories")
    .select("*, recipes(count)")
    .order("display_order");

  const categories = data as CategoryWithCount[] | null;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold">Catégories</h1>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Ajouter une catégorie</CardTitle>
        </CardHeader>
        <CardContent>
          <AddCategoryForm />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Liste des catégories</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="divide-y">
            {categories?.map((category) => {
              const recipeCount = category.recipes?.[0]?.count || 0;
              return (
                <div
                  key={category.id}
                  className="flex items-center justify-between py-4"
                >
                  <div>
                    <p className="font-medium">{category.name}</p>
                    <p className="text-sm text-muted-foreground">
                      {category.slug}
                    </p>
                  </div>
                  <div className="flex items-center gap-4">
                    <p className="text-sm text-muted-foreground">
                      {recipeCount} recette{recipeCount !== 1 ? "s" : ""}
                    </p>
                    <DeleteCategoryButton
                      categoryId={category.id}
                      categoryName={category.name}
                      recipeCount={recipeCount}
                    />
                  </div>
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
