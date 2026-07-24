#!/usr/bin/env bash
#
# publish-site.sh — Builds the ASL3-Manual site with zensical and pushes the
# compiled output to the allstarlink.github.io repository (replacement for
# 'mkdocs gh-deploy').
#
# Run from the root of the ASL3-Manual working copy. The script:
#   1. Builds the site with 'zensical build'
#   2. Shallow-clones the Pages repo to a temp directory
#   3. Replaces its contents with the fresh build (preserving CNAME and .git)
#   4. Commits with a reference back to the source commit and pushes
#
# Usage:
#   ./publish-site.sh                 # build and deploy
#   ./publish-site.sh --dry-run       # build and commit locally, skip the push
#   ./publish-site.sh -r URL -b BRANCH -o DIR
#
set -euo pipefail

# --- Defaults ----------------------------------------------------------------

SITE_REPO='https://github.com/AllStarLink/allstarlink.github.io.git'
SITE_BRANCH='main'
BUILD_DIR=''            # auto-detected from zensical.toml if empty
DRY_RUN=0

usage() {
    grep '^#' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo)      SITE_REPO="$2";   shift 2 ;;
        -b|--branch)    SITE_BRANCH="$2"; shift 2 ;;
        -o|--build-dir) BUILD_DIR="$2";   shift 2 ;;
        -n|--dry-run)   DRY_RUN=1;        shift   ;;
        -h|--help)      usage 0 ;;
        *) echo "Unknown option: $1" >&2; usage 1 ;;
    esac
done

info()  { printf '\033[36m%s\033[0m\n' "$*"; }
warn()  { printf '\033[33mWARNING: %s\033[0m\n' "$*" >&2; }
ok()    { printf '\033[32m%s\033[0m\n' "$*"; }
die()   { printf '\033[31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

# --- Sanity checks -------------------------------------------------------------

for tool in git zensical; do
    command -v "$tool" >/dev/null 2>&1 || die "'$tool' not found in PATH."
done

[[ -d .git ]] || die 'Run this script from the root of the ASL3-Manual repository.'

SOURCE_SHA=$(git rev-parse --short HEAD)
SOURCE_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ -n "$(git status --porcelain)" ]]; then
    warn 'Working tree has uncommitted changes; the deployed site may not match any pushed commit.'
fi

# --- Determine output directory ------------------------------------------------
# zensical has no CLI flag for the output path; it is controlled by 'site_dir'
# in zensical.toml (default: 'site', relative to the config file).

if [[ -z "$BUILD_DIR" ]]; then
    BUILD_DIR='site'
    if [[ -f zensical.toml ]]; then
        detected=$(sed -n 's/^[[:space:]]*site_dir[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' zensical.toml | head -n1)
        [[ -n "$detected" ]] && BUILD_DIR="$detected"
    fi
fi
info "Output directory: $BUILD_DIR"

# --- Build ---------------------------------------------------------------------

info "Building site from ${SOURCE_BRANCH}@${SOURCE_SHA} ..."

# zensical removes the site_dir itself before each build, so no pre-clean needed
zensical build

[[ -f "$BUILD_DIR/index.html" ]] || die "Build completed but '$BUILD_DIR/index.html' is missing - refusing to deploy."

# Ensure GitHub Pages does not run the output through Jekyll
touch "$BUILD_DIR/.nojekyll"

# --- Clone target repo -----------------------------------------------------------

TEMP_DIR=$(mktemp -d -t site-deploy-XXXXXXXX)
KEEP_TEMP=0
cleanup() {
    if [[ $KEEP_TEMP -eq 0 && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

info "Cloning $SITE_REPO ($SITE_BRANCH) ..."
git clone --depth 1 --branch "$SITE_BRANCH" "$SITE_REPO" "$TEMP_DIR"

# Preserve CNAME if the Pages repo has one and the build didn't produce one
CNAME_CONTENT=''
if [[ -f "$TEMP_DIR/CNAME" && ! -f "$BUILD_DIR/CNAME" ]]; then
    CNAME_CONTENT=$(cat "$TEMP_DIR/CNAME")
fi

# Wipe everything except .git (dotfiles included)
find "$TEMP_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# Copy the fresh build in (including dotfiles like .nojekyll)
cp -R "$BUILD_DIR"/. "$TEMP_DIR"/

if [[ -n "$CNAME_CONTENT" ]]; then
    printf '%s' "$CNAME_CONTENT" > "$TEMP_DIR/CNAME"
    warn 'Preserved existing CNAME file.'
fi

# --- Commit and push -------------------------------------------------------------

cd "$TEMP_DIR"

git add -A

if git diff --cached --quiet; then
    ok 'Site is already up to date - nothing to deploy.'
    exit 0
fi

MSG="Deploy ASL3-Manual@${SOURCE_SHA} (${SOURCE_BRANCH})"
git commit -m "$MSG"

if [[ $DRY_RUN -eq 1 ]]; then
    KEEP_TEMP=1
    warn "Dry run: commit created locally in $TEMP_DIR but NOT pushed."
    echo 'Inspect it, then delete the temp directory when done.'
    exit 0
fi

info "Pushing to $SITE_REPO ($SITE_BRANCH) ..."
git push origin "$SITE_BRANCH"

ok "Deployed ${SOURCE_SHA} successfully."
