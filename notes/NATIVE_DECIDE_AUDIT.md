# `native_decide` in the Lean lane: exact inventory, 126 of 142 sites converted to kernel proof

**Author.** claude (Gentzen lineage), 2026-08-15.
**Substrate.** elan + Lean `4.33.0` + mathlib `v4.33.0` olean cache, in-container,
warm from the same night's `LEAN_LANE_AUDIT` work. Every number below is a
build verdict or an `#print axioms`-equivalent environment scan, not a grep.

---

## 0. Verdict

| question | before | after |
|---|---|---|
| `native_decide` tactic sites (excl. 1 docstring mention) | **142** in 39 modules | **16** in 5 modules |
| named `theorem`s whose axiom set contains a `native_decide` axiom | **113** | **8** |
| `def`s whose axiom set contains a `native_decide` axiom | **26** | **0** |
| modules containing at least one tainted declaration | **28** | **4** |
| `sorry` / `admit` / `axiom` | 0 | 0 |

**126 sites converted**, of which 123 to plain kernel `decide` and 3 to a
`simp`-with-`padicValNat`-lemmas proof (§3). Every touched module was rebuilt;
the whole buildable tree (`Build completed successfully (8831 jobs)`) is green
after the change, excluding the 5 modules already broken at HEAD.

---

## 1. Correcting the inherited count

`notes/LEAN_LANE_AUDIT.md` §3 reported "**72 distinct named theorems** are
proved by `native_decide`", flagging in its own §6 that the figure was a
*syntactic* attribution (nearest preceding declaration keyword). It is wrong in
both directions, and the direction that matters is the undercount.

The exact figure is obtained by scanning the environment rather than the text:
import every buildable module, walk `env.constants`, and call
`Lean.collectAxioms` on each `Pairfield.*` theorem and def, keeping those whose
axiom set contains a name matching `native_decide`. That is the same function
`#print axioms` calls, applied to all 8831 jobs' worth of environment at once.

Result before any edit: **113 theorems and 26 defs, in 28 modules.**

The undercount (72 → 113) is not a counting slip; it is **taint propagation**.
Two of the 28 tainted modules — `AdaptiveResidualCycleDeletion` (3 theorems)
and `AdaptiveResidualPositionCycleAdapter` (2) — contain **zero** occurrences
of `native_decide`. They import a module that does. A theorem does not have to
mention the oracle to stand on it. Any purely syntactic audit of an unsound
escape hatch will miss exactly this, and this is the general lesson: *grep
counts sites; only the kernel counts dependencies.*

The scan file is reproducible; it is 12 lines of `run_cmd` over
`Lean.collectAxioms` and is reproduced in §6.

---

## 2. What converted, and why so much of it did

Method: per module, replace every `native_decide` tactic token (excluding the
one inside backticks in `RankOneWitness.lean`'s docstring) with `decide`, then
`lake build` that module. On failure, read the reported failing lines, restore
only those, and rebuild — iterating until green.

**30 of 39 modules converted in full, at the first attempt**, including every
one of the large ones: `EuclidCoefficientForkNoGo` (11 sites),
`AdaptiveConstantResponseSteering` (10), `EuclidCoefficientTrace` (9),
`EuclidDoublingFork` (8), `ReachableAdaptiveObservableHorizon` (8),
`NativeIndexedPolicyBoundary` (5), `AdaptiveResidualSplitting` (5),
`AdaptiveObservableHorizon` (5), `AdaptiveResidualAnnotatedSplit` (5),
`EuclidCoefficientCutBound` (4), `AdaptiveResidualAdapter` (4),
`VisitedReach` (4), `ResidualObservableHorizon` (4), and 17 smaller ones.

3 more converted in part: `DiagonalSmithRoute` (5 of 10),
`NativeIndexedReverseTraversal` (4 of 7), `NativeReverseEdgeInventory` (1 of 3).

The honest reading of that ratio is the one the task anticipated: **the
overwhelming majority of `native_decide` in this lane was habit.** The proofs
were finite checks that the kernel reduces without complaint, some in
milliseconds; nothing was gained by routing them through the compiler, and 139
of the 143 generated axioms bought nothing at all.

Two caveats on the method, stated because they bound the claim:

- Sites inside `example` blocks and `def` bodies were converted on the same
  terms. `example`s emit no reachable axiom, so converting them changes no
  dependency; it is hygiene, not correction.
- Conversion cost is compile time. Modules that were seconds are still
  seconds; I did not observe any module cross a minute that had not before.
  A slow-but-kernel proof is the intended trade and it did not bite here.

---

## 3. `TernaryCancellationFormation`: the one that needed mathematics

Its three theorems (`pairwise_ledger_collision`,
`deep_ternary_residual_eq_one`, `shallow_ternary_residual_eq_zero`) are about
`padicValNat 5` of the triples `⟨1,1,3⟩` and `⟨1,1,1⟩`. `decide` gets stuck:
`padicValNat` is not kernel-reducible.

But the content is five facts — `padicValNat 5 n = 0` for `n ∈ {1,2,3,4}` and
`padicValNat 5 5 = 1` — each one mathlib lemma wide. Replacing the oracle with

```lean
simp [pairwiseLedger, cancellationResidual, deepTriple, shallowTriple,
  padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 2 by decide),
  padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 3 by decide),
  padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 4 by decide)]
```

and the two analogous one-liners builds clean. The module now has **zero**
`native_decide`. This is CLAUDE.md's rule in miniature: the derivable statement
behind the measurement existed and was shorter than the measurement.

---

## 4. The honest residue: 16 sites, 8 theorems, 5 modules

These are the sites where kernel reduction genuinely does not work. Each is
recorded with the *observed* reason, not a guess.

### 4a. `Finset.sort` is not kernel-reducible — 6 sites, 6 theorems

`NativeReversePairTraversal:215`, `NativeReverseEdgeInventory:165,171`,
`NativeIndexedReverseTraversal:1262,1267,1304`.

All six route through `NativeReversePairTraversal.pairList`, which is
`(Finset.univ : Finset X).sort (· ≤ ·)` flat-mapped with itself. `decide`
reports "reduction got stuck at the `Decidable` instance". `decide +kernel`
(which bypasses the elaborator's `whnf` and hands the term straight to the
kernel) fails identically, so this is not an elaborator-reducibility setting.

Minimised, against bare mathlib, three lines, all three failing the same way:

```lean
example : ((Finset.univ : Finset (Fin 3)).sort (· ≤ ·)).length = 3 := by decide
example : (List.mergeSort [3,1,2] (· ≤ ·)).length = 3 := by decide
example : ((Finset.univ : Finset (Fin 3)).val.toList).length = 3 := by decide
```

`Finset.sort` is `Multiset.sort`, which is `List.mergeSort`, which is defined
by well-founded recursion; its unfolding goes through `WellFounded.fix`, and
the kernel cannot iota-reduce `Acc.rec` on an opaque accessibility proof. The
obstruction is therefore a **property of the definition, not of the search
space** — the search space here is 9 pairs and 22 edges. No amount of patience
converts these.

The remedy, if anyone wants it, is to replace `pairList`'s use of `Finset.sort`
with a structurally-recursive enumeration (`List.finRange`-style), which would
convert all six at a stroke. That is a real refactor of
`NativeReversePairTraversal`, not an audit action, so I did not do it. **This
is the single highest-value follow-up in this note.**

### 4b. `DiagonalSmithRoute` — 5 sites, 2 theorems

Lines 292, 393, 399, 511, 513. Tainted theorems:
`kuttaka610Transcript_replays_compact_certificate`,
`kuttaka610Transcript_actionCost_minimal`.

Same failure mode ("did not reduce to `isTrue` or `isFalse`"), stuck at
projections out of `ComputableSmith2x2.reduceDiagonal
(positiveDiagonalCoprimeFactors 6 10 _)`. `reduceDiagonal` is a tactic-mode
definition returning a dependent `Certificate`; kernel reduction stalls on
`(…).L.a11` and `(…).R.a12`. **I did not isolate which sub-definition is the
blocker** — it is plausibly `Nat.gcd`/`xgcd`-shaped, but I did not confirm it,
and I decline to state a cause I did not observe. What is confirmed is the
failure and its shape: an unreducible definition, again not a size problem.

### 4c. `ChartQuotient:238` — 1 site, 0 theorems, a measured timeout

```lean
example : Fintype.card (Quotient (dfaFutureSetoid automaton)) = 3 := by decide
```

This is the one genuine *cost* case rather than a reducibility case. With
`set_option maxRecDepth 100000` and `set_option maxHeartbeats 4000000` the
build ran **over 20 minutes without terminating** and was killed; at default
heartbeats it fails with "(deterministic) timeout at `whnf`, maximum number of
heartbeats (200000)". Deciding a `Fintype.card` of a quotient by a
behavioural setoid materialises the quotient's `Fintype` instance, and that is
where it goes. It is an `example`, so no named theorem depends on it and no
axiom is reachable from anything; it is left as-is and flagged.

### 4d. `EuclidDoublingForkMinimal` — 4 sites, untested

Lines 112, 162, 166, 175. **This module does not compile at HEAD**
(`LEAN_LANE_AUDIT` §2b: three `failed to synthesize` errors at `:63,:98,:149`),
so no conversion can be attempted and no theorem in it exists to be tainted.
Recorded here so the site count reconciles; it is a pre-existing defect owned
by that audit's item 2, not by this one.

---

## 5. Recommendation: what the Lean equivalent of `--safe` would be

Recommended, **not imposed** — this is a lane discipline and the human owner
and the lane's authors should decide it, not a passing auditor.

The Agda lane's `--safe` is a *compiler flag*: it is checked by the thing that
produces the artifact, so it cannot be forgotten. Lean has no single such flag.
The closest faithful equivalent is a two-part gate:

1. **Per-module opt-in, not silence.** A module that needs a compiler-trusting
   step declares it in its header, e.g. a comment convention
   `-- TRUSTS-COMPILER: native_decide (see notes/NATIVE_DECIDE_AUDIT.md §4a)`.
   Cost: one line per exceptional module, currently 5.
2. **A post-build axiom gate.** The environment scan of §6, run as a `lake exe`
   or a CI step, listing every `Pairfield.*` theorem whose `collectAxioms` set
   is not a subset of `{propext, Classical.choice, Quot.sound}`, and failing if
   that list differs from a checked-in allowlist. This is strictly stronger
   than grepping for `native_decide`: it catches taint propagation (§1), and it
   would catch `axiom`, `sorryAx`, and any future escape hatch without being
   taught their names.

Cost, honestly stated: the gate costs one full `lake build` plus one
whole-environment import (here: ~1 minute of scan on top of a warm build, tens
of minutes cold). It cannot run today, because **the lane does not build** —
`HeadDepthBlindnessAdapter` and three orphans fail — so item 2 of
`LEAN_LANE_AUDIT` §5 is a hard prerequisite. A gate over a red build is
theatre. Recommend in this order: fix the 4 broken modules → `globs =
["Pairfield.+"]` → axiom gate with a 4-module allowlist → header convention.

---

## 6. Reproduction

Given a built tree, with `ALLMODS` the list of buildable modules:

```lean
-- one `import` line per module of ALLMODS, then:
open Lean in
run_cmd do
  let env ← Lean.getEnv
  for (n, ci) in env.constants.toList do
    if n.isInternal then continue
    unless (`Pairfield).isPrefixOf n do continue
    let kind := match ci with | .thmInfo _ => "THM" | .defnInfo _ => "DEF" | _ => ""
    if kind == "" then continue
    let axs ← Lean.collectAxioms n
    let bad := axs.filter (fun a => (a.toString.splitOn "native_decide").length > 1)
    if !bad.isEmpty then
      Lean.logInfo s!"{kind}\t{n}\t{bad.size}\t{env.getModuleFor? n |>.getD `none}"
```

`lake env lean Scan.lean`. Present output: 8 `THM` lines, listed in §4.

---

## 7. Scope limits

- I audited `native_decide` and nothing else. `decide` sites (299 bare-token
  occurrences under `Pairfield/` after this change, up from 151 tactic sites
  recorded by `LEAN_LANE_AUDIT`; the two counts are not measured the same way
  and should not be subtracted) are kernel-checked and were not reviewed for
  whether their *statements* say what the surrounding prose claims. That sweep
  is `LEAN_LANE_AUDIT` §6's open item and remains open.
- The 5 broken modules at HEAD (`HeadDepthBlindnessAdapter`, `CapabilityGraph`,
  `HolonomyDescent`, `ArbitrarySmithClosure`, `EuclidDoublingForkMinimal`) were
  excluded from every build and every scan. Two of them were being edited by
  another agent in this worktree while I worked; I did not touch them.
- The taint scan covers the `Pairfield.*` namespace. A `native_decide` axiom
  reachable only through a mathlib-namespaced declaration would be missed;
  none exists, since mathlib is a fixed pinned revision, but the scan does not
  prove that.
- §4b's cause is not isolated, by explicit choice. §4c's 20-minute figure is a
  wall-clock observation in this container, not a bound.
