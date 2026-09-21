{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡∞‡-‡Æ‡ã‡ï‡‡ ‚î the fence MoksaLosslessReturn owes: its debt SCALAR is
-- only the reachability shadow, and it is strictly coarser than the
-- fibre.  The scalar can read "settled" while curvature remains.
--
-- ‡®‡Ø-‡‡µ‡∞‡‡Æ‡: each standpoint conflates a pair the
-- other separates.  ‡‡Æ‡æ‡‡∞‡-‡®‡ø‡‡‡Ø‡Æ‡: a transitive verdict
-- flattens, and a typed spectrum does not escape it merely by having
-- more coordinates.  MoksaLosslessReturn proved a fixed-point theorem for
-- the debt COUNT (a ‚ï).  A count is a set-valued observable of the
-- configuration, and the real
-- metric is NOT a scalar: it is holonomy, the fibre, the typed boundary
-- spectrum.  So the scalar's fixed point (debt 0) cannot be the
-- stationary condition of the endogenous geometry.  This module proves
-- exactly that gap, with the smallest witness.
--
-- TWO DEBTS, one shadowing the other:
--   ‚ REACHABILITY debt: is every codomain point hit?  = surjectivity.
--     Its "count of missed points" is the ‚à-scalar MoksaLosslessReturn's
--     savara-step drives to zero.
--   ‚ FIBRE debt: is every fibre a proposition (no retained
--     distinction)? = injectivity/equivalence.  This is the curvature
--     ‚î what a loop carries, what an observation cannot
--     see into.
--
-- THE WITNESS: Bool ‚í Unit.  Surjective (reachability debt = 0: the
-- scalar reads SETTLED), yet its fibre over tt is Bool ‚î two points,
-- not a proposition (fibre debt > 0: curvature remains).  So
-- scalar-stationary ‚ fibre-stationary; moka-of-the-count is not
-- moka-of-the-geometry.  The stationary condition of the field is
-- isEquiv (every fibre contractible = ‡‡ï‡≤‡æ‡¶‡‡ = kevala), and the count
-- reaching 0 is its strict, lossy set-level projection.
------------------------------------------------------------------------

module AvaranaMoksa_TheDebtScalarIsTheReachabilityShadowAndIsStrictlyCoarserThanTheFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv; fiber)
open import Cubical.Foundations.Isomorphism using (isoToPath; iso; Iso)
open import Cubical.Data.Bool using (Bool; true; false; true‚â¢false)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Sigma using (Œ£; _,_; fst; snd; _√ó_)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.PropositionalTruncation using (‚à£_‚à£‚ÇÅ; isPropPropTrunc)

-- the observation whose reachability debt is zero and whose fibre debt
-- is not: the terminal map on Bool.
observe : Bool ‚Üí Unit
observe _ = tt

-- REACHABILITY DEBT ZERO.  Every point of Unit is hit ‚î surjective,
-- with an explicit preimage.  (The ‚à-scalar of "missed points" is 0:
-- MoksaLosslessReturn's savara-step is already at its fixed point here.)
reachability-settled : (u : Unit) ‚Üí Œ£[ b ‚àà Bool ] (observe b ‚â° u)
reachability-settled tt = true , refl

-- FIBRE DEBT POSITIVE.  The fibre over tt has two distinct points ‚î
-- (true, refl) and (false, refl) ‚î so it is NOT a proposition.  This is
-- the retained distinction the scalar cannot see: curvature.
fibre-not-prop : ¬¨ ((x y : fiber observe tt) ‚Üí x ‚â° y)
fibre-not-prop pr = true‚â¢false (cong fst (pr (true , refl) (false , refl)))

-- THE GAP, stated once.  Reachability-settled AND fibre-unsettled hold
-- of the SAME map.  So the debt scalar reaching zero (reachability) is
-- consistent with the geometry not being stationary (fibre).  The two
-- standpoints separate exactly here.
scalar-does-not-imply-geometry :
    (Œ£[ f ‚àà ((u : Unit) ‚Üí Œ£[ b ‚àà Bool ] (observe b ‚â° u)) ] Unit)   -- reachability settled ‚Ä¶
  √ó (¬¨ ((x y : fiber observe tt) ‚Üí x ‚â° y))                          -- ‚Ä¶ yet fibre not settled
scalar-does-not-imply-geometry = (reachability-settled , tt) , fibre-not-prop

-- THE STATIONARY CONDITION, named correctly.  The geometry is
-- stationary exactly when the observation is an equivalence ‚î every
-- fibre contractible, ‡‡ï‡≤‡æ‡¶‡‡, kevala ‚î which STRICTLY implies both
-- debts vanish, while neither debt alone implies it.  (isEquiv is the
-- field's true vacuum; the count is its shadow.)
stationary : (A B : Type) (f : A ‚Üí B) ‚Üí Type
stationary A B f = isEquiv f
