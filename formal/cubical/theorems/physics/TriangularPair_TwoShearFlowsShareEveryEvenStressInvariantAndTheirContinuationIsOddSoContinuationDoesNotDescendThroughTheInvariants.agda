{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TriangularPair — two shear flows u^σ = (0 , a , σ v), σ = ±1, share
-- every σ-even reading of their stress and differ in the σ-odd
-- continuation, so the continuation does not descend through the
-- invariants.  The prime-boundary document's Theorem 8, at the exact
-- layer: its stress matrix and its continuation as ring terms.
--
-- WHAT THIS IS.  The document exhibits the pair u^σ with stress
--
--     R^σ = (A²/2) · [[0,0,0],[0,1,σ cos x₂],[0,σ cos x₂,1]]
--
-- and continuation ∂ₜU^σ(0) = (σ A²/2) e₃ sin x₂.  Here, over any
-- commutative ring, with c standing for the value cos x₂ and s for
-- sin x₂ at a point, and with the harmless factor 2 absorbed (we write
-- 2R^σ so that no ½ is needed):
--
--   §1  stress σ A c : M3 as the matrix above;
--       cont σ A s : K = σ · A · A · s.
--   §2  the even law — tr, tr(R²), tr(R³) of stress σ are unchanged by
--       σ ↦ −σ (solver);  the odd law — cont (−σ) ≡ −(cont σ) (solver).
--   §3  over ℤ at A = c = s = 1 and σ = ±1: the triple of invariants
--       agrees on the pair (by computation) and the continuation gives
--       1 and −1, so by the corpus's descent lemma the continuation does
--       not factor through (tr , tr R² , tr R³).  This is the same shape
--       as StrainInvariants.charge-odd against magnitude-even and
--       QRClosure.c₁-not-through-QR, now with the document's own pair.
--
-- READING.  The document's point: every reading that is a function of
-- the stress invariants — and, by the same parity, of |u|², |ω|², the
-- energy budget — sees one flow where there are two; the next instant
-- tells them apart.  So no such reading can be a continuation law.
--
-- SYĀT — THE CLAIM, EXACTLY.  Ring identities in (σ , A , c , s) and one
-- two-point witness over ℤ.  The matrix is the document's stress written
-- down, not derived from a velocity field; the continuation is the
-- document's formula written down, not derived from Navier–Stokes.  The
-- derivations (the pressure solve on the torus) are NOT here.
------------------------------------------------------------------------

module TriangularPair_TwoShearFlowsShareEveryEvenStressInvariantAndTheirContinuationIsOddSoContinuationDoesNotDescendThroughTheInvariants where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver

open import DescentObstructionUnified using (FactorsThrough ; factorObstruction)
open import QRClosure_TheRestrictedEulerQuotientClosesByRingIdentityAndThePressureHessianCouplingDoesNotDescendThroughIt using (module Gradient)

------------------------------------------------------------------------
-- §1–§2  Over any commutative ring.
------------------------------------------------------------------------

module Pair {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd) renaming (_+_ to _+r_ ; _·_ to _·r_ ; -_ to neg)
  open Gradient R' using (M3 ; m3 ; tr ; _*_)

  private
    K : Type ℓ
    K = fst R'

  -- 2R^σ at a point where cos x₂ = c
  stress : (σ A c : K) → M3
  stress σ A c = m3
    0r 0r 0r
    0r (A ·r A) (A ·r A ·r (σ ·r c))
    0r (A ·r A ·r (σ ·r c)) (A ·r A)

  -- 2 e₃ · ∂ₜU^σ(0) at a point where sin x₂ = s
  cont : (σ A s : K) → K
  cont σ A s = σ ·r (A ·r A ·r s)

  -- the three trace invariants of the stress
  I₁ I₂ I₃ : (σ A c : K) → K
  I₁ σ A c = tr (stress σ A c)
  I₂ σ A c = tr (stress σ A c * stress σ A c)
  I₃ σ A c = tr (stress σ A c * stress σ A c * stress σ A c)

  I₁-even : (σ A c : K) → I₁ σ A c ≡ I₁ (neg σ) A c
  I₁-even σ A c = solve! R'

  I₂-even : (σ A c : K) → I₂ σ A c ≡ I₂ (neg σ) A c
  I₂-even σ A c = solve! R'

  I₃-even : (σ A c : K) → I₃ σ A c ≡ I₃ (neg σ) A c
  I₃-even σ A c = solve! R'

  cont-odd : (σ A s : K) → cont (neg σ) A s ≡ neg (cont σ A s)
  cont-odd σ A s = solve! R'

  -- the invariants in closed form: 2A², 2A⁴(1 + σ²c²), 2A⁶(1 + 3σ²c²)
  I₁-closed : (σ A c : K) → I₁ σ A c ≡ (1r +r 1r) ·r (A ·r A)
  I₁-closed σ A c = solve! R'

  I₂-closed : (σ A c : K)
            → I₂ σ A c ≡ (1r +r 1r) ·r (A ·r A ·r (A ·r A)) ·r (1r +r σ ·r σ ·r (c ·r c))
  I₂-closed σ A c = solve! R'

------------------------------------------------------------------------
-- §3  Over ℤ: the pair σ = ±1 at A = c = s = 1.
------------------------------------------------------------------------

open Pair ℤCommRing

private
  T : ℤ → Type₀
  T (pos _) = Unit
  T (negsuc _) = ⊥

  pos≢negsuc : {m n : ℕ} → pos m ≡ negsuc n → ⊥
  pos≢negsuc p = subst T p tt

-- the reading: all three invariants at once, as a function of σ
invariants : ℤ → (ℤ × ℤ) × ℤ
invariants σ = (I₁ σ (pos 1) (pos 1) , I₂ σ (pos 1) (pos 1)) , I₃ σ (pos 1) (pos 1)

-- the continuation, as a function of σ
continuation : ℤ → ℤ
continuation σ = cont σ (pos 1) (pos 1)

pair-shares-invariants : invariants (pos 1) ≡ invariants (negsuc 0)
pair-shares-invariants = refl

pair-values : invariants (pos 1) ≡ ((pos 2 , pos 4) , pos 8)
pair-values = refl

pair-continuations : (continuation (pos 1) ≡ pos 1) × (continuation (negsuc 0) ≡ negsuc 0)
pair-continuations = refl , refl

-- THE DESCENT OBSTRUCTION: the continuation is not a function of the invariants.
continuation-not-through-invariants : ¬ FactorsThrough invariants continuation
continuation-not-through-invariants =
  factorObstruction invariants continuation (pos 1) (negsuc 0) refl pos≢negsuc
