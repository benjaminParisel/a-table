"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ImageUpload } from "@/components/shared/image-upload";
import type { Category, Tag, Recipe } from "@/types";

interface RecipeFormProps {
  categories: Category[];
  tags: Tag[];
  recipe?: Recipe & { tags: Tag[] };
}

export function RecipeForm({ categories, tags, recipe }: RecipeFormProps) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [formData, setFormData] = useState({
    title: recipe?.title || "",
    description: recipe?.description || "",
    ingredients: recipe?.ingredients || "",
    instructions: recipe?.instructions || "",
    prep_time: recipe?.prep_time?.toString() || "",
    cook_time: recipe?.cook_time?.toString() || "",
    servings: recipe?.servings?.toString() || "4",
    image_url: recipe?.image_url || "",
    category_id: recipe?.category_id || "",
    tag_ids: recipe?.tags.map((t) => t.id) || [],
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const payload = {
      title: formData.title,
      description: formData.description || null,
      ingredients: formData.ingredients || null,
      instructions: formData.instructions || null,
      prep_time: formData.prep_time ? parseInt(formData.prep_time) : null,
      cook_time: formData.cook_time ? parseInt(formData.cook_time) : null,
      servings: parseInt(formData.servings) || 4,
      image_url: formData.image_url || null,
      category_id: formData.category_id,
      tag_ids: formData.tag_ids,
    };

    try {
      const url = recipe ? `/api/recipes/${recipe.id}` : "/api/recipes";
      const method = recipe ? "PUT" : "POST";

      const res = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (!res.ok) {
        const data = await res.json();
        throw new Error(data.error || "Une erreur est survenue");
      }

      const data = await res.json();

      toast.success(recipe ? "Recette mise à jour" : "Recette créée", {
        description: `"${formData.title}" a été ${recipe ? "mise à jour" : "créée"} avec succès.`,
      });

      router.push(`/recipes/${data.data.id}`);
      router.refresh();
    } catch (err) {
      const message = err instanceof Error ? err.message : "Une erreur est survenue";
      setError(message);
      toast.error("Erreur", { description: message });
    } finally {
      setLoading(false);
    }
  };

  const toggleTag = (tagId: string) => {
    setFormData((prev) => ({
      ...prev,
      tag_ids: prev.tag_ids.includes(tagId)
        ? prev.tag_ids.filter((id) => id !== tagId)
        : [...prev.tag_ids, tagId],
    }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Informations générales</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="title">Titre *</Label>
            <Input
              id="title"
              value={formData.title}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, title: e.target.value }))
              }
              required
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="category">Catégorie *</Label>
            <Select
              value={formData.category_id}
              onValueChange={(value) =>
                setFormData((prev) => ({ ...prev, category_id: value }))
              }
              required
            >
              <SelectTrigger>
                <SelectValue placeholder="Sélectionner une catégorie" />
              </SelectTrigger>
              <SelectContent>
                {categories.map((cat) => (
                  <SelectItem key={cat.id} value={cat.id}>
                    {cat.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="space-y-2">
            <Label htmlFor="description">Description</Label>
            <Textarea
              id="description"
              value={formData.description}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, description: e.target.value }))
              }
              rows={3}
            />
          </div>

          <div className="space-y-2">
            <Label>Image de la recette</Label>
            <ImageUpload
              value={formData.image_url || null}
              onChange={(url) =>
                setFormData((prev) => ({ ...prev, image_url: url || "" }))
              }
              disabled={loading}
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Temps et portions</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-4 sm:grid-cols-3">
          <div className="space-y-2">
            <Label htmlFor="prep_time">Temps de préparation (min)</Label>
            <Input
              id="prep_time"
              type="number"
              min="0"
              value={formData.prep_time}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, prep_time: e.target.value }))
              }
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="cook_time">Temps de cuisson (min)</Label>
            <Input
              id="cook_time"
              type="number"
              min="0"
              value={formData.cook_time}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, cook_time: e.target.value }))
              }
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="servings">Portions</Label>
            <Input
              id="servings"
              type="number"
              min="1"
              value={formData.servings}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, servings: e.target.value }))
              }
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Ingrédients et instructions</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="ingredients">Ingrédients</Label>
            <Textarea
              id="ingredients"
              value={formData.ingredients}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, ingredients: e.target.value }))
              }
              rows={6}
              placeholder="Un ingrédient par ligne..."
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="instructions">Instructions</Label>
            <Textarea
              id="instructions"
              value={formData.instructions}
              onChange={(e) =>
                setFormData((prev) => ({
                  ...prev,
                  instructions: e.target.value,
                }))
              }
              rows={8}
              placeholder="Les étapes de préparation..."
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Tags</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex flex-wrap gap-4">
            {tags.map((tag) => (
              <div key={tag.id} className="flex items-center space-x-2">
                <Checkbox
                  id={`tag-${tag.id}`}
                  checked={formData.tag_ids.includes(tag.id)}
                  onCheckedChange={() => toggleTag(tag.id)}
                />
                <Label htmlFor={`tag-${tag.id}`} className="cursor-pointer">
                  {tag.name}
                </Label>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {error && <p className="text-sm text-destructive">{error}</p>}

      <div className="flex gap-4">
        <Button type="submit" disabled={loading}>
          {loading
            ? "Enregistrement..."
            : recipe
            ? "Mettre à jour"
            : "Créer la recette"}
        </Button>
        <Button
          type="button"
          variant="outline"
          onClick={() => router.back()}
        >
          Annuler
        </Button>
      </div>
    </form>
  );
}
