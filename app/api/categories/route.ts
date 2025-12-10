import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser, isAdmin } from "@/lib/supabase/server";
import { slugify } from "@/lib/utils";
import { z } from "zod";

const categorySchema = z.object({
  name: z.string().min(1).max(100),
  display_order: z.number().int().optional(),
});

export async function GET() {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data, error } = await supabase
    .from("categories")
    .select("*")
    .order("display_order");

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ data });
}

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const admin = await isAdmin();

  if (!admin) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  try {
    const body = await request.json();
    const validated = categorySchema.parse(body);

    const slug = slugify(validated.name);

    const { data, error } = await supabase
      .from("categories")
      .insert({
        name: validated.name,
        slug,
        display_order: validated.display_order || 0,
      })
      .select()
      .single();

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ data }, { status: 201 });
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
