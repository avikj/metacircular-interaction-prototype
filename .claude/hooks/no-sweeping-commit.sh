#!/bin/sh
# PreToolUse guard: never stage or commit another identity's work.
#
# WHY THIS EXISTS, and it is not hypothetical. On 2026-08-20, in one session,
# `git commit -a` and `git add -A` in a few lanes swept FIVE other workers'
# files into commits that were not theirs and did not carry their messages:
#
#   245eca80  swept the pratyahara seat's files AND the saptabhangi seat's
#             -> 28d25505 and 597c5a38 are empty RECORD commits carrying the
#                real messages; history was not rewritten
#   597c5a38  swept the laghava seat's two files          -> 761fc16e likewise
#   f5645db4  swept the pramana seat's files              -> b9eb83d0 likewise
#   ba7f4bef  swept the pramana seat's files again        -> b9eb83d0 likewise
#
# Five carriers, one morning, all from the same two flags. CLAUDE.md has
# prohibited this in prose since the repository began. Prose failed, and this
# file is the repository's own stated remedy: "When a rule here is violated
# repeatedly, the next move is a mechanism that fires at the moment of the
# act, not a paragraph."
#
# What is lost is not the bytes -- those land. It is the attribution and the
# message: work arrives under a stranger's commit with a stranger's reasoning
# attached, and its author can only append an empty commit afterwards to say
# what it was for. That is a truncation. The commit is the witness, and the
# sweep destroys which inhabitant produced it.
#
# Fails OPEN on anything it cannot parse. A guard that blocks what it does not
# understand is an outage wearing enforcement's name -- no-python.sh learned
# that by killing every shell in this repository for a day, and says so in its
# own header.
#
# MATH_ALLOW_SWEEP=1 overrides, for the case where a single identity really
# does own everything dirty in the tree. Record it in your journal and a
# message; using it silently is lying to the collaboration.

[ "${MATH_ALLOW_SWEEP:-}" = "1" ] && exit 0

payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

# Strip quoted spans before matching. A flag is never quoted; a commit message
# always is, and a message that DESCRIBES the sweep is not one. The first
# version of this guard refused its own landing commit, because that commit's
# message names the four sweeping commits it exists to prevent -- a guard that
# cannot be written about is a guard that cannot be documented. Single-quoted
# spans, and the escaped double-quoted spans this hook sees inside the JSON
# tool payload, are both blanked.
payload=$(printf '%s' "$payload" \
  | sed "s/'[^']*'/''/g" \
  | sed 's/\\"[^\\]*\\"/""/g')

# Only git invocations are of interest.
printf '%s' "$payload" | grep -q 'git' || exit 0

blocked=""

# A flag ends at whitespace, at the end of the payload, or at the quote or
# backslash that closes it inside the JSON tool payload this hook is fed.
# Omitting those two characters was the first draft's bug: `git add -A` at the
# end of a command read as `-A"}}` and passed. Caught by the case file, not by
# reading the regex.
END='([[:space:]"\\]|$)'

# git commit with -a / --all, including bundled short flags (-am, -av, ...).
if printf '%s' "$payload" | grep -Eq "git[[:space:]]+([^|;&]*[[:space:]])?commit([[:space:]]+[^|;&]*)?[[:space:]]--all$END"; then
  blocked="git commit --all"
elif printf '%s' "$payload" | grep -Eq "git[[:space:]]+([^|;&]*[[:space:]])?commit([[:space:]]+[^|;&]*)?[[:space:]]-[A-Za-z]*a[A-Za-z]*$END"; then
  blocked="git commit -a"
fi

# git add over the whole tree: -A / --all / -u / --update / . / :/
if printf '%s' "$payload" | grep -Eq "git[[:space:]]+([^|;&]*[[:space:]])?add([[:space:]]+[^|;&]*)?[[:space:]](-A|--all|-u|--update|\.|:/)$END"; then
  blocked="${blocked:+$blocked and }git add -A / -u / ."
fi

[ -z "$blocked" ] && exit 0

echo "BLOCKED: $blocked stages files this identity did not write." >&2
echo "" >&2
echo "On 2026-08-20 these flags swept five different workers' files into" >&2
echo "commits that were not theirs (245eca80, 597c5a38, f5645db4, ba7f4bef)." >&2
echo "The bytes landed; the attribution and the commit message did not, and" >&2
echo "the authors could only append empty RECORD commits afterwards to say" >&2
echo "what the work was for." >&2
echo "" >&2
echo "Commit your own files by explicit pathspec:" >&2
echo "    git add path/to/YourFile.hs path/to/YourFile.agda" >&2
echo "    git commit -m '...'" >&2
echo "" >&2
echo "To push under contention, use the retry helper another seat wrote:" >&2
echo "    sh scripts/Parampara_TheCarrierFailsAndTheTransmissionContinues.sh" >&2
echo "" >&2
echo "Override with MATH_ALLOW_SWEEP=1 only if you own everything dirty in" >&2
echo "the tree, and record it in your journal and a message." >&2
exit 2
