# Task: API pour le menu favori (CRUD)

## Problem

On doit permettre aux utilisateurs de sauvegarder, récupérer et supprimer leur menu favori. Le backend doit gérer ces opérations avec la table `favorite_menus`.

## Proposed Solution

Créer un endpoint `/api/menu/favorite` avec :
- GET : Récupérer le menu favori avec les recettes enrichies
- POST : Sauvegarder/remplacer le menu favori (upsert)
- DELETE : Supprimer le menu favori

## Dependencies

- Task 1 : Migration base de données (table `favorite_menus`)
- Task 2 : Types TypeScript (`FavoriteMenu`)

## Context

- Pattern API existant : `app/api/menu/generate/route.ts`
- Utiliser upsert pour gérer le remplacement (contrainte UNIQUE)
- Enrichir les recettes avec relations comme dans `/api/menu/generate`

## Success Criteria

- GET retourne le menu favori avec recettes complètes (category, tags)
- GET retourne null/404 si pas de favori
- POST crée ou remplace le menu favori
- POST valide que toutes les recipe_ids existent
- DELETE supprime le menu favori
- Toutes les routes retournent 401 si non authentifié
