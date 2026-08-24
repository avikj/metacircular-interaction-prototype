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
-- NaturalMachine.TheStratumRankExistsAndDominationStrictlyLowersIt
--
-- ON THE NAME, since this repository's rule (CLAUDE.md, "File naming",
-- owner, 2026-08-19) is to lead with the tradition's term.  **There is
-- no Indian source term for this object and none is invented.**  The
-- object is the rank of a candidate in iterated non-dominated sorting
-- — Goldberg 1989, and the fast-non-dominated-sort of Deb, Pratap,
-- Agarwal & Meyarivan 2002 — and that is where it comes from.  The
-- naming rule's own guard says to say so rather than to attach a
-- Sanskrit label to material that is not Indian; this file is an
-- instance of that guard, and the English name is a decision, not a
-- default.  (Where the same corpus DOES have the term — ṛṇa-dhana for
-- the debt/asset reading, samacchheda for equalising divisors — the
-- files carry it.)
--
-- ────────────────────────────────────────────────────────────────────
-- Every ordering statement on this line so far says "some earlier
-- stratum": `Beats`, `theStrataAreOrdered`, `OrderedM`.  That is
-- weaker than a rank, and the corpus has recorded the gap for several
-- cycles without closing it.  Closed here.
--
-- WHAT IS PROVED
--
--   rank n xs v       the index of v's stratum: 0 if v is maximal in
--                     the archive, else one more than its rank in the
--                     remainder.  Fuel-recursive, no `Fin`, no
--                     well-founded recursion
--   memberIntoFilterOut
--                     a member failing the predicate is a member of the
--                     complement (arbitrary decidable predicate)
--   rankDominatorIsSmaller
--                     **if w strictly dominates v and both are in the
--                     archive, then `rank w < rank v`** — given enough
--                     fuel, which is `lengthL xs ≤ n`
--
-- **WHY THE FUEL HYPOTHESIS IS NOT A BLEMISH.**  At `n = 0` the rank of
-- everything is 0 and the statement would be false; the hypothesis
-- `lengthL xs ≤ n` makes that case VACUOUS rather than excluded,
-- because a list of length ≤ 0 is empty and has no members.  The same
-- hypothesis is what `fuelSuffices` already needed for termination, so
-- the rank costs no new assumption.
--
-- **WHAT THE RANK BUYS OVER "SOME EARLIER STRATUM".**  A number, hence
-- a comparison that composes: from `rank w < rank v` and
-- `rank z < rank w` one gets `rank z < rank v` by transitivity on ℕ,
-- whereas "beaten by a member of an earlier stratum" needs the whole
-- stratification to chain.  It is also the form in which selection
-- pressure is usually stated.
--
-- WHAT IS NOT CLAIMED.  It is NOT proved that `rank v = k` iff v is a
-- member of the k-th element of `strata` — that needs an indexing
-- function into the list of strata and is a separate statement.  The
-- converse of the theorem is false as stated: `rank w < rank v` does
-- NOT imply w dominates v (members of the same stratum are
-- incomparable, and members of different strata need not be related at
-- all).  Nothing here transports to the MIXED setting; that is the
-- ṛṇa-dhana route and it is a further cycle.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheStratumRankExistsAndDominationStrictlyLowersIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ≤-trans)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (memberToAny)
open import NaturalMachine.OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import NaturalMachine.TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; IsParetoMaximal ; decIsParetoMaximal)
open import NaturalMachine.TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL ; filterOut ; remainder ; theRemainderIsStrictlyShorter)
open import NaturalMachine.TheStratificationTerminatesOnItsOwnLength
  using (lengthZeroGivesNil)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  Into the complement
------------------------------------------------------------------------

memberIntoFilterOut :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Mem a xs → ¬ P a → Mem a (filterOut P d xs)
memberIntoFilterOut P d []       a e       ¬p = ⊥.rec e
memberIntoFilterOut P d (x ∷ xs) a m       ¬p with d x
memberIntoFilterOut P d (x ∷ xs) a (inl q) ¬p | yes px =
  ⊥.rec (¬p (subst P q px))
memberIntoFilterOut P d (x ∷ xs) a (inr r) ¬p | yes _ =
  memberIntoFilterOut P d xs a r ¬p
memberIntoFilterOut P d (x ∷ xs) a (inl q) ¬p | no _ = inl q
memberIntoFilterOut P d (x ∷ xs) a (inr r) ¬p | no _ =
  inr (memberIntoFilterOut P d xs a r ¬p)

------------------------------------------------------------------------
-- 2.  The rank
------------------------------------------------------------------------

rank : ℕ → List (List ℕ) → List ℕ → ℕ
rank zero    xs       v = 0
rank (suc n) []       v = 0
rank (suc n) (x ∷ xs) v with decIsParetoMaximal v (x ∷ xs)
... | yes _ = 0
... | no  _ = suc (rank n (remainder (x ∷ xs)) v)

------------------------------------------------------------------------
-- 3.  A dominator has strictly smaller rank
------------------------------------------------------------------------

rankDominatorIsSmaller :
  (n : ℕ) (xs : List (List ℕ)) (v w : List ℕ)
  → lengthL xs ≤ n
  → Mem v xs → Mem w xs → StrictlyDominates v w
  → rank n xs w < rank n xs v
rankDominatorIsSmaller zero    xs       v w h memV memW sd =
  ⊥.rec (subst (Mem v) (lengthZeroGivesNil xs h) memV)
rankDominatorIsSmaller (suc n) []       v w h memV memW sd = ⊥.rec memV
rankDominatorIsSmaller (suc n) (x ∷ xs) v w h memV memW sd
  with decIsParetoMaximal v (x ∷ xs)
... | yes vmax =
  ⊥.rec (vmax (memberToAny (StrictlyDominates v) w (x ∷ xs) memW sd))
... | no ¬vmax with decIsParetoMaximal w (x ∷ xs)
...   | yes _    = suc-≤-suc zero-≤
...   | no ¬wmax =
  suc-≤-suc
    (rankDominatorIsSmaller n (remainder (x ∷ xs)) v w
      (pred-≤-pred (≤-trans (theRemainderIsStrictlyShorter x xs) h))
      (memberIntoFilterOut (λ u → IsParetoMaximal u (x ∷ xs))
        (λ u → decIsParetoMaximal u (x ∷ xs)) (x ∷ xs) v memV ¬vmax)
      (memberIntoFilterOut (λ u → IsParetoMaximal u (x ∷ xs))
        (λ u → decIsParetoMaximal u (x ∷ xs)) (x ∷ xs) w memW ¬wmax)
      sd)
