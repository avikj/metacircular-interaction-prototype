{-# OPTIONS --cubical --safe #-}

-- EkatvaNirnaya_TheTwoVowsForceTheDecisionRuleUniquelySoTheBornStandpointHasNoRival
--
-- एकत्व-निर्णयः — ekatva, uniqueness; nirṇaya, the decision.  Compound
-- built here, 2026-08-23, for program ४ of YugaParivartana (measurement
-- as conflict resolution).  Sources as AvaktavyaPrasava's header gives
-- them, and nothing further claimed of any: Kātyāyana's vārttika on
-- 1.4.2 (the configuration), Umāsvāti 5.31 (asserted/unasserted),
-- Siddhasena, Sanmatitarka 1.21 (durnaya — the vow this theorem shows
-- is load-bearing).
--
-- WHAT IS PROVED.  AvaktavyaPrasava checks two laws of the birth's
-- assertion function eka : List R → Maybe R:
--
--     (1) IT DECIDES on unanimity: all contenders saying a ⟹ just a.
--     (2) IT TAKES NOTHING: two contenders differing ⟹ nothing.
--
-- This module proves the theorem that makes those laws a FOUNDATION
-- rather than a design choice: **on nonempty contention lists over any
-- discrete result type, the two laws determine the function COMPLETELY.
-- Any two rules satisfying them agree everywhere.**  There is no room
-- for a tie-breaker, a weighting, a hidden preference — the vows leave
-- zero freedom.  In program ४'s reading: the Born-standpoint decision
-- rule has no rival within its vows; whatever satisfies ahiṃsā-of-
-- assertion (take nothing not unanimously given) and decision-on-
-- unanimity IS it.  The proof is a decidable dichotomy: every nonempty
-- list over a discrete type is either constant or exhibits a differing
-- pair, and each law covers one horn.
--
-- SYĀT — THE CLAIM, EXACTLY.  Nothing about amplitudes, weights, or the
-- quantitative Born rule — this is the uniqueness of the ASSERTION
-- layer (which propositions the decision may assert), the qualitative
-- skeleton.  The quantitative extension (weights forced by vows on a
-- richer carrier) is program ४'s open continuation, named in
-- YugaParivartana.  Empty contention lists are genuinely
-- underdetermined by the laws (vacuous unanimity for every a at once)
-- and are excluded by type, honestly.

module EkatvaNirnaya_TheTwoVowsForceTheDecisionRuleUniquelySoTheBornStandpointHasNoRival where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Relation.Nullary using (¬_ ; Discrete ; yes ; no)

private
  variable
    ℓ : Level

module _ {A : Type ℓ} (disc : Discrete A) where

  data _∈_ (x : A) : List A → Type ℓ where
    अत्र   : ∀ {ys}   → x ∈ (x ∷ ys)
    तत्र   : ∀ {y ys} → x ∈ ys → x ∈ (y ∷ ys)

  -- all members equal a
  सर्वसमम् : A → List A → Type ℓ
  सर्वसमम् a []       = Unit*
  सर्वसमम् a (x ∷ xs) = (x ≡ a) × सर्वसमम् a xs

  -- the two vows, as a record on a candidate rule
  record व्रतिन् (e : List A → Maybe A) : Type ℓ where
    field
      निर्णयति : (a : A) (vs : List A)
               → सर्वसमम् a (a ∷ vs) → e (a ∷ vs) ≡ just a
      न-गृह्णाति : (vs : List A) (x y : A)
                 → x ∈ vs → y ∈ vs → ¬ x ≡ y → e vs ≡ nothing

  -- the dichotomy: over a discrete type, every list is constant-at-a
  -- or exhibits a member differing from a
  विभागः : (a : A) (vs : List A)
         → सर्वसमम् a vs ⊎ (Σ[ x ∈ A ] (x ∈ vs) × (¬ x ≡ a))
  विभागः a [] = inl tt*
  विभागः a (x ∷ xs) with disc x a
  ... | yes p = recurse (विभागः a xs)
    where
      recurse : सर्वसमम् a xs ⊎ (Σ[ y ∈ A ] (y ∈ xs) × (¬ y ≡ a))
              → सर्वसमम् a (x ∷ xs) ⊎ (Σ[ y ∈ A ] (y ∈ (x ∷ xs)) × (¬ y ≡ a))
      recurse (inl s)             = inl (p , s)
      recurse (inr (y , m , np))  = inr (y , तत्र m , np)
  ... | no np = inr (x , अत्र , np)

  -- THE THEOREM: the vows leave no freedom on nonempty lists
  एकत्वम् : (e e' : List A → Maybe A)
          → व्रतिन् e → व्रतिन् e'
          → (a : A) (vs : List A)
          → e (a ∷ vs) ≡ e' (a ∷ vs)
  एकत्वम् e e' ve ve' a vs with विभागः a (a ∷ vs)
  ... | inl s =
        व्रतिन्.निर्णयति ve a vs s ∙ sym (व्रतिन्.निर्णयति ve' a vs s)
  ... | inr (x , m , np) =
        व्रतिन्.न-गृह्णाति ve  (a ∷ vs) x a m अत्र np
      ∙ sym (व्रतिन्.न-गृह्णाति ve' (a ∷ vs) x a m अत्र np)
