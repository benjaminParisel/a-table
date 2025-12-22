"use client";

import {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  type ReactNode,
} from "react";

interface FavoritesContextType {
  favoriteIds: Set<string>;
  isLoading: boolean;
  isFavorite: (recipeId: string) => boolean;
  toggleFavorite: (recipeId: string) => Promise<void>;
  refreshFavorites: () => Promise<void>;
}

const FavoritesContext = createContext<FavoritesContextType | null>(null);

export function FavoritesProvider({ children }: { children: ReactNode }) {
  const [favoriteIds, setFavoriteIds] = useState<Set<string>>(new Set());
  const [isLoading, setIsLoading] = useState(true);

  const fetchFavorites = useCallback(async () => {
    try {
      const res = await fetch("/api/recipes/favorites");
      if (res.ok) {
        const data = await res.json();
        setFavoriteIds(new Set(data.recipe_ids || []));
      }
    } catch {
      // Silent fail - user might not be logged in
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchFavorites();
  }, [fetchFavorites]);

  const isFavorite = useCallback(
    (recipeId: string) => favoriteIds.has(recipeId),
    [favoriteIds]
  );

  const toggleFavorite = useCallback(
    async (recipeId: string) => {
      const currentlyFavorited = favoriteIds.has(recipeId);
      const method = currentlyFavorited ? "DELETE" : "POST";

      // Optimistic update
      setFavoriteIds((prev) => {
        const next = new Set(prev);
        if (currentlyFavorited) {
          next.delete(recipeId);
        } else {
          next.add(recipeId);
        }
        return next;
      });

      try {
        const res = await fetch("/api/recipes/favorites", {
          method,
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ recipe_id: recipeId }),
        });

        if (!res.ok) {
          // Revert on error
          setFavoriteIds((prev) => {
            const next = new Set(prev);
            if (currentlyFavorited) {
              next.add(recipeId);
            } else {
              next.delete(recipeId);
            }
            return next;
          });
        }
      } catch {
        // Revert on error
        setFavoriteIds((prev) => {
          const next = new Set(prev);
          if (currentlyFavorited) {
            next.add(recipeId);
          } else {
            next.delete(recipeId);
          }
          return next;
        });
      }
    },
    [favoriteIds]
  );

  const refreshFavorites = useCallback(async () => {
    setIsLoading(true);
    await fetchFavorites();
  }, [fetchFavorites]);

  return (
    <FavoritesContext.Provider
      value={{
        favoriteIds,
        isLoading,
        isFavorite,
        toggleFavorite,
        refreshFavorites,
      }}
    >
      {children}
    </FavoritesContext.Provider>
  );
}

export function useFavorites() {
  const context = useContext(FavoritesContext);
  if (!context) {
    throw new Error("useFavorites must be used within a FavoritesProvider");
  }
  return context;
}
