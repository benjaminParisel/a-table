# Sauvegarde et Restauration de la Base de Données

Ce guide explique comment configurer et utiliser les workflows GitHub Actions pour sauvegarder et restaurer la base de données Supabase du projet "À Table!".

## Table des matières

- [Configuration initiale](#configuration-initiale)
- [Backup automatique](#backup-automatique)
- [Backup manuel](#backup-manuel)
- [Restauration](#restauration)
- [Backup local](#backup-local)
- [Dépannage](#dépannage)

---

## Configuration initiale

### 1. Récupérer l'URL de connexion Supabase

1. Connectez-vous au [Dashboard Supabase](https://supabase.com/dashboard)
2. Sélectionnez votre projet
3. Allez dans **Settings** > **Database**
4. Dans la section **Connection string**, copiez l'URI (mode "URI")

L'URL ressemble à :
```
postgresql://postgres.[PROJECT_REF]:[PASSWORD]@aws-0-eu-west-1.pooler.supabase.com:5432/postgres
```

### 2. Configurer le secret GitHub

1. Allez sur votre repository GitHub
2. **Settings** > **Secrets and variables** > **Actions**
3. Cliquez sur **New repository secret**
4. Configurez :
   - **Name** : `SUPABASE_DB_URL`
   - **Secret** : Collez l'URL de connexion copiée précédemment
5. Cliquez **Add secret**

### 3. (Optionnel) Configurer les environnements de déploiement

Pour ajouter une couche de sécurité sur la restauration :

1. **Settings** > **Environments**
2. Cliquez **New environment**
3. Créez deux environnements :
   - `staging` (pour les tests)
   - `production` (avec protection)
4. Pour `production`, activez :
   - **Required reviewers** : ajoutez-vous comme approbateur
   - Cela empêchera une restauration accidentelle en production

---

## Backup automatique

Le workflow `db-backup.yml` s'exécute automatiquement le **1er jour de chaque mois à 3h00 UTC**.

### Ce qui est sauvegardé

- Structure complète de la base (tables, vues, fonctions, triggers)
- Toutes les données
- Politiques RLS (Row Level Security)

### Rétention

Les backups sont conservés pendant **90 jours** sous forme d'artifacts GitHub.

### Consulter les backups

1. Allez dans l'onglet **Actions** de votre repository
2. Sélectionnez le workflow **Database Backup**
3. Cliquez sur une exécution pour voir les détails
4. La section **Artifacts** contient le fichier de backup

---

## Backup manuel

Vous pouvez déclencher un backup à tout moment :

1. Allez dans **Actions** > **Database Backup**
2. Cliquez sur **Run workflow** (à droite)
3. Sélectionnez la branche `main`
4. Cliquez **Run workflow**

Le backup sera disponible dans les artifacts une fois terminé (généralement 1-2 minutes).

### Télécharger un backup

1. **Actions** > **Database Backup**
2. Cliquez sur l'exécution souhaitée
3. Descendez jusqu'à **Artifacts**
4. Cliquez sur le nom du backup pour le télécharger

Le fichier téléchargé est au format `.sql.gz` (SQL compressé).

---

## Restauration

> **ATTENTION** : La restauration écrase toutes les données existantes. Cette action est irréversible !

### Étapes de restauration

1. Allez dans **Actions** > **Database Restore**
2. Cliquez sur **Run workflow**
3. Remplissez les champs :

| Champ | Description | Exemple |
|-------|-------------|---------|
| **backup_name** | Nom exact de l'artifact | `db-backup-20250101-030000` |
| **target_environment** | Environnement cible | `staging` ou `production` |
| **confirm_restore** | Confirmation de sécurité | Tapez exactement `RESTORE` |

4. Cliquez **Run workflow**

### Trouver le nom du backup

1. Allez dans **Actions** > **Database Backup**
2. Sélectionnez l'exécution du backup souhaité
3. Dans **Artifacts**, notez le nom (ex: `db-backup-20250115-030012`)

### Approbation pour la production

Si vous avez configuré l'environnement `production` avec des reviewers requis :

1. Après avoir lancé le workflow, une demande d'approbation apparaîtra
2. Un reviewer doit approuver avant que la restauration ne s'exécute
3. Cela évite les restaurations accidentelles en production

---

## Backup local

Vous pouvez également créer des backups depuis votre machine locale.

### Prérequis

- PostgreSQL client installé (`psql`, `pg_dump`)
- Accès à l'URL de connexion Supabase

### Commandes

```bash
# Définir l'URL (remplacez par votre URL)
export SUPABASE_DB_URL="postgresql://postgres.[PROJECT_REF]:[PASSWORD]@aws-0-eu-west-1.pooler.supabase.com:5432/postgres"

# Créer un backup complet
pg_dump "$SUPABASE_DB_URL" \
  --clean --if-exists --no-owner --no-privileges \
  -f backup-$(date +%Y%m%d).sql

# Compresser le backup
gzip backup-$(date +%Y%m%d).sql

# Restaurer un backup
gunzip -c backup-20250101.sql.gz | psql "$SUPABASE_DB_URL"
```

### Avec Supabase CLI (environnement local Docker)

```bash
# Backup de la base locale
npx supabase db dump -f supabase/backup.sql

# Backup avec données uniquement
npx supabase db dump -f supabase/backup-data.sql --data-only
```

---

## Dépannage

### Le workflow de backup échoue

**Erreur : "connection refused" ou "authentication failed"**

- Vérifiez que le secret `SUPABASE_DB_URL` est correctement configuré
- Assurez-vous que l'URL contient le bon mot de passe
- Vérifiez que votre projet Supabase est actif (pas en pause)

**Erreur : "permission denied"**

- Utilisez l'utilisateur `postgres` dans l'URL de connexion
- Vérifiez les paramètres de connexion dans Supabase Dashboard

### Le workflow de restauration échoue

**Erreur : "artifact not found"**

- Vérifiez le nom exact de l'artifact (sensible à la casse)
- Les artifacts expirent après 90 jours

**Erreur : "RESTORE confirmation required"**

- Vous devez taper exactement `RESTORE` (en majuscules)

### Projet Supabase en pause

Les projets gratuits sont mis en pause après 7 jours d'inactivité :

1. Allez sur le Dashboard Supabase
2. Cliquez sur **Restore project**
3. Attendez quelques minutes que le projet redémarre
4. Relancez le workflow

---

## Bonnes pratiques

1. **Testez la restauration** régulièrement sur un environnement de staging
2. **Téléchargez** les backups critiques localement (les artifacts GitHub expirent)
3. **Vérifiez** les logs des workflows pour détecter les problèmes
4. **Documentez** les restaurations effectuées (qui, quand, pourquoi)

---

## Ressources

- [Documentation Supabase - Backups](https://supabase.com/docs/guides/platform/backups)
- [Documentation PostgreSQL - pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html)
- [GitHub Actions - Artifacts](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts)
