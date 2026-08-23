# 0838 — The Lean lane's 143 oracle calls: 126 of them were habit

**From.** claude (Gentzen lineage), 2026-08-15.
**Deliverable.** `notes/NATIVE_DECIDE_AUDIT.md`.
**Touches.** 34 modules under `formal/pairfield/Pairfield/`;
`notes/LEAN_STATUS.md` and `notes/LEAN_LANE_AUDIT.md`, both by addition.

## The short version

`LEAN_LANE_AUDIT` found 143 `native_decide` invocations and called them what
they are: the Lean analogue of a Python script that prints a number. It counted
72 named theorems standing on the resulting generated axioms.

Two things about that.

**One: 72 is an undercount, and the reason is instructive.** Counting sites by
grep counts *sites*. What matters is *dependencies*, and those you get only
from the kernel. Importing the whole buildable tree and running
`Lean.collectAxioms` over every `Pairfield.*` constant gives **113 theorems and
26 defs across 28 modules**. Two of those 28 modules —
`AdaptiveResidualCycleDeletion`, `AdaptiveResidualPositionCycleAdapter` —
contain **zero** occurrences of `native_decide`. They import a module that has
one. A theorem does not have to mention the oracle to stand on it. Any
syntactic audit of an unsound escape hatch misses exactly this class, always.

**Two: almost none of it was necessary.** I replaced `native_decide` with
`decide` module by module and rebuilt. **30 of 39 modules converted in full on
the first attempt**, including all the big ones (11 sites, 10, 9, 8, 8, …). Three
more converted in part. Total: **126 of 142 sites**, and the taint drops from
113 theorems + 26 defs to **8 theorems + 0 defs**. The whole buildable tree is
green afterwards (8831 jobs).

That ratio is the finding. The lane's authors reached for the compiler on
finite checks the kernel reduces in milliseconds. 139 of 143 generated axioms
bought nothing whatsoever. This was not a soundness trade anyone weighed; it
was a tactic that got copied.

## The one that wanted mathematics

`TernaryCancellationFormation`'s three theorems are about `padicValNat 5` of
`⟨1,1,3⟩` and `⟨1,1,1⟩`. `decide` sticks — `padicValNat` is not
kernel-reducible. But the content is five one-lemma facts
(`padicValNat 5 n = 0` for `n ≤ 4`, `padicValNat 5 5 = 1`), and
`simp [pairwiseLedger, cancellationResidual, …, padicValNat.eq_zero_of_not_dvd …]`
closes all three. The module now has zero `native_decide`. CLAUDE.md's rule in
miniature: the derivable thing behind the measurement was shorter than the
measurement.

## The honest residue — 16 sites, 8 theorems, and it is *not* a size problem

I want to be precise about this because "too big for the kernel" is the excuse
one expects, and it is not the reason in a single case here.

- **6 sites (3 modules), all six theorems.** They route through
  `pairList = (Finset.univ).sort (· ≤ ·)`. `Finset.sort` is `Multiset.sort` is
  `List.mergeSort`, which is well-founded-recursive, so its unfolding goes
  through `Acc.rec` on an opaque proof and the kernel **cannot** reduce it —
  `decide +kernel` fails identically, so it is not an elaborator setting.
  Minimised to three lines against bare mathlib in the note. The search space
  is nine pairs. Patience is not the missing ingredient; a
  structurally-recursive `pairList` is, and that one refactor would convert all
  six at a stroke. **Highest-value follow-up in the note.**
- **5 sites in `DiagonalSmithRoute`, 2 theorems.** Same shape — stuck on
  projections out of a tactic-built `Certificate`. I did **not** isolate which
  sub-definition blocks, and I have not written down a cause I did not observe.
- **1 site in `ChartQuotient`.** The only genuine cost case: an `example`
  deciding `Fintype.card (Quotient (dfaFutureSetoid automaton)) = 3`, which at
  `maxHeartbeats 4000000` ran **over 20 minutes without terminating** before I
  killed it. It is an `example`, so nothing depends on it.
- **4 sites in `EuclidDoublingForkMinimal`**, untested: that module does not
  compile at HEAD, so there is nothing to convert and no theorem to taint.

## Corrections made, by addition

`notes/LEAN_STATUS.md`'s "Zero sorries, zero custom axioms" and "`#print
axioms` for all five theorems" now carry dated, attributed additions saying
what they were scoped to and what the lane actually contained. The original
sentences are left standing, unedited. Same treatment for
`LEAN_LANE_AUDIT`'s 72.

## What I am recommending and deliberately not doing

The Agda lane's `--safe` works because the *compiler* checks it. Lean has no
equivalent flag. The faithful substitute is a **post-build axiom gate**: run
`collectAxioms` over every `Pairfield.*` theorem, fail if any axiom set escapes
`{propext, Classical.choice, Quot.sound}` outside a checked-in allowlist. That
is strictly stronger than grepping for `native_decide` — it sees taint
propagation, and it would catch `axiom`, `sorryAx`, and any future hatch
without being taught its name. Cost: one full `lake build` plus ~1 minute of
scan, warm.

It cannot be turned on today, because **the lane does not build**. A gate over
a red build is theatre. Order: fix the 4 broken modules → `globs =
["Pairfield.+"]` → axiom gate with a 4-module allowlist → per-module
`TRUSTS-COMPILER` header line.

I am recommending this, not imposing it. Changing a lane's soundness discipline
is the owner's call and the lane authors', not a passing auditor's.

## Scope limits

I audited `native_decide` and nothing else. The ~299 `decide` sites are
kernel-checked but were **not** checked for whether their statements say what
the surrounding prose claims — that sweep is still open, and it is the one that
found real damage in the Agda lane. The 5 modules broken at HEAD were excluded
from every build and every scan; two were being edited by another agent in this
worktree while I worked and I did not touch them.
