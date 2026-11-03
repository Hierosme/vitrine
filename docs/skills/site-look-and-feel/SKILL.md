---
name: site-look-and-feel
description: "Maintenir le design system visuel de la vitrine (palette Nord structurée selon Material Design 3 : rôles de couleur, échelle typographique, formes, élévation, états, mouvement, points de rupture ; thèmes clair et sombre ; composants hero/cartes/boutons/CTA/preuves ; budgets de texte). À utiliser pour toute modification de style, de mise en page, de composant visuel, ou d'apparence d'une page."
---

# Look & feel — design system

> **Pourquoi ces règles ?** Voir [l'explication du design system](../../explanation/design-system.md) (première impression, crédibilité, ergonomie cognitive, Material Design 3, avec les sources). Ce skill dit **comment** appliquer ces règles.

## Sources de vérité

| Élément | Fichier |
|---|---|
| Tokens + composants CSS | `site/stylesheets/extra.css` |
| Polices, palette, icône logo, features | `zensical.toml` → `theme` |
| Surcharge de template | `overrides/main.html` (`theme.custom_dir`) : **métadonnées SEO uniquement**, aucune mise en page — voir skill `site-navigation` § Référencement |
| Favicon | `site/assets/images/favicon.svg` (icône du logo, fond nord0, motif nord8) et `apple-touch-icon.png` (180 px, même dessin, fond plein) |
| Référentiel de structure | [Material Design 3](https://m3.material.io) (fondations, styles, composants) |

Le thème de base est celui de **Zensical en variante `classic`** (`theme.variant`), qui reprend le rendu et les classes `md-*` de Material for MkDocs : ne pas passer à la variante `modern` sans revoir `extra.css`. On le personnalise par des variables CSS, on ne le réécrit pas : ses conventions (logo en haut à gauche, menu en haut, pied de page) sont un atout.

**Identité ≠ structure.** L'identité (palette Nord, Inter, dégradé du hero) est propre au site. La **structure** des tokens et des composants suit Material Design 3 : rôles de couleur, échelles de type, de formes et d'élévation, couches d'état, mouvement, points de rupture. On ne reprend pas la palette par défaut de M3 (violet) ni Roboto.

## Principes

| # | Principe | Fondement | Conséquence concrète |
|---|---|---|---|
| P1 | **Esthétique classique d'abord** | Lavie & Tractinsky 2004 | Ordre, alignement, espaces réguliers (grille de 4dp), deux polices. La sobriété prime sur l'originalité. |
| P2 | **Un seul geste expressif** | Lavie & Tractinsky 2004 | Seul le dégradé Polar Night → Frost du hero est « expressif ». Aucun autre effet sans décision explicite. |
| P3 | **Le hero est l'écran des 50 ms** | Lindgaard et al. 2006 | Titre + proposition de valeur + 2 boutons maximum, compréhensible d'un coup d'œil, au-dessus de la ligne de flottaison. |
| P4 | **La finition fait la crédibilité** | Fogg et al. 2003 ; Tractinsky et al. 2000 | Aucun défaut toléré en clair, en sombre, ni à aucun point de rupture. Un détail raté dégrade le jugement global. |
| P5 | **Homogénéité** | Bastien & Scapin 1993 ; M3 (tokens) | Une seule palette (Nord), des rôles M3, des échelles uniques, deux styles de bouton seulement. |
| P5bis | **Deux thèmes égaux** | Bastien & Scapin (adaptabilité) ; M3 (schémas clair et sombre) | Clair et sombre ont les mêmes rôles. Tout ajout définit son rôle **dans les deux thèmes**. |
| P6 | **Une action principale** | Hick 1952 ; M3 (« filled : idéalement une seule action par page ») | Un seul bouton `--primary` (filled) par page : contacter. |
| P7 | **Zéro charge extrinsèque** | Sweller 1988 | Pas de carrousel, d'animation décorative, d'autoplay ni de pop-up. Le mouvement ne sert qu'aux retours d'état (M3 : durées courtes). |
| P8 | **Des preuves vraies et visibles** | Fogg 2003 ; Cyr 2008 | Références dans `vt-proof`. **Jamais** de référence, logo ou témoignage inventé : un `TODO` plutôt qu'un faux. |
| P9 | **La couleur sert la hiérarchie** | Bastien & Scapin ; WCAG 1.4.1 ; M3 (rôles) | Les accents marquent des **repères** (rang d'une carte, étape de la frise, intertitre). Jamais seuls porteurs d'information. |
| P10 | **Des paires de rôles, jamais des couleurs** | M3 « Color roles » | Un texte sur `X` prend `on-X`. Pas de combinaison hors paire : c'est elle qui garantit le contraste dans les deux thèmes. |
| P11 | **Un état = une couche, pas une autre couleur** | M3 « States » | Survol 8 %, focus 10 %, appui 10 % de la couleur du contenu sur le conteneur. Pas d'état sur un élément non interactif. |
| P12 | **Accessible par construction** | M3 « Accessibility » ; WCAG 2.2 | Liens soulignés, anneau de focus de 3dp, cibles de 48dp, un seul H1, aucun niveau de titre sauté, 60 caractères par ligne au plus. |

## Couleur : rôles M3 sur la palette Nord

Le site utilise la palette [Nord](https://www.nordtheme.com/docs/colors-and-palettes) dans un thème clair et un thème sombre ; le thème par défaut suit la préférence système, la bascule est dans l'en-tête.

### Trois couches de tokens (`extra.css`)

| Couche | Section | Contenu | Qui l'utilise |
|---|---|---|---|
| **Palette** | `1. TOKENS` (1.a, 1.b) | `--vt-nord0…15` (officiels) et dérivés de même teinte | **Uniquement** la section 2 (et les ombres 1.d) |
| **Rôles** | `2. THÈMES` | Rôles M3 `--vt-primary`, `--vt-on-surface`, `--vt-surface-container-*`… et couleurs personnalisées (`--vt-brand-*`, `--vt-hero-*`, `--vt-accent-*`, `--vt-code-*`), définis par thème | Les composants (section 3) et le mapping (section 2bis) |
| **Mapping thème** | `2bis` | `--md-*` → rôles (y compris `--md-shadow-z1…3` → élévation M3) | Le thème Zensical |

**Règle d'or :** un composant n'utilise jamais `var(--vt-nordX)`, seulement un rôle. `mise run check` le vérifie.

### Rôles M3 par thème

| Rôle M3 | Clair (Snow Storm) | Sombre (Polar Night) | Usage |
|---|---|---|---|
| `primary` / `on-primary` | nord10-aa / nord6 | nord9-bright / nord0 | Liens, bouton principal (filled) |
| `primary-container` / `on-primary-container` | nord10-container / nord10-on-container | nord10-aa / nord6 | Bloc CTA de fin de page |
| `secondary` / `on-secondary` | nord8-aa / nord6 | nord8 / nord0 | Anneau de focus, liseré de citation |
| `secondary-container` / `on-…` | nord8-container / nord8-on-container | nord8-on-container / nord6 | Citation (devise) |
| `tertiary` / `-container` (+ `on-…`) | nord15-aa / nord15-container | nord15-bright / nord15-on-container | Encadrés « exemple » |
| `error` / `-container` (+ `on-…`) | nord11-aa / nord11-container | nord11-bright / nord11-on-container | Encadrés « danger » |
| `surface` / `on-surface` / `on-surface-variant` | nord6 / nord0 / nord3 | nord0 / nord6 / nord4 | Fond de page, texte, texte secondaire, libellé des boutons outlined |
| `surface-container-lowest…highest` | nord6-bright, nord5-soft, nord5, nord4-soft, nord4 | nord0-deep, nord1-dim, nord1, nord2, nord2-bright | Cartes (low), tuiles (high) |
| `inverse-surface` / `inverse-on-surface` / `inverse-primary` | nord1 / nord6 / nord8 | nord6 / nord1 / nord10-aa | Réservés (snackbar, infobulle) |
| `outline` / `outline-variant` | nord3-outline / nord4 | nord3-bright / nord3 | Contour des boutons outlined (3:1) / séparateurs, frise, tableaux |
| `scrim`, `shadow` | nord0 | nord0 | Voiles, ombres |

### Couleurs personnalisées (M3 « custom colors »)

| Groupe | Clair | Sombre | Usage |
|---|---|---|---|
| `brand` / `brand-variant` / `on-brand` / `brand-focus` | nord0 / nord1 / nord6 / nord8 | nord1 / nord0-deep / nord6 / nord8 | En-tête, onglets, pied de page (Polar Night dans les deux thèmes) |
| `hero-*` | dégradé nord0 → nord1 → nord10, CTA nord8 / nord0, texte nord6 | dégradé nord1 → nord2 → nord10, idem | Hero de l'accueil, toujours sombre |
| `accent-1…6` | nord10, nord8-ui, nord14-ui, nord13-ui, nord12-ui, nord15-ui | nord9, nord8, nord14, nord13, nord12, nord15 | Repères catégoriels non textuels |
| `code-*` | dérivés `-aa` | Frost / Aurora | Coloration syntaxique |
| `admonition-*` | info `primary`, astuce nord14, alerte nord13, danger `error`, question `secondary`, exemple `tertiary` | idem | Encadrés des articles |

### Dérivés

Les couleurs Nord n'atteignent souvent pas les contrastes AA ou ne fournissent pas assez de niveaux de surface. On **dérive des variantes de même teinte** : multiplication RVB (assombri) ou mélange vers une autre couleur Nord ou le blanc (éclairci). Nommage `--vt-nordX-<suffixe>` (`-aa` texte, `-ui` non textuel, `-bright`, `-soft`, `-dim`, `-deep`, `-outline`, `-container`, `-on-container`), avec en commentaire son origine et son usage. Les valeurs sont dans `extra.css` § 1.b.

### Accents catégoriels

Les éléments répétés (cartes, étapes de frise, tuiles) reçoivent `--vt-accent` selon leur rang, en cycle sur `--vt-accent-1…6`. Le rouge (`nord11`) est réservé au danger. Le cycle est défini **une seule fois** (bloc « Cycle d'accent »). Les accents sont **non textuels** et atteignent 3:1 sur la page, les cartes et les tuiles (`design:contrast`).

## Échelles M3 (`extra.css` § 1)

Unités : la racine du thème vaut 20 px (125 %), donc **1dp M3 = 0.05rem** ; les tailles de texte sont en `em` du corps (16 px).

| Échelle | Tokens | Valeurs | Affectation |
|---|---|---|---|
| **Formes** | `--vt-shape-none…full` | 0, 4, 8, 12, 16, 20, 28, 32, 48dp, full | Boutons, portrait, barres : `full` · cartes, tuiles, citation : `medium` · CTA : `large` · hero : `extra-large` · encadrés, blocs de code : `small` · code en ligne : `extra-small` · appui sur un bouton : `small` (shape morph) |
| **Élévation** | `--vt-elevation-0…5` | ombres M3 (clé 30 % + ambiante 15 %) | Cartes : 1 · portrait : 2 · bouton principal survolé : 1 · encadrés, tuiles, CTA : 0 (séparation par la teinte). Niveaux 4–5 réservés aux interactions. |
| **États** | `--vt-state-hover/focus/pressed/dragged/disabled` | 8 %, 10 %, 10 %, 16 %, 38 % | `color-mix(in srgb, <on-couleur> var(--vt-state-hover), <conteneur>)` |
| **Focus** | `--vt-focus-ring-width/offset` | 3px, 2px | Anneau `secondary` (fonds clairs), `brand-focus` (en-tête, pied), `hero-focus` (hero) |
| **Typographie** | `--vt-type-<rôle>-<taille>-size/-line/-tracking`, `--vt-font-weight-*` | échelle M3 : display, headline, title, body, label | H1 : headline large · H2 : headline small · H3 : title large · H4 : title medium · intitulé de groupe : title small · hero : headline large → display small (expanded) · accroche : body large → title large · corps : body large · cartes et tuiles : body medium (titre de carte : title medium) · boutons, preuves : label large |
| **Mouvement** | `--vt-motion-easing-*`, `--vt-motion-duration-*` | standard `cubic-bezier(0.2, 0, 0, 1)`, 150 et 200 ms | Transitions d'état seulement (`--vt-transition-state`), désactivées si `prefers-reduced-motion` |
| **Espacement** | `--vt-space-1…6` | 4, 8, 16, 24, 40, 64dp | Seule échelle d'espacement autorisée |
| **Dimensions** | `--vt-size-button`, `--vt-size-target`, `--vt-measure`, `--vt-portrait-size(-compact)` | 40dp, 48dp, 60ch, 13rem / 8rem | Boutons, cibles tactiles, longueur de ligne, portrait |

Graisses : 400 (regular), 500 (medium, M3 pour labels et titles) et 700 (variante « emphasized » retenue pour les titres de page et de section). Interlettrage d'Inter : 0 pour le corps de texte (les valeurs M3 sont calibrées pour Roboto), valeurs M3 pour labels et titres.

### Points de rupture M3

Les variables CSS sont interdites dans `@media` : les valeurs sont écrites dans `extra.css` § 4 et ici.

| Classe M3 | Largeur | Comportement |
|---|---|---|
| compact | < 37.5em (600dp) | Hero en colonne, portrait 8rem, une carte par ligne |
| medium | 37.5em – 52.4375em | Hero en ligne, grilles de 4 en 2 × 2 |
| expanded | 52.5em – 74.9375em (840dp) | Portrait 13rem, titre du hero en display small, accroche en title large |
| large / extra-large | ≥ 75em / ≥ 100em | Identique à expanded (le contenu est plafonné par le thème) |

## Composants disponibles

| Composant | Markdown | Équivalent M3 | Usage et budget |
|---|---|---|---|
| Hero | `<div class="vt-hero" markdown>` portrait, puis `<div class="vt-hero-text" markdown>` (H1, accroche, boutons) `</div></div>` | — (couleur personnalisée) | Une fois, en haut de l'accueil. H1 ≤ 6 mots, accroche ≤ 30 mots, 2 boutons maximum. Colonne en compact, ligne dès medium. |
| Portrait | `![Portrait de …](assets/images/….jpg){ .vt-portrait width="480" height="480" fetchpriority="high" }` | — | Dans le hero uniquement, en **premier** élément. Photo carrée réelle (480 px, JPEG ≤ 50 Ko), `alt` descriptif. |
| Cartes | `<div class="grid cards" markdown>` + liste | Carte **elevated** (surface-container-low, niveau 1, medium, 16dp) | 2 à 6 cartes par grille (au-delà, plusieurs grilles avec un intitulé de groupe). Icône `:material-…:` + titre gras + `---` + **une phrase ≤ 20 mots**. Liseré supérieur et icône à l'accent du rang. Non cliquables en entier : aucun effet de survol. 4 cartes = 2 × 2. |
| Intitulé de groupe | `Libellé` puis `{ .vt-group-label }` à la ligne, juste avant une grille | Title small, on-surface-variant | Nomme une famille de cartes (page Services). Pas un titre : ni table des matières, ni niveau de titre. |
| Intertitre H2 | `## Titre` | Headline small | Barre d'accent sous chaque H2 (repère de balayage). |
| Frise | `<div class="vt-timeline" markdown>` autour de H3 successifs | — | Un H3 par étape, pastille à l'accent du rang, ligne `outline-variant`. |
| Tuiles | `<div class="vt-tiles" markdown>` autour d'une liste | Carte **filled**, remappée sur surface-container-high (les accents y gardent 3:1) | 2 à 6 éléments `**Libellé** — détail`. 3 colonnes au plus ; 4 = 2 × 2. |
| Citation | `> **Phrase**` | secondary-container | Devise ou citation, une par page maximum. |
| Bouton principal | `[Texte](page.md){ .md-button .md-button--primary }` | Bouton **filled** (primary / on-primary, rond, 40dp) | **Un seul par page.** Libellé = verbe d'action, 1 à 3 mots, sans retour à la ligne. |
| Bouton secondaire | `[Texte](page.md){ .md-button }` | Bouton **outlined** (contour outline, libellé on-surface-variant) | Une ou deux actions secondaires maximum. |
| CTA de fin | `<div class="vt-cta" markdown>` … `</div>` | primary-container, rayon large | Fin de chaque page de contenu, une phrase et un bouton. |
| Preuves | `<div class="vt-proof" markdown>` + images ou texte court | — | Logos clients, certifications : **uniquement réels et autorisés**. |
| Encadrés | `!!! note`, `!!! tip`, `??? question` | Rôles M3 (primary, secondary, tertiary, error) | Articles de blog uniquement. |

Icônes : jeu `material/` en priorité, `fontawesome/brands/` pour les logos de réseaux. **Une icône est toujours accompagnée d'un libellé** (signifiance des codes).

## Règles techniques

1. **Aucune valeur littérale** hors de la section `TOKENS` : couleur, rayon (`border-radius`), ombre (`box-shadow`), taille et graisse de texte (`font-size`, `line-height`, `font-weight`, `letter-spacing`), mouvement (`transition`, `animation`). `mise run check` le vérifie. Un besoin nouveau donne un **token** (§ 1) ou un **rôle** (§ 2, défini pour les deux thèmes) et s'ajoute aux tableaux ci-dessus.
2. **Pas de couleur hors palette Nord.** Si aucune couleur ne convient, on crée un dérivé de même teinte.
3. **Respecter les paires M3** : un texte sur `X` prend `on-X` ; texte secondaire `on-surface-variant` ; contour d'une cible `outline` (3:1) ; séparateur décoratif `outline-variant`. Un nouveau couple s'ajoute à la liste `pairs` de `.mise/tasks/design/contrast`.
4. Contraste **WCAG AA** : 4.5:1 pour le texte, 3:1 pour les composants d'interface et les accents. `mise run design:contrast` calcule les ratios à partir du CSS.
5. **États** : uniquement sur ce qui est interactif, par couche d'état (`--vt-state-*`) de la couleur du contenu. Pas de changement de teinte arbitraire au survol.
6. Toute classe maison est préfixée **`vt-`**. Ne pas surcharger les classes `.md-*` en dehors des sections `MAPPING` et `COMPOSANTS`.
7. Pas de JavaScript, de police ni de dépendance CSS externe supplémentaire sans décision explicite du propriétaire. Toute ressource externe (police, image) passe par le plugin `privacy`.
8. **Mobile d'abord** : styles de base pour compact, puis `@media (min-width: 37.5em)` et `(min-width: 52.5em)`. Vérifier les trois classes, en clair et en sombre.
9. **Pas d'élément orphelin** dans une grille (P1) : 4 éléments en 2 × 2, 6 en 3 + 3.
10. Un nouveau composant va dans `extra.css` (section COMPOSANTS, commentaire d'usage et équivalent M3) **et** dans le tableau « Composants disponibles », avec son budget.

## Anti-patterns à refuser

- Carrousel, slider, texte animé, parallaxe, vidéo en lecture automatique, pop-up de capture d'email.
- Plusieurs boutons primaires (filled), ou un hero à 3 boutons et plus.
- Nouvelle couleur « juste pour cette page », ou une teinte hors Nord (le violet de base M3, le turquoise Material…).
- `var(--vt-nordX)` dans un composant ; texte sur un conteneur sans son rôle `on-*`.
- Rayon, ombre ou taille de texte écrits en dur au lieu d'un token.
- Effet de survol sur un élément non cliquable ; niveau d'élévation 4 ou 5 au repos.
- Lien non souligné dans le contenu ; anneau de focus supprimé ou invisible.
- Accent utilisé comme couleur de texte, ou couleur seule pour transmettre une information.
- Rôle défini dans un seul des deux thèmes.
- Icône seule sans texte comme lien de navigation.
- Logo client, chiffre ou témoignage non vérifié.

## Checklist avant de terminer

- [ ] `mise run check` passe : valeurs littérales, palette via les rôles, contrastes AA des deux thèmes, préfixes `vt-`, un seul bouton principal par page, hiérarchie des titres, builds stricts.
- [ ] Rendu vérifié en clair et en sombre, aux trois classes compact / medium / expanded (`mise run site:serve`), y compris états survol, focus clavier (Tab) et appui.
- [ ] Budgets de texte respectés : hero, cartes, CTA.
- [ ] Audit rapide Bastien & Scapin et M3 : guidage, charge de travail, homogénéité, signifiance ; paires de rôles respectées ; cibles de 48dp.
- [ ] Tableaux « Couleur », « Échelles » et « Composants » de ce skill à jour. Si un principe change, mettre aussi à jour `docs/explanation/design-system.md`.
