{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CurvatureCannotLiveOnTheImageOfAnExactCompression
--
--
--   "Exact elimination commutes; compression C can make orders differ:
--    Î”^C_{ij} > 0 is architecture curvature. â¦ Curvature arises only
--    from too-small context families, approximation, dropped witnesses,
--    or incoherent interface updates."
--
-- The second sentence is a LIST OF CAUSES, offered without an argument
-- that the list is exhaustive.  It is, and the argument is short â” but
-- it needs the causes to be read as ONE condition, which is what this
-- module supplies.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED, for any `C : S â’ T`, eliminations `f g : S â’ S` and
-- their compressed counterparts `f' g' : T â’ T`
--
--   curvatureVanishesOnTheImage
--       if `C` INTERTWINES both steps â” `C (f s) â‰¡ f' (C s)` and the
--       same for `g` â” and the uncompressed steps commute, then the
--       compressed steps commute at every `C s`.  NO injectivity, no
--       full abstraction, no surjectivity is used: the two simulation
--       squares and the commuting square are the whole proof.
--
--   curvatureIsOffTheImage
--       hence, contrapositively, a point where the compressed steps
--       FAIL to commute is not `C` of anything.
--
-- **So Â§36â“38's four causes are one cause, split by where it bites.**
-- "Too-small context family" is the image being too small â” the
-- curvature sits at a `t` no context reaches.  "Approximation",
-- "dropped witnesses" and "incoherent interface updates" are all the
-- intertwining square failing, i.e. `C (f s) â‰ f' (C s)`.  There is no
-- fifth possibility, because those two hypotheses are everything the
-- proof consumes.  That is a stronger statement than the list, and it
-- says what to check when curvature is observed: FIND THE POINT, and
-- ask whether it is reachable; if it is, one of the two squares is a
-- lie.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  This is the elementary fact that a simulation transports
-- commuting diagrams onto the image; it is the pasting of two squares
-- and is standard in any category.  It is checked here because Â§36â“38
-- states the causal list without it, and because "curvature" invites a
-- geometric reading that suggests the phenomenon is subtler than the
-- pasting.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module CurvatureCannotLiveOnTheImageOfAnExactCompression where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Î£-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

module _ {S T : Type}
  (C  : S â†’ T)
  (f  g  : S â†’ S)
  (f' g' : T â†’ T)
  (sf : (s : S) â†’ C (f s) â‰¡ f' (C s))
  (sg : (s : S) â†’ C (g s) â‰¡ g' (C s))
  (comm : (s : S) â†’ f (g s) â‰¡ g (f s))
  where

  ------------------------------------------------------------------
  -- 1.  Two simulation squares and one commuting square paste
  ------------------------------------------------------------------

  curvatureVanishesOnTheImage :
    (s : S) â†’ f' (g' (C s)) â‰¡ g' (f' (C s))
  curvatureVanishesOnTheImage s =
      cong f' (sym (sg s))
    âˆ™ sym (sf (g s))
    âˆ™ cong C (comm s)
    âˆ™ sg (f s)
    âˆ™ cong g' (sf s)

  ------------------------------------------------------------------
  -- 2.  So curvature is evidence about REACHABILITY
  ------------------------------------------------------------------

  curvatureIsOffTheImage :
    (t : T) â†’ Â¬ (f' (g' t) â‰¡ g' (f' t)) â†’ Â¬ (Î£[ s âˆˆ S ] C s â‰¡ t)
  curvatureIsOffTheImage t bent (s , e) =
    bent (subst (Î» x â†’ f' (g' x) â‰¡ g' (f' x))
                e (curvatureVanishesOnTheImage s))

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "ORDERS: two steps are treated â¦ nothing is proved for `n` steps,
--    and the `n`-step statement needs the two-step case plus an
--    induction that is not written."
--
-- Written, in
-- `OrderIndependenceTransfersAlongAnyNumberOfSteps`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so)
-- â” and it does NOT need the two-step case.  That prediction was wrong
-- in a useful direction:
--
--   Step        a step, its compressed counterpart, and the
--               intertwining square, packaged so a LIST carries its own
--               hypotheses
--   simFold     `C (runS ps s) â‰¡ runT ps (C s)` â” intertwining extends
--               to composites, by a one-line induction
--   orderIndependenceTransfers / disagreementIsOffTheImage
--   twoStepsAreAnInstance   Â§1â“2 here, recovered as `p âˆ q âˆ []` versus
--                           `q âˆ p âˆ []`
--
-- **THE GENERALISATION IS CHEAPER THAN THE SPECIAL CASE.**  The proof
-- above pastes a simulation square, the commuting square, and a second
-- simulation square in sequence.  The n-step proof SEPARATES those:
-- `simFold` is pure simulation and knows nothing about commuting, and
-- the commuting hypothesis is used exactly once under a single
-- `cong C`.  Generality removed the interleaving that made this
-- argument look like a chain.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above â” including the 2026-08-19 append above it, whose closing
-- sentence is what this corrects.
--
-- **"THE ONLY PART OF Â§36â“38's 'FOR EVERY ORDER' STILL OPEN" IS NO
-- LONGER OPEN.**  The block above ends:
--
-- That derivation needs a permutation relation on lists and an induction, and
-- is the only part of Â§36â“38's 'for every order' still open."
--
-- Derived at commit `15e4bc40`,
-- `PairwiseCommutationGivesEveryOrder` (--safe, no
-- postulates, no holes; container green under Agda 2.6.3 + cubical
-- v0.5, NOT the declared pin).  `_~_` is the permutation relation â”
-- identity, congruence under `âˆ`, adjacent transposition, transitivity
-- â” and `permInvariant` is the induction, with the transposition case
-- BEING the commutation hypothesis.  `everyOrderAgreesAfterCompression`
-- and `disagreementUnderPermutationIsOffTheImage` then carry it to the
-- compressed side.
--
-- **THIS IS AN INCOMPLETE PROPAGATION, NOT AN OVERCLAIM.**  The
-- sentence was true when written.
-- `OrderIndependenceTransfersAlongAnyNumberOfSteps` â” the module the
-- block above is about â” DOES point at the closing module; this file
-- does not, and was the site that kept the discharged item alive.  The
-- same failure was recorded at `3aa3c78c`/`94054b52` on a different
-- line, and the cheap check is the one that caught it: grep the
-- corpus for the item's own subject and READ THE FILENAMES.
--
-- **AND IT COST MORE THAN A STALE SENTENCE.**  I carried that item as
-- open in my working state for roughly twelve cycles and came within
-- one cycle of lifting a treadmill rest to rebuild what already
-- existed; recorded at `d0467d7b`.
--
-- **WHAT IS ACTUALLY OPEN ON THIS LINE**, in the closing module's own
-- words: the commutation hypothesis is GLOBAL â” `comm` quantifies over
-- ALL steps of the type, not over the steps appearing in the list.
-- Restricting it to list members is possible but needs the restriction
-- carried through `swap` and `trans` with a membership index, which is
-- NOT done.  So the line covers a system whose elimination steps all
-- commute, not a system with a commuting sub-family â” which is the case
-- Î” 28's setting plausibly has.
--
-- NOTHING ABOVE IS RETRACTED.  Every theorem in this file is unaltered
-- and true, and `cc8a3e16`'s three-point witness still shows the
-- impossibility is non-vacuous.
------------------------------------------------------------------------
