-- Migration: admin_manage_profiles
-- Description: Permet aux admins de modifier et supprimer les profils utilisateurs

-- ============================================
-- Table: profiles - Policies admin
-- ============================================

-- Policy pour permettre aux admins de modifier n'importe quel profil
CREATE POLICY "Admins can update any profile"
ON "public"."profiles"
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- Policy pour permettre aux admins de supprimer n'importe quel profil
-- Note: La suppression du profil est généralement faite via la suppression
-- de l'utilisateur dans auth.users (qui cascade sur profiles)
-- Mais on ajoute cette policy pour la cohérence
CREATE POLICY "Admins can delete any profile"
ON "public"."profiles"
FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
);
