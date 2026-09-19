{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FlippingACostCoordinateIsSoundButNotFaithful
--
-- Every module on the Pareto line has carried the same admission:
--
--   "Â§5.2's objectives include wall time, tokens, and dollar cost,
--    which are to be MINIMISED; nothing below flips any coordinate, so
--    the theorems are about a vector all of whose coordinates point the
--    same way, and applying them needs the costs negated first."
--
-- Two cycles on the min-plus line then showed that reversing an order
-- is load-bearing rather than cosmetic â” once in the residuation, once
-- in mistaking the meet for a `min`.  So the flip deserves its own
-- theorem instead of a promise, and it does not come free.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Vec ds            a fitness vector as a RECURSIVE FAMILY over a
--                     direction list: one entry per objective, one
--                     `Bool` per objective saying benefit or cost.  No
--                     `Fin`, and mismatched arities are not
--                     representable
--   Dom ds v w        MIXED dominance: `â‰` at a benefit coordinate,
--                     `â‰` at a cost coordinate â” what Â§5.2 actually
--                     means by Pareto
--   âˆ-antitone        `b âˆ _` reverses `â‰`, derived from the monus
--                     adjunction already proved on the min-plus line
--   flipWith          cap the costs and subtract: `cap âˆ x` at a cost
--                     coordinate, `x` at a benefit one
--   flipIsSound       mixed dominance IMPLIES ordinary product
--                     dominance of the flipped vectors â” so every
--                     theorem on the Pareto line transfers
--   flipIsNotFaithful and the converse FAILS: at `cap = 3`, the costs
--                     `5` and `7` both flip to `0`, so the flipped
--                     vectors dominate each other while the originals
--                     do not
--
-- **So the promise those modules made is half true.**  Flipping is
-- enough to APPLY the results â” soundness is all that direction needs.
-- It is not enough to TRANSPORT them back: a conclusion about flipped
-- vectors does not return, because the cap identifies every cost above
-- it.  The admission should have said "negate the costs, and pick a cap
-- above every cost you will ever compare", which is a real modelling
-- obligation and not a rewriting step.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  That maximising `C âˆ x` is minimising `x` under a cap,
-- and that truncation loses the order above the cap, is elementary; it
-- is proved here because five modules deferred it in a sentence.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module FlippingACostCoordinateIsSoundButNotFaithful where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _âˆ¸_ ; snotz ; injSuc ; +-comm)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; â‰¤-refl ; â‰¤-trans ; â‰¤-k+)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_â‰¼_)
open import MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (âˆ¸-adjË¡ ; âˆ¸-adjÊ³)

------------------------------------------------------------------------
-- 1.  Vectors over a direction list, and mixed dominance
------------------------------------------------------------------------

Vec : List Bool â†’ Type
Vec []       = Unit
Vec (_ âˆ· ds) = â„• Ã— Vec ds

-- `true` = benefit (higher is better), `false` = cost (lower is better)
Dom : (ds : List Bool) â†’ Vec ds â†’ Vec ds â†’ Type
Dom []           _        _        = Unit
Dom (true  âˆ· ds) (x , xs) (y , ys) = (x â‰¤ y) Ã— Dom ds xs ys
Dom (false âˆ· ds) (x , xs) (y , ys) = (y â‰¤ x) Ã— Dom ds xs ys

------------------------------------------------------------------------
-- 2.  Monus is antitone, from the adjunction already proved
------------------------------------------------------------------------

âˆ¸-antitone : (b m n : â„•) â†’ m â‰¤ n â†’ b âˆ¸ n â‰¤ b âˆ¸ m
âˆ¸-antitone b m n le =
  âˆ¸-adjÊ³ b n (b âˆ¸ m) (â‰¤-trans (âˆ¸-adjË¡ b m (b âˆ¸ m) â‰¤-refl) (â‰¤-k+ le))

------------------------------------------------------------------------
-- 3.  The flip
------------------------------------------------------------------------

flipWith : (cap : â„•) (ds : List Bool) â†’ Vec ds â†’ List â„•
flipWith cap []           _        = []
flipWith cap (true  âˆ· ds) (x , xs) = x âˆ· flipWith cap ds xs
flipWith cap (false âˆ· ds) (x , xs) = (cap âˆ¸ x) âˆ· flipWith cap ds xs

flipIsSound :
  (cap : â„•) (ds : List Bool) (v w : Vec ds)
  â†’ Dom ds v w â†’ flipWith cap ds v â‰¼ flipWith cap ds w
flipIsSound cap []           _        _        _           = tt
flipIsSound cap (true  âˆ· ds) (x , xs) (y , ys) (le , rest) =
  le , flipIsSound cap ds xs ys rest
flipIsSound cap (false âˆ· ds) (x , xs) (y , ys) (ge , rest) =
  âˆ¸-antitone cap y x ge , flipIsSound cap ds xs ys rest

------------------------------------------------------------------------
-- 4.  And the converse fails: the cap identifies costs above it
------------------------------------------------------------------------

oneCost : List Bool
oneCost = false âˆ· []

cheap dear : Vec oneCost
cheap = 5 , tt
dear  = 7 , tt

bothFlipToZero : flipWith 3 oneCost cheap â‰¼ flipWith 3 oneCost dear
bothFlipToZero = â‰¤-refl , tt

Â¬7â‰¤5 : Â¬ (7 â‰¤ 5)
Â¬7â‰¤5 (k , e) =
  snotz (injSuc (injSuc (injSuc (injSuc (injSuc (sym (+-comm k 7) âˆ™ e))))))

dearDoesNotDominate : Â¬ Dom oneCost cheap dear
dearDoesNotDominate (le , _) = Â¬7â‰¤5 le

flipIsNotFaithful :
    (flipWith 3 oneCost cheap â‰¼ flipWith 3 oneCost dear)
  Ã— (Â¬ Dom oneCost cheap dear)
flipIsNotFaithful = bothFlipToZero , dearDoesNotDominate

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The item left open above â” "no RESTRICTED converse is
-- proved: presumably `flipIsSound`'s converse holds once every cost is
-- `â‰ cap`" â” is closed in
-- `RnaDhana_TheCostFlipIsFaithfulBelowTheCap` (--safe,
-- no postulates, no holes; container green under Agda 2.6.3 + cubical
-- v0.5, NOT the declared pin â” check.sh returns 1 and says so).
--
-- **The guess above was stronger than the truth.**  Not every cost
-- needs the bound: only the costs of `w`, the vector claimed to
-- dominate.  `v`'s costs may exceed the cap arbitrarily.  So the
-- modelling obligation this line has been carrying is smaller than it
-- was written â” a cap above the costs of the candidates one wants to
-- conclude are BETTER, not above every cost in the archive.
--
-- The refutation above is untouched and consistent with it: its
-- witness caps at 3 with `w`'s cost 7, which fails the bound.
--
-- That module also carries the owner's naming directive of 2026-08-19
-- (CLAUDE.md, "File naming"): the Indian term first, the English
-- title after an underscore.  à‹àà§à¨ Â a-dhana, Brahmagupta's asset
-- and debt â” one magnitude under two readings, which is what a benefit
-- coordinate and a cost coordinate are.
------------------------------------------------------------------------
