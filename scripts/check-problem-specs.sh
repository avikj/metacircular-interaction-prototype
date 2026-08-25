#!/bin/sh
# check-problem-specs.sh — fail closed on problem specs and bound contracts.
#
# This is the non-Python replacement for the two content checks that
# `.github/workflows/epistemic.yml` used to run as
# `python3 machinery/validate.py`.  It validates DATA (JSON under
# machinery/specs/), not code, so it carries over whole: every invariant
# below is transcribed from machinery/validate.py::validate_problem_spec
# and machinery/bound_contract.py::validate_contract, which remain in the
# tree as the provenance for this file.
#
# Why it is shell and jq rather than Python: CLAUDE.md bans Python, and the
# repository's other CI job rejects any commit that adds or modifies a .py
# file.  A gate written in a language the repository's own gate refuses is
# a gate that cannot be repaired.  jq is present on ubuntu-latest.
#
# Scope, stated so nobody reads more into a green than it carries: this
# checks the three JSON specs.  It does NOT replace `discovery_loop.py
# validate` or the 282 machinery/test_*.py unit tests, which tested the
#
# Exit 0 = every spec valid.  Exit 1 = at least one invalid or unreadable.

set -eu

cd "$(dirname "$0")/.."

if ! command -v jq >/dev/null 2>&1; then
  echo "check-problem-specs: FAIL — jq is not installed." >&2
  exit 1
fi

CONTRACT_FORMAT="math-bound-contract-v1"

# ---------------------------------------------------------------- #
# math-problem-spec-v1                                              #
# transcribed from machinery/validate.py::validate_problem_spec     #
# ---------------------------------------------------------------- #
SPEC_PROGRAM='
def is_int: type == "number" and (. == floor);
. as $d
| if ($d | type) != "object" then ["problem spec must be an object"]
  else
    [ ("claim_id","family","degree","mode","coefficient_order","decomposition","stages")
      | . as $k | select(($d | has($k)) | not) | "missing \($k)" ]
    + ( if (["discovery","certificate"] | index($d.mode)) == null
        then ["mode must be discovery or certificate"] else [] end )
    + [ ($d.stages // [])[] as $s
        | ($s.constraints // [])[] as $c
        | ( if (["theorem","audited-lemma","heuristic"] | index($c.status)) == null
            then "\($s.id)/\($c.id): invalid status" else empty end ),
          ( if ($c.prunes // false)
                 and ((["theorem","audited-lemma"] | index($c.status)) == null)
            then "\($s.id)/\($c.id): unproved constraint may not prune" else empty end ),
          ( if ($c.prunes // false)
                 and (($c.proof_ref == null) or ($c.proof_ref == "") or ($c.proof_ref == "pending"))
            then "\($s.id)/\($c.id): pruning requires proof_ref" else empty end )
      ]
  end
| .[]
'

# ---------------------------------------------------------------- #
# math-bound-contract-v1                                            #
# transcribed from machinery/bound_contract.py::validate_contract   #
# ---------------------------------------------------------------- #
CONTRACT_PROGRAM='
# machinery/bound_contract.py::_canonical_nonnegative_integer accepts an
# integer, or a STRING that is already the canonical decimal spelling of a
# nonnegative integer -- int(v) must round-trip through str().  So "14"
# passes and "014", "+14", " 14", "1e3" and true do not.  The specs in the
# tree store their bounds as strings, so getting this right is the whole
# check.  Returns the numeric value, or null if not canonical.
def canon:
  if type == "boolean" then null
  elif type == "number" then (if . == floor and . >= 0 then . else null end)
  elif type == "string" then (if test("^(0|[1-9][0-9]*)$") then tonumber else null end)
  else null end;
def is_nonneg_int: canon != null;
. as $d
| if ($d | type) != "object" then ["contract must be an object"]
  else
    ( if $d.format != "math-bound-contract-v1" then ["wrong format"] else [] end )
    + ( if ($d.polynomial | type) != "string" or ($d.polynomial | length) == 0
        then ["polynomial must be a nonempty string"] else [] end )
    + ( ($d.degree) as $deg
      | if ($deg | type) != "number" or ($deg != ($deg | floor)) or $deg < 2
        then ["degree must be an integer at least 2"]
        else
          ( ($d.bounds_by_exponent) as $bm
          | if ($bm | type) != "object" then ["bounds_by_exponent must be an object"]
            else
              ( if (([range(1; $deg)] | map(tostring) | sort) != (($bm | keys) | sort))
                then ["bounds_by_exponent must contain exactly the interior exponents 1..\($deg - 1)"]
                else [] end )
              + [ $bm | to_entries[]
                  | select((.value | is_nonneg_int) | not)
                  | "invalid bound entry at exponent \"\(.key)\"" ]
              + ( ($d.derived_vector) as $dv
                | if ($dv | type) != "object" then ["derived_vector must be an object"]
                  elif (["constant-to-leading","leading-to-constant"] | index($dv.orientation)) == null
                    then ["derived_vector orientation is invalid"]
                  elif ($dv.values | type) != "array" or ($dv.values | length) != ($deg - 1)
                    then ["derived_vector values must have length \($deg - 1)"]
                  elif ([ $dv.values[] | select((. | is_nonneg_int) | not) ] | length) > 0
                    then ["invalid derived_vector: bound must be a canonical nonnegative decimal integer"]
                  else
                    # The orientation cross-check: the vector is indexed by
                    # POSITION, the map by EXPONENT, and a reversed vector is
                    # otherwise indistinguishable from a correct one.
                    [ range(0; $deg - 1) as $i
                      | (if $dv.orientation == "constant-to-leading"
                         then $i + 1 else $deg - 1 - $i end) as $e
                      | ($dv.values[$i] | canon) as $observed
                      | ($bm[($e | tostring)] | canon) as $expected
                      | select($observed != $expected)
                      | "orientation mismatch: derived_vector index \($i) denotes exponent \($e), giving \($observed), but bounds_by_exponent gives \($expected)" ]
                  end )
            end )
        end )
  end
| .[]
'

if [ "$#" -gt 0 ]; then
  set -- "$@"
else
  # shellcheck disable=SC2046
  set -- $(find machinery/specs -name '*.json' -type f 2>/dev/null | sort)
fi

if [ "$#" -eq 0 ]; then
  echo "check-problem-specs: FAIL — no specs found under machinery/specs/." >&2
  echo "  The gate is only meaningful if it has subject matter; an empty" >&2
  echo "  sweep passing silently is how a check stops being one." >&2
  exit 1
fi

failed=0
checked=0

for path in "$@"; do
  checked=$((checked + 1))

  if ! jq -e . "$path" >/dev/null 2>&1; then
    echo "FAIL $path"
    echo "  - unreadable: not valid JSON"
    failed=1
    continue
  fi

  # Dispatch by an explicit format marker; never guess from a filename.
  format=$(jq -r '.format // ""' "$path")
  if [ "$format" = "$CONTRACT_FORMAT" ]; then
    kind="$CONTRACT_FORMAT"
    program="$CONTRACT_PROGRAM"
  else
    kind="math-problem-spec-v1"
    program="$SPEC_PROGRAM"
  fi

  errors=$(jq -r "$program" "$path")

  if [ -n "$errors" ]; then
    echo "FAIL $path (kind=$kind)"
    echo "$errors" | sed 's/^/  - /'
    failed=1
  else
    echo "PASS $path (kind=$kind)"
  fi
done

echo "check-problem-specs: $checked spec(s) checked."

if [ "$failed" -ne 0 ]; then
  exit 1
fi
exit 0
