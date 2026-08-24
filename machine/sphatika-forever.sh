#!/bin/sh
# The machine, wired: completion rounds forever, landings kept forever.
# No carrier in any loop.  Rounds self-halt at true fixpoint and restart
# when the frontier moves (a sense pass, a peer exchange, a library
# append from any lane); the keeper commits and pushes whatever the
# machine produced, every five minutes, naming every path.
set -u
cd "$(dirname "$0")/.."
BIN=${SPHATIKA_BIN:-/tmp/sphatika-bin}
( while :; do
    sh machine/sphatika-rounds.sh 24
    sleep 120
  done ) &
while :; do
    sleep 300
    CHANGED=""
    for f in machine/sphatika.crystal machine/library.terms \
             machine/sanghatta-report-current.txt formal/cubical/Sphatika.agda \
             collab/orchestration/sphatika.log; do
        [ -n "$(git status --porcelain -- "$f" 2>/dev/null)" ] && CHANGED="$CHANGED $f"
    done
    [ -z "$CHANGED" ] && continue
    git add $CHANGED 2>/dev/null
    OPTS=""; for f in $CHANGED; do OPTS="$OPTS -o $f"; done
    git commit $OPTS -m "the machine keeps its own work ($(date -u +%H:%MZ))" >/dev/null 2>&1
    n=0; until git push -u origin "$(git symbolic-ref --quiet --short HEAD)" >/dev/null 2>&1 \
          || [ $n -ge 4 ]; do n=$((n+1)); sleep $((2**n)); done
done
