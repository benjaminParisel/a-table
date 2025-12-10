import { redirect } from "next/navigation";
import Link from "next/link";
import { Users, Tags, FolderTree } from "lucide-react";
import { isAdmin } from "@/lib/supabase/server";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";

export default async function AdminPage() {
  const admin = await isAdmin();

  if (!admin) {
    redirect("/recipes");
  }

  const adminLinks = [
    {
      href: "/admin/users",
      title: "Utilisateurs",
      description: "Gérer les utilisateurs et les invitations",
      icon: Users,
    },
    {
      href: "/admin/categories",
      title: "Catégories",
      description: "Gérer les catégories de recettes",
      icon: FolderTree,
    },
    {
      href: "/admin/tags",
      title: "Tags",
      description: "Gérer les tags des recettes",
      icon: Tags,
    },
  ];

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Administration</h1>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {adminLinks.map((link) => (
          <Link key={link.href} href={link.href}>
            <Card className="h-full transition-shadow hover:shadow-lg">
              <CardHeader>
                <link.icon className="h-8 w-8 text-primary mb-2" />
                <CardTitle>{link.title}</CardTitle>
                <CardDescription>{link.description}</CardDescription>
              </CardHeader>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
