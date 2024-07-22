#!/usr/bin/env bash

exitfn () {
    trap SIGINT              # Restore signal handling for SIGINT
    cd ../..
    exit                     #   then exit script.
}

trap "exitfn" INT            # Set up SIGINT trap to call function.

# export HUGO_STATS_PATH="./starters/$1/hugo_stats.json"
# printf 'HUGO_STATS_PATH: %s\n' "$HUGO_STATS_PATH"

# create modules replace from contents in "./modules"
modules_dir="$(pwd)/modules"
modules="$(ls "$modules_dir")"
hugo_module_replacements=""
for module in $modules; do
    module_github_prefix="github.com/HugoBlox/hugo-blox-builder/modules"
    if [[ "${module}" == "${blox-bootstrap}" ]]; then
        module_github_prefix="$module_github_prefix/v5"
    fi
    hugo_module_replacements="$module_github_prefix/$module -> $modules_dir/$module,$hugo_module_replacements"
done
# remove trailing comma
hugo_module_replacements=${hugo_module_replacements::-1}

# `--source "starters/$1"` won't work for Tailwind Module
# due to Hugo limitation requiring Hugo to be run from site dir
starter_dir="starters/$1"
cd "$starter_dir" || exit 1

WC_DEMO=true \
HUGO_ENVIRONMENT=development \
HUGOxPARAMSxDECAP_CMSxLOCAL_BACKEND=true \
HUGO_MODULE_REPLACEMENTS="$hugo_module_replacements" \
hugo && \
npm_config_yes=true npx pagefind --site "public" --output-subdir ../static/pagefind && \
hugo server --panicOnWarning --renderStaticToDisk -F --port 8081 --bind 0.0.0.0

trap SIGINT                  # Restore signal handling to previous before exit.
