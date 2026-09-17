{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Punarukti_TheTwoScaledCakravalaStepsAreOneTheorem
--
-- ON THE NAME.  ààà¨à°àà•àà Â punarukta â” "said again".  Gautama,
-- *Nyyastra* 5.2 (~2nd c. CE), the nigrahasthna list, at 5.2.14 in
-- the standard numbering: abdrthayo punarvacana punaruktam
-- **anyatra anuvdt** â” restating word or sense is a ground of defeat,
-- EXCEPT where it is anuvda, deliberate restatement.  The exception is
-- the whole point of the name here: a second proof of a theorem is not
-- a defect if it says it is a second proof.  Neither of the two modules
-- below says so, and neither imports the other.
--
-- WHAT IS CLAIMED.  Exactly one thing, and it is checked, not asserted:
--
--     CakravalaDescent.Descent.cakravalaScaled
--       (added 2026-08-18 19:27 UTC, a1e105bd)
--   and
--     Cakravala.Cycle.cakravala-step
--       (added 2026-08-18 10:00 UTC, 230030a1)
--
-- are ONE THEOREM over an arbitrary commutative ring: same hypotheses
-- (the state condition plus the cakravla's three cleared divisions),
-- same conclusion up to `sym` on the hypotheses and one associativity.
-- `scaledâ’step` and `stepâ’scaled` below derive each from the other,
-- so neither is a weakening of the other in any direction.
--
-- The duplication is not visible from either header.  NaturalMachine's
-- (10:00) says "This thread has quoted the cakravla in eight modules
-- and built it in none", which was true when written.
-- CakravalaDescent's (19:27) says "There was no `CakravalaDescent`
-- ... two references pointing at work that was never done" â” and by
-- then the kÂ²-scaled step HAD been done, nine hours earlier, in the
-- same generality, in this same directory tree.  Neither file names the
-- other.  Exactly one module imports both: the GENERATED aggregate root
-- `Samuccaya_...`, which imports all 897 modules under formal/cubical/
-- and asserts nothing about any pair of them.  A mechanical root cannot
-- notice that two of its rows are one theorem.
--
-- The private lemma `Cakravala.Cycle.bhavana-trivial`
-- (`solve! R`) is likewise `Bhavana.Form.cakravalaCleared` again, and
-- `Cakravala.àà•àà°àà¯-àà¦-à°ààà®à` is that same identity a third time over â
-- from `Brahmagupta.àà¾àµà¨à¾-à®à¾à¨`.  Those are named here and NOT bridged:
-- one bridge is enough to place the finding, and `bhavana-trivial` is
-- private, so a bridge to it would have to edit another author's file.
--
-- SOURCE OF THE MATHEMATICS RESTATED, not of this file: Jayadeva
-- (~950 CE, through Udayadivkara's *Sundar*, 1073) and Bhskara II,
-- *Bjagaita* (1150), the cakravla; the identity it turns on is
-- Brahmagupta's bhvan, *Brhmasphuasiddhnta* 18 (628), at the
-- trivial triple (m, 1, mÂ² âˆ’ D).
--
-- CHECKED: Agda 2.8.0, `--cubical --safe`.  No postulates, no holes.
------------------------------------------------------------------------

module Punarukti_TheTwoScaledCakravalaStepsAreOneTheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing

import Bhavana
import CakravalaDescent
import CakravalaStep as NMC

private
  variable
    â„“ : Level

module Bridge (CR : CommRing â„“) where

  open CommRingStr (snd CR)
  open Bhavana.Form CR using (R ; N)
  open CakravalaDescent.Descent CR using (cakravalaScaled)
  open NMC.Cycle CR using (OnForm ; cakravala-step)

  -- CakravalaDescent's statement, from NaturalMachine's.
  scaledâ†’step : (D a b m k a' b' k' : R)
              â†’ N D a b â‰¡ k
              â†’ a Â· m + D Â· b â‰¡ k Â· a'
              â†’ a + b Â· m     â‰¡ k Â· b'
              â†’ m Â· m - D     â‰¡ k Â· k'
              â†’ k Â· (k Â· k') â‰¡ (k Â· k) Â· N D a' b'
  scaledâ†’step D a b m k a' b' k' nab ea eb ek =
      Â·Assoc k k k'
    âˆ™ sym (cakravala-step D a b k m a' b' k'
             nab (sym ea) (sym eb) (sym ek))

  -- NaturalMachine's statement, from CakravalaDescent's.
  stepâ†’scaled : (D a b k m a' b' k' : R)
              â†’ OnForm D a b k
              â†’ k Â· a' â‰¡ a Â· m + D Â· b
              â†’ k Â· b' â‰¡ a + b Â· m
              â†’ k Â· k' â‰¡ m Â· m - D
              â†’ (k Â· k) Â· N D a' b' â‰¡ (k Â· k) Â· k'
  stepâ†’scaled D a b k m a' b' k' onform ha hb hk =
      sym (cakravalaScaled D a b m k a' b' k'
             onform (sym ha) (sym hb) (sym hk))
    âˆ™ Â·Assoc k k k'
