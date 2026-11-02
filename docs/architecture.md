# Architecture

## Arborescence

```
.mise/config.toml       # outillage (python, uv) + venv
.mise/tasks/            # tâches mise (scripts bash exécutables)
.mise/lib/zensical.sh   # fonctions communes aux tâches : config hors ligne, lecture de zensical.toml
requirements.in         # dépendance directe : zensical (version épinglée)
requirements.txt        # verrou complet généré par `mise run deps:lock` (ne pas éditer)
zensical.toml           # config du site : thème, plugins, NAVIGATION
zensical.docs.toml      # config de l'aperçu de la doc projet (non publiée)
overrides/main.html     # surcharge du thème : métadonnées SEO (Open Graph, JSON-LD, apple-touch-icon)
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

> Générateur : [Zensical](https://zensical.org), successeur de Material for MkDocs par la même équipe, en **variante `classic`** (même rendu et mêmes classes `md-*` que Material, sur lesquels repose `extra.css`). Le projet n'utilise plus MkDocs.
>
> `docs_dir = "site"` et `site_dir = "build"` : Zensical, comme MkDocs, sort par défaut dans `site/`, d'où le renommage de la sortie en `build/`. Zensical **vide `build/` à chaque build** : tout fichier généré en plus (`robots.txt`) l'est par la tâche `site:build`, après le build.
>
> Front-matter : Zensical **ignore sans erreur** une page dont le YAML est invalide (typiquement un « : » dans une valeur non entre guillemets) ; seuls les liens vers elle échouent ensuite. Mettre `title` et `description` entre guillemets.
>
> Templates : `overrides/` est rendu par **minijinja**, un sous-ensemble de Jinja2 (pas de méthodes Python comme `.append()` ou `.startswith()` ; utiliser les filtres et tests : `selectattr`, `startingwith`, `map`…). `page.is_homepage` n'existe pas : tester `page.url == ""`.

## Commandes

Première fois : `mise trust && mise install`.

| Tâche | Alias | Rôle |
|---|---|---|
| `mise run install` | | `uv pip sync` de `.venv` sur `requirements.txt` : installe les versions verrouillées **et retire tout paquet absent** (sauté si `requirements.txt` inchangé) |
| `mise run deps:lock [-U]` | | Régénère le verrou `requirements.txt` depuis `requirements.in` (multi-plateforme ; `-U` pour monter de version) |
| `mise run site:serve [-p 8000]` | `serve` | Aperçu du site public |
| `mise run site:build` | `build` | Build strict du site dans `build/`, puis `robots.txt` (utilisé par la CI) |
| `mise run docs:serve [-p 8001]` | | Aperçu de la doc projet (`docs/`, skills inclus) |
| `mise run docs:build` | | Build strict de la doc projet dans `build-docs/` |
| `mise run preview` | | Aperçu simultané site (:8000) + doc (:8001) |
| `mise run blog:new "Titre" [-c Catégorie] [--publish]` | | Crée un article daté (brouillon par défaut) |
| `mise run blog:list` | | Liste des articles : date, statut, catégories |
| `mise run todo` | | `TODO` restants dans le site et la config |
| `mise run design:contrast [-v]` | | Contrastes WCAG AA des paires de rôles M3, thèmes clair et sombre, calculés depuis `extra.css` |
| `mise run content:services [-m 500]` | | Longueur minimale de chaque service détaillé de `services.md` |
| `mise run content:seo` | | `title` et `description` en front-matter : présence, longueurs, unicité |
| `mise run content:headings` | | Accessibilité (M3) : un seul H1 par page, aucun niveau de titre sauté |
| `mise run content:todo-visible` | | Aucun `TODO` visible sur le site publié (seuls les commentaires HTML sont tolérés) |
| `mise run check` | `lint` | Design system (couleurs, rayons, ombres, typographie et durées via tokens, palette via rôles M3, contrastes des paires de rôles, préfixes `vt-`, 1 CTA principal par page), accessibilité (hiérarchie des titres), navigation (≤ 6 onglets, `vt-cta` en fin de page, pas de menu latéral, services ≥ 500 caractères), contenu (aucun TODO visible), référencement (`title`, `description`), builds stricts |
| `mise run dns:check [domaine]` | | Vérifie DNS (A, AAAA, CNAME www, CAA) et HTTPS |
| `mise run clean` | | Supprime `build/`, `build-docs/` |

Les tâches sont des scripts bash exécutables dans `.mise/tasks/` (sous-dossier = namespace). `mise tasks` liste tout.
Compatibles bash 3.2 (macOS) : pas de `mapfile`, tableaux associatifs ni `${var,,}`.

## Polices et build hors ligne

Le plugin `privacy` de Zensical télécharge les polices Google **au build** et les sert depuis le site (aucune requête vers Google depuis le navigateur du visiteur). Le premier build demande donc un accès réseau à `fonts.googleapis.com` / `fonts.gstatic.com` ; les fichiers sont ensuite en cache dans `.cache/` (ignoré par git, vidé par `mise run clean`). Sans réseau, le build strict échoue : préfixer la tâche par `VITRINE_PRIVACY=false` (ex. `VITRINE_PRIVACY=false mise run check`). La fonction `zensical_config` de `.mise/lib/zensical.sh` génère alors `.zensical.offline.toml` (ignoré par git) avec le plugin désactivé ; les polices restent servies par Google, **à ne jamais déployer ainsi**.

Les ressources de `unpkg.com` (pyodide, référencé par le JavaScript du thème) sont exclues du plugin (`assets_exclude`) : la fonction n'est pas utilisée.

## Déploiement

- Push sur `main` → workflow `deploy.yml` → `mise run site:build` → GitHub Pages.
- Réglage dépôt : **Settings → Pages → Source : GitHub Actions**.
- Domaine personnel : **Settings → Pages → Custom domain** (avec un déploiement par Actions, un fichier `CNAME` dans le dépôt est ignoré).
- DNS chez DNSimple : `ALIAS @ → <user>.github.io`, `CNAME www → <user>.github.io`, TXT de vérification du domaine sur le compte GitHub.

## Mettre à jour Zensical

Zensical est en version 0.0.x : une montée de version peut casser la config ou les templates.

1. Modifier la version dans `requirements.in`, puis `mise run deps:lock`.
2. `mise run check`, puis vérifier le rendu (`mise run preview`) en clair et en sombre, desktop et mobile.
3. Consulter le journal des versions ([github.com/zensical/zensical](https://github.com/zensical/zensical/releases)) pour les options de `zensical.toml` et les templates (`overrides/main.html`).
