{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTruncationErrorIsExactAtEveryFiniteStage
--
-- The error of a truncated geometric series is not un-said in this
-- corpus: it is exactly rⁿ, at every finite n, over ℤ, with no limit and
-- no analysis.  What needs analysis is only its asymptotics.
--
-- And the truncated sum alone does not carry it: at n = 1 the partial
-- sum is `1` for EVERY ratio, while the error is the ratio itself.  So
-- the error term separates exactly what the truncation identifies.
--
-- ────────────────────────────────────────────────────────────────────
-- RELATION TO `Madhava.agda`
--
-- `Madhava.गुणश्रेढी-योगः : (1 − r) · ∑_{k<n} rᵏ ≡ 1 − rⁿ` over ℤ, by
-- induction.
-- §1 below is that module's own theorem plus `minusPlus`: the error is exactly r�.
--
-- ────────────────────────────────────────────────────────────────────
------------------------------------------------------------------------

module TheTruncationErrorIsExactAtEveryFiniteStage where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_ ; injPos)
open import Cubical.Data.Int.Properties using (minusPlus ; ·Comm ; ·IdR)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import Madhava using (घात ; सङ्कलितम् ; गुणश्रेढी-योगः)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  The remainder, exactly, at every finite n
--
-- Reading `Madhava.गुणश्रेढी-योगः` as a statement about error rather than
-- about the sum: the scaled partial sum plus rⁿ is exactly 1.  No limit,
-- no convergence, no ℝ — the same induction, rearranged.
------------------------------------------------------------------------

exactRemainder :
  (r : ℤ) (n : ℕ)
  → (pos 1 - r) · सङ्कलितम् r n + घात r n ≡ pos 1
exactRemainder r n =
    cong (_+ घात r n) (गुणश्रेढी-योगः r n)
  ∙ minusPlus (घात r n) (pos 1)

------------------------------------------------------------------------
-- 2.  The partial sum, and what it forgets
--
-- At n = 1 the sum is `1` whatever the ratio; the error at n = 1 IS the
-- ratio.  So one step of truncation already discards everything the
-- error carries.
------------------------------------------------------------------------

sumAtOneIsOne : (r : ℤ) → सङ्कलितम् r 1 ≡ pos 1
sumAtOneIsOne r = refl

errorAtOneIsTheRatio : (r : ℤ) → घात r 1 ≡ r
errorAtOneIsTheRatio r = ·Comm (pos 1) r ∙ ·IdR r

------------------------------------------------------------------------
-- 3.  The error's own step, and the exact point where analysis begins
------------------------------------------------------------------------

errorStep : (r : ℤ) (n : ℕ) → घात r (suc n) ≡ घात r n · r
errorStep r n = refl

sumStep : (r : ℤ) (n : ℕ) → सङ्कलितम् r (suc n) ≡ सङ्कलितम् r n + घात r n
sumStep r n = refl


------------------------------------------------------------------------
-- 4.  THE COLLISION.  The error separates what the truncation identifies.
--
-- Isolated in the corpus's standing shape, so the general lemma applies
-- rather than a fresh argument being written.  Seventh site of
-- `TranscriptDescent.collisionObstructsDecoder`.
------------------------------------------------------------------------

private
  2≢3 : ¬ (pos 2 ≡ pos 3)
  2≢3 p = znots (injSuc (injSuc (injPos p)))

truncate error : ℤ → ℤ
truncate r = सङ्कलितम् r 1
error    r = घात r 1

truncationCollision :
  Σ[ a ∈ ℤ ] Σ[ b ∈ ℤ ] ((truncate a ≡ truncate b) × (¬ (error a ≡ error b)))
truncationCollision =
  pos 2 , pos 3 , refl ,
  λ h → 2≢3 (sym (errorAtOneIsTheRatio (pos 2)) ∙ h ∙ errorAtOneIsTheRatio (pos 3))

errorDoesNotFactorThroughTheTruncation :
  ¬ FactorsThrough truncate error
errorDoesNotFactorThroughTheTruncation =
  collisionObstructsDecoder truncate error {pos 2} {pos 3}
    refl
    (λ h → 2≢3 (sym (errorAtOneIsTheRatio (pos 2)) ∙ h ∙ errorAtOneIsTheRatio (pos 3)))

------------------------------------------------------------------------
-- 5.  The sentence this earns.
--
-- "A correlation coefficient has no content; the content is the error
-- term."  §4 is that, on Mdhava's own object and at one step:
-- the truncation is constant in the ratio, the error is the identity in
-- it, and no invariant of the former reports the latter.
------------------------------------------------------------------------
