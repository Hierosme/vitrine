# Documentation projet — vitrine

Documentation **du projet** (pas du site public : celui-ci vit dans `site/`). Aperçu : `mise run docs:serve`.

| Document | Contenu |
|---|---|
| [architecture.md](architecture.md) | Organisation du dépôt, build, déploiement, domaine |
| [explanation/design-system.md](explanation/design-system.md) | *Explication* : pourquoi le design system est ainsi fait, et ses sources (IHM, ergonomie, crédibilité) |
| [skills/oxygen-ui-design-guidelines](skills/oxygen-ui-design-guidelines/SKILL.md) | Skill : **norme de design** (Oxygen UI × Nord), chargée à chaque session ; prévaut sur tout le reste |
| [skills/site-look-and-feel](skills/site-look-and-feel/SKILL.md) | Skill : implémentation de la norme dans Zensical (tokens, composants, contrôles) |
| [skills/site-navigation](skills/site-navigation/SKILL.md) | Skill : maintenir la navigation et l'arborescence |

## Ajouter un skill

1. Créer `docs/skills/<nom-en-kebab-case>/SKILL.md` avec un front-matter `name` + `description`.
2. Le référencer dans la table « Skills » de `AGENTS.md` (déclencheurs + chemin) et dans `nav` de `zensical.docs.toml`.
3. Le lien `.claude/skills → docs/skills` le rend découvrable automatiquement par Claude.

## Organisation (Diátaxis)

La doc suit [Diátaxis](https://diataxis.fr/) :

- `explanation/` : le **pourquoi** (contexte, choix, sources) ;
- `skills/` : le **comment** opérationnel, qui sert à la fois de *how-to* et de *référence* pour les humains et les agents ;
- `architecture.md` : la *référence* du dépôt et des commandes.
