# À Table! - Guide de développement

## Stack technique

- Next.js 16 + React 19 + TypeScript
- Tailwind CSS 4
- Supabase (PostgreSQL + Auth)
- shadcn/ui components
- Icônes: Lucide React

## Patterns à suivre

### API Routes

- Validation avec Zod
- Utiliser `createClient` et `getUser` de `@/lib/supabase/server`
- Retourner `NextResponse.json()`
- Gestion d'erreurs standardisée

### Composants

- Client components: `"use client"` en haut du fichier
- Server components: par défaut dans `app/`
- UI: utiliser shadcn/ui (`@/components/ui/`)

### Base de données

- Ingrédients stockés en texte brut séparé par `\n`
- Relations many-to-many via tables de junction
- RLS activé sur toutes les tables

## Commandes utiles

```bash
pnpm dev          # Serveur de développement
pnpm build        # Build production
pnpm lint         # Linting
```

## Structure du projet

```
app/
├── (main)/       # Pages avec layout principal
├── api/          # API routes
components/
├── ui/           # shadcn/ui components
├── recipes/      # Composants recettes
├── menu/         # Composants menu
lib/
├── supabase/     # Client Supabase
├── cache.ts      # Utilitaires de cache
├── utils.ts      # Fonctions utilitaires
types/
└── index.ts      # Types TypeScript globaux
supabase/
├── schema.sql    # Schéma de base de données
└── seed.sql      # Données de test
```
