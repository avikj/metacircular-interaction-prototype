{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ààµàà°à â” FERMAT'S CUBE, PAID THE CORPUS'S WAY: NOT A BIGGER SCAN BUT
-- THE THEOREM COMPRESSED TO ITS ONE IRREDUCIBLE STEP.
--
-- `Fermat3Gate` wrote FLTâ as a type and named the debt exactly: "the
-- debt is a descent proof in a quadratic ring, not a bigger scan -- no
-- bound on the scan reaches the universal, which is what `restrict`
-- having no converse says as a type."  This module pays everything in
-- that debt EXCEPT the one Eisenstein step, in the corpus's own reduction
-- idiom (RHReducesToBoundedness, NSReducesToDepletion): isolate the single
-- arithmetic mountain, discharge the rest by a checked term citing a
-- corpus primitive.
--
-- THE MINIMUM-DESCRIPTION-LENGTH CORE.  A positive solution of
-- xÂ³ + yÂ³ â‰¡ zÂ³ is a `Soln`.  Euler's descent is the ONE step `Descent`:
-- every solution yields a strictly z-smaller solution.  Given that step,
-- FLTâ is FORCED, because the corpus already owns `no-infinite-descent`
-- (RenormalizedObserverTower): no â•-valued measure falls forever.  So
--
--     fltâ-from-descent : Descent â’ Â Soln
--     paysFLTâ          : Descent â’ FLTâ
--
-- are checked terms, and the WHOLE of Fermat's cube is compressed to the
-- single line `Descent`, whose inhabitant is the classical â[Ï‰]
-- unique-factorisation descent (Euler 1770; â[Ï‰] is a UFD, which is why
-- n = 3 is elementary and n at the first irregular prime is not).
--
-- THE COMPRESSION IS LOSSLESS.  `lossless : (Â Soln â’ FLTâ) — (FLTâ â’ Â Soln)`
-- proves the two faces are interderivable, so nothing about Fermat's cube
-- is discarded by the reduction -- only the one step is deferred, named,
-- and LOCATED in the multiplicative structure of â[Ï‰], exactly where
-- `PrimePairEquationsâ¦` proves the content of such problems must sit
-- (additive coordinates never cross it).  This is the corpus's own
-- doctrine applied to itself: a theorem is its shortest self-certifying
-- form plus the one obstruction it cannot forge.
--
-- THE CLAIM, EXACTLY: the LOSSLESS reduction of Fermat's cube to that single descent
-- step, citing `no-infinite-descent`.
-- The measure is z; any strictly-decreasing invariant of the descent
-- serves identically.
------------------------------------------------------------------------

module Avatarana_TheCubeSurfaceIsEmptyBecauseEverySolutionDescendsAndNoNaturalFallsForeverSoFermatsCubeIsOneEisensteinStep where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; _â‰¤_)
open import Cubical.Data.Sigma using (Î£ ; Î£-syntax ; _,_ ; fst ; snd ; _Ã—_)
open import Cubical.Relation.Nullary using (Â¬_)

open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (cube ; SÂ²)
open import Fermat3Gate_TheCubeGateBelowThirteenIsSignedAndBothNearMissesAreItsTightness
  using (FLTâ‚ƒ)
open import RenormalizedObserverTower
  using (no-infinite-descent)

------------------------------------------------------------------------
-- Â§1  A positive solution of the Fermat cube, and its measure.
------------------------------------------------------------------------

record Soln : Type where
  constructor soln
  field
    x y z : â„•
    px : 1 â‰¤ x
    py : 1 â‰¤ y
    pz : 1 â‰¤ z
    eq : SÂ² x y â‰¡ cube z

------------------------------------------------------------------------
-- Â§2  The one irreducible step: every solution has a strictly smaller one.
--     Its inhabitant is the â[Ï‰] descent.
------------------------------------------------------------------------

Descent : Type
Descent = (s : Soln) â†’ Î£[ s' âˆˆ Soln ] (Soln.z s' < Soln.z s)

------------------------------------------------------------------------
-- Â§3  Given the step, Fermat's cube is forced â” by the corpus's own
--     `no-infinite-descent`.  Iterating the step from any solution builds
--     a strictly decreasing â•-sequence of z's, which cannot exist.
------------------------------------------------------------------------

fltâ‚ƒ-from-descent : Descent â†’ Â¬ Soln
fltâ‚ƒ-from-descent step sâ‚€ = no-infinite-descent (f , strict)
  where
  g : â„• â†’ Soln
  g zero    = sâ‚€
  g (suc n) = fst (step (g n))

  f : â„• â†’ â„•
  f n = Soln.z (g n)

  -- f (suc n) = z (fst (step (g n)))  <  z (g n) = f n,   definitionally.
  strict : (n : â„•) â†’ f (suc n) < f n
  strict n = snd (step (g n))

------------------------------------------------------------------------
-- Â§4  The reduction is lossless: Â Soln and FLTâ are interderivable, so
--     the compression discards nothing of Fermat's cube.
------------------------------------------------------------------------

lossless : (Â¬ Soln â†’ FLTâ‚ƒ) Ã— (FLTâ‚ƒ â†’ Â¬ Soln)
lossless = fromNoSoln , toNoSoln
  where
  fromNoSoln : Â¬ Soln â†’ FLTâ‚ƒ
  fromNoSoln ns x y z px py pz eq = ns (soln x y z px py pz eq)

  toNoSoln : FLTâ‚ƒ â†’ Â¬ Soln
  toNoSoln flt (soln x y z px py pz eq) = flt x y z px py pz eq

------------------------------------------------------------------------
-- Â§5  Fermat's cube, paid down to the one Eisenstein step.
------------------------------------------------------------------------

paysFLTâ‚ƒ : Descent â†’ FLTâ‚ƒ
paysFLTâ‚ƒ step = fst lossless (fltâ‚ƒ-from-descent step)
