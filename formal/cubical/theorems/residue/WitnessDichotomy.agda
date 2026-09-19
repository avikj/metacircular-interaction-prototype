{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessDichotomy
--
-- The closing statement of the witness thread, and a correction to the
-- case analysis in `TheFloorIsAnswerability` Â§4.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CORRECTION FIRST
--
-- That Â§4 lists "the four cases" as
--
--     answering â“ reading â“  âŸ 2
--     answering â“ reading â—  âŸ 3
--     answering â“ reading â—  âŸ âˆž
--     answering â—            âŸ 1
--
-- and calls them exhaustive.  They are not four cases of two binary
-- capacities: the third row repeats the second's hypotheses, and
-- (answering â—, reading â“) is missing.  The reason it is missing is that
-- it does not matter, and that is a theorem rather than an oversight:
--
--     unanswerableâ’one : Â (Î[ d âˆˆ D ] law d x) â’ Refutes law (x âˆ [])
--
-- One unanswerable point refutes on its own, whatever else the decoders
-- can read.  So answerability is not one of two independent axes â” it is
-- a GATE.  Fail it and the number is 1; pass it and reading decides
-- between 2 and everything above.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- SO THE PICTURE IS A CHAIN, NOT A SQUARE
--
--     Â answerable                      âŸ 1        Â§1
--     answerable, readable              âŸ 2        Â§2, ceiling elsewhere
--     answerable, not readable          âŸ â‰ 2, and 3 and âˆž both occur
--
-- and the middle line is the one every site in this corpus sits on.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND ONE PIECE OF DUPLICATION REMOVED
--
-- `laghava-probe-is-two`, `barrier-witness-number-2` and
-- `laghava-is-two` each assemble "a collision plus the floor gives
-- exactly 2" by hand, with the same length bookkeeping three times.
-- Â§2 does it once.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module WitnessDichotomy where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; Â¬-<-zero ; pred-â‰¤-pred)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import WitnessNumberIsTwo using (AllHold ; Refutes)
open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import TheFloorIsAnswerability
  using (Answerable ; answerableâ†’no-singleton ; answerableâ†’no-empty)

private
  variable
    â„“d â„“x â„“ : Level

------------------------------------------------------------------------
-- 1.  ANSWERABILITY IS A GATE, NOT AN AXIS
------------------------------------------------------------------------

unanswerableâ†’one :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“) (x : X)
  â†’ Â¬ (Î£[ d âˆˆ D ] law d x)
  â†’ Refutes law (x âˆ· [])
unanswerableâ†’one law x un d (h , _) = un (d , h)

-- exactly 1, given only that there is some decoder at all (else the
-- empty list would already refute)
unanswerable-witness-number-1 :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ D â†’ (x : X) â†’ Â¬ (Î£[ d âˆˆ D ] law d x)
  â†’ WitnessNumberIs law 1
unanswerable-witness-number-1 law dâ‚€ x un =
    (x âˆ· [] , refl , unanswerableâ†’one law x un)
  , least
  where
  least : (ys : List _) â†’ length ys < 1 â†’ Â¬ Refutes law ys
  least []       _  = Î» ref â†’ ref dâ‚€ tt*
  least (y âˆ· ys) lt = Empty.rec (Â¬-<-zero (pred-â‰¤-pred lt))

------------------------------------------------------------------------
-- 2.  PAST THE GATE: a collision plus the floor is exactly 2, once
--
-- Stated for an arbitrary law with an arbitrary separating pair, so that
-- the three sites which assembled this by hand can point here instead.
------------------------------------------------------------------------

collision-witness-number-2 :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ Answerable law
  â†’ (x x' : X)
  â†’ ((d : D) â†’ law d x â†’ law d x' â†’ âŠ¥)
  â†’ WitnessNumberIs law 2
collision-witness-number-2 law ans x x' kills =
    (x âˆ· x' âˆ· [] , refl , pair)
  , least
  where
  pair : Refutes law (x âˆ· x' âˆ· [])
  pair d (at-x , at-x' , _) = kills d at-x at-x'

  least : (ys : List _) â†’ length ys < 2 â†’ Â¬ Refutes law ys
  least []           _  = answerableâ†’no-empty law ans x
  least (a âˆ· [])     _  = answerableâ†’no-singleton law ans a
  least (a âˆ· b âˆ· ys) lt = Empty.rec (Â¬-<-zero (pred-â‰¤-pred (pred-â‰¤-pred lt)))

------------------------------------------------------------------------
-- 3.  The two hypotheses of Â§2, side by side with what they exclude
--
-- `Answerable` excludes the degenerate 1; the "kills" hypothesis is what
-- a collision supplies, and is exactly the negative half of the
-- factorisation obstruction.  Neither mentions Y, T, discreteness, or
-- any structure of the mathematics being obstructed â” which is the
-- thread's conclusion in its smallest form.
------------------------------------------------------------------------

-- the collision hypothesis, in the shape every site produces it
collisionKills :
  {D : Type â„“d} {X : Type â„“x} {W : Type â„“} {V : Type â„“}
  (obs : X â†’ W) (val : X â†’ V)
  (read : D â†’ W â†’ V)
  (x x' : X) â†’ obs x â‰¡ obs x' â†’ Â¬ (val x â‰¡ val x')
  â†’ (d : D) â†’ (read d (obs x) â‰¡ val x) â†’ (read d (obs x') â‰¡ val x') â†’ âŠ¥
collisionKills obs val read x x' same differ d at-x at-x' =
  differ (sym at-x âˆ™ cong (read d) same âˆ™ at-x')

------------------------------------------------------------------------
-- 4.  What the thread now says, entire.
--
--   The cost of an absence of factorisation shape is fixed by two
--   capacities of its DECODERS and by nothing about the mathematics
--   obstructed:
--
--     answering   every point is answered by some decoder.  Fail it and
--                 the cost is 1 and the absence is degenerate â” one
--                 unreachable point, not two confused ones.
--     reading     the decoders see a discrete probe.  Given answering,
--                 pass it and the cost is exactly 2; fail it and 3 and âˆž
--                 both occur.
--
--   Every site in this corpus passes both, which is why every site costs
--
-- OPEN, named and not estimated.  Whether "reading" admits a converse:
-- these modules show a discrete probe SUFFICES for the ceiling and that
-- its absence permits 3 and âˆž, but not that some readability condition
-- is NECESSARY.  A decoder space with no discrete probe and ceiling 2
-- would settle it and none is known here.
------------------------------------------------------------------------
