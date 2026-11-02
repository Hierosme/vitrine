"""Hook MkDocs : génère robots.txt dans le dossier de build.

L'URL du sitemap est déduite de `site_url` (mkdocs.yml), pour qu'aucun domaine
ne soit écrit en dur ailleurs que dans la configuration.
"""
import os


def on_post_build(config, **kwargs):
    lines = ["User-agent: *", "Allow: /"]
    site_url = (config.get("site_url") or "").rstrip("/")
    if site_url:
        lines += ["", f"Sitemap: {site_url}/sitemap.xml"]
    path = os.path.join(config["site_dir"], "robots.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
