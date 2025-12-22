import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser } from "@/lib/supabase/server";
import { z } from "zod";

const updateProfileSchema = z.object({
  display_name: z.string().max(100).optional().nullable(),
  show_images: z.boolean().optional(),
});

// GET - Fetch current user profile
export async function GET() {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const { data: profile, error } = await supabase
      .from("profiles")
      .select("*")
      .eq("id", user.id)
      .single();

    if (error) {
      throw error;
    }

    return NextResponse.json({ profile });
  } catch {
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

// PATCH - Update current user profile
export async function PATCH(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = updateProfileSchema.parse(body);

    const { data: profile, error } = await supabase
      .from("profiles")
      .update({
        ...validated,
        updated_at: new Date().toISOString(),
      })
      .eq("id", user.id)
      .select()
      .single();

    if (error) {
      throw error;
    }

    return NextResponse.json({ profile });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({ error: error.issues }, { status: 400 });
    }
    console.error("Profile update error:", error);
    const message = error instanceof Error ? error.message : "Internal server error";
    return NextResponse.json(
      { error: message },
      { status: 500 }
    );
  }
}
