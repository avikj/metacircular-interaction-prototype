{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Punarukti_TheTwoScaledCakravalaStepsAreOneTheorem
--
-- ON THE NAME.  पुनरुक्त · punarukta — "said again".  Gautama,
-- *Nyāyasūtra* 5.2 (~2nd c. CE), the nigrahasthāna list, at 5.2.14 in
-- the standard numbering: śabdārthayoḥ punarvacanaṃ punaruktam
-- **anyatra anuvādāt** — restating word or sense is a ground of defeat,
-- EXCEPT where it is anuvāda, deliberate restatement.  The exception is
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
-- (the state condition plus the cakravāla's three cleared divisions),
-- same conclusion up to `sym` on the hypotheses and one associativity.
-- `scaled→step` and `step→scaled` below derive each from the other,
-- so neither is a weakening of the other in any direction.
--
-- The duplication is not visible from either header.  NaturalMachine's
-- (10:00) says "This thread has quoted the cakravāla in eight modules
-- and built it in none", which was true when written.
-- CakravalaDescent's (19:27) says "There was no `CakravalaDescent`
-- ... two references pointing at work that was never done" — and by
-- then the k²-scaled step HAD been done, nine hours earlier, in the
-- same generality, in this same directory tree.  Neither file names the
-- other.  Exactly one module imports both: the GENERATED aggregate root
-- `Samuccaya_...`, which imports all 897 modules under formal/cubical/
-- and asserts nothing about any pair of them.  A mechanical root cannot
-- notice that two of its rows are one theorem.
--
-- The private lemma `Cakravala.Cycle.bhavana-trivial`
-- (`solve! R`) is likewise `Bhavana.Form.cakravalaCleared` again, and
-- `Cakravala.चक्रीय-पद-रूपम्` is that same identity a third time over ℤ
-- from `Brahmagupta.भावना-मान`.  Those are named here and NOT bridged:
-- one bridge is enough to place the finding, and `bhavana-trivial` is
-- private, so a bridge to it would have to edit another author's file.
--
-- SYĀT — THE CLAIM, EXACTLY.  Nothing new about the cakravāla.  No claim that
-- either module should be deleted — the two proofs run by different
-- routes (`solve!` on the whole identity, versus Brahmagupta's
-- composition plus `normScale`), and a second route is worth having.
-- What is claimed is only that the corpus did not know it had two, and
-- now the fact is a term.  Nothing here touches termination, Bhāskara's
-- minimality rule, or existence of solutions.
--
-- SOURCE OF THE MATHEMATICS RESTATED, not of this file: Jayadeva
-- (~950 CE, through Udayadivākara's *Sundarī*, 1073) and Bhāskara II,
-- *Bījagaṇita* (1150), the cakravāla; the identity it turns on is
-- Brahmagupta's bhāvanā, *Brāhmasphuṭasiddhānta* 18 (628), at the
-- trivial triple (m, 1, m² − D).
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
