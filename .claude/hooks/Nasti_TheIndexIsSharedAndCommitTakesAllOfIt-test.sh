#!/bin/sh
# Falsify the guard in BOTH directions before believing it, on a scratch repo
# whose index state is CONSTRUCTED, not observed. Sixteen agents are live in
# the real tree; this test never touches it.
#
# Column 2 of the case file is the state of the shared index at the moment the
# hook looks. That state is the entire content of the check, so it is a column
# and not an assumption.
set -u
H=/Users/avikjain/Desktop/math2/.claude/hooks
HOOK=$H/Nasti_TheIndexIsSharedAndCommitTakesAllOfIt.sh
CASES=$H/Nasti_TheIndexIsSharedAndCommitTakesAllOfIt.cases
OLD=$H/no-sweeping-commit.sh

R=$(mktemp -d) || exit 1
trap 'rm -rf "$R"' EXIT
cd "$R" || exit 1
git init -q . >/dev/null 2>&1
git config user.email t@t
git config user.name t
mkdir -p machine
echo base > machine/Base.hs
git add machine/Base.hs
git commit -q -m base
echo other > machine/OtherLane.hs
echo foo > machine/Foo.hs

# JSON-quote a raw command string for the tool payload the hook is fed.
jsonq() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/^/"/; s/$/"/'; }

fail=0; n=0
while IFS='	' read -r want state cmd; do
  [ -z "${want:-}" ] && continue
  case "$want" in \#*) continue;; esac
  n=$((n+1))
  git reset -q
  [ "$state" = DIRTY ] && git add machine/OtherLane.hs
  printf '{"tool_input":{"command":%s}}' "$(jsonq "$cmd")" | sh "$HOOK" >/dev/null 2>&1
  rc=$?
  if [ "$want" = BLOCK ]; then exp=2; else exp=0; fi
  if [ "$rc" != "$exp" ]; then
    fail=$((fail+1)); echo "WRONG want=$want state=$state rc=$rc : $cmd"
  fi
done < "$CASES"
echo "cases=$n wrong=$fail"

git reset -q
git add machine/OtherLane.hs

# --- states where refusing would be an outage, checked live ---------------
# Mid-merge, mid-rebase, mid-cherry-pick: git itself refuses a partial commit,
# so a refusal here strands every lane resolving a conflict. Must be silent.
gd=$(git rev-parse --git-dir)
git rev-parse HEAD > "$gd/MERGE_HEAD"
printf '{"tool_input":{"command":"git commit -m resolve"}}' | sh "$HOOK" >/dev/null 2>&1
echo "mid-merge rc = $? (expect 0)"
rm -f "$gd/MERGE_HEAD"

mkdir -p "$gd/rebase-merge"
printf '{"tool_input":{"command":"git commit -m resolve"}}' | sh "$HOOK" >/dev/null 2>&1
echo "mid-rebase rc = $? (expect 0)"
rmdir "$gd/rebase-merge"

# Writing a file whose TEXT names the command. Every dosa record about this
# harm, and this hook's own source, is written with a heredoc containing the
# command; a guard that refuses the act of documenting the guard is useless.
# Assembled from fragments so the test cannot pass by an accident of quoting.
G=$(printf 'g%sit c%sommit' '' '')
body="cat > /dev/null <<'XEOF'
the cause was an unscoped $G taking the whole shared index
XEOF"
printf '{"tool_input":{"command":%s}}' \
  "$(printf '%s' "$body" | sed 's/\\/\\\\/g; s/"/\\"/g' | awk '{printf "%s\\n", $0}' | sed 's/\\n$//; s/^/"/; s/$/"/')" \
  | sh "$HOOK" >/dev/null 2>&1
echo "heredoc-documenting-the-guard rc = $? (expect 0)"

# --- the cross-line span, which is how a guard becomes an outage ----------
# A multi-line Bash command arrives as one JSON string with literal \n escapes.
# Two lines that are each harmless alone must stay harmless joined. Checked
# with jq and again with jq removed from PATH, because a guard that is only
# correct when jq is installed is not correct.
joined='git commit -o machine/Foo.hs -m x\nls -a'
printf '{"tool_input":{"command":"%s"}}' "$joined" | sh "$HOOK" >/dev/null 2>&1
echo "cross-line, with jq    rc = $? (expect 0)"
# A PATH with every tool the hook uses EXCEPT jq. Emptying PATH outright is not
# this test -- that removes sed and git too and the hook exits 127, which would
# have been read as a pass for the wrong reason.
SHIM=$R/shim; mkdir -p "$SHIM"
for t in sed awk grep git wc head tr cat; do
  p=$(command -v "$t") && ln -sf "$p" "$SHIM/$t"
done
command -v jq >/dev/null 2>&1 && echo "  (jq present, so the fallback is genuinely being exercised)"
printf '{"tool_input":{"command":"%s"}}' "$joined" | PATH="$SHIM" /bin/sh "$HOOK" >/dev/null 2>&1
echo "cross-line, without jq rc = $? (expect 0)"
printf '{"tool_input":{"command":"git commit -m x"}}' | PATH="$SHIM" /bin/sh "$HOOK" >/dev/null 2>&1
echo "unscoped, without jq   rc = $? (expect 2)"
# and the same two lines with the commit UNSCOPED must still be refused, so
# the decoding did not simply blind the guard
joined2='git commit -m x\nls -a'
printf '{"tool_input":{"command":"%s"}}' "$joined2" | sh "$HOOK" >/dev/null 2>&1
echo "cross-line unscoped    rc = $? (expect 2)"

# --- the four real commands, against both guards --------------------------
# Verbatim shapes from machine/dosa.lekha dosa 0013 and 0014. This hook must
# refuse them; the add -A guard lets every one through, which is why this
# file exists rather than an edit to that one.
i=0
for c in "git add machine/DosaLekha_TheWrittenDefectRecord.hs && git commit -q -m sugar" \
         "git add machine/Sabda_TheWireHasNoBoolean.hs && git commit -q -m mrcchakatika" \
         "git add machine/Nasti_TruncationCensus.hs && git commit -q -F -" \
         "git add formal/cubical/Everything.agda && git commit -q -m transport"; do
  i=$((i+1))
  printf '{"tool_input":{"command":%s}}' "$(jsonq "$c")" | sh "$HOOK" >/dev/null 2>&1
  a=$?
  printf '{"tool_input":{"command":%s}}' "$(jsonq "$c")" | sh "$OLD" >/dev/null 2>&1
  b=$?
  echo "swept command $i: this guard rc=$a (expect 2), add -A guard rc=$b (expect 0)"
done
