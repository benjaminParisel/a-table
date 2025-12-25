# Task: Import de documents pour préremplir les recettes

Permettre l'import de fichiers PDF, DOC et DOCX lors de la création d'une recette pour extraire automatiquement les informations et préremplir le formulaire.

## Codebase Context

### Structure du formulaire de recette

**Fichier principal**: `components/recipes/recipe-form.tsx`
- Lignes 44-56: État du formulaire avec tous les champs
- Lignes 58-111: Fonction handleSubmit (POST/PUT vers `/api/recipes`)
- Lignes 162-379: Interface utilisateur du formulaire

**Champs à préremplir**:
| Champ | Type | Description |
|-------|------|-------------|
| `title` | string | Nom de la recette |
| `description` | text | Description/résumé |
| `ingredients` | text | Un ingrédient par ligne |
| `instructions` | text | Étapes de préparation |
| `prep_time` | number | Temps de préparation (minutes) |
| `cook_time` | number | Temps de cuisson (minutes) |
| `servings` | number | Nombre de portions (défaut: 4) |
| `category_id` | UUID | Catégorie (sélection manuelle) |
| `tag_ids` | UUID[] | Tags (détection automatique possible) |

### Types existants

**Fichier**: `types/index.ts`
- Lignes 28-43: Interface `Recipe`
- Lignes 45-49: `RecipeWithRelations`

### API existante

**Fichier**: `app/api/recipes/route.ts`
- Lignes 7-18: Schéma Zod pour validation
- Lignes 72-135: Handler POST avec génération de slug

### Upload d'images existant

**Fichier**: `components/shared/image-upload.tsx`
- Lignes 22-75: Pattern d'upload vers Supabase Storage
- Bucket: `recipe-images`, path: `recipes/{filename}`
- Validation: type image/*, taille max 5MB
- Génération nom unique: timestamp + random string

### Page de création de recette

**Fichier**: `app/(main)/recipes/new/page.tsx`
- Récupère catégories et tags depuis la base
- Rend le composant RecipeForm

## Documentation Insights

### Upload de fichiers Next.js 16

**Approche recommandée**: API Route Handler

```typescript
// API Route Handler
export async function POST(request: NextRequest) {
  const formData = await request.formData();
  const file = formData.get('file') as File;
  const bytes = await file.arrayBuffer();
  const buffer = Buffer.from(bytes);
  // Process...
}
```

**React 19 Hooks**:
- `useTransition`: Pour état de chargement async

## Research Findings

### Librairies de parsing choisies

| Format | Librairie | Taille | Notes |
|--------|-----------|--------|-------|
| **PDF** | `pdf-parse` | ~200KB | Simple, rapide, sans dépendances |
| **DOC + DOCX** | `word-extractor` | ~50KB | Pure Node.js, supporte les deux formats |

**word-extractor** avantages:
- Pas de dépendance externe (pas besoin d'antiword)
- Fonctionne sur toutes les plateformes
- Supporte à la fois .doc (OLE) et .docx (Open XML)

Sources:
- [word-extractor sur npm](https://www.npmjs.com/package/word-extractor)
- [GitHub word-extractor](https://github.com/morungos/node-word-extractor)

### Extraction intelligente avec Google Gemini

**Choix validé**: Google Gemini (gratuit via Google AI Studio)

**Avantages**:
- 100% gratuit (1M tokens/minute)
- Excellente qualité d'extraction
- API simple à intégrer
- Comprend le français nativement

**Librairie**: `@google/generative-ai`

```typescript
import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

const prompt = `Analyse ce texte de recette et extrais les informations en JSON:
{
  "title": "nom de la recette",
  "description": "courte description ou null",
  "ingredients": "ingrédients séparés par des sauts de ligne",
  "instructions": "étapes séparées par des sauts de ligne",
  "prep_time": nombre en minutes ou null,
  "cook_time": nombre en minutes ou null,
  "servings": nombre de portions ou null
}

Texte:
${extractedText}`;

const result = await model.generateContent(prompt);
const json = JSON.parse(result.response.text());
```

## Key Files

### À modifier
- `components/recipes/recipe-form.tsx` - Ajouter props pour données importées
- `app/(main)/recipes/new/page.tsx` - Intégrer composant d'import

### À créer
- `components/recipes/document-import.tsx` - Composant d'import de document
- `app/api/recipes/import/route.ts` - API pour traitement du document
- `lib/parsers/pdf.ts` - Parser PDF avec pdf-parse
- `lib/parsers/word.ts` - Parser DOC/DOCX avec word-extractor
- `lib/parsers/extract-recipe.ts` - Extraction via Gemini

### Référence
- `components/shared/image-upload.tsx` - Pattern d'upload existant
- `app/api/recipes/route.ts:7-18` - Schéma Zod de référence

## Patterns to Follow

### 1. Validation avec Zod
```typescript
const ACCEPTED_TYPES = [
  'application/pdf',
  'application/msword', // .doc
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document', // .docx
];

const importSchema = z.object({
  file: z.instanceof(File)
    .refine(f => f.size <= 10 * 1024 * 1024, 'Fichier trop volumineux (max 10MB)')
    .refine(f => ACCEPTED_TYPES.includes(f.type), 'Format non supporté (PDF, DOC, DOCX)')
});
```

### 2. Structure de réponse API
```typescript
// Type pour les données extraites
interface ExtractedRecipe {
  title: string;
  description: string | null;
  ingredients: string;
  instructions: string;
  prep_time: number | null;
  cook_time: number | null;
  servings: number | null;
}

return NextResponse.json({
  success: true,
  data: ExtractedRecipe
});
```

### 3. Parsing selon le type de fichier
```typescript
async function extractText(buffer: Buffer, mimeType: string): Promise<string> {
  if (mimeType === 'application/pdf') {
    const pdf = await pdfParse(buffer);
    return pdf.text;
  }

  // DOC et DOCX
  const extractor = new WordExtractor();
  const doc = await extractor.extract(buffer);
  return doc.getBody();
}
```

## Dependencies

### À installer
```bash
pnpm add pdf-parse word-extractor @google/generative-ai
pnpm add -D @types/pdf-parse
```

### Variables d'environnement
```env
GEMINI_API_KEY=your_api_key_here
```

Pour obtenir la clé: https://aistudio.google.com/apikey

### Existantes (déjà installées)
- `zod` - Validation
- `lucide-react` - Icônes (FileUp, FileText, Loader2)
- `sonner` - Notifications toast

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Page /recipes/new                         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐    ┌────────────────────────────┐  │
│  │  DocumentImport     │───▶│     RecipeForm             │  │
│  │  - Drag & drop      │    │     (prérempli)            │  │
│  │  - PDF/DOC/DOCX     │    │                            │  │
│  └─────────────────────┘    └────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────┐
│              POST /api/recipes/import                        │
├─────────────────────────────────────────────────────────────┤
│  1. Valider fichier (type, taille)                          │
│  2. Parser selon format:                                    │
│     - PDF → pdf-parse → texte                               │
│     - DOC/DOCX → word-extractor → texte                     │
│  3. Envoyer texte à Gemini                                  │
│  4. Parser JSON retourné                                    │
│  5. Valider avec Zod                                        │
│  6. Retourner données structurées                           │
└─────────────────────────────────────────────────────────────┘
```

## Considérations UX

1. **Zone de drop** avec indication visuelle claire
2. **Formats acceptés** affichés (PDF, DOC, DOCX)
3. **Indicateur de progression** pendant le parsing (~2-3s)
4. **Preview optionnel** avant préremplissage
5. **Édition manuelle** toujours possible après import
6. **Messages d'erreur clairs** si extraction échoue

## Décisions prises

| Question | Décision | Raison |
|----------|----------|--------|
| Stocker les documents originaux? | Non | Pas nécessaire, on extrait juste le texte |
| LLM pour extraction? | Oui - Gemini | Gratuit, précis, simple |
| Support DOC (ancien format)? | Oui | Demande utilisateur, word-extractor le supporte |
| Extraction côté client ou serveur? | Serveur | Sécurité clé API, meilleure perf |

## Prochaine étape

Exécuter `/epct:plan 02-import-document-recipe` pour créer le plan d'implémentation détaillé.
