{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FlippingACostCoordinateIsSoundButNotFaithful
--
-- Â§5.2's objectives include wall time, tokens, and dollar cost, which
-- are to be MINIMISED; the other modules on the Pareto line flip no
-- coordinate, so their theorems are about a vector all of whose
-- coordinates point the same way, and applying them needs the costs
-- negated first.
--
-- The min-plus line shows twice that reversing an order is load-bearing
-- rather than cosmetic â” once in the residuation, once in mistaking the
-- meet for a `min`.  So the flip has its own theorem, and it does not
-- come free.
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
-- **So "negate the costs first" is half true.**  Flipping is
-- enough to APPLY the results â” soundness is all that direction needs.
-- It is not enough to TRANSPORT them back: a conclusion about flipped
-- vectors does not return, because the cap identifies every cost above
-- it.  The exact form is "negate the costs, and pick a cap
-- above every cost you will ever compare", which is a real modelling
-- obligation and not a rewriting step.
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
-- The RESTRICTED converse of `flipIsSound` is proved in
-- `RnaDhana_TheCostFlipIsFaithfulBelowTheCap`.  Not every cost needs
-- the bound: only the costs of `w`, the vector claimed to dominate.
-- `v`'s costs may exceed the cap arbitrarily.  So the modelling
-- obligation is a cap above the costs of the candidates one wants to
-- conclude are BETTER, not above every cost in the archive.
--
-- The refutation above is consistent with it: its witness caps at 3
-- with `w`'s cost 7, which fails the bound.
------------------------------------------------------------------------
