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

L'essentiel, pour qui ne lirait que ces lignes :

1. Un référentiel dit **quoi** ; le contrôle dit **comment** ; la preuve montre que c'est **fait**, et depuis quand.
2. NIS2, DORA, le CRA et ISO 27001 se recoupent largement : un contrôle bien décrit sert à tous.
3. Un contrôle écrit en code se vérifie sans rien modifier, chaque jour, et chaque vérification est une preuve.

## Contexte

En juillet 2026, une même organisation peut relever de trois textes européens à la fois. **DORA** s'applique depuis le 17 janvier 2025 aux entités financières et à leurs prestataires informatiques. Le **Cyber Resilience Act** impose aux fabricants de produits comportant des éléments numériques de signaler les vulnérabilités activement exploitées à partir du 11 septembre 2026, avant ses exigences complètes au 11 décembre 2027. **NIS2** n'est toujours pas transposée en France : la Commission européenne a saisi la Cour de justice de l'UE le 8 juillet 2026, et l'ANSSI publie en attendant ReCyF, un référentiel de travail en 20 objectifs. À cela s'ajoute souvent une certification **ISO/IEC 27001**.

La réponse habituelle est un tableur par référentiel, tenu par une équipe différente, et un audit qui se prépare en rassemblant des captures d'écran dans l'urgence. Les mêmes mesures (authentification forte, correctifs, sauvegardes, journalisation) y sont décrites trois ou quatre fois, et vérifiées une fois par an au mieux.

La conformité continue renverse la logique : chaque mesure est décrite **une fois**, sous forme de contrôle exécutable, rattachée à toutes les exigences qu'elle couvre, et vérifiée en permanence. Cet article en présente les concepts et un premier contrôle complet. Il ne constitue pas un avis juridique : le périmètre exact de chaque texte pour votre organisation relève de vos juristes et de vos autorités.

## Concepts clés

![Schéma : quatre exigences, NIS2 article 21 paragraphe 2, DORA article 9 paragraphe 4, CRA annexe I et ISO 27001 mesure A 8.5, pointent vers un seul contrôle, CTL-ACC-01, accès SSH par clé sans connexion root, décrit une seule fois en code Ansible. Ce contrôle est appliqué, ce qui corrige l'écart sur chaque hôte, et vérifié de façon planifiée en mode check, sans rien modifier. La vérification produit une preuve, un rapport JSON horodaté où changed égal zéro signifie conforme ; un écart détecté déclenche la correction. Les preuves vont à l'auditeur ou à un outil de GRC : une preuve, rattachée à plusieurs référentiels.](../../assets/images/blog/conformite-continue-light.png#only-light)
![Schéma : quatre exigences, NIS2 article 21 paragraphe 2, DORA article 9 paragraphe 4, CRA annexe I et ISO 27001 mesure A 8.5, pointent vers un seul contrôle, CTL-ACC-01, accès SSH par clé sans connexion root, décrit une seule fois en code Ansible. Ce contrôle est appliqué, ce qui corrige l'écart sur chaque hôte, et vérifié de façon planifiée en mode check, sans rien modifier. La vérification produit une preuve, un rapport JSON horodaté où changed égal zéro signifie conforme ; un écart détecté déclenche la correction. Les preuves vont à l'auditeur ou à un outil de GRC : une preuve, rattachée à plusieurs référentiels.](../../assets/images/blog/conformite-continue-dark.png#only-dark)

### Exigence

**Définition.** Ce qu'un texte impose, formulé en objectif : NIS2 demande par exemple, à son article 21, des politiques de contrôle d'accès et le recours à l'authentification multifacteur.

**À ne pas confondre avec** une solution technique : un texte européen dit rarement comment faire, et c'est voulu.

**Exemple.** DORA, article 9(4)(d) : mettre en place des politiques et protocoles pour des mécanismes d'authentification forte.

**En pratique.** Une exigence se lit avec son périmètre : qui y est soumis, et à partir de quand.

### Contrôle

**Définition.** La mesure concrète qui répond à une ou plusieurs exigences, identifiée par un code stable (`CTL-ACC-01`) et décrite assez précisément pour être vérifiée.

**À ne pas confondre avec** une politique : « l'accès aux serveurs est protégé » est une intention ; « SSH n'accepte que les clés et refuse la connexion root » est un contrôle.

**Exemple.** `CTL-ACC-01` couvre à la fois NIS2 21(2)(i) et (j), DORA 9(4)(c) et (d), l'annexe I du CRA et la mesure A 8.5 d'ISO 27001.

**En pratique.** Le contrôle est l'unité de travail : on le décrit, on l'applique, on le vérifie, on le rattache.

### Preuve

**Définition.** L'élément qui montre qu'un contrôle est en place sur un périmètre donné, à une date donnée.

**À ne pas confondre avec** une déclaration : « nous désactivons les mots de passe SSH » n'est pas une preuve ; le rapport de vérification de chaque hôte, horodaté, en est une.

**Exemple.** Le rapport JSON d'une exécution en mode vérification : la liste des hôtes, des tâches et de leur état, avec la date.

**En pratique.** Une preuve utile est **horodatée**, **rattachée à un périmètre** (quels hôtes), **reproductible** (quelle version du code) et **conservée**.

### Table de correspondance

**Définition.** La table qui relie chaque contrôle aux exigences qu'il couvre, dans chaque référentiel.

**À ne pas confondre avec** une équivalence entre référentiels : deux exigences proches ne se recouvrent pas toujours entièrement, et la table doit le dire.

**Exemple.** Le NIST maintient un format de correspondance entre référentiels, OLIR (*Online Informative References*), repris par certains outils de GRC.

**En pratique.** Un nouveau référentiel ne demande plus de nouveaux contrôles, mais une nouvelle colonne, et l'identification des écarts.

### Dérive

**Définition.** L'écart qui apparaît entre l'état décrit et l'état réel d'un système : une modification manuelle, un paquet mis à jour, un serveur ajouté hors du processus.

**À ne pas confondre avec** une non-conformité constatée en audit : la dérive existe dès le lendemain de l'audit, qu'on la mesure ou non.

**Exemple.** Un administrateur réactive l'authentification par mot de passe pour dépanner, et oublie de la désactiver.

**En pratique.** Seule une vérification fréquente rend la dérive visible avant l'audit, ou avant l'attaquant.

### Contrôle décrit en code

**Définition.** Un contrôle écrit dans un outil d'automatisation déclaratif, qui sait à la fois appliquer l'état attendu et vérifier l'état réel sans le modifier. Avec Ansible, c'est le mode `--check`.

**À ne pas confondre avec** un script de durcissement exécuté une fois : un script modifie, il ne dit pas si l'état est encore le bon six mois plus tard.

**Exemple.** Le même playbook corrige un hôte en écart, puis, exécuté en `--check`, rapporte `changed: 0` sur chaque hôte conforme.

**En pratique.** Le code du contrôle, versionné et relu, devient lui-même un élément de preuve : il montre **comment** la mesure est appliquée.

## Référence rapide

### Concepts

| Concept | Définition courte | Ce que ça change en pratique | À ne pas confondre avec |
|---|---|---|---|
| Exigence | Ce que le texte impose | Le « quoi », avec son périmètre | Une solution technique |
| Contrôle | La mesure concrète, identifiée | L'unité de travail, vérifiable | Une politique |
| Preuve | Ce qui montre le contrôle en place, à une date | L'audit se nourrit de l'exploitation | Une déclaration |
| Table de correspondance | Contrôle → exigences de chaque référentiel | Un référentiel de plus, une colonne de plus | Une équivalence parfaite |
| Dérive | Écart entre état décrit et état réel | Se mesure en continu, pas une fois par an | Une non-conformité d'audit |
| Contrôle en code | Appliquer et vérifier avec le même code | La vérification produit la preuve | Un script de durcissement |

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

Les références d'articles renvoient aux textes officiels ; la correspondance d'un contrôle à une exigence reste une interprétation à documenter et à faire valider.

### Un contrôle complet avec Ansible

Le contrôle `CTL-ACC-01`, avec ses références en commentaire et une étiquette à son identifiant. Testé avec ansible-core 2.21 : un hôte en écart est signalé en `--check` (`changed` supérieur à 0), corrigé par une exécution normale, puis vérifié conforme (`changed: 0`).

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

1. `validate` fait vérifier la nouvelle configuration par `sshd` avant de la mettre en place : une erreur de syntaxe ne coupe jamais l'accès.
2. L'étiquette `CTL-ACC-01` permet de n'exécuter que ce contrôle (`--tags CTL-ACC-01`).
3. Le nom du service (`ssh` ou `sshd`) dépend de la distribution.

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

Le greffon de sortie `ansible.posix.json` fait partie de la collection `ansible.posix`, incluse dans le paquet `ansible`. Planifiée dans la chaîne CI/CD, cette vérification produit une preuve par jour ; un `changed` supérieur à 0 signale une dérive, à traiter comme un incident.

### Ranger la correspondance : CISO Assistant

Une table de correspondance tient dans un fichier tant que les contrôles se comptent en dizaines. Au-delà, un outil de GRC (gouvernance, risques et conformité) aide à la maintenir. [CISO Assistant](https://github.com/intuitem/ciso-assistant-community), édité par la société française intuitem, en est un exemple open source :

- sa bibliothèque de référentiels comprend notamment NIS2, DORA, le CRA et ISO 27001 ;
- il sépare les exigences des mesures de sécurité, et s'appuie sur le format OLIR du NIST pour les correspondances entre référentiels ;
- il se déploie chez soi (Docker Compose, Helm) et expose une API REST destinée à l'automatisation ;
- l'édition communautaire est sous licence AGPL-3.0 ; certaines fonctions relèvent d'éditions commerciales.

Vérifiez dans sa documentation d'API quels objets peuvent être alimentés automatiquement avant de bâtir la collecte des preuves dessus.

!!! note "Critère de décision"
    Un tableur suffit tant qu'une seule personne tient la correspondance et qu'un seul référentiel compte vraiment. Dès que plusieurs équipes, plusieurs référentiels ou un auditeur externe entrent en jeu, l'outil de GRC devient le registre, et le code des contrôles reste la source de la preuve.

## Erreurs fréquentes

### Chaque audit se prépare en trois semaines

**Symptôme.** Avant chaque audit, des captures d'écran, des exports et des attestations sont rassemblés à la main.

**Cause.** Les preuves sont reconstituées après coup, au lieu d'être produites par l'exploitation.

**Correction.** Faites produire la preuve par la vérification planifiée de chaque contrôle, et conservez-la.

### Conforme le jour de l'audit, plus le mois suivant

**Symptôme.** Un contrôle validé en audit est retrouvé en écart lors d'un incident.

**Cause.** La dérive : une modification manuelle n'a jamais été détectée.

**Correction.** Vérifiez chaque jour en mode `--check`, et alertez sur tout `changed` supérieur à 0.

### Trois tableurs pour trois référentiels

**Symptôme.** La même mesure est décrite, testée et justifiée par trois équipes, avec trois statuts différents.

**Cause.** Le travail est organisé par référentiel, et non par contrôle.

**Correction.** Tenez un catalogue de contrôles unique et une table de correspondance vers chaque référentiel.

### L'auditeur refuse la preuve

**Symptôme.** Le rapport de vérification est jugé insuffisant.

**Cause.** Il ne dit ni quand, ni sur quel périmètre, ni avec quelle version du code il a été produit.

**Correction.** Horodatez, joignez l'inventaire des hôtes vérifiés et la référence du commit du code de contrôle, et conservez les rapports selon une durée définie.

### Le mode --check ne signale rien sur une tâche de commande

**Symptôme.** Une tâche `ansible.builtin.command` ou `shell` n'est jamais rapportée en écart.

**Cause.** Ces modules ne savent pas prévoir leur effet : en mode vérification, ils sont ignorés.

**Correction.** Utilisez des modules déclaratifs (`lineinfile`, `template`, `service`…), ou écrivez une tâche de vérification explicite en lecture seule.

## Aide-mémoire

- **Exigence** = quoi ; **contrôle** = comment ; **preuve** = c'est fait, depuis quand.
- **Un contrôle, un identifiant stable** (`CTL-ACC-01`), rattaché à toutes les exigences qu'il couvre.
- **NIS2** : art. 21 (mesures), art. 23 (notification 24 h, 72 h, un mois).
- **DORA** : depuis le 17 janvier 2025 ; art. 8 à 12 (risque informatique), art. 19 (incidents), art. 28 (prestataires).
- **CRA** : art. 14 au 11 septembre 2026 (24 h, 72 h, 14 jours) ; annexe I au 11 décembre 2027.
- **Ansible** : appliquer sans option, vérifier en `--check`, prouver en `ansible.posix.json`.
- **`changed: 0`** sur chaque hôte = conforme ; supérieur à 0 = dérive.
- **Preuve recevable** : horodatée, périmètre, version du code, conservée.
- **Modules déclaratifs** plutôt que `command` ou `shell`.
- **Outil de GRC** (ex. CISO Assistant) dès que plusieurs référentiels et équipes sont en jeu.

## Pour aller plus loin

- [Objectifs de service : les définir, les mesurer, s'en servir](2026-07-10-objectifs-de-service.md), sur ce blog : la même logique de mesure continue, appliquée à la fiabilité.
- [Directive NIS2 (UE) 2022/2555](https://eur-lex.europa.eu/eli/dir/2022/2555/oj), [règlement DORA (UE) 2022/2554](https://eur-lex.europa.eu/eli/reg/2022/2554/oj) et [Cyber Resilience Act (UE) 2024/2847](https://eur-lex.europa.eu/eli/reg/2024/2847/oj) : les textes officiels.
- [Obligations de signalement du CRA](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting), Commission européenne.
- [MonEspaceNIS2](https://monespacenis2.cyber.gouv.fr/), ANSSI : NIS2 en France, assujettissement et référentiel.
- [Mode vérification d'Ansible](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html) et [greffon de sortie `ansible.posix.json`](https://docs.ansible.com/ansible/latest/collections/ansible/posix/json_callback.html).
- [OLIR](https://csrc.nist.gov/projects/olir), NIST : le format de correspondance entre référentiels.
- [CISO Assistant](https://github.com/intuitem/ciso-assistant-community) : outil de GRC open source.

Vos audits se préparent encore dans l'urgence ? [Construisons un socle de contrôles vérifiés en continu](../../contact.md).
