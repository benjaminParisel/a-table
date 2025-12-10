"use client";

import { useState, useRef } from "react";
import Image from "next/image";
import { Upload, X, Loader2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface ImageUploadProps {
  value: string | null;
  onChange: (url: string | null) => void;
  disabled?: boolean;
}

export function ImageUpload({ value, onChange, disabled }: ImageUploadProps) {
  const [isUploading, setIsUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const supabase = createClient();

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith("image/")) {
      setError("Le fichier doit être une image");
      return;
    }

    // Validate file size (max 5MB)
    if (file.size > 5 * 1024 * 1024) {
      setError("L'image ne doit pas dépasser 5 Mo");
      return;
    }

    setError(null);
    setIsUploading(true);

    try {
      // Generate unique filename
      const fileExt = file.name.split(".").pop();
      const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
      const filePath = `recipes/${fileName}`;

      // Upload to Supabase Storage
      const { error: uploadError } = await supabase.storage
        .from("recipe-images")
        .upload(filePath, file, {
          cacheControl: "3600",
          upsert: false,
        });

      if (uploadError) {
        throw uploadError;
      }

      // Get public URL
      const { data: urlData } = supabase.storage
        .from("recipe-images")
        .getPublicUrl(filePath);

      onChange(urlData.publicUrl);
    } catch (err) {
      console.error("Upload error:", err);
      setError("Erreur lors de l'upload de l'image");
    } finally {
      setIsUploading(false);
      // Reset input
      if (inputRef.current) {
        inputRef.current.value = "";
      }
    }
  };

  const handleRemove = async () => {
    if (!value) return;

    try {
      // Extract file path from URL
      const url = new URL(value);
      const pathParts = url.pathname.split("/");
      const bucketIndex = pathParts.indexOf("recipe-images");
      if (bucketIndex !== -1) {
        const filePath = pathParts.slice(bucketIndex + 1).join("/");

        // Delete from storage
        await supabase.storage.from("recipe-images").remove([filePath]);
      }
    } catch (err) {
      console.error("Error removing image:", err);
    }

    onChange(null);
  };

  return (
    <div className="space-y-2">
      <input
        ref={inputRef}
        type="file"
        accept="image/*"
        onChange={handleFileChange}
        disabled={disabled || isUploading}
        className="hidden"
      />

      {value ? (
        <div className="relative aspect-video w-full max-w-md rounded-lg overflow-hidden bg-muted">
          <Image
            src={value}
            alt="Image de la recette"
            fill
            className="object-cover"
          />
          <Button
            type="button"
            variant="destructive"
            size="icon"
            className="absolute top-2 right-2"
            onClick={handleRemove}
            disabled={disabled || isUploading}
          >
            <X className="h-4 w-4" />
          </Button>
        </div>
      ) : (
        <div
          onClick={() => !disabled && !isUploading && inputRef.current?.click()}
          className={cn(
            "flex flex-col items-center justify-center aspect-video w-full max-w-md rounded-lg border-2 border-dashed border-muted-foreground/25 bg-muted/50 cursor-pointer transition-colors hover:border-muted-foreground/50 hover:bg-muted",
            (disabled || isUploading) && "cursor-not-allowed opacity-50"
          )}
        >
          {isUploading ? (
            <>
              <Loader2 className="h-10 w-10 text-muted-foreground animate-spin" />
              <p className="mt-2 text-sm text-muted-foreground">
                Upload en cours...
              </p>
            </>
          ) : (
            <>
              <Upload className="h-10 w-10 text-muted-foreground" />
              <p className="mt-2 text-sm text-muted-foreground">
                Cliquez pour ajouter une image
              </p>
              <p className="text-xs text-muted-foreground">
                PNG, JPG, WebP (max 5 Mo)
              </p>
            </>
          )}
        </div>
      )}

      {error && <p className="text-sm text-destructive">{error}</p>}
    </div>
  );
}
