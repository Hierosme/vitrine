---
date: 2026-09-12
authors:
  - jerome
categories:
  - "Conformité du SI"
slug: trivy-scan-images-iac-secrets-gitlab-ci
description: "Trivy dans GitLab CI : scanner images, IaC et secrets, bloquer seulement ce qui compte, et produire le SBOM CycloneDX de chaque version."
type: savoir-faire
niveau: confirmé
versions_testees: ["trivy 0.74.0"]
derniere_verification: 2026-11-18
---

Thème : :material-shield-check-outline: [Conformité du SI](../../services.md#conformite-si)
{ .vt-post-service }

# Trivy : scanner images, IaC et secrets dans GitLab CI

Un seul outil pour les vulnérabilités de vos images, les erreurs de configuration de votre infrastructure as code et les secrets oubliés dans le dépôt. Cet article montre comment brancher Trivy dans GitLab CI, régler la barrière pour qu'elle bloque l'essentiel, et produire au passage le SBOM de chaque version.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **configurer** un scan d'image et de dépôt dans GitLab CI, avec une barrière qui fait échouer le pipeline ;
- **réduire le bruit** : vulnérabilités sans correctif, exceptions datées, déclarations VEX ;
- **détecter** les erreurs de configuration (Dockerfile, Terraform, Kubernetes) et les secrets commités ;
- **générer** un SBOM CycloneDX avec Trivy et l'envoyer à Dependency-Track.

L'essentiel :

1. Trivy rend toujours un code de sortie 0 par défaut : sans `--exit-code 1`, il informe mais ne bloque rien.
2. Un rapport complet pour la revue, une barrière étroite pour le blocage : deux appels, deux réglages.
3. Le scanner fait partie de votre chaîne d'approvisionnement : épinglez sa version et son image.

## Contexte

Le 11 septembre 2026, les obligations de signalement du Cyber Resilience Act entrent en application : un fabricant doit déclarer en 24 heures une vulnérabilité activement exploitée dans ses produits. Il faut donc connaître le contenu de chaque image livrée et ses failles connues, au moment du build et pas seulement lors d'un audit.

Trivy, l'outil open source d'Aqua Security (licence Apache-2.0), couvre ce besoin dans un binaire unique : vulnérabilités des paquets du système et des dépendances applicatives, erreurs de configuration, secrets, licences. Il s'installe en une ligne dans un job de CI.

Son histoire récente rappelle aussi une contrainte. Le **19 mars 2026**, une version piégée du binaire (v0.69.4) a été publiée, et les étiquettes des actions GitHub `trivy-action` et `setup-trivy` ont été redirigées vers du code qui volait les secrets des pipelines. L'outil qui protège votre chaîne d'approvisionnement en fait partie, et se protège comme le reste.

## Concepts clés

![Schéma : Trivy part d'une cible (image, système de fichiers, dépôt, configuration ou SBOM) et de bases téléchargées depuis un registre OCI et mises en cache : la base de vulnérabilités trivy-db et les règles de configuration. Les scanners vuln, secret, misconfig et license produisent des résultats, que des filtres réduisent : sévérité, statut du correctif, fichier .trivyignore, déclarations VEX. Ce qui reste alimente deux sorties : la barrière, où --exit-code 1 fait échouer le job s'il reste un résultat après filtrage, et les rapports (GitLab, SARIF, CycloneDX) pour la revue de merge request et l'envoi du SBOM à Dependency-Track.](../../assets/images/blog/trivy-scan-light.png#only-light)
![Schéma : Trivy part d'une cible (image, système de fichiers, dépôt, configuration ou SBOM) et de bases téléchargées depuis un registre OCI et mises en cache : la base de vulnérabilités trivy-db et les règles de configuration. Les scanners vuln, secret, misconfig et license produisent des résultats, que des filtres réduisent : sévérité, statut du correctif, fichier .trivyignore, déclarations VEX. Ce qui reste alimente deux sorties : la barrière, où --exit-code 1 fait échouer le job s'il reste un résultat après filtrage, et les rapports (GitLab, SARIF, CycloneDX) pour la revue de merge request et l'envoi du SBOM à Dependency-Track.](../../assets/images/blog/trivy-scan-dark.png#only-dark)

### Cible et scanners

Chaque commande vise un type de **cible** : `trivy image`, `trivy fs` (un répertoire), `trivy repo` (un dépôt Git), `trivy config` (fichiers d'infrastructure as code), `trivy sbom` (un SBOM existant). Les **scanners** choisissent ce qu'on y cherche : `vuln`, `secret`, `misconfig`, `license`. Par défaut, `image`, `fs` et `repo` activent `vuln` et `secret` ; ajoutez `--scanners vuln,secret,misconfig` pour tout couvrir en un passage.

### Bases et cache

Trivy ne connaît aucune vulnérabilité par lui-même : il télécharge la base `trivy-db` depuis un registre OCI, `mirror.gcr.io/aquasec/trivy-db:2` puis `ghcr.io/aquasecurity/trivy-db:2` en secours. Les règles de configuration suivent le même chemin. Le tout est stocké dans le répertoire de cache, `~/.cache/trivy` par défaut. Sans cache partagé, chaque job retélécharge la base.

### Filtres

La **sévérité** (`--severity`) restreint les niveaux affichés. Le **statut du correctif** écarte ce que vous ne pouvez pas corriger aujourd'hui : `--ignore-unfixed` équivaut à `--ignore-status affected,will_not_fix,fix_deferred,end_of_life`. Les **exceptions** vivent dans `.trivyignore`, avec une date d'expiration. Les déclarations **VEX** (`--vex`, encore expérimental) écartent les vulnérabilités jugées non exploitables lors du triage.

### Barrière

Le code de sortie fait la barrière. `--exit-code` vaut 0 par défaut : le job réussit quel que soit le résultat. Avec `--exit-code 1`, il échoue dès qu'un résultat survit aux filtres. Tout le réglage consiste donc à choisir ces filtres.

## Référence rapide

### Commandes

| Commande / configuration | Cas d'usage | Effet | Point d'attention |
|---|---|---|---|
| `trivy image --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed IMAGE` | Barrière avant publication de l'image | Échec si une vulnérabilité élevée ou critique a un correctif | Le rapport complet se fait dans un appel séparé, sans barrière |
| `trivy fs --scanners vuln,secret,misconfig .` | Scan du dépôt en merge request | Dépendances, secrets et IaC en un passage | Le scanner `misconfig` n'est pas actif par défaut |
| `trivy config --misconfig-scanners terraform,dockerfile .` | Restreindre l'analyse IaC | Seuls les types listés sont analysés | Par défaut : Terraform, Dockerfile, Kubernetes, Helm, CloudFormation, ARM, Ansible… |
| `trivy image --format cyclonedx --output sbom.cdx.json IMAGE` | SBOM de la version | Inventaire des composants, sans les vulnérabilités | Format produit : CycloneDX 1.7 |
| `trivy sbom sbom.cdx.json` | Réanalyser un SBOM conservé | Vulnérabilités connues aujourd'hui | Ne refait pas l'inventaire |
| `trivy image --download-db-only`, puis `--skip-db-update` | Plusieurs scans dans un job | Une seule mise à jour de la base | À combiner avec un cache CI |
| `--format template --template "@/contrib/gitlab.tpl"` | Rapport pour GitLab | Fichier pour l'artefact `container_scanning` | Chemin valable dans l'image officielle `aquasec/trivy` |
| `--vex repo` ou `--vex fichier.json` | Appliquer un triage | Écarte les vulnérabilités déclarées non exploitables | Expérimental ; formats OpenVEX, CycloneDX et CSAF |

### Exceptions datées

`.trivyignore`, lu par défaut, accepte un identifiant par ligne et une date d'expiration :

```text
# Healthcheck géré par l'orchestrateur — revue le 31 mars
DS-0026 exp:2027-03-31
```

Le format YAML, expérimental, ajoute un périmètre et une justification ; il se passe avec `--ignorefile .trivyignore.yaml` :

```yaml
misconfigurations:
  - id: DS-0002
    paths:
      - "build/Dockerfile"
    expired_at: 2027-03-31
    statement: Image de build, jamais exécutée en production
```

Une exception expirée cesse de s'appliquer : le résultat réapparaît au scan suivant.

### Job GitLab CI

```yaml
# GitLab CI — Trivy 0.74.0
.trivy:
  image:
    name: docker.io/aquasec/trivy:0.74.0   # épinglez aussi le digest : @sha256:…
    entrypoint: [""]
  variables:
    TRIVY_CACHE_DIR: ".trivycache/"
    TRIVY_NO_PROGRESS: "true"
  cache:
    key: trivy-db
    paths:
      - .trivycache/

trivy-image:
  extends: .trivy
  stage: test
  variables:
    IMAGE: "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA"
    TRIVY_AUTH_URL: "$CI_REGISTRY"
    TRIVY_USERNAME: "$CI_REGISTRY_USER"
    TRIVY_PASSWORD: "$CI_REGISTRY_PASSWORD"
  script:
    - trivy image --download-db-only
    # Rapport complet pour la merge request : n'échoue jamais
    - trivy image --skip-db-update --exit-code 0 --format template
        --template "@/contrib/gitlab.tpl" --output gl-container-scanning-report.json "$IMAGE"
    # Barrière : vulnérabilités élevées ou critiques qui ont un correctif
    - trivy image --skip-db-update --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed "$IMAGE"
  artifacts:
    when: always
    reports:
      container_scanning: gl-container-scanning-report.json
```

!!! tip "Bonne pratique"
    Séparez le rapport et la barrière, comme dans ce job. Le rapport montre tout aux relecteurs ; la barrière ne bloque que ce qu'une équipe peut corriger dans la journée. Une barrière trop large finit désactivée, et je préfère une règle étroite respectée à une règle stricte contournée.

### SBOM vers Dependency-Track

Sur les versions publiées, générez le SBOM de l'image, puis envoyez-le à Dependency-Track depuis un job qui dispose de `curl` :

```bash
trivy image --format cyclonedx --output sbom.cdx.json "$IMAGE"
curl --fail -X POST "$DTRACK_URL/api/v1/bom" \
  -H "X-Api-Key: $DTRACK_API_KEY" \
  -F "autoCreate=true" -F "projectName=$CI_PROJECT_PATH" \
  -F "projectVersion=$CI_COMMIT_TAG" -F "bom=@sbom.cdx.json"
```

Trivy répond pour le build en cours ; Dependency-Track réanalyse ensuite ce SBOM chaque jour, avec les vulnérabilités publiées depuis la livraison.

## Erreurs fréquentes

### Le pipeline reste vert alors que le rapport liste des vulnérabilités CRITICAL

Cause : `--exit-code` vaut 0 par défaut. Correction : ajoutez `--exit-code 1` sur l'appel qui sert de barrière, et seulement sur celui-là.

### Les jobs de scan sont lents, et certains échouent au téléchargement de la base (HTTP 429)

Cause : sans cache, chaque job retélécharge `trivy-db` et sollicite le registre. Correction : fixez `TRIVY_CACHE_DIR` dans un répertoire du projet, déclarez-le dans `cache:`, téléchargez la base une fois (`--download-db-only`) puis scannez avec `--skip-db-update`. Pour une flotte de runners, `--db-repository` pointe vers un miroir interne.

### La barrière bloque sur des vulnérabilités qu'aucune version ne corrige

Cause : sans filtre de statut, une faille sans correctif publié bloque la livraison sans action possible. Correction : `--ignore-unfixed` sur la barrière ; gardez ces vulnérabilités visibles dans le rapport et dans Dependency-Track, dont l'analyse quotidienne signalera le correctif quand il sortira.

### Le fichier `.trivyignore` compte des dizaines de lignes que personne ne sait justifier

Cause : des exceptions ajoutées sans date ni motif, pour débloquer un pipeline. Correction : une date `exp:` sur chaque ligne, ou le format YAML avec `statement` ; l'exception expirée revient d'elle-même dans le rapport.

!!! danger "Risque"
    Une référence mobile (`aquasec/trivy:latest`, une étiquette d'action GitHub) exécute dans votre pipeline le code que l'éditeur, ou un attaquant, y place demain. En mars 2026, les étiquettes `trivy-action` 0.0.1 à 0.34.2 ont été redirigées vers un code qui exfiltrait les secrets des pipelines (avis GHSA-cxm3-wv7p-598c). Épinglez l'image par digest et les actions par SHA de commit, et limitez les secrets accessibles au job de scan.

## Aide-mémoire

```text
# Trivy 0.74.0
trivy image --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed IMAGE   # barrière
trivy image --format template --template "@/contrib/gitlab.tpl" -o r.json IMAGE   # rapport GitLab
trivy fs --scanners vuln,secret,misconfig .         # dépôt : dépendances, secrets, IaC
trivy config .                                      # IaC seule
trivy image --format cyclonedx -o sbom.cdx.json IMAGE   # SBOM de la version
trivy sbom sbom.cdx.json                            # réanalyser un SBOM
--exit-code 0 par défaut : sans --exit-code 1, rien ne bloque
--ignore-unfixed = --ignore-status affected,will_not_fix,fix_deferred,end_of_life
.trivyignore : ID exp:AAAA-MM-JJ ; YAML : id, paths, expired_at, statement
Cache : TRIVY_CACHE_DIR + cache CI ; --download-db-only puis --skip-db-update
Base : mirror.gcr.io/aquasec/trivy-db:2, secours ghcr.io ; --db-repository pour un miroir
Épingler l'image par digest et les actions par SHA
```

## Pour aller plus loin

- [Documentation de Trivy](https://trivy.dev/) et [dépôt `aquasecurity/trivy`](https://github.com/aquasecurity/trivy) : notes de version et code source.
- [Filtrage des résultats](https://trivy.dev/docs/dev/configuration/filtering/), [bases de données](https://trivy.dev/docs/dev/configuration/db/) et [VEX](https://trivy.dev/docs/dev/supply-chain/vex/), dans la documentation.
- [Intégration GitLab CI](https://trivy.dev/docs/dev/tutorials/integrations/gitlab-ci/), exemple officiel.
- [Compromission de la chaîne d'approvisionnement de Trivy](https://www.aquasec.com/blog/trivy-supply-chain-attack-what-you-need-to-know/), Aqua Security : chronologie et remédiation.
- [Envoi d'un SBOM à Dependency-Track depuis la CI](https://docs.dependencytrack.org/usage/cicd/).
- [SBOM et chaîne d'approvisionnement : Dependency-Track et CycloneDX](2026-08-20-sbom-dependency-track-cyclonedx.md), sur ce blog.
- [Conformité continue : un socle de contrôles pour NIS2, DORA et le CRA](2026-07-24-conformite-continue-nis2-dora-cra.md), sur ce blog.

Vous voulez une barrière de sécurité que vos équipes gardent activée ? [Mettons-la en place dans vos pipelines](../../contact.md).
