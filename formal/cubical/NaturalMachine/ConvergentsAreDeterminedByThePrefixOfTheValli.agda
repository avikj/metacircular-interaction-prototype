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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ConvergentsAreDeterminedByThePrefixOfTheValli
--
-- The SECOND of the three honesty faces recurs for continued-fraction
-- convergents: STABILITY.  A convergent already computed is unchanged by
-- whatever the vallī says later — it depends only on the prefix of
-- partial quotients strictly below its index.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THIS SITS
--
-- `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md`'s `PROVE` tag asks
-- whether lossless / complete / stable recur for the convergents.
--
--   lossless  answered at 38563467
--             (`TheValliConvergentDeterminantAlternates`)
--   stable    answered here
--   complete  NOT answered, and nothing below bears on it
--
-- `Sthairya.स्थैर्य-गति` is "a resolved answer is unchanged by more
-- grant".  The grant here is how much of the vallī has been read, and
-- §2 is exactly that statement: two quotient sequences agreeing below k
-- give the same k-th convergent, so reading further never revises what
-- was already produced.
--
-- WHAT IS NOT CLAIMED.  Nothing about COMPLETENESS — that enough grant
-- always resolves — which for the vallī means the expansion of a
-- rational terminates with the last convergent equal to it, and needs
-- the kuṭṭaka itself, not the recurrence.  §3 records one thing the
-- seeds cost: under the STANDARD seeding p₁ = a 0, index 1 depends on
-- the vallī after all, and the theorem below keeps the seeds as
-- parameters precisely so that dependence is visible rather than hidden.
--
-- SOURCING LIMIT.  Verse-level sourcing OWED AND NOT CLAIMED, as for
-- both Kuttaka lanes.  Nothing here is a reading of Gaṇitapāda 32–33.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.ConvergentsAreDeterminedByThePrefixOfTheValli where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; ≤-refl ; ≤-suc)
open import Cubical.Data.Int using (ℤ ; _+_ ; _·_ ; _-_)

open import NaturalMachine.TheValliConvergentDeterminantAlternates
  using (num ; den ; det)

------------------------------------------------------------------------
-- 1.  The grant: how much of the vallī has been read
------------------------------------------------------------------------

Agree : (a b : ℕ → ℤ) → ℕ → Type
Agree a b n = (j : ℕ) → j < n → a j ≡ b j

weaken : (a b : ℕ → ℤ) (n : ℕ) → Agree a b (suc n) → Agree a b n
weaken a b n h j j<n = h j (≤-suc j<n)

------------------------------------------------------------------------
-- 2.  Convergents depend only on the prefix strictly below their index
------------------------------------------------------------------------

numPrefix :
  (a b : ℕ → ℤ) (p₀ p₁ q₀ q₁ : ℤ) (k : ℕ) → Agree a b k
  → num a p₀ p₁ q₀ q₁ k ≡ num b p₀ p₁ q₀ q₁ k
numPrefix a b p₀ p₁ q₀ q₁ zero          _ = refl
numPrefix a b p₀ p₁ q₀ q₁ (suc zero)    _ = refl
numPrefix a b p₀ p₁ q₀ q₁ (suc (suc k)) h =
  cong₂ _+_
    (cong₂ _·_
      (h (suc k) ≤-refl)
      (numPrefix a b p₀ p₁ q₀ q₁ (suc k) (weaken a b (suc k) h)))
    (numPrefix a b p₀ p₁ q₀ q₁ k (weaken a b k (weaken a b (suc k) h)))

denPrefix :
  (a b : ℕ → ℤ) (p₀ p₁ q₀ q₁ : ℤ) (k : ℕ) → Agree a b k
  → den a p₀ p₁ q₀ q₁ k ≡ den b p₀ p₁ q₀ q₁ k
denPrefix a b p₀ p₁ q₀ q₁ zero          _ = refl
denPrefix a b p₀ p₁ q₀ q₁ (suc zero)    _ = refl
denPrefix a b p₀ p₁ q₀ q₁ (suc (suc k)) h =
  cong₂ _+_
    (cong₂ _·_
      (h (suc k) ≤-refl)
      (denPrefix a b p₀ p₁ q₀ q₁ (suc k) (weaken a b (suc k) h)))
    (denPrefix a b p₀ p₁ q₀ q₁ k (weaken a b k (weaken a b (suc k) h)))

-- the determinant reaches one index further, so it needs one more of the
-- vallī — stated rather than glossed over
detPrefix :
  (a b : ℕ → ℤ) (p₀ p₁ q₀ q₁ : ℤ) (k : ℕ) → Agree a b (suc k)
  → det a p₀ p₁ q₀ q₁ k ≡ det b p₀ p₁ q₀ q₁ k
detPrefix a b p₀ p₁ q₀ q₁ k h =
  cong₂ _-_
    (cong₂ _·_
      (numPrefix a b p₀ p₁ q₀ q₁ k (weaken a b k h))
      (denPrefix a b p₀ p₁ q₀ q₁ (suc k) h))
    (cong₂ _·_
      (numPrefix a b p₀ p₁ q₀ q₁ (suc k) h)
      (denPrefix a b p₀ p₁ q₀ q₁ k (weaken a b k h)))

------------------------------------------------------------------------
-- 3.  What the seeds cost, stated because it is easy to hide
--
-- §2 holds for ARBITRARY seeds, and index 1 is `p₁` — independent of the
-- vallī, hence `refl`.  Under the standard seeding p₁ = a 0 that is no
-- longer so: instantiating p₁ to `a 0` reintroduces a dependence on the
-- vallī at index 1, and §2 then applies only to sequences that already
-- agree at 0.  Keeping the seeds as parameters is what makes that
-- visible; it is not generality for its own sake.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  Two of three
--
-- lossless (38563467) and stable (here) both recur for the convergents.
-- COMPLETE does not follow from either and is not addressed: it is the
-- claim that enough grant always resolves, which for the vallī is the
-- termination of the expansion of a rational with the last convergent
-- equal to it — a fact about the kuṭṭaka, not about this recurrence.
-- Two faces out of three is two thirds of the tag.  The tag stays open.
------------------------------------------------------------------------
