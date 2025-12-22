"use client";

import { useState, useEffect } from "react";
import { Plus, Tag as TagIcon } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { Tag } from "@/types";

export function TagsManager() {
  const [tags, setTags] = useState<Tag[]>([]);
  const [newTagName, setNewTagName] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const [isAdding, setIsAdding] = useState(false);

  useEffect(() => {
    fetchTags();
  }, []);

  const fetchTags = async () => {
    try {
      const res = await fetch("/api/tags");
      if (res.ok) {
        const { data } = await res.json();
        setTags(data || []);
      }
    } catch {
      // Silent fail
    } finally {
      setIsLoading(false);
    }
  };

  const handleAddTag = async () => {
    const trimmedName = newTagName.trim();
    if (!trimmedName) return;

    // Vérifier si le tag existe déjà
    const existingTag = tags.find(
      (t) => t.name.toLowerCase() === trimmedName.toLowerCase()
    );
    if (existingTag) {
      toast.error("Ce tag existe déjà");
      return;
    }

    setIsAdding(true);
    try {
      const res = await fetch("/api/tags", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: trimmedName }),
      });

      if (!res.ok) {
        const data = await res.json();
        throw new Error(data.error || "Erreur lors de la création du tag");
      }

      const { data: newTag } = await res.json();
      setTags((prev) => [...prev, newTag].sort((a, b) => a.name.localeCompare(b.name)));
      setNewTagName("");
      toast.success("Tag créé", { description: `"${trimmedName}" a été ajouté` });
    } catch (err) {
      const message = err instanceof Error ? err.message : "Erreur";
      toast.error("Erreur", { description: message });
    } finally {
      setIsAdding(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <TagIcon className="h-5 w-5" />
          Gestion des tags
        </CardTitle>
        <CardDescription>
          Créez de nouveaux tags pour organiser vos recettes
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex gap-2 items-end">
          <div className="flex-1 space-y-2">
            <Label htmlFor="newTagProfile">Nouveau tag</Label>
            <Input
              id="newTagProfile"
              value={newTagName}
              onChange={(e) => setNewTagName(e.target.value)}
              placeholder="Nom du tag..."
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  e.preventDefault();
                  handleAddTag();
                }
              }}
            />
          </div>
          <Button
            onClick={handleAddTag}
            disabled={isAdding || !newTagName.trim()}
          >
            <Plus className="h-4 w-4 mr-2" />
            {isAdding ? "Ajout..." : "Ajouter"}
          </Button>
        </div>

        <div className="pt-4 border-t">
          <Label className="text-sm text-muted-foreground mb-2 block">
            Tags existants ({tags.length})
          </Label>
          {isLoading ? (
            <p className="text-sm text-muted-foreground">Chargement...</p>
          ) : tags.length === 0 ? (
            <p className="text-sm text-muted-foreground">Aucun tag disponible</p>
          ) : (
            <div className="flex flex-wrap gap-2">
              {tags.map((tag) => (
                <Badge key={tag.id} variant="secondary">
                  {tag.name}
                </Badge>
              ))}
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
