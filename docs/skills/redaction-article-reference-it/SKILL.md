---
name: redaction-article-reference-it
description: Rédiger un article de blog de référence IT (savoir-faire, savoir-comprendre ou mixte) pour la vitrine Zensical, après un questionnaire de cadrage en 5 points. À utiliser pour tout nouvel article ou épisode de série du blog.
---

# Rédaction d'article de référence IT

Ce skill produit des articles de blog qui partagent tous le même air de famille : des articles de référence rédigés par un praticien senior, qui forment le lecteur dès la première lecture et qu'il rouvre ensuite comme aide-mémoire.

**À lire avant de rédiger**, en plus de ce skill : `oxygen-ui-design-guidelines` (norme, toujours), `site-look-and-feel` (composants et budgets d'encadrés) et `site-navigation` (format d'article, catégories, SEO). En cas de conflit, ces skills l'emportent sur celui-ci, qui doit alors être corrigé.

## Entrée

Le seul élément indispensable est le **sujet**, donné dans la demande (ex. « nouvel article : les Collections Ansible »). L'opérateur peut préciser des paramètres ; sinon, appliquez les valeurs par défaut.

## Paramètres (valeurs par défaut si non précisées)

- Série / épisode : à déterminer
- Type d'article : à proposer au questionnaire (savoir-faire · savoir-comprendre · mixte)
- Nature du sujet : technologique (technologique · méthodologique)
- Public : ingénieurs et tech leads, 2 à 8 ans d'expérience
- Niveau : confirmé (initiation · confirmé · expert)
- Catégorie : une valeur de `plugins.blog.categories_allowed` (`zensical.toml`)
- Longueur cible : 1 500 à 2 200 mots hors code
- Langue : français ; le lecteur est vouvoyé, l'auteur s'exprime à la première personne ; termes techniques anglais conservés quand c'est l'usage

## Types d'article

Le type détermine les objectifs, le contenu de certaines sections et la forme des exercices. La structure, les encadrés et le style restent identiques pour tous les types.

- **Savoir-faire** : le lecteur apprend à exécuter (configurer, déployer, diagnostiquer, mettre en place une pratique). Mesure de réussite : il sait le faire seul.
- **Savoir-comprendre** : le lecteur acquiert rapidement les concepts clés d'un domaine pour être efficace : poser les bonnes questions, lire une architecture, comprendre une discussion d'experts, prendre une décision éclairée. Mesure de réussite : il sait expliquer, distinguer et choisir.
- **Mixte** : quelques concepts indispensables, puis leur mise en œuvre. Mesure de réussite : il comprend pourquoi il fait ce qu'il fait.

Quel que soit le type, le savoir doit être actionnable : chaque concept présenté est relié à une conséquence pratique (une décision, un réflexe, un risque à anticiper). Un concept sans implication pratique n'a pas sa place dans l'article.

## Déroulé en deux phases

### Phase 1 — Questionnaire d'avant-rédaction (obligatoire)

Avant toute rédaction, posez à l'opérateur les 5 questions ci-dessous, puis arrêtez-vous et attendez ses réponses. Ne créez aucun fichier à ce stade.

Pour chaque question, proposez une hypothèse par défaut déduite du sujet, afin que l'opérateur puisse simplement valider, corriger ou compléter. Si l'opérateur répond « ok » ou laisse une question sans réponse, retenez votre hypothèse et signalez-la dans le compte rendu. Une hypothèse ne contient jamais d'expérience, de client ou de chiffre inventé.

Présentez le questionnaire sous cette forme :

> **Q1 — Lecteur et situation de départ**
> Qui lira cet article, et dans quelle situation concrète se trouve-t-il quand il en a besoin ? Avez-vous un cas réel (projet, incident, demande client) à utiliser comme fil conducteur ?
> *Hypothèse proposée : …*

> **Q2 — Type d'article et objectifs**
> S'agit-il de savoir-faire, de savoir-comprendre ou d'un article mixte ? Qu'est-ce que le lecteur doit savoir faire, expliquer ou décider à l'issue de l'article ? (2 à 4 objectifs observables)
> *Hypothèse proposée : type …, objectifs …*

> **Q3 — Périmètre**
> Qu'est-ce qui est inclus, qu'est-ce qui est explicitement exclu ? Quelles versions, quels outils, quel environnement cible (cloud, OS, stack) ?
> *Hypothèse proposée : …*

> **Q4 — Point de vue et retour terrain**
> Quelles recommandations, convictions ou retours d'expérience personnels voulez-vous faire apparaître ? Y a-t-il une idée reçue à corriger ou une pratique à déconseiller ?
> *Hypothèse proposée : aucune, l'article restera strictement factuel.*

> **Q5 — Sources, catégorie et contraintes**
> Y a-t-il des sources à utiliser ou à éviter (documentation interne, RFC, articles précédents de la série) ? Quelle catégorie du blog ? Des contraintes à respecter (confidentialité client, noms à anonymiser, date de publication) ?
> *Hypothèse proposée : catégorie …, …*

Les réponses priment sur les paramètres par défaut en cas de divergence. Les retours d'expérience viennent **uniquement** des réponses à Q4 ou de `site/parcours.md` (règle « ne jamais inventer » d'`AGENTS.md`).

### Phase 2 — Rédaction

Ne commencez qu'après réception des réponses au questionnaire.

1. Recherchez et vérifiez dans la documentation officielle les commandes, options, valeurs par défaut et comportements que vous allez citer.
2. Créez le brouillon avec `mise run blog:new "Titre" -c Catégorie` (jamais à la main), puis éditez le fichier créé dans `site/blog/posts/`.
3. Rédigez selon la structure ci-dessous, appliquez l'auto-contrôle, puis lancez `mise run check`, qui doit passer.

## Rôle

Vous êtes un praticien senior en IT (automatisation, réseau, CI/CD, cloud, méthodes) et formateur. Vous rédigez un article qui remplit deux fonctions :

1. Former : le lecteur doit acquérir une compétence ou une compréhension opérationnelle dès la première lecture.
2. Servir de référence : le lecteur doit pouvoir revenir plus tard et retrouver en moins de 30 secondes la commande, la définition, la règle ou le critère dont il a besoin.

## Principes pédagogiques (non négociables)

1. Annoncez 2 à 4 objectifs observables. Verbes selon le type :
    - savoir-faire : configurer, déployer, diagnostiquer, automatiser, mettre en place…
    - savoir-comprendre : expliquer, distinguer, identifier, choisir, anticiper, évaluer…

    Jamais « comprendre », « découvrir » ou « connaître », qui ne sont pas vérifiables.
2. Le pourquoi avant le comment : partez du problème concret que le sujet résout.
3. Le concret avant l'abstrait : un cas réaliste sert de fil conducteur à tout l'article.
4. Progression : concepts, puis cas commenté, puis mise en pratique.
5. Charge cognitive maîtrisée : 5 à 7 concepts clés au maximum par article, un seul concept nouveau par section. Si un prérequis manque, renvoyez vers lui au lieu de l'expliquer en détail.
6. Chaque concept est défini par contraste : ce qu'il est, ce qu'il n'est pas (la notion voisine avec laquelle on le confond), et ce qu'il change en pratique.
7. Auto-évaluation : l'article se termine par des questions, pas par un résumé passif.
8. Chaque section doit rester utile si on y arrive directement par une ancre ou un survol.

## Registre

- Professionnel, factuel, sobre, direct. Aucune métaphore filée, aucune référence sportive, ludique ou narrative.
- Une analogie technique est autorisée dans la section « Concepts clés » si elle clarifie réellement un mécanisme. Une seule.
- Le ton est celui d'un expert qui transmet à des pairs : sans condescendance ni enthousiasme marketing.

## Structure imposée (ordre identique dans tous les articles)

Les titres H2 sont fixes pour que les ancres soient stables et que le lecteur s'y retrouve immédiatement. Seuls les titres des sections 5, 6 et 7 dépendent du type d'article ; le type mixte utilise les titres du savoir-faire.

| #  | Savoir-faire / Mixte    | Savoir-comprendre    |
|----|-------------------------|----------------------|
| 1  | En bref                 | En bref              |
| 2  | Contexte                | Contexte             |
| 3  | Concepts clés           | Concepts clés        |
| 4  | Référence rapide        | Référence rapide     |
| 5  | Démonstration commentée | Cas analysé          |
| 6  | Erreurs fréquentes      | Idées reçues         |
| 7  | Exercices               | Mises en situation   |
| 8  | Auto-évaluation         | Auto-évaluation      |
| 9  | Aide-mémoire            | Aide-mémoire         |
| 10 | Pour aller plus loin    | Pour aller plus loin |

### 0. Front-matter, titre et accroche

Le front-matter produit par `blog:new` (voir `site-navigation`, § Ajouter un article de blog), complété des métadonnées de série :

```yaml
---
date: AAAA-MM-JJ
authors:
  - jerome
categories:
  - …                          # uniquement des valeurs de categories_allowed
slug: …
description: "…"               # 70 à 160 caractères, unique, orientée bénéfice
draft: true
serie: …
episode: …
type: …                        # savoir-faire | savoir-comprendre | mixte
niveau: …
versions_testees: [ … ]        # si applicable, ex. "ansible-core 2.17"
derniere_verification: AAAA-MM-JJ
---
```

Le temps de lecture est calculé par le plugin blog (`post_readtime`) : ne l'écrivez pas.

Puis : `# Titre` (mot-clé en tête), une accroche de 1 à 2 phrases (le bénéfice pour le lecteur, affichée dans la liste du blog), puis `<!-- more -->`.

### 1. En bref

- Des tuiles `vt-tiles` (4 ou 6, jamais d'orphelin) : **Type**, **Niveau**, **Public**, **Pratique** (durée estimée), **Prérequis**, **Versions testées**. Pour un article sans pratique ni outil, gardez les 4 premières pertinentes.
- Puis « À l'issue de cet article, vous saurez : » + la liste des objectifs.
- Puis 3 points clés maximum : l'essentiel pour qui ne lirait que ça.

Pas d'encadré : la norme interdit d'encadrer un paragraphe d'introduction.

### 2. Contexte

Le problème, les situations où il se pose, pourquoi c'est important maintenant. 150 à 250 mots. Partez d'un cas concret et daté, pas d'une généralité.

### 3. Concepts clés

Le modèle mental : les notions indispensables et leurs relations. Chaque terme est défini à sa première occurrence (`def_list` ou `abbr` sont disponibles).

Obligatoire : un schéma. Mermaid n'est pas activé sur le site (il chargerait du JavaScript externe, ce que `site-look-and-feel` interdit sans décision du propriétaire) : dessinez un schéma texte dans un bloc ` ```text `, ou une liste hiérarchique si les relations sont simples.

- Savoir-faire : uniquement les concepts nécessaires à l'exécution, en 300 mots maximum.
- Savoir-comprendre et mixte : c'est la section principale. Pour chaque concept : définition en une phrase, distinction avec la notion voisine, exemple concret, conséquence pratique.

### 4. Référence rapide

La partie qu'on vient relire. Un ou plusieurs tableaux selon le type :

- savoir-faire, technologique : | Commande / configuration | Cas d'usage | Effet | Point d'attention |
- savoir-faire, méthodologique : | Pratique | Cas d'usage | Mise en œuvre | Point d'attention |
- savoir-comprendre : | Concept | Définition courte | Ce que ça change en pratique | À ne pas confondre avec |
  et, si le sujet s'y prête, un tableau comparatif d'options : | Critère | Option A | Option B | Option C |
- mixte : le tableau des concepts, puis celui des commandes ou pratiques.

Classez les lignes de la plus utile à la moins utile. Uniquement des éléments vérifiables dans la documentation officielle ou par exécution. Si la mise en œuvre varie selon l'outil ou la plateforme, ajoutez une colonne ou une sous-section H3 par variante (les onglets `pymdownx.tabbed` ne sont pas activés).

### 5. Démonstration commentée / Cas analysé

- **Démonstration commentée** (savoir-faire, mixte) : un exemple guidé pas à pas sur le cas fil conducteur, une sous-section H3 par étape, toujours selon le même schéma : **Objectif** → **Mise en œuvre** (le code ou l'action) → **Résultat attendu** (sortie réelle ou état vérifiable). Le code est complet, exécutable, avec les versions précisées. Commentez les lignes clés par des commentaires dans le code, ou par une liste numérotée sous le bloc (les annotations de code ne sont pas activées).
- **Cas analysé** (savoir-comprendre) : une situation réaliste (architecture, incident, décision d'équipe) lue à travers les concepts de la section 3. Pour chaque point clé : **Constat** → **Concept mobilisé** → **Conséquence ou décision**.

### 6. Erreurs fréquentes / Idées reçues

3 à 5 entrées, une sous-section H3 ou un élément de liste par entrée.

- Erreurs fréquentes : symptôme → cause → correction. Le symptôme est formulé tel que le lecteur l'observera (message d'erreur exact, comportement constaté), pour qu'on puisse le retrouver par une recherche.
- Idées reçues : idée reçue → réalité (sourcée) → conséquence pratique de l'erreur.

### 7. Exercices / Mises en situation

Trois exercices de difficulté croissante, un H3 chacun (pas d'encadré, pour tenir le budget) :

- Savoir-faire, mixte :
    - **Exercice 1 — Application** : reproduire la démonstration avec une variante.
    - **Exercice 2 — Adaptation** : transposer à un contexte différent.
    - **Exercice 3 — Cas ouvert** : un problème qui demande des arbitrages argumentés.
- Savoir-comprendre :
    - **Situation 1 — Identifier** : reconnaître le concept à l'œuvre dans une situation décrite.
    - **Situation 2 — Expliquer** : justifier un comportement ou un choix observé.
    - **Situation 3 — Décider** : choisir entre plusieurs options et argumenter.

Chaque exercice se termine par une ligne *Piste :* en italique. Jamais la solution complète du troisième exercice.

### 8. Auto-évaluation

4 à 5 questions numérotées : au moins une de diagnostic (« que se passe-t-il si… »), une d'arbitrage (« A ou B, dans quel cas ? ») et, pour le savoir-comprendre, une de distinction (« quelle différence entre X et Y ? »).

Toutes les réponses, numérotées et justifiées, dans **un seul** bloc replié `??? question "Réponses"`.

### 9. Aide-mémoire

15 lignes maximum, sans encadré : une liste ou un bloc de code. Elle doit pouvoir s'imprimer et rester compréhensible sans le reste de l'article.

- Savoir-faire : les commandes et réflexes essentiels.
- Savoir-comprendre : les définitions en une ligne et les règles de décision.

### 10. Pour aller plus loin

L'article suivant de la série, les sources officielles (documentation, RFC, spécifications) et 1 ou 2 ressources complémentaires de référence. Dernière ligne : un lien vers Contact (`../../contact.md`) formulé selon le sujet, comme dans les articles existants. Liens internes relatifs vers le `.md`.

## Encadrés (budget de la norme : 3 par article, 1 visible à l'écran)

Le bloc `??? question "Réponses"` de l'auto-évaluation en consomme un. Il en reste **2 au maximum**, choisis parmi :

- `!!! tip "Bonne pratique"` : une recommandation issue de l'expérience terrain, justifiée
- `!!! warning "Attention"` : une erreur fréquente ou coûteuse, ou un comportement contre-intuitif
- `!!! note "Critère de décision"` : une règle pour choisir entre plusieurs options
- `!!! danger "Risque"` : uniquement pour une perte de données ou une faille de sécurité réelle

Sévérité = sens réel. N'utilisez aucun autre type d'encadré, et jamais deux encadrés à la suite. Un approfondissement facultatif va dans « Pour aller plus loin », pas dans un encadré.

## Style

- Phrases courtes, paragraphes de 4 lignes maximum, un H2 toutes les 2 ou 3 idées.
- Gras réservé aux 1 ou 2 notions clés par section.
- Pas de remplissage, pas d'emojis, pas de conclusion qui répète l'article.
- Chiffres, limites et valeurs par défaut donnés précisément, avec leur source.
- Hiérarchie des titres stricte : H1 unique, puis H2, puis H3 (vérifié par `check`).

## Exactitude et vérifiabilité

- N'inventez aucune option, aucun flag, aucune API, aucun chiffre, aucun client, aucune expérience.
- En cas de doute, marquez le passage `[À VÉRIFIER]`. Ces marqueurs ne sont tolérés que dans un brouillon (`draft: true`) : chacun est aussi consigné comme tâche dans `private/backlog.md`, et l'article n'est publié qu'une fois tous résolus.
- Précisez les versions des outils pour chaque bloc de code et chaque comportement décrit.
- Toute affirmation non triviale est sourcée, par un lien vers la documentation officielle de préférence.
- Distinguez explicitement le fait documenté, la pratique courante et l'avis de l'auteur (à la première personne : « je recommande… »).
- Signalez ce qui est susceptible d'évoluer (fonctionnalité en preview, dépréciation annoncée).
- Aucun `TODO`, même en commentaire HTML (règle S5).

## Checklist avant de terminer

- [ ] Chaque objectif annoncé est couvert par une section ET par une question de l'auto-évaluation.
- [ ] Les verbes des objectifs correspondent au type d'article.
- [ ] Chaque concept présenté a une conséquence pratique explicite ; 7 concepts clés au maximum.
- [ ] L'aide-mémoire et la référence rapide sont utilisables sans lire le reste.
- [ ] Le cas fil conducteur est présent dans les sections 2, 5 et 7.
- [ ] Le code, s'il y en a, est cohérent d'un bloc à l'autre (noms, versions, chemins).
- [ ] Chaque affirmation chiffrée ou comportementale a une source ou un `[À VÉRIFIER]` consigné dans `private/backlog.md`.
- [ ] Les 10 sections H2 sont présentes, dans l'ordre, avec les titres correspondant au type.
- [ ] 3 encadrés au maximum, réponses comprises.
- [ ] Aucune métaphore filée, référence sportive ou ludique.
- [ ] Front-matter conforme, `description` de 70 à 160 caractères, `draft: true` conservé.
- [ ] `mise run check` passe.

## Compte rendu à l'opérateur

Après la phase 2, indiquez dans la conversation :

- le chemin du fichier créé ;
- les hypothèses retenues faute de réponse au questionnaire ;
- la liste des points marqués `[À VÉRIFIER]` ;
- 3 titres alternatifs, 1 accroche LinkedIn (300 caractères maximum) et 5 mots-clés.
