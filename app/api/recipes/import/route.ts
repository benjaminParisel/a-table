import { NextRequest, NextResponse } from "next/server";
import {
  extractTextFromDocument,
  extractRecipeFromText,
  ACCEPTED_MIME_TYPES,
} from "@/lib/parsers";

const MAX_FILE_SIZE = 10 * 1024 * 1024;

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData();
    const file = formData.get("file") as File | null;

    if (!file) {
      return NextResponse.json(
        { error: "Aucun fichier fourni" },
        { status: 400 }
      );
    }

    if (file.size > MAX_FILE_SIZE) {
      return NextResponse.json(
        { error: "Fichier trop volumineux (max 10 Mo)" },
        { status: 400 }
      );
    }

    if (!ACCEPTED_MIME_TYPES.includes(file.type as typeof ACCEPTED_MIME_TYPES[number])) {
      return NextResponse.json(
        { error: "Format non supporté. Formats acceptés: PDF, DOC, DOCX" },
        { status: 400 }
      );
    }

    const arrayBuffer = await file.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);

    const text = await extractTextFromDocument(buffer, file.type);

    if (!text || text.trim().length === 0) {
      return NextResponse.json(
        { error: "Impossible d'extraire le texte du document" },
        { status: 400 }
      );
    }

    const extractedRecipe = await extractRecipeFromText(text);

    return NextResponse.json({
      success: true,
      data: extractedRecipe,
    });
  } catch (error) {
    console.error("Import error:", error);
    return NextResponse.json(
      {
        error:
          error instanceof Error
            ? error.message
            : "Erreur lors de l'import du document",
      },
      { status: 500 }
    );
  }
}
