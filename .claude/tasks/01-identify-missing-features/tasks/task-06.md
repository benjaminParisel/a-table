# Task: Composant et page de recherche par ingrédients

## Problem

Les utilisateurs n'ont pas d'interface pour rechercher des recettes par ingrédients disponibles. On doit créer la page et le composant principal.

## Proposed Solution

Créer :
1. Page `/search-ingredients` avec titre et description
2. Composant `IngredientSearch` qui utilise `ChipInput` et appelle l'API

## Dependencies

- Task 3 : API de recherche par ingrédients
- Task 5 : Composant ChipInput

## Context

- Pattern de page : `app/(main)/menu/page.tsx`
- Pattern de composant client : `components/menu/menu-generator.tsx`
- Utiliser `RecipeCard` pour afficher les résultats
- États à gérer : ingrédients sélectionnés, résultats, loading, error

## Success Criteria

- Page accessible à `/search-ingredients`
- Titre "Qu'est-ce que je peux cuisiner ?"
- Utilisateur peut ajouter/retirer des ingrédients via chips
- Bouton "Rechercher" appelle l'API
- Résultats affichés en grille de RecipeCard
- Message approprié si aucun résultat
- États de chargement et d'erreur gérés
