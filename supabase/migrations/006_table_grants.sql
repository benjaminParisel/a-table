-- Grant permissions to anon and authenticated roles
-- Required for PostgREST to allow access to tables

-- SELECT permissions for all tables
GRANT SELECT ON public.recipes TO anon, authenticated;
GRANT SELECT ON public.categories TO anon, authenticated;
GRANT SELECT ON public.tags TO anon, authenticated;
GRANT SELECT ON public.recipe_tags TO anon, authenticated;
GRANT SELECT ON public.profiles TO anon, authenticated;
GRANT SELECT ON public.favorite_recipes TO anon, authenticated;
GRANT SELECT ON public.favorite_menus TO anon, authenticated;

-- INSERT, UPDATE, DELETE for authenticated users
GRANT INSERT, UPDATE, DELETE ON public.recipes TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.recipe_tags TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.favorite_recipes TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.favorite_menus TO authenticated;
GRANT INSERT, UPDATE ON public.profiles TO authenticated;
