import { IngredientSearch } from "@/components/search/ingredient-search";

export const metadata = {
  title: "Recherche par ingrédients",
  description: "Trouvez des recettes basées sur les ingrédients que vous avez",
};

export default function SearchIngredientsPage() {
  return (
    <div className="container py-8">
      <div className="mx-auto max-w-4xl space-y-8">
        <div className="text-center space-y-2">
          <h1 className="text-3xl font-bold">Qu'est-ce que je peux cuisiner ?</h1>
          <p className="text-lg text-muted-foreground">
            Entrez les ingrédients que vous avez et découvrez les recettes
            possibles
          </p>
        </div>
        <IngredientSearch />
      </div>
    </div>
  );
}
