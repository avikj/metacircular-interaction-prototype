#!/bin/sh
# PreToolUse guard: the markdown ban (human owner, 2026-08-24), enforced at
# tool-call time.  Modelled exactly on no-python.sh, including its failure
# posture, because the argument is the same one.
#
# WHY.  A .md file asserts.  A checked term is the object.  The corpus's own
# measurement: 975 notes, 3.8% of them reaching a chapter; 443 commits to
# machine/ against 6 to the directory that called itself "the machine that is
# the process" and was twelve markdown files deep.  The failure this ban
# targets is not sloppiness, it is that prose is the cheapest thing an agent
# can emit and the only thing nothing can refute.  kernel/ was deleted on
# 2026-08-24 for exactly this, and the agent asked to read the metacircular
# core had answered by writing two more markdown files into it.
#
# SCOPE, and it matches the Python ban's scope precisely.  EXISTING .md files
# are legacy: deletions always pass, additions and modifications do not.  The
# ban is on NEW prose, not on the record already written -- striking a claim
# in place stays possible only because CLAUDE.md itself is legacy under this
# rule.
#
# THE CONFLICT, stated here rather than discovered later.  BOOK.md says this
# repository is a book about India and that the PRIMARY deliverable is
# "reading the texts, translation, scholarship from inside the tradition."
# That deliverable is prose.  Under this ban the book cannot be written in
# this repository in the form BOOK.md describes.  That is a real cost and the
# owner's call, not the hook's; the hook records it so nobody rediscovers it
# as a surprise.
#
# Fails OPEN on anything it cannot parse.  A guard that blocks what it does
# not understand is an outage wearing enforcement's name -- no-python.sh's own
# header records the session in which that killed every shell in the tree.
#
# TWO MATCHERS, and the second is not optional.  no-python.sh guards `Bash` as
# well as `Write|Edit` because a ban that only watches the file-writing tool is
# a ban on one spelling: `cat > notes/x.md <<'EOF'` is the same act through a
# different door, and it is the door an agent under pressure reaches for.  The
# Bash arm therefore matches WRITES ONLY -- redirection, tee, cp/mv/touch/sed
# -i onto a .md target.  Reads pass (grep, cat, less, wc, git log).  Deletions
# pass, by the scope rule above; so does `git rm`.
#
# MATH_ALLOW_MARKDOWN=1 overrides, and using it without recording it in your
# journal and a message is lying to the collaboration (CLAUDE.md).

[ "${MATH_ALLOW_MARKDOWN:-}" = "1" ] && exit 0

payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

md='\.(md|markdown)'

refuse() {
  echo "BLOCKED: $1. Markdown is banned in this repository" >&2
  echo "(owner, 2026-08-24). Deletions always pass; additions and" >&2
  echo "modifications do not." >&2
  echo "" >&2
  echo "A .md file asserts; a checked term is the object. Put it in Agda" >&2
  echo "(formal/cubical/, punaragamana/src/) or Lean (formal/pairfield/)." >&2
  echo "A claim that cannot be stated as a type is a claim nothing can" >&2
  echo "refute -- which is what the ban is about." >&2
  echo "" >&2
  echo "If the content is a header, a provenance note or a struck claim, it" >&2
  echo "belongs in the module it is about, where the kernel reads past it." >&2
  echo "Override with MATH_ALLOW_MARKDOWN=1 and record it in your journal" >&2
  echo "and a message." >&2
  exit 2
}

# creating or modifying a .md / .markdown file through the file-writing tools
if printf '%s' "$payload" | grep -Eq '"(Write|Edit|NotebookEdit)"' \
   && printf '%s' "$payload" | grep -Eq "${md}(\\\\\"|\"|\$)"; then
  refuse "writing a .md file"
fi

# the same act through the shell.  Writes only; reads and deletions pass.
if printf '%s' "$payload" | grep -Eq '"Bash"'; then
  # Matched against the whole payload rather than a cut-out "command" field:
  # splitting JSON with cut/tr is what makes a guard misfire, and the write
  # patterns below are specific enough that the description field does not
  # trip them.
  if printf '%s' "$payload" | grep -Eq ">>?[[:space:]]*[^[:space:]|;&\"]*${md}" \
     || printf '%s' "$payload" | grep -Eq "tee[[:space:]]+([^|;&\"]*[[:space:]])?[^[:space:]|;&\"]*${md}" \
     || printf '%s' "$payload" | grep -Eq "(cp|mv|touch|install)[[:space:]]+[^|;&\"]*${md}" \
     || printf '%s' "$payload" | grep -Eq "sed[[:space:]]+[^|;&\"]*-i[^|;&\"]*${md}"; then
    refuse "writing a .md file from the shell"
  fi
fi

exit 0
