{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheValliConvergentDeterminantAlternates
--
-- One of the three honesty faces DOES recur for continued-fraction
-- convergents, and it is the first: LOSSLESSNESS.  The determinant of
-- two consecutive convergents flips sign at every step and is therefore
-- a unit at every step, so each step of the vall is invertible over ‚.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE OPEN TAG THIS ANSWERS, AND HOW MUCH OF IT
--
-- tag: "whether the three honesty faces (lossless / complete / stable)
-- recur for continued-fraction convergents ‚î the vall already IS the
-- CF".
--
-- Answered here: LOSSLESS, yes, and exactly.  NOT answered: complete,
-- and stable.  Those are statements about a grant and about monotonicity
-- under more grant; neither is touched below, and one face out of three
-- is not the tag closed.  It is one third of it, and saying so is the
-- point of the note's own honesty ledger.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE OBJECT
--
-- Given partial quotients `a : ‚ï ‚í ‚` ‚î the vall, ryabhaa's column of
-- quotients (*ryabhaya*, Gaitapda 32‚ì33, 499) ‚î the convergent
-- numerators and denominators satisfy the same two-step recurrence with
-- different seeds.  Their determinant
--
--     det k  =  p k ¬ q (k+1)  ‚àí  p (k+1) ¬ q k
--
-- satisfies  det (k+1) ‚â° ‚àí det k  (¬ß2), hence  det k ‚â° signed k (det 0)
-- (¬ß3): every determinant in the chain is ¬ the first one.  With the
-- standard seeds the first one is 1, so all are units ‚î which is B©zout,
-- and is what `Bija.‡‡‡‡ó‡‡ø‡‡Æ‡`'s alternating orientation is computing.
--
-- SOURCING LIMIT. Nothing here is offered as a reading of Gaitapda 32‚ì33;
-- the recurrence is the standard one and the vall is named because this
-- corpus's own kuaka modules name it.
------------------------------------------------------------------------

module TheValliConvergentDeterminantAlternates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _¬∑_ ; _-_ ; -_)
open import Cubical.Data.Int.Properties using (¬∑Comm)
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- 1.  The convergents, from the vall
------------------------------------------------------------------------

module _ (a : ‚Ñï ‚Üí ‚Ñ§) (p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ : ‚Ñ§) where

  num : ‚Ñï ‚Üí ‚Ñ§
  num zero          = p‚ÇÄ
  num (suc zero)    = p‚ÇÅ
  num (suc (suc k)) = a (suc k) ¬∑ num (suc k) + num k

  den : ‚Ñï ‚Üí ‚Ñ§
  den zero          = q‚ÇÄ
  den (suc zero)    = q‚ÇÅ
  den (suc (suc k)) = a (suc k) ¬∑ den (suc k) + den k

  det : ‚Ñï ‚Üí ‚Ñ§
  det k = num k ¬∑ den (suc k) - num (suc k) ¬∑ den k

------------------------------------------------------------------------
-- 2.  The step: the determinant flips sign, by ring algebra alone
------------------------------------------------------------------------

private
  flip : (A P P' Q Q' : ‚Ñ§)
       ‚Üí P ¬∑ (A ¬∑ Q + Q') - (A ¬∑ P + P') ¬∑ Q ‚â° - (P' ¬∑ Q - P ¬∑ Q')
  flip A P P' Q Q' = solve! ‚Ñ§CommRing

detAlternates :
  (a : ‚Ñï ‚Üí ‚Ñ§) (p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ : ‚Ñ§) (k : ‚Ñï)
  ‚Üí det a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k) ‚â° - det a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k
detAlternates a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k =
  flip (a (suc k))
       (num a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k)) (num a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k)
       (den a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k)) (den a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k)

------------------------------------------------------------------------
-- 3.  Hence every determinant is ¬ the first, for ARBITRARY seeds
------------------------------------------------------------------------

signed : ‚Ñï ‚Üí ‚Ñ§ ‚Üí ‚Ñ§
signed zero    x = x
signed (suc k) x = - signed k x

detIsSignedFirst :
  (a : ‚Ñï ‚Üí ‚Ñ§) (p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ : ‚Ñ§) (k : ‚Ñï)
  ‚Üí det a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k ‚â° signed k (det a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ 0)
detIsSignedFirst a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ zero    = refl
detIsSignedFirst a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k) =
    detAlternates a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k
  ‚àô cong -_ (detIsSignedFirst a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k)

------------------------------------------------------------------------
-- 4.  The standard seeds, where the first determinant is 1
--
-- p‚ = 1, p‚ = a 0, q‚ = 0, q‚ = 1.  Then det 0 = 1¬1 ‚àí a‚¬0.
------------------------------------------------------------------------

private
  firstDet : (A : ‚Ñ§) ‚Üí pos 1 ¬∑ pos 1 - A ¬∑ pos 0 ‚â° pos 1
  firstDet A = cong (Œª z ‚Üí pos 1 ¬∑ pos 1 - z) (¬∑Comm A (pos 0))

standardFirstDeterminant :
  (a : ‚Ñï ‚Üí ‚Ñ§) ‚Üí det a (pos 1) (a 0) (pos 0) (pos 1) 0 ‚â° pos 1
standardFirstDeterminant a = firstDet (a 0)

standardDeterminantIsAUnit :
  (a : ‚Ñï ‚Üí ‚Ñ§) (k : ‚Ñï)
  ‚Üí det a (pos 1) (a 0) (pos 0) (pos 1) k ‚â° signed k (pos 1)
standardDeterminantIsAUnit a k =
    detIsSignedFirst a (pos 1) (a 0) (pos 0) (pos 1) k
  ‚àô cong (signed k) (standardFirstDeterminant a)

------------------------------------------------------------------------
-- 5.  Why this is the LOSSLESS face and not a new one
--
-- `LosslessReturn.‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡` proves the kuaka's descent reversible;
-- `Gati.‡‡≤‡ã‡‡` proves it for the whole algorithm.  ¬ß4 is the same
-- property at the convergents: a determinant that is a unit at every
-- step is exactly the statement that the 2ó2 step matrix is invertible
-- over ‚, so no step of the vall loses information.  `Bija.‡‡‡‡ó‡‡ø‡‡Æ‡`
-- computes B©zout by climbing that column with alternating orientation
-- ‚î the alternation of ¬ß2 is that orientation, as an identity.
--
-- The other two faces are NOT here.  `Purnata.‡‡‡∞‡‡‡‡Ø‡æ-‡ó‡‡∞‡‡‡Æ‡`
-- (complete: enough grant always resolves) and `Sthairya.‡‡‡‡à‡∞‡‡Ø-‡ó‡‡ø`
-- (stable: a resolved answer survives more grant) are statements about a
-- grant, and no grant appears above.  One face is not three.
------------------------------------------------------------------------
