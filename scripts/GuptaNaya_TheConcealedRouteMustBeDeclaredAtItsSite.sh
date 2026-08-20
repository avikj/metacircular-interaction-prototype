#!/usr/bin/env bash
# गुप्तनय — the concealed route.  A standing check on the Lean lane's oracle
# use.  No toolchain required; this is text analysis and fires on the write.
#
# ---------------------------------------------------------------------------
# THE PRINCIPLE, AND WHOSE IT IS
#
# Jaina nayavāda (Siddhasena Divākara, *Sanmatitarka*, Prakrit, c. 5th–6th c.
# CE; elaborated by Akalaṅka, 8th c.): every piece of knowledge is held from a
# standpoint, a *naya*.  A naya is not a defect — it is the only way knowledge
# comes.  What makes it a **durnaya** is CONCEALMENT: a standpoint that does
# not declare itself and so presents a partial warrant as the whole.
# `notes/AHIMSA_SUTRA_VISTARA.md` §2 states it in four lines —
#
#     सर्वं ज्ञानं सनयम् । निर्नयं ज्ञानं नास्ति ।
#     यो नयं न वदति स नयं गोपयति ।
#     गुप्तो नयो दुर्नयो भवति ।
#
#   "All knowledge is standpointed; there is no standpointless knowledge.
#    He who does not state the standpoint conceals it.
#    A concealed standpoint becomes a durnaya."
#
# and adds the sharp part: दुर्नयो न मिथ्या — a durnaya is not FALSE, and that
# is what makes it worse than a falsehood.  A false claim can be contradicted.
# A concealed standpoint offers nothing to contradict, because the place it
# was seen from is hidden.
#
# NOT CLAIMED: that the Jaina logicians wrote about compilers.  What is theirs
# is the principle that the route to a claim is part of the claim, and that
# hiding the route is a distinct fault from being wrong.
#
# ---------------------------------------------------------------------------
# THE ROUTE THIS CHECKS
#
# `native_decide` does not ask Lean's kernel anything.  It compiles the
# decision procedure to machine code, runs it, and — if it returns `true` —
# emits a fresh axiom per use, so that every `#print axioms` downstream of it
# names a generated `._native.native_decide.ax`.  The claim is then warranted
# by the Lean COMPILER (and by the CPU it ran on), not by the kernel.  That is
# a real route to knowledge and this check does not forbid it.  It requires it
# to be DECLARED, in three places, because the three answer three different
# readers:
#
#   1. AT THE USE SITE — for whoever is editing that proof.
#   2. IN THE FILE HEADER (`-- TRUSTS-COMPILER:`) — for whoever opens the file.
#   3. IN `axiom-allowlist.txt` — for whoever audits the lane, WITH the
#      observed reason kernel `decide` does not work and what would remove it.
#
# 2 and 3 were recommended by `notes/NATIVE_DECIDE_AUDIT.md` §5 and adopted;
# 3 is enforced by `lake exe axiom_gate` and 2 by nothing.  1 did not exist.
# This repository's own rule (CLAUDE.md, "Regressions observed in one long
# session") is that when a rule is repeatedly stated and not mechanised, the
# next move is a mechanism that fires at the moment of the act, not another
# paragraph.  So: this.
#
# ---------------------------------------------------------------------------
# WHAT THIS IS NOT, stated so nobody retires the thing that actually works
#
# `lake exe axiom_gate` is the real instrument.  It walks the BUILT
# environment and runs `Lean.collectAxioms`, so it sees oracle dependency
# THROUGH IMPORTS, which no grep can — two of the 28 modules tainted at audit
# time contained no occurrence of the token.  This script counts SITES.
#
#   axiom gate        — sees dependencies; needs a full build; blind to
#                       anonymous declarations.
#   example-oracles   — sees anonymous declarations; blind to dependencies.
#   this script       — sees whether the route is DECLARED; blind to both.
#
# Three complements, none subsuming another.  A green here is not a soundness
# claim and must never be quoted as one.
#
# ---------------------------------------------------------------------------
# EXIT 0 = every oracle site in the lane declares its route in all three
# places.  Checks 1–4 fail the script.  Check 5 REPORTS and does not fail:
# it is a judgement call on English prose, and a blocking guard on a
# judgement call is an outage wearing enforcement's name.
set -euo pipefail

cd "$(dirname "$0")/.."

LANE="${LEAN_LANE_DIR:-formal/pairfield/Pairfield}"
ALLOWLIST="${LEAN_ALLOWLIST:-formal/pairfield/axiom-allowlist.txt}"

[ -d "$LANE" ] || { echo "GuptaNaya: lane directory $LANE not found" >&2; exit 2; }
[ -f "$ALLOWLIST" ] || { echo "GuptaNaya: no allowlist at $ALLOWLIST" >&2; exit 2; }

# The tokens that route a claim around the kernel.  `sorry`/`sorryAx` are here
# because they are the same fault in its purest form: a claim with no route at
# all.  CLAUDE.md says all three are absent from the lane and must stay absent.
ORACLES='native_decide|ofReduceBool|ofReduceNat|sorryAx|\bsorry\b'

# The marker this check introduces, and the ONLY thing it adds to the lane's
# obligations.  One comment line, immediately above the tactic or trailing it.
SITE_MARKER='NATIVE-BECAUSE:'
HEADER_MARKER='TRUSTS-COMPILER:'

status=0
n_sites=0
fail() { echo "    $1"; status=1; }

# strip `--` line comments so a header PARAGRAPH about native_decide is not
# counted as a use of it.  Block comments `/- -/` are handled by depth.
strip_comments() {
  awk '
  BEGIN { d = 0 }
  { out = ""; n = length($0); i = 1
    while (i <= n) {
      c2 = substr($0, i, 2)
      if (c2 == "/-") { d++; i += 2; continue }
      if (d > 0 && c2 == "-/") { d--; i += 2; continue }
      if (d == 0 && c2 == "--") { break }
      if (d == 0) out = out substr($0, i, 1)
      i++
    }
    print out
  }' "$1"
}

# The nearest preceding column-0 declaration keyword, and its name.  Same
# attribution rule notes/DECIDE_STATEMENT_SWEEP.md §1 used, and it carries the
# same warning: it names SITES, not dependencies.
sites_in() { # sites_in <file> -> "LINE<TAB>KIND<TAB>NAME<TAB>TOKEN"
  local f="$1"
  paste -d'\t' <(seq 1 "$(wc -l < "$f")") <(strip_comments "$f") \
    | awk -F'\t' -v oracles="$ORACLES" '
        $2 ~ /^(theorem|lemma|example|def|instance|abbrev|axiom|opaque)[ \t({\[]/ {
          split($2, w, /[ \t({\[]/); kind = w[1]; name = w[2]
          if (name == "") name = "(anonymous)"
        }
        { if (match($2, oracles))
            printf "%s\t%s\t%s\t%s\n", $1, kind, name, substr($2, RSTART, RLENGTH) }
      '
}

files=$(find "$LANE" -name '*.lean' -not -path '*/.lake/*' | sort)

# Declarations found to use an oracle, for checks 3 and 5.
oracle_decls=""

echo "GuptaNaya — is every route to a claim declared where the claim is made?"
echo "lane      : $LANE"
echo "allowlist : $ALLOWLIST"
echo

for f in $files; do
  sites=$(sites_in "$f" || true)
  [ -n "$sites" ] || continue

  # ---- 2. the file header must declare that this module trusts the compiler
  # (checked once per file, before the per-site loop, so the message is one
  # line and not one per site).
  if ! grep -q -- "$HEADER_MARKER" "$f"; then
    fail "NO-HEADER          $f uses an oracle and carries no \`-- $HEADER_MARKER\` header"
  fi

  while IFS=$'\t' read -r line kind name tok; do
    [ -n "$line" ] || continue
    n_sites=$((n_sites + 1))

    # ---- 1. the site itself must say why the kernel route was not taken.
    #
    # The window is the CONTIGUOUS `--` comment block immediately above the
    # site, of any length, plus the site line itself.  A fixed-size window was
    # the first draft and it was wrong in the way that matters: the observed
    # reason for the one live site in this lane is two measurements, a cause
    # and a removal path, and it runs to fifteen lines.  A rule that only
    # admits three would have taught people to write a marker that says
    # nothing, which is the concealment this file exists to prevent, wearing
    # compliance's clothes.  Attachment, not length, is the right criterion.
    lo=$line
    while [ "$lo" -gt 1 ]; do
      prev=$(sed -n "$((lo - 1))p" "$f")
      case "$(printf '%s' "$prev" | sed 's/^[[:space:]]*//')" in
        --*) lo=$((lo - 1)) ;;
        *) break ;;
      esac
    done
    if ! sed -n "${lo},${line}p" "$f" | grep -q -- "$SITE_MARKER"; then
      fail "NO-SITE-REASON     $f:$line \`$tok\` in \`$kind $name\` — no \`-- $SITE_MARKER\` in the comment block attached to the site"
    fi

    # ---- 4. an anonymous declaration cannot be reached by the axiom gate at
    # all.  scripts/check-lean-example-oracles.sh owns the `example` case; this
    # catches every other way a site ends up unattributable.
    if [ "$name" = "(anonymous)" ] || [ "$kind" = "example" ]; then
      fail "UNNAMED            $f:$line \`$tok\` sits in an anonymous \`$kind\`; \`lake exe axiom_gate\` cannot see it"
    else
      oracle_decls="$oracle_decls
$name"
    fi
  done <<< "$sites"
done

# ---- 3. every oracle-carrying declaration must be named in the allowlist ----
# Matched on the final component, because the allowlist stores fully-qualified
# names (`Pairfield.ChartQuotientWitness.quotientCard_eq_three`) and a source
# file states the short one.  A suffix match can in principle collide; that
# would ADMIT a site rather than fail one, so it is recorded as a residual
# below rather than dressed up as exact.
allow=$(grep -v '^[[:space:]]*#' "$ALLOWLIST" | grep -v '^[[:space:]]*$' || true)
uniq_decls=$(printf '%s\n' "$oracle_decls" | grep -v '^$' | sort -u || true)
for d in $uniq_decls; do
  if ! printf '%s\n' "$allow" | grep -qE "(^|\.)${d}$"; then
    fail "NOT-ALLOWLISTED    \`$d\` uses an oracle and is not in $ALLOWLIST"
  fi
done

echo "oracle sites found : $n_sites"
echo "declarations       : $(printf '%s\n' "$uniq_decls" | grep -c . || true)"

# ---- 5. ADVISORY: prose that calls such a theorem "checked" ---------------
#
# The other half of the discipline, and the half no mechanism touched: a
# theorem resting on `native_decide` must never be described as "checked",
# "proved" or "verified" without the qualification, because the reader of that
# sentence has no way to recover the route.  This is the durnaya proper — the
# sentence is not FALSE (the theorem is very probably true and the compiler
# very probably ran it correctly), it simply conceals which faculty did the
# work.
#
# Reported and not failed.  Word adjacency in English is a judgement call, the
# hit rate on a corpus this size is unknown, and this repository's own record
# says a blocking guard on a judgement call becomes a red light nobody looks
# at.  What it does buy is that nobody has to REMEMBER to grep.
echo
echo "advisory — prose describing an oracle-backed declaration:"
CLAIM='checked|verified|machine-checked|kernel|proved|proven|green'
QUALIFY='native_decide|native decide|compiler|TRUSTS-COMPILER|oracle|axiom|allowlist|ofReduceBool|not kernel|un-?checked'
found_prose=0
n_claims=0
for d in $uniq_decls; do
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    n_claims=$((n_claims + 1))
    if ! printf '%s' "$hit" | grep -qE "$QUALIFY"; then
      echo "    UNQUALIFIED  $hit"
      found_prose=1
    fi
  done <<< "$(grep -rInE "$d" --include='*.md' notes collab machine formal 2>/dev/null \
              | grep -E "$CLAIM" || true)"
done
# Two different observations, kept apart.  "Every mention is qualified" is a
# result; "there are no mentions" is not, and printing the same sentence for
# both is the exact collapse this file is named after — a verdict presented
# without the standpoint it was reached from.
if [ "$n_claims" -eq 0 ]; then
  echo "    VACUOUS: no prose in notes/ collab/ machine/ formal/ mentions any of these"
  echo "    declarations alongside a claim word.  This check has therefore not been"
  echo "    exercised and today's green says nothing about it."
elif [ "$found_prose" -eq 0 ]; then
  echo "    $n_claims claim-bearing mention(s), all of them carrying the route."
fi

echo
if [ "$status" -ne 0 ]; then
  echo "FAIL: an oracle site does not declare its route."
  echo "The remedy is never to delete this check.  It is one of:"
  echo "  * replace \`native_decide\` with kernel \`decide\` (try \`decide +kernel\` FIRST —"
  echo "    it retired five sites in DiagonalSmithRoute.lean, see NATIVE_DECIDE_AUDIT §4b);"
  echo "  * or declare the route: \`-- $SITE_MARKER <observed reason>\` at the site, a"
  echo "    \`-- $HEADER_MARKER\` header on the file, and an entry in $ALLOWLIST"
  echo "    carrying (a) the axiom, (b) the OBSERVED reason kernel checking does not"
  echo "    work — measured, not guessed — and (c) what would remove it."
  exit 1
fi

echo "OK: every oracle site declares its route at the site, in the file header,"
echo "    and in the allowlist.  This says nothing about taint through imports:"
echo "    run \`lake exe axiom_gate\` for that."
echo
echo "RESIDUAL, stated rather than hidden: check 3 matches the allowlist on the"
echo "final name component, so two declarations with the same short name in"
echo "different namespaces would each satisfy the other's entry.  That direction"
echo "ADMITS a site rather than failing one, and the axiom gate catches it with"
echo "fully-qualified names.  Fixing it here needs namespace tracking this"
echo "textual pass does not have."
