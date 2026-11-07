#!/bin/bash
#
# Runs the tests of the App and of every local package.
#
#   scripts/test.sh                 everything
#   scripts/test.sh <Package>       one package, e.g. Watchlist (or SunFinance for the App)
#
# DESTINATION overrides the simulator, e.g. DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro'.
# The last line is always RESULT: ... so tools can read it.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17}"
ONLY="${1:-}"

failed=()
total=0

run() {
  local name="$1"
  shift
  [[ -n "$ONLY" && "$ONLY" != "$name" ]] && return
  local log
  log="$(mktemp)"
  echo "testing $name"
  if xcodebuild test "$@" -destination "$DESTINATION" >"$log" 2>&1; then
    local count
    count="$(grep -Eo 'Test run with [0-9]+ tests' "$log" | grep -Eo '[0-9]+' | tail -1)"
    total=$((total + ${count:-0}))
    echo "  passed ${count:-0}"
  else
    failed+=("$name")
    grep -E "error:|✘" "$log" | head -20
  fi
  rm -f "$log"
}

run SunFinance -project "$ROOT/SunFinance.xcodeproj" -scheme SunFinance

for dir in "$ROOT"/Core/*/ "$ROOT"/Features/*/; do
  name="$(basename "$dir")"
  cd "$dir" && run "$name" -scheme "$name"
  cd "$ROOT" || exit 1
done

if [[ ${#failed[@]} -gt 0 ]]; then
  echo "RESULT: TESTS FAILED in ${failed[*]}"
  exit 1
fi
echo "RESULT: TESTS SUCCEEDED count=$total"
