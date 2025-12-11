-- ======================
-- Storage Configuration
-- ======================

-- Create bucket for recipe images
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'recipe-images',
  'recipe-images',
  true,
  5242880, -- 5MB
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
);

-- Storage policies for recipe images
CREATE POLICY "Anyone can view recipe images"
ON storage.objects FOR SELECT
USING (bucket_id = 'recipe-images');

CREATE POLICY "Authenticated users can upload recipe images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'recipe-images'
  AND auth.role() = 'authenticated'
);

CREATE POLICY "Authenticated users can update recipe images"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'recipe-images'
  AND auth.role() = 'authenticated'
);

CREATE POLICY "Authenticated users can delete recipe images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'recipe-images'
  AND auth.role() = 'authenticated'
);
