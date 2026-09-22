{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoCollisionsAreOneInstantiation
--
-- This module gives
-- a second route to the same two theorems, through
-- `AnyonyaAbhava.anyonyaâ’samsarga` rather than
-- `TranscriptDescent.collisionObstructsDecoder`, and Â§4's observation
-- about what that duplication can and cannot mean.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE COMMON TYPE
--
-- `AnyonyaAbhava.Collision` is already parametric in the
-- presentation type:
--
--     Collision q t = Î[ x ] Î[ x' ] ((q x â‰¡ q x') — Anyonya (t x) (t x'))
--
-- so `Collision eval size` and `Collision asSet cost` are the same type
-- at two different presentation types â” `Expr` and `List Rule` â” and
-- nothing has to be built to relate them.  Â§1 and Â§2 below are the two
-- existing collision terms, typed at that general type by `refl`-level
-- agreement: the isolation those modules performed had already produced
-- instances of it without saying so.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  `Collision eval size`, from `Laghava.laghava-collision`;
--   Â§2  `Collision asSet cost`, from `Anuvrtti.anuvrtti-collision`;
--   Â§3  the general lemma applied at each, by the second route;
--   Â§4  and that the two routes AGREE, provably and for a reason that
--       is not about either lemma: `Â FactorsThrough q t` is a
--       proposition, so any two proofs of it are equal.  Two general
--       lemmas reaching one negation are not two results.
------------------------------------------------------------------------

module TheTwoCollisionsAreOneInstantiation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Relation.Nullary.Properties using (isPropÂ¬)

open import FiniteInformation using (FactorsThrough)
open import AnyonyaAbhava using (Collision ; anyonyaâ†’samsarga)
open import Laghava using (Expr ; eval ; size ; laghava-collision)
open import Anuvrtti using (cost ; asSet ; anuvrtti-collision)
open import OneLemmaFiveSites using (laghava-noFactor ; anuvrtti-noFactor)

------------------------------------------------------------------------
-- 1.  Laghava's isolated pair IS a Collision
------------------------------------------------------------------------

laghavaCollision : Collision eval size
laghavaCollision = laghava-collision

------------------------------------------------------------------------
-- 2.  Anuvrtti's isolated pair IS a Collision
------------------------------------------------------------------------

anuvrttiCollision : Collision asSet cost
anuvrttiCollision = anuvrtti-collision

------------------------------------------------------------------------
-- 3.  The general lemma, applied.  No new argument at either site.
------------------------------------------------------------------------

laghava-does-not-factorâ€² : Â¬ FactorsThrough eval size
laghava-does-not-factorâ€² =
  anyonyaâ†’samsarga eval size
    {x = laghavaCollision .fst} {x' = laghavaCollision .snd .fst}
    (laghavaCollision .snd .snd .fst)
    (laghavaCollision .snd .snd .snd)

anuvrtti-does-not-factorâ€² : Â¬ FactorsThrough asSet cost
anuvrtti-does-not-factorâ€² =
  anyonyaâ†’samsarga asSet cost
    {x = anuvrttiCollision .fst} {x' = anuvrttiCollision .snd .fst}
    (anuvrttiCollision .snd .snd .fst)
    (anuvrttiCollision .snd .snd .snd)

------------------------------------------------------------------------
-- 4.  The two routes agree, and not because the lemmas are related
--
-- `OneLemmaFiveSites` reaches these two theorems through
-- `collisionObstructsDecoder`; Â§3 reaches them through
-- `anyonyaâ’samsarga`.  The results coincide, and the reason is that
-- the target is a negation and negations are propositions.  So the
-- duplication is invisible in the conclusions and visible only in the imports.
------------------------------------------------------------------------

routes-agree-laghava :
  laghava-does-not-factorâ€² â‰¡ laghava-noFactor
routes-agree-laghava = isPropÂ¬ _ _ _

routes-agree-anuvrtti :
  anuvrtti-does-not-factorâ€² â‰¡ anuvrtti-noFactor
routes-agree-anuvrtti = isPropÂ¬ _ _ _
