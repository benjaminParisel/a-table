import { Navbar } from "@/components/layout/navbar";
import { getProfile } from "@/lib/supabase/server";

export default async function MainLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const profile = await getProfile();

  return (
    <div className="min-h-screen bg-background">
      <Navbar profile={profile} />
      <main className="container py-6">{children}</main>
    </div>
  );
}
