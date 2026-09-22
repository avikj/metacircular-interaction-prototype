{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FlippingACostCoordinateIsSoundButNotFaithful
--
-- §5.2's objectives include wall time, tokens, and dollar cost, which
-- are to be MINIMISED; the other modules on the Pareto line flip no
-- coordinate, so their theorems are about a vector all of whose
-- coordinates point the same way, and applying them needs the costs
-- negated first.
--
-- The min-plus line shows twice that reversing an order is load-bearing
-- rather than cosmetic — once in the residuation, once in mistaking the
-- meet for a `min`.  So the flip has its own theorem, and it does not
-- come free.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Vec ds            a fitness vector as a RECURSIVE FAMILY over a
--                     direction list: one entry per objective, one
--                     `Bool` per objective saying benefit or cost.  No
--                     `Fin`, and mismatched arities are not
--                     representable
--   Dom ds v w        MIXED dominance: `≤` at a benefit coordinate,
--                     `≥` at a cost coordinate — what §5.2 actually
--                     means by Pareto
--   ∸-antitone        `b ∸ _` reverses `≤`, derived from the monus
--                     adjunction already proved on the min-plus line
--   flipWith          cap the costs and subtract: `cap ∸ x` at a cost
--                     coordinate, `x` at a benefit one
--   flipIsSound       mixed dominance IMPLIES ordinary product
--                     dominance of the flipped vectors — so every
--                     theorem on the Pareto line transfers
--   flipIsNotFaithful and the converse FAILS: at `cap = 3`, the costs
--                     `5` and `7` both flip to `0`, so the flipped
--                     vectors dominate each other while the originals
--                     do not
--
-- **So "negate the costs first" is half true.**  Flipping is
-- enough to APPLY the results — soundness is all that direction needs.
-- It is not enough to TRANSPORT them back: a conclusion about flipped
-- vectors does not return, because the cap identifies every cost above
-- it.  The exact form is "negate the costs, and pick a cap
-- above every cost you will ever compare", which is a real modelling
-- obligation and not a rewriting step.
------------------------------------------------------------------------

module FlippingACostCoordinateIsSoundButNotFaithful where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; snotz ; injSuc ; +-comm)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; ≤-trans ; ≤-k+)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_≼_)
open import MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (∸-adjˡ ; ∸-adjʳ)

------------------------------------------------------------------------
-- 1.  Vectors over a direction list, and mixed dominance
------------------------------------------------------------------------

Vec : List Bool → Type
Vec []       = Unit
Vec (_ ∷ ds) = ℕ × Vec ds

-- `true` = benefit (higher is better), `false` = cost (lower is better)
Dom : (ds : List Bool) → Vec ds → Vec ds → Type
Dom []           _        _        = Unit
Dom (true  ∷ ds) (x , xs) (y , ys) = (x ≤ y) × Dom ds xs ys
Dom (false ∷ ds) (x , xs) (y , ys) = (y ≤ x) × Dom ds xs ys

------------------------------------------------------------------------
-- 2.  Monus is antitone, from the adjunction already proved
------------------------------------------------------------------------

∸-antitone : (b m n : ℕ) → m ≤ n → b ∸ n ≤ b ∸ m
∸-antitone b m n le =
  ∸-adjʳ b n (b ∸ m) (≤-trans (∸-adjˡ b m (b ∸ m) ≤-refl) (≤-k+ le))

------------------------------------------------------------------------
-- 3.  The flip
------------------------------------------------------------------------

flipWith : (cap : ℕ) (ds : List Bool) → Vec ds → List ℕ
flipWith cap []           _        = []
flipWith cap (true  ∷ ds) (x , xs) = x ∷ flipWith cap ds xs
flipWith cap (false ∷ ds) (x , xs) = (cap ∸ x) ∷ flipWith cap ds xs

flipIsSound :
  (cap : ℕ) (ds : List Bool) (v w : Vec ds)
  → Dom ds v w → flipWith cap ds v ≼ flipWith cap ds w
flipIsSound cap []           _        _        _           = tt
flipIsSound cap (true  ∷ ds) (x , xs) (y , ys) (le , rest) =
  le , flipIsSound cap ds xs ys rest
flipIsSound cap (false ∷ ds) (x , xs) (y , ys) (ge , rest) =
  ∸-antitone cap y x ge , flipIsSound cap ds xs ys rest

------------------------------------------------------------------------
-- 4.  And the converse fails: the cap identifies costs above it
------------------------------------------------------------------------

oneCost : List Bool
oneCost = false ∷ []

cheap dear : Vec oneCost
cheap = 5 , tt
dear  = 7 , tt

bothFlipToZero : flipWith 3 oneCost cheap ≼ flipWith 3 oneCost dear
bothFlipToZero = ≤-refl , tt

¬7≤5 : ¬ (7 ≤ 5)
¬7≤5 (k , e) =
  snotz (injSuc (injSuc (injSuc (injSuc (injSuc (sym (+-comm k 7) ∙ e))))))

dearDoesNotDominate : ¬ Dom oneCost cheap dear
dearDoesNotDominate (le , _) = ¬7≤5 le

flipIsNotFaithful :
    (flipWith 3 oneCost cheap ≼ flipWith 3 oneCost dear)
  × (¬ Dom oneCost cheap dear)
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
