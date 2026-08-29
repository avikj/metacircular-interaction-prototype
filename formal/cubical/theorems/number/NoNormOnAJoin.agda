{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NoNormOnAJoin
--
-- `DescentIsNotInversion` ends by naming the sharpest open form of the
-- question three modules had been circling:
--
--     does the walk admit a norm?
--
-- It does not, and the proof is the same three words as every other
-- answer in this thread — **idempotence forbids it** — but the
-- conclusion is not the one the question expected, and the last section
-- says why.
--
-- ────────────────────────────────────────────────────────────────────
-- THE THEOREM
--
-- A norm, in the sense descent needs, is a map N from states to a ring
-- with N(x · y) = N x · N y.  Suppose the state law is a join, so every
-- state is idempotent.  Then
--
--     N x · N x  =  N (x ⊔ x)  =  N x
--
-- so **every value of N is an idempotent of the ring**.  In a ring with
-- no zero divisors the only idempotents are 0 and 1.  Therefore:
--
--     a multiplicative norm on a join monoid takes at most TWO VALUES.
--
-- It separates nothing.  `three-collide` makes that exact: among any
-- three states, two have the same norm, always.  Over an infinite state
-- space — and the walk's is infinite — such a function is not a norm in
-- any useful sense; it is a predicate.
--
-- So there is no descent to be had for the walk's step law, at any state,
-- for any norm, over any domain.  The question is closed, negatively, and
-- it did not need a single measurement.
--
-- ────────────────────────────────────────────────────────────────────
-- THE PART THAT INVERTS THE QUESTION
--
-- The walk's state space is NOT normless.  `SumProductTorus.val` is a
-- perfectly good multiplicative norm:
--
--     val (u ⊕ v) ≡ val u · val v                    (`val-⊕`, checked)
--
-- Derivations carry TWO operations — ⊕ (which is multiplication of the
-- numbers) and ⊔ (which is lcm) — cohering tropically by `⊔-⊕-distrib`.
-- `val` is multiplicative for ⊕.  The theorem above says no map is
-- multiplicative for ⊔ except a two-valued one.
--
-- And the walk **steps by ⊔**.
--
-- That is the finding, and it is sharper than "the walk has no norm":
--
--     the walk's state space has a norm; the walk's step law is the one
--     operation of the two for which that norm does not exist.  The
--     machine is running on the wrong one of its own operations.
--
-- Which is not a defect of the walk's rule — by `Apavada` no rule change
-- reaches it — and not a fact about lcm's difficulty.  It is a choice of
-- semigroup, made implicitly, whose consequence is the loss of every
-- descent mechanism at once.
--
-- SYĀT — THE CLAIM, EXACTLY.  That a ⊕-stepping machine would be better, or
-- terminate, or be lossless.  ⊕ multiplies capacities where ⊔ joins them,
-- so its states grow faster; whether the norm it keeps pays for that is
-- open and is not touched here.  Only the dichotomy is proved.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NoNormOnAJoin where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

open import SumProductTorus using (Exp ; zeroE ; _⊔_)
open import IdempotenceForbidsDescent using (⊔-idem)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  In a domain, the only idempotents are 0 and 1
------------------------------------------------------------------------

module NoNorm (R : CommRing ℓ) where

  open CommRingStr (snd R)

  A : Type ℓ
  A = fst R

  NoZeroDivisors : Type ℓ
  NoZeroDivisors = (x y : A) → x · y ≡ 0r → (x ≡ 0r) ⊎ (y ≡ 0r)

  private
    factor : (x : A) → x · (x - 1r) ≡ (x · x) - x
    factor x = solve! R

    self-sub : (x : A) → x - x ≡ 0r
    self-sub x = solve! R

    shift : (x : A) → (x - 1r) + 1r ≡ x
    shift x = solve! R

    zero-plus : (x : A) → 0r + x ≡ x
    zero-plus x = solve! R

  from-difference : (x : A) → x - 1r ≡ 0r → x ≡ 1r
  from-difference x h =
    sym (shift x) ∙ cong (_+ 1r) h ∙ zero-plus 1r

  module _ (nzd : NoZeroDivisors) where

    idem-in-domain : (x : A) → x · x ≡ x → (x ≡ 0r) ⊎ (x ≡ 1r)
    idem-in-domain x h with nzd x (x - 1r) (factor x ∙ cong (_- x) h ∙ self-sub x)
    ... | inl p = inl p
    ... | inr q = inr (from-difference x q)

    ------------------------------------------------------------------
    -- 2.  THE THEOREM.  A multiplicative norm on a join takes ≤ 2 values
    ------------------------------------------------------------------

    module Norm {M : Type ℓ'} (_⋆_ : M → M → M)
                (idem : (m : M) → m ⋆ m ≡ m)
                (N : M → A)
                (mult : (m n : M) → N (m ⋆ n) ≡ N m · N n)
                where

      -- the value of the norm is an idempotent of the ring
      norm-idempotent : (m : M) → N m · N m ≡ N m
      norm-idempotent m = sym (mult m m) ∙ cong N (idem m)

      two-valued : (m : M) → (N m ≡ 0r) ⊎ (N m ≡ 1r)
      two-valued m = idem-in-domain (N m) (norm-idempotent m)

      -- and therefore it separates nothing: among any three states, two
      -- carry the same norm.
      three-collide : (x y z : M)
                    → (N x ≡ N y) ⊎ ((N x ≡ N z) ⊎ (N y ≡ N z))
      three-collide x y z with two-valued x | two-valued y | two-valued z
      ... | inl px | inl py | _      = inl (px ∙ sym py)
      ... | inr px | inr py | _      = inl (px ∙ sym py)
      ... | inl px | inr py | inl pz = inr (inl (px ∙ sym pz))
      ... | inl px | inr py | inr pz = inr (inr (py ∙ sym pz))
      ... | inr px | inl py | inl pz = inr (inr (py ∙ sym pz))
      ... | inr px | inl py | inr pz = inr (inl (px ∙ sym pz))

------------------------------------------------------------------------
-- 3.  ℤ is a domain, so the walk's states admit no separating norm
------------------------------------------------------------------------

open import Cubical.Data.Int using (ℤ ; pos ; _·_)
open import Cubical.Data.Int.Properties using (isIntegralℤ ; discreteℤ)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

open NoNorm ℤCommRing using (NoZeroDivisors) renaming (module Norm to ℤNorm)

ℤ-nzd : NoZeroDivisors
ℤ-nzd x y p with discreteℤ x (pos 0)
... | yes q = inl q
... | no  q = inr (isIntegralℤ x y p q)

-- THE WALK.  Fix any basis.  For any map N from the walk's states to ℤ
-- that is multiplicative for the walk's OWN step law, every state's norm
-- is 0 or 1, and no three states are separated.
module WalkNorm (bs : List ℕ)
                (N : Exp bs → ℤ)
                (mult : (u v : Exp bs) → N (u ⊔ v) ≡ N u · N v)
              = ℤNorm ℤ-nzd {M = Exp bs} _⊔_ (⊔-idem bs) N mult

walk-norm-two-valued :
  (bs : List ℕ) (N : Exp bs → ℤ)
  (mult : (u v : Exp bs) → N (u ⊔ v) ≡ N u · N v)
  (u : Exp bs) → (N u ≡ pos 0) ⊎ (N u ≡ pos 1)
walk-norm-two-valued = WalkNorm.two-valued

walk-norm-separates-nothing :
  (bs : List ℕ) (N : Exp bs → ℤ)
  (mult : (u v : Exp bs) → N (u ⊔ v) ≡ N u · N v)
  (x y z : Exp bs) → (N x ≡ N y) ⊎ ((N x ≡ N z) ⊎ (N y ≡ N z))
walk-norm-separates-nothing = WalkNorm.three-collide

------------------------------------------------------------------------
-- 4.  For contrast, in one line: the OTHER operation has a norm.
--
-- `SumProductTorus.val-⊕ : val (u ⊕ v) ≡ val u · val v` is exactly the
-- multiplicativity this module proves impossible for ⊔.  Same state
-- space, same map, different semigroup, opposite answer.  The walk steps
-- by ⊔.
------------------------------------------------------------------------
