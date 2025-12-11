# À Table !

Application familiale privée de gestion de recettes de cuisine.

## Fonctionnalités

- **Gestion des recettes** : Créer, modifier, supprimer et consulter des recettes
- **Catégories** : Entrée, Plat, Dessert, Apéro, Accompagnement
- **Tags** : Végétarien, Végan, Sans gluten, Sans lactose, Rapide, Économique, Familial, Festif
- **Recherche et filtres** : Par titre, ingrédients, catégorie, tags et temps de préparation
- **Générateur de menus** : Génération aléatoire de menus par catégories
- **Authentification** : Accès privé avec gestion des rôles (admin/utilisateur)
- **Mode sombre** : Support du thème clair/sombre

## Stack technique

- **Framework** : Next.js 16 (App Router) avec TypeScript
- **React** : 19
- **UI** : shadcn/ui + Tailwind CSS v4
- **Base de données & Auth** : Supabase (PostgreSQL + Auth)
- **Icônes** : lucide-react
- **Validation** : Zod

## Prérequis

- Node.js 20+
- pnpm 10+
- Docker (pour Supabase local)

## Installation

```bash
# Cloner le projet
git clone <url-du-repo>
cd a-table

# Installer les dépendances
pnpm install

# Copier le fichier d'environnement
cp .env.example .env.local
```

## Configuration

### Variables d'environnement

Éditer `.env.local` avec vos valeurs :

```env
# Supabase (production)
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Supabase (local - décommentez pour le dev local)
# NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
# NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
# SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Développement local avec Supabase

### Démarrer Supabase en local

```bash
# Initialiser Supabase (première fois uniquement)
pnpm supabase:init

# Démarrer les services Supabase
pnpm supabase:start

# Voir le status des services
pnpm supabase:status
```

Une fois démarré, vous aurez accès à :
- **API URL** : http://127.0.0.1:54321
- **Studio** : http://127.0.0.1:54323
- **Inbucket (emails)** : http://127.0.0.1:54324

### Appliquer les migrations

```bash
# Appliquer le schéma de base de données
pnpm supabase:db:reset
```

### Arrêter Supabase

```bash
pnpm supabase:stop
```

## Scripts disponibles

```bash
# Développement
pnpm dev              # Démarrer le serveur de développement (Turbopack)
pnpm build            # Build de production
pnpm start            # Démarrer le serveur de production
pnpm lint             # Lancer ESLint

# Supabase
pnpm supabase:start   # Démarrer Supabase local
pnpm supabase:stop    # Arrêter Supabase local
pnpm supabase:status  # Voir le status des services
pnpm supabase:db:reset # Réinitialiser la base de données
pnpm supabase:db:push  # Pousser les migrations
pnpm supabase:gen:types # Générer les types TypeScript
```

## Structure du projet

```
a-table/
├── app/                    # Routes Next.js (App Router)
│   ├── (auth)/            # Routes d'authentification
│   ├── (main)/            # Routes protégées
│   │   ├── recipes/       # Gestion des recettes
│   │   ├── menu/          # Générateur de menus
│   │   └── admin/         # Panel d'administration
│   └── api/               # Routes API
├── components/
│   ├── layout/            # Composants de mise en page
│   ├── recipes/           # Composants liés aux recettes
│   ├── menu/              # Composants du générateur de menus
│   └── ui/                # Composants shadcn/ui
├── lib/
│   ├── supabase/          # Clients Supabase (browser, server, middleware)
│   └── utils.ts           # Utilitaires
├── types/                 # Types TypeScript
└── supabase/
    ├── config.toml        # Configuration Supabase local
    ├── migrations/        # Migrations SQL
    └── seed.sql           # Données initiales
```

## Base de données

### Tables principales

- **profiles** : Profils utilisateurs (extension de auth.users)
- **categories** : Catégories de recettes
- **tags** : Tags/attributs des recettes
- **recipes** : Recettes
- **recipe_tags** : Relation many-to-many recettes/tags

### Schéma

Le schéma complet est disponible dans `supabase/migrations/`.

## Créer un utilisateur admin

Après avoir créé un compte, exécutez dans Supabase Studio (SQL Editor) :

```sql
UPDATE profiles SET role = 'admin' WHERE email = 'votre@email.com';
```

## Licence

Projet privé - Tous droits réservés
