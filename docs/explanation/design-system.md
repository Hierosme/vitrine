# Le design system de la vitrine et ses fondements

!!! abstract "Type de document"
    **Explication** au sens [Diátaxis](https://diataxis.fr/explanation/) : ce document dit *pourquoi* le design system est ainsi fait. Les règles de décision visuelle sont dans la norme [`oxygen-ui-design-guidelines`](../skills/oxygen-ui-design-guidelines/SKILL.md), qui prévaut ; leur traduction pour Zensical est dans [`site-look-and-feel`](../skills/site-look-and-feel/SKILL.md), la navigation dans [`site-navigation`](../skills/site-navigation/SKILL.md). Les valeurs exactes sont dans `site/stylesheets/extra.css` et `zensical.toml`.

## Le problème à résoudre

Une vitrine de freelance s'adresse surtout à des gens qui **ne connaissent pas encore le consultant** : un recruteur, un CTO ou un acheteur arrivé depuis LinkedIn, un moteur de recherche ou un lien partagé. La visite est courte, et la page doit faire trois choses dans l'ordre :

1. produire une **première impression** favorable, avant même que le texte soit lu ;
2. installer la **crédibilité**, c'est-à-dire la légitimité d'une personne inconnue ;
3. rendre la **proposition de valeur** et l'**action de contact** évidentes, avec un effort mental minimal.

La recherche en interaction homme-machine (IHM), en ergonomie cognitive et en marketing numérique éclaire ces trois points sous quatre angles complémentaires. Ils sont détaillés ci-dessous, chacun suivi des choix qu'il justifie.

## 1. Première impression et esthétique visuelle

### Ce que dit la recherche

**Le jugement en 50 millisecondes.** Lindgaard, Fernandes, Dudek et Brown (2006) ont montré qu'un internaute porte un jugement d'attrait visuel sur une page en environ **50 ms**. Ce jugement est stable : il est très corrélé à celui porté après une exposition plus longue. Il s'agit de l'attrait visuel, pas encore de la crédibilité ou de l'utilisabilité. Mais cette impression initiale teinte la suite de l'évaluation, par un effet de halo.

**Esthétique classique et esthétique expressive.** Lavie et Tractinsky (2004) ont construit une échelle de mesure de l'esthétique perçue des sites web, qui met en évidence deux dimensions :

- l'**esthétique classique** : ordre, propreté, clarté, symétrie. Elle est fortement liée à la facilité d'utilisation perçue ;
- l'**esthétique expressive** : originalité, créativité, effets visuels.

**« What is beautiful is usable ».** Tractinsky, Katz et Ikar (2000) ont observé que l'esthétique perçue d'une interface *avant* usage prédit fortement son utilisabilité perçue *après* usage. Cette perception n'était pas affectée par le niveau réel d'utilisabilité manipulé dans l'expérience.

### Ce que cela implique ici

- **L'esthétique classique est le socle.** La structure est sobre, les espaces sont généreux et réguliers (échelle `--vt-space-*`), l'alignement reste stable et il n'y a que deux polices. Pour un consultant, le site doit d'abord rassurer.
- **Un seul geste expressif, maîtrisé.** La bande au dégradé Frost (nord9 → nord10, `--vt-gradient-primary`) en tête du hero donne une signature sans coûter en clarté : elle est décorative et aucun texte n'y est posé. Tout autre effet (animation, parallaxe, illustration chargée) doit être justifié au regard de ce compromis.
- **Le hero est l'écran des 50 ms.** Il porte un titre, une proposition de valeur courte et au plus deux boutons. Il est conçu pour être compris d'un coup d'œil.
- **Les finitions comptent.** Un défaut visuel (contraste, alignement, mode sombre cassé) dégrade le jugement global, pas seulement l'élément en cause. C'est pourquoi tout changement est vérifié en clair, en sombre, sur desktop et sur mobile.

## 2. Crédibilité perçue et confiance

### Ce que dit la recherche

**La théorie proéminence-interprétation.** Fogg (2003) modélise l'évaluation de la crédibilité en deux temps. L'internaute **remarque** un élément (proéminence), puis lui **attribue un sens** (interprétation). Seuls les éléments remarqués pèsent dans le jugement.

**L'apparence est le premier critère cité.** Dans une étude de Fogg et al. (2003) menée avec Consumer WebWatch auprès de plus de 2 500 participants, le critère le plus cité pour juger la crédibilité d'un site est le **« design look »** : mise en page, typographie, couleurs, cohérence visuelle. Il est mentionné dans environ 46 % des commentaires, devant la structure de l'information et le focus du contenu.

**Design, confiance et fidélité.** Cyr (2008) a étudié trois composantes du design web dans plusieurs cultures (Canada, Allemagne, Chine) :

1. le **design de l'information**, c'est-à-dire l'organisation logique du contenu ;
2. le **design de navigation**, c'est-à-dire le guidage et la clarté des liens ;
3. le **design visuel** : esthétique, images, couleurs.

Ses résultats relient ces composantes à la confiance (*online trust*), à la satisfaction et à la fidélité. Le poids de chaque composante varie selon les cultures.

### Ce que cela implique ici

- **La crédibilité se joue en surface d'abord.** Une typographie soignée (Inter, Fira Code), une palette restreinte et des composants homogènes ne sont pas cosmétiques : c'est ce que l'internaute remarque, donc ce qu'il interprète.
- **Les trois composantes de Cyr sont réparties dans les skills.** Le design de l'information et le design de navigation relèvent du skill `site-navigation`, le design visuel du skill `site-look-and-feel`.
- **Les preuves doivent être visibles et vraies.** Références, certifications et logos clients passent par le composant `vt-proof`, placé là où l'œil passe. Un élément proéminent mais douteux (faux témoignage, logo non autorisé) est interprété négativement. D'où la règle : **aucune référence inventée**, une tâche dans le backlog privé plutôt qu'un faux.
- **Le contact est visible partout.** Il occupe le dernier onglet, l'icône email dans le pied de page et un bloc `vt-cta` en fin de page de contenu. Une personne joignable est plus crédible.

## 3. Ergonomie cognitive et guidage

### Ce que dit la recherche

**Les critères ergonomiques de Bastien et Scapin (INRIA, 1993).** C'est le cadre francophone de référence pour évaluer une interface. Il comporte huit critères :

| Critère | Traduction dans la vitrine |
|---|---|
| **Guidage** (incitation, groupement et distinction, feedback, lisibilité) | Hero, grilles de cartes, titres de section, contrastes conformes à l'AA |
| **Charge de travail** (brièveté, densité informationnelle) | Budgets de texte : hero court, une phrase par carte, paragraphes courts |
| **Contrôle explicite** | Liens et boutons aux libellés d'action explicites, pas d'automatisme (carrousel, pop-up) |
| **Adaptabilité** | Responsive, bascule clair/sombre qui suit le système par défaut |
| **Gestion des erreurs** | Build strict (aucun lien cassé), page 404 du thème |
| **Homogénéité / cohérence** | Tokens uniques, deux styles de bouton seulement, composants réutilisés |
| **Signifiance des codes** | Icônes toujours accompagnées d'un libellé, libellés de menu en un mot clair |
| **Compatibilité** | Conventions du web respectées : logo en haut à gauche qui renvoie à l'accueil, menu en haut |

**Lecture à l'écran et page d'accueil.** Nielsen et Loranger (2006), puis les études oculométriques du Nielsen Norman Group, décrivent une lecture **non linéaire, par balayage** (*scanning*). Il y a le motif en « F » : deux bandes horizontales puis une descente verticale le long de la marge gauche. Le contenu visible **sans défiler** (*above the fold*) reçoit l'essentiel de l'attention. Et le **respect des conventions** réduit le coût d'orientation.

L'actualisation de 2017 précise que le motif en F est surtout le symptôme d'un contenu **mal structuré**. Des intertitres, des listes et des mots-clés en début de ligne permettent de lire plus efficacement.

**Loi de Hick-Hyman.** Hick (1952) et Hyman (1953) ont montré que le temps de décision croît de façon logarithmique avec le nombre d'options équiprobables. Transposée au web, et c'est une heuristique plutôt qu'une loi stricte, elle suggère que chaque action secondaire affaiblit l'action principale.

**Charge cognitive.** Sweller (1988) distingue la charge liée à la tâche de la charge **extrinsèque** imposée par la présentation. La seconde doit être minimisée.

### Ce que cela implique ici

- **Une action principale par page.** Il y a au plus un bouton `md-button--primary` par page et au plus deux boutons dans le hero. La tâche `mise run check` contrôle la première règle.
- **Six onglets au maximum**, cinq actuellement. La tâche `check` le vérifie aussi.
- **Les pages sont écrites pour le balayage.** Un seul H1 ; un H2 toutes les deux ou trois idées ; le mot-clé en tête de titre et de puce ; des listes plutôt que des paragraphes denses ; le gras réservé aux termes clés.
- **L'essentiel est au-dessus de la ligne de flottaison.** Sur l'accueil, la proposition de valeur et le bouton de contact sont dans le hero.
- **Pas de charge extrinsèque gratuite.** Pas de carrousel, d'animation décorative, de vidéo en lecture automatique ni de pop-up.
- **Les conventions plutôt que l'originalité de structure.** La structure fournie par le thème (Zensical, variante `classic`, héritée de Material for MkDocs : en-tête, onglets, pied de page) est conservée. On personnalise par les tokens, on ne réinvente pas la mise en page.

## 4. Pourquoi un design system outillé

Les règles ci-dessus ne tiennent dans le temps que si elles sont **écrites, centralisées et vérifiées** :

- une **norme** unique (`oxygen-ui-design-guidelines`) fixe les règles de décision : quand encadrer, mettre en valeur, contraster, espacer (§ 7) ;
- les **tokens** (`--vt-*`) donnent l'homogénéité : une couleur ou un espacement n'existe qu'à un endroit, et les couleurs passent par des rôles définis pour chaque thème (§ 5) ;
- les **composants** (`vt-hero`, `vt-cta`, `vt-proof`, cartes Material) répondent aux besoins récurrents sans improvisation ;
- les **skills** traduisent ces principes en règles opérationnelles pour les humains et les agents IA ;
- la tâche **`mise run check`** automatise ce qui peut l'être : palette fermée, couleurs en dur, absence d'ombre, usage de la palette via les rôles, contrastes WCAG des deux thèmes, sections inversées, préfixes de classes, nombre de CTA principaux, budget de navigation, builds stricts.

Le choix de Zensical (successeur de Material for MkDocs, par la même équipe) relève de la même logique. Le thème apporte une base accessible, responsive et conforme aux conventions. Le design system se contente de l'**habiller**, ce qui limite la dette de maintenance.

## 5. Pourquoi la palette Nord, en deux thèmes

### Le choix de Nord

[Nord](https://www.nordtheme.com/) est une palette de 16 couleurs « arctiques » en quatre groupes : *Polar Night* (fonds sombres), *Snow Storm* (fonds clairs), *Frost* (accents froids) et *Aurora* (couleurs sémantiques). Elle est très répandue dans l'outillage des développeurs : éditeurs, terminaux, shells, outils en ligne de commande.

Ce choix découle des principes précédents :

- **Esthétique classique** : la palette est désaturée, peu contrastée entre les teintes et structurée par rôles. Elle produit naturellement l'ordre et la sobriété que recommandent Lavie & Tractinsky.
- **Homogénéité** : 16 couleurs fermées, documentées et nommées. Une contrainte forte qui protège la cohérence dans le temps (Bastien & Scapin).
- **Signal d'appartenance** (hypothèse de conception, non testée) : pour un public technique (CTO, équipes plateforme), une palette familière de leur propre environnement peut renforcer le sentiment que le consultant « parle leur langue ». C'est un pari de marque, pas un résultat de recherche.

### Deux thèmes, mêmes rôles

Le thème clair (fonds Snow Storm, texte Polar Night) et le thème sombre (fonds Polar Night, texte Snow Storm) reprennent les deux « ambiances » prévues par Nord. L'en-tête, le hero et le pied de page suivent le thème ; seul le bloc d'appel au contact est une **section inversée** (sombre dans les deux thèmes), pour que l'inversion reste un signal réservé à l'action. Le thème affiché suit par défaut la préférence du système (`prefers-color-scheme`) et le visiteur peut basculer à tout moment. C'est le critère d'**adaptabilité** de Bastien & Scapin.

Pour que les deux thèmes restent équivalents, le design system sépare trois couches : la **palette** (les valeurs), les **rôles** (fond, texte, lien, CTA…), définis une fois par thème, et les **composants**, qui ne connaissent que les rôles. Un composant ne peut donc pas être soigné dans un thème et oublié dans l'autre.

### Le compromis fidélité / accessibilité

Nord est conçu pour des éditeurs de code sur fond sombre. Plusieurs de ses couleurs, utilisées comme texte sur Snow Storm, ne passent pas le seuil WCAG AA de 4.5:1. Par exemple, `nord10` sur `nord6` donne 3.5:1, et les teintes Frost et Aurora sur fond clair sont souvent sous 2.5:1.

La priorité va à l'accessibilité, parce qu'un défaut de lisibilité dégrade directement la crédibilité (§ 1 et 2). Mais la fidélité à Nord est préservée par la méthode : la palette est **fermée**, et seules **trois variantes de même teinte** sont dérivées, uniquement pour le texte : `nord10-strong` (liens et bouton principal en clair), `nord11-strong` et `nord11-soft` (texte d'erreur en clair et en sombre). Partout ailleurs, les couleurs pastel servent de fond, de liseré ou d'icône, jamais de texte sur fond clair. Les ratios sont calculés et vérifiés automatiquement par `mise run design:contrast`, pour chaque couple texte/fond de chaque thème.

### La couleur comme repère, pas comme décor

Les éléments répétés (cartes, étapes du parcours, compétences) ont besoin d'être séparables : c'est le critère de **groupement et distinction par le format** de Bastien & Scapin, et la lecture par balayage décrite par Nielsen profite de repères stables, comme un liseré sous chaque intertitre.

Ces repères utilisent un **accent unique**, tiré de Frost (nord10 en clair, nord8 en sombre). Une version antérieure faisait tourner six accents, dont quatre couleurs Aurora : elle détournait des couleurs qui signifient un état (erreur, avertissement, succès) et exigeait une dizaine de dérivés pour atteindre 3:1 en clair. La distinction vient désormais de la forme (carte, liseré, pastille) et de l'espacement, ce qui laisse à Aurora son seul rôle sémantique. La couleur n'est jamais le seul porteur d'information ([WCAG 1.4.1](https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html)), et l'accent atteint 3:1 sur la page et sur les surfaces ([WCAG 1.4.11](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)).

## 6. Pourquoi des règles de référencement

### Le constat

Le visiteur visé arrive souvent d'un moteur de recherche ou d'un lien partagé (§ « Le problème à résoudre »). Avant même la page, il voit donc un **résultat de recherche** ou un **aperçu de partage** : un titre, une description, parfois une image. C'est la première surface remarquée, au sens de Fogg (proéminence → interprétation), et elle se règle dans le code, pas dans la mise en page.

### Ce que cela implique ici

- **Un titre par page, mot-clé en tête.** Google affiche le contenu de `<title>` comme lien du résultat et le tronque au-delà de la largeur disponible (environ 60 caractères). Un titre « Accueil - Jérôme Ornech » ne dit rien de l'offre ; « Expert DevOps & Ansible freelance » répond à la requête.
- **Une description unique par page.** La meta description sert souvent d'extrait sous le lien. Identique sur toutes les pages, elle n'aide ni le moteur ni le lecteur à les distinguer.
- **Des aperçus de partage maîtrisés.** Le protocole Open Graph fixe le titre, le texte et l'image affichés par LinkedIn, Slack ou une messagerie. Sans lui, la plateforme improvise.
- **Des données structurées vraies.** Le JSON-LD `Person` (schema.org) décrit la personne, son métier et ses profils. Il obéit à la même règle que les preuves visibles (§ 2) : uniquement des faits déjà publiés sur le site.
- **Aucun TODO visible.** Un texte provisoire affiché est un défaut de finition (§ 1) et un contenu pauvre pour les moteurs. Il reste dans le backlog privé : pas même en commentaire HTML, que le générateur recopie dans la page publiée.
- **Des URL stables.** Une URL courte et sans date (`/blog/<slug>/`) ne vieillit pas ; une URL modifiée perd les liens et l'historique acquis.
- **Polices hébergées sur le site.** Charger les polices depuis Google transmet l'adresse IP du visiteur à un tiers ; le plugin `privacy` les embarque au build. C'est aussi une requête vers un domaine externe en moins au chargement.

## 7. Pourquoi une norme de décision : Oxygen UI × Nord

### Le constat

Les sections précédentes fixent des **principes** (sobriété, crédibilité, guidage) et une **identité** (Nord). Un design system décrit d'habitude ses composants ; il dit rarement **quand** ne pas s'en servir. Sans cette règle, chaque contenu attire son cadre, sa couleur, son encadré, et la hiérarchie se dilue : c'est la *banner blindness*. Pour un agent IA qui modifie le site, c'est encore plus vrai : il applique ce qui est écrit.

### Ce que la norme apporte

La norme [`oxygen-ui-design-guidelines`](../skills/oxygen-ui-design-guidelines/SKILL.md) reprend les fondations d'[Oxygen UI](https://github.com/wso2/oxygen-ui), le design system de WSO2 bâti sur MUI, avec la palette Nord comme norme de couleur. Elle est écrite sous forme de **règles de décision** (« encadrer QUAND… / NE PAS encadrer QUAND… »), lisibles par un humain comme par un agent :

- **Un ordre de préférence** : espacement, puis typographie, puis fond, puis bordure, puis couleur, puis effet. On s'arrête au premier moyen qui suffit. C'est l'**esthétique classique** de Lavie & Tractinsky (§ 1) rendue opératoire, et la charge extrinsèque minimale de Sweller (§ 3).
- **Un design plat** : aucune ombre. La hiérarchie des surfaces passe par trois niveaux de fond (Snow Storm ou Polar Night) et une bordure, ce que Nord prévoit lui-même pour des designs « minimal and flat ».
- **Une forme et une typographie uniques** : un seul rayon (8px), l'échelle typographique d'Oxygen UI (Inter, Fira Code pour le code), un espacement sur une base de 8px. Des échelles fermées réduisent les décisions arbitraires (homogénéité de Bastien & Scapin).
- **Des limites chiffrées** : un H1, un bouton principal, un dégradé, un encadré visible à l'écran, un niveau d'imbrication de cadres, deux sections inversées par page. Elles traduisent Hick-Hyman (§ 3) et la proéminence de Fogg (§ 2) : ce qui ressort doit rester rare pour être remarqué.
- **Des contrastes mesurés** sur les couples réels de la palette, et la règle qui en découle : en clair, les couleurs pastel ne portent jamais de texte.

### Ce que cela change concrètement

Les boutons, cartes et tuiles ont tous un rayon de 8px et aucune ombre. L'en-tête, le hero et le pied de page suivent le thème. Le CTA de fin de page devient une section inversée, déclarée dans le Markdown (`data-md-color-scheme="slate"`) plutôt que recolorée à la main. Les blocs de code restent sombres dans les deux thèmes, selon la coloration officielle de Nord. `mise run check` refuse toute couleur hors des 19 autorisées et toute ombre portée.

## Limites et précautions de lecture

- Ces travaux datent pour la plupart des années 2000. Les écrans, les usages mobiles et les conventions ont changé depuis, mais les mécanismes cognitifs décrits (jugement rapide, halo, balayage, coût des choix) restent largement admis.
- Plusieurs études portent sur des populations ou des cultures spécifiques. Cyr montre justement que le poids des facteurs varie selon la culture. Les effets doivent être pris comme des **tendances**, pas comme des constantes.
- La loi de Hick décrit des choix entre options équiprobables. Sur une page web, c'est une **heuristique de conception**, pas une prédiction quantitative.
- Le « motif en F » n'est pas une cible à reproduire, mais un signal d'alerte sur la structuration du contenu.

## Sources

### Première impression et esthétique

- Lindgaard, G., Fernandes, G., Dudek, C. & Brown, J. (2006). *Attention web designers: You have 50 milliseconds to make a good first impression!* Behaviour & Information Technology, 25(2), 115–126. [doi:10.1080/01449290500330448](https://doi.org/10.1080/01449290500330448)
- Lavie, T. & Tractinsky, N. (2004). *Assessing dimensions of perceived visual aesthetics of web sites.* International Journal of Human-Computer Studies, 60(3), 269–298. [doi:10.1016/j.ijhcs.2003.09.002](https://doi.org/10.1016/j.ijhcs.2003.09.002)
- Tractinsky, N., Katz, A. S. & Ikar, D. (2000). *What is beautiful is usable.* Interacting with Computers, 13(2), 127–145. [doi:10.1016/S0953-5438(00)00031-X](https://doi.org/10.1016/S0953-5438(00)00031-X) ; [notice Oxford Academic](https://academic.oup.com/iwc/article/13/2/127/898608)

### Crédibilité et confiance

- Fogg, B. J. (2003). *Prominence-interpretation theory: Explaining how people assess credibility online.* CHI '03 Extended Abstracts. [doi:10.1145/765891.765951](https://doi.org/10.1145/765891.765951)
- Fogg, B. J., Soohoo, C., Danielson, D. R., Marable, L., Stanford, J. & Tauber, E. R. (2003). *How do users evaluate the credibility of Web sites? A study with over 2,500 participants.* DUX '03. [doi:10.1145/997078.997097](https://doi.org/10.1145/997078.997097) ; [rapport Consumer WebWatch](https://advocacy.consumerreports.org/research/how-do-people-evaluate-a-web-sites-credibility)
- [Stanford Web Credibility Research](https://credibility.stanford.edu/), page du projet et liste des publications.
- Cyr, D. (2008). *Modeling web site design across cultures: Relationships to trust, satisfaction, and e-loyalty.* Journal of Management Information Systems, 24(4), 47–72. [doi:10.2753/MIS0742-1222240402](https://doi.org/10.2753/MIS0742-1222240402) ; [notice JMIS](https://jmis-web.org/articles/247)

### Ergonomie cognitive et guidage

- Bastien, J. M. C. & Scapin, D. L. (1993). *Ergonomic criteria for the evaluation of human-computer interfaces.* Rapport technique INRIA RT-0156. [HAL inria-00070012](https://inria.hal.science/inria-00070012)
- Nielsen, J. & Loranger, H. (2006). *Prioritizing Web Usability.* New Riders. [Présentation NN/g](https://www.nngroup.com/books/prioritizing-web-usability/)
- Nielsen, J. (2006). *F-Shaped Pattern For Reading Web Content.* [nngroup.com](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content-discovered/)
- Pernice, K. (2017). *F-Shaped Pattern of Reading on the Web: Misunderstood, But Still Relevant.* [nngroup.com](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/)
- Nielsen Norman Group. *Scrolling and Attention.* [nngroup.com](https://www.nngroup.com/articles/scrolling-and-attention/)
- Hick, W. E. (1952). *On the rate of gain of information.* Quarterly Journal of Experimental Psychology, 4(1), 11–26. [doi:10.1080/17470215208416600](https://doi.org/10.1080/17470215208416600)
- Hyman, R. (1953). *Stimulus information as a determinant of reaction time.* Journal of Experimental Psychology, 45(3), 188–196. [doi:10.1037/h0056940](https://doi.org/10.1037/h0056940)
- Sweller, J. (1988). *Cognitive load during problem solving: Effects on learning.* Cognitive Science, 12(2), 257–285. [doi:10.1207/s15516709cog1202_4](https://doi.org/10.1207/s15516709cog1202_4)

### Référentiels techniques

- Arctic Ice Studio. *Nord, Colors and Palettes.* [nordtheme.com](https://www.nordtheme.com/docs/colors-and-palettes) ; [dépôt GitHub nordtheme/nord](https://github.com/nordtheme/nord)
- W3C. *WCAG 2.2, Understanding SC 1.4.11 Non-text Contrast.* [w3.org](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)
- W3C. *WCAG 2.2, Understanding SC 1.4.1 Use of Color.* [w3.org](https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html)
- W3C. *WCAG 2.2, Understanding SC 1.4.3 Contrast (Minimum).* [w3.org](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)
- WSO2. *Oxygen UI* (design system, basé sur MUI). [github.com/wso2/oxygen-ui](https://github.com/wso2/oxygen-ui)
- MUI. *Material UI* : [Palette](https://mui.com/material-ui/customization/palette/), [Spacing](https://mui.com/material-ui/customization/spacing/), [Breakpoints](https://mui.com/material-ui/customization/breakpoints/), [Card](https://mui.com/material-ui/react-card/), [Alert](https://mui.com/material-ui/react-alert/), [Button](https://mui.com/material-ui/react-button/)
- Google Search Central. *Influencing your title links in search results.* [developers.google.com](https://developers.google.com/search/docs/appearance/title-link)
- Google Search Central. *Control your snippets in search results.* [developers.google.com](https://developers.google.com/search/docs/appearance/snippet)
- Google Search Central. *Introduction to structured data markup.* [developers.google.com](https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data)
- *The Open Graph protocol.* [ogp.me](https://ogp.me/) ; schema.org. *Person.* [schema.org/Person](https://schema.org/Person)
- Zensical. *Documentation* (configuration, plugins, personnalisation). [zensical.org](https://zensical.org/docs/) ; [dépôt GitHub zensical/zensical](https://github.com/zensical/zensical)
- Material for MkDocs. *Built-in privacy plugin* (repris par Zensical). [squidfunk.github.io](https://squidfunk.github.io/mkdocs-material/plugins/privacy/)
- Material for MkDocs. *Customization.* [squidfunk.github.io](https://squidfunk.github.io/mkdocs-material/customization/)
- Procida, D. *Diátaxis, Explanation.* [diataxis.fr](https://diataxis.fr/explanation/)

## Pour approfondir

L'essentiel de la littérature est en anglais. Requêtes utiles sur [Google Scholar](https://scholar.google.com/), [ACM Digital Library](https://dl.acm.org/), [IEEE Xplore](https://ieeexplore.ieee.org/), [ScienceDirect](https://www.sciencedirect.com/) et [Cairn](https://www.cairn.info/) :

```text
"website credibility" AND "visual design" AND ("first impressions" OR "aesthetics")
"classical aesthetics" AND "expressive aesthetics" AND "website"
"landing page design" AND ("cognitive load" OR "conversion")
"homepage usability" AND "information architecture"
"surface credibility" AND "web design"
```
