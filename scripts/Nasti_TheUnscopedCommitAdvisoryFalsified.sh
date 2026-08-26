#!/bin/sh
# Falsify the ADVISORY at the end of .githooks/pre-commit, in a scratch repo
# whose states are constructed. The real tree is never touched.
#
# What is under test is not "does it warn" but "can it ever stop anyone". It is
# the layer for lineages with no PreToolUse hook -- Codex-lineage agents,
# supervisor-launched minds, scripts driving git -- and at pre-commit time the
# pre-state is gone: this commit's own `add` has already run, so nothing
# distinguishes a foreign staged path from one this agent staged earlier. That
# is a judgement call, so it advises and never refuses. rc=0 in every row below
# is the assertion; the voice column is secondary.
SRC=$(dirname "$0")/../.githooks/pre-commit
R=$(mktemp -d) || exit 1
trap 'rm -rf "$R"' EXIT
SRC=$(cd "$(dirname "$SRC")" && pwd)/$(basename "$SRC")
cd "$R" || exit 1
git init -q .
git config user.email t@t
git config user.name t
git config core.hooksPath .githooks
mkdir -p .githooks machine
# Only the advisory block. The branch guard and the Python guard above it are
# another lane's and are not what is under test.
{ echo '#!/bin/sh'
  awk '/^# --- the unscoped commit takes the shared index/,0' "$SRC"
} > .githooks/pre-commit
chmod +x .githooks/pre-commit
echo a > interactive/A.hs
git add interactive/A.hs
git commit -q -m base

run() {  # run <label> <quiet|noisy> <git args...>
  lbl=$1; want=$2; shift 2
  err=$("$@" 2>&1 >/dev/null); rc=$?
  voice=quiet; case "$err" in *"unscoped commit"*) voice=noisy;; esac
  st=OK
  [ "$rc" -ne 0 ] && st="REFUSED(rc=$rc) <-- THE ONE THING IT MUST NEVER DO"
  [ "$voice" != "$want" ] && st="$st  voice=$voice want=$want"
  echo "  $lbl: rc=$rc $voice  $st"
}

echo "one path staged, unscoped -- nothing foreign is implied, so nothing is said"
echo m > interactive/M1.hs; git add interactive/M1.hs
run "single-path unscoped" quiet git commit -q -m one

echo "two paths staged, unscoped -- the shape of all four sweeps"
echo m > interactive/M2.hs; echo t > interactive/T2.hs
git add interactive/M2.hs interactive/T2.hs
run "multi-path unscoped" noisy git commit -q -m two

echo "another lane staged first, this lane commits -o -- the repair"
echo m > interactive/M3.hs; echo t > interactive/T3.hs
git add interactive/T3.hs
git add interactive/M3.hs
run "scoped -o" quiet git commit -q -o interactive/M3.hs -m three
echo "  other lane's file still staged, not taken: [$(git diff --cached --name-only | tr '\n' ' ')]"
echo "  commit carried: [$(git show --stat --format= HEAD | head -1 | tr -s ' ')]"

echo "mid-merge, where git itself refuses -o -- must not refuse either"
git commit -q -m clear -- interactive/T3.hs 2>/dev/null
git checkout -q -b side
echo s > interactive/S.hs; git add interactive/S.hs; git commit -q -m side
git checkout -q main
echo m > interactive/S.hs; git add interactive/S.hs; git commit -q -m mainside
git merge side >/dev/null 2>&1
echo m > interactive/S.hs; git add interactive/S.hs
run "mid-merge unscoped" quiet git commit -q -m resolve
echo "  (quiet because the conflict resolution staged one path; the assertion"
echo "   here is rc=0, since -o is impossible mid-merge and a refusal would"
echo "   strand every lane resolving a conflict)"
