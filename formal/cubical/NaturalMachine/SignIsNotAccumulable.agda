{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SignIsNotAccumulable
--
-- `BoundedStateNeedsAGroup` recorded a rhyme and refused to call it a
-- result: a join-multiplicative map is an indicator, never a weight, and
-- the parity barrier is usually described as an inability to carry a
-- ±1-valued multiplicative function.  The rhyme has an exact theorem
-- under it, and it is stronger than the {0,1} statement it came from.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY IDEMPOTENCE IS NOT A SPECIAL FEATURE OF lcm
--
-- Everything in this thread has turned on idempotence, and it has been
-- presented as a property of the join.  It is more general than that, and
-- the general reason needs no arithmetic at all:
--
--     **knowing something twice is knowing it once.**
--
-- Any state law that ACCUMULATES — observations, constraints, standpoints,
-- congruences, installed primes — is idempotent, because combining a
-- datum with itself adds nothing.  lcm is idempotent for this reason and
-- not for a reason about divisibility.  So the theorems below apply to
-- every accumulating machine, the walk being one instance.
--
-- ────────────────────────────────────────────────────────────────────
-- THE THEOREM
--
-- Let ⋆ be accumulative (idempotent) and f multiplicative for it into a
-- commutative ring.  Then f m is an idempotent of the ring, so by
-- `IdempotenceForbidsDescent.idem-invertible-is-unit` applied to the
-- ring's MULTIPLICATIVE monoid:
--
--     accumulative-unit-values-are-one :
--       f m invertible  →  f m ≡ 1r
--
-- No domain hypothesis.  An accumulative law admits no multiplicative
-- function taking ANY unit value other than 1.
--
-- Over ℤ the units are ±1, so:
--
--     sign-is-not-accumulable :  ¬ (f m ≡ −1)
--
-- **Sign is not accumulable.**  Not "hard to accumulate": there is no
-- accumulating law and no multiplicative f taking the value −1, ever.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS AND IS NOT, ABOUT THE PARITY BARRIER
--
-- IS: an exact statement that no weight taking a unit value other than 1
-- can be multiplicative for an accumulating state law.  Over ℤ that rules
-- out every function attaining −1 — λ everywhere, μ off the squares —
-- for every accumulative law at once.  Whatever carries sign, it is not
-- accumulation.
--
-- IS NOT: a theorem about sieves.  The bridge — "a sieve's state law is
-- accumulation of congruence knowledge, and its weights would have to be
-- multiplicative for it" — is a MODELLING CLAIM.  It is stated here and
-- proved nowhere, in this repository or (as far as this file's author
-- established) elsewhere.  Treating the bridge as established would be
-- exactly the error CLAUDE.md's opening paragraph is about, one level up
-- from a fitted constant: a resemblance promoted to a mechanism.
--
-- The honest form of the claim is a conditional, and it is worth having
-- as one: IF a sieve's combination law is accumulative and IF its weight
-- must be multiplicative for that law, THEN by the theorem below the
-- weight is 1 wherever it is a unit, hence cannot be λ.  Both antecedents
-- are open.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.SignIsNotAccumulable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Int using (ℤ ; pos ; negsuc) renaming (_·_ to _·ℤ_)
open import Cubical.Data.Int.Properties using (negsucNotpos)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import Texts.IdempotenceForbidsDescent using (module Mon)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  Accumulation
------------------------------------------------------------------------

-- a law under which combining a datum with itself adds nothing.  This is
-- the abstract content of "knowing twice is knowing once", and it is why
-- lcm, ∪, ∧, and every observation-merge in this corpus is idempotent.
Accumulative : {M : Type ℓ} → (M → M → M) → Type ℓ
Accumulative {M = M} _⋆_ = (m : M) → m ⋆ m ≡ m

------------------------------------------------------------------------
-- 2.  The theorem, over any commutative ring — no domain hypothesis
------------------------------------------------------------------------

module Weight (R : CommRing ℓ) where

  open CommRingStr (snd R)

  A : Type ℓ
  A = fst R

  private
    ·-idr : (x : A) → x · 1r ≡ x
    ·-idr x = solve! R

    ·-assoc' : (x y z : A) → (x · y) · z ≡ x · (y · z)
    ·-assoc' x y z = solve! R

  -- the ring's multiplicative monoid, as a monoid
  module Mul = Mon {M = A} _·_ 1r ·-idr ·-assoc'

  module _ {M : Type ℓ'} (_⋆_ : M → M → M)
           (acc : Accumulative _⋆_)
           (f : M → A)
           (mult : (m n : M) → f (m ⋆ n) ≡ f m · f n)
           where

    -- every value of an accumulative weight is a ring idempotent
    value-is-idempotent : (m : M) → f m · f m ≡ f m
    value-is-idempotent m = sym (mult m m) ∙ cong f (acc m)

    -- THE THEOREM.  A unit value is forced to be 1.
    accumulative-unit-values-are-one :
      (m : M) → Mul.Invertible (f m) → f m ≡ 1r
    accumulative-unit-values-are-one m inv =
      Mul.idem-invertible-is-unit (f m) (value-is-idempotent m) inv

------------------------------------------------------------------------
-- 3.  Over ℤ: sign is not accumulable
------------------------------------------------------------------------

open Weight ℤCommRing renaming (module Mul to ℤMul)
open CommRingStr (snd ℤCommRing) using () renaming (1r to 1ℤ)

-- −1 is a unit: (−1)·(−1) = 1, by computation
minusOne : ℤ
minusOne = negsuc 0

minusOne-invertible : ℤMul.Invertible minusOne
minusOne-invertible = minusOne , refl

minusOne-is-not-one : ¬ (minusOne ≡ 1ℤ)
minusOne-is-not-one = negsucNotpos 0 1

-- THE CONSEQUENCE.  No accumulative law carries a weight that is ever −1.
-- Sign is not accumulable.
sign-is-not-accumulable :
  {M : Type ℓ'} (_⋆_ : M → M → M) → Accumulative _⋆_ →
  (f : M → ℤ) → ((m n : M) → f (m ⋆ n) ≡ f m ·ℤ f n) →
  (m : M) → ¬ (f m ≡ minusOne)
sign-is-not-accumulable _⋆_ acc f mult m h =
  minusOne-is-not-one
    (sym h ∙ accumulative-unit-values-are-one _⋆_ acc f mult m inv)
  where
  inv : ℤMul.Invertible (f m)
  inv = minusOne , cong (_·ℤ minusOne) h

------------------------------------------------------------------------
-- 4.  The sentence, with its conditional intact.
--
-- Accumulation is idempotent because knowing twice is knowing once.  A
-- weight multiplicative for an accumulative law is 1 wherever it is a
-- unit.  Sign is a unit and is not 1.  Therefore no accumulating machine
-- multiplies sign — not the walk, not a sieve, not an observer.
--
-- Whether a sieve IS such a machine is the open half, and it is open.
------------------------------------------------------------------------
