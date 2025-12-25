export type UserRole = "admin" | "user";

export interface Profile {
  id: string;
  email: string;
  display_name: string | null;
  role: UserRole;
  show_images: boolean;
  created_at: string;
  updated_at: string;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  display_order: number;
  created_at: string;
}

export interface Tag {
  id: string;
  name: string;
  slug: string;
  created_at: string;
}

export interface Recipe {
  id: string;
  title: string;
  slug: string;
  description: string | null;
  ingredients: string | null;
  instructions: string | null;
  prep_time: number | null;
  cook_time: number | null;
  servings: number;
  image_url: string | null;
  category_id: string;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface RecipeWithRelations extends Recipe {
  category: Category;
  tags: Tag[];
  author: Profile | null;
}

export interface ExtractedRecipe {
  title: string;
  description: string | null;
  ingredients: string;
  instructions: string;
  prep_time: number | null;
  cook_time: number | null;
  servings: number | null;
}

export interface RecipeFilters {
  search?: string;
  category?: string;
  tags?: string[];
  prepTimeMax?: number;
  cookTimeMax?: number;
}

export interface MenuSelection {
  categories: string[];
}

export interface GeneratedMenu {
  recipes: RecipeWithRelations[];
  generated_at: string;
}

// API Response types
export interface ApiResponse<T> {
  data?: T;
  error?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface FavoriteMenu {
  id: string;
  user_id: string;
  recipe_ids: string[];
  created_at: string;
  updated_at: string;
}

export interface FavoriteMenuWithRecipes {
  id: string;
  user_id: string;
  recipes: RecipeWithRelations[];
  created_at: string;
  updated_at: string;
}

export interface IngredientSearchResult {
  recipe: RecipeWithRelations;
  matchedIngredients: string[];
  matchCount: number;
}

export interface FavoriteRecipe {
  id: string;
  user_id: string;
  recipe_id: string;
  created_at: string;
}
