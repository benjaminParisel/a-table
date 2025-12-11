-- ======================
-- À Table ! Database Schema
-- ======================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ======================
-- PROFILES (extends Supabase auth.users)
-- ======================
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ======================
-- CATEGORIES
-- ======================
CREATE TABLE public.categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ======================
-- TAGS
-- ======================
CREATE TABLE public.tags (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ======================
-- RECIPES
-- ======================
CREATE TABLE public.recipes (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  ingredients TEXT,
  instructions TEXT,
  prep_time INTEGER,
  cook_time INTEGER,
  servings INTEGER DEFAULT 4,
  image_url TEXT,
  category_id UUID NOT NULL REFERENCES public.categories(id),
  created_by UUID REFERENCES public.profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for search
CREATE INDEX idx_recipes_title ON public.recipes
  USING GIN (to_tsvector('french', title));
CREATE INDEX idx_recipes_ingredients ON public.recipes
  USING GIN (to_tsvector('french', ingredients));
CREATE INDEX idx_recipes_category ON public.recipes(category_id);

-- ======================
-- RECIPE_TAGS (Junction table)
-- ======================
CREATE TABLE public.recipe_tags (
  recipe_id UUID REFERENCES public.recipes(id) ON DELETE CASCADE,
  tag_id UUID REFERENCES public.tags(id) ON DELETE CASCADE,
  PRIMARY KEY (recipe_id, tag_id)
);

CREATE INDEX idx_recipe_tags_recipe ON public.recipe_tags(recipe_id);
CREATE INDEX idx_recipe_tags_tag ON public.recipe_tags(tag_id);

-- ======================
-- ROW LEVEL SECURITY
-- ======================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_tags ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view all profiles" ON public.profiles
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- Categories policies (all authenticated can read, admin can write)
CREATE POLICY "Anyone can view categories" ON public.categories
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin can manage categories" ON public.categories
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Tags policies
CREATE POLICY "Anyone can view tags" ON public.tags
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin can manage tags" ON public.tags
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Recipes policies (all authenticated can CRUD)
CREATE POLICY "Anyone can view recipes" ON public.recipes
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Anyone can create recipes" ON public.recipes
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Anyone can update recipes" ON public.recipes
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Anyone can delete recipes" ON public.recipes
  FOR DELETE USING (auth.role() = 'authenticated');

-- Recipe_tags policies
CREATE POLICY "Anyone can view recipe_tags" ON public.recipe_tags
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Anyone can manage recipe_tags" ON public.recipe_tags
  FOR ALL USING (auth.role() = 'authenticated');

-- ======================
-- FUNCTIONS
-- ======================

-- Function to search recipes
CREATE OR REPLACE FUNCTION search_recipes(search_query TEXT)
RETURNS SETOF public.recipes AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT r.*
  FROM public.recipes r
  LEFT JOIN public.recipe_tags rt ON r.id = rt.recipe_id
  LEFT JOIN public.tags t ON rt.tag_id = t.id
  WHERE
    r.title ILIKE '%' || search_query || '%'
    OR r.ingredients ILIKE '%' || search_query || '%'
    OR t.name ILIKE '%' || search_query || '%'
  ORDER BY r.title;
END;
$$ LANGUAGE plpgsql;

-- Function to get random recipe by category
CREATE OR REPLACE FUNCTION get_random_recipe_by_category(cat_id UUID)
RETURNS SETOF public.recipes AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM public.recipes
  WHERE category_id = cat_id
  ORDER BY RANDOM()
  LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- ======================
-- TRIGGERS
-- ======================

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER recipes_updated_at
  BEFORE UPDATE ON public.recipes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (NEW.id, NEW.email, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
