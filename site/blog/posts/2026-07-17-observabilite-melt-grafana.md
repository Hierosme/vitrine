---
date: 2026-07-17
authors:
  - jerome
categories:
  - "SRE : fiabilité & performance"
slug: observabilite-melt-grafana
description: "Métriques, événements, journaux, traces : les quatre signaux MELT, la stack Grafana qui les stocke (Alloy, Mimir, Loki, Tempo) et comment les corréler."
type: mixte
niveau: confirmé
derniere_verification: 2026-11-06
---

Thème : :material-speedometer: [SRE : fiabilité & performance](../../services.md#sre)
{ .vt-post-service }

# Observabilité MELT : quatre signaux, une stack Grafana

Métriques, événements, journaux et traces répondent chacun à une question différente. Cet article les distingue, montre où la stack Grafana les range et comment passer de l'un à l'autre pendant un diagnostic.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **distinguer** les quatre signaux MELT et la question à laquelle chacun répond ;
- **associer** chaque signal au composant de la stack Grafana qui le collecte, le stocke ou l'affiche ;
- **corréler** les signaux entre eux : d'une alerte à la trace, puis au journal ;
- **choisir** quoi instrumenter en premier selon votre contexte.

L'essentiel, pour qui ne lirait que ces lignes :

1. Les métriques disent **que** quelque chose ne va pas, les traces **où**, les journaux **pourquoi** ; les événements disent **ce qui a changé**.
2. La valeur vient de la corrélation : un même `trace_id` et un même `service.name` dans tous les signaux.
3. Un seul collecteur pour tous les signaux (Alloy, ou l'OpenTelemetry Collector), plutôt qu'un agent par outil.

## Contexte

Une alerte de SLO se déclenche : le budget d'erreur du service de paiement fond. L'équipe ouvre un tableau de bord de métriques, qui confirme la hausse des erreurs. Puis elle cherche dans les journaux, sans savoir quel service fautif interroger. Puis elle ouvre l'outil de traces, mais aucun identifiant ne relie une requête en erreur à ses journaux. Trois outils, trois requêtes à écrire, trois vocabulaires : le diagnostic prend une heure, quand la cause tenait en une ligne de journal.

Ce n'est pas un manque de données, c'est un manque de **liens** entre les données. L'acronyme MELT (*Metrics, Events, Logs, Traces*) nomme les quatre signaux qu'une observabilité complète collecte. Leur intérêt tient moins à chacun d'eux qu'à la possibilité de passer de l'un à l'autre sans perdre le fil.

En 2026, OpenTelemetry fournit le format commun de collecte, et la stack open source de Grafana Labs offre un stockage par signal (Mimir, Loki, Tempo, Pyroscope pour les profils) avec une interface unique pour les corréler. C'est elle qui illustre cet article ; les concepts valent pour d'autres outils.

## Concepts clés

![Schéma : les applications et l'infrastructure, instrumentées par un SDK OpenTelemetry ou par Beyla (eBPF), envoient leurs signaux en OTLP à un collecteur unique, Grafana Alloy ou l'OpenTelemetry Collector, qui reçoit, enrichit et route chaque signal. Le collecteur envoie les métriques à Mimir (requêtes PromQL), les journaux et événements à Loki, les traces à Tempo (requêtes TraceQL) et les profils à Pyroscope, hors MELT. Grafana interroge les quatre stockages pour visualiser, alerter et corréler, en passant d'un signal à l'autre grâce aux exemplars, au trace_id et au service.name.](../../assets/images/blog/observabilite-melt-light.png#only-light)
![Schéma : les applications et l'infrastructure, instrumentées par un SDK OpenTelemetry ou par Beyla (eBPF), envoient leurs signaux en OTLP à un collecteur unique, Grafana Alloy ou l'OpenTelemetry Collector, qui reçoit, enrichit et route chaque signal. Le collecteur envoie les métriques à Mimir (requêtes PromQL), les journaux et événements à Loki, les traces à Tempo (requêtes TraceQL) et les profils à Pyroscope, hors MELT. Grafana interroge les quatre stockages pour visualiser, alerter et corréler, en passant d'un signal à l'autre grâce aux exemplars, au trace_id et au service.name.](../../assets/images/blog/observabilite-melt-dark.png#only-dark)

### Métriques

**Définition.** Des valeurs numériques agrégées dans le temps : compteurs, jauges, histogrammes, identifiés par un nom et des étiquettes. Dans la stack Grafana, Prometheus ou Mimir les stockent, PromQL les interroge.

**À ne pas confondre avec** un journal comptabilisé : une métrique est agrégée dès la source, elle ne garde pas le détail de chaque requête.

**Exemple.** Le taux d'erreurs du service de paiement sur cinq minutes, base du SLI de l'article sur les objectifs de service.

**En pratique.** C'est le signal le moins coûteux et le plus rapide à interroger : il porte les SLO, les alertes et les tableaux de bord.

### Événements

**Définition.** Des faits ponctuels qui modifient le système : un déploiement, un changement de configuration, une bascule, le début d'un incident.

**À ne pas confondre avec** un journal applicatif : un événement est rare et décrit un changement ; un journal est fréquent et décrit un fonctionnement.

**Exemple.** Dans Grafana, un déploiement devient une annotation : un trait vertical sur tous les graphiques, à l'heure exacte du changement. Les annotations s'alimentent par l'API HTTP de Grafana ou par une requête sur une source de données, par exemple Loki.

**En pratique.** Une courbe qui se dégrade juste après un trait de déploiement oriente le diagnostic plus vite que n'importe quelle requête.

### Journaux

**Définition.** Des enregistrements horodatés émis par les applications et les systèmes, de préférence structurés. Loki les stocke en n'indexant que quelques étiquettes ; LogQL les interroge.

**À ne pas confondre avec** une base de recherche plein texte : Loki sélectionne d'abord les flux par étiquettes, puis filtre leur contenu.

**Exemple.** Reçu en OTLP, l'attribut de ressource `service.name` devient l'étiquette `service_name` ; les autres attributs, dont l'identifiant de trace, deviennent des **métadonnées structurées**, filtrables sans être indexées.

**En pratique.** Gardez peu d'étiquettes, à faible nombre de valeurs ; tout le reste va en métadonnées structurées ou dans le message.

### Traces

**Définition.** Le chemin d'une requête à travers les services, découpé en *spans* (une opération, sa durée, son statut, ses attributs) reliés par un `trace_id`. Tempo les stocke, TraceQL les interroge.

**À ne pas confondre avec** un journal qui porterait un identifiant de requête : la trace donne la structure (qui appelle qui, combien de temps chacun).

**Exemple.** Une requête de paiement lente se décompose en un appel au service de stock, rapide, et une requête en base, qui porte toute la latence.

**En pratique.** Le générateur de métriques de Tempo calcule à partir des traces des métriques RED (taux, erreurs, durée) et une carte des dépendances entre services, sans instrumentation supplémentaire.

### Corrélation

**Définition.** La capacité de passer d'un signal à un autre pour la même requête, le même service ou le même instant.

**À ne pas confondre avec** l'affichage côte à côte : trois graphiques sur un même tableau de bord ne sont pas corrélés s'ils ne partagent aucun identifiant.

**Exemple.** Un point d'un graphique PromQL porte un *exemplar*, l'identifiant d'une trace représentative : un clic ouvre la trace dans Tempo, puis un autre ouvre les journaux du même `trace_id` dans Loki.

**En pratique.** La corrélation repose sur trois conventions : le même `service.name` partout, le `trace_id` dans les journaux, les exemplars activés côté métriques.

### Collecteur unique

**Définition.** Un seul agent par machine ou par nœud, qui reçoit tous les signaux en OTLP, les enrichit (attributs Kubernetes, environnement), les échantillonne et les route vers chaque stockage. Dans la stack Grafana, c'est Alloy, une distribution du collecteur OpenTelemetry qui sait aussi exécuter des pipelines Prometheus. Le projet OpenTelemetry publie son propre collecteur, l'[OpenTelemetry Collector](https://opentelemetry.io/docs/collector/), neutre vis-à-vis des éditeurs : comme Mimir, Loki et Tempo acceptent l'OTLP, il peut remplacer Alloy sans changer les stockages.

**À ne pas confondre avec** l'instrumentation : le SDK OpenTelemetry, dans l'application, produit les signaux ; le collecteur les transporte.

**Exemple.** Beyla, l'instrumentation par eBPF de Grafana Labs, produit métriques et traces pour des services qu'on ne peut pas modifier, et les confie au même collecteur.

**En pratique.** Les règles d'enrichissement et d'échantillonnage vivent en un seul endroit, versionné comme le reste de l'infrastructure.

### Cardinalité

**Définition.** Le nombre de combinaisons distinctes d'étiquettes. Chaque combinaison est une série temporelle dans Mimir, un flux dans Loki.

**À ne pas confondre avec** le volume de données : dix étiquettes à deux valeurs coûtent moins qu'une seule étiquette à un million de valeurs.

**Exemple.** Un identifiant d'utilisateur en étiquette de métrique crée une série par utilisateur.

**En pratique.** Les valeurs à forte cardinalité (identifiant d'utilisateur, de requête, de commande) vont dans les traces, les métadonnées structurées ou le corps des journaux, jamais en étiquettes.

## Référence rapide

### Concepts

| Concept | Définition courte | Ce que ça change en pratique | À ne pas confondre avec |
|---|---|---|---|
| Métriques | Valeurs agrégées dans le temps | Portent SLO, alertes et tableaux de bord | Des journaux comptés |
| Événements | Faits ponctuels qui changent le système | Relient une dégradation à sa cause probable | Les journaux applicatifs |
| Journaux | Enregistrements horodatés, structurés | Expliquent le pourquoi d'une erreur | Une recherche plein texte |
| Traces | Chemin d'une requête en *spans* | Localisent où le temps et les erreurs se produisent | Un journal avec identifiant |
| Corrélation | Passer d'un signal à l'autre | Diagnostic en minutes, pas en heures | L'affichage côte à côte |
| Collecteur unique | Un agent pour tous les signaux | Règles d'enrichissement centralisées | L'instrumentation |
| Cardinalité | Combinaisons distinctes d'étiquettes | Coût et performance des stockages | Le volume de données |

### Un signal, un composant

| Signal | Stockage | Langage de requête | Question typique |
|---|---|---|---|
| Métriques | Prometheus, Mimir | PromQL | Le taux d'erreurs dépasse-t-il le budget ? |
| Événements | Annotations Grafana, Loki | LogQL, API Grafana | Qu'a-t-on déployé juste avant ? |
| Journaux | Loki | LogQL | Quel message accompagne cette erreur ? |
| Traces | Tempo | TraceQL | Quel appel porte la latence ? |
| Profils (hors MELT) | Pyroscope | — | Quelle fonction consomme le CPU ? |

### Passer d'un signal à l'autre dans Grafana

| De | Vers | Mécanisme |
|---|---|---|
| Métriques | Traces | Exemplars de la source Prometheus, ouverts dans Tempo |
| Journaux | Traces | Champs dérivés (*derived fields*) de la source Loki, sur le `trace_id` |
| Traces | Journaux | Réglage *Trace to logs* de la source Tempo |
| Traces | Métriques | Réglage *Trace to metrics* de la source Tempo |
| Traces | Profils | Réglage *Trace to profiles* de la source Tempo, vers Pyroscope |

!!! note "Critère de décision"
    Quoi instrumenter en premier ? Les métriques des parcours qui portent vos SLO, puis les traces de ces mêmes parcours, puis le `trace_id` dans les journaux. Les événements de déploiement coûtent presque rien et se branchent dès le premier jour.

### Collecte avec Alloy

Un pipeline minimal : réception OTLP, regroupement par lots, puis un stockage par signal. Les noms de composants, les ports par défaut (4317 en gRPC, 4318 en HTTP) et les points d'entrée de Mimir et Loki sont ceux de la documentation officielle ; les noms d'hôtes sont à adapter.

```alloy
// Réception OTLP depuis les applications instrumentées
otelcol.receiver.otlp "default" {
  grpc {}
  http {}

  output {
    metrics = [otelcol.processor.batch.default.input]
    logs    = [otelcol.processor.batch.default.input]
    traces  = [otelcol.processor.batch.default.input]
  }
}

// Regroupement par lots avant envoi
otelcol.processor.batch "default" {
  output {
    metrics = [otelcol.exporter.prometheus.mimir.input]
    logs    = [otelcol.exporter.otlphttp.loki.input]
    traces  = [otelcol.exporter.otlphttp.tempo.input]
  }
}

// Métriques → Mimir, par le protocole remote write de Prometheus
otelcol.exporter.prometheus "mimir" {
  forward_to = [prometheus.remote_write.mimir.receiver]
}

prometheus.remote_write "mimir" {
  endpoint {
    url = "http://mimir:9009/api/v1/push"
  }
}

// Journaux → Loki, en OTLP natif
otelcol.exporter.otlphttp "loki" {
  client {
    endpoint = "http://loki:3100/otlp"
  }
}

// Traces → Tempo, en OTLP
otelcol.exporter.otlphttp "tempo" {
  client {
    endpoint = "http://tempo:4318"
  }
}
```

1. `otelcol.receiver.otlp` ouvre un serveur gRPC et un serveur HTTP, sur leurs ports par défaut.
2. `otelcol.exporter.prometheus` convertit les métriques OpenTelemetry pour `prometheus.remote_write`, qui pousse vers `/api/v1/push` de Mimir.
3. L'exportateur `otlphttp` ajoute `/v1/logs` au point d'entrée `/otlp` de Loki.
4. En production, ajoutez le chiffrement TLS et l'authentification de chaque stockage.

### Alloy ou OpenTelemetry Collector

Les deux reçoivent l'OTLP et alimentent les mêmes stockages. La documentation d'OpenTelemetry range d'ailleurs Alloy parmi les distributions tierces de son collecteur, qu'elle précise ne pas valider.

| Critère | Grafana Alloy | OpenTelemetry Collector |
|---|---|---|
| Éditeur | Grafana Labs | Projet OpenTelemetry (CNCF), neutre vis-à-vis des éditeurs |
| Configuration | Syntaxe propre à Alloy, composants `otelcol.*` et `prometheus.*` | YAML : `receivers`, `processors`, `exporters`, `connectors`, puis `service.pipelines` |
| Prometheus | Pipelines Prometheus natifs (collecte, réécriture d'étiquettes, remote write) | Par des composants de la distribution *contrib* |
| Distributions | Une seule, maintenue par Grafana Labs | Officielles : *core*, *contrib*, *k8s*, *otlp* ; ou la vôtre, assemblée avec l'outil `ocb` |
| Points d'écoute | Ceux de la configuration | `localhost` par défaut : l'exposer explicitement pour recevoir depuis d'autres hôtes |
| Quand le choisir | La stack Grafana est la cible, avec des pipelines Prometheus existants | Plusieurs backends ou éditeurs, ou une configuration à garder indépendante de l'éditeur |

### Requêtes de diagnostic

```text
# PromQL — part des requêtes en erreur, par service (métriques)
sum by (service_name) (rate(http_requests_total{code=~"5.."}[5m]))
/
sum by (service_name) (rate(http_requests_total[5m]))

# TraceQL — traces en erreur d'un service (traces)
{ resource.service.name = "checkout" && status = error }

# TraceQL — spans lents de ce service
{ resource.service.name = "checkout" && span:duration > 500ms }

# TraceQL metrics — taux d'erreurs calculé depuis les traces
100 * ({ status = error } | rate()) / ({ } | rate())

# LogQL — journaux d'une trace, par métadonnée structurée (journaux)
{service_name="checkout"} | trace_id="0242ac120002"
```

Les métriques HTTP prises en exemple viennent de votre instrumentation : adaptez le nom et les étiquettes à ce qu'elle expose.

## Erreurs fréquentes

### Les séries de métriques explosent

**Symptôme.** La mémoire de Prometheus ou la facture de Mimir grimpe sans hausse du trafic.

**Cause.** Une étiquette à forte cardinalité : identifiant d'utilisateur, de requête, chemin d'URL avec identifiants.

**Correction.** Retirez l'étiquette, normalisez les chemins (`/orders/{id}`) et portez le détail dans les traces.

### Loki refuse des journaux

**Symptôme.** Des erreurs de limite de flux actifs côté Loki, ou des requêtes lentes sur peu de données.

**Cause.** Trop d'étiquettes, ou des étiquettes à trop de valeurs : chaque combinaison est un flux.

**Correction.** Ne gardez en étiquettes que le service, l'environnement et quelques dimensions stables ; le reste va en métadonnées structurées.

### Impossible de passer d'un journal à sa trace

**Symptôme.** Les journaux d'une requête en erreur ne proposent aucun lien vers Tempo.

**Cause.** Les journaux ne portent pas le `trace_id`, ou la source Loki n'a pas de champ dérivé configuré.

**Correction.** Émettez les journaux par le SDK OpenTelemetry, qui ajoute le contexte de trace, puis configurez le champ dérivé vers Tempo.

### Une requête TraceQL ne renvoie rien

**Symptôme.** `{ span.http.response.status_code >= 500 }` ne trouve aucune trace, alors que des erreurs existent.

**Cause.** Le nom de l'attribut dépend de la version des conventions sémantiques suivie par l'instrumentation : `http.status_code` dans les anciennes, `http.response.status_code` dans les récentes.

**Correction.** Vérifiez dans une trace réelle le nom exact de l'attribut, ou filtrez sur le statut du span (`status = error`), indépendant des conventions.

### Les traces d'erreurs manquent

**Symptôme.** L'échantillonnage garde 1 % des traces, et les requêtes en erreur sont rarement parmi elles.

**Cause.** Un échantillonnage décidé en tête de requête, avant de savoir si elle échouera.

**Correction.** Échantillonnez en fin de trace dans le collecteur (`otelcol.processor.tail_sampling` dans Alloy), en gardant toutes les traces en erreur ou lentes.

!!! warning "Attention"
    L'échantillonnage en fin de trace demande que tous les spans d'une même trace arrivent au même collecteur. Avec plusieurs instances d'Alloy, il faut répartir les spans par `trace_id` avant l'échantillonnage.

## Aide-mémoire

- **Métriques** : que se passe-t-il ? Mimir, PromQL.
- **Événements** : qu'est-ce qui a changé ? Annotations Grafana.
- **Journaux** : pourquoi ? Loki, LogQL, peu d'étiquettes.
- **Traces** : où ? Tempo, TraceQL.
- **Profils** : quelle fonction ? Pyroscope, hors MELT.
- **Collecte** : un seul collecteur en OTLP pour tous les signaux, Alloy ou OpenTelemetry Collector.
- **Corrélation** : même `service.name`, `trace_id` dans les journaux, exemplars activés.
- **Cardinalité** : identifiants en traces ou métadonnées, jamais en étiquettes.
- **Échantillonnage** : en fin de trace, en gardant erreurs et lenteurs.
- **Ordre d'instrumentation** : métriques des SLO, traces, `trace_id` dans les journaux, événements de déploiement.

## Pour aller plus loin

- [Objectifs de service : les définir, les mesurer, s'en servir](2026-07-10-objectifs-de-service.md), sur ce blog : les SLO que l'observabilité sert à mesurer.
- [SRE en 2026 : la pile de compétences à maîtriser](2026-07-03-competences-sre-2026.md), sur ce blog : l'observabilité parmi les sept familles de compétences.
- [Signaux OpenTelemetry](https://opentelemetry.io/docs/concepts/signals/) : métriques, journaux, traces et le statut de chaque signal.
- [Grafana Alloy](https://grafana.com/docs/alloy/latest/) : composants `otelcol.*` et `prometheus.*`.
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/) : [configuration](https://opentelemetry.io/docs/collector/configuration/) et [distributions](https://opentelemetry.io/docs/collector/distributions/).
- [Envoyer des journaux à Loki en OpenTelemetry](https://grafana.com/docs/loki/latest/send-data/otel/) et [métadonnées structurées](https://grafana.com/docs/loki/latest/get-started/labels/structured-metadata/).
- [Construire des requêtes TraceQL](https://grafana.com/docs/tempo/latest/traceql/construct-traceql-queries/) et [métriques issues des traces](https://grafana.com/docs/tempo/latest/metrics-from-traces/).
- [Relier les traces aux autres signaux](https://grafana.com/docs/grafana/latest/datasources/tempo/configure-tempo-data-source/) et [exemplars](https://grafana.com/docs/grafana/latest/fundamentals/exemplars/), documentation Grafana.

Vos diagnostics passent par trois outils et une heure de recherche ? [Construisons une observabilité qui relie vos signaux](../../contact.md).
