import WordExtractor from "word-extractor";

const extractor = new WordExtractor();

export async function parseWord(buffer: Buffer): Promise<string> {
  try {
    const doc = await extractor.extract(buffer);
    return doc.getBody();
  } catch (error) {
    throw new Error(
      `Erreur lors de la lecture du document Word: ${error instanceof Error ? error.message : "Erreur inconnue"}`
    );
  }
}
