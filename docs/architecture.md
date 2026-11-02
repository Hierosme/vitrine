# Architecture

## Arborescence

```
.mise/config.toml       # outillage (python, uv) + venv
.mise/tasks/            # tâches mise (scripts bash exécutables)
requirements.txt        # mkdocs + mkdocs-material (plugin blog intégré)
mkdocs.yml              # config du site : thème, plugins, NAVIGATION
mkdocs.docs.yml         # config de l'aperçu de la doc projet (non publiée)
overrides/main.html     # surcharge Material : métadonnées SEO (Open Graph, JSON-LD, apple-touch-icon)
hooks/robots.py         # hook MkDocs : génère build/robots.txt depuis site_url
backlog.md              # tâches en attente (prompts pour agent, questions à l'opérateur, suivi)
site/                   # SOURCES du site public (docs_dir)
  index.md, services.md, parcours.md, contact.md
  blog/index.md, blog/.authors.yml, blog/posts/*.md
  stylesheets/extra.css # DESIGN SYSTEM : palette Nord, rôles clair/sombre, composants
build/, build-docs/     # sorties de build (ignorées par git)
docs/                   # documentation projet (Diátaxis) + skills agents
  explanation/          # le « pourquoi » (design system et ses sources)
AGENTS.md               # point d'entrée des agents IA
.github/workflows/deploy.yml
```

> `docs_dir: site` et `site_dir: build` : MkDocs utilise `site/` comme sortie par défaut, d'où le renommage de la sortie en `build/`.

## Commandes

Première fois : `mise trust && mise install`.

| Tâche | Alias | Rôle |
|---|---|---|
| `mise run install` | | Dépendances Python dans `.venv` (sauté si `requirements.txt` inchangé) |
| `mise run site:serve [-p 8000]` | `serve` | Aperçu du site public |
| `mise run site:build` | `build` | Build strict du site dans `build/` (utilisé par la CI) |
| `mise run docs:serve [-p 8001]` | | Aperçu de la doc projet (`docs/`, skills inclus) |
| `mise run docs:build` | | Build strict de la doc projet dans `build-docs/` |
| `mise run preview` | | Aperçu simultané site (:8000) + doc (:8001) |
| `mise run blog:new "Titre" [-c Catégorie] [--publish]` | | Crée un article daté (brouillon par défaut) |
| `mise run blog:list` | | Liste des articles : date, statut, catégories |
| `mise run todo` | | `TODO` restants dans le site et la config |
| `mise run design:contrast [-v]` | | Contrastes WCAG AA des thèmes clair et sombre, calculés depuis `extra.css` |
| `mise run content:services [-m 500]` | | Longueur minimale de chaque service détaillé de `services.md` |
| `mise run content:seo` | | `title` et `description` en front-matter : présence, longueurs, unicité |
| `mise run content:todo-visible` | | Aucun `TODO` visible sur le site publié (seuls les commentaires HTML sont tolérés) |
| `mise run check` | `lint` | Design system (couleurs, palette via rôles, contrastes, préfixes `vt-`, 1 CTA principal par page), navigation (≤ 6 onglets, `vt-cta` en fin de page, pas de menu latéral, services ≥ 500 caractères), contenu (aucun TODO visible), référencement (`title`, `description`), builds stricts |
| `mise run dns:check [domaine]` | | Vérifie DNS (A, AAAA, CNAME www, CAA) et HTTPS |
| `mise run clean` | | Supprime `build/`, `build-docs/` |

Les tâches sont des scripts bash exécutables dans `.mise/tasks/` (sous-dossier = namespace). `mise tasks` liste tout.
Compatibles bash 3.2 (macOS) : pas de `mapfile`, tableaux associatifs ni `${var,,}`.

## Polices et build hors ligne

Le plugin `privacy` de Material télécharge les polices Google **au build** et les sert depuis le site (aucune requête vers Google depuis le navigateur du visiteur). Le premier build demande donc un accès réseau à `fonts.googleapis.com` / `fonts.gstatic.com` ; les fichiers sont ensuite en cache dans `.cache/` (ignoré par git). Sans réseau : `VITRINE_PRIVACY=false mise run check` (les polices restent alors chargées depuis Google, à ne pas déployer ainsi).

## Déploiement

- Push sur `main` → workflow `deploy.yml` → `mise run site:build` → GitHub Pages.
- Réglage dépôt : **Settings → Pages → Source : GitHub Actions**.
- Domaine personnel : **Settings → Pages → Custom domain** (avec un déploiement par Actions, un fichier `CNAME` dans le dépôt est ignoré).
- DNS chez DNSimple : `ALIAS @ → <user>.github.io`, `CNAME www → <user>.github.io`, TXT de vérification du domaine sur le compte GitHub.
