# Task: Identifier les fonctionnalités manquantes

## Vue d'ensemble du projet

**À Table!** est une application Next.js 16 de gestion de recettes avec :
- Stack : Next.js 16 + React 19 + TypeScript + Tailwind CSS + Supabase
- UI : shadcn/ui components
- Auth : Supabase Auth avec rôles (admin/user)

## Fonctionnalités actuellement implémentées

### Core
- CRUD complet des recettes
- Recherche full-text (titre, ingrédients)
- Filtrage par catégorie, tags, temps de préparation
- Upload d'images pour les recettes
- Générateur de menu aléatoire par catégorie

### Auth & Admin
- Login/Logout
- Rôles admin/user
- Gestion des catégories et tags (admin)

### UI/UX
- Thème clair/sombre
- Design responsive
- Notifications toast
- États de chargement (skeleton)

## Fonctionnalités manquantes identifiées

### Priorité Haute (Simples à implémenter)

1. **Système de favoris/bookmarks**
   - Marquer une recette comme favorite
   - Page "Mes favoris"
   - Bouton coeur sur les cartes de recettes

2. **Liste de courses**
   - Générer depuis un menu
   - Ajouter manuellement des ingrédients
   - Cocher les éléments achetés
   - Exporter/Imprimer

3. **Impression de recette**
   - Version imprimable d'une recette
   - CSS @media print optimisé

4. **Profil utilisateur**
   - Modifier son nom d'affichage
   - Changer son mot de passe

5. **Page "Mes recettes"**
   - Voir uniquement les recettes créées par l'utilisateur

6. **Calculateur de portions**
   - Ajuster les quantités d'ingrédients selon le nombre de portions

### Priorité Moyenne

7. **Notes personnelles sur les recettes**
   - Ajouter des notes privées à une recette

8. **Historique des menus générés**
   - Sauvegarder les menus générés
   - Revoir les menus passés

9. **Export de recettes**
   - Export PDF ou JSON d'une ou plusieurs recettes

10. **Recherche par ingrédients disponibles**
    - "Qu'est-ce que je peux faire avec X, Y, Z ?"

### Priorité Basse

11. **Système de notation**
    - Noter les recettes (1-5 étoiles)

12. **Partage de recettes**
    - Lien public pour partager

13. **Planification hebdomadaire**
    - Calendrier de repas sur 7 jours

## Fichiers clés à modifier

### Pour les favoris
- Nouveau : `supabase/migrations/xxx_favorites.sql` (table favorites)
- Nouveau : `app/api/favorites/route.ts`
- Nouveau : `app/(main)/favorites/page.tsx`
- Modifier : `components/recipes/recipe-card.tsx` (bouton favori)
- Modifier : `types/index.ts` (type Favorite)

### Pour la liste de courses
- Nouveau : `supabase/migrations/xxx_shopping_list.sql`
- Nouveau : `app/api/shopping-list/route.ts`
- Nouveau : `app/(main)/shopping-list/page.tsx`
- Nouveau : `components/shopping/shopping-list.tsx`

### Pour l'impression
- Nouveau : `app/(main)/recipes/[id]/print/page.tsx`
- Modifier : `app/globals.css` (styles @media print)

### Pour le profil
- Nouveau : `app/(main)/profile/page.tsx`
- Nouveau : `app/api/profile/route.ts`
- Nouveau : `components/profile/profile-form.tsx`

### Pour mes recettes
- Nouveau : `app/(main)/my-recipes/page.tsx`
- Réutiliser : `components/recipes/recipe-list.tsx` avec filtre

### Pour le calculateur de portions
- Modifier : `app/(main)/recipes/[id]/page.tsx`
- Nouveau : `components/recipes/portion-calculator.tsx`

## Patterns à suivre

### Création de nouvelles tables
```sql
CREATE TABLE public.favorites (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES public.recipes(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);

ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own favorites" ON public.favorites
  FOR ALL USING (auth.uid() = user_id);
```

### Création d'API route
```typescript
// app/api/favorites/route.ts
import { createClient } from "@/lib/supabase/server"
import { NextResponse } from "next/server"

export async function GET() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  const { data, error } = await supabase
    .from("favorites")
    .select("*, recipe:recipes(*)")
    .eq("user_id", user.id)

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  return NextResponse.json({ data })
}
```

### Composant client avec mutation
```typescript
"use client"

import { useState } from "react"
import { Heart } from "lucide-react"
import { Button } from "@/components/ui/button"
import { toast } from "sonner"

export function FavoriteButton({ recipeId, initialFavorited }: Props) {
  const [isFavorited, setIsFavorited] = useState(initialFavorited)
  const [isLoading, setIsLoading] = useState(false)

  const toggleFavorite = async () => {
    setIsLoading(true)
    try {
      const res = await fetch(`/api/favorites/${recipeId}`, {
        method: isFavorited ? "DELETE" : "POST",
      })
      if (res.ok) {
        setIsFavorited(!isFavorited)
        toast.success(isFavorited ? "Retiré des favoris" : "Ajouté aux favoris")
      }
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <Button variant="ghost" size="icon" onClick={toggleFavorite} disabled={isLoading}>
      <Heart className={isFavorited ? "fill-red-500 text-red-500" : ""} />
    </Button>
  )
}
```

## Dépendances existantes

- Supabase client configuré (`lib/supabase/server.ts`, `lib/supabase/client.ts`)
- Système de cache (`lib/cache.ts`)
- Types TypeScript (`types/index.ts`)
- Composants UI shadcn/ui disponibles
- Icônes Lucide React

## Recommandation

Commencer par les **favoris** car :
1. Fonctionnalité très demandée
2. Implémentation simple (1 table, 1 API, 1 composant)
3. Visible immédiatement (bouton coeur sur chaque recette)
4. Sert de base pour d'autres fonctionnalités (liste de courses depuis favoris)
