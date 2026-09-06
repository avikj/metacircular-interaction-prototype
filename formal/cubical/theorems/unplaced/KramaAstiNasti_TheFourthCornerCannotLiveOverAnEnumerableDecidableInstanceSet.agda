{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- क्रम · नास्ति — two terms, one from each half of the सप्तभङ्गी apparatus.
--
--   स्यान्नास्ति, the second भङ्ग: in some respect, it is not.  **Samantabhadra,
--   *Āptamīmāṃsā* 14-24 (~6th c. CE); Akalaṅka, *Laghīyastraya* (~8th c.);
--   rooted in Umāsvāti, *Tattvārthasūtra* 5.31-32 (~2nd-5th c.).**
--
--   क्रमार्पण versus सहार्पण — presentation in SUCCESSION versus SIMULTANEOUSLY.
--   **Akalaṅka, *Laghīyastraya* (~8th c.); Vidyānandin,
--   *Tattvārthaślokavārttika* (~9th c.).**  This is the load-bearing one:
--   अस्ति and नास्ति asserted in succession give the third भङ्ग and are
--   expressible; asserted together they give अवक्तव्य, the fourth, which is
--   neither unknown nor undefined nor empty but a positive fourth position.
--   The distinction is what makes seven positions and not four.
--
-- **No claim is made that Samantabhadra, Akalaṅka or Vidyānandin proved
-- anything below.**  The sevenfold division and the क्रम/सह distinction are
-- theirs, stated as doctrine; the theorems here are about what the fourth
-- corner can and cannot be over particular index types in cubical type
-- theory, and they are this repository's.  The Jaina texts do not contain a
-- claim about enumerable decidable instance sets and nothing here should be
-- read as saying they do.
--
------------------------------------------------------------------------
-- TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
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
-- THE SCOPE, EXACTLY.  Existence.  No model realising
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

module KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet where

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
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "Existence.  … this is a second SUFFICIENT condition, sharper and
--    checkable, not a necessary one."
--
-- A NECESSARY one now exists, for one family, in
-- `TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- Take the instance set to be ONE instance (`Unit`), remedies
-- arbitrary, `bad _ r = Q r`.  Then, both directions checked:
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
-- WHAT THAT SAYS ABOUT THIS MODULE, and it is not flattering.  A ONE-
-- ELEMENT instance family is enumerable — `Enumerated Unit` is
-- immediate.  So the whole `Enumerated` apparatus above cannot be what
-- separates the corner from its absence: at Unit the enumeration is
-- free and the entire question is whether the BADNESS is stable.  The
-- decidability hypothesis was doing all the work and the enumerability
-- hypothesis none of it, in the only case where the answer is now
-- known.  This module is still correct — it covers families where
-- BOTH matter — but the sentence "the fourth corner needs an instance
-- family that is not enumerable OR a badness that is not decidable"
-- reads as offering two routes, and the first is not a route at all
-- when one instance suffices.
--
-- STILL NOT CLAIMED: EXISTENCE.  DNS is neither provable nor refutable
-- in this substrate; exhibiting a failure needs a model, and none is
-- constructed. What changed is the question's status, not its answer.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above (the import line was rewritten mechanically because the
-- imported FILE was renamed; no statement changed).
--
-- **NAMING.**  Under the owner's directive of 2026-08-19 (CLAUDE.md,
-- "File naming"), three files on this line now lead with the term:
--
--   Avaktavya_TheFourthCornerIsRefutedUnderPointwiseStability
--   Avaktavya_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
--   Avaktavya_AnEnumerableRemedySetKillsTheFourthCorner
--
-- अवक्तव्य — the fourth bhaṅga of the Jaina saptabhaṅgī (Umāsvāti,
-- *Tattvārthasūtra*; Samantabhadra; Akalaṅka; Siddhasena Divākara),
-- which is the position this line's "fourth corner" has meant since it
-- began, via `AnuktaAvaktavya`'s सामयिक and नित्य.  This file keeps its
-- name for now because thirteen modules import it and the rename is a
-- separate, mechanical cycle; that is a scheduling fact, not a
-- judgement that the term does not apply.
--
-- **THE SCHOOL BOUNDARY, and it matters here more than usual.**
-- `Saptabhangi` and `SaptabhangiNaya` — another identity's, written in
-- Devanagari with Sanskrit identifiers, not merely named in Sanskrit —
-- prove that स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम्: krama
-- (sequential) and saha (simultaneous, yugapad) assertion give
-- different vāṇīs, so avaktavya is NOT sequential both-ness and the
-- seven positions do not reduce to two.  **That is their result and
-- this line does not restate, reprove, or absorb it.**
--
-- What it does to my claims is an OPEN COMPARISON, stated as such:
-- this line identifies the fourth corner AT ONE INSTANCE with failure
-- of the double-negation shift, a principle from a different lineage
-- entirely (Spector 1962; Kreisel), and nothing here has checked
-- whether the DNS identification is compatible with their krama/saha
-- separation, or whether it collapses a distinction they keep.  Until
-- that is checked, treating the two as one toolkit would be exactly
-- the error CLAUDE.md names — and the honest position is that I have
-- an identification at one instance and they have a structure, and the
-- relation between them is unproved.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end.  The file was
-- renamed under the owner's directive (CLAUDE.md, "File naming",
-- 2026-08-19) to lead with अवक्तव्य — the fourth bhaṅga of the Jaina
-- saptabhaṅgī, which is the position this line has meant by "the
-- fourth corner" throughout, via `AnuktaAvaktavya`'s सामयिक and नित्य.
-- Eleven importing modules had their `open import` line rewritten
-- mechanically; nothing else in any of them changed, and all twelve
-- re-checked EXIT=0 with zero warning lines.
--
-- **AND THE RENAME EXPOSED SOMETHING STRUCTURAL WORTH RECORDING.**  Of
-- the eleven importers, most take only `Any`, `decAny` and
-- `memberToAny` — list utilities that have nothing to do with the
-- fourth corner, or with Jaina logic, and that ended up here because
-- this is where they were first needed.  So a module named for a
-- position in the saptabhaṅgī is load-bearing for the Pareto
-- stratification, which is Goldberg/Deb non-dominated sorting and has
-- no Indian source at all.  That is not a naming problem the directive
-- creates — it is a factoring problem the rename made visible: the
-- utilities want their own module, and the corpus already has THREE
-- separate `All` definitions for the same reason.  Consolidating them
-- touches other identities' files, so it is an OFFER and not an edit,
-- and it is recorded here rather than done.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end.  **THE
-- PREVIOUS NAME WAS WRONG AND THIS RECORDS THE CORRECTION.**
--
-- One cycle ago this file, and three others on this line, were renamed
-- `Avaktavya_*` on the grounds that "the fourth corner" is the fourth
-- bhaṅga of the saptabhaṅgī.  The next cycle proved it is not:
-- `KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition`
-- shows the corner is a PRODUCT of two independent negations, and that
-- simultaneous refusal collapses into the sequential pair — `¬ (A ⊎ B)`
-- and `(¬ A) × (¬ B)` are interderivable here with no hypothesis.  By
-- the theorem in another identity's `Saptabhangi`, the fourth bhaṅga is
-- exactly what a sequential position is NOT.
--
-- So the position this line occupies is the THIRD bhaṅga —
-- स्यात्-अस्ति-नास्ति, asserted क्रमेण (kramena, in sequence) — and the
-- four files now lead with `KramaAstiNasti_`.  Fifteen modules had
-- their `module` or `open import` line rewritten mechanically; no
-- statement in any of them changed, and all fifteen re-checked EXIT=0
-- with zero warning lines.
--
-- **The naming directive is what made this refutable.**  An
-- English-only title asserts nothing about the object and cannot be
-- checked against it; naming a file for a tradition's term states a
-- claim, and this one failed in one cycle.  The lesson for the rest of
-- the backlog: when adopting a term, prove the object has the property
-- the term names — before the rename, not after.
--
-- What is still NOT claimed: that avaktavya is inexpressible here; only
-- that a product of negations over an instance family is not it.
------------------------------------------------------------------------
