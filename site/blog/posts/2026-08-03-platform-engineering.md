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

En trois points :

1. Une plateforme est un **produit** : ses utilisateurs sont les équipes de développement, son succès se mesure à leur adoption, et un **Product Owner** en porte la vision et les priorités.
2. Le **chemin balisé** est la voie recommandée, outillée de bout en bout ; on peut en sortir, à ses frais.
3. Commencez par la **plateforme la plus fine possible** : parfois une page de documentation et un modèle de dépôt suffisent.

## Contexte

Une équipe veut lancer un service. Il lui faut un dépôt, un pipeline, des environnements, des secrets, de la supervision, des règles de sécurité. Sans plateforme, elle ouvre une demande pour chaque élément, ou reconstruit tout elle-même, autrement que l'équipe voisine : la charge cognitive monte, la livraison ralentit, chaque service devient un cas particulier.

Le Platform Engineering regroupe ces besoins dans une plateforme interne en libre-service. L'idée s'est structurée avec le livre blanc et le modèle de maturité de la CNCF (Cloud Native Computing Foundation), et la recherche DORA l'étudie depuis 2024. En 2025, selon DORA, 90 % des organisations utilisent une plateforme interne et 76 % ont une équipe plateforme dédiée. Mais en 2024, DORA observait aussi qu'une plateforme peut réduire le débit et la stabilité des livraisons : sa qualité décide de son effet.

## Concepts clés

![Schéma en cinq couches. En haut, les équipes de développement, qui livrent en libre-service. Elles passent par les interfaces de la plateforme : portail, API et CLI, documentation. Ces interfaces exposent les chemins balisés, mis en valeur : modèle de service, puis pipeline CI/CD, puis environnements, la voie recommandée, outillée de bout en bout, jamais imposée. Les chemins balisés s'appuient sur les capacités de la plateforme : infrastructure as code (Terraform, Ansible), exécution (Kubernetes, Nomad), observabilité (SLO, traces) et sécurité (secrets, contrôles). En bas, l'infrastructure : cloud public, cloud privé ou datacenter.](../../assets/images/blog/platform-engineering-light.png#only-light)
![Schéma en cinq couches. En haut, les équipes de développement, qui livrent en libre-service. Elles passent par les interfaces de la plateforme : portail, API et CLI, documentation. Ces interfaces exposent les chemins balisés, mis en valeur : modèle de service, puis pipeline CI/CD, puis environnements, la voie recommandée, outillée de bout en bout, jamais imposée. Les chemins balisés s'appuient sur les capacités de la plateforme : infrastructure as code (Terraform, Ansible), exécution (Kubernetes, Nomad), observabilité (SLO, traces) et sécurité (secrets, contrôles). En bas, l'infrastructure : cloud public, cloud privé ou datacenter.](../../assets/images/blog/platform-engineering-dark.png#only-dark)

### Plateforme interne

Pour la CNCF, un ensemble intégré de capacités, définies et présentées selon les besoins de ses utilisateurs ; son livre blanc en recense treize domaines, des portails et API au stockage des artefacts. Le mot qui compte est « intégré » : dix outils séparés ne font pas une plateforme. Le test : créer un environnement de test en une commande, déjà relié à la supervision et aux secrets, sans rien demander à personne.

### Plateforme comme produit

Premier attribut retenu par la CNCF : la plateforme existe pour ses utilisateurs et évolue à partir de leurs besoins. Un projet se termine à la livraison ; un produit vit, avec une feuille de route, des retours et des mesures d'adoption. Si des équipes contournent la plateforme, c'est une information produit, pas un problème de discipline. Cette approche a un responsable, le Product Owner (voir la référence rapide).

### Équipe plateforme

Elle construit la plateforme pour les équipes alignées sur un flux de valeur métier, dans le vocabulaire de *Team Topologies*. Ce n'est pas une exploitation renommée qui traite des demandes : son travail est de les rendre inutiles, par exemple en publiant un module qui crée les bases de données plutôt que de les créer à la main. Sa réussite se mesure chez les autres : délai de livraison, autonomie, satisfaction.

### Chemin balisé

Le *golden path* de la CNCF : un parcours recommandé, fourni avec un modèle de projet et sa documentation, qui crée par exemple le dépôt, le pipeline, les environnements et l'entrée au catalogue. C'est la voie la plus simple, pas la seule autorisée. Une équipe peut en sortir pour un besoin réel, en prenant à sa charge ce que le chemin lui aurait apporté.

### Plateforme la plus fine possible

La *thinnest viable platform* de *Team Topologies* : la plus petite plateforme qui rende service, parfois une simple page wiki. C'est un point de départ qui grandit avec les besoins constatés, par exemple une page qui décrit comment créer et livrer un service, et un dépôt modèle qui l'applique. Pas de portail avant un chemin balisé réellement utilisé.

### Portail développeur

L'interface web qui rassemble catalogue des services, documentation et modèles ; Backstage, en incubation à la CNCF, est le plus connu. Ce n'est qu'une interface, à côté des API, des CLI et de la documentation. Un portail sans chemins balisés solides n'est qu'une vitrine ; un chemin balisé sans portail reste utilisable en ligne de commande.

### Maturité

Le modèle de la CNCF évalue cinq aspects (investissement, adoption, interfaces, opérations, mesure) sur quatre niveaux : provisoire, opérationnalisé, à l'échelle, optimisé. Pas de note globale : une équipe peut être « à l'échelle » sur les interfaces et « provisoire » sur la mesure. Travaillez d'abord l'aspect le plus faible.

## Référence rapide

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

C'est souvent le rôle qui manque, et celui qui décide de l'adoption. Sans lui, la plateforme répond aux besoins qu'imaginent ses ingénieurs, et se mesure à ce qui est livré plutôt qu'à ce qui est utilisé. Le modèle de maturité de la CNCF veut un investissement « comme un produit » et une adoption **demandée par les équipes** ; DORA rappelle qu'une plateforme peut ralentir la livraison. C'est au Product Owner de le voir, et d'arbitrer.

| Responsabilité | En pratique | Indicateur à suivre |
|---|---|---|
| Connaître les utilisateurs | Entretiens avec les équipes, observation d'un premier service livré de bout en bout, carte des frictions du parcours | Frictions identifiées et classées |
| Prioriser par la valeur | Un backlog ordonné sur les irritants les plus fréquents, pas sur la nouveauté technique | Délai pour livrer un premier service en production |
| Dire non | Refuser les capacités sans demande réelle ; préférer la plateforme la plus fine possible | Part des capacités livrées effectivement utilisées |
| Mesurer | Adoption de chaque chemin balisé, satisfaction des équipes, métriques DORA avant et après | Taux d'adoption, satisfaction, métriques DORA |
| Communiquer | Feuille de route visible, notes de version, documentation tenue à jour | Questions récurrentes au support de la plateforme |
| Gérer le cycle de vie | Dépréciations annoncées à l'avance, migrations accompagnées | Équipes encore sur une version dépréciée |

Il n'a pas besoin d'être le meilleur technicien de l'équipe, mais doit comprendre le métier de développeur et avoir le mandat de dire non.

### Un premier chemin balisé de livraison continue

| Étape | Ce que fournit la plateforme | Exemple d'outil |
|---|---|---|
| Créer le service | Modèle de dépôt : code de départ, tests, fichier de catalogue | Dépôt modèle, ou modèle de portail |
| Intégrer | Pipeline réutilisable : construction, tests, analyse de sécurité | Workflow CI partagé |
| Livrer | Déploiement identique pour chaque environnement | Pipeline poussé ou GitOps (Argo CD, Flux) |
| Exécuter | Environnement prêt : quotas, secrets, réseau | Kubernetes ou Nomad, provisionné par Terraform |
| Observer | Tableaux de bord et SLO par défaut | Stack d'observabilité commune |

### Outils open source : quatre approches

Un dépôt modèle et une page de documentation suffisent pour démarrer. Quand la plateforme grandit, quatre approches open source reviennent souvent, et se combinent plus qu'elles ne s'opposent.

| Approche | Projet | Ce qu'il apporte | Statut à la CNCF |
|---|---|---|---|
| Portail développeur | [Backstage](https://backstage.io/) | Catalogue des services, documentation, modèles de création de projets | En incubation depuis 2022 |
| Plan de contrôle d'infrastructure | [Crossplane](https://www.crossplane.io/) | Construire ses propres API de plateforme sur Kubernetes, « comme un fournisseur cloud » | Gradué en octobre 2025 |
| Modèle d'application | [KubeVela](https://kubevela.io/) | Décrire une application et la livrer sur plusieurs environnements, à partir du modèle OAM (*Open Application Model*) | En incubation depuis 2023 |
| Spécification de charge de travail | [Score](https://score.dev/) | Décrire une charge de travail une fois, indépendamment de la plateforme, puis la traduire pour Docker Compose ou Kubernetes | En bac à sable depuis 2024 |

Le portail est l'interface ; le plan de contrôle et le modèle d'application portent les capacités ; la spécification de charge de travail sépare ce que décrit le développeur de ce qu'exécute la plateforme.

!!! note "Critère de décision"
    Un portail se justifie quand plusieurs équipes créent régulièrement des services et que le catalogue devient difficile à tenir à jour à la main. Avant cela, un dépôt modèle et une page de documentation donnent le même chemin balisé, pour une fraction de l'effort.

## Erreurs fréquentes

### La plateforme est livrée, personne ne l'utilise

**Symptôme.** Des mois de construction, des équipes qui continuent comme avant. **Cause.** Un projet d'infrastructure, pas un produit. **Correction.** Un Product Owner identifié, des entretiens avec les équipes, un premier chemin balisé sur leur besoin le plus fréquent, l'adoption mesurée.

### Le portail est vide

**Symptôme.** Un catalogue à moitié rempli, des modèles qui ne marchent plus. **Cause.** Le portail a précédé les chemins balisés. **Correction.** D'abord un chemin balisé qui fonctionne de bout en bout, ensuite le portail.

### Les livraisons ralentissent après l'arrivée de la plateforme

**Symptôme.** Délai de livraison et taux d'échec des changements se dégradent. **Cause.** De nouvelles étapes, des abstractions mal comprises, des retours peu clairs en cas d'échec. **Correction.** Mesurez les métriques DORA avant et après, et soignez les messages de chaque étape.

### Le chemin balisé devient une obligation

**Symptôme.** Des équipes bloquées par un besoin non couvert. **Cause.** La voie recommandée est devenue la voie unique. **Correction.** Autorisez la sortie, documentez ce qu'elle implique, et faites des sorties fréquentes un signal pour la feuille de route.

## Aide-mémoire

- **Plateforme** : capacités intégrées, présentées selon les besoins des utilisateurs.
- **Comme un produit**, avec un **Product Owner** qui priorise par la valeur et sait dire non.
- **Équipe plateforme** : réussit quand les autres livrent plus vite et plus seules.
- **Chemin balisé** : la voie la plus simple, pas la seule.
- **Plus fine possible** : parfois une page et un dépôt modèle.
- **Portail** : après les chemins balisés, pas avant.
- **DORA** : gains de productivité, risque sur le débit ; 90 % ont une plateforme en 2025.
- **Premier chemin** : créer, intégrer, livrer, exécuter, observer.

## Pour aller plus loin

- [Objectifs de service](2026-07-10-objectifs-de-service.md) et [observabilité MELT](2026-07-17-observabilite-melt-grafana.md), sur ce blog : deux capacités à offrir en libre-service.
- [Livre blanc sur les plateformes](https://tag-app-delivery.cncf.io/whitepapers/platforms/) et [modèle de maturité](https://tag-app-delivery.cncf.io/whitepapers/platform-eng-maturity-model/), CNCF.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/), DORA.
- [*Thinnest viable platform*](https://teamtopologies.com/key-concepts-content/what-is-a-thinnest-viable-platform-tvp), *Team Topologies*.

Vos équipes réinventent leur chaîne de livraison à chaque service ? [Construisons votre premier chemin balisé](../../contact.md).

