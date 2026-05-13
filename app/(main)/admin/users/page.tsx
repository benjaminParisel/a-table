import { redirect } from "next/navigation";
import { isAdmin, createClient, getUser } from "@/lib/supabase/server";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { InviteUserForm } from "@/components/admin/invite-user-form";
import { UserRoleSelect } from "@/components/admin/user-role-select";
import { DeleteUserButton } from "@/components/admin/delete-user-button";
import type { Profile } from "@/types";

export default async function AdminUsersPage() {
  const admin = await isAdmin();

  if (!admin) {
    redirect("/recipes");
  }

  const supabase = await createClient();
  const currentUser = await getUser();

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
          <CardTitle>Inviter un utilisateur</CardTitle>
          <CardDescription>
            Envoyez une invitation par email. L&apos;utilisateur recevra un lien pour créer son compte.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <InviteUserForm />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Liste des utilisateurs</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="divide-y">
            {users?.map((user) => {
              const isCurrentUser = user.id === currentUser?.id;
              return (
                <div
                  key={user.id}
                  className="flex items-center justify-between py-4 gap-4"
                >
                  <div className="min-w-0 flex-1">
                    <p className="font-medium truncate">
                      {user.display_name || user.email}
                      {isCurrentUser && (
                        <span className="text-xs text-muted-foreground ml-2">(vous)</span>
                      )}
                    </p>
                    <p className="text-sm text-muted-foreground truncate">{user.email}</p>
                  </div>
                  <div className="flex items-center gap-2">
                    <UserRoleSelect
                      userId={user.id}
                      currentRole={user.role || "user"}
                      isCurrentUser={isCurrentUser}
                    />
                    <DeleteUserButton
                      userId={user.id}
                      userEmail={user.email}
                      userName={user.display_name}
                      isCurrentUser={isCurrentUser}
                    />
                  </div>
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
