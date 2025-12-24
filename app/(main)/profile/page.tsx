import { redirect } from "next/navigation";
import { getProfile } from "@/lib/supabase/server";
import { ProfileForm } from "@/components/profile/profile-form";
import { PasswordForm } from "@/components/profile/password-form";
import { TagsManager } from "@/components/profile/tags-manager";
import { User } from "lucide-react";

export default async function ProfilePage() {
  const profile = await getProfile();

  if (!profile) {
    redirect("/login");
  }

  return (
    <div className="space-y-6 max-w-2xl mx-auto">
      <div className="flex items-center gap-2">
        <User className="h-8 w-8" />
        <h1 className="text-3xl font-bold">Mon profil</h1>
      </div>

      <div className="space-y-6">
        <TagsManager />
        <ProfileForm profile={profile} />
        <PasswordForm />
      </div>
    </div>
  );
}
