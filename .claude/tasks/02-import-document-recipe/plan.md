# Implementation Plan: Import de documents pour préremplir les recettes

## Overview

Ajouter une fonctionnalité d'import de documents (PDF, DOC, DOCX) sur la page de création de recette. Le document est envoyé à une API qui extrait le texte, puis utilise Google Gemini pour structurer les données en format recette. Les champs du formulaire sont ensuite préremplis avec les données extraites.

## Dependencies

Ordre d'implémentation (les fichiers dépendent des précédents):

1. **Installation des packages** (prérequis)
2. **Types** → définir `ExtractedRecipe`
3. **Parsers** → pdf.ts, word.ts (indépendants)
4. **Extraction Gemini** → extract-recipe.ts (dépend des parsers)
5. **API Route** → route.ts (dépend de tout le lib/parsers)
6. **Composant UI** → document-import.tsx (dépend de l'API)
7. **Intégration** → modifier recipe-form.tsx et page.tsx

## File Changes

### 1. Installation des dépendances

```bash
pnpm add pdf-parse word-extractor @google/generative-ai
pnpm add -D @types/pdf-parse
```

### 2. `.env.local`

- Ajouter la variable `GEMINI_API_KEY`
- Documenter dans `.env.example` si existant

---

### 3. `types/index.ts`

- Ajouter l'interface `ExtractedRecipe` après l'interface `Recipe` (ligne ~43)
- Champs: title (string), description (string | null), ingredients (string), instructions (string), prep_time (number | null), cook_time (number | null), servings (number | null)
- Cette interface sera utilisée par l'API et le composant d'import

---

### 4. `lib/parsers/pdf.ts` (nouveau fichier)

- Créer fonction `parsePdf(buffer: Buffer): Promise<string>`
- Utiliser `pdf-parse` pour extraire le texte
- Retourner le texte brut du document
- Gérer les erreurs de parsing avec message explicite

---

### 5. `lib/parsers/word.ts` (nouveau fichier)

- Créer fonction `parseWord(buffer: Buffer): Promise<string>`
- Utiliser `word-extractor` pour extraire le texte (supporte .doc et .docx)
- Instancier WordExtractor, appeler extract(buffer), puis getBody()
- Retourner le texte brut du document
- Gérer les erreurs de parsing avec message explicite

---

### 6. `lib/parsers/extract-recipe.ts` (nouveau fichier)

- Importer GoogleGenerativeAI depuis @google/generative-ai
- Créer fonction `extractRecipeFromText(text: string): Promise<ExtractedRecipe>`
- Configurer le modèle Gemini avec `gemini-1.5-flash`
- Construire le prompt demandant l'extraction en JSON avec les champs:
  - title, description, ingredients, instructions, prep_time, cook_time, servings
- Parser la réponse JSON
- Valider la structure avec un schéma Zod basique
- Gérer le cas où Gemini retourne du texte non-JSON (extraire le JSON du texte)
- Retourner les données extraites typées

---

### 7. `lib/parsers/index.ts` (nouveau fichier)

- Exporter les fonctions des autres fichiers du dossier
- Créer fonction utilitaire `extractTextFromDocument(buffer: Buffer, mimeType: string): Promise<string>`
- Router vers parsePdf ou parseWord selon le mimeType
- Types MIME supportés:
  - `application/pdf` → parsePdf
  - `application/msword` → parseWord (.doc)
  - `application/vnd.openxmlformats-officedocument.wordprocessingml.document` → parseWord (.docx)

---

### 8. `app/api/recipes/import/route.ts` (nouveau fichier)

- Créer handler POST
- Récupérer le fichier depuis formData
- Valider avec Zod:
  - Taille max 10MB
  - Types MIME acceptés (PDF, DOC, DOCX)
- Convertir File en Buffer via arrayBuffer()
- Appeler extractTextFromDocument avec le buffer et le mimeType
- Appeler extractRecipeFromText avec le texte extrait
- Retourner NextResponse.json avec { success: true, data: ExtractedRecipe }
- Gérer les erreurs:
  - 400 si fichier invalide
  - 500 si erreur de parsing ou extraction
  - Messages d'erreur en français

---

### 9. `components/recipes/document-import.tsx` (nouveau fichier)

- Créer composant client ("use client")
- Props: `onImport: (data: ExtractedRecipe) => void`, `disabled?: boolean`
- État local: isImporting (boolean), error (string | null)
- Utiliser useRef pour l'input file (pattern de image-upload.tsx)
- Interface:
  - Zone cliquable avec bordure en pointillés (style similaire à image-upload.tsx)
  - Icône FileUp de lucide-react
  - Texte "Importer un document" + formats acceptés
  - État de chargement avec Loader2 et texte "Analyse en cours..."
- Comportement:
  - Au clic, ouvrir le sélecteur de fichiers
  - Accepter .pdf, .doc, .docx
  - Envoyer le fichier à POST /api/recipes/import via FormData
  - En cas de succès, appeler onImport avec les données
  - En cas d'erreur, afficher le message sous la zone
- Utiliser les composants shadcn/ui existants (Button, cn pour les classes)

---

### 10. `components/recipes/recipe-form.tsx`

- Ajouter prop optionnelle `initialData?: Partial<ExtractedRecipe>` aux RecipeFormProps
- Modifier l'état initial formData (lignes 44-56) pour utiliser initialData si fourni:
  - `title: initialData?.title || recipe?.title || ""`
  - Idem pour description, ingredients, instructions
  - Pour prep_time, cook_time, servings: convertir number en string si présent
- Ajouter fonction `handleDocumentImport(data: ExtractedRecipe)` qui:
  - Met à jour formData avec setFormData
  - Affiche un toast de succès "Document importé"
- Ajouter le composant DocumentImport dans le JSX:
  - Placer avant la première Card (informations générales)
  - Passer onImport={handleDocumentImport}
  - Passer disabled={loading}
- Importer DocumentImport depuis "@/components/recipes/document-import"
- Importer le type ExtractedRecipe depuis "@/types"

---

### 11. `app/(main)/recipes/new/page.tsx`

- Aucune modification nécessaire
- Le composant RecipeForm gère l'import en interne
- La prop initialData est optionnelle et non utilisée ici

---

## Testing Strategy

### Tests manuels à effectuer

1. **Upload PDF**
   - Importer un PDF de recette
   - Vérifier que tous les champs sont préremplis
   - Vérifier que les valeurs numériques sont correctes

2. **Upload DOC**
   - Importer un fichier .doc
   - Vérifier l'extraction du texte

3. **Upload DOCX**
   - Importer un fichier .docx moderne
   - Vérifier l'extraction du texte

4. **Cas d'erreur**
   - Fichier trop volumineux (>10MB) → message d'erreur
   - Format non supporté (.txt, .jpg) → message d'erreur
   - Document sans contenu recette → extraction partielle acceptable

5. **UX**
   - Indicateur de chargement visible pendant l'analyse
   - Toast de succès après import
   - Possibilité de modifier les champs après import
   - Bouton désactivé pendant le chargement du formulaire

### Fichiers de test recommandés

- Créer dossier `__tests__/fixtures/` avec:
  - `recipe-sample.pdf`
  - `recipe-sample.doc`
  - `recipe-sample.docx`

---

## Documentation

- Ajouter la variable `GEMINI_API_KEY` dans `.env.example` si le fichier existe
- Pas de mise à jour README nécessaire (fonctionnalité utilisateur intuitive)

---

## Rollout Considerations

### Prérequis avant déploiement

1. Obtenir une clé API Gemini sur https://aistudio.google.com/apikey
2. Ajouter `GEMINI_API_KEY` aux variables d'environnement de production

### Limites connues

- Gemini gratuit: 1M tokens/minute (largement suffisant)
- Taille fichier max: 10MB (configurable dans l'API)
- Qualité d'extraction dépend de la structure du document source

### Pas de migration de données requise

- Fonctionnalité additive, aucun changement de schéma BDD
- Pas d'impact sur les recettes existantes
