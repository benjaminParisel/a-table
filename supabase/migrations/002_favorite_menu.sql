-- ======================
-- FAVORITE MENUS
-- Store one favorite menu per user
-- ======================

CREATE TABLE public.favorite_menus (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  recipe_ids UUID[] NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT unique_user_favorite UNIQUE (user_id)
);

CREATE INDEX idx_favorite_menus_user ON public.favorite_menus(user_id);

-- Enable RLS
ALTER TABLE public.favorite_menus ENABLE ROW LEVEL SECURITY;

-- Users can only manage their own favorite menu
CREATE POLICY "Users can view own favorite menu" ON public.favorite_menus
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own favorite menu" ON public.favorite_menus
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own favorite menu" ON public.favorite_menus
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorite menu" ON public.favorite_menus
  FOR DELETE USING (auth.uid() = user_id);

-- Auto-update updated_at trigger
CREATE TRIGGER favorite_menus_updated_at
  BEFORE UPDATE ON public.favorite_menus
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
