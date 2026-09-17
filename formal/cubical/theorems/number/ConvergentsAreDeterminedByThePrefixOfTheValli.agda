{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ConvergentsAreDeterminedByThePrefixOfTheValli
--
-- The SECOND of the three honesty faces recurs for continued-fraction
-- convergents: STABILITY.  A convergent already computed is unchanged by
-- whatever the vall says later ‚î it depends only on the prefix of
-- partial quotients strictly below its index.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHERE THIS SITS
--
-- whether lossless / complete / stable recur for the convergents.
--
--   lossless  answered at 38563467
--             (`TheValliConvergentDeterminantAlternates`)
--   stable    answered here
--   complete  NOT answered, and nothing below bears on it
--
-- `Sthairya.‡‡‡‡à‡∞‡‡Ø-‡ó‡‡ø` is "a resolved answer is unchanged by more
-- grant".  The grant here is how much of the vall has been read, and
-- ¬ß2 is exactly that statement: two quotient sequences agreeing below k
-- give the same k-th convergent, so reading further never revises what
-- was already produced.
--
-- SOURCING LIMIT. Nothing here is a reading of Gaitapda 32‚ì33.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module ConvergentsAreDeterminedByThePrefixOfTheValli where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; ‚â§-refl ; ‚â§-suc)
open import Cubical.Data.Int using (‚Ñ§ ; _+_ ; _¬∑_ ; _-_)

open import TheValliConvergentDeterminantAlternates
  using (num ; den ; det)

------------------------------------------------------------------------
-- 1.  The grant: how much of the vall has been read
------------------------------------------------------------------------

Agree : (a b : ‚Ñï ‚Üí ‚Ñ§) ‚Üí ‚Ñï ‚Üí Type
Agree a b n = (j : ‚Ñï) ‚Üí j < n ‚Üí a j ‚â° b j

weaken : (a b : ‚Ñï ‚Üí ‚Ñ§) (n : ‚Ñï) ‚Üí Agree a b (suc n) ‚Üí Agree a b n
weaken a b n h j j<n = h j (‚â§-suc j<n)

------------------------------------------------------------------------
-- 2.  Convergents depend only on the prefix strictly below their index
------------------------------------------------------------------------

numPrefix :
  (a b : ‚Ñï ‚Üí ‚Ñ§) (p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ : ‚Ñ§) (k : ‚Ñï) ‚Üí Agree a b k
  ‚Üí num a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k ‚â° num b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k
numPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ zero          _ = refl
numPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc zero)    _ = refl
numPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc (suc k)) h =
  cong‚ÇÇ _+_
    (cong‚ÇÇ _¬∑_
      (h (suc k) ‚â§-refl)
      (numPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k) (weaken a b (suc k) h)))
    (numPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k (weaken a b k (weaken a b (suc k) h)))

denPrefix :
  (a b : ‚Ñï ‚Üí ‚Ñ§) (p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ : ‚Ñ§) (k : ‚Ñï) ‚Üí Agree a b k
  ‚Üí den a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k ‚â° den b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k
denPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ zero          _ = refl
denPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc zero)    _ = refl
denPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc (suc k)) h =
  cong‚ÇÇ _+_
    (cong‚ÇÇ _¬∑_
      (h (suc k) ‚â§-refl)
      (denPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k) (weaken a b (suc k) h)))
    (denPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k (weaken a b k (weaken a b (suc k) h)))

-- the determinant reaches one index further, so it needs one more of the
-- vall ‚î stated rather than glossed over
detPrefix :
  (a b : ‚Ñï ‚Üí ‚Ñ§) (p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ : ‚Ñ§) (k : ‚Ñï) ‚Üí Agree a b (suc k)
  ‚Üí det a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k ‚â° det b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k
detPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k h =
  cong‚ÇÇ _-_
    (cong‚ÇÇ _¬∑_
      (numPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k (weaken a b k h))
      (denPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k) h))
    (cong‚ÇÇ _¬∑_
      (numPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ (suc k) h)
      (denPrefix a b p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k (weaken a b k h)))

------------------------------------------------------------------------
-- 3.  What the seeds cost, stated because it is easy to hide
--
-- ¬ß2 holds for ARBITRARY seeds, and index 1 is `p‚` ‚î independent of the
-- vall, hence `refl`.  Under the standard seeding p‚ = a 0 that is no
-- longer so: instantiating p‚ to `a 0` reintroduces a dependence on the
-- vall at index 1, and ¬ß2 then applies only to sequences that already
-- agree at 0.  Keeping the seeds as parameters is what makes that
-- visible; it is not generality for its own sake.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  Two of three
--
-- lossless (38563467) and stable (here) both recur for the convergents.
-- COMPLETE does not follow from either and is not addressed: it is the
-- claim that enough grant always resolves, which for the vall is the
-- termination of the expansion of a rational with the last convergent
-- equal to it ‚î a fact about the kuaka, not about this recurrence.
-- Two faces out of three is two thirds of the tag.  The tag stays open.
------------------------------------------------------------------------
