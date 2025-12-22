"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Save } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { useUserPreferences } from "@/components/profile/user-preferences-provider";
import type { Profile } from "@/types";

interface ProfileFormProps {
  profile: Profile;
}

export function ProfileForm({ profile }: ProfileFormProps) {
  const router = useRouter();
  const { updatePreferences } = useUserPreferences();
  const [displayName, setDisplayName] = useState(profile.display_name || "");
  const [showImages, setShowImages] = useState(profile.show_images ?? true);
  const [isLoading, setIsLoading] = useState(false);
  const [message, setMessage] = useState<{ type: "success" | "error"; text: string } | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setMessage(null);

    try {
      const res = await fetch("/api/profile", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          display_name: displayName.trim() || null,
          show_images: showImages,
        }),
      });

      const data = await res.json();

      if (res.ok) {
        setMessage({ type: "success", text: "Profil mis à jour avec succès" });
        updatePreferences({ showImages });
        router.refresh();
      } else {
        console.error("Profile update error:", data);
        const errorText = typeof data.error === "string"
          ? data.error
          : JSON.stringify(data.error);
        setMessage({ type: "error", text: errorText || "Erreur lors de la mise à jour" });
      }
    } catch (err) {
      console.error("Profile update exception:", err);
      setMessage({ type: "error", text: "Erreur lors de la mise à jour" });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Informations personnelles</CardTitle>
        <CardDescription>
          Modifiez votre nom d&apos;affichage et vos préférences
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              type="email"
              value={profile.email}
              disabled
              className="bg-muted"
            />
            <p className="text-xs text-muted-foreground">
              L&apos;email ne peut pas être modifié
            </p>
          </div>

          <div className="space-y-2">
            <Label htmlFor="displayName">Nom d&apos;affichage</Label>
            <Input
              id="displayName"
              type="text"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              placeholder="Votre nom"
            />
          </div>

          <div
            className="flex items-center space-x-3 p-3 -mx-3 rounded-lg active:bg-muted/50 touch-manipulation cursor-pointer"
            onClick={() => setShowImages(!showImages)}
          >
            <Checkbox
              id="showImages"
              checked={showImages}
              onCheckedChange={(checked) => setShowImages(checked === true)}
              className="h-5 w-5"
            />
            <Label htmlFor="showImages" className="cursor-pointer text-base flex-1">
              Afficher les images des recettes
            </Label>
          </div>

          {message && (
            <p
              className={`text-sm ${
                message.type === "success" ? "text-green-600" : "text-destructive"
              }`}
            >
              {message.text}
            </p>
          )}

          <Button type="submit" disabled={isLoading} className="w-full sm:w-auto h-12 sm:h-10">
            <Save className="mr-2 h-4 w-4" />
            {isLoading ? "Enregistrement..." : "Enregistrer"}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
