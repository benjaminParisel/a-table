export async function parsePdf(buffer: Buffer): Promise<string> {
  try {
    // Dynamic import to avoid pdf-parse trying to load test files at module initialization
    const pdf = (await import("pdf-parse/lib/pdf-parse")).default;
    const data = await pdf(buffer);
    return data.text;
  } catch (error) {
    throw new Error(
      `Erreur lors de la lecture du PDF: ${error instanceof Error ? error.message : "Erreur inconnue"}`
    );
  }
}
