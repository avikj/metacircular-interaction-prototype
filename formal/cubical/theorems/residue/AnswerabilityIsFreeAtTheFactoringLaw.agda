{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnswerabilityIsFreeAtTheFactoringLaw
--
-- A hypothesis that is CORRECTLY assumed
-- in general and is a THEOREM at the site the generalisation came from.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TWO STATEMENTS
--
-- `WitnessDichotomy` proves, for an arbitrary law:
--
--     collision-witness-number-2
--       : (law : D â’ X â’ Type â“) â’ Answerable law â’ (x x' : X)
--       â’ ((d : D) â’ law d x â’ law d x' â’ âŠ) â’ WitnessNumberIs law 2
--
-- `TheFloorIsAnswerability` proves, for the corpus's
-- central law:
--
--     factorLaw-answerable q t x = (Î» _ â’ t x) , refl
--
-- â” a CONSTANT decoder, written down, not searched for.
--
-- So at `factorLaw q t` the first theorem's hypothesis is the second
-- theorem's conclusion.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  the composite: from a collision alone â” `q x â‰¡ q x'` and
--       `Â (t x â‰¡ t x')` â” the full `WitnessNumberIs (factorLaw q t) 2`,
--       with `Answerable` supplied internally and no longer appearing
--       in the statement.
--
--   Â§2  and the discharge isolated as its own object, so that the next
--       site needing it does not re-derive it.
--
-- The content is the removal.  At the central law, the whole of
-- witness-number-2 is the collision: answerability contributes a
-- hypothesis that a function space satisfies because it has constants.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE FLOOR, IN TWO RESPECTS
--
-- "The floor is answerability" and Â§1 are two different claims:
--
--   ààà¯à¾àà â” in the respect of an arbitrary law, answerability is a
--            real hypothesis: `WitnessDichotomy` assumes it because
--            without it the witness number drops to 1, and
--            `TheFloorIsAnswerability` exhibits `lonelyLaw` where it
--            fails.
--   ààà¯à¾àà â” in the respect of the factoring law specifically, it is a
--            theorem, because the decoder space is a function space and
--            function spaces have constants.
--
-- A à¨à¯ that is vacuously satisfied at a site is not thereby a wrong
-- à¨à¯, and collapsing "free here" into "unnecessary" would be exactly
-- the move aneknta blocks: the two respects disagree, so there is
-- plurality and no collapse is licensed.
--
------------------------------------------------------------------------

module AnswerabilityIsFreeAtTheFactoringLaw where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Sigma using (Î£-syntax ; _,_)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import WitnessNumberIsTwo using (factorLaw ; collisionâ†’refutes)
open import TheFloorIsAnswerability using (factorLaw-answerable)
open import WitnessDichotomy using (collision-witness-number-2)

private
  variable
    â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  The composite, with `Answerable` gone from the statement
------------------------------------------------------------------------

factoring-witness-number-2 :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) {x x' : X}
  â†’ q x â‰¡ q x' â†’ Â¬ (t x â‰¡ t x')
  â†’ WitnessNumberIs (factorLaw q t) 2
factoring-witness-number-2 q t {x} {x'} same differ =
  collision-witness-number-2 (factorLaw q t)
    (factorLaw-answerable q t) x x' kills
  where
  kills : (d : Image q â†’ _) â†’ factorLaw q t d x â†’ factorLaw q t d x' â†’ âŠ¥
  kills d ax ax' = collisionâ†’refutes q t same differ d (ax , ax' , tt*)

------------------------------------------------------------------------
-- 2.  The discharge on its own, so the next site does not redo it
------------------------------------------------------------------------

answerabilityDischarged :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T)
  â†’ (x : X) â†’ Î£[ d âˆˆ (Image q â†’ T) ] factorLaw q t d x
answerabilityDischarged q t = factorLaw-answerable q t
