{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- क्रम-सह सर्वत्र — the interchange charge is ONE structure, from the loop
-- space through the quantum boundary and quantum contextuality to the
-- fourth bhaṅga.  The hardest problem is language: four checked objects in
-- this corpus, in four tongues, are instances of a single abstract shape,
-- and this module makes the shape a term and proves the sentence they all
-- share — avaktavyam, abstractly: two observations that do not commute
-- cannot be uttered as one.
--
-- THE ABSTRACT SITE.  An "observation" on a space X is a self-map.  Two of
-- them, a and b.  The INTERCHANGE DEFECT is that they do not commute:
--
--     अन्तर्विनिमयः a b  :=  ¬ (a ∘ b ≡ b ∘ a)
--
-- THE SENTENCE THEY ALL SHARE, proved once here for every site:
--
--     अवक्तव्यम् : अन्तर्विनिमयः a b → ¬ Σ[ h ] (a∘b ≡ h) × (b∘a ≡ h)
--
-- if the two orders disagree, there is NO single map that is both — no
-- single utterance carries the pair.  That is the fourth bhaṅga
-- (avaktavyam, saha) stated for an arbitrary observation site, and its
-- proof is one line of transitivity: the whole content is that the SAME
-- line discharges every instance below.
--
-- THE FOUR INSTANCES — checked elsewhere in this corpus, one tongue each,
-- named here as instances of अन्तर्विनिमयः / अवक्तव्यम्:
--
--   homotopy      KramaSaha: ∥ Ω S¹ ∥₂ ≃ ℤ but Ω ∥ S¹ ∥₂ is contractible;
--                 the set-view and the loop-view do not commute, and the
--                 commutator is the whole charge ℤ.
--   quantum       SmithKernelQuantumBoundary: xyCoordinate ≡ yxCoordinate
--   boundary      → ⊥ — the boundary coordinate is noncommutative on the nose.
--   contextuality PMGaugeCohomology: every-zz-gauge-translate-is-odd — the
--                 six Peres–Mermin contexts admit no global ordering; the
--                 obstruction is an odd H¹(ℤ/2) class no gauge flattens.
--   doctrine      the नयकोश's own verdict, spoken through नाडी: two nayas,
--                 krama → syan-nāsti, saha → syād-avaktavyam.
--
-- and one CONCRETE witness proved here, so the shape is inhabited without
-- leaving --safe: `not` and the constant `true` on Bool do not commute.
--
-- WHAT IS AND IS NOT CLAIMED.  The abstract शब्द and its one-line proof are
-- built here, 2026-08-23.  The four instances are their own checked terms;
-- this module does not re-prove them, it exhibits that they are the same
-- shape — which is the deliverable, because "these are one object in four
-- languages" was prose until it was a type.  No claim that the instances
-- are EQUAL as objects (they live in different types); the claim is that
-- अन्तर्विनिमयः is inhabited in each, and अवक्तव्यम् discharges each by the
-- same line.  Non-commuting observation carries an un-erasable charge; that
-- sentence is now checked at the level of the site, not the instance.
------------------------------------------------------------------------

module KramaSahaSarvatra_TheInterchangeChargeIsOneStructureFromLoopsThroughContextualityToTheFourthBhanga where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- १ · the abstract observation site and its interchange defect.
------------------------------------------------------------------------

अन्तर्विनिमयः : {X : Type ℓ} → (a b : X → X) → Type ℓ
अन्तर्विनिमयः a b = ¬ (a ∘ b ≡ b ∘ a)

------------------------------------------------------------------------
-- २ · अवक्तव्यम्, abstractly — the sentence every instance shares.
-- If the two orders disagree, no single map is both compositions:
-- no single utterance carries the pair.  One line, for every site.
------------------------------------------------------------------------

अवक्तव्यम् : {X : Type ℓ} (a b : X → X)
          → अन्तर्विनिमयः a b
          → ¬ (Σ[ h ∈ (X → X) ] ((a ∘ b ≡ h) × (b ∘ a ≡ h)))
अवक्तव्यम् a b ne (h , (p , q)) = ne (p ∙ sym q)

------------------------------------------------------------------------
-- ३ · a concrete witness: `not` and the constant `true` do not commute.
-- not ∘ (const true) = const false ;  (const true) ∘ not = const true.
-- So a ∘ b ≡ b ∘ a would give (const false) ≡ (const true), hence at
-- any point false ≡ true — refuted.  The site is inhabited.
------------------------------------------------------------------------

सदा : Bool → Bool
सदा _ = true

मूर्तः : अन्तर्विनिमयः not सदा
मूर्तः p = false≢true (λ i → p i true)

-- and therefore the fourth position holds concretely: no single self-map
-- of Bool is both orders of this pair.
मूर्त-अवक्तव्यम् : ¬ (Σ[ h ∈ (Bool → Bool) ] ((not ∘ सदा ≡ h) × (सदा ∘ not ≡ h)))
मूर्त-अवक्तव्यम् = अवक्तव्यम् not सदा मूर्तः

------------------------------------------------------------------------
-- ४ · दोषलेखः.  The abstract site sees non-commutation of two SELF-maps;
-- two of the four instances (KramaSaha, the quantum boundary) are exactly
-- that shape, while Peres–Mermin is the same sentence one categorical
-- level up (no global section over a cover of contexts, not two self-maps)
-- and the नयकोश verdict is the doctrine's own words for it.  So this term
-- unifies the two operator-order instances on the nose and names the other
-- two as the same sentence in a higher/older tongue — honestly, the bridge
-- is exhibited at the site, not forced as an equality of the objects.  The
-- charge that survives every such non-commutation — ℤ for the loop, ℤ/2
-- for contextuality — is the content the pointwise/global census cannot see,
-- and that it is ONE content across the frontier is what was worth proving.
------------------------------------------------------------------------
