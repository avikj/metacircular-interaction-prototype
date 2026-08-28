{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheWholeMixedStratificationIsTheFlippedOne
--
-- ऋणधन · ṛṇa-dhana — Brahmagupta, *Brāhmasphuṭasiddhānta* (628): one
-- magnitude read as *dhana* (asset) or *ṛṇa* (debt).  The sign rules
-- are his; the caps, the filters and the induction below are not.
--
-- ────────────────────────────────────────────────────────────────────
-- `RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum` transferred ONE
-- layer and named the rest:
--
--   "the REMAINDER half (same argument, negated predicate), then the
--    iteration, in which the caps must still bound the shrinking
--    archive at every step."
--
-- Both are done here, and the shrinking-archive worry was unfounded:
-- `allBoundedFilterOut` is four lines, because a filtered list is a
-- sublist and `AllBounded` is pointwise.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   mixedRemainder      the mixed complement of the mixed layer
--   filterOutMapCommutes / filterOutRespectsOn
--                       the two list lemmas again, negated branch
--   allBoundedFilterOut a filtered archive is still bounded — for an
--                       ARBITRARY decidable predicate, so it covers
--                       the layer as well as the remainder
--   theMixedRemainderIsTheFlippedRemainder
--                       `map flip (mixedRemainder ds vs) ≡
--                        remainder (map flip vs)`
--   mixedStrata         the mixed stratification, same fuel recursion
--                       as `strata`
--   theMixedStrataAreTheFlippedStrata
--                       `map (map flip) (mixedStrata n ds vs) ≡
--                        strata n (map flip vs)`, for every fuel
--
-- **SO THE WHOLE §5.2 OUTPUT-PROPERTY BLOCK IS AVAILABLE IN THE COST
-- READING.**  Coverage, disjointness and order were proved for
-- `strata`; the equation above says the mixed stratification IS that
-- stratification, flipped, so each of those statements transports by
-- rewriting along one path — no re-proof, and no new hypothesis beyond
-- `AllBounded` on the initial archive.  The obligation every module on
-- the Pareto line has carried in its header since the line began is
-- discharged.
--
-- **WHAT THE INDUCTION ACTUALLY NEEDED**, since I predicted otherwise:
-- not injectivity, not a rank, not a measure — only that the caps
-- survive peeling, and they do trivially.  The recursion then goes
-- through because `map flip (v ∷ vs)` reduces to `flip v ∷ map flip vs`
-- definitionally, so the flipped archive is already in the cons form
-- `strata` matches on.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Everything here is filter/map bookkeeping over
-- Goldberg/Deb non-dominated sorting.
--
-- SYĀT — THE CLAIM, EXACTLY.  The transported statements are NOT written out
-- as separate theorems — the path is given and the rewriting is left
-- to the reader or to a later cycle; nothing here claims a new fact
-- about coverage, disjointness or order beyond that they transport.
-- `AllBounded` remains a hypothesis: nothing constructs caps.  The
-- CERTIFICATE line still states its cost component in the benefit
-- reading and is untouched by this.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheWholeMixedStratificationIsTheFlippedOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (IsParetoMaximal ; decIsParetoMaximal ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder)
open import TheStratificationTerminatesOnItsOwnLength using (strata)
open import FlippingACostCoordinateIsSoundButNotFaithful using (Vec)
open import RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps ; BoundedC ; flipWithCaps)
open import RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedMaximal ; AllBounded ; boundedAtMember)
open import RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
  using (decMixedMaximal ; mixedStratum ; mixedMaximalIff
        ; theMixedStratumIsTheFlippedStratum)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The negated branch of the two list lemmas
------------------------------------------------------------------------

filterOutMapCommutes :
  {B : Type} (f : A → B) (Q : B → Type) (dq : (b : B) → Dec (Q b))
  (xs : List A)
  → filterOut Q dq (map f xs)
    ≡ map f (filterOut (λ a → Q (f a)) (λ a → dq (f a)) xs)
filterOutMapCommutes f Q dq []       = refl
filterOutMapCommutes f Q dq (x ∷ xs) with dq (f x)
... | yes _ = filterOutMapCommutes f Q dq xs
... | no  _ = cong (f x ∷_) (filterOutMapCommutes f Q dq xs)

filterOutRespectsOn :
  (P Q : A → Type) (dp : (a : A) → Dec (P a)) (dq : (a : A) → Dec (Q a))
  (xs : List A)
  → ((a : A) → Mem a xs → (P a → Q a) × (Q a → P a))
  → filterOut P dp xs ≡ filterOut Q dq xs
filterOutRespectsOn P Q dp dq []       iff = refl
filterOutRespectsOn P Q dp dq (x ∷ xs) iff with dp x | dq x
... | yes _ | yes _ =
  filterOutRespectsOn P Q dp dq xs (λ a m → iff a (inr m))
... | yes p | no ¬q = ⊥.rec (¬q (fst (iff x (inl refl)) p))
... | no ¬p | yes q = ⊥.rec (¬p (snd (iff x (inl refl)) q))
... | no  _ | no  _ =
  cong (x ∷_) (filterOutRespectsOn P Q dp dq xs (λ a m → iff a (inr m)))

------------------------------------------------------------------------
-- 2.  Caps survive peeling
------------------------------------------------------------------------

allBoundedFilterOut :
  (ds : List Bool) (cs : Caps ds)
  (P : Vec ds → Type) (d : (u : Vec ds) → Dec (P u))
  (vs : List (Vec ds))
  → AllBounded ds cs vs → AllBounded ds cs (filterOut P d vs)
allBoundedFilterOut ds cs P d []       _        = tt
allBoundedFilterOut ds cs P d (v ∷ vs) (b , bs) with d v
... | yes _ = allBoundedFilterOut ds cs P d vs bs
... | no  _ = b , allBoundedFilterOut ds cs P d vs bs

------------------------------------------------------------------------
-- 3.  The remainder transfers
------------------------------------------------------------------------

mixedRemainder : (ds : List Bool) → List (Vec ds) → List (Vec ds)
mixedRemainder ds vs =
  filterOut (MixedMaximal ds vs) (decMixedMaximal ds vs) vs

theMixedRemainderIsTheFlippedRemainder :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  → AllBounded ds cs vs
  → map (flipWithCaps ds cs) (mixedRemainder ds vs)
    ≡ remainder (map (flipWithCaps ds cs) vs)
theMixedRemainderIsTheFlippedRemainder ds cs vs ab =
    cong (map (flipWithCaps ds cs))
      (filterOutRespectsOn (MixedMaximal ds vs)
        (λ u → IsParetoMaximal (flipWithCaps ds cs u)
                               (map (flipWithCaps ds cs) vs))
        (decMixedMaximal ds vs)
        (λ u → decIsParetoMaximal (flipWithCaps ds cs u)
                                  (map (flipWithCaps ds cs) vs))
        vs
        (λ a m → mixedMaximalIff ds cs vs ab a (boundedAtMember ds cs vs a ab m)))
  ∙ sym (filterOutMapCommutes (flipWithCaps ds cs)
          (λ y → IsParetoMaximal y (map (flipWithCaps ds cs) vs))
          (λ y → decIsParetoMaximal y (map (flipWithCaps ds cs) vs))
          vs)

------------------------------------------------------------------------
-- 4.  …and so does the whole stratification
------------------------------------------------------------------------

mixedStrata : ℕ → (ds : List Bool) → List (Vec ds) → List (List (Vec ds))
mixedStrata zero    ds vs       = []
mixedStrata (suc n) ds []       = []
mixedStrata (suc n) ds (v ∷ vs) =
  mixedStratum ds (v ∷ vs) ∷ mixedStrata n ds (mixedRemainder ds (v ∷ vs))

theMixedStrataAreTheFlippedStrata :
  (n : ℕ) (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  → AllBounded ds cs vs
  → map (map (flipWithCaps ds cs)) (mixedStrata n ds vs)
    ≡ strata n (map (flipWithCaps ds cs) vs)
theMixedStrataAreTheFlippedStrata zero    ds cs vs       _  = refl
theMixedStrataAreTheFlippedStrata (suc n) ds cs []       _  = refl
theMixedStrataAreTheFlippedStrata (suc n) ds cs (v ∷ vs) ab =
  cong₂ _∷_
    (theMixedStratumIsTheFlippedStratum ds cs (v ∷ vs) ab)
    ( theMixedStrataAreTheFlippedStrata n ds cs (mixedRemainder ds (v ∷ vs))
        (allBoundedFilterOut ds cs (MixedMaximal ds (v ∷ vs))
          (decMixedMaximal ds (v ∷ vs)) (v ∷ vs) ab)
    ∙ cong (strata n)
        (theMixedRemainderIsTheFlippedRemainder ds cs (v ∷ vs) ab) )
