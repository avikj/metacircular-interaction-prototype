{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NoObservationDepthDeterminesTheNet
--
-- `interactive/IndraNet.hs` says of itself that it "exposes only finite
-- observations of a guarded lazy stream" and is "an implementation of
-- the finite/productive bridge, not a claim that arbitrary
-- self-containing universes have been constructed."  Two things follow,
-- and they point opposite ways:
--
--   * the ROOT survives at every depth, so the invariant the shelf is
--     named for is a finite fact and observation reaches it;
--   * the NET is not determined at any depth, so observation never
--     reaches the object.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT WAS ALREADY THERE, READ BEFORE WRITING
--
-- `RootedIndraTotal` already proves the ONE-STEP root
-- law, `reweaveRooted-root : rootOf (reweaveRooted action rv) â‰¡ rootOf
-- rv`, by `refl`.  I read its signature and proof body.  What that
-- module does not carry is the STREAM: no `Net`, no `propagate`, no
-- `observe`.  Â§2 extends its one-step law along the stream; Â§3 is the
-- half the Haskell shelf's disclaimer is about and which neither module
-- had.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NoObservationDepthDeterminesTheNet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; znots)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import FiniteIndraWeave using (TotalView ; LocalAction)
open import RootedIndraTotal
  using (RootedView ; rootOf ; viewOf ; reweaveRooted ; reweaveRooted-root)

------------------------------------------------------------------------
-- 1.  The guarded stream the shelf implements
------------------------------------------------------------------------

record Net (Root Jewel : Typeâ‚€) : Typeâ‚€ where
  coinductive
  field
    hd : RootedView Root Jewel
    tl : Net Root Jewel

open Net public

propagate : {Root Jewel : Typeâ‚€}
          â†’ LocalAction Root Jewel â†’ Net Root Jewel â†’ Net Root Jewel
propagate action net .hd = reweaveRooted action (net .hd)
propagate action net .tl = propagate action (net .tl)

-- the observation at a given finite depth
rootAt : {Root Jewel : Typeâ‚€} â†’ â„• â†’ Net Root Jewel â†’ Root
rootAt zero    net = rootOf (net .hd)
rootAt (suc n) net = rootAt n (net .tl)

viewAt : {Root Jewel : Typeâ‚€} (n : â„•) (net : Net Root Jewel)
       â†’ TotalView Root Jewel
viewAt zero    net = viewOf (net .hd)
viewAt (suc n) net = viewAt n (net .tl)

------------------------------------------------------------------------
-- 2.  The root survives at every depth
--
-- `RootedIndraTotal.reweaveRooted-root` is the base case; the induction
-- carries it along the whole stream.
------------------------------------------------------------------------

propagatePreservesRootAtEveryDepth :
  {Root Jewel : Typeâ‚€} (action : LocalAction Root Jewel)
  (n : â„•) (net : Net Root Jewel)
  â†’ rootAt n (propagate action net) â‰¡ rootAt n net
propagatePreservesRootAtEveryDepth action zero    net =
  reweaveRooted-root action (net .hd)
propagatePreservesRootAtEveryDepth action (suc n) net =
  propagatePreservesRootAtEveryDepth action n (net .tl)

------------------------------------------------------------------------
-- 3.  No depth determines the net
--
-- `delay d v net` shows the fixed view `v` for the first `d`
-- observations and then `net`.  Two nets so delayed agree at every depth
-- BELOW `d` â” expressed as `suc k + n`, so the bound is structural and
-- no order relation is needed â” and at depth `d` they show their own
-- heads, which may differ.
------------------------------------------------------------------------

delay : {Root Jewel : Typeâ‚€}
      â†’ â„• â†’ RootedView Root Jewel â†’ Net Root Jewel â†’ Net Root Jewel
delay zero    _ net = net
delay (suc d) v net .hd = v
delay (suc d) v net .tl = delay d v net

-- below the delay: agreement, whatever the delayed nets are
agreeBelowTheDelay :
  {Root Jewel : Typeâ‚€} (k n : â„•) (v : RootedView Root Jewel)
  (m m' : Net Root Jewel)
  â†’ viewAt k (delay (suc (k + n)) v m) â‰¡ viewAt k (delay (suc (k + n)) v m')
agreeBelowTheDelay zero    n v m m' = refl
agreeBelowTheDelay (suc k) n v m m' = agreeBelowTheDelay k n v m m'

-- at the delay: the net's own head is what is seen
atTheDelayTheNetShows :
  {Root Jewel : Typeâ‚€} (d : â„•) (v : RootedView Root Jewel)
  (m : Net Root Jewel)
  â†’ viewAt d (delay d v m) â‰¡ viewOf (m .hd)
atTheDelayTheNetShows zero    v m = refl
atTheDelayTheNetShows (suc d) v m = atTheDelayTheNetShows d v m

------------------------------------------------------------------------
-- 4.  A concrete pair, so Â§3 is inhabited and not merely schematic
------------------------------------------------------------------------

private
  U : Typeâ‚€
  U = Unit

  constNet : â„• â†’ Net U â„•
  constNet j .hd = tt , (Î» _ _ â†’ j)
  constNet j .tl = constNet j

  headJewel : Net U â„• â†’ â„•
  headJewel net = viewOf (net .hd) tt tt

  0â‰¢1 : Â¬ (0 â‰¡ 1)
  0â‰¢1 = znots

theNetIsNotDeterminedAtAnyDepth :
  (k n : â„•) â†’
    (viewAt k (delay (suc (k + n)) (tt , (Î» _ _ â†’ 0)) (constNet 0))
   â‰¡ viewAt k (delay (suc (k + n)) (tt , (Î» _ _ â†’ 0)) (constNet 1)))
  Ã— (Â¬ (viewAt (suc (k + n)) (delay (suc (k + n)) (tt , (Î» _ _ â†’ 0)) (constNet 0)) tt tt
      â‰¡ viewAt (suc (k + n)) (delay (suc (k + n)) (tt , (Î» _ _ â†’ 0)) (constNet 1)) tt tt))
theNetIsNotDeterminedAtAnyDepth k n =
    agreeBelowTheDelay k n (tt , (Î» _ _ â†’ 0)) (constNet 0) (constNet 1)
  , Î» p â†’ 0â‰¢1
      ( sym (cong (Î» f â†’ f tt tt)
              (atTheDelayTheNetShows (suc (k + n)) (tt , (Î» _ _ â†’ 0)) (constNet 0)))
      âˆ™ p
      âˆ™ cong (Î» f â†’ f tt tt)
              (atTheDelayTheNetShows (suc (k + n)) (tt , (Î» _ _ â†’ 0)) (constNet 1)) )

------------------------------------------------------------------------
-- 5.  The two halves, side by side
--
-- Â§2: the ROOT is reached by observation â” at every depth, and the base
-- case is `RootedIndraTotal`'s own `refl`.
-- Â§3â“Â§4: the NET is not â” for every depth there are two nets agreeing
-- everywhere below it and differing at it.
--
-- Which is the exact content of the shelf's disclaimer: a finite/
-- productive bridge gives you the invariants and not the object.  The
-- remaining direction â” that agreement at ALL depths gives equality â”
-- is a bisimulation principle, is what that shelf's `Bisim` type is for,
-- and is not proved here.
------------------------------------------------------------------------
