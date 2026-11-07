#!/bin/bash
#
# Generates each package's Playground/Playground.xcodeproj from its project.yml.
#
#   scripts/playgrounds.sh             every package
#   scripts/playgrounds.sh <Package>   one package, e.g. Watchlist
#
# The last line is always RESULT: ... so tools can read it.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE="${1:-*}"

SPECS=()
for spec in "$ROOT"/Features/$PACKAGE/Playground/project.yml "$ROOT"/Core/$PACKAGE/Playground/project.yml; do
  [[ -f "$spec" ]] && SPECS+=("$spec")
done

if [[ ${#SPECS[@]} -eq 0 ]]; then
  echo "error: no playground found for $PACKAGE" >&2
  echo "RESULT: PLAYGROUNDS BLOCKED"
  exit 2
fi

for spec in "${SPECS[@]}"; do
  xcodegen generate --quiet --spec "$spec"
  echo "generated ${spec#"$ROOT"/}"
done
echo "RESULT: PLAYGROUNDS GENERATED count=${#SPECS[@]}"
