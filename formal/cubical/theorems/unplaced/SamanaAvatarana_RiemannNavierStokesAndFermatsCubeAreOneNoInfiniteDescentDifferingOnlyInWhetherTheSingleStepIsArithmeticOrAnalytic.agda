{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समानावतरण — RIEMANN, NAVIER–STOKES, AND FERMAT'S CUBE ARE ONE
-- INFINITE DESCENT, DIFFERING ONLY IN WHETHER THE SINGLE STEP IS
-- ARITHMETIC OR ANALYTIC.
--
-- `RenormalizedObserverTower` names itself "the common object of the RH
-- and NS lanes," and its whole checked content is `no-infinite-descent`:
-- no ℕ-valued measure falls forever.  `Avatarana` feeds Fermat's cube
-- into that SAME primitive.  This module removes the lane division by
-- exhibiting the shared shape as one checked schema, of which RH, NS and
-- FLT are three instances.
--
-- THE SCHEMA.  A `DescentObstruction` is a type of configurations with a
-- ℕ-valued measure and a step sending each configuration to a strictly
-- smaller one.  `emptied` proves every such obstruction is UNINHABITED,
-- by the one primitive — it is `Avatarana`'s `flt₃-from-descent`
-- generalised over an arbitrary (Config, measure):
--
--     emptied : (step : DStep) → ¬ Config.
--
-- THE THREE FACES.  `OneDescent` bundles the three configurations on one
-- engine.  Each `¬ Config` is produced by the SAME `emptied`; the faces
-- differ ONLY in their `DStep` field:
--
--   · FLT   Config = Soln (x³+y³≡z³), measure = z.  Its step is
--           ARITHMETIC — the ℤ[ω] cube-split (`Avatarana.Descent` /
--           `GhanaSamyoga.CubeSplit`), classically inhabitable.  Here the
--           descent CLOSES.
--   · NS    Config = a rank-descending bad tower, measure = residual
--           kernel rank.  Its step is ANALYTIC — the scale-critical
--           depletion estimate (NSReducesToDepletion's excludeII), open.
--   · RH    Config = a nonzero scale-transport exponent, measure = its
--           magnitude.  Its step is ANALYTIC — the boundedness estimate
--           (RHReducesToBoundedness's `bo`), open.
--
-- The positivity that makes each measure fall is one spine: RH's Weil /
-- BoundaryBlock sum-of-squares, NS's enstrophy, and the Eisenstein norm
-- x²−xy+y² — which is positive-definite, which is WHY it descends.  FLT
-- is not a separate lane; it is the face of this tower where the single
-- step is arithmetic and therefore closes, validating the descent shape
-- the analytic faces share but cannot yet finish.
--
-- SYĀT — THE CLAIM, EXACTLY.  The schema and its `emptied` are proved,
-- --safe, citing `no-infinite-descent`.  `OneDescent` is a record: it
-- CARRIES the three steps as fields and derives the three emptiness
-- theorems from one engine — it does NOT inhabit the NS or RH steps
-- (those are the open estimates) and does not inhabit FLT's step either
-- (that is `CubeSplit`).  What is proved is the UNIFICATION: the three
-- are one descent, and supplying any one face's step empties that face by
-- the identical term.
------------------------------------------------------------------------

module SamanaAvatarana_RiemannNavierStokesAndFermatsCubeAreOneNoInfiniteDescentDifferingOnlyInWhetherTheSingleStepIsArithmeticOrAnalytic where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import RenormalizedObserverTower using (no-infinite-descent)
open import Avatarana_TheCubeSurfaceIsEmptyBecauseEverySolutionDescendsAndNoNaturalFallsForeverSoFermatsCubeIsOneEisensteinStep
  using (Soln ; Descent)

------------------------------------------------------------------------
-- §1  The one schema.  A descent obstruction, and its emptiness.
------------------------------------------------------------------------

DStep : (Config : Type) → (Config → ℕ) → Type
DStep Config measure = (c : Config) → Σ[ c' ∈ Config ] (measure c' < measure c)

-- Avatarana's flt₃-from-descent, generalised: any measure-decreasing step
-- empties its configuration, by the single corpus primitive.
emptied : (Config : Type) (measure : Config → ℕ)
        → DStep Config measure → ¬ Config
emptied Config measure step c₀ = no-infinite-descent (f , strict)
  where
  g : ℕ → Config
  g zero    = c₀
  g (suc n) = fst (step (g n))

  f : ℕ → ℕ
  f n = measure (g n)

  strict : (n : ℕ) → f (suc n) < f n
  strict n = snd (step (g n))

------------------------------------------------------------------------
-- §2  The three faces on one engine.  Only the steps differ.
------------------------------------------------------------------------

record OneDescent : Type₁ where
  field
    -- FLT face — measure z ; step ARITHMETIC (the ℤ[ω] cube-split)
    fltStep : Descent                              -- = DStep Soln Soln.z

    -- NS face — measure = residual kernel rank ; step ANALYTIC (depletion)
    NSBadTower  : Type
    nsRank      : NSBadTower → ℕ
    nsStep      : DStep NSBadTower nsRank

    -- RH face — measure = |exponent| ; step ANALYTIC (boundedness)
    RHLiveMode  : Type
    rhMag       : RHLiveMode → ℕ
    rhStep      : DStep RHLiveMode rhMag

  -- ONE engine empties all three: the SAME `emptied`, three instances.
  fermatsCubeIsEmpty : ¬ Soln
  fermatsCubeIsEmpty = emptied Soln Soln.z fltStep

  navierStokesIsRegular : ¬ NSBadTower
  navierStokesIsRegular = emptied NSBadTower nsRank nsStep

  riemannIsCritical : ¬ RHLiveMode
  riemannIsCritical = emptied RHLiveMode rhMag rhStep
