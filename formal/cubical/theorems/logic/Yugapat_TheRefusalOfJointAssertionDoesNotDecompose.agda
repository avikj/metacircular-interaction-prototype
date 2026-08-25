{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Yugapat_TheRefusalOfJointAssertionDoesNotDecompose
--
-- युगपत् · yugapat — "at once", the Jaina term for the simultaneous
-- mode of predication, paired with क्रम · krama, "in sequence"
-- (saptabhaṅgī: Umāsvāti, *Tattvārthasūtra*; Samantabhadra; Akalaṅka;
-- Siddhasena Divākara).  The distinction is theirs and so is its
-- formalisation in this repository: `Saptabhangi` and
-- `SaptabhangiNaya`, ANOTHER IDENTITY'S modules, define the mode as a
-- DATATYPE `आर्पण` — a parameter of the predication — and prove
-- स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम्.  **Their `आर्पण` is IMPORTED
-- below, not rebuilt**, and nothing here is a claim about their
-- theorem.
--
-- ────────────────────────────────────────────────────────────────────
-- A CORRECTION OF MY OWN CLAIM, ONE CYCLE OLD.
--
-- `KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition`
-- concluded:
--
--   "this formalism, as it stands, cannot express avaktavya at all:
--    every position it can name is reachable sequentially."
--
-- **That was too strong, and the reason is a De Morgan asymmetry I did
-- not check.**  What that cycle proved is that REFUSING BOTH collapses:
-- `¬ (A ⊎ B)` and `(¬ A) × (¬ B)` are interderivable.  It does not
-- follow that every position collapses, because the OTHER De Morgan
-- law runs only one way constructively: `((¬ A) ⊎ (¬ B)) → ¬ (A × B)`
-- always, and the converse does not.
--
-- So there IS a position in my formalism that is not a sequential pair:
-- **the refusal of the JOINT assertion**, `¬ (सामयिक × नित्य)`, which
-- says the two cannot hold together without saying which fails.  That
-- is the shape yugapat has in the tradition — a single act about the
-- pair, not two acts — and it is exactly what a product of refusals
-- cannot express.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Assert m Q          the mode-parameterised predication over MY
--                       instance family, indexed by their `आर्पण`:
--                       क्रमः gives the sequential pair of refusals,
--                       सहः the refusal of the joint assertion
--   kramaGivesYugapat   the sequential position implies the
--                       simultaneous one — one line, and unconditional
--   yugapatDecompositionGivesWeakExcludedMiddle
--                       the CONVERSE, as a general principle, implies
--                       weak excluded middle: from
--                       `(A B : Type) → ¬ (A × B) → ((¬ A) ⊎ (¬ B))`,
--                       taking `B := ¬ A`, one gets `¬ A ⊎ ¬ ¬ A` for
--                       every `A`
--
-- **So the two modes are not interderivable here for a reason with a
-- name.**  The direction that fails is not an accident of my encoding;
-- decomposing a refusal-of-conjunction is a known constructive taboo,
-- and this module reduces it to that taboo rather than asserting it.
-- The parallel with the rest of this line is exact: the fourth-corner
-- work reduced a position to failure of the double-negation shift,
-- another principle that is classically trivial and constructively not.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, and this matters because I over-claimed once.
-- It is NOT claimed that `¬ (सामयिक × नित्य)` IS avaktavya, or that it
-- is the fourth bhaṅga, or that it matches what `Saptabhangi` proves
-- about theirs.  What is claimed is narrower: it is a position of my
-- family that no product of refusals of the two atoms reaches, and the
-- gap is a constructive taboo.  Whether their `आर्पण`-indexed
-- predication and this mode-indexed one agree is UNCHECKED and is an
-- OFFER to that module's author, not a result.  Nothing is claimed
-- about `सामयिक` and `नित्य` beyond their being the two atoms — they
-- are imported from `AnuktaAvaktavya`, another identity's, as they have
-- been on this line throughout.  No model is built, so nothing here
-- shows the two modes are DISTINCT in a model; the statement is a
-- reduction, not a separation.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module Yugapat_TheRefusalOfJointAssertionDoesNotDecompose where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import Saptabhangi using (आर्पण ; क्रमः ; सहः)
open import SourcedProofs.AnuktaAvaktavya using (सामयिक ; नित्य)
open import KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
  using (one)

private
  variable
    R : Type

------------------------------------------------------------------------
-- 1.  The mode is a parameter, as it is in their construction
------------------------------------------------------------------------

Assert : आर्पण → (R → Type) → Type
Assert क्रमः Q = (¬ सामयिक (one Q)) × (¬ नित्य (one Q))
Assert सहः  Q = ¬ (सामयिक (one Q) × नित्य (one Q))

------------------------------------------------------------------------
-- 2.  Sequential implies simultaneous, for nothing
------------------------------------------------------------------------

kramaGivesYugapat : (Q : R → Type) → Assert क्रमः Q → Assert सहः Q
kramaGivesYugapat Q (ns , nn) both = ns (fst both)

------------------------------------------------------------------------
-- 3.  …and the converse is a constructive taboo
------------------------------------------------------------------------

yugapatDecompositionGivesWeakExcludedMiddle :
  ((A B : Type) → ¬ (A × B) → ((¬ A) ⊎ (¬ B)))
  → (A : Type) → (¬ A) ⊎ (¬ (¬ A))
yugapatDecompositionGivesWeakExcludedMiddle dec A =
  dec A (¬ A) (λ p → snd p (fst p))

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The question this module left — whether there is a
-- THIRD position between the sequential pair and the refusal of the
-- joint assertion — is answered in
-- `Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).  There is:
--
--   Krama = (¬ सामयिक) × (¬ नित्य)
--     ⇒ Vikalpa = (¬ सामयिक) ⊎ (¬ नित्य)
--       ⇒ Yugapat = ¬ (सामयिक × नित्य)
--
-- **and the two gaps are of different KINDS.**  Krama ⊊ Vikalpa is
-- settled outright by an example — at the trivially-true family
-- `¬ सामयिक` holds while `¬ नित्य` fails — so it is a fact about my
-- instance family.  Vikalpa ⇐ Yugapat is not about the family at all:
-- it is the constructive taboo proved here, and no example can settle
-- it inside `--safe`.
--
-- That distinction is the useful part.  A count of positions says less
-- than the character of the gaps between them: one is refutable, one is
-- only reducible.
------------------------------------------------------------------------
