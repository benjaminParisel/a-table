# Task: Intégration des favoris dans le générateur de menu

## Problem

Les composants de menu favori existent mais ne sont pas intégrés dans la page du générateur de menu. Les utilisateurs ne peuvent pas encore utiliser la fonctionnalité.

## Proposed Solution

Modifier `MenuGenerator` pour :
- Afficher le menu favori existant en haut de la page
- Ajouter le bouton étoile quand un menu est généré
- Gérer l'état pour savoir si le menu généré est le favori

## Dependencies

- Task 7 : Composants FavoriteMenuButton et FavoriteMenuDisplay

## Context

- Fichier à modifier : `components/menu/menu-generator.tsx`
- Le bouton étoile apparaît à côté du titre "Votre menu :"
- Le menu favori s'affiche au-dessus du générateur

## Success Criteria

- Menu favori affiché en haut si existant
- Bouton étoile visible après génération d'un menu
- Étoile pleine si menu généré = menu favori
- Sauvegarde met à jour l'affichage du favori
- Suppression du favori met à jour l'UI
