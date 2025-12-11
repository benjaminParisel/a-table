-- ======================
-- Revert anonymous read access - keep data private
-- ======================

-- Drop the anonymous read policies
DROP POLICY IF EXISTS "Anon can view categories" ON public.categories;
DROP POLICY IF EXISTS "Anon can view tags" ON public.tags;
DROP POLICY IF EXISTS "Anon can view recipes" ON public.recipes;
DROP POLICY IF EXISTS "Anon can view recipe_tags" ON public.recipe_tags;
