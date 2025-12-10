import { redirect } from "next/navigation";
import { isAdmin, createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { Profile } from "@/types";

export default async function AdminUsersPage() {
  const admin = await isAdmin();

  if (!admin) {
    redirect("/recipes");
  }

  const supabase = await createClient();
  const { data } = await supabase
    .from("profiles")
    .select("*")
    .order("created_at", { ascending: false });

  const users = data as Profile[] | null;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold">Utilisateurs</h1>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Liste des utilisateurs</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="divide-y">
            {users?.map((user) => (
              <div
                key={user.id}
                className="flex items-center justify-between py-4"
              >
                <div>
                  <p className="font-medium">
                    {user.display_name || user.email}
                  </p>
                  <p className="text-sm text-muted-foreground">{user.email}</p>
                </div>
                <Badge variant={user.role === "admin" ? "default" : "secondary"}>
                  {user.role === "admin" ? "Admin" : "Utilisateur"}
                </Badge>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
