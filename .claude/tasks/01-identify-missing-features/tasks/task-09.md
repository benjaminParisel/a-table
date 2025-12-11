# Task: Ajouter le lien de navigation vers la recherche par ingrédients

## Problem

La nouvelle page de recherche par ingrédients n'est pas accessible depuis la navigation principale. Les utilisateurs ne peuvent pas la découvrir facilement.

## Proposed Solution

Ajouter un lien vers `/search-ingredients` dans la navbar, après le lien "Menu" existant.

## Dependencies

- Task 6 : Page de recherche par ingrédients (pour que le lien fonctionne)

## Context

- Fichier à modifier : `components/navbar.tsx`
- Observer le pattern des liens existants
- Libellé suggéré : "Par ingrédients" ou avec icône Search

## Success Criteria

- Lien visible dans la navigation
- Clic navigue vers `/search-ingredients`
- Style cohérent avec les autres liens de navigation
- Lien actif visuellement quand sur la page
