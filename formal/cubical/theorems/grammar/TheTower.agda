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
--   4  ordered text       the strapha, in its order
--   5  alphabet order     the iva-stra list beneath the rules
--
-- The separations, all checked, all of the same shape ‚î two objects the
-- coarser level identifies and the finer one distinguishes:
--
--   1 ‚ê 2   `cardinality-forgets-which` (below).  `Bool` has two
--           self-equivalences; the cardinality is 2 either way.
--   2 ‚ê 3   `Laghava.laghava-collision`.  Two expressions, one function,
--           different ‡≤‡æ‡ò‡µ.
--   3 ‚ê 4   `Anuvrtti.anuvrtti-collision`.  Two texts, one rule set,
--           different ‡≤‡æ‡ò‡µ, by ‡‡®‡‡µ‡‡‡‡‡ø.
--   4 ‚ê 5   `Pratyahara.no-order-makes-all-intervals`.  Not a collision ‚î
--           an exhaustive impossibility.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHERE UNIVALENCE SITS
--
-- At level 1, and exactly there.  `UnivalenceErasesTheAlgorithm` shows
-- `ua` records the equivalence and nothing beneath it, so univalence is
-- the tool for the top level and is blind to 2‚ì5 by construction ‚î which
-- is not a defect and is why ‡≤‡æ‡ò‡µ had to be invented separately.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY FIVE AND NOT MORE
--
-- Levels 3‚ì5 are Pini's and were
-- read off the Adhyy's actual devices; a tradition with different
-- devices would supply different levels.  These five are distinct, and
-- that is what the four terms establish.
------------------------------------------------------------------------

module TheTower where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true‚â¢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import Laghava using (laghava-collision)
open import Anuvrtti using (anuvrtti-collision)
open import Pratyahara using (no-order-makes-all-intervals)

------------------------------------------------------------------------
-- 1 ‚ê 2.  Cardinality does not determine the function.
--
-- `Bool` and `Bool` are equivalent in two ways; at level 1 that is one fact (the
-- cardinality is 2), at level 2 it is two different functions.
------------------------------------------------------------------------

idB : Bool ‚Üí Bool
idB b = b

cardinality-forgets-which : ¬¨ (idB ‚â° not)
cardinality-forgets-which p = true‚â¢false (funExt‚Åª p true)

-- and both are bijections, so nothing at level 1 could have told them
-- apart: they have the same source, the same target, and the same count.
both-are-involutions :
  ((b : Bool) ‚Üí idB (idB b) ‚â° b) √ó ((b : Bool) ‚Üí not (not b) ‚â° b)
both-are-involutions = (Œª _ ‚Üí refl) , inv
  where
  inv : (b : Bool) ‚Üí not (not b) ‚â° b
  inv true  = refl
  inv false = refl

------------------------------------------------------------------------
-- 2.  The tower, assembled ‚î every separation as a term in one place
------------------------------------------------------------------------

-- 1 ‚ê 2 : here.
-- 2 ‚ê 3 : two expressions, one meaning, different size.
level2‚Üê3 = laghava-collision

-- 3 ‚ê 4 : two texts, one rule set, different cost.
level3‚Üê4 = anuvrtti-collision

-- 4 ‚ê 5 : every ordering of three letters fails on some pair.
level4‚Üê5 = no-order-makes-all-intervals

------------------------------------------------------------------------
-- 3.  The shape of the four, said once.
--
-- Three of them are COLLISIONS: two objects identified above, separated
-- below.  The fourth is not ‚î it is an exhaustive impossibility, and by
-- `Pratyahara` ¬ß¬ß6‚ì7 its content is a size, four rather than three.
------------------------------------------------------------------------
