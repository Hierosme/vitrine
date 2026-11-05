---
name: oxygen-ui-design-guidelines
description: "Règles de décision visuelle pour concevoir ou relire une interface Oxygen UI (WSO2, basé sur MUI) avec la palette Nord comme norme de couleur : quand encadrer, mettre en valeur, contraster, espacer, utiliser light/dark."
---

# Oxygen UI × Nord — guidelines de décision visuelle

Ce skill dit **quand** appliquer un traitement visuel (cadre, mise en valeur, contraste, espacement, thème clair/sombre) dans une interface construite avec **Oxygen UI**, le design system de WSO2 bâti sur **MUI (Material UI)**. La **palette Nord** (nordtheme.com, `nord0`…`nord15`) est la **norme de couleur** : elle remplace la palette d'origine d'Oxygen UI. Les composants, la typographie, l'espacement et le rayon restent ceux d'Oxygen UI.

Applique-le dès que tu crées, modifies ou relis une page, un composant ou un écran Oxygen UI / MUI.

## 0. Règle d'or : l'ordre de préférence

Pour séparer, regrouper ou faire ressortir un élément, essaie les moyens **dans cet ordre** et arrête-toi au premier qui suffit :

1. **Espacement** (rapprocher ce qui va ensemble, éloigner le reste)
2. **Typographie** (taille, graisse, couleur `text.secondary`)
3. **Fond / surface** (changer de niveau Polar Night ou Snow Storm)
4. **Bordure** (`divider`, 1px)
5. **Couleur sémantique** (Frost pour l'accent, Aurora pour les états)
6. **Dégradé / effet** (`gradient-primary`, blur) — exceptionnel

Oxygen UI et Nord sont tous deux des systèmes **plats** : toutes les ombres (`shadows-1…24`) valent `none`. **N'ajoute jamais de `box-shadow` ni d'`elevation` pour créer de la hiérarchie** : utilise le niveau de surface ou la bordure (§4).

## 1. La palette Nord

| Groupe | Tokens | Rôle Nord |
|---|---|---|
| **Polar Night** (sombres) | `nord0` `#2E3440` · `nord1` `#3B4252` · `nord2` `#434C5E` · `nord3` `#4C566A` | Fonds et surfaces en dark ; texte en light |
| **Snow Storm** (clairs) | `nord4` `#D8DEE9` · `nord5` `#E5E9F0` · `nord6` `#ECEFF4` | Fonds et surfaces en light ; texte en dark |
| **Frost** (bleus) | `nord7` `#8FBCBB` · `nord8` `#88C0D0` · `nord9` `#81A1C1` · `nord10` `#5E81AC` | Accents UI : `nord8` = accent principal, `nord9` = secondaire, `nord10` = tertiaire, `nord7` = élément à faire ressortir à côté de `nord8` |
| **Aurora** (états) | `nord11` `#BF616A` · `nord12` `#D08770` · `nord13` `#EBCB8B` · `nord14` `#A3BE8C` · `nord15` `#B48EAD` | `nord11` erreur · `nord12` fonction avancée/dangereuse (rare) · `nord13` avertissement · `nord14` succès · `nord15` fonction inhabituelle (rare) |

**Nuances dérivées autorisées.** Nord autorise d'autres nuances de ses couleurs. Seules ces trois-là sont autorisées ici, et uniquement pour atteindre le contraste WCAG AA. Elles gardent la teinte d'origine et ne modifient que la luminosité :

| Token dérivé | Valeur | Usage unique |
|---|---|---|
| `nord10-strong` | `#476993` | Liens, texte d'accent et bouton principal en **light** (4.9:1 sur `nord6`, 4.6:1 sur `nord5`) |
| `nord11-strong` | `#A64A54` | Texte d'erreur et bouton destructif en **light** (4.9:1 sur `nord6`, 4.6:1 sur `nord5`) |
| `nord11-soft` | `#F7939B` | Texte d'erreur en **dark** (5.7:1 sur `nord0`, 4.6:1 sur `nord1`) |

N'invente **aucune autre** couleur et n'utilise aucune valeur hexadécimale en dur : passe par le thème (`theme.vars.palette.*`, `sx`) ou les variables CSS `--oxygen-*`.

## 2. Correspondance Oxygen UI → Nord

**Méthode.** Chaque token est remplacé par la couleur Nord **la plus proche** (distance perceptuelle OKLab) **dans la famille qui correspond à son rôle** : neutres → Polar Night/Snow Storm, accents → Frost, états → Aurora. Le choix est forcé dans trois cas, marqués ⚑ : quand la couleur la plus proche viole le rôle (ex. `grey.600` tomberait sur `nord10`, un bleu), quand elle échoue au contraste, ou quand elle contredit la doc Nord.

### Fonds, surfaces, texte

| Token Oxygen | Origine light → **Nord light** | Origine dark → **Nord dark** |
|---|---|---|
| `background.default` | `#ffffff` → **`nord6`** | `#060d1a` → **`nord0`** |
| `background.paper` (carte, panneau) | blanc @50 % → **`nord5`** | `#0a1628` @46 % → **`nord1`** |
| Surface surélevée (menu, dialog, popover) | → **`nord4`** ⚑ (rôle Nord « élevé ») | overlays 1–24 → **`nord2`** ⚑ |
| `background.acrylic` (+ `blur-*`) | → **`nord6` @80 %** | → **`nord0` @80 %** |
| `text.primary` | `#181818` → **`nord0`** | `#ffffff` → **`nord6`** |
| `text.secondary` | 72 % → **`nord3`** | 70 % → **`nord4`** |
| `text.disabled` | 38 % → **`nord3` @60 %** | 50 % → **`nord3`** |
| `divider` | noir @7 % → **`nord4`** | blanc @9 % → **`nord2`** ⚑ (`nord3` si trop discret) |
| `action.hover` | noir @4 % → **`nord5`** | blanc @8 % → **`nord1`** |
| `action.selected` | noir @8 % → **`nord4`** | blanc @16 % → **`nord2`** (rôle Nord « sélection ») |
| `common.black` / `common.white` | → **`nord0`** / **`nord6`** | idem |

### Gris

| Oxygen | → Nord | Oxygen | → Nord |
|---|---|---|---|
| `grey.50` `#fafafa` | `nord6` | `grey.500` `#9e9e9e` | `nord4` ⚑ (au plus proche : `nord9`, bleu) |
| `grey.100` `#f5f5f5` | `nord6` | `grey.600` `#757575` | `nord3` ⚑ (au plus proche : `nord10`, bleu) |
| `grey.200` `#eeeeee` | `nord6` | `grey.700` `#616161` | `nord3` |
| `grey.300` `#e0e0e0` | `nord4` | `grey.800` `#424242` | `nord1` |
| `grey.400` `#bdbdbd` | `nord4` ⚑ (au plus proche : `nord7`) | `grey.900` `#212121` | `nord0` |

Nord n'a que 7 neutres pour 10 gris : plusieurs gris fusionnent. N'utilise donc pas l'échelle `grey.*` pour hiérarchiser : utilise les rôles (`background.*`, `text.*`, `divider`).

### Accent et états

| Token Oxygen | Origine | → **Nord light** | → **Nord dark** |
|---|---|---|---|
| `primary.main` | `#3688FF` | **`nord10`** (UI, icônes, bordures) · `nord10-strong` (texte, bouton) | **`nord8`** ⚑ (`nord10` = 3.1:1 sur `nord0` ; `nord8` = accent principal Nord) |
| `primary.light` | `#6ba8f5` | **`nord9`** | **`nord9`** |
| `primary.dark` | `#2d78e0` | **`nord10-strong`** | **`nord10`** |
| `primary.contrastText` | `#fff` | **`nord6`** sur `nord10-strong` | **`nord0`** sur `nord8` ⚑ |
| `secondary.main` | `#5498b4` | **`nord9`** | **`nord9`** |
| `secondary.light` / `.dark` | `#85cde3` / `#2d8eac` | **`nord8`** / **`nord10`** | idem |
| `--oxygen-gradient-primary` | `#3688FF → #1d5eb4` | **`nord9 → nord10`** ⚑ (au plus proche pour la fin : `nord3`, gris) | idem |
| `error.main` | `#ef4444` | **`nord11`** · texte : `nord11-strong` | **`nord11`** · texte : `nord11-soft` |
| `error.dark` (bouton destructif) | `#c62828` | **`nord11-strong`** + texte `nord6` | **`nord11-strong`** + texte `nord6` |
| `warning.main` | `#f59e0b` | **`nord13`** | **`nord13`** |
| `warning.dark` | `#e65100` | **`nord12`** ⚑ (au plus proche : `nord11`, rouge = erreur) | **`nord12`** |
| `success.main` | `#10b981` | **`nord14`** | **`nord14`** |
| `success.dark` | `#1b5e20` | **`nord14`** ⚑ (au plus proche : `nord2`, gris) | **`nord14`** |
| `info.main` | `#8bf9fa` | **`nord8`** ⚑ (au plus proche : `nord4`, neutre) | **`nord8`** |
| `info.dark` | `#01579b` | **`nord10`** ⚑ (au plus proche : `nord3`) | **`nord10`** |
| `*.contrastText` de `warning` / `success` / `info` | blanc ou `#0a1628` | **`nord0`** | **`nord0`** |
| `Alert` standard (fond teinté) | rgb pastel | couleur d'état @15 % sur `nord6` + texte `nord0` | couleur d'état @15 % sur `nord0` + texte `nord6` |
| `Tooltip` / `Snackbar` | gris foncé / clair | **`nord1`** + texte `nord6` | **`nord4`** + texte `nord0` |

### Coloration syntaxique (blocs de code)

Remplace `syntax-light-*` et `syntax-dark-*` par la convention officielle de Nord, qui est pensée pour un fond sombre. **Les blocs de code restent sombres dans les deux thèmes** : fond `nord0`, ou `nord1` si la page est déjà en `nord0`. Sur fond clair, les couleurs Frost et Aurora passent sous 3:1.

| Élément | Couleur | Contraste sur `nord0` |
|---|---|---|
| Texte, ponctuation | `nord6` | 10.8 |
| Commentaire | `nord4` @70 % (la doc Nord indique `nord3`, mais 1.7:1 est illisible) | ≈ 6.1 |
| Mot-clé, opérateur, tag | `nord9` | 4.6 |
| Fonction | `nord8` | 6.2 |
| Classe, type | `nord7` | 6.0 |
| Chaîne | `nord14` | 6.1 |
| Nombre | `nord15` | 4.4 ⚠️ |
| Annotation, décorateur | `nord12` | 4.4 ⚠️ |

⚠️ `nord15` et `nord12` sont juste sous 4.5:1. C'est toléré pour de la coloration syntaxique, où la couleur ne porte pas seule le sens. Si un audit AA strict l'exige, affiche-les en `nord6`.

### Exemple d'implémentation (à adapter au thème du projet)

```ts
const nord = {
  n0: '#2E3440', n1: '#3B4252', n2: '#434C5E', n3: '#4C566A',
  n4: '#D8DEE9', n5: '#E5E9F0', n6: '#ECEFF4',
  n7: '#8FBCBB', n8: '#88C0D0', n9: '#81A1C1', n10: '#5E81AC',
  n11: '#BF616A', n12: '#D08770', n13: '#EBCB8B', n14: '#A3BE8C', n15: '#B48EAD',
  n10Strong: '#476993', n11Strong: '#A64A54', n11Soft: '#F7939B',
};

const theme = extendTheme({
  cssVarPrefix: 'oxygen',
  colorSchemes: {
    light: { palette: {
      primary:   { main: nord.n10Strong, light: nord.n9, dark: nord.n10Strong, contrastText: nord.n6 },
      secondary: { main: nord.n9, light: nord.n8, dark: nord.n10, contrastText: nord.n0 },
      error:     { main: nord.n11Strong, light: nord.n11, dark: nord.n11Strong, contrastText: nord.n6 },
      warning:   { main: nord.n13, dark: nord.n12, contrastText: nord.n0 },
      success:   { main: nord.n14, dark: nord.n14, contrastText: nord.n0 },
      info:      { main: nord.n8, dark: nord.n10, contrastText: nord.n0 },
      background: { default: nord.n6, paper: nord.n5 },
      text: { primary: nord.n0, secondary: nord.n3 },
      divider: nord.n4,
      action: { hover: nord.n5, selected: nord.n4 },
    }},
    dark: { palette: {
      primary:   { main: nord.n8, light: nord.n9, dark: nord.n10, contrastText: nord.n0 },
      secondary: { main: nord.n9, light: nord.n8, dark: nord.n10, contrastText: nord.n0 },
      error:     { main: nord.n11Soft, light: nord.n11Soft, dark: nord.n11Strong, contrastText: nord.n0 },
      warning:   { main: nord.n13, dark: nord.n12, contrastText: nord.n0 },
      success:   { main: nord.n14, dark: nord.n14, contrastText: nord.n0 },
      info:      { main: nord.n8, dark: nord.n10, contrastText: nord.n0 },
      background: { default: nord.n0, paper: nord.n1 },
      text: { primary: nord.n6, secondary: nord.n4 },
      divider: nord.n2,
      action: { hover: nord.n1, selected: nord.n2 },
    }},
  },
});
```

> En light, `primary.main` est `nord10-strong` pour que les boutons et les liens passent AA. N'utilise `nord10` pur que pour des éléments non textuels (icône, bordure de focus, indicateur, illustration).

## 3. Typographie et espacement (inchangés, Oxygen UI)

Typographie (Inter Variable) : `h1` 28px · `h2` 24px · `h3` 22px · `h4` 20px · `h5` 16px · `h6` 14px/500 · `subtitle1` 18px · `body1` 14px · `body2` 13px · `caption` 11px · `button` 14px/500. Code : Fira Code. Rayon `shape.borderRadius` 8px. Bordure 1px solid. Espacement `theme.spacing(n)` = n × 8px (base MUI).

### Espacement

Principe : **l'espacement est le premier outil de regroupement** (proximité, Gestalt). Un écran bien espacé n'a presque pas besoin de cadres.

| Usage | Valeur `theme.spacing` |
|---|---|
| Icône ↔ libellé, éléments d'un même chip/bouton | `0.5`–`1` (4–8px) |
| Champs d'un même groupe, items d'une liste | `1`–`2` (8–16px) |
| Padding interne d'une carte / d'un panneau | `2`–`3` (16–24px) |
| Entre deux blocs d'une même section | `3`–`4` (24–32px) |
| Entre deux sections de page | `6`–`10` (48–80px) |

- **L'espace interne d'un groupe doit être au moins 2 fois plus petit que l'espace qui le sépare des autres groupes.** Sinon le regroupement est illisible.
- Un titre est **plus proche du contenu qu'il introduit** que du bloc précédent (ex. `mt: 6, mb: 2`).
- Utilise `Stack` (`spacing`) ou `Grid` (`spacing`/`gap`) plutôt que des marges sur chaque enfant.
- Uniquement des valeurs de l'échelle ; pas de `13px`, `margin: 7`.
- Largeur de lecture : texte courant ≤ ~70 caractères (`maxWidth`).

### Hiérarchie typographique

- **Un seul `h1` par page.** Ne saute pas de niveau ; découple niveau sémantique (`component`) et style (`variant`).
- Pour faire ressortir **sans** cadre : graisse (500/600) ou taille ; pour faire reculer : `color="text.secondary"` (`nord3` light / `nord4` dark).
- `caption` et `overline` : métadonnées uniquement (date, catégorie, aide).
- Pas plus de **3 tailles de texte** dans un même bloc.
- Couleur d'accent sur du texte : réservée aux **liens et éléments interactifs**.

## 4. Cadres et surfaces (Card, Paper, Box encadrée)

Principe : **un cadre isole une unité, il ne décore pas.**

**Niveaux de surface Nord** (maximum 3) :

| Niveau | Light (Snow Storm, « bright to dark ») | Dark (Polar Night) |
|---|---|---|
| 0 — page | `nord6` | `nord0` |
| 1 — carte, panneau, champ de formulaire | `nord5` | `nord1` |
| 2 — menu, dialog, popover, notification, sélection | `nord4` | `nord2` |

Les écarts entre niveaux sont faibles (light `nord5`/`nord6` 1.06:1, dark `nord1`/`nord0` 1.24:1). **Une surface de niveau 1 posée sur la page a donc presque toujours besoin d'une bordure `divider`.**

**Encadrer QUAND :**
- le contenu est une **unité autonome et répétée** (carte produit, offre, intégration, membre d'équipe) → `Card`
- le contenu est **actionnable comme un tout** → `Card` + `CardActionArea`
- il faut **séparer un contenu secondaire** du flux principal (panneau latéral, résumé, configuration) → `Paper` / `Box` niveau 1
- un **formulaire ou un réglage** doit être lu comme un bloc distinct dans une page dense

**NE PAS encadrer QUAND :**
- l'espacement suffit (cas le plus fréquent)
- il n'y a **qu'un seul** élément de ce type sur la page
- c'est du texte courant (intro, paragraphe, titre)
- cela créerait un **cadre dans un cadre** → **1 niveau** d'imbrication maximum ; à l'intérieur, `Divider` ou espacement
- c'est pour « remplir » une zone vide

**Comment encadrer :** `Card variant="outlined"` (ou `Box` avec `bgcolor: 'background.paper'`, `border: 1px solid`, `borderColor: 'divider'`, `borderRadius: 1`, padding `2`–`3`). Jamais d'`elevation`.

**Surfaces translucides (acrylic + blur)** : seulement pour un élément **posé au-dessus de contenu qui défile** (navbar fixe, menu, dialog, drawer).

## 5. Mise en valeur (callout, alert, bannière, chip)

Principe : **plus on met en valeur, moins chaque mise en valeur compte** (banner blindness).

| Besoin | Composant | Couleur Nord | Règle |
|---|---|---|---|
| Retour du système suite à une action | `Alert` `severity` (standard) | `nord11` / `nord13` / `nord14` / `nord8` | Sévérité = sens réel. Pas de marketing. |
| Message éphémère | `Snackbar` | `nord1` (light) / `nord4` (dark) | Jamais d'info indispensable. |
| Info globale page/app | Bannière (`Alert` pleine largeur) | selon sévérité | 1 maximum, dismissible si non bloquante. |
| Note, astuce, mise en garde dans un contenu | Callout : `Box` niveau 1 + bordure gauche 3–4px couleur d'état, ou `Alert variant="outlined"` | `nord8` (note), `nord13` (attention), `nord11` (danger) | 1 visible à l'écran, 3 par page. |
| Statut, catégorie | `Chip size="small"` | neutre (`nord4` / `nord2`) sauf statut réel | Jamais comme bouton principal. |
| Mise en avant secondaire (« à côté » de l'accent) | Icône, chip, badge | `nord7` | Rôle Nord : faire ressortir à côté de `nord8`. |
| Action avancée ou dangereuse (non destructive) | Bouton `outlined`, icône | `nord12` | Rare. Si destructive → `error`. |
| Fonction inhabituelle, bêta, expérimentale | Chip | `nord15` | Rare. |
| Chiffre clé, KPI | `h3`/`h2` + `caption` | texte | Pas de couleur d'état si la valeur n'est pas bonne/mauvaise. |
| Appel à l'action principal | `Button variant="contained" color="primary"` | light `nord10-strong` + `nord6` · dark `nord8` + `nord0` | **1 seul par vue**. |
| Moment de marque (hero, CTA final) | `--oxygen-gradient-primary` | `nord9 → nord10` | **1 par page**, décoratif uniquement : **jamais de texte posé dessus**. |

**NE PAS mettre en valeur QUAND :**
- l'information est déjà la plus importante par sa position/taille
- on veut juste « aérer » une page longue → espacement et titres
- le message n'appelle aucune action ni attention
- un callout est déjà visible à l'écran

**Ne jamais détourner une couleur Aurora pour décorer** (ex. chip `nord14` « Nouveau »).

## 6. Contraste et accessibilité (WCAG 2.2 AA)

Seuils : **4.5:1** pour le texte courant ; **3:1** pour le grand texte (≥ 24px, ou ≥ 18.66px en gras) et pour les composants d'interface (bordures de champ, icônes porteuses de sens, focus). Un libellé de bouton en 14px/500 est du **texte courant** : il faut 4.5:1.

Ratios mesurés sur la palette Nord :

| Combinaison | Ratio | Verdict |
|---|---|---|
| `nord0` sur `nord6` (texte light) | 10.8 | ✅ |
| `nord3` sur `nord6` (texte secondaire light) | 6.4 | ✅ |
| `nord6` sur `nord0` (texte dark) | 10.8 | ✅ |
| `nord4` sur `nord0` (texte secondaire dark) | 9.3 | ✅ |
| `nord4` sur `nord1` (texte secondaire sur carte dark) | 7.5 | ✅ |
| `nord10-strong` sur `nord6` / `nord5` · `nord6` sur `nord10-strong` | 4.9 / 4.6 · 4.9 | ✅ liens et bouton principal light (jamais sur `nord4`, 4.2) |
| `nord10` sur `nord6` | 3.5 | ⚠️ icônes, bordures, grand texte uniquement |
| `nord8` sur `nord6` | 1.7 | ❌ jamais comme texte ou icône seule en light |
| `nord9` sur `nord6` | 2.3 | ❌ idem |
| `nord8` sur `nord0` / `nord0` sur `nord8` | 6.2 | ✅ accent et bouton principal dark |
| `nord9` sur `nord0` | 4.6 | ✅ |
| `nord10` sur `nord0` | 3.1 | ⚠️ pas de texte en dark |
| `nord11` sur `nord6` | 3.6 | ⚠️ icône uniquement → texte : `nord11-strong` (4.9) |
| `nord11` sur `nord0` | 3.1 | ⚠️ icône uniquement → texte : `nord11-soft` (5.7) |
| `nord13` / `nord14` sur `nord6` | 1.4 / 1.8 | ❌ jamais comme texte, icône seule ou bordure en light |
| `nord0` sur `nord13` / `nord14` / `nord12` | 8.0 / 6.1 / 4.4 | ✅ / ✅ / ⚠️ (grand texte) |
| `nord13` / `nord14` / `nord7` sur `nord0` | 8.0 / 6.1 / 6.0 | ✅ |
| `nord15` sur `nord0` | 4.4 | ⚠️ grand texte uniquement |
| `nord3` sur `nord0` | 1.7 | ❌ jamais comme texte en dark (bordure décorative OK) |
| `nord4` sur `nord6`, `nord2` sur `nord0` (dividers) | 1.2 / 1.5 | décoratif uniquement ; **bordure de champ** : `nord3` en light (6.4), `nord9` en dark (4.6) |

Règles :
- En **light**, les couleurs pastel (Frost clair, Aurora) **ne portent jamais de texte** : elles servent de **fond** (avec texte `nord0`), d'icône accompagnée d'un libellé, ou de liseré décoratif.
- **Jamais la couleur seule** pour porter un sens : ajoute une icône ou un libellé.
- Texte sur surface translucide ou sur image : vérifie le contraste sur le **pire** fond possible.
- Focus clavier toujours visible : anneau `nord10` (light) / `nord8` (dark), 2px.
- `text.disabled` : seulement pour un état réellement désactivé.

## 7. Thème clair / sombre

**Thème de l'application :**
- Supporte **les deux** thèmes (`CssVarsProvider` / `data-color-scheme`). Par défaut, suis `prefers-color-scheme` et laisse l'utilisateur basculer.
- Light = style Nord « bright to dark » (base `nord6`, surfaces `nord5` puis `nord4`). N'utilise pas le style « semi-light » (base `nord4`) sauf demande explicite.
- Dark = base `nord0`, surfaces `nord1` puis `nord2`. Pas de noir pur.
- Tout passe par les rôles de palette (§2). Si tu écris `theme.palette.mode === 'dark' ? … : …`, c'est probablement qu'un rôle manque dans le thème.
- **L'accent change de token entre les modes** (`nord10-strong` en light, `nord8` en dark). C'est voulu et géré par le thème : ne le recode pas dans les composants.
- Images et illustrations : prévoir une variante ou un fond neutre ; logos via composant thémé.

**Section inversée (bande `nord0` dans une page claire, ou l'inverse)** : c'est une mise en valeur forte.
- **Utiliser QUAND** : hero d'accueil, CTA final, footer, ou rupture de rythme dans une page marketing longue.
- **NE PAS utiliser** : dans une interface applicative (console, formulaires, tableaux de bord), pour un paragraphe isolé, ou plus de **2 fois** par page.
- Force le schéma sur le conteneur (`data-color-scheme="dark"` ou `ThemeProvider` imbriqué) pour que les enfants héritent des tokens dark (accent `nord8`, texte `nord6`). Ne recolore pas à la main.

## 8. Limites chiffrées

- 1 `h1` par page
- 1 bouton `contained primary` par vue
- 1 dégradé de marque par page, sans texte dessus
- 1 callout visible à l'écran, 3 par page
- 1 bannière globale à la fois
- 1 niveau d'imbrication de cadres
- 3 niveaux de surface maximum
- 3 tailles de texte par bloc
- 2 sections inversées par page
- 16 couleurs Nord + 3 nuances dérivées, rien d'autre
- 0 ombre portée, 0 couleur en dur

## 9. Exemples

✅ Grille de 3 offres : cartes outlined sur `background.paper`, un seul CTA contained.

```tsx
<Grid container spacing={3}>
  {plans.map((p) => (
    <Grid key={p.id} size={{ xs: 12, md: 4 }}>
      <Card variant="outlined" sx={{ p: 3, height: '100%' }}>
        <Typography variant="h4" component="h3">{p.name}</Typography>
        <Typography color="text.secondary" sx={{ mt: 1, mb: 3 }}>{p.pitch}</Typography>
        <Button fullWidth variant={p.recommended ? 'contained' : 'outlined'}>Choisir</Button>
      </Card>
    </Grid>
  ))}
</Grid>
```

❌ Paragraphe d'intro dans une carte avec ombre et texte Frost en dur.

```tsx
<Card elevation={4}>                                     {/* ombre interdite, cadre inutile */}
  <Typography sx={{ color: '#88C0D0' }}>Bienvenue…</Typography>   {/* nord8 sur nord6 = 1.7:1, en dur */}
</Card>
```
→ Corrigé : `<Typography variant="subtitle1" color="text.secondary" sx={{ maxWidth: 640, mb: 6 }}>Bienvenue…</Typography>`

✅ Mise en garde dans une doc :
```tsx
<Alert severity="warning" variant="outlined">Cette action révoque tous les jetons actifs.</Alert>
```
(icône `nord13` + texte `nord0` en light : le sens n'est pas porté par la couleur seule.)

❌ Chip `color="success"` (`nord14`) pour « Nouveau » → détournement d'Aurora : chip neutre, ou `nord7` pour une mise en avant secondaire.

❌ Bouton `contained` `nord8` avec texte `nord6` en light (1.7:1) → le thème doit fournir `nord10-strong` + `nord6` en light, `nord8` + `nord0` en dark.

## 10. Checklist avant de rendre

1. Ai-je essayé l'espacement avant d'ajouter un cadre ou une couleur ?
2. Chaque cadre isole-t-il une unité autonome, sans cadre imbriqué ?
3. Une seule action principale et une seule mise en valeur forte par vue ?
4. Chaque couleur Nord est-elle utilisée dans son rôle (Frost = accent, Aurora = état) ?
5. Aucune couleur pastel ne porte de texte en light ? Tous les contrastes respectent-ils le §6 ?
6. Que des tokens Nord / thème, aucune ombre, aucune valeur en dur ?
7. L'écran est-il correct en light **et** en dark sans code conditionnel ?
8. Les limites du §8 sont-elles respectées ?

Si une règle doit être enfreinte pour une raison métier, fais-le explicitement et signale-le dans ta réponse.
