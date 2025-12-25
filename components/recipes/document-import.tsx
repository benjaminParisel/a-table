"use client";

import { useState, useRef } from "react";
import { FileUp, Loader2 } from "lucide-react";
import { cn } from "@/lib/utils";
import type { ExtractedRecipe } from "@/types";

interface DocumentImportProps {
  onImport: (data: ExtractedRecipe) => void;
  disabled?: boolean;
}

const ACCEPTED_EXTENSIONS = ".pdf,.doc,.docx";

export function DocumentImport({ onImport, disabled }: DocumentImportProps) {
  const [isImporting, setIsImporting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setError(null);
    setIsImporting(true);

    try {
      const formData = new FormData();
      formData.append("file", file);

      const response = await fetch("/api/recipes/import", {
        method: "POST",
        body: formData,
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || "Erreur lors de l'import");
      }

      onImport(result.data);
    } catch (err) {
      console.error("Import error:", err);
      setError(
        err instanceof Error ? err.message : "Erreur lors de l'import du document"
      );
    } finally {
      setIsImporting(false);
      if (inputRef.current) {
        inputRef.current.value = "";
      }
    }
  };

  return (
    <div className="space-y-2">
      <input
        ref={inputRef}
        type="file"
        accept={ACCEPTED_EXTENSIONS}
        onChange={handleFileChange}
        disabled={disabled || isImporting}
        className="hidden"
      />

      <div
        onClick={() => !disabled && !isImporting && inputRef.current?.click()}
        className={cn(
          "flex flex-col items-center justify-center py-8 px-4 w-full rounded-lg border-2 border-dashed border-muted-foreground/25 bg-muted/50 cursor-pointer transition-colors hover:border-muted-foreground/50 hover:bg-muted",
          (disabled || isImporting) && "cursor-not-allowed opacity-50"
        )}
      >
        {isImporting ? (
          <>
            <Loader2 className="h-10 w-10 text-muted-foreground animate-spin" />
            <p className="mt-2 text-sm text-muted-foreground">
              Analyse en cours...
            </p>
          </>
        ) : (
          <>
            <FileUp className="h-10 w-10 text-muted-foreground" />
            <p className="mt-2 text-sm text-muted-foreground">
              Importer un document pour préremplir
            </p>
            <p className="text-xs text-muted-foreground">
              PDF, DOC, DOCX (max 10 Mo)
            </p>
          </>
        )}
      </div>

      {error && <p className="text-sm text-destructive">{error}</p>}
    </div>
  );
}
