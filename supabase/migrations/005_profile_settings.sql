-- ======================
-- PROFILE SETTINGS
-- Add user preferences
-- ======================

-- Add show_images preference to profiles
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS show_images BOOLEAN DEFAULT true;

-- Update RLS policy to allow users to update their own profile (if not exists)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'profiles'
    AND policyname = 'Users can update own profile'
  ) THEN
    CREATE POLICY "Users can update own profile" ON public.profiles
      FOR UPDATE USING (auth.uid() = id)
      WITH CHECK (auth.uid() = id);
  END IF;
END $$;
