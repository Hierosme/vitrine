---
name: site-look-and-feel
description: Maintenir le design system visuel de la vitrine (palette Nord, thèmes clair et sombre, couleurs, typographie, espacements, composants hero/cartes/boutons/CTA/preuves, modes clair et sombre, budgets de texte). À utiliser pour toute modification de style, de mise en page, de composant visuel, ou d'apparence d'une page.
---

# Look & feel — design system

> **Pourquoi ces règles ?** Voir [l'explication du design system](../../explanation/design-system.md) (première impression, crédibilité, ergonomie cognitive, avec les sources). Ce skill dit **comment** appliquer ces règles.

## Sources de vérité

| Élément | Fichier |
|---|---|
| Tokens + composants CSS | `site/stylesheets/extra.css` |
| Polices, palette, icône logo, features | `mkdocs.yml` → `theme` |
| Surcharge de template | `overrides/main.html` (`theme.custom_dir`) : **métadonnées SEO uniquement**, aucune mise en page — voir skill `site-navigation` § Référencement |
| Favicon | `site/assets/images/favicon.svg` (icône du logo, fond nord0, motif nord8) et `apple-touch-icon.png` (180 px, même dessin, fond plein) |

Le thème de base est **Material for MkDocs**. On le personnalise par des variables CSS, on ne le réécrit pas : ses conventions (logo en haut à gauche, menu en haut, pied de page) sont un atout.

## Principes

| # | Principe | Fondement | Conséquence concrète |
|---|---|---|---|
| P1 | **Esthétique classique d'abord** | Lavie & Tractinsky 2004 | Ordre, alignement, espaces réguliers, deux polices. La sobriété prime sur l'originalité. |
| P2 | **Un seul geste expressif** | Lavie & Tractinsky 2004 | Seul le dégradé Polar Night → Frost du hero est « expressif ». Aucun autre effet sans décision explicite. |
| P3 | **Le hero est l'écran des 50 ms** | Lindgaard et al. 2006 | Titre + proposition de valeur + 2 boutons maximum, compréhensible d'un coup d'œil, au-dessus de la ligne de flottaison. |
| P4 | **La finition fait la crédibilité** | Fogg et al. 2003 ; Tractinsky et al. 2000 | Aucun défaut toléré en clair, en sombre, sur desktop ou sur mobile. Un détail raté dégrade le jugement global. |
| P5 | **Homogénéité** | Bastien & Scapin 1993 | Une seule palette (Nord), tokens uniques, composants réutilisés, deux styles de bouton seulement. |
| P5bis | **Deux thèmes égaux** | Bastien & Scapin (adaptabilité) | Clair et sombre ont le même soin et les mêmes rôles. Tout ajout définit son rôle **dans les deux thèmes**. |
| P6 | **Une action principale** | Hick 1952 ; Hyman 1953 | Un seul bouton `--primary` par page : contacter. |
| P7 | **Zéro charge extrinsèque** | Sweller 1988 | Pas de carrousel, d'animation décorative, d'autoplay ni de pop-up. |
| P9 | **La couleur sert la hiérarchie** | Bastien & Scapin (groupement / distinction par le format) ; WCAG 1.4.1 | Les accents marquent des **repères** : rang d'une carte, étape de la frise, intertitre. Jamais décoratifs, jamais seuls porteurs d'information (toujours un texte ou une forme avec). |
| P8 | **Des preuves vraies et visibles** | Fogg 2003 ; Cyr 2008 | Références dans `vt-proof`. **Jamais** de référence, logo ou témoignage inventé : un `TODO` plutôt qu'un faux. |

## Identité : palette Nord, deux thèmes

Sobre, technique, fiable. Le site utilise la palette [Nord](https://www.nordtheme.com/docs/colors-and-palettes) dans un thème clair et un thème sombre. Le thème par défaut suit la préférence système du visiteur ; la bascule est dans l'en-tête.

### Trois couches de tokens (`extra.css`)

| Couche | Section | Contenu | Qui l'utilise |
|---|---|---|---|
| **Palette** | `1. TOKENS` | `--vt-nord0…15` (officiels) et dérivés `-aa`, `-deep`, `-bright` | **Uniquement** la section 2 |
| **Rôles** | `2. THÈMES` | `--vt-color-*`, `--vt-code-*`, `--vt-hero-*`, `--vt-admonition-*`, définis par thème | Les composants (section 3) et le mapping Material (section 2bis) |
| **Mapping Material** | `2bis` | `--md-*` → rôles | Le thème Material |

**Règle d'or :** un composant n'utilise jamais `var(--vt-nordX)`, seulement un rôle. Changer de palette ou de thème ne demande alors de toucher qu'aux sections 1 et 2. `mise run check` le vérifie.

### Palette Nord officielle

| Groupe | Tokens | Usage |
|---|---|---|
| Polar Night | `--vt-nord0…3` | Fonds du thème sombre, en-tête, texte du thème clair |
| Snow Storm | `--vt-nord4…6` | Fonds du thème clair, texte du thème sombre |
| Frost | `--vt-nord7…10` | Accents : liens, CTA, focus, coloration du code |
| Aurora | `--vt-nord11…15` | Sémantique : erreur, alerte, succès, encadrés, code |

### Dérivés accessibles

Plusieurs couleurs Nord n'atteignent pas le contraste AA en texte, par exemple `nord10` sur `nord6` : 3.5:1. On dérive alors une variante de **même teinte** en multipliant ses composantes RVB :

| Token | Origine | Usage |
|---|---|---|
| `--vt-nord10-aa` / `-aa-hover` | nord10 × 0.80 / × 0.70 | Liens et CTA du thème clair |
| `--vt-nord7-aa`, `nord11-aa`, `nord13-aa`, `nord14-aa`, `nord15-aa` | × 0.50 à 0.75 | Coloration du code, thème clair |
| `--vt-nord0-deep` | nord0 × 0.93 | Fond de code, thème sombre |
| `--vt-nord8-ui`, `nord12-ui`, `nord13-ui`, `nord14-ui`, `nord15-ui` | × 0.62 à 0.84 | Accents **non textuels** du thème clair (≥ 3:1, WCAG 1.4.11) |
| `--vt-nord3-bright`, `--vt-nord11-bright` | éclaircis | Commentaires et erreurs de code, thème sombre |

Un nouveau dérivé est nommé `--vt-nordX-<suffixe>`, avec en commentaire son origine et son ratio.

### Rôles par thème

| Rôle | Clair (Snow Storm) | Sombre (Polar Night) |
|---|---|---|
| `--vt-color-bg` / `-surface` / `-border` | nord6 / nord5 / nord4 | nord0 / nord1 / nord2 |
| `--vt-color-text` / `-text-muted` | nord0 / nord3 | nord6 / nord4 |
| `--vt-color-brand` (en-tête) | nord0 | nord1 |
| `--vt-color-link` / `-link-hover` | nord10-aa / nord10-aa-hover | nord8 / nord7 |
| `--vt-color-accent` (CTA) / `-on-accent` | nord10-aa / nord6 | nord8 / nord0 |
| `--vt-color-focus` | nord10 | nord8 |
| `--vt-code-bg` | nord5 | nord0-deep |
| Hero (`--vt-hero-*`) | dégradé nord0 → nord1 → nord10, CTA nord8 | dégradé nord1 → nord2 → nord10, CTA nord8 |
| Accents `--vt-accent-1…6` | nord10, nord8-ui, nord14-ui, nord13-ui, nord12-ui, nord15-ui | nord9, nord8, nord14, nord13, nord12, nord15 |
| Encadrés (`--vt-admonition-*`) | info nord10, astuce nord14, alerte nord13, danger nord11, question nord8, exemple nord15 | idem |

### Accents catégoriels

Les éléments répétés (cartes, étapes de frise, tuiles) reçoivent `--vt-accent` selon leur rang, en cycle sur `--vt-accent-1…6` : Frost bleu, Frost cyan, puis Aurora vert, jaune, orange et violet. Le rouge (`nord11`) est réservé au danger. Le cycle est défini **une seule fois** dans `extra.css` (bloc « Cycle d'accent »). Un nouveau composant répété s'y ajoute, sans recréer sa propre logique de couleurs.

Les accents sont **non textuels** (bordures, pastilles, icônes, barres). Ils doivent atteindre 3:1 sur le fond et la surface, ce que `design:contrast` vérifie. Ne jamais les utiliser comme couleur de texte : prendre alors un dérivé `-aa`.

### Autres tokens

| Token | Valeur | Usage |
|---|---|---|
| `--vt-radius` / `--vt-radius-lg` | `0.6rem` / `1rem` | Boutons, cartes / hero |
| `--vt-shadow` | ombre douce en nord0 translucide | Cartes |
| `--vt-space-1…6` | 0.25 → 4rem | Seule échelle d'espacement autorisée |
| `--vt-measure` | `38rem` (~65 car.) | Largeur max des textes d'accroche |
| `--vt-portrait-size` / `-mobile` | `13rem` / `8rem` | Diamètre du portrait |

Typographie : **Inter** pour le texte, **JetBrains Mono** pour le code. Aucune autre police. Elles sont **auto-hébergées** au build par le plugin `privacy` (aucune requête vers Google depuis le navigateur).
Graisses : **400 et 700 uniquement**, celles que charge `theme.font` (un 600 serait rendu en 700 ou simulé). Les H1 sont en 700, comme celui du hero, pour dominer les H2.
Transparences : `color-mix(in srgb, var(--vt-color-…) N%, transparent)`, jamais de `rgba()` littéral.

## Composants disponibles

| Composant | Markdown | Usage et budget |
|---|---|---|
| Hero | `<div class="vt-hero" markdown>` portrait, puis `<div class="vt-hero-text" markdown>` (H1, accroche, boutons) `</div></div>` | Une fois, en haut de l'accueil. H1 ≤ 6 mots, accroche ≤ 30 mots, 2 boutons maximum. Flex : texte centré verticalement face au portrait (à droite) ; en colonne sur mobile, portrait au-dessus. |
| Portrait | `![Portrait de …](assets/images/….jpg){ .vt-portrait width="480" height="480" fetchpriority="high" }` | Dans le hero uniquement, en **premier** élément, avant `vt-hero-text`. Photo carrée réelle (480 px, JPEG ≤ 50 Ko), `alt` descriptif. Rond, liseré Frost ; réduit sur mobile. |
| Cartes | `<div class="grid cards" markdown>` + liste | 3 à 6 cartes. Icône `:material-…:` + titre gras + `---` + **une phrase ≤ 20 mots**. Liseré supérieur et icône prennent automatiquement l'accent de leur rang. Le titre peut être un lien vers une ancre de la page (cartes-sommaire de Services). **4 cartes = grille 2 × 2** (automatique), jamais 3 + 1. |
| Intertitre H2 | `## Titre` | Barre d'accent dégradée automatique sous chaque H2 (repère de balayage). |
| Frise | `<div class="vt-timeline" markdown>` autour de H3 successifs | Parcours chronologique : un H3 par étape, pastille colorée selon le rang. |
| Tuiles | `<div class="vt-tiles" markdown>` autour d'une liste | 2 à 6 éléments courts au format `**Libellé** — détail`. Liseré gauche coloré selon le rang. **3 colonnes au plus** ; 4 tuiles = 2 × 2 (automatique). |
| Citation | `> **Phrase**` | Devise ou citation : liseré accent-2, fond teinté. Une par page maximum. |
| Bouton principal | `[Texte](page.md){ .md-button .md-button--primary }` | **Un seul par page.** Libellé = verbe d'action (« Me contacter », « Parlons-en »). |
| Bouton secondaire | `[Texte](page.md){ .md-button }` | Une ou deux actions secondaires maximum. Contour couleur lien ; se remplit au survol. |
| CTA de fin | `<div class="vt-cta" markdown>` … `</div>` | Fin de chaque page de contenu, une phrase et un bouton. |
| Preuves | `<div class="vt-proof" markdown>` + images ou texte court | Logos clients, certifications : **uniquement réels et autorisés**. Les images sont mises en niveaux de gris automatiquement. |
| Encadrés | `!!! note`, `!!! tip`, `??? question` | Articles de blog uniquement. |

Icônes : jeu `material/` en priorité, `fontawesome/brands/` pour les logos de réseaux. **Une icône est toujours accompagnée d'un libellé** (signifiance des codes).

## Règles techniques

1. **Aucune valeur en dur** (couleur, rayon, ombre, espacement) hors de la section `TOKENS` de `extra.css`. Un besoin de couleur nouveau donne un **rôle** dans la section 2, défini pour les deux thèmes, qui pointe vers la palette ; il s'ajoute aux tableaux ci-dessus.
2. **Pas de couleur hors palette Nord.** Si aucune couleur Nord ne convient, on crée un dérivé de même teinte, sans importer d'autre teinte.
3. Toute classe maison est préfixée **`vt-`**. Ne pas surcharger les classes `.md-*` en dehors des sections `MAPPING` et `COMPOSANTS` existantes.
4. Contraste texte/fond **WCAG AA** minimum : 4.5:1 pour le texte courant, 3:1 pour le gros texte et les composants d'interface. `mise run design:contrast` calcule les ratios à partir du CSS. Un nouveau couple texte/fond doit être ajouté à la liste `pairs` de ce script.
5. Pas de JavaScript, de police ni de dépendance CSS externe supplémentaire sans décision explicite du propriétaire. Toute ressource externe (police, image) passe par le plugin `privacy`, qui la télécharge au build.
8. **Pas d'élément orphelin** dans une grille (P1) : 4 éléments en 2 × 2, 6 en 3 + 3. Les règles sont dans `extra.css` (« Grilles de 4 éléments », `vt-tiles`).
6. Mobile d'abord : vérifier sous 45em, où le hero réduit son padding.
7. Un nouveau composant va dans `extra.css` (section COMPOSANTS, avec un commentaire d'usage) **et** dans le tableau « Composants disponibles », avec son budget.

## Anti-patterns à refuser

- Carrousel, slider, texte animé, parallaxe, vidéo en lecture automatique, pop-up de capture d'email.
- Plusieurs boutons primaires, ou un hero à 3 boutons et plus.
- Nouvelle couleur « juste pour cette page », ou une teinte hors Nord (le turquoise Material par défaut, par exemple).
- `var(--vt-nordX)` utilisé directement dans un composant.
- Accent utilisé comme couleur de texte, ou couleur seule pour transmettre une information.
- Plus de couleurs que de repères : un accent par élément répété, pas de dégradé arc-en-ciel.
- Rôle défini dans un seul des deux thèmes.
- Icône seule sans texte comme lien de navigation.
- Logo client, chiffre ou témoignage non vérifié.

## Checklist avant de terminer

- [ ] `mise run check` passe : couleurs en dur, palette utilisée via les rôles, contrastes AA des deux thèmes, préfixes `vt-`, un seul CTA principal par page, builds stricts.
- [ ] Rendu vérifié en clair et en sombre, sur desktop et mobile (`mise run site:serve`).
- [ ] Budgets de texte respectés : hero, cartes, CTA.
- [ ] Audit Bastien & Scapin rapide : guidage, charge de travail, homogénéité et signifiance sont-ils préservés ?
- [ ] Tableaux « Identité » et « Composants » de ce skill à jour. Si un principe change, mettre aussi à jour `docs/explanation/design-system.md`.
