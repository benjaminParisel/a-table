-- Migration: restrict_access_to_authenticated_users
-- Description: Restreint l'accès à l'application aux utilisateurs connectés uniquement

-- ============================================
-- Table: categories
-- ============================================
-- Supprimer les anciennes policies
drop policy if exists "Anyone can view categories" on "public"."categories";
drop policy if exists "authenticated_read_categories" on "public"."categories";

-- Nouvelle policy: lecture authentifiée uniquement
create policy "Authenticated users can view categories"
on "public"."categories"
for select
to authenticated
using (true);

-- ============================================
-- Table: recipes
-- ============================================
-- Supprimer les anciennes policies
drop policy if exists "Anyone can view recipes" on "public"."recipes";
drop policy if exists "authenticated_read_recipes" on "public"."recipes";
drop policy if exists "Anyone can create recipes" on "public"."recipes";
drop policy if exists "recipes_insert" on "public"."recipes";
drop policy if exists "Anyone can update recipes" on "public"."recipes";
drop policy if exists "recipes_update" on "public"."recipes";
drop policy if exists "Anyone can delete recipes" on "public"."recipes";
drop policy if exists "recipes_delete" on "public"."recipes";

-- Nouvelles policies: authentifié uniquement
create policy "Authenticated users can view recipes"
on "public"."recipes"
for select
to authenticated
using (true);

create policy "Authenticated users can create recipes"
on "public"."recipes"
for insert
to authenticated
with check (true);

create policy "Authenticated users can update recipes"
on "public"."recipes"
for update
to authenticated
using (true);

create policy "Authenticated users can delete recipes"
on "public"."recipes"
for delete
to authenticated
using (true);

-- ============================================
-- Table: tags
-- ============================================
-- Supprimer les anciennes policies
drop policy if exists "Anyone can view tags" on "public"."tags";
drop policy if exists "authenticated_read_tags" on "public"."tags";

-- Nouvelle policy: lecture authentifiée uniquement
create policy "Authenticated users can view tags"
on "public"."tags"
for select
to authenticated
using (true);

-- ============================================
-- Table: profiles
-- ============================================
-- Supprimer les anciennes policies
drop policy if exists "Users can view all profiles" on "public"."profiles";
drop policy if exists "profiles_read" on "public"."profiles";
drop policy if exists "Users can update own profile" on "public"."profiles";
drop policy if exists "profiles_update_own" on "public"."profiles";

-- Nouvelles policies: authentifié uniquement
create policy "Authenticated users can view profiles"
on "public"."profiles"
for select
to authenticated
using (true);

create policy "Authenticated users can update own profile"
on "public"."profiles"
for update
to authenticated
using (auth.uid() = id);

-- ============================================
-- Table: recipe_tags
-- ============================================
-- Supprimer les anciennes policies
drop policy if exists "Anyone can view recipe_tags" on "public"."recipe_tags";
drop policy if exists "authenticated_read_recipe_tags" on "public"."recipe_tags";
drop policy if exists "Anyone can manage recipe_tags" on "public"."recipe_tags";

-- Nouvelles policies: authentifié uniquement
create policy "Authenticated users can view recipe_tags"
on "public"."recipe_tags"
for select
to authenticated
using (true);

create policy "Authenticated users can manage recipe_tags"
on "public"."recipe_tags"
for all
to authenticated
using (true)
with check (true);

-- ============================================
-- Table: favorite_menus
-- ============================================
-- Supprimer les anciennes policies (déjà sécurisées mais nommées "public")
drop policy if exists "Users can view own favorite menu" on "public"."favorite_menus";
drop policy if exists "favorite_menus_select" on "public"."favorite_menus";
drop policy if exists "Users can create own favorite menu" on "public"."favorite_menus";
drop policy if exists "favorite_menus_insert" on "public"."favorite_menus";
drop policy if exists "Users can update own favorite menu" on "public"."favorite_menus";
drop policy if exists "Users can delete own favorite menu" on "public"."favorite_menus";
drop policy if exists "favorite_menus_delete" on "public"."favorite_menus";

-- Nouvelles policies: authentifié + propriétaire
create policy "Authenticated users can view own favorite menus"
on "public"."favorite_menus"
for select
to authenticated
using (auth.uid() = user_id);

create policy "Authenticated users can create own favorite menus"
on "public"."favorite_menus"
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Authenticated users can update own favorite menus"
on "public"."favorite_menus"
for update
to authenticated
using (auth.uid() = user_id);

create policy "Authenticated users can delete own favorite menus"
on "public"."favorite_menus"
for delete
to authenticated
using (auth.uid() = user_id);

-- ============================================
-- Table: favorite_recipes
-- ============================================
-- Supprimer les anciennes policies
drop policy if exists "Users can view own favorite recipes" on "public"."favorite_recipes";
drop policy if exists "favorite_recipes_select" on "public"."favorite_recipes";
drop policy if exists "Users can create own favorite recipes" on "public"."favorite_recipes";
drop policy if exists "favorite_recipes_insert" on "public"."favorite_recipes";
drop policy if exists "Users can delete own favorite recipes" on "public"."favorite_recipes";
drop policy if exists "favorite_recipes_delete" on "public"."favorite_recipes";

-- Nouvelles policies: authentifié + propriétaire
create policy "Authenticated users can view own favorite recipes"
on "public"."favorite_recipes"
for select
to authenticated
using (auth.uid() = user_id);

create policy "Authenticated users can create own favorite recipes"
on "public"."favorite_recipes"
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Authenticated users can delete own favorite recipes"
on "public"."favorite_recipes"
for delete
to authenticated
using (auth.uid() = user_id);
