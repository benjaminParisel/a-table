# Tasks: Recherche par ingrédients + Menu favori

## Overview

Implémentation de deux fonctionnalités pour l'application "À Table!" :
1. **Recherche par ingrédients** : Trouver des recettes basées sur les ingrédients disponibles
2. **Menu favori** : Sauvegarder un menu généré comme favori (1 par utilisateur)

## Task List

### Infrastructure
- [ ] **Task 1**: Migration BDD favorite_menus - `task-01.md`
- [ ] **Task 2**: Types TypeScript - `task-02.md`

### APIs Backend
- [ ] **Task 3**: API recherche par ingrédients - `task-03.md` (dépend de Task 2)
- [ ] **Task 4**: API menu favori CRUD - `task-04.md` (dépend de Tasks 1, 2)

### Composants UI
- [ ] **Task 5**: Composant ChipInput - `task-05.md`
- [ ] **Task 6**: Page recherche par ingrédients - `task-06.md` (dépend de Tasks 3, 5)
- [ ] **Task 7**: Composants menu favori - `task-07.md` (dépend de Task 4)

### Intégration
- [ ] **Task 8**: Intégration dans MenuGenerator - `task-08.md` (dépend de Task 7)
- [ ] **Task 9**: Lien navigation - `task-09.md` (dépend de Task 6)

## Dependency Graph

```
Task 1 (BDD) ─────────────────┐
                              ├──► Task 4 (API favori) ──► Task 7 (UI favori) ──► Task 8 (Intégration)
Task 2 (Types) ──┬────────────┘
                 │
                 └──► Task 3 (API search) ──┐
                                            ├──► Task 6 (Page search) ──► Task 9 (Nav)
Task 5 (ChipInput) ─────────────────────────┘
```

## Execution Order

### Phase 1 - Parallélisable
Peuvent être faites en parallèle :
- Task 1 : Migration base de données
- Task 2 : Types TypeScript
- Task 5 : Composant ChipInput

### Phase 2 - APIs
Après Phase 1 :
- Task 3 : API recherche (après Task 2)
- Task 4 : API favori (après Tasks 1 + 2)

### Phase 3 - UI
Après Phase 2 :
- Task 6 : Page recherche (après Tasks 3 + 5)
- Task 7 : Composants favori (après Task 4)

### Phase 4 - Finalisation
Après Phase 3 :
- Task 8 : Intégration MenuGenerator (après Task 7)
- Task 9 : Lien navigation (après Task 6)

## Estimated Effort

| Task | Complexité | Temps estimé |
|------|------------|--------------|
| 1    | Simple     | ~15 min      |
| 2    | Simple     | ~10 min      |
| 3    | Moyenne    | ~30 min      |
| 4    | Moyenne    | ~30 min      |
| 5    | Simple     | ~20 min      |
| 6    | Moyenne    | ~30 min      |
| 7    | Moyenne    | ~30 min      |
| 8    | Simple     | ~20 min      |
| 9    | Simple     | ~10 min      |

**Total estimé** : ~3h de travail

## Quick Start

Pour commencer l'implémentation :
```bash
# Exécuter les tâches dans l'ordre
/epct:code .claude/tasks/01-identify-missing-features
```

Ou exécuter tâche par tâche manuellement en suivant l'ordre des phases.
