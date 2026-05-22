# 📦 Ajouter un article à l'inventaire

À quoi ça sert : enregistrer un nouveau produit (pelote, écharpe, gilet, etc.) pour qu'il puisse être vendu au point de vente et apparaître éventuellement sur la boutique en ligne.

> Un article créé dans l'inventaire est automatiquement disponible dans le point de vente s'il est marqué comme tel (voir étape 4).

---

## Créer un article simple

1. Aller sur **https://thegoat.karpos.pro/web** et se connecter.
2. Menu **Inventaire** → onglet **Produits** → **Produits**.
3. Cliquer sur **Nouveau** en haut à gauche.
4. Remplir la fiche :
   - **Nom du produit** : ex. « Écharpe mohair grise ».
   - **Photo** : cliquer sur l'icône appareil photo en haut à droite, téléverser.
   - **Catégorie** : choisir Écharpes / Pelotes / Gilets / etc.
   - **Type de produit** : *Produit stockable* (essentiel pour le suivi de stock).
   - **Prix de vente** : prix TTC affiché au marché.
   - **Disponible au point de vente** : cocher la case (sinon il n'apparaîtra pas en caisse).
   - **Vente** (onglet) : cocher **Peut être vendu**.
5. Cliquer sur **Enregistrer** (icône nuage en haut).

## Créer un article avec variantes (taille, coloris)

Quand le même article existe en plusieurs versions (ex. : écharpe en 4 coloris) :

1. Suivre les étapes ci-dessus jusqu'à l'enregistrement.
2. Aller dans l'onglet **Attributs & variantes** sur la fiche produit.
3. Cliquer **Ajouter une ligne** :
   - Attribut : *Coloris* (créer s'il n'existe pas).
   - Valeurs : taper *Écru, Gris, Brun, Bleu*.
4. Enregistrer : Odoo crée automatiquement une variante par combinaison.

## Mettre du stock initial

1. Sur la fiche produit, cliquer sur **Mettre à jour la quantité** (bouton en haut à droite).
2. Saisir la quantité par variante (ex. : 5 écharpes grises, 3 écharpes brunes).
3. Choisir l'emplacement de stock :
   - **Stock/Atelier** : ce qui reste à la ferme.
   - **Stock/Marché** : sous-stock dédié pour ce qui part au marché. *À utiliser avant chaque marché.*
4. Valider.

## Transférer du stock atelier → marché

Avant chaque marché, déplacer ce qui est emporté :

1. Menu **Inventaire** → **Opérations** → **Transferts**.
2. Cliquer **Nouveau** → Type d'opération : *Transfert interne*.
3. Origine : *Stock/Atelier*, Destination : *Stock/Marché*.
4. Ajouter les articles et quantités.
5. **Valider**.

---

## Si ça coince

- **L'article n'apparaît pas au point de vente** : vérifier que **Disponible au point de vente** est coché et que la catégorie POS est correcte sur la fiche.
- **Stock négatif** : une vente a été enregistrée sans stock préalable. Faire un transfert ou ajuster manuellement via **Mettre à jour la quantité**.
- **Doublons** : avant de créer, rechercher dans la liste des produits (icône loupe) pour éviter de créer deux fois le même.
