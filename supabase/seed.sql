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
