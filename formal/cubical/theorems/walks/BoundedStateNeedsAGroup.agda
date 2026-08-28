{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BoundedStateNeedsAGroup
--
-- What "descent" is, operationally, for a machine — and why the previous
-- five modules are about the walk's SIZE and not only about its algebra.
--
-- Descent, in the abstract, is the ability to come back down.  For a
-- machine the concrete form of that ability is FORGETTING: removing from
-- the state something previously installed, so the state can be a window
-- rather than a history.  A machine that can forget runs in bounded
-- state; a machine that cannot must carry everything it has ever seen,
-- and its capacity is the product of everything it has ever seen.  That
-- is the walk, and cap(k) = e^ψ(k) is the bill.
--
-- This module makes forgetting a property and locates it exactly.
--
--   ⊞ over ℤ-exponents:  `window-slide` — installing g and then removing
--     it returns the state unchanged.  A sliding window is available, so
--     the state need never grow past the window's content.
--
--   ⊕ over ℕ-exponents:  `cone-cannot-forget` — if installing g can be
--     undone by ANY subsequent step, then g was the empty install.  There
--     is nothing to forget with.  Positivity, again.
--
--   ⊔ over ℕ-exponents:  `join-cannot-forget` — same conclusion by the
--     other route, idempotence.  A join can only ever add.
--
-- So all three walk-available laws fail to forget, for the two distinct
-- reasons this thread has been separating, and only the group succeeds.
--
--     among the three laws the walk’s own state space carries, exactly
--     one can forget, and it is the group.
--
-- Stated as a general principle — "bounded state requires a group law" —
-- that is a SLOGAN, not a theorem, and this module does not prove it.
-- What is proved is the three instances, with their two distinct reasons.
-- The slogan is what they are evidence for.
--
-- With them the arc that began at `SuccessorIsNotTropical` is closed for
-- the walk specifically: its unbounded state is forced, the force is
-- algebraic, and the only exit among its own operations is ratios.
--
-- SYĀT — THE CLAIM, EXACTLY.  No bound on any particular machine, no rate, and
-- no statement that a group-stepping machine over ratios is small — only
-- that forgetting is available there and provably nowhere else among the
-- laws the walk's own state space carries.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module BoundedStateNeedsAGroup where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-assoc ; +-zero ; inj-m+ ; injSuc ; snotz)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import SumProductTorus using (Exp ; zeroE ; _⊕_ ; _⊔_ ; _⊔ℕ_ ; ⊔ℕ-comm)
open import DescentCostsTheIntegers
  using (ExpZ ; zeroZ ; _⊞_ ; negE ; +≡0→≡0)

------------------------------------------------------------------------
-- 1.  The group forgets: install then remove is the identity
------------------------------------------------------------------------

open CommRingStr (snd ℤCommRing) using ()
  renaming (_+_ to _+ℤ_ ; -_ to -ℤ_ ; 0r to 0ℤ)

private
  cancelℤ : (x g : ℤCommRing .fst) → (x +ℤ g) +ℤ (-ℤ g) ≡ x
  cancelℤ x g = solve! ℤCommRing

window-slide : (bs : List ℕ) (u g : ExpZ bs)
             → ((u ⊞ g) ⊞ negE bs g) ≡ u
window-slide []       _        _        = refl
window-slide (b ∷ bs) (x , xs) (y , ys) i =
  cancelℤ x y i , window-slide bs xs ys i

------------------------------------------------------------------------
-- 2.  The ℕ-cone cannot forget: positivity
--
-- If some later step undoes an install, the install was empty.
------------------------------------------------------------------------

private
  cancelℕ : (x y z : ℕ) → (x + y) + z ≡ x → y ≡ 0
  cancelℕ x y z p =
    +≡0→≡0 y z (inj-m+ (+-assoc x y z ∙ p ∙ sym (+-zero x)))

cone-cannot-forget :
  (bs : List ℕ) (u g v : Exp bs) → ((u ⊕ g) ⊕ v) ≡ u → g ≡ zeroE bs
cone-cannot-forget []       _        _        _        _ = refl
cone-cannot-forget (b ∷ bs) (x , xs) (y , ys) (z , zs) p i =
    cancelℕ x y z (cong fst p) i
  , cone-cannot-forget bs xs ys zs (cong snd p) i

------------------------------------------------------------------------
-- 3.  The join cannot forget: idempotence
--
-- Same conclusion, unrelated proof.  A join only ever adds, so if a later
-- join undoes an install then the install contributed nothing.
------------------------------------------------------------------------

private
  suc⊔-nonzero : (y z : ℕ) → ¬ (suc y ⊔ℕ z ≡ 0)
  suc⊔-nonzero y zero    p = snotz p
  suc⊔-nonzero y (suc z) p = snotz p

  cancel⊔ℕ : (x y z : ℕ) → (x ⊔ℕ y) ⊔ℕ z ≡ x → y ⊔ℕ x ≡ x
  cancel⊔ℕ zero    zero    z p = refl
  cancel⊔ℕ zero    (suc y) z p = Empty.rec (suc⊔-nonzero y z p)
  cancel⊔ℕ (suc x) zero    z p = refl
  cancel⊔ℕ (suc x) (suc y) zero    p =
    cong suc (⊔ℕ-comm y x ∙ injSuc p)
  cancel⊔ℕ (suc x) (suc y) (suc z) p =
    cong suc (cancel⊔ℕ x y z (injSuc p))

-- the install was already contained in the state: joining it back changes
-- nothing, which is what "there was nothing to forget" means for a join.
join-cannot-forget :
  (bs : List ℕ) (u g v : Exp bs) → ((u ⊔ g) ⊔ v) ≡ u → (g ⊔ u) ≡ u
join-cannot-forget []       _        _        _        _ = refl
join-cannot-forget (b ∷ bs) (x , xs) (y , ys) (z , zs) p i =
    cancel⊔ℕ x y z (cong fst p) i
  , join-cannot-forget bs xs ys zs (cong snd p) i

------------------------------------------------------------------------
-- 4.  The sentence.
--
--   forgetting is the operational form of descent, and among the three
--   laws the walk’s own state space carries, exactly one has it — the
--   one whose states are ratios.
--
-- The general principle this suggests, that bounded state requires a
-- group law, is not proved here and is not asserted.  Three instances and
-- two independent obstructions are what the file contains.
------------------------------------------------------------------------
