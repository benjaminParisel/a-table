"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Plus } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export function AddCategoryForm() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [isAdding, setIsAdding] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const trimmedName = name.trim();
    if (!trimmedName) return;

    setIsAdding(true);
    try {
      const res = await fetch("/api/categories", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: trimmedName }),
      });

      if (!res.ok) {
        const data = await res.json();
        throw new Error(data.error || "Erreur lors de la création");
      }

      setName("");
      toast.success("Catégorie créée", {
        description: `"${trimmedName}" a été ajoutée.`,
      });
      router.refresh();
    } catch (err) {
      const message = err instanceof Error ? err.message : "Erreur";
      toast.error("Erreur", { description: message });
    } finally {
      setIsAdding(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="flex gap-2">
      <Input
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder="Nom de la catégorie..."
        className="flex-1"
      />
      <Button type="submit" disabled={isAdding || !name.trim()}>
        <Plus className="h-4 w-4 mr-2" />
        {isAdding ? "Ajout..." : "Ajouter"}
      </Button>
    </form>
  );
}
