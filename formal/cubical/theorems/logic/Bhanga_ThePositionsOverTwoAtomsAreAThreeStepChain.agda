{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain
--
-- ‡‡ô‡‡ó ¬ bhaga ‚î a "figure" or mode of predication, the unit the
-- saptabhag counts seven of (Umsvti, *Tattvrthastra*;
-- Samantabhadra; Akalaka; Siddhasena Divkara).  The seven, and the
-- proof that the fourth is irreducible, are ANOTHER IDENTITY'S:
-- `Saptabhangi` and `SaptabhangiNaya`, written in Devanagari.  **This
-- module is about MY two atoms only** ‚î `‡‡æ‡Æ‡Ø‡ø‡ï` and `‡®‡ø‡‡‡Ø`, imported
-- as instances from `AnuktaAvaktavya` ‚î and it does not restate,
-- reprove or extend their construction.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- `Yugapat_TheDenialOfJointAssertionDoesNotDecompose` found a second
-- position and asked the obvious next question: is there a THIRD,
-- between the sequential pair and the denial of the joint assertion,
-- or are two all there are?
--
-- **There is a third, and it sits strictly between them.**
--
--   Krama Q    = (¬ ‡‡æ‡Æ‡Ø‡ø‡ï) ó (¬ ‡®‡ø‡‡‡Ø)     both denied, in sequence
--   Vikalpa Q  = (¬ ‡‡æ‡Æ‡Ø‡ø‡ï) ‚ä (¬ ‡®‡ø‡‡‡Ø)     one of them denied, said
--                                            without saying which
--   Yugapat Q  = ¬ (‡‡æ‡Æ‡Ø‡ø‡ï ó ‡®‡ø‡‡‡Ø)         their joint assertion
--                                            denied, as one act
--
-- WHAT IS PROVED
--
--   kramaGivesVikalpa      Krama ‚í Vikalpa, one line
--   vikalpaGivesYugapat    Vikalpa ‚í Yugapat, two lines
--   trivialHasVikalpa / trivialLacksKrama
--                          **the first step is STRICT, and refuted
--                          outright rather than reduced to a taboo**:
--                          at the trivially-true family, `¬ ‡‡æ‡Æ‡Ø‡ø‡ï`
--                          holds while `¬ ‡®‡ø‡‡‡Ø` fails, so Vikalpa
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
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  The De Morgan chain `(¬A) ó (¬B) ‚í (¬A) ‚ä (¬B) ‚í
-- ¬ (A ó B)` and the taboo status of its converses are standard
-- intuitionistic logic.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

open import AnuktaAvaktavya using (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ; ‡§®‡§ø‡§§‡•ç‡§Ø)
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

Krama : (R ‚Üí Type) ‚Üí Type
Krama Q = (¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q)) √ó (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø (one Q))

Vikalpa : (R ‚Üí Type) ‚Üí Type
Vikalpa Q = (¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q)) ‚äé (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø (one Q))

Yugapat : (R ‚Üí Type) ‚Üí Type
Yugapat Q = ¬¨ (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q) √ó ‡§®‡§ø‡§§‡•ç‡§Ø (one Q))

------------------------------------------------------------------------
-- 2.  The chain
------------------------------------------------------------------------

kramaGivesVikalpa : (Q : R ‚Üí Type) ‚Üí Krama Q ‚Üí Vikalpa Q
kramaGivesVikalpa Q k = inl (fst k)

vikalpaGivesYugapat : (Q : R ‚Üí Type) ‚Üí Vikalpa Q ‚Üí Yugapat Q
vikalpaGivesYugapat Q (inl ns) both = ns (fst both)
vikalpaGivesYugapat Q (inr nn) both = nn (snd both)

------------------------------------------------------------------------
-- 3.  The first step is strict, by an example
------------------------------------------------------------------------

trivialHasVikalpa : Vikalpa trivial
trivialHasVikalpa = inl firstAloneHolds

trivialLacksKrama : ¬¨ Krama trivial
trivialLacksKrama k = secondFailsThere (snd k)

------------------------------------------------------------------------
-- 4.  The second step's converse is a taboo, not an example
------------------------------------------------------------------------

yugapatToVikalpaIsWeakExcludedMiddle :
  ((A B : Type) ‚Üí ¬¨ (A √ó B) ‚Üí ((¬¨ A) ‚äé (¬¨ B)))
  ‚Üí (A : Type) ‚Üí (¬¨ A) ‚äé (¬¨ (¬¨ A))
yugapatToVikalpaIsWeakExcludedMiddle =
  yugapatDecompositionGivesWeakExcludedMiddle

yugapatToKramaIsAlsoTaboo :
  ((A B : Type) ‚Üí ¬¨ (A √ó B) ‚Üí ((¬¨ A) √ó (¬¨ B)))
  ‚Üí (A : Type) ‚Üí (¬¨ A) ‚äé (¬¨ (¬¨ A))
yugapatToKramaIsAlsoTaboo dec =
  yugapatDecompositionGivesWeakExcludedMiddle
    (Œª A B h ‚Üí inl (fst (dec A B h)))
