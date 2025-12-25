 -- Description: Supprime les policies RLS redondantes (authenticated déjà couvert par public)

  -- ============================================
  -- Table: categories
  -- ============================================
  drop policy if exists "authenticated_read_categories" on "public"."categories";

  -- ============================================
  -- Table: favorite_menus
  -- ============================================
  drop policy if exists "favorite_menus_select" on "public"."favorite_menus";
  drop policy if exists "favorite_menus_insert" on "public"."favorite_menus";
  drop policy if exists "favorite_menus_delete" on "public"."favorite_menus";

  -- ============================================
  -- Table: favorite_recipes
  -- ============================================
  drop policy if exists "favorite_recipes_select" on "public"."favorite_recipes";
  drop policy if exists "favorite_recipes_insert" on "public"."favorite_recipes";
  drop policy if exists "favorite_recipes_delete" on "public"."favorite_recipes";

  -- ============================================
  -- Table: profiles
  -- ============================================
  drop policy if exists "profiles_read" on "public"."profiles";
  drop policy if exists "profiles_update_own" on "public"."profiles";

  -- ============================================
  -- Table: recipe_tags
  -- ============================================
  drop policy if exists "authenticated_read_recipe_tags" on "public"."recipe_tags";

  -- ============================================
  -- Table: recipes
  -- ============================================
  drop policy if exists "authenticated_read_recipes" on "public"."recipes";
  drop policy if exists "recipes_insert" on "public"."recipes";
  drop policy if exists "recipes_update" on "public"."recipes";
  drop policy if exists "recipes_delete" on "public"."recipes";

  -- ============================================
  -- Table: tags
  -- ============================================
  drop policy if exists "authenticated_read_tags" on "public"."tags";