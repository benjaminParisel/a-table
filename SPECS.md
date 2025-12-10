# À Table ! - Project Specifications for Claude Code

## Project Overview

Build a private family recipe management web application with the following features:
- Recipe CRUD (Create, Read, Update, Delete)
- Categories and tags management
- Search and filtering
- Random menu generator
- User authentication (private access)
- Admin panel for user/category/tag management

## Tech Stack

- **Framework**: Next.js 15 (App Router) with TypeScript
- **React**: 19
- **UI**: shadcn/ui + Tailwind CSS v4
- **Database & Auth**: Supabase (PostgreSQL + Auth)
- **Icons**: lucide-react
- **Validation**: zod

## Setup Commands

```bash
# Initialize Next.js 15 project
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"

# Install dependencies
npm install @supabase/supabase-js @supabase/ssr zod lucide-react

# Initialize shadcn/ui (style: default, base color: stone, css variables: yes)
npx shadcn@latest init

# Add shadcn components
npx shadcn@latest add button card input label badge dialog select checkbox dropdown-menu avatar separator sheet toast textarea popover command
```

## Environment Variables

Create `.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Project Structure

```
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── (main)/
│   │   ├── layout.tsx
│   │   ├── page.tsx                    # Redirect to /recipes
│   │   ├── recipes/
│   │   │   ├── page.tsx                # Recipe list with search/filters
│   │   │   ├── new/
│   │   │   │   └── page.tsx            # Create recipe form
│   │   │   └── [id]/
│   │   │       ├── page.tsx            # Recipe detail view
│   │   │       └── edit/
│   │   │           └── page.tsx        # Edit recipe form
│   │   ├── menu/
│   │   │   └── page.tsx                # Menu generator
│   │   └── admin/
│   │       ├── page.tsx                # Admin dashboard
│   │       ├── users/
│   │       │   └── page.tsx            # User management
│   │       ├── categories/
│   │       │   └── page.tsx            # Category management
│   │       └── tags/
│   │           └── page.tsx            # Tag management
│   ├── layout.tsx
│   └── globals.css
├── components/
│   ├── ui/                             # shadcn components (auto-generated)
│   ├── layout/
│   │   ├── navbar.tsx
│   │   ├── mobile-nav.tsx
│   │   └── user-menu.tsx
│   ├── recipes/
│   │   ├── recipe-card.tsx
│   │   ├── recipe-list.tsx
│   │   ├── recipe-form.tsx
│   │   ├── recipe-filters.tsx
│   │   └── recipe-detail.tsx
│   ├── menu/
│   │   └── menu-generator.tsx
│   └── admin/
│       ├── category-form.tsx
│       ├── tag-form.tsx
│       └── user-list.tsx
├── lib/
│   ├── supabase/
│   │   ├── client.ts                   # Browser client
│   │   ├── server.ts                   # Server client (async)
│   │   └── middleware.ts               # Auth middleware helper
│   ├── utils.ts                        # Utility functions (cn, slugify, etc.)
│   ├── constants.ts                    # App constants
│   └── validations/
│       └── recipe.ts                   # Zod schemas
├── hooks/
│   ├── use-recipes.ts
│   ├── use-categories.ts
│   ├── use-tags.ts
│   └── use-auth.ts
├── types/
│   └── index.ts                        # TypeScript types
├── actions/
│   ├── recipes.ts                      # Server actions for recipes
│   ├── categories.ts                   # Server actions for categories
│   ├── tags.ts                         # Server actions for tags
│   └── auth.ts                         # Server actions for auth
└── middleware.ts                       # Next.js middleware for auth
```

## ⚠️ Next.js 15 Breaking Changes - IMPORTANT

### 1. Async Request APIs

In Next.js 15, `cookies()`, `headers()`, `params`, and `searchParams` are now **async**.

```typescript
// ❌ Next.js 14 (OLD)
import { cookies } from 'next/headers'
const cookieStore = cookies()
const token = cookieStore.get('token')

// ✅ Next.js 15 (NEW)
import { cookies } from 'next/headers'
const cookieStore = await cookies()
const token = cookieStore.get('token')
```

### 2. Async params in Dynamic Routes

```typescript
// ❌ Next.js 14 (OLD)
export default function RecipePage({ params }: { params: { id: string } }) {
  const { id } = params
  // ...
}

// ✅ Next.js 15 (NEW)
export default async function RecipePage({ 
  params 
}: { 
  params: Promise<{ id: string }> 
}) {
  const { id } = await params
  // ...
}
```

### 3. Async searchParams in Pages

```typescript
// ❌ Next.js 14 (OLD)
export default function RecipesPage({ 
  searchParams 
}: { 
  searchParams: { category?: string } 
}) {
  const category = searchParams.category
  // ...
}

// ✅ Next.js 15 (NEW)
export default async function RecipesPage({ 
  searchParams 
}: { 
  searchParams: Promise<{ category?: string }> 
}) {
  const { category } = await searchParams
  // ...
}
```

### 4. Fetch Caching

```typescript
// Next.js 15: fetch is NOT cached by default (more intuitive)
// To cache, explicitly add:
fetch(url, { cache: 'force-cache' })
```

## Supabase Configuration (Next.js 15 Compatible)

### Browser Client (src/lib/supabase/client.ts)

```typescript
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

### Server Client (src/lib/supabase/server.ts)

```typescript
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const cookieStore = await cookies()

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {
            // The `setAll` method was called from a Server Component.
            // This can be ignored if you have middleware refreshing sessions.
          }
        },
      },
    }
  )
}
```

### Middleware (src/lib/supabase/middleware.ts)

```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) => 
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({
            request,
          })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const {
    data: { user },
  } = await supabase.auth.getUser()

  // Protected routes: redirect to login if not authenticated
  if (
    !user &&
    !request.nextUrl.pathname.startsWith('/login')
  ) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  // Redirect logged-in users away from login page
  if (user && request.nextUrl.pathname.startsWith('/login')) {
    const url = request.nextUrl.clone()
    url.pathname = '/recipes'
    return NextResponse.redirect(url)
  }

  return supabaseResponse
}
```

### Root Middleware (src/middleware.ts)

```typescript
import { type NextRequest } from 'next/server'
import { updateSession } from '@/lib/supabase/middleware'

export async function middleware(request: NextRequest) {
  return await updateSession(request)
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public files (public folder)
     */
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
```

## Database Schema (Supabase SQL)

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (extends Supabase auth.users)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Categories table
CREATE TABLE public.categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Default categories
INSERT INTO public.categories (name, slug, display_order) VALUES
  ('Entrée', 'entree', 1),
  ('Plat', 'plat', 2),
  ('Dessert', 'dessert', 3),
  ('Apéro', 'apero', 4),
  ('Accompagnement', 'accompagnement', 5);

-- Tags table
CREATE TABLE public.tags (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Default tags
INSERT INTO public.tags (name, slug) VALUES
  ('Végétarien', 'vegetarien'),
  ('Végan', 'vegan'),
  ('Sans gluten', 'sans-gluten'),
  ('Sans lactose', 'sans-lactose'),
  ('Rapide', 'rapide'),
  ('Économique', 'economique'),
  ('Familial', 'familial'),
  ('Festif', 'festif');

-- Recipes table
CREATE TABLE public.recipes (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  ingredients TEXT,
  instructions TEXT,
  prep_time INTEGER,
  cook_time INTEGER,
  servings INTEGER DEFAULT 4,
  image_url TEXT,
  category_id UUID NOT NULL REFERENCES public.categories(id),
  created_by UUID REFERENCES public.profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Recipe-Tags junction table
CREATE TABLE public.recipe_tags (
  recipe_id UUID REFERENCES public.recipes(id) ON DELETE CASCADE,
  tag_id UUID REFERENCES public.tags(id) ON DELETE CASCADE,
  PRIMARY KEY (recipe_id, tag_id)
);

-- Indexes
CREATE INDEX idx_recipes_category ON public.recipes(category_id);
CREATE INDEX idx_recipes_title ON public.recipes USING GIN (to_tsvector('french', title));
CREATE INDEX idx_recipe_tags_recipe ON public.recipe_tags(recipe_id);
CREATE INDEX idx_recipe_tags_tag ON public.recipe_tags(tag_id);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_tags ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Profiles
CREATE POLICY "Users can view all profiles" ON public.profiles
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- Categories (read: all, write: admin)
CREATE POLICY "Authenticated can view categories" ON public.categories
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admin can manage categories" ON public.categories
  FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- Tags (read: all, write: admin)
CREATE POLICY "Authenticated can view tags" ON public.tags
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admin can manage tags" ON public.tags
  FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- Recipes (all authenticated can CRUD)
CREATE POLICY "Authenticated can view recipes" ON public.recipes
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated can create recipes" ON public.recipes
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated can update recipes" ON public.recipes
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated can delete recipes" ON public.recipes
  FOR DELETE USING (auth.role() = 'authenticated');

-- Recipe_tags
CREATE POLICY "Authenticated can view recipe_tags" ON public.recipe_tags
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated can manage recipe_tags" ON public.recipe_tags
  FOR ALL USING (auth.role() = 'authenticated');

-- Triggers
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER recipes_updated_at
  BEFORE UPDATE ON public.recipes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (NEW.id, NEW.email, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Helper function: search recipes
CREATE OR REPLACE FUNCTION search_recipes(search_query TEXT)
RETURNS SETOF public.recipes AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT r.*
  FROM public.recipes r
  LEFT JOIN public.recipe_tags rt ON r.id = rt.recipe_id
  LEFT JOIN public.tags t ON rt.tag_id = t.id
  WHERE 
    r.title ILIKE '%' || search_query || '%'
    OR r.ingredients ILIKE '%' || search_query || '%'
    OR t.name ILIKE '%' || search_query || '%'
  ORDER BY r.title;
END;
$$ LANGUAGE plpgsql;
```

## TypeScript Types (src/types/index.ts)

```typescript
export type UserRole = 'admin' | 'user';

export interface Profile {
  id: string;
  email: string;
  display_name: string | null;
  role: UserRole;
  created_at: string;
  updated_at: string;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  display_order: number;
  created_at: string;
}

export interface Tag {
  id: string;
  name: string;
  slug: string;
  created_at: string;
}

export interface Recipe {
  id: string;
  title: string;
  slug: string;
  description: string | null;
  ingredients: string | null;
  instructions: string | null;
  prep_time: number | null;
  cook_time: number | null;
  servings: number;
  image_url: string | null;
  category_id: string;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface RecipeWithRelations extends Recipe {
  category: Category;
  tags: Tag[];
  author?: Profile | null;
}

export interface RecipeFilters {
  search?: string;
  category?: string;
  tags?: string[];
  maxPrepTime?: number;
  maxCookTime?: number;
}

// Next.js 15 page props types
export interface PageProps<TParams = {}, TSearchParams = {}> {
  params: Promise<TParams>;
  searchParams: Promise<TSearchParams>;
}
```

## Key Components Specifications

### 1. Navbar (src/components/layout/navbar.tsx)
- Logo "À Table !" with ChefHat icon
- Navigation links: Recettes, Menu
- Admin link (visible only for admin users)
- User dropdown menu (profile, logout)
- Mobile responsive with hamburger menu

### 2. RecipeCard (src/components/recipes/recipe-card.tsx)
Props: `recipe: RecipeWithRelations`
Display:
- Image (or placeholder gradient with emoji)
- Category badge (orange)
- Title
- Prep + cook time with Clock icon
- Servings with Users icon
- Tags as small badges (max 2 visible)
- Hover effect: shadow + scale

### 3. RecipeFilters (src/components/recipes/recipe-filters.tsx)
Features:
- Search input (searches title, ingredients, tags)
- Category filter (single select)
- Tags filter (multi select)
- Prep time filter (ranges: <15min, 15-30min, 30-60min, >60min)
- Active filters shown as removable chips
- "Reset filters" button
- Filters stored in URL params (shareable)

### 4. RecipeForm (src/components/recipes/recipe-form.tsx)
Fields:
- title (required, text)
- category_id (required, select)
- description (optional, textarea)
- ingredients (optional, textarea)
- instructions (optional, textarea)
- prep_time (optional, number)
- cook_time (optional, number)
- servings (optional, number, default 4)
- tags (optional, multi-select)
- image_url (optional, text input for URL)

Validation with zod.

### 5. MenuGenerator (src/components/menu/menu-generator.tsx)
Features:
- Checkboxes for each category (with recipe count)
- Minimum 1 category required
- Default selection: Entrée + Plat + Dessert
- "Generate" button with animation
- Display generated recipes as cards
- "Regenerate" button
- Categories with 0 recipes are disabled

## Pages Specifications (Next.js 15 Patterns)

### Login Page (/login)
- Email + password form
- Supabase Auth signInWithPassword
- Redirect to /recipes on success
- Error handling with toast

### Recipes List Page (/recipes)

```typescript
// src/app/(main)/recipes/page.tsx
import { createClient } from '@/lib/supabase/server'
import type { PageProps } from '@/types'

interface RecipesSearchParams {
  search?: string;
  category?: string;
  tags?: string;
}

export default async function RecipesPage({ 
  searchParams 
}: PageProps<{}, RecipesSearchParams>) {
  const { search, category, tags } = await searchParams
  const supabase = await createClient()
  
  // Fetch recipes with filters...
}
```

### Recipe Detail Page (/recipes/[id])

```typescript
// src/app/(main)/recipes/[id]/page.tsx
import { createClient } from '@/lib/supabase/server'
import type { PageProps } from '@/types'

export default async function RecipeDetailPage({ 
  params 
}: PageProps<{ id: string }>) {
  const { id } = await params
  const supabase = await createClient()
  
  // Fetch recipe by id...
}
```

### Create Recipe Page (/recipes/new)
- RecipeForm component
- Server action to create
- Redirect to recipe detail on success

### Edit Recipe Page (/recipes/[id]/edit)

```typescript
// src/app/(main)/recipes/[id]/edit/page.tsx
import { createClient } from '@/lib/supabase/server'
import type { PageProps } from '@/types'

export default async function EditRecipePage({ 
  params 
}: PageProps<{ id: string }>) {
  const { id } = await params
  const supabase = await createClient()
  
  // Fetch recipe for editing...
}
```

### Menu Generator Page (/menu)
- MenuGenerator component
- Full page centered layout

### Admin Pages (/admin/*)
- Protected: redirect non-admin to /recipes
- /admin: Dashboard with stats (recipe count, user count)
- /admin/users: List users, invite button, delete button
- /admin/categories: CRUD categories
- /admin/tags: CRUD tags

## Server Actions Pattern (Next.js 15)

```typescript
// src/actions/recipes.ts
'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { recipeSchema } from '@/lib/validations/recipe'

export async function createRecipe(formData: FormData) {
  const supabase = await createClient()
  
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return { error: 'Unauthorized' }
  }

  const validatedFields = recipeSchema.safeParse({
    title: formData.get('title'),
    category_id: formData.get('category_id'),
    description: formData.get('description'),
    // ... other fields
  })

  if (!validatedFields.success) {
    return { error: 'Invalid fields' }
  }

  const { data, error } = await supabase
    .from('recipes')
    .insert({
      ...validatedFields.data,
      slug: slugify(validatedFields.data.title),
      created_by: user.id,
    })
    .select()
    .single()

  if (error) {
    return { error: error.message }
  }

  revalidatePath('/recipes')
  redirect(`/recipes/${data.id}`)
}

export async function updateRecipe(id: string, formData: FormData) {
  const supabase = await createClient()
  // Similar pattern with update...
}

export async function deleteRecipe(id: string) {
  const supabase = await createClient()
  // Delete and redirect...
}

export async function getRandomRecipesByCategories(categoryIds: string[]) {
  const supabase = await createClient()
  
  const recipes = await Promise.all(
    categoryIds.map(async (categoryId) => {
      const { data } = await supabase
        .from('recipes')
        .select('*, category:categories(*)')
        .eq('category_id', categoryId)
        .limit(1)
        .order('random()')
        .single()
      return data
    })
  )

  return recipes.filter(Boolean)
}
```

## Design Specifications

### Colors (Tailwind)
- Primary: orange-600 (#EA580C)
- Primary hover: orange-700
- Background: stone-50
- Card background: white
- Text: stone-800
- Muted text: stone-500
- Border: stone-200

### UI Guidelines
- Use shadcn/ui components
- Rounded corners: rounded-xl for cards, rounded-lg for buttons
- Subtle shadows on hover
- Smooth transitions (transition-all)
- Mobile-first responsive design
- French labels for UI (code in English)

## Important Notes

1. **All UI text should be in French**
2. **All code (variables, functions, comments) in English**
3. **Use Server Components by default**, 'use client' only when needed
4. **Handle loading and error states** with loading.tsx and error.tsx
5. Use **toast notifications** for success/error feedback
6. Implement proper **TypeScript types** everywhere
7. Follow **Next.js 15 App Router** conventions
8. **Always use async/await** for cookies(), headers(), params, searchParams
9. **Supabase server client must be created with await**: `await createClient()`