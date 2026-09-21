{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheAdmissibleOrdersArePreciselyThePrincipalUpSetSoStrengthIsNotAFunctionOfTheEdgeCount
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Happens-before, causal delivery and consistency models are
-- distributed-systems objects with no established Indian source; a
-- fabricated label would assert a provenance.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE QUESTION, AND WHY IT IS MIS-POSED
--
-- Does the constraint biting on SOME orders make it useful, i.e. **how
-- does the strength of the discipline grow with the number of recorded
-- edges?**  `oneDeclaredEdgeExcludesTheConcurrentOrder` would be the
-- first point of that curve.
--
-- **There is no second point, because there is no curve.**  ¬ß1 below is
-- the reason, and it is one `refl`: for the delivery discipline of
-- `AnEmptyDependencyRelationMakesCausalDeliveryVacuous`,
--
--     Respects hb ord   is definitionally   hb ‚ä ord,
--
-- so the admissible orders of `hb` are exactly the PRINCIPAL UP-SET of
-- `hb` in the inclusion preorder on relations.  Strength is therefore
-- not a quantity attached to a relation; it IS the relation, read
-- upwards.  ¬ß4 makes that refutation concrete rather than rhetorical:
-- two relations on `Bool` with ONE EDGE EACH whose admissible families
-- are incomparable ‚î neither contains the other.  **So no function of
-- the edge count can determine the discipline's strength**, and the
-- question was asking for a summary statistic that does not exist.
--
-- WHAT IS PROVED
--
--   respectsIsInclusion    `Respects Write hb ord ‚â° (hb ‚ä ord)`, `refl`
--   leastAdmissible        `hb` is itself admissible, so the family is
--                          the up-set of an actual element, not merely
--                          upward-closed
--   moreEdgesFewerOrders   antitone: `hb ‚ä hb‚≤` shrinks the family
--   admissibilityIsFaithful
--                          and the converse ‚î if every order admissible
--                          for `hb` is admissible for `hb‚≤` then
--                          `hb‚≤ ‚ä hb`.  Proved by evaluating the
--                          hypothesis AT `hb`, which `leastAdmissible`
--                          makes legal.  So the map
--                          `hb ‚¶ {orders admitting it}` is an
--                          order-reversing EMBEDDING: every genuinely
--                          new edge changes the family, and no two
--                          distinct relations share one
--   sameAdmissibleOrdersMeansSameRelation
--                          both directions at once
--   hbA / hbB / incomparableFamiliesAtOneEdgeEach
--                          the counterexample: `hbA` declares
--                          `false ‚í true`, `hbB` declares `true ‚í false`,
--                          and each is admissible for itself and not for
--                          the other
--
-- **WHAT THIS SETTLES ABOUT THE EARLIER MODULE.**
-- `oneDeclaredEdgeExcludesTheConcurrentOrder` is the instance of
-- `admissibilityIsFaithful` at `hb = ‚à`, `ord = Œª _ _ ‚í ‚ä`.  It is
-- not the first point of a sequence; it is one corner of a lattice
-- statement.  Reading it as a data point ‚í **seeing a `1` in a theorem
-- and reaching for a growth law** ‚î is the reflex `CLAUDE.md` names
-- when it forbids fitting a pattern from three points.
------------------------------------------------------------------------

module TheAdmissibleOrdersArePreciselyThePrincipalUpSetSoStrengthIsNotAFunctionOfTheEdgeCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import AnEmptyDependencyRelationMakesCausalDeliveryVacuous
  using (Respects)

------------------------------------------------------------------------
-- 1.  Admissibility IS inclusion
------------------------------------------------------------------------

module _ (Write : Type) where

  Rel : Type‚ÇÅ
  Rel = Write ‚Üí Write ‚Üí Type

  _‚äë_ : Rel ‚Üí Rel ‚Üí Type
  R ‚äë S = (a b : Write) ‚Üí R a b ‚Üí S a b

  respectsIsInclusion :
    (hb ord : Rel) ‚Üí Respects Write hb ord ‚â° (hb ‚äë ord)
  respectsIsInclusion hb ord = refl

  ----------------------------------------------------------------------
  -- 2.  The family is the principal up-set of hb
  ----------------------------------------------------------------------

  leastAdmissible : (hb : Rel) ‚Üí Respects Write hb hb
  leastAdmissible hb a b h = h

  moreEdgesFewerOrders :
    (hb hb‚Ä≤ ord : Rel) ‚Üí hb ‚äë hb‚Ä≤
    ‚Üí Respects Write hb‚Ä≤ ord ‚Üí Respects Write hb ord
  moreEdgesFewerOrders hb hb‚Ä≤ ord sub resp a b h = resp a b (sub a b h)

  ----------------------------------------------------------------------
  -- 3.  ‚¶and the assignment hb ‚¶ its family is an embedding
  ----------------------------------------------------------------------

  admissibilityIsFaithful :
    (hb hb‚Ä≤ : Rel)
    ‚Üí ((ord : Rel) ‚Üí Respects Write hb ord ‚Üí Respects Write hb‚Ä≤ ord)
    ‚Üí hb‚Ä≤ ‚äë hb
  admissibilityIsFaithful hb hb‚Ä≤ f = f hb (leastAdmissible hb)

  sameAdmissibleOrdersMeansSameRelation :
    (hb hb‚Ä≤ : Rel)
    ‚Üí ((ord : Rel) ‚Üí Respects Write hb ord ‚Üí Respects Write hb‚Ä≤ ord)
    ‚Üí ((ord : Rel) ‚Üí Respects Write hb‚Ä≤ ord ‚Üí Respects Write hb ord)
    ‚Üí (hb‚Ä≤ ‚äë hb) √ó (hb ‚äë hb‚Ä≤)
  sameAdmissibleOrdersMeansSameRelation hb hb‚Ä≤ f g =
    admissibilityIsFaithful hb hb‚Ä≤ f , admissibilityIsFaithful hb‚Ä≤ hb g

------------------------------------------------------------------------
-- 4.  One edge each, incomparable families
--
-- `hbA` declares `false ‚í true`; `hbB` declares `true ‚í false`.  Each is
-- admissible for itself (¬ß2) and refuses the other, so neither family
-- contains the other.  Equal edge counts, incomparable strengths.
------------------------------------------------------------------------

hbA : Bool ‚Üí Bool ‚Üí Type
hbA false true = Unit
hbA _     _    = ‚ä•

hbB : Bool ‚Üí Bool ‚Üí Type
hbB true false = Unit
hbB _    _     = ‚ä•

hbBIsNotAdmissibleForHbA : ¬¨ Respects Bool hbB hbA
hbBIsNotAdmissibleForHbA resp = resp true false tt

hbAIsNotAdmissibleForHbB : ¬¨ Respects Bool hbA hbB
hbAIsNotAdmissibleForHbB resp = resp false true tt

incomparableFamiliesAtOneEdgeEach :
  ( Respects Bool hbA hbA √ó (¬¨ Respects Bool hbB hbA) )
  √ó ( Respects Bool hbB hbB √ó (¬¨ Respects Bool hbA hbB) )
incomparableFamiliesAtOneEdgeEach =
  ( leastAdmissible Bool hbA , hbBIsNotAdmissibleForHbA )
  , ( leastAdmissible Bool hbB , hbAIsNotAdmissibleForHbB )
