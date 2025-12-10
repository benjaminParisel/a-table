export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string;
          display_name: string | null;
          role: "admin" | "user";
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          email: string;
          display_name?: string | null;
          role?: "admin" | "user";
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          display_name?: string | null;
          role?: "admin" | "user";
          created_at?: string;
          updated_at?: string;
        };
      };
      categories: {
        Row: {
          id: string;
          name: string;
          slug: string;
          display_order: number;
          created_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          slug: string;
          display_order?: number;
          created_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          slug?: string;
          display_order?: number;
          created_at?: string;
        };
      };
      tags: {
        Row: {
          id: string;
          name: string;
          slug: string;
          created_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          slug: string;
          created_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          slug?: string;
          created_at?: string;
        };
      };
      recipes: {
        Row: {
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
        };
        Insert: {
          id?: string;
          title: string;
          slug: string;
          description?: string | null;
          ingredients?: string | null;
          instructions?: string | null;
          prep_time?: number | null;
          cook_time?: number | null;
          servings?: number;
          image_url?: string | null;
          category_id: string;
          created_by?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          title?: string;
          slug?: string;
          description?: string | null;
          ingredients?: string | null;
          instructions?: string | null;
          prep_time?: number | null;
          cook_time?: number | null;
          servings?: number;
          image_url?: string | null;
          category_id?: string;
          created_by?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      recipe_tags: {
        Row: {
          recipe_id: string;
          tag_id: string;
        };
        Insert: {
          recipe_id: string;
          tag_id: string;
        };
        Update: {
          recipe_id?: string;
          tag_id?: string;
        };
      };
    };
    Functions: {
      search_recipes: {
        Args: { search_query: string };
        Returns: Database["public"]["Tables"]["recipes"]["Row"][];
      };
      get_random_recipe_by_category: {
        Args: { cat_id: string };
        Returns: Database["public"]["Tables"]["recipes"]["Row"];
      };
    };
  };
}
