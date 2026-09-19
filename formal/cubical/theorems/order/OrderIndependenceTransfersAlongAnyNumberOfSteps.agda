{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OrderIndependenceTransfersAlongAnyNumberOfSteps
--
-- `CurvatureCannotLiveOnTheImageOfAnExactCompression` closed with:
--
--   "ORDERS: two steps are treated, so 'for every order' is here just
--    'the two orders of two steps'; nothing is proved for `n` steps,
--    and the `n`-step statement needs the two-step case plus an
--    induction that is not written."
--
-- The induction is written, and it turns out NOT to need the two-step
-- case at all â” which is the finding.  What the two-step proof did by
-- pasting three squares, the n-step proof does by pasting ONE square
-- per step and then using the uncompressed order-independence once.
-- The earlier module is a corollary, not a lemma.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Step              a step, its compressed counterpart, and the
--                     intertwining square, packaged so a LIST of them
--                     carries its own hypotheses
--   runS / runT       run a list of steps, rightmost first
--   simFold           `C (runS ps s) â‰¡ runT ps (C s)` â” intertwining
--                     extends from one step to any composite, by a
--                     one-line induction
--   orderIndependenceTransfers
--                     if two composites agree UNCOMPRESSED, their
--                     compressed counterparts agree on the image
--   disagreementIsOffTheImage
--                     hence a point where two compressed composites
--                     disagree is not `C` of anything
--   twoStepsAreAnInstance
--                     the earlier two-step theorem, recovered by taking
--                     the two lists to be `f âˆ g âˆ []` and `g âˆ f âˆ []`
--
-- **The generalisation is cheaper than the special case.**  The
-- two-step proof pasted a simulation square, the commuting square, and
-- a second simulation square in sequence; the n-step proof separates
-- those concerns â” `simFold` is pure simulation and knows nothing about
-- commuting, and the commuting hypothesis is applied exactly once,
-- under a single `cong C`.  Generality removed the interleaving that
-- made the two-step argument look like a chain.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  A simulation extends to composites by induction, and
-- transports equalities of composites onto the image; this is the
-- functoriality of simulation and is standard.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module OrderIndependenceTransfersAlongAnyNumberOfSteps where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (Î£-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

module _ {S T : Type} (C : S â†’ T) where

  ------------------------------------------------------------------
  -- 1.  A step carries its own intertwining square
  ------------------------------------------------------------------

  Step : Type
  Step = Î£[ f âˆˆ (S â†’ S) ] Î£[ f' âˆˆ (T â†’ T) ]
           ((s : S) â†’ C (f s) â‰¡ f' (C s))

  runS : List Step â†’ S â†’ S
  runS []       s = s
  runS (p âˆ· ps) s = fst p (runS ps s)

  runT : List Step â†’ T â†’ T
  runT []       t = t
  runT (p âˆ· ps) t = fst (snd p) (runT ps t)

  ------------------------------------------------------------------
  -- 2.  Intertwining extends to composites
  ------------------------------------------------------------------

  simFold : (ps : List Step) (s : S) â†’ C (runS ps s) â‰¡ runT ps (C s)
  simFold []       s = refl
  simFold (p âˆ· ps) s =
    snd (snd p) (runS ps s) âˆ™ cong (fst (snd p)) (simFold ps s)

  ------------------------------------------------------------------
  -- 3.  So order-independence transfers, for any number of steps
  ------------------------------------------------------------------

  orderIndependenceTransfers :
    (ps qs : List Step)
    â†’ ((s : S) â†’ runS ps s â‰¡ runS qs s)
    â†’ (s : S) â†’ runT ps (C s) â‰¡ runT qs (C s)
  orderIndependenceTransfers ps qs eq s =
    sym (simFold ps s) âˆ™ cong C (eq s) âˆ™ simFold qs s

  disagreementIsOffTheImage :
    (ps qs : List Step)
    â†’ ((s : S) â†’ runS ps s â‰¡ runS qs s)
    â†’ (t : T) â†’ Â¬ (runT ps t â‰¡ runT qs t) â†’ Â¬ (Î£[ s âˆˆ S ] C s â‰¡ t)
  disagreementIsOffTheImage ps qs eq t bent (s , e) =
    bent (subst (Î» x â†’ runT ps x â‰¡ runT qs x) e
                (orderIndependenceTransfers ps qs eq s))

  ------------------------------------------------------------------
  -- 4.  The two-step theorem is an instance
  ------------------------------------------------------------------

  twoStepsAreAnInstance :
    (p q : Step)
    â†’ ((s : S) â†’ fst p (fst q s) â‰¡ fst q (fst p s))
    â†’ (s : S)
    â†’ fst (snd p) (fst (snd q) (C s)) â‰¡ fst (snd q) (fst (snd p) (C s))
  twoStepsAreAnInstance p q comm =
    orderIndependenceTransfers (p âˆ· q âˆ· []) (q âˆ· p âˆ· []) comm

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "PERMUTATIONS ARE NOT MODELLED.  'For every order' is encoded as
--    the HYPOTHESIS that two uncompressed composites agree â¦ and NO
--    theorem here derives that hypothesis from pairwise commutation."
--
-- Derived, in `PairwiseCommutationGivesEveryOrder`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so):
--
--   _~_             permutation in the standard inductive presentation
--                   (identity, congruence, ADJACENT transposition,
--                    transitivity)
--   permInvariant   under pairwise commutation of the STEPS, any two
--                   permutations have the same uncompressed composite â”
--                   and the transposition case IS the hypothesis
--   everyOrderAgreesAfterCompression / disagreementUnderPermutationIsOffTheImage
--
-- So Î” 28 Â§36â“38's "for every order" is now discharged at the level it
-- is stated: three cycles ago it was two orders of two steps; here it
-- was any two composites ASSUMED equal; there it is â” assume the steps
-- commute PAIRWISE, and every order agrees, compressed and
-- uncompressed alike.
--
-- ONE CUBICAL DETAIL WORTH CARRYING: `permInvariant` matches on the
-- RELATION only and keeps the lists implicit.  Matching the lists too
-- makes Agda warn that the function "will not compute when applied to
-- transports", because it would rely on injectivity of `_âˆ_`, which
-- cubical does not support.  The first draft did exactly that and was
-- rewritten.
--
------------------------------------------------------------------------
