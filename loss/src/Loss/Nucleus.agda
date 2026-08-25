{-# OPTIONS --cubical --safe --guardedness #-}

-- Punarāgamana · Nucleus
--
-- Where Carrier and Orbit meet: the carrier construction commutes with taking
-- the whole infinite trajectory, not merely with one step.
--
-- Φ-square (Carrier.agda) says the square closes for a single application of
-- Φ.  That does not by itself say anything about the orbit, because an orbit
-- is a coinductive object and equality of coinductive objects is not implied
-- by agreement of any finite prefix.  So each statement here is proved as a
-- bisimulation — corecursively, one head at a time — and then turned into a
-- path by `bisim`.
--
-- The transport version is where uaβ earns its place: transport along ua does
-- not reduce on a neutral variable, so `transport-orbit≈` cannot close its
-- head by refl the way the other two can.  It closes by
-- carry-transport-descend, i.e. by the β rule.

module Loss.Nucleus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat

open import Loss.Carrier
open import Loss.Orbit

private
  variable
    ℓ : Level

module _ {A B : Type ℓ} (f : A → B) (Φ : A → A) where

  -- Descending pointwise along an orbit of Φ is the orbit of Φ-carrier.
  descend-orbit≈ : (a : A)
                 → mapO (descend f) (unfold Φ a) ≈ unfold (Φ-carrier f Φ) (descend f a)
  ≈here (descend-orbit≈ a) = refl
  ≈next (descend-orbit≈ a) = descend-orbit≈ (Φ a)

  descend-orbit : (a : A)
                → mapO (descend f) (unfold Φ a) ≡ unfold (Φ-carrier f Φ) (descend f a)
  descend-orbit a = bisim (descend-orbit≈ a)

  -- …and ascending pointwise brings it back.
  ascend-orbit≈ : (a : A)
                → mapO (ascend f) (unfold (Φ-carrier f Φ) (descend f a)) ≈ unfold Φ a
  ≈here (ascend-orbit≈ a) = refl
  ≈next (ascend-orbit≈ a) = ascend-orbit≈ (Φ a)

  ascend-orbit : (a : A)
               → mapO (ascend f) (unfold (Φ-carrier f Φ) (descend f a)) ≡ unfold Φ a
  ascend-orbit a = bisim (ascend-orbit≈ a)

  -- The same, but along the univalent transport rather than along descend.
  -- The head is uaβ, not refl.
  transport-orbit≈ : (a : A)
                   → mapO (carry-transport f) (unfold Φ a) ≈ mapO (descend f) (unfold Φ a)
  ≈here (transport-orbit≈ a) = carry-transport-descend f a
  ≈next (transport-orbit≈ a) = transport-orbit≈ (Φ a)

  transport-orbit : (a : A)
                  → mapO (carry-transport f) (unfold Φ a) ≡ unfold (Φ-carrier f Φ) (descend f a)
  transport-orbit a = bisim (transport-orbit≈ a) ∙ descend-orbit a

  -- The finite view agrees: the n-th element of the carrier orbit is the
  -- descent of the n-th iterate on the base.
  orbit-lookup : (a : A) (n : ℕ)
               → lookup (unfold (Φ-carrier f Φ) (descend f a)) n ≡ descend f (iterate Φ n a)
  orbit-lookup a n = unfold-lookup (Φ-carrier f Φ) (descend f a) n ∙ step a n
    where
      step : (a : A) (n : ℕ)
           → iterate (Φ-carrier f Φ) n (descend f a) ≡ descend f (iterate Φ n a)
      step a zero    = refl
      step a (suc n) = step (Φ a) n
