-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SmithTorsorBridge
--
-- The meeting point of the two Smith lanes, typed.
--
-- NaturalMachine.SmithCapability (the library's certified normalizer)
-- produces, for any integer matrix, ONE normalization event: the
-- normal form N with invertible L, R and the replay path
-- N ≡ L ⋆ M ⋆ R.  The Gamma0 modules (Partner/Converse/Freeness/
-- Transitivity/TransporterMembership) prove that the SET of all such
-- events at a 2×2 nonzero-determinant endpoint is a Γ₀(q)-torsor,
-- every clause a program.
--
-- This module joins them: `toTuple` is a multiplication-preserving
-- change of representation (via the library's own dot2), and
-- `eventOfSmith` converts the normalizer's replay path into exactly
-- the event equation the torsor modules quantify over.  Corollary
-- (by Gamma0Transitivity/TransporterMembership, no new proof needed):
-- the certified normalizer computes a SECTION of the event torsor,
-- and any other presentation of the same matrix differs from it by
-- the explicit transporter εᵤ·U′·adj U, whose congruence membership
-- carries a computed divisibility witness.
------------------------------------------------------------------------

module SmithTorsorBridge where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.FinData using (zero ; one)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient
open import Cubical.Algebra.IntegerMatrix.Smith

open import Gamma0Partner using (R ; M ; mul)
open import NaturalMachine.SmithCapability
  using (normalMatrix ; leftTransform ; rightTransform ; replaySmith)

open Coefficient ℤCommRing

-- change of representation ------------------------------------------

toTuple : Mat 2 2 → M
toTuple A = (A zero zero , A zero one , A one zero , A one one)

-- multiplication is preserved, by the library's own 2-element sum law

homMul : (A B : Mat 2 2) → toTuple (A ⋆ B) ≡ mul (toTuple A) (toTuple B)
homMul A B i =
  ( dot2 (A zero) (λ l → B l zero) i
  , dot2 (A zero) (λ l → B l one) i
  , dot2 (A one) (λ l → B l zero) i
  , dot2 (A one) (λ l → B l one) i )

-- the normalizer's output, as an event of the torsor -----------------

eventOfSmith : (A : Mat 2 2)
             → toTuple (normalMatrix A)
               ≡ mul (mul (toTuple (leftTransform A)) (toTuple A))
                     (toTuple (rightTransform A))
eventOfSmith A =
  cong toTuple (replaySmith A)
  ∙ homMul (leftTransform A ⋆ A) (rightTransform A)
  ∙ cong (λ w → mul w (toTuple (rightTransform A)))
         (homMul (leftTransform A) A)
