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
-- answer in this line of modules â” **idempotence forbids it** â” but the
-- conclusion is not the one the question expected, and the last section
-- says why.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE THEOREM
--
-- A norm, in the sense descent needs, is a map N from states to a ring
-- with N(x Â y) = N x Â N y.  Suppose the state law is a join, so every
-- state is idempotent.  Then
--
--     N x Â N x  =  N (x âŠ” x)  =  N x
--
-- so **every value of N is an idempotent of the ring**.  In a ring with
-- no zero divisors the only idempotents are 0 and 1.  Therefore:
--
--     a multiplicative norm on a join monoid takes at most TWO VALUES.
--
-- It separates nothing.  `three-collide` makes that exact: among any
-- three states, two have the same norm, always.  Over an infinite state
-- space â” and the walk's is infinite â” such a function is not a norm in
-- any useful sense; it is a predicate.
--
-- So there is no descent to be had for the walk's step law, at any state,
-- for any norm, over any domain.  The question is closed, negatively, and
-- it did not need a single measurement.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE PART THAT INVERTS THE QUESTION
--
-- The walk's state space is NOT normless.  `SumProductTorus.val` is a
-- perfectly good multiplicative norm:
--
--     val (u âŠ• v) â‰¡ val u Â val v                    (`val-âŠ•`, checked)
--
-- Derivations carry TWO operations â” âŠ• (which is multiplication of the
-- numbers) and âŠ” (which is lcm) â” cohering tropically by `âŠ”-âŠ•-distrib`.
-- `val` is multiplicative for âŠ•.  The theorem above says no map is
-- multiplicative for âŠ” except a two-valued one.
--
-- And the walk **steps by âŠ”**.
--
-- That is the finding, and it is sharper than "the walk has no norm":
--
--     the walk's state space has a norm; the walk's step law is the one
--     operation of the two for which that norm does not exist.  The
--     machine is running on the wrong one of its own operations.
--
-- Which is not a defect of the walk's rule â” by `Apavada` no rule change
-- reaches it â” and not a fact about lcm's difficulty.  It is a choice of
-- semigroup, made implicitly, whose consequence is the loss of every
-- descent mechanism at once.
------------------------------------------------------------------------

module NoNormOnAJoin where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Relation.Nullary using (Â¬_ ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

open import SumProductTorus using (Exp ; zeroE ; _âŠ”_)
open import IdempotenceForbidsDescent using (âŠ”-idem)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  In a domain, the only idempotents are 0 and 1
------------------------------------------------------------------------

module NoNorm (R : CommRing â„“) where

  open CommRingStr (snd R)

  A : Type â„“
  A = fst R

  NoZeroDivisors : Type â„“
  NoZeroDivisors = (x y : A) â†’ x Â· y â‰¡ 0r â†’ (x â‰¡ 0r) âŠŽ (y â‰¡ 0r)

  private
    factor : (x : A) â†’ x Â· (x - 1r) â‰¡ (x Â· x) - x
    factor x = solve! R

    self-sub : (x : A) â†’ x - x â‰¡ 0r
    self-sub x = solve! R

    shift : (x : A) â†’ (x - 1r) + 1r â‰¡ x
    shift x = solve! R

    zero-plus : (x : A) â†’ 0r + x â‰¡ x
    zero-plus x = solve! R

  from-difference : (x : A) â†’ x - 1r â‰¡ 0r â†’ x â‰¡ 1r
  from-difference x h =
    sym (shift x) âˆ™ cong (_+ 1r) h âˆ™ zero-plus 1r

  module _ (nzd : NoZeroDivisors) where

    idem-in-domain : (x : A) â†’ x Â· x â‰¡ x â†’ (x â‰¡ 0r) âŠŽ (x â‰¡ 1r)
    idem-in-domain x h with nzd x (x - 1r) (factor x âˆ™ cong (_- x) h âˆ™ self-sub x)
    ... | inl p = inl p
    ... | inr q = inr (from-difference x q)

    ------------------------------------------------------------------
    -- 2.  THE THEOREM.  A multiplicative norm on a join takes â‰ 2 values
    ------------------------------------------------------------------

    module Norm {M : Type â„“'} (_â‹†_ : M â†’ M â†’ M)
                (idem : (m : M) â†’ m â‹† m â‰¡ m)
                (N : M â†’ A)
                (mult : (m n : M) â†’ N (m â‹† n) â‰¡ N m Â· N n)
                where

      -- the value of the norm is an idempotent of the ring
      norm-idempotent : (m : M) â†’ N m Â· N m â‰¡ N m
      norm-idempotent m = sym (mult m m) âˆ™ cong N (idem m)

      two-valued : (m : M) â†’ (N m â‰¡ 0r) âŠŽ (N m â‰¡ 1r)
      two-valued m = idem-in-domain (N m) (norm-idempotent m)

      -- and therefore it separates nothing: among any three states, two
      -- carry the same norm.
      three-collide : (x y z : M)
                    â†’ (N x â‰¡ N y) âŠŽ ((N x â‰¡ N z) âŠŽ (N y â‰¡ N z))
      three-collide x y z with two-valued x | two-valued y | two-valued z
      ... | inl px | inl py | _      = inl (px âˆ™ sym py)
      ... | inr px | inr py | _      = inl (px âˆ™ sym py)
      ... | inl px | inr py | inl pz = inr (inl (px âˆ™ sym pz))
      ... | inl px | inr py | inr pz = inr (inr (py âˆ™ sym pz))
      ... | inr px | inl py | inl pz = inr (inr (py âˆ™ sym pz))
      ... | inr px | inl py | inr pz = inr (inl (px âˆ™ sym pz))

------------------------------------------------------------------------
-- 3.  â is a domain, so the walk's states admit no separating norm
------------------------------------------------------------------------

open import Cubical.Data.Int using (â„¤ ; pos ; _Â·_)
open import Cubical.Data.Int.Properties using (isIntegralâ„¤ ; discreteâ„¤)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open NoNorm â„¤CommRing using (NoZeroDivisors) renaming (module Norm to â„¤Norm)

â„¤-nzd : NoZeroDivisors
â„¤-nzd x y p with discreteâ„¤ x (pos 0)
... | yes q = inl q
... | no  q = inr (isIntegralâ„¤ x y p q)

-- THE WALK.  Fix any basis.  For any map N from the walk's states to â
-- that is multiplicative for the walk's OWN step law, every state's norm
-- is 0 or 1, and no three states are separated.
module WalkNorm (bs : List â„•)
                (N : Exp bs â†’ â„¤)
                (mult : (u v : Exp bs) â†’ N (u âŠ” v) â‰¡ N u Â· N v)
              = â„¤Norm â„¤-nzd {M = Exp bs} _âŠ”_ (âŠ”-idem bs) N mult

walk-norm-two-valued :
  (bs : List â„•) (N : Exp bs â†’ â„¤)
  (mult : (u v : Exp bs) â†’ N (u âŠ” v) â‰¡ N u Â· N v)
  (u : Exp bs) â†’ (N u â‰¡ pos 0) âŠŽ (N u â‰¡ pos 1)
walk-norm-two-valued = WalkNorm.two-valued

walk-norm-separates-nothing :
  (bs : List â„•) (N : Exp bs â†’ â„¤)
  (mult : (u v : Exp bs) â†’ N (u âŠ” v) â‰¡ N u Â· N v)
  (x y z : Exp bs) â†’ (N x â‰¡ N y) âŠŽ ((N x â‰¡ N z) âŠŽ (N y â‰¡ N z))
walk-norm-separates-nothing = WalkNorm.three-collide

------------------------------------------------------------------------
-- 4.  For contrast, in one line: the OTHER operation has a norm.
--
-- `SumProductTorus.val-âŠ• : val (u âŠ• v) â‰¡ val u Â val v` is exactly the
-- multiplicativity this module proves impossible for âŠ”.  Same state
-- space, same map, different semigroup, opposite answer.  The walk steps
-- by âŠ”.
------------------------------------------------------------------------
