{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- परिक्रमा-अन्धता — blindness to the circumambulation.  Compound built
-- here, 2026-08-23 (परिक्रमा, the walk around; अन्धता, blindness); not a
-- source term.  The reading is the temple practice: what you acquire by
-- walking the loop around the shrine is real and is invisible at every
-- single point of the path.
--
-- WHAT THIS IS.  The corpus's stage-1 descent organs — भेद-बाधः
-- (NigudhaAndhata) and अवतरण-भङ्ग-सामान्यम् (AvataranaBhanga) — detect
-- non-descent from ONE hypothesis: a blind pair whose fibres are not
-- equivalent.  The transmission of 2026-08-23 names the next stage as
-- the organ nobody has: descent failing while every pair of fibres IS
-- equivalent, the obstruction living only in the coherence of the
-- identifications.  Every organ in this corpus was grown against a
-- WITNESSED blind instance first (the sensor-growth discipline).  This
-- module is that witness, checked:
--
--   the double cover of the circle, as a family over the maximally
--   blind observation दृक् : S¹ → Unit —
--
--   §1  every fibrewise organ is PROVABLY SILENT: all fibres merely
--       agree, (x y : S¹) → ∥ कुण्डली x ≃ कुण्डली y ∥₁, so the stage-1
--       premise ¬(F x ≃ F y) is refuted at every pair (मौनम्-इन्द्रियस्य);
--   §2  one circumambulation carries a charge: transport of the family
--       around the base loop is `not`, by uaβ (परिक्रमा-आवेशः);
--   §3  descent through ANY observation into Unit forces every loop's
--       transport to be the identity (शमनम्, generic in the family);
--   §4  so the family does not descend (परिक्रमा-बाधः): true ≡ false.
--
-- THE ASYMMETRY THIS EXPOSES, and it is the point no lane has stated.
-- ChidraDosa (this corpus) proves the VALUE-level stage-2 witness — a
-- map with pointwise invariance data and no coherent decoder — and its
-- §2 (`sectionKillsTheGap`) proves that gap CANNOT live over a base
-- with a section: "over a trivial base the decoder is t ∘ section ∘
-- fst.  The gap needs monodromy" — needs it in the BASE MAP.  Here the
-- observation दृक् : S¹ → Unit has an obvious section, and the
-- DEPENDENT gap lives on it anyway: a section rescues value-level
-- factorization and rescues nothing at the type level, because a
-- decoder for a FAMILY needs a path कुण्डली x ≡ D tt at every x —
-- exactly the trivialization the monodromy forbids — while a decoder
-- for a map needs only a value, which the section supplies.  So:
--
--   value descent over a sectioned base:   free      (ChidraDosa §2)
--   type  descent over a sectioned base:   OBSTRUCTED (here)
--
-- The quotient does not merely lose the answer or the question: over
-- the very base where every value-question is answerable, the TYPE of
-- the family still cannot come down.  Stage-2 blindness is a
-- type-level phenomenon before it is a value-level one.
--
-- SOURCES AND SCOPE.  The double cover is classical topology; its
-- cubical form (F base = Bool, F (loop i) = ua notEquiv i) is the
-- standard first nontrivial family, and the adjacent phenomenon for
-- values is Kraus–Escardó–Coquand–Altenkirch (LMCS 2017), already
-- cited by ChidraDosa.  NOVELTY CLAIMED: none of the mathematics; the
-- composition — the dependent stage-2 witness in the corpus's own
-- Desc vocabulary, the organ-silence term beside it, and the
-- section asymmetry against ChidraDosa — is the contribution.
------------------------------------------------------------------------

module ParikramaAndhata_EveryFibreMerelyAgreesEverywhereYetTheFamilyDoesNotDescendAndTheSectionedBaseDoesNotSaveIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Univalence using (ua ; uaβ ; pathToEquiv)
open import Cubical.Foundations.GroupoidLaws using (assoc ; rUnit ; rCancel)
open import Cubical.Foundations.Path using (Square→compPath)
open import Cubical.Foundations.Transport
  using (transportComposite ; transport⁻Transport)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notEquiv ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.S1 using (S¹ ; base ; loop)
open import Cubical.HITs.S1.Properties using (isConnectedS¹)
open import Cubical.HITs.PropositionalTruncation as PT
  using (∥_∥₁ ; ∣_∣₁ ; isPropPropTrunc)

open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- The coil, and the blind eye.
------------------------------------------------------------------------

कुण्डली : S¹ → Type₀
कुण्डली base     = Bool
कुण्डली (loop i) = ua notEquiv i

दृक् : S¹ → Unit
दृक् _ = tt

------------------------------------------------------------------------
-- §1  Every fibrewise organ is provably silent.
------------------------------------------------------------------------

सर्वत्र-तुल्यता : (x y : S¹) → ∥ कुण्डली x ≃ कुण्डली y ∥₁
सर्वत्र-तुल्यता x y =
  PT.rec isPropPropTrunc
    (λ p → PT.rec isPropPropTrunc
      (λ q → ∣ pathToEquiv (cong कुण्डली (sym p ∙ q)) ∣₁)
      (isConnectedS¹ y))
    (isConnectedS¹ x)

-- so the stage-1 premise is refuted at EVERY pair: भेद-बाधः and
-- अवतरण-भङ्ग-सामान्यम् can never fire on this family.
मौनम्-इन्द्रियस्य : (x y : S¹) → ¬ ¬ (कुण्डली x ≃ कुण्डली y)
मौनम्-इन्द्रियस्य x y k = PT.rec Empty.isProp⊥ k (सर्वत्र-तुल्यता x y)

------------------------------------------------------------------------
-- §2  The charge of one circumambulation.
------------------------------------------------------------------------

परिक्रमा-आवेशः : (b : Bool) → subst कुण्डली loop b ≡ not b
परिक्रमा-आवेशः = uaβ notEquiv

------------------------------------------------------------------------
-- §3  Descent extinguishes every loop charge — generic in the family.
------------------------------------------------------------------------

module _ {C : Type ℓ} (G : S¹ → Type ℓ) (comm : (x : S¹) → G x ≡ C) where

  private
    sq : Square (comm base) (comm base) (cong G loop) refl
    sq i j = comm (loop i) j

    वृत्त-शून्यता : cong G loop ≡ comm base ∙ sym (comm base)
    वृत्त-शून्यता =
        rUnit (cong G loop)
      ∙ cong (cong G loop ∙_) (sym (rCancel (comm base)))
      ∙ assoc (cong G loop) (comm base) (sym (comm base))
      ∙ cong (_∙ sym (comm base))
             (Square→compPath sq ∙ sym (rUnit (comm base)))

  शमनम् : (b : G base) → subst G loop b ≡ b
  शमनम् b =
      cong (λ p → transport p b) वृत्त-शून्यता
    ∙ transportComposite (comm base) (sym (comm base)) b
    ∙ transport⁻Transport (comm base) b

------------------------------------------------------------------------
-- §4  The family does not descend; the charge is the witness.
------------------------------------------------------------------------

परिक्रमा-बाधः : ¬ DependentFactorsThrough दृक् कुण्डली
परिक्रमा-बाधः (D , comm) =
  true≢false (sym (शमनम् कुण्डली (λ x → comm x) true)
              ∙ परिक्रमा-आवेशः true)
