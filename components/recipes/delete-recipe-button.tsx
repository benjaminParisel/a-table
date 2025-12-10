"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Trash2 } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";

interface DeleteRecipeButtonProps {
  recipeId: string;
  recipeName?: string;
}

export function DeleteRecipeButton({ recipeId, recipeName }: DeleteRecipeButtonProps) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);

  const handleDelete = async () => {
    setLoading(true);

    try {
      const res = await fetch(`/api/recipes/${recipeId}`, {
        method: "DELETE",
      });

      if (!res.ok) {
        throw new Error("Failed to delete recipe");
      }

      toast.success("Recette supprimée", {
        description: recipeName ? `"${recipeName}" a été supprimée.` : undefined,
      });

      router.push("/recipes");
      router.refresh();
    } catch {
      toast.error("Erreur", {
        description: "Impossible de supprimer la recette. Veuillez réessayer.",
      });
    } finally {
      setLoading(false);
      setOpen(false);
    }
  };

  return (
    <AlertDialog open={open} onOpenChange={setOpen}>
      <AlertDialogTrigger asChild>
        <Button
          variant="outline"
          size="icon"
          disabled={loading}
          className="text-destructive hover:text-destructive"
        >
          <Trash2 className="h-4 w-4" />
        </Button>
      </AlertDialogTrigger>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>Supprimer la recette ?</AlertDialogTitle>
          <AlertDialogDescription>
            {recipeName ? (
              <>Êtes-vous sûr de vouloir supprimer &quot;{recipeName}&quot; ? </>
            ) : (
              <>Êtes-vous sûr de vouloir supprimer cette recette ? </>
            )}
            Cette action est irréversible.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel disabled={loading}>Annuler</AlertDialogCancel>
          <AlertDialogAction
            onClick={handleDelete}
            disabled={loading}
            className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
          >
            {loading ? "Suppression..." : "Supprimer"}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
