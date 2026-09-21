{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain
--
-- àà™àà— Â bhaga â” a "figure" or mode of predication, the unit the
-- saptabhag counts seven of (Umsvti, *Tattvrthastra*;
-- Samantabhadra; Akalaka; Siddhasena Divkara).  The seven, and the
-- proof that the fourth is irreducible, are in
-- `Saptabhangi` and `SaptabhangiNaya`.  This
-- module is about two atoms only â” `àà¾à®à¯à¿à•` and `à¨à¿ààà¯`, imported
-- as instances from `AnuktaAvaktavya`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `Yugapat_TheDenialOfJointAssertionDoesNotDecompose` found a second
-- position and asked the obvious next question: is there a THIRD,
-- between the sequential pair and the denial of the joint assertion,
-- or are two all there are?
--
-- **There is a third, and it sits strictly between them.**
--
--   Krama Q    = (Â àà¾à®à¯à¿à•) — (Â à¨à¿ààà¯)     both denied, in sequence
--   Vikalpa Q  = (Â àà¾à®à¯à¿à•) âŠ (Â à¨à¿ààà¯)     one of them denied, said
--                                            without saying which
--   Yugapat Q  = Â (àà¾à®à¯à¿à• — à¨à¿ààà¯)         their joint assertion
--                                            denied, as one act
--
-- WHAT IS PROVED
--
--   kramaGivesVikalpa      Krama â’ Vikalpa, one line
--   vikalpaGivesYugapat    Vikalpa â’ Yugapat, two lines
--   trivialHasVikalpa / trivialLacksKrama
--                          **the first step is STRICT, and refuted
--                          outright rather than reduced to a taboo**:
--                          at the trivially-true family, `Â àà¾à®à¯à¿à•`
--                          holds while `Â à¨à¿ààà¯` fails, so Vikalpa
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
-- Krama/Vikalpa gap is a fact about the instance family and is settled
-- by an example.  The Vikalpa/Yugapat gap is not about the family at
-- all: it is a constructive taboo, and no example can settle it inside
-- `--safe`.  A chain of three positions whose gaps have different
-- character is a more informative object than a count of positions.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- The De Morgan chain `(ÂA) — (ÂB) â’ (ÂA) âŠ (ÂB) â’
-- Â (A — B)` and the taboo status of its converses are standard
-- intuitionistic logic.
------------------------------------------------------------------------

module Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_âŠ_ ; inl ; inr)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

open import AnuktaAvaktavya using (à¤¸à¤¾à¤®à¤¯à¤¿à¤• ; à¤¨à¤¿à¤¤à¥à¤¯)
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

Krama : (R â†’ Type) â†’ Type
Krama Q = (Â¬ à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q)) Ã— (Â¬ à¤¨à¤¿à¤¤à¥à¤¯ (one Q))

Vikalpa : (R â†’ Type) â†’ Type
Vikalpa Q = (Â¬ à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q)) âŠ (Â¬ à¤¨à¤¿à¤¤à¥à¤¯ (one Q))

Yugapat : (R â†’ Type) â†’ Type
Yugapat Q = Â¬ (à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q) Ã— à¤¨à¤¿à¤¤à¥à¤¯ (one Q))

------------------------------------------------------------------------
-- 2.  The chain
------------------------------------------------------------------------

kramaGivesVikalpa : (Q : R â†’ Type) â†’ Krama Q â†’ Vikalpa Q
kramaGivesVikalpa Q k = inl (fst k)

vikalpaGivesYugapat : (Q : R â†’ Type) â†’ Vikalpa Q â†’ Yugapat Q
vikalpaGivesYugapat Q (inl ns) both = ns (fst both)
vikalpaGivesYugapat Q (inr nn) both = nn (snd both)

------------------------------------------------------------------------
-- 3.  The first step is strict, by an example
------------------------------------------------------------------------

trivialHasVikalpa : Vikalpa trivial
trivialHasVikalpa = inl firstAloneHolds

trivialLacksKrama : Â¬ Krama trivial
trivialLacksKrama k = secondFailsThere (snd k)

------------------------------------------------------------------------
-- 4.  The second step's converse is a taboo, not an example
------------------------------------------------------------------------

yugapatToVikalpaIsWeakExcludedMiddle :
  ((A B : Type) â†’ Â¬ (A Ã— B) â†’ ((Â¬ A) âŠ (Â¬ B)))
  â†’ (A : Type) â†’ (Â¬ A) âŠ (Â¬ (Â¬ A))
yugapatToVikalpaIsWeakExcludedMiddle =
  yugapatDecompositionGivesWeakExcludedMiddle

yugapatToKramaIsAlsoTaboo :
  ((A B : Type) â†’ Â¬ (A Ã— B) â†’ ((Â¬ A) Ã— (Â¬ B)))
  â†’ (A : Type) â†’ (Â¬ A) âŠ (Â¬ (Â¬ A))
yugapatToKramaIsAlsoTaboo dec =
  yugapatDecompositionGivesWeakExcludedMiddle
    (Î» A B h â†’ inl (fst (dec A B h)))
