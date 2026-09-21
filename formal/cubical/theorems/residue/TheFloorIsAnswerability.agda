{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheFloorIsAnswerability
--
-- The witness thread has a ceiling theorem whose hypothesis is now
-- located exactly (`TheCeilingIsAboutReading`: the decoders must have
-- something discrete to read).  Its FLOOR has been proved four times â”
-- `WitnessNumberIsTwo.singleton-never-refutes`,
-- `SiteAudit.full-singleton-never`,
-- `TheCeilingIsAboutReading.probe-singleton-never`,
-- `BarrierIsTwoWitnesses.one-config-never-suffices` â” each time by
-- exhibiting a constant decoder, and each time described as holding
-- "with no hypothesis at all".
--
-- That description is wrong, and this module says what the hypothesis
-- is.  It is not constancy and it is not a function space.  It is:
--
--     Answerable law  =  (x : X) â’ Î[ d âˆˆ D ] law d x
--
-- every point is answered by SOME decoder.  Constant decoders are one
-- way to have that and not the only way, and where it fails the floor
-- fails with it â” witness number 1 is realised (Â§3).
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SYMMETRY THAT CLOSES THE THREAD
--
--   FLOOR â‰ 2   the decoder space ANSWERS every point       Â§2
--   CEILING â‰ 2 the decoders READ a discrete probe          TheCeilingIsAboutReading
--
-- Both ends are properties of the decoder space and neither is a
-- property of the mathematics being obstructed.  That is the whole
-- content of the deflation, stated as economically as it can be: the
-- cost of an absence is fixed by what its decoders can do, and the two
-- capacities that fix it are answering and reading.
--
-- Every site in this corpus has both, which is why every site is 2.
-- `WitnessNumberIsUnbounded` drops reading and gets 3;
-- `WitnessNumberCanBeInfinite` drops it further and gets no number at
-- all; Â§3 here drops answering and gets 1.  The four cases exhaust the
-- possibilities the two capacities allow.
------------------------------------------------------------------------

module TheFloorIsAnswerability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; Â¬-<-zero ; pred-â‰¤-pred)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import WitnessNumberIsTwo using (AllHold ; Refutes ; factorLaw)
open import WitnessNumberIsThePotential using (WitnessNumberIs)

private
  variable
    â„“d â„“x â„“y â„“t â„“ : Level

------------------------------------------------------------------------
-- 1.  The hypothesis the floor actually uses
------------------------------------------------------------------------

Answerable : {D : Type â„“d} {X : Type â„“x} â†’ (D â†’ X â†’ Type â„“) â†’ Type (â„“-max â„“d (â„“-max â„“x â„“))
Answerable {D = D} {X = X} law = (x : X) â†’ Î£[ d âˆˆ D ] law d x

------------------------------------------------------------------------
-- 2.  THE FLOOR: answerability is exactly what it needs
------------------------------------------------------------------------

answerableâ†’no-singleton :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ Answerable law â†’ (x : X) â†’ Â¬ Refutes law (x âˆ· [])
answerableâ†’no-singleton law ans x ref =
  ref (ans x .fst) (ans x .snd , tt*)

answerableâ†’no-empty :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ Answerable law â†’ (x : X) â†’ Â¬ Refutes law []
answerableâ†’no-empty law ans x ref = ref (ans x .fst) tt*

-- and a function space is answerable because it has constants: this is
-- the one line the four earlier proofs were each re-deriving
factorLaw-answerable :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) â†’ Answerable (factorLaw q t)
factorLaw-answerable q t x = (Î» _ â†’ t x) , refl

------------------------------------------------------------------------
-- 3.  WITHOUT ANSWERABILITY THE FLOOR IS 1
--
-- One decoder, one point, and the decoder wrong there.  Nothing exotic
-- is needed: this is the smallest unanswerable system there is.
------------------------------------------------------------------------

lonelyLaw : Unit â†’ Unit â†’ Typeâ‚€
lonelyLaw _ _ = âŠ¥

not-answerable : Â¬ Answerable lonelyLaw
not-answerable ans = ans tt .snd

one-refutes : Refutes lonelyLaw (tt âˆ· [])
one-refutes d (bad , _) = bad

empty-does-not : Â¬ Refutes lonelyLaw []
empty-does-not ref = ref tt tt*

lonely-witness-number-1 : WitnessNumberIs lonelyLaw 1
lonely-witness-number-1 = (tt âˆ· [] , refl , one-refutes) , least
  where
  least : (ys : List Unit) â†’ length ys < 1 â†’ Â¬ Refutes lonelyLaw ys
  least []       _  = empty-does-not
  least (y âˆ· ys) lt = Empty.rec (Â¬-<-zero (pred-â‰¤-pred lt))

------------------------------------------------------------------------
-- 4.  The four cases, and that they are the four
------------------------------------------------------------------------

-- answering â“ reading â“  âŸ 2   every site here (WhyTheSitesAreTwo,
--                                TheCeilingIsAboutReading, SiteAudit)
-- answering â“ reading â—  âŸ 3   WitnessNumberIsUnbounded
-- answering â“ reading â—  âŸ âˆž   WitnessNumberCanBeInfinite
-- answering â—            âŸ 1   Â§3 above

-- The three-standpoint system of `WitnessNumberIsUnbounded` IS
-- answerable â” which is why its number is 3 and not 1, and is the fact
-- that makes the two capacities independent rather than nested.
open import WitnessNumberIsUnbounded
  using (Three ; t0 ; t1 ; t2 ; law ; missingâ‚)

three-is-answerable : Answerable law
three-is-answerable x = missingâ‚ x .fst , missingâ‚ x .snd .fst

------------------------------------------------------------------------
-- 5.  What this settles.
--
-- SETTLED.  The floor is not free.  It is answerability, it was being
-- re-proved by hand at every site through the accident that function
-- spaces contain constants, and it fails â” with witness number dropping
-- to 1 â” as soon as some point is answered by no decoder at all.
--
-- CORRECTED.  Four modules describe their floor as holding "with no
-- hypothesis at all" or "no hypotheses".  Each is correct AT ITS SITE,
-- since each site's decoder space is a function space into an inhabited
-- type; none is correct in general.  The phrase was doing the work of
-- an unstated lemma, which is the same error this corpus's protocol is
-- written against, in miniature.
--
-- WHAT IT MEANS.  A point no decoder answers is an absence with a single
-- witness â” the nearest thing this measure has to a BARE absence, which
-- `Abhava` forbids in its own setting.  Here it is not forbidden but it
-- is degenerate: the obstruction is not that two things are confused,
-- which is what every genuine site in this corpus turned out to be, but
-- that one thing is unreachable.  That is why 2 and not 1 is the
-- interesting floor.
--
-- OPEN, named and not estimated.  Whether any site in this corpus fails
-- answerability.  `SiteAudit` enumerated the sites and every one has a
-- function space into an inhabited type, so none does; whether the
-- corpus contains obstructions NOT of factorisation shape that do has
-- not been checked.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  CORRECTION to Â§4, appended the same day.
--
-- Â§4 lists "the four cases" of two capacities and calls them exhaustive.
-- They are not four cases of two binary capacities: the third row
-- repeats the second's hypotheses, and (answering â—, reading â“) is
-- absent.  `WitnessDichotomy` shows why the missing row
-- does not exist as a case:
--
--     unanswerableâ’one : Â (Î[ d âˆˆ D ] law d x) â’ Refutes law (x âˆ [])
--
-- one unanswerable point refutes on its own, whatever the decoders can
-- read.  So answerability is not one of two independent axes.  It is a
-- GATE: fail it and the number is 1; pass it and reading decides between
-- 2 and everything above.  The picture is a chain, not a square, and Â§4
-- drew a square.
--
-- The independence claim in the commit that introduced this module â”
-- "the capacities are independent, not nested" â” is wrong in the same
-- way.  `three-is-answerable` does show the three-standpoint system
-- answers without reading, which is a real fact; it does not make the
-- capacities symmetric, because no system fails answering and is
-- thereby anything other than 1.
------------------------------------------------------------------------
