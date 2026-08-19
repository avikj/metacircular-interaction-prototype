{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
--
-- `TheFourthCornerIsRefutedUnderPointwiseStability` ended with:
--
--   "NOT SETTLED: whether it exists.  The hypothesis is not shown
--    necessary, and no model realising `¬ सामयिक × ¬ नित्य` is
--    exhibited.  The unconditional question is where it was, and this
--    narrows where to look rather than answering it."
--
-- This narrows it much further, and by discharging the hypothesis
-- rather than by assuming a weaker one.  Where the instance family is
-- ENUMERABLE and badness is DECIDABLE, pointwise stability is not a
-- hypothesis at all — it is a theorem — so the fourth corner is refuted
-- with nothing assumed.
--
-- Jaina terms first, and the school named: सामयिक (temporary) and नित्य
-- (permanent) are `AnuktaAvaktavya`'s, another identity's, and are used
-- here unchanged; nothing below edits or reinterprets them.  The corner
-- in question is the fourth of the saptabhaṅgī reading that module
-- sets up — both readings denied at once.  What is added is a condition
-- on the INSTANCE SET, not on the predication.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Enumerated I     a list of instances together with a proof that
--                    every instance is in it (`Any (_≡ i)`), which is
--                    the constructive content of "finite family" without
--                    a cardinality
--   decAny           decidability transports along that list
--   decΣOverEnumerated
--                    hence `Σ[ i ∈ I ] P i` is DECIDABLE
--   enumerableDecidableGivesPointwiseStability
--                    hence stable, by `Dec→Stable`
--   fourthCornerRefutedOverEnumerableDecidable
--                    hence the fourth corner is refuted, unconditionally
--
-- The prior module's hypothesis was "finding a surviving instance is
-- not a genuine search".  This says: over an enumerable family with
-- decidable badness it is not a search, it is a scan.  So the fourth
-- corner, if it exists at all, needs an instance family that is not
-- enumerable OR a badness that is not decidable — not merely "some Σ
-- happens to be unstable".
--
-- ────────────────────────────────────────────────────────────────────
-- IDIOM.  `Any` is a recursive type family, `Any P [] = ⊥`,
-- `Any P (x ∷ xs) = P x ⊎ Any P xs`, not an inductive family with an
-- index.  That is the repository's standing cubical rule — in cubical
-- v0.5 `Fin n = Σ k (k < n)`, so constructors in index positions do not
-- pattern-match — and it is why nothing here mentions `Fin` at all.
--
-- WHAT IS STILL NOT CLAIMED.  Existence.  No model realising
-- `¬ सामयिक × ¬ नित्य` is exhibited here either, and none is refuted in
-- general: this is a second sufficient condition, sharper and checkable,
-- not a necessary one.  `Enumerated I` is a Σ, not a truncation, so it
-- carries a CHOSEN enumeration and two enumerations of one family are
-- two elements — nothing here is invariant under changing it, and
-- nothing needs to be.  The covering proof uses paths (`x ≡ i`) and
-- `subst`, so `I` is not assumed to have decidable equality and the
-- list may repeat.  Finally the empty family is enumerable: there
-- `सामयिक` is the unit and the refutation is vacuous, which is correct
-- and worth saying rather than hiding.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Dec→Stable)

open import AnuktaAvaktavya using (सामयिक ; नित्य)
open import NaturalMachine.TheFourthCornerIsRefutedUnderPointwiseStability
  using (fourthCornerRefutedUnderPointwiseStability)

private
  variable
    A Ix R : Type

------------------------------------------------------------------------
-- 1.  Any, as a recursive family
------------------------------------------------------------------------

Any : (P : A → Type) → List A → Type
Any P []       = ⊥
Any P (x ∷ xs) = P x ⊎ Any P xs

anyToΣ : (P : A → Type) (xs : List A) → Any P xs → Σ[ x ∈ A ] P x
anyToΣ P []       e       = ⊥.rec e
anyToΣ P (x ∷ xs) (inl p) = x , p
anyToΣ P (x ∷ xs) (inr q) = anyToΣ P xs q

-- placing a witness into the list, along the covering path
memberToAny :
  (P : A → Type) (i : A) (xs : List A)
  → Any (λ x → x ≡ i) xs → P i → Any P xs
memberToAny P i []       e       p = ⊥.rec e
memberToAny P i (x ∷ xs) (inl q) p = inl (subst P (sym q) p)
memberToAny P i (x ∷ xs) (inr m) p = inr (memberToAny P i xs m p)

decAny :
  (P : A → Type) → ((x : A) → Dec (P x))
  → (xs : List A) → Dec (Any P xs)
decAny P d []       = no (λ e → e)
decAny P d (x ∷ xs) with d x
... | yes p = yes (inl p)
... | no ¬p with decAny P d xs
...   | yes q = yes (inr q)
...   | no ¬q = no (λ { (inl p) → ¬p p ; (inr q) → ¬q q })

------------------------------------------------------------------------
-- 2.  Enumerable instance families
--
-- No cardinality, no `Fin`, no decidable equality on Ix: a list, and a
-- proof that nothing is outside it.
------------------------------------------------------------------------

Enumerated : Type → Type
Enumerated Ix = Σ[ xs ∈ List Ix ] ((i : Ix) → Any (λ x → x ≡ i) xs)

decΣOverEnumerated :
  Enumerated Ix → (P : Ix → Type) → ((i : Ix) → Dec (P i))
  → Dec (Σ[ i ∈ Ix ] P i)
decΣOverEnumerated {Ix} (xs , cov) P d with decAny P d xs
... | yes a  = yes (anyToΣ P xs a)
... | no ¬a  = no (λ z → ¬a (memberToAny P (fst z) xs (cov (fst z)) (snd z)))

------------------------------------------------------------------------
-- 3.  So the search is a scan, and the hypothesis discharges
------------------------------------------------------------------------

enumerableDecidableGivesPointwiseStability :
  (bad : Ix → R → Type)
  → Enumerated Ix
  → ((i : Ix) (r : R) → Dec (bad i r))
  → (r : R) → ¬ ¬ (Σ[ i ∈ Ix ] bad i r) → Σ[ i ∈ Ix ] bad i r
enumerableDecidableGivesPointwiseStability bad e d r =
  Dec→Stable (decΣOverEnumerated e (λ i → bad i r) (λ i → d i r))

------------------------------------------------------------------------
-- 4.  The fourth corner, refuted with nothing assumed about stability
------------------------------------------------------------------------

fourthCornerRefutedOverEnumerableDecidable :
  (bad : Ix → R → Type)
  → Enumerated Ix
  → ((i : Ix) (r : R) → Dec (bad i r))
  → ¬ ((¬ सामयिक bad) × (¬ नित्य bad))
fourthCornerRefutedOverEnumerableDecidable bad e d =
  fourthCornerRefutedUnderPointwiseStability bad
    (enumerableDecidableGivesPointwiseStability bad e d)
