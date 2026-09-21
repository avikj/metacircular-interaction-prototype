{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PowModHasTheSameShape
--
-- The criterion in `FuelAdequacyIsACollision` found `FrontierList.expOf`
-- retrospectively.  Applied forward across the corpus it finds at least
-- nine more, listed in `ExhaustionIsSystematic`.  Different subsystem,
-- different hand:
--     HeadDepthMerge.powMod : â• â’ â• â’ â• â’ â• â’ â•
--     powMod zero    m b e = 1 %% m          -- exhausted
--     powMod (suc f) m b e = â¦ if e == 0 then 1 %% m â¦   -- legitimate
--
-- Fuel as bare data, result as bare data â” `expOf`'s shape exactly.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUTHOR ALREADY SAW THE SYMPTOM
--
-- `HeadDepthMergeBreaker` Â§edge records it, and honestly:
--
--     -- powMod fuel exhaustion silently returns 1 %% m: with fuel 1,
--     -- 2^4 mod 7 comes out 1; the true value is 2 â¦
--     -- In the certified range e â‰ 23^4 âˆ’ 1 < 2^40 so fuel 40 never
--     -- exhausts, but the wart is real outside it.
--     edge-powMod-fuel-wart : HDM.powMod 1 7 2 4 â‰¡ 1
--
-- That is a `refl` at one input plus an adequacy claim in prose â” the
-- same arrangement `frontier8 = refl` had, found independently, and
-- filed as a caveat about a range rather than as a fact about a type.
-- Nothing here disputes the range claim.  What the criterion adds is
-- that the range claim is the ONLY thing that can save the call site,
-- because no decoder on the returned number can.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE COLLISION
--
-- Exhaustion and the legitimate `e â‰¡ 0` branch return the same
-- expression, `1 %% m`.  So:
--
--     powMod  1 7 2 4  =  1      exhausted; the true value is 2
--     powMod 40 7 2 0  =  1      correct;   2â° mod 7 really is 1
--
-- Same returned number, opposite correctness.  Hence
--
--     Â FactorsThrough value correct
--
-- and the returned â• provably does not tell a caller whether it is the
-- answer.  This is the second site of one phenomenon, not an analogy:
-- the repair below is `FuelAdequacyIsACollision`'s `withK` with the
-- bound replaced by (m , b , e).
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- OWNERSHIP
--
-- `HeadDepthMerge` and `HeadDepthMergeBreaker` are another identity's
-- files and are not edited.  This module imports them and adds the
-- theorem beside them, per the repository's standing norm.
------------------------------------------------------------------------

module PowModHasTheSameShape where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Agda.Builtin.Nat using (_==_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Relation.Nullary using (Â¬_)

open import Cubical.Functions.Image using (Image ; restrictToImage)

import HeadDepthMerge as HDM
open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  The call, and what a caller wants to know about it
------------------------------------------------------------------------

Inputs : Type
Inputs = â„• Ã— (â„• Ã— (â„• Ã— â„•))          -- (fuel , modulus , base , exponent)

value : Inputs â†’ â„•
value (f , m , b , e) = HDM.powMod f m b e

truth : â„• â†’ â„• â†’ â„• â†’ â„•
truth m b e = HDM.power b e HDM.%% m

correct : Inputs â†’ Bool
correct (f , m , b , e) = HDM.powMod f m b e == truth m b e

------------------------------------------------------------------------
-- 2.  The two calls, computed
------------------------------------------------------------------------

exhausted : Inputs
exhausted = (1 , 7 , 2 , 4)

legitimate : Inputs
legitimate = (40 , 7 , 2 , 0)

-- the author's own witness, restated in this module's vocabulary
exhausted-value : value exhausted â‰¡ 1
exhausted-value = refl

legitimate-value : value legitimate â‰¡ 1
legitimate-value = refl

-- 2â´ mod 7 = 2, so the exhausted call is wrong; 2â° mod 7 = 1, so the
-- other is right
exhausted-truth : truth 7 2 4 â‰¡ 2
exhausted-truth = refl

legitimate-truth : truth 7 2 0 â‰¡ 1
legitimate-truth = refl

same-value : value exhausted â‰¡ value legitimate
same-value = refl

exhausted-wrong : correct exhausted â‰¡ false
exhausted-wrong = refl

legitimate-right : correct legitimate â‰¡ true
legitimate-right = refl

different-status : Â¬ (correct exhausted â‰¡ correct legitimate)
different-status p =
  trueâ‰¢false (sym legitimate-right âˆ™ sym p âˆ™ exhausted-wrong)

------------------------------------------------------------------------
-- 3.  THE OBSTRUCTION
------------------------------------------------------------------------

powMod-correctness-does-not-factor : Â¬ FactorsThrough value correct
powMod-correctness-does-not-factor =
  collisionObstructsDecoder value correct
    {x = exhausted} {x' = legitimate}
    same-value
    different-status

------------------------------------------------------------------------
-- 4.  THE REPAIR, identical in shape to the first site
------------------------------------------------------------------------

withSpec : Inputs â†’ (â„• Ã— (â„• Ã— (â„• Ã— â„•)))
withSpec (f , m , b , e) = (m , b , e , HDM.powMod f m b e)

correct-factors : FactorsThrough withSpec correct
correct-factors = decode , law
  where
  decode : Image withSpec â†’ Bool
  decode ((m , b , e , v) , _) = v == truth m b e

  law : (x : Inputs) â†’ decode (restrictToImage withSpec x) â‰¡ correct x
  law (f , m , b , e) = refl

------------------------------------------------------------------------
-- 5.  What two sites establish that one did not.
--
-- One site is an anecdote about `expOf`.  Two sites, in unrelated
-- subsystems, written by different hands, with the same return-type
-- shape and the same failure â” an adequacy claim that lives in a
-- comment because it cannot live in the type â” make it a property of
-- the shape.
--
-- The criterion is therefore promoted from an observation to a check
-- worth running: a fuelled function whose fuel is bare data and whose
-- result is bare data has an adequacy obligation that the type system
-- will not carry, and searching for `fuel` will not find it, because
-- the risky ones do not name their fuel parameter.  `expOf` is
-- `â• â’ â• â’ â• â’ â•`; `powMod` is `â• â’ â• â’ â• â’ â• â’ â•`.  Both are invisible
-- to the obvious grep, which is why both survived.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  THE FULL LIST.
--
-- A search over top-level SIGNATURES containing the word `fuel` finds
-- only these two.  The whole point of the criterion is
-- that the risky functions take their fuel as bare, unnamed data â”
-- `expOf : â• â’ â• â’ â• â’ â•`, `powMod : â• â’ â• â’ â• â’ â• â’ â•` â” so that
-- search looks for the very property Â§5 proves absent.
--
-- The search over bare arrow chains turns up
-- `remF`, `quoF`, `gcdF`, `spfF` (TransmissionRefutations), `divF`,
-- `modF`, `omegaF` (SieveFiber) and `gcdF` (Gamma0Index) alongside these
-- two.  Every one defaults on exhaustion to a value that is also a
-- legitimate output â” which is forced, not careless, since a total
-- function into â• must return something.
--
-- `ExhaustionIsSystematic` carries the claim,
-- the shared packaging, and computed collisions in three subsystems.
-- It also records that the cheap surrogate â” "did more fuel change the
-- answer?" â” fails for `powMod` itself: exhaustion there is stable
-- across a step, `powMod 1 7 2 4 â‰¡ powMod 2 7 2 4 â‰¡ 1`, answer 2.
------------------------------------------------------------------------
