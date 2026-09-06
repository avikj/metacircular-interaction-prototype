{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheParetoStratumIsDecidableAndTheFilterIsExact
--
-- `AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision` closed
-- with, among its NOT-CLAIMED items:
--
--   "it is NOT proved that a Pareto stratification EXISTS
--    constructively for an arbitrary archive, which would need a
--    decision on `≼` and is not proved here."
--
-- The decision exists, and with it the stratum is not merely a
-- specification but a computed list.  That matters for
-- `DARWIN_GODEL_MATH.md` §5.2 in a way the previous module could not
-- say: §5.2's controller "first selects a Pareto stratum S" and samples
-- inside it, and a controller cannot select what it cannot compute.
-- The previous cycle proved there is no best to pick; this one proves
-- the thing §5.2 picks INSTEAD is constructible.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   dec≤ / dec≼             the product order on fitness vectors is
--                           decidable, from `splitℕ-≤` alone
--   decStrictlyDominates    hence so is strict domination
--   decIsParetoMaximal      hence so is Pareto-maximality against a
--                           finite archive, reusing `decAny`
--   filterDec               the stratum, as a list
--   stratumOnlyKeepsMaximal    soundness — everything kept is maximal
--   stratumKeepsEveryMaximal   completeness — nothing maximal is dropped
--
-- Soundness and completeness together are why "the filter is exact":
-- the computed stratum and the specified stratum have the same members,
-- so §5.2's first stage denotes.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Decidability of a product order from decidability of its
-- factors, and the soundness/completeness of a decidable filter, are
-- elementary.  They are checked here because the previous module named
-- their absence as the reason its result was a specification and not a
-- construction.
--
-- THE SCOPE, EXACTLY.  This is ONE stratum — the maximal layer.
-- A STRATIFICATION is the iterated construction (remove the layer,
-- repeat), and that needs a termination argument on the archive's
-- length which is NOT given here; nothing below iterates.  No claim is
-- made that the stratum is non-empty: for the empty archive it is
-- empty, and for a non-empty archive non-emptiness needs an argument
-- this module does not make.  `filterDec` preserves multiplicity and
-- order, so an archive listing one vector twice yields a stratum
-- listing it twice — no deduplication, and `≼`'s antisymmetry is not
-- used to quotient anything.  Costs are still unflipped, exactly as the
-- previous module recorded: §5.2's wall time, tokens and dollars are to
-- be MINIMISED and no coordinate is negated here.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheParetoStratumIsDecidableAndTheFilterIsExact where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; <-asym ; splitℕ-≤)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; decAny)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_≼_)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The order is decidable
------------------------------------------------------------------------

dec≤ : (m n : ℕ) → Dec (m ≤ n)
dec≤ m n with splitℕ-≤ m n
... | inl p = yes p
... | inr q = no (<-asym q)

dec≼ : (v w : List ℕ) → Dec (v ≼ w)
dec≼ []       []       = yes tt
dec≼ []       (_ ∷ _)  = no (λ z → z)
dec≼ (_ ∷ _)  []       = no (λ z → z)
dec≼ (x ∷ xs) (y ∷ ys) with dec≤ x y
... | no ¬p = no (λ r → ¬p (fst r))
... | yes p with dec≼ xs ys
...   | yes q = yes (p , q)
...   | no ¬q = no (λ r → ¬q (snd r))

decNeg : {B : Type} → Dec B → Dec (¬ B)
decNeg (yes b) = no (λ n → n b)
decNeg (no ¬b) = yes ¬b

------------------------------------------------------------------------
-- 2.  Hence Pareto-maximality against a finite archive is decidable
------------------------------------------------------------------------

StrictlyDominates : List ℕ → List ℕ → Type
StrictlyDominates v w = (v ≼ w) × (¬ (w ≼ v))

decStrictlyDominates : (v w : List ℕ) → Dec (StrictlyDominates v w)
decStrictlyDominates v w with dec≼ v w
... | no ¬p = no (λ r → ¬p (fst r))
... | yes p with decNeg (dec≼ w v)
...   | yes ¬q = yes (p , ¬q)
...   | no ¬¬q = no (λ r → ¬¬q (snd r))

IsParetoMaximal : List ℕ → List (List ℕ) → Type
IsParetoMaximal v xs = ¬ Any (StrictlyDominates v) xs

decIsParetoMaximal :
  (v : List ℕ) (xs : List (List ℕ)) → Dec (IsParetoMaximal v xs)
decIsParetoMaximal v xs =
  decNeg (decAny (StrictlyDominates v) (decStrictlyDominates v) xs)

------------------------------------------------------------------------
-- 3.  The stratum, as a computed list
------------------------------------------------------------------------

All : (P : A → Type) → List A → Type
All P []       = Unit
All P (x ∷ xs) = P x × All P xs

filterDec :
  (P : A → Type) → ((a : A) → Dec (P a)) → List A → List A
filterDec P d []       = []
filterDec P d (x ∷ xs) with d x
... | yes _ = x ∷ filterDec P d xs
... | no  _ = filterDec P d xs

filterDecOnlyKeepsSatisfiers :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A)
  → All P (filterDec P d xs)
filterDecOnlyKeepsSatisfiers P d []       = tt
filterDecOnlyKeepsSatisfiers P d (x ∷ xs) with d x
... | yes p = p , filterDecOnlyKeepsSatisfiers P d xs
... | no  _ = filterDecOnlyKeepsSatisfiers P d xs

filterDecKeepsEverySatisfier :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Any (λ y → y ≡ a) xs → P a → Any (λ y → y ≡ a) (filterDec P d xs)
filterDecKeepsEverySatisfier P d []       a e        pa = ⊥.rec e
filterDecKeepsEverySatisfier P d (x ∷ xs) a (inl q)  pa with d x
... | yes _ = inl q
... | no ¬p = ⊥.rec (¬p (subst P (sym q) pa))
filterDecKeepsEverySatisfier P d (x ∷ xs) a (inr m)  pa with d x
... | yes _ = inr (filterDecKeepsEverySatisfier P d xs a m pa)
... | no  _ = filterDecKeepsEverySatisfier P d xs a m pa

------------------------------------------------------------------------
-- 4.  So §5.2's first stage denotes
------------------------------------------------------------------------

stratum : List (List ℕ) → List (List ℕ)
stratum xs = filterDec (λ v → IsParetoMaximal v xs) (λ v → decIsParetoMaximal v xs) xs

stratumOnlyKeepsMaximal :
  (xs : List (List ℕ)) → All (λ v → IsParetoMaximal v xs) (stratum xs)
stratumOnlyKeepsMaximal xs =
  filterDecOnlyKeepsSatisfiers (λ v → IsParetoMaximal v xs)
                               (λ v → decIsParetoMaximal v xs) xs

stratumKeepsEveryMaximal :
  (xs : List (List ℕ)) (v : List ℕ)
  → Any (λ y → y ≡ v) xs → IsParetoMaximal v xs
  → Any (λ y → y ≡ v) (stratum xs)
stratumKeepsEveryMaximal xs v =
  filterDecKeepsEverySatisfier (λ u → IsParetoMaximal u xs)
                               (λ u → decIsParetoMaximal u xs) xs v

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  §"WHAT IS STILL NOT CLAIMED" makes two admissions.  One
-- is discharged, the other is not, and this says which is which.
--
-- DISCHARGED: "No claim is made that the stratum is non-empty … for a
-- non-empty archive non-emptiness needs an argument this module does
-- not make."  The argument is made, in
-- `ANonEmptyArchiveHasANonEmptyStratum`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   ⊏-irrefl / ⊏-trans   strict domination; transitivity is NOT
--                        inherited from `≼-trans`, the negative half
--                        has to be argued
--   anyMap               `Any` is functorial in its predicate
--   maximalExists        every non-empty archive has a member maximal
--                        in it — list induction, DECIDING at each step
--                        whether the tail's maximum beats the head; if
--                        it does, the HEAD is maximal, because anything
--                        beating the head would beat it by transitivity
--   stratumIsNonEmpty    hence `stratum (x ∷ xs)` has a member
--
-- The decision that makes the induction constructive is
-- `decStrictlyDominates` above; without it this would need excluded
-- middle, which is the point of having proved decidability first.
--
-- NOT DISCHARGED, and unchanged: one STRATUM is not a STRATIFICATION.
-- Removing the layer and repeating still needs a termination argument
-- on the archive's length, and nothing iterates anywhere yet.  Also
-- still open: the SIZE of the stratum, whether it lists all maximal
-- elements up to the duplication `filterDec` preserves, and whether the
-- element `maximalExists` produces is canonical — it depends on the
-- list's order.
------------------------------------------------------------------------
