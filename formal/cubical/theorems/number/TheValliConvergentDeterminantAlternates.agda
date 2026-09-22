{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheValliConvergentDeterminantAlternates
--
-- One of the three honesty faces DOES recur for continued-fraction
-- convergents, and it is the first: LOSSLESSNESS.  The determinant of
-- two consecutive convergents flips sign at every step and is therefore
-- a unit at every step, so each step of the vall is invertible over â.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE OBJECT
--
-- Given partial quotients `a : â• â’ â` â” the vall, ryabhaa's column of
-- quotients (*ryabhaya*, Gaitapda 32â“33, 499) â” the convergent
-- numerators and denominators satisfy the same two-step recurrence with
-- different seeds.  Their determinant
--
--     det k  =  p k Â q (k+1)  âˆ’  p (k+1) Â q k
--
-- satisfies  det (k+1) â‰¡ âˆ’ det k  (Â§2), hence  det k â‰¡ signed k (det 0)
-- (Â§3): every determinant in the chain is Â the first one.  With the
-- standard seeds the first one is 1, so all are units â” which is B©zout,
-- and is what `Bija.àààà—àà¿àà®à`'s alternating orientation is computing.
--
-- The recurrence is the standard one and the vall is named because this
-- corpus's own kuaka modules name it.
------------------------------------------------------------------------

module TheValliConvergentDeterminantAlternates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Int using (â„¤ ; pos ; _+_ ; _Â·_ ; _-_ ; -_)
open import Cubical.Data.Int.Properties using (Â·Comm)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- 1.  The convergents, from the vall
------------------------------------------------------------------------

module _ (a : â„• â†’ â„¤) (pâ‚€ pâ‚ qâ‚€ qâ‚ : â„¤) where

  num : â„• â†’ â„¤
  num zero          = pâ‚€
  num (suc zero)    = pâ‚
  num (suc (suc k)) = a (suc k) Â· num (suc k) + num k

  den : â„• â†’ â„¤
  den zero          = qâ‚€
  den (suc zero)    = qâ‚
  den (suc (suc k)) = a (suc k) Â· den (suc k) + den k

  det : â„• â†’ â„¤
  det k = num k Â· den (suc k) - num (suc k) Â· den k

------------------------------------------------------------------------
-- 2.  The step: the determinant flips sign, by ring algebra alone
------------------------------------------------------------------------

private
  flip : (A P P' Q Q' : â„¤)
       â†’ P Â· (A Â· Q + Q') - (A Â· P + P') Â· Q â‰¡ - (P' Â· Q - P Â· Q')
  flip A P P' Q Q' = solve! â„¤CommRing

detAlternates :
  (a : â„• â†’ â„¤) (pâ‚€ pâ‚ qâ‚€ qâ‚ : â„¤) (k : â„•)
  â†’ det a pâ‚€ pâ‚ qâ‚€ qâ‚ (suc k) â‰¡ - det a pâ‚€ pâ‚ qâ‚€ qâ‚ k
detAlternates a pâ‚€ pâ‚ qâ‚€ qâ‚ k =
  flip (a (suc k))
       (num a pâ‚€ pâ‚ qâ‚€ qâ‚ (suc k)) (num a pâ‚€ pâ‚ qâ‚€ qâ‚ k)
       (den a pâ‚€ pâ‚ qâ‚€ qâ‚ (suc k)) (den a pâ‚€ pâ‚ qâ‚€ qâ‚ k)

------------------------------------------------------------------------
-- 3.  Hence every determinant is Â the first, for ARBITRARY seeds
------------------------------------------------------------------------

signed : â„• â†’ â„¤ â†’ â„¤
signed zero    x = x
signed (suc k) x = - signed k x

detIsSignedFirst :
  (a : â„• â†’ â„¤) (pâ‚€ pâ‚ qâ‚€ qâ‚ : â„¤) (k : â„•)
  â†’ det a pâ‚€ pâ‚ qâ‚€ qâ‚ k â‰¡ signed k (det a pâ‚€ pâ‚ qâ‚€ qâ‚ 0)
detIsSignedFirst a pâ‚€ pâ‚ qâ‚€ qâ‚ zero    = refl
detIsSignedFirst a pâ‚€ pâ‚ qâ‚€ qâ‚ (suc k) =
    detAlternates a pâ‚€ pâ‚ qâ‚€ qâ‚ k
  âˆ™ cong -_ (detIsSignedFirst a pâ‚€ pâ‚ qâ‚€ qâ‚ k)

------------------------------------------------------------------------
-- 4.  The standard seeds, where the first determinant is 1
--
-- pâ = 1, pâ = a 0, qâ = 0, qâ = 1.  Then det 0 = 1Â1 âˆ’ aâÂ0.
------------------------------------------------------------------------

private
  firstDet : (A : â„¤) â†’ pos 1 Â· pos 1 - A Â· pos 0 â‰¡ pos 1
  firstDet A = cong (Î» z â†’ pos 1 Â· pos 1 - z) (Â·Comm A (pos 0))

standardFirstDeterminant :
  (a : â„• â†’ â„¤) â†’ det a (pos 1) (a 0) (pos 0) (pos 1) 0 â‰¡ pos 1
standardFirstDeterminant a = firstDet (a 0)

standardDeterminantIsAUnit :
  (a : â„• â†’ â„¤) (k : â„•)
  â†’ det a (pos 1) (a 0) (pos 0) (pos 1) k â‰¡ signed k (pos 1)
standardDeterminantIsAUnit a k =
    detIsSignedFirst a (pos 1) (a 0) (pos 0) (pos 1) k
  âˆ™ cong (signed k) (standardFirstDeterminant a)

------------------------------------------------------------------------
-- 5.  Why this is the LOSSLESS face and not a new one
--
-- `LosslessReturn.ààà¨à°à¾à—à®à¨à®à` proves the kuaka's descent reversible;
-- `Gati.àà²à‹àà` proves it for the whole algorithm.  Â§4 is the same
-- property at the convergents: a determinant that is a unit at every
-- step is exactly the statement that the 2—2 step matrix is invertible
-- over â, so no step of the vall loses information.  `Bija.àààà—àà¿àà®à`
-- computes B©zout by climbing that column with alternating orientation
-- â” the alternation of Â§2 is that orientation, as an identity.
------------------------------------------------------------------------
