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
