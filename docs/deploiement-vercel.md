# Déploiement de À Table! sur Vercel

## Prérequis

- Un compte [Vercel](https://vercel.com) (gratuit)
- Un compte [Supabase](https://supabase.com) (gratuit)
- Le code source hébergé sur GitHub
- Node.js 18+ et pnpm installés localement

---

## Checklist rapide

- [ ] Créer un projet Supabase en production
- [ ] Appliquer le schéma de base de données
- [ ] Configurer le storage pour les images
- [ ] Pousser le code sur GitHub
- [ ] Importer le projet sur Vercel
- [ ] Configurer les variables d'environnement
- [ ] Configurer l'authentification Supabase
- [ ] Tester le déploiement

---

## Étape 1 : Créer un projet Supabase

### 1.1 Créer le projet

1. Connecte-toi sur [supabase.com](https://supabase.com)
2. Clique sur **New Project**
3. Choisis :
   - **Nom** : `a-table` (ou autre)
   - **Région** : `West EU (Paris)` pour la France
   - **Mot de passe** : génère-en un fort et note-le
4. Attends ~2 minutes que le projet soit provisionné

### 1.2 Récupérer les clés API

Dans **Project Settings > API**, note ces valeurs :

| Clé | Variable d'environnement |
|-----|--------------------------|
| Project URL | `NEXT_PUBLIC_SUPABASE_URL` |
| anon public | `NEXT_PUBLIC_SUPABASE_ANON_KEY` |
| service_role | `SUPABASE_SERVICE_ROLE_KEY` |

> **Important** : La clé `service_role` est secrète, ne jamais l'exposer côté client !

---

## Étape 2 : Appliquer le schéma de base de données

Tu as deux options : manuelle (simple) ou via CLI (recommandée).

### Option A : Via l'éditeur SQL (simple)

1. Va dans **SQL Editor** dans Supabase
2. Exécute les fichiers dans cet ordre :

```
supabase/migrations/000_20231210000000_initial_schema.sql  # Tables principales
supabase/migrations/001_20231210000001_storage.sql         # Configuration storage
supabase/migrations/002_favorite_menu.sql                  # Menus favoris
supabase/migrations/003_revert_anon_read.sql               # Sécurité RLS
supabase/migrations/004_favorite_recipes.sql               # Recettes favorites
supabase/migrations/005_profile_settings.sql               # Paramètres profil
supabase/migrations/006_table_grants.sql                   # Permissions GRANT
```

3. Ensuite, exécute `supabase/storage.sql` pour configurer le bucket d'images

### Option B : Via Supabase CLI (recommandée)

Cette méthode permet de gérer les migrations de façon versionnée.

```bash
# 1. Installer la CLI Supabase (si pas déjà fait)
pnpm add -g supabase

# 2. Se connecter à Supabase
npx supabase login

# 3. Lier le projet local au projet distant
npx supabase link --project-ref <project-id>
# Le project-id se trouve dans Project Settings > General

# 4. Pousser les migrations vers la production
npx supabase db push

# 5. Appliquer la configuration du storage
# (à faire manuellement dans SQL Editor car non géré par les migrations)
```

Contenu de `supabase/storage.sql` à exécuter :

```sql
-- Créer le bucket pour les images de recettes
INSERT INTO storage.buckets (id, name, public)
VALUES ('recipe-images', 'recipe-images', true)
ON CONFLICT (id) DO NOTHING;

-- Policies pour le storage
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'recipe-images');

CREATE POLICY "Authenticated users can update images"
ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id = 'recipe-images');

CREATE POLICY "Authenticated users can delete images"
ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'recipe-images');

CREATE POLICY "Public read access for recipe images"
ON storage.objects FOR SELECT TO public
USING (bucket_id = 'recipe-images');
```

---

## Étape 3 : Pousser le code sur GitHub

### 3.1 Créer le repository

```bash
# Si ce n'est pas déjà fait
git remote add origin https://github.com/ton-username/a-table.git
git push -u origin main
```

### 3.2 Vérifier les fichiers ignorés

Assure-toi que `.gitignore` contient :

```
.env
.env.local
.env*.local
```

> Ne jamais commiter les secrets !

---

## Étape 4 : Déployer sur Vercel

### 4.1 Importer le projet

1. Va sur [vercel.com/new](https://vercel.com/new)
2. Clique sur **Import Git Repository**
3. Autorise l'accès à ton compte GitHub
4. Sélectionne le repository `a-table`

### 4.2 Configurer le projet

Vercel détecte automatiquement Next.js. Vérifie ces paramètres :

| Paramètre | Valeur |
|-----------|--------|
| Framework Preset | Next.js |
| Root Directory | `.` |
| Build Command | `pnpm build` |
| Install Command | `pnpm install` |

### 4.3 Ajouter les variables d'environnement

Dans la section **Environment Variables**, ajoute :

| Variable | Valeur |
|----------|--------|
| `NEXT_PUBLIC_SUPABASE_URL` | `https://xxxxx.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `eyJhbGciOiJIUzI1NiIsInR...` |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhbGciOiJIUzI1NiIsInR...` |
| `NEXT_PUBLIC_APP_URL` | `https://a-table.vercel.app` |

> **Note** : `NEXT_PUBLIC_APP_URL` sera l'URL finale. Tu pourras la modifier après le premier déploiement.

### 4.4 Déployer

Clique sur **Deploy** et attends ~2 minutes.

---

## Étape 5 : Configuration post-déploiement

### 5.1 Mettre à jour l'URL de l'application

Une fois déployé, Vercel te donne une URL (ex: `a-table-xxx.vercel.app`).

1. Retourne dans Vercel **Settings > Environment Variables**
2. Modifie `NEXT_PUBLIC_APP_URL` avec la vraie URL
3. Redéploie via **Deployments > ... > Redeploy**

### 5.2 Configurer Supabase pour l'authentification

Dans Supabase **Authentication > URL Configuration** :

| Paramètre | Valeur |
|-----------|--------|
| Site URL | `https://ton-app.vercel.app` |
| Redirect URLs | `https://ton-app.vercel.app/**` |

### 5.3 (Optionnel) Configurer un domaine personnalisé

**Sur Vercel** (Settings > Domains) :
1. Ajoute ton domaine (ex: `atable.fr`)
2. Configure les DNS chez ton registrar

**Sur Supabase** : Mets à jour les URLs de redirection avec ton domaine.

---

## Déploiements automatiques

Une fois configuré :
- Chaque **push sur `main`** déclenche un déploiement en production
- Chaque **Pull Request** crée un Preview Deployment pour tester

---

## Commandes utiles

```bash
# Tester le build localement avant de pousser
pnpm build

# Installer la CLI Vercel
pnpm add -g vercel

# Déployer en preview depuis le terminal
vercel

# Déployer en production
vercel --prod

# Voir les logs en temps réel
vercel logs https://ton-app.vercel.app

# Supabase : voir le statut des migrations
npx supabase migration list --linked
```

---

## Résolution de problèmes

### Le build échoue

```bash
# Teste localement d'abord
pnpm build
pnpm lint
```

Erreurs fréquentes :
- Types TypeScript manquants
- Imports non résolus
- Variables d'environnement manquantes

### Erreurs Supabase en production

1. **Vérifie les variables d'environnement** dans Vercel
2. **Vérifie les policies RLS** - les tables doivent avoir des policies pour permettre l'accès
3. **Consulte les logs** dans Supabase > Database > Logs

### Les images ne s'affichent pas

1. Vérifie que le bucket `recipe-images` existe dans Storage
2. Vérifie que les policies sont appliquées
3. Le `next.config.ts` autorise déjà `*.supabase.co`

### Erreur "Invalid API key"

- Vérifie que tu utilises les clés de **production** (pas celles de développement local)
- Les clés locales commencent par `eyJ...` avec `supabase-demo`
- Les clés prod ont un format différent

---

## Gestion des migrations futures

Quand tu modifies le schéma en local :

```bash
# 1. Créer une nouvelle migration
npx supabase migration new nom_de_la_migration

# 2. Éditer le fichier créé dans supabase/migrations/

# 3. Tester localement
npx supabase db reset

# 4. Pousser en production
npx supabase db push
```

---

## Backup de la base de données

Voir le guide dédié : [database-backup.md](./database-backup.md)

---

## Coûts estimés (plans gratuits)

| Service | Plan | Limites |
|---------|------|---------|
| **Vercel** | Hobby (gratuit) | 100 GB bande passante/mois, builds illimités |
| **Supabase** | Free | 500 MB DB, 1 GB storage, 50k auth users, 500k edge function invocations |

Pour une app familiale, les plans gratuits sont largement suffisants.

---

## Liens utiles

- [Documentation Vercel](https://vercel.com/docs)
- [Documentation Supabase](https://supabase.com/docs)
- [Guide Next.js sur Vercel](https://vercel.com/docs/frameworks/nextjs)
- [Supabase CLI](https://supabase.com/docs/guides/cli)
