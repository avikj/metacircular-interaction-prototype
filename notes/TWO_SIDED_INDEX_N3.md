> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The two-sided index at n = 3: shape enters where n = 2 saw only the product

**Author:** cf-tessera.  **Status:** derived in full below; exhaustive
replay (pre-ban, frozen) in `machinery/two_sided_index_n3.py`; boot
claim `two-sided-index-n3` in the core.  Answers the question left open
by R0036/R0038: does the δ-defect reach the index?

## Theorem (local index)

Let `e ∈ ℤ^n` be a valuation vector, `a_ij = max(0, e_i − e_j)`,
`D = diag(p^{e_i})`, and

    K(a) = { H ∈ SL_n(ℤ_p) : p^{a_ij} | H_ij  (i ≠ j) }
         = SL_n(ℤ_p) ∩ D·GL_n(ℤ_p)·D⁻¹        (R0036's description).

Let `P̄ ⊆ SL_n(F_p)` be the zero-pattern subgroup: `H̄_ij = 0` whenever
`a_ij ≥ 1`.  Then

    [SL_n(ℤ_p) : K(a)]  =  [SL_n(F_p) : P̄] · p^{Σ_{i≠j} max(0, a_ij − 1)}.

## Proof

`K(a)` is a group as an intersection of two groups.  Fix `N > max a`.

**Counting mod `p^N`.**  Let `S` be the shape set mod `p^N` (entries
`H_ij ∈ p^{a_ij}·ℤ/p^N`), so `|S| = p^{n²N − Σ a_ij}`.  `S` is closed
under multiplication (the triangle inequality `a_ik ≤ a_ij + a_jk`
holds for valuation patterns).  Invertibility mod `p^N` is a mod-`p`
condition, and reduction `S → S mod p` has equal fibers, so with
`z = #{(i,j) : i ≠ j, a_ij ≥ 1}`:

    |S×| = |S| · |P̄_GL| / p^{n² − z},     P̄_GL := pattern ∩ GL_n(F_p).

**Determinant fibers.**  `det : S× → (ℤ/p^N)×` is surjective
(`diag(u,1,…,1) ∈ S×`) with equal fibers (translate by a preimage), so
the image `K̄` of `K(a)` in `SL_n(ℤ/p^N)` — which is exactly
`{H ∈ S× : det H = 1}` by smooth lifting (scale one column by a unit
`≡ 1 mod p^N`; valuations are preserved) — has

    |K̄| = |S×| / (p^{N−1}(p − 1)).

**Assembly.**  With `|SL_n(ℤ/p^N)| = p^{(n²−1)(N−1)}|SL_n(F_p)|` and
`|P̄_GL| = (p−1)·|P̄|` (same determinant-fiber argument inside the
pattern), the index

    [SL_n(ℤ_p) : K(a)] = |SL_n(ℤ/p^N)| / |K̄|
                       = ( |SL_n(F_p)| / |P̄| ) · p^{Σ a_ij − z},

and `Σ a_ij − z = Σ max(0, a_ij − 1)`.  ∎

## Corollary 1 (the n = 2 collapse, proved)

At `n = 2` with `a₁₂, a₂₁ ≥ 1` the pattern is the torus, and
`[SL₂(F_p) : T] · p^{a₁₂+a₂₁−2} = p(p+1)·p^{a₁₂+a₂₁−2}
= ψ(p^{a₁₂+a₂₁})`: only the **sum** enters — the two-sided index law
of the core, rederived from the general formula.

## Corollary 2 (the collapse fails at n = 3 — shape enters)

`e = (0,0,2)` and `e′ = (0,1,2)` have the same total level `p⁴`, but

    index(e)  = p²·(p²+p+1)        (line-stabilizer shape, deep lift)
    index(e′) = p·(p+1)·(p²+p+1)   (Borel shape, Iwahori-type)

— at `p = 2`: **28 ≠ 42**, both matched by exhaustive count.  No
function of the total level computes the index; the support's shape is
load-bearing.  This is the index-level face of the δ-defect: at each
prime the labeled exponents satisfy `s₁₃ ∈ {s₁₂+s₂₃, |s₁₂−s₂₃|}`, and
the chain branch (`δ` trivial) versus antichain branch (`δ` ≠ 1)
selects between shapes with different mod-p factors.

## Corollary 3 (labeled levels determine the index)

The labeled triple `(s₁₂, s₁₃, s₂₃)` of pairwise exponent sums
recovers the valuation pattern up to permutation and the global sign
`e ↦ −e` (transpose-inverse), both of which preserve the index.  So at
`n = 3` the pairwise **labeled** levels determine the index — what is
lost against `n = 2` is only the reduction to their product.

## Corollary 4 (the δ-witness, globally)

`D = diag(6,10,15)`: at each of `p = 2, 3, 5` the local shape is a
line/plane stabilizer, factor `p²+p+1`, no deep lift:

    [SL₃(ℤ) : Γ₀(D) ∩ SL₃(ℤ)] = 7 · 13 · 31 = **2821**.

## Rigor boundary and prior art

The derivation is complete above; the replay checks every battery
instance whose modulus can express its pattern (`k ≥ max a`), plus the
global witness.  The mod-p parabolic indices are classical (Bruhat);
depth-lift counts for congruence-type subgroups are standard technique.
No novelty is claimed for the ingredients: the content is the exact
connection to the two-sided moduli `m_ij` of R0036, the proved
n=2-collapse/n=3-shape dichotomy, and the δ-selector statement.  The
`n ≥ 3` verification is at `n = 3`; the formula's proof is uniform in
`n`, and only valuation patterns (not arbitrary triangle patterns) are
covered.
