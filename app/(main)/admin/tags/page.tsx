import { redirect } from "next/navigation";
import { isAdmin, createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

interface TagWithCount {
  id: string;
  name: string;
  slug: string;
  created_at: string;
  recipe_tags: { count: number }[];
}

export default async function AdminTagsPage() {
  const admin = await isAdmin();

  if (!admin) {
    redirect("/recipes");
  }

  const supabase = await createClient();
  const { data } = await supabase
    .from("tags")
    .select("*, recipe_tags(count)")
    .order("name");

  const tags = data as TagWithCount[] | null;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold">Tags</h1>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Liste des tags</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="divide-y">
            {tags?.map((tag) => {
              const usageCount = tag.recipe_tags?.[0]?.count || 0;
              return (
                <div
                  key={tag.id}
                  className="flex items-center justify-between py-4"
                >
                  <div>
                    <p className="font-medium">{tag.name}</p>
                    <p className="text-sm text-muted-foreground">{tag.slug}</p>
                  </div>
                  <p className="text-sm text-muted-foreground">
                    {usageCount} recette{usageCount !== 1 ? "s" : ""}
                  </p>
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
