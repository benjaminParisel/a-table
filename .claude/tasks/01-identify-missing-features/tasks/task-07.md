# Task: Composants UI pour le menu favori

## Problem

On doit permettre aux utilisateurs de sauvegarder un menu généré comme favori et de voir leur menu favori existant. Cela nécessite deux composants : un bouton de sauvegarde et un affichage du favori.

## Proposed Solution

Créer deux composants :
1. `FavoriteMenuButton` : bouton étoile pour sauvegarder le menu actuel
2. `FavoriteMenuDisplay` : affiche le menu favori existant avec option de suppression

## Dependencies

- Task 4 : API menu favori (GET, POST, DELETE)

## Context

- Pattern de composant client : `components/menu/menu-generator.tsx`
- Utiliser `Star` de Lucide pour l'icône (pleine si favori, vide sinon)
- Toast via `sonner` pour les confirmations
- Utiliser `RecipeCard` pour afficher les recettes du favori

## Success Criteria

- `FavoriteMenuButton` :
  - Affiche étoile pleine si menu actuel = favori, vide sinon
  - Clic sauvegarde le menu, affiche toast de confirmation
- `FavoriteMenuDisplay` :
  - Affiche "Mon menu favori" avec les recettes si existant
  - Bouton corbeille pour supprimer le favori
  - Ne rien afficher si pas de favori
