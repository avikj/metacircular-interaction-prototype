{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SignIsNotAccumulable
--
-- `BoundedStateNeedsAGroup` recorded a rhyme and refused to call it a
-- result: a join-multiplicative map is an indicator, never a weight, and
-- the parity barrier is usually described as an inability to carry a
-- Â1-valued multiplicative function.  The rhyme has an exact theorem
-- under it, and it is stronger than the {0,1} statement it came from.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY IDEMPOTENCE IS NOT A SPECIAL FEATURE OF lcm
--
-- Everything in this thread has turned on idempotence, and it has been
-- presented as a property of the join.  It is more general than that, and
-- the general reason needs no arithmetic at all:
--
--     **knowing something twice is knowing it once.**
--
-- Any state law that ACCUMULATES â” observations, constraints, standpoints,
-- congruences, installed primes â” is idempotent, because combining a
-- datum with itself adds nothing.  lcm is idempotent for this reason and
-- not for a reason about divisibility.  So the theorems below apply to
-- every accumulating machine, the walk being one instance.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE THEOREM
--
-- Let â‹ be accumulative (idempotent) and f multiplicative for it into a
-- commutative ring.  Then f m is an idempotent of the ring, so by
-- `IdempotenceForbidsDescent.idem-invertible-is-unit` applied to the
-- ring's MULTIPLICATIVE monoid:
--
--     accumulative-unit-values-are-one :
--       f m invertible  â’  f m â‰¡ 1r
--
-- No domain hypothesis.  An accumulative law admits no multiplicative
-- function taking ANY unit value other than 1.
--
-- Over â the units are Â1, so:
--
--     sign-is-not-accumulable :  Â (f m â‰¡ âˆ’1)
--
-- **Sign is not accumulable.**  Not "hard to accumulate": there is no
-- accumulating law and no multiplicative f taking the value âˆ’1, ever.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS IS AND IS NOT, ABOUT THE PARITY BARRIER
--
-- IS: an exact statement that no weight taking a unit value other than 1
-- can be multiplicative for an accumulating state law.  Over â that rules
-- out every function attaining âˆ’1 â” Î» everywhere, Î¼ off the squares â”
-- for every accumulative law at once.  Whatever carries sign, it is not
-- accumulation.
--
-- IS NOT: a theorem about sieves.  The bridge â” "a sieve's state law is
-- accumulation of congruence knowledge, and its weights would have to be
-- multiplicative for it" â” is a MODELLING CLAIM.  It is stated here and
-- proved nowhere, in this repository or (as far as this file's author
-- established) elsewhere.  Treating the bridge as established would be
-- exactly the error CLAUDE.md's opening paragraph is about, one level up
-- from a fitted constant: a resemblance promoted to a mechanism.
--
-- The honest form of the claim is a conditional, and it is worth having
-- as one: IF a sieve's combination law is accumulative and IF its weight
-- must be multiplicative for that law, THEN by the theorem below the
-- weight is 1 wherever it is a unit, hence cannot be Î».  Both antecedents
-- are open.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module SignIsNotAccumulable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc) renaming (_Â·_ to _Â·â„¤_)
open import Cubical.Data.Int.Properties using (negsucNotpos)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import IdempotenceForbidsDescent using (module Mon)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  Accumulation
------------------------------------------------------------------------

-- a law under which combining a datum with itself adds nothing.  This is
-- the abstract content of "knowing twice is knowing once", and it is why
-- lcm, âˆ, âˆ§, and every observation-merge in this corpus is idempotent.
Accumulative : {M : Type â„“} â†’ (M â†’ M â†’ M) â†’ Type â„“
Accumulative {M = M} _â‹†_ = (m : M) â†’ m â‹† m â‰¡ m

------------------------------------------------------------------------
-- 2.  The theorem, over any commutative ring â” no domain hypothesis
------------------------------------------------------------------------

module Weight (R : CommRing â„“) where

  open CommRingStr (snd R)

  A : Type â„“
  A = fst R

  private
    Â·-idr : (x : A) â†’ x Â· 1r â‰¡ x
    Â·-idr x = solve! R

    Â·-assoc' : (x y z : A) â†’ (x Â· y) Â· z â‰¡ x Â· (y Â· z)
    Â·-assoc' x y z = solve! R

  -- the ring's multiplicative monoid, as a monoid
  module Mul = Mon {M = A} _Â·_ 1r Â·-idr Â·-assoc'

  module _ {M : Type â„“'} (_â‹†_ : M â†’ M â†’ M)
           (acc : Accumulative _â‹†_)
           (f : M â†’ A)
           (mult : (m n : M) â†’ f (m â‹† n) â‰¡ f m Â· f n)
           where

    -- every value of an accumulative weight is a ring idempotent
    value-is-idempotent : (m : M) â†’ f m Â· f m â‰¡ f m
    value-is-idempotent m = sym (mult m m) âˆ™ cong f (acc m)

    -- THE THEOREM.  A unit value is forced to be 1.
    accumulative-unit-values-are-one :
      (m : M) â†’ Mul.Invertible (f m) â†’ f m â‰¡ 1r
    accumulative-unit-values-are-one m inv =
      Mul.idem-invertible-is-unit (f m) (value-is-idempotent m) inv

------------------------------------------------------------------------
-- 3.  Over â: sign is not accumulable
------------------------------------------------------------------------

open Weight â„¤CommRing renaming (module Mul to â„¤Mul)
open CommRingStr (snd â„¤CommRing) using () renaming (1r to 1â„¤)

-- âˆ’1 is a unit: (âˆ’1)Â(âˆ’1) = 1, by computation
minusOne : â„¤
minusOne = negsuc 0

minusOne-invertible : â„¤Mul.Invertible minusOne
minusOne-invertible = minusOne , refl

minusOne-is-not-one : Â¬ (minusOne â‰¡ 1â„¤)
minusOne-is-not-one = negsucNotpos 0 1

-- THE CONSEQUENCE.  No accumulative law carries a weight that is ever âˆ’1.
-- Sign is not accumulable.
sign-is-not-accumulable :
  {M : Type â„“'} (_â‹†_ : M â†’ M â†’ M) â†’ Accumulative _â‹†_ â†’
  (f : M â†’ â„¤) â†’ ((m n : M) â†’ f (m â‹† n) â‰¡ f m Â·â„¤ f n) â†’
  (m : M) â†’ Â¬ (f m â‰¡ minusOne)
sign-is-not-accumulable _â‹†_ acc f mult m h =
  minusOne-is-not-one
    (sym h âˆ™ accumulative-unit-values-are-one _â‹†_ acc f mult m inv)
  where
  inv : â„¤Mul.Invertible (f m)
  inv = minusOne , cong (_Â·â„¤ minusOne) h

------------------------------------------------------------------------
-- 4.  The sentence, with its conditional intact.
--
-- Accumulation is idempotent because knowing twice is knowing once.  A
-- weight multiplicative for an accumulative law is 1 wherever it is a
-- unit.  Sign is a unit and is not 1.  Therefore no accumulating machine
-- multiplies sign â” not the walk, not a sieve, not an observer.
--
-- Whether a sieve IS such a machine is the open half, and it is open.
------------------------------------------------------------------------
