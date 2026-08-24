-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनपेक्षा — मानं यं पक्षं न पश्यति, तत्र सर्वं पदं स्वयमेव संरक्षति ।
--
-- (non-dependence: the coordinate an invariant cannot see is the one in
--  which every step conserves it by itself.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THIS COMES FROM.  `punaragamana/…/AntyaSamskara_…` instantiates
-- the carrier law at Mādhava's end-correction: base = (index of the
-- correction , the point it is evaluated at), carried = that convergent's
-- स्थौल्य, coarseness.  Its finding is the exact mirror of the प्रस्तार
-- module in the same library — there the carried datum sees the WHOLE
-- base and the base may be dropped; here the base has a coordinate the
-- carried datum CANNOT SEE:
--
--     स्थौल्य-मूल-अदृश्यम् : (k : ℕ) (n n' : ℤ) → स्थौल्य (k , n) ≡ स्थौल्य (k , n')
--
-- and it reads that blindness as the correctness criterion itself:
--
--     "A correction that misses by a fixed integer is a correction; one
--      that misses by something growing with n is an estimate.  That the
--      argument is invisible to the coarseness IS the statement that
--      these are corrections, and it is why the Kerala mathematicians
--      could find them without any analysis: they were solving a
--      difference equation in closed form."
--
-- §२–§४ below are that as a law rather than an instance.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT BUYS, and it is an operational thing, not a tidier statement.
--
-- `Dhruva_….संरक्षणम्` is the per-step condition `(a : A) → f (Φ a) ≡ f a`,
-- and `Kaksya_…` carries a conserved quantity along a whole orbit from
-- it.  Both take conservation as a HYPOTHESIS about the step, to be
-- checked for each Φ one meets.
--
-- Blindness is checked ONCE, about the invariant, and then EVERY step
-- that moves only the invisible coordinate conserves — automatically, for
-- all of them at once, with nothing to verify per step (§३).  That is the
-- difference between a property re-established at each move and a
-- property of the design, and it is what "uniform in a parameter" means
-- when it is made precise: an algorithm is uniform in a coordinate
-- exactly when its invariant does not read that coordinate.
--
-- §४ is the converse, so the criterion is not merely sufficient: an
-- invariant blind to a coordinate FACTORS through the rest, and one that
-- factors is blind.  Blindness and factorisation are the same property,
-- which is why it can be checked once.
--
-- §५ is the contrast that makes it a distinction: the second projection
-- is NOT blind to its own coordinate, and a step moving that coordinate
-- provably fails to conserve.  Without it, §३ would be true and empty.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES.  Mādhava of Saṅgamagrāma (c. 1340–1425), transmitted in
-- Nīlakaṇṭha, तन्त्रसङ्ग्रहः २.२७१–२७४ (1501) and Jyeṣṭhadeva,
-- युक्तिभाषा (c. 1530) — the अन्त्यसंस्कार and स्थौल्य.  NOT CLAIMED: that
-- any of them proved anything below, or that any text has been opened
-- here; the citation is carried from the punaragamana module named above
-- and from `formal/cubical/NaturalMachine/AntyaSamskaraSthaulya.agda`,
-- is second-hand, and is owed at verse level.  Nothing here is about π,
-- and there is no limit, no ℝ and no error bound in this file.
--
-- अनपेक्षा is ordinary Sanskrit for non-dependence and no text is claimed
-- for the compound.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Anapeksa_BlindnessToACoordinateIsAFactorisationSoEveryStepInItConservesForFree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

module _ {A C B : Type ℓ} (f : A × C → B) where

  ------------------------------------------------------------------------
  -- १ · अनपेक्षा — the invariant does not read the second coordinate.
  ------------------------------------------------------------------------

  अनपेक्षा : Type ℓ
  अनपेक्षा = (a : A) (c c' : C) → f (a , c) ≡ f (a , c')

  ------------------------------------------------------------------------
  -- २ · स्थिति-पदम् — a step that moves ONLY the invisible coordinate.
  --     The first coordinate is untouched, which is the only thing the
  --     invariant can see, so §३ needs nothing about ψ at all.
  ------------------------------------------------------------------------

  पार्श्व-पदम् : (C → C) → (A × C → A × C)
  पार्श्व-पदम् ψ x = fst x , ψ (snd x)

  ------------------------------------------------------------------------
  -- ३ · सर्व-पदं संरक्षति — EVERY SUCH STEP CONSERVES, for free.
  --
  --     Quantified over ψ: one blindness proof discharges the conservation
  --     condition for all of them simultaneously.  `Dhruva`'s संरक्षणम् is
  --     a hypothesis per step; here it is a conclusion, once.
  ------------------------------------------------------------------------

  अनपेक्षा→संरक्षणम् : अनपेक्षा → (ψ : C → C) (x : A × C)
                     → f (पार्श्व-पदम् ψ x) ≡ f x
  अनपेक्षा→संरक्षणम् blind ψ x = blind (fst x) (ψ (snd x)) (snd x)

  -- and therefore along every finite trajectory of every such step
  पुनरावृत्तिः : (C → C) → ℕ → A × C → A × C
  पुनरावृत्तिः ψ zero    x = x
  पुनरावृत्तिः ψ (suc n) x = पुनरावृत्तिः ψ n (पार्श्व-पदम् ψ x)

  अनपेक्षा→कक्ष्या : अनपेक्षा → (ψ : C → C) (n : ℕ) (x : A × C)
                   → f (पुनरावृत्तिः ψ n x) ≡ f x
  अनपेक्षा→कक्ष्या blind ψ zero    x = refl
  अनपेक्षा→कक्ष्या blind ψ (suc n) x =
    अनपेक्षा→कक्ष्या blind ψ n (पार्श्व-पदम् ψ x)
    ∙ अनपेक्षा→संरक्षणम् blind ψ x

  ------------------------------------------------------------------------
  -- ४ · अनपेक्षा IS FACTORISATION, both directions.  This is why the check
  --     is once and not per step: there is one property here, not two.
  ------------------------------------------------------------------------

  कारणम् : Type ℓ
  कारणम् = Σ[ g ∈ (A → B) ] ((x : A × C) → f x ≡ g (fst x))

  अनपेक्षा→कारणम् : C → अनपेक्षा → कारणम्
  अनपेक्षा→कारणम् c₀ blind = (λ a → f (a , c₀)) , (λ x → blind (fst x) (snd x) c₀)

  कारणम्→अनपेक्षा : कारणम् → अनपेक्षा
  कारणम्→अनपेक्षा (g , h) a c c' = h (a , c) ∙ sym (h (a , c'))

------------------------------------------------------------------------
-- ५ · दृश्यम् — the contrast, so §३ is a distinction and not a vacuity.
--
--     The second projection reads exactly the coordinate §१ forbids
--     reading.  It is not blind, and `not` moving that coordinate
--     provably fails to conserve it.
------------------------------------------------------------------------

द्वितीयम् : ℕ × Bool → Bool
द्वितीयम् = snd

न-अनपेक्षा : ¬ (अनपेक्षा द्वितीयम्)
न-अनपेक्षा blind = true≢false (blind zero true false)

-- and the step that flips it does not conserve
विपर्यासः : Bool → Bool
विपर्यासः true  = false
विपर्यासः false = true

न-संरक्षणम् : ¬ (द्वितीयम् (पार्श्व-पदम् द्वितीयम् विपर्यासः (zero , true))
              ≡ द्वितीयम् (zero , true))
न-संरक्षणम् = true≢false ∘ sym
  where
  _∘_ : {X Y Z : Type₀} → (Y → Z) → (X → Y) → X → Z
  (g ∘ h) x = g (h x)
