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

export async function GET(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const searchParams = request.nextUrl.searchParams;
  const search = searchParams.get("search");
  const category = searchParams.get("category");
  const page = parseInt(searchParams.get("page") || "1");
  const limit = parseInt(searchParams.get("limit") || "20");

  let query = supabase
    .from("recipes")
    .select(
      `
      *,
      category:categories(*),
      tags:recipe_tags(tag:tags(*))
    `,
      { count: "exact" }
    )
    .order("created_at", { ascending: false })
    .range((page - 1) * limit, page * limit - 1);

  if (search) {
    query = query.or(
      `title.ilike.%${search}%,ingredients.ilike.%${search}%`
    );
  }

  if (category) {
    query = query.eq("categories.slug", category);
  }

  const { data, error, count } = await query;

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({
    data,
    total: count || 0,
    page,
    limit,
    totalPages: Math.ceil((count || 0) / limit),
  });
}

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = recipeSchema.parse(body);
    const { tag_ids, ...recipeData } = validated;

    // Generate unique slug
    let slug = slugify(validated.title);
    const { data: existing } = await supabase
      .from("recipes")
      .select("slug")
      .eq("slug", slug)
      .single();

    if (existing) {
      slug = `${slug}-${Date.now()}`;
    }

    // Create recipe
    const { data: recipe, error: recipeError } = await supabase
      .from("recipes")
      .insert({
        ...recipeData,
        slug,
        created_by: user.id,
      })
      .select()
      .single();

    if (recipeError) {
      return NextResponse.json({ error: recipeError.message }, { status: 500 });
    }

    // Add tags
    if (tag_ids && tag_ids.length > 0) {
      const tagInserts = tag_ids.map((tag_id) => ({
        recipe_id: recipe.id,
        tag_id,
      }));

      await supabase.from("recipe_tags").insert(tagInserts);
    }

    // Invalidate cache for all users
    invalidateRecipesCache();

    return NextResponse.json({ data: recipe }, { status: 201 });
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
