import { revalidateTag } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { Category, Tag } from "@/types";

// Cache tags for granular invalidation
export const CACHE_TAGS = {
  recipes: "recipes",
  categories: "categories",
  tags: "tags",
} as const;

// Fetch categories (requires authentication)
export async function getCategories(): Promise<Category[] | null> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("categories")
    .select("*")
    .order("display_order");
  return data as Category[] | null;
}

// Fetch tags (requires authentication)
export async function getTags(): Promise<Tag[] | null> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("tags")
    .select("*")
    .order("name");
  return data as Tag[] | null;
}

// Invalidate cache functions
export function invalidateRecipesCache() {
  revalidateTag(CACHE_TAGS.recipes, { expire: 0 });
}

export function invalidateCategoriesCache() {
  revalidateTag(CACHE_TAGS.categories, { expire: 0 });
}

export function invalidateTagsCache() {
  revalidateTag(CACHE_TAGS.tags, { expire: 0 });
}

export function invalidateAllCache() {
  revalidateTag(CACHE_TAGS.recipes, { expire: 0 });
  revalidateTag(CACHE_TAGS.categories, { expire: 0 });
  revalidateTag(CACHE_TAGS.tags, { expire: 0 });
}
