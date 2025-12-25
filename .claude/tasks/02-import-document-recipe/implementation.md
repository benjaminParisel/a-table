# Implementation: Import de documents pour préremplir les recettes

## Completed

### Fichiers créés
- `types/index.ts` - Ajout de l'interface `ExtractedRecipe`
- `types/pdf-parse.d.ts` - Déclaration de types pour pdf-parse
- `types/word-extractor.d.ts` - Déclaration de types pour word-extractor
- `lib/parsers/pdf.ts` - Parser PDF utilisant pdf-parse v1.1.1
- `lib/parsers/word.ts` - Parser DOC/DOCX utilisant word-extractor
- `lib/parsers/extract-recipe.ts` - Extraction intelligente via Google Gemini
- `lib/parsers/index.ts` - Exports et fonction utilitaire `extractTextFromDocument`
- `app/api/recipes/import/route.ts` - API endpoint POST pour l'import
- `components/recipes/document-import.tsx` - Composant UI d'import

### Fichiers modifiés
- `components/recipes/recipe-form.tsx` - Intégration du composant DocumentImport + handler `handleDocumentImport`

### Dépendances installées
- `pdf-parse@1.1.1` (v1 pour compatibilité serverless)
- `word-extractor@1.0.4`
- `@google/generative-ai@0.24.1`

## Deviations from Plan

1. **pdf-parse v1.1.1 au lieu de v2.x**
   - La v2 utilise pdfjs-dist qui nécessite des APIs Canvas (DOMMatrix) non disponibles en environnement serverless Next.js
   - Solution: utiliser la v1.1.1 plus légère avec import dynamique (`pdf-parse/lib/pdf-parse`) pour éviter le chargement des fichiers test

2. **Déclarations de types personnalisées**
   - `@types/pdf-parse` supprimé car incompatible avec l'import dynamique
   - Créé `types/pdf-parse.d.ts` et `types/word-extractor.d.ts` manuellement

3. **Import dynamique pour pdf-parse**
   - L'import statique cause une erreur car pdf-parse essaie de charger des fichiers test au démarrage
   - Solution: `await import("pdf-parse/lib/pdf-parse")` dans la fonction

## Test Results

- **Build**: ✓ Passed
- **TypeScript**: ✓ No errors
- **Routes générées**: `/api/recipes/import` (Dynamic)

## Prérequis pour utilisation

1. **Variable d'environnement requise**:
   ```env
   GEMINI_API_KEY=your_api_key_here
   ```

2. **Obtenir la clé**: https://aistudio.google.com/apikey

## Follow-up Tasks

1. **Test manuel** à effectuer avec des fichiers PDF, DOC et DOCX réels
2. **Ajouter GEMINI_API_KEY** dans `.env.local` avant de tester
3. **Configurer en production** la variable d'environnement sur le serveur de déploiement

## Architecture finale

```
User selects file (PDF/DOC/DOCX)
         │
         ▼
DocumentImport component
         │
         ▼ POST /api/recipes/import
         │
         ├─► Validate file (type, size)
         │
         ├─► Extract text
         │   ├─► PDF: pdf-parse
         │   └─► DOC/DOCX: word-extractor
         │
         ├─► Send to Gemini for structured extraction
         │
         └─► Return ExtractedRecipe JSON
         │
         ▼
RecipeForm (fields pre-filled)
```
