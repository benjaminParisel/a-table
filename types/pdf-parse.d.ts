declare module "pdf-parse/lib/pdf-parse" {
  interface PDFData {
    numpages: number;
    numrender: number;
    info: Record<string, unknown>;
    metadata: Record<string, unknown> | null;
    text: string;
    version: string;
  }

  function pdf(buffer: Buffer): Promise<PDFData>;
  export default pdf;
}
