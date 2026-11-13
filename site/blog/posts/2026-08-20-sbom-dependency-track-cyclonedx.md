---
date: 2026-08-20
authors:
  - jerome
categories:
  - "Conformité du SI"
slug: sbom-dependency-track-cyclonedx
description: "SBOM CycloneDX et OWASP Dependency-Track : savoir ce que contient chaque version livrée, en être alerté et le prouver, de la CI à l'exploitation."
type: savoir-comprendre
niveau: confirmé
derniere_verification: 2026-11-13
---

Thème : :material-shield-check-outline: [Conformité du SI](../../services.md#conformite-si)
{ .vt-post-service }

# SBOM et chaîne d'approvisionnement : Dependency-Track et CycloneDX

Quand une faille critique est publiée dans une bibliothèque répandue, une seule question compte : sommes-nous touchés, et où ? Cet article montre comment un SBOM CycloneDX et OWASP Dependency-Track y répondent en minutes, et où les brancher dans votre pipeline et votre cycle de développement.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **expliquer** ce qu'un SBOM apporte à la sécurité de la chaîne d'approvisionnement logicielle ;
- **distinguer** le format (CycloneDX), l'inventaire (Dependency-Track) et l'analyse ponctuelle en CI ;
- **situer** chaque brique dans le pipeline CI/CD et dans le cycle de développement ;
- **anticiper** ce que le Cyber Resilience Act va demander sur ce sujet.

L'essentiel :

1. Un SBOM décrit ce que contient **une version** ; Dependency-Track garde ces descriptions pour **tout le portefeuille** et les réanalyse quand une vulnérabilité est publiée.
2. On génère le SBOM au build, on applique une barrière avant la livraison, et la surveillance continue prend le relais en exploitation.
3. Le SBOM n'est pas une formalité de conformité : c'est la condition pour répondre vite, et le CRA en fait une obligation.

## Contexte

Le 9 décembre 2021, la vulnérabilité Log4Shell (CVE-2021-44228) est rendue publique. Dans de nombreuses organisations, il faut des jours, parfois des semaines, pour savoir quelles applications embarquent `log4j-core`, directement ou par une dépendance de dépendance. Le 29 mars 2024, la porte dérobée insérée dans `xz-utils` (CVE-2024-3094) rappelle que la menace peut aussi venir d'un composant compromis en amont.

Dans les deux cas, le problème n'est pas de corriger : c'est de **savoir**. Une application moderne assemble des centaines de composants tiers, et cette liste change à chaque build.

Le cadre réglementaire suit. NIS2 range la sécurité de la chaîne d'approvisionnement parmi les mesures obligatoires de son article 21. Le **Cyber Resilience Act** impose aux fabricants de signaler les vulnérabilités activement exploitées à partir du **11 septembre 2026**, dans les 24 heures. Ses exigences essentielles, applicables au 11 décembre 2027, demandent d'établir une nomenclature logicielle « dans un format couramment utilisé et lisible par machine » couvrant au minimum les dépendances de premier niveau. Signaler en 24 heures suppose de savoir en quelques minutes ce que contient chaque produit livré. Cet article n'est pas un avis juridique.

## Concepts clés

![Schéma : en entrée, le build CI produit un SBOM CycloneDX par version, et les sources de vulnérabilités (NVD, GitHub, OSV) alimentent l'analyse. Les deux convergent vers Dependency-Track, l'inventaire de tout le portefeuille, où chaque version livrée est réanalysée en continu. Dependency-Track sert à deux moments : avant la livraison, une barrière de politiques bloque la livraison en cas de violation ; en exploitation, une nouvelle vulnérabilité déclenche une alerte puis un triage VEX. Les deux aboutissent aux preuves : le SBOM et le VEX joints à chaque version, pour les clients, l'audit et le signalement.](../../assets/images/blog/sbom-dependency-track-light.png#only-light)
![Schéma : en entrée, le build CI produit un SBOM CycloneDX par version, et les sources de vulnérabilités (NVD, GitHub, OSV) alimentent l'analyse. Les deux convergent vers Dependency-Track, l'inventaire de tout le portefeuille, où chaque version livrée est réanalysée en continu. Dependency-Track sert à deux moments : avant la livraison, une barrière de politiques bloque la livraison en cas de violation ; en exploitation, une nouvelle vulnérabilité déclenche une alerte puis un triage VEX. Les deux aboutissent aux preuves : le SBOM et le VEX joints à chaque version, pour les clients, l'audit et le signalement.](../../assets/images/blog/sbom-dependency-track-dark.png#only-dark)

### SBOM

Le **SBOM** (*Software Bill of Materials*, nomenclature logicielle) est la liste des composants d'un logiciel, avec leur version, leur origine, leur licence et leurs relations de dépendance. Ce n'est pas un fichier de verrouillage (`package-lock.json`, `poetry.lock`) : celui-ci sert à reproduire une installation dans un écosystème, alors que le SBOM décrit le produit livré, tous écosystèmes confondus, image de conteneur comprise. Il vaut pour **une version** précise : en pratique, on le régénère à chaque build.

### CycloneDX

CycloneDX est un format de SBOM porté par l'OWASP, normalisé par Ecma International sous la référence **ECMA-424** ; la 2e édition, de décembre 2025, correspond à la version 1.7. Son concurrent principal est **SPDX**, de la Linux Foundation, normalisé ISO/IEC 5962:2021. Les deux décrivent des composants ; CycloneDX a été conçu dès l'origine pour la sécurité et couvre aussi les vulnérabilités (VEX), la cryptographie (CBOM), les services (SaaSBOM) ou les modèles d'IA. Le choix compte peu tant que vos outils le lisent : Dependency-Track consomme du CycloneDX.

### Analyse de composition

L'analyse de composition (*SCA*, *Software Composition Analysis*) rapproche chaque composant du SBOM des bases de vulnérabilités. Le rapprochement repose sur des identifiants : le **PURL** (*Package URL*, par exemple `pkg:maven/org.apache.logging.log4j/log4j-core@2.14.1`) et le CPE utilisé par la NVD. Un SBOM sans identifiants fiables donne une analyse aveugle : vérifiez que votre générateur renseigne bien le PURL.

### Inventaire continu

C'est ce qui distingue Dependency-Track d'un scanner de dépendances lancé en CI. Le scanner répond : « cette version a-t-elle des vulnérabilités connues **aujourd'hui** ? ». Dependency-Track conserve le SBOM de chaque version livrée et le réanalyse quand les sources de vulnérabilités sont mises à jour. Une faille publiée six mois après la livraison remonte donc sur les versions encore en production, sans rebuild. C'est la réponse à la question de Log4Shell.

### Politique

Une politique traduit une règle de l'organisation en condition vérifiable : une vulnérabilité au-delà d'un seuil de sévérité, une licence interdite, un composant trop ancien. Dependency-Track distingue trois familles de politiques : sécurité, licences et opérationnelle. Évaluée en CI, une politique devient une **barrière** : la livraison s'arrête tant que la violation n'est pas traitée. Une barrière sans politique partagée bloque au hasard ; elle se négocie avec les équipes avant d'être activée.

### VEX

Le **VEX** (*Vulnerability Exploitability eXchange*) déclare si une vulnérabilité présente dans un composant est réellement exploitable dans votre produit : affecté, non affecté, en cours d'analyse, corrigé. Une liste de CVE dit ce qui est présent ; le VEX dit ce qui compte. C'est le résultat du triage, fait dans Dependency-Track, et il se partage : un client qui reçoit votre SBOM reçoit aussi vos conclusions, au lieu de vous questionner sur chaque alerte.

### Provenance

Le SBOM dit **quoi** ; la provenance dit **comment** l'artefact a été construit : quel dépôt, quel commit, quel pipeline. Le cadre **SLSA** (*Supply-chain Levels for Software Artifacts*) gradue ces garanties, et des outils comme Sigstore signent l'artefact et ses attestations. Un SBOM non signé, produit hors de la CI, ne prouve rien ; signé et attaché à l'artefact, il devient une preuve.

## Référence rapide

### Où brancher chaque brique

| Étape du cycle de développement | Étape du pipeline | Action | Point d'attention |
|---|---|---|---|
| Conception | — | Définir les politiques : seuils de sévérité, licences autorisées, composants interdits | À valider avec la sécurité et le juridique avant d'activer une barrière |
| Développement | Pré-commit, revue de code | Analyse rapide des dépendances ajoutées | Retour en minutes ; ne remplace pas l'inventaire |
| Build | Après la résolution des dépendances | Générer le SBOM CycloneDX, depuis le gestionnaire de paquets **et** depuis l'image de conteneur | L'image embarque aussi les paquets du système |
| Vérification | Après le build, avant la publication | Envoyer le SBOM à Dependency-Track, lire les violations, échouer sur les violations bloquantes | Barrière sur la branche principale et les versions publiées, pas sur chaque branche de travail |
| Publication | Création de la version | Signer le SBOM, l'attacher à l'artefact, avec le VEX | Un SBOM par version publiée |
| Déploiement | Mise en production | Marquer la version comme déployée dans Dependency-Track | Désactiver les versions retirées, sinon le bruit noie l'utile |
| Exploitation | — | Alertes sur nouvelle vulnérabilité, triage, mise à jour du VEX | Notifications vers l'outil de tickets ou la messagerie de l'équipe |

### Générer un SBOM CycloneDX

| Écosystème | Générateur | Remarque |
|---|---|---|
| Java (Maven, Gradle) | `cyclonedx-maven-plugin`, `cyclonedx-gradle-plugin` | Intégré au build, voit les dépendances résolues |
| JavaScript (npm) | `@cyclonedx/cyclonedx-npm` | S'appuie sur l'arbre installé |
| Python | `cyclonedx-py` | Depuis l'environnement ou le fichier de verrouillage |
| Multi-langage | `cdxgen` | Outil polyglotte de l'organisation CycloneDX |
| Image de conteneur | `syft`, `trivy` | Couvrent aussi les paquets du système |

!!! note "Critère de décision"
    Générez le SBOM avec l'outil natif de l'écosystème quand il existe : il voit l'arbre de dépendances réellement résolu. Ajoutez un générateur d'image (`syft`, `trivy`) dès que vous livrez des conteneurs, pour couvrir les paquets du système d'exploitation.

## Idées reçues

### « Un scan de dépendances en CI suffit »

Le scan dit ce qui est vulnérable au moment du build. Or la plupart des vulnérabilités sont publiées **après** la livraison des versions qui les contiennent. Sans inventaire réanalysé en continu, une version en production depuis six mois n'est plus jamais examinée. Gardez le scan en CI pour le retour rapide, et Dependency-Track pour la durée de vie du produit.

### « Le SBOM est un document de conformité, on le produit pour l'audit »

Un SBOM produit à la main avant l'audit décrit une version qui n'existe déjà plus. Sa valeur vient de son automatisation : un SBOM par build, conservé par version. La conformité au CRA en découle ; l'inverse ne fonctionne pas.

### « Il faut corriger toutes les vulnérabilités remontées »

Une grande partie des vulnérabilités détectées ne sont pas exploitables dans votre contexte : fonction vulnérable jamais appelée, composant présent seulement au build. Vouloir tout corriger épuise les équipes et noie les vrais risques. Triez avec la sévérité, la probabilité d'exploitation (score EPSS du FIRST) et votre contexte, puis documentez la décision dans le VEX.

### « Publier son SBOM, c'est exposer ses failles »

Un SBOM décrit des composants publics, pas votre code. Un attaquant obtient la même information en analysant le binaire ou l'image. Le CRA demande d'établir le SBOM ; le diffuser à vos clients, accompagné de votre VEX, leur évite de vous solliciter à chaque alerte publique.

## Aide-mémoire

- **SBOM** : liste des composants d'**une** version, avec version, licence et PURL.
- **CycloneDX** : format de SBOM de l'OWASP, ECMA-424 ; alternative : SPDX (ISO/IEC 5962).
- **SCA** : rapprochement des composants avec les bases de vulnérabilités, par PURL et CPE.
- **Dependency-Track** : inventaire du portefeuille, réanalysé en continu, avec politiques et notifications.
- **VEX** : la vulnérabilité est-elle exploitable chez vous ? Le résultat du triage, partageable.
- **Provenance (SLSA)** : comment l'artefact a été construit ; signer SBOM et artefact.
- **Build** : générer le SBOM, du code **et** de l'image.
- **Avant livraison** : barrière sur les violations bloquantes, sur la branche principale.
- **Exploitation** : alerte, triage, VEX ; désactiver les versions retirées.
- **CRA** : signalement en 24 h dès le 11 septembre 2026 ; SBOM exigé au 11 décembre 2027.

## Pour aller plus loin

- [OWASP Dependency-Track](https://dependencytrack.org/) et sa [documentation](https://docs.dependencytrack.org/).
- [Spécification CycloneDX](https://cyclonedx.org/specification/overview/) et [ECMA-424](https://ecma-international.org/publications-and-standards/standards/ecma-424/).
- [Package URL (PURL)](https://github.com/package-url/purl-spec) et [EPSS](https://www.first.org/epss/), FIRST.
- [SLSA](https://slsa.dev/) et [Sigstore](https://www.sigstore.dev/).
- [Cyber Resilience Act](https://eur-lex.europa.eu/eli/reg/2024/2847/oj) et [NIS2](https://eur-lex.europa.eu/eli/dir/2022/2555/oj) : les textes officiels.
- [Conformité continue : un socle de contrôles pour NIS2, DORA et le CRA](2026-07-24-conformite-continue-nis2-dora-cra.md), sur ce blog.
- [Platform Engineering](2026-08-03-platform-engineering.md), sur ce blog : où loger ces briques dans une plateforme interne.

Vous devez savoir en quelques minutes ce que contiennent vos versions livrées ? [Mettons en place votre inventaire logiciel](../../contact.md).
