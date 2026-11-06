---
date: 2026-08-03
authors:
  - jerome
categories:
  - "Continuous Delivery"
slug: platform-engineering
description: "Platform Engineering : plateforme interne, équipe plateforme, chemins balisés. Ce que c'est, ce que la recherche DORA en dit, et par où commencer."
type: mixte
niveau: confirmé
derniere_verification: 2026-11-06
---

Thème : :material-rocket-launch-outline: [Continuous Delivery](../../services.md#continuous-delivery)
{ .vt-post-service }

# Platform Engineering : livrer en libre-service, sans tout réinventer

Le Platform Engineering consiste à offrir aux équipes de développement une plateforme interne, pensée comme un produit, qui leur permet de livrer en libre-service. Cet article en définit les notions, rappelle ce que la recherche en dit, et propose un premier chemin balisé pour la livraison continue.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **distinguer** plateforme interne, portail développeur et équipe plateforme ;
- **expliquer** ce qu'est un chemin balisé et pourquoi il ne doit jamais être imposé ;
- **évaluer** la maturité d'une démarche plateforme avec le modèle de la CNCF ;
- **concevoir** un premier chemin balisé de livraison continue, du modèle de service au déploiement.

L'essentiel, pour qui ne lirait que ces lignes :

1. Une plateforme est un **produit** : ses utilisateurs sont les équipes de développement, son succès se mesure à leur adoption, et un **Product Owner** en porte la vision et les priorités.
2. Le **chemin balisé** est la voie recommandée, outillée de bout en bout ; on peut en sortir, à ses frais.
3. Commencez par la **plateforme la plus fine possible** : parfois une page de documentation et un modèle de dépôt suffisent.

## Contexte

Une équipe veut lancer un nouveau service. Il lui faut un dépôt, un pipeline d'intégration et de livraison, des environnements, des secrets, de la supervision, des règles de sécurité. Sans plateforme, elle ouvre une demande pour chaque élément, attend, ou reconstruit tout elle-même, autrement que l'équipe voisine. La charge cognitive monte, la livraison ralentit, et chaque service devient un cas particulier à exploiter.

Le Platform Engineering répond à cette situation en regroupant ces besoins dans une plateforme interne, utilisable en libre-service. L'idée n'est pas neuve, mais elle s'est structurée : la CNCF (Cloud Native Computing Foundation) a publié un livre blanc sur les plateformes et un modèle de maturité, et la recherche DORA l'étudie depuis 2024. Selon la page que DORA consacre à cette capacité, 90 % des organisations interrogées en 2025 utilisent une plateforme interne de développement, et 76 % disposent d'une équipe plateforme dédiée.

La même recherche apporte une nuance utile : en 2024, DORA observe que la plateforme améliore la productivité individuelle et la performance des équipes, mais peut aussi réduire le débit de livraison et la stabilité des changements. Une plateforme n'est donc pas un gain automatique : sa qualité décide de son effet, ce que confirme le constat de 2025 sur l'IA (voir plus bas).

## Concepts clés

![Schéma en cinq couches. En haut, les équipes de développement, qui livrent en libre-service. Elles passent par les interfaces de la plateforme : portail, API et CLI, documentation. Ces interfaces exposent les chemins balisés, mis en valeur : modèle de service, puis pipeline CI/CD, puis environnements, la voie recommandée, outillée de bout en bout, jamais imposée. Les chemins balisés s'appuient sur les capacités de la plateforme : infrastructure as code (Terraform, Ansible), exécution (Kubernetes, Nomad), observabilité (SLO, traces) et sécurité (secrets, contrôles). En bas, l'infrastructure : cloud public, cloud privé ou datacenter.](../../assets/images/blog/platform-engineering-light.png#only-light)
![Schéma en cinq couches. En haut, les équipes de développement, qui livrent en libre-service. Elles passent par les interfaces de la plateforme : portail, API et CLI, documentation. Ces interfaces exposent les chemins balisés, mis en valeur : modèle de service, puis pipeline CI/CD, puis environnements, la voie recommandée, outillée de bout en bout, jamais imposée. Les chemins balisés s'appuient sur les capacités de la plateforme : infrastructure as code (Terraform, Ansible), exécution (Kubernetes, Nomad), observabilité (SLO, traces) et sécurité (secrets, contrôles). En bas, l'infrastructure : cloud public, cloud privé ou datacenter.](../../assets/images/blog/platform-engineering-dark.png#only-dark)

### Plateforme interne

**Définition.** Selon le livre blanc de la CNCF, une plateforme est un ensemble intégré de capacités, définies et présentées selon les besoins de ses utilisateurs. Le livre blanc en recense treize domaines, des portails web et des API jusqu'au stockage des artefacts, en passant par les modèles de chemins balisés, l'automatisation de la livraison, l'observabilité, les secrets et la sécurité.

**À ne pas confondre avec** un empilement d'outils : une plateforme intègre et présente ses capacités de façon cohérente ; dix outils accessibles séparément n'en font pas une.

**Exemple.** Créer un environnement de test en un clic ou une commande, déjà relié à la supervision et aux secrets.

**En pratique.** Chaque capacité exposée doit être utilisable sans ouvrir de demande à l'équipe plateforme.

### Plateforme comme produit

**Définition.** Une plateforme existe pour servir les besoins de ses utilisateurs ; elle se conçoit et évolue à partir de ces besoins, comme n'importe quel produit logiciel. C'est le premier attribut retenu par la CNCF.

**À ne pas confondre avec** un projet d'infrastructure : un projet se termine à la livraison ; un produit a une feuille de route, des utilisateurs, des retours et des mesures d'adoption.

**Exemple.** L'équipe plateforme interroge les équipes de développement, mesure le temps nécessaire pour livrer un premier service, et priorise ce qui le réduit.

**En pratique.** Si les équipes contournent la plateforme, c'est une information produit, pas un problème de discipline. Cette approche a un responsable : le Product Owner de la plateforme (voir la référence rapide).

### Équipe plateforme

**Définition.** L'équipe qui construit et fait évoluer la plateforme, au service des équipes alignées sur un flux de valeur métier, selon le vocabulaire de *Team Topologies*.

**À ne pas confondre avec** une équipe d'exploitation renommée, qui traiterait des demandes une à une : l'équipe plateforme réduit le nombre de demandes en les rendant inutiles.

**Exemple.** Plutôt que de créer chaque base de données à la main, l'équipe plateforme publie un module qui le fait, documenté et testé.

**En pratique.** Sa réussite se mesure chez les autres : délai de livraison, autonomie et satisfaction des équipes utilisatrices.

### Chemin balisé

**Définition.** Un parcours de travail recommandé, fourni avec un modèle de projet initial et sa documentation ; la CNCF parle de *golden path*.

**À ne pas confondre avec** une contrainte : le chemin balisé est la voie la plus simple, pas la seule autorisée.

**Exemple.** Un modèle de service qui crée le dépôt, le pipeline CI/CD, les environnements et l'inscription au catalogue des services.

**En pratique.** Une équipe peut en sortir pour un besoin réel, mais elle prend alors en charge ce que le chemin balisé lui aurait apporté.

### Plateforme la plus fine possible

**Définition.** Le principe de la *thinnest viable platform* de *Team Topologies* : la plus petite plateforme qui rende service. Ses auteurs rappellent qu'elle peut n'être qu'une page wiki, si cela suffit.

**À ne pas confondre avec** une plateforme au rabais : c'est un point de départ, qui grandit avec les besoins constatés.

**Exemple.** Une page qui documente la manière recommandée de créer et de livrer un service, et un modèle de dépôt qui l'applique.

**En pratique.** Ne construisez pas de portail avant d'avoir un chemin balisé que des équipes utilisent.

### Portail développeur

**Définition.** L'interface web qui rassemble le catalogue des services, la documentation et les modèles, comme Backstage, projet en incubation à la CNCF.

**À ne pas confondre avec** la plateforme elle-même : le portail est une interface parmi d'autres, avec les API, les CLI et la documentation.

**Exemple.** Un formulaire du portail qui crée un nouveau service à partir d'un modèle, quel que soit l'outil retenu.

**En pratique.** Un portail sans chemins balisés solides n'est qu'une vitrine ; un chemin balisé sans portail reste utilisable en ligne de commande.

### Maturité

**Définition.** Le modèle de maturité de la CNCF évalue une démarche plateforme sur cinq aspects (investissement, adoption, interfaces, opérations, mesure) et quatre niveaux : provisoire, opérationnalisé, à l'échelle, optimisé.

**À ne pas confondre avec** une note globale : le modèle précise qu'il ne sert pas à classer une organisation entière à un seul niveau.

**Exemple.** Une équipe peut être au niveau « à l'échelle » sur les interfaces (libre-service) et « provisoire » sur la mesure.

**En pratique.** Choisissez l'aspect le plus faible et travaillez-le en premier.

## Référence rapide

### Concepts

| Concept | Définition courte | Ce que ça change en pratique | À ne pas confondre avec |
|---|---|---|---|
| Plateforme interne | Capacités intégrées, présentées selon les besoins des utilisateurs | Livraison en libre-service | Un empilement d'outils |
| Plateforme comme produit | Conçue et mesurée à partir des besoins de ses utilisateurs | Feuille de route, retours, adoption | Un projet d'infrastructure |
| Équipe plateforme | Construit la plateforme pour les équipes métier | Moins de demandes, plus d'autonomie | Une exploitation renommée |
| Chemin balisé | Voie recommandée, outillée de bout en bout | La bonne pratique devient la plus simple | Une contrainte |
| Plateforme la plus fine possible | La plus petite plateforme qui rende service | Commencer petit, grandir sur les besoins | Une plateforme au rabais |
| Portail développeur | Catalogue, documentation, modèles | Une interface, pas la plateforme | La plateforme elle-même |
| Maturité | Cinq aspects, quatre niveaux | Progresser aspect par aspect | Une note globale |

### Modèle de maturité de la CNCF

| Aspect | Provisoire | Opérationnalisé | À l'échelle | Optimisé |
|---|---|---|---|---|
| Investissement | Volontaire ou temporaire | Équipe dédiée | Comme un produit | Écosystème outillé |
| Adoption | Erratique | Poussée de l'extérieur | Demandée par les équipes | Participative |
| Interfaces | Processus sur mesure | Outillage standard | Libre-service | Services intégrés |
| Opérations | À la demande | Suivi centralisé | Mises en œuvre centralement | Services gérés |
| Mesure | Ponctuelle | Collecte régulière | Analyses | Quantitative et qualitative |

### Ce que dit la recherche DORA

| Constat | Année | Ce que ça implique |
|---|---|---|
| La plateforme améliore la productivité individuelle, la performance des équipes et celle de l'organisation | 2024 | L'investissement se justifie |
| Elle peut aussi réduire la stabilité des changements et le débit de livraison | 2024 | Mesurez la livraison avant et après, avec les métriques DORA |
| 90 % des organisations utilisent une plateforme interne, 76 % ont une équipe plateforme | 2025 | La question n'est plus « faut-il », mais « laquelle, et de quelle qualité » |
| Quand la plateforme est de bonne qualité, l'adoption de l'IA a un effet nettement positif sur la performance ; sinon, un effet négligeable | 2025 | La plateforme conditionne le retour sur investissement de l'IA |
| La capacité la plus liée à une bonne expérience : un retour clair sur le résultat de chaque tâche | 2025 | Soignez les messages des pipelines et des outils en libre-service |

### L'approche produit : le rôle du Product Owner de plateforme

C'est souvent le rôle qui manque, et celui qui décide de l'adoption. Sans lui, une plateforme est construite par des ingénieurs d'infrastructure, pour les besoins qu'ils imaginent, et mesurée à ce qui a été livré plutôt qu'à ce qui est utilisé. Le modèle de maturité de la CNCF le traduit dans ses deux premiers aspects : l'investissement passe « comme un produit », et l'adoption, d'abord poussée de l'extérieur, doit devenir **demandée par les équipes**. DORA rappelle de son côté qu'une plateforme peut ralentir la livraison : c'est au Product Owner de le voir, et d'arbitrer.

| Responsabilité | En pratique | Indicateur à suivre |
|---|---|---|
| Connaître les utilisateurs | Entretiens avec les équipes, observation d'un premier service livré de bout en bout, carte des frictions du parcours | Frictions identifiées et classées |
| Prioriser par la valeur | Un backlog ordonné sur les irritants les plus fréquents, pas sur la nouveauté technique | Délai pour livrer un premier service en production |
| Dire non | Refuser les capacités sans demande réelle ; préférer la plateforme la plus fine possible | Part des capacités livrées effectivement utilisées |
| Mesurer | Adoption de chaque chemin balisé, satisfaction des équipes, métriques DORA avant et après | Taux d'adoption, satisfaction, métriques DORA |
| Communiquer | Feuille de route visible, notes de version, documentation tenue à jour | Questions récurrentes au support de la plateforme |
| Gérer le cycle de vie | Dépréciations annoncées à l'avance, migrations accompagnées | Équipes encore sur une version dépréciée |

Le Product Owner de plateforme n'a pas besoin d'être le meilleur technicien de l'équipe ; il doit en revanche comprendre assez le métier de développeur pour juger ce qui fait gagner du temps, et avoir le mandat de dire non.

### Un premier chemin balisé de livraison continue

| Étape | Ce que fournit la plateforme | Exemple d'outil |
|---|---|---|
| Créer le service | Modèle de dépôt : code de départ, tests, fichier de catalogue | Dépôt modèle, ou modèle de portail |
| Intégrer | Pipeline réutilisable : construction, tests, analyse de sécurité | Workflow CI partagé |
| Livrer | Déploiement identique pour chaque environnement | Pipeline poussé ou GitOps (Argo CD, Flux) |
| Exécuter | Environnement prêt : quotas, secrets, réseau | Kubernetes ou Nomad, provisionné par Terraform |
| Observer | Tableaux de bord et SLO par défaut | Stack d'observabilité commune |

### Outils open source : quatre approches

Aucun outil n'est nécessaire pour démarrer : un dépôt modèle et une page de documentation forment déjà un chemin balisé. Quand la plateforme grandit, quatre approches open source reviennent souvent ; elles se combinent plus qu'elles ne s'opposent.

| Approche | Projet | Ce qu'il apporte | Statut à la CNCF |
|---|---|---|---|
| Portail développeur | [Backstage](https://backstage.io/) | Catalogue des services, documentation, modèles de création de projets | En incubation depuis 2022 |
| Plan de contrôle d'infrastructure | [Crossplane](https://www.crossplane.io/) | Construire ses propres API de plateforme sur Kubernetes, « comme un fournisseur cloud » | Gradué en octobre 2025 |
| Modèle d'application | [KubeVela](https://kubevela.io/) | Décrire une application et la livrer sur plusieurs environnements, à partir du modèle OAM (*Open Application Model*) | En incubation depuis 2023 |
| Spécification de charge de travail | [Score](https://score.dev/) | Décrire une charge de travail une fois, indépendamment de la plateforme, puis la traduire pour Docker Compose ou Kubernetes | En bac à sable depuis 2024 |

1. Le **portail** est l'interface des développeurs ; il ne remplace ni les chemins balisés ni les capacités qu'il expose.
2. Le **plan de contrôle** et le **modèle d'application** portent les capacités : ce que le libre-service crée réellement.
3. La **spécification de charge de travail** sépare ce que le développeur décrit de la façon dont la plateforme l'exécute.

!!! note "Critère de décision"
    Un portail se justifie quand plusieurs équipes créent régulièrement des services et que le catalogue devient difficile à tenir à jour à la main. Avant cela, un dépôt modèle et une page de documentation donnent le même chemin balisé, pour une fraction de l'effort.

## Erreurs fréquentes

### La plateforme est livrée, personne ne l'utilise

**Symptôme.** Des mois de construction, puis des équipes qui continuent comme avant.

**Cause.** La plateforme a été conçue comme un projet d'infrastructure, sans partir des besoins des équipes.

**Correction.** Traitez-la comme un produit, avec un Product Owner identifié : entretiens avec les équipes, premier chemin balisé sur leur besoin le plus fréquent, mesure de l'adoption.

### Le portail est vide

**Symptôme.** Un portail installé, un catalogue à moitié rempli, des modèles qui ne marchent plus.

**Cause.** Le portail a précédé les chemins balisés qu'il devait exposer.

**Correction.** Construisez d'abord un chemin balisé qui fonctionne de bout en bout, puis exposez-le dans le portail.

### Les livraisons ralentissent après l'arrivée de la plateforme

**Symptôme.** Le délai de livraison et le taux d'échec des changements se dégradent.

**Cause.** Un effet que DORA observe aussi en 2024 : nouvelles étapes, abstractions mal comprises, retours peu clairs quand une tâche échoue.

**Correction.** Mesurez les métriques DORA avant et après, et soignez les messages d'erreur et de résultat de chaque étape.

### Le chemin balisé devient une obligation

**Symptôme.** Des équipes bloquées par un besoin que le chemin balisé ne couvre pas.

**Cause.** La voie recommandée a été transformée en voie unique.

**Correction.** Autorisez la sortie du chemin, documentez ce qu'elle implique, et faites des sorties fréquentes un signal pour la feuille de route.

## Aide-mémoire

- **Plateforme** : capacités intégrées, présentées selon les besoins des utilisateurs (CNCF).
- **Comme un produit** : utilisateurs, feuille de route, retours, adoption mesurée.
- **Product Owner** : connaît les équipes, priorise par la valeur, dit non, mesure l'adoption.
- **Équipe plateforme** : réussit quand les autres équipes livrent plus vite et plus seules.
- **Chemin balisé** : la voie la plus simple, pas la seule.
- **Plateforme la plus fine possible** : parfois une page de documentation et un dépôt modèle.
- **Portail** : une interface, après les chemins balisés, pas avant.
- **Maturité CNCF** : investissement, adoption, interfaces, opérations, mesure ; quatre niveaux.
- **DORA 2024** : plus de productivité, mais attention au débit et à la stabilité.
- **DORA 2025** : 90 % ont une plateforme ; sa qualité conditionne l'effet de l'IA.
- **Premier chemin** : créer, intégrer, livrer, exécuter, observer.

## Pour aller plus loin

- [Objectifs de service : les définir, les mesurer, s'en servir](2026-07-10-objectifs-de-service.md), sur ce blog : les SLO qu'une plateforme peut fournir par défaut, et le lien avec les métriques DORA.
- [Observabilité MELT : quatre signaux, une stack Grafana](2026-07-17-observabilite-melt-grafana.md), sur ce blog : une capacité d'observabilité à offrir en libre-service.
- [Livre blanc sur les plateformes](https://tag-app-delivery.cncf.io/whitepapers/platforms/) et [modèle de maturité du Platform Engineering](https://tag-app-delivery.cncf.io/whitepapers/platform-eng-maturity-model/), CNCF.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/), DORA : la capacité et les constats de recherche.
- [*Thinnest viable platform*](https://teamtopologies.com/key-concepts-content/what-is-a-thinnest-viable-platform-tvp), *Team Topologies*.
- Projets cités : [Backstage](https://backstage.io/), [Crossplane](https://www.crossplane.io/), [KubeVela](https://kubevela.io/) et [Score](https://score.dev/) ; leur statut sur [la liste des projets de la CNCF](https://www.cncf.io/projects/).

Vos équipes réinventent leur chaîne de livraison à chaque service ? [Construisons votre premier chemin balisé](../../contact.md).
