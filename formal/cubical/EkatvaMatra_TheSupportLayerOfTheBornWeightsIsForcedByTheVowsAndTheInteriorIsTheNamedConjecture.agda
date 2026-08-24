-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- एकत्व-मात्रा — ekatva (uniqueness) of the mātrā (measure/weight).
-- Compound built here, 2026-08-23, for program ४ of YugaParivartana
-- (Born as the ethics of information).  Sources as EkatvaNirnaya /
-- AvaktavyaPrasava give them; nothing further claimed.
--
-- THE NEXT STONE, taken.  EkatvaNirnaya proved the QUALITATIVE skeleton:
-- a rule `e : List A → Maybe A` obeying the two vows (decide-on-unanimity,
-- take-nothing-on-disagreement) is forced uniquely on nonempty
-- contentions.  That lives on the all-or-nothing carrier `Maybe A`.  This
-- module lifts the uniqueness to an actual WEIGHT carrier `W` — the first
-- move of the quantitative layer — and states the full Born conjecture as
-- a precise type, unproved and marked as such.
--
-- WHAT IS PROVED (kernel-checked, no postulates, no holes):
--   the SUPPORT layer of the weights is forced.  A weight rule
--   `q : List A → A → W` obeying the quantitative vows
--     • तत्-मात्रा   — unanimity for a gives a the unit weight 𝟙;
--     • अन्य-मात्रा  — unanimity for a gives every OTHER result 𝟘
--                      (ahiṃsā of assertion: no weight on the unasserted);
--     • शून्य-मात्रा — any disagreement gives every result 𝟘
--                      (take nothing not unanimously given)
--   is determined COMPLETELY on nonempty contentions: any two such rules
--   agree at every result (एकत्वम्-मात्रा), by the same decidable
--   dichotomy EkatvaNirnaya used.  So the {𝟘,𝟙}-valued (support) part of
--   the Born weights has no rival within the vows — exactly as the
--   qualitative layer, now on weights.
--
-- WHAT IS NOT PROVED, and is stated honestly as a conjecture type:
--   `BornInteriorConjecture` — the INTERIOR.  Replace the all-or-nothing
--   vows by (i) normalisation, (ii) additivity across a refinement of the
--   contention (ahiṃsā quantitative: a coarse outcome's weight is the sum
--   of its parts — no distinction destroyed), and (iii) permutation
--   invariance (anekānta: no standpoint absolutised); then on a carrier
--   rich enough to be amplitudes the weights are forced to |⟨·⟩|².  This
--   is Program ४'s open result.  THE WALL, named: this is Gleason
--   territory (Gleason 1957 — non-contextual measures on projections are
--   ⟨ψ|·|ψ⟩ in dimension ≥ 3, and FAIL in dimension 2, needing Busch's
--   POVM form).  The discrete dichotomy that closes the support layer
--   CANNOT close the interior — the interior is a continuum and the
--   dichotomy is exactly a decidable two-case split.  So the conjecture
--   is stated over an abstract weight ring as the honest target; proving
--   it even at qubit-pair scale (dimension 4 ≥ 3) is the open stone.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical library).
------------------------------------------------------------------------

module EkatvaMatra_TheSupportLayerOfTheBornWeightsIsForcedByTheVowsAndTheInteriorIsTheNamedConjecture where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Relation.Nullary using (¬_ ; Discrete ; yes ; no)

private
  variable
    ℓ ℓ' : Level

module _ {A : Type ℓ} (disc : Discrete A) where

  data _∈_ (x : A) : List A → Type ℓ where
    अत्र : ∀ {ys}   → x ∈ (x ∷ ys)
    तत्र : ∀ {y ys} → x ∈ ys → x ∈ (y ∷ ys)

  सर्वसमम् : A → List A → Type ℓ
  सर्वसमम् a []       = Unit*
  सर्वसमम् a (x ∷ xs) = (x ≡ a) × सर्वसमम् a xs

  -- over a discrete type, every list is constant-at-a or exhibits a differer
  विभागः : (a : A) (vs : List A)
         → सर्वसमम् a vs ⊎ (Σ[ x ∈ A ] (x ∈ vs) × (¬ x ≡ a))
  विभागः a [] = inl tt*
  विभागः a (x ∷ xs) with disc x a
  ... | yes p = recurse (विभागः a xs)
    where
      recurse : सर्वसमम् a xs ⊎ (Σ[ y ∈ A ] (y ∈ xs) × (¬ y ≡ a))
              → सर्वसमम् a (x ∷ xs) ⊎ (Σ[ y ∈ A ] (y ∈ (x ∷ xs)) × (¬ y ≡ a))
      recurse (inl s)            = inl (p , s)
      recurse (inr (y , m , np)) = inr (y , तत्र m , np)
  ... | no np = inr (x , अत्र , np)

  ----------------------------------------------------------------------
  -- the weight carrier and the quantitative vows on the support layer
  ----------------------------------------------------------------------

  module _ {W : Type ℓ'} (𝟘 𝟙 : W) where

    record मात्रिन् (q : List A → A → W) : Type (ℓ-max ℓ ℓ') where
      field
        तत्-मात्रा   : (a : A) (vs : List A)
                     → सर्वसमम् a (a ∷ vs) → q (a ∷ vs) a ≡ 𝟙
        अन्य-मात्रा  : (a r : A) (vs : List A)
                     → सर्वसमम् a (a ∷ vs) → ¬ r ≡ a → q (a ∷ vs) r ≡ 𝟘
        शून्य-मात्रा : (vs : List A) (x y : A)
                     → x ∈ vs → y ∈ vs → ¬ x ≡ y → (r : A) → q vs r ≡ 𝟘

    -- THE THEOREM: the support layer of the weights is forced.
    एकत्वम्-मात्रा : (q q' : List A → A → W)
                  → मात्रिन् q → मात्रिन् q'
                  → (a : A) (vs : List A) (r : A)
                  → q (a ∷ vs) r ≡ q' (a ∷ vs) r
    एकत्वम्-मात्रा q q' mq mq' a vs r with विभागः a (a ∷ vs)
    ... | inr (x , m , np) =
              मात्रिन्.शून्य-मात्रा mq  (a ∷ vs) x a m अत्र np r
          ∙ sym (मात्रिन्.शून्य-मात्रा mq' (a ∷ vs) x a m अत्र np r)
    ... | inl s with disc r a
    ...   | yes p =
                cong (q (a ∷ vs)) p ∙ मात्रिन्.तत्-मात्रा mq a vs s
              ∙ sym (मात्रिन्.तत्-मात्रा mq' a vs s) ∙ sym (cong (q' (a ∷ vs)) p)
    ...   | no np =
                मात्रिन्.अन्य-मात्रा mq  a r vs s np
              ∙ sym (मात्रिन्.अन्य-मात्रा mq' a r vs s np)

  ----------------------------------------------------------------------
  -- the interior, stated honestly as a conjecture type (not inhabited)
  ----------------------------------------------------------------------

  -- A quantitative interior rule assigns weights that need not be {𝟘,𝟙}.
  -- The conjecture: under normalisation + additivity (ahiṃsā) +
  -- permutation invariance (anekānta) on a carrier rich enough to be
  -- amplitudes, any two such rules agree — Born uniqueness.  Stated over
  -- an abstract weight ring `W` with the vow-record supplied by the
  -- caller; NOT proved here (Gleason wall, see header).  It is a Type, so
  -- writing it costs nothing and asserts nothing until inhabited.
  BornInteriorConjecture :
      {W : Type ℓ'}
      (Vow : (List A → A → W) → Type ℓ')          -- the interior vows
    → Type (ℓ-max ℓ ℓ')
  BornInteriorConjecture {W = W} Vow =
      (q q' : List A → A → W) → Vow q → Vow q'
    → (a : A) (vs : List A) (r : A) → q (a ∷ vs) r ≡ q' (a ∷ vs) r
