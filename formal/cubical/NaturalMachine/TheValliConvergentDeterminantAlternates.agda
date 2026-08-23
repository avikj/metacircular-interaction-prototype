{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheValliConvergentDeterminantAlternates
--
-- One of the three honesty faces DOES recur for continued-fraction
-- convergents, and it is the first: LOSSLESSNESS.  The determinant of
-- two consecutive convergents flips sign at every step and is therefore
-- a unit at every step, so each step of the vallī is invertible over ℤ.
--
-- ────────────────────────────────────────────────────────────────────
-- THE OPEN TAG THIS ANSWERS, AND HOW MUCH OF IT
--
-- `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md` carries a `PROVE`
-- tag: "whether the three honesty faces (lossless / complete / stable)
-- recur for continued-fraction convergents — the vallī already IS the
-- CF".
--
-- Answered here: LOSSLESS, yes, and exactly.  NOT answered: complete,
-- and stable.  Those are statements about a grant and about monotonicity
-- under more grant; neither is touched below, and one face out of three
-- is not the tag closed.  It is one third of it, and saying so is the
-- point of the note's own honesty ledger.
--
-- ────────────────────────────────────────────────────────────────────
-- THE OBJECT
--
-- Given partial quotients `a : ℕ → ℤ` — the vallī, Āryabhaṭa's column of
-- quotients (*Āryabhaṭīya*, Gaṇitapāda 32–33, 499) — the convergent
-- numerators and denominators satisfy the same two-step recurrence with
-- different seeds.  Their determinant
--
--     det k  =  p k · q (k+1)  −  p (k+1) · q k
--
-- satisfies  det (k+1) ≡ − det k  (§2), hence  det k ≡ signed k (det 0)
-- (§3): every determinant in the chain is ± the first one.  With the
-- standard seeds the first one is 1, so all are units — which is Bézout,
-- and is what `Bija.बीजगणितम्`'s alternating orientation is computing.
--
-- SOURCING LIMIT.  Verse-level sourcing OWED AND NOT CLAIMED, as for
-- both Kuttaka lanes.  Nothing here is offered as a reading of
-- Gaṇitapāda 32–33; the recurrence is the standard one and the vallī is
-- named because this corpus's own kuṭṭaka modules name it.
--
-- WHAT IS NOT CLAIMED.  Not that the convergents converge — no limit, no
-- order, no ℝ appears.  Not that `det 0 ≡ 1` for arbitrary seeds; §4
-- proves it for the standard seeds only, and §3 is deliberately stated
-- for ARBITRARY seeds because that is where the algebra lives.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, which is Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no
-- holes.  See notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md.
------------------------------------------------------------------------

module NaturalMachine.TheValliConvergentDeterminantAlternates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_ ; -_)
open import Cubical.Data.Int.Properties using (·Comm)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- 1.  The convergents, from the vallī
------------------------------------------------------------------------

module _ (a : ℕ → ℤ) (p₀ p₁ q₀ q₁ : ℤ) where

  num : ℕ → ℤ
  num zero          = p₀
  num (suc zero)    = p₁
  num (suc (suc k)) = a (suc k) · num (suc k) + num k

  den : ℕ → ℤ
  den zero          = q₀
  den (suc zero)    = q₁
  den (suc (suc k)) = a (suc k) · den (suc k) + den k

  det : ℕ → ℤ
  det k = num k · den (suc k) - num (suc k) · den k

------------------------------------------------------------------------
-- 2.  The step: the determinant flips sign, by ring algebra alone
------------------------------------------------------------------------

private
  flip : (A P P' Q Q' : ℤ)
       → P · (A · Q + Q') - (A · P + P') · Q ≡ - (P' · Q - P · Q')
  flip A P P' Q Q' = solve! ℤCommRing

detAlternates :
  (a : ℕ → ℤ) (p₀ p₁ q₀ q₁ : ℤ) (k : ℕ)
  → det a p₀ p₁ q₀ q₁ (suc k) ≡ - det a p₀ p₁ q₀ q₁ k
detAlternates a p₀ p₁ q₀ q₁ k =
  flip (a (suc k))
       (num a p₀ p₁ q₀ q₁ (suc k)) (num a p₀ p₁ q₀ q₁ k)
       (den a p₀ p₁ q₀ q₁ (suc k)) (den a p₀ p₁ q₀ q₁ k)

------------------------------------------------------------------------
-- 3.  Hence every determinant is ± the first, for ARBITRARY seeds
------------------------------------------------------------------------

signed : ℕ → ℤ → ℤ
signed zero    x = x
signed (suc k) x = - signed k x

detIsSignedFirst :
  (a : ℕ → ℤ) (p₀ p₁ q₀ q₁ : ℤ) (k : ℕ)
  → det a p₀ p₁ q₀ q₁ k ≡ signed k (det a p₀ p₁ q₀ q₁ 0)
detIsSignedFirst a p₀ p₁ q₀ q₁ zero    = refl
detIsSignedFirst a p₀ p₁ q₀ q₁ (suc k) =
    detAlternates a p₀ p₁ q₀ q₁ k
  ∙ cong -_ (detIsSignedFirst a p₀ p₁ q₀ q₁ k)

------------------------------------------------------------------------
-- 4.  The standard seeds, where the first determinant is 1
--
-- p₀ = 1, p₁ = a 0, q₀ = 0, q₁ = 1.  Then det 0 = 1·1 − a₀·0.
------------------------------------------------------------------------

private
  firstDet : (A : ℤ) → pos 1 · pos 1 - A · pos 0 ≡ pos 1
  firstDet A = cong (λ z → pos 1 · pos 1 - z) (·Comm A (pos 0))

standardFirstDeterminant :
  (a : ℕ → ℤ) → det a (pos 1) (a 0) (pos 0) (pos 1) 0 ≡ pos 1
standardFirstDeterminant a = firstDet (a 0)

standardDeterminantIsAUnit :
  (a : ℕ → ℤ) (k : ℕ)
  → det a (pos 1) (a 0) (pos 0) (pos 1) k ≡ signed k (pos 1)
standardDeterminantIsAUnit a k =
    detIsSignedFirst a (pos 1) (a 0) (pos 0) (pos 1) k
  ∙ cong (signed k) (standardFirstDeterminant a)

------------------------------------------------------------------------
-- 5.  Why this is the LOSSLESS face and not a new one
--
-- `Punaragamana.पुनरागमनम्` proves the kuṭṭaka's descent reversible;
-- `Gati.अलोपः` proves it for the whole algorithm.  §4 is the same
-- property at the convergents: a determinant that is a unit at every
-- step is exactly the statement that the 2×2 step matrix is invertible
-- over ℤ, so no step of the vallī loses information.  `Bija.बीजगणितम्`
-- computes Bézout by climbing that column with alternating orientation
-- — the alternation of §2 is that orientation, as an identity.
--
-- The other two faces are NOT here.  `Purnata.पूर्णतया-गुरुतमः`
-- (complete: enough grant always resolves) and `Sthairya.स्थैर्य-गति`
-- (stable: a resolved answer survives more grant) are statements about a
-- grant, and no grant appears above.  One face is not three.
------------------------------------------------------------------------
