import { NextRequest, NextResponse } from "next/server";
import { createAdminClient, isAdmin, getUser } from "@/lib/supabase/server";
import { z } from "zod";

const updateRoleSchema = z.object({
  role: z.enum(["user", "admin"]),
});

// PATCH - Modifier le rôle d'un utilisateur
export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  const admin = await isAdmin();
  if (!admin) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  // Empêcher un admin de modifier son propre rôle
  const currentUser = await getUser();
  if (currentUser?.id === id) {
    return NextResponse.json(
      { error: "Vous ne pouvez pas modifier votre propre rôle" },
      { status: 400 }
    );
  }

  try {
    const body = await request.json();
    const validated = updateRoleSchema.parse(body);

    // Utiliser le client admin pour bypasser les RLS
    const supabaseAdmin = createAdminClient();

    const { data, error } = await supabaseAdmin
      .from("profiles")
      .update({ role: validated.role })
      .eq("id", id)
      .select()
      .single();

    if (error) {
      console.error("Error updating role:", error);
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    if (!data) {
      return NextResponse.json({ error: "Utilisateur non trouvé" }, { status: 404 });
    }

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Unexpected error:", error);
    if (error instanceof z.ZodError) {
      return NextResponse.json({ error: error.issues[0].message }, { status: 400 });
    }
    return NextResponse.json(
      { error: "Erreur interne du serveur" },
      { status: 500 }
    );
  }
}

// DELETE - Supprimer un utilisateur
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  const admin = await isAdmin();
  if (!admin) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  // Empêcher un admin de se supprimer lui-même
  const currentUser = await getUser();
  if (currentUser?.id === id) {
    return NextResponse.json(
      { error: "Vous ne pouvez pas supprimer votre propre compte" },
      { status: 400 }
    );
  }

  try {
    const supabaseAdmin = createAdminClient();

    // Supprimer l'utilisateur de auth.users
    // Le profil sera supprimé automatiquement grâce à ON DELETE CASCADE
    const { error } = await supabaseAdmin.auth.admin.deleteUser(id);

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ success: true });
  } catch {
    return NextResponse.json(
      { error: "Erreur interne du serveur" },
      { status: 500 }
    );
  }
}
