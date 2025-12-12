-- ======================
-- Seed Data for À Table !
-- ======================

-- Insert default categories
INSERT INTO public.categories (name, slug, display_order) VALUES
  ('Entrée', 'starter', 1),
  ('Plat', 'main', 2),
  ('Dessert', 'dessert', 3),
  ('Apéro', 'appetizer', 4),
  ('Accompagnement', 'side', 5)
ON CONFLICT (slug) DO NOTHING;

-- Insert default tags
INSERT INTO public.tags (name, slug) VALUES
  ('Végétarien', 'vegetarian'),
  ('Végan', 'vegan'),
  ('Sans gluten', 'gluten-free'),
  ('Sans lactose', 'lactose-free'),
  ('Rapide', 'quick'),
  ('Économique', 'budget'),
  ('Familial', 'family'),
  ('Festif', 'festive'),
  ('Thermomix', 'thermomix'),
  ('Exotique', 'exotic')
ON CONFLICT (slug) DO NOTHING;

-- ======================
-- TEST USER for local development
-- ======================
-- Email: walter.bates@mail.com
-- Password: bpm

-- Insert test user into auth.users
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  aud,
  role,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change,
  email_change_token_new,
  email_change_token_current,
  phone,
  phone_change,
  phone_change_token,
  reauthentication_token
) VALUES (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  '00000000-0000-0000-0000-000000000000',
  'walter.bates@mail.com',
  crypt('bpm', gen_salt('bf')),
  NOW(),
  '{"provider": "email", "providers": ["email"]}',
  '{"email_verified": false}',
  'authenticated',
  'authenticated',
  NOW(),
  NOW(),
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

-- Insert identity for test user (required for Supabase Auth)
INSERT INTO auth.identities (
  id,
  user_id,
  identity_data,
  provider,
  provider_id,
  last_sign_in_at,
  created_at,
  updated_at
) VALUES (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  '{"sub": "a1b2c3d4-e5f6-7890-abcd-ef1234567890", "email": "walter.bates@mail.com", "email_verified": false, "phone_verified": false}',
  'email',
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  NOW(),
  NOW(),
  NOW()
) ON CONFLICT (provider, provider_id) DO NOTHING;

-- Insert profile for test user (admin role for full access)
INSERT INTO public.profiles (id, email, display_name, role)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'walter.bates@mail.com',
  'Walter Bates',
  'admin'
) ON CONFLICT (id) DO NOTHING;

-- ======================
-- RECIPES: Viandes
-- ======================

-- 1. Aiguillettes de canard aux clémentines
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Aiguillettes de canard aux clémentines',
  'aiguillettes-canard-clementines',
  'Délicieuses aiguillettes de canard en papillote avec des clémentines caramélisées au miel et basilic frais.',
  '- 4 échalotes
- 2 cuillères à soupe d''huile d''olive
- 1 poignée de raisins secs
- 1 grosse cuillère à soupe de miel
- 3 grosses aiguillettes de canard (150 g)
- 3 petites clémentines (ou 2 grosses)
- 5 belles feuilles de basilic frais
- Poivre, sel',
  '1. Éplucher et émincer les échalotes, les faire revenir dans une poêle avec l''huile d''olive. Quand elles commencent à se colorer, ajouter les raisins secs puis le miel, laisser caraméliser à feu doux. Éplucher les clémentines, ciseler le basilic.

2. Dresser les papillotes : découper 3 carrés de papier sulfurisé. Sur chacun d''eux, déposer une aiguillette de canard, saler, poivrer. Disposer autour quelques quartiers de clémentine, recouvrir d''échalotes caramélisées et de basilic ciselé.

3. Fermer hermétiquement la papillote (agrafes, ficelle, etc.), et faire cuire au four préchauffé à 200°C (thermostat 6-7) pendant 20 à 25 minutes.

4. Servir chaud, accompagné de riz blanc.',
  20, 25, 3,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 2. Aiguillettes de canard sauce balsamique
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Aiguillettes de canard sauce balsamique',
  'aiguillettes-canard-sauce-balsamique',
  'Aiguillettes de canard fondantes nappées d''une sauce crémeuse au vinaigre balsamique et champignons.',
  '- 300g d''aiguillettes de canard
- 1 échalote
- 2 cuillères à soupe de vinaigre balsamique
- 20 cl de crème fraîche semi-épaisse
- 1 petite boîte de champignons de Paris',
  '1. Faire revenir l''échalote émincée dans un peu d''huile d''olive. Réserver.

2. Dans la même sauteuse, remplacer l''échalote par les aiguillettes de canard. Saler, poivrer et faire dorer. Réserver.

3. Déglacer les sucs avec le vinaigre balsamique puis avec la crème. Laisser un peu épaissir à feu doux.

4. Remettre les échalotes, la viande et ajouter les champignons. Couvrir et cuire 5 minutes complémentaires.',
  15, 20, 3,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 3. Aiguillettes de poulet aux agrumes et estragon
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Aiguillettes de poulet aux agrumes et estragon',
  'aiguillettes-poulet-agrumes-estragon',
  'Aiguillettes de poulet marinées aux agrumes et parfumées à l''estragon, servies avec une sauce crémeuse.',
  '- Aiguillettes de poulet
- Le jus de 2 citrons et 2 oranges
- 3 cuillères à soupe de miel
- 3 cuillères à soupe d''huile d''olive
- Quelques feuilles d''estragon
- 4 cuillères à soupe de crème fraîche',
  '1. Faire mariner le poulet pendant au moins 2 heures avec : les jus, l''huile, le miel et l''estragon.

2. Faire chauffer un peu d''huile d''olive dans une sauteuse et y déposer les aiguillettes de poulet; laisser cuire à feu vif pendant 5 minutes puis ajouter la marinade et laisser réduire.

3. Ajouter la crème et laisser mijoter 5 minutes.',
  15, 15, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 4. Aiguillettes de poulet sauce rhum, miel, citron
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Aiguillettes de poulet sauce rhum, miel, citron',
  'aiguillettes-poulet-rhum-miel-citron',
  'Aiguillettes de poulet nappées d''une sauce exotique au rhum, miel et citron.',
  '- 1 kg d''aiguillettes de poulet
- 10 cl de rhum brun
- 10 cl de jus de citron
- 10 cl de miel
- 20 cl de crème',
  '1. Faites revenir les aiguillettes dans un peu d''huile puis laissez-les cuire. Réservez la viande au chaud.

2. Dans la poêle, versez le rhum, le jus de citron et le miel. Laissez chauffer quelques minutes puis ajoutez la crème. Salez et poivrez selon convenance.

3. Pour avoir une sauce bien onctueuse, on peut ajouter un peu de sauceline.

4. Replacez les aiguillettes dans la poêle et servez.',
  10, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 5. Blanc de poulet et ses légumes, sauce aux carottes (Thermomix)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Blanc de poulet et ses légumes, sauce aux carottes',
  'blanc-poulet-legumes-sauce-carottes-thermomix',
  'Blancs de poulet vapeur accompagnés de brocolis et champignons, nappés d''une sauce onctueuse aux carottes. Recette Thermomix.',
  '- 4 blancs de poulet
- 1 petit oignon
- 200g carottes
- 1 cube bouillon volaille
- 30g de beurre
- 500g eau
- 200g champignons Paris
- 2 càs bombées de maïzena
- 50g crème liquide
- 100g gruyère râpé
- 1 tête de brocoli
- Poivre',
  '1. Mettre l''oignon coupé en 2 et les carottes en tronçons dans le bol et mixer 3sec/V5 ; racler les parois.

2. Ajouter 1/3 du beurre et régler 3min30/Varoma/V1.

3. Ajouter l''eau et le bouillon de poule. Placer les blancs de poulet dans le panier et les champignons au-dessus. Mettre les brocolis dans le varoma.

4. Régler 30min/Varoma/V1.

5. Retirer le panier et le varoma. Ajouter la crème, le poivre, le reste du beurre et la maïzena. Régler 6min/80°/V4.

6. 3 minutes avant la fin, ajouter le gruyère. Mixer la sauce 30sec/V5 si désiré.',
  20, 40, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 6. Blancs de volaille farcis aux pruneaux
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Blancs de volaille farcis aux pruneaux',
  'blancs-volaille-farcis-pruneaux',
  'Roulés de blancs de poulet et poitrine fumée farcis aux pruneaux, cuits à la vapeur. Recette de Mercotte.',
  '- 300g de très fines tranches de poitrine fumée
- 6 gros blancs de poulet
- 20 à 30 pruneaux dénoyautés
- Sel, poivre',
  '1. Couper un grand rectangle de papier film, le poser bien à plat sur le plan de travail.

2. Étaler dessus les tranches de lard, puis recouvrir avec les blancs de volaille finement émincés dans l''épaisseur.

3. Assaisonner de sel et de poivre du moulin et poser 1 rangée de pruneaux au 1/3 de la surface.

4. Rouler en serrant bien, comme pour les sushi, en s''aidant du papier film, pour former un boudin de 5cm de diamètre.

5. Fermer hermétiquement avec le film et cuire à la vapeur 30 minutes.

6. Retirer le film, égoutter, découper en tranches. Servir avec une sauce crème champignons.',
  20, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 7. Colombo de dinde aux petits légumes
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Colombo de dinde aux petits légumes',
  'colombo-dinde-petits-legumes',
  'Escalopes de dinde mijotées aux épices colombo avec carottes, poivron et tomates dans une sauce crémeuse.',
  '- 400 g d''escalopes de dinde
- 2 belles carottes
- 1 poivron jaune
- 2 tomates
- 1 oignon
- 70 ml de vin blanc sec
- 1 cuillère à soupe de Maïzena
- 3 cuillères à soupe de crème fraîche
- 1 bonne cuillère à soupe d''épices à colombo
- 1 brin de thym
- Sel, poivre',
  '1. Préchauffer le four à 180°C.

2. Peler et émincer l''oignon. Peler et tailler les légumes en dés. Les placer au fond d''une cocotte allant au four.

3. Détailler les escalopes de dinde en cubes et les déposer sur les légumes.

4. Dans un bol, délayer la Maïzena dans le vin blanc et la crème. Assaisonner.

5. Arroser le contenu de la cocotte avec cette sauce et déposer le thym.

6. Fermer la cocotte et enfourner pendant 30-35 min.',
  20, 35, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 8. Colombo de porc
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Colombo de porc',
  'colombo-porc',
  'Porc mijoté aux épices colombo avec pommes de terre, carottes et aubergine. Un plat réconfortant aux saveurs antillaises.',
  '- 700 g de porc à mijoter
- 4 pommes de terre
- 4 carottes
- 1 aubergine
- 4 oignons nouveaux
- 50 cl de bouillon de légumes
- 2 cuillères à soupe d''épices pour colombo
- Huile
- Sel, poivre, piment',
  '1. Coupez le porc en morceaux, pelez les pommes de terre et coupez-les en quatre, pelez les carottes et coupez-les en rondelles, coupez l''aubergine en dés.

2. Coupez les oignons nouveaux en quatre, émincez les tiges.

3. Faites chauffer un filet d''huile dans une sauteuse creuse et faites dorer les morceaux de viande.

4. Ajoutez tous les légumes, parsemez d''épices pour colombo, arrosez de bouillon.

5. Laissez cuire à couvert durant 1h30, pour obtenir des morceaux de viande fondants. Ajoutez du bouillon en cours de cuisson si nécessaire.',
  20, 90, 6,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 9. Colombo de poulet
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Colombo de poulet',
  'colombo-poulet',
  'Cuisses de poulet marinées et mijotées aux épices colombo avec pommes de terre. Saveurs des Antilles.',
  '- 4 cuisses de poulet (ou blancs)
- 2 oignons
- 1 gousse d''ail
- 2 cuillères à café de poudre à colombo
- 1 cuillère à soupe de rhum blanc (facultatif)
- 3 pommes de terre moyennes
- Persil frais
- Le jus d''un citron
- Mélange quatre épices
- Sel et poivre',
  '1. Faire mariner le poulet 4-5 heures avec 1 oignon en dés, le rhum, 1 cuillère de colombo, le quatre épices, sel, poivre et jus de citron.

2. Faire dorer le poulet dans une sauteuse, puis le mettre de côté.

3. Faire revenir les oignons et les pommes de terre en dés, ainsi que l''ail haché.

4. Rajouter le poulet, le colombo et le persil haché.

5. Couvrir d''eau et laisser mijoter 10-30 min selon les légumes ajoutés.

6. Servir avec du riz.',
  20, 40, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 10. Cuisses de poulet au citron
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cuisses de poulet au citron',
  'cuisses-poulet-citron',
  'Cuisses de poulet rôties lentement au four avec oignon, citron, thym et romarin, arrosées de miel.',
  '- 4 cuisses de poulet
- 1 gros oignon
- 1 branche de romarin
- 20 brins de thym
- 1 citron bio
- 1 cuillère à soupe de miel
- Huile d''olive
- Sel, poivre',
  '1. Préchauffez le four à 160°C.

2. Épluchez et émincez l''oignon puis faites-le revenir dans une casserole avec de l''huile d''olive et les feuilles de romarin.

3. Dans un plat de cuisson, répartissez l''oignon rissolé puis déposez les cuisses de poulet, les brins de thym et le citron en fines lamelles.

4. Salez, poivrez puis arrosez d''huile d''olive et de miel.

5. Enfournez pour 1h45 en arrosant régulièrement le poulet avec le jus de cuisson.

6. Servez accompagné de pommes de terre et légumes verts.',
  15, 105, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 11. Cuisses de poulet sauce champignons (Thermomix)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cuisses de poulet sauce champignons',
  'cuisses-poulet-sauce-champignons-thermomix',
  'Cuisses de poulet vapeur avec pommes de terre, nappées d''une sauce crémeuse aux champignons. Recette Thermomix.',
  '- 4 cuisses de poulet
- 500 g pommes de terre en bâtons
- 350 g champignons frais de Paris
- 40 cl crème fraîche épaisse 30%
- 400 g eau
- 2 cubes de bouillon
- Sel, poivre
- Herbes de Provence',
  '1. Mettre dans le bol : les champignons, la crème, les cubes de bouillon et l''eau.

2. Déposer les pommes de terre dans le varoma, saler et poivrer.

3. Déposer les cuisses de poulet sur le plateau supérieur du varoma, ajouter les herbes de Provence, sel et poivre.

4. Régler Varoma, 60 min, vitesse 1.

5. Ajuster le temps selon la cuisson des cuisses.

6. Servir en nappant de la sauce champignons.',
  20, 60, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 12. Curry de cuisses de poulet aux pommes
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Curry de cuisses de poulet aux pommes',
  'curry-cuisses-poulet-pommes',
  'Cuisses de poulet au curry avec des pommes et une touche de yaourt pour une sauce onctueuse.',
  '- 4 cuisses de poulet
- 2 cuillères à soupe de poudre de curry
- 200 g de riz basmati
- 1 pomme
- 4 oignons
- 2 yaourts
- 1 citron
- 1 cuillère à soupe de persil ciselé
- 20 g de beurre
- Sel, poivre',
  '1. Épluchez et émincez les oignons. Épluchez la pomme et coupez-la en dés. Prélevez les zestes du citron, blanchissez-les, puis pressez le citron.

2. Faites chauffer l''huile et faites dorer les cuisses de poulet de chaque côté à feu vif. Réservez.

3. Remplacez par le beurre et faites fondre les oignons, les zestes et la pomme à feu doux. Saupoudrez de curry, remettez le poulet, versez le jus de citron, salez et poivrez.

4. Faites cuire à feu doux et à couvert pendant 20 min. Ajoutez les yaourts 5 min avant la fin.

5. Servez avec le riz basmati et parsemez de persil.',
  20, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 13. Dinde au curry
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Dinde au curry',
  'dinde-au-curry',
  'Escalope de dinde mijotée au curry avec tomate fraîche, vin blanc et crème. Simple et savoureux.',
  '- 1 escalope de dinde
- 1 oignon
- 1 belle tomate bien mûre
- 1/2 jus de citron
- 1 verre de vin blanc
- 1 cube de bouillon de volaille
- 2 grosses cuillères à soupe de crème fraîche épaisse
- 1 grosse cuillère à café de curry
- 1 noisette de beurre
- Du riz',
  '1. Faire cuire votre riz et le laisser gonfler.

2. Faire fondre une belle noisette de beurre dans une sauteuse. Y faire revenir l''oignon émincé finement.

3. Ajouter l''escalope de dinde en morceaux. Incorporez les dés de tomate fraîche.

4. Déglacer avec le vin blanc et ajoutez le bouillon de volaille. Laisser revenir 2-3 min.

5. Parfumez avec le curry et bien l''incorporer. Versez le jus de citron, salez et poivrez.

6. Terminez par la crème fraîche. Laissez mijoter quelques minutes.',
  15, 20, 1,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 14. Dinde à l'ananas et à la noix de coco
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Dinde à l''ananas et à la noix de coco',
  'dinde-ananas-noix-coco',
  'Escalopes de dinde aux saveurs exotiques : ananas, noix de coco râpée et rhum. Un voyage culinaire.',
  '- 4 escalopes de dinde
- 1 oignon
- 1 verre de rhum
- 1 cuillère à soupe de farine
- 1 citron vert
- 3 cuillères à soupe de noix de coco râpée
- 1 cube de poule au pot
- 1 boîte d''ananas
- Poivre
- Feuilles de coriandre (facultatif)
- 100 ml de lait de coco (optionnel)',
  '1. Coupez les escalopes en fines lamelles.

2. Pelez et émincez l''oignon. Faites-le fondre à feu doux avec de l''huile d''olive. Ajoutez la viande.

3. Lorsqu''elle est bien dorée, ajoutez le rhum et laissez-le s''évaporer.

4. Ajoutez la farine, le jus de citron, la noix de coco et le bouillon préparé. Poivrez et laissez cuire 20 mn à couvert.

5. 5 minutes avant la fin, ajoutez l''ananas en morceaux et les feuilles de coriandre.

6. Servez chaud avec du riz blanc.',
  15, 25, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 15. Émincé de dinde au curry et à la mangue
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Émincé de dinde au curry et à la mangue',
  'emince-dinde-curry-mangue',
  'Émincé de dinde parfumé au curry, gingembre et curcuma, agrémenté de mangue et ananas.',
  '- 600 g de filet de dinde
- 1 oignon
- 1 gousse d''ail
- 1/2 mangue
- 3 tranches d''ananas
- 1 cuillère à soupe de curry
- 1/2 cuillère à café de gingembre râpé
- 1/2 cuillère à café de curcuma
- 25 cl de bouillon de volaille
- 3 cuillères à soupe de crème (ou lait de coco)
- Sel, poivre
- Huile d''olive',
  '1. Émincez finement les filets de dinde en lamelles. Pelez et émincez l''oignon. Hachez l''ail. Coupez la mangue et l''ananas en cubes.

2. Faites chauffer l''huile d''olive dans une sauteuse. Faites-y dorer la viande. Réservez.

3. Ajoutez de l''huile et faites revenir l''oignon et l''ail avec les épices. Ajoutez la mangue. Versez le bouillon et la crème.

4. Faites réduire quelques instants, puis ajoutez la dinde et l''ananas. Laissez mijoter quelques minutes et servez chaud.',
  20, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 16. Émincé de dinde au saint-marcellin
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Émincé de dinde au saint-marcellin',
  'emince-dinde-saint-marcellin',
  'Émincé de dinde gratiné au saint-marcellin avec pommes de terre vapeur. Gourmand et fondant.',
  '- 25 g de graisse de canard
- 300 g d''escalope ou de filet de dinde
- 1 gousse d''ail
- 1 gros oignon
- 12 cl d''eau
- 6 g de fond de veau déshydraté
- Sel, poivre, noix de muscade
- 200 g de pommes de terre cuites vapeur
- 10 cl de crème liquide
- 100 g de saint-marcellin',
  '1. Faire dorer la viande en lanières dans la graisse de canard. Ajouter l''oignon émincé et l''ail écrasé, puis l''eau et le fond de veau. Saler et poivrer. Cuire 5 bonnes minutes.

2. Dans un plat à four, déposer les pommes de terre en rondelles puis la préparation à la dinde.

3. Napper de crème et saupoudrer de noix de muscade. Éparpiller le fromage en dés.

4. Enfourner sous le gril du four pendant 10 min.

5. Servir bien chaud.',
  15, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 17. Émincé de poulet au Porto
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Émincé de poulet au Porto',
  'emince-poulet-porto',
  'Escalopes de poulet en lamelles avec champignons, déglacées au Porto et nappées de crème.',
  '- 2 escalopes de poulet
- 1 échalote
- 1 petite boîte de champignons entiers
- 2 cuillères à soupe d''huile d''olive
- 5 cl de porto rouge
- 10 cl de crème liquide
- Sel, poivre',
  '1. Verser 1 cuillère à soupe d''huile d''olive dans une poêle et faire dorer les escalopes de poulet en petites lamelles. Saler et poivrer. Réserver.

2. Faire dorer l''échalote dans le reste d''huile et ajouter les champignons égouttés. Laisser revenir puis rajouter le poulet.

3. Verser le porto. Laisser mijoter environ 10 min puis ajouter la crème liquide.

4. Laisser réduire à feu doux. Ajuster l''assaisonnement.

5. Servir bien chaud avec du riz ou des pommes de terre vapeur.',
  10, 20, 2,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 18. Escalopes de poulet gratinées au four (Thermomix)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Escalopes de poulet gratinées au four',
  'escalopes-poulet-gratinees-thermomix',
  'Escalopes de poulet nappées d''une sauce crémeuse au paprika et gratinées au fromage. Recette Thermomix.',
  '- 400 g de filets ou escalopes de poulet
- 150 g d''eau
- 200 g de crème fraîche fluide
- 1 càs d''oignons frits
- 1 càc de bouillon en poudre
- 1 càc de paprika doux
- 1 pincée de poivre de cayenne (facultatif)
- 20 g de farine
- Sel, poivre
- 150 g de fromage (comté)',
  '1. Préchauffez le four à 200°C.

2. Déposez les escalopes dans un plat à gratin, salez, poivrez et mettez du paprika. Versez les oignons frits par-dessus.

3. Dans le bol du Thermomix, râpez le fromage quelques secondes vitesse 7. Réservez.

4. Mettez tous les autres ingrédients et la moitié du fromage dans le bol. Réglez 7 minutes, 100°C, vitesse 3.

5. Versez la sauce sur les escalopes, déposez le reste de fromage râpé.

6. Enfournez environ 30 minutes.',
  15, 40, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 19. Filet mignon de porc à l'avesnoise
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Filet mignon de porc à l''avesnoise',
  'filet-mignon-porc-avesnoise',
  'Filet mignon mariné à la bière et mijoté au maroilles avec pommes reinettes. Spécialité du Nord.',
  '- 800 g de filet mignon de porc
- 0,5 l de bière de garde (type Ch''ti)
- Du maroilles
- 2 pommes reinette
- 3 cuillères à soupe de crème fraîche
- 1 bouquet garni
- 100 g de beurre, huile
- 2 cuillères à soupe de farine
- 50 g d''échalotes
- 600 g de pommes de terre
- Sel, poivre',
  '1. Couper la viande en lamelles de 2 cm et mariner 3 heures avec la bière, le bouquet garni et du sel.

2. Faire cuire les pommes de terre en robe des champs. Les éplucher avec les pommes reinette et couper en quartiers.

3. Dans un faitout, faire colorer beurre et huile. Y plonger les morceaux de viande et saisir 5-6 minutes. Saler, poivrer, ajouter les échalotes hachées.

4. Singer la viande avec la farine. Enlever la croûte du maroilles et le couper en cubes.

5. Faire sauter les pommes de terre et les pommes séparément.

6. Ajouter le maroilles et la crème fraîche au faitout. Laisser mijoter quelques minutes.

7. Dresser les assiettes avec la viande au centre, entourée de pommes de terre et de pommes, nappée de sauce.',
  30, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 20. Filet mignon de porc au cidre (mamie)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Filet mignon de porc au cidre',
  'filet-mignon-porc-cidre-mamie',
  'Filet mignon en tranches avec champignons, sauce au cidre et crème fraîche. Recette de mamie Odile.',
  '- 1 filet mignon d''environ 450 g
- 2 échalotes
- 300 g de champignons de Paris
- 50 cl de cidre brut (ou bière)
- 200 g de crème fraîche épaisse
- 1 jaune d''œuf (facultatif)
- 1 cuillère à soupe de farine
- Sel et poivre
- Persil',
  '1. Détailler le filet mignon en tranches fines.

2. Laver les champignons et les détailler en lamelles.

3. Faire revenir les échalotes hachées et les champignons dans un peu d''huile, sans les laisser griller.

4. Saler et poivrer les tranches de filet mignon, les passer dans la farine. Les faire revenir à feu vif puis cuire 4-5 minutes sur chaque face à feu moyen.

5. Quand les champignons ont pris couleur, ajouter le cidre. Assaisonner et laisser bouillir. Ajouter la crème fraîche et laisser épaissir.

6. Hors du feu, ajouter un jaune d''œuf et du persil. Rectifier l''assaisonnement.

7. Napper la viande avec la sauce. Servir avec des haricots verts.',
  20, 45, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 21. Filet mignon de porc au cidre (Ô délices)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Filet mignon de porc au cidre avec légumes',
  'filet-mignon-porc-cidre-legumes',
  'Filet mignon mijoté au cidre avec carottes, oignons nouveaux et pommes Reines de Reinettes.',
  '- 1 filet mignon de 500 à 600 g
- 60 cl de cidre brut
- 4 carottes (400 g)
- 6 oignons nouveaux
- 2 pommes Reines de Reinettes
- 10 cl de crème
- 1 cuillère à soupe de farine
- Sel, poivre',
  '1. Épluchez et coupez les carottes en cubes. Nettoyez les oignons nouveaux.

2. Faites dorer le filet dans une sauteuse et ajoutez les carottes et les oignons.

3. Saupoudrez de farine, mélangez bien puis versez le cidre. Montez à ébullition et laissez cuire à feu moyen durant 30 min en couvrant à demi.

4. Ajoutez la crème et laissez réduire à feu vif durant 5 à 10 min.

5. Séparément, épluchez et coupez les pommes en cubes. Faites-les sauter au beurre durant 10 min à feu vif.

6. Servez les pommes en accompagnement du porc.',
  20, 45, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 22. Filet mignon de porc au fromage de chèvre
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Filet mignon de porc au fromage de chèvre',
  'filet-mignon-porc-fromage-chevre',
  'Filets mignons farcis au chèvre, bardés de lard, mijotés au vin blanc et crème. Fondant et savoureux.',
  '- 2 filets mignons de porc
- 1 barde de lard
- 200 g de fromage de chèvre en bûche
- 2 cuillères à soupe de paprika
- 2 cuillères à soupe de thym déshydraté
- 1 oignon
- 15 cl d''eau
- 15 cl de vin blanc sec
- 3 cuillères à café de fond de volaille
- 30 cl de crème fraîche épaisse légère
- Huile, beurre
- Sel, poivre
- Ficelle de cuisine',
  '1. Éplucher et ciseler l''oignon. Découper le fromage en tranches épaisses.

2. Préparer les filets : placer les tranches de fromage entre les 2 parties ; mettre la barde et ficeler serré.

3. Préparer un bouillon avec l''eau, le vin blanc et le fond de volaille.

4. Mélanger les épices et y rouler les filets.

5. Faire blondir l''oignon dans un mélange huile et beurre. Faire dorer les filets de chaque côté (5 min) ; saler, poivrer.

6. Ajouter le bouillon chaud, gratter les sucs, et laisser mijoter 20-25 min.

7. Ajouter la crème fraîche, mélanger, mijoter 5 min. Servir avec des tagliatelles fraîches.',
  20, 35, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 23. Filet mignon de porc au maroilles
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Filet mignon de porc au maroilles',
  'filet-mignon-porc-maroilles',
  'Filets mignons mijotés au vin blanc avec une sauce onctueuse au maroilles. Spécialité ch''ti.',
  '- 2 filets mignons de porc
- 10 cl de vin blanc
- 1 oignon
- 50 cl de crème fraîche
- 250 g de maroilles
- Sel et poivre',
  '1. Faire blondir l''oignon haché dans une cocotte ou sauteuse.

2. Ajouter les filets mignons, les faire dorer sur tous les côtés, puis ajouter le vin blanc. Couvrir et laisser cuire 20 minutes.

3. Dans un bol, couper le maroilles en petits morceaux. Ajouter la crème et mélanger.

4. Vérifier la cuisson. Une fois les filets cuits, ajouter la crème et le maroilles. Le fromage va fondre progressivement.

5. Le plat est prêt une fois que la sauce est bien onctueuse.

6. Accompagner de tagliatelles fraîches.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 24. Filet mignon de porc, sauce crème moutardée aux champignons
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Filet mignon sauce crème moutardée aux champignons',
  'filet-mignon-sauce-creme-moutarde-champignons',
  'Filet mignon de porc mijoté dans une sauce crémeuse à la moutarde avec champignons de Paris.',
  '- 800g de filet mignon de porc
- 20cl de vin blanc sec
- 3 cuillères à soupe de moutarde
- 50 cl de crème fraîche
- 1 cuillère d''huile d''olive
- 1 oignon
- 1 grosse gousse d''ail
- 50 g de champignons de Paris par personne
- 1 pincée de romarin',
  '1. Faire fondre l''oignon émincé dans l''huile d''olive sans le faire dorer. Réserver.

2. Faire dorer le filet mignon sur toutes les faces à feu vif.

3. Ajouter un verre d''eau (25cl), l''oignon, l''ail écrasé, le romarin, sel et poivre. Laisser mijoter à couvert 30 minutes à feu doux.

4. Dans un bol, mélanger la moutarde avec le vin blanc jusqu''à obtenir un mélange lisse. Ajouter la crème fraîche.

5. Verser ce mélange dans la casserole. Ajouter les champignons émincés.

6. Laisser mijoter à feu très doux pendant 15 minutes.

7. Servir avec des pâtes au gratin ou un gratin de légumes.',
  20, 50, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 25. Gratin de dinde aux tomates séchées et mozzarella (Thermomix)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Gratin de dinde aux tomates séchées et mozzarella',
  'gratin-dinde-tomates-sechees-mozzarella-thermomix',
  'Escalopes de dinde gratinées avec champignons, tomates séchées, basilic et mozzarella. Recette Thermomix.',
  '- 2 escalopes de dinde
- 150g champignons de Paris
- 1 grosse échalote
- 8 feuilles de basilic
- 1 càs huile olive
- Sel et poivre
- 150g vin blanc (muscadet)
- 40g tomates séchées
- 100g crème liquide
- 1 càc de sucre (facultatif)
- 1 boule de mozzarella',
  '1. Mettre les escalopes dans le panier et les champignons émincés par-dessus.

2. Mettre dans le bol l''échalote et le basilic, mixer 5sec/V5 ; racler.

3. Verser l''huile et régler 4min/Varoma/V1.

4. Ajouter le vin blanc, saler et poivrer, insérer le panier et régler 12min/100°C/V2.

5. Retirer le panier et couper les escalopes en petits morceaux. Mettre dans des plats individuels avec les champignons.

6. Ajouter les tomates séchées, la crème dans le bol et mixer 30sec/V4.

7. Napper la viande de sauce. Ajouter la mozzarella en tranches et gratiner au four.',
  20, 30, 2,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 26. Gratin de pâtes sur lit de poireaux et poulet
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Gratin de pâtes sur lit de poireaux et poulet',
  'gratin-pates-poireaux-poulet',
  'Gratin de pâtes avec poulet et poireaux fondants, gratiné au fromage.',
  '- 250g de pâtes
- 2 blancs de poulet
- 2 poireaux
- 200ml de crème fraîche
- 100g de fromage râpé
- 1 oignon
- Sel, poivre
- Muscade',
  '1. Faire cuire les pâtes al dente. Réserver.

2. Émincer les poireaux et l''oignon. Les faire fondre dans du beurre 15 minutes.

3. Couper le poulet en morceaux et le faire dorer. Ajouter aux poireaux.

4. Ajouter la crème, assaisonner de sel, poivre et muscade.

5. Mélanger avec les pâtes et verser dans un plat à gratin.

6. Couvrir de fromage râpé et gratiner au four à 200°C pendant 15-20 minutes.',
  20, 40, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 27. Papillotes de poulet au bacon et au chèvre
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Papillotes de poulet au bacon et au chèvre',
  'papillotes-poulet-bacon-chevre',
  'Blancs de poulet en papillotes avec bacon croustillant et fromage de chèvre fondant.',
  '- 4 blancs de poulet
- 8 tranches de bacon
- 1 bûche de chèvre
- Herbes de Provence
- Sel, poivre
- Huile d''olive',
  '1. Préchauffer le four à 200°C.

2. Découper 4 grands carrés de papier sulfurisé.

3. Déposer 2 tranches de bacon sur chaque feuille, puis un blanc de poulet.

4. Saler, poivrer, ajouter les herbes de Provence et un filet d''huile d''olive.

5. Déposer des rondelles de chèvre sur chaque blanc.

6. Fermer hermétiquement les papillotes.

7. Enfourner 25-30 minutes.

8. Servir avec une salade verte ou des légumes.',
  15, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 28. Papillotes de poulet aux poireaux
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Papillotes de poulet aux poireaux',
  'papillotes-poulet-poireaux',
  'Blancs de poulet en papillotes sur un lit de poireaux fondants à la crème.',
  '- 4 blancs de poulet
- 4 poireaux
- 20 cl de crème fraîche
- 1 citron
- Sel, poivre
- Ciboulette',
  '1. Préchauffer le four à 180°C.

2. Laver et émincer les poireaux. Les faire fondre à la poêle avec un peu de beurre pendant 10 minutes.

3. Ajouter la crème, le jus de citron, sel et poivre. Laisser réduire 5 minutes.

4. Répartir les poireaux sur 4 feuilles de papier sulfurisé.

5. Déposer un blanc de poulet sur chaque lit de poireaux. Assaisonner.

6. Fermer les papillotes hermétiquement.

7. Enfourner 25-30 minutes.

8. Parsemer de ciboulette avant de servir.',
  20, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 29. Parmentier de canard
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Parmentier de canard',
  'parmentier-canard',
  'Hachis parmentier revisité avec du confit de canard effiloché et une purée onctueuse.',
  '- 2 cuisses de canard confites
- 1 kg de pommes de terre
- 50 cl de lait
- 50 g de beurre
- 2 oignons
- 2 gousses d''ail
- Persil
- Sel, poivre
- Fromage râpé',
  '1. Faire cuire les pommes de terre à l''eau salée. Les écraser en purée avec le lait chaud et le beurre. Assaisonner.

2. Effilocher la chair des cuisses de canard confites.

3. Faire revenir les oignons émincés et l''ail haché. Ajouter le canard effiloché et le persil.

4. Dans un plat à gratin, disposer une couche de canard, puis une couche de purée.

5. Saupoudrer de fromage râpé.

6. Enfourner à 200°C pendant 20-25 minutes jusqu''à ce que le dessus soit doré.',
  30, 25, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 30. Paupiettes de dinde au bacon
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Paupiettes de dinde au bacon',
  'paupiettes-dinde-bacon',
  'Paupiettes de dinde enroulées de bacon, mijotées dans une sauce crémeuse aux champignons.',
  '- 4 paupiettes de dinde
- 8 tranches de bacon
- 250 g de champignons
- 1 oignon
- 20 cl de vin blanc
- 20 cl de crème fraîche
- Thym
- Sel, poivre',
  '1. Enrouler chaque paupiette de 2 tranches de bacon.

2. Les faire dorer dans une cocotte avec un peu d''huile. Réserver.

3. Faire revenir l''oignon émincé et les champignons.

4. Remettre les paupiettes, ajouter le vin blanc et le thym.

5. Couvrir et laisser mijoter 30 minutes.

6. Ajouter la crème fraîche, laisser épaissir 5 minutes.

7. Servir avec du riz ou des pâtes.',
  15, 40, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 31. Petites cocottes feuilletées au poulet
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Petites cocottes feuilletées au poulet',
  'petites-cocottes-feuilletees-poulet',
  'Cocottes individuelles de poulet crémeux aux champignons, recouvertes d''un chapeau de pâte feuilletée dorée.',
  '- 400 g de blancs de poulet
- 200 g de champignons
- 1 oignon
- 30 cl de crème fraîche
- 1 pâte feuilletée
- 1 jaune d''œuf
- Thym
- Sel, poivre',
  '1. Préchauffer le four à 200°C.

2. Couper le poulet en dés et le faire dorer. Réserver.

3. Faire revenir l''oignon émincé et les champignons.

4. Ajouter le poulet, la crème et le thym. Assaisonner. Laisser mijoter 10 minutes.

5. Répartir dans 4 petites cocottes individuelles.

6. Découper des cercles de pâte feuilletée et couvrir chaque cocotte. Badigeonner de jaune d''œuf.

7. Enfourner 15-20 minutes jusqu''à ce que la pâte soit dorée.',
  25, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 32. Piccata romana (Thermomix)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Piccata romana',
  'piccata-romana-thermomix',
  'Escalopes de veau panées à la romaine, servies avec une sauce au citron. Recette Thermomix.',
  '- 4 escalopes de veau fines
- 100 g de parmesan râpé
- 2 œufs
- Farine
- Chapelure
- 2 citrons
- Beurre
- Sel, poivre',
  '1. Battre les œufs avec le parmesan.

2. Passer les escalopes dans la farine, puis dans le mélange œufs-parmesan, puis dans la chapelure.

3. Faire fondre le beurre dans une poêle et cuire les escalopes 3-4 minutes de chaque côté.

4. Presser les citrons et verser le jus sur les escalopes en fin de cuisson.

5. Servir immédiatement avec des pâtes ou une salade.',
  15, 10, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 33. Rosace de volaille aux morilles
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rosace de volaille aux morilles',
  'rosace-volaille-morilles',
  'Blancs de poulet en rosace accompagnés d''une sauce crémeuse aux morilles. Plat festif et élégant.',
  '- 4 blancs de poulet
- 30 g de morilles séchées
- 30 cl de crème fraîche
- 20 cl de vin blanc
- 2 échalotes
- 50 g de beurre
- Sel, poivre',
  '1. Faire tremper les morilles dans de l''eau tiède pendant 30 minutes. Les égoutter et les rincer.

2. Faire revenir les échalotes émincées dans le beurre. Ajouter les morilles et le vin blanc. Laisser réduire de moitié.

3. Ajouter la crème et laisser mijoter 10 minutes. Assaisonner.

4. Pendant ce temps, cuire les blancs de poulet à la poêle ou au four.

5. Trancher les blancs en fines escalopes et les disposer en rosace sur les assiettes.

6. Napper de sauce aux morilles et servir.',
  20, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 34. Rôti de magret aux fruits
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rôti de magret aux fruits',
  'roti-magret-fruits',
  'Rôti de magrets de canard farci aux fruits secs, caramélisé au miel. Idéal pour les fêtes.',
  '- 2 magrets de canard
- 100 g de pruneaux
- 100 g d''abricots secs
- 50 g de noix
- 3 cuillères à soupe de miel
- 1 orange (jus et zestes)
- Sel, poivre
- Ficelle de cuisine',
  '1. Préchauffer le four à 180°C.

2. Quadriller la peau des magrets sans percer la chair.

3. Hacher grossièrement les fruits secs et les noix.

4. Superposer les 2 magrets, côté chair, avec les fruits au milieu. Ficeler pour former un rôti.

5. Faire dorer le rôti côté peau dans une poêle chaude.

6. Placer dans un plat, arroser de miel et de jus d''orange.

7. Enfourner 25-30 minutes en arrosant régulièrement.

8. Laisser reposer 5 minutes avant de trancher.',
  25, 35, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 35. Roulades de poulet au jambon cru et boursin
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Roulades de poulet au jambon cru et boursin',
  'roulades-poulet-jambon-cru-boursin',
  'Escalopes de poulet farcies au boursin et enroulées dans du jambon cru. Simple et délicieux.',
  '- 4 escalopes de poulet
- 4 tranches de jambon cru
- 1 boursin ail et fines herbes
- Sel, poivre
- Cure-dents',
  '1. Préchauffer le four à 180°C.

2. Aplatir légèrement les escalopes de poulet.

3. Tartiner chaque escalope de boursin.

4. Rouler chaque escalope et l''entourer d''une tranche de jambon cru. Maintenir avec un cure-dent.

5. Disposer dans un plat allant au four.

6. Enfourner 25-30 minutes.

7. Servir avec une salade verte ou des légumes grillés.',
  15, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 36. Sauté de porc à la normande
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sauté de porc à la normande',
  'saute-porc-normande',
  'Sauté de porc aux pommes et au cidre, parfumé au calvados. Une recette traditionnelle normande.',
  '- 600 g de sauté de porc
- 2 pommes
- 1 oignon
- 30 cl de cidre
- 20 cl de crème fraîche
- 2 cl de calvados (facultatif)
- Thym
- Sel, poivre',
  '1. Faire dorer les morceaux de porc dans une cocotte. Réserver.

2. Faire revenir l''oignon émincé.

3. Remettre la viande, ajouter le cidre et le thym. Couvrir et mijoter 45 minutes.

4. Éplucher les pommes, les couper en quartiers et les faire dorer au beurre.

5. Ajouter les pommes et la crème à la cocotte. Flamber au calvados si désiré.

6. Laisser mijoter encore 10 minutes.

7. Servir avec du riz ou des pommes de terre.',
  20, 60, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 37. Sauté de porc au caramel
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sauté de porc au caramel',
  'saute-porc-caramel',
  'Sauté de porc laqué au caramel de sauce soja. Une touche asiatique fondante et savoureuse.',
  '- 500 g de sauté de porc
- 3 cuillères à soupe de sucre
- 3 cuillères à soupe de sauce soja
- 2 cuillères à soupe de nuoc-mâm
- 2 gousses d''ail
- 1 oignon
- Poivre',
  '1. Faire un caramel à sec avec le sucre dans une cocotte.

2. Ajouter la sauce soja et le nuoc-mâm. Attention aux projections.

3. Ajouter l''ail émincé et l''oignon en lamelles.

4. Ajouter les morceaux de porc et bien les enrober.

5. Ajouter un peu d''eau si nécessaire, couvrir et laisser mijoter 45 minutes à feu doux.

6. Poivrer et servir avec du riz blanc.',
  15, 50, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 38. Sauté de porc au caramel (recette chinoise)
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sauté de porc au caramel chinois',
  'saute-porc-caramel-chinois',
  'Porc caramélisé à la chinoise avec gingembre et sauce soja. Authentique et parfumé.',
  '- 500 g de poitrine de porc
- 100 g de sucre
- 4 cuillères à soupe de sauce soja
- 2 cuillères à soupe de vin de riz (ou xérès)
- 1 morceau de gingembre frais
- 2 anis étoilés
- 1 bâton de cannelle
- 2 gousses d''ail',
  '1. Couper le porc en cubes. Le blanchir 2 minutes à l''eau bouillante. Égoutter.

2. Faire un caramel avec le sucre et 2 cuillères à soupe d''eau.

3. Ajouter le porc et bien l''enrober de caramel.

4. Ajouter le gingembre émincé, l''ail, l''anis, la cannelle, la sauce soja et le vin de riz.

5. Couvrir d''eau à hauteur et laisser mijoter 1h à feu doux.

6. En fin de cuisson, augmenter le feu pour faire réduire et glacer la viande.

7. Servir avec du riz.',
  20, 70, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 39. Sauté de veau au citron vert
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sauté de veau au citron vert',
  'saute-veau-citron-vert',
  'Sauté de veau parfumé au citron vert avec une sauce crémeuse. Frais et raffiné.',
  '- 600 g de sauté de veau
- 2 citrons verts
- 1 oignon
- 20 cl de vin blanc
- 20 cl de crème fraîche
- 2 cuillères à soupe d''huile d''olive
- Sel, poivre
- Coriandre fraîche',
  '1. Faire dorer les morceaux de veau dans l''huile d''olive. Réserver.

2. Faire revenir l''oignon émincé.

3. Remettre la viande, déglacer au vin blanc.

4. Ajouter le jus d''un citron vert et les zestes. Couvrir et mijoter 45 minutes.

5. Ajouter la crème et le jus du second citron. Laisser épaissir 5 minutes.

6. Parsemer de coriandre fraîche et servir.',
  15, 55, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 40. Sauté de veau aux agrumes et au miel
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sauté de veau aux agrumes et au miel',
  'saute-veau-agrumes-miel',
  'Sauté de veau caramélisé au miel et parfumé aux agrumes. Un plat sucré-salé délicieux.',
  '- 600 g de sauté de veau
- 2 oranges
- 1 citron
- 3 cuillères à soupe de miel
- 1 oignon
- 20 cl de bouillon de volaille
- Thym
- Sel, poivre',
  '1. Faire dorer les morceaux de veau. Réserver.

2. Faire revenir l''oignon émincé avec le miel jusqu''à caramélisation.

3. Remettre la viande, ajouter le jus des agrumes, les zestes et le bouillon.

4. Ajouter le thym, couvrir et mijoter 50 minutes.

5. En fin de cuisson, faire réduire la sauce si nécessaire.

6. Servir avec de la semoule ou du riz.',
  15, 55, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 41. Sot l'y laisse crème, champignons, lardons
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sot l''y laisse crème, champignons, lardons',
  'sot-ly-laisse-creme-champignons-lardons',
  'Sot l''y laisse de dinde mijotés avec champignons, lardons et crème. Un morceau méconnu et savoureux.',
  '- 500 g de sot l''y laisse de dinde
- 200 g de champignons
- 150 g de lardons
- 1 oignon
- 25 cl de crème fraîche
- 10 cl de vin blanc
- Persil
- Sel, poivre',
  '1. Faire revenir les lardons dans une poêle. Réserver.

2. Faire dorer les sot l''y laisse de tous côtés. Réserver.

3. Faire revenir l''oignon émincé et les champignons.

4. Remettre les lardons et la viande. Déglacer au vin blanc.

5. Ajouter la crème, couvrir et mijoter 20-25 minutes.

6. Parsemer de persil et servir avec des tagliatelles ou du riz.',
  15, 30, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- 42. Tajine de veau aux oignons, miel et safran
INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tajine de veau aux oignons, miel et safran',
  'tajine-veau-oignons-miel-safran',
  'Tajine de veau sucré-salé avec oignons caramélisés, miel et safran. Parfums du Maroc.',
  '- 800 g de sauté de veau
- 500 g d''oignons
- 3 cuillères à soupe de miel
- 1 dose de safran
- 1 cuillère à café de cannelle
- 100 g de raisins secs
- 50 g d''amandes effilées
- 2 cuillères à soupe d''huile d''olive
- Sel, poivre
- Coriandre fraîche',
  '1. Faire dorer la viande dans l''huile. Réserver.

2. Faire revenir les oignons émincés à feu doux jusqu''à ce qu''ils soient fondants (20 min).

3. Remettre la viande, ajouter le safran dilué dans un peu d''eau chaude, la cannelle, sel et poivre.

4. Couvrir d''eau à hauteur et mijoter 1h.

5. Ajouter le miel et les raisins secs. Poursuivre la cuisson 15 minutes.

6. Faire griller les amandes à sec.

7. Servir garni d''amandes et de coriandre, avec de la semoule.',
  20, 95, 4,
  (SELECT id FROM public.categories WHERE slug = 'main')
) ON CONFLICT (slug) DO NOTHING;

-- ======================
-- RECIPE TAGS
-- ======================

-- Tags pour les recettes festives et familiales
INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'aiguillettes-canard-clementines' AND t.slug IN ('festive', 'family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'blancs-volaille-farcis-pruneaux' AND t.slug IN ('festive')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'rosace-volaille-morilles' AND t.slug IN ('festive')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'roti-magret-fruits' AND t.slug IN ('festive')
ON CONFLICT DO NOTHING;

-- Tags pour les recettes rapides
INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'aiguillettes-poulet-rhum-miel-citron' AND t.slug IN ('quick', 'exotic')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'emince-poulet-porto' AND t.slug IN ('quick')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'dinde-au-curry' AND t.slug IN ('quick')
ON CONFLICT DO NOTHING;

-- Tags pour les recettes exotiques
INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'colombo-dinde-petits-legumes' AND t.slug IN ('exotic', 'family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'colombo-porc' AND t.slug IN ('exotic', 'family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'colombo-poulet' AND t.slug IN ('exotic', 'family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'dinde-ananas-noix-coco' AND t.slug IN ('exotic')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'emince-dinde-curry-mangue' AND t.slug IN ('exotic')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'saute-porc-caramel' AND t.slug IN ('exotic')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'saute-porc-caramel-chinois' AND t.slug IN ('exotic')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'tajine-veau-oignons-miel-safran' AND t.slug IN ('exotic', 'festive')
ON CONFLICT DO NOTHING;

-- Tags pour les recettes Thermomix
INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'blanc-poulet-legumes-sauce-carottes-thermomix' AND t.slug IN ('thermomix', 'family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'cuisses-poulet-sauce-champignons-thermomix' AND t.slug IN ('thermomix', 'family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'escalopes-poulet-gratinees-thermomix' AND t.slug IN ('thermomix', 'family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'gratin-dinde-tomates-sechees-mozzarella-thermomix' AND t.slug IN ('thermomix')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'piccata-romana-thermomix' AND t.slug IN ('thermomix', 'quick')
ON CONFLICT DO NOTHING;

-- Tags pour les recettes familiales
INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'cuisses-poulet-citron' AND t.slug IN ('family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'curry-cuisses-poulet-pommes' AND t.slug IN ('family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'filet-mignon-porc-cidre-mamie' AND t.slug IN ('family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'gratin-pates-poireaux-poulet' AND t.slug IN ('family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'parmentier-canard' AND t.slug IN ('family')
ON CONFLICT DO NOTHING;

INSERT INTO public.recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id FROM public.recipes r, public.tags t
WHERE r.slug = 'saute-porc-normande' AND t.slug IN ('family')
ON CONFLICT DO NOTHING;
-- ======================
-- RECIPES: Desserts, Apéritifs, Entrées
-- Generated from recipe documents
-- ======================

-- Desserts (95 recipes)

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bavarois au citron',
  'bavarois-au-citron',
  'Délicieuse recette de dessert.',
  'Pour la déco :
du chocolat fondu
le zeste d''un citron
La mousse au citron :',
  'Mettre la crème dans le bol du robot, puis la monter en chantilly avec la moitié du sucre (30g). Une fois la crème montée en chantilly, incorporer le fromage blanc.
Pendant ce temps là, faire ramollir les 2 feuilles de gélatine dans un bol d''eau froide.

Faire chauffer la moitié du jus de citron avec l''autre moitié de sucre (30g). Une fois le jus de citron chaud, essorer les feuilles de gélatine puis les faire diluer dans ce jus. Retirer du feu et mélanger avec l''autre moitié de jus de citron (non chauffé). Laisser refroidir (à température ambiante).

Incorporer ce jus de citron tiède (presque froid) dans le mélange chantilly/fromage blanc et réserver cette mousse au frais.

Mixer les biscuits pour les réduire en poudre, les verser dans un bol puis y ajouter le cacao en poudre et le beurre mou, mélanger pour obtenir un mélange sablé. Répartir ce mélange dans 4 cercles individuels, bien tasser à l''aide du poussoir.
Verser la mousse au citron par dessus puis placer au frais pendant 3 heures.

le miroir au citron :
Faire chauffer la moitié du jus de citron avec le sucre, y faire diluer la demi feuille de gélatine (préalablement ramollie dans de l''eau froide pendant 5 minutes et essorée).
Retirer du feu et ajouter le jus de citron restant et 2 gouttes de colorant jaune (pour accentuer la couleur du citron).
Laisser bien tiédir avant de verser une fine couche au dessus des bavarois mis au frais.

Remettre au frais pendant au moins encore une heure avant de servir.

Pour faciliter le démoulage, il suffit de passer une lame de couteau autour des petits cercles et avant de les retirer ou de pousser les bavarois vers le haut à l''aide du poussoir !

Pour la décoration au chocolat, j''ai tout simplement dessiné des traits de chocolat fondu sur une bande de rhodoïd
Je les ai mis ensuite au frais, il faut laisser le chocolat figer avant de décoller le rhodoïd, il suffit ensuite de découper le chocolat à la taille voulue pour décorer vos bavarois...',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bavarois caramel sur praliné feuilleté',
  'bavarois-caramel-sur-praline-feuillete',
  'Délicieuse recette de dessert.',
  'Pour un moule 27x35   (28x18)
Craquant :
420g de pralinoise  (210g)
170 de crêpes dentelle émiettées  (85g)
Mousse pommes :
700g de compote  (350g)
4 feuilles de gélatine  (2)
20 cl de crème fleurette  (10cl)
6-8 pommes cuites caramélisées
Mousse caramel au beurre salé :
340g de sucre  (170g)
200g de beurre salé  (100g)
8 feuilles de gélatine  (4)
100cl de crème fleurette  (50cl)
Versez la mousse au caramel sur la mousse aux pommes puis placez au réfrigérateur.',
  'Faites fondre la pralinoise au bain-marie. Ajoutez les crêpes. Mélangez et garnissez le moule chemisé de rhodoïd. Placez au réfrigérateur pour qu’il durcisse.
Faites ramollir la feuille de gélatine dans de l’eau froide.  Chauffez 3-4 cuillers de liqueur à la pomme (ou d’eau) et faites dissoudre la gélatine dedans. Mélangez à la compote. Montez la crème en chantilly et mélangez à la compote.
Sur le craquant refroidi, versez la mousse de pommes, des morceaux de pommes caramélisées et le reste de la mousse. Placez au réfrigérateur.
Faites ramollir la gélatine dans un bol d’eau froide. Faites bouillir dans une casserole 25 cl de crème. Versez le sucre dans une casserole avec le beurre salé et faites-le chauffer jusqu’à l’obtention d’un caramel. Ajoutez petit à petit la crème liquide bouillante et mélangez au fouet. Essorez la gélatine et ajoutez-la dans le caramel en fouettant.
Pendant que le caramel refroidit, montez les 75 cl de crème restants en chantilly. Mélangez délicatement le caramel et la chantilly.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bavarois poire chocolat sur craquant speculoos',
  'bavarois-poire-chocolat-sur-craquant-speculoos',
  'Délicieuse recette de dessert.',
  '(Lilie Bakery)
https://liliebakery.fr/bavarois-poire-chocolat-craquant-speculoos/
Base speculoos : 120g beurre doux fondu	180g
300g speculoos		450g
Mousse au chocolat : 300g chocolat noir pâtissier		400g
90g beurre doux			120g
3 jaunes d’œufs				4
50g sucre glace				65g
40cl crème liquide entière		53cl
2 cc sucre en poudre			2,5
Mousse poire : 35cl crème liquide entière		70cl
100g sucre glace			200g
300g purée de poires			600g
4 feuilles de gélatine			8
Gelée de poire : 2 feuilles de gélatine			4
200g purée de poires			400g
Décor chocolat : 100g chocolat noir pâtissier',
  'Base
Mélanger le beurre fondu aux speculoos en miettes. Tasser la pâte obtenue (comparable à du sable) dans le fond d’un moule rond à charnière de 220cm de diamètre puis mettre au frais.
Mousse chocolat
Faire fondre le chocolat noir et le beurre au bain marie. Battre les jaunes d’œufs et le sucre glace jusqu’à blanchiment.
Battre en chantilly la crème liquide entière avec le sucre en poudre.
Mélanger au fouet le chocolat fondu et les jaunes d’œufs, ajouter délicatement la chantilly. Couler dans le fond du moule sur la base biscuitée. Remettre au frais pour 1h minimum.
Mousse poire
Monter la crème liquide entière en chantilly avec le sucre glace.
Chauffer 200g de purée de poires (on peut prendre des poires au sirop et les mixer ou faire cuire des poires fraîches) et y faire fondre les feuilles de gélatine préalablement ramollies dans l’eau froide. Ajouter 400g de purée de poires et bien mélanger.
Gelée de poire
Faire ramollir les feuilles de gélatine dans l’eau froide.
Chauffer 200g de purée de poires. Y faire fondre la gélatine. Incorporer à nouveau 200g de purée de poires. Bien mélanger. Laisser tiédir puis verser délicatement sur le dessus du bavarois.
Décor chocolat
Faire fondre du chocolat noir pâtissier au bain marie puis déposer une fine couche de chocolat sur une bande rhodoïd. Il suffit ensuite de plier cette bande pour que le chocolat prenne forme en refroidissant. (cf. boucles en chocolat sur photo). Décoller délicatement avant de déposer sur le dessus du bavarois.
Garder le bavarois plusieurs heures au frais avant dégustation.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bavarois à la fraise',
  'bavarois-a-la-fraise',
  'Délicieuse recette de dessert.',
  'Pour un gâteau (27x37)
Génoise :
4 œufs
100g de sucre
100g de farine',
  'Etalez sur une plaque et faites cuire 15 min th 180°C.
Laissez tiédir puis démoulez. Sur une plaque, déposez la génoise et installez le moule emporte-pièces garni de film à chemiser pour un démoulage plus facile.
Mousse à la fraise :
900g de coulis de fraises
65cl de crème liquide 30%
8 feuilles de gélatine
10 cl de sirop de canne (facultatif selon le taux de sucre du coulis)
Faites ramollir les feuilles de gélatine dans un bol d’eau froide puis faites-les dissoudre dans le sirop de canne bouillant (ou dans de l’eau si les fruits sont déjà suffisamment sucrés). Ajoutez-les ensuite au coulis de fraises en mélangeant bien pour éviter les grumeaux.
Montez la crème en chantilly bien ferme puis ajoutez-la délicatement au coulis de fraises. Versez ensuite dans le moule emporte-pièces et lissez la surface. Mettre au réfrigérateur.
Miroir aux fraises :
300g de coulis de fraises
3 feuilles de gélatine
un peu d’eau
Faites ramollir les feuilles de gélatine dans un bol d’eau froide puis faites-les dissoudre dans un peu d’eau bouillante. Ajoutez-les ensuite au coulis de fraises en mélangeant bien pour éviter les grumeaux. Versez ce mélange sur le gâteau lorsque la mousse aux fraises est prise.
Avant de servir, retirez le moule emporte-pièces et décorez selon vos envies…',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bavarois à la framboise',
  'bavarois-a-la-framboise',
  'Délicieuse recette de dessert.',
  'Pour un gâteau (27x37)
Génoise :
4 œufs
100g de sucre
100g de farine',
  'Etalez sur une plaque et faites cuire 15 min th 180°C.
Laissez tiédir puis démoulez. Sur une plaque, déposez la génoise et installez le moule emporte-pièces garni de film à chemiser pour un démoulage plus facile.
Mousse à la framboise :
900g de coulis de framboises
65cl de crème liquide 30%
9-10 feuilles de gélatine
300g de sucre
Faites ramollir les feuilles de gélatine dans un bol d’eau froide puis faites-les dissoudre dans de l’eau ou sucre liquide bouillant. Ajoutez-les ensuite au coulis de framboises en mélangeant bien pour éviter les grumeaux.
Montez la crème en chantilly bien ferme puis ajoutez-la délicatement au coulis de framboises. Versez ensuite dans le moule emporte-pièces et lissez la surface. Mettre au réfrigérateur.
Miroir aux framboises :
300g de coulis de framboises
3 feuilles de gélatine
100g de sucre
un peu d’eau
Faites ramollir les feuilles de gélatine dans un bol d’eau froide puis faites-les dissoudre dans un peu d’eau bouillante. Ajoutez-les ensuite au coulis de framboises en mélangeant bien pour éviter les grumeaux. Versez ce mélange sur le gâteau lorsque la mousse aux framboises est prise.
Avant de servir, retirez le moule emporte-pièces et décorez selon vos envies…',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Brioche',
  'brioche',
  'Délicieuse recette de dessert.',
  'Pour 3 brioches (moules alu 1l) :
500g farine
20g levure
5 œufs (environ 250g)
8 cl lait
210g beurre
75g sucre
1 cuiller à café sel
Mettre le lait, la levure et le sucre dans le bol du thermomix. Mélanger 5 min, 37°, vitesse 2
Ajouter les œufs et la farine. Mélanger 5 min, épi.
Ajouter le beurre coupé en morceaux et le sel. Mélanger 10 min, épi.
Dégazer puis former 9 pâtons. Mettre 3 pâtons dans chaque moule beurré et fariné.
Sortir du four et attendre un peu avant de déguster…',
  'Laisser pousser environ 2 heures (selon la température de la pièce) dans un saladier recouvert d’un torchon.
Laisser pousser de nouveau sous un torchon. Lorsque la pâte arrive au niveau du bord supérieur du moule, badigeonner de lait avec un pinceau puis faire cuire 20 minutes environ (selon le four) dans un four préchauffé à 180°. (cuisson chaleur traditionnelle, pas de chaleur tournante…)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Brownies choco-caramel',
  'brownies-choco-caramel',
  'Délicieuse recette de dessert.',
  '(Cyril Lignac)',
  'Temps de cuisson : 15 minutes
Pour 6 personnes :
100g de noix concassées
12 carrés de chocolat blanc
10 caramels mous au beurre salé
120g de chocolat noir
120g de beurre
120g de sucre
2 œufs
60g de farine
Préchauffer le four à 180°.
Mélanger les noix concassées, le chocolat blanc coupé grossièrement et les caramels également coupés en gros morceaux.
Faire fondre le chocolat noir et le beurre au bain-marie.
Dans un récipient, fouetter le sucre avec les œufs. Ajouter ensuite le chocolat fondu puis la farine. Mélanger. Ajouter enfin le mélange noix-chocolat blanc-caramels mous.
Mettre cette pâte dans des petits moules silicones et enfourner 15 minutes (voir plus selon la taille de vos moules).
Sortir, laisser refroidir et démouler.
Déguster.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Brownies de Julie Andrieu',
  'brownies-de-julie-andrieu',
  'Délicieuse recette de dessert.',
  '(Le cahier gourmand de Sophie)
http://sophie.over-blog.com/article-brownies-de-julie-andrieu-le-meilleur--42885607.html',
  '3 œufs
200 g de chocolat
200 g de sucre (120 g)
80 g de farine
200 g de beurre (150 g de beurre 41%)
1 cc de vanille
50 g de noix

Faire fondre le chocolat et le beurre.
Fouetter les œufs et le sucre.
Ajouter la vanille et la farine tamisée.
Incorporer le chocolat aux œufs.
Mettre dans un moule beurré de 20 cm et enfourner 20 min à 200°C.
Astuce : plonger le plat dans un bain d''eau froide à la sortie du four pour avoir un brownie avec une croûte croustillante et un intérieur fondant.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Charlotte au citron (livre Flo)',
  'charlotte-au-citron-livre-flo',
  'Délicieuse recette de dessert.',
  'Charlotte au citron
(Végétarien et gourmand Marmiton, livre Flo)
2 citrons
3 œufs
75g de sucre
250g de mascarpone
1g d’agar-agar
1càs de rhum',
  'Pressez les citrons. Placez le jus de citron dans une casserole, faites-le chauffer. Ajoutez l’agar-agar et laissez bouillir 1 minute en remuant. Laissez refroidir un peu.
Séparez les blancs des jaunes d’œufs. Dans un saladier, battez les jaunes avec le sucre jusqu’à ce que le mélange blanchisse. Incorporez le mascarpone et le jus de citron.
Dans un bol, mélangez 6 càs d’eau avec le rhum. Faites tremper légèrement les biscuits dans le mélange eau-rhum. Tapissez un moule à charlotte de film alimentaire en le faisant largement déborder. Tapissez le moule (le fond et la paroi) avec les biscuits imbibés, côté bombé vers l’extérieur.
Versez la mousse au citron dans le moule, recouvrez de biscuits trempés.
Placez au moins 4 heures au frais.
Conseil : on peut ajouter le zeste d’un citron dans la mousse et faire un mélange limoncello, jus de citron et eau pour tremper les biscuits.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cheesecake poires speculoos (Inès)',
  'cheesecake-poires-speculoos-ines',
  'Délicieuse recette de dessert.',
  'Cheesecake poires/spéculoos
– Pour la base :
200g de spéculoos
100g de beurre
– Pour l’appareil à cheesecake :
7g de gélatine en feuilles
12cl de lait
1 jaune d’œuf
120g de sucre
300g de philadelphia
300g de crème liquide à 30% de matière grasse
5 poires
La base du cheesecake
1. Émiettez-les spécules.
2. Faites fondre le beurre. Versez les miettes et le beurre fondu dans un saladier et mélangez.
3. Placez le cercle de diamètre 24 cm sur une plaque type plaque de cuisson pouvant aller au réfrigérateur.
Versez un peu de sablé/beurre dans le fond de chaque cercle et tassez à l’aide d’un poussoir et à défaut à l’aide du dos d’une cuillère.
L’appareil à cheesecake
1. Placez la gélatine dans un bol d’eau froide.
2. Versez le lait dans une casserole et portez-le à ébullition.
3. Pendant ce temps fouettez ensemble le jaune d’œuf et 30g de sucre jusqu’à ce que le mélange blanchisse.
4. Versez le lait bouillant sur le mélange jaune d’œuf/sucre tout en fouettant. Reversez le mélange dans la casserole et faites chauffer sur feu moyen jusqu’à ce que le mélange épaississe sans jamais cesser de fouetter.
5. Coupez la cuisson et ajoutez les 90g de sucre restant et la gélatine essorée. Mélangez.
6. Laissez refroidir un peu. Versez dans un grand saladier puis ajoutez le philadelphia. Fouettez bien le mélange.
7. Placez la crème liquide et les fouets 15 minutes au congélateur. Lorsque la crème est bien froide, versez la dans le bol du robot et fouettez-la pour obtenir une crème fouettée bien ferme.
8. Incorporez délicatement à l’aide d’une maryse la crème fouettée au mélange à base de philadelphia.
9. Lavez, épluchez et évidez les poires. Réservez-en une entière pour la décoration du dessus des cheesecakes. Coupez le reste en dés.
10. Recouvrez la base du cheesecake de dés de poires.',
  '12. Placez des lanières de poires sur le cheesecake et émiettez des spéculoos.
13. Réservez au réfrigérateur au moins 3 heures, voir toute une nuit. Au moment du service, décerclez en faisant glisser la lame d’un couteau tout le long du cheesecake.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Clafoutis à la rhubarbe',
  'clafoutis-a-la-rhubarbe',
  'Délicieuse recette de dessert.',
  '(Marmiton)',
  'Suivre les étapes de la recette.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Craquant au chocolat mousseux',
  'craquant-au-chocolat-mousseux',
  'Délicieuse recette de dessert.',
  '(Journal des femmes)',
  'Pour 12 personnes :
Pour la dacquoise à la noisette :
90 g de noisettes
90 g de sucre glace
40 g de sucre en poudre
4 blancs d''œufs battus en neige
Pour le feuilleté praliné :
100 g de chocolat noir
100 g de Pralinoise (tablette de chocolat de la marque Poulain)
20 g de pralin
18 crêpes dentelles brisées
(vous pouvez utilisez de la pâte pralinée mais dans ce cas, ne rajoutez pas les 40 g de pralin)
Pour la mousse au chocolat :
360 g de chocolat noir (de couverture si possible)
50 cl de crème liquide entière montée en chantilly
10 cl de lait
Dacquoise à la noisette : dans un saladier, mélangez toutes les poudres ensemble. Dans un second saladier, battez les blancs en neige puis incorporez-y les poudres peu à peu tout en soulevant la masse délicatement.
Versez cette pâte en fine couche dans un cercle à pâtisserie de 26 à 28 cm de diamètre (ou un rectangle de 20*23 cm environ ou dans un moule à fond amovible) et faites cuire 10 à 15 minutes à 170°c ou 180°c (thermostat 6). Surveillez le temps de cuisson. 

Feuilleté praliné : faites fondre les chocolats, laissez refroidir un peu et ajoutez-y le pralin et les crêpes dentelles brisées. Mélangez et étalez cette pâte sur la dacquoise refroidie. 

Mousse au chocolat : faites fondre le chocolat.
Montez la crème liquide en chantilly et versez-y le chocolat puis le lait. Fouettez bien le tout et versez la mousse sur le feuilleté praliné. 

Voilà, les trois étages sont montés, il ne reste plus qu''à laisser cet entremets au frais pour la nuit ou pour la journée puis à le décorer avec du cacao amer en poudre.
Pensez à le sortir 1/2 heure à 1 heure avant la dégustation.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Craquant chocolat et poires',
  'craquant-chocolat-et-poires',
  'Délicieuse recette de dessert.',
  'Pour un cadre de 27x35 :
Fond craquant :
420g de pralinoise
170g de gavottes
Mousse chocolat noir :
450g de chocolat noir
900g de crème liquide (30%)
6 jaunes d''œufs
60g de sucre
9 cuil. à soupe d''eau
Poires :
~800g de poires cuites (coupées en dés)
Fond craquant :
Mousse chocolat noir :
Montez la crème en chantilly, réservez au frais.
Faites fondre le chocolat.
Ajoutez la chantilly petit à petit.
Pour la déco, prévoir ¼ poire cuite au sirop par assiette.',
  'Faites fondre au bain marie la pralinoise puis ajoutez les gavottes émiettées. Bien mélangez et étalez dans le fond du cadre. Placez-le au frigo (ou congélateur pour une prise plus rapide).
Pendant ce temps, placez les jaunes d''œufs dans un cul de poule et faites bouillir l''eau et le sucre.
Versez bouillant sur les œufs sans cesser de remuer puis ajoutez le chocolat fondu. Mélangez au batteur.
Versez un peu de mousse au fond du cadre, puis les poires cuites et refroidies. Versez ensuite le reste de mousse.
Enfin, soit vous le mettez au congélateur si vous voulez y mettre un nappage... soit au frigo pour une simple déco avec des copeaux de chocolat par exemple ! (On peut aussi faire des traces avec une fourchette avant de le placer au frais).',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crumble au citron et poires',
  'crumble-au-citron-et-poires',
  'Délicieuse recette de dessert.',
  '(ô délices)
Pour la garniture :
2 gros œufs
80 g de sucre
1 cuillère à café de maïzena
7 cl de jus de citron (environ 1 ½ citron)
3 belles poires
Pour la croûte :
100 g de farine
70 g de beurre mou
50 g de sucre',
  'Suivre les étapes de la recette.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crumble fraises-rhubarbe',
  'crumble-fraises-rhubarbe',
  'Délicieuse recette de dessert.',
  '(Jardin bio Vaillant)
400g de fraises
120g de farine
120g de sucre
120g de beurre mou',
  'Préchauffez le four à 200°C.
Nettoyez la rhubarbe, coupez les branches en tronçons.
Equeutez les fraises, coupez-les en dés.
Mélangez les fruits et ajoutez 2 cuillères à soupe de sucre. Disposez-les dans un plat.
Dans un saladier, mélangez du bout des doigts la farine, le sucre et le beurre mou pour obtenir le crumble. Parsemez-le sur les fruits.
Enfournez pour 30 minutes.
Servez le crumble tiède ou à température ambiante, il sera parfait avec une boule de glace ou de la chantilly.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crumble renversé pommes-caramel (Pasca)',
  'crumble-renverse-pommes-caramel-pasca',
  'Délicieuse recette de dessert.',
  'Crumble renversé pommes-caramel
(Pasca)
8 pommes
Crumble :
60g de beurre mou
60g de sucre (cassonade ou blanc)
70g de farine
Caramel :
100g de beurre
100g de sucre
300mL de crème fraiche épaisse',
  'Pour le crumble :
Mélanger à la main le beurre mou avec le sucre et la farine.
Pour le caramel :
Faire fondre le beurre dans une petite casserole, ajouter le sucre et faites chauffer à feu moyen, en remuant bien, jusqu’à dissolution du sucre. Ajouter la crème fraiche épaisse et faire cuire doucement 1 à 2 minutes, jusqu’à épaississement. Retirer du feu et laisser refroidir 1 minute.
Pour le montage :
Répartir le crumble émietté au fond des verres.
Répartir les pommes sur le crumble.
Répartir le caramel tiède sur les pommes.
Conseil :
Répartir le crumble et les pommes dans les verres avant de faire le caramel afin de pouvoir répartir le caramel encore tiède dans les verres.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crème aux spéculoos',
  'creme-aux-speculoos',
  'Délicieuse recette de dessert.',
  '(Journal des femmes)
Pour 6 personnes : (24 mini-crèmes)
15 cl lait entier
35 cl crème fraiche entière liquide
4 jaunes d’œufs
50 g sucre
50 g pâte de spéculoos
4 spéculoos',
  'Préchauffer le four à 150°.
Chauffer le lait et la crème avec la pâte de spéculoos.
Battre dans un saladier les jaunes d’œufs et le sucre jusqu''à blanchiment.
Verser en filet la crème chaude sur les œufs et bien mélanger.
Verser dans des ramequins allant au bain-marie.
Cuire 1h15 (20 minutes pour les mini-crèmes).
Laisser refroidir et mettre au frais au moins 2h.
A l''aide d''un rouleau à pâtisserie, écraser les spéculoos entre 2 feuilles de papier sulfurisé.
Juste au moment de servir, verser les biscuits émiettés sur les crèmes.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crème brûlée (cahier gourmand de Sophie)',
  'creme-brulee-cahier-gourmand-de-sophie',
  'Délicieuse recette de dessert.',
  'Crèmes brûlées
(Le cahier gourmand de Sophie)
http://sophie.over-blog.com/article-24484442.html',
  'Pour 4 crèmes brûlées :
5 gros jaunes d''œufs (ou 6 petits),
40 cl de crème liquide,
40 g de sucre,
de la vanille
Fouetter les jaunes et le sucre.
Faire chauffer la crème avec la vanille, à feu doux.
Arrêter aux premiers frémissements.
La verser sur les jaunes en fouettant.
Répartir dans les moules.
Mettre au four au bain marie 1h15 à 100°C (ou 30 min à 130°C, sans bain marie)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crème caramel au beurre demi-sel',
  'creme-caramel-au-beurre-demi-sel',
  'Délicieuse recette de dessert.',
  'Crème caramel au beurre demi-sel (Salidou)
(ô délices)
Pour un petit pot à confiture :
100 g de sucre semoule
40 g de beurre demi-sel
20 cl de crème fraîche liquide, entière',
  'Suivre les étapes de la recette.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crèmes brûlées coco citron vert',
  'cremes-brulees-coco-citron-vert',
  'Délicieuse recette de dessert.',
  '(Un déjeuner de soleil)
https://www.undejeunerdesoleil.com/2020/11/creme-brulee-citron-vert-coco.html
4 jaunes d’œufs entre 80 et 100 g
28 cl crème de coco
6 cl lait de coco ou bien pour plus d’onctuosité 34 cl de crème de coco en tout
55 g sucre
2 zestes citron vert non traités
2 càs sucre de canne cassonade pour la caramélisation ou du sucre blanc
Voici donc les proportions pour une personne et un petit ramequin (doublez pour les gourmands, je compte 1,5 œuf par personne…) :
1 jaune d’œuf
15 g de sucre
60 g de crème -- > crème plus dense (on peut aller jusqu’à 90 g -- > crème équilibrée)',
  'Verser cette crème dans des ramequins (dans l’idéal de céramique) à 2 cm environ de hauteur (un peu moins si le ramequin est petit). Enfourner 40 min s’ils sont petits (autour de 8 cm de diamètre) ou 1 h s’il sont plus grands (autour de 12 cm de diamètre). La crème ne doit absolument pas bouillir mais prendre. Elle est prête quand elle est encore légèrement tremblotante à cœur, qu’il s’est formé une sorte de pellicule au-dessus qui fait qu’en effleurant avec le doigt la crème, elle ne s’y attache pas.
Faire refroidir à température ambiante puis mettre au frais pendant au moins 4 heures (elle va encore se raffermir).
Peu avant de servir saupoudrer les crèmes de la moitié du sucre de canne puis passer au chalumeau en ayant soin de bien faire caraméliser le sucre à un endroit avant de passer sur une autre zone. Ajouter le reste de sucre et caraméliser à nouveau avec le chalumeau. Servir de suite.
Variante : vous pouvez remplacer le citron vert par du citron jaune ou du zeste d’orange (le plus parfumé possible ce qui n’est pas toujours le cas) ou bien de l’huile essentielle de mandarine ou de citron ou même de yuzu (en pharmacie, magasin bio ou chez Aroma-zone)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Entremet aux 3 chocolats sur fond craquant',
  'entremet-aux-3-chocolats-sur-fond-craquant',
  'Délicieuse recette de dessert.',
  '(Passion pâtisserie)
http://www.passionpatisserie.fr/article-entremet-aux-3-chocolats-sur-fond-craquant-104222874.html
Pour 10 personnes (cercle de 28 cm de diamètre) :
Fond craquant :
150g de pralinoise
75g de gavottes
Mousse chocolat noir :
150g de chocolat noir
300g de crème liquide (30%)
2 jaunes d''œufs
20g de sucre
3 cuil. à soupe d''eau
Mousse chocolat au lait :					Mousse chocolat blanc :
150g de chocolat au lait					150g de chocolat blanc
300g de crème liquide					300g de crème liquide
2 jaunes d''œufs						2 jaunes d''œufs
20g de sucre						20g de sucre
3 cuil. à soupe d''eau					3 cuil. à soupe d''eau
1 + 1/2 feuilles de gélatine				1 + 1/2 feuilles de gélatine
Fond craquant :
Mousse chocolat noir :
Montez la crème en chantilly, réservez au frais.
Faites fondre le chocolat.
Ajoutez la chantilly petit à petit. Versez dans votre cercle et remettre au congélateur.
Mousse chocolat au lait et blanc :',
  'Faites fondre au bain marie la pralinoise puis ajoutez les gavottes émiettées. Bien mélanger et étaler dans le fond du cercle. Placez-le au congélateur.
Pendant ce temps, placez les jaunes d''œufs dans un cul de poule et faites bouillir l''eau et le sucre.
Versez bouillant sur les œufs sans cesser de remuer puis ajoutez le chocolat fondu. Mélangez au batteur.
Pour ces mousses, procédez de la même manière, sans oublier d''ajouter la gélatine ramollie au mélange œufs/sucre, juste avant d''ajouter le chocolat.
A la fin, soit vous le remettez au congélateur si vous voulez y mettre un nappage... ou au frigo pour une simple déco avec des copeaux de chocolat par exemple !',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Entremet Chocolat et Noix de coco',
  'entremet-chocolat-et-noix-de-coco',
  'Délicieuse recette de dessert.',
  'In Gâteaux de fêtes & entremets
Une petite réalisation tout droit sortie de mon imagination, de la noix de coco et du chocolat au lait… Un entremet tout en douceur et en légèreté qui se compose d’une base croustillante noix de coco, un crémeux au chocolat au lait et d’une mousse à la noix de coco … Un dessert plutôt facile à réaliser et qui en jette.
Pour 4 nuages de coco : (plaque bleue)
Pour la dacquoise noix de coco:
100 g de noix de coco râpée
4 blancs d’œufs  (10)
100 g de sucre
20 g de fleur de maïs
Pour le crémeux au chocolat au lait:
150 g de chocolat au lait   (400g)
150 ml de crème liquide
100 g de sucre
Pour la mousse à la noix de coco:
400 ml de crème de coco
120 g de fromage blanc
3 blancs d’œufs   (6)
80 g de sucre
2 g d’agar agar',
  'Préparez tout d’abord la dacquoise à la noix de coco,
Préchauffez le four à 180°C.
Mélangez la noix de coco râpée, le sucre et la fleur de maïs.
Montez les blancs en neige et incorporez-les.
Sur une plaque recouverte d’un papier de cuisson versez le mélange puis étalez-le uniformément sur une hauteur de 2 cm.
Mettre au four 20 minutes.
Dès la sortie du four, détaillez à l’aide d’un emporte-pièce 4 ronds de la taille de vos cercles à pâtisserie. Laissez la base au fond du cercle puis réservez.
Préparez le crémeux au chocolat,
Dans une casserole, faites chauffer la crème liquide.
Versez-la sur le chocolat au lait coupé en petits morceaux. Bien mélanger.
Reprendre vos cercles à pâtisserie avec au fond la base à la noix de coco, puis versez un peu de chaque crémeux sur chaque ronds.
Mettre au congélateur.
Préparez la mousse à la noix de coco,
Dans une casserole, délayez la crème de coco avec le sucre et l’agar agar puis portez à ébullition.
Baissez le feu et faites cuire 2 à 3 minutes. Otez du feu.
Battez le fromage blanc dans un saladier, ajoutez la crème de coco, mélangez bien.
Sortir les cercles du congélateur, puis répartissez de la mousse dans chacun d’eux.
Faites prendre 2 heures au réfrigérateur.
Je conseille de le remettre au congélateur et de le sortir une bonne heure avant dégustation… Petit conseil que je viens de recevoir, on ne congèle pas l’agar agar! lol quand je dis que je suis une débutante!!! :) Mais bon moi ça n’a pas fait d’effet secondaire alors… ^^',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Fondant moelleux aux trois chocolats',
  'fondant-moelleux-aux-trois-chocolats',
  'Délicieuse recette de dessert.',
  '(Quand Nad cuisine)
Pour 9 carrés (soit 1 par personne ou plus si gourmands il y a !) :
Pour le fondant :
170 g de chocolat au lait
60 g de beurre
3 œufs
40 g de sucre
60 g de farine
1 pincée de sel
Pour la couche blanche :
100 g de chocolat blanc
2 feuilles de gélatine
50 ml de lait
150 g de fromage blanc
Pour le glaçage :
125 g de chocolat noir
20 g beurre
1 cs de sucre glace',
  'Découper le fondant en parts et les déposer dans les assiettes de service. Napper de sauce sans totalement recouvrir la couche blanche et remettre au frais 30 min. Comme je le disais précédemment, mon glaçage n''était pas suffisamment coulant pour napper le fondant. Je me suis donc servie de mon décopen et ai décoré les parts au moment de servir.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Forêt noire',
  'foret-noire',
  'Délicieuse recette de dessert.',
  '(Framboise et vanille)
https://www.framboiseetvanille.fr/recipe-items/foret-noire/
La génoise :							La crème chantilly :
- 7 œufs							- 1kg de crème entière liquide
- 210 gr de sucre						- 400 gr de mascarpone
- 70 gr de cacao en poudre non sucré			- 12 càs de sucre glace (à ajuster selon)
- 70 gr de farine						- un pot de cerise en bocal
- 70 gr maïzena						  (jus + eau + kirsch + sucre = 1/3 l)
- ½ sachet de levure chimique',
  'Commencer par la génoise : Préchauffer le four à 180 degrés. Séparer les blancs des jaunes. Fouetter à l’aide d’un robot ou d’un batteur les blancs en rajoutant le sucre petit à petit jusqu’à avoir une meringue.
Verser les jaunes et fouetter encore 2 minutes. Tamiser le cacao, la levure, la farine et la maïzena et incorporer en 2 fois tout en mélangeant délicatement avec une maryse.
Quand vous obtenez un mélange homogène, verser dans le moule de 18 cm chemisé de papier cuisson (ou beurré et fariné).
Enfourner pendant 45 min environ suivant le four toujours à 180 degrés. Planter un couteau pour vérifier la cuisson, il doit ressortir sec.
Démouler la génoise et laisser refroidir sur une grille.
Couvrir avec du film alimentaire et laisser reposer au réfrigérateur pendant 1 h environ. C’est important d’avoir une génoise refroidie, la découpe sera plus facile.
Pendant ce temps, monter la chantilly dans un bol très froid, en fouettant la crème liquide entière et le mascarpone. Rajouter le sucre glace petit à petit tout en augmentant la vitesse progressivement. Quand la crème est bien épaissie c’est prêt.
Le montage : Diviser en 3 la génoise à l’aide d’une lyre ou d’un couteau, découper légèrement le dessus pour avoir 3 disques réguliers. Déposer le premier disque de génoise dans une assiette de service ou d’une semelle à gâteaux.
Imbiber le premier disque de génoise à l’aide d’un pinceau avec le jus des cerises en bocal.
Ce n’est pas nécessaire de lisser parfaitement, car le gâteau sera décoré de copeaux de chocolat.
L’astuce pour réaliser des petits copeaux : découper une tablette de chocolat noir à l’aide d’un économe pour avoir des petits copeaux. Décorer comme vous le souhaitez.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Fraisiers (individuels)',
  'fraisiers-individuels',
  'Délicieuse recette de dessert.',
  'Pour 12 fraisiers (cercles ronds) :
Génoise (plaque bleue) :
4 œufs
100g de sucre
100g de farine',
  'Etalez sur la plaque et faites cuire 15 minutes à 180°.
Mousse à la fraise :
600g de coulis
5,5 feuilles de gélatine
6,5 cl de sucre de canne
Miroir à la fraise :
200g de coulis
2 feuilles de gélatine',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Gâteau chocolat Jivara citron',
  'gateau-chocolat-jivara-citron',
  'Délicieuse recette de dessert.',
  'Gâteau chocolat Jivara / citron
Pour 1 gâteau (plaque bleue)
La mousse au citron
Curd citron :				Mousse citron :
2 œufs				3 feuilles gélatine
2 citrons				1 citron
100g de sucre			300g de crème
36g de beurre
Curd :
Zestez les citrons. Dans une casserole, cassez les œufs. Ajoutez le zeste, le jus et le sucre. Portez à ébullition en remuant. Hors du feu, ajoutez le beurre et remuez jusqu’à ce qu’il fonde complètement. (Si on veut, passez le curd au chinois et réservez à température ambiante.)
Mousse citron :
Zestez le citron. Pressez le jus. Ajoutez la gélatine au préalablement ramollie dans de l’eau froide. Faites chauffer le tout pour fondre la gélatine. Ajoutez au curd lorsque le jus est refroidi. Montez la crème en chantilly et mélangez au curd.
Le cake au citron :',
  'Le sablé breton au citron :
175g de beurre demi-sel, 140g de sucre en poudre, 2g de fleur de sel, 70g de jaunes d’œufs, 220g de farine, 4,2g de levure chimique, le zeste d’un citron 1/2.
Dans le bol du robot, mélangez avec le fouet plat pendant 2min le beurre pommade, le sucre et le sel. Ajoutez les jaunes et mélangez pendant encore 2min. Incorporez ensuite la farine tamisée avec la levure et le zeste du citron. Mélangez sans travailler longtemps, aplatissez la pâte en un rectangle de 27x37cm et 3mm d’épaisseur entre 2 feuilles guitare (ou papier sulfurisé) réservez au réfrigérateur une heure ou au congélateur 15 min. Préchauffez le four à 200°. Mettez le carré de pâte dans un cadre à entremets carré de 27×37 (taille de la plaque bleue) non beurré et enfournez 12min à 14min à vérifier.
La mousse Jivara citron (à faire 2 fois) :
300g de couverture Jivara lactée ou d’un chocolat au lait à 40%, 215g de lait frais entier, 4,5g de gélatine soit 2,25 feuilles, 425g de crème fleurette à 35%, 3/4 d’un zeste d’un citron.
Faites fondre le chocolat au bain-marie. Parallèlement faites bouillir le lait. Hors du feu ajoutez-y la gélatine préalablement ramollie dans de l’eau froide et essorée. Mélangez au fouet en versant le lait chaud en 3 fois sur le chocolat. Mélangez bien et laissez refroidir entre 35°/40°. Montez la crème en chantilly (pour obtenir une consistance mousseuse). Versez le chocolat dans la crème montée et mélangez bien de bas en haut en un mouvement qui part du centre pour obtenir une mousse bien homogène, ajoutez le zeste de citron finement râpé.
Le montage : 
Assemblez le gâteau : sablé au citron, mousse Jivara citron, mousse citron, cake au citron et mousse Jivara citron.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Lait concentré sucré (Thermomix)',
  'lait-concentre-sucre-thermomix',
  'Délicieuse recette de dessert.',
  'Crèmes brûlées
(Papilles on/off)
http://papilles-on-off.blogspot.fr/2011/05/lait-concentre-sucre-maison-au.html
Pour 70 g de lait concentré sucré
35g de lait en poudre = 1 gobelet bien rempli
35g de sucre roux
35g d’eau',
  'Mettre le lait en poudre ainsi que le sucre dans le bol. Mixer 6s, vitesse 10. Ajouter l’eau pour 10 mn, 90°, vitesse 3 en prenant soin de ne pas mettre le gobelet. Verser le tout dans un pot en verre stérilisé (… et laver votre bol avant que le lait restant n’accroche trop !...) Mettre au frais.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Macarons (ChefNini)',
  'macarons-chefnini',
  'Délicieuse recette de dessert.',
  'Macarons
(ChefNini)
http://www.chefnini.com/macaron-video/
Pour 10 macarons environ :
1 blanc d’œuf (calibre moyen – environ 35-36g)
40g de poudre d’amande
65g de sucre glace
15g de sucre en poudre
½ cc cacao amer
- Versez le blanc dans un cul-de-poule (ou une casserole).
- Pesez le sucre glace et la poudre d’amande et mixez-la dans votre robot. Tamisez sur une grande feuille de papier sulfurisé à l’aide d’une passoire fine. Si vous souhaitez colorer vos coques avec du cacao amer, ajoutez-le à ce moment-là au sucre glace et à la poudre d’amande.
– Pesez dans un ramequin le sucre en poudre.',
  '- Versez de l’eau dans une casserole, mettez sur feu doux et déposez le cul de poule avec les blancs. Faites tiédir ainsi le blanc en fouettant à la main tranquillement. Testez la température des blancs avec votre doigt : il doit être juste tiède. Le blanc devient alors mousseux.
- Retirez le cul de poule de la casserole, posez sur votre plan de travail et fouettez au batteur électrique vitesse 1.
- Lorsqu’il devient blanc, ajoutez le sucre en poudre et continuez de fouetter, vitesse 2, de façon à obtenir une meringue blanche et brillante.
- Vous devez voir apparaitre un “bec d’oiseau” au bout de votre fouet. Vous pouvez ajouter à ce moment-là du colorant et finissez de fouetter pour incorporer le colorant (colorant liquide possible). Il ne faut pas hésiter à vous attarder un peu sur le fouettage, le résultat n’en sera que meilleur.
- Versez alors le mélange poudre d’amande / sucre glace sur la meringue en 4-5 fois et macaronnez : prenez une maryse ou une corne et faites un mouvement de bas en haut en revenant vers vous et en tournant le saladier d’un quart de tour.
- La pâte doit être souple. Lorsque vous la soulevez et que vous la laissez retomber, vous aurez un aperçu de l’aspect des coques. La pâte doit être lisse et se reformer tranquillement.
- Posez votre feuille de papier sulfurisé sur une plaque.
- Versez dans une poche à douille de 10mm la pâte à macaron et pochez : Placez votre douille de façon perpendiculaire à la plaque, exercez une pression avec la main placée sur la poche à douille, stoppez la pression, puis enlevez la douille en faisant un cercle dans le sens des aiguilles d’une montre tout en effleurant le macaron. Cela évitera de former une pointe sur la coque.
- Claquez la plaque sur le plan de travail pour que les coques prennent formes.
- Retirez le papier sulfurisé de la plaque, délicatement pour ne pas abîmer les coques. Placez cette plaque au réfrigérateur le temps du croûtage.
- Laissez croûter 40 min à température ambiante.
- Au bout de 30 min, préchauffez votre four à 160°C, chaleur tournante.
- Placez la feuille de papier sulfurisée sur la plaque qui vient du réfrigérateur et placez celle-ci sur une autre plaque ou la lèche-frites de votre four que vous aurez retiré avant de faire préchauffer votre four.
- Enfournez dans le four à mi-hauteur pendant 10 min, puis éteignez le four et laissez-les ainsi pendant 3 à 5 min.
- Laissez refroidir avant de décoller les coques délicatement : retournez le papier sulfurisé de façon à poser les coques sur le plan de travail et à avoir le papier sulfurisé sur le dessus : décoller doucement le papier du macaron.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Macarons au sucre cuit (Françoise)',
  'macarons-au-sucre-cuit-francoise',
  'Délicieuse recette de dessert.',
  'Macarons au sucre cuit
2 x 80 g blanc d’œuf		250 g poudre d’amandes		250 g de sucre glace
225 g de sucre semoule + 60 g eau à cuire à 118 °
Ajouter l’arôme désiré.
Ganache
120 g crème liquide	200 g chocolat noir	30 g beurre  éventuellement arôme orange ou café
Porter la crème à ébullition.
Verser la crème sur le chocolat.
Ajouter le beurre et éventuellement l’arôme.
Ganache 2
80 g crème	180 g chocolat blanc	20 g beurre éventuellement citron, citron vert, vanille, pistache, fraise, framboise
Idem ci-dessus',
  'Mélanger la poudre d’amandes, le sucre glace et 80 g de blanc d’œuf.
Battre 80 g de de blanc d’œuf avec une pincée de sel puis ajouter le sucre cuit. Continuer à battre jusqu’à faire descendre la température.
Ajouter le colorant alimentaire désiré selon le parfum final.
Dresser sur une plaque à l’aide d’une poche à douille.
Mettre au four environ 12 minutes à 170 °C en laissant le four entrouvert à l’aide d’un bouchon.
N.B : il est préférable de garnir les macarons le lendemain et de laisser sécher dans une pièce fraîche.
Crème au beurre
150 g beurre ramolli  + 100 g sucre glace',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Mini tartelettes au chocolat et crumble de spéculoos',
  'mini-tartelettes-au-chocolat-et-crumble-de-speculoos',
  'Délicieuse recette de dessert.',
  '(Mes p’tits biscuits gourmands)
200grs de pâte brisée ou sablée maison
100grs de chocolat noir
10cl de crème fraîche liquide
50grs de crumble original Spéculoos Lotus + un peu pour le décor
Froncer des mini moules à tartelettes de pâte. Les cuire vides 8 minutes au four à 180°C.
Les laisser refroidir.
Pendant ce temps, casser le chocolat en morceaux et le mettre dans une casserole avec la crème.
Laisser fondre à feu doux en remuant de temps en temps jusqu''à une ganache brillante.
Parsemer de crumble de spéculoos, mettre une petite 1/2h eu frais et déguster.',
  'Laisser un peu refroidir, ajouter le crumble de spéculoos. Mélanger brièvement et remplir les fonds de tartelettes.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Mini tartelettes mascarpone framboises',
  'mini-tartelettes-mascarpone-framboises',
  'Délicieuse recette de dessert.',
  'Voir la recette',
  'Préparer ensuite la crème :
20 cl de crème liquide entière
100g de mascarpone
50g de sucre glace
Quelques brisures de framboises surgelées
Monter la crème liquide en chantilly avec le sucre, ajouter le mascarpone et continuer à battre jusqu''a l''obtention d''une crème ferme.
Ajouter les brisures de framboises, mélanger.
Placer la crème au réfrigérateur.
Mettre à cuire pendant environ 15 minutes à 180°c.
À la sortie du four, laisser refroidir complètement.
Mettre la crème dans une poche à douille et garnir les fonds à mini tartelettes.
Décorer enfin avec des framboises et placer au frais jusqu''au moment de servir...',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Moelleux au chocolat, coeur framboise',
  'moelleux-au-chocolat-coeur-framboise',
  'Délicieuse recette de dessert.',
  'Moelleux au chocolat, cœur framboise
(livre de Pasca)
Pour 6 personnes :
Pour la pâte à moelleux :
100g de beurre (+ pour les moules)
4 œufs
140g de chocolat noir
60g de sucre en poudre
20g de maïzena
40g de farine
20g de cacao en poudre pour les moules
Pour le cœur :
250g de framboises
250g de sucre
Préchauffez le four à 200°C (th. 6-7). Beurrez les moules et chemisez-les de cacao. Réservez-les au réfrigérateur.
Préparez le cœur. Dans une casserole, faites chauffer les framboises et le sucre à feu doux pendant 15 min en remuant régulièrement. Remuez bien et laissez refroidir. Versez dans un bac à glaçons puis placez au réfrigérateur pendant 2 h.',
  '(On peut remplacer les framboises par des fraises ou des mûres...)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Moelleux au chocolat',
  'moelleux-au-chocolat',
  'Délicieuse recette de dessert.',
  '(Cuisine AZ)
250 de chocolat noir à pâtisserie
150 g de beurre + 20 g pour le moule
6 œufs
200 g de sucre glace
80 g de farine',
  'Préchauffez le four th.6 (180°C).
Tapissez un moule à manqué de papier sulfurisé en laissant dépasser les bords pour que le démoulage se passe en douceur, badigeonnez-le de beurre mou ou fondu au pinceau et réservez-le au réfrigérateur.
Cassez le chocolat en morceaux et faites-le fondre au bain-marie avec le beurre puis mélangez à la spatule.
Dans une terrine, battez les œufs avec le sucre glace jusqu''à ce que le mélange blanchisse, puis ajoutez le mélange chocolat / beurre fondu et la farine. Versez dans le moule à manqué et glissez sur une grille au bas du four pour 20 à 25 min de cuisson.
Laissez le gâteau refroidir dans le moule avant de le démouler très délicatement et de le poser sur le plat de service. À déguster très vite.
*Si vous devez le réserver au réfrigérateur, enveloppez-le de film alimentaire et sortez-le du réfrigérateur 1 heure au moins avant de le servir.
*Conseil : poudrez le gâteau de sucre glace et servez-le avec une crème anglaise, un coulis de fruits ou du caramel au beurre salé.
Astuces
Pour démouler facilement le gâteau, coupez 2 longues bandes de papier sulfurisé à poser en croix dans le fond du moule et qui devront dépasser de chaque côté puis un cercle au diamètre du moule pour en couvrir le fond. Les 4 languettes de papier sulfurisé qui dépasseront vous permettront de démouler le gâteau tout en douceur.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Moelleux au citron, coeur lemon curd',
  'moelleux-au-citron-coeur-lemon-curd',
  'Délicieuse recette de dessert.',
  'Moelleux au citron, cœur lemon curd
(livre de Pasca)
Pour 6 personnes :
Pour la pâte à moelleux :
100g de beurre mou (+ pour les moules)
2 œufs
60g d’amandes en poudre
120g de sucre en poudre
120g de farine (+ pour les moules)
½ sachet de levure chimique
le zeste d’un citron
Pour le cœur :
20g de beurre
2 œufs
50g de sucre
10g de maïzena
le jus de 2 citrons',
  'Préchauffez le four à 200°C (th. 6-7). Beurrez les moules et chemisez-les de farine. Réservez-les au réfrigérateur.
Préparez le cœur. Dans une casserole, faites fondre à feu doux le sucre et le jus de citron. Augmentez le feu et ajoutez la maïzena et les œufs sans cesser de remuer. Le mélange va commencer à épaissir. Laissez cuire 5 min. Hors du feu, ajoutez le beurre et laissez refroidir. Versez dans un bac à glaçons et mettez au congélateur 3 h.
Préparez la pâte à moelleux. Dans une jatte, faites blanchir les œufs et le sucre. Ajoutez le beurre, puis la farine, la poudre d’amandes et la levure. Versez un tiers de la pâte dans les ramequins, puis déposez un glaçon de lemon curd. Recouvrez du reste de pâte puis enfournez pour 10 min environ. Dégustez aussitôt.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Moelleux coco, coeur choco',
  'moelleux-coco-coeur-choco',
  'Délicieuse recette de dessert.',
  'Moelleux coco, cœur choco
(livre de Pasca)
Pour 6 personnes :
Pour la pâte à moelleux :
3 blancs d’œufs
150g de noix de coco râpée
120g de sucre en poudre
Pour le cœur :
20ml de crème fraîche
50g de chocolat noir
Préparez le cœur. Dans une casserole, faites chauffer la crème à feu doux. Retirez du feu juste avant l’ébullition et ajoutez le chocolat en morceaux. Remuez bien et laissez refroidir, puis placez au réfrigérateur pendant 2 h.',
  '(Attention à la cuisson ! Ces pyramides sont cuites quand les arêtes commencent à dorer.)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Mousse au Limoncello façon soufflé',
  'mousse-au-limoncello-facon-souffle',
  'Délicieuse recette de dessert.',
  '(Péché de gourmandise)
http://pechedegourmand.canalblog.com/archives/2007/08/29/6012409.html
250 g de fromage blanc type faisselle
1 citron
2 œufs
10 cl de Limoncello (liqueur italienne à base de citron)
15 cl de crème liquide
120 g de sucre en poudre
3 feuilles de gélatine',
  'Laisser égoutter le fromage blanc pendant 1 h. Faire ramollir la gélatine dans de l''eau froide. Râper le zeste du citron et le mélanger avec 20 g de sucre. Réserver pour la déco.
Presser le jus du citron et le mettre dans une casserole avec le Limoncello. Faire tiédir le tout et ajouter la gélatine égouttée et essorée à la main.
Prendre des ramequins et les entourer avec une bande de rhodoïd que vous fixerez avec du scotch (vous pouvez aussi mettre une bande de papier sulfurisé). Il faut que le rhodoïd soit plus haut que le bord du ramequin. Répartir la mousse dans les ramequins en remplissant à ras bord du rhodoïd et en égalisant la surface avec une spatule. Mettre 3 h minimum au frigo.
Pour servir retirer délicatement le rhodoïd, décorer avec les zestes sucrés ou comme je l''ai fait avec des fruits rouges (framboises, mûres ou groseilles) et une feuille de menthe fraîche.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Couronne gitane',
  'couronne-gitane',
  'Délicieuse recette de dessert.',
  '70 g de sucre en poudre
14 morceaux de sucre imbibés d’eau (23 petits)
100 g de beurre
2 œufs
40 g de farine',
  'Faire fondre, à feu doux, le chocolat dans ½ verre d’eau. Ajouter le sucre en poudre et les 14 morceaux de sucre imbibés.
Hors du feu, incorporer le beurre fondu, les jaunes d’œufs, la farine puis les blancs d’œufs battus en neige.
Verser dans un moule à savarin et enfourner 20 min à 200°C.
Laisser refroidir un peu avant de démouler.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Pain d''épices',
  'pain-d-epices',
  'Délicieuse recette de dessert.',
  'Pain d’épices
(Mémé)
250 g de farine
1 cuillère à café de bicarbonate
130 g de miel
200 ml de lait bouillant
1 cuillère à café de mélange pour pain d’épices',
  'Mettre le sucre avec le lait bouillant, ajouter le bicarbonate et la farine. Mélanger et laisser reposer pendant 1 heure.
Ajouter le miel liquide et les épices au moment de mettre au four.
Préchauffer le four th 200° en chaleur tournante. Enfourner grille 2 pendant 1 à 2 minutes puis réduire le four à 150° chaleur traditionnelle pour une cuisson lente et douce de 45 minutes. Vérifier la cuisson à l’aide d’un couteau.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Royal mousses caramel beurre salé et chocolat noir',
  'royal-mousses-caramel-beurre-sale-et-chocolat-noir',
  'Délicieuse recette de dessert.',
  '(Gourmandise homecooked)
http://gourmandises-homecooked.blogspot.fr/2011/02/dessert-royal-mousses-caramel-beurre.html
- Pour la dacquoise aux noisettes
45 g de poudre de noisettes
45g de sucre glace tamisé
20g de sucre en poudre
2 blancs montés en neige
- Pour le croquant :
80 g de pralinoise
80g de chocolat noir corsé
80g de gavottes écrasées
- Pour la mousse au caramel au beurre salé :
50 g de sucre
37,5g de beurre
20 cl de crème liquide (placée au congel au moins 10 minutes avant)
1.5 feuilles de gélatine
1 belle pincée de fleur de sel
Pour la mousse au chocolat noir :
100g de chocolat noir corsé
20 cl de crème liquide (placée au congel au moins 10 minutes avant)
1 feuille de gélatine
Pour le glaçage au chocolat noir et chocolat lait :
40 g chocolat noir / 40g chocolat lait
48 g de sucre glace
8 cl de crème liquide
1/2 feuille de gélatine',
  '1: Dans un saladier, mélangez toutes les poudres ensemble.
2: Dans un second saladier, battez les blancs en neige puis incorporez-y les poudres peu à peu délicatement.
Versez cette pâte en fine couche dans des cercles à pâtisserie  et faites cuire 15 minutes à 180°C (thermostat 6). Surveillez le temps de cuisson.
1: Faites fondre la pralinoise et le chocolat noir au bain marie, mélangez aux gavottes.
2: Déposez une couche de ce mélange dans les cercles, sur la génoise refroidie.
3: Laissez reposer au frais au minimum 30 minutes.
1: Dans une casserole, faites fondre le sucre jusqu''à obtenir un caramel doré.
Faites ramollir la feuille de gélatine et demie dans de l''eau froide.
2: Hors du feu, ajoutez le beurre en morceaux et la fleur de sel, fouettez vivement, puis ajoutez la moitié de la crème. Ajoutez la feuille de gélatine.
3: Montez les 10 autres centilitres de crème liquide en chantilly. Le secret ? Ustensiles et saladier placés au frais depuis au moins 1 heure, crème au congel pendant au moins 10 minutes.
4: Mélangez délicatement la chantilly et la crème caramel.
5: Faites couler une couche de mousse caramel sur le croquant, placez au frais au moins 1 heure.
1: Faites fondre le chocolat au bain-marie
2: Hors du feu, ajoutez 5 cl de crème pour refroidir le chocolat.
3: Montez les 15 autres centilitres de crème liquide en chantilly.
4: Mélangez délicatement la chantilly et la crème chocolat.
5: Faites couler une couche de mousse chocolat sur la mousse caramel, placez au frais au moins 1 heure.
1: Faites fondre les chocolats au bain-marie, faites fondre la demi-feuille de gélatine dans de l''eau froide.
2: Hors du feu, ajoutez la crème et tamisez le sucre glace. Essorez la gélatine, incorporez-la et fouettez.
3: Nappez le royal avec ce glaçage brillant. Laissez au frais au moins 30 minutes.
- Pour le démoulage :
Passez un couteau dont la lame aura été chauffée par le dessous du cercle pour décoller la génoise, puis passez très rapidement la flamme du chalumeau sur le cercle : ça se démoule tout seul !!!',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Shortbread Millionnaire (Pasca)',
  'shortbread-millionnaire-pasca',
  'Délicieuse recette de dessert.',
  'Shortbread Millionnaire
Pour la pâte sablée
50g de sucre
1 sachet de sucre vanillé (facultatif)
1 demi-sachet de levure
120g de beurre demi-sel
180g de farine
Pour le caramel
100g de sucre
120g de beurre
1 boîte de lait concentré sucré (environ 400g)
Glaçage
200g de chocolat au lait',
  'Préchauffez le four à 170°C.
Pour la pâte sablée, travaillez à la main le beurre et le sucre. Mélangez bien. Ajoutez la farine tamisée et la levure. Mélangez de nouveau jusqu''à ce que vous parveniez à former facilement une boule avec la pâte. 
Puis étalez-la dans un moule en silicone (de forme rectangulaire 18x26cm pour moi). Tassez-la avec le dos d''une c à s de façon à ce qu''elle soit peu épaisse et piquez-la avec une fourchette. 
Enfournez pour 25-30 min. Le biscuit doit à peine dorer.
Dans une casserole, faites caraméliser le sucre. Ajoutez le beurre au caramel. Mélangez.
Au micro-onde, faites fondre vos tablettes de chocolat puis versez-le sur la crème au caramel devenue froide. Laissez le moule refroidir puis placez-le au frigo pour plusieurs heures (l''idéal étant de le faire la veille car il sera encore meilleur !).
Coupez-le ensuite en petits carrés et savourez.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Soufflés choco-noix de coco',
  'souffles-choco-noix-de-coco',
  'Délicieuse recette de dessert.',
  '(Cuisine AZ)
110 g de beurre + un morceau pour beurrer les ramequins
3 œufs
3 c. à soupe de sucre
5 c. à soupe de noix de coco en poudre
1 pincée de sel',
  'Allumez le four thermostat 4 (160°) et beurrez 4 ramequins. Faites fondre le chocolat avec le beurre à feu très doux.
Cassez les œufs et séparez les jaunes des blancs. Mettez les jaunes dans un saladier et les blancs dans un autre. Ajoutez le sel aux blancs et battez-les en neige très ferme.
Ajoutez le sucre aux jaunes d''œufs et mélangez bien. Ajoutez la noix de coco en poudre, le chocolat et enfin les blancs en neige. Mélangez. Remplissez les ramequins avec cette pâte. Mettez-les au four pendant 25 minutes puis sortez-les avec des gants de cuisine. Dégustez les soufflés tout de suite !',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tiramisu au citron',
  'tiramisu-au-citron',
  'Délicieuse recette de dessert.',
  'Curd citron : 2 œufs				Mousse mascarpone : 2 œufs
2 citrons							    50g sucre roux
100g sucre							    250g mascarpone
36g beurre							    20g jus citron
~ 10 biscuits cuillers',
  'Zester le citron. Dans une casserole, casser l’œuf. Ajouter le zeste, le jus de citron et le sucre. Porter à ébullition en remuant. Hors du feu, ajouter le beurre et remuer jusqu’à ce qu’il fonde complètement. Réserver le curd à température ambiante. (peut se préparer la veille…)
Séparer les blancs des jaunes. Avec les jaunes, mélanger au sucre roux, le mascarpone et le jus de citron. Fouetter avec le robot jusqu’à ce que le mélange soit homogène, il doit prendre du volume.
Dans un autre récipient, monter les blancs en neige, puis les incorporer délicatement au mélange précédent.
Dans une assiette creuse, mélanger un peu de jus de citron avec du limoncello et un peu de sucre. Tremper les biscuits cuillers dedans. Alterner une couche de biscuits, lemon curd puis mousse mascarpone. Recommencer l’opération.
Mettre au frais plusieurs heures avant dégustation.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tiramisu aux fraises',
  'tiramisu-aux-fraises',
  'Délicieuse recette de dessert.',
  'Pour 9 verres :
~ 1 kg de fraises
5 œufs
310 g de mascarpone
60 g de sucre
18 biscuits à la cuillère
pour le sirop : 50 g de sucre
150 ml d’eau
6 feuilles de menthe
2 cuillers à soupe de coulis de fraises',
  'Faites chauffer 50 g de sucre et 150 ml d''eau puis quand cela arrive à ébullition, enlevez du feu et ajoutez des feuilles de menthe, laisse refroidir cela va infuser. Lorsque le sirop est refroidi, ajoutez 2 cuillers à soupe de coulis de fraises. Mélangez.
Faites tremper rapidement les biscuits dans le sirop, et les disposez dans les verres. Versez de la crème dessus, puis des morceaux de fraises (lavées et équeutées), puis à nouveau des biscuits trempés, de la crème et terminez par des fraises.
Réservez au frais au moins 2 heures.
Remarque : on peut ajouter un peu de coulis de fraises sur les fraises à l’intérieur du verre.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tiramisu aux pommes et caramel au beurre salé (Quand Nad cuisine)',
  'tiramisu-aux-pommes-et-caramel-au-beurre-sale-quand-nad-cuisine',
  'Délicieuse recette de dessert.',
  'Tiramisu aux pommes et caramel au beurre salé
(Quand Nad cuisine)
http://quandnadcuisine.fr/article-tiramisu-aux-pommes-et-caramel-au-beurre-sale-117738221.html
Pour 6 belles verrines : 			(pour 10 verres)
5 belles pommes
20 g de beurre
1 càs de sucre vanillé
3 œufs					5
300 g de mascarpone			500g de mascarpone
50 g de sucre					80g
2 càs de liqueur de pomme verte		4 càs
9 palets bretons
caramel au beurre salé',
  'Pour environ 24 palets :
80 g de beurre salé mou				120
80 g de sucre						120
1 càs de sucre vanillé maison			1,5
2 jaunes d''œufs					3
140 g de farine					210
1/2 sachet de levure chimique			3/4
Travailler le beurre en pommade dans le bol d''un batteur. Ajouter les sucres et les jaunes sans cesser de fouetter.

Ajouter ensuite la farine et la levure et malaxer bien le tout (pour moi, toujours le kitchenaid avec la "feuille").  La pâte doit être homogène. Former un boudin et l''enrouler de film alimentaire. Placer au réfrigérateur durant 1h.

Préchauffer le four à 150°.

Couper des tranches de 5 mm d''épaisseur dans le boudin de pâte et les placer dans le fond de moule à muffins (ou à tartelettes) afin qu''ils ne s''étalent pas trop pendant la cuisson.

Enfourner et laisser cuire 20 min. Les palets doivent être bien dorés. Laisser tiédir quelques instants et démouler. Laisser refroidir complètement sur une grille avant de les conserver dans une boîte en fer.
Pour 1 gros pot de caramel :
160 g de sucre en poudre
20 cl de crème liquide
80 g de beurre demi-sel
Placer le sucre dans une casserole et faire chauffer jusqu''à obtenir un caramel ambré. Pendant ce temps, dans une autre casserole (ou au micro-ondes), faire chauffer la crème. Couper le beurre en morceaux.

Lorsque le caramel atteint une jolie couleur ambrée, retirer la casserole du feu et ajouter délicatement la crème, petit à petit, en prenant garde aux projections. Bien remuer. Quand il n''y a plus de gros bouillons, ajouter le beurre. Remuer bien l''ensemble, le caramel doit être bien lisse, sans gros morceaux. Dans le cas contraire, remettre la casserole sur feu doux, et bien mélanger.

Verser dans un pot en verre et laisser refroidir avant de placer au réfrigérateur. Il suffira de le laisser quelques minutes à température ambiante pour lui redonner tout son crémeux (ou le passer quelques secondes au micro-ondes si vous êtes pressés ou si vous voulez l''utiliser plutôt en coulis).
Selon Raphaël Haumont, mettre le beurre avec le sucre pour faire le caramel…',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Vacherin maison',
  'vacherin-maison',
  'Délicieuse recette de dessert.',
  'Pour 1 vacherin 8-10 pers (taille 185x340) :
2 l de glaces (parfums au choix)
Meringues réalisées avec 2 blancs d’œufs
Chantilly (30 cl crème)',
  'Conseil : placez la plaque support au congélateur avant de commencer à monter le vacherin… La glace ne fondra pas quand vous la mettrez dans le moule…',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrines de mousse de cassis',
  'verrines-de-mousse-de-cassis',
  'Délicieuse recette de dessert.',
  '130g de coulis de cassis
35g de sucre
1 feuille de gélatine
100g de crème fleurette
125g de mascarpone',
  'Faire ramollir la gélatine dans de l’eau froide. Faire chauffer le coulis de cassis et le sucre jusqu’à ce qu’il soit tiède, lui ajouter la gélatine essorée. Laisser ce mélange refroidir.
Battre la crème avec le mascarpone jusqu’à obtention d’une crème façon chantilly. L’ajouter au mélange précédent et verser le tout dans des verrines.
Laisser prendre au réfrigérateur pendant au minimum 4 heures.
Rq : il est possible de procéder comme pour un tiramisu et d’ajouter des biscuits sablés (même quantité pour 2 grands verres avec 2 sablés par verre)…',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bûche chocolat au lait, citron',
  'buche-chocolat-au-lait-citron',
  'Délicieuse recette de dessert.',
  '(La cuisine de Mercotte)
https://www.mercotte.fr/2011/11/02/preparons-les-fetes-la-buche-2011-premier-essai/
Pour une gouttière à bûche de 52.5cm, soit 3 bûches de 17.5 cm et par ordre d’entrée en scène :
La gelée au citron : 250g de jus de citron, 120g de sucre en poudre, 3 feuilles de gélatine soit 6g ramollies dans beaucoup d’eau froide et essorées.
Portez presque à ébullition le sucre et 100g de jus de citron. Hors du feu y dissoudre la gélatine, ajoutez le reste du jus et coulez dans une mini gouttière à bûche. Bloquez au grand froid.',
  'Le sablé breton au citron : 125g de beurre demi-sel, 100g de sucre en poudre, 1.5g de fleur de sel, 50g de jaunes d’œufs, 155g de farine, 3 g de levure chimique, le zeste d’un citron.
Dans le bol du robot, crémez à la feuille pendant 2min le beurre pommade, le sucre et le sel. Ajoutez les jaunes et mélangez pendant encore 2min. Incorporez ensuite la farine tamisée avec la levure et le zeste du citron. Mélangez sans corser, aplatissez la pâte en un carré de 20x20cm et 3mm d’épaisseur entre 2 feuilles guitare réservez au réfrigérateur une heure ou au congélateur 15 min. Préchauffez le four à 200°. Mettez le carré de pâte dans un cadre à entremets carré de 20×20 non beurré et enfournez 12min à 14min à vérifier. Quand le biscuit est refroidi coupez délicatement 3 bandes de la largeur de la gouttière à bûche, réservez.
La mousse Jivara citron : 400g de couverture Jivara lactée ou d’un chocolat au lait à 40%, 285g de lait frais entier, 6g de gélatine soit 3 feuilles, 570g de crème fleurette à 35%, le zeste d’un citron.
Faites fondre le chocolat au bain-marie ou au micro-ondes si vous maîtrisez [pas moi !]. Parallèlement faites bouillir le lait. Hors du feu ajoutez-y la gélatine préalablement ramollie dans de l’eau froide et essorée. Réalisez en frictionnant à la maryse une émulsion en versant le lait chaud en 3 fois sur le chocolat. Mélangez bien et laissez refroidir entre 35°/40°. Montez la crème pour obtenir une consistance mousseuse. Versez le chocolat dans la crème montée et mélangez bien de bas en haut en un mouvement qui part du centre pour obtenir une mousse bien homogène, ajoutez le zeste de citron finement râpé à la microplane.
Le montage : versez au fond de la gouttière chemisée d’une feuille guitare 1/3 de la mousse légère Jivara citron, recouvrez d’une bande de cake au citron, démoulez la gelée de citron posez-la sur le cake, recouvrez le tout avec le reste de mousse légère. Terminez en ajoutant le sablé breton. Bloquez au grand froid.
La finition : démoulez la bûche encore congelée et découpez-la en 3 portions égales. Plusieurs possibilités s’offrent à vous. La plus simple, poudrez la bûche avec du cacao en poudre, ajoutez quelques éléments de décoration, et laissez revenir à température au réfrigérateur pendant 6 heures environ avant de la déguster. Vous pouvez aussi réaliser un glaçage
Le glaçage Jivara : 95g de chocolat Jivara ou à de chocolat au lait à 40%, 125g soit 1/8 de litre de crème fleurette à 35%, 30g de miel d’acacia, 30g de beurre.
Faites fondre le chocolat au bain-marie et bouillir la crème et le miel. Réalisez une émulsion en versant la crème en 3 fois sur le chocolat et en frictionnant énergiquement à la maryse. Quand la température du mélange est entre 35° et 40° ajoutez le beurre coupé en dés et lissez au mixer plongeant pour homogénéiser le tout. Placez la bûche tout juste sortie du congélateur sur une grille à pâtisserie posée sur un plateau pour pouvoir récupérer l’excédent de glaçage et recouvrez-la entièrement, lissez éventuellement à la spatule. Réservez au réfrigérateur et décorez à votre guise au moment de servir.
Explications utiles ou futiles :
Le rétro planning général qui peut se situer bien en amont de la dégustation évidement.
J-2 ou plus : réalisation de l’insert gelée de citron, et hop au congélateur. Préparez aussi la pâte à sablé breton prête à cuire.
J-1 : cuisson et pré découpage du cake au citron et du sablé breton.
J-0 : réalisation de la mousse au chocolat, dressage dans la gouttière ou le moule choisi, et retour au congélateur.
Les moules à bûches : certes il faut avoir de la place dans son congélateur pour utiliser les moules gouttières spécifiques de différentes formes.  Il existe aussi dans la même série des moules à insert très pratiques. Vous pouvez même les laver soigneusement après usage et les conserver pour l’année suivante.  Sinon, pas de panique, un moule à cake, une bouteille en plastique coupée dans la longueur pourront remplacer sans problème les moules plus sophistiqués. Pour la gelée citron vous pouvez la mouler dans des empreintes en silicone à financiers par exemple et vous les alignerez dans la longueur.
Bloquer au froid : mettre au congélateur.
Le beurre clarifié : j’utilise le beurre clarifié prêt à l’usage de Valrhona idéal pour les cakes mais vous pouvez très bien le remplacer par du beurre fondu tiédi.
Le rhum : tout à fait facultatif bien sûr, mais il est bon de savoir que l’alcool s’évapore à la cuisson et qu’il va juste donner un petit plus.
Flexipat : tapis de silicone à bords d’une hauteur de 1cm indispensable pour cuire les biscuits tels que biscuits à la cuillère, Joconde, dacquoise, cakes à plat etc.
Les jaunes d’œufs : et oui il faut peser les jaunes, en général 50g représentent à peu près 3 jaunes moyens.
Crémer à la feuille : mélanger à l’aide du fouet plat du robot le beurre pommade et le sucre par exemple pour obtenir un mélange mousseux.
Ne pas corser une pâte : ne pas trop la travailler, arrêter rapidement le robot dès que les éléments sont rassemblés.
Feuilles guitare : feuilles plastiques transparentes, idéales pour rendre le chocolat brillant mais on peut détourner leur usage pour étaler plus ou moins finement les pâtes et éviter ainsi l’ajout de farine qui va en modifier la texture. Vous pouvez les remplacer par de la toile cirée alimentaire transparente.
Cadre à pâtisserie non beurré :  Pour avoir l’aspect rustique du sablé breton, pas lisse sur les bords en fait, il ne faut pas beurrer le moule tout simplement. Si vous n’avez qu’un cadre rectangulaire, vous pouvez cuire le biscuit en plusieurs fois. Si vous ne faites qu’une seule bûche dans un moule à cake par exemple ce qui est fort possible, réservez le surplus de pâte au congélateur pour une utilisation future. Il existe des cadres réglables très pratiques.
Émulsion : Émulsionner : Mélanger au fouet, mixer ou maryse 2 liquides qui ne se mélangent pas naturellement. Huile + eau par exemple.
Crème montée mousseuse : crème fouettée avant qu’elle ne devienne ferme, elle est plus légère car elle contient encore de l’air, plus facile à incorporer, idéale pour les mousses.
La décoration : j’ai trouvé le glaçage moins pratique car à réaliser le jour de la dégustation, en fait je ne sais pas s’il supporte la congélation, il faudra que je pose la question. Le poudrage cacao non seulement est hyper simple mais il peut se faire avant de replacer les bûches au congélateur, après c’est à vous de vous organiser selon vos préférences.
Chemiser la gouttière : Il suffit de couler un peu d’eau chaude dans le moule à l’envers et tout se décolle rapidement et en plus le moule est pratiquement impeccable prêt à resservir. L’essayer c’est l’adopter…',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bûche chocolat Jivara citron',
  'buche-chocolat-jivara-citron',
  'Délicieuse recette de dessert.',
  'Bûche chocolat Jivara / citron
(Mercotte)
https://www.mercotte.fr/2011/11/02/preparons-les-fetes-la-buche-2011-premier-essai/
Pour 2 bûches (moule bûche carrée, moule bûche ronde)
La mousse au citron (insert bûche, moules mini tartes silicone) :
Curd citron :				Mousse citron :
2 œufs				3 feuilles gélatine
2 citrons				1 citron
100g de sucre			300g de crème
36g de beurre
Rq : trop de mousse au citron pour 2 bûches mais si moitié, pas assez…
Curd :
Zestez le citron. Dans une casserole, cassez l’œuf. Ajoutez le zeste, le jus et le sucre. Portez à ébullition en remuant. Hors du feu, ajoutez le beurre et remuez jusqu’à ce qu’il fonde complètement. (Si on veut, passez le curd au chinois et réservez à température ambiante.)
Mousse citron :
Zestez le citron. Pressez le jus. Ajoutez la gélatine au préalablement ramollie dans de l’eau froide. Faites chauffer le tout pour fondre la gélatine. Ajoutez au curd lorsque le jus est refroidi. Montez la crème en chantilly et mélangez au curd. Placez dans les inserts garnis de film et mettez au congélateur.
Le cake au citron :',
  'Rq : essayer avec 2 œufs seulement car beaucoup de restes de cake…
Le sablé breton au citron : (pour 27x35)
125g (187g) de beurre demi-sel, 100g (150g) de sucre en poudre, 1.5g de fleur de sel, 50g (75g) de jaunes d’œufs, 155g (232g) de farine, 3 g (5g) de levure chimique, le zeste d’un citron.
Dans le bol du robot, mélangez avec le fouet plat pendant 2min le beurre pommade, le sucre et le sel. Ajoutez les jaunes et mélangez pendant encore 2min. Incorporez ensuite la farine tamisée avec la levure et le zeste du citron. Mélangez sans travailler longtemps, aplatissez la pâte en un rectangle de 20x30cm et 3mm d’épaisseur entre 2 feuilles guitare (ou papier sulfurisé) réservez au réfrigérateur une heure ou au congélateur 15 min. Préchauffez le four à 200°. Mettez le carré de pâte dans un cadre à entremets carré de 20×30 non beurré et enfournez 12min à 14min à vérifier. Quand le biscuit est refroidi coupez délicatement 2 bandes de la largeur de la gouttière à bûche, réservez.
La mousse Jivara citron :
400g de couverture Jivara lactée ou d’un chocolat au lait à 40%, 285g de lait frais entier, 6g de gélatine soit 3 feuilles, 570g de crème fleurette à 35%, le zeste d’un citron.
Faites fondre le chocolat au bain-marie. Parallèlement faites bouillir le lait. Hors du feu ajoutez-y la gélatine préalablement ramollie dans de l’eau froide et essorée. Mélangez au fouet en versant le lait chaud en 3 fois sur le chocolat. Mélangez bien et laissez refroidir entre 35°/40°. Montez la crème en chantilly (pour obtenir une consistance mousseuse). Versez le chocolat dans la crème montée et mélangez bien de bas en haut en un mouvement qui part du centre pour obtenir une mousse bien homogène, ajoutez le zeste de citron finement râpé.
Rq : pas assez de mousse pour 2 bûches…
Le montage : 
Versez au fond du moule chemisé d’une feuille guitare 1/3 de la mousse légère Jivara citron, recouvrez d’une bande de cake au citron, démoulez la mousse au citron posez-la sur le cake, recouvrez le tout avec le reste de mousse légère. Terminez en ajoutant le sablé breton. Bloquez au grand froid.
La finition : 
Démoulez la bûche encore congelée. Plusieurs possibilités s’offrent à vous. La plus simple, poudrez la bûche avec du cacao en poudre, ajoutez quelques éléments de décoration, et laissez revenir à température au réfrigérateur pendant 6 heures environ avant de la déguster. Vous pouvez aussi réaliser un glaçage.
Le glaçage Jivara : 95g de chocolat Jivara ou à de chocolat au lait à 40%, 125g soit 1/8 de litre de crème fleurette à 35%, 30g de miel d’acacia, 30g de beurre.
Faites fondre le chocolat au bain-marie et bouillir la crème et le miel. Réalisez une émulsion en versant la crème en 3 fois sur le chocolat et en frictionnant énergiquement à la maryse. Quand la température du mélange est entre 35° et 40° ajoutez le beurre coupé en dés et lissez au mixer plongeant pour homogénéiser le tout. Placez la bûche tout juste sortie du congélateur sur une grille à pâtisserie posée sur un plateau pour pouvoir récupérer l’excédent de glaçage et recouvrez-la entièrement, lissez éventuellement à la spatule. Réservez au réfrigérateur et décorez à votre guise au moment de servir.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bûche chocolat, insert framboise',
  'buche-chocolat-insert-framboise',
  'Délicieuse recette de dessert.',
  'Bûche mousse chocolat, insert framboise
Pour 2 bûches (moules bûche rond, petit moule cake…)
Insert framboise (2 inserts) :					1 insert
300g coulis framboises						200g
80g sucre								50g
3 feuilles de gélatine						2
150g crème fleurette						100g
Faites chauffer le coulis avec le sucre. Ajoutez la gélatine au préalablement trempée dans de l’eau froide. Montez la crème en chantilly et ajoutez-y le coulis de framboise. Versez dans les moules à insert et bloquez au congélateur.
Génoise :
3 œufs
75g sucre
75g de farine',
  'Etalez sur une plaque et faites cuire 10-12 minutes th 180°.
Mousse chocolat : 2 bûches					1 bûche
140g de sucre							85g
210g d’œufs entiers						125g
50cl crème fleurette						30cl
375g de chocolat noir de couverture				225g
Faites fondre le chocolat au bain-marie. Une fois les pistoles fondues, retirez du feu et réservez. Versez le sucre avec 5 à 10cl d’eau et portez à ébullition. Pendant ce temps, cassez les œufs dans le bol du batteur. Fouettez les œufs entiers au batteur électrique et incorporez à petite vitesse le sucre cuit bouillant en le faisant couler sur la paroi interne de la cuve. Augmentez la vitesse du batteur au maximum, et fouettez jusqu''à complet refroidissement.
Le montage :
Garnissez le moule de papier rhodoïd. Etalez une partie de la mousse au chocolat. Ajoutez l’insert framboise puis le reste de la mousse au chocolat. Posez ensuite la génoise dessus. Bloquez au congélateur.
La finition : 
Démoulez la bûche encore congelée. Plusieurs possibilités s’offrent à vous. La plus simple, poudrez la bûche avec du cacao en poudre, ajoutez quelques éléments de décoration, et laissez revenir à température au réfrigérateur pendant 6 heures environ avant de la déguster. Vous pouvez aussi réaliser un glaçage.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bûche coco chocolat, façon bounty',
  'buche-coco-chocolat-facon-bounty',
  'Délicieuse recette de dessert.',
  '(Le meilleur du chef)',
  'Pour 1 bûche (moule bûche ronde)
Insert coco :
170g de lait concentré sucré
120g de noix de coco râpée
Versez dans un cul de poule le lait concentré. Ajoutez la noix de coco et mélangez soigneusement jusqu’à l’obtention d’une pâte homogène. Versez dans le moule à insert en tassant bien et lissez de manière à obtenir une surface plane. Placez au congélateur.
Rocher coco :
1 œuf
90g de sucre en poudre
125g de noix de coco râpée
Cassez l’œuf dans un cul de poule. Ajoutez le sucre et la noix de coco. Mélangez jusqu’à l’obtention d’une pâte homogène. Préparez un cadre de dimension 30 cm de long et étalez la pâte sur ½ cm d’épaisseur. Coupez une bande de largeur 8 cm. Avec le surplus de pâte, confectionnez des petites boules de pâte qui serviront à la décoration.
Faites cuire thermostat 160°C jusqu’à ce que le biscuit soit coloré (environ 15 minutes).
Glaçage chocolat :
60g de chocolat noir
25g d’huile de pépins de raisin
Faites fondre le chocolat au bain-marie. Hors du feu, ajoutez l’huile de pépins de raisin et mélangez bien. Sortez l’insert coco du congélateur. Au pinceau, badigeonnez la surface plane de l’insert avec le glaçage. Démoulez l’insert et badigeonnez les autres faces de l’insert au pinceau en veillant bien à le placer auparavant sur une grille munie d’un plat pour récupérer le surplus de chocolat. Dès que le glaçage est pris, replacez le tout au congélateur.
La mousse chocolat au lait :
200g de chocolat au lait à 40%, 140g de lait frais entier, 1,5 feuille, 280g de crème fleurette à 35%.
Faites fondre le chocolat au bain-marie. Parallèlement faites bouillir le lait. Hors du feu ajoutez-y la gélatine préalablement ramollie dans de l’eau froide et essorée. Mélangez au fouet en versant le lait chaud en 3 fois sur le chocolat. Mélangez bien et laissez refroidir entre 35°/40°. Montez la crème en chantilly (pour obtenir une consistance mousseuse). Versez le chocolat dans la crème montée et mélangez bien de bas en haut en un mouvement qui part du centre pour obtenir une mousse bien homogène.
Le montage : 
Versez au fond du moule chemisé d’une feuille guitare 1/3 de la mousse au chocolat au lait, placez l’insert coco, puis recouvrez le tout avec le reste de mousse. Terminez en ajoutant le rocher coco. Bloquez au grand froid.
La finition : 
Démoulez la bûche encore congelée. Plusieurs possibilités s’offrent à vous. La plus simple, poudrez la bûche avec du cacao en poudre, ajoutez quelques éléments de décoration, et laissez revenir à température au réfrigérateur pendant 6 heures environ avant de la déguster. Vous pouvez aussi réaliser un glaçage.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bûche mousse fraises, insert framboise',
  'buche-mousse-fraises-insert-framboise',
  'Délicieuse recette de dessert.',
  'Pour 2 bûches (moules à cake, 1 grand et 1 petit)
Insert framboise (5 mini moules bûches silicone) :
300g coulis framboises
30g sucre
3 feuilles de gélatine
quelques framboises
Mélangez le tout. Versez dans les mini moules et bloquez au congélateur.
Génoise :
2 œufs
50g sucre
50g de farine',
  'Etalez sur une plaque et faites cuire 10-12 minutes th 180°.
Mousse fraises :
700g coulis fraises
6 feuilles de gélatine
50cl crème fleurette
Le montage :
Garnissez le moule de papier rhodoïd. Etalez une partie de la mousse aux fraises. Ajoutez l’insert framboise puis le reste de la mousse aux fraises. Posez ensuite la génoise dessus. Bloquez au congélateur.
La finition : 
Démoulez la bûche encore congelée. Plusieurs possibilités s’offrent à vous. La plus simple, poudrez la bûche avec du cacao en poudre, ajoutez quelques éléments de décoration, et laissez revenir à température au réfrigérateur pendant 6 heures environ avant de la déguster. Vous pouvez aussi réaliser un glaçage.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bûche mousse pommes, caramel',
  'buche-mousse-pommes-caramel',
  'Délicieuse recette de dessert.',
  'Bûche mousse pommes/caramel
Pour 1 bûche (moule bûche ronde)
Mousse pommes :
180g de compote
1 feuille de gélatine
5 cl de crème fleurette
2 pommes cuites caramélisées
Craquant :
110g de pralinoise
40-45g de crêpes dentelle émiettées
Mousse caramel :
145g de sucre
85g de beurre salé
4 feuilles de gélatine
47cl de crème fleurette
Le montage :',
  'Faites ramollir la feuille de gélatine dans de l’eau froide.  Chauffez une cuiller de liqueur à la pomme (ou d’eau) et faites dissoudre la gélatine dedans. Mélangez à la compote. Montez la crème en chantilly et mélangez à la compote.
Dans l’insert, versez la mousse de pommes, des morceaux de pommes caramélisées et le reste de la mousse. Placez au congélateur.
Faites fondre la pralinoise au bain-marie. Ajoutez les crêpes. Mélangez et garnissez un moule de la taille du moule à bûche (~30x8).
Faites ramollir la gélatine dans un bol d’eau froide. Faites bouillir dans une casserole 12 cl de crème. Versez le sucre dans une casserole et faites-le chauffer jusqu’à l’obtention d’un caramel. Retirez-le du feu et ajoutez le beurre salé en petits morceaux en fouettant puis la crème liquide bouillante. Essorez la gélatine et ajoutez-la dans le caramel en fouettant.
Pendant que le caramel refroidit, montez les 35 cl de crème restants en chantilly. Mélangez délicatement le caramel et la chantilly.
Tapissez le fond du moule de film transparent. Versez de la mousse au caramel en faisant remonter la crème sur les côtés. Placez l’insert mousse de pommes encore congelé au centre puis complétez avec le reste de mousse au caramel. Posez le craquant sur la mousse puis bloquez au congélateur.
La finition : 
Démoulez la bûche encore congelée. Plusieurs possibilités s’offrent à vous. La plus simple, poudrez la bûche avec du cacao en poudre, ajoutez quelques éléments de décoration, et laissez revenir à température au réfrigérateur pendant 6 heures environ avant de la déguster. Vous pouvez aussi réaliser un glaçage.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Bounty maison',
  'bounty-maison',
  'Délicieuse recette de dessert.',
  '(Ôdélices)
1 boîte de lait concentré sucré
200g de noix de coco
300g de chocolat noir ou lait pâtissier',
  'Mélangez dans un saladier le lait concentré et la noix de coco râpée.
Etalez ce mélange sur 2 cm d’épaisseur dans un moule carré (ou sur une plaque) recouvert de papier cuisson.
Recouvrez d’un film alimentaire et placez au frigo une nuit.
Le lendemain sortez du réfrigérateur et découpez en rectangle.
Façonnez les rectangles avec les doigts pour obtenir une jolie forme arrondie.
Placez 30 min au congélateur pour durcir la pâte.
Dans un bol faites fondre le chocolat au bain-marie ou au four à micro-onde en mélangeant toutes les 30 secondes.
Sortez les barres coco du congélateur. A l’aide d’une fourchette attrapez une barre coco, trempez-la dans le chocolat fondu. Recouvrez bien de chocolat, rattrapez la barre avec la fourchette, tapotez pour ôter l’excédent de chocolat et raclez la fourchette sur le rebord du bol. Posez délicatement sur une feuille de papier cuisson. Déposez la fourchette sur la barre chocolatée pour la marquer.
Recommencez pour toutes les barres coco.
Placez les barres coco choco au frais jusqu’à ce que le chocolat soit durci.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rochers au praliné',
  'rochers-au-praline',
  'Délicieuse recette de dessert.',
  '(Cuisine AZ)
200 g de pralinoise
50 g de chocolat noir à 70% de cacao
75 g de crêpes dentelles
25 noisettes entières',
  'Faites fondre le chocolat et la pralinoise au bain-marie.
Remuez jusqu’à ce que le mélange soit bien lisse.
Émiettez les crêpes dentelles et ajoutez-les aux chocolats fondus. Mélangez bien.
Placez au frais pendant 30 min.
Formez des petites boules de taille égale à la main, et insérez-y une noisette au centre.
Réservez au frais avant de servir.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Shortbread Millionnaire (Pasca)',
  'shortbread-millionnaire-pasca',
  'Délicieuse recette de dessert.',
  'Shortbread Millionnaire
Pour la pâte sablée
50g de sucre
1 sachet de sucre vanillé (facultatif)
1 demi-sachet de levure
120g de beurre demi-sel
180g de farine
Pour le caramel
100g de sucre
120g de beurre
1 boîte de lait concentré sucré (environ 400g)
Glaçage
200g de chocolat au lait',
  'Préchauffez le four à 170°C.
Pour la pâte sablée, travaillez à la main le beurre et le sucre. Mélangez bien. Ajoutez la farine tamisée et la levure. Mélangez de nouveau jusqu''à ce que vous parveniez à former facilement une boule avec la pâte. 
Puis étalez-la dans un moule en silicone (de forme rectangulaire 18x26cm pour moi). Tassez-la avec le dos d''une c à s de façon à ce qu''elle soit peu épaisse et piquez-la avec une fourchette. 
Enfournez pour 25-30 min. Le biscuit doit à peine dorer.
Dans une casserole, faites caraméliser le sucre. Ajoutez le beurre au caramel. Mélangez.
Au micro-onde, faites fondre vos tablettes de chocolat puis versez-le sur la crème au caramel devenue froide. Laissez le moule refroidir puis placez-le au frigo pour plusieurs heures (l''idéal étant de le faire la veille car il sera encore meilleur !).
Coupez-le ensuite en petits carrés et savourez.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Glace au caramel au beurre salé (Glace et sorbet)',
  'glace-au-caramel-au-beurre-sale-glace-et-sorbet',
  'Délicieuse recette de dessert.',
  'Glace au caramel au beurre salé
(Glace et sorbet)
http://glace-sorbet.fr/glace-au-caramel-au-beurre-sale/
Pour la glace elle-même :
15 grammes de sucre en poudre
4 jaunes d’œufs
150 ml de crème liquide type fleurette
350 ml de lait entier',
  'Commencer par préparer la crème caramel :
Mettre la crème à chauffer. Dès qu’elle commence à bouillir, la retirer du feu.
En parallèle, mettre le sucre et l’eau dans une casserole. Faire chauffer à feu doux sans remuer jusqu’à ce que le caramel ait une belle couleur ambrée. Retirer du feu et ajouter le beurre. Verser délicatement la crème et mélanger. Remettre sur feu doux et laisser réduire 5 minutes à petit bouillon, le temps que les morceaux de caramel se dissolvent.
Puis, faire la glace :
Dans un saladier, fouetter les jaunes d’œufs avec le sucre jusqu’à ce que le mélange mousse et blanchisse légèrement.
A part, faire chauffer le lait et la crème à la limite de l’ébullition. Ajouter la crème caramel et mélanger jusqu’à ce que ce soit homogène. Verser sur le mélange jaunes/sucre en mélangeant. Remettre dans la casserole sur feu doux et remuer jusqu’à ce que le mélange épaississe : il doit napper la cuillère.
Réserver dans un récipient propre et laisser refroidir complètement.
Turbiner et surtout… se régaler !
Sortir du congélateur un bon quart d’heure avant le service.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Glace au caramel au beurre salé (Thermomix)',
  'glace-au-caramel-au-beurre-sale-thermomix',
  'Délicieuse recette de dessert.',
  '(En cuisine)
85 g de crème liquide à 15%
300 g de lait écrémé
3 jaunes d''œufs
100 g de sucre blond
3 CS d''eau
20 g de beurre demi-sel',
  '1. Pour le caramel au beurre salé : Mettre le sucre blond à chauffer dans une casserole avec 2 à 3 cuillères à soupe d''eau, remuer la casserole pour que tout le sucre soit bien imbibé d''eau (ne pas utiliser de spatule ou de fouet !).
2. Avec un thermomètre de cuisson (ou juste à la vue et l''odeur si vous n''en avez pas), surveillez la cuisson du caramel (170 à 180°C). Dès qu''il est à la bonne température, le retirer du feu et ajouter le beurre demi sel. Le laisser fondre en remuant la casserole.
3. Pour la glace au caramel beurre salé : Mettre le caramel au beurre salé encore chaud dans le bol du Thermomix avec le lait, la crème liquide et les jaunes d''œufs. Faire cuire 8 minutes à 90°C à vitesse 2.
4. A la sonnerie, verser dans une barquette congélation. Laisser refroidir à l''air libre puis la fermer et la placer au congélateur pour 10 heures minimum.
5. Au moment de servir, mettre la glace en gros morceaux dans le bol du Thermomix et mixer 15 secondes à vitesse 9 en s''aidant de la spatule.
6. Faire des boules et servir aussitôt.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Glace noix de coco (Thermomix)',
  'glace-noix-de-coco-thermomix',
  'Délicieuse recette de dessert.',
  'Glace noix de coco
(Papilles on/off)
http://papilles-on-off.blogspot.fr/2011/09/glace-noix-de-coco-au-thermomix.html
100g de lait concentré sucré
400g de lait de coco (2 briquettes de 20 cl)
100g de lait
Déco : Noix de coco râpée',
  'Suivre les étapes de la recette.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sucre inverti',
  'sucre-inverti',
  'Délicieuse recette de dessert.',
  'En parallèle, faire bouillir 1/2 litre d’eau, seul.
Ce sirop de sucre inverti peut se conserver plus de 6 mois au frais, dans une boite hermétique.',
  'Pour cela, mélanger 1/2 litre (500g) d’eau, 350g de sucre et le jus d’1 citron dans une casserole. Porter à ébullition en mélangeant de temps en temps pour bien dissoudre le sucre. Dès que l’ébullition commence, compter 5 minutes (tout pile !) et couper le feu. Il peut être intéressant d’avoir un thermomètre car idéalement, il faut couper le feu dès que le mélange atteint 114°C. Stopper immédiatement la cuisson en trempant la casserole dans de l’eau froide.
Verser cette eau bouillie dans le sirop pour obtenir un point total de 850g.
Laisser entièrement refroidir à température ambiante.
Comment utiliser le sucre inverti ?
Le sirop de sucre inverti peut être utilisé à chaque fois que l’on veut un résultat moelleux : glaces, sorbets, gâteaux, brioche… Remplacez le sucre en poudre par la même quantité moins 20 % de votre sirop de sucre inverti. Par exemple, si vous devez mettre 100 g de sucre en poudre, mettez 80 g de sirop de sucre inverti (100 g – 20 %).',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sucre pour les glaces',
  'sucre-pour-les-glaces',
  'Délicieuse recette de dessert.',
  'Avec beaucoup d’attention j’ai regarder vos commentaires sur ce sujet très intéressent et si complexe.
Pour ma part j’utilise pour leur propriété plusieurs sucre comme certains d’entre vous …
Je vais essayer d’en donner quelques infos ….déjà connu pour certains d entre vous.
Les sucres ont une influence fondamentale sur la qualité finale d’une glace. Ils va falloir les combiner afin de garder une glace souple.
Rôle des sucres dans une glace:
-contrôler du goût sucré (intensité sucrée)
-contrôler de la température de congélation
-réguler de la texture
-renforcer des arômes
-éviter la formation de cristaux
Chaque sucre possède un pouvoir édulcorant et un pouvoir antigel spécifique.
Le saccharose ou sucre en poudre constitue la valeur de référence pour les autres sucres.
On lui donne la valeur 100 pour son pouvoir édulcorant (sucrant) et pour son pouvoir antigel.
Par exemple, Le dextrose a un pouvoir édulcorant de 70. Par contre, son pouvoir antigel est de 190. Il résistera bien mieux au froid et la glace sera moins dure ! La contrepartie, sera une fonte accélérée.',
  'En combinant les différents types de sucres, il est possible d’obtenir des textures plus crémeuse et moins dures à basse température
Avantages et inconvénients des sucres
– Le saccharose : c’est le sucre en poudre. Il est fabriqué à partir des betteraves ou de la canne à sucre.
Il a l’inconvénient de cristalliser. Il pourra donner une texture sableuse avec des cristaux très durs.
On a intérêt à l’associer avec d’autres sucres.
– Le dextrose : il provient du raffinage de l’amidon maïs. Il se présente sous la forme d’une poudre se dissolvant facilement dans l’eau. Le dextrose possède un fort pouvoir antibactérien. Il a un faible pouvoir sucrant. Il sera utile dans les glaces aux fruits, les sorbets non pasteurisé et les glaces aux herbes aromatiques. Il apporte de la fraîcheur en bouche et permet d’abaisser le point de congélation (-0.55°C par point de %), d’améliorer la texture. Le dextrose a tendance à décolorer et à modifier légèrement le goût des glaces. Une glace contenant du dextrose aura tendance à fondre plus vite. Il n’est pas favorable au foisonnement. C’est souvent le sucre utilisé par les glaciers italiens.
– Le glucose: on le trouve sous une forme la forme de sirop de glucose ou de poudre que l’on appelle glucose atomisé (poudre) ou encore glucose déshydraté ou glucose anhydre. Il existe différents types de glucoses atomisés. On les différencie par le sigle DE qui signifie dextrose équivalent. Plus le DE est faible plus le pouvoir sucrant et antigel est faible.
Le glucose atomisé est un sirop de glucose déshydraté qui ce présente sous forme d’une poudre blanche assurant le rôle de stabilisateur et délivre un apport précieux en extrait sec. Il retarde la dessiccation des produits et leur assure une plus longue conservation tout en leur permettant de conserver leur aspect moelleux.
son ps est évalué a 0,5.
Il est intéressant dans la mesure où il permet d’apporter de la matière sèche au mix sans trop le sucrer. Il est par ailleurs anti cristallisant du saccharose. Il va améliorer la texture, la résistance aux chocs thermiques, la conservation des glaces et sorbets.
Attention, surdosé il donne une sensation collante et pâteuse dans la bouche.
– Le sucre inverti : est utilisé dans les glaces ayant tendance à durcir: glaces au chocolat, aux fruits secs (glace au praliné, glace amandes…). Il va apporter du moelleux et abaisser le point de congélation. Il évite la cristallisation du saccharose. Son inconvénient réside dans son fort pouvoir sucrant. Un excès de sucre inverti donnera une texture pâteuse, collante et entraînera une fonte accélérée.
– Le miel a à peu près les mêmes caractéristiques que le sucre inverti. C’est certainement l’édulcorant connu le plus ancien. Il abaisse le point de congélation car il contient 75% de sucre inverti.
– Le fructose est le sucre des fruits qui a un très fort pouvoir sucrant. Il faudra en tenir compte dans les sorbets aux fruits naturellement sucrés.
La combinaison des sucres va permettre de réguler, contrôler et retarder le point de congélation de l’eau contenu dans des glaces.
Une glace au chocolat ayant tendance à durcir, il faudra utiliser des sucres à fort pouvoir antigel comme le sucre inverti. Au contraire, pour une glace avec de l’alcool, il faudra utiliser des sucres avec un faible pouvoir antigel comme le glucose atomisé.
Conclusion sur l’utilisation des sucres dans les glaces:
Les sucres vont influencer la dureté d’une glace. Ils vont “aspirer” les molécules d’eau qui ne seront plus disponibles pour durcir la glace. La glace va sortir de la sorbetière entre -4°C et -8°c et 50% de l’eau liquide est congelée. A -20°C, 85% de l’eau sera congelée et stabilisée. En cas de réchauffement puis d’un nouveau refroidissement, les cristaux de glace augmenteront de volume et viendront durcir la crème glacée.
Un mélange saccharose – glucose atomisé voir dextrose va permettre d’agir sur le point de congélation et d’obtenir des glaces moins dures, plus onctueuses et avec une vitesse de fonte raisonnable.
Le sucre inverti est tout indiqué pour les glaces ayant tendance à durcir. C’est le cas des glaces contenant beaucoup de matière grasse d’origine végétale : chocolat, aux fruits secs (praliné, amande…) ou coco.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Glaçage au caramel',
  'glacage-au-caramel',
  'Délicieuse recette de dessert.',
  '(Passion pâtisserie)
http://www.passionpatisserie.fr/15-categorie-12385648.html
87 g d''eau
110 g de sucre
75 g de crème
80 g de dessert caramel (plaque comme le chocolat)
2 feuilles de gélatine',
  'Portez l''eau et le sucre à ébullition.
Ajoutez la crème puis à la reprise de l''ébullition ajoutez le caramel.
Retirez du feu et ajoutez la gélatine ramollie.
Laissez refroidir (maxi 30°c) puis versez sur la mousse.
Mettre au frigo.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Nappage miroir noir',
  'nappage-miroir-noir',
  'Délicieuse recette de dessert.',
  '(Passion pâtisserie)
http://www.passionpatisserie.fr/categorie-12385648.html
90 g d''eau
110 g de sucre
75 g de crème liquide
15 g de cacao en poudre
2 feuilles de gélatine',
  'Portez l''eau et le sucre à ébullition. Ajoutez la crème puis le cacao en poudre. Laissez cuire à feu doux 15 min. (ça prend du temps ! le nappage doit être onctueux... quand vous trempez une cuillère à soupe dedans, ça doit rester collé sur le dos et on ne doit pas voir en transparence. Vous pouvez donc le préparer à l''avance).
Retirez du feu et ajoutez la gélatine ramollie.
Laisser épaissir et refroidir (26 - 28 °c).
Sortez la bûche du congélateur, démoulez et nappez... et laissez-la se décongeler au frigo.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Galettes au beurre salé',
  'galettes-au-beurre-sale',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 25 galettes :
250 g de farine
150 g de sucre
½ sachet de levure chimique
60 g de beurre salé mou
1 œuf
2 cs de lait
Dorure : 1 jaune d’œuf et 1 cs de lait',
  'Formez une boule et enveloppez-la dans du film alimentaire. Placez-la au frais pendant 1 heure. Préchauffez le four à 165°C (th 5-6).
Etalez la pâte sur une épaisseur de 5 mm puis découpez des cercles avec un emporte-pièce de 5 cm de diamètre. Disposez les galettes sur une plaque recouverte de papier sulfurisé.
Badigeonnez les galettes avec le jaune d’œuf délayé dans le lait. A l’aide d’une fourchette, striez légèrement le dessus. Faites cuire 10 à 15 minutes jusqu’à ce que les galettes soient joliment dorées.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Barquettes à la fraise',
  'barquettes-a-la-fraise',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 20 barquettes :
biscuits : 100 g de sucre
3 œufs + blancs
80 g de farine
sirop : 2 feuilles de gélatine
20 cl d’eau
2 cs sirop de grenadine
1 cs d’arôme naturel de fraise',
  'Mettez au four environ 10 minutes. Dès la sortie du four et avec le manche arrondi d’un couvert, faites une empreinte régulière et ovale de 1 cm de profondeur. Démoulez. Recommencez l’empreinte si celle-ci ne vous semble pas assez marquée.
Sirop : Faites tremper les feuilles de gélatine dans un bol d’eau très froide. Dans une casserole, faites chauffer l’eau puis ajoutez le sirop de grenadine et l’arôme de fraise. Essorez les feuilles de gélatine et ajoutez-les au sirop. Réservez au réfrigérateur afin que le sirop prenne la consistance d’une gelée. Il doit toutefois rester coulant.
Garnissez le centre des barquettes puis laissez prendre avant de déguster.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Biscuits à la framboise',
  'biscuits-a-la-framboise',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 20 biscuits :
4 œufs
120 g de sucre
120 g de farine
40 g de beurre fondu
250 g de confiture à la framboise (ou orange amère)
250 g de chocolat noir',
  'Dans un saladier, mélangez les œufs et le sucre puis posez le saladier sur une casserole d’eau à feu doux tout en fouettant au batteur jusqu’à ce que le mélange devienne mousseux et triple de volume. Retirez le saladier du bain-marie et continuez de fouetter jusqu’à complet refroidissement. Préchauffez le four à 180°C (th 6).
Versez en pluie la farine tamisée en trois fois en l’incorporant très délicatement jusqu’à ce que la pâte devienne homogène. Ajoutez le beurre fondu et incorporez-le. Sans attendre, versez la pâte dans des moules à muffins et mettez à cuire environ 8 minutes. Laissez refroidir avant de démouler.
Coupez les biscuits en deux dans le sens de la largeur. Déposez une cuillère à café de confiture sur chaque moitié puis reconstituer les biscuits.
Faites fondre le chocolat au bain-marie. Laissez tiédir pour qu’il ne soit pas trop liquide puis versez-le sur les biscuits. Egalisez la surface à l’aide d’une spatule. Laissez le chocolat prendre à température ambiante.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Broyé du Poitou',
  'broye-du-poitou',
  'Délicieuse recette de dessert.',
  '(Papy Hubert)
1 œuf
250g de beurre salé ramolli
250g de sucre semoule
500g de farine',
  'Mélanger le tout.
Etaler la pâte au rouleau à pâtisserie.
Cuire au four 165°C, chaleur tournante, grille du milieu, environ 15 minutes.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Canistrelli au citron',
  'canistrelli-au-citron',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 20 canistrelli :
le zeste d’un citron
300 g de farine
75 g de sucre
1 sachet de sucre vanillé
7 g de levure chimique
7 cl de vin blanc
7 cl d’huile
50 g de sucre glace',
  'variante : qq gouttes d’huile essentielle (alimentaire) de citron relèveront agréablement la saveur des canistrelli
Préchauffez le four à 180°C (th 6). Dès que tous les éléments sont amalgamés, pétrissez rapidement la pâte pour former une boule qui ne doit pas être collante.
Sur une surface farinée, étalez la pâte sur une épaisseur de 1 cm. Découpez des biscuits à l’aide d’un emporte-pièce (fleur ou autre…). Enfournez 10 minutes, baissez la température du four à 150°C (th 5) puis prolongez la cuisson de 8 à 10 minutes.
Les canistrelli doivent être blond pâle mais fermes lorsque vous essayez d’enfoncer votre doigt sur la surface. Laissez-les refroidir puis saupoudrez-les légèrement de sucre glace.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Carrés à la menthe',
  'carres-a-la-menthe',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 20 carrés :
pâte : 175 g de farine
60 g de sucre
½ sachet de sucre vanillé
1 cs de cacao non sucré
125 g de beurre
1 jaune d’œuf
ganache : 100 g de chocolat noir
10 cl de crème fraîche liquide
10 feuilles de menthe
15 g de beurre',
  'Pâte : Dans un saladier, tamisez la farine puis ajoutez le sucre, le sucre vanillé et le cacao. Mélangez bien. Ajoutez le beurre découpé en morceaux et le jaune d’œuf. Travaillez de façon à obtenir une pâte souple. Formez une boule, enveloppez-la de film alimentaire et placez-la au frais pendant 1 heure. Préchauffez le four à 180°C (th 6).
Etalez la pâte sur une épaisseur de 4 mm d’épaisseur puis découpez des carrés de 4 cm de côté. Posez-les sur une plaque recouverte de papier sulfurisé beurré et fariné. Faites cuire 10 à 15 minutes. Laissez refroidir quelques minutes avant de déposer les carrés sur une grille.
Ganache : Découpez le chocolat en morceaux. Faites chauffer la crème dans une casserole, ajoutez la menthe et laissez infuser 5 minutes. Filtrez puis portez à ébullition avant de verser sur le chocolat en remuant bien. Incorporez le beurre découpé en morceaux et mélangez. Laissez refroidir la ganache.
A l’aide d’une poche à douille garnissez la moitié des biscuits avec la ganache. Recouvrez ensuite d’un biscuit.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cookies au caramel et flocons d''avoine (Ôdélices)',
  'cookies-au-caramel-et-flocons-d-avoine-odelices',
  'Délicieuse recette de dessert.',
  'Cookies au caramel et flocons d’avoine
(Ôdélices)
150 g de farine
120 g de beurre mou
130 g de flocons d’avoine
60 g de caramels mous
100 g de sucre
1 gros œuf
½ sachet de levure',
  'Suivre les étapes de la recette.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cookies aux flocons d''avoine et aux raisins',
  'cookies-aux-flocons-d-avoine-et-aux-raisins',
  'Délicieuse recette de dessert.',
  'Cookies aux flocons d’avoine et aux raisins
(Livre Josette)
Pour 20 à 25 gros cookies :
225 g de farine
125 g de noix de coco râpée
1 cc de bicarbonate de soude
½ cc de cannelle en poudre
½ cc de gingembre en poudre
½ cc de sel
250 g de beurre ramolli
200 g de cassonade
6 cs de sirop d’érable
1 gros œuf
1 ½ cc vanille liquide
375 g de gros flocons d’avoine
180 g de raisins secs
Préchauffez le four à 170°C (th 5-6) et tapissez deux plaques de cuisson de papier sulfurisé.',
  'A l’aide d’une cuillère à soupe, façonnez des boules de pâte de la taille d’une noix et déposez-les sur les plaques de cuisson en les espaçant bien. Enfournez 15 à 20 minutes, jusqu’à ce que les cookies soient bien dorés. Laissez-les reposer 5 minutes sur les plaques de cuisson puis transposez-les sur des grilles pour qu’ils finissent de refroidir.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cookies aux flocons d''avoine',
  'cookies-aux-flocons-d-avoine',
  'Délicieuse recette de dessert.',
  'Cookies aux flocons d''avoine express
Pour une quarantaine de cookie :
300 g de farine
160 g de flocons d''avoine
250 g de beurre bien mou
180 g de cassonade
2 œufs
1 sachet de levure
1 pincée de sel
une tablette de chocolat au lait ou des pépites de chocolat
Préchauffez le four à 190°C.
Travaillez ensemble le beurre et le sucre. Incorporez les œufs un à un bien mélangez.
Dans un autre saladier, mélangez la farine, la levure, les flocons d''avoine et le sel.
Incorporez le mélange farine/flocons d''avoine au beurre/sucre.
Ajoutez le chocolat coupé en pépites.
Sur une plaque à pâtisserie recouverte de papier de cuisson, disposez des petits tas de pâte, bien espacés les uns des autres. Aplatissez-les avec votre paume de main.
Pour finir
Mettez à cuire 10 minutes environ, le bord des cookies doit juste commencer à dorer.
Laissez refroidir quelques instants les cookies avant de les décoller de la plaque et laissez les refroidir à plat.',
  'Cuisson 10 mn
Temps Total 15 mn',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cookies aux noix façon brownies',
  'cookies-aux-noix-facon-brownies',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 20 à 24 cookies :
250 g de chocolat noir
90 g de beurre
3 gros œufs
1 cc d’extrait de vanille liquide
75 g de farine
½ cc de levure chimique
½ cc de sel
180 g de pépites de chocolat noir
125 g de noix grossièrement concassées',
  'Versez la farine, la levure et le sel, puis mélangez bien le tout. Ajoutez les pépites de chocolat et les noix. Déposez de dix à douze cuillerées à soupe de pâte ainsi obtenue sur chaque plaque de cuisson.
Enfournez pour 10 à 12 minutes, jusqu’à ce que les cookies se craquellent un peu, tout en restant tendres. Laissez-les reposer sur les plaques de cuisson, jusqu’à ce qu’ils durcissent légèrement, puis transposez-les sur des grilles pour qu’ils finissent de refroidir.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cookies',
  'cookies',
  'Délicieuse recette de dessert.',
  '- 150g de cassonade
- un œuf
- 180g de farine
- ½ sachet de levure
- 100g de pépites de chocolat
Rq : 10 minutes de cuisson suffisent…',
  'Formez des petites boules de pâte avec vos mains et disposez-les sur une plaque recouverte de papier sulfurisé.
Faites cuire 10 à 12 minutes dans le four (th 180°C), chaleur tournante.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Croquants des îles',
  'croquants-des-iles',
  'Délicieuse recette de dessert.',
  '160 g de sucre
150 g de beurre ramolli
150 g de farine
6 g de levure chimique
125 g de noix de coco râpée',
  'Préchauffez le four à 180°C (th 6).
Dans un saladier, fouettez les œufs et le sucre jusqu’à ce que le mélange soit mousseux. Ajoutez le beurre ramolli. Incorporez la farine avec la levure et 100 g de noix de coco. Mélangez bien.
A l’aide de petites cuillers, formez des petits tas en prenant soin de bien les espacer. Faites cuire 15 minutes en saupoudrant le reste de noix de coco au milieu de la cuisson. (facultatif)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Délices pur beurre',
  'delices-pur-beurre',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 40 délices :
220 g de farine
120 g de beurre demi-sel découpé en dés
110 g de sucre
1 œuf entier + 1 jaune
2 cs de jus d’orange
Laissez les biscuits légèrement dorer, sortez-les du four puis laissez-les refroidir sur une grille.',
  'Préchauffez le four à 180°C (th 6). Versez la farine dans un saladier, ajoutez les dés de beurre et le sucre. Incorporez peu à peu la farine en pluie puis l’œuf entier et mélangez rapidement. Ajoutez le jus d’orange. Mélangez. Laissez reposer une nuit. Farinez bien le plan de travail. Etalez la pâte sur une épaisseur de 5 mm.
Découpez des biscuits en utilisant un emporte-pièce. Déposez-les sur une plaque de four recouverte de papier sulfurisé en prenant soin de bien les espacer.
Badigeonnez les biscuits de jaune d’œuf battu en vous aidant d’un pinceau. Mettez cuire 8 à 10 minutes.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Fondants à la banane',
  'fondants-a-la-banane',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 24 fondants :
100 g de beurre mou
230 g de sucre
2 œufs
3 bananes
200 g de farine
½ sachet de levure chimique
1 cc de jus de citron
1 cs de rhum brun
Sortez les muffins du four puis laissez-les refroidir avant de les démouler sur une grille.',
  'Fouettez le beurre mou. Ajoutez le sucre puis les œufs. Ecrasez 2 bananes pelées et incorporez-les au mélange précédent, ainsi que la farine tamisée et la levure. Versez le jus de citron et le rhum. Remuez bien. Terminez en ajoutant la banane restante coupée en dés puis en mélangeant délicatement.
Préchauffez le four à 180°C (th 6). Humectez légèrement les moules à muffins puis remplissez-les de pâte aux deux tiers.
Faites cuire 20 minutes le temps que les petits gâteaux soient dorés et gonflés. Vérifiez la cuisson avec la lame d’un couteau : si elle ressort sèche, les muffins sont cuits.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Langues de chat (Ôdélices)',
  'langues-de-chat-odelices',
  'Délicieuse recette de dessert.',
  'Langues de chat
(Ôdélices)
75 g de beurre
100 g de sucre glace
1 cuillère à café d''extrait de vanille
3 blancs d''œufs
100 g de farine',
  'Suivre les étapes de la recette.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Meringues',
  'meringues',
  'Délicieuse recette de dessert.',
  '(ChefNini)
http://www.chefnini.com/reussir-meringues-francaises/
Pour 20 meringues :
2 blancs d’œuf
125g de sucre en poudre
quelques gouttes de jus de citron (2-3)
1 pincée de sel
Séparez les blancs des jaunes et laissez reposer les blancs à température ambiante pendant 1 heure dans un récipient recouvert d’un linge : ce n’est pas obligatoire, mais vous mettez toutes les chances de votre côté pour obtenir des blancs en neige bien volumineux.',
  '1- Versez les blancs dans un saladier avec le sel.
2- Commencez à fouetter les blancs au batteur électrique (ou au fouet à la main).
3- Lorsque les blancs deviennent mousseux (comme sur la photo ci-dessous), commencez à versez le sucre petit à petit.
4- Ajoutez tout de suite le jus de citron.
5- Cessez de fouetter lorsque les blancs sont bien fermes (techniquement, on dit « serrés »). Lorsque vous sortez vos fouets de la meringue, des pics doivent se former. C’est ce qu’on appelle un bec d’oiseau.
Une autre astuce pour vérifier que les blancs sont bien montés : retournez (avec prudence) votre saladier. Les blancs ne doivent pas bouger.
6- Faites préchauffer votre four à 80°C.
7- Déposez du papier sulfurisé ou un tapis en silicone sur une plaque allant au four.
8- A l’aide d’une poche à douille ou d’une cuillère à soupe, réalisez des petits tas en quinconce. Veillez à bien espacer chaque meringue.
9- Enfournez pour 2h, dans la partie basse du four pour les fours électriques et dans la partie haute pour les fours à gaz. Toutes les 20 minutes, entrouvrez la porte du four pour faire échapper la vapeur. Surveillez régulièrement.
10- Pour savoir si les meringues sont cuites, essayez d’en décoller une. Si elle se décolle parfaitement bien et que le dessous est cuit, la cuisson est finie. Autrement, retournez toutes les meringues et poursuivez la cuisson 45 min pour finir de cuire l’intérieur et le dessous.
11- En fin de cuisson, laissez la porte entrouverte (en intercalant une cuillère en bois) et laissez les meringues refroidir en même temps que le four.
12- Décollez les meringues délicatement.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Navettes à la fleur d''oranger',
  'navettes-a-la-fleur-d-oranger',
  'Délicieuse recette de dessert.',
  'Navettes à la fleur d’oranger
(Livre Josette)
Pour 50 navettes :
500 g de farine
½ sachet de levure chimique
70 g de beurre fondu
2 œufs entiers + 1 jaune
250 g de sucre
3 cs de d’eau de fleur d’oranger
2 cs de lait',
  'Tamisez la farine et la levure dans un saladier. Dans un autre saladier, travaillez vigoureusement au fouet le beurre fondu, les œufs entiers et le jaune avec le sucre.
Délayez progressivement la pâte avec l’eau de fleur d’oranger. Versez la farine en pluie et mélangez. Préchauffez le four à 190 °C (th 6-7).
Divisez la pâte en 50 parts. Façonnez de petites barquettes effilées aux extrémités et incurvées au centre. Marquez bien une empreinte au centre avec le pouce. Laissez reposer 2 heures.
Au pinceau, badigeonnez les navettes de lait. Mettez à cuire 15 minutes. Laissez refroidir sur une grille.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Palets bretons',
  'palets-bretons',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 20 palets :
80 g de beurre
2 jaunes d’œufs
80 g de sucre
140 g de farine
½ sachet de levure chimique
2 pincées de fleur de sel de Guérande
2 sachets de sucre vanillé',
  'Sortez le beurre du réfrigérateur à l’avance pour qu’il soit à température ambiante puis travaillez-le en pommade avec une cuillère en bois.
Mélangez les jaunes d’œufs et le sucre au fouet. Ajoutez le beurre en pommade, la farine, la levure, la fleur de sel et le sucre vanillé.
Préchauffez le four à 170°C (th 5-6). Travaillez la pâte puis laissez-la reposer au réfrigérateur pendant 2 heures.
Faites un boudin de 5 cm de diamètre puis découpez des tranches de 1 cm que vous déposerez ensuite dans des moules à muffins. Enfournez pour 15 minutes environ.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Petits gâteaux aux blancs d''oeufs',
  'petits-gateaux-aux-blancs-d-oeufs',
  'Délicieuse recette de dessert.',
  'Petits gâteaux aux blancs d’œufs
(A table)
3 blancs d''œufs 
70 gr de sucre 
90 gr de beurre 
60 gr de farine 
1/2 sachet de levure chimique 
Quelques carrés de chocolat pâtissier',
  'Préchauffer le four à 180°C. 
Faire fondre le beurre, y ajouter le sucre, la farine et la levure chimique. Bien mélanger jusqu''à l''obtention d''une pâte bien homogène.
Dans un saladier, monter les blancs en neige bien ferme avec une pincée de sel.
Ajouter délicatement à l''aide d''une maryse les œufs au mélange "beurre-sucre-farine-levure".
Répartir la pâte dans des petits moules , en les remplissant qu''au 3/4 puis enfoncer un petit carré de chocolat dans chaque empreinte.
Enfourner pour une quinzaine de minutes, laisser refroidir sur une grille et saupoudrer de sucre glace.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Petits gâteaux de la tante Mathilde',
  'petits-gateaux-de-la-tante-mathilde',
  'Délicieuse recette de dessert.',
  '(Mémé)
60 g de beurre
1 œuf
125g de sucre
3 cuillères de crème épaisse
½ paquet de levure',
  'Mélanger l’œuf avec le sucre. Ajouter la crème, le beurre fondu puis la farine avec la levure.
Prendre de la pâte que l’on roule en quenelles allongées que l’on roule ensuite dans du sucre cristallisé. Laisser reposer environ 1 heure.
Faire cuire dans un four préchauffé à 165°, grille 3, chaleur tournante, 15 minutes. (13 minutes selon mamie)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Petits moelleux à la bergamote',
  'petits-moelleux-a-la-bergamote',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 36 petits moelleux :
250 g de beurre
230 g de farine
4 œufs
180 g de sucre
1 gousse de vanille
1 cc d’essence de bergamote
Faites cuire 15 à 20 minutes. Laissez tiédir avant de les démouler puis déposez-les sur une grille.',
  'Faites fondre le beurre. Tamisez la farine, ajoutez les œufs un à un puis le sucre et le beurre fondu. Mélangez au fouet afin d’obtenir une pâte lisse.
Fendez la gousse de vanille en deux et grattez les graines avec la pointe d’un couteau. Incorporez-les à la pâte ainsi que l’essence de bergamote. Mélangez bien. Préchauffez le four à 180°C (th6).
Versez la pâte dans des moules à mini-muffins en les remplissant aux trois quarts puis réservez au réfrigérateur pendant 1 heure.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Petits sablés fourrés au chocolat (Ôdélices)',
  'petits-sables-fourres-au-chocolat-odelices',
  'Délicieuse recette de dessert.',
  'Petits sablés fourrés au chocolat
(Ôdélices)
175 g de farine
60 g de beurre
60 g de sucre glace
1 cuillerée à soupe de levure chimique
1 œuf
75 g de chocolat
20 g de lait',
  '1. Mélangez entre vos mains la farine et le beurre, ajoutez ensuite le sucre glace et la levure.
2. Battez l’œuf et réservez en 2 cuillères à soupe qui serviront de dorure. Ajoutez l’œuf battu à la farine, mélangez jusqu’à obtenir une pâte homogène.
3. Laissez reposer au frais 15 min.
4. Faites fondre le chocolat et incorporez le lait. Mélangez et laissez tiédir.
5. Abaissez la pâte sur 3 mm d’épaisseur. Découpez dedans 10 cercles de 6 cm de diamètre et 10 cercles de 7 cm de diamètre.
6. Au centre des petits cercles, déposez une cuillère à café de ganache au chocolat. Déposez par-dessus un disque de pâte plus grand, soudez les bords en pressant délicatement, sans faire sortir le chocolat. Pour bien les souder, humidifiez les bords de la pâte avec un petit pinceau trempé dans de l’eau.
7. Badigeonnez de dorure et enfournez dans le four préchauffé à 180°C durant 15 min environ.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rochers à la noix de coco',
  'rochers-a-la-noix-de-coco',
  'Délicieuse recette de dessert.',
  '(Mamie Odile)
Pour 16 rochers :
- 125g de noix de coco râpée
- 150g de sucre
- une cuiller à café de vanille en poudre (ou liquide)
- 2 œufs
- une pincée de sel',
  'Battez les blancs d’œufs à la fourchette. Ajoutez le sucre et le sel. Faites chauffer sur feu très doux en remuant à la fourchette. Laissez épaissir sans cesser de battre, puis ajoutez la noix de coco et la vanille.
Disposez des petites boules de pâte sur une plaque. Faites cuire à feu doux (150°C) pendant 20 minutes.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Scones anglais',
  'scones-anglais',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 12 scones :
30 g de sucre
1 sachet de levure chimique
340 g de farine
70 g de beurre
1 œuf
170 cl de lait',
  'Dans un saladier, mélangez le sucre, la levure, la farine et le beurre. Ajoutez l’œuf battu et le lait. Pétrissez la pâte pendant 5 minutes.
Laissez reposer la pâte pendant 10 minutes. Farinez votre plan de travail puis étalez la pâte sur une épaisseur de 2 cm.
Préchauffez le four à 220°C (th 7-8). Découpez des cercles de pâte à l’aide d’un emporte-pièce de 5 cm de diamètre.
Déposez les biscuits sur une plaque recouverte de papier sulfurisé puis faites-les cuire pendant 25 minutes. Dégustez les scones lorsqu’ils sont encore tièdes.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Volcans moelleux framboises fraises (Ôdélices)',
  'volcans-moelleux-framboises-fraises-odelices',
  'Délicieuse recette de dessert.',
  'Volcans moelleux framboises fraises
(Ôdélices)
2 petits œufs
40 g de sucre
3 cuillères à soupe de sirop de fraises
1 càc d''eau de fleur d''oranger
1 pincée de sel
60 g de farine
20 g de beurre fondu
32 framboises',
  '1. Dans un saladier, fouettez les œufs et le sucre à l’aide d’un fouet électrique, jusqu’à obtention d’un mélange mousseux.
2. En continuant de fouetter, ajoutez petit à petit le sirop, la fleur d’oranger, le sel, la farine et le beurre fondu.
3. Déposez une framboise au fond de petits moules en forme de pyramide puis répartissez la pâte à gâteau sur le dessus.
4. Faites cuire 15 min dans le four préchauffé à 180°C.
5. Laissez tiédir avant de démouler.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Whoopie pies à la rhubarbe et au chocolat blanc (Ôdélices)',
  'whoopie-pies-a-la-rhubarbe-et-au-chocolat-blanc-odelices',
  'Délicieuse recette de dessert.',
  'Whoopie pies à la rhubarbe et au chocolat blanc
(Ôdélices)
Pour les biscuits :
100 g de beurre ramolli
100 g de sucre
1 œuf
200 g de farine T65
5 cl de crème fraîche
Pour la garniture :
150 g de rhubarbe
30 g de sucre
50 g de chocolat blanc',
  '1. Dans un saladier, battez le beurre ramolli avec le sucre jusqu’à avoir un mélange mousseux.
2. Incorporez l’œuf battu puis la farine.
3. Ajoutez la crème et mélangez bien la pâte.
4. Placez le mélange 1h au réfrigérateur.
5. Formez des boules de pâte et placez-les sur une plaque recouverte de papier sulfurisé. Mouillez vos mains et aplatissez les boules.
6. Faites cuire 10 min dans le four préchauffé à 180°C.
Pour la garniture :',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Whoopies au chocolat',
  'whoopies-au-chocolat',
  'Délicieuse recette de dessert.',
  '(Livre Josette)
Pour 12 whoopies :
125 g de farine
½ sachet de levure chimique
1 pincée de sel
15 g de cacao en poudre non sucré
100 g de sucre
½ œuf
6 cl d’huile
9 cl de lait
100 g de chocolat noir
5 cl de crème fraîche liquide
Recouvrez ensuite d’un autre biscuit. Réservez au réfrigérateur avant de déguster.',
  'Préchauffez le four à 175°C (th 6-7). Tamisez la farine puis ajoutez la levure, le sel, le cacao et le sucre. Mélangez bien. Dans un saladier, fouettez l’œuf avec l’huile et le lait. Incorporez petit à petit le mélange à base de farine.
Sur une plaque, déposez plusieurs cuillères à café de pâte en prenant soin de bien les espacer. Faites cuire environ 12 minutes, jusqu’à ce que les biscuits soient bien fermes. Laissez-les refroidir quelques minutes avant de les déposer sur une grille.
Découpez le chocolat en morceaux. Faites chauffer la crème puis versez-la doucement pour bien faire fondre le chocolat. Faites refroidir la ganache. A l’aide d’une poche à douille, garnissez la moitié des biscuits.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tarte au citron meringuée',
  'tarte-au-citron-meringuee',
  'Délicieuse recette de dessert.',
  '(la cuisine de Mercotte)
L’appareil au citron :
le zeste et le jus de 3 citrons
3 œufs
60g de beurre pommade
120g de sucre glace
La meringue :
3 blancs d’œufs, 150g de sucre en poudre',
  'La finition : Étalez, versez, pochez au choix,  la crème encore tiède dans les fonds de tarte ou tartelettes refroidis et chablonnés (enduire  les fonds de tarte d’une fine couche de chocolat fondu à l’aide d’un pinceau dans le but d’éviter à la pâte de ramollir. La couche une fois refroidie imperméabilise). Lissez à la spatule coudée. Décorez éventuellement, ici une perle craquante Valrhona.
Battez les blancs en neige très ferme. Ajoutez le sucre et continuez à battre pendant 5 bonnes minutes. Dressez la meringue sur la tarte puis dorez-la avec un chalumeau. Réservez au frais jusqu’au moment de servir.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tarte poire chocolat',
  'tarte-poire-chocolat',
  'Délicieuse recette de dessert.',
  '1 pâte feuilletée
120g de chocolat dessert
50g de crème liquide
1 grosse boîte de poires au sirop
1 œuf
1 sachet de sucre vanillé
sucre et crème (pour le battu, c’est au pif…)',
  'Faire fondre le chocolat avec un peu d’eau. Ajouter la crème liquide. Mélanger puis garnir le fond de tarte.
Couper les poires en lamelles et les répartir sur le mélange chocolat-crème. Faire un battu avec l’œuf, le sucre, le sucre vanillé et la crème. Verser le battu sur la tarte.
Faire cuire à 180°C (pour moi mais ça dépend des fours…, je ne sais pas combien de temps…, je surveille et je regarde quand c’est bien doré au-dessus…)',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartelette au citron',
  'tartelette-au-citron',
  'Délicieuse recette de dessert.',
  '(la cuisine de Mercotte)
L’appareil au citron pour un fond de tarte de 20cm ou quelques tartelettes :
le zeste et le jus de 2 citrons – ou 1citron 1/2 selon les goûts
2 œufs
40g de beurre pommade
80g de sucre glace',
  'La finition : Étalez, versez, pochez au choix,  la crème encore tiède dans les fonds de tarte ou tartelettes refroidis et chablonnés (enduire  les fonds de tarte d’une fine couche de chocolat fondu à l’aide d’un pinceau dans le but d’éviter à la pâte de ramollir. La couche une fois refroidie imperméabilise). Lissez à la spatule coudée. Décorez éventuellement, ici une perle craquante Valrhona.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartelette poire chocolat',
  'tartelette-poire-chocolat',
  'Délicieuse recette de dessert.',
  '1 grande boîte de poires au sirop
1 c. à café de maïzena
20 cl de lait
20 cl de crème liquide.
sucre vanillé
120 g de chocolat
10 cl de crème liquide
Crème de poires :
Réduisez les poires en purée dans un blender avec la moitié du sirop.
Faites chauffer la moitié du lait dans une casserole.',
  'Montez la crème fraîche en chantilly et mélangez délicatement à la purée de poires.
Mettez au réfrigérateur pendant au moins 1 heure.
Ganache au chocolat :
Ajoutez une fine couche de ganache au chocolat sur la tartelette.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartelette à la mousse de framboises',
  'tartelette-a-la-mousse-de-framboises',
  'Délicieuse recette de dessert.',
  '(Novice en cuisine)
Pour la pâte :
200g de farine
100g de beurre
2 cuillères à soupe de cacao en poudre
Une cuillère à soupe de sucre
Un demi-verre d''eau
Une pincée de sel
Pour la mousse de framboises :					Pour la décoration :
200g de framboises						6 belles framboises
100g de sucre glace						un peu de vermicelles au chocolat
10cl de crème liquide
3 blancs d’œufs
Une pincée de sel',
  'La pâte :
Mettez la farine, le sucre en poudre, le cacao et le sel dans le bol du robot.
Ajoutez le beurre ramolli et mélangez jusqu’à obtention d’un mélange sableux.
Ajoutez un demi-verre d’eau en filet et travaillez la pâte.
Formez une boule, couvrez le bol et le laisser au frais 30min.
Préchauffez le four à 180°C.
Etalez la pâte sur le plan de travail fariné puis garnissez en vos moules à tartelettes.
Piquez la pâte avec une fourchette,  couvrez de papier sulfurisé et remplissez de billes céramiques.
Faites cuire les fonds de tarte 30min et laissez-les refroidir.
La mousse :
Lavez les framboises et mixez les jusqu’à obtention d’une purée.
Montez la crème en chantilly, en ajoutant le sucre glace lorsqu’elle commence à prendre.
Mélangez la chantilly à la purée de framboises.
Remplissez les fonds de tarte de mousse de framboises et placez-les au frais au moins 1h.
Juste avant de servir, décorez les tartelettes de framboises entières et des vermicelles de chocolat.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartelette à la mousse de mangue',
  'tartelette-a-la-mousse-de-mangue',
  'Délicieuse recette de dessert.',
  '(La table de Marie-Chantal)
Mettre la feuille de gélatine à détendre dans un verre d''eau froide pendant 10 mn à peu près.
Déguster bien frais.',
  'Pour la mousse de mangue :
300g de mangue surgelées
2 cs de sucre en poudre
le jus d''1/2 citron vert
100ml de crème liquide bien fraîche
1 cs de sucre
1 feuille de gélatine
Décongeler la mangue, puis la passer au mixer. Ajouter le sucre ainsi que le jus du 1/2 citron. Mixer de nouveau. Faire légèrement chauffer 3 cs de mangue mixée puis ajouter la feuille de gélatine essorée. Bien mélanger et finir en ajoutant ce mélange chaud au reste de mangue mixée. Bien mélanger le tout et réserver.
A l''aide du batteur, fouetter la crème liquide, ajouter le sucre et fouetter à nouveau pendant quelques minutes. Mélanger délicatement la crème fouettée à la mangue, puis remplir les fonds de tartelettes. Placer au réfrigérateur pour 4 h.',
  30, 30, 6,
  (SELECT id FROM public.categories WHERE slug = 'dessert')
) ON CONFLICT (slug) DO NOTHING;

-- Apéritif (66 recipes)

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Biscuits salés aux lardons et au parmesan',
  'biscuits-sales-aux-lardons-et-au-parmesan',
  'Délicieux apéritif maison.',
  '(Cahier de gourmandises)
http://cahierdegourmandises.fr/2013/11/22/biscuits-lardons-parmesan/
180 g de farine
100 g de parmesan râpé
1/2 sachet de levure chimique
70 g de beurre demi-sel ramolli
1 œuf
2 cuillères à soupe d''huile d''olive
100 g d''allumettes de lardons
Thym
Sel et poivre',
  'Cuisson : 15 min
Total : 45 min
Mélanger le beurre mou et le parmesan.
Ajouter la farine, puis l’huile d’olive et l''œuf.
Ajouter le thym. Saler et poivrer.
Pétrir jusqu’à obtenir un mélange homogène.
Incorporer les lardons à l''aide d''une spatule.
Former deux boudins de 3 à 4 cm de diamètre.
Découper de petites boules (tranches d''environ 1 cm). Les déposer en les aplatissant légèrement sur une plaque recouverte de papier sulfurisé.
Faire cuire 15 min à 180°C.
Laisser refroidir avant de servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cake aux olives',
  'cake-aux-olives',
  'Délicieux apéritif maison.',
  '1 paquet de levure
4 œufs
20 cl d’huile
10 cl de vin blanc sec
10 cl de Martini blanc
200 g de jambon (coupé en dés)
160 g d’olives vertes dénoyautées et coupées en 4
150 g de gruyère râpé
poivre
Remarque : je prépare le cake dans mon robot… donc pas de cuiller en bois ni de fouet électrique…',
  'Mélanger farine, levure et œufs avec une cuiller en bois. Ajouter l’huile. Mélanger à nouveau. Ajouter le vin blanc et mélanger au fouet électrique. Ajouter le Martini et mélanger avec la cuiller en bois. Ajouter jambon, olives, gruyère. Poivrer.
Verser dans deux petits moules à cake beurrés et farinés. Cuire à four moyen (165°C) 40 minutes environ. Démouler tiède.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cake croque monsieur',
  'cake-croque-monsieur',
  'Délicieux apéritif maison.',
  '(Les délices de Caroline)
200ml de crème liquide
1 crottin de chèvre
3 œufs
12 tranches de pain de mie complet sans croûte
4 tranches de jambon
20g de parmesan
sel, poivre',
  'Préchauffez le four à 180°C.
Faites chauffer la crème liquide et faites fondre dedans le crottin de chèvre. Salez, poivrez. Réservez.
Recommencez l''opération.
Enfournez et cuire 30 minutes à 180°C.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cake montagnard',
  'cake-montagnard',
  'Délicieux apéritif maison.',
  '(Cuisine AZ)
150 g de jambon cru
100 g de tome de Savoie
100 g de beaufort
100 g de champignons
100 g de beurre
225 g de farine
1 sachet de levure chimique
4 œufs
10 cl de crème liquide
beurre et farine pour le moule
sel, poivre',
  'Préchauffez le four th.6 (180°C).
Beurrez et farinez le moule à cake. Coupez le jambon, la tome, le beaufort, en dés.
Emincez les champignons. Faites-les sauter à l''huile dans une poêle. Salez et poivrez, lorsqu''ils ont rendu leur eau, égouttez-les. Faites fondre le beurre à feu doux.
Mélangez la farine avec une grosse pincée de sel, et la levure. Creusez un puits et cassez les œufs.
Amalgamez peu à peu la farine, les œufs à la spatule. Incorporez le beurre fondu puis la crème liquide. Ajoutez les champignons, le jambon, les fromages, versez dans le moule.
Enfournez pendant 40 min.
Attendez 10 min après la sortie du four pour démouler le cake. Laissez-le refroidir sur une grille.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cannelés au chorizo et beaufort',
  'canneles-au-chorizo-et-beaufort',
  'Délicieux apéritif maison.',
  '(Cuisine AZ)
50 g de beurre
100 g de farine
150 g de beaufort en morceaux
chorizo très fin en chiffonnade
2 œufs
1/2 litre de lait écrémé
sel, poivre
Moule à cannelés',
  'Dans un saladier, mélangez avec un fouet la farine avec un œuf entier et le jaune du deuxième œuf, pour obtenir une pâte bien homogène.
Versez le lait/beurre dans votre mélange progressivement et incorporez-les complètement jusqu''à l''obtention d''une pâte bien lisse. Laissez tiédir la pâte en la mettant au frais une petite heure.
Préchauffez votre four à 210°.
Coupez en petites lamelles votre chorizo, et rajoutez-les avec les morceaux de beaufort dans votre pâte. Salez et poivrez.
Remplissez vos moules aux deux tiers avec votre pâte et enfournez vos cannelés pendant 45 minutes. (Dans les commentaires, moules trop remplis…)
Laissez-les tiédir sur une grille une fois démoulés, puis servez.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cookies au parmesan et tomates confites',
  'cookies-au-parmesan-et-tomates-confites',
  'Délicieux apéritif maison.',
  '(Beau est bon)
http://beauestbon.fr/cookies-au-parmesan-et-tomates-confitesexclu-m6/
50 g de parmesan
50 g de farine
30 g de beurre
1 cuillère à café de levure chimique
1 cuillère à soupe d’amande en poudre
1 œuf
50 g de tomates séchées',
  'Taillez les tomates confites en dés.
Préparez la pâte. Réunir les poudres (parmesan, farine, levure et amande en poudre) avec le beurre en morceaux et effectuer un sablage du bout des doigts. Incorporez l’œuf entier et mélangez afin d’obtenir une pâte homogène. Ajoutez les tomates confites et pétrissez de nouveau.
Préchauffez le four à 200°.
Façonnez des boules de tailles égales et disposez –les sur une plaque avec un papier cuisson.
A l’aide d’une petite cuillère, aplatissez légèrement les boules et enfournez les cookies pour 10 min.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cookies aux tomates séchées et olives',
  'cookies-aux-tomates-sechees-et-olives',
  'Délicieux apéritif maison.',
  'http://lagrandepages.over-blog.com/article-cookies-aux-tomates-sechees-et-olives-pour-un-tour-en-cuisine-n-43-95843179.html
85g de farine
30g de parmesan
1 œuf
20g de beurre
50g de tomates séchées
2cs d''huile contenue dans le bocal de tomates séchées
1 pincée de sel
1cc de levure chimique
30g d''olives vertes dénoyautées
basilic',
  'Coupez les olives et les tomates séchées en petits morceaux plus ou moins gros selon vos envies.
Dans un récipient, mélangez la farine, la levure et le parmesan avec une pincée de sel.
Ajoutez ensuite le beurre mou, l''huile, le basilic et l''œuf. Mélangez à nouveau.
Disposez des petits tas de pate sur votre plaque de cuisson ou votre tapis de cuisson.
Faites cuire 10 minutes à 200° dans un four préchauffé.
100 g tomates semi-séchées
40 g Parmigiano Reggiano à râper
10 olives vertes dénoyautées
100 g farine de blé
Feuilles de basilic frais
15 g beurre doux
1 œuf',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Courgettes à l''aigre doux',
  'courgettes-a-l-aigre-doux',
  'Délicieux apéritif maison.',
  'Courgettes à l’aigre-doux
(Régie Vaillant)
1,5 kg de courgettes
3 oignons coupés en morceaux
1 poignée de gros sel
40 cl de vinaigre de cidre
40 cl d’eau
250 g de sucre
6 cuillères à café de curry
1 cuillère à soupe de poivre en grain',
  '– 1er jour : Coupez les courgettes en morceaux sans les éplucher. Mélangez courgettes, oignons, sel et tenir au frais.
– 2ème jour : Rincez les courgettes et laissez égoutter (je vérifie que le sel est parti en gouttant les courgettes).
Dans une poêle, ajoutez le vinaigre de cidre, l’eau, le sucre, le curry et le poivre. Faîtes bouillir. Ensuite versez sur les courgettes avec les oignons. Laissez reposer une nuit.
– 3ème jour : faîtes bouillir le tout 5 minutes. Versez chaud dans les bocaux et fermez.
– Servir en apéritif
Bon appétit.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Croquants tomate séchée, pignon et tapenade (livre de Pasca)',
  'croquants-tomate-sechee-pignon-et-tapenade-livre-de-pasca',
  'Délicieux apéritif maison.',
  'Croquants tomate séchée, pignon et tapenade
(livre Pasca)
Pour 13 croquants :
180g de farine blanche
70g de beurre mou
2 pincées de sel
30g de parmesan
1,5 càs de tapenade
1 œuf
4 pétales de tomates séchées
2 càs de pignons de pin',
  'Dans un saladier, mélangez du bout des doigts la farine, le beurre et le sel. Ajoutez
Ensuite le parmesan, la tapenade et l’œuf, puis mélangez vivement. Découpez en dés les pétales de tomate séchée et concassez les pignons. Ajoutez les pétales de tomate et les pignons puis malaxez énergiquement avec les mains.
Sur du film alimentaire, disposez la pâte et formez un boudin. Emballez-le bien et placez-le au frais 1 à 2h.
Préchauffez le four à 180°C (th 6). Sortez le boudin du frigo et découpez-le en palets. Disposez-les sur une plaque à pâtisserie et enfournez pendant 20 à 25 minutes.
Laissez refroidir avant de consommer.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crèmes brûlées au foie gras',
  'cremes-brulees-au-foie-gras',
  'Délicieux apéritif maison.',
  '(Quand Nad cuisine)
Pour 2 personnes :
60 g de foie gras mi-cuit
1 jaune d''œuf
50 g de crème liquide
50 g de lait
sel, poivre 5 baies
2 cc bombées de cassonade',
  'Préchauffer le four à 100°.

Mixer le foie gras en morceaux avec le jaune d''œuf, la crème et le lait. Assaisonner.

Verser dans deux petits ramequins (assez plats) et enfourner. Laisser cuire 1h (cela peut paraître beaucoup mais le four n''est pas très chaud).

A la sortie du four, laisser refroidir et placer quelques heures au réfrigérateur.

Au moment de servir, saupoudrer de cassonade et caraméliser à l''aide d''un chalumeau (ou sous le gril bien chaud du four).',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Cœurs de palmier façon makis (Françoise)',
  'curs-de-palmier-facon-makis-francoise',
  'Délicieux apéritif maison.',
  'Cœurs de palmier façon makis',
  'Facile
Pour 4 personnes :
10 à12 coeurs de palmier (au naturel)
1/2 bouquet de
ciboulette
120 g de saint Morêt
Sel, poivre du moulin
1 échalote
1 pincée de piment de Cayenne
Baies roses
Huile d''olive
Cuisson : 0 mn
Repos : 0 mn
Pour finir... C''est une délicieuse façon de profiter des atouts nutritionnels du cœur de palmier !',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Escargots briochés aux lardons et au fromage',
  'escargots-brioches-aux-lardons-et-au-fromage',
  'Délicieux apéritif maison.',
  '(Les délices d’Hélène)
http://delicesdhelene.over-blog.com/article-22009339.html
Pour une vingtaine de petits escargots
1/2 sachet de levure francine spécial pain (ou 1/2 cube de levure fraîche)
15cl de lait
250g de farine
20g de sucre en poudre
5g de sel fin
40g de beurre à température ambiante
Pour la garniture :
200g de Kiri (une boîte de 8 carrés)
10cl de crème fraîche liquide
200g de lardons
gruyère râpé',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Feuille d''endive, confit d''oignon et emmental pimenté',
  'feuille-d-endive-confit-d-oignon-et-emmental-pimente',
  'Délicieux apéritif maison.',
  'Feuille d’endive, confit d’oignon et emmental pimenté
1 belle endive
1 pot de confit d''oignons
1 tranche de jambon cru
100 g d’Emmental
piment d''Espelette en poudre
poivre du moulin',
  'Lavez l’endive.
Essuyez-la bien et effeuillez-la.
Coupez le bout : environ 3 cm.
Coupez le jambon cru et l’Emmental en lanières d’environ 1 à 2 cm de large.
Garnissez chaque feuille avec 1 c. à café de confit d’oignon, une lanière de jambon cru et une lamelle d’Emmental. Saupoudrez de piment d’Espelette et ajoutez un tour de moulin à poivre.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Gaspacho de courgettes',
  'gaspacho-de-courgettes',
  'Délicieux apéritif maison.',
  '(Piratage culinaire)
https://www.piratageculinaire.com/2017/06/gaspacho-aux-courgettes-et-la-menthe.html
1 oignon
menthe fraîche
sel, poivre',
  'Faire cuire les courgettes coupées en morceaux avec l’oignon, sel, poivre, sans mettre trop d’eau.
Ajouter la menthe et mixer. Laisser refroidir puis répartir dans des verrines. Mettre au frais pensant 2 heures au moins. Décorer de menthe fraîche avant de servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Gougères',
  'gougeres',
  'Délicieux apéritif maison.',
  'Pour 30 gougères moyennes environ :
150g de farine
80g de beurre
1/4l d’eau
4 œufs
1 cuiller à café de sel
1 poignée d’emmental râpé
Mettre le beurre et le sel dans l’eau. Porter à ébullition.
Hors du feu, ajouter les œufs un à un et mélanger bien. Ajouter enfin une poignée d’emmental.
Faire cuire dans le four, thermostat 200° environ 20 minutes.',
  'Ajouter la farine hors du feu, puis faire cuire un peu la pâte sur le feu (environ 4-5 minutes) pour la faire dessécher.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Gressins au thym',
  'gressins-au-thym',
  'Délicieux apéritif maison.',
  '(Livre Josette)
Pour 20 gressins :
le zeste d’un citron
220 g de farine
80 g de beurre
90 g de fromage râpé
1 cc et demi de sel
2 cc de thym séché',
  'Mélangez du bout des doigts la farine, le beurre, le fromage râpé et le sel jusqu’à l’obtention d’une consistance sableuse.
Incorporez le thym en pétrissant rapidement. Ajoutez de l’eau si la consistance est trop sèche. Sur un plan de travail fariné, étalez la pâte sur une épaisseur de 6 mm.
Préchauffez le four à 180°C (th 6). Découpez des lanières de 1 cm de large. Vrillez-les sur elles-mêmes puis disposez-les sur une plaque pour le four recouverte de papier sulfurisé.
Enfournez 15 minutes jusqu’à ce que les gressins soient légèrement dorés. Sortez du four et laissez refroidir sur une grille.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Madeleines aux lardons',
  'madeleines-aux-lardons',
  'Délicieux apéritif maison.',
  '(Ôdélices)
3 œufs
150 g de farine
1/2 sachet de levure chimique
100 g de beurre
80 g de lardons
1 cuillère à soupe (à table) de thym
3 cuillères à soupe (à table) de lait
sel, poivre',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Madeleines tomates séchées basilic',
  'madeleines-tomates-sechees-basilic',
  'Délicieux apéritif maison.',
  'Madeleines tomates séchées/basilic
(Adèle Pomme)
3 œufs
4,5 càs huile d’olive
120g de farine
½ sachet de levure
6 tomates séchées
Basilic, piment d’espelette',
  'Mélanger les œufs et l’huile d’olive. Ajouter petit à petit la farine avec la levure et le sel.
Couper les tomates séchées en petits morceaux et les ajouter au mélange ainsi que le piment d’espelette et le basilic.
Faire cuire les mini-madeleines 5 min à 200° puis 5 min à 180°.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Mini pizzas triangles (Pasca)',
  'mini-pizzas-triangles-pasca',
  'Délicieux apéritif maison.',
  'Mini pizzas triangles
(livre Pasca)
Pour 16 pizzas :
1 pâte à pizza
Fromage type St Moret
Saumon fumé
Aneth',
  'Etaler un peu la pâte à pizza. Découper en 16 parties.
Tartiner de St Moret, puis disposer dessus des lanières de saumon fumé. Parsemer d’aneth finement ciselée.
Faire cuire th 180°C.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Mousse de thon',
  'mousse-de-thon',
  'Délicieux apéritif maison.',
  '(750g)
http://www.750g.com/verrines-ou-petites-coupelles-mousse-de-thon-et-tartare-de-betteraves-a-la-coriandre-r25416.htm
1 boîte de fromage frais type ST MORET
1 grosse boîte de thon au naturel
1/2 bouquet de coriandre
1petite échalote
poivre moulu
1 betterave
QS: vinaigre balsamique, huile d''olive, coriandre en poudre et fraîche',
  'Mixer le fromage, le thon, la 1/2 botte de coriandre, l''échalote coupée en morceaux : il faut mixer en plusieurs fois mais brièvement, car il faut laisser une consistance épaisse à la mousse). Réserver.
Détailler la betterave en cube, saler, poivrer, ajouter la coriandre en poudre, le vinaigre balsamique et l''huile.
Dans des petites coupelles (5cmx5 env.) déposer une c à s de mousse de thon et disposer dessus le tartare de betterave.
Décorer avec des feuilles de coriandre fraiches.
Réserver 1 h au frais avant de servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Muffins au Roquefort (livre de Pasca)',
  'muffins-au-roquefort-livre-de-pasca',
  'Délicieux apéritif maison.',
  'Muffins au roquefort
(livre Pasca)
Pour 4 personnes :
125g de farine
½ sachet de levure chimique
4 œufs
20cl de lait
15cl d’huile d’olive
120g de roquefort
50g de noix',
  'Préchauffez le four à 180°C (th 6).
Versez la pâte dans les moules. Enfournez pour 20 à 25 minutes de cuisson. Les muffins doivent être bien gonflés et dorés.
Servez-les tièdes ou froids.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Muffins aux carottes et au chèvre',
  'muffins-aux-carottes-et-au-chevre',
  'Délicieux apéritif maison.',
  '150 g de farine
1 sachet de levure
1 bonne pincée de cumin
3 œufs
250 g de fromage blanc de chèvre en faisselle
4 c.à soupe d''huile d''olive
2 carottes râpées
70 g de gruyère râpé
sel et poivre',
  'Préchauffez le four Th.6 (180°C).
Dans un saladier, mélangez la farine, la levure et le cumin.
Dans un autre saladier, battez les œufs avec la faisselle de chèvre et l''huile.
Enfournez environ 15 minutes. (parfois plus dans les commentaires)',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Muffins de pommes de terre',
  'muffins-de-pommes-de-terre',
  'Délicieux apéritif maison.',
  '250 g pommes de terre à purée
2 petits oignons rouges émincés
2 œufs
100 g farine
25 g beurre
2 c. à soupe olives noires hachées
30 g feta
Poivre du moulin, sel',
  'Préchauffez le four Th6 (175 °C).
Epluchez les pommes de terre et coupez-les en 4. Faites-les cuire dans l’eau salée durant 15 min.
Vérifiez la cuisson avec la pointe d’un couteau et réduisez-les en purée.
Ajoutez les jaunes d''œuf, l''oignon, la feta, les olives et la farine.
Assaisonnez avec le sel et le poivre.
Battez les blancs d''œuf en neige et incorporez-les à l''appareil.
Beurrez un moule à muffins. Remplissez-les au tiers.
Faites cuire les muffins pendant 25 min.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Pannacotta jambon cancoillotte (verrine)',
  'pannacotta-jambon-cancoillotte-verrine',
  'Délicieux apéritif maison.',
  'Pannacotta jambon cancoillotte
(Les délices d’Hélène)
http://delicesdhelene.over-blog.com/article-pannacotta-jambon-cancoillote-59485079.html
Pour une vingtaine de mini-verrines
20cl de crème liquide
250g de cancoillotte
2 feuilles de gélatine
4 tranches de jambon fumé
sel et poivre
quelques noisettes pour la décoration (facultatif)',
  'Mixer le jambon fumé à l''aide d''un robot. Le tasser avec les doigts au fond de petites verrines. Réserver.
Tremper la gélatine dans de l''eau froide pour la ramollir. Dans une casserole, faire chauffer la crème avec la cancoillotte. Hors du feu, aouter la gélatine et fouetter pour la dissoudre. Laisser tiédir. Remplir les verrines du mélange crème-cancoillotte et placer au frais toute une nuit. Le lendemain, décorer d''une demi noisette avant de déguster.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Petits choux farcis à la crème de saumon fumé et aneth (Pasca)',
  'petits-choux-farcis-a-la-creme-de-saumon-fume-et-aneth-pasca',
  'Délicieux apéritif maison.',
  'Petits choux farcis à la crème de saumon fumé et aneth
Pour garnir 24 petites gougères :
60g de crème fraîche
150g de fromage frais
150g de saumon fumé
Aneth, ciboulette
Sel et poivre',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rafraîchissant de radis',
  'rafraichissant-de-radis',
  'Délicieux apéritif maison.',
  '(Jardin bio Vaillant)
1 tomate
3 cuillers à soupe de crème fraîche
100g de lardons allumettes
Sel, poivre
1 cuiller à café de vinaigre balsamique
1 cuiller à café d’huile d’olive',
  'Commencez par laver et couper en morceaux les radis. Mixez-les à l’aide d’un blender. Ajoutez aux radis mixés une tomate pelée, la crème fraîche, l’huile d’olive, le vinaigre et assaisonnez selon votre goût.
Faites griller les lardons.
Mettez au frigo et dégustez bien frais.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Roulades de saumon fumé à la mousse d''avocat',
  'roulades-de-saumon-fume-a-la-mousse-d-avocat',
  'Délicieux apéritif maison.',
  'Roulades de saumon fumé à la mousse d’avocat
(Cuisine AZ)
3 avocats bien murs
8 tranches de saumon fumé
1 citron
10 cl de crème fraîche
2 c. à soupe d''herbes vertes hachées au choix
quelques tomates cerise pour la décoration
sel, poivre de Cayenne',
  'Pelez les avocats et coupez-les en lanières, écrasez à la fourchette puis arrosez aussitôt avec le jus de citron.
Mélangez la chair d''avocat avec la crème et les herbes hachées. Assaisonnez généreusement de sel et de cayenne.
Etalez les tranches de saumon et déposez un peu de mousse sur chacune d''elles.
Roulez les tranches et conservez-les au frais sous un film plastique.
Hachez finement l''oignon. Disposez 2 roulades sur chaque assiette.
Décorez de tomates cerise coupées en deux et d''1 c. à soupe d''oignon.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Roulés feuilletés chèvre miel',
  'roules-feuilletes-chevre-miel',
  'Délicieux apéritif maison.',
  'Roulés feuilletés chèvre-miel
(Cahier de gourmandises)
http://cahierdegourmandises.fr/2013/04/22/roules-miel-chevre/
1 rouleau de pâte feuilletée
50gr de chèvre frais
1 crottin de Chavignol
Miel liquide
Poivre',
  'Cuisson : 15 min
Étaler la pâte. Tartiner de chèvre sur toute la surface de la pâte. Ajouter une fine couche de miel. Poivrer. Découper de fins morceaux de crottin et les répartir sur la pâte. Rouler la pâte en serrant bien dans le sens de la longueur.
Filmer le rouleau obtenu. L''entreposer pour plusieurs heures au réfrigérateur.
Sortir les rouleaux et ôter le film. Couper des tronçons d’1 à 1,5 cm dans le rouleau puis les disposer sur une plaque allant au four, recouverte de papier sulfurisé.
Cuire à four chaud à 200° pour 15 minutes. Sortir les spirales lorsqu’elles sont justes dorées.
Notes',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sablés au fromage de chèvre',
  'sables-au-fromage-de-chevre',
  'Délicieux apéritif maison.',
  '(Cuisine et dépendances)
http://gainthekitchen.canalblog.com/archives/2010/11/20/19578366.html
100g de farine à pain (avec levure incorporée)
100 g de chèvre frais (Petit Billy) 
1 jaune d''œuf 
3 cuil à soupe d''huile d''olive
 facultatif : 1 cuil à soupe de miel
1 cuil à café d''origan
 fleur de sel',
  'Battre le chèvre frais pour en faire une crème, ajouter l''huile et le miel. Ajouter les œufs, puis  la farine et mélanger. Ajouter l''origan et la fleur de sel. Rassembler la pâte en boule.
Laisser reposer au moins une heure au frais pour que la pâte se raffermisse.
Préchauffer le four à 180°C (th.6).
Rouler la pâte en deux boudins de 5 cm de diamètre. Trancher en biscuits de 1 cm d''épaisseur et disposer les cookies sur une tôle à pâtisserie chemisée de papier sulfurisé.
Enfourner et laisser cuire 12 à 15 min, jusqu''à ce que  les biscuits soient légèrement dorés.
Laisser refroidir sur une grille, ils durciront en séchant.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sablés au roquefort et au romarin',
  'sables-au-roquefort-et-au-romarin',
  'Délicieux apéritif maison.',
  '(Livre Josette)
Pour 20 sablés :
110 g de beurre mou
100 g de roquefort
1 branche de romarin
150 g de farine
1 jaune d’œuf
2 cs d’huile d’olive
1 pincée de poivre
variante : on peut remplacer le romarin par du thym',
  'Fouettez le beurre et émiettez le roquefort. Lavez et épongez le romarin, puis ciselez-le finement. Dans un saladier, travaillez le beurre ave le roquefort. Ajoutez la farine tamisée, le romarin, le jaune d’œuf et l’huile d’olive. Poivrez et travaillez l’ensemble pour obtenir une pâte sableuse.
Formez un rouleau de 3 à 4 cm de diamètre avec la pâte, enveloppez-la dans du film alimentaire puis laissez-la reposer 2 heures au réfrigérateur. Préchauffez le four à 200°C (th 6-7).
Retirez le film et découpez des rondelles de 5 mm d’épaisseur. Posez les rondelles sur une plaque de four recouverte de papier sulfurisé.
Faites cuire 10 minutes. Sortez la plaque du four et laissez refroidir un peu avant de déposer les biscuits sur une grille.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sablés comté pavot',
  'sables-comte-pavot',
  'Délicieux apéritif maison.',
  'Sablés comté-pavot
Pour 30 à 40 biscuits :
100g de beurre 1/2 sel (à température ambiante)
140g de comté râpé
120g de farine
2 cuil. à soupe de graines de pavot
un peu de poivre noir (facultatif)',
  'Versez la farine dans un saladier. Ajoutez le beurre coupé en dés, le comté, le poivre et les graines de pavot. Malaxez avec le pétrin vitesse 1 puis augmentez à 3 et pétrissez la pâte jusqu''à l''obtention d''une boule. Couvrez et laissez reposer 30 minutes au frais.
Préchauffez au four th.180°C (170°). Etalez la pâte au rouleau sur une épaisseur de 3mm. Découpez des formes avec un emporte-pièce. Disposez-les sur une plaque recouverte de papier sulfurisé et enfournez pour 15 (13) minutes. Laissez refroidir sur une grille avant de les entreposer dans une boîte hermétique.
Vous pouvez également rouler la pâte en 2 boudins puis placer au frais 30 minutes. Avant de passer au four, il suffit de couper des tranches d''environ 0,5cm.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Soupe glacée au saumon fumé (Maxi Cuisine)',
  'soupe-glacee-au-saumon-fume-maxi-cuisine',
  'Délicieux apéritif maison.',
  'Soupe glacée au saumon fumé
(Maxi Cuisine)
Pour 6personnes :
450g de saumon fumé
1,5 botte de radis
15 cl de crème liquide
8 cerneaux de noix mondés
½ bouquet de ciboulette
3 càs de fond de veau en poudre
tabasco
Sel, poivre',
  'Faire bouillir 1,2 litre d’eau avec le fond de veau. Laisser frémir 5 minutes en remuant et laisser refroidir.
Nettoyer les radis, puis les couper en morceaux. Réunir le saumon coupé en lanières, les cerneaux de noix, les radis, le consommé de veau, un peu de tabasco et la crème dans un mixeur. Saler légèrement, poivrer.
Mixer jusqu’à obtenir une crème lisse et homogène. Réserver au réfrigérateur au moins 2 heures.
Servir dans des verrines, décoré avec de la ciboulette ciselée.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sucettes de concombre',
  'sucettes-de-concombre',
  'Délicieux apéritif maison.',
  '(Cuisine actuelle)
1 concombre
Boursin échalotes ciboulette',
  'Lavez le concombre. Coupez-le en tronçons de 10 cm environ. Évidez le cœur du concombre à l’aide d’un évideur à pommes.
Remplissez les tronçons de concombre de boursin.
Coupez les tronçons de concombre en tranches d’environ 8 millimètres.
Piquez chaque tranche sur un pique et réservez au frais jusqu’au moment de servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartelettes pomme magret canard (Françoise)',
  'tartelettes-pomme-magret-canard-francoise',
  'Délicieux apéritif maison.',
  'Tartelettes pommes/magret (Françoise)
Pour 54 petites tartelettes :
- 2 rouleaux de pâte
- 3 pommes
- 200 g de magret environ (ok avec 180 g)
- 25 g de beurre
- 2 échalotes
- 2 cuillère à soupe de miel
- 4 cuillère à soupe de vinaigre balsamique
- sel, poivre',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine de betteraves aux noix',
  'verrine-de-betteraves-aux-noix',
  'Délicieux apéritif maison.',
  'Verrine betteraves aux noix
300g de betteraves cuites
100g de fromage blanc
crème fraîche
60g de noix + demi-cerneaux pour la déco
2 cas d’huile de noix
sel, poivre',
  'Mettre les betteraves, le fromage blanc, l’huile, le sel et le poivre dans le mixeur. Mixez. Ajoutez la crème fraîche pour obtenir la consistance souhaitée.
Ajoutez enfin les noix et mixez quelques instants de manière à ne pas complètement écraser les noix.
Disposez dans des verrines et ajoutez le demi-cerneau de noix pour décorer. Mettre au frais quelques heures avant de servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine de crème de carottes à l''orange',
  'verrine-de-creme-de-carottes-a-l-orange',
  'Délicieux apéritif maison.',
  'Crème de carottes à l’orange
(Françoise)
Pour 10 verrines :
500g de carottes cuites
2 petits oignons
1 bouquet de coriandre
2 oranges
25cl de bouillon de volaille froid
12cl de crème liquide
Sel, poivre
Réservez au froid jusqu’au moment de servir.',
  'Pressez les oranges. Epluchez les oignons et émincez-les. Effeuillez la coriandre en gardant quelques feuilles pour le décor. Mixez les carottes avec le jus d’orange, le bouillon de volaille (j’ai fait cuire les carottes dedans et j’en ai mis un peu, sinon ça devenait une soupe !), les oignons et la coriandre. Salez, poivrez et ajoutez la crème. Décorez d’une petite feuille de coriandre.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine de mousse chèvre noix',
  'verrine-de-mousse-chevre-noix',
  'Délicieux apéritif maison.',
  'Mousse chèvre-noix
(Croquant fondant gourmand)
Pour 15 verrines :
140g de fromage de chèvre frais (type Chavroux)
130g de crème liquide
20g de cerneaux de noix + déco
sel, poivre, piment d’Espelette',
  'Hachez les noix assez finement au couteau (ou au mixeur mais ne pas réduire en poudre). Ecrasez le fromage de chèvre jusqu’à ce qu’il devienne une crème lisse puis ajoutez les noix hachées.
Montez la crème en chantilly et ajoutez-la délicatement au mélange chèvre-noix.
Goûtez pour rectifier l’assaisonnement. Ajoutez un peu de piment d’Espelette.
Garnissez les verrines et réservez au frais.
Avant de servir, déposez un demi-cerneau de noix dans chaque verrine.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine de mousse d''asperges',
  'verrine-de-mousse-d-asperges',
  'Délicieux apéritif maison.',
  'Mousse d’asperges
(Atelier des chefs)',
  'Pour 6 personnes : 
250g d’asperges
25 cl de crème liquide entière
1 feuille de gélatine (2g)
sel, poivre
Dans un grand volume d’eau bouillante salée, cuire les asperges pendant 20 minutes.
Égoutter les asperges, couper les pointes et mixer les queues. Mettre la feuille de gélatine à tremper dans un bol d’eau froide.
Battre la crème en chantilly.
Faire chauffer 1/3 des asperges mixées et dissoudre la gélatine dedans. Ajouter le reste de purée, assaisonner de sel et de poivre (la purée doit être à température). Ajouter ensuite délicatement la crème fouettée et réservée au frais pendant au moins 30 min.
Ajouter quelques lanières de saumon fumé.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine de mousse de Langres',
  'verrine-de-mousse-de-langres',
  'Délicieux apéritif maison.',
  'Mousse de Langres
Pour 20 verrines (petits verres en verre) :
300 g de Langres
200g de crème liquide 30%
200g de crème liquide 30% (pour chantilly)
Dans une casserole, versez la crème (200g). Ajoutez le Langres et faites fondre le mélange à feu doux en remuant sans cesse.',
  'Montez la crème en chantilly et incorporez délicatement à la mousse fouettée. Versez dans des verrines et ajoutez des lanières de jambon sec. Réservez au frais.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine de velouté de courgettes (livre de Pasca)',
  'verrine-de-veloute-de-courgettes-livre-de-pasca',
  'Délicieux apéritif maison.',
  'Verrine de velouté de courgettes
(livre Pasca)
Pour 8 personnes :
1kg de courgettes émincées
100g de fromage de chèvre sec coupé en petits morceaux
2 oignons blancs hachés
2 gousses d’ail hachées
100g d’olives noires dénoyautées et hachées
10cl de crème fraîche
2 tablettes de bouillon de volaille
Sel, poivre',
  'Dans une grande casserole, mettez 50cl d’eau, les courgettes, les oignons, l’ail, du sel, du poivre et le bouillon. Portez à ébullition et laissez cuire 15 minutes.
Egouttez les légumes, et réservez le bouillon. Passez les courgettes au moulin à légumes, ajoutez la crème fraîche, puis versez petit à petit le bouillon pour obtenir la texture que vous souhaitez. Laissez refroidir et saupoudrez de miettes d’olives et de fromage de chèvre.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine jambon cru et duo de mousses',
  'verrine-jambon-cru-et-duo-de-mousses',
  'Délicieux apéritif maison.',
  '(Les délices d’Hélène)
Pour 6 à 8 verrines (en fonction de la taille des verrines)
300g de jambon cru Aoste
1/2 concombre
Pour la mousse au fromage blanc
Pour la mousse de tomate
Au moment de servir, décorer de chips de jambon croustillant.',
  '200g de fromage blanc
2 cuil. à soupe d''huile d''olive
1 cuil. à soupe de jus de citron
1 bouquet de basilic frais
3 feuilles de gélatine
sel, poivre
4 tomates
2 feuilles de gélatine
100g de crème fraîche épaisse
1 cuil. à soupe de vinaigre balsamique
Préparer la mousse de tomates : Émonder les tomates. Les faire bouillir 30 secondes dans de l''eau bouillante, jusqu''à ce que la peau se craquelle. Les plonger dans un bain d''eau glacée pour stopper la cuisson. Retirer la peau des tomates et les épépiner puis les tailler en dés. Tremper les feuilles de gélatine dans de l''eau froide. Dans le bol d''un mixeur, placer les tomates avec la crème fraiche et la gélatine. Saler et poivrer et ajouter le vinaigre. Répartir cette mousse dans des verrines individuelles et placer au frais en attendant (environ 2h).
Couper le jambon en lamelles. En disposer 200g sur la mousse de tomate. Passer le reste au four pendant 10 minutes th.210°C pour obtenir des chips de jambon croustillantes (pour la décoration). Couper le concombre très finement et parsemer sur les verrines.
Préparer la mousse au fromage blanc : faire tremper les feuilles de gélatine. Les dissoudre dans 2 cuil. à soupe d''eau, dans une casserole. Dans un saladier, mélanger le fromage blanc avec la gélatine fondue. Ajouter l''huile d''olive, le jus de citron et le basilic finement haché. Rectifier l''assaisonnement. Mélanger le tout et recouvrir la verrine de ce mélange. Placer au frais 2 h environ.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine poire, Roquefort et jambon cru (livre de Pasca)',
  'verrine-poire-roquefort-et-jambon-cru-livre-de-pasca',
  'Délicieux apéritif maison.',
  'Verrine poire, roquefort et jambon cru
(livre Pasca)
Pour 12 verrines :
3 poires
2 càc de sucre en poudre
½ càs d’huile d’olive
½ roquefort
10 càs de crème liquide entière
6 tranches de jambon cru',
  'Epluchez et épépinez les poires. Faites chauffer l’huile dans une poêle et faites-y compoter les poires avec le sucre pendant 5 minutes. Réservez sur une assiette.
Dans les verrines, disposez les poires, 2 cuillers à café de crème de roquefort et parsemez de jambon cru.
Réservez au frais jusqu’au moment de servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrines bayadères (Maxi Cuisine)',
  'verrines-bayaderes-maxi-cuisine',
  'Délicieux apéritif maison.',
  'Verrines bayadères
(Maxi Cuisine)
Pour 6personnes :
750g d’asperges vertes
300g de fromage frais
15cl de crème allégée
1 bouquet d’herbes (ciboulette, aneth, persil)
400g de truite fumée
Le jus d’1/2 citron
Mélange 5 baies
Sel, poivre',
  'Cuire les asperges à l’eau bouillante salée 7 à 8 minutes. Garder 6 pointes. Mixer le reste en purée. Rectifier l’assaisonnement si nécessaire.
Mélanger le fromage frais et la crème fraîche, saler, poivrer et incorporer les herbes fraîches finement ciselées.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrines d''asperges et truite fumée',
  'verrines-d-asperges-et-truite-fumee',
  'Délicieux apéritif maison.',
  'Verrines d’asperges et truite fumée
()
Pour 18 verrines en verre :
300g d’asperges vertes cuites
2 œufs durs
200g de mascarpone
sel, poivre
piment d’Espelette
Cuire les asperges 20 minutes dans de l’eau bouillante salée.
Verser dans les verrines. Ajouter quelques lanières de truite fumée ou pointes d’asperges.',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrines de saumon fumé à la crème de raifort',
  'verrines-de-saumon-fume-a-la-creme-de-raifort',
  'Délicieux apéritif maison.',
  '(Françoise)
Pour 6 personnes :
12 tomates cerises, coupées en 2
6 tranches de saumon fumé, coupé en lanières
300 g de fromage blanc
1 cuil. à café bien bombée de raifort
½ bouquet d’aneth, haché
Poivre du moulin
Quelques brins d’aneth pour la décoration
Dans un bol, mélanger le fromage blanc, le raifort et l’aneth. Poivrer.
Répartir le mélange au fromage blanc dans 6 verrines.',
  'Recouvrir d’une couche de tomates cerises puis d’une couche de lanières de saumon fumé. Décorer avec les brins d’aneth.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrines mousse de jambon et tomates confites',
  'verrines-mousse-de-jambon-et-tomates-confites',
  'Délicieux apéritif maison.',
  '(Marmiton)',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrines poivron et fromage frais (Françoise)',
  'verrines-poivron-et-fromage-frais-francoise',
  'Délicieux apéritif maison.',
  'Verrines poivron et fromage frais
Entrée - Facile - Bon marché
Toutes les photos +',
  '- 2 poivrons rouges	(3 gros poivrons -- > au moins 20 verrines en verre)
- 150 g de fromage frais à tartiner (type St Môret)		(300g)
- 15 cl de crème fraîche entière liquide	(~200g… à ajuster)
- sel
- poivre 5 baies',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sauce légumes crus',
  'sauce-legumes-crus',
  'Délicieux apéritif maison.',
  'Sauce aux herbes:
Sauce rose:',
  'Sauce fines herbes-moutarde : 
250 g de yaourt maigre 
1 c. à soupe de crème fraîche à 5 % de MG (type Campina) 
4 c. à café de miel 
2 c. à soupe de moutarde douce 
1 c. à soupe de thym 
1 c. à soupe de persil 
2 c. à café de cacahuètes pilées 
sel, poivre 

Sauce ciboulette-citron : 
125 ml de lait écrémé 90 g de crème fraîche à 5 % de MG (type Campina) 
4 c. à café de fécule 
1 bouquet de ciboulette 
le jus d''1 citron 
1 c. à soupe de grains de poivre vert en conserve 
sel, poivre 

Sauce fines herbes-noix : 
200 ml de bouillon de légumes 
4 c. à soupe de crème fleurette 
4 c. à soupe de crème fraîche à 5 % de MG (type Campina) 
1 c. à café de fécule 
1 c. à soupe de basilic haché 
2 c. à café de noix pilées 
sel, poivre 

Sauce fines herbes : 
100 g de tomates sechées, sans huile 
120 g de fromage de chèvre frais 
225 g de fromage blanc allégé 
1 c. à soupe de basilic haché 
1 c. à soupe de marjolaine hachée 
5 c. à café d''amandes pilées 
sel, poivre 

Sauce romarin-échalotes : 
400 g d''échalotes 
1 gousse d''ail epluchée et dégermée 
2 c. à café d''huile végétale 
2 c. à soupe de romarin 
100 ml de vin rouge sec 
200 ml de bouillon de légumes 
75 g de crème fraîche à 5 % de MG (type Campina)
- 4 càc fromage blanc
- 2 càc jus de citron
- 1/2 càc moutarde
- 2 càc ciboulette finement ciselée
- 1 càc persil finement haché
- sel, poivre
2. Goûter et rectifier l''assaisonnement si nécessaire en ajoutant du sel ou du poivre.
- 4 càc fromage blanc
- 1/2 càc jus de citron
- 1 pointe de couteau de piment d''Espelette
- 1 càc ketchup
- paprika
- sel, poivre
2. Goûter et rectifier l''assaisonnement si nécessaire en ajoutant du sel ou du poivre.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Verrine duo de chou-fleur et betterave (livre de Pasca)',
  'verrine-duo-de-chou-fleur-et-betterave-livre-de-pasca',
  'Délicieux apéritif maison.',
  'Verrine duo de chou-fleur et betterave
(livre Pasca)
Pour 10 verrines :
250g de chou-fleur
250g de betterave cuite
1 petit suisse
1 càs de persil
1 pincée de cumin en poudre
1 càs de ricotta
2 càs de crème liquide
1 càc de jus de citron
4 pincées de curry en poudre
1 càs de ciboulette hachée
Sel',
  'Faites bouillir une casserole d’eau et faites cuire le chou-fleur 10 minutes. Egouttez-le et laissez-le refroidir.
Dans des verrines, disposez une couche de crème à la betterave puis la crème au chou-fleur. Pour la décoration, parsemez de graines de sésame noir et de ciboulette ciselée.
Conservez au frais jusqu’au moment se servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Caviar d''asperges au citron (un déjeuner de soleil)',
  'caviar-d-asperges-au-citron-un-dejeuner-de-soleil',
  'Délicieux apéritif maison.',
  'Caviar d’asperges au citron
(un déjeuner de soleil)
https://www.undejeunerdesoleil.com/2010/05/caviar-dasperges-au-citron.html',
  'Couper les tiges d’asperges en petits cylindres. Les verser dans une casserole et recouvrir d’eau. Laisser mijoter à feu moyen pendant 20-25 minutes afin que les asperges s’attendrissent. Retirer du feu et égoutter. Passer au mixeur avec l’huile d’olive et le jus de citron pour obtenir une crème fine. Ajouter le zeste de citron, saler, poivrer et mélanger. Elle se garde un jour au frigo recouverte d’un peu d’huile d’olive.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Caviar d''aubergine (Cookomix)',
  'caviar-d-aubergine-cookomix',
  'Délicieux apéritif maison.',
  'Caviar d’aubergine
(Cookomix)
700g d’aubergines
2 gousses d’ail
20g d’huile d’olive
1 càc de sel aux herbes
3 càs de jus de citron
1 càs de paprika (facultatif)
poivre',
  'Mettre les gousses d’ail dans le thermomix et mélanger 5 s, vitesse 8. Racler les bords avec la spatule.
Ajouter les aubergines épluchées et coupées en morceaux et mélanger 5 s, vitesse 5.
Ajouter le sel, l’huile d’olive et le poivre. Cuire 16 min/varoma/vitesse 1.
Ajouter le paprika et le jus de citron puis mélanger 5 s, vitesse 5.
Mettre au frais au moins 30 minutes.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Caviar de tomate et jambon cru',
  'caviar-de-tomate-et-jambon-cru',
  'Délicieux apéritif maison.',
  '(Espace thermomix)
Caviar
150 g tomates séchées
75 g jambon cru, découpé en morceau
2 gousses d''ail
5 feuilles basilic
1/2 c. à café rase Piment doux
à discrétion Sel et poivre
75 g d''huile d''olive
Croûtons
1 baguette de pain, coupée en tranches',
  'Allumer le four à 200°. Couper des tranches de pain ni trop fines, ni trop épaisses. Déposer sur une plaque et enfourner 10min.
Mettre dans  les tomates séchées, le jambon cru, l''ail et le basilic. Thermomixer 30sec vitesse 5.
Remixer plus ou moins jusqu''à l''obtention d''une sorte de pâte.
Ajouter le piment, le sel et poivre et l''huile d''olive. Mixer 10sec vitesse 3.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Caviar de tomates séchées (La p''tite cuisine de Pauline)',
  'caviar-de-tomates-sechees-la-p-tite-cuisine-de-pauline',
  'Délicieux apéritif maison.',
  'Caviar de tomates séchées
(La p’tite cuisine de Pauline)
http://www.ptitecuisinedepauline.com/article-caviar-de-tomates-sechees-117769469.html
75g de coulis de tomates
200g de tomates séchées à l''huile
1 gousse d''ail
4 càs d''huile d''olive
quelques feuilles de basilic
sel, poivre',
  'Rq : je n’ajoute pas les 4 càs d’huile d’olive car les tomates séchées sont déjà marinées dans l’huile…',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Crème de poivrons et ricotta (un déjeuner de soleil)',
  'creme-de-poivrons-et-ricotta-un-dejeuner-de-soleil',
  'Délicieux apéritif maison.',
  'Crème de poivrons et ricotta
(Un déjeuner de soleil)
https://www.undejeunerdesoleil.com/2009/07/creme-de-poivrons-et-ricotta.html
110 g poivrons rouges déjà grillés (ou 200-250 g à griller)
110 g ricotta
20 feuilles de basilic (ou romarin, origan…)
sel et poivre
1 tranche de mie de pain',
  '1. Griller les poivrons : préchauffer le four à 200°C, poser les poivrons sur une plaque recouverte de papier cuisson et les faire cuire pendant 30-40 minutes environ, en les retournant à moitié cuisson, afin qu’ils deviennent grillés et ‘mous’. Les faire refroidir puis les peler.
2. Passer au mixeur les poivrons, la ricotta, le pain et le basilic. Saler et poivrer. Servir avec de la focaccia, des sablés, sur des tartines ou même avec des pâtes.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rillettes aux champignons',
  'rillettes-aux-champignons',
  'Délicieux apéritif maison.',
  'Rillettes de champignons
(Del’s cooking twist)
https://www.delscookingtwist.com/fr/rillettes-vegetariennes-aux-champignons/
450g de champignons de Paris, lavés, équeutés et coupés en morceaux
3 gousses d’ail, émincées
6 brins de thym
45g de beurre doux
Sel et poivre du moulin
1 cuil. à soupe de vinaigre balsamique
60g de chèvre frais (ou Philadelphia, Saint Moret)',
  'Dans un robot mixeur, réduire en purée les champignons avec l’ail et le thym, en veillant à ce qu’il reste un peu de texture à l’ensemble.
Faire chauffer le beurre dans une poêle puis ajouter la mixture de champignons et cuire pendant environ 3 minutes. Saler, poivrer puis ajouter le vinaigre balsamique et cuire encore une à deux minutes, jusqu’à ce que le liquide soit complètement absorbé.
Transférer dans un saladier. Ajouter le chèvre frais et mélanger immédiatement pour lui permettre de fondre au contact des champignons encore chauds.
Placer au réfrigérateur et laisser refroidir pendant 30 minutes, puis servir avec du pain ou sur des crackers apéritifs.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rillettes aux châtaignes (Marie-Claude)',
  'rillettes-aux-chataignes-marie-claude',
  'Délicieux apéritif maison.',
  'Rillettes aux châtaignes
Aussi, j''ai ajouté des noisettes et des noix dans la terrine pour le p''tit côté croquant, mais vous pouvez ne pas en mettre ou les remplacer par des pistaches, ou n''en mettre qu''une seule sorte.
Pour 4-6 personnes
- 200 g de châtaignes en bocal
- 20 g de cerneaux de noix
- 20 g de noisettes décortiquées
- 1 échalote
- 1 gousse d''ail
- 1 yaourt au soja nature (soit environ 100g)
- 5 cl de crème végétale
- 2 cuillères à soupe de sauce tamari (pas mis )
- 2 cuillères à soupe d''huile d''olive
- quelques branches fraîches de persil ou de ciboulette
- 1 cuillère à café de thé noir fumé (facultatif mais conseillé)( pas mis)
- sel
- poivre
1. Placer la crème végétale dans une petite casserole avec le thé noir fumé et faire chauffer à feu doux. Ôter du feu et laisser infuser 10 minutes. (pas fait)
2. Éplucher et émincer l''échalote.
3. Placer dans un bol et mettre au frais jusqu''au moment de servir avec des toasts ou crackers.',
  'Souvent à base de champignons, j''ai voulu la réaliser cette année avec des châtaignes, afin de rendre la terrine plus festive encore et le résultat est là! De délicieuses rillettes pleines de caractère et légèrement fumées. Facilement tartinable sur des petits toasts, elle séduira à coup sûr!',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'rillettes champignons',
  'rillettes-champignons',
  'Délicieux apéritif maison.',
  'Rillettes de champignons
(Del’s cooking twist)
https://www.delscookingtwist.com/fr/rillettes-vegetariennes-aux-champignons/
450g de champignons de Paris, lavés, équeutés et coupés en morceaux
3 gousses d’ail, émincées
6 brins de thym
45g de beurre doux
Sel et poivre du moulin
1 cuil. à soupe de vinaigre balsamique
60g de chèvre frais (ou Philadelphia, Saint Moret)',
  'Dans un robot mixeur, réduire en purée les champignons avec l’ail et le thym, en veillant à ce qu’il reste un peu de texture à l’ensemble.
Faire chauffer le beurre dans une poêle puis ajouter la mixture de champignons et cuire pendant environ 3 minutes. Saler, poivrer puis ajouter le vinaigre balsamique et cuire encore une à deux minutes, jusqu’à ce que le liquide soit complètement absorbé.
Transférer dans un saladier. Ajouter le chèvre frais et mélanger immédiatement pour lui permettre de fondre au contact des champignons encore chauds.
Placer au réfrigérateur et laisser refroidir pendant 30 minutes, puis servir avec du pain ou sur des crackers apéritifs.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Rillettes de saumon',
  'rillettes-de-saumon',
  'Délicieux apéritif maison.',
  '2 boîtes de rillettes de saumon
1 boîte de Saint Moret
Aneth (selon goût)
1 paquet de saumon fumé cocktail découpé en dés
Mélanger le tout. Mettre au frais.
Servir sur des crakers ou ficelle tranchée.
Remarque : Je prends du saumon fumé ou de la truite fumée en tranches (environ 120g)…',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade bacon (thermomix)',
  'tartinade-bacon-thermomix',
  'Délicieux apéritif maison.',
  'Tartinade bacon, pistaches
(Thermomix)
100g de fromage blanc
150g de fromage frais type St Moret
1 c. à café bombée de moutarde
50 g de bacon
sel, poivre, ail et échalote déshydratés
30g de pistache
Ajouter les pistaches et programmer 20sec / V4.
Servir frais.',
  'Suivre les étapes de la recette.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade carottes et noix de cajou',
  'tartinade-carottes-et-noix-de-cajou',
  'Délicieux apéritif maison.',
  'Tartinade carotte et noix de cajou
(Dans la cuisine de Sophie)
https://danslacuisinedesophie.fr/2021/04/tartinade-carotte-et-cajou.html
4 carottes fanes ou 2 carottes
100 g de noix de cajou
1 gousse d''ail
1 cuillère à café rase de cumin moulu (remplacé par paprika)
1 cuillère à soupe d''huile d''olive
1 cuillère à café d''huile de sésame (remplacé par huile noisette)
2 cuillères à soupe de jus de citron
sel
poivre
quelques feuilles de coriandre (facultatif) (pas mis)',
  'Verser dans une poêle les noix de cajou et les faire dorer à feu moyen en remuant régulièrement. Réserver.
Peler les carottes et les couper en morceaux. Les faire cuire 7 minutes dans une casserole d''eau bouillante salée. Egoutter (tout en gardant de côté un peu d''eau de cuisson), passer sous l''eau froide et égoutter une dernière fois.
Placer les carottes dans le bol d''un blender avec les noix de cajou.
Peler la gousse d''ail, la couper en deux. L''ajouter dans le bol avec les huiles, le cumin, les jus de citron. Saler légèrement et poivrer.
Mixer finement en ajoutant un tout petit d''eau de cuisson au fur et à mesure jusqu''à obtenir une consistance crémeuse.
Placer au frais ou consommer de suite.
Servir avec des crackers, du pain grillé et quelques feuilles de coriandre.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade chèvre chorizo',
  'tartinade-chevre-chorizo',
  'Délicieux apéritif maison.',
  '(Cuisiner tout simplement)
http://cuisinertoutsimplement.com/article-tartinade-chevre-chorizo-120320421.html
200g de fromage de Chèvre (Style Chavroux) 
140g de chorizo doux
1càc de concentré de tomate
1càs de crème fraîche épaisse (ou plus selon l’épaisseur)
du piment d''Espelette
poivre',
  'Peler le chorizo et le couper en petits morceaux.
Mixer le chorizo avec le fromage de chèvre et le concentré de tomate.
Ajouter 2 pincées de piment d''Espelette, un peu de poivre et la crème épaisse.
Mélanger.
Verser la tartinade dans une verrine et servir avec des petites tranches de pain grillées.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade crème de poivron (livre Flo)',
  'tartinade-creme-de-poivron-livre-flo',
  'Délicieux apéritif maison.',
  'Crème de poivron
(Végétarien et gourmand Marmiton, livre Flo)
3 courgettes
3 càs de parmesan râpé
3 càs de crème fraîche
1 càs d’huile d’olive
sel, poivre',
  'Lavez le poivron, coupez-le en deux, ôtez le pédoncule et les graines. Détaillez-le en petites lamelles. Faites revenir le poivron dans une poêle avec l’huile d’olive. Quand il commence à dorer, stoppez la cuisson, versez-le dans un bol et mixez-le.
Versez le poivron mixé dans la poêle sur feu doux, ajoutez la crème fraîche puis le parmesan. Salez et poivrez. Laissez épaissir quelques instants.
Une fois refroidi, mettez cette crème de poivron au frigo.
Conseil : on peut peler le poivron pour que ce soit plus digeste. Si on veut une crème verte, on met un poivron vert.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade de chèvre au miel et romarin (livre Pasca)',
  'tartinade-de-chevre-au-miel-et-romarin-livre-pasca',
  'Délicieux apéritif maison.',
  'Tartinade de chèvre au miel et romarin
(livre Pasca)
Pour 4-6 personnes (250g environ) :
1 bûche de chèvre (200g)
1 càs de miel liquide
1 càs de crème fraîche
1 càs de feuilles de romarin frais
30g de noix décortiquées
Sel, poivre',
  'Coupez la bûche de chèvre en petits morceaux dans le bol du mixeur. Versez le miel liquide et la crème fraîche. Mixez jusqu’à l’obtention d’un mélange homogène.
Ajoutez les feuilles de romarin ciselées et les noix. Les noix doivent être grossièrement hachées. Goûtez et rectifiez l’assaisonnement.
Versez la crème dans un bol et servez-la à température ambiante. La crème de chèvre se conserve pendant 5 jours au frigo. Sortez-la au moins 1 h avant de la servir.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade de courgettes à la menthe (régie rurale)',
  'tartinade-de-courgettes-a-la-menthe-regie-rurale',
  'Délicieux apéritif maison.',
  'Tartinade de courgettes à la menthe
(Régie rurale)',
  'Lavez et épluchez vos courgettes, coupez-les en morceaux et faites les cuire 15 minutes à la vapeur.
Préchauffez le four thermostat 8 (240 degrés). Disposez vos tranches de chorizo sur le lèchefrite, enfournez les à mi-hauteur et laissez les tranches de chorizo griller légèrement (ça va vite, surveillez la cuisson de prêt !
Dans un blender, mixez vos courgettes bien égouttées avec le Philadelphia, la menthe, la poudre d’ail le sel et le poivre. Goûtez et rectifiez l’assaisonnement selon votre goût.
Cet apéritif se marie bien avec une boisson du type : Mojito, Perroquet, Virgin Mojito ou diabolo menthe.
Pour les végétariens, remplacer le chorizo par des petits croutons grillés frottés à l’ail.
Vous pouvez remplacer le philadelphia par du Saint-Morêt, carré Frais, petits suisses…',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade de radis noir (Thermomix)',
  'tartinade-de-radis-noir-thermomix',
  'Délicieux apéritif maison.',
  'Tartinade de radis noir
(Thermomix)
Pour 6 personnes :
200g de radis noir coupé en tronçons
40g d’échalotes coupées en 2
1 càs de ciboulette ciselée
150g de fromage frai type Saint Morêt
Sel, poivre',
  'Mettre le radis noir et les échalotes dans le bol, puis hacher 5 sec/vitesse 5. Racler les parois du bol à l’aide de la spatule.
Ajouter la ciboulette, le fromage frais, le sel et le poivre, puis mélanger 10 sec/sens inverse/vitesse 3. Transvaser dans un récipient et réserver au réfrigérateur. Servir bien frais.
Rq : On peut remplacer le radis noir par du radis bleu, vert ou rose.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Tartinade à l''artichaut et au citron (Cooking Julia)',
  'tartinade-a-l-artichaut-et-au-citron-cooking-julia',
  'Délicieux apéritif maison.',
  'Tartinade à l’artichaut et au citron
(Cooking Julia)
http://cookingjulia.blogspot.com/2018/06/tartinade-lartichaut-et-au-citron.html
200 g de fonds d''artichaut (en bocal)
125 g de ricotta
1 gousse d''ail
1 c. à s. d''huile d''olive
1/2 citron
5 feuilles de basilic
piment d''Espelette
sel, poivre',
  'Égoutter et rincer les fonds d''artichaut. Les mettre dans le bol du Thermomix avec la ricotta, la gousse d''ail pelée et pressée au presse-ail, l''huile d''olive, le jus de citron, les feuilles de basilic lavées et ciselées, du sel et du poivre.
Programmer 10 secondes, vitesse 4. Racler les parois du bol. Recommencer jusqu''à obtenir la consistance désirée. Rectifier l''assaisonnement.
Débarrasser la tartinade dans un ramequin et la saupoudrer de piment d''Espelette. Servir avec du pain frais, baguette ou pain de campagne.',
  20, 15, 6,
  (SELECT id FROM public.categories WHERE slug = 'appetizer')
) ON CONFLICT (slug) DO NOTHING;

-- Entrées (17 recipes)

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Asperges sauce radis fromage blanc',
  'asperges-sauce-radis-fromage-blanc',
  'Délicieuse entrée maison.',
  'Pointes d''asperges vertes et dip de radis
(sauce radis cerfeuil échalote fromage blanc)
12 asperges vertes
Pour la sauce radis :
10 radis (50 g)
1 demi-échalote
5 branches de cerfeuil
100 g de fromage blanc
Sel, poivre du moulin',
  'L''info nutrition de Solveig :
Les asperges arrivent au printemps pour drainer notre organisme grâce à leurs fibres douces. Pour profiter de leur taux exceptionnel de potassium qui leur donne cet effet diurétique, faites-les cuire à la vapeur douce. Pour préserver la légèreté de ce légume (25 kcal/100 g), je préfère lui associer une sauce toute légère avec radis et fromage blanc !',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Croustillant de cabécou au confit d''oignon',
  'croustillant-de-cabecou-au-confit-d-oignon',
  'Délicieuse entrée maison.',
  'Croustillant de cabécou au confit d’oignon
(Cuisine AZ)
1 oignon
100 g de sucre
12 feuilles de filo
Vin rouge
18 petits cabécous (petits fromages de chèvre en palet)
beurre
La veille, préparez la confiture d’oignon :
-- > Coupez l’oignon en lamelles et mettez-les dans une casserole avec le sucre.
-- > Couvrez de vin rouge à hauteur et faites cuire à feu moyen jusqu’à ébullition, le tout pendant 1 h 30.
-- > Passez le tout au mixeur pendant quelques minutes et réservez.
Pour le croustillant :
-- > Préchauffez le four th. 6 (180°C).
-- > Prenez une feuille de filo et beurrez-la sur la moitié puis pliez-la en 2. Beurrez ensuite la moitié de cette autre face, pliez-la en 2 à nouveau et beurrez le dessus (on obtient un carré). Procédez de la même manière avec les 11 autres feuilles.
-- > Posez une feuille sur un plan de travail. Placez 3 petits cabécous au centre et disposez sur le dessus 1 cuiller à soupe de confiture d’oignon.
-- > Recouvrez avec une autre feuille de filo beurrée. Ecrasez bien les bords de façon à rendre le croustillant bien hermétique. Découpez le croustillant en forme arrondie.
-- > Enfournez pendant 10 minutes.
La pâte filo est légèrement différente de la feuille de brick. Elle se présente sous forme rectangulaire, elle est plus soyeuse et plus souple à travailler, elle se dessèche moins. 
En bouche, elle se rapproche davantage d’une pâte feuilletée que la feuille de brick, plus craquante et plus friable.',
  'Cuisson : 1 h 30 + 10 min',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Flan saumon fumé-chèvre',
  'flan-saumon-fume-chevre',
  'Délicieuse entrée maison.',
  '(Cuisine et partage)
http://www.cuisineetpartage.fr/article-flans-st-valentin-saumon-fume-chevre-et-sa-sauce-hollandaise-115217066.html
150g de saumon fumé
100g de chèvre (bûche sans peau)
4 œufs
20cl de crème fraîche épaisse légère
2 pincées de piment d''Espelette pour le dessus
pour la sauce hollandaise :
1 citron (le jus)
3jaunes d''œufs
1/2 verre de lait
120g de beurre
1/2 cuillère à café de sel, poivre.',
  'Préchauffer le four à 220° thermostat 7.
Mixer le saumon fumé et le chèvre. Ajouter les œufs et la crème fraîche, bien mélanger. (ne pas saler, le saumon fumé et le chèvre suffisent)
Verser le liquide dans des moules silicones individuels ou des moules beurrés. Faire cuire 35 à 40 minutes au bain-marie. (à surveiller)
Pour la sauce hollandaise :
Faire fondre le beurre et attendre qu''il refroidisse pour commencer la sauce.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Foie gras (Raphaël Haumont)',
  'foie-gras-raphael-haumont',
  'Délicieuse entrée maison.',
  'Foie gras
(Raphaël Haumont)',
  '1/ Peser et deveiner le foie. 
2/ Le mélanger avec l’assaisonnement :
- 12g de sel par kilo.
- 2g de poivre par kilo.
- 2g de sucre par kilo.
- Pincée d''épices de Noël, muscade, etc....(facultatif).
- Un trait d''huile de noisette (facultatif).
- Un trait de cognac ou armagnac (facultatif).
3/ Serrer l''ensemble dans du film alimentaire pour former un ballotin.
4/ Faire bouillir une très grande quantité d''eau. Y plonger le ballotin.
5/ Couper le feu et laisser refroidir.
6/ Sortir le foie gras et laisser maturer au réfrigérateur au moins 2 jours.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Gratin courgettes-saumon fumé',
  'gratin-courgettes-saumon-fume',
  'Délicieuse entrée maison.',
  '(Carnet gourmand)',
  'Pour 2 personnes :
- 2 petites courgettes ;
- 2 tranches de saumon fumé ;
- 1 œuf ;
- 1cs de crème liquide ;
- gruyère râpé ;
- poivre.
Préchauffer le four à 180°C.
Couper les rondelles de courgettes en rondelles.
Les faire revenir dans une poêle huilée jusqu''à ce qu''elles soient tendres.
En mettre la moitié dans des minis cocottes (ou un plat à gratin, ou tout autre récipient allant au four).
Couper en lamelles le saumon fumé, déposer sur les courgettes puis recouvrir du reste de courgettes.
Battre l''œuf en omelette, ajouter la crème et le poivre (inutile de saler avec le saumon fumé).
Verser sur les gratins, recouvrir de gruyère et enfourner environ 20mn.
On peut aussi bien servir chaud que tiède ou froid.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Millefeuille au saumon et à l''avocat',
  'millefeuille-au-saumon-et-a-l-avocat',
  'Délicieuse entrée maison.',
  'Millefeuille au saumon et à l’avocat
(Where is the kitchen ?)
4 tranches de saumon
1 avocat bien mûr
1/2 petit billy
1 c. à café de crème fraiche
1/2 c. à café d''aneth
quelques grains entiers de poivre rouge',
  'Battez le fromage de chèvre avec la crème fraiche.
Ajoutez de l''aneth et du poivre noir moulu.
Coupez une tranche de saumon d''environ 4 cm de largeur.
Versez un peu de fromage de chèvre sur une des extrémités de la tranche de saumon.
Placez une petite tranche d’avocat et quelques grains de poivre rouge par dessus.
Repliez la tranche de saumon et refaites une couche chèvre/avocat.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Mousse de brocolis',
  'mousse-de-brocolis',
  'Délicieuse entrée maison.',
  '(Cuisine AZ)
400 g de brocolis
2 œufs
200 ml de crème fraîche liquide allégée à 8%MG
muscade
margarine (pour graisser les ramequins)
sel, poivre',
  'Graissez 4 ramequins et mettez-les au frais.
Préchauffez votre four th.6 (180 °C).
Détaillez les brocolis en petits bouquets et passez-les à l’eau froide pour les laver.
Faites bouillir dans le fond d’un autocuiseur de l’eau salée puis plongez les bouquets de brocolis dans le panier de l’autocuiseur et laissez cuire 10 min.
Rafraîchissez les brocolis sous l’eau froide et égouttez-les.
Dans un plat creux, fouettez ensemble les œufs et la crème liquide, assaisonnez de muscade râpée, de sel et de poivre.
Mixez les brocolis en purée (à l’aide d’un robot mixeur) et ajoutez-les au mélange œufs et crème jusqu’à ce que cela devienne homogène.
Remplissez les ramequins de cette mousse et enfournez 30 min.
Démoulez et dégustez !',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Petits fondants au thon et à l''estragon',
  'petits-fondants-au-thon-et-a-l-estragon',
  'Délicieuse entrée maison.',
  'Petits fondants au thon et à l’estragon
(Quand Nad cuisine)
http://quandnadcuisine.over-blog.com/article-24893814.html
Pour 6 fondants :
1 grosse boîte de thon (280 g égoutté)
125 g de fromage blanc
2 œufs
1 bonne cc de moutarde à l''ancienne
35 g de farine
estragon séché
sel, poivre',
  'Suivre les étapes de la recette.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Roulades de saumon fumé à la mousse d''avocat',
  'roulades-de-saumon-fume-a-la-mousse-d-avocat',
  'Délicieuse entrée maison.',
  'Roulades de saumon fumé à la mousse d’avocat
(Cuisine AZ)
3 avocats bien murs
8 tranches de saumon fumé
1 citron
10 cl de crème fraîche
2 c. à soupe d''herbes vertes hachées au choix
quelques tomates cerise pour la décoration
sel, poivre de Cayenne',
  'Pelez les avocats et coupez-les en lanières, écrasez à la fourchette puis arrosez aussitôt avec le jus de citron.
Mélangez la chair d''avocat avec la crème et les herbes hachées. Assaisonnez généreusement de sel et de cayenne.
Etalez les tranches de saumon et déposez un peu de mousse sur chacune d''elles.
Roulez les tranches et conservez-les au frais sous un film plastique.
Hachez finement l''oignon. Disposez 2 roulades sur chaque assiette.
Décorez de tomates cerise coupées en deux et d''1 c. à soupe d''oignon.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Roulé vert aux épinards et au saumon fumé',
  'roule-vert-aux-epinards-et-au-saumon-fume',
  'Délicieuse entrée maison.',
  '(Jardin bio Vaillant)
600g d’épinards
5 œufs
1,5 fromage ail et fines herbes
Sel et poivre
Muscade',
  'Faire cuire les épinards et bien les égoutter (pour ce faire, je les ai fait tomber au beurre). Les mixer très finement.
Couvrir l’omelette d’une couche de fromage ail et fines herbes et déposer dessus les tranches de saumon fumé en les faisant se chevaucher.
A l’aide du papier film rouler l’omelette en serrant bien puis enfermer le tout dans le papier film.
Laisser reposer au moins 1h au frigo.
Couper en tranches et servir avec une salade.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Sauce asperges',
  'sauce-asperges',
  'Délicieuse entrée maison.',
  'Sauce mousseline à l''ancienne
1 c à soupe de moutarde à l''ancienne
1 jaune d''oeuf
15 cl d''huile
1 c à soupe de jus de citron
1 blanc d''oeuf battu en neige bien ferme
1 yaourt à 0%
1 échalote hachée
1 c à soupe de moutarde forte
1 c à soupe de vinaigre de vin blanc
2 c à soupe d''huile
1  c à soupe de persil haché
1 c à soupe de ciboulette hachée
1 c à café d''estragon
sel et poivre
Sauce Minceur à l''orange
150 gr de fromage blanc à 0%
1 jaune d''oeuf
5 cl de jus d''orange
1 c à café de zeste haché très fin de l''orange
1 c à soupe de jus de citron
1 pincée de paprika
1 blanc d''oeuf monté en neige ferme
sel et poivre
Sauce au beurre ( sauce à servir chaude )
100 gr de beurre
1 jus de citron
1 c à soupe d''estragon frais
sel et poivre
5 cl de vinaigre de Xérès
10 cl d''huile
2 c à soupe de cerfeuil ciselé très fin
sel et poivre.
Asperges à la coque
2 oeufs à la coque
8 asperges
un peu de ciboulette
sel et poivre
1 jus d'' orange
30 cl de crème liquide
sel et poivre',
  'Mélangez la moutarde et le jaune d''oeuf . Battez à la fourchette en versant tout doucement 15 cl d''huile d''olive et le jus de citron. Ajoutez le blanc d''oeuf battu en neige bien ferme.
Sauce légère au yaourt
Sauce vinaigrette
Servez 2 oeufs à la coque ouverts, salés et poivrés, avec 8 asperges en guise de mouillettes. On peut ajouter aux jaunes un peu de ciboulette et des oeufs de lump.
Sauce à la crème ( sauce à servir tiède)
Servez la sauce tiède.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Terrine aux deux saumons',
  'terrine-aux-deux-saumons',
  'Délicieuse entrée maison.',
  '(Les délices d’Hélène)
Pour la taille d''un moule à cake standard
500g de saumon frais
3 œufs
20cl de crème liquide
150g de saumon fumé
sel, poivre, herbes aromatiques (aneth, ciboulette, persil)
1/2 cuil. à café de paprika pour la couleur',
  'Laisser refroidir puis garder au réfrigérateur jusqu''au moment de servir, il ne reste plus qu''à démouler !',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Terrine de courgettes, thon et tomates',
  'terrine-de-courgettes-thon-et-tomates',
  'Délicieuse entrée maison.',
  '(Ptitchef)
300g de courgettes (environ 2 courgettes)
3 œufs
2 càs de fécule de pomme de terre ou riz
20cl de crème liquide légère (5% de matière grasse pour moi)
1 petite boîte de thon
6 à 8 tomates séchées
Ciboulette Piment doux Sel et poivre',
  'Couper les courgettes en fines rondelles et les cuire à la vapeur 10 minutes. Bien les égoutter.
Préchauffer le four à 180° (thermostat 6).
A l''aide du fouet électrique, mélanger les œufs et la fécule.
Ajouter la crème liquide et mélanger à la cuillère. Puis ajouter le piment doux (une bonne càc pour moi mais c''est selon votre goût), le sel, le poivre, la ciboulette ciselée.
Couper les tomates séchées en petits morceaux. Emietter le thon. Les ajouter à l''appareil ainsi que les courgettes.
Mélanger délicatement et verser le tout dans un moule à cake en silicone (ou dans un moule classique recouvert de papier sulfurisé).
Cuire 30 minutes au four.
Laisser refroidir et mettre au frigo.
Servir bien frais.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Terrine de fromage aux tomates (Maxi Cuisine)',
  'terrine-de-fromage-aux-tomates-maxi-cuisine',
  'Délicieuse entrée maison.',
  'Terrine de fromage aux tomates
(Maxi Cuisine)
Pour 6 personnes :
400g de chèvre frais
8 tomates
2 oignons
1 gousse d’ail
4 feuilles de gélatine (10g)
2 càs crème liquide
1 bouquet d’herbes mélangées (estragon, cerfeuil, aneth, ciboulette)
Piment d’Espelette
3 càs d’huile d’olive
Sel, poivre',
  'Monder, épépiner et couper les tomates en dés. Faire revenir les tomates, les oignons et l’ail hachés dans l’huile à feu doux jusqu’à l’obtention d’une purée assez sèche. Y dissoudre une feuille de gélatine ramollie dans l’eau froide essorée.
Ecraser le chèvre frais dans un saladier avec une fourchette. Chauffer la crème et y dissoudre 3 feuilles de gélatine préalablement ramollies dans l’eau froide puis essorées. Laisser tiédir, puis incorporer cette crème au fromage de chèvre. Parsemer d’herbes ciselées et de 2 à 3 pincées de piment. Bien mélanger, saler peu. Poivrer généreusement.
Servir bien frais, démoulé à l’aide du film alimentaire et parsemer d’herbes hachées.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Terrine de légumes',
  'terrine-de-legumes',
  'Délicieuse entrée maison.',
  '(Cuisine AZ)
1 brocoli
3 carottes
100 g de fromage blanc 0%
4 œufs
persil',
  'Préchauffez votre four th.7 (210°C).
Lavez et détaillez en bouquets le brocoli.
Faites bouillir un fond d’eau dans une cocotte. A ébullition, déposez les bouquets de brocolis dans le panier de la cocotte et couvrez. Au sifflement, laissez cuire 5 minutes.
Epluchez et découpez les carottes en rondelles. Cuisez-les sans matière grasse dans une sauteuse anti-adhésive couverte. Ensuite, ajoutez les brocolis et continuez à cuire les légumes quelques minutes.
Battez les œufs.
Dans un saladier, mélangez les légumes cuits, le fromage blanc, les œufs battus et le persil frais lavé.
Cuisez la terrine au bain marie pendant 45 minutes.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Terrine de poisson aux noix de Saint-Jacques',
  'terrine-de-poisson-aux-noix-de-saint-jacques',
  'Délicieuse entrée maison.',
  '(Quand Nad cuisine)
Pour 8 petites terrines (moules à muffins en silicone, ici en forme de roses) :
400 g de merlan
100 g de crème épaisse
2 œufs
3 cs d''herbes (ciboulette, persil, cerfeuil)
8 noix de Saint-Jacques
sel, poivre
Pour la sauce :
1 cc de moutarde
20 cl de crème liquide
le jus d''1/2 citron
75 g de beurre
1 cc de ciboulette
sel, poivre',
  'Suivre les étapes de la recette.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.recipes (title, slug, description, ingredients, instructions, prep_time, cook_time, servings, category_id)
VALUES (
  'Terrine de thon aux courgettes',
  'terrine-de-thon-aux-courgettes',
  'Délicieuse entrée maison.',
  '(Marmiton)',
  'Suivre les étapes de la recette.',
  25, 20, 4,
  (SELECT id FROM public.categories WHERE slug = 'starter')
) ON CONFLICT (slug) DO NOTHING;

