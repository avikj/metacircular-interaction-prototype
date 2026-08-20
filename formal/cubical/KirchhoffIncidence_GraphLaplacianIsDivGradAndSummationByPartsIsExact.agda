{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- KirchhoffIncidence_GraphLaplacianIsDivGradAndSummationByPartsIsExact
--
-- PROVENANCE, stated before the mathematics, because the file-naming rule
-- (CLAUDE.md, "File naming", note 2) requires that a module whose
-- mathematics does not originate in the traditions this repository reads
-- SAY SO rather than be given a fabricated Sanskrit label.
--
-- This file has no Sanskrit name because its content is not Indian.  The
-- objects below are, with text and date:
--
--   * G. Kirchhoff, "Ueber die Auflösung der Gleichungen, auf welche man
--     bei der Untersuchung der linearen Vertheilung galvanischer Ströme
--     geführt wird", Annalen der Physik und Chemie 72 (1847) 497–508.
--     The incidence matrix `B` of a network, the node law (`div ω ≡ 0`),
--     the loop law (`ω` is a `grad`), the spanning tree, and the count
--     |E| − |V| + 1 of independent circulations.  The two laws themselves
--     are one paper earlier: Ann. Phys. Chem. 64 (1845) 497–514.
--     Composing the node law with Ohm's law on each edge is exactly
--     `div (c · grad φ) = source`, i.e. the weighted graph Laplacian.
--     `Δ = div ∘ grad` is Kirchhoff's equation and nothing else.
--
--   * H. Poincaré, "Analysis Situs", J. École Polytech. (2) 1 (1895) 1–121:
--     incidence matrices of a complex as boundary operators over ℤ, with
--     ∂∂ = 0.  This is where `B` becomes a differential rather than a
--     bookkeeping table.
--
--   * B. Eckmann, "Harmonische Funktionen und Randwertaufgaben in einem
--     Komplex", Comment. Math. Helv. 17 (1945) 240–255.  The combinatorial
--     Hodge theorem: Δ = δd + dδ on a finite complex, the orthogonal
--     decomposition, and harmonic cochains ≅ cohomology.  On a graph the
--     dδ term is empty and Δ = δd, which is `laplacian-is-gram` below.
--
--   * H. Weyl, "Repartición de corriente en una red conductora", Rev. Mat.
--     Hisp.-Amer. 5 (1923) 153–164: Kirchhoff's problem as an orthogonal
--     decomposition of the edge space into cycle space and cut space.
--     `by-parts` is the pairing that decomposition is orthogonal for.
--
--   * H. Whitney, Geometric Integration Theory (Princeton, 1957) is often
--     given as the source of discrete exterior calculus and is NOT the
--     source of anything below.  Whitney's contribution is the bridge in
--     the other direction — cochains on a simplicial complex to genuine
--     differential forms (the Whitney elements), plus the cochain product
--     of "On products in a complex", Ann. of Math. 39 (1938) 397–432.
--     No product and no manifold occurs here.
--
--   * A. Dimakis and F. Müller-Hoissen, "Discrete differential calculus:
--     graphs, topologies, and gauge theory", J. Math. Phys. 35 (1994)
--     6703–6735, is where the graph d acquires a bimodule of 1-forms and a
--     Leibniz rule; that structure is not built here either.
--
-- WHAT IS AND IS NOT CLAIMED.  Nothing below is new mathematics.  The
-- claim is only that these five identities now exist in this repository as
-- checked terms rather than as prose, over an arbitrary commutative ring,
-- for an arbitrary finite directed multigraph, with no connectivity,
-- simplicity, or loop-freeness hypothesis anywhere.
--
-- WHAT IS REFUTED, deliberately, at the bottom of the file: the claim I
-- formed while writing it — that `Δ φ ≡ 0` forces `φ` constant.  It does
-- not, and `harmonic-does-not-force-constant` is the counterexample.  That
-- is the precise place where Kirchhoff's connectivity count enters and the
-- reason his β = |E| − |V| + c carries a `c`.
--
-- CHECKED: Agda 2.6.3, cubical library v0.5 (commit 132a2a3) — this
-- container, NOT the repository pin declared in BUILD.md.  --cubical
-- --safe, no postulates, no holes, EXIT 0.
--
-- Two warnings remain, both of the same kind and both benign: Agda 2.6.3
-- under --cubical reports that a match on `Cubical.Data.FinData.Fin`
-- "relies on injectivity of ℕ.suc", so the matched function will not
-- compute under `transp`.  It fires on `Triangle.at3` and on
-- `Refutation.φ01`, the two places where a concrete finite graph is
-- written down.  Neither function is ever transported; the warning is a
-- property of pattern-matching on an indexed family in this Agda, not of
-- anything claimed here.  Nothing in §§0–1 warns.
--
-- Author: cf-tessera-i-0, 2026-08-20.
------------------------------------------------------------------------

module KirchhoffIncidence_GraphLaplacianIsDivGradAndSummationByPartsIsExact where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.FinData using (Fin ; zero ; suc ; FinVec)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.Ring.Base
open import Cubical.Algebra.Ring.Properties
open import Cubical.Algebra.Ring.BigOps
open import Cubical.Algebra.CommRing.Base
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

private variable ℓ : Level

------------------------------------------------------------------------
-- 0.  Three facts about finite sums that the library does not ship
------------------------------------------------------------------------

module Sums (R' : CommRing ℓ) where
  private
    Rr = CommRing→Ring R'
    R = fst R'
  open CommRingStr (snd R') public
  open Sum Rr public
  open KroneckerDelta Rr public
  open RingTheory Rr public

  -- the empty sum, at every length
  ∑0 : ∀ {n} → ∑ {n} (λ _ → 0r) ≡ 0r
  ∑0 {ℕ.zero}  = refl
  ∑0 {ℕ.suc n} = cong (0r +_) (∑0 {n}) ∙ +IdR 0r

  -- a column of the Kronecker delta sums to one
  ∑δ : ∀ {n} (j : Fin n) → ∑ (λ i → δ i j) ≡ 1r
  ∑δ {n} j = ∑Ext (λ i → sym (·IdL (δ i j))) ∙ ∑Mulr1 n (λ _ → 1r) j

  -- Fubini for finite sums
  ∑Swap : ∀ {n m} (F : Fin n → Fin m → R)
        → ∑ (λ i → ∑ (λ j → F i j)) ≡ ∑ (λ j → ∑ (λ i → F i j))
  ∑Swap {ℕ.zero}  {m} F = sym (∑0 {m})
  ∑Swap {ℕ.suc n} {m} F =
      cong (∑ (λ j → F zero j) +_) (∑Swap {n} {m} (λ i j → F (suc i) j))
    ∙ sym (∑Split (λ j → F zero j) (λ j → ∑ (λ i → F (suc i) j)))

------------------------------------------------------------------------
-- 1.  A finite directed multigraph and Kirchhoff's incidence matrix
--
--   Vertices are `Fin n`, edges are `Fin m`, and every edge carries a
--   source and a target.  Nothing forbids loops (`src e ≡ tgt e`),
--   parallel edges, or isolated vertices, and the graph need not be
--   connected.  Coefficients live in any commutative ring.
------------------------------------------------------------------------

module Graph (R' : CommRing ℓ) (n m : ℕ) (src tgt : Fin m → Fin n) where
  open Sums R' public
  private R = fst R'

  C⁰ : Type ℓ                       -- vertex functions, 0-cochains
  C⁰ = FinVec R n

  C¹ : Type ℓ                       -- edge functions, 1-cochains
  C¹ = FinVec R m

  infixl 6 _−_
  _−_ : R → R → R
  x − y = x + (- y)

  -- Kirchhoff 1847: the incidence matrix, +1 at the head, −1 at the tail.
  B : Fin n → Fin m → R
  B v e = δ v (tgt e) − δ v (src e)

  -- the discrete exterior derivative / potential difference / gradient
  grad : C⁰ → C¹
  grad φ e = φ (tgt e) − φ (src e)

  -- its adjoint: the graph divergence, net flow out of a vertex
  div : C¹ → C⁰
  div ω v = ∑ (λ e → B v e · ω e)

  -- the graph Laplacian
  Δ : C⁰ → C⁰
  Δ = div ∘ grad

  -- the Gram matrix of the rows of B; for a loopless simple graph this is
  -- degree-minus-adjacency, but that identification needs hypotheses this
  -- module deliberately does not assume.
  L : Fin n → Fin n → R
  L v w = ∑ (λ e → B v e · B w e)

  ----------------------------------------------------------------------
  -- 1.1  Delta picks a coordinate out of a sum
  ----------------------------------------------------------------------

  private
    pick : (φ : C⁰) (j : Fin n) → ∑ (λ v → δ v j · φ v) ≡ φ j
    pick φ j = ∑Ext (λ v → ·Comm (δ v j) (φ v)) ∙ ∑Mulr1 n φ j

    pickNeg : (φ : C⁰) (j : Fin n) → ∑ (λ v → (- δ v j) · φ v) ≡ - φ j
    pickNeg φ j =
        ∑Ext (λ v → -DistL· (δ v j) (φ v))
      ∙ ∑Dist- (λ v → δ v j · φ v)
      ∙ cong (-_) (pick φ j)

  ----------------------------------------------------------------------
  -- THEOREM 1.  `grad` is multiplication by the transpose of `B`.
  --
  --   This is the statement that "potential difference along an edge" and
  --   "the incidence matrix" are the same operator, which is what makes
  --   Kirchhoff's loop law a statement about a matrix.
  ----------------------------------------------------------------------

  grad-is-incidence : (φ : C⁰) (e : Fin m) → grad φ e ≡ ∑ (λ v → B v e · φ v)
  grad-is-incidence φ e =
    sym ( ∑Ext (λ v → ·DistL+ (δ v (tgt e)) (- δ v (src e)) (φ v))
        ∙ ∑Split (λ v → δ v (tgt e) · φ v) (λ v → (- δ v (src e)) · φ v)
        ∙ cong₂ _+_ (pick φ (tgt e)) (pickNeg φ (src e)) )

  ----------------------------------------------------------------------
  -- THEOREM 2.  Summation by parts: `grad` and `div` are adjoint for the
  -- two obvious pairings.  This is discrete Green / discrete Stokes, and
  -- it holds with no boundary condition because a finite graph has no
  -- boundary: every edge has both its endpoints inside.
  ----------------------------------------------------------------------

  by-parts : (φ : C⁰) (ω : C¹)
           → ∑ (λ e → grad φ e · ω e) ≡ ∑ (λ v → φ v · div ω v)
  by-parts φ ω =
      ∑Ext (λ e → cong (_· ω e) (grad-is-incidence φ e))
    ∙ ∑Ext (λ e → ∑Mulldist (ω e) (λ v → B v e · φ v))
    ∙ ∑Swap (λ e v → (B v e · φ v) · ω e)
    ∙ ∑Ext (λ v → ∑Ext (λ e →
          cong (_· ω e) (·Comm (B v e) (φ v)) ∙ sym (·Assoc (φ v) (B v e) (ω e))))
    ∙ sym (∑Ext (λ v → ∑Mulrdist (φ v) (λ e → B v e · ω e)))

  ----------------------------------------------------------------------
  -- THEOREM 3.  The graph Laplacian is `B Bᵀ`, entrywise.
  --
  --   Δ = div ∘ grad, and its matrix is the Gram matrix of the incidence
  --   rows.  On a loopless simple graph the diagonal entry is the degree
  --   and the off-diagonal entry is minus the number of edges joining the
  --   two vertices, i.e. D − A; that specialisation is a computation, and
  --   `triangle-laplacian` below performs it on the 3-cycle.
  ----------------------------------------------------------------------

  laplacian-is-gram : (φ : C⁰) (v : Fin n) → Δ φ v ≡ ∑ (λ w → L v w · φ w)
  laplacian-is-gram φ v =
      ∑Ext (λ e → cong (B v e ·_) (grad-is-incidence φ e))
    ∙ ∑Ext (λ e → ∑Mulrdist (B v e) (λ w → B w e · φ w))
    ∙ ∑Swap (λ e w → B v e · (B w e · φ w))
    ∙ ∑Ext (λ w → ∑Ext (λ e → ·Assoc (B v e) (B w e) (φ w)))
    ∙ ∑Ext (λ w → sym (∑Mulldist (φ w) (λ e → B v e · B w e)))

  ----------------------------------------------------------------------
  -- THEOREM 4.  Constants are harmonic.  `Δ 1 = 0`, i.e. the rows of the
  -- Laplacian sum to zero, which is why it is always singular.
  ----------------------------------------------------------------------

  constants-harmonic : (c : R) (v : Fin n) → Δ (λ _ → c) v ≡ 0r
  constants-harmonic c v =
    ∑Ext (λ e → cong (B v e ·_) (+InvR c)) ∙ ∑Mulr0 (λ e → B v e)

  ----------------------------------------------------------------------
  -- THEOREM 5.  Every column of `B` sums to zero, hence the total
  -- divergence of any edge flow vanishes: what leaves one vertex arrives
  -- at another.  This is the global form of Kirchhoff's node law and it
  -- is an identity, not a hypothesis on ω.
  ----------------------------------------------------------------------

  column-sum : (e : Fin m) → ∑ (λ v → B v e) ≡ 0r
  column-sum e =
      ∑Split (λ v → δ v (tgt e)) (λ v → - δ v (src e))
    ∙ cong₂ _+_ (∑δ (tgt e)) (∑Dist- (λ v → δ v (src e)) ∙ cong (-_) (∑δ (src e)))
    ∙ +InvR 1r

  total-divergence : (ω : C¹) → ∑ (λ v → div ω v) ≡ 0r
  total-divergence ω =
      ∑Swap (λ v e → B v e · ω e)
    ∙ ∑Ext (λ e → sym (∑Mulldist (ω e) (λ v → B v e)))
    ∙ ∑Ext (λ e → cong (_· ω e) (column-sum e))
    ∙ ∑Mul0r ω

  ----------------------------------------------------------------------
  -- COROLLARY 6.  Kirchhoff's power identity: the Dirichlet energy of a
  -- potential, summed over edges, equals its pairing with its own
  -- Laplacian, summed over vertices.  One line from Theorem 2.
  ----------------------------------------------------------------------

  dirichlet : (φ : C⁰) → ∑ (λ e → grad φ e · grad φ e) ≡ ∑ (λ v → φ v · Δ φ v)
  dirichlet φ = by-parts φ (grad φ)

------------------------------------------------------------------------
-- 2.  The 3-cycle over ℤ: the Laplacian is degree minus adjacency
--
--   Vertices 0,1,2; edges 0→1, 1→2, 2→0.  Theorem 3 says Δ has matrix L;
--   here L is computed, and each of its nine entries is checked against
--   D − A by `refl`.
------------------------------------------------------------------------

module Triangle where
  v0 v1 v2 : Fin 3
  v0 = zero
  v1 = suc zero
  v2 = suc (suc zero)

  -- The index is kept as `suc (suc (suc k))` with `k` a variable rather
  -- than as the numeral 3: cubical Agda 2.6.3 refuses a match that peels a
  -- literal, because it would need injectivity of ℕ.suc.
  private
    at3 : {k : ℕ} (a b c : Fin 3) → Fin (ℕ.suc (ℕ.suc (ℕ.suc k))) → Fin 3
    at3 a b c zero             = a
    at3 a b c (suc zero)       = b
    at3 a b c (suc (suc _))    = c

  srcT tgtT : Fin 3 → Fin 3
  srcT = at3 {0} v0 v1 v2       -- edges 0→1, 1→2, 2→0
  tgtT = at3 {0} v1 v2 v0

  open Graph ℤCommRing 3 3 srcT tgtT

  triangle-diagonal : (L v0 v0 ≡ pos 2) × (L v1 v1 ≡ pos 2) × (L v2 v2 ≡ pos 2)
  triangle-diagonal = refl , refl , refl

  triangle-offdiagonal :
      (L v0 v1 ≡ negsuc 0) × (L v1 v2 ≡ negsuc 0) × (L v2 v0 ≡ negsuc 0)
  triangle-offdiagonal = refl , refl , refl

  -- and the row really does sum to zero: 2 − 1 − 1 = 0 (Theorem 4, here
  -- as an arithmetic fact rather than as the general proof).
  triangle-row : Δ (λ _ → pos 1) v0 ≡ pos 0
  triangle-row = constants-harmonic (pos 1) v0

------------------------------------------------------------------------
-- 3.  THE REFUTATION.
--
--   The claim I formed while writing Theorem 4 and believed long enough to
--   start writing down: "Δ φ ≡ 0 forces φ constant" — the discrete maximum
--   principle, the statement that the kernel of the Laplacian is exactly
--   the constants.
--
--   It is false, and it does not need a subtle graph to be false.  Take
--   two vertices and no edges.  Every sum over edges is empty, so Δ φ is
--   identically 0 for EVERY φ, while φ = (0,1) is not constant.
--
--   What the false claim was missing is Kirchhoff's own count: the kernel
--   of Δ has dimension c(G), the number of connected components, and
--   β = |E| − |V| + c carries that c for exactly this reason.  I had
--   silently assumed c = 1.  Connectivity is not decoration on the
--   theorem; it is the whole of the theorem's hypothesis.
------------------------------------------------------------------------

module Refutation where
  noEdgeSrc noEdgeTgt : Fin 0 → Fin 2
  noEdgeSrc ()
  noEdgeTgt ()

  open Graph ℤCommRing 2 0 noEdgeSrc noEdgeTgt

  φ01 : C⁰
  φ01 zero       = pos 0
  φ01 (suc zero) = pos 1

  -- on a graph with no edges every function is harmonic, definitionally
  everything-is-harmonic : (φ : C⁰) (v : Fin 2) → Δ φ v ≡ pos 0
  everything-is-harmonic φ v = refl

  private
    isZero : ℤ → Bool
    isZero (pos ℕ.zero)    = true
    isZero (pos (ℕ.suc _)) = false
    isZero (negsuc _)      = false

  φ01-not-constant : ¬ (φ01 zero ≡ φ01 (suc zero))
  φ01-not-constant p = true≢false (cong isZero p)

  -- the claim "Δ φ ≡ 0 → φ is constant", stated so it can be refuted
  HarmonicForcesConstant : Type₀
  HarmonicForcesConstant =
    (φ : C⁰) → ((v : Fin 2) → Δ φ v ≡ pos 0) → ((u v : Fin 2) → φ u ≡ φ v)

  harmonic-does-not-force-constant : ¬ HarmonicForcesConstant
  harmonic-does-not-force-constant h =
    φ01-not-constant (h φ01 (everything-is-harmonic φ01) zero (suc zero))

------------------------------------------------------------------------
-- Rigor boundary.
--
-- Checked generically, over any commutative ring and any finite directed
-- multigraph: grad is Bᵀ; grad and div are adjoint; Δ = div ∘ grad has
-- matrix B Bᵀ; constants are harmonic; every column of B sums to zero and
-- hence total divergence vanishes; the Dirichlet identity.
--
-- Checked concretely over ℤ: the 3-cycle Laplacian is D − A.
--
-- Refuted: that the kernel of Δ is the constants.
--
-- NOT claimed: any spectral statement, positive semidefiniteness (which
-- needs an order, not a ring), the matrix-tree theorem, Δ = δd + dδ in
-- degrees above 1, the identification L = D − A for a general graph
-- (it needs looplessness and is done here only for the triangle), or any
-- statement about infinite graphs.
------------------------------------------------------------------------
