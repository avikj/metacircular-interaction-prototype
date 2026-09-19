{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoCollisionsAreOneInstantiation
--
-- Thread (3), the à²à¾à˜àµ thread, worked without inventing anything.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- PRIOR ART FIRST, BECAUSE THIS FILE ALMOST REPEATED IT
--
-- `Laghava` Â§6 and `Anuvrtti` Â§6 each
-- isolate a collision and ask for the corpus's general lemma to be
-- applied to it.  I set out to make that repair.  It was already made:
-- `OneLemmaFiveSites` Â§1â“Â§2 derives
--
--     laghava-noFactor  : Â FactorsThrough eval size
--     anuvrtti-noFactor : Â FactorsThrough asSet cost
--
-- from `TranscriptDescent.collisionObstructsDecoder`, term for term the
-- construction Â§3 below performs.  It is in the latch.  It also carries
-- a distinction this file did not have â” collision versus exhaustion as
-- two routes to `Â FactorsThrough`, available depending on the decoder
-- space â” and says that reading five sites as "one lemma" would flatten
-- it.
--
-- HOW THE CHECK MISSED IT, stated because the check is the point.  The
-- standing rule is to grep the latch for the THREAD'S NAME before
-- writing.  That was done: "Laghava", "Anuvrtti", "Pratyahara",
-- "Apavada" all matched, and `OneLemmaFiveSites` contains none of those
-- words.  Grepping names finds modules named after the thread; it does
-- not find the module that already proves the statement.  The check
-- that works is to grep for the STATEMENT â” here, `Â FactorsThrough
-- eval size` â” which was the technique used one cycle earlier and not
-- used here.
--
-- WHAT SURVIVES, and it is smaller than what this file set out to do:
-- a second route to the same two theorems, through
-- `AnyonyaAbhava.anyonyaâ’samsarga` rather than
-- `TranscriptDescent.collisionObstructsDecoder`, and Â§4's observation
-- about what that duplication can and cannot mean.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND THE COMMON TYPE WAS NEVER MISSING
--
-- The standing description of this thread has said that a joint
-- statement across the sites "needs a common presentation type, and
-- inventing one to make the pattern work is the failure mode".  The
-- first half is wrong and the warning was therefore aimed at nothing.
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
-- A CORRECTION TO MY OWN STANDING DESCRIPTION: IT IS TWO SITES, NOT
-- THREE
--
-- The thread has been carried as "anuvtti AND pratyhra AND apavda".
-- A grep of `Pratyahara.agda` and `Apavada.agda` for `collision` and
-- `Collision` returns nothing, and reading their SIGNATURE LISTS finds
-- no pair of presentations agreeing on a coarse map and differing on a
-- measure â” `no-3-list` is a Î but not that shape, and `kinds-exclude`
-- is a disjointness.  So on that evidence there are two sites of this
-- shape, not three.
--
-- That is a SEARCH RESULT: a collision phrased without the word â” say,
-- as an inlined `Â` of an equality between two named objects â” would
-- evade both greps, and Â§3 does not claim to have classified those two
-- modules, only to have failed to find the shape in them.
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
--
-- ààà¯à¾àà â” in the respect of what is proved, nothing new: both results
--          existed, by private proofs.
-- ààà¯à¾àà â” in the respect of what carries them, the private proofs are
--          no longer load-bearing, and a third site of the same shape
--          would now cost one line.
--
-- Those do not collapse.  The private proofs are not deleted and are
-- not wrong; what changes is which argument the corpus depends on.
--
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
-- duplication is invisible in the conclusions and can only ever be seen
-- in the imports â” which is exactly why grepping for the STATEMENT is
-- the check that works.
------------------------------------------------------------------------

routes-agree-laghava :
  laghava-does-not-factorâ€² â‰¡ laghava-noFactor
routes-agree-laghava = isPropÂ¬ _ _ _

routes-agree-anuvrtti :
  anuvrtti-does-not-factorâ€² â‰¡ anuvrtti-noFactor
routes-agree-anuvrtti = isPropÂ¬ _ _ _
