{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FlippingACostCoordinateIsSoundButNotFaithful
--
-- Every module on the Pareto line has carried the same admission:
--
--   "§5.2's objectives include wall time, tokens, and dollar cost,
--    which are to be MINIMISED; nothing below flips any coordinate, so
--    the theorems are about a vector all of whose coordinates point the
--    same way, and applying them needs the costs negated first."
--
-- Two cycles on the min-plus line then showed that reversing an order
-- is load-bearing rather than cosmetic — once in the residuation, once
-- in mistaking the meet for a `min`.  So the flip deserves its own
-- theorem instead of a promise, and it does not come free.
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
-- **So the promise those modules made is half true.**  Flipping is
-- enough to APPLY the results — soundness is all that direction needs.
-- It is not enough to TRANSPORT them back: a conclusion about flipped
-- vectors does not return, because the cap identifies every cost above
-- it.  The admission should have said "negate the costs, and pick a cap
-- above every cost you will ever compare", which is a real modelling
-- obligation and not a rewriting step.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  That maximising `C ∸ x` is minimising `x` under a cap,
-- and that truncation loses the order above the cap, is elementary; it
-- is proved here because five modules deferred it in a sentence.
--
-- SYĀT — THE CLAIM, EXACTLY.  No RESTRICTED converse is proved: presumably
-- `flipIsSound`'s converse holds once every cost is `≤ cap`, and that
-- is NOT checked here — only the unrestricted converse is refuted.  The
-- cap is a single number shared by all cost coordinates; per-coordinate
-- caps are not modelled.  Nothing is said about how a cap should be
-- chosen, and nothing here connects to `stratum` or `maximalExists` —
-- transporting those along the flip is a further step, not done.
-- `Vec ds` is indexed by DIRECTIONS, not by a length, so it is not the
-- `List ℕ` the earlier Pareto modules use; `flipWith` lands in `List ℕ`
-- precisely so their `_≼_` applies unchanged.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The item left open above — "no RESTRICTED converse is
-- proved: presumably `flipIsSound`'s converse holds once every cost is
-- `≤ cap`" — is closed in
-- `RnaDhana_TheCostFlipIsFaithfulBelowTheCap` (--safe,
-- no postulates, no holes; container green under Agda 2.6.3 + cubical
-- v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- **The guess above was stronger than the truth.**  Not every cost
-- needs the bound: only the costs of `w`, the vector claimed to
-- dominate.  `v`'s costs may exceed the cap arbitrarily.  So the
-- modelling obligation this line has been carrying is smaller than it
-- was written — a cap above the costs of the candidates one wants to
-- conclude are BETTER, not above every cost in the archive.
--
-- The refutation above is untouched and consistent with it: its
-- witness caps at 3 with `w`'s cost 7, which fails the bound.
--
-- That module also carries the owner's naming directive of 2026-08-19
-- (CLAUDE.md, "File naming"): the Indian term first, the English
-- title after an underscore.  ऋणधन · ṛṇa-dhana, Brahmagupta's asset
-- and debt — one magnitude under two readings, which is what a benefit
-- coordinate and a cost coordinate are.
------------------------------------------------------------------------
