# 👤 Gérer les clients (point de vente)

À quoi ça sert : associer une vente à un client connu pour :
- envoyer le ticket par email plutôt que sur papier,
- suivre l'historique d'achat d'un fidèle,
- éditer une facture nominative (si demandée).

> Une vente peut se faire sans client (vente anonyme, le cas le plus courant au marché). On enregistre un client seulement quand c'est utile.

---

## Ajouter un client depuis le point de vente

1. Dans l'écran de vente, cliquer sur **Client** en haut du panier (à droite).
2. La liste des clients existants s'affiche.
3. Cliquer sur **Créer** (en haut à droite de la liste).
4. Remplir au minimum :
   - **Nom** (obligatoire).
   - **Email** (recommandé pour envoyer le ticket).
   - **Téléphone** (facultatif).
   - **Adresse** (facultatif, utile pour facture nominative).
5. Cliquer **Enregistrer**.
6. Le client est automatiquement associé à la vente en cours.

## Rechercher / sélectionner un client existant

1. Cliquer sur **Client** en haut du panier.
2. Dans la barre de recherche en haut de la liste, taper le nom ou l'email.
3. Cliquer sur le client → il est sélectionné pour la vente.

## Modifier les informations d'un client

1. Cliquer sur **Client** → rechercher le client.
2. Cliquer sur le crayon ✏️ à côté de son nom.
3. Modifier les champs nécessaires.
4. **Enregistrer**.

## Supprimer / archiver un client

Odoo ne supprime pas réellement un client : il l'**archive** (pour garder l'historique des ventes).

1. Quitter le point de vente : menu **Contacts** (depuis le backend Odoo).
2. Rechercher le client → cliquer sur sa fiche.
3. Menu **Action** (engrenage ⚙️ en haut) → **Archiver**.
4. Le client n'apparaît plus dans les listes par défaut.

> Pour retrouver un client archivé : filtre **Archivé** dans la barre de recherche de la liste des contacts.

---

## Bon réflexes au marché

- Pour un **client de passage** : ne pas créer de fiche. Vendre en anonyme.
- Pour un **habitué qui veut son ticket par email** : créer ou rechercher la fiche, lui demander son email.
- Pour une **demande de facture** (entreprise, comité d'entreprise…) : créer la fiche avec adresse + numéro SIRET / TVA si fournis, puis associer la vente.

---

## Si ça coince

- **Un client n'apparaît pas dans la recherche** : il est peut-être archivé. Vérifier dans **Contacts** avec le filtre Archivé.
- **Deux fiches pour la même personne** : c'est fréquent. Quitter le POS, aller dans **Contacts**, archiver la fiche en double et garder celle qui a l'historique de ventes.
- **Envoi de ticket par email échoue** : vérifier l'orthographe de l'email sur la fiche.
