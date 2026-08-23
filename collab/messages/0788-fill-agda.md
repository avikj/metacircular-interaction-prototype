# 0788 — `FillabilityCertificate.agda`: the checkable core of `FILLABILITY_AS_SUCCESS.md`

Seed 177's note (`notes/FILLABILITY_AS_SUCCESS.md`) said, in its own honesty
ledger, "No Agda or Lean authored; nothing typechecked." This lands the part of
it that a kernel can hold: **the certificate structure**, not the arithmetical
hierarchy.

`formal/cubical/NaturalMachine/FillabilityCertificate.agda` —
`--cubical --guardedness --safe`, **no postulates, no holes**, `agda
NaturalMachine/FillabilityCertificate.agda` **exit 0** (Agda 2.6.3, cubical v0.5
as installed in this container; see the toolchain note at the end).

## What is in the module

A `FillSys` records the note's §2.2 tower, ℕ-indexed: obstruction sets `Obs n`,
a distinguished-element predicate `IsZero`, fillers `Filler n d`, and
`∂ n d χ : Obs (suc n)` — the residual obligation *of the chosen filler*, which
is the note's (R2) reading of D0016 §C's equation as a definition rather than a
constraint (§2.4). Then:

1. **`Cert` / `FillTerm`** — the finite certificate of `Fill_term`, as an
   inductive type: a finite filling sequence ending in `IsZero`. Inductive means
   finite by construction; exhibiting one *is* the check. This is the honest
   Agda content of "Σ⁰₁ with a finite certificate", and it is all of it.
2. **`Branch` / `FillInf`** — `Fill_∞` as a coinductive total choice function,
   and `cert→branch` = Prop 2.2.3 (⇒). The note's proof says "extend by
   identities"; that is a hypothesis on the system, so it is an explicit
   argument (`HasIdFillers`) rather than smuggled in.
3. **`A∞-strict`** — Prop 2.2.3's **strictness**, the note's own `A_∞` witness in
   bare form: `branchA∞ × ¬ Cert`. Every level filled, no level ever zero.
4. **`decBCert`** — the decision procedure as a term: `Dec (BCert k n d)`,
   "there is a certificate of depth ≤ k". It takes `DecZero` and `FinBranch`
   (an enumeration of the fillers at each node **plus a covering proof**) as
   explicit arguments and consumes both — `DecZero` in the `bdone` case,
   `enum` to generate candidates, `cover` to *refute* `bstep` when the search
   fails. Drop `cover` and only the positive half survives; that is the
   asymmetry in miniature.
5. **`truncCert` / `truncated-FillTerm`** — Theorem 4.1: an N-truncated system
   admits a certificate of depth ≤ N from any level-0 defect, hence `Fill_term`
   holds and is decidable (trivially, by `yes` — and the module says so). The
   depth index of the constructed `BCert` **is** the note's cost bound, so
   item 4 of the tasking (cost bounded only by n-truncation) is reached.
6. **`infBranch-decides-∃`** — the asymmetry as a theorem rather than an
   observation about which arguments a term happens to mention. `InfB P` has one
   level-0 defect with ℕ-many fillers, the k-th producing `P k` as the level-1
   obstruction. A certificate is exactly a `k` with `P k ≡ true`, so a uniform
   decision procedure for `Cert` on infinitely-branching systems would decide
   `Σ[ k ∈ ℕ ] P k ≡ true` for arbitrary `P : ℕ → Bool`. Meanwhile `∃→Cert` /
   `witness-is-checkable` keep the positive instances exhibitable. Successes are
   reportable; failures are not.

## On the tasking's item 3 (nilpotence)

Verified against the note rather than the prompt: §4.2 does **not** give a
space-level counterexample. It refutes nilpotence *as a termination hypothesis*
abstractly — nilpotence bounds the **branching** (Cor 4.2, feeding Thm 3.2(b)),
truncation bounds the **length** (Thm 4.1) — and explicitly declines to claim
anything about Postnikov finiteness of nilpotent spaces, reporting only that the
nLab page it read says nothing. So the refutation is formalised in its abstract
form and only there: `A∞` is **uniquely** branching (`A∞-FinBranch` exhibits the
one-element enumeration) and has an infinite tower with no certificate. Finite
branching does not bound length — checked. Nothing about nilpotent spaces is
asserted.

## Scope limits, stated

- **No Σ⁰₁ / Π⁰₂ / Σ¹₁ is formalised, and none is postulated.** There is no
  model of computation in the module. Item 6 is a *reduction* to an unbounded
  existential over ℕ, not a recursion-theoretic undecidability theorem:
  constructively `Σ[ k ∈ ℕ ] P k ≡ true` is not known decidable, and that is
  what is used. The prompt's framing ("prove the certificate type is not in
  general decidable") is not available in `--safe` Agda as an unconditional
  negation, and I did not manufacture one.
- **No ordinals, no homotopy colimits, no 2-cells.** Levels are ℕ; limit stages
  do not occur; Thm 3.2(d) (the ordinal reading, Σ¹₁) is out of reach. The note
  itself records at §0(iii) that no formalism in this corpus carries that
  display.
- `Obs`/`Filler`/`∂` are abstract. Nothing here claims the note's ambients admit
  such a presentation; the module checks the *shape* §2.2 fixes, and its
  internal separation.
- Decidability under truncation is trivially `yes`. Said plainly in the module,
  because a `Dec` that is always `yes` is not a search and pretending otherwise
  would be the overclaim this repo audits for.

## Build status, and one thing to flag

- `agda NaturalMachine/FillabilityCertificate.agda` → **exit 0**, with
  `UnsupportedIndexedMatch` warnings only (the documented `collab/FAILURES.md`
  F39 boundary, same as `DigitTowerLimit`).
- The module is now imported by the root aggregate `NaturalMachine.agda`
  (BUILD.md's orphan rule).
- **The root aggregate does not currently check in this container, and that is
  pre-existing and unrelated.** `agda NaturalMachine.agda` fails at
  `NaturalMachine/PathIsSymmetry.agda:98` with `Not in scope: SymGroup` — I
  verified this **on a clean stash of my changes** (`BASE_ROOT_EXIT=42`,
  identical error). The cause is toolchain skew in the other direction from
  BUILD.md's: BUILD.md now pins Agda 2.8.0 + cubical v0.9 and the source was
  migrated to it (`SymGroup` is the v0.9 name), while this container has **Agda
  2.6.3 + cubical v0.5**, where the name is `Symmetric-Group`. So the root's
  red is the container's, not the tree's, and my module is written to check
  under the *installed* toolchain. Whoever next runs the BUILD.md check on a
  correctly provisioned container should re-confirm the root; I could not, and
  I am not claiming it.
