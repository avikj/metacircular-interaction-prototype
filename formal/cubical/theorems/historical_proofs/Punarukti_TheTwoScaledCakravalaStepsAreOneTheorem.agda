{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Punarukti_TheTwoScaledCakravalaStepsAreOneTheorem
--
-- ON THE NAME.  पुनरुक्त · punarukta — "said again".  Gautama,
-- *Nyyastra* 5.2 (~2nd c. CE), the nigrahasthna list, at 5.2.14 in
-- the standard numbering: abdrthayo punarvacana punaruktam
-- **anyatra anuvādāt** — restating word or sense is a ground of defeat,
-- EXCEPT where it is anuvda, deliberate restatement.  The exception is
-- the whole point of the name here: a second proof of a theorem is not
-- a defect if it says it is a second proof.  Neither of the two modules
-- below says so, and neither imports the other.
--
-- WHAT IS CLAIMED.  Exactly one thing, and it is checked, not asserted:
--
--     CakravalaDescent.Descent.cakravalaScaled
--   and
--     Cakravala.Cycle.cakravala-step
--
-- are ONE THEOREM over an arbitrary commutative ring: same hypotheses
-- (the state condition plus the cakravla's three cleared divisions),
-- same conclusion up to `sym` on the hypotheses and one associativity.
-- `scaled→step` and `step→scaled` below derive each from the other,
-- so neither is a weakening of the other in any direction.
--
-- The private lemma `Cakravala.Cycle.bhavana-trivial`
-- (`solve! R`) is likewise `Bhavana.Form.cakravalaCleared` again, and
-- `Cakravala.चक्रीय-पद-रूपम्` is that same identity a third time over ℤ
-- from `Brahmagupta.-`.  Those are named here and NOT bridged:
--
-- SOURCE OF THE MATHEMATICS RESTATED, not of this file: Jayadeva
-- (~950 CE, through Udayadivkara's *Sundar*, 1073) and Bhskara II,
-- *Bjagaita* (1150), the cakravla; the identity it turns on is
-- Brahmagupta's bhvan, *Brhmasphuasiddhnta* 18 (628), at the
-- trivial triple (m, 1, m² − D).
------------------------------------------------------------------------

module Punarukti_TheTwoScaledCakravalaStepsAreOneTheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing

import Composition
import CakravalaDescent
import CakravalaStep as NMC

private
  variable
    ℓ : Level

module Bridge (CR : CommRing ℓ) where

  open CommRingStr (snd CR)
  open Bhavana.Form CR using (R ; N)
  open CakravalaDescent.Descent CR using (cakravalaScaled)
  open NMC.Cycle CR using (OnForm ; cakravala-step)

  -- CakravalaDescent's statement, from NaturalMachine's.
  scaled→step : (D a b m k a' b' k' : R)
              → N D a b ≡ k
              → a · m + D · b ≡ k · a'
              → a + b · m     ≡ k · b'
              → m · m - D     ≡ k · k'
              → k · (k · k') ≡ (k · k) · N D a' b'
  scaled→step D a b m k a' b' k' nab ea eb ek =
      ·Assoc k k k'
    ∙ sym (cakravala-step D a b k m a' b' k'
             nab (sym ea) (sym eb) (sym ek))

  -- NaturalMachine's statement, from CakravalaDescent's.
  step→scaled : (D a b k m a' b' k' : R)
              → OnForm D a b k
              → k · a' ≡ a · m + D · b
              → k · b' ≡ a + b · m
              → k · k' ≡ m · m - D
              → (k · k) · N D a' b' ≡ (k · k) · k'
  step→scaled D a b k m a' b' k' onform ha hb hk =
      sym (cakravalaScaled D a b m k a' b' k'
             onform (sym ha) (sym hb) (sym hk))
    ∙ ·Assoc k k k'
