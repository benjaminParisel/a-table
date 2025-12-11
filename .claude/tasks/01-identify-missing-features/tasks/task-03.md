# Task: API de recherche par ingrédients

## Problem

Les utilisateurs veulent trouver des recettes basées sur les ingrédients qu'ils ont sous la main. Actuellement, la recherche ne permet que de chercher par titre/description.

## Proposed Solution

Créer un endpoint POST `/api/recipes/search-by-ingredients` qui :
- Accepte une liste d'ingrédients
- Filtre les recettes contenant TOUS les ingrédients demandés
- Supporte le matching partiel et insensible à la casse/accents
- Retourne les recettes triées par simplicité (moins d'ingrédients = plus simple)

## Dependencies

- Task 2 : Types TypeScript (pour `IngredientSearchResult`)

## Context

- Pattern API existant : `app/api/recipes/route.ts`, `app/api/menu/generate/route.ts`
- Les ingrédients sont stockés en texte brut séparé par `\n` dans `recipes.ingredients`
- Validation Zod utilisée dans les autres routes
- Normalisation des accents : `string.normalize("NFD").replace(/[\u0300-\u036f]/g, "")`

## Success Criteria

- Endpoint retourne les recettes contenant TOUS les ingrédients
- "poulet" match "escalope de poulet", "filet de poulet"
- "été" match "ete" (insensible aux accents)
- Recettes triées par nombre d'ingrédients croissant
- Retourne 401 si non authentifié
- Retourne array vide si aucune recette ne match
