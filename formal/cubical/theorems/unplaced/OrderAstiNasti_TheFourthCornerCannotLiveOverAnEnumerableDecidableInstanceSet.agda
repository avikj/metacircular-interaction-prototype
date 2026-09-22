{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- क्रम · नास्ति — two terms, one from each half of the सप्तभङ्गी apparatus.
--
--   स्यान्नास्ति, the second भङ्ग: in some respect, it is not.  **Samantabhadra,
--   *ptamms* 14-24 (~6th c. CE); Akalaka, *Laghyastraya* (~8th c.);
--   rooted in Umsvti, *Tattvrthastra* 5.31-32 (~2nd-5th c.).**
--
--   क्रमार्पण versus सहार्पण — presentation in SUCCESSION versus SIMULTANEOUSLY.
--   **Akalaka, *Laghyastraya* (~8th c.); Vidynandin,
--   *Tattvrthalokavrttika* (~9th c.).**  This is the load-bearing one:
--   अस्ति and नास्ति asserted in succession give the third भङ्ग and are
--   expressible; asserted together they give अवक्तव्य, the fourth, which is
--   neither unknown nor undefined nor empty but a positive fourth position.
--   The distinction is what makes seven positions and not four.
--
-- The sevenfold division and the क्रम/सह distinction are
-- theirs, stated as doctrine; the theorems here are about what the fourth
-- corner can and cannot be over particular index types in cubical type
-- theory, and they are this repository's.
--
------------------------------------------------------------------------
-- TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
--
-- Where the instance family is
-- ENUMERABLE and badness is DECIDABLE, pointwise stability is not a
-- hypothesis at all — it is a theorem — so the fourth corner is refuted
-- with nothing assumed.
--
-- Jaina terms first, and the school named: सामयिक (temporary) and नित्य
-- (permanent) are `AnuktaAvaktavya`'s, and are used
-- here unchanged; nothing below edits or reinterprets them.  The corner
-- in question is the fourth of the saptabhag reading that module
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
------------------------------------------------------------------------

module OrderAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Dec→Stable)

open import AnuktaAvaktavya using (सामयिक ; नित्य)
open import KramaAstiNasti_TheFourthCornerIsRefutedUnderPointwiseStability
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

------------------------------------------------------------------------
-- This module gives a SUFFICIENT condition for refuting the corner.  A
-- NECESSARY one exists, for one family, in
-- `TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift`.
--
-- Take the instance set to be ONE instance (`Unit`), remedies
-- arbitrary, `bad _ r = Q r`.  Then:
--
--   ¬ सामयिक  ≃  (r : R) → ¬ ¬ Q r
--   ¬ नित्य    ≃  ¬ ((r : R) → Q r)
--
-- so the fourth corner IS a counterexample to the DOUBLE-NEGATION SHIFT
-- (Spector 1962; Kreisel), and
--
--   fourthCornerRefutesPointwiseStability
--       the corner implies ¬ ((r) → Stable (Q r))
--
-- — the converse of §3 here, so at that family the stability hypothesis
-- is necessary as well as sufficient.
--
-- WHAT THAT SAYS ABOUT THIS MODULE.  A ONE-
-- ELEMENT instance family is enumerable — `Enumerated Unit` is
-- immediate.  So the whole `Enumerated` apparatus above cannot be what
-- separates the corner from its absence: at Unit the enumeration is
-- free and the entire question is whether the BADNESS is stable.  The
-- decidability hypothesis was doing all the work and the enumerability
-- hypothesis none of it, in the only case where the answer is
-- known.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- **THE SCHOOL BOUNDARY.**
-- `Saptabhangi` and `SaptabhangiNaya`
-- prove that स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम्: krama
-- (sequential) and saha (simultaneous, yugapad) assertion give
-- different vs, so avaktavya is NOT sequential both-ness and the
-- seven positions do not reduce to two.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ON THE NAME.  `OrderSaha_TheFourthCornerIWasNamingIsTheSequentialPosition`
-- shows the corner is a PRODUCT of two independent negations, and that
-- simultaneous refusal collapses into the sequential pair — `¬ (A ⊎ B)`
-- and `(¬ A) × (¬ B)` are interderivable here with no hypothesis.  By
-- the theorem in `Saptabhangi`, the fourth bhaga is
-- exactly what a sequential position is NOT.
--
-- So the position this line occupies is the THIRD bhaṅga —
-- स्यात्-अस्ति-नास्ति, asserted क्रमेण (kramena, in sequence) — and the
-- files on this line lead with `OrderAstiNasti_`.
------------------------------------------------------------------------
