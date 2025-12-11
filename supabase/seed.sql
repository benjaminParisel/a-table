-- ======================
-- Seed Data for À Table !
-- ======================

-- Insert default categories
INSERT INTO public.categories (name, slug, display_order) VALUES
  ('Entrée', 'starter', 1),
  ('Plat', 'main', 2),
  ('Dessert', 'dessert', 3),
  ('Apéro', 'appetizer', 4),
  ('Accompagnement', 'side', 5)
ON CONFLICT (slug) DO NOTHING;

-- Insert default tags
INSERT INTO public.tags (name, slug) VALUES
  ('Végétarien', 'vegetarian'),
  ('Végan', 'vegan'),
  ('Sans gluten', 'gluten-free'),
  ('Sans lactose', 'lactose-free'),
  ('Rapide', 'quick'),
  ('Économique', 'budget'),
  ('Familial', 'family'),
  ('Festif', 'festive')
ON CONFLICT (slug) DO NOTHING;
