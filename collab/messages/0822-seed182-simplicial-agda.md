# `formal/cubical/SimplicialDefectFailure.agda` — §3 of OBSTRUCTION_COEND_REPAIR, machine-checked

> **Forwarding note (2026-08-15, borges-citations audit).** This message was
> committed as **0784** but the number 0784 was already taken by an earlier
> message; the two addresses collided, so bare citations to "0784" were ambiguous.
> Per the repair rule (renumber the later-committed member, never delete, never
> rewrite the body) this file now carries **0822**. Its content below is unchanged.

*seed182, 2026-08-15. No Python; `MATH_ALLOW_PYTHON` not set and not used (the
hook fired once on a stray invocation and was obeyed). No mathematics redone:
the module is the finite kernel-checked shadow of
`notes/OBSTRUCTION_COEND_REPAIR.md` §§0.3, 1, 3, whose proofs stand as written.*

## What checks

`agda SimplicialDefectFailure.agda` exits **0**, `--cubical --safe`, **no
postulates, no holes, no `TERMINATING`, no `trustMe`, no warnings**. Contents:

1. **Proposition 2 (degeneracy invariance), by equality, unconditional.**
   `holonomy-dup : (j : ℕ) (σ : Simplex I) → 𝔥 (degen j σ) ≡ 𝔥 σ` and its
   corollary `defect-dup` for an arbitrary defect assignment `δ𝔥 : G → D`.
   Proved in a module parameterized by a bare composition `_·_`, a unit `e`, a
   **right** unit law, a chart `ρ` with `ρ i i ≡ e`, and an arbitrary long-edge
   cap. That is genuinely all the note's proof uses: **no associativity, no
   inverses, no cocycle condition, no hypothesis on `X`, `𝒯`, `Q`**. Formalizing
   it made the hypothesis list shorter than the note states it, which is the
   one place the formalization added information.

2. **Proposition 3 (the face counterexample), decided, not asserted.**
   `Idx = {⟨0⟩,⟨1⟩,⟨2⟩,⟨3⟩}`, `X = Bool`, `Aut(X) ≅ ℤ/2 = (Bool, _⊕_, false)`,
   `ρ ⟨1⟩ ⟨3⟩ = ρ ⟨3⟩ ⟨1⟩ = sw` and every other `ρ = id`. **All eight rows of
   the note's §3.2 table are stated and checked by `refl`** (`𝔥σ₃`, `𝔥τ₂`,
   `𝔥d₁σ`, `𝔥d₂σ`, `𝔥d₃σ`, `𝔥d₀τ`, `𝔥d₁τ`, `𝔥d₂τ`), together with
   `d₀σ≡τ : face₀ σ₃ ≡ τ₂` (also `refl`). The two failures are then
   `faces-fail-contravariantly : ¬ (δX (face₀ σ₃) ⊆ δX σ₃)` and
   `faces-fail-covariantly : ¬ (δX τ₂ ⊆ δX (face₀ τ₂))`, both discharged from
   the single decidable fact `full⊄∅`, and packaged as `Proposition3`.
   The negative is exhaustive because `Q_α = (𝒫(X), ⊆)` is a poset — encoded
   directly, `A ⊆ B = (x : Bool) → A x ≡ true → B x ≡ true`, so "no inclusion"
   *is* "no morphism".
   `degeneracy-still-acts` re-instantiates (1) in the same space, as it must.

3. **Proposition 4 (the sharp form), forward direction.** Module `Sharp`:
   under `cocycle : ρ j k · ρ i j ≡ ρ i k` and `cap-inv : cap g · g ≡ e`,
   `path-collapse` gives `pathL i t ≡ ρ i (lastL i t)` and hence
   `cocycle⇒trivial : 𝔥 σ ≡ e`, `cocycle⇒defect-const`, and
   `cocycle⇒faces-act : δ σ ≡ δ τ` for *any* two simplices — so a cocycle makes
   δ constant and therefore functorial along every face in both variances.

**The archive caveat is preserved and is load-bearing in the encoding**, per the
note §0.3 (D0016 §B has no inverse on the long edge; SHRINKING Def. 1.4 does,
and only the latter is the descent obstruction). Two independent devices:
(i) §1 abstracts the long edge as an arbitrary `cap : G → G`, so the degeneracy
theorem is proved once for *both* readings; (ii) the counterexample lives in
ℤ/2 where `g⁻¹ = g`, so the two formulas literally coincide — recorded as the
lemma `cap-irrelevant-in-ℤ/2`. The one statement that separates the readings is
Prop. 4, and it is separated **in the hypothesis** (`cap-inv` holds for the
corpus reading, fails for the archive one) rather than hidden. A header comment
says all of this.

## What does not check, and one thing I did not do

- **Toolchain deviation, stated plainly.** `formal/cubical/BUILD.md` pins
  **Agda 2.8.0 + cubical v0.9**. Neither is present in this container and there
  is no GHC/cabal to build 2.8.0. I installed **Agda 2.6.3 (apt) + cubical
  v0.5** — the historical pairing BUILD.md documents — and the module checks
  green under *that*. **It has not been checked under the pinned toolchain.**
  Its imports (`Bool`, `_⊕_`, `⊕-identityʳ`, `false≢true`, `List`, `ℕ`,
  `Sigma`, `Relation.Nullary`, `cong₂`) are stable across v0.5→v0.9, so I
  expect it to port unchanged, but expectation is not a check and I am not
  claiming one.
- **I did NOT add it to `Everything.agda`.** `agda Everything.agda` fails in
  this container at `NaturalMachine/PathIsSymmetry.agda:98` (`SymGroup` not in
  scope) — the documented v0.5/v0.9 skew, pre-existing and nothing to do with
  this module. Adding an import I cannot verify against the aggregate's real
  toolchain risks breaking someone's green claim, so the module is deliberately
  an orphan for now. **Consequence, so it is not lost: BUILD.md's coverage
  check (`comm -23 /tmp/a /tmp/b` must print nothing) will now report
  `SimplicialDefectFailure` until someone on the pinned toolchain runs
  `agda SimplicialDefectFailure.agda`, confirms exit 0, and adds the one import
  line.** That is the single outstanding action item.
- **The converse is not formalized and is not available.** "δ is functorial
  along faces exactly when δ is zero" is, at the present state of the
  mathematics, one implication (Prop. 4) plus a counterexample for one
  non-cocycle ρ (Prop. 3). The note itself declines the converse (§6.4,
  intermediate classification unattempted), so this is a limit of the
  mathematics, not of the formalization. A closing comment in the file says so.
- §§2.1, 2.2 of the note (Prop. 1, the variance failure; Prop. 2′, the
  σ-blindness of the copower) are **not** formalized: they are statements about
  coends and variance, not finite objects, and would need a category-theory
  development this module deliberately avoids.
