# Backlog — vitrine

Tâches restantes après l'audit du 2026-11-02. Chacune contient ce qu'il faut à un agent IA pour la traiter seul : contexte, **questions à poser à l'opérateur avant de modifier quoi que ce soit**, prompt, fichiers, critères d'acceptation et journal.

## Mode d'emploi (agent)

1. Lis `AGENTS.md`, puis les skills concernés (`docs/skills/*/SKILL.md`), **avant** de traiter une tâche.
2. Choisis une tâche `à faire` dont les dépendances sont `fait`, par priorité (P1 → P3).
3. Si la tâche a une section **Questions à l'opérateur** : pose-les toutes en une fois, **attends les réponses**, passe le statut à `en attente opérateur` en attendant. Ne devine jamais une réponse : une information inventée (client, chiffre, date, statut juridique) détruit la crédibilité, qui est l'objectif du site. Une réponse manquante devient un `<!-- TODO: … -->` (jamais un TODO visible) et la tâche reste ouverte.
4. Exécute le prompt, puis `mise run check` : il **doit** passer.
5. Mets à jour la tâche : statut, cases cochées, une ligne de journal datée (`AAAA-MM-JJ — ce qui a été fait — réponses reçues`). Mets aussi à jour le tableau de synthèse.
6. Commit en français, à l'impératif, qui cite l'identifiant (`Ajoute les mentions légales (B-03)`).

Statuts : `à faire` · `en attente opérateur` · `en cours` · `fait` · `abandonné` (avec la raison dans le journal).
Priorités : **P1** bloque la mise en ligne · **P2** crédibilité et conversion · **P3** confort, référencement de fond.

## Synthèse

| ID | Tâche | Prio | Questions | Dépend de | Statut |
|---|---|---|---|---|---|
| B-01 | Disponibilité dans les modalités | P1 | oui | — | à faire |
| B-02 | Domaine et adresse email réels | P1 | oui | — | à faire |
| B-03 | Page « Mentions légales » | P1 | oui | B-02 | à faire |
| B-04 | Dépôt git et publication GitHub Pages | P1 | oui | B-02 | à faire |
| B-05 | Vérifier le premier build avec polices auto-hébergées | P1 | non | — | à faire |
| B-06 | Vérifier les référentiels de conformité annoncés | P1 | oui | — | à faire |
| B-07 | Compléter TheGreenBow et BDA dans le parcours | P2 | oui | — | à faire |
| B-08 | Clarifier la chronologie Nova / Extia / TheGreenBow | P2 | oui | — | à faire |
| B-09 | Bandeau de preuves sur l'accueil | P2 | oui | — | à faire |
| B-10 | Études de cas (réalisations) | P2 | oui | B-08, B-09 | à faire |
| B-11 | Méthode, formats d'intervention et FAQ | P2 | oui | — | à faire |
| B-12 | Compléter la page Contact | P2 | oui | B-02 | à faire |
| B-13 | Portrait professionnel récent | P2 | oui | — | à faire |
| B-14 | Image de partage 1200 × 630 | P3 | oui | B-13 | à faire |
| B-15 | Profils externes et liens vers le site | P3 | oui | B-02 | à faire |
| B-16 | Search Console et Bing Webmaster Tools | P3 | oui | B-02, B-04 | à faire |
| B-17 | Plan éditorial et premiers articles | P2 | oui | — | à faire |
| B-18 | Décision : barre de recherche | P3 | oui | — | à faire |
| B-19 | Décision : logo et monogramme | P3 | oui | — | à faire |
| B-20 | Décision : une page par service | P3 | oui | — | à faire |
| B-21 | Vérification des liens dans `check` | P3 | oui | B-04 | à faire |
| B-22 | Verrouiller les dépendances Python | P3 | non | — | à faire |
| B-23 | Veille MkDocs 2.0 / Zensical | P3 | non | — | à faire |

---

## P1 — avant la mise en ligne

### B-01 — Disponibilité dans les modalités

- **Statut** : à faire · **Priorité** : P1 · **Skills** : site-navigation, site-look-and-feel
- **Contexte** : la tuile « Disponibilité — TODO. » était visible sur Services ; elle a été retirée et remplacée par un commentaire HTML dans `site/services.md` (section Modalités).

**Questions à l'opérateur**

1. Quelle disponibilité afficher : immédiate, à partir d'une date (laquelle), ou à temps partiel (combien de jours par semaine) ?
2. Accepte-t-on qu'elle se périme ? Sinon, quelle formulation durable (ex. « démarrage sous 2 à 4 semaines ») ?
3. Qui la met à jour, et à quelle fréquence ?

**Prompt**

> Dans `site/services.md`, section « Modalités », rétablis une 4ᵉ tuile `vt-tiles` au format `**Disponibilité** — <réponse>` à partir des réponses de l'opérateur, et supprime le commentaire `<!-- TODO: tuile « Disponibilité » … -->`. Avec 4 tuiles, la grille passe automatiquement en 2 × 2. Si la disponibilité est datée, ajoute à côté un commentaire HTML `<!-- Mise à jour : AAAA-MM-JJ -->` pour en suivre la fraîcheur.

- **Fichiers** : `site/services.md`
- **Critères d'acceptation**
    - [ ] La tuile affiche une information fournie par l'opérateur, sans TODO visible.
    - [ ] `mise run check` passe.
- **Journal** :

### B-02 — Domaine et adresse email réels

- **Statut** : à faire · **Priorité** : P1 · **Skills** : site-navigation
- **Contexte** : `site_url` vaut `https://mondomaine.fr/` et l'email `contact@mondomaine.fr`. Canonical, `sitemap.xml`, `robots.txt`, Open Graph et JSON-LD en dérivent tous : ils sont faux tant que ce n'est pas corrigé.

**Questions à l'opérateur**

1. Quel est le domaine exact ? Version canonique avec ou sans `www` ?
2. Quelle adresse email de contact publier ? Doit-elle être masquée contre les robots (au prix d'un peu de JavaScript, à décider) ?
3. Le domaine est-il déjà configuré chez DNSimple (ALIAS apex, CNAME www, TXT de vérification GitHub) ?

**Prompt**

> Remplace `https://mondomaine.fr/` par le domaine canonique dans `mkdocs.yml` (`site_url`, retire le commentaire TODO) et l'adresse `contact@mondomaine.fr` partout où elle apparaît (`grep -rn mondomaine site mkdocs.yml`) : `extra.social` et `site/contact.md` (bouton principal et commentaire TODO). Lance `mise run check`, puis `mise run dns:check` et rapporte son résultat à l'opérateur sans modifier la configuration DNS toi-même.

- **Fichiers** : `mkdocs.yml`, `site/contact.md`
- **Critères d'acceptation**
    - [ ] `grep -rn mondomaine site mkdocs.yml` ne renvoie rien.
    - [ ] `build/robots.txt` et `build/sitemap.xml` contiennent le vrai domaine.
    - [ ] `mise run check` passe ; résultat de `dns:check` consigné dans le journal.
- **Journal** :

### B-03 — Page « Mentions légales »

- **Statut** : à faire · **Priorité** : P1 · **Dépend de** : B-02 · **Skills** : site-navigation, site-look-and-feel
- **Contexte** : obligatoires pour un site professionnel en France (LCEN, art. 6 III) : identité de l'éditeur, contact, directeur de la publication, hébergeur. L'hébergeur est connu : GitHub, Inc., 88 Colin P. Kelly Jr. Street, San Francisco, CA 94107, États-Unis. Le site ne dépose aucun cookie et n'a pas de mesure d'audience (à confirmer).

**Questions à l'opérateur**

1. Statut juridique : entreprise individuelle (micro-entreprise ou non), EURL, SASU, portage salarial, autre ?
2. Dénomination sociale, numéro SIREN ou RCS, et numéro de TVA intracommunautaire s'il existe.
3. Adresse à publier : siège, domiciliation ? (Pour un entrepreneur individuel, une adresse de domiciliation évite de publier l'adresse personnelle.)
4. Directeur de la publication : Jérôme Ornech ?
5. Le site restera-t-il sans mesure d'audience ni cookie ? Si un outil est prévu, lequel ?

**Prompt**

> Crée `site/mentions-legales.md` avec `title`, `description` (70–160 caractères) et `hide: [navigation, toc]`, et un H1 « Mentions légales ». Sections H2 : Éditeur, Directeur de la publication, Hébergeur, Données personnelles et cookies, Propriété intellectuelle. N'utilise **que** les réponses de l'opérateur et l'hébergeur indiqué ci-dessus. Déclare la page dans `mkdocs.yml` via `not_in_nav: | /mentions-legales.md` (MkDocs ≥ 1.6), sans l'ajouter à `nav` : l'onglet resterait inutile et le budget N1 est de 6. Ajoute un lien dans `copyright` (`&copy; Jérôme Ornech — Expert DevOps freelance · <a href="/mentions-legales/">Mentions légales</a>`, chemin relatif à la racine du domaine). Dans `.mise/tasks/check`, exclus `mentions-legales.md` de la règle N6 (bloc `vt-cta`) au même titre qu'`index.md` et `contact.md`, et documente l'exception dans la règle N6 du skill `site-navigation`.

- **Fichiers** : `site/mentions-legales.md`, `mkdocs.yml`, `.mise/tasks/check`, `docs/skills/site-navigation/SKILL.md`
- **Critères d'acceptation**
    - [ ] Toutes les mentions obligatoires sont présentes et fournies par l'opérateur.
    - [ ] Lien visible dans le pied de page de toutes les pages, en clair et en sombre.
    - [ ] `mise run check` passe.
- **Journal** :

### B-04 — Dépôt git et publication GitHub Pages

- **Statut** : à faire · **Priorité** : P1 · **Dépend de** : B-02
- **Contexte** : le dossier du projet n'est pas un dépôt git. Le workflow `.github/workflows/deploy.yml` publie sur GitHub Pages à chaque push sur `main`.

**Questions à l'opérateur**

1. Existe-t-il déjà un dépôt distant ? Sinon : compte (`Hierosme` ?), nom du dépôt, public ou privé ?
2. Le dossier `_to_delete/` peut-il être supprimé définitivement ? (Il est ignoré par git de toute façon.)
3. Qui configure Settings → Pages (source « GitHub Actions », domaine personnel) : l'opérateur ou l'agent via `gh` ?

**Prompt**

> Initialise git (`git init -b main`), vérifie que `.gitignore` exclut `.venv/`, `build/`, `build-docs/`, `.cache/`, `.idea/`, `_to_delete/` et `Claude outputs/`, puis fais un premier commit en français à l'impératif. Ajoute le remote fourni par l'opérateur et pousse seulement après son accord explicite. Si l'opérateur le demande, configure Pages avec `gh api` (source GitHub Actions, domaine personnel). Vérifie que le workflow passe (`gh run watch`).

- **Critères d'acceptation**
    - [ ] Dépôt poussé, workflow « Deploy site » vert.
    - [ ] Site accessible en HTTPS sur le domaine (`mise run dns:check` passe).
- **Journal** :

### B-05 — Vérifier le premier build avec polices auto-hébergées

- **Statut** : à faire · **Priorité** : P1
- **Contexte** : le plugin `privacy` a été activé le 2026-11-02 pour servir Inter et JetBrains Mono depuis le site (RGPD). L'environnement de l'audit n'avait pas accès à Google Fonts : le téléchargement n'a pas pu être vérifié. Hors ligne, `VITRINE_PRIVACY=false` désactive le plugin.

**Prompt**

> Sur une machine avec accès réseau, lance `mise run check`. Vérifie ensuite que `build/index.html` ne contient plus `fonts.googleapis.com`, que `build/assets/external/` contient les fichiers de police, et que le rendu (`mise run site:serve`) utilise bien Inter, en clair et en sombre. En cas d'échec, consigne l'erreur dans le journal sans désactiver le plugin.

- **Critères d'acceptation**
    - [ ] Aucune requête vers `fonts.googleapis.com` ou `fonts.gstatic.com` au chargement d'une page (onglet Réseau du navigateur).
    - [ ] Le workflow GitHub Actions réussit avec le plugin actif.
- **Journal** :

### B-06 — Vérifier les référentiels de conformité annoncés

- **Statut** : à faire · **Priorité** : P1 · **Skills** : site-navigation
- **Contexte** : la section « Conformité du SI » de `site/services.md` (et sa carte) cite PCI-DSS, NIS 2 et ISO/IEC 27002, alors que le parcours n'atteste que des projets de conformité **ANSSI** (DigDeo). `AGENTS.md` interdit de mettre en avant une compétence absente du profil.

**Questions à l'opérateur**

1. Le profil LinkedIn ou une mission réelle mentionne-t-il PCI-DSS, NIS 2 ou ISO 27002 ? Lesquels, dans quel contexte ?
2. Sinon, préfère-t-on retirer ces référentiels ou les présenter explicitement comme « démarche transposable » sans revendiquer d'expérience ?

**Prompt**

> Selon la réponse : soit ajoute au parcours la mission qui atteste chaque référentiel conservé ; soit reformule la carte et la section « Conformité du SI » de `site/services.md` pour ne revendiquer que l'expérience ANSSI. La section doit garder au moins 500 caractères (`mise run content:services`) et la structure contexte / 4 puces / « Ce que vous y gagnez ». Mets à jour la `description` du front-matter si elle cite un référentiel retiré.

- **Critères d'acceptation**
    - [ ] Chaque référentiel cité est attesté par le parcours, ou n'est plus revendiqué.
    - [ ] `mise run check` passe.
- **Journal** :

---

## P2 — crédibilité et conversion

### B-07 — Compléter TheGreenBow et BDA dans le parcours

- **Statut** : à faire · **Priorité** : P2 · **Skills** : site-navigation
- **Contexte** : le poste le plus récent (TheGreenBow, 2025–2026) se limite à « Paris. » ; BDA (1999–2004) n'a aucune description. Le poste le plus récent est celui que le lecteur regarde en premier.

**Questions à l'opérateur**

1. TheGreenBow : périmètre du poste, 2 ou 3 réalisations concrètes, technologies, taille de l'équipe ?
2. BDA : type d'intégration réseau, clients ou secteurs (si publiables), technologies ?
3. Ces informations figurent-elles dans le profil LinkedIn (source de vérité) ?

**Prompt**

> Dans `site/parcours.md`, complète les entrées TheGreenBow et BDA de la frise `vt-timeline` sur le modèle des autres : 2 à 3 puces « verbe d'action + détail », mot porteur en tête, uniquement à partir des réponses. Si TheGreenBow apporte une compétence absente des tuiles « Compétences clés », propose-la à l'opérateur avant de l'ajouter (6 tuiles maximum). Si la mission rejoint un service, propose de la citer dans le paragraphe de contexte de ce service dans `site/services.md`.

- **Critères d'acceptation**
    - [ ] Aucune entrée de la frise sans contenu.
    - [ ] `mise run check` passe.
- **Journal** :

### B-08 — Clarifier la chronologie Nova / Extia / TheGreenBow

- **Statut** : à faire · **Priorité** : P2 · **Skills** : site-navigation
- **Contexte** : Nova Technology (2021–2025), Extia pour France Télévisions (2023–2024) et TheGreenBow (2025–2026) se chevauchent. Un lecteur peut y voir une incohérence.

**Questions à l'opérateur**

1. Quel lien entre Nova Technology et Extia : ESN employeur, sous-traitance, missions successives ?
2. Dates exactes (mois/année) de chaque poste et de chaque mission client ?
3. Statut actuel : freelance depuis quand, sous quelle forme ?

**Prompt**

> Reformule les titres H3 et les dates de la frise de `site/parcours.md` pour que la chronologie se lise sans ambiguïté (ex. « Expert DevOps — Nova Technology (2021–2025) » avec les missions comme sous-blocs, mission France Télévisions « via Extia »). N'ajoute que des faits confirmés par l'opérateur. Vérifie la cohérence avec la section « Network as Code » de `site/services.md`.

- **Critères d'acceptation**
    - [ ] Aucun chevauchement de dates non expliqué.
    - [ ] `mise run check` passe.
- **Journal** :

### B-09 — Bandeau de preuves sur l'accueil

- **Statut** : à faire · **Priorité** : P2 · **Skills** : site-look-and-feel, site-navigation
- **Contexte** : le composant `vt-proof` existe (commentaire TODO dans `site/index.md`) mais n'est pas utilisé. Des preuves en texte suffisent : les logos demandent une autorisation explicite.

**Questions à l'opérateur**

1. Quels clients peut-on citer nommément sur l'accueil (France Télévisions, Maison Christian Louboutin, Ansys, DigDeo…) ? Un contrat ou un accord de confidentialité l'interdit-il ?
2. Des logos sont-ils autorisés par écrit ? Si oui, fournir les fichiers SVG.
3. Quels chiffres afficher ? Candidats déjà attestés sur le site : « 25 ans d'expérience », « 14 ans de datacenter et de HPC chez Ansys ».
4. Certifications à afficher (intitulé exact, année) ?

**Prompt**

> Dans `site/index.md`, remplace le commentaire `vt-proof` par un bloc `<div class="vt-proof" markdown>` placé juste après le hero : de 3 à 5 éléments courts (noms de clients autorisés en texte, chiffres attestés, certifications), uniquement à partir des réponses. N'utilise des logos que s'ils sont autorisés par écrit (`site/assets/logos/`, SVG, `alt` = nom du client). Vérifie le rendu en clair et en sombre, sur desktop et mobile.

- **Critères d'acceptation**
    - [ ] Chaque élément est réel et autorisé ; aucun logo sans accord écrit.
    - [ ] `mise run check` passe ; rendu vérifié dans les 4 combinaisons thème × écran.
- **Journal** :

### B-10 — Études de cas (réalisations)

- **Statut** : à faire · **Priorité** : P2 · **Dépend de** : B-08, B-09 · **Skills** : site-navigation, site-look-and-feel
- **Contexte** : levier de crédibilité le plus fort d'une vitrine de freelance (Fogg 2003, Cyr 2008). Matière disponible : France Télévisions (Network as Code), Louboutin (OMS), grand compte La Défense (Continuous Delivery), DigDeo (conformité ANSSI, CD).

**Questions à l'opérateur** (pour chaque cas retenu)

1. Peut-on nommer le client ? Sinon, quelle description anonyme (secteur, taille) ?
2. Situation de départ : quel problème, quelle contrainte ?
3. Intervention : durée, taille de l'équipe, rôle exact, choix techniques.
4. Résultats : mesurables et vérifiables (chiffres réels uniquement), ou qualitatifs ?
5. Une citation du client est-elle disponible **et autorisée par écrit** ?
6. Où placer les cas : nouvel onglet « Réalisations » (6ᵉ et dernier onglet possible avant Contact, budget N1) ou section de la page Parcours ?

**Prompt**

> Crée les études de cas selon l'emplacement choisi. Format de chaque cas : H2 « Client — sujet », puis Contexte (2–3 phrases), Intervention (3–4 puces « verbe + détail »), Résultat (puces ; chiffres seulement s'ils sont fournis), Technologies (une ligne), et un lien vers le service correspondant (`services.md#ancre`). Termine par un `vt-cta`. Si nouvelle page : `title`, `description`, `hide: [navigation]`, entrée dans `nav` entre Services et Parcours, mise à jour de la « Structure actuelle » du skill `site-navigation`. Depuis chaque section de `site/services.md`, ajoute un lien vers le cas correspondant.

- **Critères d'acceptation**
    - [ ] Chaque fait est confirmé par l'opérateur ; aucun chiffre ni citation inventés.
    - [ ] 6 onglets au plus ; `mise run check` passe.
- **Journal** :

### B-11 — Méthode, formats d'intervention et FAQ

- **Statut** : à faire · **Priorité** : P2 · **Skills** : site-navigation
- **Contexte** : un acheteur cherche aussi comment se déroule une mission et à quelles conditions. Rien ne le dit aujourd'hui.

**Questions à l'opérateur**

1. Étapes habituelles d'une mission (cadrage, audit, réalisation, transfert…) ?
2. Formats proposés : régie, forfait, audit court, formation ? Durée minimale ?
3. Facturation directe, portage salarial, ou via ESN uniquement ?
4. Afficher un TJM, une fourchette, ou « sur devis » ?
5. Délai de démarrage habituel ? Accord de confidentialité (NDA) accepté ?
6. Autres questions fréquentes reçues des prospects ?

**Prompt**

> Dans `site/services.md`, avant « Modalités », ajoute `## Comment je travaille` (étapes en liste numérotée courte) et `## Questions fréquentes` (chaque question en H3, réponse de 2 phrases maximum). Ces H2 **n'ont pas** d'identifiant explicite `{ #… }` : ce ne sont pas des services (règle N8). N'écris que les réponses de l'opérateur ; une question sans réponse n'est pas publiée.

- **Critères d'acceptation**
    - [ ] Toutes les réponses viennent de l'opérateur.
    - [ ] `mise run check` passe ; table des matières lisible.
- **Journal** :

### B-12 — Compléter la page Contact

- **Statut** : à faire · **Priorité** : P2 · **Dépend de** : B-02 · **Skills** : site-navigation, site-look-and-feel
- **Contexte** : la page a été structurée (« Pour un premier échange efficace ») avec les informations existantes. Il manque les engagements et les canaux.

**Questions à l'opérateur**

1. Délai de réponse habituel à afficher ?
2. Lien de prise de rendez-vous (Cal.com, Calendly…) ? Si oui, il devient le bouton secondaire ; l'email reste le bouton principal (règle P6).
3. Profils à ajouter (Malt, autre plateforme) ? Téléphone publié ?

**Prompt**

> Mets à jour `site/contact.md` avec les réponses : une phrase sur le délai de réponse après les boutons, le lien de rendez-vous en `.md-button` secondaire (2 boutons secondaires au plus : retire GitHub de la rangée s'il le faut, il reste dans le pied de page). Ajoute les nouveaux profils à `extra.social` dans `mkdocs.yml` (ils alimentent aussi le `sameAs` du JSON-LD). Supprime le commentaire TODO quand tout est traité.

- **Critères d'acceptation**
    - [ ] Un seul bouton primaire ; `mise run check` passe.
- **Journal** :

### B-13 — Portrait professionnel récent

- **Statut** : à faire · **Priorité** : P2 · **Skills** : site-look-and-feel
- **Contexte** : le portrait actuel est une photo prise en extérieur, au fond de paysage de vacances. Un portrait professionnel récent, cohérent avec 25 ans d'expérience, renforce la crédibilité (Cyr 2008 : images et confiance). Il sert aussi d'image de partage (Open Graph) et d'avatar du blog.

**Questions à l'opérateur**

1. Une photo plus récente et plus professionnelle est-elle disponible ? (Visage net, fond neutre ou sobre, cadrage carré possible.)
2. Garder la photo actuelle en attendant ?

**Prompt**

> Avec la photo fournie, produis `site/assets/images/jerome-ornech.jpg` (carré 480 × 480, JPEG progressif ≤ 50 Ko, visage centré) et `jerome-ornech-avatar.jpg` (160 × 160). Ne change ni les noms de fichiers ni le Markdown. Vérifie le hero en clair et en sombre, sur desktop et mobile.

- **Critères d'acceptation**
    - [ ] Poids et dimensions respectés ; rendu vérifié.
- **Journal** :

---

## P3 — référencement de fond, confort, outillage

### B-14 — Image de partage 1200 × 630

- **Statut** : à faire · **Priorité** : P3 · **Dépend de** : B-13 · **Skills** : site-look-and-feel
- **Contexte** : `og:image` utilise le portrait carré 480 px (`extra.seo.image`). LinkedIn affiche mieux une image 1200 × 630 (format 1,91:1).

**Questions à l'opérateur**

1. Contenu souhaité : portrait + nom + « Expert DevOps & Ansible freelance » sur le dégradé du hero ? Autre ?
2. Une image unique pour tout le site suffit-elle, ou une image par article de blog (plugin `social` de Material, qui demande les bibliothèques Cairo en CI) ?

**Prompt**

> Pour une image unique : crée `site/assets/images/partage.png` (1200 × 630, ≤ 300 Ko), aux couleurs Nord du hero (dégradé nord0 → nord1 → nord10, texte nord6, police Inter). Pointe `extra.seo.image` dessus, passe `twitter:card` à `summary_large_image` et ajoute `og:image:width` et `og:image:height` dans `overrides/main.html`. Teste l'aperçu avec le Post Inspector de LinkedIn une fois le site en ligne.

- **Critères d'acceptation**
    - [ ] Aperçu LinkedIn correct ; `mise run check` passe.
- **Journal** :

### B-15 — Profils externes et liens vers le site

- **Statut** : à faire · **Priorité** : P3 · **Dépend de** : B-02
- **Contexte** : les liens entrants depuis des profils reconnus aident le référencement et la cohérence de l'identité. Le JSON-LD reprend `extra.social` comme `sameAs`.

**Questions à l'opérateur**

1. Quels profils existent : Malt, Crème de la Crème, Ansible Galaxy, Stack Overflow, autre ?
2. L'opérateur peut-il ajouter l'URL du site au champ « Site web » de LinkedIn et au profil GitHub (README de profil) ?
3. Souhaite-t-on une fiche Google Business Profile (zone desservie, sans adresse publique) pour les recherches locales (« freelance DevOps Corse ») ?

**Prompt**

> Ajoute les profils confirmés à `extra.social` (icône `fontawesome/brands/…` ou `material/…`, `name` explicite). Propose à l'opérateur un texte court pour le README de profil GitHub et la section « Infos » de LinkedIn, reprenant le H1 et l'accroche du site avec le lien. Ne crée aucun compte toi-même.

- **Critères d'acceptation**
    - [ ] `sameAs` du JSON-LD (accueil) liste tous les profils confirmés ; `mise run check` passe.
- **Journal** :

### B-16 — Search Console et Bing Webmaster Tools

- **Statut** : à faire · **Priorité** : P3 · **Dépend de** : B-02, B-04
- **Questions à l'opérateur**

1. Quel compte Google utiliser ? Vérification du domaine par enregistrement TXT chez DNSimple : qui l'ajoute ?
2. Même chose pour Bing (import depuis Search Console possible).

**Prompt**

> Guide l'opérateur pas à pas : propriété « Domaine » dans Search Console, enregistrement TXT chez DNSimple, soumission de `https://<domaine>/sitemap.xml`, inspection de l'URL d'accueil. Puis import dans Bing Webmaster Tools. Consigne dans le journal la date de soumission ; à J+14, relève les pages indexées et les éventuelles erreurs.

- **Journal** :

### B-17 — Plan éditorial et premiers articles

- **Statut** : à faire · **Priorité** : P2 · **Skills** : site-navigation
- **Contexte** : le blog est le principal levier de référencement sur des requêtes précises. Un seul article publié (« Bienvenue »). Sujets candidats tirés des missions réelles, avec la requête visée :
    - Découper une base Ansible monolithique en rôles et Collections — *refactoring Ansible, collections Ansible*
    - Écrire un lookup plugin Ansible en Python — *lookup plugin ansible*
    - Network as Code : configurer ses équipements réseau depuis Git — *network as code ansible*
    - Embarquer une équipe réseau dans Git et la CI/CD — *automatisation réseau équipe*
    - Appliquer les recommandations de l'ANSSI avec Ansible — *conformité ANSSI ansible*
    - Un pipeline de livraison continue pour l'infrastructure — *continuous delivery infrastructure*

**Questions à l'opérateur**

1. Quels sujets retenir, dans quel ordre ? D'autres idées ?
2. Rythme de publication réaliste (ex. un article par mois) ?
3. Pour chaque article : anecdotes, chiffres, extraits de code **réels et publiables** (sans données client) ?
4. Qui rédige : l'agent rédige un brouillon à partir d'une interview, puis l'opérateur relit ?

**Prompt**

> Pour chaque sujet retenu, interroge l'opérateur (problème rencontré, solution, pièges, résultat), puis crée le brouillon avec `mise run blog:new "Titre" -c <Catégorie>`. Rédige à la première personne, ton direct ; H2 tous les 2–3 paragraphes, mot-clé en tête des titres ; code d'exemple générique (aucun nom de client ni d'hôte réel). Renseigne `description` (70–160 caractères). Laisse `draft: true` : c'est l'opérateur qui publie. Ajoute un lien vers le service concerné en fin d'article.

- **Critères d'acceptation**
    - [ ] Brouillons validés par l'opérateur ; `mise run blog:list` à jour ; `mise run check` passe.
- **Journal** :

### B-18 — Décision : barre de recherche

- **Statut** : à faire · **Priorité** : P3 · **Skills** : site-look-and-feel, site-navigation
- **Contexte** : la recherche occupe une place visible dans l'en-tête pour un site de 5 pages (Hick 1952 : chaque option affaiblit l'action principale). Elle deviendra utile quand le blog aura une dizaine d'articles.

**Questions à l'opérateur**

1. Retirer la recherche maintenant et la rétablir plus tard, ou la garder ?

**Prompt**

> Si retrait : supprime le plugin `search` et la feature `search.highlight` dans `mkdocs.yml`, avec un commentaire indiquant quand la rétablir. Vérifie l'en-tête en clair et en sombre, desktop et mobile. Consigne la décision dans le skill `site-navigation` (nouvelle règle de navigation).

- **Journal** :

### B-19 — Décision : logo et monogramme

- **Statut** : à faire · **Priorité** : P3 · **Skills** : site-look-and-feel
- **Contexte** : le logo est l'icône `material/infinity`, symbole très répandu du DevOps donc peu distinctif. Le favicon (`favicon.svg`, `apple-touch-icon.png`) a été dessiné le 2026-11-02 à partir de cette même icône.

**Questions à l'opérateur**

1. Garder l'infini, ou passer à un monogramme « JO » ?
2. Si monogramme : préférences de forme (cercle, carré arrondi), graisse ?

**Prompt**

> Si monogramme : dessine `site/assets/images/logo.svg` (lettres en Inter 700, couleur `currentColor` pour suivre l'en-tête dans les deux thèmes), règle `theme.logo` dans `mkdocs.yml` à la place de `theme.icon.logo`, puis régénère `favicon.svg` et `apple-touch-icon.png` (180 × 180, fond nord0, motif nord8). Mets à jour le tableau « Sources de vérité » du skill `site-look-and-feel`.

- **Journal** :

### B-20 — Décision : une page par service

- **Statut** : à faire · **Priorité** : P3 · **Skills** : site-navigation, site-look-and-feel
- **Contexte** : une URL par service permet de viser une requête par page (« freelance Ansible », « Network as Code », « conformité ANSSI »…). En contrepartie : plus de pages à maintenir, et la page Services actuelle (cartes-sommaire + sections) est cohérente avec la règle N8.

**Questions à l'opérateur**

1. Éclater Services en sous-pages, ou garder la page unique ?
2. Si oui : tous les services, ou seulement les 2–3 prioritaires commercialement ?

**Prompt**

> Si oui : crée `site/services/index.md` (cartes-sommaire, intro, Modalités, `vt-cta`) et une page par service (`site/services/<ancre>.md`, `title`, `description`, `vt-cta`), en déplaçant le texte existant sans le réécrire. Dans `nav`, transforme « Services » en section avec index (`navigation.indexes`), sans ajouter d'onglet. Mets à jour les liens internes (accueil, articles), `.mise/tasks/content/services` (qui lit aujourd'hui `site/services.md`) et la section « Structure de la page Services » du skill `site-navigation`. Les anciennes ancres `services/#…` cesseront de fonctionner : à faire avant la mise en ligne si possible.

- **Journal** :

### B-21 — Vérification des liens dans `check`

- **Statut** : à faire · **Priorité** : P3 · **Dépend de** : B-04
- **Contexte** : le build strict vérifie les liens internes, pas les liens externes (LinkedIn, GitHub, sources).

**Questions à l'opérateur**

1. Accepte-t-on une nouvelle dépendance (`lychee`, installable par mise) ?
2. Vérifier les liens externes à chaque `check`, ou seulement en CI ou à la demande (LinkedIn bloque souvent les robots : code 999) ?

**Prompt**

> Ajoute `lychee` à `[tools]` de `.mise/config.toml`, crée la tâche `.mise/tasks/links/check` (bash 3.2 compatible, en-têtes `#MISE`) qui lance par défaut `lychee --offline build` (liens internes et ancres) et, avec un drapeau `--external` de la tâche, `lychee build --exclude linkedin.com` (liens externes). Branche-la selon la réponse et ajoute-la au tableau des commandes de `docs/architecture.md`.

- **Journal** :

### B-22 — Verrouiller les dépendances Python

- **Statut** : à faire · **Priorité** : P3
- **Contexte** : `requirements.txt` fixe des intervalles (`mkdocs>=1.6,<2`, `mkdocs-material>=9.6,<10`) : deux builds à des dates différentes peuvent utiliser des versions différentes.

**Prompt**

> Génère `requirements.lock` avec `uv pip compile requirements.txt -o requirements.lock`, fais-le utiliser par `.mise/tasks/install` (`uv pip install -r requirements.lock`, `sources` mis à jour) et documente la procédure de mise à jour dans `docs/architecture.md`. Vérifie `mise run check` et le workflow CI.

- **Journal** :

### B-23 — Veille MkDocs 2.0 / Zensical

- **Statut** : à faire · **Priorité** : P3 · tâche récurrente (trimestrielle)
- **Contexte** : l'équipe Material for MkDocs avertit au build que MkDocs 2.0 cassera plugins et surcharges de thème (voir son analyse, février 2026), et développe Zensical comme successeur. Le projet est protégé par `mkdocs<2` dans `requirements.txt`.

**Prompt**

> Vérifie l'état de Zensical : compatibilité de `mkdocs.yml`, prise en charge du plugin blog, des plugins `privacy` et `search`, des `hooks` et de `custom_dir`. Consigne le constat dans le journal. Ne propose une migration que si toutes les fonctions utilisées sont couvertes, et dans ce cas crée une nouvelle tâche dédiée.

- **Journal** :

---

## Fait le 2026-11-02 (audit)

Pour mémoire, corrigé sans information nouvelle :

- **Contenu** : TODO « Disponibilité » retiré de la page Services (→ B-01) ; article « Bienvenue » et page Blog complétés à partir des contenus existants ; tuiles « Compétences clés » alignées sur les services (6 tuiles) ; page Contact structurée ; « ma mission récente pour France Télévisions » daté (2023–2024).
- **Design** : hero en flex (texte centré face au portrait) ; H1 en 700 ; graisses alignées sur les polices chargées ; grilles de 4 éléments en 2 × 2 et tuiles limitées à 3 colonnes ; liens Précédent/Suivant supprimés ; table des matières retirée du Parcours ; favicon SVG et apple-touch-icon.
- **SEO** : `title` et `description` uniques sur chaque page ; Open Graph, Twitter Card, JSON-LD `Person` (`overrides/main.html`, `extra.seo`) ; `robots.txt` généré (`hooks/robots.py`) ; URL d'articles `/blog/<slug>/` ; polices auto-hébergées (plugin `privacy`, → B-05).
- **Outillage** : `mise run content:seo` et `content:todo-visible`, branchés dans `check` ; `blog:new` génère une `description` ; `.gitignore` complété ; skills, `architecture.md`, `AGENTS.md` et explication du design system (§ 6) mis à jour.
