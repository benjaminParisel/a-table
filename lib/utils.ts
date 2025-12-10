import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";
import slugifyLib from "slugify";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function slugify(text: string): string {
  return slugifyLib(text, {
    lower: true,
    strict: true,
    locale: "fr",
  });
}

export function formatTime(minutes: number | null): string {
  if (!minutes) return "-";
  if (minutes < 60) return `${minutes} min`;
  const hours = Math.floor(minutes / 60);
  const mins = minutes % 60;
  return mins > 0 ? `${hours}h${mins}` : `${hours}h`;
}

export function getTotalTime(
  prepTime: number | null,
  cookTime: number | null
): number | null {
  if (!prepTime && !cookTime) return null;
  return (prepTime || 0) + (cookTime || 0);
}
