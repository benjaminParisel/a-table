"use client";

import { Printer } from "lucide-react";
import { Button } from "@/components/ui/button";

export function PrintRecipeButton() {
  const handlePrint = () => {
    window.print();
  };

  return (
    <Button
      variant="outline"
      size="icon"
      onClick={handlePrint}
      title="Imprimer la recette"
      className="h-11 w-11 touch-manipulation print:hidden"
    >
      <Printer className="h-5 w-5" />
    </Button>
  );
}
