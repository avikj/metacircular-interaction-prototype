-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्थूलभारः — the coarse weight is the sum over the observation fibre,
-- and branch multiplicity is the whole of it.
--
-- TERM.  स्थूल / सूक्ष्म (gross / subtle) is the standard Sanskrit pair
-- for the coarse and the fine grain of an object; भार is weight, load.
-- The compound स्थूल-भार, "the coarse weight", is built HERE and no
-- source is claimed for it (CLAUDE.md, naming rule, note 2).
--
-- SEED.  The owner's transmission of 2026-08-23, the Born ladder,
-- step 2 (fibre additivity) together with the "rational coarse
-- weights" observation:
--
--     m + n micro-outcomes, one transitive orbit, weight 1/(m+n) each;
--     a coarse observation groups m as event A and n as event B;
--     then W(A) = m/(m+n) and W(B) = n/(m+n), by pushforward.
--
-- FORMALIZED WITHOUT DIVISION.  The carrier language makes the
-- rational statement exact with NO division and NO rationals: if h is
-- an (a+b)-th part of 𝟙 (गुणः h ≡ 𝟙 over the whole orbit), then the
-- coarse weight of the m-branch IS the m-fold sum गुणः h over that
-- branch.  "m/(m+n)" is a NAME for m·h under (m+n)·h ≡ 𝟙; the theorem
-- is the multiplicity identity, and the division is bookkeeping that
-- never has to happen.  That is why the result composes with
-- `SamaVibhaga` (which forces w = const h) rather than presupposing ℚ.
--
-- THE OBJECTS.  Micro-outcomes: X = Fin (suc a) ⊎ Fin (suc b) — the
-- coarse observation is literally the tag, स्थूलः = Bool by inl/inr.
-- The fibre of स्थूलः over true is the left summand; the coarse weight
-- is total weight of that summand.  This presentation makes "sum over
-- the fibre" definitional rather than a subset-enumeration lemma.
--
-- WHAT IS PROVED.
--
--   स्थूलयोगः      the total over the disjoint sum is the sum of the
--                  two branch totals — fibre additivity, proved by
--                  induction on the left branch, consuming exactly ONE
--                  algebraic law: associativity of _+ᵂ_, taken as a
--                  hypothesis.  (SamaVibhaga consumed none; the ladder
--                  spends its algebra one law at a time, and the
--                  ledger of what each step costs is part of the
--                  result.)
--   शाखाभारः       on the uniform weight const h, the coarse weight of
--                  the left branch is गुणः a h (that is, (a+1)·h) and
--                  of the right branch गुणः b h — multiplicity is the
--                  whole content.
--   पूर्णता        and the two coarse weights recompose to 𝟙 under the
--                  orbit normalization (suc a + suc b)·h ≡ 𝟙.
--
-- WHAT IS NOT CLAIMED.  Ladder steps 3–5 (equal-amplitude refinement,
-- the general rational law over arbitrary partitions, continuity /
-- noncontextual extension) are untouched and open.  Nothing here
-- chooses a partition: the ⊎-presentation is one coarse observation,
-- not the theory of all of them.
------------------------------------------------------------------------

module SthulaBhara_TheCoarseWeightIsTheSumOverTheObservationFibreAndMultiplicityIsTheWholeOfIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; गुणः ; total-const)

private
  variable
    ℓ : Level

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z)
         (a b : ℕ) where

  -- micro-outcomes, with the coarse observation as the tag.
  सूक्ष्मम् : Type
  सूक्ष्मम् = Fin (suc a) ⊎ Fin (suc b)

  स्थूलः : सूक्ष्मम् → Bool
  स्थूलः (inl _) = true
  स्थूलः (inr _) = false

  -- the fold of a left branch onto a residue R — "sum over the fibre
  -- of true, then whatever the rest weighs".
  शेषयोगः : W → (k : ℕ) → (Fin (suc k) → W) → W
  शेषयोगः R zero    u = u fzero +ᵂ R
  शेषयोगः R (suc k) u = u fzero +ᵂ शेषयोगः R k (λ i → u (fsuc i))

  -- the total over the disjoint sum: left fibre folded onto the right
  -- fibre's total.
  उभययोगः : (सूक्ष्मम् → W) → W
  उभययोगः w = शेषयोगः (total _+ᵂ_ b (λ j → w (inr j))) a (λ i → w (inl i))

  -- the fold IS branch-total-plus-residue.  One induction, consuming
  -- only assoc.
  शेषयोग-न्यायः : (R : W) (k : ℕ) (u : Fin (suc k) → W)
               → शेषयोगः R k u ≡ (total _+ᵂ_ k u) +ᵂ R
  शेषयोग-न्यायः R zero    u = refl
  शेषयोग-न्यायः R (suc k) u =
      cong (u fzero +ᵂ_) (शेषयोग-न्यायः R k (λ i → u (fsuc i)))
    ∙ assoc (u fzero) (total _+ᵂ_ k (λ i → u (fsuc i))) R

  -- fibre additivity: the whole is the left fibre's total plus the
  -- right fibre's total.
  स्थूलयोगः : (w : सूक्ष्मम् → W)
            → उभययोगः w ≡ (total _+ᵂ_ a (λ i → w (inl i)))
                          +ᵂ (total _+ᵂ_ b (λ j → w (inr j)))
  स्थूलयोगः w = शेषयोग-न्यायः (total _+ᵂ_ b (λ j → w (inr j))) a (λ i → w (inl i))

  -- on the uniform weight, each coarse weight is its multiplicity.
  शाखाभारः : (h : W)
           → total _+ᵂ_ a (λ _ → h) ≡ गुणः _+ᵂ_ a h
  शाखाभारः h = total-const _+ᵂ_ a h

  -- and under the orbit normalization the two branches recompose to 𝟙:
  -- (a+1)·h +ᵂ (b+1)·h ≡ total of the constant family over the sum.
  पूर्णता : (𝟙 h : W)
          → उभययोगः (λ _ → h) ≡ 𝟙
          → (गुणः _+ᵂ_ a h) +ᵂ (गुणः _+ᵂ_ b h) ≡ 𝟙
  पूर्णता 𝟙 h norm =
      cong₂ _+ᵂ_ (sym (total-const _+ᵂ_ a h)) (sym (total-const _+ᵂ_ b h))
    ∙ sym (स्थूलयोगः (λ _ → h))
    ∙ norm
