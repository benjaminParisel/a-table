import { parsePdf } from "./pdf";
import { parseWord } from "./word";

export { parsePdf } from "./pdf";
export { parseWord } from "./word";
export { extractRecipeFromText } from "./extract-recipe";

const MIME_PDF = "application/pdf";
const MIME_DOC = "application/msword";
const MIME_DOCX =
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document";

export const ACCEPTED_MIME_TYPES = [MIME_PDF, MIME_DOC, MIME_DOCX] as const;

export async function extractTextFromDocument(
  buffer: Buffer,
  mimeType: string
): Promise<string> {
  switch (mimeType) {
    case MIME_PDF:
      return parsePdf(buffer);
    case MIME_DOC:
    case MIME_DOCX:
      return parseWord(buffer);
    default:
      throw new Error(`Format non supporté: ${mimeType}`);
  }
}
