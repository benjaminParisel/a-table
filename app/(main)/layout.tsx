import { Navbar } from "@/components/layout/navbar";
import { BottomNav } from "@/components/layout/bottom-nav";
import { FavoritesProvider } from "@/components/recipes/favorites-provider";
import { UserPreferencesProvider } from "@/components/profile/user-preferences-provider";
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
      <UserPreferencesProvider>
        <FavoritesProvider>
          <main className="container py-4 pb-24 md:py-6 md:pb-6">{children}</main>
        </FavoritesProvider>
      </UserPreferencesProvider>
      <BottomNav />
    </div>
  );
}
