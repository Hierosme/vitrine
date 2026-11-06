---
date: 2026-07-24
authors:
  - jerome
categories:
  - "Conformité du SI"
slug: conformite-continue-nis2-dora-cra
description: "NIS2, DORA, CRA : un même contrôle décrit en code, rattaché à plusieurs référentiels, vérifié chaque jour et qui produit lui-même ses preuves d'audit."
type: mixte
niveau: confirmé
versions_testees: ["ansible-core 2.21", "ansible.posix 2.2"]
derniere_verification: 2026-11-06
---

Thème : :material-shield-check-outline: [Conformité du SI](../../services.md#conformite-si)
{ .vt-post-service }

# Conformité continue : un socle de contrôles pour NIS2, DORA et le CRA

NIS2, DORA et le Cyber Resilience Act demandent, avec des mots différents, souvent les mêmes mesures. Cet article montre comment décrire un contrôle une seule fois dans le code, le rattacher à plusieurs référentiels et en tirer des preuves vérifiables chaque jour.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **distinguer** l'exigence, le contrôle et la preuve ;
- **rattacher** un même contrôle technique à plusieurs référentiels ;
- **décrire** ce contrôle dans le code d'infrastructure et le vérifier en continu ;
- **collecter** les preuves automatiquement, plutôt que de les reconstituer avant l'audit.

L'idée en trois phrases :

1. Un référentiel dit **quoi** ; le contrôle dit **comment** ; la preuve montre que c'est **fait**, et depuis quand.
2. NIS2, DORA, le CRA et ISO 27001 se recoupent largement : un contrôle bien décrit sert à tous.
3. Un contrôle écrit en code se vérifie sans rien modifier, chaque jour, et chaque vérification est une preuve.

## Contexte

En juillet 2026, une même organisation peut relever de trois textes européens. **DORA** s'applique depuis le 17 janvier 2025 aux entités financières et à leurs prestataires informatiques. Le **Cyber Resilience Act** impose aux fabricants de signaler les vulnérabilités activement exploitées à partir du 11 septembre 2026, avant ses exigences complètes au 11 décembre 2027. **NIS2** n'est toujours pas transposée en France : la Commission a saisi la Cour de justice de l'UE le 8 juillet 2026, et l'ANSSI publie en attendant ReCyF, un référentiel de travail en 20 objectifs. S'y ajoute souvent une certification **ISO/IEC 27001**.

La réponse habituelle est un tableur par référentiel et un audit préparé dans l'urgence, à coups de captures d'écran. La conformité continue renverse la logique : chaque mesure est décrite **une fois**, sous forme de contrôle exécutable, rattachée à toutes les exigences qu'elle couvre, et vérifiée en permanence. Cet article n'est pas un avis juridique : le périmètre exact de chaque texte relève de vos juristes et de vos autorités.

## Concepts clés

![Schéma : quatre exigences, NIS2 article 21 paragraphe 2, DORA article 9 paragraphe 4, CRA annexe I et ISO 27001 mesure A 8.5, pointent vers un seul contrôle, CTL-ACC-01, accès SSH par clé sans connexion root, décrit une seule fois en code Ansible. Ce contrôle est appliqué, ce qui corrige l'écart sur chaque hôte, et vérifié de façon planifiée en mode check, sans rien modifier. La vérification produit une preuve, un rapport JSON horodaté où changed égal zéro signifie conforme ; un écart détecté déclenche la correction. Les preuves vont à l'auditeur ou à un outil de GRC : une preuve, rattachée à plusieurs référentiels.](../../assets/images/blog/conformite-continue-light.png#only-light)
![Schéma : quatre exigences, NIS2 article 21 paragraphe 2, DORA article 9 paragraphe 4, CRA annexe I et ISO 27001 mesure A 8.5, pointent vers un seul contrôle, CTL-ACC-01, accès SSH par clé sans connexion root, décrit une seule fois en code Ansible. Ce contrôle est appliqué, ce qui corrige l'écart sur chaque hôte, et vérifié de façon planifiée en mode check, sans rien modifier. La vérification produit une preuve, un rapport JSON horodaté où changed égal zéro signifie conforme ; un écart détecté déclenche la correction. Les preuves vont à l'auditeur ou à un outil de GRC : une preuve, rattachée à plusieurs référentiels.](../../assets/images/blog/conformite-continue-dark.png#only-dark)

### Exigence

Ce qu'un texte impose, formulé en objectif. L'article 21 de NIS2 demande des politiques de contrôle d'accès et l'authentification multifacteur ; l'article 9(4)(d) de DORA, des mécanismes d'authentification forte. Aucun ne dit comment faire, et c'est voulu. Une exigence se lit toujours avec son périmètre : qui y est soumis, et à partir de quand.

### Contrôle

La mesure concrète qui répond à une ou plusieurs exigences, avec un identifiant stable (`CTL-ACC-01`) et une description assez précise pour être vérifiée. « L'accès aux serveurs est protégé » est une intention ; « SSH n'accepte que les clés et refuse root » est un contrôle, qui couvre à lui seul NIS2 21(2)(i) et (j), DORA 9(4)(c) et (d), l'annexe I du CRA et la mesure A 8.5 d'ISO 27001. On le décrit, l'applique, le vérifie et le rattache.

### Preuve

Ce qui montre qu'un contrôle est en place sur un périmètre, à une date. « Nous désactivons les mots de passe SSH » est une déclaration ; le rapport horodaté de vérification de chaque hôte est une preuve. Pour être recevable, elle doit être horodatée, rattachée à un périmètre, reproductible (quelle version du code) et conservée.

### Table de correspondance

Elle relie chaque contrôle aux exigences qu'il couvre, référentiel par référentiel, sans prétendre que deux exigences proches sont équivalentes. Le NIST maintient un format pour ces correspondances, OLIR (*Online Informative References*), repris par certains outils de GRC. Un nouveau référentiel ne demande alors plus de nouveaux contrôles, seulement une nouvelle colonne.

### Dérive

L'écart qui se creuse entre l'état décrit et l'état réel : modification manuelle, paquet mis à jour, serveur ajouté hors processus. L'administrateur qui réactive les mots de passe SSH pour dépanner et oublie de les désactiver en est l'exemple type. La dérive existe dès le lendemain de l'audit ; seule une vérification fréquente la rend visible à temps.

### Contrôle décrit en code

Écrit dans un outil déclaratif, un contrôle sait appliquer l'état attendu et vérifier l'état réel sans le modifier ; avec Ansible, c'est le mode `--check`. Un script de durcissement, lui, modifie une fois sans dire si l'état est encore bon six mois plus tard. Versionné et relu, le code du contrôle devient lui-même un élément de preuve.

## Référence rapide

### NIS2, DORA, CRA : ce qu'ils ont en commun

| Thème | NIS2 (directive 2022/2555) | DORA (règlement 2022/2554) | CRA (règlement 2024/2847) | ISO/IEC 27001:2022 |
|---|---|---|---|---|
| Soumis | Entités essentielles et importantes de 18 secteurs | Entités financières et leurs prestataires informatiques | Fabricants de produits comportant des éléments numériques | Organisations certifiées |
| Applicable | Selon la transposition nationale (non transposée en France) | Depuis le 17 janvier 2025 | Art. 14 au 11 septembre 2026 ; ensemble au 11 décembre 2027 | Volontaire |
| Inventaire des actifs | Art. 21(2)(i) | Art. 8 | Annexe I, partie II (nomenclature logicielle, SBOM) | A 5.9 |
| Accès et authentification forte | Art. 21(2)(i) et (j) | Art. 9(4)(c) et (d) | Annexe I, partie I | A 8.5 |
| Cryptographie | Art. 21(2)(h) | Art. 9(4)(d) (clés) | Annexe I, partie I | A 8.24 |
| Vulnérabilités et correctifs | Art. 21(2)(e) | Art. 9(4)(f) | Annexe I, partie II | A 8.8 |
| Sauvegarde et restauration | Art. 21(2)(c) | Art. 12 | — | A 8.13 |
| Détection et journalisation | Art. 21(2)(b) | Art. 10 | Annexe I, partie I | A 8.15, A 8.16 |
| Chaîne d'approvisionnement | Art. 21(2)(d) | Art. 28 | Composants tiers intégrés (art. 13) | A 5.19 à A 5.22 |
| Notification des incidents | Art. 23 : 24 h, 72 h, rapport final à un mois | Art. 19 | Art. 14 : 24 h, 72 h, rapport final à 14 jours ou un mois | A 5.24 à A 5.26 |

Rattacher un contrôle à une exigence reste une interprétation, à documenter et à faire valider.

### Un contrôle complet avec Ansible

Testé avec ansible-core 2.21 : un hôte en écart est signalé en `--check`, corrigé par une exécution normale, puis vérifié conforme (`changed: 0`).

```yaml
# Contrôle CTL-ACC-01 — accès SSH par clé uniquement, jamais en root.
# Référentiels : NIS2 art. 21(2)(i) et (j) ; DORA art. 9(4)(c) et (d) ;
# CRA annexe I, partie I ; ISO/IEC 27001:2022, annexe A 8.5.
- name: CTL-ACC-01 — accès SSH par clé, sans connexion root
  hosts: all
  become: true
  vars:
    sshd_config: /etc/ssh/sshd_config
  tasks:
    - name: Désactiver l'authentification par mot de passe
      ansible.builtin.lineinfile:
        path: "{{ sshd_config }}"
        regexp: '^#?PasswordAuthentication\s'
        line: PasswordAuthentication no
        validate: /usr/sbin/sshd -t -f %s
      notify: Recharger sshd
      tags: [CTL-ACC-01]

    - name: Interdire la connexion directe en root
      ansible.builtin.lineinfile:
        path: "{{ sshd_config }}"
        regexp: '^#?PermitRootLogin\s'
        line: PermitRootLogin no
        validate: /usr/sbin/sshd -t -f %s
      notify: Recharger sshd
      tags: [CTL-ACC-01]

  handlers:
    - name: Recharger sshd
      ansible.builtin.service:
        name: ssh
        state: reloaded
```

`validate` fait vérifier la configuration par `sshd` avant de l'installer : une erreur de syntaxe ne coupe jamais l'accès. Le nom du service (`ssh` ou `sshd`) dépend de la distribution.

### Produire la preuve

```bash
# Vérification planifiée, sans rien modifier : le rapport JSON est la preuve
mkdir -p preuves
ANSIBLE_STDOUT_CALLBACK=ansible.posix.json \
  ansible-playbook -i inventaire controle-acces-ssh.yml --check \
  > "preuves/CTL-ACC-01-$(date -u +%Y%m%dT%H%M%SZ).json"

# Lecture : changed à 0 sur chaque hôte = conforme
jq '.stats' preuves/CTL-ACC-01-*.json
```

`ansible.posix.json` est fourni par la collection `ansible.posix`, incluse dans le paquet `ansible`. Planifiée en CI/CD, la vérification produit une preuve par jour ; tout `changed` supérieur à 0 est une dérive, à traiter comme un incident.

### Ranger la correspondance : CISO Assistant

Au-delà de quelques dizaines de contrôles, un outil de GRC (gouvernance, risques et conformité) aide à tenir la table. [CISO Assistant](https://github.com/intuitem/ciso-assistant-community), de la société française intuitem, en est un exemple open source :

- référentiels inclus : notamment NIS2, DORA, le CRA et ISO 27001 ;
- correspondances au format OLIR du NIST ;
- déploiement chez soi (Docker Compose, Helm) et API REST pour l'automatisation ;
- édition communautaire sous AGPL-3.0, certaines fonctions en éditions commerciales.

Vérifiez dans sa documentation d'API ce qui peut être alimenté automatiquement avant d'y brancher la collecte des preuves.

!!! note "Critère de décision"
    Un tableur suffit tant qu'une seule personne tient la correspondance et qu'un seul référentiel compte vraiment. Dès que plusieurs équipes, plusieurs référentiels ou un auditeur externe entrent en jeu, l'outil de GRC devient le registre, et le code des contrôles reste la source de la preuve.

## Erreurs fréquentes

### Chaque audit se prépare en trois semaines

**Symptôme.** Captures d'écran, exports et attestations rassemblés à la main. **Cause.** Les preuves sont reconstituées après coup. **Correction.** Faites-les produire par la vérification planifiée de chaque contrôle, et conservez-les.

### Conforme le jour de l'audit, plus le mois suivant

**Symptôme.** Un contrôle validé en audit est retrouvé en écart lors d'un incident. **Cause.** Une modification manuelle jamais détectée. **Correction.** Vérification quotidienne en `--check`, et une alerte sur tout `changed` supérieur à 0.

### Trois tableurs pour trois référentiels

**Symptôme.** La même mesure décrite et justifiée par trois équipes, avec trois statuts. **Cause.** Un travail organisé par référentiel plutôt que par contrôle. **Correction.** Un catalogue de contrôles unique et une table de correspondance.

### L'auditeur refuse la preuve

**Symptôme.** Le rapport est jugé insuffisant. **Cause.** Il ne dit ni quand, ni sur quel périmètre, ni avec quelle version du code. **Correction.** Horodatez, joignez l'inventaire des hôtes et la référence du commit, et conservez selon une durée définie.

### Le mode --check ne signale rien sur une tâche de commande

**Symptôme.** Une tâche `command` ou `shell` n'est jamais en écart. **Cause.** Ces modules ne savent pas prévoir leur effet et sont ignorés en mode vérification. **Correction.** Des modules déclaratifs (`lineinfile`, `template`, `service`…), ou une tâche de vérification en lecture seule.

## Aide-mémoire

- **Exigence** = quoi ; **contrôle** = comment ; **preuve** = c'est fait, depuis quand.
- **Un contrôle, un identifiant stable**, rattaché à toutes ses exigences.
- **NIS2** : art. 21 (mesures), art. 23 (24 h, 72 h, un mois).
- **DORA** : depuis le 17 janvier 2025 ; art. 8 à 12, 19, 28.
- **CRA** : art. 14 au 11 septembre 2026 ; ensemble au 11 décembre 2027.
- **Ansible** : appliquer, vérifier en `--check`, prouver avec `ansible.posix.json`.
- **`changed: 0`** = conforme ; plus = dérive.
- **Preuve recevable** : horodatée, périmètre, version du code, conservée.

## Pour aller plus loin

- [Objectifs de service](2026-07-10-objectifs-de-service.md), sur ce blog : la même logique de mesure continue, appliquée à la fiabilité.
- [NIS2](https://eur-lex.europa.eu/eli/dir/2022/2555/oj), [DORA](https://eur-lex.europa.eu/eli/reg/2022/2554/oj) et [Cyber Resilience Act](https://eur-lex.europa.eu/eli/reg/2024/2847/oj) : les textes officiels.
- [Obligations de signalement du CRA](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting), Commission européenne.
- [MonEspaceNIS2](https://monespacenis2.cyber.gouv.fr/), ANSSI.
- [Mode vérification d'Ansible](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html) et [`ansible.posix.json`](https://docs.ansible.com/ansible/latest/collections/ansible/posix/json_callback.html).
- [OLIR](https://csrc.nist.gov/projects/olir), NIST, et [CISO Assistant](https://github.com/intuitem/ciso-assistant-community).

Vos audits se préparent encore dans l'urgence ? [Construisons un socle de contrôles vérifiés en continu](../../contact.md).

