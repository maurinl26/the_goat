# Digitalisation vente mohair — Note de projet

> [!NOTE] Contexte
> Note de cadrage pour le pilote de digitalisation avec une éleveuse de la coopérative SICA Mohair. Le test porte sur la **vente en direct au marché**, avec un socle minimaliste qui peut évoluer vers la boutique en ligne et le suivi coopératif.

---

## Objectif du pilote

Équiper une éleveuse de trois capacités progressives :

- [ ] **Suivi de stock** — savoir ce qu'elle a, en temps réel
- [ ] **Vente au marché** — encaisser, décrémenter le stock, sans papier
- [ ] **Suivi commandes SICA** — tracer ce qui part en transformation, ce qui revient

> [!TIP] Valeur stratégique pour SICA Mohair
> Ce déploiement pilote documente un **modèle standard** réplicable aux 150 membres de la coopérative. C'est un argument concret pour la position de partenaire industriel : un outil opérationnel testé, pas seulement une vision.

---

## Outil retenu : Odoo Community (open source)

Odoo est recommandé pour sa **cohérence avec la vision SICA** (traçabilité lot → fil → vente) et parce que la maîtrise technique est déjà présente pour le déployer.

Modules activés pour le pilote :

| Module | Usage |
|--------|-------|
| **Inventaire** | Stock matières premières + produits finis |
| **Point of Sale (POS)** | Caisse mobile au marché, mode hors-ligne |
| **Portail partenaire** | Accès SICA pour voir les envois en transformation |

---

## 🧪 Phase de test — Vente au marché

### Ce qu'on valide

Le test avec la cousine a un périmètre volontairement réduit :

1. Encoder les produits une fois (pelotes, écharpes, tricots…) avec leurs variantes (coloris, grammage)
2. Utiliser Odoo POS sur une **tablette ou smartphone** pendant un marché réel
3. Encaisser en espèces **et** par carte sans contact
4. Vérifier que le stock se décrémente correctement après la session
5. Identifier les frictions avant tout déploiement plus large

> [!WARNING] Point d'attention : le stock "marché"
> Créer un **sous-stock dédié aux articles emportés** au marché, distinct du stock atelier. Cela évite de survendre en ligne ce qui est physiquement absent.

### Déroulé type d'une session de test

```
J-3  Encodage des produits dans Odoo (avec photos optionnelles)
J-1  Chargement de la tablette, test du mode hors-ligne
J    Vente au marché → encaissements POS
J+0  Synchronisation des ventes au retour
J+1  Revue : stock cohérent ? Tickets corrects ? Temps de saisie ?
```

### Matériel nécessaire pour le test

| Équipement | Détail | Coût |
|------------|--------|------|
| Tablette | Android 10+ ou iPad (si déjà disponible : 0€) | 0 à 200 € |
| Lecteur carte | **SumUp Air** — sans abonnement, compatible POS | ~29 € |
| Connexion | Partage de connexion smartphone suffit pour la synchro | 0 € |
| Impression ticket | **Optionnel** — ticket papier non indispensable pour tester | 0 € |

---

## 💶 Coûts détaillés

### Phase de test (one-shot)

| Poste | Montant | Notes |
|-------|---------|-------|
| Hébergement VPS OVH (1 mois) | ~6 € | Starter 2 vCPU / 4 Go RAM |
| Nom de domaine | ~15 € | Annuel, ~1,25 €/mois |
| Certificat SSL | 0 € | Let's Encrypt, inclus |
| SumUp Air (lecteur carte) | ~29 € | Commission : 1,69 %/transaction |
| Tablette (si achat) | 150–200 € | Optionnel si smartphone disponible |
| Temps de configuration | 0 € | Réalisé en interne |
| **Total sans tablette** | **~50 €** | |
| **Total avec tablette** | **~230 €** | |

> [!TIP] Si la cousine a déjà un smartphone Android récent
> Le test peut démarrer à **moins de 50 €** : Odoo POS fonctionne dans le navigateur mobile, sans application dédiée.

---

### Coûts récurrents (après validation du pilote)

#### Scénario A — Pilote marché uniquement (pas de boutique en ligne)

| Poste | Coût mensuel |
|-------|-------------|
| Hébergement VPS OVH Starter | 6 € |
| Domaine + SSL | ~1,25 € |
| SumUp (commission ventes) | ~1,69 % du CA marché |
| Maintenance Odoo | 0 € (open source) |
| **Total fixe** | **~7,25 €/mois** |

#### Scénario B — Pilote marché + boutique en ligne

| Poste | Coût mensuel |
|-------|-------------|
| Hébergement VPS OVH Confort | ~12 € |
| Domaine + SSL | ~1,25 € |
| Stripe (paiement en ligne) | 1,5 % + 0,25 €/transaction |
| Expédition (étiquettes Colissimo) | Variable selon commandes |
| **Total fixe** | **~13,25 €/mois** |

#### Scénario C — Odoo Online (hébergé par Odoo, sans VPS)

| Poste | Coût mensuel |
|-------|-------------|
| Odoo Online One App | ~25 €/mois/utilisateur |
| Avantage | Zéro maintenance serveur |
| Inconvénient | Plus cher, moins de contrôle |
| **Recommandation** | ❌ À éviter pour ce cas d'usage |

---

### Tableau de décision

| Critère | VPS (~7€/mois) | Odoo Online (~25€/mois) |
|---------|---------------|------------------------|
| Coût | ✅ Minimal | ❌ Élevé |
| Maintenance | ⚠️ Technique requise | ✅ Aucune |
| Contrôle | ✅ Total | ❌ Limité |
| Scalabilité | ✅ Facile | ✅ Facile |
| **Verdict pilote** | ✅ **Recommandé** | Pour si besoin d'autonomie totale |

---

## Étapes suivantes

- [ ] Confirmer que la cousine a une tablette ou smartphone disponible
- [ ] Lister ses produits actuels (catégories, variantes, prix)
- [ ] Choisir une date de marché pour le premier test réel
- [ ] Commander SumUp Air (livraison ~3 jours)
- [ ] Déployer Odoo sur VPS OVH (2-3h de config)
- [ ] Former la cousine sur la saisie POS (~1h)

---

## Liens utiles

- [Odoo Community](https://www.odoo.com/fr_FR/page/community) — téléchargement open source
- [OVH VPS Starter](https://www.ovhcloud.com/fr/vps/) — hébergement recommandé
- [SumUp Air](https://www.sumup.com/fr-fr/lecteurs-carte-bancaire/air/) — lecteur carte marché
- [Stripe](https://stripe.com/fr) — paiement en ligne (Scénario B)

---

*Note créée dans le cadre du projet SICA Mohair — partenariat industriel filière mohair française*

#mohair #SICA #odoo #digitalisation #pilote #vente-directe
