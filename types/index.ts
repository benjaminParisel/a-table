export type UserRole = "admin" | "user";

export interface Profile {
  id: string;
  email: string;
  display_name: string | null;
  role: UserRole;
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
