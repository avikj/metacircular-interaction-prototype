#!/bin/sh
# check-forecast-citations.sh -- one narrow board guard, 2026-08-15.
#
# Defect it exists for: collab/STATE.md line 205 asserted "forecast `Z/2`
# falsified and corrected" where no pre-registration ever contained `Z/2`.
# The number was invented at a correction step and travelled. The cheapest
# mechanical trace of that pattern is a row that claims a forecast/prediction
# was falsified, refuted or missed while naming no upstream artifact at all.
#
# SCOPE, stated so nobody over-trusts it. This checks that a citation EXISTS.
# It does NOT check that the cited message contains the forecast -- rows are
# free prose, forecasts are free prose, and ~320 message numbers collide in
# this corpus, so resolving "msg 0077" mechanically would be wrong more often
# than right (row 338 is exactly such a collision). Verifying content is a
# human/agent read. Exercised 2026-08-15: fires on the pre-correction row 205
# text, 0 hits on the whole current board.
#
# Exit 1 on a hit.

set -eu
BOARD="${1:-collab/STATE.md}"
[ -f "$BOARD" ] || { echo "check-forecast-citations: no $BOARD" >&2; exit 0; }

CLAIM='([Ff]orecast|[Pp]rediction)[^|]{0,60}(falsif|refut|[Mm][Ii][Ss][Ss][Ee][Dd]|was false|did not hold)|(falsif|refut|[Mm][Ii][Ss][Ss][Ee][Dd])[^|]{0,60}([Ff]orecast|[Pp]rediction)'
CITE='[Mm]sgs?[[:space:]]+[0-9]{3,4}|notes/[A-Za-z0-9_]+\.md|(code|machinery)/[A-Za-z0-9_]+\.py|journals/[A-Za-z0-9_-]+\.md'

hits=$(grep -nE '^\|' "$BOARD" | grep -E "$CLAIM" | grep -vE "$CITE" || true)

if [ -n "$hits" ]; then
  echo "check-forecast-citations: board rows claim a falsified/missed forecast but cite no pre-registration:" >&2
  echo "$hits" | cut -c1-200 >&2
  echo "Name the message, journal, note or script docstring where the forecast was registered." >&2
  exit 1
fi
exit 0
