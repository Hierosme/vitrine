# AGENTS.md — vitrine DevOps freelance

Site vitrine statique de **Jérôme Ornech**, Expert DevOps freelance (automatisation systèmes et réseaux, Ansible, Python, Network as Code, Continuous Delivery), généré avec **MkDocs + Material** (plugin blog), thèmes clair et sombre sur la palette **Nord**, hébergé sur **GitHub Pages** avec un domaine personnel (DNS chez DNSimple).

## À charger au démarrage de chaque session

Lis ces fichiers **avant toute action** :

1. `docs/README.md` — index de la documentation projet
2. `docs/architecture.md` — arborescence, commandes, déploiement
3. `backlog.md` — travail en attente : si la demande correspond à une tâche, suivre son prompt et poser ses questions à l'opérateur **avant** de modifier quoi que ce soit, puis mettre à jour son statut

## Skills — chargement obligatoire selon la tâche

Avant de modifier quoi que ce soit, identifie les skills concernés et **lis leur `SKILL.md` en entier**, puis respecte leurs règles et leur checklist.

| Skill | Chemin | À charger si la tâche touche… |
|---|---|---|
| `site-navigation` | `docs/skills/site-navigation/SKILL.md` | `mkdocs.yml` (`nav`, `features`, `plugins.blog`), ajout/renommage/suppression de page dans `site/`, article de blog, liens internes |
| `site-look-and-feel` | `docs/skills/site-look-and-feel/SKILL.md` | `site/stylesheets/`, `mkdocs.yml` (`theme`), palette Nord, thèmes clair et sombre, mise en page, composants, couleurs, polices, icônes |

En cas de doute, charge les deux. Une nouvelle page de contenu les concerne toujours tous les deux.

**Décision de design non couverte par un skill**, ou demande de « pourquoi » : lis `docs/explanation/design-system.md`. Il décrit les fondements (première impression, crédibilité, ergonomie cognitive) et leurs sources. Toute nouvelle règle doit pouvoir s'y rattacher. Sinon, propose de compléter l'explication avant de coder.

## Arborescence

- `site/` — sources **du site public** (Markdown, CSS). Rien d'autre.
- `docs/` — documentation **du projet** et skills. Jamais publiée.
- `overrides/` (métadonnées SEO), `hooks/` (génération de `robots.txt`) : extensions du build, voir `docs/architecture.md`.
- `backlog.md` — tâches en attente, avec prompts, questions à l'opérateur et suivi.
- `build/`, `build-docs/` — sorties générées, ne pas éditer, ne pas committer.

## Commandes

Toujours passer par les tâches mise (`.mise/tasks/`), jamais par `mkdocs` directement :

```bash
mise run preview                       # aperçu site (:8000) + doc projet (:8001)
mise run blog:new "Titre" -c Ansible   # nouvel article (brouillon)
mise run check                         # design system + builds stricts — DOIT passer avant de terminer
```

Liste complète : `docs/architecture.md` § Commandes, ou `mise tasks`.
Nouvelle tâche : script bash exécutable dans `.mise/tasks/` (en-têtes `#MISE description=…`, compatible bash 3.2), à ajouter au tableau de `docs/architecture.md`.

## Conventions

- Contenu du site en **français**, ton professionnel et direct, à la première personne.
- Source de vérité du parcours et des compétences : le profil de Jérôme (export LinkedIn). Ne mettre en avant **que** des compétences et expériences qui y figurent.
- Ne jamais inventer de clients, références, chiffres ou certifications : laisser un `<!-- TODO: … -->` (commentaire HTML, jamais visible) et une tâche dans `backlog.md`. Une preuve fausse détruit la crédibilité, qui est l'objectif même du site.
- Documentation projet rangée selon Diátaxis (voir `docs/README.md`).
- Modifier un skill quand une règle de design ou de navigation change (le skill décrit l'état réel).
- Commits courts en français, à l'impératif (`Ajoute l'article sur les Collections Ansible`).
