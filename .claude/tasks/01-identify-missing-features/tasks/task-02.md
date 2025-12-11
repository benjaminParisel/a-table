# Task: Ajouter les types TypeScript pour les nouvelles fonctionnalités

## Problem

Les nouvelles fonctionnalités (menu favori et recherche par ingrédients) nécessitent des types TypeScript pour assurer la cohérence et la sécurité du typage dans toute l'application.

## Proposed Solution

Étendre `types/index.ts` avec :
- Interface `FavoriteMenu` pour la table favorite_menus
- Interface `IngredientSearchResult` pour les résultats de recherche par ingrédients

## Dependencies

- Aucune (peut être fait en parallèle avec Task 1)

## Context

- Fichier de types existant : `types/index.ts`
- Pattern à suivre : les interfaces existantes (`Recipe`, `RecipeWithRelations`, etc.)
- Les recettes utilisent `RecipeWithRelations` qui inclut category, tags, author

## Success Criteria

- Types `FavoriteMenu` et `IngredientSearchResult` exportés
- TypeScript compile sans erreur
- Types correspondent à la structure de la base de données (Task 1)
