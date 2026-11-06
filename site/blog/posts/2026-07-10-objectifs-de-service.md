---
date: 2026-07-10
authors:
  - jerome
categories:
  - "SRE : fiabilité & performance"
slug: objectifs-de-service-slo
description: "SLI, SLO, budget d'erreur : ce que sont les objectifs de service, comment les mesurer avec Prometheus et pourquoi ils complètent les métriques DORA."
serie: "Compétences SRE en 2026"
episode: 2
type: mixte
niveau: confirmé
versions_testees: ["promtool 2.45 (Prometheus)"]
derniere_verification: 2026-11-06
---

Thème : :material-speedometer: [SRE : fiabilité & performance](../../services.md#sre)
{ .vt-post-service }

# Objectifs de service : les définir, les mesurer, s'en servir

Un objectif de service transforme « le service est-il fiable ? » en une question à laquelle on répond par un chiffre et une décision. Cet article définit SLI, SLO et budget d'erreur, montre comment les mesurer avec Prometheus et les relie aux métriques DORA.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **distinguer** SLI, SLO, SLA et budget d'erreur ;
- **choisir** les SLI d'un service à partir de ce que vivent ses utilisateurs ;
- **calculer** un budget d'erreur et son taux de consommation sur une fenêtre donnée ;
- **mettre en place** la mesure et une alerte sur la consommation du budget, avec Prometheus.

L'essentiel, pour qui ne lirait que ces lignes :

1. Un SLO se mesure du point de vue de l'utilisateur, jamais de celui du serveur.
2. Le budget d'erreur, c'est ce que le SLO autorise à rater : il se dépense en livraisons et en incidents.
3. On alerte sur la vitesse de consommation du budget, pas sur un taux d'erreur instantané.

## Contexte

« Quelle est notre fiabilité ? » La question arrive souvent après un incident, posée par un responsable métier. Les réponses habituelles ne l'aident pas : un taux de disponibilité des serveurs à 99,98 %, alors que les utilisateurs ont vu des erreurs pendant une heure, ou une capture de tableau de bord que personne ne sait lire.

Les objectifs de service répondent à trois besoins. **Mesurer ce que vit l'utilisateur**, et non l'état des machines. **Fixer un niveau de fiabilité suffisant**, et non maximal : chaque neuf supplémentaire coûte en infrastructure, en astreinte et en vitesse de livraison. **Arbitrer** entre livrer et stabiliser à partir d'un chiffre partagé, plutôt qu'au gré du dernier incident.

C'est là que les objectifs de service rejoignent les métriques **DORA**, qui mesurent la performance de livraison logicielle : fréquence de déploiement, délai des changements, taux d'échec des changements, temps de rétablissement après un déploiement raté et, depuis 2024, taux de déploiements de reprise. DORA dit à quelle vitesse et avec quelle stabilité une équipe livre ; le SLO dit si ce qu'elle livre tient sa promesse auprès des utilisateurs. Les deux se lisent ensemble : une équipe peut livrer vite et souvent tout en épuisant son budget d'erreur, et c'est précisément ce que le SLO rend visible.

## Concepts clés

![Schéma : les requêtes des utilisateurs donnent le SLI (part des requêtes réussies), sur lequel porte le SLO (99,9 % sur 30 jours glissants). Le budget d'erreur (0,1 % des requêtes du mois) est consommé par les incidents et les livraisons ratées ; son taux de consommation déclenche les alertes, qui mènent à la politique de budget : livrer ou stabiliser.](../../assets/images/blog/slo-concepts-light.png#only-light)
![Schéma : les requêtes des utilisateurs donnent le SLI (part des requêtes réussies), sur lequel porte le SLO (99,9 % sur 30 jours glissants). Le budget d'erreur (0,1 % des requêtes du mois) est consommé par les incidents et les livraisons ratées ; son taux de consommation déclenche les alertes, qui mènent à la politique de budget : livrer ou stabiliser.](../../assets/images/blog/slo-concepts-dark.png#only-dark)

### SLI, l'indicateur

**Définition.** Un SLI (*Service Level Indicator*) est un ratio : les événements « bons » divisés par les événements valides. Par exemple, les requêtes servies sans erreur 5xx divisées par toutes les requêtes.

**À ne pas confondre avec** une métrique technique (CPU, mémoire, nombre de pods) : ces métriques expliquent une panne, elles ne disent pas si l'utilisateur la subit.

**Exemple.** Le *SRE Workbook* range les SLI par type de service : disponibilité, latence et qualité pour un service à requêtes ; fraîcheur, exactitude et couverture pour un traitement de données ; durabilité pour du stockage.

**En pratique.** Distinguez la **spécification** (« part des pages d'accueil chargées en moins de 300 ms ») de l'**implémentation** (où et comment on la mesure : journaux de l'application, répartiteur de charge, sonde externe, navigateur). Une même spécification peut avoir plusieurs implémentations, plus ou moins proches de l'utilisateur.

### SLO, l'objectif

**Définition.** Un SLO (*Service Level Objective*) est la cible fixée sur un SLI, sur une fenêtre de temps : « 99,9 % des requêtes réussies sur 30 jours glissants ».

**À ne pas confondre avec** le SLA (*Service Level Agreement*), engagement contractuel assorti de pénalités. Le SLO est interne et plus exigeant que le SLA, pour laisser une marge avant la pénalité.

**Exemple.** Le livre SRE de Google déconseille de viser 100 % : au-delà d'un certain seuil, l'utilisateur ne perçoit plus la différence, car sa propre connexion est moins fiable que le service.

**En pratique.** Deux ou trois SLO par service suffisent, sur les parcours qui comptent : se connecter, payer, consulter.

### Budget d'erreur

**Définition.** Le budget d'erreur est le complément du SLO : 1 − SLO. Avec un SLO de 99,9 %, 0,1 % des requêtes du mois peuvent échouer.

**À ne pas confondre avec** une tolérance aux pannes : c'est une ressource à dépenser, pas une limite à ne jamais approcher.

**Exemple.** Un service qui reçoit 1 000 requêtes par minute en reçoit 43,2 millions en 30 jours : le budget est de 43 200 requêtes en échec. En temps, 0,1 % de 30 jours représente environ 43 minutes d'indisponibilité totale.

**En pratique.** Le budget restant décide : tant qu'il en reste, l'équipe livre ; quand il est épuisé, la priorité passe à la fiabilité.

### Fenêtre glissante ou calendaire

**Définition.** Une fenêtre glissante couvre toujours les N derniers jours ; une fenêtre calendaire repart de zéro au début de chaque mois ou trimestre.

**À ne pas confondre avec** la période de rapport : on peut mesurer en glissant et rendre compte au mois.

**Exemple.** Avec une fenêtre calendaire, un incident du 30 est « oublié » le 1er ; avec une fenêtre glissante, il pèse pendant 30 jours.

**En pratique.** Le *SRE Workbook* recommande une fenêtre glissante, plus proche de ce que retiennent les utilisateurs.

### Taux de consommation

**Définition.** Le taux de consommation (*burn rate*) est la vitesse à laquelle le budget se dépense, rapportée à la vitesse qui l'épuiserait exactement en fin de fenêtre. Un taux de 1 épuise le budget en 30 jours ; un taux de 14,4 l'épuise en un peu plus de deux jours.

**À ne pas confondre avec** le taux d'erreur : 2 % d'erreurs, c'est un taux de consommation de 20 pour un SLO à 99,9 %, mais de 2 pour un SLO à 99 %.

**Exemple.** Un taux de 14,4 maintenu pendant une heure consomme 2 % du budget mensuel (14,4 ÷ 720 heures).

**En pratique.** C'est la base des alertes : on réveille quelqu'un quand le budget fond vite, pas à chaque pic d'erreurs.

### Politique de budget d'erreur

**Définition.** Un document court, validé par le produit, le développement et l'exploitation, qui dit ce qui se passe quand le budget est épuisé : gel des fonctionnalités, priorité aux correctifs, post-mortem obligatoire au-delà d'un seuil.

**À ne pas confondre avec** une sanction : la politique protège l'équipe des arbitrages au cas par cas.

**Exemple.** « Si le budget sur 30 jours est épuisé, seuls les correctifs et les changements de fiabilité sont déployés jusqu'à ce que le SLO soit de nouveau tenu. »

**En pratique.** Sans politique écrite, un SLO est un indicateur de plus ; avec elle, il devient un outil de décision.

## Référence rapide

### Concepts

| Concept | Définition courte | Ce que ça change en pratique | À ne pas confondre avec |
|---|---|---|---|
| SLI | Événements bons ÷ événements valides | On mesure ce que vit l'utilisateur | Une métrique technique (CPU, mémoire) |
| SLO | Cible sur un SLI, sur une fenêtre | Un niveau de fiabilité suffisant et partagé | Le SLA contractuel |
| Budget d'erreur | 1 − SLO | Arbitre entre livrer et stabiliser | Une tolérance à ne jamais approcher |
| Taux de consommation | Vitesse de dépense du budget, 1 = épuisé en fin de fenêtre | Des alertes sur l'essentiel | Le taux d'erreur brut |
| Fenêtre glissante | Les N derniers jours | L'incident pèse tant qu'il est récent | La période de rapport |
| Politique de budget | Ce qui se passe quand le budget est épuisé | Le SLO devient une décision | Une sanction |

### SLO et métriques DORA

| Question | Répondue par | Exemple |
|---|---|---|
| Livrons-nous vite ? | DORA : fréquence de déploiement, délai des changements | Plusieurs déploiements par jour |
| Nos livraisons sont-elles stables ? | DORA : taux d'échec des changements, taux de déploiements de reprise | 5 % des déploiements demandent une intervention |
| Récupérons-nous vite d'un déploiement raté ? | DORA : temps de rétablissement après un déploiement raté | Retour arrière en 10 minutes |
| Les utilisateurs obtiennent-ils ce qui est promis ? | SLO et budget d'erreur | 99,9 % de requêtes réussies sur 30 jours |
| Pouvons-nous continuer à livrer à ce rythme ? | Budget d'erreur restant | Budget consommé à 40 % au 20e jour |

### Choisir l'alerte (SLO de 99,9 % sur 30 jours)

Valeurs recommandées par le *SRE Workbook* (chapitre *Alerting on SLOs*) : une alerte se déclenche quand la fenêtre longue **et** une fenêtre courte, égale à un douzième de la longue, dépassent le seuil.

| Budget consommé | Fenêtre longue | Fenêtre courte | Taux de consommation | Seuil d'erreurs | Action |
|---|---|---|---|---|---|
| 2 % | 1 h | 5 min | 14,4 | 1,44 % | Réveiller l'astreinte |
| 5 % | 6 h | 30 min | 6 | 0,6 % | Réveiller l'astreinte |
| 10 % | 3 jours | 6 h | 1 | 0,1 % | Ticket |

!!! note "Critère de décision"
    La fenêtre courte évite qu'une alerte reste active longtemps après la fin du problème : la fenêtre longue garde la mémoire d'un incident, la courte confirme qu'il est toujours en cours.

### Mesure avec Prometheus

Règles d'enregistrement et d'alerte pour un SLI de disponibilité (part des réponses non 5xx) d'un service `api` instrumenté avec un compteur `http_requests_total`. Elles ont été validées avec `promtool check rules` et un test unitaire `promtool test rules`, sous promtool 2.45.

```yaml
groups:
  - name: slo-api-disponibilite
    rules:
      # SLI : part des requêtes en erreur (5xx), sur plusieurs fenêtres
      - record: job:slo_errors_per_request:ratio_rate5m
        expr: |
          sum by (job) (rate(http_requests_total{job="api", code=~"5.."}[5m]))
          /
          sum by (job) (rate(http_requests_total{job="api"}[5m]))
      - record: job:slo_errors_per_request:ratio_rate30m
        expr: |
          sum by (job) (rate(http_requests_total{job="api", code=~"5.."}[30m]))
          /
          sum by (job) (rate(http_requests_total{job="api"}[30m]))
      - record: job:slo_errors_per_request:ratio_rate1h
        expr: |
          sum by (job) (rate(http_requests_total{job="api", code=~"5.."}[1h]))
          /
          sum by (job) (rate(http_requests_total{job="api"}[1h]))
      - record: job:slo_errors_per_request:ratio_rate6h
        expr: |
          sum by (job) (rate(http_requests_total{job="api", code=~"5.."}[6h]))
          /
          sum by (job) (rate(http_requests_total{job="api"}[6h]))

      # SLO 99,9 % : budget d'erreur = 0,1 % des requêtes
      # Consommation rapide : 2 % du budget mensuel en 1 h (taux de consommation 14,4)
      - alert: BudgetErreurConsommationRapide
        expr: |
          job:slo_errors_per_request:ratio_rate1h > (14.4 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate5m > (14.4 * 0.001)
        labels:
          severity: page
      # Consommation soutenue : 5 % du budget mensuel en 6 h (taux de consommation 6)
      - alert: BudgetErreurConsommationSoutenue
        expr: |
          job:slo_errors_per_request:ratio_rate6h > (6 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate30m > (6 * 0.001)
        labels:
          severity: page
```

1. Les règles d'enregistrement calculent le ratio une fois par fenêtre : les alertes et les tableaux de bord réutilisent le même calcul.
2. `sum by (job)` agrège toutes les instances : le SLI porte sur le service, pas sur un pod.
3. Le seuil est le taux de consommation multiplié par le budget (0,001 pour 99,9 %).
4. Le test unitaire injecte 2 % d'erreurs pendant une heure : l'alerte rapide se déclenche ; avec 0,05 % d'erreurs, aucune alerte.

Dans Kubernetes, le compteur peut venir de l'application elle-même ou du point d'entrée du cluster (contrôleur d'entrée ou passerelle). Le point d'entrée est plus proche de l'utilisateur ; l'application voit le détail des parcours. Une sonde externe complète les deux pour les pannes qui empêchent toute requête d'arriver.

## Erreurs fréquentes

### Le SLO est tenu, les utilisateurs se plaignent

**Symptôme.** Le tableau de bord affiche 99,95 % de réussite, le support reçoit des plaintes de lenteur.

**Cause.** Le SLI ne mesure que la disponibilité, ou la latence est mesurée en moyenne : la moyenne masque les requêtes lentes.

**Correction.** Ajoutez un SLI de latence exprimé en part des requêtes sous un seuil (« 99 % en moins de 300 ms »), mesuré au plus près de l'utilisateur.

### L'alerte réveille l'astreinte pour un pic de deux minutes

**Symptôme.** Des pages nocturnes qui se résolvent seules avant que quiconque intervienne.

**Cause.** L'alerte compare le taux d'erreur instantané au budget, sans notion de vitesse ni de durée.

**Correction.** Alertez sur le taux de consommation, avec une fenêtre longue et une fenêtre courte (tableau ci-dessus).

### Aucune alerte quand le service ne reçoit plus de trafic

**Symptôme.** Le service est inaccessible pendant la nuit, aucune alerte ne se déclenche.

**Cause.** Sans requête, le ratio vaut 0 ÷ 0 : PromQL renvoie `NaN`, et toute comparaison avec `NaN` est fausse.

**Correction.** Complétez le SLI par une sonde externe, ou par une alerte sur l'absence de trafic attendu.

### Le budget est épuisé et rien ne change

**Symptôme.** Le SLO est raté trois mois de suite ; les livraisons continuent au même rythme.

**Cause.** Aucune politique de budget d'erreur validée par le produit.

**Correction.** Écrivez la politique avant d'en avoir besoin, et faites-la valider par ceux qui décident des priorités.

!!! warning "Attention"
    Un SLO fixé au niveau actuel du service, « parce que c'est ce qu'on fait déjà », fige l'existant. Partez de ce dont l'utilisateur a besoin, puis vérifiez que le service peut le tenir.

## Aide-mémoire

- **SLI** = événements bons ÷ événements valides, mesuré côté utilisateur.
- **SLO** = cible sur un SLI, sur une fenêtre (30 jours glissants par défaut).
- **SLA** = contrat, moins exigeant que le SLO.
- **Budget d'erreur** = 1 − SLO ; 99,9 % sur 30 jours ≈ 43 minutes.
- **Taux de consommation** = vitesse de dépense ; 1 = budget épuisé en fin de fenêtre.
- **Alertes** : 14,4 sur 1 h et 5 min ; 6 sur 6 h et 30 min (astreinte) ; 1 sur 3 jours et 6 h (ticket).
- **Seuil d'alerte** = taux de consommation × (1 − SLO).
- **Latence** : en part des requêtes sous un seuil, jamais en moyenne.
- **Trafic nul** : ratio `NaN`, prévoir une sonde externe.
- **Politique de budget** : écrite et validée avant le premier épuisement.
- **DORA** : vitesse et stabilité des livraisons ; **SLO** : promesse tenue auprès des utilisateurs.

## Pour aller plus loin

- [SRE en 2026 : la pile de compétences à maîtriser](2026-07-03-competences-sre-2026.md), sur ce blog : les sept familles de compétences d'un SRE, dont les objectifs de service.
- [*Service Level Objectives*](https://sre.google/sre-book/service-level-objectives/), chapitre du livre SRE de Google : SLI, SLO, SLA.
- [*Implementing SLOs*](https://sre.google/workbook/implementing-slos/) et [*Alerting on SLOs*](https://sre.google/workbook/alerting-on-slos/), *SRE Workbook* : types de SLI, fenêtres, taux de consommation.
- [Métriques DORA](https://dora.dev/guides/dora-metrics/) : définitions officielles des cinq métriques de livraison.
- [Règles d'enregistrement](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) et [tests unitaires des règles](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/), documentation Prometheus.
- [OpenSLO](https://github.com/OpenSLO/OpenSLO) : une spécification ouverte pour décrire les SLO indépendamment de l'outil.

Vos équipes débattent de la fiabilité à chaque incident ? [Définissons ensemble vos objectifs de service](../../contact.md).
