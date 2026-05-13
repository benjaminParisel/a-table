import { NextRequest, NextResponse } from "next/server";
import { createAdminClient, isAdmin } from "@/lib/supabase/server";
import { invalidateTagsCache } from "@/lib/cache";

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  const admin = await isAdmin();
  if (!admin) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  // Utiliser le client admin pour bypasser les RLS
  const supabaseAdmin = createAdminClient();

  // La suppression du tag supprimera automatiquement les associations
  // dans recipe_tags grâce à ON DELETE CASCADE
  const { error } = await supabaseAdmin
    .from("tags")
    .delete()
    .eq("id", id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  invalidateTagsCache();
  return NextResponse.json({ success: true });
}
