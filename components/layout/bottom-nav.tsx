"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { BookOpen, ChefHat, Heart, Search, User } from "lucide-react";
import { cn } from "@/lib/utils";

const navItems = [
  { href: "/recipes", label: "Recettes", icon: BookOpen },
  { href: "/menu", label: "Menu", icon: ChefHat },
  { href: "/search-ingredients", label: "Recherche", icon: Search },
  { href: "/favorites", label: "Favoris", icon: Heart },
  { href: "/profile", label: "Profil", icon: User },
];

export function BottomNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50 border-t bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 md:hidden">
      <div className="flex h-16 items-center justify-around">
        {navItems.map((item) => {
          const isActive = pathname.startsWith(item.href);
          const Icon = item.icon;

          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "flex flex-col items-center justify-center gap-1 px-3 py-2 min-w-[64px] rounded-lg transition-colors",
                isActive
                  ? "text-primary"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              <Icon className={cn("h-6 w-6", isActive && "fill-primary/20")} />
              <span className="text-xs font-medium">{item.label}</span>
            </Link>
          );
        })}
      </div>
      {/* Safe area pour les iPhones avec encoche */}
      <div className="h-[env(safe-area-inset-bottom)]" />
    </nav>
  );
}
