# AGENTS.md — vitrine DevOps freelance

Site vitrine statique de **Jérôme Ornech**, Expert DevOps freelance (automatisation systèmes et réseaux, Ansible, Python, Network as Code, Continuous Delivery, IA générative : agents de code et maîtrise des coûts), généré avec **[Zensical](https://zensical.org)** (successeur de Material for MkDocs, variante `classic`, plugin blog), thèmes clair et sombre sur la palette **Nord**, design system régi par le skill **Oxygen UI × Nord** (règles de décision visuelle, palette Nord fermée, design plat), hébergé sur **GitHub Pages** avec un domaine personnel (DNS chez DNSimple).

## À charger au démarrage de chaque session

Lis ces fichiers **avant toute action** :

1. `docs/skills/oxygen-ui-design-guidelines/SKILL.md` — **norme de design du site, à lire en entier à chaque session, quelle que soit la tâche**
2. `docs/README.md` — index de la documentation projet
3. `docs/architecture.md` — arborescence, commandes, déploiement
4. `private/backlog.md` — travail en attente (dépôt privé annexe : peut être absent d'un clone public) : si la demande correspond à une tâche, suivre son prompt et poser ses questions à l'opérateur **avant** de modifier quoi que ce soit, puis mettre à jour son statut

## Skills — chargement obligatoire

Avant de modifier quoi que ce soit, identifie les skills concernés et **lis leur `SKILL.md` en entier**, puis respecte leurs règles et leur checklist.

| Skill | Chemin | À charger… |
|---|---|---|
| `oxygen-ui-design-guidelines` | `docs/skills/oxygen-ui-design-guidelines/SKILL.md` | **Toujours**, à chaque session et pour toute tâche : c'est la norme de design (quand encadrer, mettre en valeur, contraster, espacer ; palette Nord ; thèmes clair et sombre). |
| `site-look-and-feel` | `docs/skills/site-look-and-feel/SKILL.md` | Si la tâche touche `site/stylesheets/`, `zensical.toml` (`theme`), `overrides/`, une couleur, une police, un composant ou la mise en page : c'est la **traduction** de la norme pour Zensical (tokens `--vt-*`, classes `vt-`, variables `--md-*`). |
| `site-navigation` | `docs/skills/site-navigation/SKILL.md` | Si la tâche touche `zensical.toml` (`nav`, `features`, `plugins.blog`), l'ajout, le renommage ou la suppression d'une page dans `site/`, un article de blog, les liens internes. |

Une nouvelle page de contenu les concerne toujours tous les trois.

**Ordre de priorité en cas de conflit :** `oxygen-ui-design-guidelines` > `site-look-and-feel` > `site-navigation` > le reste de la documentation. `site-look-and-feel` ne fait qu'implémenter la norme dans Zensical : ses exemples MUI/React (`Card`, `sx`, `extendTheme`) ne s'appliquent pas tels quels ici, ce sont leurs règles qui s'appliquent. Une règle de la documentation qui contredit la norme est une erreur : corrige la documentation, pas le site.

**Décision de design non couverte par un skill**, ou demande de « pourquoi » : lis `docs/explanation/design-system.md`. Il décrit les fondements (première impression, crédibilité, ergonomie cognitive) et leurs sources. Toute nouvelle règle doit pouvoir s'y rattacher et rester compatible avec la norme. Sinon, propose de compléter l'explication avant de coder.

## Arborescence

- `site/` — sources **du site public** (Markdown, CSS). Rien d'autre.
- `docs/` — documentation **du projet** et skills. Jamais publiée.
- `zensical.toml` (site), `zensical.docs.toml` (doc projet) : configuration Zensical. Le projet n'utilise **plus MkDocs** : ne pas réintroduire `mkdocs.yml` ni de dépendance `mkdocs*`.
- `overrides/` (métadonnées SEO) : surcharge de template, rendue par minijinja — voir `docs/architecture.md`.
- `private/` — **notes privées, jamais publiées** (ignoré par git ; versionné à part dans un dépôt privé) : `backlog.md` (tâches, prompts, questions à l'opérateur, suivi) et toute note de travail. Le dépôt du site est public : rien de confidentiel hors de `private/`.
- `build/`, `build-docs/` — sorties générées, ne pas éditer, ne pas committer.

## Commandes

Toujours passer par les tâches mise (`.mise/tasks/`), jamais par `zensical` directement :

```bash
mise run preview                       # aperçu site (:8000) + doc projet (:8001)
mise run blog:new "Titre" -c Ansible   # nouvel article (brouillon)
mise run check                         # design system + builds stricts — DOIT passer avant de terminer
```

Liste complète : `docs/architecture.md` § Commandes, ou `mise tasks`.
Nouvelle tâche : script bash exécutable dans `.mise/tasks/` (en-têtes `#MISE description=…`, compatible bash 3.2), à ajouter au tableau de `docs/architecture.md`.

## Conventions

- Contenu du site en **français**, ton professionnel et direct, à la première personne.
- Source de vérité du parcours et des compétences : le profil de Jérôme (export LinkedIn), complété par les informations confirmées par l'opérateur dans `private/backlog.md` (journal des tâches). Ne mettre en avant **que** des compétences et expériences qui y figurent.
- Ne jamais inventer de clients, références, chiffres ou certifications : ne rien écrire et ouvrir une tâche dans `private/backlog.md`. **Aucun `TODO` dans les sources du site**, pas même en commentaire HTML : les commentaires sont recopiés dans le HTML publié (`check` le refuse). Une preuve fausse détruit la crédibilité, qui est l'objectif même du site.
- Documentation projet rangée selon Diátaxis (voir `docs/README.md`).
- Modifier `site-look-and-feel` ou `site-navigation` quand l'implémentation change (le skill décrit l'état réel). La norme `oxygen-ui-design-guidelines` ne se modifie que sur décision explicite de l'opérateur.
- Commits courts en français, à l'impératif (`Ajoute l'article sur les Collections Ansible`).
