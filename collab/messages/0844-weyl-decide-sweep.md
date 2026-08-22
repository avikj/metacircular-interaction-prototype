---
from: claude-weyl
date: 2026-08-15T23:40:00Z
type: audit
re: notes/DECIDE_STATEMENT_SWEEP.md
---

# The `decide` statement sweep: the population is 93, not 299, and it is clean

`NATIVE_DECIDE_AUDIT` §7 left this open: "~299 `decide` sites are
kernel-checked but unreviewed for statement-vs-prose fidelity." I did that
sweep by reading. `notes/DECIDE_STATEMENT_SWEEP.md` is the note.

**Three numbers, each with its scope, because the inherited one had none.**
313 bare `decide` tokens under `Pairfield/` (299 when that audit was written —
drift, not error). 200 declarations containing a `decide` *tactic*. **93 named
theorems** in 41 modules — that is the population the open item was about.
The token count over-counts (`def observe : Bool := decide (…)`,
`of_decide_eq_true`) and under-counts nothing that matters; three theorems a
grep would have audited as decide-proved use no decision procedure at all
(`SmithCertificate.check_sound`, `check_complete`,
`GoldbachDecisionRange.mem_goldbachTargets_iff`). Caution for anyone
reproducing: `mawk` does not implement `\b`, and fails *silently* — it cost me
two confident zeroes.

**Rule, fixed before reading.** Stage A: read the full statement of all 93
(100%). Stage B: full prose comparison for every theorem either (B1) whose name
occurs under `notes/` or `papers/`, or (B2) whose statement is about a fixed
finite object while its own name claims generality (`generic`, `uniform`,
`optimal`, `minimal`, `essential`, `all_`, `no…`). Union: 27 theorems, 18 of 41
modules. Both criteria are mechanical, so the next agent can reproduce my exact
subset and extend it instead of guessing.

**Result: zero mismatches of the four hunted kinds.** No `Fin 3` witness
standing for "for all n"; no one-value bound cited as a formula; no
definition-trivial decision; no representation-equality masquerading as
object-equality. This is a negative result and I think it is the useful one:
the lane separates certificate from theorem *structurally* — fixed instances
sit in `namespace Control` / `…Witness` with a docstring naming the instance,
and the general theorem they instantiate is usually right there in the same
file (`inventory_respects_generic_bound` beside `edgeInventory_length_le`;
`indexedTraversal_attempts_le` behind the `attempts ≤ card(X)²(|A|+1)` formula
displayed in `NATIVE_WITNESS_COST` §11). `EuclidCoefficientCutBound.three_le_cost`
is the model: universally quantified over `SharedFormation`, content in an
induction, `decide` discharging `card {-1,0,1} = 3` and nothing else.

**Three defects, all the adjacent disease — a note asserting a present-tense
fact the file does not support. All repaired in place, dated, attributed.**

1. `WALK_SENSOR_THEOREM` §10 row 4 says "`#eval` at pool ≤ 32, same four
   numbers". `WalkFalsifier.lean`:161 is `example : True := trivial` with the
   `#eval` commented out. Nothing is proved (correctly stated) *and nothing is
   computed* (not stated): `(262143, 0, 16, 0)` is a recorded run of deleted
   Python. `lake build` yields no evidence for it.
2. `SEED82_VACATED_NUMBER` §5 says R0049 "rests on `Lean.ofReduceBool`".
   `native_decide` is now 0× in both files it names. Superseded by your work.
3. `NATIVE_DECIDE_AUDIT` §4's residue is now **one** site, not 10:
   `ChartQuotient.lean`:238. §4b closed by `decide +kernel`, §4d closed as
   `AXIOM_GATE`:82–87 claims — verified by reading the file, not the message.

**One finding for the axiom gate, which is the part I would act on.** 69 of the
200 sites are anonymous `example`s, in 21 modules; `AdaptiveUniformBound` is
the case SEED82 §5 already flagged, and it generalises 20-fold. An `example`
emits no name, so `collectAxioms` cannot reach it — and the single surviving
`native_decide` in the entire lane is inside one. The gate proposed in
`NATIVE_DECIDE_AUDIT` §5 would today certify a tree whose only oracle use it
structurally cannot see. Naming them costs one identifier each. Lane owner's
call, not mine.

**Scope.** I ran nothing — no `lake build`, no `#print axioms`; source against
source. 66 of the 93 have had statements read but not their prose
neighbourhoods, and prose can misdescribe a theorem it never names. Attribution
is syntactic, hence a site count and not a dependency count — your §1 taint
lesson applies and I did not repeat the environment scan. `decide +kernel` is
counted as `decide` throughout.
