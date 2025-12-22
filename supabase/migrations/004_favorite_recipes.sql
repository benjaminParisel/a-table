-- ======================
-- FAVORITE RECIPES
-- Store favorite recipes per user (many-to-many)
-- ======================

CREATE TABLE public.favorite_recipes (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES public.recipes(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT unique_user_recipe_favorite UNIQUE (user_id, recipe_id)
);

CREATE INDEX idx_favorite_recipes_user ON public.favorite_recipes(user_id);
CREATE INDEX idx_favorite_recipes_recipe ON public.favorite_recipes(recipe_id);

-- Enable RLS
ALTER TABLE public.favorite_recipes ENABLE ROW LEVEL SECURITY;

-- Users can only manage their own favorites
CREATE POLICY "Users can view own favorite recipes" ON public.favorite_recipes
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own favorite recipes" ON public.favorite_recipes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorite recipes" ON public.favorite_recipes
  FOR DELETE USING (auth.uid() = user_id);
