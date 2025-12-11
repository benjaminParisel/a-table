# Task: Migration base de données pour les menus favoris

## Problem

L'application n'a pas de moyen de persister les menus favoris des utilisateurs. On a besoin d'une table pour stocker un menu favori par utilisateur, avec les IDs des recettes qui composent ce menu.

## Proposed Solution

Créer une migration SQL qui ajoute la table `favorite_menus` avec :
- Contrainte UNIQUE sur `user_id` (1 seul favori par utilisateur)
- Tableau d'UUIDs pour les `recipe_ids`
- Policies RLS pour que chaque utilisateur ne puisse gérer que son propre menu

## Dependencies

- Aucune (peut commencer immédiatement)

## Context

- Pattern de migration existant : `supabase/schema.sql`
- RLS policies similaires sur la table `recipes`
- La table `profiles` existe déjà avec `id` comme clé primaire

## Success Criteria

- Table `favorite_menus` créée avec structure correcte
- RLS activé avec policy appropriée
- Contrainte UNIQUE sur `user_id` fonctionne (test d'insertion double échoue)
