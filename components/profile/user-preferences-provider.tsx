"use client";

import {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  type ReactNode,
} from "react";

interface UserPreferences {
  showImages: boolean;
}

interface UserPreferencesContextType {
  preferences: UserPreferences;
  isLoading: boolean;
  updatePreferences: (prefs: Partial<UserPreferences>) => void;
  refreshPreferences: () => Promise<void>;
}

const defaultPreferences: UserPreferences = {
  showImages: true,
};

const UserPreferencesContext = createContext<UserPreferencesContextType | null>(null);

export function UserPreferencesProvider({ children }: { children: ReactNode }) {
  const [preferences, setPreferences] = useState<UserPreferences>(defaultPreferences);
  const [isLoading, setIsLoading] = useState(true);

  const fetchPreferences = useCallback(async () => {
    try {
      const res = await fetch("/api/profile");
      if (res.ok) {
        const data = await res.json();
        if (data.profile) {
          setPreferences({
            showImages: data.profile.show_images ?? true,
          });
        }
      }
    } catch {
      // Silent fail - use defaults
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchPreferences();
  }, [fetchPreferences]);

  const updatePreferences = useCallback((prefs: Partial<UserPreferences>) => {
    setPreferences((prev) => ({ ...prev, ...prefs }));
  }, []);

  const refreshPreferences = useCallback(async () => {
    setIsLoading(true);
    await fetchPreferences();
  }, [fetchPreferences]);

  return (
    <UserPreferencesContext.Provider
      value={{
        preferences,
        isLoading,
        updatePreferences,
        refreshPreferences,
      }}
    >
      {children}
    </UserPreferencesContext.Provider>
  );
}

export function useUserPreferences() {
  const context = useContext(UserPreferencesContext);
  if (!context) {
    throw new Error("useUserPreferences must be used within a UserPreferencesProvider");
  }
  return context;
}
