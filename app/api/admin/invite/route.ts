import { NextRequest, NextResponse } from "next/server";
import { createAdminClient, isAdmin } from "@/lib/supabase/server";
import { z } from "zod";

const inviteSchema = z.object({
  email: z.string().email("Email invalide"),
  role: z.enum(["user", "admin"]).default("user"),
});

export async function POST(request: NextRequest) {
  const admin = await isAdmin();

  if (!admin) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  try {
    const body = await request.json();
    const validated = inviteSchema.parse(body);

    const supabaseAdmin = createAdminClient();

    // Vérifier si l'utilisateur existe déjà
    const { data: existingUsers } = await supabaseAdmin.auth.admin.listUsers();
    const userExists = existingUsers?.users?.some(
      (u) => u.email?.toLowerCase() === validated.email.toLowerCase()
    );

    if (userExists) {
      return NextResponse.json(
        { error: "Un utilisateur avec cet email existe déjà" },
        { status: 400 }
      );
    }

    // Envoyer l'invitation
    const redirectUrl = `${process.env.NEXT_PUBLIC_APP_URL}/auth/callback`;

    const { data, error } = await supabaseAdmin.auth.admin.inviteUserByEmail(
      validated.email,
      {
        redirectTo: redirectUrl,
        data: {
          role: validated.role,
          invited_at: new Date().toISOString(),
        },
      }
    );

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json(
      {
        success: true,
        message: `Invitation envoyée à ${validated.email}`,
        data,
      },
      { status: 201 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({ error: error.issues[0].message }, { status: 400 });
    }
    return NextResponse.json(
      { error: "Erreur interne du serveur" },
      { status: 500 }
    );
  }
}
