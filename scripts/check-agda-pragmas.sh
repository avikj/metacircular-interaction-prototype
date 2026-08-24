#!/usr/bin/env bash
# Mechanical `--safe` header check for the Agda lane — no Agda required.
#
# WHY THIS EXISTS
#
# CLAUDE.md's guarantee for the Agda lane is "`--cubical --safe`, no
# postulates, no holes".  But `--safe` is asserted PER MODULE, via an
# `{-# OPTIONS ... #-}` pragma that must appear before the module header.
# A file that omits the pragma is typechecked WITHOUT it, silently: it may
# postulate, use `{-# TERMINATING #-}`, `primTrustMe`, `--rewriting`, or
# leave metas unsolved, and `formal/check.sh` will still print nothing.
# Agda has no lane-wide assertion; the convention was a repeated header and
# a prose claim.  notes/AXIOM_GATE.md §6.1 identified this as the one
# remaining asymmetry between the two lanes and declined to gate on it,
# correctly, for want of a measurement.  notes/AGDA_PRAGMA_AUDIT.md is the
# measurement; this is the gate.
#
# WHAT IT CHECKS, purely textually, over every *.agda under formal/:
#   1. every file has an `{-# OPTIONS ... #-}` pragma, on its own line,
#      BEFORE the `module` header (a pragma after it does not apply);
#   2. the pragma carries `--safe`;
#   3. files under formal/cubical/ additionally carry `--cubical`;
#   4. no pragma carries a `--safe`-incompatible or discipline-defeating
#      flag (see UNSAFE_FLAGS below);
#   5. no file contains, in code (line comments stripped), `postulate`, an
#      interaction hole `{! !}`, `{-# TERMINATING #-}`,
#      `{-# NON_TERMINATING #-}`, `{-# NON_COVERING #-}`,
#      `{-# NO_POSITIVITY_CHECK #-}`, `{-# POLARITY #-}`,
#      `{-# INJECTIVE #-}`, `{-# REWRITE #-}`, `primTrustMe` or `trustMe`.
#
# WHAT IT DOES NOT CHECK.  It is text analysis, not a build; it says nothing
# about whether any module typechecks (that is formal/check.sh and the pin in
# BUILD.md) nor about whether a module is reachable from an aggregate root
# (that is scripts/check-agda-closure.sh).  Points 4 and 5 are belt-and-braces:
# Agda's own `--safe` already rejects every one of them at typecheck time.
# The load-bearing check is 1-3, because those are what make `--safe` apply
# at all, and nothing else in this repository measures them.
#
# Exit 0 = every module asserts `--safe`, and nothing in the lane relies on
# a construct `--safe` forbids.
set -euo pipefail

cd "$(dirname "$0")/.."

# `--safe`-incompatible or discipline-defeating options.  Agda itself rejects
# most of these alongside `--safe`; listing them makes the failure legible
# here rather than 40 minutes into a build, and catches the case where
# someone drops `--safe` and adds one of these in the same edit.
# Matched as whole words: `--guarded` (experimental later-modality theory,
# NOT --safe) must not match `--guardedness` (the ordinary coinduction
# totality checker, which IS --safe-compatible and is used by 275 modules
# here). Getting that wrong flagged 275 files on the first run.
UNSAFE_FLAGS='--type-in-type|--omega-in-omega|--no-termination-check|--no-positivity-check|--no-coverage-check|--injective-type-constructors|--rewriting|--allow-unsolved-metas|--allow-incomplete-matches|--no-forcing|--no-flat-split|--cumulativity|--sized-types|--experimental-irrelevance|--guarded|--erased-matches|--no-double-check'

# In-code constructs that defeat the discipline CLAUDE.md asserts.
BAD_CONSTRUCTS='postulate|\{!|\{-# *(TERMINATING|NON_TERMINATING|NON_COVERING|NO_POSITIVITY_CHECK|POLARITY|INJECTIVE|REWRITE|IMPOSSIBLE)|primTrustMe|trustMe'

# ---------------------------------------------------------------------- #
# ALLOWLIST.  Every entry names its file and its reason.  An allowlist      #
# without reasons rots into a rubber stamp within one shift                 #
# (notes/AXIOM_GATE.md §4); if an entry loses its reason, delete the entry, #
# let the gate go red, and make someone look.                              #
#                                                                          #
# Format: one "path<TAB>check" pair per line, where check is one of        #
# no-safe | no-cubical | unsafe-flag | construct.                          #
#                                                                          #
# As of the audit (2026-08-15) this list is EMPTY, and that is the finding: #
# all 378 .agda files under formal/ carry `--safe`.  The two candidate      #
# exceptions were examined and neither needs an entry:                     #
#                                                                          #
#   * formal/cubical/NaturalMachine/Control/*.agda (9 files) — deliberately #
#     ill-typed controls that MUST fail to typecheck (BUILD.md), and which  #
#     check-agda-closure.sh keeps unimported.  They would be the natural    #
#     exception, but they do not need one: all 9 carry                      #
#     `--cubical --safe --no-import-sorts` (2 also `--guardedness`).  A     #
#     control that fails for the intended mathematical reason should still  #
#     be `--safe`; if it ever needs to drop the flag to fail the RIGHT way, #
#     add it here with that reason spelled out.                            #
#   * formal/executable/*.agda (8 files) — MAlonzo/GHC extraction targets   #
#     (machine/run-extracted-rewrite.sh), non-cubical by construction.      #
#     They carry `--safe` (one also `--guardedness`) and are exempt from    #
#     the `--cubical` check by directory scope, not by allowlist: check 3   #
#     applies only under formal/cubical/.                                   #
# ---------------------------------------------------------------------- #
# First entry, 2026-08-23, found by ./nitya's second-ever performance:     #
#                                                                          #
#   * AsiddhaCatustayam_… — NOT --safe BY DESIGN, its own header's first    #
#     line: the module states four open problems (Goldbach, twin primes,   #
#     Collatz, RH) as types and leaves every proof a HOLE — the kernel's   #
#     located refusal IS the artifact, and --safe forbids holes.  Held     #
#     out of Everything.agda's closure deliberately (verified: no import). #
#     If this file ever gains a proof term, delete this entry and let the  #
#     gate demand --safe for what it now actually claims.                  #
# ---------------------------------------------------------------------- #
ALLOWLIST=$(cat <<'EOF'
formal/cubical/AsiddhaCatustayam_TheFourUnestablishedHeldAtOnceAndRefusedByTheKernel.agda	no-safe
EOF
)

allowed() { # allowed <path> <check>
  [ -n "$ALLOWLIST" ] || return 1
  printf '%s\n' "$ALLOWLIST" | grep -qxF "$(printf '%s\t%s' "$1" "$2")"
}

status=0
n_files=0; n_safe=0; n_cubical=0
fail() { echo "    $1"; status=1; }

files=$(find formal -name '*.agda' -not -path '*/_build/*' | sort)

for f in $files; do
  n_files=$((n_files + 1))

  # Pragma line must precede the module header to have any effect.
  pl=$(grep -n '^{-# OPTIONS' "$f" | head -1 | cut -d: -f1 || true)
  ml=$(grep -n '^module ' "$f" | head -1 | cut -d: -f1 || true)

  if [ -z "$pl" ]; then
    allowed "$f" no-safe || fail "NO-OPTIONS-PRAGMA  $f (typechecked without --safe)"
    continue
  fi
  if [ -n "$ml" ] && [ "$pl" -gt "$ml" ]; then
    fail "PRAGMA-AFTER-MODULE $f (line $pl > module line $ml; the pragma does not apply)"
  fi

  opts=$(sed -n "${pl}p" "$f")

  case " $opts " in
    *" --safe "*) n_safe=$((n_safe + 1)) ;;
    *) allowed "$f" no-safe || fail "NO-SAFE            $f: $opts" ;;
  esac

  case "$f" in
    formal/cubical/*)
      case " $opts " in
        *" --cubical "*) n_cubical=$((n_cubical + 1)) ;;
        *) allowed "$f" no-cubical || fail "NO-CUBICAL         $f: $opts" ;;
      esac ;;
  esac

  # `-e` is required: every alternative begins with `-`.  Whole-word match
  # (padded, delimiter-anchored) so `--guardedness` is not read as `--guarded`.
  bad=$(printf ' %s ' "$opts" \
        | grep -oE -e "(^|[[:space:]])($UNSAFE_FLAGS)([[:space:]]|$)" \
        | tr -d '[:space:]' | sort -u || true)
  if [ -n "$bad" ]; then
    allowed "$f" unsafe-flag \
      || fail "UNSAFE-FLAG        $f: $(printf '%s' "$bad" | tr '\n' ' ')"
  fi
done

# ---- in-code constructs, with ALL comments stripped ----------------------
# Naive `sed 's/--.*$//'` is not enough: this corpus is heavily commented, and
# the phrase "no postulates, no holes" appears in ~40 header blocks, one of
# them (ObligatioOrderTrilemma.agda:34) inside a `{- ... -}` block rather than
# on `--` lines. A gate that reports that is a gate people learn to ignore.
# strip_comments walks characters tracking `{- ... -}` nesting depth, emits
# only depth-0 text, and drops `--`-to-EOL at depth 0. `{-#` is deliberately
# NOT treated as a comment opener, so `{-# TERMINATING #-}` survives to be
# caught; a `{-#` inside a block comment still nests and closes balanced.
# Line numbering is preserved (one output line per input line).
strip_comments() {
  awk '
  BEGIN { d = 0 }   # depth persists ACROSS lines: block comments are multi-line
  { out = ""; n = length($0); i = 1
    while (i <= n) {
      c2 = substr($0, i, 2)
      if (d == 0 && c2 == "{-" && substr($0, i+2, 1) == "#") { out = out "{-#"; i += 3; continue }
      if (c2 == "{-") { d++; i += 2; continue }
      if (d > 0 && c2 == "-}") { d--; i += 2; continue }
      if (d == 0 && c2 == "--") { break }
      if (d == 0) out = out substr($0, i, 1)
      i++
    }
    print out
  }' "$1"
}

# Prefilter: only files whose RAW text mentions a bad construct need the
# (comparatively slow) comment strip. Stripping can only remove matches, never
# create them, so this is exact, and it cuts 378 awk invocations to ~50.
candidates=$(printf '%s\n' $files | xargs grep -lE "$BAD_CONSTRUCTS" || true)

for f in $candidates; do
  hits=$(strip_comments "$f" | grep -nE "$BAD_CONSTRUCTS" || true)
  if [ -n "$hits" ]; then
    allowed "$f" construct || {
      printf '%s\n' "$hits" | while IFS= read -r h; do
        fail "CONSTRUCT          $f:$h"
      done
      status=1
    }
  fi
done

echo "files scanned      : $n_files (formal/**/*.agda)"
echo "assert --safe      : $n_safe"
echo "assert --cubical   : $n_cubical (of $(printf '%s\n' "$files" | grep -c '^formal/cubical/') under formal/cubical/)"

if [ "$status" -ne 0 ]; then
  echo
  echo "FAIL: the lane's --safe guarantee is asserted per module, and the above"
  echo "module(s) do not assert it, or rely on a construct --safe forbids."
  echo "Add the pragma, or add an allowlist entry WITH ITS REASON in this script."
else
  echo "OK: every module asserts --safe; no postulate, hole, TERMINATING,"
  echo "    trustMe, REWRITE or --safe-incompatible flag in the lane."
fi
exit "$status"
