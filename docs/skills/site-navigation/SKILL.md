---
name: site-navigation
description: Maintenir la navigation, l'architecture de l'information et la structure des pages de la vitrine Zensical (onglets, pages, URLs, titres, blog, catégories). À utiliser pour toute création, suppression, renommage ou déplacement de page, tout changement de menu, toute rédaction ou restructuration de contenu de page, et tout ajout d'article de blog.
---

# Navigation et architecture de l'information

> **Pourquoi ces règles ?** Voir [l'explication du design system](../../explanation/design-system.md), en particulier Cyr 2008 (design de l'information et de navigation), Nielsen & Loranger 2006 (balayage, conventions) et Hick 1952 (nombre de choix).

## Sources de vérité

| Élément | Fichier |
|---|---|
| Menu principal (onglets) | `zensical.toml` → clé `nav` |
| Comportement de navigation | `zensical.toml` → `theme.features` |
| Catégories de blog autorisées | `zensical.toml` → `plugins.blog.categories_allowed` |
| Auteurs du blog | affichage désactivé (`authors = false` dans `plugins.blog`) ; `site/blog/.authors.yml` garde le nom pour mémoire, **sans avatar** |
| Articles | `site/blog/posts/AAAA-MM-JJ-slug.md` (URL publiée : `/blog/<slug>/`) |
| Titre `<title>` et meta description | front-matter `title` / `description` de chaque page |
| Open Graph, JSON-LD, apple-touch-icon | `overrides/main.html` ; données de la personne : `zensical.toml` → `extra.seo` |
| `robots.txt` | généré par la tâche `site:build` à partir de `site_url` (Zensical vide `build/` à chaque build) |

## Structure actuelle

Accueil · Services · Parcours · Blog · Contact.

Hors menu (`not_in_nav` dans `zensical.toml`) : **Mentions légales** (`site/mentions-legales.md`), accessible depuis le lien du pied de page (`copyright`).

L'ordre suit le parcours d'un visiteur qui ne connaît pas encore le consultant : **découvrir → évaluer l'offre → vérifier la crédibilité → lire → contacter**. Contact reste toujours le dernier onglet.

## Principes

| # | Principe | Fondement | Conséquence concrète |
|---|---|---|---|
| N1 | **Peu de choix au premier niveau** | Hick 1952 ; Hyman 1953 | **6 onglets maximum**, vérifié par `mise run check`. Au-delà, regrouper. |
| N2 | **Respecter les conventions du web** | Nielsen & Loranger 2006 ; Bastien & Scapin (compatibilité) | Logo en haut à gauche qui renvoie à l'accueil, menu en haut, contact en dernier. La structure Material n'est pas modifiée. |
| N3 | **Libellés signifiants** | Bastien & Scapin (signifiance des codes) | Un mot clair et concret, sans jargon ni néologisme marketing. |
| N4 | **Écrire pour le balayage** | NN/g, F-pattern 2006 / 2017 | Structure de page ci-dessous. |
| N5 | **L'essentiel sans défiler** | NN/g, *Scrolling and Attention* | Sur l'accueil, la proposition de valeur et le CTA sont dans le hero. Sur les autres pages, le H1 et la première phrase disent de quoi parle la page. |
| N6 | **Toujours un chemin vers le contact** | Cyr 2008 (confiance → action) | Chaque page de contenu, **accueil compris**, se termine par un `vt-cta` (sauf Contact et Mentions légales, exclues dans `check`). Sur l'accueil, son bouton est secondaire (`.md-button`) : le bouton principal est déjà dans le hero. |
| N8 | **Du détail derrière chaque promesse** | Fogg 2003 (proéminence → interprétation) ; Cyr 2008 | Une carte attire l'œil, la section la justifie : au moins 500 caractères par service, rédigés comme une **mission type**. Les preuves (employeurs, clients, années) vivent dans Parcours, jamais dans Services. |
| N7 | **Pas de navigation redondante** | Sweller 1988 (charge extrinsèque) ; Nielsen (balayage) | Pas de menu latéral qui répète les onglets : la largeur va au contenu. |

## Règles de navigation

1. **Toute page de `site/` figure dans `nav`**, sauf les articles de blog, gérés par le plugin, et les pages déclarées dans `not_in_nav` (`zensical.toml`). `mise run check` le vérifie pour les pages de premier niveau ; le build `--strict` vérifie les liens internes.
2. Au-delà de 6 onglets, regrouper en section avec une page `index.md` (feature `navigation.indexes`).
3. Libellés de menu : **un mot, en français, majuscule initiale**, sans emoji.
4. Noms de fichiers : `kebab-case`, sans accent, extension `.md`. L'URL en découle : renommer casse des liens externes, donc à éviter après la mise en ligne.
5. Liens internes **relatifs vers le `.md`** (`[Contact](contact.md)`), jamais vers l'URL publiée. Texte de lien explicite : jamais « cliquez ici ».
6. **Pas de menu latéral sur les pages de premier niveau.** Les onglets suffisent, et le menu de gauche ne montrerait que la page courante. Toute page `site/*.md` porte `hide: [navigation]` dans son front-matter (vérifié par `check`, règle N7).
7. **Table des matières (à droite)** : on la garde seulement si la page a au moins 3 sections H2 utiles et aucun autre sommaire. Sinon on ajoute `toc` à `hide` (Accueil, Services, dont la liste des expertises sert de sommaire, Parcours, Contact). Sur Parcours, la table répétait chaque poste de la frise et prenait de la largeur à la frise.
9. **Pas de liens « Précédent / Suivant »** en bas de page (`navigation.footer` désactivé) : c'est une convention de documentation, pas de vitrine, et le plugin blog y glissait ses pages d'archives.
8. Le blog garde sa colonne de gauche, qui y sert : archives, catégories, métadonnées de l'article.

## Structure d'une page (écrire pour le balayage)

- **Un seul H1** par page, qui reprend le libellé du menu ou le précise.
- **Première phrase** : ce que le visiteur trouvera ou obtiendra. Pas d'introduction générique.
- **Un H2 toutes les 2 ou 3 idées.** Le mot-clé en tête de titre (« Ansible : … » plutôt que « Mon approche d'Ansible »).
- **Listes à puces** plutôt que des paragraphes denses. Une idée par puce, le mot porteur au début.
- Listes courtes de faits clés (compétences, modalités) : composant `vt-tiles`. Suites chronologiques : composant `vt-timeline`.
- **Paragraphes de 4 lignes maximum.** Le gras est réservé à 1 ou 2 termes clés par section.
- Fin de page : un bloc `vt-cta` vers Contact.

## Structure de la page Services

La page est construite sur le composant **Expertises** (voir le skill `site-look-and-feel`) : une liste numérotée à gauche, le détail de l'expertise choisie à droite, en CSS seul. Sous 900px, la liste disparaît et les panneaux s'empilent.

1. H1 seul, sans paragraphe d'introduction : la liste des expertises suit directement.
2. **Liste des expertises** (`<nav class="vt-exp-list">`) : une entrée `<a class="vt-exp-item" href="#ancre">` par service (numéro, pictogramme, titre, **cartouche d'une ligne**, 45 caractères au plus, formulé en gain client : « Des livraisons fréquentes et sans stress »), **sans intitulé de famille**. **8 services exactement** : le marquage de l'entrée sélectionnée est écrit pour 8 rangs dans `extra.css`. Pour en ajouter un, en fusionner deux autres sous une nouvelle étiquette.
3. **Un panneau par service** (`<section class="vt-exp-panel">`), dans l'ordre de la liste : pictogramme, `## Titre { #ancre }`. L'identifiant explicite est obligatoire : il désigne la section comme un service et sert de cible (`:target`) à la liste. Le panneau contient **au moins 500 caractères** de texte visible (règle N8, `mise run content:services`) :
    - la phrase de gain, du point de vue du client, avec `{ .vt-exp-lead }` ;
    - un paragraphe de contexte (2 ou 3 phrases) rédigé comme une **mission type** : la situation du client (« Vos déploiements reposent sur… »), puis ce que fait la mission (« La mission automatise… »). **Aucune référence aux expériences** : ni employeur, ni client, ni année, ni « j'ai ». `content:services` le vérifie à partir des noms présents dans `site/parcours.md` ;
    - « Exemples de périmètre de mission » avec `{ .vt-exp-label }`, puis **6 puces** « **Action** + détail » dans `<div class="vt-exp-checks" markdown>` ;
    - un lien d'action vers Contact, propre au service : `[Discuter de … :material-arrow-right:](contact.md){ .vt-next }`. C'est un lien, pas un bouton : le seul bouton principal reste celui du `vt-cta`.
4. `## Modalités` (tuiles `vt-tiles`, sans identifiant explicite) puis `vt-cta`.

La liste tient lieu de sommaire : la table des matières de droite est masquée (`toc` dans `hide`).

L'accueil reprend le même composant sous « Domaines d'intervention », en version courte : panneaux en `### Titre { #exp-<ancre> }`, puis **deux paragraphes** : le résultat final pour le client, en gras (`{ .vt-exp-lead }`, la même phrase que sur Services), et sous l'intitulé « C'est le bon moment si… » (`{ .vt-exp-label }`) les situations qui doivent faire penser au service ; enfin `[Détail du service :material-arrow-right:](services.md#<ancre>){ .vt-next }`. Ajouter, retirer ou renommer un service se fait donc **sur les deux pages**, dans le même ordre (ordre du cycle de vie logiciel : exigences → code → livraison → exploitation → transmission).

## Ajouter un article de blog

Utiliser `mise run blog:new "Titre" -c Catégorie`, qui crée le fichier, le slug et un brouillon, puis éditer. Format produit :

```markdown
---
date: AAAA-MM-JJ
authors: [jerome]
categories: [Ansible]      # uniquement des valeurs de categories_allowed
slug: titre-court
description: "Résumé pour les moteurs de recherche (70 à 160 caractères)."
draft: true
---

# Titre de l'article

Accroche (affichée dans la liste du blog) : 1 à 2 phrases, le bénéfice pour le lecteur.

<!-- more -->

Corps…
```

- `description` : 70 à 160 caractères, unique, exigée pour publier (vérifié par `check`).
- Ne **jamais** ajouter un article à `nav`.
- Nouvelle catégorie : l'ajouter d'abord à `categories_allowed`. La liste reste courte, 8 catégories maximum, pour la même raison que N1.
- Pour publier, retirer `draft: true`. `mise run blog:list` donne l'état des articles.

## Référencement (SEO)

> **Pourquoi ?** Voir l'[explication du design system](../../explanation/design-system.md), § 6.

| # | Règle | Vérification |
|---|---|---|
| S1 | Chaque page porte en front-matter un **`title`** (balise `<title>`, suivie de « - Jérôme Ornech ») : **mot-clé en tête**, 60 caractères maximum suffixe compris. Le libellé du menu reste celui de `nav`. | `mise run content:seo` |
| S2 | Chaque page et chaque article publié porte une **`description`** de 70 à 160 caractères, **unique** : ce que le visiteur trouvera, avec les mots-clés de la page. | `mise run content:seo` |
| S3 | Le H1 reste court et lisible (budget du hero) ; il peut différer du `title`. | relecture |
| S4 | Les aperçus de partage (Open Graph, Twitter Card) et le JSON-LD `Person` (accueil) sont **générés** par `overrides/main.html` : on ne les écrit jamais à la main dans une page. Les faits du JSON-LD viennent de `extra.seo` et de `extra.social` : uniquement des informations déjà publiées sur le site. | build |
| S5 | **Aucun TODO dans les sources publiées**, même en commentaire HTML (recopié dans le HTML) : un manque d'information se note uniquement dans `private/backlog.md`. | `mise run content:todo-visible` |
| S6 | URL d'article `/blog/<slug>/` (`post_url_format: "{slug}"`) : courte, sans date, pérenne. Ne plus changer le slug d'un article publié. | relecture |
| S7 | Le domaine n'est écrit qu'à un endroit : `site_url`. Canonical, sitemap, `robots.txt`, Open Graph et JSON-LD en découlent. | build |

## Checklist avant de terminer

- [ ] `mise run check` passe : builds stricts, budget d'onglets, pages de premier niveau dans `nav`, un seul CTA principal par page, pas de menu latéral (N7), services d'au moins 500 caractères et formulés en missions types (N8), aucun TODO visible (S5), `title` et `description` conformes (S1, S2).
- [ ] Le menu est lisible sur desktop et sur mobile (`mise run site:serve`, fenêtre sous 76em).
- [ ] Chaque page modifiée respecte la structure : H1 unique, première phrase utile, H2 réguliers, `vt-cta` final.
- [ ] Aucun lien interne cassé, aucune page orpheline.
- [ ] Si la structure change, mettre à jour la section « Structure actuelle » de ce skill.
