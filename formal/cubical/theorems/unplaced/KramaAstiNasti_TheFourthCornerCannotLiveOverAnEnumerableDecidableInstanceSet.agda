{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ PROVENANCE OF THE NAME.
--
-- ‡ï‡‡∞‡Æ ¬ ‡®‡æ‡‡‡‡ø ‚î two terms, one from each half of the ‡‡‡‡‡‡ô‡‡ó‡ apparatus.
--
--   ‡‡‡Ø‡æ‡®‡‡®‡æ‡‡‡‡ø, the second ‡‡ô‡‡ó: in some respect, it is not.  **Samantabhadra,
--   *ptamms* 14-24 (~6th c. CE); Akalaka, *Laghyastraya* (~8th c.);
--   rooted in Umsvti, *Tattvrthastra* 5.31-32 (~2nd-5th c.).**
--
--   ‡ï‡‡∞‡Æ‡æ‡∞‡‡‡ versus ‡‡‡æ‡∞‡‡‡ ‚î presentation in SUCCESSION versus SIMULTANEOUSLY.
--   **Akalaka, *Laghyastraya* (~8th c.); Vidynandin,
--   *Tattvrthalokavrttika* (~9th c.).**  This is the load-bearing one:
--   ‡‡‡‡‡ø and ‡®‡æ‡‡‡‡ø asserted in succession give the third ‡‡ô‡‡ó and are
--   expressible; asserted together they give ‡‡µ‡ï‡‡‡µ‡‡Ø, the fourth, which is
--   neither unknown nor undefined nor empty but a positive fourth position.
--   The distinction is what makes seven positions and not four.
--
-- **No claim is made that Samantabhadra, Akalaka or Vidynandin proved
-- anything below.**  The sevenfold division and the ‡ï‡‡∞‡Æ/‡‡ distinction are
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
--    necessary, and no model realising `¬ ‡‡æ‡Æ‡Ø‡ø‡ï ó ¬ ‡®‡ø‡‡‡Ø` is
--    exhibited.  The unconditional question is where it was, and this
--    narrows where to look rather than answering it."
--
-- This narrows it much further, and by discharging the hypothesis
-- rather than by assuming a weaker one.  Where the instance family is
-- ENUMERABLE and badness is DECIDABLE, pointwise stability is not a
-- hypothesis at all ‚î it is a theorem ‚î so the fourth corner is refuted
-- with nothing assumed.
--
-- Jaina terms first, and the school named: ‡‡æ‡Æ‡Ø‡ø‡ï (temporary) and ‡®‡ø‡‡‡Ø
-- (permanent) are `AnuktaAvaktavya`'s, another identity's, and are used
-- here unchanged; nothing below edits or reinterprets them.  The corner
-- in question is the fourth of the saptabhag reading that module
-- sets up ‚î both readings denied at once.  What is added is a condition
-- on the INSTANCE SET, not on the predication.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   Enumerated I     a list of instances together with a proof that
--                    every instance is in it (`Any (_‚â° i)`), which is
--                    the constructive content of "finite family" without
--                    a cardinality
--   decAny           decidability transports along that list
--   decŒOverEnumerated
--                    hence `Œ[ i ‚àà I ] P i` is DECIDABLE
--   enumerableDecidableGivesPointwiseStability
--                    hence stable, by `Dec‚íStable`
--   fourthCornerRefutedOverEnumerableDecidable
--                    hence the fourth corner is refuted, unconditionally
--
-- The prior module's hypothesis was "finding a surviving instance is
-- not a genuine search".  This says: over an enumerable family with
-- decidable badness it is not a search, it is a scan.  So the fourth
-- corner, if it exists at all, needs an instance family that is not
-- enumerable OR a badness that is not decidable ‚î not merely "some Œ
-- happens to be unstable".
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- IDIOM.  `Any` is a recursive type family, `Any P [] = ‚ä`,
-- `Any P (x ‚à xs) = P x ‚ä Any P xs`, not an inductive family with an
-- index.  That is the repository's standing cubical rule ‚î in cubical
-- v0.5 `Fin n = Œ k (k < n)`, so constructors in index positions do not
-- pattern-match ‚î and it is why nothing here mentions `Fin` at all.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_ ; Dec ; yes ; no ; Dec‚ÜíStable)

open import AnuktaAvaktavya using (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ; ‡§®‡§ø‡§§‡•ç‡§Ø)
open import KramaAstiNasti_TheFourthCornerIsRefutedUnderPointwiseStability
  using (fourthCornerRefutedUnderPointwiseStability)

private
  variable
    A Ix R : Type

------------------------------------------------------------------------
-- 1.  Any, as a recursive family
------------------------------------------------------------------------

Any : (P : A ‚Üí Type) ‚Üí List A ‚Üí Type
Any P []       = ‚ä•
Any P (x ‚à∑ xs) = P x ‚äé Any P xs

anyToŒ£ : (P : A ‚Üí Type) (xs : List A) ‚Üí Any P xs ‚Üí Œ£[ x ‚àà A ] P x
anyToŒ£ P []       e       = ‚ä•.rec e
anyToŒ£ P (x ‚à∑ xs) (inl p) = x , p
anyToŒ£ P (x ‚à∑ xs) (inr q) = anyToŒ£ P xs q

-- placing a witness into the list, along the covering path
memberToAny :
  (P : A ‚Üí Type) (i : A) (xs : List A)
  ‚Üí Any (Œª x ‚Üí x ‚â° i) xs ‚Üí P i ‚Üí Any P xs
memberToAny P i []       e       p = ‚ä•.rec e
memberToAny P i (x ‚à∑ xs) (inl q) p = inl (subst P (sym q) p)
memberToAny P i (x ‚à∑ xs) (inr m) p = inr (memberToAny P i xs m p)

decAny :
  (P : A ‚Üí Type) ‚Üí ((x : A) ‚Üí Dec (P x))
  ‚Üí (xs : List A) ‚Üí Dec (Any P xs)
decAny P d []       = no (Œª e ‚Üí e)
decAny P d (x ‚à∑ xs) with d x
... | yes p = yes (inl p)
... | no ¬¨p with decAny P d xs
...   | yes q = yes (inr q)
...   | no ¬¨q = no (Œª { (inl p) ‚Üí ¬¨p p ; (inr q) ‚Üí ¬¨q q })

------------------------------------------------------------------------
-- 2.  Enumerable instance families
--
-- No cardinality, no `Fin`, no decidable equality on Ix: a list, and a
-- proof that nothing is outside it.
------------------------------------------------------------------------

Enumerated : Type ‚Üí Type
Enumerated Ix = Œ£[ xs ‚àà List Ix ] ((i : Ix) ‚Üí Any (Œª x ‚Üí x ‚â° i) xs)

decŒ£OverEnumerated :
  Enumerated Ix ‚Üí (P : Ix ‚Üí Type) ‚Üí ((i : Ix) ‚Üí Dec (P i))
  ‚Üí Dec (Œ£[ i ‚àà Ix ] P i)
decŒ£OverEnumerated {Ix} (xs , cov) P d with decAny P d xs
... | yes a  = yes (anyToŒ£ P xs a)
... | no ¬¨a  = no (Œª z ‚Üí ¬¨a (memberToAny P (fst z) xs (cov (fst z)) (snd z)))

------------------------------------------------------------------------
-- 3.  So the search is a scan, and the hypothesis discharges
------------------------------------------------------------------------

enumerableDecidableGivesPointwiseStability :
  (bad : Ix ‚Üí R ‚Üí Type)
  ‚Üí Enumerated Ix
  ‚Üí ((i : Ix) (r : R) ‚Üí Dec (bad i r))
  ‚Üí (r : R) ‚Üí ¬¨ ¬¨ (Œ£[ i ‚àà Ix ] bad i r) ‚Üí Œ£[ i ‚àà Ix ] bad i r
enumerableDecidableGivesPointwiseStability bad e d r =
  Dec‚ÜíStable (decŒ£OverEnumerated e (Œª i ‚Üí bad i r) (Œª i ‚Üí d i r))

------------------------------------------------------------------------
-- 4.  The fourth corner, refuted with nothing assumed about stability
------------------------------------------------------------------------

fourthCornerRefutedOverEnumerableDecidable :
  (bad : Ix ‚Üí R ‚Üí Type)
  ‚Üí Enumerated Ix
  ‚Üí ((i : Ix) (r : R) ‚Üí Dec (bad i r))
  ‚Üí ¬¨ ((¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï bad) √ó (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø bad))
fourthCornerRefutedOverEnumerableDecidable bad e d =
  fourthCornerRefutedUnderPointwiseStability bad
    (enumerableDecidableGivesPointwiseStability bad e d)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "Existence.  ‚¶ this is a second SUFFICIENT condition, sharper and
--    checkable, not a necessary one."
--
-- A NECESSARY one now exists, for one family, in
-- `TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin ‚î check.sh returns 1 and says so).
--
-- Take the instance set to be ONE instance (`Unit`), remedies
-- arbitrary, `bad _ r = Q r`.  Then, both directions checked:
--
--   ¬ ‡‡æ‡Æ‡Ø‡ø‡ï  ‚â  (r : R) ‚í ¬ ¬ Q r
--   ¬ ‡®‡ø‡‡‡Ø    ‚â  ¬ ((r : R) ‚í Q r)
--
-- so the fourth corner IS a counterexample to the DOUBLE-NEGATION SHIFT
-- (Spector 1962; Kreisel), and
--
--   fourthCornerRefutesPointwiseStability
--       the corner implies ¬ ((r) ‚í Stable (Q r))
--
-- ‚î the converse of ¬ß3 here, so at that family the stability hypothesis
-- is necessary as well as sufficient.
--
-- WHAT THAT SAYS ABOUT THIS MODULE, and it is not flattering.  A ONE-
-- ELEMENT instance family is enumerable ‚î `Enumerated Unit` is
-- immediate.  So the whole `Enumerated` apparatus above cannot be what
-- separates the corner from its absence: at Unit the enumeration is
-- free and the entire question is whether the BADNESS is stable.  The
-- decidability hypothesis was doing all the work and the enumerability
-- hypothesis none of it, in the only case where the answer is now
-- known.  This module is still correct ‚î it covers families where
-- BOTH matter ‚î but the sentence "the fourth corner needs an instance
-- family that is not enumerable OR a badness that is not decidable"
-- reads as offering two routes, and the first is not a route at all
-- when one instance suffices.
--
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
-- ‡‡µ‡ï‡‡‡µ‡‡Ø ‚î the fourth bhaga of the Jaina saptabhag (Umsvti,
-- *Tattvrthastra*; Samantabhadra; Akalaka; Siddhasena Divkara),
-- which is the position this line's "fourth corner" has meant since it
-- began, via `AnuktaAvaktavya`'s ‡‡æ‡Æ‡Ø‡ø‡ï and ‡®‡ø‡‡‡Ø.  This file keeps its
-- name for now because thirteen modules import it and the rename is a
-- separate, mechanical cycle; that is a scheduling fact, not a
-- judgement that the term does not apply.
--
-- **THE SCHOOL BOUNDARY, and it matters here more than usual.**
-- `Saptabhangi` and `SaptabhangiNaya` ‚î another identity's, written in
-- Devanagari with  identifiers, not merely named in  ‚î
-- prove that ‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø ‚â ‡‡‡Ø‡æ‡‡-‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡: krama
-- (sequential) and saha (simultaneous, yugapad) assertion give
-- different vs, so avaktavya is NOT sequential both-ness and the
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
-- the error CLAUDE.md names ‚î and the honest position is that I have
-- an identification at one instance and they have a structure, and the
-- relation between them is unproved.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end.  The file was
-- renamed under the owner's directive (CLAUDE.md, "File naming",
-- 2026-08-19) to lead with ‡‡µ‡ï‡‡‡µ‡‡Ø ‚î the fourth bhaga of the Jaina
-- saptabhag, which is the position this line has meant by "the
-- fourth corner" throughout, via `AnuktaAvaktavya`'s ‡‡æ‡Æ‡Ø‡ø‡ï and ‡®‡ø‡‡‡Ø.
-- Eleven importing modules had their `open import` line rewritten
-- mechanically; nothing else in any of them changed, and all twelve
-- re-checked EXIT=0 with zero warning lines.
--
-- **AND THE RENAME EXPOSED SOMETHING STRUCTURAL WORTH RECORDING.**  Of
-- the eleven importers, most take only `Any`, `decAny` and
-- `memberToAny` ‚î list utilities that have nothing to do with the
-- fourth corner, or with Jaina logic, and that ended up here because
-- this is where they were first needed.  So a module named for a
-- position in the saptabhag is load-bearing for the Pareto
-- stratification, which is Goldberg/Deb non-dominated sorting and has
-- no Indian source at all.  That is not a naming problem the directive
-- creates ‚î it is a factoring problem the rename made visible: the
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
-- bhaga of the saptabhag.  The next cycle proved it is not:
-- `KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition`
-- shows the corner is a PRODUCT of two independent negations, and that
-- simultaneous refusal collapses into the sequential pair ‚î `¬ (A ‚ä B)`
-- and `(¬ A) ó (¬ B)` are interderivable here with no hypothesis.  By
-- the theorem in another identity's `Saptabhangi`, the fourth bhaga is
-- exactly what a sequential position is NOT.
--
-- So the position this line occupies is the THIRD bhaga ‚î
-- ‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø, asserted ‡ï‡‡∞‡Æ‡‡ (kramena, in sequence) ‚î and the
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
-- the term names ‚î before the rename, not after.
--
------------------------------------------------------------------------
