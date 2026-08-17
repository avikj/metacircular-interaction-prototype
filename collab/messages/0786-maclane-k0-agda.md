# 0786 — `NaturalMachine/DecategorifiedDefect.agda`: the K₀-shadow argument of `SPLICING_DEFECT_ADJUDICATED.md` §4, as a term

**From:** Mac Lane's lane (an inequality of defects is a proved statement or nothing).
**Re:** `notes/SPLICING_DEFECT_ADJUDICATED.md` Thm 4.2 / §4.3 / Cor. 4.4.
**Substrate:** Agda only. No Python written, modified or executed; no `MATH_ALLOW_PYTHON`.

## What landed

`formal/cubical/NaturalMachine/DecategorifiedDefect.agda`.
**`agda NaturalMachine/DecategorifiedDefect.agda` exits 0**, `--cubical --safe`,
zero warnings, no postulates, no holes (Agda 2.6.3, cubical v0.5 — see the
toolchain note at the end).

The note's mathematics is done and was not redone. What is formalized is the
**information-loss structure** of §4, abstracted away from the derived
categories:

- **§1, abstract.** A defect type `D` with a distinguished `0D`, a receptacle
  `A` with `0A`, an invariant `χ : D → A` with `χ 0D ≡ 0A`. Then
  `vanishes→χ-vanishes : d ≡ 0D → χ d ≡ 0A` is one `cong` — this is the note's
  Thm 4.2(3), `δ_𝔗 ≃ 0 ⟹ ⋏ = 0`, and its triviality is the point. The converse
  is isolated as `ReflectsZero`, a *hypothesis*, and nothing in the setting
  supplies it.
- **§1, the consequence that matters.** `sound-contrapositive`
  (`χ d ≢ 0A → d ≢ 0D`) holds unconditionally; `unsound-certificate` says the
  rule *"χ d ≡ 0A, therefore the construction is sufficient"* is **refuted** by
  any element of `Unsound = Σ[ d ] (χ d ≡ 0A) × ¬ (d ≡ 0D)`. That is §4.3's
  verdict on §7's conditional, as a term rather than as prose.
- **§2, the witness.** `model-unsound : Unsound`, inhabited.
- **§3, exactly what is lost.** `kernel-char`: in the model `χ (m,n) ≡ 0 ↔ m ≡ n`.
  So the invisible objects are precisely those of vanishing Euler
  characteristic — the failure is the whole diagonal, not one accident
  (`diag-unsound` produces a witness from every `m ≠ 0`).
- **§4, the characterization asked for.** `no-witness→reflects` /
  `reflects→no-witness`: **χ reflects zero iff no witness exists**, the first
  direction under ¬¬-stability of the zero-test, which the model satisfies
  (`stableRank`, from `discreteRank`). So §2's witness is not merely evidence
  against reflection; it is equivalent to its failure.

## Scope limit, stated because it is the one that could be overclaimed

**The finite model is a model.** The note's §4.3 witness is
`cofib(0) = k ⊕ k[1] ≄ 0` in `D^b(Vect_k)` with `χ(k ⊕ k[1]) = 1 − 1 = 0`
(verified against the note before modelling: §4.3 lines 270–276, with
`ω₀₂^साक्षात = ω₀₂^सन्धान = k` and `α₀₁₂ = 0`, admissible under (H3)). The Agda
replaces an object of `D^b(Vect_k)` by the pair of its even/odd total ranks
(`Rank = ℕ × ℕ`), `K₀ ≅ ℤ` by the honest difference `pos m - pos n`, and
`k ⊕ k[1]` by `(1 , 1)`. Under that replacement the witness is reproduced
exactly: `χℤ (1,1) ≡ pos 0` by `refl`, `(1,1) ≢ (0,0)` by `snotz ∘ cong fst`.

**Not formalized, and not claimed:** stable ∞-categories, cofibre sequences,
`K₀` of a triangulated category, or the fact that `D^b(Vect_k)` *realizes*
`(1,1)` as a cofibre. That last is the note's §4.3, done with pen, and is
quoted here, not re-proved. Nothing in the module depends on the
derived-category reading; the module's own claims are about the abstract shape,
and the finite model exists only to show the shape is **inhabited** — i.e. that
`Unsound` is a theorem and not a hypothesis. The header of the file says this in
the same words, so a reader of the source cannot miss it.

Also untouched, deliberately: (H), (R-coend)/(R-fixed), Prop. 1.1's variable
capture, Prop. 3.1/3.2 (both are readings of the *archive*, not formalizable
without a definition of `ω_ij`, which §3.4 shows does not exist), and Cor. 4.4's
regression verdict. §6 of the note remains the scope statement of record.

## Aggregate

Folded into the root: `NaturalMachine.agda` now carries
`import NaturalMachine.DecategorifiedDefect` with a one-paragraph gloss, per
`BUILD.md` ("an orphan that the root does not import is exactly the hole that
let the earlier overstatement hide").

**But I must report plainly that `agda NaturalMachine.agda` does NOT exit 0 in
this container, and this is pre-existing and unrelated to my module.** It fails
at `NaturalMachine/PathIsSymmetry.agda:98` with `Not in scope: SymGroup`.
`SymGroup` is the **cubical v0.9** name; this container has **cubical v0.5**,
where it is `Symmetric-Group` (`BUILD.md` §"Version-skew notes" records exactly
this rename, in the other direction). `PathIsSymmetry.agda` is untouched by me.
So the tree in the repository is the v0.9 source and the installed toolchain is
the v0.5 pair (Agda 2.6.3) — the prompt's "Agda 2.6.3 + pinned cubical library"
and BUILD.md's "Agda 2.8.0 / cubical v0.9" are not the same pinning, and the
root aggregate cannot be green under the one that is installed.

Consequences, stated so nobody quotes more than is true:

- **The claim I make is exactly:** `DecategorifiedDefect.agda` checks, exit 0,
  under Agda 2.6.3 + cubical v0.5, standing alone. It imports only
  `Cubical.Foundations.Prelude`, `Data.Nat`, `Data.Int`, `Data.Sigma`,
  `Data.Empty`, `Relation.Nullary` — no repository module — so its exit code is
  independent of the skew.
- **I do not claim the root is green**, here or after my edit. It was not green
  before my edit either, for the same reason, and I verified that by reading:
  the failing line is in a file I did not modify.
- The import line is nevertheless the right landing (BUILD.md's rule), and it
  will be covered by the root's exit 0 on whichever container carries the
  matching library version.

A second session is concurrently editing `formal/cubical/NaturalMachine/RepairTorsor.agda`
in this worktree; I staged only my own two files and left theirs alone.

## Ledger

| Claim | Status |
|---|---|
| `DecategorifiedDefect.agda` typechecks, `--safe`, 0 warnings, no postulates/holes | **Verified**, exit 0 |
| §4's one-directional implication, abstractly | **Term** (`vanishes→χ-vanishes`) |
| Its converse needs χ injective-at-zero | **Term** (`ReflectsZero`, `reflects→converse`) |
| §7's sufficiency certificate is unsound | **Term** (`unsound-certificate`, `model-certificate-unsound`) |
| Its contrapositive is sound | **Term** (`sound-contrapositive`) |
| A witness exists | **Term** (`model-unsound`), *in the finite model* |
| The witness is the note's `k ⊕ k[1]` | **Modelled, not proved** — see scope limit |
| χ reflects zero iff no witness | **Term** (`Characterization`, under ¬¬-stability; discharged in the model) |
| The loss is exactly the vanishing-χ locus | **Term** (`kernel-char`) |
| `agda NaturalMachine.agda` exits 0 here | **False**, pre-existing v0.9/v0.5 skew at `PathIsSymmetry.agda:98` |
