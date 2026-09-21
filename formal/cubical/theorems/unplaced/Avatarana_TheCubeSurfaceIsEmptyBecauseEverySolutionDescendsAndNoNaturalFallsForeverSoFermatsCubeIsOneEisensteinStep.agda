{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अवतरण — FERMAT'S CUBE, PAID THE CORPUS'S WAY: NOT A BIGGER SCAN BUT
-- THE THEOREM COMPRESSED TO ITS ONE IRREDUCIBLE STEP.
--
-- `Fermat3Gate` wrote FLT₃ as a type and named the debt exactly: "the
-- debt is a descent proof in a quadratic ring, not a bigger scan -- no
-- bound on the scan reaches the universal, which is what `restrict`
-- having no converse says as a type."  This module pays everything in
-- that debt EXCEPT the one Eisenstein step, in the corpus's own reduction
-- idiom (RHReducesToBoundedness, NSReducesToDepletion): isolate the single
-- arithmetic mountain, discharge the rest by a checked term citing a
-- corpus primitive.
--
-- THE MINIMUM-DESCRIPTION-LENGTH CORE.  A positive solution of
-- x³ + y³ ≡ z³ is a `Soln`.  Euler's descent is the ONE step `Descent`:
-- every solution yields a strictly z-smaller solution.  Given that step,
-- FLT₃ is FORCED, because the corpus already owns `no-infinite-descent`
-- (RenormalizedObserverTower): no ℕ-valued measure falls forever.  So
--
--     flt₃-from-descent : Descent → ¬ Soln
--     paysFLT₃          : Descent → FLT₃
--
-- are checked terms, and the WHOLE of Fermat's cube is compressed to the
-- single line `Descent`, whose inhabitant is the classical ℤ[ω]
-- unique-factorisation descent (Euler 1770; ℤ[ω] is a UFD, which is why
-- n = 3 is elementary and n at the first irregular prime is not).
--
-- THE COMPRESSION IS LOSSLESS.  `lossless : (¬ Soln → FLT₃) × (FLT₃ → ¬ Soln)`
-- proves the two faces are interderivable, so nothing about Fermat's cube
-- is discarded by the reduction -- only the one step is deferred, named,
-- and LOCATED in the multiplicative structure of ℤ[ω], exactly where
-- `PrimePairEquations…` proves the content of such problems must sit
-- (additive coordinates never cross it).  This is the corpus's own
-- doctrine applied to itself: a theorem is its shortest self-certifying
-- form plus the one obstruction it cannot forge.
--
-- SYĀT — THE CLAIM, EXACTLY.  NOT FLT₃: `Descent` is not inhabited here,
-- and nothing below produces a solution's smaller successor.  What IS
-- proved: the LOSSLESS reduction of Fermat's cube to that single descent
-- step, --safe, no postulates, no holes, citing `no-infinite-descent`.
-- The measure is z; any strictly-decreasing invariant of the descent
-- serves identically.
------------------------------------------------------------------------

module Avatarana_TheCubeSurfaceIsEmptyBecauseEverySolutionDescendsAndNoNaturalFallsForeverSoFermatsCubeIsOneEisensteinStep where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax ; _,_ ; fst ; snd ; _×_)
open import Cubical.Relation.Nullary using (¬_)

open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (cube ; S²)
open import Fermat3Gate_TheCubeGateBelowThirteenIsSignedAndBothNearMissesAreItsTightness
  using (FLT₃)
open import RenormalizedObserverTower
  using (no-infinite-descent)

------------------------------------------------------------------------
-- §1  A positive solution of the Fermat cube, and its measure.
------------------------------------------------------------------------

record Soln : Type where
  constructor soln
  field
    x y z : ℕ
    px : 1 ≤ x
    py : 1 ≤ y
    pz : 1 ≤ z
    eq : S² x y ≡ cube z

------------------------------------------------------------------------
-- §2  The one irreducible step: every solution has a strictly smaller one.
--     Its inhabitant is the ℤ[ω] descent; it is NOT built here.
------------------------------------------------------------------------

Descent : Type
Descent = (s : Soln) → Σ[ s' ∈ Soln ] (Soln.z s' < Soln.z s)

------------------------------------------------------------------------
-- §3  Given the step, Fermat's cube is forced — by the corpus's own
--     `no-infinite-descent`.  Iterating the step from any solution builds
--     a strictly decreasing ℕ-sequence of z's, which cannot exist.
------------------------------------------------------------------------

flt₃-from-descent : Descent → ¬ Soln
flt₃-from-descent step s₀ = no-infinite-descent (f , strict)
  where
  g : ℕ → Soln
  g zero    = s₀
  g (suc n) = fst (step (g n))

  f : ℕ → ℕ
  f n = Soln.z (g n)

  -- f (suc n) = z (fst (step (g n)))  <  z (g n) = f n,   definitionally.
  strict : (n : ℕ) → f (suc n) < f n
  strict n = snd (step (g n))

------------------------------------------------------------------------
-- §4  The reduction is lossless: ¬ Soln and FLT₃ are interderivable, so
--     the compression discards nothing of Fermat's cube.
------------------------------------------------------------------------

lossless : (¬ Soln → FLT₃) × (FLT₃ → ¬ Soln)
lossless = fromNoSoln , toNoSoln
  where
  fromNoSoln : ¬ Soln → FLT₃
  fromNoSoln ns x y z px py pz eq = ns (soln x y z px py pz eq)

  toNoSoln : FLT₃ → ¬ Soln
  toNoSoln flt (soln x y z px py pz eq) = flt x y z px py pz eq

------------------------------------------------------------------------
-- §5  Fermat's cube, paid down to the one Eisenstein step.
------------------------------------------------------------------------

paysFLT₃ : Descent → FLT₃
paysFLT₃ step = fst lossless (flt₃-from-descent step)
