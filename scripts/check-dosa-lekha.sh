#!/bin/sh
# check-dosa-lekha.sh — the doṣa-lekha is append-only; this is the mechanism
# that says so, rather than the paragraph that asks.
#
# Every record in interactive/dosa.lekha carries `sara:`, a chain value over the
# preceding record and its own canonical text.  Editing a past record,
# deleting one, or reordering two breaks the chain, and this names the first
# record where it happened.  Corrections are made by APPENDING a record whose
# `uttara:` names the one it supersedes — never by changing what was written.
#
# This repository already learned that a deletion nobody decided is found by
# an archivist draw and by nothing else (scripts/check-no-silent-deletion.sh,
# commit 142bba1f, 53 files and 2145 lines).  Same failure, different ledger.
#
#   scripts/check-dosa-lekha.sh          verify the chain; exit 1 if broken
#
# Exits 0 and says so when there is no log yet: a store with no defects in it
# is a store, not a fault.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
LOG="${DOSA_LEKHA:-$ROOT/interactive/dosa.lekha}"
[ -f "$LOG" ] || { echo "check-dosa-lekha: no log at $LOG yet — nothing to verify."; exit 0; }
command -v ghc >/dev/null 2>&1 || { echo "check-dosa-lekha: no ghc; not verified (this is not a pass)."; exit 0; }
sh "$ROOT/interactive/run-dosa-lekha.sh" verify
