import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser } from "@/lib/supabase/server";
import { invalidateRecipesCache } from "@/lib/cache";
import { slugify } from "@/lib/utils";
import { z } from "zod";

const recipeSchema = z.object({
  title: z.string().min(1).max(255),
  description: z.string().nullable().optional(),
  ingredients: z.string().nullable().optional(),
  instructions: z.string().nullable().optional(),
  prep_time: z.number().int().positive().nullable().optional(),
  cook_time: z.number().int().positive().nullable().optional(),
  servings: z.number().int().positive().default(4),
  image_url: z.string().url().nullable().optional(),
  category_id: z.string().uuid(),
  tag_ids: z.array(z.string().uuid()).optional(),
});

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data, error } = await supabase
    .from("recipes")
    .select(
      `
      *,
      category:categories(*),
      tags:recipe_tags(tag:tags(*)),
      author:profiles(*)
    `
    )
    .eq("id", id)
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 404 });
  }

  return NextResponse.json({ data });
}

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = recipeSchema.parse(body);
    const { tag_ids, ...recipeData } = validated;

    // Get current recipe
    const { data: current } = await supabase
      .from("recipes")
      .select("title, slug")
      .eq("id", id)
      .single();

    if (!current) {
      return NextResponse.json({ error: "Recipe not found" }, { status: 404 });
    }

    // Generate new slug if title changed
    let slug = current.slug;
    if (validated.title !== current.title) {
      slug = slugify(validated.title);
      const { data: existing } = await supabase
        .from("recipes")
        .select("slug")
        .eq("slug", slug)
        .neq("id", id)
        .single();

      if (existing) {
        slug = `${slug}-${Date.now()}`;
      }
    }

    // Update recipe
    const { data: recipe, error: recipeError } = await supabase
      .from("recipes")
      .update({
        ...recipeData,
        slug,
      })
      .eq("id", id)
      .select()
      .single();

    if (recipeError) {
      return NextResponse.json({ error: recipeError.message }, { status: 500 });
    }

    // Update tags
    if (tag_ids !== undefined) {
      // Remove existing tags
      await supabase.from("recipe_tags").delete().eq("recipe_id", id);

      // Add new tags
      if (tag_ids.length > 0) {
        const tagInserts = tag_ids.map((tag_id) => ({
          recipe_id: id,
          tag_id,
        }));

        await supabase.from("recipe_tags").insert(tagInserts);
      }
    }

    // Invalidate cache for all users
    invalidateRecipesCache();

    return NextResponse.json({ data: recipe });
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

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { error } = await supabase.from("recipes").delete().eq("id", id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  // Invalidate cache for all users
  invalidateRecipesCache();

  return NextResponse.json({ success: true });
}
