"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { Search, X } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { PREP_TIME_FILTERS, COOK_TIME_FILTERS } from "@/lib/constants";
import type { Category, Tag } from "@/types";

interface RecipeFiltersProps {
  categories: Category[];
  tags: Tag[];
}

export function RecipeFilters({ categories, tags }: RecipeFiltersProps) {
  const router = useRouter();
  const searchParams = useSearchParams();

  const search = searchParams.get("search") || "";
  const category = searchParams.get("category") || "";
  const selectedTags = searchParams.get("tags")?.split(",").filter(Boolean) || [];
  const prepTimeMax = searchParams.get("prepTimeMax") || "";
  const cookTimeMax = searchParams.get("cookTimeMax") || "";

  const updateParams = (key: string, value: string | null) => {
    const params = new URLSearchParams(searchParams.toString());
    if (value) {
      params.set(key, value);
    } else {
      params.delete(key);
    }
    router.push(`/recipes?${params.toString()}`);
  };

  const toggleTag = (tagSlug: string) => {
    const newTags = selectedTags.includes(tagSlug)
      ? selectedTags.filter((t) => t !== tagSlug)
      : [...selectedTags, tagSlug];
    updateParams("tags", newTags.length > 0 ? newTags.join(",") : null);
  };

  const clearFilters = () => {
    router.push("/recipes");
  };

  const hasFilters = search || category || selectedTags.length > 0 || prepTimeMax || cookTimeMax;

  return (
    <div className="space-y-4">
      <div className="flex flex-col gap-4 sm:flex-row">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Rechercher une recette..."
            value={search}
            onChange={(e) => updateParams("search", e.target.value || null)}
            className="pl-9"
          />
        </div>
        <Select
          value={category}
          onValueChange={(value) =>
            updateParams("category", value === "all" ? null : value)
          }
        >
          <SelectTrigger className="w-full sm:w-[180px]">
            <SelectValue placeholder="Catégorie" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Toutes les catégories</SelectItem>
            {categories.map((cat) => (
              <SelectItem key={cat.id} value={cat.slug}>
                {cat.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select
          value={prepTimeMax}
          onValueChange={(value) =>
            updateParams("prepTimeMax", value === "all" ? null : value)
          }
        >
          <SelectTrigger className="w-full sm:w-[180px]">
            <SelectValue placeholder="Préparation" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Toute préparation</SelectItem>
            {PREP_TIME_FILTERS.map((filter) => (
              <SelectItem key={filter.value} value={filter.value}>
                {filter.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select
          value={cookTimeMax}
          onValueChange={(value) =>
            updateParams("cookTimeMax", value === "all" ? null : value)
          }
        >
          <SelectTrigger className="w-full sm:w-[180px]">
            <SelectValue placeholder="Cuisson" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Toute cuisson</SelectItem>
            {COOK_TIME_FILTERS.map((filter) => (
              <SelectItem key={filter.value} value={filter.value}>
                {filter.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="flex flex-wrap gap-2">
        {tags.map((tag) => (
          <Badge
            key={tag.id}
            variant={selectedTags.includes(tag.slug) ? "default" : "outline"}
            className="cursor-pointer"
            onClick={() => toggleTag(tag.slug)}
          >
            {tag.name}
          </Badge>
        ))}
      </div>

      {hasFilters && (
        <Button variant="ghost" size="sm" onClick={clearFilters}>
          <X className="mr-2 h-4 w-4" />
          Effacer les filtres
        </Button>
      )}
    </div>
  );
}
