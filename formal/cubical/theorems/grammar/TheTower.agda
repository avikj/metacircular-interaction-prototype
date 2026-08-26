{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTower
--
-- Five levels of description, each strictly finer than the one above,
-- each separation a term.  The corpus has been moving between them
-- without a name for the movement.
--
--   1  cardinality        a type up to equivalence
--   2  denotation         which function, not just how many points
--   3  rule set           which rules are present
--   4  ordered text       the sūtrapāṭha, in its order
--   5  alphabet order     the śiva-sūtra list beneath the rules
--
-- The separations, all checked, all of the same shape — two objects the
-- coarser level identifies and the finer one distinguishes:
--
--   1 ← 2   `cardinality-forgets-which` (below).  `Bool` has two
--           self-equivalences; the cardinality is 2 either way.
--   2 ← 3   `Laghava.laghava-collision`.  Two expressions, one function,
--           different लाघव.
--   3 ← 4   `Anuvrtti.anuvrtti-collision`.  Two texts, one rule set,
--           different लाघव, by अनुवृत्ति.
--   4 ← 5   `Pratyahara.no-order-makes-all-intervals`.  Not a collision —
--           an exhaustive impossibility, and the only genuine obstruction
--           the session found.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE UNIVALENCE SITS
--
-- At level 1, and exactly there.  `UnivalenceErasesTheAlgorithm` shows
-- `ua` records the equivalence and nothing beneath it, so univalence is
-- the tool for the top level and is blind to 2–5 by construction — which
-- is not a defect and is why लाघव had to be invented separately.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY FIVE AND NOT MORE
--
-- No claim that the tower is complete.  Levels 3–5 are Pāṇini's and were
-- read off the Aṣṭādhyāyī's actual devices; a tradition with different
-- devices would supply different levels.  What is claimed is that these
-- five are distinct, and that is what the four terms establish.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module TheTower where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import Laghava using (laghava-collision)
open import Anuvrtti using (anuvrtti-collision)
open import Pratyahara using (no-order-makes-all-intervals)

------------------------------------------------------------------------
-- 1 ← 2.  Cardinality does not determine the function.
--
-- The one separation the session had not made as a term.  `Bool` and
-- `Bool` are equivalent in two ways; at level 1 that is one fact (the
-- cardinality is 2), at level 2 it is two different functions.
------------------------------------------------------------------------

idB : Bool → Bool
idB b = b

cardinality-forgets-which : ¬ (idB ≡ not)
cardinality-forgets-which p = true≢false (funExt⁻ p true)

-- and both are bijections, so nothing at level 1 could have told them
-- apart: they have the same source, the same target, and the same count.
both-are-involutions :
  ((b : Bool) → idB (idB b) ≡ b) × ((b : Bool) → not (not b) ≡ b)
both-are-involutions = (λ _ → refl) , inv
  where
  inv : (b : Bool) → not (not b) ≡ b
  inv true  = refl
  inv false = refl

------------------------------------------------------------------------
-- 2.  The tower, assembled — every separation as a term in one place
------------------------------------------------------------------------

-- 1 ← 2 : here.
-- 2 ← 3 : two expressions, one meaning, different size.
level2←3 = laghava-collision

-- 3 ← 4 : two texts, one rule set, different cost.
level3←4 = anuvrtti-collision

-- 4 ← 5 : every ordering of three letters fails on some pair.
level4←5 = no-order-makes-all-intervals

------------------------------------------------------------------------
-- 3.  The shape of the four, said once.
--
-- Three of them are COLLISIONS: two objects identified above, separated
-- below.  The fourth is not — it is an exhaustive impossibility, and by
-- `Pratyahara` §§6–7 its content is a size, four rather than three.
--
-- shape with the analytic lane's flagship open problem.  The tower is
-- where the two notes meet: every level boundary is either a collision or
-- a size, and there is no third kind in anything this session touched.
------------------------------------------------------------------------
