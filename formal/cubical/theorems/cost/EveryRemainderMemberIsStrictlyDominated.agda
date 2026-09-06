{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryRemainderMemberIsStrictlyDominated
--
-- `TheStratificationTerminatesOnItsOwnLength` reduced the Pareto line's
-- whole remainder to three properties of the OUTPUT:
--
--   "(1) COVERAGE … (2) DISJOINTNESS … (3) ORDER: nothing says a member
--    of an earlier layer relates by domination to a member of a later
--    one — which is the property that would make 'stratification' mean
--    what §5.2 wants."
--
-- (3) is the one that matters, and this is its first half.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   filterOutOnlyKeepsNonSatisfiers
--                the complement of the filter keeps exactly what fails
--                the predicate — the mirror of the soundness lemma the
--                measure module already had
--   anyToMember  an `Any` yields a witness TOGETHER WITH its membership,
--                which plain `anyToΣ` discards
--   everyRemainderMemberIsStrictlyDominated
--                every member of `remainder xs` is strictly dominated
--                by a member OF `xs`
--
-- **The double negation is the whole difficulty and it is decidable
-- away.**  `IsParetoMaximal v xs` is `¬ Any (StrictlyDominates v) xs`,
-- so failing it gives `¬ ¬ Any …`, not `Any …`.  The dominator is
-- recovered only because `decAny decStrictlyDominates` makes that `Any`
-- DECIDABLE, hence stable.  This is the fourth cycle on this line to
-- turn on the same decision, and it is the reason the decision was
-- worth proving first.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  A filter's complement keeps the non-satisfiers, and a
-- decidable proposition is stable; both elementary.
--
-- THE SCOPE, EXACTLY — and the second half of (3) is the real
-- one.  The dominator produced here lies in `xs`, NOT necessarily in
-- `stratum xs`.  Strengthening it needs a RELATIVISED maximality
-- lemma — for any `v` in `xs` there is a maximal `m` in `xs` with
-- `v ≼ m` — which is `maximalExists` threaded through an extra
-- parameter and is NOT proved.  Until that exists, "the layers are
-- ordered by domination" is not established: what is established is
-- that nothing dropped from a layer was undominated in the archive it
-- was dropped from.  (1) COVERAGE and (2) DISJOINTNESS are untouched.
-- Costs remain unflipped on this line.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module EveryRemainderMemberIsStrictlyDominated where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Dec→Stable)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; decAny)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; decStrictlyDominates ; IsParetoMaximal
        ; decIsParetoMaximal)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The complement keeps exactly the non-satisfiers
------------------------------------------------------------------------

AllL : (P : A → Type) → List A → Type
AllL P []       = Unit
AllL P (x ∷ xs) = P x × AllL P xs

filterOutOnlyKeepsNonSatisfiers :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A)
  → AllL (λ a → ¬ P a) (filterOut P d xs)
filterOutOnlyKeepsNonSatisfiers P d []       = tt
filterOutOnlyKeepsNonSatisfiers P d (x ∷ xs) with d x
... | yes _ = filterOutOnlyKeepsNonSatisfiers P d xs
... | no ¬p = ¬p , filterOutOnlyKeepsNonSatisfiers P d xs

allAtMemberL :
  (P : A → Type) (xs : List A) (a : A)
  → AllL P xs → Any (λ y → y ≡ a) xs → P a
allAtMemberL P []       a _          e       = ⊥.rec e
allAtMemberL P (x ∷ xs) a (p , _)    (inl q) = subst P q p
allAtMemberL P (x ∷ xs) a (_ , rest) (inr m) = allAtMemberL P xs a rest m

------------------------------------------------------------------------
-- 2.  An Any yields its witness together with the membership
------------------------------------------------------------------------

anyToMember :
  (P : A → Type) (xs : List A)
  → Any P xs → Σ[ x ∈ A ] ((Any (λ y → y ≡ x) xs) × P x)
anyToMember P []       e       = ⊥.rec e
anyToMember P (x ∷ xs) (inl p) = x , (inl refl , p)
anyToMember P (x ∷ xs) (inr a) with anyToMember P xs a
... | (w , (mem , p)) = w , (inr mem , p)

------------------------------------------------------------------------
-- 3.  So nothing dropped from a layer was undominated
------------------------------------------------------------------------

everyRemainderMemberIsStrictlyDominated :
  (xs : List (List ℕ)) (v : List ℕ)
  → Any (λ y → y ≡ v) (remainder xs)
  → Σ[ w ∈ List ℕ ]
      ((Any (λ y → y ≡ w) xs) × StrictlyDominates v w)
everyRemainderMemberIsStrictlyDominated xs v mem =
  anyToMember (StrictlyDominates v) xs dominated
  where
    notMaximal : ¬ IsParetoMaximal v xs
    notMaximal =
      allAtMemberL (λ u → ¬ IsParetoMaximal u xs)
        (filterOut (λ u → IsParetoMaximal u xs)
                   (λ u → decIsParetoMaximal u xs) xs)
        v
        (filterOutOnlyKeepsNonSatisfiers (λ u → IsParetoMaximal u xs)
                                         (λ u → decIsParetoMaximal u xs) xs)
        mem

    dominated : Any (StrictlyDominates v) xs
    dominated =
      Dec→Stable (decAny (StrictlyDominates v) (decStrictlyDominates v) xs)
                 notMaximal
