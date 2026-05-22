# 🛒 Tenir une session de marché (point de vente)

À quoi ça sert : encaisser les ventes au marché, suivre le stock en temps réel et éviter les comptes papier.

> Le point de vente fonctionne sur tablette ou smartphone, en wifi ou en 4G. Il garde les ventes même en cas de perte de réseau temporaire.

---

## Avant de partir au marché

1. Vérifier que la tablette / smartphone est **chargée** (≥ 80 %).
2. Vérifier que les articles à vendre ont bien été ajoutés à l'inventaire et au stock "Marché" (voir [Ajouter un article](inventaire-articles.md)).
3. Si paiement carte : prendre le lecteur **SumUp** et vérifier sa charge.

---

## Ouvrir la session de vente

1. Sur la tablette, ouvrir un navigateur et aller sur **https://thegoat.karpos.pro/web**.
2. Se connecter avec le compte vendeur.
3. Cliquer sur **Point de Vente** dans le menu principal.
4. Choisir la caisse **Marché** → cliquer sur **Continuer la session en cours** (ou **Nouvelle session**).
5. L'écran de vente s'affiche : à gauche les articles, à droite le panier.

---

## Encaisser un client

1. Cliquer sur l'article vendu → il s'ajoute au panier (à droite).
2. Pour augmenter la quantité : cliquer plusieurs fois sur l'article ou utiliser le pavé numérique.
3. Pour appliquer une remise :
   - Sélectionner la ligne dans le panier.
   - Cliquer sur **% Remise** sur le pavé.
   - Saisir le pourcentage.
4. Quand le panier est complet, cliquer sur **Paiement**.
5. Choisir le mode :
   - **Espèces** : saisir le montant reçu, l'écran affiche la monnaie à rendre.
   - **Carte (SumUp)** : suivre les instructions sur le lecteur.
6. Valider avec **Valider**.
7. Proposer le ticket (papier ou par email si client enregistré).

> Pour associer la vente à un client existant : cliquer sur **Client** en haut du panier, sélectionner ou créer le client (voir [Gérer les clients](clients.md)).

---

## Pendant le marché

- Le stock se décrémente automatiquement à chaque vente.
- Si plus de réseau : continuer à vendre normalement. Les ventes seront synchronisées dès la reconnexion (un petit symbole en haut indique le statut).
- Pour annuler une vente en cours : cliquer sur la corbeille à droite du panier.

---

## Clôturer la session en fin de marché

1. Cliquer sur **Fermer** en haut à droite de l'écran de vente.
2. Saisir le **montant compté en caisse** (espèces) — Odoo compare avec ce qui était attendu.
3. Si le montant correspond : cliquer sur **Fermer la session**.
4. Si un écart : noter une raison (rendu de monnaie, erreur de saisie) puis fermer.

---

## Si ça coince

- **Article introuvable au scan / recherche** : vérifier qu'il est bien dans la catégorie POS (voir [Ajouter un article](inventaire-articles.md)).
- **Pas de réseau** : vendre quand même, les ventes se synchroniseront. Ne pas fermer la session tant que le réseau n'est pas revenu.
- **Lecteur SumUp non détecté** : vérifier le Bluetooth de la tablette et la charge du lecteur.
- **Stock indique 0 alors que les pièces sont en main** : un article a été oublié au stock "Marché" avant de partir. Appeler Loïc ou continuer en désactivant le contrôle de stock pour cette vente.
