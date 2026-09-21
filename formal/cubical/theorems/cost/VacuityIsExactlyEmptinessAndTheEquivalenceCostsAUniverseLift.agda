{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- VacuityIsExactlyEmptinessAndTheEquivalenceCostsAUniverseLift
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Consistency models, happens-before and causal delivery are
-- distributed-systems objects with no Indian source I can establish,
-- and a fabricated  label would assert a provenance nobody
-- checked.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; no row
-- applies and the frame check's scope requires Indian material, of
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE AUDIT.  Target: `AnEmptyDependencyRelationMakesCausalDeliveryVacuous`,
-- ¬ß3.2.  That module proves two things and draws the wrong pair of
-- conclusions from them:
--
--   ¬ß2  emptyDeclarationIsRespectedByEveryOrder : empty hb ‚í every order
--       respects hb; and its instance `theConcurrentOrderIsAdmissible`
--       at the order `Œª _ _ ‚í ‚ä`.
--   ¬ß3  oneDeclaredEdgeExcludesTheConcurrentOrder : one edge refutes
--       `Respects (Œª _ _ ‚í ‚ä)`.
--
-- and comments on ¬ß3: *"So ¬ß2 is not a fact about causal delivery; it is
-- a fact about the relation being empty."*
--
-- **THE CONCLUSION IS RIGHT AND THE THEOREM UNDER IT IS WEAKER THAN THE
-- ONE ALREADY IN THE MODULE.**  ¬ß3 excludes ONE order from ONE edge.
-- The statement that actually says "vacuity is a fact about emptiness"
-- is the universally quantified converse
--
--     (every order respects hb) ‚í hb is empty
--
-- and it is **free from ¬ß2's own instance, read backwards**: apply the
-- vacuity hypothesis at the order `Œª _ _ ‚í ‚ä`, which is admissible
-- precisely when nothing is declared.  The module contained both halves
-- of a biimplication and published only the weaker consequence of one.
--
-- Applying the test that has been earning its keep on this line: take
-- the prose claim at its strong reading and try to INSTANTIATE it.
-- "The emptiness is doing all the work" at strength means *exactly*
-- emptiness ‚î an iff ‚î and ¬ß3 does not give it.
--
-- WHAT IS PROVED
--
--   vacuousToEmpty / emptyToVacuous
--                    the biimplication, both directions, one line each.
--   isPropEmptyHB    emptiness is a proposition (`isProp¬` pointwise).
--   VacuousP, isPropVacuousP
--                    vacuity RESTRICTED to hProp-valued orders is a
--                    proposition, and the restriction does not cost the
--                    theorem: the witnessing order `Œª _ _ ‚í ‚ä` is
--                    itself a proposition, so both directions survive.
--   vacuityIsExactlyEmptiness
--                    `Lift EmptyHB ‚â VacuousP`, by `propBiimpl‚íEquiv`.
--
-- **AND THE LIFT IS THE CONTENT, NOT PACKAGING.**  `EmptyHB` quantifies
-- over WRITES and lives in `Type‚`.  Vacuity quantifies over ORDERS ‚î
-- a universe of relations ‚î and therefore lives one level up, in
-- `Type‚`, whatever h-level it has.  v0.5's `propBiimpl‚íEquiv` takes
-- both arguments at the SAME level (`A B C D : Type ‚ì` in
-- `Cubical.Foundations.Equiv`), so the equivalence is stated with an
-- explicit `Lift`.  That is not a technicality: **"vacuity" and
-- "emptiness" are not statements of the same kind**, one being a fact
-- about a relation and the other a fact about every relation on it,
-- and the universe gap is where that difference is recorded.
------------------------------------------------------------------------

module VacuityIsExactlyEmptinessAndTheEquivalenceCostsAUniverseLift where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isPropŒ† ; isOfHLevelLift ; hProp)
open import Cubical.Foundations.Structure using (‚ü®_‚ü©)
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; propBiimpl‚ÜíEquiv)
open import Cubical.Data.Empty as ‚ä• using (‚ä• ; isProp‚ä•)
open import Cubical.Relation.Nullary using (¬¨_ ; isProp¬¨)

open import AnEmptyDependencyRelationMakesCausalDeliveryVacuous
  using (Respects ; emptyDeclarationIsRespectedByEveryOrder)

module _ (Write : Type) (hb : Write ‚Üí Write ‚Üí Type) where

  ------------------------------------------------------------------
  -- 1.  The two sides
  ------------------------------------------------------------------

  EmptyHB : Type
  EmptyHB = (a b : Write) ‚Üí ¬¨ hb a b

  Vacuous : Type‚ÇÅ
  Vacuous = (ord : Write ‚Üí Write ‚Üí Type) ‚Üí Respects Write hb ord

  ------------------------------------------------------------------
  -- 2.  The biimplication.  The forward half is the audited module's
  --     ¬ß2; the backward half is its ¬ß2's own instance, read backwards,
  --     and is what ¬ß3 should have said.
  ------------------------------------------------------------------

  emptyToVacuous : EmptyHB ‚Üí Vacuous
  emptyToVacuous empty ord =
    emptyDeclarationIsRespectedByEveryOrder Write hb empty ord

  vacuousToEmpty : Vacuous ‚Üí EmptyHB
  vacuousToEmpty vac a b h = vac (Œª _ _ ‚Üí ‚ä•) a b h

  ------------------------------------------------------------------
  -- 3.  h-levels, and the restriction that buys one
  ------------------------------------------------------------------

  isPropEmptyHB : isProp EmptyHB
  isPropEmptyHB = isPropŒ† Œª a ‚Üí isPropŒ† Œª b ‚Üí isProp¬¨ (hb a b)

  -- vacuity over PROPOSITION-valued orders.  `Respects` is unchanged;
  -- only the range of `ord` is narrowed, and the narrowing is free
  -- because the order that witnesses ¬ß2's backward half is `‚ä`, which
  -- is a proposition.
  VacuousP : Type‚ÇÅ
  VacuousP =
    (ord : Write ‚Üí Write ‚Üí hProp ‚Ñì-zero)
    ‚Üí Respects Write hb (Œª a b ‚Üí ‚ü® ord a b ‚ü©)

  isPropVacuousP : isProp VacuousP
  isPropVacuousP =
    isPropŒ† Œª ord ‚Üí isPropŒ† Œª a ‚Üí isPropŒ† Œª b ‚Üí isPropŒ† Œª _ ‚Üí snd (ord a b)

  emptyToVacuousP : EmptyHB ‚Üí VacuousP
  emptyToVacuousP empty ord a b h = ‚ä•.rec (empty a b h)

  vacuousPToEmpty : VacuousP ‚Üí EmptyHB
  vacuousPToEmpty vac a b h = vac (Œª _ _ ‚Üí (‚ä• , isProp‚ä•)) a b h

  ------------------------------------------------------------------
  -- 4.  And therefore an equivalence ‚î across one universe level
  ------------------------------------------------------------------

  vacuityIsExactlyEmptiness : Lift {j = ‚Ñì-suc ‚Ñì-zero} EmptyHB ‚âÉ VacuousP
  vacuityIsExactlyEmptiness =
    propBiimpl‚ÜíEquiv
      (isOfHLevelLift 1 isPropEmptyHB)
      isPropVacuousP
      (Œª e ‚Üí emptyToVacuousP (lower e))
      (Œª v ‚Üí lift (vacuousPToEmpty v))

------------------------------------------------------------------------
-- 5.  What this changes about reading SEED83 ¬ß3.2
--
-- The note says a corpus with no declared dependencies "cannot be run
-- causally-consistent by tuning `sync`; it lacks the metadata for the
-- model to have content."  ¬ß4 above is the exact form of that: the
-- delivery constraint and the emptiness of the dependency relation are
-- the SAME statement, not merely one implying the other.  So there is
-- no intermediate regime in which the constraint is weak-but-present ‚î
-- it is either empty and inert, or inhabited and biting.
--
-- What that does NOT settle, and is a different theorem: whether the
-- constraint biting on SOME orders makes it useful, i.e. how the
-- strength of the discipline grows with the number of recorded edges.
-- `oneDeclaredEdgeExcludesTheConcurrentOrder` is the first point of that
-- curve and nothing on this line computes a second.
------------------------------------------------------------------------
