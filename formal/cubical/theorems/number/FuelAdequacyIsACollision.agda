{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FuelAdequacyIsACollision
--
-- Sixth site of `TranscriptDescent.collisionObstructsDecoder`, and the
-- first one that is about this repository's own code rather than about
-- mathematics.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE THIS CAME FROM
--
-- `ExponentBound` had to prove that `FrontierList.logOf`'s fuel budget
-- is adequate, because nothing had.  The audit question that followed
-- was: why did THAT function escape when twenty modules here are fuel
-- driven?  The answer is a type-level criterion, and it is sharp:
--
--   `Factorisation.factorise-fuel : (fuel n : â•) â’ 0 < n â’ n â‰ fuel
--                                 â’ Factorisation n`
--   `CoprimeSplitting`'s atom      : â¦ â’ n â‰ fuel â’ Î[ p ] (IsPrime p — p âˆ n)
--   `PFreePart.pFree-fuel`         : â¦ â’ m â‰ fuel â’ Split p m
--   `KFlow`                        : â¦ â’ n â‰ fuel â’ â¦
--
-- every one of them takes the budget as a HYPOTHESIS and returns a Î
-- carrying its own postcondition.  For those, adequacy is discharged by
-- the type: the postcondition is a projection of the result, and there
-- is no theorem left to prove.
--
--   `FrontierList.expOf : â• â’ â• â’ â• â’ â•`
--
-- takes the budget as bare data and returns bare data.  It is the only
-- one of the twenty in that shape, and it is the only one whose
-- adequacy went unproved for the corpus's whole history â” carried
-- instead by `frontier8 = refl`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CRITERION, MADE EXACT
--
-- "Bare data cannot carry adequacy" is a slogan until it is a
-- collision.  Here it is one.  Fix the base p = 2 and let the input be
-- the pair (k , gas).  Then
--
--     bare (k , g)       =  expOf 2 k g
--     saturated (k , g)  =  has the climb stopped? â” i.e. is
--                           2 ^ (suc (expOf 2 k g)) already past k?
--
-- and the two inputs (2 , 1) and (8 , 1) are a collision:
--
--     expOf 2 2 1  =  1  =  expOf 2 8 1
--     saturated (2 , 1) = true   (2Â² = 4 > 2, the climb is finished)
--     saturated (8 , 1) = false  (2Â² = 4 â‰ 8, it has further to go)
--
-- So no decoder on the returned value recovers adequacy, and by the
-- corpus's own lemma that is not a gap in anyone's cleverness â” it is
-- `Â FactorsThrough bare saturated`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND THE REPAIR, IN THE SAME IDIOM
--
-- A collision names the missing distinction, and here the distinction
-- is `k`.  Return the value paired with the bound and adequacy factors
-- immediately, with the decoder written out:
--
--     withK (k , g) = (k , expOf 2 k g)
--     saturated-factors : FactorsThrough withK saturated
--
-- which is the type `expOf` should have had, in the weakest form that
-- works.  The Î-returning fuelled functions listed above are the strong
-- form of the same repair, and that is why none of them needed a
-- theorem.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- It does not claim `expOf` is wrong.  `ExponentBound` proves it right.
-- It claims the correctness was not IN the type, and locates the exact
-- information the type was missing.  Nor does it audit the remaining
-- fuelled modules line by line: the criterion is stated, four instances
-- are checked against it by inspection of their signatures above, and
-- the rest are named as unaudited rather than assumed clean.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module FuelAdequacyIsACollision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _^_)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; â‰¤Dec)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import Cubical.Functions.Image using (Image ; restrictToImage)

open import FrontierList using (expOf)
open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  The climb's state, as seen from outside
------------------------------------------------------------------------

Inputs : Type
Inputs = â„• Ã— â„•            -- (bound k , fuel remaining-count gas), base 2

bare : Inputs â†’ â„•
bare (k , g) = expOf 2 k g

-- "the climb has stopped": one more step would overshoot the bound
stopped : â„• â†’ â„• â†’ Bool
stopped k e with â‰¤Dec (2 ^ (suc e)) k
... | yes _ = false
... | no  _ = true

saturated : Inputs â†’ Bool
saturated (k , g) = stopped k (expOf 2 k g)

------------------------------------------------------------------------
-- 2.  The collision, computed
------------------------------------------------------------------------

-- both climbs stand at exponent 1 after one step
same-value : bare (2 , 1) â‰¡ bare (8 , 1)
same-value = refl

-- but one of them is finished and the other is not
sat-2 : saturated (2 , 1) â‰¡ true
sat-2 = refl

sat-8 : saturated (8 , 1) â‰¡ false
sat-8 = refl

different-status : Â¬ (saturated (2 , 1) â‰¡ saturated (8 , 1))
different-status p = trueâ‰¢false (sym sat-2 âˆ™ p âˆ™ sat-8)

------------------------------------------------------------------------
-- 3.  THE OBSTRUCTION, from the corpus's own lemma
------------------------------------------------------------------------

fuel-adequacy-does-not-factor : Â¬ FactorsThrough bare saturated
fuel-adequacy-does-not-factor =
  collisionObstructsDecoder bare saturated
    {x = (2 , 1)} {x' = (8 , 1)}
    same-value
    different-status

------------------------------------------------------------------------
-- 4.  THE REPAIR: carry the bound, and the decoder writes itself
------------------------------------------------------------------------

withK : Inputs â†’ (â„• Ã— â„•)
withK (k , g) = (k , expOf 2 k g)

saturated-factors : FactorsThrough withK saturated
saturated-factors = decode , law
  where
  decode : Image withK â†’ Bool
  decode ((k , e) , _) = stopped k e

  law : (x : Inputs) â†’ decode (restrictToImage withK x) â‰¡ saturated x
  law (k , g) = refl

------------------------------------------------------------------------
-- 5.  What the sixth site adds to the other five.
--
-- about representations of mathematical objects: à²à¾à˜àµ over expressions,
-- àà¨ààµààààà¿ over rule lists, carry/borrow over digit strings, the
-- transcript over machine states, the Jain àààààà™àà—à over standpoints.
--
-- This one is about a TYPE SIGNATURE in this repository, and it says
-- something the other five could not: the discipline in CLAUDE.md â” that
-- a computed instance must not stand in for a theorem â” has a mechanical
-- shadow.  Where the return type of a fuelled function is bare data, the
-- adequacy claim provably cannot ride along, so it will be carried by a
-- `refl` at one input or by nothing at all.  Where the return type is a
-- Î, it rides along by construction.
--
-- That is a criterion an agent can apply without reading the proofs, and
-- it found the one instance in twenty.
------------------------------------------------------------------------
