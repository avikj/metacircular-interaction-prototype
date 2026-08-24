-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheTwoCollisionsAreOneInstantiation
--
-- Thread (3), the लाघव thread, worked without inventing anything.
--
-- ────────────────────────────────────────────────────────────────────
-- PRIOR ART FIRST, BECAUSE THIS FILE ALMOST REPEATED IT
--
-- `NaturalMachine.Laghava` §6 and `NaturalMachine.Anuvrtti` §6 each
-- isolate a collision and ask for the corpus's general lemma to be
-- applied to it.  I set out to make that repair.  It was already made:
-- `NaturalMachine.OneLemmaFiveSites` §1–§2 derives
--
--     laghava-noFactor  : ¬ FactorsThrough eval size
--     anuvrtti-noFactor : ¬ FactorsThrough asSet cost
--
-- from `TranscriptDescent.collisionObstructsDecoder`, term for term the
-- construction §3 below performs.  It is in the latch.  It also carries
-- a distinction this file did not have — collision versus exhaustion as
-- two routes to `¬ FactorsThrough`, available depending on the decoder
-- space — and says that reading five sites as "one lemma" would flatten
-- it.
--
-- HOW THE CHECK MISSED IT, stated because the check is the point.  The
-- standing rule is to grep the latch for the THREAD'S NAME before
-- writing.  That was done: "Laghava", "Anuvrtti", "Pratyahara",
-- "Apavada" all matched, and `OneLemmaFiveSites` contains none of those
-- words.  Grepping names finds modules named after the thread; it does
-- not find the module that already proves the statement.  The check
-- that works is to grep for the STATEMENT — here, `¬ FactorsThrough
-- eval size` — which was the technique used one cycle earlier and not
-- used here.
--
-- WHAT SURVIVES, and it is smaller than what this file set out to do:
-- a second route to the same two theorems, through
-- `AnyonyaAbhava.anyonya→samsarga` rather than
-- `TranscriptDescent.collisionObstructsDecoder`, and §4's observation
-- about what that duplication can and cannot mean.
--
-- ────────────────────────────────────────────────────────────────────
-- AND THE COMMON TYPE WAS NEVER MISSING
--
-- The standing description of this thread has said that a joint
-- statement across the sites "needs a common presentation type, and
-- inventing one to make the pattern work is the failure mode".  The
-- first half is wrong and the warning was therefore aimed at nothing.
--
-- `NaturalMachine.AnyonyaAbhava.Collision` is already parametric in the
-- presentation type:
--
--     Collision q t = Σ[ x ] Σ[ x' ] ((q x ≡ q x') × Anyonya (t x) (t x'))
--
-- so `Collision eval size` and `Collision asSet cost` are the same type
-- at two different presentation types — `Expr` and `List Rule` — and
-- nothing has to be built to relate them.  §1 and §2 below are the two
-- existing collision terms, typed at that general type by `refl`-level
-- agreement: the isolation those modules performed had already produced
-- instances of it without saying so.
--
-- ────────────────────────────────────────────────────────────────────
-- A CORRECTION TO MY OWN STANDING DESCRIPTION: IT IS TWO SITES, NOT
-- THREE
--
-- The thread has been carried as "anuvṛtti AND pratyāhāra AND apavāda".
-- A grep of `Pratyahara.agda` and `Apavada.agda` for `collision` and
-- `Collision` returns nothing, and reading their SIGNATURE LISTS finds
-- no pair of presentations agreeing on a coarse map and differing on a
-- measure — `no-3-list` is a Σ but not that shape, and `kinds-exclude`
-- is a disjointness.  So on that evidence there are two sites of this
-- shape, not three.
--
-- That is a SEARCH RESULT: a collision phrased without the word — say,
-- as an inlined `¬` of an equality between two named objects — would
-- evade both greps, and §3 does not claim to have classified those two
-- modules, only to have failed to find the shape in them.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `Collision eval size`, from `Laghava.laghava-collision`;
--   §2  `Collision asSet cost`, from `Anuvrtti.anuvrtti-collision`;
--   §3  the general lemma applied at each, by the second route;
--   §4  and that the two routes AGREE, provably and for a reason that
--       is not about either lemma: `¬ FactorsThrough q t` is a
--       proposition, so any two proofs of it are equal.  Two general
--       lemmas reaching one negation are not two results.
--
-- स्यात् — in the respect of what is proved, nothing new: both results
--          existed, by private proofs.
-- स्यात् — in the respect of what carries them, the private proofs are
--          no longer load-bearing, and a third site of the same shape
--          would now cost one line.
--
-- Those do not collapse.  The private proofs are not deleted and are
-- not wrong; what changes is which argument the corpus depends on.
--
-- NOT CLAIMED.  That the private proofs should be removed (they are the
-- record); that `Collision` is the right general notion for any site
-- outside these two; that the pattern across two sites is anything —
-- two instances are two instances, and what is computed downstream here
-- is only that the general lemma covers both.
------------------------------------------------------------------------

module NaturalMachine.TheTwoCollisionsAreOneInstantiation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Relation.Nullary.Properties using (isProp¬)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.AnyonyaAbhava using (Collision ; anyonya→samsarga)
open import NaturalMachine.Laghava using (Expr ; eval ; size ; laghava-collision)
open import NaturalMachine.Anuvrtti using (cost ; asSet ; anuvrtti-collision)
open import NaturalMachine.OneLemmaFiveSites using (laghava-noFactor ; anuvrtti-noFactor)

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

laghava-does-not-factor′ : ¬ FactorsThrough eval size
laghava-does-not-factor′ =
  anyonya→samsarga eval size
    {x = laghavaCollision .fst} {x' = laghavaCollision .snd .fst}
    (laghavaCollision .snd .snd .fst)
    (laghavaCollision .snd .snd .snd)

anuvrtti-does-not-factor′ : ¬ FactorsThrough asSet cost
anuvrtti-does-not-factor′ =
  anyonya→samsarga asSet cost
    {x = anuvrttiCollision .fst} {x' = anuvrttiCollision .snd .fst}
    (anuvrttiCollision .snd .snd .fst)
    (anuvrttiCollision .snd .snd .snd)

------------------------------------------------------------------------
-- 4.  The two routes agree, and not because the lemmas are related
--
-- `OneLemmaFiveSites` reaches these two theorems through
-- `collisionObstructsDecoder`; §3 reaches them through
-- `anyonya→samsarga`.  The results coincide, and the reason is that
-- the target is a negation and negations are propositions.  So the
-- duplication is invisible in the conclusions and can only ever be seen
-- in the imports — which is exactly why grepping for the STATEMENT is
-- the check that works.
------------------------------------------------------------------------

routes-agree-laghava :
  laghava-does-not-factor′ ≡ laghava-noFactor
routes-agree-laghava = isProp¬ _ _ _

routes-agree-anuvrtti :
  anuvrtti-does-not-factor′ ≡ anuvrtti-noFactor
routes-agree-anuvrtti = isProp¬ _ _ _
