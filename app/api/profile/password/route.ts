import { NextRequest, NextResponse } from "next/server";
import { createClient, getUser } from "@/lib/supabase/server";
import { z } from "zod";

const passwordSchema = z.object({
  password: z.string().min(6, "Le mot de passe doit contenir au moins 6 caractères"),
});

// POST - Update password
export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const user = await getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const validated = passwordSchema.parse(body);

    const { error } = await supabase.auth.updateUser({
      password: validated.password,
    });

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 400 });
    }

    return NextResponse.json({ message: "Mot de passe mis à jour" });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({ error: error.issues[0].message }, { status: 400 });
    }
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
