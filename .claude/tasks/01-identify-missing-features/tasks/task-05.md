# Task: Composant ChipInput réutilisable

## Problem

On a besoin d'un composant UI pour saisir plusieurs éléments sous forme de chips/tags (utilisé pour la recherche par ingrédients, potentiellement réutilisable ailleurs).

## Proposed Solution

Créer un composant `ChipInput` dans `components/ui/` qui :
- Affiche un champ de saisie
- Ajoute un chip quand l'utilisateur appuie sur Enter ou virgule
- Permet de supprimer chaque chip via un bouton X
- Expose `value` et `onChange` comme une input contrôlée

## Dependencies

- Aucune (composant UI indépendant)

## Context

- Composants UI existants : `components/ui/` (shadcn/ui)
- Utiliser `Badge` de shadcn/ui pour le style des chips
- Icône X de Lucide React pour le bouton de suppression
- Pattern à suivre : composants shadcn/ui existants pour le style

## Success Criteria

- Composant accepte `value: string[]` et `onChange`
- Enter et virgule ajoutent un nouveau chip (si non vide)
- Clic sur X supprime le chip correspondant
- Style cohérent avec shadcn/ui
- Supporte un placeholder personnalisable
