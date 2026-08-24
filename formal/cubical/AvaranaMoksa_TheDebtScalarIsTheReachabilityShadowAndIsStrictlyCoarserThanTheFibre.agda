-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- आवरण-मोक्ष — the fence MoksaPunaragamana owes: its debt SCALAR is
-- only the reachability shadow, and it is strictly coarser than the
-- fibre.  The scalar can read "settled" while curvature remains.
--
-- नय-आवरणम् (landed this hour): each standpoint conflates a pair the
-- other separates.  समाचरण-नित्यम् (same hour): a transitive verdict
-- flattens, and a typed spectrum does not escape it merely by having
-- more coordinates.  MoksaPunaragamana proved a fixed-point theorem for
-- the debt COUNT (a ℕ).  A count is a set-valued observable of the
-- configuration, and — the owner's field-equation message — the real
-- metric is NOT a scalar: it is holonomy, the fibre, the typed boundary
-- spectrum.  So the scalar's fixed point (debt 0) cannot be the
-- stationary condition of the endogenous geometry.  This module proves
-- exactly that gap, with the smallest witness.
--
-- TWO DEBTS, one shadowing the other:
--   • REACHABILITY debt: is every codomain point hit?  = surjectivity.
--     Its "count of missed points" is the ∸-scalar MoksaPunaragamana's
--     saṃvara-step drives to zero.
--   • FIBRE debt: is every fibre a proposition (no retained
--     distinction)? = injectivity/equivalence.  This is the curvature
--     the owner names — what a loop carries, what an observation cannot
--     see into.
--
-- THE WITNESS: Bool → Unit.  Surjective (reachability debt = 0: the
-- scalar reads SETTLED), yet its fibre over tt is Bool — two points,
-- not a proposition (fibre debt > 0: curvature remains).  So
-- scalar-stationary ⇏ fibre-stationary; mokṣa-of-the-count is not
-- mokṣa-of-the-geometry.  The stationary condition of the field is
-- isEquiv (every fibre contractible = सकलादेश = kevala), and the count
-- reaching 0 is its strict, lossy set-level projection.
------------------------------------------------------------------------

module AvaranaMoksa_TheDebtScalarIsTheReachabilityShadowAndIsStrictlyCoarserThanTheFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv; fiber)
open import Cubical.Foundations.Isomorphism using (isoToPath; iso; Iso)
open import Cubical.Data.Bool using (Bool; true; false; true≢false)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Sigma using (Σ; _,_; fst; snd; _×_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁; isPropPropTrunc)

-- the observation whose reachability debt is zero and whose fibre debt
-- is not: the terminal map on Bool.
observe : Bool → Unit
observe _ = tt

-- REACHABILITY DEBT ZERO.  Every point of Unit is hit — surjective,
-- with an explicit preimage.  (The ∸-scalar of "missed points" is 0:
-- MoksaPunaragamana's saṃvara-step is already at its fixed point here.)
reachability-settled : (u : Unit) → Σ[ b ∈ Bool ] (observe b ≡ u)
reachability-settled tt = true , refl

-- FIBRE DEBT POSITIVE.  The fibre over tt has two distinct points —
-- (true, refl) and (false, refl) — so it is NOT a proposition.  This is
-- the retained distinction the scalar cannot see: curvature.
fibre-not-prop : ¬ ((x y : fiber observe tt) → x ≡ y)
fibre-not-prop pr = true≢false (cong fst (pr (true , refl) (false , refl)))

-- THE GAP, stated once.  Reachability-settled AND fibre-unsettled hold
-- of the SAME map.  So the debt scalar reaching zero (reachability) is
-- consistent with the geometry not being stationary (fibre).  The two
-- standpoints separate exactly here.
scalar-does-not-imply-geometry :
    (Σ[ f ∈ ((u : Unit) → Σ[ b ∈ Bool ] (observe b ≡ u)) ] Unit)   -- reachability settled …
  × (¬ ((x y : fiber observe tt) → x ≡ y))                          -- … yet fibre not settled
scalar-does-not-imply-geometry = (reachability-settled , tt) , fibre-not-prop

-- THE STATIONARY CONDITION, named correctly.  The geometry is
-- stationary exactly when the observation is an equivalence — every
-- fibre contractible, सकलादेश, kevala — which STRICTLY implies both
-- debts vanish, while neither debt alone implies it.  (isEquiv is the
-- field's true vacuum; the count is its shadow.)
stationary : (A B : Type) (f : A → B) → Type
stationary A B f = isEquiv f
