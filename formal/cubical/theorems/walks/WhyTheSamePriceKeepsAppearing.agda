{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhyTheSamePriceKeepsAppearing
--
-- Computing something downstream of a repetition, which is the only
-- thing that turns a repetition into a result.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE REPETITION
--
-- Over the last cycles this thread has found the same correction at
-- several sites: a hypothesis of `Dec` where the proof uses only
-- `Â Â A â’ A`, or a target-side condition of `Discrete` where only
-- path-stability is used.  This corpus's own rule about such things is
-- that a pattern over n instances is a pattern over n instances until
-- something downstream of it is computed.  So here is the downstream
-- computation, and it is not another instance.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  the stable types are closed under exactly the connectives
--       these sites' conclusions are built from: `Â`, `â’`, `Î `, `—`.
--       Four short proofs.  Together with `Stable-â”` from
--       `WhereTheTowerCanStillBeThree` â” stability transports along a
--       bare logical equivalence â” this is a closure statement about a
--       class of types, not a fact about any site.
--
--   Â§2  and there is no closure proof for `Î` or `âŠ`, for an exact
--       reason: `Â Â (Î â¦)` hands back no component, so there is
--       nothing to feed the pointwise stability with.
--
--   Â§3  which PREDICTS the split, and the prediction is checkable by
--       reading conclusions rather than proofs:
--
--         conclusion is Î /â’/Â-shaped over stable atoms
--             â’ stability is free, no hypothesis needed;
--         conclusion is Î-shaped
--             â’ stability must be assumed, and THAT is where a `Dec`
--               hypothesis gets written down by reflex.
--
--       Checked against the sites, by reading their signatures:
--
--         `WhereTheTowerCanStillBeThree.stableFiberConstant` â”
--           conclusion `FiberConstant q t`, a Î â into a path.  Free,
--           given stable paths in the target.  Predicted, and so it is.
--
--         `ExclusionRecoversGroundAtAPrice.coExcludeâ’coIdentify-stable`
--           â” conclusion `CoIdentify q' q`, a Î  into a path.  The
--           hypothesis it takes IS the atom-stability the schema asks
--           for, not an extra.  Predicted.
--
--         `HypothesesAssumedWhereTheyAreDerivable`'s site and
--         `TheDelimitorNeedsOnlyStability`'s site â” conclusions
--           `FactorsThrough q' t` and `Collision q t`, both Î.
--           Stability is not available and is assumed.  Predicted, and
--           both are exactly where a `Dec` was written where `Stable`
--           was used.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE BOUNDARY IS ONE-SIDED, AND THAT IS RECORDED, NOT EXPLAINED
--
-- Â§2 says no closure proof exists for `Î`.  It does not say closure
-- fails: by `TheUnstableGroundCannotBeExhibited`, `Â Stable A` is
-- refuted for every A, so no counterexample to Î-closure can ever be
-- exhibited either.  The taxonomy is therefore confirmable and not
-- refutable â” the same one-sidedness that closed the deflationary
-- test.
--
-- That is TWO occurrences of one-sidedness in this thread.  Nothing
-- downstream of the co-occurrence has been computed, so it is written
-- down and nothing is inferred from it.  The rule that produced this
-- module applies to this module.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE RESPECTS
--
--   ààà¯à¾àà â” in the respect of conclusion shape, the split is sharp and
--            Â§3 checks out at four sites;
--   ààà¯à¾àà â” in the respect of what a site actually needs, the schema
--            decides nothing: a Î-shaped conclusion may still be
--            stable for reasons peculiar to it (`Stable-â”` alone makes
--            the shape non-decisive, since a Î logically equivalent to
--            a stable Î  is stable).  Â§3 is a heuristic that must be
--            discharged by reading, not a criterion that replaces it.
--
-- These do not collapse.  A schema that predicted a site's needs
-- without reading the site would be asserting a standpoint that denies
-- the site's own, and `Stable-â”` is the proof inside this thread that
-- shape does not determine the answer.
--
------------------------------------------------------------------------

module WhyTheSamePriceKeepsAppearing where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_ ; Stable)

open import WhereTheTowerCanStillBeThree using (StableÎ  ; Stable-â†”)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  Closure, on the connectives the sites' conclusions use
------------------------------------------------------------------------

stableÂ¬ : {A : Type â„“} â†’ Stable (Â¬ A)
stableÂ¬ nnna a = nnna (Î» na â†’ na a)

stableÎ  : {A : Type â„“} {B : A â†’ Type â„“'}
        â†’ ((a : A) â†’ Stable (B a)) â†’ Stable ((a : A) â†’ B a)
stableÎ  = StableÎ 

stableâ†’ : {A : Type â„“} {B : Type â„“'} â†’ Stable B â†’ Stable (A â†’ B)
stableâ†’ st = StableÎ  (Î» _ â†’ st)

stableÃ— : {A : Type â„“} {B : Type â„“'}
        â†’ Stable A â†’ Stable B â†’ Stable (A Ã— B)
stableÃ— stA stB nn =
    stA (Î» na â†’ nn (Î» p â†’ na (fst p)))
  , stB (Î» nb â†’ nn (Î» p â†’ nb (snd p)))

-- and transport along a bare logical equivalence, restated here so the
-- closure list and its one non-structural member sit together.
stable-â†” : {A : Type â„“} {B : Type â„“'}
         â†’ (A â†’ B) â†’ (B â†’ A) â†’ Stable A â†’ Stable B
stable-â†” = Stable-â†”

------------------------------------------------------------------------
-- 2.  Where the list stops
--
-- There is no entry for `Î` and none for `âŠ`.  The reason is visible
-- in what a proof would have to do: `Â Â (Î[ a ] B a)` must produce an
-- `a` before pointwise stability of `B` can be used, and it produces
-- nothing.  Recorded as a statement about the absence of a route.
--
-- What CAN be said positively about the Î case is already in
-- `WhereTheTowerCanStillBeThree` Â§5: a decidable Î is stable.  That is
-- a hypothesis about the Î, not a closure property of the class.
------------------------------------------------------------------------

-- the closure that does hold for the dependent product of stables,
-- stated once more in the form Â§3 uses it: a conclusion that is a
-- nested Î  into stable atoms is stable.
stableÎ â‚‚ : {A : Type â„“} {B : A â†’ A â†’ Type â„“'}
         â†’ ((a a' : A) â†’ Stable (B a a')) â†’ Stable ((a a' : A) â†’ B a a')
stableÎ â‚‚ st = StableÎ  (Î» a â†’ StableÎ  (Î» a' â†’ st a a'))

stableÎ â‚ƒ : {A : Type â„“} {B : A â†’ A â†’ Type â„“'} {C : Type â„“'}
         â†’ ((a a' : A) â†’ B a a' â†’ Stable C)
         â†’ Stable ((a a' : A) â†’ B a a' â†’ C)
stableÎ â‚ƒ st = StableÎ  (Î» a â†’ StableÎ  (Î» a' â†’ StableÎ  (Î» b â†’ st a a' b)))

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `Â`, `â’`, `—`, `Î `, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `âŠ`,
-- `no-barrier-claim : Â (Â (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not â” and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------
