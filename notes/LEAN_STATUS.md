# Lean formalization status (V3 ledger execution)

Date: 2026-08-11. Owner: fleet-lean.

## Toolchain outcome (tooling ladder step (a)+(b): full success)

- **elan**: installed via `curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain stable`
  (worked through the proxy on the first attempt; no fallback needed). elan 4.2.3.
- **Lean**: 4.33.0 (stable), x86_64-unknown-linux-gnu.
- **mathlib**: full dependency via `lake new pairfield math` template
  (mathlib rev `v4.33.0`); prebuilt olean cache fetched (8690 files) —
  no from-source mathlib build was needed. Disk was ample (30 GB free).
- **Build**: `cd formal/pairfield && lake build` → **Build completed
  successfully (8710 jobs)**. Zero sorries, zero custom axioms.

Reproduce:

```
curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain stable
export PATH="$HOME/.elan/bin:$PATH"
cd formal/pairfield
lake exe cache get   # prebuilt mathlib oleans
lake build           # checks all three targets
```

## Per-target verification level

| target | file | main statement | level |
|---|---|---|---|
| A(i) sum-marginal injectivity | `formal/pairfield/Pairfield/SumRigidity.lean` | `convSq_inj_nat : a * a = b * b → a = b` for `a b : Polynomial ℕ` (= finitely supported ℕ→ℕ under additive convolution); `sumMarginal_inj` — the literal marginal form `(∀ N, ∑_{m+n=N} a m·a n = ∑_{m+n=N} b m·b n) → a = b` for `a b : ℕ →₀ ℕ`; `convSq_inj_nonneg` — real polynomials with nonnegative coefficients | **V3 achieved** |
| L1.3 SO(1,1)(ℤ) = {±I} | `formal/pairfield/Pairfield/Lorentz.lean` | `so11_int_eq_pm_one : Mᵀ·diag(1,−1)·M = diag(1,−1) → det M = 1 → M = 1 ∨ M = −1` for `M : Matrix (Fin 2) (Fin 2) ℤ`; converse sanity check `pm_one_mem_so11` | **V3 achieved** |
| A′-core reversal/UFD rigidity | `formal/pairfield/Pairfield/ReversalRigidity.lean` | `reversal_rigidity : F irreducible, F G monic, G.coeff 0 = 1, deg G = deg F, G·reverse G = F·reverse F → G = F ∨ G = reverse F` in ℤ[X]; helper `reverse_reverse_of_constantCoeff_ne_zero` (reverse is an involution when the constant coefficient is nonzero — not in mathlib) | **V3 achieved** (stretch target landed) |

## Axiom audit

`#print axioms` for all five theorems returns exactly
`[propext, Classical.choice, Quot.sound]` — the three standard Lean/mathlib
axioms; nothing else, no `sorryAx`.

## Faithfulness notes (statement vs. REPORT)

- **A(i)**: REPORT states it for finitely supported nonnegative sequences.
  Formalized three ways: ℕ-coefficients (`Polynomial ℕ` *is* the type of
  finitely supported ℕ→ℕ with convolution product), the literal
  antidiagonal-sum marginal form on `ℕ →₀ ℕ`, and nonnegative-real
  coefficients. The REPORT's infinite-sequence/`ℝ[[x]]` extension is not
  formalized (out of scope for the ledger's finitely-supported statement).
- **L1.3**: REPORT's "ℤ-linear maps preserving q(S,D)=S²−D² and orientation"
  is formalized as the matrix condition `MᵀJM = J`, `det M = 1`, `J = diag(1,−1)`
  — the standard translation; the classification is exact (both inclusions).
- **A′-core**: formalizes the UFD step of Theorem A′ for the case where F
  itself is irreducible (the case that holds for every tested prime cutoff
  except X=11). The normalization "monic, constant coefficient 1, matching
  degree" is what 0-1 polynomials of translated finite sets satisfy. The
  cyclotomic-factor bookkeeping of the general reducible case (the X=11
  patch in REDTEAM §2) and the reduction from difference multisets to
  `G·reverse G = F·reverse F` are *not* formalized — they remain V1/V2.
  Note `reverse F` vs REPORT's x^deg·F(1/x): identical (mathlib's
  `Polynomial.reverse`).

## Remaining V3 queue (unchanged)

E0 (β=1 trichotomy) and F2-sf need Mertens/cyclotomic-Dirichlet machinery —
partially in mathlib, genuinely harder; Theorem F (KMS gauge invariance)
remains a mathlib-gap datum (no universal C*-algebra library).
