"use client";

import { useState, useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { Search, X, SlidersHorizontal, ChevronUp, ChefHat, CookingPot, User, ChevronDown } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Badge } from "@/components/ui/badge";
import { PREP_TIME_FILTERS, COOK_TIME_FILTERS } from "@/lib/constants";
import type { Category, Tag } from "@/types";

interface Author {
  id: string;
  display_name: string | null;
  email: string;
}

interface RecipeFiltersProps {
  categories: Category[];
  tags: Tag[];
  authors: Author[];
}

export function RecipeFilters({ categories, tags, authors }: RecipeFiltersProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [isExpanded, setIsExpanded] = useState(false);

  const search = searchParams.get("search") || "";
  const [searchValue, setSearchValue] = useState(search);
  const selectedCategories = searchParams.get("categories")?.split(",").filter(Boolean) || [];
  const selectedTags = searchParams.get("tags")?.split(",").filter(Boolean) || [];
  const prepTimeMax = searchParams.get("prepTimeMax") || "";
  const cookTimeMax = searchParams.get("cookTimeMax") || "";
  const selectedAuthors = searchParams.get("authors")?.split(",").filter(Boolean) || [];

  const activeFiltersCount = [
    prepTimeMax,
    cookTimeMax,
    ...selectedCategories,
    ...selectedAuthors,
    ...selectedTags,
  ].filter(Boolean).length;

  // Debounce search input
  useEffect(() => {
    const timer = setTimeout(() => {
      if (searchValue !== search) {
        const params = new URLSearchParams(searchParams.toString());
        if (searchValue) {
          params.set("search", searchValue);
        } else {
          params.delete("search");
        }
        router.push(`/recipes?${params.toString()}`);
      }
    }, 300);

    return () => clearTimeout(timer);
  }, [searchValue, search, searchParams, router]);

  // Sync local state with URL params when navigating
  useEffect(() => {
    setSearchValue(search);
  }, [search]);

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

  const toggleCategory = (categorySlug: string) => {
    const newCategories = selectedCategories.includes(categorySlug)
      ? selectedCategories.filter((c) => c !== categorySlug)
      : [...selectedCategories, categorySlug];
    updateParams("categories", newCategories.length > 0 ? newCategories.join(",") : null);
  };

  const toggleAuthor = (authorId: string) => {
    const newAuthors = selectedAuthors.includes(authorId)
      ? selectedAuthors.filter((a) => a !== authorId)
      : [...selectedAuthors, authorId];
    updateParams("authors", newAuthors.length > 0 ? newAuthors.join(",") : null);
  };

  const clearFilters = () => {
    router.push("/recipes");
  };

  const hasFilters = search || selectedCategories.length > 0 || selectedTags.length > 0 || prepTimeMax || cookTimeMax || selectedAuthors.length > 0;

  return (
    <div className="space-y-4">
      {/* Barre de recherche + bouton filtres (toujours visible) */}
      <div className="flex gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Rechercher une recette..."
            value={searchValue}
            onChange={(e) => setSearchValue(e.target.value)}
            className="pl-9"
          />
        </div>
        {/* Bouton toggle filtres - visible uniquement sur mobile */}
        <Button
          variant="outline"
          size="icon"
          className="sm:hidden shrink-0"
          onClick={() => setIsExpanded(!isExpanded)}
        >
          {isExpanded ? (
            <ChevronUp className="h-4 w-4" />
          ) : (
            <SlidersHorizontal className="h-4 w-4" />
          )}
          {activeFiltersCount > 0 && !isExpanded && (
            <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-primary text-[10px] text-primary-foreground flex items-center justify-center">
              {activeFiltersCount}
            </span>
          )}
        </Button>
      </div>

      {/* Filtres - masqués sur mobile sauf si expanded, toujours visibles sur desktop */}
      <div className={`space-y-4 ${isExpanded ? "block" : "hidden"} sm:block`}>
        <div className="flex flex-col gap-4 sm:flex-row">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="outline" className="w-full sm:w-[180px] justify-between">
                <span className="truncate">
                  {selectedCategories.length === 0
                    ? "Catégories"
                    : selectedCategories.length === 1
                      ? categories.find((c) => c.slug === selectedCategories[0])?.name
                      : `${selectedCategories.length} catégories`}
                </span>
                <ChevronDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-[180px]">
              {categories.map((cat) => (
                <DropdownMenuCheckboxItem
                  key={cat.id}
                  checked={selectedCategories.includes(cat.slug)}
                  onCheckedChange={() => toggleCategory(cat.slug)}
                >
                  {cat.name}
                </DropdownMenuCheckboxItem>
              ))}
            </DropdownMenuContent>
          </DropdownMenu>
          <Select
            value={prepTimeMax}
            onValueChange={(value) =>
              updateParams("prepTimeMax", value === "all" ? null : value)
            }
          >
            <SelectTrigger className="w-full sm:w-[180px]">
              <div className="flex items-center gap-2">
                <ChefHat className="h-4 w-4 shrink-0" />
                <SelectValue placeholder="Préparation" />
              </div>
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
              <div className="flex items-center gap-2">
                <CookingPot className="h-4 w-4 shrink-0" />
                <SelectValue placeholder="Cuisson" />
              </div>
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
          {authors.length > 0 && (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="outline" className="w-full sm:w-[180px] justify-between">
                  <div className="flex items-center gap-2 truncate">
                    <User className="h-4 w-4 shrink-0" />
                    <span className="truncate">
                      {selectedAuthors.length === 0
                        ? "Auteurs"
                        : selectedAuthors.length === 1
                          ? authors.find((a) => a.id === selectedAuthors[0])?.display_name ||
                            authors.find((a) => a.id === selectedAuthors[0])?.email
                          : `${selectedAuthors.length} auteurs`}
                    </span>
                  </div>
                  <ChevronDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent className="w-[180px]">
                {authors.map((a) => (
                  <DropdownMenuCheckboxItem
                    key={a.id}
                    checked={selectedAuthors.includes(a.id)}
                    onCheckedChange={() => toggleAuthor(a.id)}
                  >
                    {a.display_name || a.email}
                  </DropdownMenuCheckboxItem>
                ))}
              </DropdownMenuContent>
            </DropdownMenu>
          )}
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
    </div>
  );
}
