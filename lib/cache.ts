import { unstable_cache, revalidateTag } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { Category, Tag } from "@/types";

// Cache tags for granular invalidation
export const CACHE_TAGS = {
  recipes: "recipes",
  categories: "categories",
  tags: "tags",
} as const;

// Revalidate time in seconds (5 minutes)
const REVALIDATE_TIME = 300;

export const getCachedCategories = unstable_cache(
  async () => {
    const supabase = await createClient();
    const { data } = await supabase
      .from("categories")
      .select("*")
      .order("display_order");
    return data as Category[] | null;
  },
  ["categories"],
  { revalidate: REVALIDATE_TIME, tags: [CACHE_TAGS.categories] }
);

export const getCachedTags = unstable_cache(
  async () => {
    const supabase = await createClient();
    const { data } = await supabase
      .from("tags")
      .select("*")
      .order("name");
    return data as Tag[] | null;
  },
  ["tags"],
  { revalidate: REVALIDATE_TIME, tags: [CACHE_TAGS.tags] }
);

// Invalidate cache functions (Next.js 16 requires a profile/expire config as second arg)
const INVALIDATE_CONFIG = { expire: 0 };

export function invalidateRecipesCache() {
  revalidateTag(CACHE_TAGS.recipes, INVALIDATE_CONFIG);
}

export function invalidateCategoriesCache() {
  revalidateTag(CACHE_TAGS.categories, INVALIDATE_CONFIG);
}

export function invalidateTagsCache() {
  revalidateTag(CACHE_TAGS.tags, INVALIDATE_CONFIG);
}

export function invalidateAllCache() {
  revalidateTag(CACHE_TAGS.recipes, INVALIDATE_CONFIG);
  revalidateTag(CACHE_TAGS.categories, INVALIDATE_CONFIG);
  revalidateTag(CACHE_TAGS.tags, INVALIDATE_CONFIG);
}
