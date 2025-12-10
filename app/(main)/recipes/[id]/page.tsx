import { notFound } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import { ArrowLeft, Clock, Users, Pencil } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { formatTime, getTotalTime } from "@/lib/utils";
import { DeleteRecipeButton } from "@/components/recipes/delete-recipe-button";
import type { Recipe, Category, Tag } from "@/types";

interface RecipeWithRelationsData extends Recipe {
  category: Category;
  tags: { tag: Tag }[];
}

export default async function RecipeDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const { data } = await supabase
    .from("recipes")
    .select(
      `
      *,
      category:categories(*),
      tags:recipe_tags(tag:tags(*))
    `
    )
    .eq("id", id)
    .single();

  const recipe = data as RecipeWithRelationsData | null;

  if (!recipe) {
    notFound();
  }

  const category = recipe.category;
  const tags = recipe.tags.map((t) => t.tag);
  const totalTime = getTotalTime(recipe.prep_time, recipe.cook_time);

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <Button variant="ghost" asChild>
          <Link href="/recipes">
            <ArrowLeft className="mr-2 h-4 w-4" />
            Retour
          </Link>
        </Button>
        <div className="flex gap-2">
          <Button variant="outline" size="icon" asChild>
            <Link href={`/recipes/${id}/edit`}>
              <Pencil className="h-4 w-4" />
            </Link>
          </Button>
          <DeleteRecipeButton recipeId={id} recipeName={recipe.title} />
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <div className="relative aspect-video bg-muted rounded-lg overflow-hidden">
          {recipe.image_url ? (
            <Image
              src={recipe.image_url}
              alt={recipe.title}
              fill
              className="object-cover"
            />
          ) : (
            <div className="flex h-full items-center justify-center text-muted-foreground">
              <span className="text-6xl">🍽️</span>
            </div>
          )}
        </div>

        <div className="space-y-4">
          <div>
            <h1 className="text-3xl font-bold">{recipe.title}</h1>
            <p className="text-muted-foreground">{category.name}</p>
          </div>

          <div className="flex flex-wrap gap-4 text-muted-foreground">
            {totalTime && (
              <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" />
                <span>{formatTime(totalTime)}</span>
              </div>
            )}
            {recipe.servings && (
              <div className="flex items-center gap-1">
                <Users className="h-4 w-4" />
                <span>{recipe.servings} portions</span>
              </div>
            )}
          </div>

          {recipe.prep_time || recipe.cook_time ? (
            <div className="text-sm text-muted-foreground">
              {recipe.prep_time && (
                <span>Préparation : {formatTime(recipe.prep_time)}</span>
              )}
              {recipe.prep_time && recipe.cook_time && <span> | </span>}
              {recipe.cook_time && (
                <span>Cuisson : {formatTime(recipe.cook_time)}</span>
              )}
            </div>
          ) : null}

          {tags.length > 0 && (
            <div className="flex flex-wrap gap-2">
              {tags.map((tag) => (
                <Badge key={tag.id} variant="secondary">
                  {tag.name}
                </Badge>
              ))}
            </div>
          )}

          {recipe.description && (
            <p className="text-muted-foreground">{recipe.description}</p>
          )}
        </div>
      </div>

      <Separator />

      <div className="grid gap-8 md:grid-cols-2">
        {recipe.ingredients && (
          <div>
            <h2 className="text-xl font-semibold mb-4">Ingrédients</h2>
            <div className="prose prose-stone dark:prose-invert">
              {recipe.ingredients.split("\n").map((line, i) => (
                <p key={i} className="my-1">
                  {line.trim().startsWith("-") ||
                  line.trim().startsWith("•") ? (
                    line
                  ) : (
                    <>• {line}</>
                  )}
                </p>
              ))}
            </div>
          </div>
        )}

        {recipe.instructions && (
          <div>
            <h2 className="text-xl font-semibold mb-4">Instructions</h2>
            <div className="prose prose-stone dark:prose-invert">
              {recipe.instructions.split("\n").map((line, i) => (
                <p key={i} className="my-2">
                  {line}
                </p>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
