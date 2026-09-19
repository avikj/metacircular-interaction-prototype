{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessNumberIsTwo
--
-- CORRECTION TO `TwoProfilesSuffice`, one commit old.
--
-- That module concluded: "the invariant is the NUMBER OF WITNESSES:
-- 1 for ‡≤‡æ‡ò‡µ, ‡‡®‡‡µ‡‡‡‡‡ø, carry/borrow and the fuel obstructions; 2 for
-- ‡‡µ‡ï‡‡‡µ‡‡Ø."  That counts in two different units.  A collision is ONE
-- PAIR, and a pair is TWO POINTS.  Under a single measure the two sites
-- do not differ at all.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ONE MEASURE
--
-- An absence of the form `¬ Œ[ d ‚àà D ] ((x : X) ‚í law d x)` is refuted
-- by a finite list of X-points when no decoder survives all of them:
--
--     AllHold law d xs   every point in xs is answered correctly by d
--     Refutes law xs  =  (d : D) ‚í ¬ AllHold law d xs
--
-- `Refutes` on any list gives the absence (¬ß2).  The question is the
-- least length that does, and it is the same everywhere in this corpus:
--
--   ¬ß3  ONE IS NEVER ENOUGH, for any `FactorsThrough` obstruction, with
--       no hypotheses at all.  The constant decoder `Œª _ ‚í t x` answers
--       x correctly, so `{x}` never refutes.  One line.
--
--   ¬ß4  A COLLISION IS EXACTLY A REFUTING PAIR.  So every collision site
--       has witness number exactly 2.
--
--   ¬ß5  AND SO DOES THE ‡‡µ‡ï‡‡‡µ‡‡Ø SITE, whose decoder space is six atoms
--       rather than a function space: `every-profile-is-said` gives the
--       lower bound and `pair-separates` the upper.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS SETTLES
--
-- The collision/exhaustion distinction dissolves, but not the way the
-- last two commits said in either direction.  It is not "1 versus 2";
-- it is 2 versus 2.  What actually differed was the ROUTE to the pair ‚î
-- construct it from a collision, or find it by looking ‚î and that is a
-- fact about how the witness is obtained, not about the absence.
--
-- Six was never a measurement of anything.  Nor, it turns out, was the
-- distinction that replaced it.  The stable quantity is 2, and ¬ß3 says
-- why the floor cannot be 1: a single point is always fittable, because
-- a decoder is only constrained where you constrain it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- FOR THE DEFLATIONARY THREAD
--
-- Every absence in this corpus that has been made exact is exact by two
-- witnesses.  That is a much flatter landscape than "barrier" language
-- suggests, and it is now measured rather than asserted: the absences
-- are not merely decidable, they are uniformly CHEAP, and the cost is
-- the same at a function space as at a six-atom language.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module WitnessNumberIsTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import FiniteInformation
  using (FactorsThrough ; sameObservation‚ÜísamePoint)

open import SaptabhangiNaya using (Profile ; Vacana)
open import TwoProfilesSuffice
  using (Says ; œÜ‚ÇÅ ; œÜ‚ÇÇ ; pair-separates ; every-profile-is-said)

private
  variable
    ‚Ñìd ‚Ñìx ‚Ñìy ‚Ñìt ‚Ñì : Level

------------------------------------------------------------------------
-- 1.  The measure
------------------------------------------------------------------------

AllHold : {D : Type ‚Ñìd} {X : Type ‚Ñìx}
        ‚Üí (D ‚Üí X ‚Üí Type ‚Ñì) ‚Üí D ‚Üí List X ‚Üí Type ‚Ñì
AllHold law d []       = Unit*
AllHold law d (x ‚à∑ xs) = law d x √ó AllHold law d xs

Refutes : {D : Type ‚Ñìd} {X : Type ‚Ñìx}
        ‚Üí (D ‚Üí X ‚Üí Type ‚Ñì) ‚Üí List X ‚Üí Type (‚Ñì-max ‚Ñìd ‚Ñì)
Refutes {D = D} law xs = (d : D) ‚Üí ¬¨ AllHold law d xs

------------------------------------------------------------------------
-- 2.  A refuting list gives the absence
------------------------------------------------------------------------

everywhere : {D : Type ‚Ñìd} {X : Type ‚Ñìx} (law : D ‚Üí X ‚Üí Type ‚Ñì)
           ‚Üí (d : D) ‚Üí ((x : X) ‚Üí law d x) ‚Üí (xs : List X) ‚Üí AllHold law d xs
everywhere law d full []       = tt*
everywhere law d full (x ‚à∑ xs) = full x , everywhere law d full xs

refutes‚Üíabsent : {D : Type ‚Ñìd} {X : Type ‚Ñìx} (law : D ‚Üí X ‚Üí Type ‚Ñì)
               ‚Üí (xs : List X) ‚Üí Refutes law xs
               ‚Üí ¬¨ (Œ£[ d ‚àà D ] ((x : X) ‚Üí law d x))
refutes‚Üíabsent law xs ref (d , full) = ref d (everywhere law d full xs)

------------------------------------------------------------------------
-- 3.  ONE POINT IS NEVER ENOUGH ‚î for any factorisation obstruction
--
-- `FactorsThrough q t` is exactly `Œ[ d ] ((x : X) ‚í factorLaw q t d x)`,
-- so this measure applies to it verbatim.  And the constant decoder
-- answers any single point, with no hypotheses on q, t, X, Y or T.
------------------------------------------------------------------------

factorLaw : {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
          ‚Üí (q : X ‚Üí Y) (t : X ‚Üí T) ‚Üí (Image q ‚Üí T) ‚Üí X ‚Üí Type ‚Ñìt
factorLaw q t d x = d (restrictToImage q x) ‚â° t x

law-is-factoring : {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
                 ‚Üí (q : X ‚Üí Y) (t : X ‚Üí T)
                 ‚Üí (Œ£[ d ‚àà (Image q ‚Üí T) ] ((x : X) ‚Üí factorLaw q t d x))
                 ‚â° FactorsThrough q t
law-is-factoring q t = refl

singleton-never-refutes :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
  (q : X ‚Üí Y) (t : X ‚Üí T) (x : X)
  ‚Üí ¬¨ Refutes (factorLaw q t) (x ‚à∑ [])
singleton-never-refutes q t x ref = ref (Œª _ ‚Üí t x) (refl , tt*)

------------------------------------------------------------------------
-- 4.  A COLLISION IS EXACTLY A REFUTING PAIR
------------------------------------------------------------------------

collision‚Üírefutes :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
  (q : X ‚Üí Y) (t : X ‚Üí T) {x x' : X}
  ‚Üí q x ‚â° q x' ‚Üí ¬¨ (t x ‚â° t x')
  ‚Üí Refutes (factorLaw q t) (x ‚à∑ x' ‚à∑ [])
collision‚Üírefutes q t {x} {x'} same differ d (at-x , at-x' , _) =
  differ (sym at-x ‚àô cong d (sameObservation‚ÜísamePoint q same) ‚àô at-x')

-- so the witness number at any collision site is exactly 2:
-- 2 suffices (above) and 1 does not (¬ß3)
collision-witness-number-2 :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
  (q : X ‚Üí Y) (t : X ‚Üí T) {x x' : X}
  ‚Üí q x ‚â° q x' ‚Üí ¬¨ (t x ‚â° t x')
  ‚Üí Refutes (factorLaw q t) (x ‚à∑ x' ‚à∑ [])
   √ó ((z : X) ‚Üí ¬¨ Refutes (factorLaw q t) (z ‚à∑ []))
collision-witness-number-2 q t same differ =
  collision‚Üírefutes q t same differ , singleton-never-refutes q t

------------------------------------------------------------------------
-- 5.  THE ‡‡µ‡ï‡‡‡µ‡‡Ø SITE IS ALSO 2 ‚î with a six-atom decoder space
--
-- Its decoders are not a function space, so ¬ß3 does not apply to it and
-- the lower bound has to come from `every-profile-is-said`.  It does,
-- and the answer is the same.
------------------------------------------------------------------------

vacanaLaw : Vacana ‚Üí Profile ‚Üí Type‚ÇÄ
vacanaLaw v œÜ = Says v œÜ

avaktavya-two-suffice : Refutes vacanaLaw (œÜ‚ÇÅ ‚à∑ œÜ‚ÇÇ ‚à∑ [])
avaktavya-two-suffice v (at-1 , at-2 , _) = pick (pair-separates v)
  where
  pick : ((¬¨ Says v œÜ‚ÇÅ) ‚äé (¬¨ Says v œÜ‚ÇÇ)) ‚Üí ‚ä•
  pick (inl bad) = bad at-1
  pick (inr bad) = bad at-2

avaktavya-one-never : (œÜ : Profile) ‚Üí ¬¨ Refutes vacanaLaw (œÜ ‚à∑ [])
avaktavya-one-never œÜ ref =
  ref (every-profile-is-said œÜ .fst) (every-profile-is-said œÜ .snd , tt*)

avaktavya-witness-number-2 :
  Refutes vacanaLaw (œÜ‚ÇÅ ‚à∑ œÜ‚ÇÇ ‚à∑ [])
  √ó ((œÜ : Profile) ‚Üí ¬¨ Refutes vacanaLaw (œÜ ‚à∑ []))
avaktavya-witness-number-2 = avaktavya-two-suffice , avaktavya-one-never

------------------------------------------------------------------------
-- 6.  Two corrections in two commits, and what they have in common.
--
--   `OneLemmaFiveSites`  asserted a LOWER bound (no pair suffices) by
--                        reading an UPPER bound off a finite type.
--   `TwoProfilesSuffice` fixed that, then compared a count of PAIRS
--                        with a count of POINTS and reported 1 versus 2.
--
-- Both errors are the same error: a quantity was named before a measure
-- was fixed.  Once the measure is fixed ‚î least refuting list, one
-- definition for every site ‚î there is nothing left to compare, because
-- the answer is 2 everywhere and ¬ß3 explains the floor.
--
-- OPEN, named and not estimated: whether any absence in this corpus has
-- witness number above 2.  ¬ß3 gives a general floor and nothing here
-- gives a general ceiling.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  THE OPEN ITEM IN ¬ß6 IS SETTLED, negatively.
--
-- ¬ß6 asked "whether any absence in this corpus has witness number above
-- 2" and noted a general floor with no general ceiling.  There is no
-- general ceiling: `WitnessNumberIsUnbounded` realises
-- witness number exactly 3, with three standpoints each wrong at
-- exactly one of three points.  Every pair leaves a survivor; the nine
-- cases are the pigeonhole written out.
--
-- So the uniform 2 across this corpus is a property of ITS SITES, not
-- of the notion of absence.  That is what having a measure buys, and it
-- could not be said before one was fixed.
--
-- Still open there, and narrower: whether any absence arising from the
-- MATHEMATICS here ‚î rather than constructed to order ‚î exceeds 2.
-- Nothing found so far does.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  CORRECTION to ¬ß3's description, appended 2026-08-18.
--
-- ¬ß3 is headed "ONE POINT IS NEVER ENOUGH ‚î for any factorisation
-- obstruction" and says the constant decoder answers a single point
-- "with no hypotheses on q, t, X, Y or T".  The theorem is right and the
-- description hides a hypothesis.
--
-- `TheFloorIsAnswerability` names it:
--
--     Answerable law = (x : X) ‚í Œ[ d ‚àà D ] law d x
--
-- The floor is answerability, not constancy.  A function space into an
-- inhabited type is answerable ‚î `factorLaw-answerable` is the one line
-- that four modules were each re-deriving by hand ‚î but answerability
-- can fail, and where it fails the floor drops to 1
-- (`lonely-witness-number-1`).
--
-- So the thread's two bounds are both properties of the DECODER SPACE
-- and neither is a property of the mathematics obstructed:
--
--     floor   ‚â 2   the decoders ANSWER every point
--     ceiling ‚â 2   the decoders READ a discrete probe
--
-- and the capacities are independent: the three-standpoint system of
-- `WitnessNumberIsUnbounded` answers but does not read, which is why its
-- number is 3 rather than 1.
------------------------------------------------------------------------
