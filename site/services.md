---
title: "Services : Ansible, réseau, CI/CD et IA"
description: "Terraform et Ansible, développement Python, Continuous Delivery, infrastructures, SRE, conformité du SI, IA générative maîtrisée et formation."
hide:
  - navigation
  - toc
---

# Services

<div class="vt-expertises" markdown>

<nav class="vt-exp-list" aria-label="Expertises" markdown>

<a class="vt-exp-item" href="#conformite-si"><span class="vt-exp-index" aria-hidden="true">01</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-shield-check-outline:</span><span class="vt-exp-text"><span class="vt-exp-title">Conformité du SI</span><span class="vt-exp-pitch">Une conformité qui tient dans la durée</span></span></a>

<a class="vt-exp-item" href="#infrastructure-as-code"><span class="vt-exp-index" aria-hidden="true">02</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-ansible:</span><span class="vt-exp-text"><span class="vt-exp-title">Infrastructure as Code</span><span class="vt-exp-pitch">Des déploiements testés et reproductibles</span></span></a>

<a class="vt-exp-item" href="#python"><span class="vt-exp-index" aria-hidden="true">03</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-language-python:</span><span class="vt-exp-text"><span class="vt-exp-title">Développement Python</span><span class="vt-exp-pitch">Vos cas particuliers enfin automatisés</span></span></a>

<a class="vt-exp-item" href="#ia-generative"><span class="vt-exp-index" aria-hidden="true">04</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-robot-outline:</span><span class="vt-exp-text"><span class="vt-exp-title">IA générative maîtrisée</span><span class="vt-exp-pitch">L'IA au service du code, budget maîtrisé</span></span></a>

<a class="vt-exp-item" href="#continuous-delivery"><span class="vt-exp-index" aria-hidden="true">05</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-rocket-launch-outline:</span><span class="vt-exp-text"><span class="vt-exp-title">Continuous Delivery</span><span class="vt-exp-pitch">Des livraisons fréquentes et sans stress</span></span></a>

<a class="vt-exp-item" href="#infrastructures"><span class="vt-exp-index" aria-hidden="true">06</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-server-network:</span><span class="vt-exp-text"><span class="vt-exp-title">Infrastructures à grande échelle</span><span class="vt-exp-pitch">Une infrastructure qui tient la charge</span></span></a>

<a class="vt-exp-item" href="#sre"><span class="vt-exp-index" aria-hidden="true">07</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-speedometer:</span><span class="vt-exp-text"><span class="vt-exp-title">SRE : fiabilité & performance</span><span class="vt-exp-pitch">Moins d'incidents, une fiabilité mesurée</span></span></a>

<a class="vt-exp-item" href="#formation"><span class="vt-exp-index" aria-hidden="true">08</span><span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-school-outline:</span><span class="vt-exp-text"><span class="vt-exp-title">Formation & documentation</span><span class="vt-exp-pitch">Des équipes autonomes après la mission</span></span></a>

</nav>

<div class="vt-exp-panels" markdown>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-shield-check-outline:</span>

## Conformité du SI { #conformite-si }

Une conformité appliquée de façon cohérente et maintenue dans le temps, plutôt qu'un état figé au jour de l'audit.
{ .vt-exp-lead }

Recommandations de l'ANSSI, PCI-DSS, directive NIS 2, mesures de l'ISO/IEC 27002 : quel que soit le référentiel, mettre un système d'information en conformité demande de la méthode et de la constance. La mission planifie et conduit le projet de mise en conformité, en s'appuyant sur l'automatisation pour que les mesures s'appliquent partout de la même façon.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Analyse** du référentiel applicable et des écarts avec l'existant.
- **Planification** du projet de conformité et priorisation des chantiers.
- **Mise en œuvre** des mesures dans le code d'infrastructure, reproductibles et vérifiables.
- **Contrôles automatisés** pour vérifier en continu que les mesures restent appliquées.
- **Suivi et documentation** de l'avancement et des choix techniques, utiles lors des audits.
- **Accompagnement** des équipes dans l'appropriation des nouvelles règles et procédures.

</div>

[Discuter de votre mise en conformité :material-arrow-right:](contact.md){ .vt-next }

</section>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-ansible:</span>

## Infrastructure as Code { #infrastructure-as-code }

Des déploiements reproductibles et des changements relus avant d'être appliqués, des ressources jusqu'aux serveurs et au réseau.
{ .vt-exp-lead }

Vos ressources sont créées à la main, vos déploiements reposent sur des procédures manuelles, ou votre réseau est encore configuré équipement par équipement. La mission décrit l'infrastructure dans du code versionné dans Git : Terraform pour provisionner les ressources, Ansible pour configurer les systèmes et les équipements réseau. Chaque changement est relu avant application puis déployé automatiquement, du poste de développement jusqu'à la production.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Terraform** : provisionnement des ressources d'infrastructure, modules réutilisables et état partagé entre les équipes.
- **Structuration** du code Ansible en rôles et Collections réutilisables et versionnés.
- **Découpage** d'une base monolithique en rôles indépendants, chacun avec son dépôt Git et son cycle de release.
- **Network as Code** : forge logicielle et Collections Ansible pour configurer les équipements réseau.
- **Relecture** de chaque changement dans Git (plan Terraform, différences Ansible) avant application, sur chaque environnement.
- **Migration** progressive de l'existant vers le code, côté ressources, systèmes et réseau.

</div>

[Discuter d'un projet d'Infrastructure as Code :material-arrow-right:](contact.md){ .vt-next }

</section>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-language-python:</span>

## Développement Python { #python }

Une automatisation qui couvre aussi vos cas particuliers, avec du code que vos équipes peuvent reprendre.
{ .vt-exp-lead }

Les modules existants ne suffisent pas toujours : une API interne, un équipement particulier, une règle propre à votre système d'information. La mission développe en Python les briques qui manquent, intégrées à votre automatisation Ansible plutôt que posées à côté. La méthode s'appuie sur l'IA générative : des agents de code accélèrent l'écriture, et chaque proposition est relue et validée avant d'entrer dans votre code. L'équipe est ensuite formée pour faire évoluer ces développements.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Modules Ansible** sur mesure pour piloter vos systèmes et vos API.
- **Lookup plugins** pour alimenter l'automatisation depuis vos propres sources de données.
- **Outillage d'exploitation** en Python pour automatiser les tâches répétitives.
- **Intégration** à vos Collections et à votre chaîne CI/CD, avec le même cycle de release que le reste du code.
- **Développement assisté par IA générative** : agents de code sur modèles locaux (LM Studio, Ollama) ou via l'API OpenAI, sous relecture humaine systématique.
- **Formation** de l'équipe à Ansible et à Python pour reprendre et faire évoluer ces développements.

</div>

[Discuter d'un développement Python :material-arrow-right:](contact.md){ .vt-next }

</section>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-robot-outline:</span>

## IA générative maîtrisée { #ia-generative }

Un assistant de code adapté à votre contexte, et un budget IA prévisible, dimensionné sur vos usages réels.
{ .vt-exp-lead }

Vos équipes veulent un assistant de code adapté à leurs outils, sans forcément confier leur code à un fournisseur externe, ni subir une facture qui suit l'usage plutôt que la valeur. La mission développe en Python des agents de code IA, appuyés sur un modèle exécuté en local avec LM Studio ou Ollama, ou hébergé via l'API OpenAI, et planifie la consommation de GPU et de tokens qui va avec.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **État des lieux** des usages de l'IA dans l'entreprise et de ce qu'ils consomment.
- **Agents de code IA** en Python, adaptés à vos outils et à vos dépôts.
- **Choix des modèles** : en local avec LM Studio ou Ollama pour garder code et données chez vous, via l'API OpenAI quand le besoin le justifie.
- **Intégration** des agents à votre chaîne existante : Git, CI/CD, automatisation Ansible.
- **Planification** de la capacité en GPU et en tokens : quels usages en local, lesquels sur une API, pour quel volume.
- **Déploiement et suivi** de l'infrastructure retenue et de ses coûts, pour ajuster les choix dans le temps.

</div>

[Discuter d'un projet d'IA générative :material-arrow-right:](contact.md){ .vt-next }

</section>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-rocket-launch-outline:</span>

## Continuous Delivery { #continuous-delivery }

Des livraisons plus fréquentes et moins risquées, avec le même processus pour chaque environnement.
{ .vt-exp-lead }

Un pipeline de livraison continue transforme chaque changement validé en déploiement fiable et répétable. La mission conçoit et met en place ce pipeline, pour vos applications comme pour l'infrastructure elle-même, selon le modèle qui convient à votre contexte : déploiement poussé par la chaîne CI/CD, ou approche GitOps, où l'état souhaité décrit dans Git est appliqué et réconcilié en continu. La chaîne est ensuite confiée à votre équipe.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Conception** du pipeline : étapes, environnements, critères de passage, modèle de déploiement (poussé par la CI/CD ou GitOps).
- **Vérifications automatisées** à chaque étape, avant tout passage en production.
- **Déploiement et maintenance** de multiples environnements.
- **Intégration** de l'automatisation Ansible dans la chaîne CI/CD.
- **Livraison de l'infrastructure** par le même pipeline que les applications.
- **Documentation et transfert** pour que l'équipe s'approprie la chaîne de livraison.

</div>

[Discuter de votre chaîne de livraison :material-arrow-right:](contact.md){ .vt-next }

</section>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-server-network:</span>

## Infrastructures à grande échelle { #infrastructures }

Une infrastructure qui tient la charge, exploitée avec des procédures claires et éprouvées.
{ .vt-exp-lead }

Nouveaux environnements à provisionner, datacenter à automatiser, clusters de calcul haute performance ou plateformes web de production à exploiter : la mission prend en charge l'infrastructure qui doit tenir la charge, de son déploiement à son exploitation au quotidien, avec des procédures automatisées plutôt que des gestes manuels.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Provisionnement** à grande échelle des machines de nouveaux environnements.
- **Automatisation** du datacenter : installation et configuration des machines.
- **Exploitation** de clusters de calcul haute performance (HPC) et de plateformes web de production.
- **Réseau d'infrastructure** : DNS, VPN inter-sites, pare-feu OPNsense.
- **Supervision** des systèmes et modernisation des outils de monitoring.
- **Procédures** d'exploitation validées, outillées et documentées.

</div>

[Discuter de votre infrastructure :material-arrow-right:](contact.md){ .vt-next }

</section>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-speedometer:</span>

## SRE : fiabilité & performance { #sre }

Une fiabilité pilotée par des objectifs mesurables, et des équipes qui passent moins de temps à éteindre des incendies.
{ .vt-exp-lead }

Lenteurs inexpliquées, incidents qui reviennent, équipes d'exploitation absorbées par les tâches manuelles : la mission applique les pratiques du Site Reliability Engineering (SRE), quel que soit le socle : serveurs physiques ou virtuels, clusters Kubernetes, calcul haute performance. Elle définit avec vous des objectifs de service mesurables, cherche les causes plutôt que les symptômes, et automatise le travail répétitif pour que les mêmes problèmes ne reviennent pas.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Objectifs de service** (SLI, SLO) et budget d'erreur, définis à partir de ce qui compte pour vos utilisateurs.
- **Observabilité** : métriques, journaux et alertes alignés sur ces objectifs.
- **Analyse** des goulots d'étranglement et des problèmes de performance, mesures à l'appui, des serveurs jusqu'aux charges conteneurisées sur Kubernetes.
- **Gestion des incidents** en expertise de niveau 3, suivie de post-mortems sans reproche et d'actions correctives.
- **Réduction du travail répétitif** (toil) par l'automatisation, et validation des nouveaux outils et procédures d'exploitation.
- **Formation** des équipes de support de niveau 2.

</div>

[Discuter de la fiabilité de votre service :material-arrow-right:](contact.md){ .vt-next }

</section>

<section class="vt-exp-panel" markdown>

<span class="vt-exp-icon" aria-hidden="true" markdown="span">:material-school-outline:</span>

## Formation & documentation { #formation }

Des équipes autonomes et une documentation à jour, qui survit à la fin de la mission.
{ .vt-exp-lead }

La culture DevOps se diffuse par la pratique partagée. Cette mission, seule ou intégrée aux autres, transmet à vos équipes ce qui a été construit pour qu'elles restent autonomes : c'est le sens du « *make it manageable* » de ma devise.

Exemples de périmètre de mission
{ .vt-exp-label }

<div class="vt-exp-checks" markdown>

- **Ateliers** de partage de connaissances : Ansible, Git, SSL, NFS, ClamAV, CI/CD, conteneurs.
- **Onboarding** des nouveaux arrivants et **pair programming**.
- **Formation** d'équipes à Ansible et à Python.
- **Plan d'action** pour accompagner une équipe vers de nouveaux outils : IDE, Git, DNS, OPNsense, CI/CD, Proxmox, conteneurs.
- **Rédaction** de dossiers d'architecture technique (DAT) et de schémas d'architecture.
- **Documentation d'exploitation** : procédures maintenues au même rythme que le code.

</div>

[Discuter d'une formation :material-arrow-right:](contact.md){ .vt-next }

</section>

</div>

</div>

## Modalités

<div class="vt-tiles" markdown>

- **Télétravail** — missions à distance, depuis Propriano (Corse).
- **Sur site** — déplacements ponctuels possibles, planifiés à l'avance, lorsque la mission le demande.
- **Bilingue** — interventions en français et en anglais.
- **Démarrage** — date fixée ensemble dès le premier échange, selon votre calendrier et mes engagements en cours.

</div>

<div class="vt-cta" data-md-color-scheme="slate" markdown>
**Un projet d'automatisation ?** [Décrire mon projet](contact.md){ .md-button .md-button--primary }
</div>
