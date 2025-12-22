"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { LogOut, Settings, ChefHat, User } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { APP_NAME } from "@/lib/constants";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { ThemeToggle } from "@/components/theme-toggle";
import type { Profile } from "@/types";

interface NavbarProps {
  profile: Profile | null;
}

export function Navbar({ profile }: NavbarProps) {
  const router = useRouter();
  const supabase = createClient();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/login");
    router.refresh();
  };

  const initials = profile?.display_name
    ? profile.display_name
        .split(" ")
        .map((n) => n[0])
        .join("")
        .toUpperCase()
    : profile?.email?.charAt(0).toUpperCase() || "U";

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-14 items-center">
        {/* Logo */}
        <Link href="/recipes" className="flex items-center space-x-2">
          <ChefHat className="h-7 w-7 text-primary" />
          <span className="font-bold text-primary text-lg">{APP_NAME}</span>
        </Link>

        {/* Navigation desktop */}
        <nav className="hidden md:flex items-center space-x-6 text-sm font-medium ml-8">
          <Link href="/recipes" className="transition-colors hover:text-primary">
            Recettes
          </Link>
          <Link href="/menu" className="transition-colors hover:text-primary">
            Menu
          </Link>
          <Link href="/search-ingredients" className="transition-colors hover:text-primary">
            Par ingrédients
          </Link>
          <Link href="/favorites" className="transition-colors hover:text-primary">
            Favoris
          </Link>
          {profile?.role === "admin" && (
            <Link href="/admin" className="transition-colors hover:text-primary">
              Admin
            </Link>
          )}
        </nav>

        {/* Actions à droite */}
        <div className="flex flex-1 items-center justify-end space-x-2">
          <ThemeToggle />
          {/* Menu utilisateur - visible uniquement sur desktop, sur mobile c'est dans la bottom nav */}
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="relative h-10 w-10 rounded-full hidden md:flex">
                <Avatar className="h-10 w-10">
                  <AvatarFallback className="bg-primary text-primary-foreground text-sm">
                    {initials}
                  </AvatarFallback>
                </Avatar>
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-56" align="end" forceMount>
              <DropdownMenuLabel className="font-normal">
                <div className="flex flex-col space-y-1">
                  <p className="text-sm font-medium leading-none">
                    {profile?.display_name || "Utilisateur"}
                  </p>
                  <p className="text-xs leading-none text-muted-foreground">
                    {profile?.email}
                  </p>
                </div>
              </DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuItem asChild>
                <Link href="/profile">
                  <User className="mr-2 h-4 w-4" />
                  Mon profil
                </Link>
              </DropdownMenuItem>
              {profile?.role === "admin" && (
                <DropdownMenuItem asChild>
                  <Link href="/admin">
                    <Settings className="mr-2 h-4 w-4" />
                    Administration
                  </Link>
                </DropdownMenuItem>
              )}
              <DropdownMenuSeparator />
              <DropdownMenuItem onClick={handleLogout}>
                <LogOut className="mr-2 h-4 w-4" />
                Se déconnecter
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </header>
  );
}
