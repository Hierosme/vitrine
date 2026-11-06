---
date: 2026-07-03
authors:
  - jerome
categories:
  - "SRE : fiabilité & performance"
slug: competences-sre-2026
description: "Les sept familles de compétences d'un SRE en 2026, de l'objectif de service à Kubernetes : les distinguer, s'évaluer et choisir quoi travailler en premier."
serie: "Compétences SRE en 2026"
episode: 1
type: savoir-comprendre
niveau: confirmé
derniere_verification: 2026-07-03
---

Thème : :material-speedometer: [SRE : fiabilité & performance](../../services.md#sre)
{ .vt-post-service }

# SRE en 2026 : la pile de compétences à maîtriser

Sept familles de compétences font un Site Reliability Engineer, et aucune ne se résume à un outil. Cet article les définit, les distingue des notions voisines et vous aide à choisir celles à travailler en premier.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **distinguer** le SRE de l'exploitation classique et du DevOps ;
- **identifier** les sept familles de compétences d'un SRE en 2026 ;
- **évaluer** votre niveau, ou celui d'une équipe, sur chacune d'elles ;
- **choisir** les deux compétences à travailler en priorité selon votre contexte.

L'essentiel, pour qui ne lirait que ces lignes :

1. Le SRE traite l'exploitation comme un problème d'ingénierie logicielle, mesuré par des objectifs de service.
2. Les outils changent tous les deux ou trois ans ; les fondamentaux et les objectifs de service restent.
3. En 2026, Kubernetes et l'IA générative élargissent le terrain du SRE sans changer sa méthode.

## Contexte

Le titre de SRE s'est imposé dans les offres d'emploi bien au-delà des entreprises qui l'ont inventé. Il recouvre pourtant des réalités très différentes : une équipe d'astreinte renommée, une équipe plateforme qui maintient Kubernetes, ou une fonction qui négocie avec les développeurs le niveau de fiabilité d'un service. Ces trois postes ne demandent pas les mêmes compétences, et confondre les trois mène à des recrutements ratés comme à des parcours de formation sans fin.

La définition d'origine, donnée par Google dans *Site Reliability Engineering* (2016), est plus exigeante : confier l'exploitation à des ingénieurs qui la traitent comme un problème logiciel, avec un plafond de travail répétitif et des objectifs de fiabilité explicites. Dix ans plus tard, trois évolutions ont élargi le terrain. Kubernetes est devenu le socle d'exécution par défaut de nombreuses organisations. L'observabilité s'est normalisée autour d'OpenTelemetry. L'IA générative s'est invitée dans l'analyse d'incidents et l'écriture de code d'infrastructure, avec un coût qu'il faut piloter.

La question n'est donc plus « quels outils apprendre ? », mais « quelles compétences restent vraies quand les outils changent, et lesquelles faut-il ajouter en 2026 ? ».

## Concepts clés

Les sept familles s'empilent : chacune s'appuie sur celles du dessous. Un SRE peut être expert sur deux ou trois d'entre elles, mais il doit savoir lire les sept.

```text
 7. IA générative et ses coûts         outil de travail, à cadrer
 6. Orchestration et livraison          Kubernetes, Nomad, CI/CD, GitOps
 5. Automatisation et IaC               Terraform, Ansible, code relu
 4. Incidents et post-mortems           réagir, puis apprendre
 3. Observabilité                       métriques, journaux, traces
 2. Objectifs de service                SLI, SLO, budget d'erreur
 1. Fondamentaux systèmes et réseau     Linux, TCP/IP, DNS, stockage
```

### Fondamentaux systèmes et réseau

**Définition.** La compréhension de ce qui se passe sous l'abstraction : ordonnancement des processus, mémoire, entrées-sorties, pile TCP/IP, résolution DNS, TLS.

**À ne pas confondre avec** la maîtrise d'un outil d'administration : savoir lancer une commande n'est pas savoir expliquer ce qu'elle mesure.

**Exemple.** Une latence qui grimpe sans charge supplémentaire s'explique souvent par une résolution DNS lente ou un disque saturé, invisibles depuis le tableau de bord de l'application.

**En pratique.** C'est la famille qui raccourcit les diagnostics. Elle ne se périme pas.

### Objectifs de service (SLI, SLO, budget d'erreur)

**Définition.** Un SLI est une mesure de la qualité perçue par l'utilisateur (part des requêtes réussies, latence au 99e centile). Un SLO est la cible fixée sur cette mesure. Le budget d'erreur est l'écart toléré : avec un SLO de 99,9 % sur 30 jours, environ 43 minutes d'indisponibilité.

**À ne pas confondre avec** le SLA, engagement contractuel assorti de pénalités, ni avec un objectif de 100 %, que le livre SRE déconseille explicitement.

**Exemple.** Tant que le budget d'erreur n'est pas consommé, l'équipe livre ; quand il l'est, la priorité passe à la fiabilité.

**En pratique.** C'est la compétence qui transforme la fiabilité en décision partagée avec les développeurs et le métier.

### Observabilité

**Définition.** La capacité à répondre à une question nouvelle sur le comportement d'un système à partir de ses signaux : métriques, journaux et traces, que la spécification OpenTelemetry décrit comme des signaux distincts.

**À ne pas confondre avec** la supervision, qui vérifie des états connus à l'avance. On supervise ce qu'on sait pouvoir casser ; on observe pour comprendre ce qu'on n'avait pas prévu.

**Exemple.** Les quatre signaux dorés du livre SRE (latence, trafic, erreurs, saturation) suffisent à décrire la santé de la plupart des services.

**En pratique.** Instrumenter avec un standard ouvert évite de réécrire la collecte à chaque changement d'outil.

### Incidents et post-mortems

**Définition.** Une gestion d'incident structurée en rôles (coordination, opérations, communication), puis un post-mortem sans reproche qui cherche les causes dans le système plutôt que chez les personnes.

**À ne pas confondre avec** l'astreinte, qui n'est que le dispositif de réveil. Être joignable n'est pas savoir conduire un incident.

**Exemple.** Un post-mortem utile se termine par des actions correctives datées et suivies, pas par une liste de responsables.

**En pratique.** C'est la famille qui fait baisser le nombre d'incidents récurrents.

### Automatisation et Infrastructure as Code

**Définition.** Décrire l'infrastructure dans du code versionné et relu (Terraform pour les ressources, Ansible pour la configuration), et éliminer le travail répétitif, que le livre SRE appelle *toil* et propose de maintenir sous la moitié du temps d'un ingénieur.

**À ne pas confondre avec** l'écriture de scripts ponctuels : un script non versionné et non relu déplace le travail répétitif sans le supprimer.

**Exemple.** Un changement d'infrastructure passe par une revue de code, comme un changement applicatif.

**En pratique.** C'est la famille qui libère le temps nécessaire à toutes les autres.

### Orchestration et livraison

**Définition.** La maîtrise du socle d'exécution (Kubernetes le plus souvent, Nomad dans certains contextes) et de la chaîne qui y livre le logiciel, de la CI/CD classique au GitOps, où un agent applique en continu l'état décrit dans Git.

**À ne pas confondre avec** l'administration de clusters : un SRE n'a pas besoin de savoir reconstruire un plan de contrôle, mais il doit savoir pourquoi un déploiement n'a pas redémarré ses pods.

**Exemple.** Dans l'univers Kubernetes, la fiabilité se déclare : sondes de santé, demandes et limites de ressources, budgets d'interruption, mise à l'échelle automatique.

**En pratique.** Kubernetes ne rend pas un service fiable par défaut ; il exécute fidèlement ce qu'on lui déclare, y compris une déclaration incomplète.

### IA générative et ses coûts

**Définition.** L'usage d'assistants et d'agents fondés sur des modèles de langage pour analyser des journaux, rédiger un premier jet de post-mortem ou de code d'infrastructure, avec une relecture humaine systématique.

**À ne pas confondre avec** l'automatisation déterministe : un modèle de langage propose, il ne garantit pas. Ce qu'il produit se relit comme le code d'un collègue.

**Exemple.** Un agent qui résume les journaux d'un incident fait gagner du temps ; un agent qui applique seul une correction en production en fait perdre.

**En pratique.** Le SRE y ajoute une compétence nouvelle : estimer et suivre ce que coûte cette assistance, en tokens ou en heures de GPU.

## Référence rapide

| Famille | Définition courte | Ce que ça change en pratique | À ne pas confondre avec |
|---|---|---|---|
| Objectifs de service | Une cible mesurée sur ce que perçoit l'utilisateur | La fiabilité devient une décision partagée | SLA contractuel, objectif de 100 % |
| Fondamentaux | Ce qui se passe sous l'abstraction | Des diagnostics plus courts | La maîtrise d'un outil |
| Observabilité | Répondre à une question imprévue à partir des signaux | On comprend l'inconnu, pas seulement le connu | La supervision |
| Incidents | Rôles clairs, puis post-mortem sans reproche | Moins d'incidents récurrents | L'astreinte |
| Automatisation et IaC | Infrastructure décrite, versionnée, relue | Du temps libéré pour l'ingénierie | Les scripts ponctuels |
| Orchestration et livraison | Socle d'exécution et chaîne de livraison | Une fiabilité déclarée, pas supposée | L'administration de clusters |
| IA générative | Assistance relue, coûts suivis | Plus de vitesse, sous contrôle | L'automatisation déterministe |

### L'univers Kubernetes vu par un SRE

| Mécanisme | Rôle pour la fiabilité | Question à se poser |
|---|---|---|
| Sondes `livenessProbe`, `readinessProbe`, `startupProbe` | Redémarrer un conteneur bloqué, retirer du trafic un pod pas prêt, laisser démarrer un service lent | Chaque sonde teste-t-elle ce qu'elle prétend tester ? |
| Demandes et limites de ressources | Placement des pods et protection des voisins | Les valeurs viennent-elles d'une mesure ou d'une copie ? |
| `PodDisruptionBudget` | Garder un minimum de répliques pendant une maintenance | Une mise à jour des nœuds peut-elle couper le service ? |
| `HorizontalPodAutoscaler` | Ajuster le nombre de répliques à la charge | Sur quelle métrique, et avec quelle marge ? |
| Contrôleurs GitOps (Argo CD, Flux) | Réconcilier en continu le cluster avec Git | Qui peut modifier le cluster sans passer par Git ? |
| Cycle de versions | Trois versions par an, environ 14 mois de correctifs chacune | Le cluster est-il encore dans la fenêtre de support ? |

!!! note "Critère de décision"
    Pour choisir les deux familles à travailler en premier, partez de la dernière douleur réelle. Incidents récurrents : incidents et observabilité. Arbitrages sans fin entre livraison et stabilité : objectifs de service. Semaine absorbée par des tâches manuelles : automatisation. Migration vers Kubernetes en cours : orchestration, sans négliger les fondamentaux.

## Idées reçues

- **« Le SRE, c'est l'exploitation sous un autre nom. »** Le livre SRE fixe au contraire un plafond au travail répétitif, pour que le reste du temps aille à l'ingénierie. Une équipe qui ne fait que de l'exploitation n'a que le titre.
- **« L'objectif, c'est 100 % de disponibilité. »** Le livre SRE explique que 100 % est presque toujours la mauvaise cible : l'utilisateur ne perçoit pas la différence au-delà d'un certain seuil, et chaque neuf supplémentaire ralentit les livraisons. Viser 100 %, c'est ne jamais avoir de budget d'erreur pour livrer.
- **« Kubernetes rend les services fiables. »** Il redémarre, répartit et met à l'échelle selon ce qu'on lui déclare. Une sonde mal écrite ou des ressources copiées d'un autre service produisent des redémarrages en boucle, fiables eux aussi.
- **« Plus de tableaux de bord, c'est plus d'observabilité. »** Un tableau de bord répond à une question posée à l'avance. L'observabilité se mesure à la capacité de répondre à une question nouvelle.

## Aide-mémoire

- **SRE** : l'exploitation traitée comme un problème d'ingénierie logicielle.
- **SLI** : la mesure ; **SLO** : la cible ; **SLA** : le contrat ; **budget d'erreur** : 1 − SLO.
- **Toil** : travail manuel, répétitif, automatisable, sans valeur durable ; à garder sous la moitié du temps.
- **Quatre signaux dorés** : latence, trafic, erreurs, saturation.
- **Supervision** : états connus ; **observabilité** : questions nouvelles.
- **Post-mortem sans reproche** : des causes dans le système, des actions suivies.
- **Kubernetes** : la fiabilité se déclare (sondes, ressources, budgets d'interruption, mise à l'échelle).
- **GitOps** : état déclaré dans Git, appliqué et réconcilié en continu.
- **IA générative** : propose, ne décide pas ; relue, et coûts suivis.
- **Priorité** : partir de la dernière douleur réelle, puis de ce qui rend le reste mesurable.

## Pour aller plus loin

- [Objectifs de service : les définir, les mesurer, s'en servir](2026-07-10-objectifs-de-service.md), sur ce blog : SLI, SLO, budget d'erreur, mesure avec Prometheus et lien avec les métriques DORA.
- [*Site Reliability Engineering*](https://sre.google/sre-book/table-of-contents/), Google, en particulier les chapitres sur le risque, les objectifs de service, le travail répétitif, la supervision des systèmes distribués et la culture du post-mortem.
- [*The Site Reliability Workbook*](https://sre.google/workbook/table-of-contents/), Google : la mise en œuvre des mêmes principes.
- [Signaux OpenTelemetry](https://opentelemetry.io/docs/concepts/signals/) : métriques, journaux et traces.
- [Sondes Kubernetes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/) et [budgets d'interruption](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) : la documentation officielle.
- [Principes OpenGitOps](https://opengitops.dev/) : la définition partagée du GitOps.
- [Versions de Kubernetes](https://kubernetes.io/releases/) : calendrier et fenêtre de support.

Votre équipe porte le titre de SRE sans en avoir encore les pratiques ? [Parlons de la fiabilité de vos services](../../contact.md).
