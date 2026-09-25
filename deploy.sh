#!/usr/bin/env bash
# Usage: ./deploy.sh "commit message"
# Builds the site, commits all changes in the source repo and in _site/
# with the given message, then pushes _site/ to the live site and the
# source repo to its GitHub backup.
set -euo pipefail

if [ $# -ne 1 ] || [ -z "$1" ]; then
    echo "Usage: $0 \"commit message\"" >&2
    exit 1
fi
msg="$1"

cd "$(dirname "$0")"

bundle exec jekyll build

# Stage everything and commit, skipping repos with nothing to commit.
commit_all() {
    git -C "$1" add -A
    if git -C "$1" diff --cached --quiet; then
        echo "Nothing to commit in $1"
    else
        git -C "$1" commit -m "$msg"
    fi
}

commit_all .
commit_all _site

git -C _site push github master
git push origin master
