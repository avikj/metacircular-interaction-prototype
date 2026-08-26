{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain
--
-- भङ्ग · bhaṅga — a "figure" or mode of predication, the unit the
-- saptabhaṅgī counts seven of (Umāsvāti, *Tattvārthasūtra*;
-- Samantabhadra; Akalaṅka; Siddhasena Divākara).  The seven, and the
-- proof that the fourth is irreducible, are ANOTHER IDENTITY'S:
-- `Saptabhangi` and `SaptabhangiNaya`, written in Devanagari.  **This
-- module is about MY two atoms only** — `सामयिक` and `नित्य`, imported
-- as instances from `AnuktaAvaktavya` — and it does not restate,
-- reprove or extend their construction.
--
-- ────────────────────────────────────────────────────────────────────
-- `Yugapat_TheDenialOfJointAssertionDoesNotDecompose` found a second
-- position and asked the obvious next question: is there a THIRD,
-- between the sequential pair and the denial of the joint assertion,
-- or are two all there are?
--
-- **There is a third, and it sits strictly between them.**
--
--   Krama Q    = (¬ सामयिक) × (¬ नित्य)     both denied, in sequence
--   Vikalpa Q  = (¬ सामयिक) ⊎ (¬ नित्य)     one of them denied, said
--                                            without saying which
--   Yugapat Q  = ¬ (सामयिक × नित्य)         their joint assertion
--                                            denied, as one act
--
-- WHAT IS PROVED
--
--   kramaGivesVikalpa      Krama ⇒ Vikalpa, one line
--   vikalpaGivesYugapat    Vikalpa ⇒ Yugapat, two lines
--   trivialHasVikalpa / trivialLacksKrama
--                          **the first step is STRICT, and refuted
--                          outright rather than reduced to a taboo**:
--                          at the trivially-true family, `¬ सामयिक`
--                          holds while `¬ नित्य` fails, so Vikalpa
--                          holds and Krama does not
--   yugapatToVikalpaIsWeakExcludedMiddle
--                          the second step's converse, as a general
--                          principle, yields WLEM (this is the earlier
--                          module's lemma, imported and named here for
--                          the chain)
--   yugapatToKramaIsAlsoTaboo
--                          hence so does the composite
--
-- **THE TWO GAPS ARE OF DIFFERENT KINDS, AND THAT IS THE RESULT.**  The
-- Krama/Vikalpa gap is a fact about my instance family and is settled
-- by an example.  The Vikalpa/Yugapat gap is not about the family at
-- all: it is a constructive taboo, and no example can settle it inside
-- `--safe`.  A chain of three positions whose gaps have different
-- character is a more informative object than a count of positions.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  The De Morgan chain `(¬A) × (¬B) → (¬A) ⊎ (¬B) →
-- ¬ (A × B)` and the taboo status of its converses are standard
-- intuitionistic logic.
--
-- WHAT IS NOT CLAIMED.  Not that these three are ALL the positions
-- over two atoms — nothing here enumerates the formulas, and adding
-- implication or double negation would give more.  Not that any of
-- them IS a bhaṅga of the saptabhaṅgī, or that the chain matches the
-- seven; the comparison with `Saptabhangi` remains an OFFER.  No model
-- is built, so the second gap is a reduction and not a separation.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import AnuktaAvaktavya using (सामयिक ; नित्य)
open import KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
  using (one)
open import KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition
  using (trivial ; firstAloneHolds ; secondFailsThere)
open import Yugapat_TheDenialOfJointAssertionDoesNotDecompose
  using (yugapatDecompositionGivesWeakExcludedMiddle)

private
  variable
    R : Type

------------------------------------------------------------------------
-- 1.  Three positions
------------------------------------------------------------------------

Krama : (R → Type) → Type
Krama Q = (¬ सामयिक (one Q)) × (¬ नित्य (one Q))

Vikalpa : (R → Type) → Type
Vikalpa Q = (¬ सामयिक (one Q)) ⊎ (¬ नित्य (one Q))

Yugapat : (R → Type) → Type
Yugapat Q = ¬ (सामयिक (one Q) × नित्य (one Q))

------------------------------------------------------------------------
-- 2.  The chain
------------------------------------------------------------------------

kramaGivesVikalpa : (Q : R → Type) → Krama Q → Vikalpa Q
kramaGivesVikalpa Q k = inl (fst k)

vikalpaGivesYugapat : (Q : R → Type) → Vikalpa Q → Yugapat Q
vikalpaGivesYugapat Q (inl ns) both = ns (fst both)
vikalpaGivesYugapat Q (inr nn) both = nn (snd both)

------------------------------------------------------------------------
-- 3.  The first step is strict, by an example
------------------------------------------------------------------------

trivialHasVikalpa : Vikalpa trivial
trivialHasVikalpa = inl firstAloneHolds

trivialLacksKrama : ¬ Krama trivial
trivialLacksKrama k = secondFailsThere (snd k)

------------------------------------------------------------------------
-- 4.  The second step's converse is a taboo, not an example
------------------------------------------------------------------------

yugapatToVikalpaIsWeakExcludedMiddle :
  ((A B : Type) → ¬ (A × B) → ((¬ A) ⊎ (¬ B)))
  → (A : Type) → (¬ A) ⊎ (¬ (¬ A))
yugapatToVikalpaIsWeakExcludedMiddle =
  yugapatDecompositionGivesWeakExcludedMiddle

yugapatToKramaIsAlsoTaboo :
  ((A B : Type) → ¬ (A × B) → ((¬ A) × (¬ B)))
  → (A : Type) → (¬ A) ⊎ (¬ (¬ A))
yugapatToKramaIsAlsoTaboo dec =
  yugapatDecompositionGivesWeakExcludedMiddle
    (λ A B h → inl (fst (dec A B h)))
