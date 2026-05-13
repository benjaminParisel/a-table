"use client";

import { useState, useEffect, useRef, useCallback } from "react";
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

interface FilterState {
  search: string;
  categories: string[];
  tags: string[];
  prepTimeMax: string;
  cookTimeMax: string;
  authors: string[];
}

export function RecipeFilters({ categories, tags, authors }: RecipeFiltersProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [isExpanded, setIsExpanded] = useState(false);

  // Parse URL params
  const urlFilters: FilterState = {
    search: searchParams.get("search") || "",
    categories: searchParams.get("categories")?.split(",").filter(Boolean) || [],
    tags: searchParams.get("tags")?.split(",").filter(Boolean) || [],
    prepTimeMax: searchParams.get("prepTimeMax") || "",
    cookTimeMax: searchParams.get("cookTimeMax") || "",
    authors: searchParams.get("authors")?.split(",").filter(Boolean) || [],
  };

  // Local state for all filters
  const [filters, setFilters] = useState<FilterState>(urlFilters);
  const debounceRef = useRef<NodeJS.Timeout | null>(null);

  const activeFiltersCount = [
    filters.prepTimeMax,
    filters.cookTimeMax,
    ...filters.categories,
    ...filters.authors,
    ...filters.tags,
  ].filter(Boolean).length;

  // Apply filters to URL with debounce
  const applyFilters = useCallback((newFilters: FilterState) => {
    if (debounceRef.current) {
      clearTimeout(debounceRef.current);
    }

    debounceRef.current = setTimeout(() => {
      const params = new URLSearchParams();

      if (newFilters.search) params.set("search", newFilters.search);
      if (newFilters.categories.length > 0) params.set("categories", newFilters.categories.join(","));
      if (newFilters.tags.length > 0) params.set("tags", newFilters.tags.join(","));
      if (newFilters.prepTimeMax) params.set("prepTimeMax", newFilters.prepTimeMax);
      if (newFilters.cookTimeMax) params.set("cookTimeMax", newFilters.cookTimeMax);
      if (newFilters.authors.length > 0) params.set("authors", newFilters.authors.join(","));

      const queryString = params.toString();
      router.push(queryString ? `/recipes?${queryString}` : "/recipes");
    }, 400);
  }, [router]);

  // Update filter and trigger debounced apply
  const updateFilter = useCallback(<K extends keyof FilterState>(key: K, value: FilterState[K]) => {
    setFilters(prev => {
      const newFilters = { ...prev, [key]: value };
      applyFilters(newFilters);
      return newFilters;
    });
  }, [applyFilters]);

  // Sync local state with URL params when navigating (back/forward)
  useEffect(() => {
    setFilters(urlFilters);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams]);

  // Cleanup timeout on unmount
  useEffect(() => {
    return () => {
      if (debounceRef.current) {
        clearTimeout(debounceRef.current);
      }
    };
  }, []);

  const toggleTag = (tagSlug: string) => {
    const newTags = filters.tags.includes(tagSlug)
      ? filters.tags.filter((t) => t !== tagSlug)
      : [...filters.tags, tagSlug];
    updateFilter("tags", newTags);
  };

  const toggleCategory = (categorySlug: string) => {
    const newCategories = filters.categories.includes(categorySlug)
      ? filters.categories.filter((c) => c !== categorySlug)
      : [...filters.categories, categorySlug];
    updateFilter("categories", newCategories);
  };

  const toggleAuthor = (authorId: string) => {
    const newAuthors = filters.authors.includes(authorId)
      ? filters.authors.filter((a) => a !== authorId)
      : [...filters.authors, authorId];
    updateFilter("authors", newAuthors);
  };

  const clearFilters = () => {
    if (debounceRef.current) {
      clearTimeout(debounceRef.current);
    }
    setFilters({
      search: "",
      categories: [],
      tags: [],
      prepTimeMax: "",
      cookTimeMax: "",
      authors: [],
    });
    router.push("/recipes");
  };

  const hasFilters = filters.search || filters.categories.length > 0 || filters.tags.length > 0 || filters.prepTimeMax || filters.cookTimeMax || filters.authors.length > 0;

  return (
    <div className="space-y-4">
      {/* Barre de recherche + bouton filtres (toujours visible) */}
      <div className="flex gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Rechercher une recette..."
            value={filters.search}
            onChange={(e) => updateFilter("search", e.target.value)}
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
                  {filters.categories.length === 0
                    ? "Catégories"
                    : filters.categories.length === 1
                      ? categories.find((c) => c.slug === filters.categories[0])?.name
                      : `${filters.categories.length} catégories`}
                </span>
                <ChevronDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-[180px]">
              {categories.map((cat) => (
                <DropdownMenuCheckboxItem
                  key={cat.id}
                  checked={filters.categories.includes(cat.slug)}
                  onCheckedChange={() => toggleCategory(cat.slug)}
                >
                  {cat.name}
                </DropdownMenuCheckboxItem>
              ))}
            </DropdownMenuContent>
          </DropdownMenu>
          <Select
            value={filters.prepTimeMax || "all"}
            onValueChange={(value) =>
              updateFilter("prepTimeMax", value === "all" ? "" : value)
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
            value={filters.cookTimeMax || "all"}
            onValueChange={(value) =>
              updateFilter("cookTimeMax", value === "all" ? "" : value)
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
                      {filters.authors.length === 0
                        ? "Auteurs"
                        : filters.authors.length === 1
                          ? authors.find((a) => a.id === filters.authors[0])?.display_name ||
                            authors.find((a) => a.id === filters.authors[0])?.email
                          : `${filters.authors.length} auteurs`}
                    </span>
                  </div>
                  <ChevronDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent className="w-[180px]">
                {authors.map((a) => (
                  <DropdownMenuCheckboxItem
                    key={a.id}
                    checked={filters.authors.includes(a.id)}
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
              variant={filters.tags.includes(tag.slug) ? "default" : "outline"}
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
