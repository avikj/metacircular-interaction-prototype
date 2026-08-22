{-# LANGUAGE BangPatterns #-}

-- A small executable counterpart to NaturalMachine.RootedIndraTotal.
-- It keeps a distinguished root, reweaves every rooted view with one local
-- action, and exposes only finite observations of a guarded lazy stream.
-- This is an implementation of the finite/productive bridge, not a claim
-- that arbitrary self-containing universes have been constructed.
module IndraNet
  ( Root, Jewel, View, LocalAction, RootedView(..), rootView
  , reweaveRooted, Net(..), propagate, observe
  , Bisim(..), propagateBisim
  ) where

type Root = Int
type Jewel = Int
type View = Root -> Root -> Jewel
type LocalAction = Root -> Jewel -> Jewel

data RootedView = RootedView
  { rootOf :: !Root
  , viewOf :: View
  }

rootView :: Root -> View -> RootedView
rootView = RootedView

reweaveRooted :: LocalAction -> RootedView -> RootedView
reweaveRooted action (RootedView root view) =
  RootedView root (\r t -> action r (view r t))

data Net = Net
  { netView :: !RootedView
  , netNext :: Net
  }

propagate :: LocalAction -> Net -> Net
propagate action (Net rv next) =
  Net (reweaveRooted action rv) (propagate action next)

observe :: Int -> Net -> [RootedView]
observe n _ | n <= 0 = []
observe n (Net rv next) = rv : observe (n - 1) next

data Bisim = Bisim
  { bisimNow :: RootedView -> RootedView -> Bool
  , bisimLater :: Bisim
  }

propagateBisim :: LocalAction
               -> Bisim -> Bisim
propagateBisim action (Bisim now later) =
  Bisim (\left right ->
           now (reweaveRooted action left) (reweaveRooted action right))
        (propagateBisim action later)

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module.
--
-- This file's own disclaimer -- it "exposes only finite observations of
-- a guarded lazy stream" and is "an implementation of the finite/
-- productive bridge, not a claim that arbitrary self-containing
-- universes have been constructed" -- now has both halves checked, in
-- `formal/cubical/NaturalMachine/NoObservationDepthDeterminesTheNet.agda`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin):
--
--   propagatePreservesRootAtEveryDepth
--       the ROOT survives every step of `propagate`, at every depth.
--       Its base case is RootedIndraTotal's own reweaveRooted-root
--       (which is refl); the induction carries it along the stream.
--
--   agreeBelowTheDelay / atTheDelayTheNetShows /
--   theNetIsNotDeterminedAtAnyDepth
--       for EVERY depth there are two nets agreeing at every depth below
--       it and differing at it.  So no finite observation depth
--       determines the net.
--
-- Together: a finite/productive bridge gives you the INVARIANTS and not
-- the OBJECT, which is exactly what the disclaimer says.  The bound in
-- the agreement lemma is written `suc (k + n)` so that it is structural
-- and no order relation is needed.
--
-- NOT proved there, and it is what this file's `Bisim` type is for:
-- that agreement at ALL depths gives equality.  That is a bisimulation
-- principle and is neither proved nor used.
-- ---------------------------------------------------------------------
