# Déploiement de À Table! sur Vercel

## Prérequis

- Un compte [Vercel](https://vercel.com) (gratuit)
- Un compte [Supabase](https://supabase.com) avec un projet en production
- Le code source hébergé sur GitHub, GitLab ou Bitbucket

---

## Étape 1 : Préparer Supabase en production

### 1.1 Créer un projet Supabase

1. Connecte-toi sur [supabase.com](https://supabase.com)
2. Clique sur **New Project**
3. Choisis un nom et une région (proche de tes utilisateurs)
4. Note le **mot de passe de la base de données** (tu en auras besoin plus tard)

### 1.2 Appliquer le schéma de base de données

Dans le **SQL Editor** de Supabase, exécute le contenu de `supabase/schema.sql` pour créer les tables.

### 1.3 Récupérer les clés API

Dans **Settings > API**, note :
- **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
- **anon public** → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- **service_role** → `SUPABASE_SERVICE_ROLE_KEY` (garder secrète !)

### 1.4 Configurer le stockage (si utilisé)

1. Va dans **Storage** et crée les buckets nécessaires
2. Configure les policies RLS pour autoriser les uploads

---

## Étape 2 : Préparer le dépôt Git

### 2.1 Pousser le code sur GitHub

```bash
# Si ce n'est pas déjà fait
git remote add origin https://github.com/ton-username/a-table.git
git push -u origin main
```

### 2.2 Vérifier les fichiers ignorés

Assure-toi que `.env.local` est dans `.gitignore` (ne jamais commiter les secrets !).

---

## Étape 3 : Déployer sur Vercel

### 3.1 Importer le projet

1. Va sur [vercel.com/new](https://vercel.com/new)
2. Clique sur **Import Git Repository**
3. Autorise l'accès à ton dépôt GitHub
4. Sélectionne le repository `a-table`

### 3.2 Configurer le projet

Vercel détecte automatiquement Next.js. Vérifie ces paramètres :

| Paramètre | Valeur |
|-----------|--------|
| Framework Preset | Next.js |
| Root Directory | `.` |
| Build Command | `pnpm build` |
| Output Directory | `.next` |
| Install Command | `pnpm install` |

### 3.3 Ajouter les variables d'environnement

Dans la section **Environment Variables**, ajoute :

```
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR...
NEXT_PUBLIC_APP_URL=https://ton-app.vercel.app
```

> **Important** : `NEXT_PUBLIC_APP_URL` sera l'URL finale de ton app. Tu pourras la modifier après le premier déploiement.

### 3.4 Déployer

Clique sur **Deploy** et attends que le build se termine (environ 1-2 minutes).

---

## Étape 4 : Configuration post-déploiement

### 4.1 Mettre à jour l'URL de l'application

Une fois déployé, Vercel te donne une URL (ex: `a-table-xxx.vercel.app`).

1. Retourne dans **Settings > Environment Variables**
2. Modifie `NEXT_PUBLIC_APP_URL` avec la vraie URL
3. Redéploie via **Deployments > ... > Redeploy**

### 4.2 Configurer Supabase pour l'authentification

Dans Supabase **Authentication > URL Configuration** :

1. **Site URL** : `https://ton-app.vercel.app`
2. **Redirect URLs** : ajoute `https://ton-app.vercel.app/**`

### 4.3 (Optionnel) Configurer un domaine personnalisé

Dans Vercel **Settings > Domains** :
1. Ajoute ton domaine (ex: `atable.fr`)
2. Configure les DNS chez ton registrar selon les instructions

---

## Déploiements automatiques

Une fois configuré, chaque push sur `main` déclenche automatiquement un nouveau déploiement. Les pull requests créent des **Preview Deployments** pour tester avant de merger.

---

## Commandes utiles

```bash
# Installer la CLI Vercel
pnpm add -g vercel

# Déployer en preview depuis le terminal
vercel

# Déployer en production
vercel --prod

# Voir les logs en temps réel
vercel logs https://ton-app.vercel.app
```

---

## Résolution de problèmes

### Le build échoue

```bash
# Teste le build localement d'abord
pnpm build
```

Vérifie les erreurs TypeScript ou de lint.

### Erreurs Supabase en production

- Vérifie que les variables d'environnement sont correctes
- Assure-toi que les policies RLS sont configurées
- Vérifie les logs dans Supabase **Database > Logs**

### Les images ne s'affichent pas

Le `next.config.ts` autorise déjà les images de `*.supabase.co`. Si tu utilises d'autres sources, ajoute-les dans `remotePatterns`.

---

## Coûts estimés

| Service | Plan Gratuit | Limites |
|---------|--------------|---------|
| Vercel | Hobby (gratuit) | 100 GB bande passante/mois |
| Supabase | Free | 500 MB DB, 1 GB stockage, 50k utilisateurs |

Pour une app familiale, les plans gratuits sont généralement suffisants.
