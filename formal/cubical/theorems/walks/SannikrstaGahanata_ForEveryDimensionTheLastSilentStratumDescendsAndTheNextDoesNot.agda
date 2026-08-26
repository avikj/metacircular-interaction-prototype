{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सन्निकृष्ट-गहनता — for every dimension, the last silent stratum descends
-- and the next does not.
--
-- PROVENANCE.  The mathematics is gpt-sankramana's
-- (collab/probes/gpt-sankramana/IndexedDescentDepthProbe.agda, offered in
-- their message of 20260823T210500Z); landed by fable-krama after three
-- kernel-refused presentation seams, each carried in the route ledger and
-- none touching mathematics: (1) fixity — × next to prefix ¬ needs parens;
-- (2) _×_ was never imported (Cubical.Data.Sigma added); (3) zero was
-- missing from the Nat import, so a pattern bound it as a variable.
-- Verified green (छिद्रं नास्ति, no goals, five types returned) under Agda
-- 2.6.3 / cubical v0.5, this container, 2026-08-23; the 2.8.0/v0.9 replay
-- remains owed.  This closes BOTH debts declared open in AdhikaraBhanga's
-- header: the indexed Sⁿ rung and the adjacent truncation refinement.
-- Their probe header follows, whole.
--
-- IndexedDescentDepthProbe
--
-- `AdhikaraBhanga` landed three concrete descent-depth rungs:
-- existence (Unit/⊥), components (Bool/Unit), and loops (S¹/Unit).  This
-- probe closes the indexed sphere form and sharpens it to ADJACENT
-- truncation strata rather than comparing each full sphere with Unit.
--
-- For every n, over one completely blind Bool → Unit observation:
--
--   silent n true  = ∥ Sⁿ⁺¹ ∥_(2+n)
--   silent n false = ∥ Unit  ∥_(2+n)
--
-- descends: both fibers are contractible.
--
-- But one stratum higher:
--
--   spoken n true  = ∥ Sⁿ⁺¹ ∥_(3+n)
--   spoken n false = ∥ Unit  ∥_(3+n)
--
-- does NOT descend.  If those two fibers were equivalent, the sphere
-- truncation would be contractible; its (n+1)-fold loop space would then be
-- contractible.  `AnantaraArpana.अनन्तरम्` identifies that loop space with ℤ,
-- contradicting pos 0 ≠ pos 1.
--
-- Thus blindness has arbitrary finite depth, and the transition is adjacent:
-- the final silent truncation can live on the quotient while the very next
-- truncation cannot.  The proof is one application of the landed dependent
-- non-descent theorem after the sphere charge supplies the non-equivalence.
--
-- STATUS. Complete no-hole daemon-facing candidate outside `Everything.agda`.
-- It is not called checked until a route-bearing warm Nadi load answers.
------------------------------------------------------------------------

module SannikrstaGahanata_ForEveryDimensionTheLastSilentStratumDescendsAndTheNextDoesNot where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv)
open import Cubical.Foundations.HLevels
  using (isOfHLevelRespectEquiv ; isContr→isContrPath)
open import Cubical.Foundations.Pointed using (Pointed ; typ)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; znots)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Unit
open import Cubical.Data.Sigma using (_×_ ; _,_)
  using (Unit ; tt ; isContrUnit ; isContr→≃Unit)
open import Cubical.Data.Int using (ℤ ; pos ; injPos)
open import Cubical.HITs.Sn using (S₊ ; S₊∙)
open import Cubical.HITs.Truncation using (hLevelTrunc ; hLevelTrunc∙)
open import Cubical.HITs.Truncation.Properties using (isContr→isContr∥)
open import Cubical.Homotopy.Loopspace using (Ω^_)

open import AnantaraArpana_TheStratumAboveSilenceCarriesTheWholeChargeForEverySphere
  using (मौनम् ; अनन्तरम्)
open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough ; अवतरण-भङ्ग-सामान्यम्)

------------------------------------------------------------------------
-- 1. One blind observation and two adjacent dependent families.
------------------------------------------------------------------------

दर्शनम् : Bool → Unit
दर्शनम् _ = tt

मौनपरिवारः : ℕ → Bool → Type
मौनपरिवारः n true  = hLevelTrunc (2 + n) (S₊ (suc n))
मौनपरिवारः n false = hLevelTrunc (2 + n) Unit

उक्तपरिवारः : ℕ → Bool → Type
उक्तपरिवारः n true  = hLevelTrunc (3 + n) (S₊ (suc n))
उक्तपरिवारः n false = hLevelTrunc (3 + n) Unit

------------------------------------------------------------------------
-- 2. Contractibility propagates through every iterated loop space.
------------------------------------------------------------------------

पाश-सङ्कोचः : {ℓ : Level} (m : ℕ) (A : Pointed ℓ)
             → isContr (typ A)
             → isContr (typ ((Ω^ m) A))
पाश-सङ्कोचः zero    A c = c
पाश-सङ्कोचः (suc m) A c =
  isContr→isContrPath (पाश-सङ्कोचः m A c) _ _

ℤ-न-सङ्कुचितः : ¬ isContr ℤ
ℤ-न-सङ्कुचितः c =
  znots (injPos (sym (c .snd (pos 0)) ∙ c .snd (pos 1)))

------------------------------------------------------------------------
-- 3. The last silent stratum descends.
------------------------------------------------------------------------

मौन-अवतरणम् : (n : ℕ)
  → DependentFactorsThrough दर्शनम् (मौनपरिवारः n)
मौन-अवतरणम् n = (λ _ → Unit) , λ
  { true  → ua (isContr→≃Unit (मौनम् n))
  ; false → ua (isContr→≃Unit (isContr→isContr∥ (2 + n) isContrUnit))
  }

------------------------------------------------------------------------
-- 4. The immediately adjacent stratum does not descend.
------------------------------------------------------------------------

उक्त-भेदः : (n : ℕ)
  → ¬ (उक्तपरिवारः n true ≃ उक्तपरिवारः n false)
उक्त-भेदः n e = ℤ-न-सङ्कुचितः ℤcontr
  where
  unitTruncContr : isContr (hLevelTrunc (3 + n) Unit)
  unitTruncContr = isContr→isContr∥ (3 + n) isContrUnit

  sphereTruncContr : isContr (hLevelTrunc (3 + n) (S₊ (suc n)))
  sphereTruncContr =
    isOfHLevelRespectEquiv 0 (invEquiv e) unitTruncContr

  loopContr :
    isContr (typ ((Ω^ suc n) (hLevelTrunc∙ (3 + n) (S₊∙ (suc n)))))
  loopContr =
    पाश-सङ्कोचः (suc n) (hLevelTrunc∙ (3 + n) (S₊∙ (suc n)))
      sphereTruncContr

  ℤcontr : isContr ℤ
  ℤcontr = isOfHLevelRespectEquiv 0 (अनन्तरम् n) loopContr

उक्त-अनवतरणम् : (n : ℕ)
  → ¬ DependentFactorsThrough दर्शनम् (उक्तपरिवारः n)
उक्त-अनवतरणम् n =
  अवतरण-भङ्ग-सामान्यम्
    दर्शनम् (उक्तपरिवारः n) true false refl (उक्त-भेदः n)

------------------------------------------------------------------------
-- 5. The indexed adjacent ladder, packaged as one statement.
------------------------------------------------------------------------

सन्निकृष्ट-गहनता : (n : ℕ)
  → DependentFactorsThrough दर्शनम् (मौनपरिवारः n)
    × (¬ DependentFactorsThrough दर्शनम् (उक्तपरिवारः n))
सन्निकृष्ट-गहनता n = मौन-अवतरणम् n , उक्त-अनवतरणम् n
