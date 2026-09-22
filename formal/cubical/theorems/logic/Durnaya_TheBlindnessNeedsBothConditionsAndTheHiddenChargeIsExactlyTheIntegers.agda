{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- दुर्नय · durnaya — a naya (standpoint) that asserts itself by DENYING
-- the other standpoints, as against a सुनय, which asserts itself while
-- leaving the others standing.  **Siddhasena Divkara, *Sanmatitarka*
-- (~5th c. CE); sharpened by Akalaka (~8th c.); Yaovijaya,
-- *Nayopadea* (~17th c.).**  Jaina.  The school is named because the
-- dispute is the content: the Naiyyikas reject anekntavda outright
-- and would not accept the diagnosis this module applies.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE.
--
-- §१–§२ move the whole question OFF the universe.  `Naya`'s loop is
-- `ua notEquiv`, so a reader may believe the phenomenon is about
-- univalence or about universes.  It is not.  `loop : base ≡ base` is a
-- CONSTRUCTOR of `S¹ : Type₀`; carrier, loop and answer all sit in
-- Type₀; and the same three facts hold.
--
-- §२ is the part that is a RECEIPT in this repository's sense — an
-- identification of a fibre with a standard type, never a bound.  What
-- every set-valued observable of the carrier destroys is not "some
-- charge": it is exactly ℤ, by `ΩS¹Isoℤ`, and the identifying map IS
-- `winding` on the nose (§��, `refl`).
-- This is the identification: the
-- mode-regarding standpoint loses nothing at all, because `winding` is
-- an equivalence and ℤ is a set.
--
-- So the two standpoints are measured against each other exactly:
--   द्रव्यार्थिक (observables of the carrier, set-valued): sees 0 of ℤ.
--   पर्यायार्थिक (observables of the path type, set-valued): sees ℤ.
-- Same loop, same h-level of answer, total blindness against total
-- sight.  Truncation was never what separated them, and neither was
-- non-dependence by itself.
--
-- §५ is the counterexample restated where nothing can be blamed on a
-- universe: `cong (idfun S¹) loop ≢ refl`, with `idfun S¹ : S¹ → S¹`
-- non-dependent and `S¹` merely not a set.
------------------------------------------------------------------------

module Durnaya_TheBlindnessNeedsBothConditionsAndTheHiddenChargeIsExactlyTheIntegers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.HITs.S1.Base using (S¹ ; base ; loop ; ΩS¹ ; winding ; ΩS¹Isoℤ)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Int.Properties using (injPos ; isSetℤ)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere as NAYA

------------------------------------------------------------------------
-- १ ── THE LOOP IS A CONSTRUCTOR, NOT A `ua`.
--
-- Carrier `S¹ : Type₀`, loop `loop : base ≡ base`.  Nothing in this
-- section mentions a universe or an equivalence.
------------------------------------------------------------------------

आवर्तः : ΩS¹
आवर्तः = loop

------------------------------------------------------------------------
-- २ ── अभिज्ञानम् — THE RECEIPT.  The hidden charge is IDENTIFIED with a
--      standard type, not bounded: ΩS¹ ≃ ℤ, and ℤ is a set.
------------------------------------------------------------------------

अभिज्ञानम् : ΩS¹ ≃ ℤ
अभिज्ञानम् = isoToEquiv ΩS¹Isoℤ

-- २ब ── and the identifying map is `winding` ON THE NOSE.  This is what
--       makes it a receipt rather than a bare cardinality remark: the
--       standard type comes with the observable that realises it.
वाहकः : fst अभिज्ञानम् ≡ winding
वाहकः = refl

-- २स ── the answer type is a SET.  So no h-level excuse is available to
--        either side of §६: both standpoints below answer in sets.
समुच्चयः : isSet ℤ
समुच्चयः = isSetℤ

------------------------------------------------------------------------
-- ३ ── द्रव्यार्थिकनयः — the substance-regarding standpoint sees NOTHING.
--
-- Every set-valued observable of the CARRIER annihilates every loop.
-- `Naya` §१ applied unchanged; the whole of ℤ collapses to a point.
------------------------------------------------------------------------

द्रव्य-अन्धत्वम् :
  (X : Type₀) → isSet X → (F : S¹ → X) → (p : ΩS¹) → cong F p ≡ refl
द्रव्य-अन्धत्वम् X isSetX F p = NAYA.नय-निरोधः isSetX F p

------------------------------------------------------------------------
-- ४ ── पर्यायार्थिकनयः — the mode-regarding standpoint sees EVERYTHING.
--
-- `winding : ΩS¹ → ℤ` is an observable of the PATH TYPE, it lands in a
-- set, and it is an equivalence: no loop is lost, not merely two
-- separated.
------------------------------------------------------------------------

पर्याय-दर्शनम् : ΩS¹ ≃ ℤ
पर्याय-दर्शनम् = अभिज्ञानम्

-- and it does not merely see: it is FAITHFUL, `intLoop ∘ winding ≡ id`.
पर्याय-अलोपः : (p : ΩS¹) → Iso.inv ΩS¹Isoℤ (winding p) ≡ p
पर्याय-अलोपः = Iso.leftInv ΩS¹Isoℤ

------------------------------------------------------------------------
-- � �� NON-DEPENDENCE ALONE IS NOT ENOUGH, OFF THE UNIVERSE.
--
-- `idfun S¹ : S¹ → S¹` is non-dependent post-composition, its codomain
-- lives in Type₀, and `cong (idfun S¹) loop` is NOT refl — because S¹
-- is not a set.
--
-- The witness of non-triviality is the receipt of §२ used as a probe:
-- `winding loop = pos 1` and `winding refl = pos 0`, both definitional.
------------------------------------------------------------------------

आवर्तः-न-लोपः : ¬ (आवर्तः ≡ refl)
आवर्तः-न-लोपः p = snotz (injPos (cong winding p))

अन्धत्वं-न-केवलम्-अनाश्रितत्वम् : ¬ (cong (idfun S¹) आवर्तः ≡ refl)
अन्धत्वं-न-केवलम्-अनाश्रितत्वम् = आवर्तः-न-लोपः

-- and the same refutation, with the quantifier the sentence carries:
-- there is no theorem "every non-dependent `cong F` annihilates".
न-सामान्यम् :
  ¬ ((X : Type₀) → (F : S¹ → X) → cong F आवर्तः ≡ refl)
न-सामान्यम् h = अन्धत्वं-न-केवलम्-अनाश्रितत्वम् (h S¹ (idfun S¹))

------------------------------------------------------------------------
-- ६ ── अनेकान्तः — NEITHER CONDITION IS SUFFICIENT, BOTH TOGETHER ARE.
--
-- One term carrying the three cells that settle it, on ONE loop:
--
--   fst  set-valued AND non-dependent-on-the-carrier  ⟹ blind.
--   snd  non-dependent alone (drop `isSet X`)          ⟹ NOT blind.
--   thd  set-valued alone (observe the path type)      ⟹ NOT blind,
--        and not merely non-blind — lossless, by §२.
--
-- `Naya` §ध's `isSet X` hypothesis is therefore not decoration.
------------------------------------------------------------------------

उभयम्-आवश्यकम् :
    ((X : Type₀) → isSet X → (F : S¹ → X) → cong F आवर्तः ≡ refl)
  × (¬ ((X : Type₀) → (F : S¹ → X) → cong F आवर्तः ≡ refl))
  × (ΩS¹ ≃ ℤ)
उभयम्-आवश्यकम् =
    (λ X isSetX F → द्रव्य-अन्धत्वम् X isSetX F आवर्तः)
  , न-सामान्यम्
  , पर्याय-दर्शनम्
