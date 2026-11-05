---
name: site-look-and-feel
description: "Implémenter dans Zensical la norme de design Oxygen UI × Nord (tokens --vt-*, rôles de couleur clair et sombre, composants hero/cartes/tuiles/boutons/CTA/preuves, contrôles mise). À utiliser pour toute modification de style, de mise en page, de composant visuel ou d'apparence d'une page, toujours avec le skill oxygen-ui-design-guidelines."
---

# Look & feel — implémentation Zensical de la norme

> **La norme fait autorité.** Les règles de décision (quand encadrer, mettre en valeur, contraster, espacer, utiliser le clair ou le sombre) sont dans [`oxygen-ui-design-guidelines`](../oxygen-ui-design-guidelines/SKILL.md), à lire en entier **avant** ce skill. Ce skill-ci dit seulement **comment** elles s'écrivent dans ce dépôt : la norme parle MUI (`Card`, `Alert`, `sx`, `extendTheme`), le site est en Zensical et CSS. En cas de doute ou de contradiction, la norme l'emporte et ce skill doit être corrigé.
>
> **Pourquoi ces choix ?** Voir [l'explication du design system](../../explanation/design-system.md).

## Sources de vérité

| Élément | Fichier |
|---|---|
| Tokens, rôles, composants CSS | `site/stylesheets/extra.css` |
| Polices (Inter, Fira Code), palette, icône logo, features | `zensical.toml` → `theme` |
| Surcharge de template | `overrides/main.html` (`theme.custom_dir`) : **métadonnées SEO uniquement**, aucune mise en page — voir skill `site-navigation` § Référencement |
| Favicon | `site/assets/images/favicon.svg` (icône du logo, fond nord0, motif nord8) et `apple-touch-icon.png` (180 px, même dessin, fond plein) |
| Contrôles | `mise run check`, `mise run design:contrast` |

Le thème de base est **Zensical en variante `classic`** (`theme.variant`), qui reprend le rendu et les classes `md-*` de Material for MkDocs : ne pas passer à la variante `modern` sans revoir `extra.css`. On l'habille par des variables CSS, on ne le réécrit pas : ses conventions (logo en haut à gauche, menu en haut, pied de page) sont un atout.

## Correspondance norme → Zensical

| Norme (MUI / Oxygen UI) | Ici |
|---|---|
| `theme.vars.palette.*`, variables `--oxygen-*` | Rôles `--vt-*` (§ 2 d'`extra.css`), repris par les variables `--md-*` du thème (§ 2bis) |
| `colorSchemes.light` / `.dark` | `[data-md-color-scheme="default"]` / `[data-md-color-scheme="slate"]` |
| Section inversée (`ThemeProvider` imbriqué, `data-color-scheme="dark"`) | Attribut `data-md-color-scheme="slate"` sur le `<div>` du CTA (le hero suit le thème) |
| `theme.spacing(n)` | `--vt-spacing-n` (n × 8px ; `--vt-spacing-0-5` = 4px) |
| `shape.borderRadius` | `--vt-radius` (8px) |
| `shadows-*` = `none` | `--vt-shadow-none`, et `--md-shadow-z1…3` neutralisées |
| Variantes typographiques `h1`…`caption` | `--vt-type-<variante>-size` / `-line` |
| `Card variant="outlined"` | Grille de cartes `grid cards`, tuiles `vt-tiles` |
| `Alert` (standard / outlined) | Encadrés `!!!` (articles), citation `>` |
| `Button variant="contained" color="primary"` / `variant="outlined"` | `.md-button .md-button--primary` / `.md-button` |
| `Chip`, `Snackbar`, `Tooltip`, `Dialog` | Sans objet sur cette vitrine statique (ne pas en créer sans décision) |
| Points de rupture `sm` 600px / `md` 900px | `@media (min-width: 37.5em)` / `(min-width: 56.25em)` |

## Couleur

### Trois couches de tokens (`extra.css`)

| Couche | Section | Contenu | Qui l'utilise |
|---|---|---|---|
| **Palette** | `1. TOKENS` (1.a, 1.b) | `--vt-nord0…15` et les **3 seuls dérivés** de la norme : `--vt-nord10-strong`, `--vt-nord11-strong`, `--vt-nord11-soft` | **Uniquement** la section 2 |
| **Rôles** | `2. THÈMES` | Rôles de la norme, définis par thème | Les composants (section 3) et le mapping (2bis) |
| **Mapping thème** | `2bis` | `--md-*` → rôles | Le thème Zensical |

**Règle d'or :** un composant n'utilise jamais `var(--vt-nordX)`, seulement un rôle. `mise run check` le vérifie, ainsi que la palette fermée (aucune autre couleur que les 19 autorisées).

### Rôles par thème

| Rôle | Clair (« bright to dark ») | Sombre (Polar Night) | Usage |
|---|---|---|---|
| `bg-default` | nord6 | nord0 | Fond de page (niveau 0) |
| `bg-paper` | nord5 | nord1 | Niveau 1 : cartes, tuiles, citation, en-tête, onglets, pied de page, CTA (dans sa portée sombre) |
| `bg-raised` | nord4 | nord2 | Niveau 2 : menus, popovers (aucun texte d'accent dessus) |
| `text-primary` / `text-secondary` | nord0 / nord3 | nord6 / nord4 | Texte courant / secondaire |
| `divider` | nord4 | nord2 | Séparateurs, bordure de toute surface de niveau 1 |
| `field-border` | nord3 | nord9 | Contour d'une cible (3:1) |
| `action-hover` / `action-selected` | nord5 / nord4 | nord1 / nord2 | Survol / sélection, surlignage (`mark`), bouton de recherche |
| `primary` / `primary-contrast` | nord10-strong / nord6 | nord8 / nord0 | Liens, bouton principal, bouton outlined |
| `accent` | nord10 | nord8 | **Seul** accent des repères non textuels : barre sous les H2, pastilles de la frise, icônes de cartes (pas de liseré sur les cartes ni les tuiles) |
| `focus` | nord10 | nord8 | Anneau de focus (2px) |
| `error` / `error-text` | nord11 / nord11-strong | nord11 / nord11-soft | Icône, liseré / texte d'erreur |
| `warning`, `success`, `info`, `highlight` | nord13, nord14, nord8, nord7 | idem | États (encadrés), jamais de texte en clair ; texte posé dessus : `on-state` (nord0) |
| `gradient-primary` | nord9 → nord10 | idem | Bande décorative du hero uniquement |
| `code-*` | blocs nord0, coloration Nord | idem (+ bordure nord2) | Blocs de code, sombres dans les deux thèmes |
| `code-inline-bg` / `-fg` | nord4 / nord0 | nord2 / nord6 | Code en ligne |

### Sections inversées

Seul le bloc CTA de fin de page est une **section inversée** : son `<div>` porte `data-md-color-scheme="slate"`. Il hérite ainsi de tous les rôles sombres (texte nord6, accent nord8, bouton nord8 + nord0) sans aucune règle CSS spécifique, et pose une surface `bg-paper` (nord1) bordée de `divider` pour rester visible sur une page déjà sombre. **2 par page au maximum** (vérifié par `check`). Le hero de l'accueil, l'en-tête et le pied de page **suivent le thème** (décision de l'opérateur) : `check` refuse un `data-md-color-scheme` sur le hero.

## Échelles (`extra.css` § 1)

La racine du thème vaut 20 px (125 %) : **1px de la norme = 0.05rem**.

| Échelle | Tokens | Valeurs | Affectation |
|---|---|---|---|
| **Forme** | `--vt-radius`, `--vt-border-width`, `--vt-accent-bar`, `--vt-callout-bar` | 8px, 1px, 3px, 4px | Rayon unique partout (boutons, cartes, tuiles, hero, CTA, code, pastilles) |
| **Ombres** | `--vt-shadow-none` | `none` | Aucune ombre, nulle part |
| **États** | `--vt-opacity-hover/focus/pressed` | 8 %, 12 %, 12 % | `color-mix(in srgb, <libellé> X, <conteneur>)` sur les boutons uniquement |
| **Teintes** | `--vt-opacity-tint`, `--vt-opacity-comment` | 15 %, 70 % | Titre d'encadré, commentaires de code |
| **Focus** | `--vt-focus-ring-width/offset` | 2px, 2px | Anneau `focus` |
| **Typographie** | `--vt-type-<variante>-size/-line`, `--vt-font-weight-*` | h1 28 · h2 24 · h3 22 · h4 20 · h5 16 · h6 14/500 · subtitle1 18 · body1 14 · body2 13 · button 14/500 · caption 11 | Corps : body1 · titres H1–H4 : h1–h4 (graisse 400) · titre de carte : h5 · intitulé de groupe : h6 · accroche du hero et texte du CTA : subtitle1 · preuves : body2 · emphase sans cadre : graisse 500/600 |
| **Mouvement** | `--vt-easing-standard`, `--vt-duration-shortest` | `cubic-bezier(0.4, 0, 0.2, 1)`, 150 ms | Transitions d'état des boutons seulement, coupées si `prefers-reduced-motion` |
| **Espacement** | `--vt-spacing-0-5…8` | 4, 8, 16, 24, 32, 40, 48, 64px | Seule échelle autorisée (voir § Espacement de la norme) |
| **Dimensions** | `--vt-size-button`, `--vt-size-target`, `--vt-measure` | 40px, 48px, 60ch | Boutons, cibles tactiles, longueur de ligne |

### Points de rupture

Les variables CSS sont interdites dans `@media` : les valeurs sont écrites dans `extra.css` § 4.

| Classe | Largeur | Comportement |
|---|---|---|
| xs | < 37.5em (600px) | Une carte par ligne |
| sm et plus | ≥ 37.5em | Grilles de 4 en 2 × 2 |

## Composants disponibles

> **Un service, pas un profil.** Le site présente des missions, pas une personne à embaucher : **aucun portrait ni avatar** (hero, blog, image de partage). L'image de partage est le logo en attendant une image dédiée (backlog B-14).

| Composant | Markdown | Équivalent norme | Usage et budget |
|---|---|---|---|
| Hero | `<div class="vt-hero" markdown>` puis `<div class="vt-hero-text" markdown>` (H1, accroche, boutons) `</div></div>` | Zone ouverte (sans cadre ni fond), séparée par l'espace (64px dessous) + dégradé de marque (bande décorative) | Une fois, en haut de l'accueil. H1 ≤ 6 mots, accroche ≤ 30 mots, 2 boutons maximum. |
| Cartes | `<div class="grid cards" markdown>` + liste | `Card variant="outlined"` (niveau 1, bordure `divider`, icône `accent`) | Unités autonomes et répétées : 2 à 6 cartes par grille, jamais une seule. Icône `:material-…:` + titre gras + `---` + **une phrase ≤ 20 mots**. Non cliquables en entier : aucun effet de survol. 4 cartes = 2 × 2. |
| Intitulé de groupe | `Libellé` puis `{ .vt-group-label }` à la ligne, juste avant une grille | Typographie h6, texte secondaire | Nomme une famille de cartes. Pas un titre. |
| Expertises | `<div class="vt-expertises" markdown>` : `<nav class="vt-exp-list" markdown>` (intitulés de groupe + entrées `<a class="vt-exp-item" href="#ancre">` avec `vt-exp-index`, `vt-exp-icon`, `vt-exp-title`, `vt-exp-pitch`) puis `<div class="vt-exp-panels" markdown>` (un `<section class="vt-exp-panel" markdown>` par expertise) | Liste de `Card outlined` cliquables (niveau 0) + panneau de détail (niveau 1, collant sous l'en-tête) ; sélection d'accent | Accueil et Services. **Fonctionne en CSS seul** : le panneau affiché est celui dont le titre est la cible de l'URL (`:target`), le premier par défaut. **`site/javascripts/expertises.js`** (seul script du site, décision du propriétaire) supprime le saut de défilement : il ajoute `.vt-js`, marque l'entrée (`aria-current`) et le panneau (`.is-current`) choisis, et met l'URL à jour par `history.replaceState`. 8 entrées, sans intitulé de famille. **Un pictogramme `:material-…:` distinct par expertise**, le même sur les deux pages. Mobile : liste masquée, panneaux empilés. Structure détaillée : skill `site-navigation`. |
| Intertitre H2 | `## Titre` | h2 + liseré `accent` | Repère de balayage sous chaque H2. |
| Frise | `<div class="vt-timeline" markdown>` autour de H3 successifs | — | Un H3 par étape, pastille `accent`, ligne `divider`. |
| Tuiles | `<div class="vt-tiles" markdown>` autour d'une liste | `Card variant="outlined"` sans icône ni liseré | 2 à 6 éléments `**Libellé** — détail`. 3 colonnes au plus ; 4 = 2 × 2. |
| Citation | `> **Phrase**` | Callout (niveau 1, bordure gauche `info`) | Devise ou citation : 1 par page, compte dans la limite des callouts. |
| Bouton principal | `[Texte](page.md){ .md-button .md-button--primary }` | `Button contained primary` | **Un seul par page.** Libellé = verbe d'action, 1 à 3 mots. |
| Bouton secondaire | `[Texte](page.md){ .md-button }` | `Button outlined` | Une ou deux actions secondaires maximum. |
| CTA de fin | `<div class="vt-cta" data-md-color-scheme="slate" markdown>` … `</div>` | Section inversée (CTA final) | Fin de chaque page de contenu, accueil compris : une phrase et un bouton (secondaire sur l'accueil, dont le hero porte déjà le principal). Libellé orienté action et bénéfice (« Décrire mon projet »), jamais « Parlons-en » ou « Cliquez ici ». |
| Lien d'action | `[Discuter de … :material-arrow-right:](contact.md){ .vt-next }` | Lien (graisse 500) | En fin de chaque section de service : un chemin vers le contact sans attendre le bas de page. Jamais un bouton. |
| Preuves | `<div class="vt-proof" markdown>` + images ou texte court | — | Logos clients, certifications : **uniquement réels et autorisés**. |
| Encadrés | `!!! note`, `!!! tip`, `!!! warning`, `!!! danger`, `??? question`, `!!! example` | `Alert` standard (info, succès, avertissement, erreur ; `highlight` pour exemple) | Articles de blog uniquement. 1 visible à l'écran, 3 par page. Sévérité = sens réel. |

Icônes : jeu `material/` en priorité, `fontawesome/brands/` pour les logos de réseaux. **Une icône est toujours accompagnée d'un libellé.**

## Règles techniques

1. **Aucune valeur littérale** hors de la section `TOKENS` : couleur, rayon, ombre, taille et graisse de texte, interlignage, mouvement. Un besoin nouveau donne un **token** (§ 1) ou un **rôle** (§ 2, défini pour les deux thèmes) et s'ajoute aux tableaux ci-dessus.
2. **Palette fermée** : 16 couleurs Nord + `nord10-strong`, `nord11-strong`, `nord11-soft`. Une teinte translucide d'une couleur Nord (`color-mix(…, transparent)`) est permise ; toute autre couleur est refusée par `check`.
3. Contraste **WCAG AA** : 4.5:1 pour le texte (un libellé de bouton 14px est du texte courant), 3:1 pour les composants d'interface et les repères. Un nouveau couple texte/fond s'ajoute à la liste `pairs` de `.mise/tasks/design/contrast`.
4. **Aucune ombre** : `box-shadow` et `--md-shadow-z*` ne valent que `none` (`check`).
5. **États** : uniquement sur ce qui est interactif, par opacité de la couleur du libellé (`--vt-opacity-*`).
6. Toute classe maison est préfixée **`vt-`**. Ne pas surcharger les classes `.md-*` en dehors des sections `MAPPING` et `COMPOSANTS`.
7. Pas de JavaScript, de police ni de dépendance CSS externe supplémentaire sans décision explicite du propriétaire. Toute ressource externe (police, image) passe par le plugin `privacy`.
8. **Mobile d'abord** : styles de base pour xs, puis `@media (min-width: 37.5em)` et `(min-width: 56.25em)`. Vérifier les trois classes, en clair et en sombre.
9. **Pas d'élément orphelin** dans une grille : 4 éléments en 2 × 2, 6 en 3 + 3.
10. Un nouveau composant va dans `extra.css` (section COMPOSANTS, commentaire d'usage et équivalent norme) **et** dans le tableau « Composants disponibles », avec son budget.

## Anti-patterns à refuser

- Carrousel, slider, texte animé, parallaxe, vidéo en lecture automatique, pop-up de capture d'email.
- Plusieurs boutons principaux, ou un hero à 3 boutons et plus.
- Couleur hors des 19 autorisées, nouvelle nuance « juste pour cette page », Aurora utilisée comme décoration, plusieurs accents de repère.
- `var(--vt-nordX)` dans un composant ; rôle défini dans un seul thème.
- Ombre, élévation, rayon autre que `--vt-radius`, taille de texte en dur.
- Cadre dans un cadre, carte seule, paragraphe d'intro encadré.
- Texte posé sur le dégradé de marque ; plus de 2 sections inversées par page ; section inversée recolorée à la main au lieu de `data-md-color-scheme="slate"`.
- Couleur pastel (Frost clair, Aurora) comme texte en thème clair ; couleur seule pour transmettre une information.
- Effet de survol sur un élément non cliquable ; lien non souligné dans le contenu ; anneau de focus supprimé.
- Icône seule sans texte comme lien de navigation.
- Logo client, chiffre ou témoignage non vérifié.

## Checklist avant de terminer

- [ ] Checklist de la norme (`oxygen-ui-design-guidelines` § 10) parcourue.
- [ ] `mise run check` passe : palette fermée, valeurs littérales, design plat, palette via les rôles, contrastes AA des deux thèmes, sections inversées (CTA seul), préfixes `vt-`, un seul bouton principal par page, hiérarchie des titres, builds stricts.
- [ ] Rendu vérifié en clair et en sombre, aux trois classes xs / sm / md (`mise run site:serve`), y compris survol, focus clavier (Tab) et appui.
- [ ] Budgets de texte respectés : hero, cartes, CTA.
- [ ] Tableaux « Rôles », « Échelles » et « Composants » de ce skill à jour. Si un principe change, mettre aussi à jour `docs/explanation/design-system.md`.
