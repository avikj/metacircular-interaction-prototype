{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExhaustionIsSystematic
--
-- CORRECTION TO `PowModHasTheSameShape` Â§1, which said the criterion
-- "finds one more â” and only one".  It finds at least nine, and the
-- reason it looked like one is that the earlier search read top-level
-- SIGNATURES containing the word `fuel`.  The fuelled functions in this
-- corpus mostly take their fuel unnamed and untyped, so that search was
-- looking for the property it had just proved invisible.
--
-- Per the standing rule the earlier file is not edited; this one carries
-- the correction, and it is a substantive one â” the phenomenon is
-- systematic, not a pair of anecdotes.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THE EXHAUSTION BRANCHES ACTUALLY LOOK LIKE
--
--   TransmissionRefutations  gcdF zero a _ = a        (right when b â‰¡ 0)
--                            quoF zero _ _ = zero     (right when n < d)
--                            remF zero n _ = n        (right when n < d)
--                            spfF zero _ n = n        (right when n prime)
--   SieveFiber               divF zero d n = zero     (right when n < d)
--                            modF zero d n = n        (right when n < d)
--                            omegaF zero d n = zero   (right when no factor)
--   Gamma0Index              gcdF zero a b = a        (right when b â‰¡ 0)
--   HeadDepthMerge           powMod zero m b e = 1 %% m  (right when e â‰¡ 0)
--
-- EVERY ONE of them defaults, on exhaustion, to a value that is also a
-- legitimate output.  That is not carelessness â” it is forced.  A total
-- function into â• must return SOME natural number when the fuel runs
-- out, and every natural number is a legitimate output of some call.
-- The default is unavoidable and the collision follows from it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND THE CHEAP SURROGATE FAILS TOO
--
-- The obvious escape is to test convergence instead of correctness:
-- "did one more unit of fuel change the answer?"  For the subtractive
-- loops it works.  For `powMod` it does not, and the reason is the
-- halving recursion:
--
--     powMod 1 7 2 4  â‰¡  1  â‰¡  powMod 2 7 2 4     while 2â´ mod 7 = 2
--
-- Exhaustion there is STABLE ACROSS A STEP.  So the site below uses
-- correctness against `power b e %% m` for `powMod`, and one-step
-- stability for the subtractive ones â” each instance takes the sharpest
-- test available, and the packaging is what makes them one shape.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- OWNERSHIP
--
-- `TransmissionRefutations`, `SieveFiber`, `HeadDepthMerge` are other
-- identities' files.  They are imported and not edited.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module ExhaustionIsSystematic where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; suc)
open import Agda.Builtin.Nat using (_==_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Relation.Nullary using (Â¬_)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

import HeadDepthMerge as HDM
import TransmissionRefutations as TR
import SieveFiber as SF

------------------------------------------------------------------------
-- 1.  The shape, once
------------------------------------------------------------------------

module Site {X : Type} (run : â„• â†’ X â†’ â„•) (good : â„• â†’ X â†’ Bool) where

  Inputs : Type
  Inputs = â„• Ã— X

  value : Inputs â†’ â„•
  value (f , x) = run f x

  status : Inputs â†’ Bool
  status (f , x) = good f x

  -- one bad call and one good call returning the same number is already
  -- an obstruction to every decoder on the returned number
  site : (a b : Inputs)
       â†’ value a â‰¡ value b
       â†’ status a â‰¡ false
       â†’ status b â‰¡ true
       â†’ Â¬ FactorsThrough value status
  site a b same aBad bGood =
    collisionObstructsDecoder value status {x = a} {x' = b}
      same
      (Î» p â†’ trueâ‰¢false (sym bGood âˆ™ sym p âˆ™ aBad))

------------------------------------------------------------------------
-- 2.  HeadDepthMerge.powMod â” correctness against the exact power
------------------------------------------------------------------------

module PowMod where

  run : â„• â†’ (â„• Ã— (â„• Ã— â„•)) â†’ â„•
  run f (m , b , e) = HDM.powMod f m b e

  good : â„• â†’ (â„• Ã— (â„• Ã— â„•)) â†’ Bool
  good f (m , b , e) = HDM.powMod f m b e == (HDM.power b e HDM.%% m)

  open Site run good public

  bad : Inputs
  bad = (1 , 7 , 2 , 4)          -- exhausted; returns 1, answer is 2

  ok : Inputs
  ok = (40 , 7 , 2 , 0)          -- correct; 2â° mod 7 really is 1

  same : value bad â‰¡ value ok
  same = refl

  bad-wrong : status bad â‰¡ false
  bad-wrong = refl

  ok-right : status ok â‰¡ true
  ok-right = refl

  obstruction : Â¬ FactorsThrough value status
  obstruction = site bad ok same bad-wrong ok-right

  -- and the cheap surrogate does not save it: one more unit of fuel
  -- changes nothing while the answer is still wrong
  stable-but-wrong : HDM.powMod 1 7 2 4 â‰¡ HDM.powMod 2 7 2 4
  stable-but-wrong = refl

  true-answer : (HDM.power 2 4 HDM.%% 7) â‰¡ 2
  true-answer = refl

------------------------------------------------------------------------
-- 3.  TransmissionRefutations.remF â” one-step stability
------------------------------------------------------------------------

module RemF where

  run : â„• â†’ (â„• Ã— â„•) â†’ â„•
  run f (n , d) = TR.remF f n d

  good : â„• â†’ (â„• Ã— â„•) â†’ Bool
  good f (n , d) = TR.remF f n d == TR.remF (suc f) n d

  open Site run good public

  bad : Inputs
  bad = (0 , 3 , 2)              -- exhausted; returns 3, next fuel gives 1

  ok : Inputs
  ok = (5 , 3 , 4)               -- 3 < 4, so 3 is the remainder, settled

  same : value bad â‰¡ value ok
  same = refl

  bad-wrong : status bad â‰¡ false
  bad-wrong = refl

  ok-right : status ok â‰¡ true
  ok-right = refl

  obstruction : Â¬ FactorsThrough value status
  obstruction = site bad ok same bad-wrong ok-right

------------------------------------------------------------------------
-- 4.  SieveFiber.divF â” one-step stability, and the default is `zero`
------------------------------------------------------------------------

module DivF where

  run : â„• â†’ (â„• Ã— â„•) â†’ â„•
  run f (d , n) = SF.divF f d n

  good : â„• â†’ (â„• Ã— â„•) â†’ Bool
  good f (d , n) = SF.divF f d n == SF.divF (suc f) d n

  open Site run good public

  bad : Inputs
  bad = (0 , 2 , 3)              -- exhausted; returns 0, next fuel gives 1

  ok : Inputs
  ok = (5 , 4 , 3)               -- 3 < 4, so the quotient really is 0

  same : value bad â‰¡ value ok
  same = refl

  bad-wrong : status bad â‰¡ false
  bad-wrong = refl

  ok-right : status ok â‰¡ true
  ok-right = refl

  obstruction : Â¬ FactorsThrough value status
  obstruction = site bad ok same bad-wrong ok-right

------------------------------------------------------------------------
-- 5.  What is now established, and what is not.
--
-- ESTABLISHED.  Three subsystems, three hands, one shape, each with a
-- computed pair of calls: `Â FactorsThrough value status`.  Together
-- with Â§1's reading of six further exhaustion branches, the conclusion
-- is that this is a property of the return type, not of any author.
-- A fuelled function into bare â• MUST pick a default, the default is
-- always someone's legitimate answer, and so the returned number can
-- never report its own adequacy.
--
-- NOT ESTABLISHED.  That any of these functions is called outside its
-- adequate range anywhere in this repository.  Six of the nine are read
-- from their exhaustion branches only and have no collision computed
-- here.  Nothing in this file evaluates any author's range claim; it
-- shows only that such claims are load-bearing and cannot be replaced
-- by inspecting results.
--
-- THE REPAIR is unchanged from the first two sites and is the shape the
-- rest of this corpus already uses: take the budget as a hypothesis and
-- return a Î.  `factorise-fuel`, `primeDivisor-fuel`, `pFree-fuel`,
-- `decay-fuel` and `WalkJumps.strip` all do, and none of them needed a
-- theorem, because for them there is nothing left to prove.
------------------------------------------------------------------------
