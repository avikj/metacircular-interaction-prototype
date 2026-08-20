#!/bin/sh
# नष्टिः — PreToolUse guard on the command that actually swept.
#
# WHAT THIS IS FOR, and it is not the same thing as no-sweeping-commit.sh.
#
# Four lanes had staged work swept into other lanes' commits on 2026-08-20:
#   6b200f55 (subject: sugar)          carried the dosa-lekha lane's four files
#   c9726ed1 (subject: the Mrcchakatika) carried the wire lane's six
#   14cb41a5 (subject: a census mark)  carried the audit lane's five
#   acf4dcda                            carried a sixth lane's Everything.agda
#
# Three lanes independently diagnosed the cause as `git add -A`, and
# .claude/hooks/no-sweeping-commit.sh was built against that diagnosis.
# NOBODY RAN `git add -A`. Every one of those commands was of the form
#
#     git add <one-path> && git commit -q -m ...
#
# which is a correctly scoped `add` followed by an UNSCOPED `commit`. Run
# against the three real command strings, no-sweeping-commit.sh exits 0 on
# all three; it would have prevented none of the four commits. That is
# recorded, with the commands, in machine/dosa.lekha dosa 0013 and 0014.
#
# The cause is that `git commit` has no pathspec by default and takes the
# ENTIRE INDEX, and sixteen processes in this tree share one index. So the
# scoped `add` protects nothing: whatever a concurrent lane staged in the
# seconds before lands in this commit, under this commit's message.
#
# WHY THE HOOK CAN BE SURE, and this is the whole trick. PreToolUse fires
# BEFORE the command runs. So at the moment this hook looks, the command's
# own `git add` has not happened yet, and `git diff --cached --name-only` is
# EXACTLY the set of paths this command did not stage and will carry anyway.
# No parsing of pathspecs, no registry of who claims what, no per-agent
# config that sixteen live agents would have to be told about. The index
# itself names the hazard.
#
# WHAT IS DESTROYED is not the bytes -- those land. It is the attribution
# and the reason: `git log --follow` on a swept file reports it introduced by
# a commit about something else, and its author can only append an empty
# RECORD commit afterwards. AHIMSA_SUTRA_VISTARA section 4-5: the truncation
# makes all inhabitants equal in one step, the THAT remains and the WHICH
# perishes, and there is no retraction -- न दुर्लभम्, नास्ति.
#
# THE GRADED RESPONSE, so this is not an outage wearing enforcement's name:
#
#   index non-empty  -> the sweep is DEMONSTRATED (a drsta hazard: these named
#                       paths, right now, will be carried). Refuse, and print
#                       the ready-to-paste `-o` line. The remedy costs one flag.
#   index empty      -> the hazard is real but latent (another lane may stage
#                       between this `add` and this `commit`; the hook cannot
#                       see the future). Advise, exit 0.
#
# A judgement call is advised, never refused. A fact is refused. Everything
# it cannot parse, and every state where the remedy would not work, fails OPEN
# -- no-python.sh's header records the day a blocking guard killed every shell
# in this repository.
#
# AND `-o` IS NOT A COMPLETE FIX, which the message says out loud: `-o` scopes
# which PATHS, not which VERSION. It commits the WORKING TREE content of those
# paths, so if another lane has unstaged edits in a file you both touch, `-o`
# still carries them. The Panini lane hit exactly that on machine/MathMachine.hs
# and machine/Astadhyayi.hs. This hook warns when the paths you name with `-o`
# have unstaged modifications, so the log never implies otherwise.
#
# MATH_ALLOW_SWEEP=1 overrides (shared with no-sweeping-commit.sh, deliberately:
# one override for one class of harm). Using it silently is lying to the
# collaboration -- record it in your journal and a message.

[ "${MATH_ALLOW_SWEEP:-}" = "1" ] && exit 0

payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

# Extract the command, DECODED. This is not a detail. A multi-line Bash command
# reaches a hook as one JSON string with literal \n escapes, so a guard that
# matches the RAW payload sees a single grep line and its segment regexes span
# what were separate lines of the script. Demonstrated against
# no-sweeping-commit.sh: `git commit -o machine/Foo.hs -m x` and `ls -a` each
# exit 0 alone, and joined by an escaped newline they are REFUSED -- a blocking
# guard failing closed on two harmless lines. Decoding first is what makes
# every grep below line-oriented, which is the only reason they are safe.
#
# jq if present, tolerant sed if not; the fallback unescapes \n itself, because
# a guard that is only correct when jq is installed is not correct. Anything
# that does not yield a command exits 0.
cmd=""
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null)
fi
if [ -z "$cmd" ]; then
  cmd=$(printf '%s' "$payload" \
    | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' \
    | sed 's/\\n/\
/g; s/\\t/	/g; s/\\"/"/g')
fi
[ -z "$cmd" ] && exit 0

# Cheap reject: nothing to say about a command that never commits.
printf '%s' "$cmd" | grep -q 'commit' || exit 0

# `-o` / `--only` / an explicit `--` pathspec is the scoped form. Checked
# BEFORE quoted spans are blanked, so a quoted path is not mistaken for absent.
scoped=0
printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])(-o|--only)([[:space:]]|$)' && scoped=1
printf '%s' "$cmd" | grep -Eq 'commit([[:space:]]+[^|;&]*)?[[:space:]]--[[:space:]]' && scoped=1

# Blank quoted spans so a COMMIT MESSAGE that discusses `git commit` -- this
# header, dosa 0013, the message of this hook's own landing commit -- is not
# read as an invocation. A guard that cannot be written about cannot be
# documented; no-sweeping-commit.sh learned that by refusing its own landing.
#
# Heredoc BODIES are dropped first, for the same reason one level up: this
# hook's own source, and every dosa record about the sweep, is written to disk
# with `cat > file <<'EOF'`, and the text inside names the command. Without
# this pass the guard refuses the act of documenting the guard.
bare=$(printf '%s\n' "$cmd" | awk '
  { if (skip) { t=$0; sub(/[[:space:]]+$/,"",t); if (t==delim) skip=0; next }
    if (match($0, /<<-?[[:space:]]*[\047"]?[A-Za-z_][A-Za-z0-9_]*[\047"]?/)) {
      d=substr($0,RSTART,RLENGTH); sub(/^<<-?[[:space:]]*/,"",d); gsub(/[\047"]/,"",d)
      delim=d; skip=1 }
    print }' \
  | sed "s/'[^']*'/''/g" | sed 's/"[^"]*"/""/g')

# A real `git commit` invocation: `git` and `commit` in one pipeline segment,
# with only flags between them.
printf '%s' "$bare" | grep -Eq "git[[:space:]]+([^|;&]*[[:space:]])?commit([[:space:]]|$)" || exit 0

# --- states where the remedy does not exist: fail OPEN --------------------
# `git commit -o` is refused by git itself during a merge, rebase, cherry-pick
# or revert ("cannot do a partial commit during a merge"). Blocking here would
# strand every lane resolving a conflict, which is the outage this repository
# has already had once. Silence.
gitdir=$(git rev-parse --git-dir 2>/dev/null) || exit 0
for f in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
  [ -e "$gitdir/$f" ] && exit 0
done
for d in rebase-merge rebase-apply; do
  [ -e "$gitdir/$d" ] && exit 0
done

# --- the -o caveat: right paths, wrong version ---------------------------
if [ "$scoped" = 1 ]; then
  dirty=$(git diff --name-only 2>/dev/null | head -20)
  if [ -n "$dirty" ]; then
    echo "note: --only scopes which PATHS, not which VERSION. It commits the" >&2
    echo "WORKING TREE content of the paths you name, so if another lane has" >&2
    echo "unstaged edits in a file you both touch, those edits ride along." >&2
    echo "Unstaged right now:" >&2
    printf '%s\n' "$dirty" | sed 's/^/    /' >&2
    echo "If any of these are paths you are committing and the edits are not" >&2
    echo "yours, say so in the message rather than let the log imply otherwise." >&2
  fi
  exit 0
fi

# --- unscoped commit -----------------------------------------------------
staged=$(git diff --cached --name-only 2>/dev/null)

if [ -z "$staged" ]; then
  # Latent, not demonstrated. Advise; never refuse a judgement call.
  echo "note: this commit has no pathspec, so it will take whatever is in the" >&2
  echo "index when it runs. The index is empty NOW, but sixteen lanes share it" >&2
  echo "and this hook cannot see what is staged between your add and your" >&2
  echo "commit. Prefer: git commit -o <your paths> -m '...'" >&2
  exit 0
fi

n=$(printf '%s\n' "$staged" | wc -l | tr -d ' ')

echo "REFUSED: an unscoped 'git commit' with $n path(s) already in the index." >&2
echo "" >&2
echo "These are staged RIGHT NOW, before your command has run, so your own" >&2
echo "'git add' did not stage them. An unscoped commit takes the whole index" >&2
echo "and will carry all of them under your message:" >&2
echo "" >&2
printf '%s\n' "$staged" | sed 's/^/    /' >&2
echo "" >&2
echo "This is how 6b200f55, c9726ed1, 14cb41a5 and acf4dcda took four other" >&2
echo "lanes' files on 2026-08-20. Each of those ran a correctly scoped" >&2
echo "'git add <path>' first. The add was never the problem." >&2
echo "" >&2
echo "Name what you are committing:" >&2
echo "" >&2
echo "    git commit -o <your path> [<your path>...] -m '...'" >&2
echo "" >&2
echo "If the paths above ARE yours, staged in an earlier call, name them too:" >&2
echo "" >&2
printf '    git commit -o' >&2
printf '%s\n' "$staged" | while IFS= read -r p; do printf ' %s' "$p" >&2; done
printf " -m '...'\n" >&2
echo "" >&2
echo "Note that -o commits the WORKING TREE version of those paths, not your" >&2
echo "staged one. If a shared file has another lane's unstaged edits in it," >&2
echo "-o carries them, and that belongs in your message." >&2
echo "" >&2
echo "MATH_ALLOW_SWEEP=1 overrides, if you own everything in the index." >&2
echo "Record it in your journal and a message." >&2
exit 2
