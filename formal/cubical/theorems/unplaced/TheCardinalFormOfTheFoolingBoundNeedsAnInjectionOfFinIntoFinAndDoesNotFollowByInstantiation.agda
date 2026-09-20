{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCardinalFormOfTheFoolingBoundNeedsAnInjectionOfFinIntoFinAndDoesNotFollowByInstantiation
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Fooling sets and rectangle covers are communication-complexity
-- objects with no Indian source I can establish, and fabricating a
--  label would assert a provenance nobody checked â” the mirror
-- image of the scrubbing the naming rule corrects.  Checked before
-- naming: `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; no row applies, and the frame
-- check's scope requires Indian material, which this module has none
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE LINE, AND WHAT IT DECLARED IT WAS NOT DOING
--
--   AFoolingPairForcesTwoRectangles       one sound rectangle cannot
--                                         hold two fooling cells
--   AFoolingSetForcesDistinctRectangles   a sound cover is INJECTIVE on
--                                         a fooling family
--   NRectanglesCannotCoverSucNFoolingCells
--                                         and therefore `n` rectangles
--                                         cannot serve `suc n` cells
--
-- The second said, in its own words: *"INJECTIVITY IS NOT 'â‰ k'.
-- Turning 'distinct cells get distinct rectangles' into 'at least k
-- rectangles' is a COUNTING step."*  The third supplied the counting
-- step **in contrapositive form**, and justified that choice:
--
--   "'At least k rectangles' is a statement about a cardinal, and a
--    cardinal needs the cover's index to be finite and to be COUNTED.
--    â¦ **That is the whole content of the numeric claim and it is
--    stated without a cardinality.**"
--
-- The first half is exactly right.  **The last sentence is the corpus's
-- recurring split, one more time: `the whole content` reads identically
-- in a strong and a weak sense.**
--
--   WEAK, and true.  For a cover indexed by `Fin n` against `suc n`
--   cells, the contrapositive carries everything the inequality would.
--
--   STRONG, and false.  The cardinal statement quantifies over covers
--   of ARBITRARY size `m` and concludes `suc n â‰ m`.  **That does not
--   follow from the third module by instantiation**, and Â§2 below says
--   precisely why: its `rects` is indexed by `Fin n`, so a cover of `m`
--   rectangles with `m â‰ n` cannot be handed to it at all â” extending
--   `rects` to `Fin n` would require inventing rectangles and proving
--   them sound.  What is needed instead is an INJECTION `Fin m â Fin n`,
--   and that injection is the arithmetic the module was avoiding.
--
-- WHAT IS PROVED
--
--   finIncl / finInclInjective
--                    `m â‰ n` gives an injection `Fin m â’ Fin n`.  In
--                    v0.5 `Fin n = Î[ k âˆˆ â• ] k < n`, so this is
--                    `<â‰-trans` on the proof component and injectivity
--                    is `toâ•-injective` â” the underlying â• is untouched,
--                    which is why `cong toâ•` suffices.
--   atLeastSucNRectangles
--                    **the cardinal form**: a fooling family of `suc n`
--                    cells, covered soundly by ANY `Fin m`-indexed
--                    family under ANY assignment, forces `suc n â‰ m`.
--
-- HOW THE THREE CASES ARE PAID FOR, since this is where the counting
-- actually lives.  On `suc n â‰Ÿ m` (`Trichotomy`, kernel-decidable):
--   lt   `suc n < m`   â’ `<-weaken`, free
--   eq   `suc n â‰¡ m`   â’ `subst` on `â‰-refl`, free
--   gt   `m < suc n`   â’ `pred-â‰-pred` gives `m â‰ n`, then the
--                        injection, then `pigeonhole-special`, then the
--                        line's own injectivity theorem.  **Only this
--                        branch does any work, and it is the branch the
--                        contrapositive form already covered.**
-- So the cardinal form is the contrapositive form PLUS a trichotomy
-- PLUS an injection.  Two of the three branches are bookkeeping; naming
-- them is the point, because "it is just the contrapositive" hides that
-- the third branch changed shape.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheCardinalFormOfTheFoolingBoundNeedsAnInjectionOfFinIntoFinAndDoesNotFollowByInstantiation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; suc)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-refl ; <-weaken ; pred-â‰¤-pred ; <â‰¤-trans
        ; _â‰Ÿ_ ; lt ; eq ; gt)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Fin using (Fin ; toâ„• ; toâ„•-injective)
open import Cubical.Data.Fin.Properties using (pigeonhole-special)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import AFoolingPairForcesTwoRectangles
  using (Rect ; Sound ; Covers)
open import AFoolingSetForcesDistinctRectangles
  using (Fooling ; foolingSetForcesDistinctRectangles)

------------------------------------------------------------------------
-- 1.  m â‰ n gives an injection Fin m â’ Fin n
--
-- Nothing about fooling sets here; this is the missing ingredient, and
-- it is stated separately so that its cost is visible.
------------------------------------------------------------------------

finIncl : {m n : â„•} â†’ m â‰¤ n â†’ Fin m â†’ Fin n
finIncl mâ‰¤n (k , k<m) = (k , <â‰¤-trans k<m mâ‰¤n)

finInclInjective :
  {m n : â„•} (mâ‰¤n : m â‰¤ n) (x y : Fin m)
  â†’ finIncl mâ‰¤n x â‰¡ finIncl mâ‰¤n y â†’ x â‰¡ y
finInclInjective mâ‰¤n x y p = toâ„•-injective (cong toâ„• p)

------------------------------------------------------------------------
-- 2.  The cardinal form
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row â†’ Col â†’ Bool) where

  atLeastSucNRectangles :
    (n m : â„•)
    (r : Fin (suc n) â†’ Row) (c : Fin (suc n) â†’ Col)
    â†’ Fooling Row Col M (Fin (suc n)) r c
    â†’ (rects : Fin m â†’ Rect Row Col M)
    â†’ (pick : Fin (suc n) â†’ Fin m)
    â†’ ((i : Fin (suc n)) â†’ Sound Row Col M (rects (pick i)))
    â†’ ((i : Fin (suc n)) â†’ Covers Row Col M (rects (pick i)) (r i) (c i))
    â†’ suc n â‰¤ m
  atLeastSucNRectangles n m r c fool rects pick sound covers with suc n â‰Ÿ m
  ... | lt sucn<m = <-weaken sucn<m
  ... | eq sucnâ‰¡m = subst (Î» z â†’ suc n â‰¤ z) sucnâ‰¡m â‰¤-refl
  ... | gt m<sucn = âŠ¥.rec tooFew
    where
      mâ‰¤n : m â‰¤ n
      mâ‰¤n = pred-â‰¤-pred m<sucn

      squash : Fin (suc n) â†’ Fin n
      squash i = finIncl mâ‰¤n (pick i)

      collision : Î£[ i âˆˆ Fin (suc n) ] Î£[ j âˆˆ Fin (suc n) ]
                    (Â¬ i â‰¡ j) Ã— (squash i â‰¡ squash j)
      collision = pigeonhole-special squash

      i    = collision .fst
      j    = collision .snd .fst
      iâ‰¢j  = collision .snd .snd .fst
      same = collision .snd .snd .snd

      pickEq : pick i â‰¡ pick j
      pickEq = finInclInjective mâ‰¤n (pick i) (pick j) same

      tooFew : âŠ¥
      tooFew =
        foolingSetForcesDistinctRectangles Row Col M
          (Fin (suc n)) r c fool
          (Î» k â†’ rects (pick k)) sound covers
          i j iâ‰¢j (cong rects pickEq)

------------------------------------------------------------------------
-- 3.  What changed, stated as a difference and not as a completion
--
-- `NRectanglesCannotCoverSucNFoolingCells` is the `m â‰¡ n` diagonal of
-- Â§2 read contrapositively, and Â§2 is not a strengthening OF it â” the
-- two have different hypotheses and neither is an instance of the
-- other:
--
--   that module   fixes the cover's index at `Fin n` and concludes `âŠ`
--   Â§2            leaves the index at `Fin m` and concludes an
--                 inequality in â•
--
-- Going from the first to the second is not weakening a hypothesis; it
-- is supplying `finIncl`, which did not exist on this line.  A reader
-- who took "that is the whole content of the numeric claim" at strength
-- would have believed Â§2 was already available and would have been
-- wrong by exactly one lemma.
--
-- STILL OPEN on this line, and unchanged by Â§2: any upper bound, and
-- any construction of a cover.  Both are different theorems, not gaps.
------------------------------------------------------------------------
