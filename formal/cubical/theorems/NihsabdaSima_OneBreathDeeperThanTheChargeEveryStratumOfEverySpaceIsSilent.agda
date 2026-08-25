{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- निःशब्द-सीमा — the boundary of silence.  The edge that makes the
-- stratum grammar sharp.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- सामान्यम् (ArpanaSopana): stratum 3+m, looped m+1 times, utters
-- π₁₊ₘ(A) — for every pointed A.  मौनम्/सर्वमौनम् (Mauna, SarvaMauna):
-- for a TRUNCATED space, strata above its level are silent.  But what is
-- the unconditional edge?  How many loops can ANY stratum of ANY space
-- sustain before silence — with no hypothesis on the space at all?
--
-- ANSWERED HERE, and the bound is exactly one breath past the charge:
--
--   निःशब्दसीमा : for EVERY pointed A, every n and every extra depth d,
--
--        Ω^(1+n+d) (∥A∥₂₊ₙ)  is contractible.
--
-- The stratum 2+n, looped 1+n+d times, is a point — always.  Read
-- against सामान्यम् at the matching index (stratum 3+m = 2+(1+m),
-- charge voice m+1 loops, silence from m+2 loops): a stratum utters its
-- whole charge at its deepest sounding depth, and the very next loop is
-- silence, for every space, sharply.  Special faces:
--
--   • n = 0: stratum 2 (the set stratum) is silent at every depth ≥ 1 —
--     speech in the ladder begins at stratum 3, universally.
--   • d = 0: the first silent depth of stratum 2+n is 1+n, one past the
--     n-loop voice in which (per सामान्यम्, shifted) it utters πₙ.
--
-- The proof is two library facts through one descent: the truncation
-- carries its own level (isOfHLevelTrunc), levels lift (isOfHLevelPlus'),
-- and k loops peel k levels (अवरोहः, Mauna) down to a pointed
-- proposition, which is contractible.  Unlike SarvaMauna nothing is
-- assumed of A — the level lives in the truncation itself.
--
-- SOURCES AND SCOPE.  isOfHLevelTrunc, isOfHLevelPlus',
-- inhProp→isContr are the library's; अवरोहः is Mauna's (this corpus,
-- 2026-08-23).  This module's content is the composition and the
-- sharpness reading.  निःशब्द (soundless) and सीमा (boundary) are
-- ordinary Sanskrit used as labels; the compound is built here; no
-- source is claimed for the mathematics, and the arpita/anarpita
-- stratum reading remains, as in StaraArpana, a reading.
------------------------------------------------------------------------

module NihsabdaSima_OneBreathDeeperThanTheChargeEveryStratumOfEverySpaceIsSilent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Pointed using (Pointed ; typ ; pt)
open import Cubical.Foundations.HLevels
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.HITs.Truncation using (hLevelTrunc∙ ; isOfHLevelTrunc)
open import Cubical.Homotopy.Loopspace using (Ω^_)

open import Mauna_TheTwistedRingUttersOnceAndAboveTheKramaEveryStratumIsSilent
  using (अवरोहः)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- निःशब्दसीमा — stratum 2+n, looped 1+n+d times, is a point, for every
-- pointed space whatsoever.
------------------------------------------------------------------------

निःशब्दसीमा : (n d : ℕ) (A : Pointed ℓ)
  → isContr (typ ((Ω^ (1 + (n + d))) (hLevelTrunc∙ (2 + n) A)))
निःशब्दसीमा n d A =
  inhProp→isContr (pt ((Ω^ (1 + (n + d))) X)) silent
  where
    X : Pointed _
    X = hLevelTrunc∙ (2 + n) A

    -- the truncation's own level, lifted by d: (2+n)+d is definitionally
    -- 2+(n+d), which is 1 + (1+(n+d)) — exactly what the descent asks.
    levelX : isOfHLevel (2 + (n + d)) (typ X)
    levelX = isOfHLevelPlus' {n = d} (2 + n) (isOfHLevelTrunc (2 + n))

    silent : isProp (typ ((Ω^ (1 + (n + d))) X))
    silent = अवरोहः 1 (1 + (n + d)) X levelX
