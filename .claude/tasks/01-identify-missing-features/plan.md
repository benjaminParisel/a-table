# Implementation Plan: Recherche par ingrédients + Menu favori

## Overview

Implémentation de deux fonctionnalités complémentaires :
1. **Recherche par ingrédients** : Permettre aux utilisateurs de saisir les ingrédients qu'ils ont (via chips interactifs) et trouver les recettes qui les utilisent TOUS
2. **Menu favori** : Permettre de sauvegarder UN menu généré par utilisateur (bouton étoile)

## Dependencies

- Système d'authentification existant (Supabase Auth)
- Table `recipes` avec champ `ingredients` (texte brut, séparé par `\n`)
- Composant `MenuGenerator` existant
- Types TypeScript existants (`types/index.ts`)

---

## File Changes

### 1. `supabase/migrations/001_favorite_menu.sql` (NOUVEAU)

- Créer la table `favorite_menus` pour stocker le menu favori par utilisateur
- Structure : `id`, `user_id` (FK profiles, UNIQUE), `recipe_ids` (UUID[]), `created_at`, `updated_at`
- Activer RLS avec policy "Users can manage own favorite menu"
- Contrainte UNIQUE sur `user_id` (1 seul menu favori par utilisateur)

### 2. `types/index.ts`

- Ajouter interface `FavoriteMenu` : `{ id, user_id, recipe_ids: string[], created_at, updated_at }`
- Ajouter interface `IngredientSearchResult` : `{ recipe: R
ecipeWithRelations, matchedIngredients: string[], matchCount: number }`

### 3. `app/api/recipes/search-by-ingredients/route.ts` (NOUVEAU)

- Endpoint POST pour rechercher des recettes par ingrédients
- Validation Zod : `{ ingredients: string[] }` (min 1 ingrédient)
- Récupérer toutes les recettes avec leurs ingrédients
- Filtrer côté serveur : garder uniquement les recettes contenant TOUS les ingrédients saisis
- Matching insensible à la casse et aux accents (normalisation)
- Matching partiel : "poulet" match "escalope de poulet", "filet de poulet", etc.
- Retourner les recettes triées par pertinence (nombre total d'ingrédients croissant = recette plus simple)
- Inclure dans la réponse les ingrédients matchés pour mise en évidence UI

### 4. `components/search/ingredient-search.tsx` (NOUVEAU)

- Composant client avec interface chips/tags
- État : `inputValue` (string), `selectedIngredients` (string[]), `results` (RecipeWithRelations[]), `loading`, `error`
- Input avec placeholder "Ajouter un ingrédient..."
- Gestion Enter/virgule pour ajouter un chip
- Chips affichés avec bouton X pour supprimer
- Bouton "Rechercher" qui appelle l'API
- Affichage des résultats sous forme de grille de RecipeCard
- Message si aucun résultat : "Aucune recette ne contient tous ces ingrédients"
- Pattern à suivre : `components/menu/menu-generator.tsx` pour la structure

### 5. `app/(main)/search-ingredients/page.tsx` (NOUVEAU)

- Page server component pour la route `/search-ingredients`
- Titre : "Qu'est-ce que je peux cuisiner ?"
- Description : "Entrez les ingrédients que vous avez et découvrez les recettes possibles"
- Rendre le composant `IngredientSearch`

### 6. `components/ui/chip-input.tsx` (NOUVEAU)

- Composant réutilisable pour saisie de chips/tags
- Props : `value: string[]`, `onChange: (values: string[]) => void`, `placeholder`
- Input avec gestion Enter/virgule
- Affichage des chips avec Badge + bouton X
- Style cohérent avec shadcn/ui

### 7. `app/api/menu/favorite/route.ts` (NOUVEAU)

- GET : Récupérer le menu favori de l'utilisateur connecté (avec les recettes enrichies)
- POST : Sauvegarder/remplacer le menu favori (body: `{ recipe_ids: string[] }`)
- DELETE : Supprimer le menu favori
- Vérifier que toutes les recipe_ids existent avant sauvegarde

### 8. `components/menu/favorite-menu-button.tsx` (NOUVEAU)

- Composant client : bouton étoile pour sauvegarder le menu généré
- Props : `recipeIds: string[]`, `onSaved?: () => void`
- État : `isFavorited` (boolean), `isLoading`
- Au clic : POST vers `/api/menu/favorite`
- Icône étoile pleine si menu actuel = menu favori, vide sinon
- Toast de confirmation : "Menu sauvegardé !" ou "Menu favori mis à jour !"

### 9. `components/menu/favorite-menu-display.tsx` (NOUVEAU)

- Composant client pour afficher le menu favori sauvegardé
- Récupère le menu favori via GET `/api/menu/favorite` au montage
- Si pas de favori : ne rien afficher
- Si favori existe : afficher une section "Mon menu favori" avec les RecipeCard
- Bouton pour supprimer le favori (icône corbeille)
- Style : section séparée visuellement (Card ou border)

### 10. `components/menu/menu-generator.tsx`

- Importer et ajouter `FavoriteMenuButton` après le titre "Votre menu :"
- Passer les IDs des recettes générées au bouton
- Ajouter `FavoriteMenuDisplay` en haut du composant pour afficher le menu favori existant
- Ajouter un état pour suivre si le menu généré actuel est le favori

### 11. `components/navbar.tsx`

- Ajouter un lien vers `/search-ingredients` dans la navigation
- Libellé : "Par ingrédients" ou icône Search avec tooltip
- Placer après le lien "Menu" existant

---

## Testing Strategy

### Tests manuels à effectuer

1. **Recherche par ingrédients**
   - Taper "poulet" + Enter → chip apparaît
   - Ajouter "tomate" → deux chips
   - Cliquer X sur un chip → le supprime
   - Rechercher avec "poulet, tomate" → recettes contenant LES DEUX
   - Rechercher avec ingrédient inexistant → message "aucune recette"
   - Rechercher avec "canard" → recettes de canard apparaissent

2. **Menu favori**
   - Générer un menu → bouton étoile apparaît
   - Cliquer étoile → toast "Menu sauvegardé"
   - Régénérer un menu → l'étoile est vide (nouveau menu)
   - Recharger la page → le menu favori est affiché
   - Supprimer le favori → la section disparaît
   - Utilisateur non connecté → fonctionnalité cachée ou message

### Validation technique

- Vérifier les policies RLS sur `favorite_menus`
- Tester le matching d'ingrédients avec accents (é, è, à)
- Tester le matching partiel ("poulet" dans "escalope de poulet")
- Vérifier qu'un seul menu favori par utilisateur (UNIQUE constraint)

---

## Documentation

- Mettre à jour la section "Fonctionnalités" du README si existant
- Les pages sont auto-documentées via leur titre et description

---

## Rollout Considerations

### Base de données

- La migration doit être exécutée : `npx supabase db push` ou via dashboard
- Pas de données à migrer (nouvelle table)

### Breaking Changes

- Aucun breaking change - ajout de fonctionnalités uniquement

### Performance

- La recherche par ingrédients charge toutes les recettes puis filtre côté serveur
- Si la base grandit (>1000 recettes), envisager une fonction PostgreSQL ou recherche FTS dédiée
- Le menu favori est une requête simple avec JOIN sur recipes

---

## Ordre d'implémentation recommandé

1. Migration base de données (`favorite_menus`)
2. Types TypeScript
3. API routes (search-by-ingredients, menu/favorite)
4. Composants UI (chip-input, ingredient-search, favorite-menu-button, favorite-menu-display)
5. Pages (search-ingredients)
6. Intégration dans menu-generator
7. Lien dans navbar
