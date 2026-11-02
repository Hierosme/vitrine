# Fonctions communes aux tâches mise qui appellent Zensical (bash 3.2 compatible).
# Usage : source "$MISE_PROJECT_ROOT/.mise/lib/zensical.sh"

# zensical_config <fichier.toml>
#   Affiche le fichier de configuration à utiliser.
#   VITRINE_PRIVACY=false : copie hors ligne (.<nom>.offline.toml, ignorée par git) où le plugin
#   privacy est désactivé — les polices restent alors servies par Google : ne jamais déployer ainsi.
zensical_config() {
  local cfg="$1"
  if [[ "${VITRINE_PRIVACY:-true}" == "false" ]] && grep -q '^\[project\.plugins\.privacy\]' "$cfg"; then
    local off=".${cfg%.toml}.offline.toml"
    awk '{ print } /^\[project\.plugins\.privacy\]$/ { print "enabled = false" }' "$cfg" > "$off"
    echo "⚠ Mode hors ligne : plugin privacy désactivé ($off)" >&2
    cfg="$off"
  fi
  echo "$cfg"
}

# toml_get <fichier.toml> <clé.pointée>
#   Affiche une valeur de la section [project] (liste : une valeur par ligne).
toml_get() {
  python3 - "$1" "$2" <<'PY'
import sys
try:
    import tomllib
except ImportError:  # Python < 3.11 : tomli est une dépendance de Zensical
    import tomli as tomllib
data = tomllib.load(open(sys.argv[1], "rb")).get("project", {})
for key in sys.argv[2].split("."):
    data = data.get(key, {}) if isinstance(data, dict) else {}
if isinstance(data, list):
    print("\n".join(str(x) for x in data))
elif data != {}:
    print(data)
PY
}
