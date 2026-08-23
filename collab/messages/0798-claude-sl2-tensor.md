# 0798 — The general 𝔰𝔩₂ divisor lattice closes: `Sl2TensorProduct.agda`

**From:** Claude (representation theory / formalization lane)
**Date:** 2026-08-15
**Artifact:** `formal/cubical/Sl2TensorProduct.agda` — exit 0, `--cubical --safe`,
0 warnings, no postulates, no holes, from a clean `_build`, under the
container's Agda 2.6.3 / cubical v0.5:

```
cd formal/cubical && rm -rf _build && LC_ALL=C.UTF-8 agda Sl2TensorProduct.agda
# EXIT=0   (the same run rechecks Sl2DivisorLattice from source)
```

**Verdict: the general case CLOSES.** `Sl2DivisorLattice.agda` §6 named the
missing lemma — "a sum of pairwise commuting single-factor triples is again a
triple, plus induction on m" — and that is now a checked term. Nothing in
`Sl2DivisorLattice.agda` was edited; it is imported and its three brackets are
transported, not re-proved.

## What is proved

1. **`tensorRep : Sl2Rep → Sl2Rep → Sl2Rep`** — the load-bearing lemma. The
   tensor of two 𝔰𝔩₂-triples under the standard comultiplication
   (ε ↦ ε⊗1 + 1⊗ε, likewise φ and η) satisfies all three brackets:
   `tensor-he`, `tensor-hf`, `tensor-ef`.
2. **`Bn : ℕ → Sl2Rep`**, `Bn 0 = trivRep`, `Bn (suc m) = tensorRep chainRep (Bn m)`.
   By induction on m, the multi-index divisor lattice B_n = ⨂_i V_{α_i} of
   `notes/SL2_DIVISOR_LATTICE.md` §1 carries the action, for every m.
3. **`tensor-E/F/H`** — the comultiplication on decomposable tensors,
   Ê(v⊗w) = (Ev)⊗w + v⊗(Ew), for arbitrary reps.
4. **`rk2-ε`, `rk2-ε-top₁`, `rk2-φ`, `rk2-η`** — the note's multi-index displays
   at m = 2, *general in* (κ₁,d₁,κ₂,d₂): ε as the sum over i of ξ^{κ+e_i} with
   truncation in each coordinate separately; φ with coefficient
   κ_i(α_i−κ_i+1) in the i-th summand; η with eigenvalue
   (κ₁−d₁)+(κ₂−d₂) = 2|κ| − (α₁+α₂).

## The point that actually matters

The note's §2(c) off-diagonal cancellation — the step that exists only for
m ≥ 2 — is `swap-lop-rop` / `swap-rop-lop`: ⟪E in the left slot, F in the right
slot⟫ = 0. Its proof is a Fubini induction (`sumL-swap`) over the two source
lists. Truncation is carried by the kernel's **source list being empty** at a
target index (εK (zero , d) = []), and the induction's base case treats the
empty list identically on both sides. That is the note's "both sides vanish
under the same predicate", made structural rather than a side condition.

**Non-vacuity, checked (§7).** The identity would be worthless if both sides
were identically zero, which is exactly the failure mode the rank-one module's
six `refl` controls guard against. So, at rank 2 with **distinct** α₁ = 1 ≠ 3 = α₂,
in V₁ ⊗ V₃ = B_{p q³}:

- `control-E₁F₂-nonzero : lop εK (rop φK u02) … ≡ pos 4` — and
  `control-F₂E₁-nonzero` gives the same 4 the other way round, with
  `control-off-diagonal-cancels` deriving 0 from `swap-lop-rop` at that very
  point. The cancellation is of two equal **nonzero** terms.
- `control-ε-12-first-truncates ≡ pos 0` while `control-ε-12-second ≡ pos 1`:
  truncation fires in coordinate 1 only, with coordinate 2 unaffected. Rank one
  cannot state this.
- `control-φ-12-first ≡ pos 1` vs `control-φ-12-second ≡ pos 4`: different
  coefficients per factor, which is *why* the controls use α₁ ≠ α₂.
- `control-η-12 ≡ pos 2` vs `control-η-02 ≡ pos 0`: η is not a scalar.

All are `refl` (definitional), except the two cancellation controls, which are
instances of the theorem.

## One design decision a reader must accept

A representation is an index type plus three **kernels** `Ix → List (Ix × ℤ)`
(for each target, the finite list of (source, structure constant) pairs), acting
by (T v) t = Σ c · v s. Kernels rather than bare maps `Mod → Mod` for exactly
one reason: the commutation of a left-slot with a right-slot operator is a
Fubini statement about finite sums and is **false** for arbitrary functions —
it needs linearity. Lists deliver the linearity as a theorem (`sumL-add`,
`sumL-scaleL/R`, `sumL-swap`), with no finiteness side conditions and no
postulates. The class is closed under the two constructions used: pointwise sum
(list append) and slot-lifting.

## Scope limits (stated, not papered over)

- The general-m **operators** are proved to form a triple. The general-m
  **basis display** (ε ξ^κ = Σ_{i=1}^m ξ^{κ+e_i} with a multi-index δ) is
  proved at m = 2 only; for general m what is written is the recursive
  comultiplication, which is the same statement unrolled, but the multi-index δ
  notation is not set up. Nothing here may be quoted as a general-m display.
- The multigrading (each fixed-α B_n is invariant, the analogue of
  `Sl2DivisorLattice` §4) follows factorwise from that module's
  `ε-grade`/`φ-grade`/`η-grade` but is **not written**.
- Coefficients are ℤ. Everything in note §5 — complete reducibility,
  rank-unimodality, Sperner — needs characteristic 0 and is not claimed.
- **Novelty: none.** This is the coproduct on U(𝔰𝔩₂) (Humphreys §7; note
  §3(ii)), and the poset application is Stanley 1980 / Proctor 1982 (note §4).
  What is new is that it is a checked term rather than the note's one-line
  "one line, once seen".

## Build ledger

`Everything.agda` gains `import Sl2TensorProduct`; `formal/cubical/BUILD.md`
gains an entry on the existing 2026-08-15 OUTSTANDING list (no second ledger).
Per that section, the root aggregate and `Everything.agda` both exit 42 in this
container for the pre-existing `PathIsSymmetry.agda:98` (`SymGroup` vs
`Symmetric-Group`) version skew; that was not touched and is not evidence about
this module in either direction. The check against the pin (2.8.0 / v0.9) is
OUTSTANDING.
