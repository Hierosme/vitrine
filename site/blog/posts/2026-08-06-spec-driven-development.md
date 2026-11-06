---
date: 2026-08-06
authors:
  - jerome
categories:
  - "IA générative maîtrisée"
slug: spec-driven-development
description: "Spec-driven development : écrire la spécification avant de faire coder l'agent IA. Les trois niveaux, les outils, les pièges, et où placer la relecture humaine."
type: mixte
niveau: confirmé
derniere_verification: 2026-11-06
---

Thème : :material-robot-outline: [IA générative maîtrisée](../../services.md#ia-generative)
{ .vt-post-service }

# Spec-driven development : la spécification avant le code

Avec un agent de code, la tentation est de décrire le besoin en une phrase et de laisser faire. Le spec-driven development inverse l'ordre : on écrit d'abord une spécification, que l'humain et l'agent prennent pour référence. Cet article en définit les notions, compare les outils et montre où placer la relecture humaine.

<!-- more -->

## En bref

À l'issue de cet article, vous saurez :

- **distinguer** les trois niveaux du spec-driven development : la spécification d'abord, la spécification ancrée, la spécification comme source ;
- **rédiger** une spécification courte, aux exigences testables, qu'un agent peut suivre ;
- **choisir** quand l'approche se justifie, et quand elle alourdit un petit changement ;
- **placer** les points de relecture et de validation humaine du cycle.

À retenir :

1. La spécification dit **quoi** et **pourquoi** ; le plan dit **comment** ; l'agent code tâche par tâche.
2. Chaque étape est relue et validée par un humain : la spécification ne transfère pas la responsabilité à l'agent.
3. La spécification utile est **courte et testable** ; une spécification de vingt pages déplace le problème de la relecture du code vers la relecture du texte.

## Contexte

Un agent de code reçoit : « ajoute la gestion des enregistrements DNS au module ». Il produit trois cents lignes plausibles, qui créent bien des enregistrements, mais ignorent le mode vérification et les erreurs de l'API, et suppriment au passage des enregistrements que personne n'avait demandé de toucher. L'agent n'a pas désobéi : la demande ne disait rien de tout cela.

Le spec-driven development répond à ce problème. Birgitta Böckeler, sur le site de Martin Fowler, le définit comme le fait d'écrire une spécification avant le code, qui devient la source de vérité pour l'humain comme pour l'IA. L'approche s'est outillée en 2025, avec Kiro chez AWS et Spec Kit, publié en open source par GitHub en septembre. Le Technology Radar de Thoughtworks l'a classée en novembre 2025 dans l'anneau *Assess*, avec des réserves sur des processus lourds et des spécifications longues à relire.

## Concepts clés

![Schéma : un cycle en cinq étapes. La constitution fixe les principes du projet (tests d'abord, conventions, sécurité). La spécification dit quoi et pourquoi (exigences testables, hors périmètre). Le plan dit comment (architecture, choix techniques). Les tâches découpent le travail en petites étapes vérifiables. À l'implémentation, l'agent code une tâche à la fois, avec ses tests. Entre chaque étape, le livrable est relu et validé. L'implémentation aboutit à une vérification humaine, mise en valeur : tests, relecture du code, validation finale manuelle. En cas d'écart, on revient à la spécification, qui évolue.](../../assets/images/blog/spec-driven-development-light.png#only-light)
![Schéma : un cycle en cinq étapes. La constitution fixe les principes du projet (tests d'abord, conventions, sécurité). La spécification dit quoi et pourquoi (exigences testables, hors périmètre). Le plan dit comment (architecture, choix techniques). Les tâches découpent le travail en petites étapes vérifiables. À l'implémentation, l'agent code une tâche à la fois, avec ses tests. Entre chaque étape, le livrable est relu et validé. L'implémentation aboutit à une vérification humaine, mise en valeur : tests, relecture du code, validation finale manuelle. En cas d'écart, on revient à la spécification, qui évolue.](../../assets/images/blog/spec-driven-development-dark.png#only-dark)

### Spécification

Elle décrit ce que le changement doit faire, et pourquoi : contexte, exigences, hors périmètre, critères d'acceptation. Un prompt sert une fois ; une spécification se relit, se valide et se conserve. Celle qui décrit le comment (classes, bibliothèques) empiète sur le plan et prive le relecteur d'un critère simple : le résultat fait-il ce qui était demandé ?

### Les trois niveaux

Birgitta Böckeler distingue la spécification d'abord (*spec-first*), écrite pour la tâche en cours ; la spécification ancrée (*spec-anchored*), conservée pour faire évoluer la fonctionnalité ; la spécification comme source (*spec-as-source*), seul fichier que l'humain modifie. Tous les outils pratiquent le premier niveau, peu visent les suivants : en octobre 2025, elle classait Kiro et Spec Kit au premier, et seul Tessl, alors en bêta privée, visait le deuxième. Commencez par le premier ; réservez l'ancrage aux fonctionnalités durables.

### Constitution

Dans Spec Kit, les principes non négociables du projet, que chaque spécification et chaque plan respectent : tests écrits avant le code, fonctionnalités accessibles en ligne de commande, aucun secret dans le dépôt. Elle vaut pour tout le projet et change rarement. Quelques principes vérifiables valent mieux qu'une longue charte.

### Exigence testable

Une exigence formulée de façon qu'un test puisse la vérifier. Kiro utilise la notation EARS (*Easy Approach to Requirements Syntax*) : « QUAND condition, LE SYSTÈME DOIT comportement ». « Le module est robuste » est une intention ; « si l'API répond en erreur, le module échoue avec son message » est une exigence. Chacune donne au moins un test, sinon elle s'oublie à la relecture.

### Plan et tâches

Le plan traduit la spécification en choix techniques ; les tâches le découpent en petites étapes, chacune terminée par un résultat constatable, un test qui passe par exemple. « Implémenter le mode vérification, avec son test » plutôt que « écrire `module.py` » : des tâches courtes donnent des changements courts, les seuls qu'on relit vraiment.

### Relecture et validation humaines

À chaque étape, une personne relit et valide avant la suivante : spécification, plan, tâches, puis code et tests. Relire, c'est vérifier que l'agent a fait ce que dit la spécification, et seulement cela. Le blog de GitHub qui présente Spec Kit le résume : le rôle de l'humain n'est pas seulement de piloter, c'est de vérifier. C'est aussi la règle de la [charte IA de ce site](../../charte-ia.md).

### Écart entre spécification et code

Il apparaît quand le code évolue sans la spécification, le plus souvent par une correction faite directement dans le code. Au niveau de la spécification ancrée, toute modification de comportement passe donc par la spécification, dans le même changement que le code.

## Référence rapide

### Outils

| Outil | Ce qu'il propose | Niveau visé, selon Böckeler (octobre 2025) |
|---|---|---|
| [Spec Kit](https://github.com/github/spec-kit) (GitHub, open source, licence MIT) | Une CLI et des commandes pour l'agent : constitution, spécification, plan, tâches, implémentation ; compatible avec plusieurs agents de code | Spécification d'abord |
| [Kiro](https://kiro.dev/docs/specs/) (AWS) | Un environnement de développement qui produit trois fichiers par fonctionnalité : exigences, conception, tâches | Spécification d'abord |
| Tessl | Une plateforme qui vise la spécification ancrée, voire comme source ; en bêta privée lors de cette analyse | Spécification ancrée |

Les commandes de Spec Kit ont changé de nom au fil des versions : référez-vous à la documentation de la version installée.

### Quand l'approche se justifie

| Situation | Spécification ? |
|---|---|
| Nouvelle fonctionnalité, plusieurs comportements, plusieurs fichiers | Oui |
| Module partagé, utilisé par d'autres équipes | Oui, et ancrée |
| Correctif d'une ligne, comportement évident | Non : un bon message de commit suffit |
| Exploration, prototype jetable | Non, ou une spécification de quelques lignes |

### Exemple de spécification courte

Pour un module Ansible fictif, `dns_record`, en notation inspirée d'EARS. Elle tient sur un écran, et c'est voulu.

```markdown
# Spécification : module Ansible dns_record

## Contexte
Les enregistrements DNS sont aujourd'hui créés à la main dans la console
du fournisseur. Le module doit les gérer depuis les playbooks.

## Exigences
1. QUAND l'enregistrement demandé n'existe pas, LE MODULE DOIT le créer
   et renvoyer changed=true.
2. QUAND l'enregistrement existe avec la même valeur, LE MODULE DOIT
   ne rien modifier et renvoyer changed=false.
3. QUAND le module s'exécute en mode vérification (--check), LE MODULE
   DOIT annoncer le changement sans l'appliquer.
4. SI l'API du fournisseur répond en erreur, LE MODULE DOIT échouer
   avec le message de l'API.

## Hors périmètre
- Suppression d'enregistrements.
- Gestion des zones.

## Critères d'acceptation
- Un test unitaire par exigence.
- Les tests de qualité d'Ansible (ansible-test sanity) passent.
```

1. Le **hors périmètre** est aussi important que les exigences : il dit à l'agent ce qu'il ne doit pas toucher.
2. Chaque exigence numérotée devient un test : la relecture vérifie la correspondance.
3. Aucune exigence ne dit comment coder : c'est le rôle du plan.

!!! note "Critère de décision"
    Si la spécification est plus longue que le code qu'elle décrit, elle est probablement trop détaillée, ou le changement trop petit pour en mériter une.

## Erreurs fréquentes

### Un petit correctif devient quatre récits utilisateur

**Symptôme.** Une correction d'une ligne produit exigences, conception et une dizaine de tâches. **Cause.** Le même processus pour tous les changements, travers relevé par Böckeler dès ses premiers essais. **Correction.** Réservez la spécification aux changements qui la justifient.

### Personne ne relit les spécifications générées

**Symptôme.** De longs fichiers Markdown, validés sans être lus. **Cause.** La relecture du code a simplement été déplacée vers celle du texte. **Correction.** Des spécifications courtes, des exigences écrites ou réécrites à la main, relues comme du code.

### L'agent ne suit pas la spécification

**Symptôme.** Une exigence ignorée, ou un changement hors périmètre. **Cause.** Une spécification guide l'agent sans le contraindre ; Böckeler parle d'un faux sentiment de contrôle. **Correction.** Un test par exigence, et une relecture qui compare le code à la spécification point par point.

### La spécification ne correspond plus au code

**Symptôme.** Trois mois plus tard, elle décrit un comportement disparu. **Cause.** Les évolutions sont faites directement dans le code. **Correction.** Pour les fonctionnalités durables, la spécification évolue dans le même changement que le code.

!!! warning "Attention"
    Une spécification n'est pas une délégation : la responsabilité de ce qui part en production reste celle de la personne qui valide.

## Aide-mémoire

- **Spécification** : quoi et pourquoi ; **plan** : comment ; **tâches** : étapes vérifiables.
- **Trois niveaux** : d'abord, ancrée, comme source.
- **Constitution** : quelques principes vérifiables, pour tout le projet.
- **Exigence testable** : QUAND condition, LE SYSTÈME DOIT comportement.
- **Hors périmètre** écrit noir sur blanc ; **un test par exigence**.
- **Relecture humaine** à chaque étape ; **validation finale manuelle**, toujours.
- **Petit changement** : pas de spécification.
- **Écart** : la spécification évolue avec le code.

## Pour aller plus loin

- [Charte IA](../../charte-ia.md), sur ce site : relecture humaine fine et validation finale manuelle.
- [Understanding Spec-Driven-Development: Kiro, spec-kit, and Tessl](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html), Birgitta Böckeler, octobre 2025 : les trois niveaux et une analyse critique des outils.
- [Spec-driven development with AI](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/), blog GitHub, septembre 2025, et le [dépôt Spec Kit](https://github.com/github/spec-kit).
- [Spécifications dans Kiro](https://kiro.dev/docs/specs/) : exigences, conception, tâches.
- [Spec-driven development](https://www.thoughtworks.com/radar/techniques/spec-driven-development), Technology Radar de Thoughtworks, novembre 2025.

Vos équipes adoptent des agents de code et veulent garder la main sur ce qui part en production ? [Parlons de votre cadre de travail avec l'IA](../../contact.md).
