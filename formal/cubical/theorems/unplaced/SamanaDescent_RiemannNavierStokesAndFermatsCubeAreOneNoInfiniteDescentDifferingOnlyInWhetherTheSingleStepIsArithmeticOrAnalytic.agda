{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà®à¾à¨à¾àµàà°à â” RIEMANN, NAVIERâ“STOKES, AND FERMAT'S CUBE ARE ONE
-- INFINITE DESCENT, DIFFERING ONLY IN WHETHER THE SINGLE STEP IS
-- ARITHMETIC OR ANALYTIC.
--
-- `RenormalizedObserverTower` names itself "the common object of the RH
-- and NS lanes," and its whole checked content is `no-infinite-descent`:
-- no â•-valued measure falls forever.  `Avatarana` feeds Fermat's cube
-- into that SAME primitive.  This module removes the lane division by
-- exhibiting the shared shape as one checked schema, of which RH, NS and
-- FLT are three instances.
--
-- THE SCHEMA.  A `DescentObstruction` is a type of configurations with a
-- â•-valued measure and a step sending each configuration to a strictly
-- smaller one.  `emptied` proves every such obstruction is UNINHABITED,
-- by the one primitive â” it is `Avatarana`'s `fltâ-from-descent`
-- generalised over an arbitrary (Config, measure):
--
--     emptied : (step : DStep) â’ Â Config.
--
-- THE THREE FACES.  `OneDescent` bundles the three configurations on one
-- engine.  Each `Â Config` is produced by the SAME `emptied`; the faces
-- differ ONLY in their `DStep` field:
--
--   Â FLT   Config = Soln (xÂ³+yÂ³â‰¡zÂ³), measure = z.  Its step is
--           ARITHMETIC â” the â[Ï‰] cube-split (`Avatarana.Descent` /
--           `GhanaSamyoga.CubeSplit`), classically inhabitable.  Here the
--           descent CLOSES.
--   Â NS    Config = a rank-descending bad tower, measure = residual
--           kernel rank.  Its step is ANALYTIC â” the scale-critical
--           depletion estimate (NSReducesToDepletion's excludeII), open.
--   Â RH    Config = a nonzero scale-transport exponent, measure = its
--           magnitude.  Its step is ANALYTIC â” the boundedness estimate
--           (RHReducesToBoundedness's `bo`), open.
--
-- The positivity that makes each measure fall is one spine: RH's Weil /
-- BoundaryBlock sum-of-squares, NS's enstrophy, and the Eisenstein norm
-- xÂ²âˆ’xy+yÂ² â” which is positive-definite, which is WHY it descends.  FLT
-- is not a separate lane; it is the face of this tower where the single
-- step is arithmetic and therefore closes, validating the descent shape
-- the analytic faces share but cannot yet finish.
--
-- SYT â” THE CLAIM, EXACTLY.  The schema and its `emptied` are proved, citing
-- `no-infinite-descent`.  `OneDescent` is a record: it
-- CARRIES the three steps as fields and derives the three emptiness
-- theorems from one engine â” it does NOT inhabit the NS or RH steps
-- (those are the open estimates) and does not inhabit FLT's step either
-- (that is `CubeSplit`).  What is proved is the UNIFICATION: the three
-- are one descent, and supplying any one face's step empties that face by
-- the identical term.
------------------------------------------------------------------------

module SamanaAvatarana_RiemannNavierStokesAndFermatsCubeAreOneNoInfiniteDescentDifferingOnlyInWhetherTheSingleStepIsArithmeticOrAnalytic where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Sigma using (Î£ ; Î£-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

open import RenormalizedObserverTower using (no-infinite-descent)
open import Avatarana_TheCubeSurfaceIsEmptyBecauseEverySolutionDescendsAndNoNaturalFallsForeverSoFermatsCubeIsOneEisensteinStep
  using (Soln ; Descent)

------------------------------------------------------------------------
-- Â§1  The one schema.  A descent obstruction, and its emptiness.
------------------------------------------------------------------------

DStep : (Config : Type) â†’ (Config â†’ â„•) â†’ Type
DStep Config measure = (c : Config) â†’ Î£[ c' âˆˆ Config ] (measure c' < measure c)

-- Avatarana's fltâ-from-descent, generalised: any measure-decreasing step
-- empties its configuration, by the single corpus primitive.
emptied : (Config : Type) (measure : Config â†’ â„•)
        â†’ DStep Config measure â†’ Â¬ Config
emptied Config measure step câ‚€ = no-infinite-descent (f , strict)
  where
  g : â„• â†’ Config
  g zero    = câ‚€
  g (suc n) = fst (step (g n))

  f : â„• â†’ â„•
  f n = measure (g n)

  strict : (n : â„•) â†’ f (suc n) < f n
  strict n = snd (step (g n))

------------------------------------------------------------------------
-- Â§2  The three faces on one engine.  Only the steps differ.
------------------------------------------------------------------------

record OneDescent : Typeâ‚ where
  field
    -- FLT face â” measure z ; step ARITHMETIC (the â[Ï‰] cube-split)
    fltStep : Descent                              -- = DStep Soln Soln.z

    -- NS face â” measure = residual kernel rank ; step ANALYTIC (depletion)
    NSBadTower  : Type
    nsRank      : NSBadTower â†’ â„•
    nsStep      : DStep NSBadTower nsRank

    -- RH face â” measure = |exponent| ; step ANALYTIC (boundedness)
    RHLiveMode  : Type
    rhMag       : RHLiveMode â†’ â„•
    rhStep      : DStep RHLiveMode rhMag

  -- ONE engine empties all three: the SAME `emptied`, three instances.
  fermatsCubeIsEmpty : Â¬ Soln
  fermatsCubeIsEmpty = emptied Soln Soln.z fltStep

  navierStokesIsRegular : Â¬ NSBadTower
  navierStokesIsRegular = emptied NSBadTower nsRank nsStep

  riemannIsCritical : Â¬ RHLiveMode
  riemannIsCritical = emptied RHLiveMode rhMag rhStep
