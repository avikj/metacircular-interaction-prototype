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

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- एकत्व-मात्रा-द्वयम् — uniqueness of the two-outcome measure: the FIRST
-- step into the interior of the Born weights, past EkatvaMatra's support
-- layer.  Program ४ of YugaParivartana.  2026-08-23.
--
-- WHAT IS PROVED (kernel-checked).  On a symmetric two-outcome contention
-- (Bool), a weight rule obeying
--   • योगः   — normalisation: w(true) + w(false) ≡ 𝟙
--   • साम्यम् — permutation invariance (anekānta: neither outcome
--              absolutised): w(true) ≡ w(false)
-- is UNIQUE — any two agree at both outcomes — PROVIDED the weight
-- carrier halves 𝟙 uniquely.  The forced value is the unique y with
-- y + y ≡ 𝟙: the Born weight ½ of the symmetric qubit, forced, not
-- assumed.  This is the interior, not the support: it pins a genuine
-- weight VALUE.
--
-- WHAT THE PROOF REVEALS, and it is the point.  The forcing needs
-- `halvesUniquely` — unique 2-divisibility of the carrier.  That is
-- exactly the char-0 / archimedean structure `README` C5 isolates
-- ("in characteristic 0 … the receipt is arithmetic"): over ℚ or ℝ the
-- half exists and is unique, so the symmetric Born weight is forced; over
-- a carrier where 𝟙 has two distinct halves or none, it is not.  So the
-- interior opens exactly over the archimedean carrier — and the general
-- (asymmetric, higher-outcome) interior remains Gleason (dim ≥ 3), the
-- wall EkatvaMatra names.  Symmetric interior: reached.  General interior:
-- still walled, honestly.
------------------------------------------------------------------------

module EkatvaMatraDvaya_TheSymmetricTwoOutcomeBornWeightIsForcedToHalfExactlyOverAUniquelyHalvingCarrier where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false)

private variable ℓ : Level

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W) (𝟙 : W)
         (halvesUniquely : isProp (Σ[ y ∈ W ] (y +ᵂ y ≡ 𝟙))) where

  record द्विमात्रिन् (w : Bool → W) : Type ℓ where
    field
      योगः   : (w true +ᵂ w false) ≡ 𝟙
      साम्यम् : w true ≡ w false

  open द्विमात्रिन्

  -- each vow-obeying rule exhibits w(true) as a half of 𝟙
  halfOf : (w : Bool → W) → द्विमात्रिन् w → Σ[ y ∈ W ] (y +ᵂ y ≡ 𝟙)
  halfOf w d = w true , (cong (w true +ᵂ_) (साम्यम् d) ∙ योगः d)

  -- THE THEOREM: the symmetric two-outcome Born weight is forced.
  एकत्वम्-द्विमात्रा : (w w' : Bool → W)
                     → द्विमात्रिन् w → द्विमात्रिन् w'
                     → (b : Bool) → w b ≡ w' b
  एकत्वम्-द्विमात्रा w w' d d' true  =
    cong fst (halvesUniquely (halfOf w d) (halfOf w' d'))
  एकत्वम्-द्विमात्रा w w' d d' false =
    sym (साम्यम् d) ∙ cong fst (halvesUniquely (halfOf w d) (halfOf w' d')) ∙ साम्यम् d'
