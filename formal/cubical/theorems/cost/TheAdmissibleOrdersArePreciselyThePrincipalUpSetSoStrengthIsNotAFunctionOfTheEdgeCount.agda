{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheAdmissibleOrdersArePreciselyThePrincipalUpSetSoStrengthIsNotAFunctionOfTheEdgeCount
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Happens-before, causal delivery and consistency models are
-- distributed-systems objects with no established Indian source; a
-- fabricated label would assert a provenance.
--
-- ────────────────────────────────────────────────────────────────────
-- THE QUESTION, AND WHY IT IS MIS-POSED
--
-- Does the constraint biting on SOME orders make it useful, i.e. **how
-- does the strength of the discipline grow with the number of recorded
-- edges?**  `oneDeclaredEdgeExcludesTheConcurrentOrder` would be the
-- first point of that curve.
--
-- **There is no second point, because there is no curve.**  §1 below is
-- the reason, and it is one `refl`: for the delivery discipline of
-- `AnEmptyDependencyRelationMakesCausalDeliveryVacuous`,
--
--     Respects hb ord   is definitionally   hb ⊑ ord,
--
-- so the admissible orders of `hb` are exactly the PRINCIPAL UP-SET of
-- `hb` in the inclusion preorder on relations.  Strength is therefore
-- not a quantity attached to a relation; it IS the relation, read
-- upwards.  §4 makes that refutation concrete rather than rhetorical:
-- two relations on `Bool` with ONE EDGE EACH whose admissible families
-- are incomparable — neither contains the other.  **So no function of
-- the edge count can determine the discipline's strength**, and the
-- question was asking for a summary statistic that does not exist.
--
-- WHAT IS PROVED
--
--   respectsIsInclusion    `Respects Write hb ord ≡ (hb ⊑ ord)`, `refl`
--   leastAdmissible        `hb` is itself admissible, so the family is
--                          the up-set of an actual element, not merely
--                          upward-closed
--   moreEdgesFewerOrders   antitone: `hb ⊑ hb′` shrinks the family
--   admissibilityIsFaithful
--                          and the converse — if every order admissible
--                          for `hb` is admissible for `hb′` then
--                          `hb′ ⊑ hb`.  Proved by evaluating the
--                          hypothesis AT `hb`, which `leastAdmissible`
--                          makes legal.  So the map
--                          `hb ↦ {orders admitting it}` is an
--                          order-reversing EMBEDDING: every genuinely
--                          new edge changes the family, and no two
--                          distinct relations share one
--   sameAdmissibleOrdersMeansSameRelation
--                          both directions at once
--   hbA / hbB / incomparableFamiliesAtOneEdgeEach
--                          the counterexample: `hbA` declares
--                          `false → true`, `hbB` declares `true → false`,
--                          and each is admissible for itself and not for
--                          the other
--
-- **WHAT THIS SETTLES ABOUT THE EARLIER MODULE.**
-- `oneDeclaredEdgeExcludesTheConcurrentOrder` is the instance of
-- `admissibilityIsFaithful` at `hb = ∅`, `ord = λ _ _ → ⊥`.  It is
-- not the first point of a sequence; it is one corner of a lattice
-- statement.
------------------------------------------------------------------------

module TheAdmissibleOrdersArePreciselyThePrincipalUpSetSoStrengthIsNotAFunctionOfTheEdgeCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import AnEmptyDependencyRelationMakesCausalDeliveryVacuous
  using (Respects)

------------------------------------------------------------------------
-- 1.  Admissibility IS inclusion
------------------------------------------------------------------------

module _ (Write : Type) where

  Rel : Type₁
  Rel = Write → Write → Type

  _⊑_ : Rel → Rel → Type
  R ⊑ S = (a b : Write) → R a b → S a b

  respectsIsInclusion :
    (hb ord : Rel) → Respects Write hb ord ≡ (hb ⊑ ord)
  respectsIsInclusion hb ord = refl

  ----------------------------------------------------------------------
  -- 2.  The family is the principal up-set of hb
  ----------------------------------------------------------------------

  leastAdmissible : (hb : Rel) → Respects Write hb hb
  leastAdmissible hb a b h = h

  moreEdgesFewerOrders :
    (hb hb′ ord : Rel) → hb ⊑ hb′
    → Respects Write hb′ ord → Respects Write hb ord
  moreEdgesFewerOrders hb hb′ ord sub resp a b h = resp a b (sub a b h)

  ----------------------------------------------------------------------
  -- 3.  …and the assignment hb ↦ its family is an embedding
  ----------------------------------------------------------------------

  admissibilityIsFaithful :
    (hb hb′ : Rel)
    → ((ord : Rel) → Respects Write hb ord → Respects Write hb′ ord)
    → hb′ ⊑ hb
  admissibilityIsFaithful hb hb′ f = f hb (leastAdmissible hb)

  sameAdmissibleOrdersMeansSameRelation :
    (hb hb′ : Rel)
    → ((ord : Rel) → Respects Write hb ord → Respects Write hb′ ord)
    → ((ord : Rel) → Respects Write hb′ ord → Respects Write hb ord)
    → (hb′ ⊑ hb) × (hb ⊑ hb′)
  sameAdmissibleOrdersMeansSameRelation hb hb′ f g =
    admissibilityIsFaithful hb hb′ f , admissibilityIsFaithful hb′ hb g

------------------------------------------------------------------------
-- 4.  One edge each, incomparable families
--
-- `hbA` declares `false → true`; `hbB` declares `true → false`.  Each is
-- admissible for itself (§2) and refuses the other, so neither family
-- contains the other.  Equal edge counts, incomparable strengths.
------------------------------------------------------------------------

hbA : Bool → Bool → Type
hbA false true = Unit
hbA _     _    = ⊥

hbB : Bool → Bool → Type
hbB true false = Unit
hbB _    _     = ⊥

hbBIsNotAdmissibleForHbA : ¬ Respects Bool hbB hbA
hbBIsNotAdmissibleForHbA resp = resp true false tt

hbAIsNotAdmissibleForHbB : ¬ Respects Bool hbA hbB
hbAIsNotAdmissibleForHbB resp = resp false true tt

incomparableFamiliesAtOneEdgeEach :
  ( Respects Bool hbA hbA × (¬ Respects Bool hbB hbA) )
  × ( Respects Bool hbB hbB × (¬ Respects Bool hbA hbB) )
incomparableFamiliesAtOneEdgeEach =
  ( leastAdmissible Bool hbA , hbBIsNotAdmissibleForHbA )
  , ( leastAdmissible Bool hbB , hbAIsNotAdmissibleForHbB )
