---
title: "Réalisations : missions DevOps de référence"
description: "Comptes-rendus de missions DevOps : conformité, Network as Code, livraison continue, infrastructures et SRE, actions menées et bénéfice client."
hide:
  - navigation
  - toc
---

# Réalisations

Des comptes-rendus de missions, classés par expertise principale. Les clients sont désignés par leur secteur.

<section class="vt-mission" markdown>

## Conformité ANSSI et industrialisation pour une entreprise du numérique

:material-shield-check-outline: **Expertise principale** : [Conformité du SI](services.md#conformite-si) · **Durée** : environ 2 ans
{ .vt-mission-meta }

Également mobilisées : [Continuous Delivery](services.md#continuous-delivery), [Développement Python](services.md#python), [Formation & documentation](services.md#formation)
{ .vt-mission-meta }

Actions menées
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Pilotage technique** de l'infrastructure et du développement, en tant que responsable technique.
- **Planification et conduite** du projet de mise en conformité avec les recommandations de l'ANSSI.
- **Conception et déploiement** d'un pipeline de Continuous Delivery.
- **Développement** de modules et de lookup plugins Ansible sur mesure en Python.
- **Formation** de l'équipe à Ansible et à Python.

</div>

Bénéfice client
{ .vt-exp-label }

Une mise en conformité conduite comme un projet planifié, une chaîne de livraison continue en place, et une équipe capable de faire évoluer elle-même l'automatisation.
{ .vt-exp-lead }

</section>

<section class="vt-mission" markdown>

## Network as Code pour un groupe audiovisuel public

:material-ansible: **Expertise principale** : [Infrastructure as Code](services.md#infrastructure-as-code) · **Durée** : environ 1 an
{ .vt-mission-meta }

Également mobilisée : [Formation & documentation](services.md#formation)
{ .vt-mission-meta }

Actions menées
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Conception et développement** d'une automatisation Network as Code.
- **Forge logicielle** dédiée à la configuration des équipements réseau.
- **Automatisation** des configurations réseau via des Collections Ansible.
- **Migration** des configurations existantes vers le code.
- **Plan d'action et ateliers** pour l'équipe réseau : IDE, Ansible, Git, DNS, OPNsense, CI/CD, Proxmox, conteneurs.

</div>

Bénéfice client
{ .vt-exp-label }

Une configuration réseau décrite dans Git, relue et déployée automatiquement, et une équipe réseau outillée pour la faire vivre.
{ .vt-exp-lead }

</section>

<section class="vt-mission" markdown>

## Pipeline de livraison continue pour un grand compte

:material-rocket-launch-outline: **Expertise principale** : [Continuous Delivery](services.md#continuous-delivery) · **Durée** : environ 1 an
{ .vt-mission-meta }

Également mobilisées : [Infrastructure as Code](services.md#infrastructure-as-code), [Formation & documentation](services.md#formation)
{ .vt-mission-meta }

Actions menées
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Découpage** d'une base Ansible monolithique en rôles indépendants, chacun avec son dépôt Git et son cycle de release.
- **Déploiement automatisé** via des Collections Ansible pour les équipes de production.
- **Ateliers** de partage de connaissances : SSL, NFS, Ansible, ClamAV.
- **Onboarding** des nouveaux arrivants et **pair programming**.

</div>

Bénéfice client
{ .vt-exp-label }

Des rôles Ansible qui évoluent et se livrent indépendamment, des déploiements de production automatisés, et une équipe qui partage les mêmes pratiques.
{ .vt-exp-lead }

</section>

<section class="vt-mission" markdown>

## Environnements d'un système de gestion des commandes pour une maison de luxe

:material-server-network: **Expertise principale** : [Infrastructures à grande échelle](services.md#infrastructures) · **Durée** : environ 1 an
{ .vt-mission-meta }

Également mobilisées : [SRE : fiabilité & performance](services.md#sre), [Formation & documentation](services.md#formation)
{ .vt-mission-meta }

Actions menées
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Provisionnement** à grande échelle des machines des futurs environnements.
- **Identification** des goulots d'étranglement et des problèmes de performance.
- **Rédaction et maintenance** du dossier d'architecture technique (DAT) et des schémas d'architecture.

</div>

Bénéfice client
{ .vt-exp-label }

Des environnements provisionnés à grande échelle pour le futur système, des limites de performance identifiées, et une architecture documentée et partagée.
{ .vt-exp-lead }

</section>

<section class="vt-mission" markdown>

## Fiabilisation d'un socle on-premise avant lancement pour un éditeur de cybersécurité

:material-speedometer: **Expertise principale** : [SRE : fiabilité & performance](services.md#sre) · **Durée** : environ 6 mois
{ .vt-mission-meta }

Également mobilisées : [Infrastructure as Code](services.md#infrastructure-as-code), [Continuous Delivery](services.md#continuous-delivery)
{ .vt-mission-meta }

Actions menées
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Fiabilisation** d'un socle applicatif créé de zéro, avant le lancement du produit, destiné à être déployé sur site chez les clients finaux.
- **Socle HashiCorp** : Nomad pour l'orchestration, Consul pour la découverte de services, Vault pour les secrets, le tout provisionné avec Terraform.
- **Tests de panne** des composants du socle, pour vérifier son comportement quand un service tombe.
- **Tests de montée en charge** pour éprouver le socle avant les premiers déploiements chez les clients.
- **Tests de reprise** après incident.
- **Durcissement** du socle et gestion des secrets avec Vault.

</div>

Bénéfice client
{ .vt-exp-label }

Un socle fiabilisé avant le lancement du produit, éprouvé par des tests de panne, de charge et de reprise, et prêt à être déployé chez les clients finaux avec des secrets maîtrisés.
{ .vt-exp-lead }

</section>

## Expérience antérieure

<div class="vt-full" markdown>

Plus de 20 ans en entreprise avant ces missions :

- **14 ans d'ingénierie systèmes et réseau** chez un éditeur de logiciels de simulation : automatisation et support du datacenter, clusters de calcul haute performance (HPC), support de niveau 3 et formation des équipes de niveau 2.
- **Administration réseau et systèmes** pour des sites web à fort trafic : supervision Nagios, messagerie, DNS et VPN inter-sites.
- **Intégration réseau** pour des sites web à fort trafic.

</div>

<div class="vt-cta" data-md-color-scheme="slate" markdown>
**Un contexte similaire ?** [Décrire mon projet](contact.md){ .md-button .md-button--primary }
</div>
