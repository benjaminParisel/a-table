import Groq from "groq-sdk";
import { z } from "zod";
import type { ExtractedRecipe } from "@/types";

const extractedRecipeSchema = z.object({
  title: z.string(),
  description: z.string().nullable(),
  ingredients: z.string(),
  instructions: z.string(),
  prep_time: z.number().nullable(),
  cook_time: z.number().nullable(),
  servings: z.number().nullable(),
});

function extractJsonFromText(text: string): string {
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (jsonMatch) {
    return jsonMatch[0];
  }
  return text;
}

export async function extractRecipeFromText(
  text: string
): Promise<ExtractedRecipe> {
  const apiKey = process.env.GROQ_API_KEY;
  if (!apiKey) {
    throw new Error("GROQ_API_KEY non configurée");
  }

  const groq = new Groq({ apiKey });

  const prompt = `Analyse ce texte de recette et extrais les informations en JSON.
Retourne UNIQUEMENT le JSON, sans texte avant ou après.
Format attendu:
{
  "title": "nom de la recette",
  "description": "courte description ou null si non trouvée",
  "ingredients": "liste des ingrédients, un par ligne, séparés par des sauts de ligne",
  "instructions": "étapes de préparation, une par ligne, séparées par des sauts de ligne",
  "prep_time": nombre de minutes de préparation ou null si non trouvé,
  "cook_time": nombre de minutes de cuisson ou null si non trouvé,
  "servings": nombre de portions ou null si non trouvé
}

Texte de la recette:
${text}`;

  try {
    const completion = await groq.chat.completions.create({
      messages: [{ role: "user", content: prompt }],
      model: "llama-3.3-70b-versatile",
      temperature: 0.1,
      max_tokens: 2048,
    });

    const responseText = completion.choices[0]?.message?.content || "";
    const jsonText = extractJsonFromText(responseText);
    const parsed = JSON.parse(jsonText);
    const validated = extractedRecipeSchema.parse(parsed);
    return validated;
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new Error("Le format de la réponse est invalide");
    }
    if (error instanceof SyntaxError) {
      throw new Error("Impossible de parser la réponse JSON");
    }
    throw new Error(
      `Erreur lors de l'extraction: ${error instanceof Error ? error.message : "Erreur inconnue"}`
    );
  }
}
