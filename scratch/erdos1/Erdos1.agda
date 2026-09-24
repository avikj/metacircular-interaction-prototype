{-# OPTIONS --safe #-}

module Erdos1 where

open import Agda.Builtin.Nat using (Nat; zero; suc; _+_; _*_; _<_)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.List using (List; []; _∷_)

data ⊥ : Set where
¬_ : Set → Set
¬ A = A → ⊥

data Bit : Set where O I : Bit

bit : Bit → Nat
bit O = 0
bit I = 1

sum : List Nat → List Bit → Nat
sum [] bs = 0
sum (a ∷ as) [] = 0
sum (a ∷ as) (b ∷ bs) = bit b * a + sum as bs

-- d is blocked by A exactly when d is a difference of two subset sums of A.
record Blocked (as : List Nat) (d : Nat) : Set where
  constructor blocked
  field
    lhs rhs : List Bit
    equation : d + sum as rhs ≡ sum as lhs
open Blocked public

Valid : List Nat → Nat → Set
Valid as x = ¬ Blocked as x

-- The induction hypothesis in its literal contrapositive form:
-- T is a lower bound on a valid addition iff every x<T is blocked.
Coverage : List Nat → Nat → Set
Coverage as T = (x : Nat) → x < T → Blocked as x

coverage-lower-bound :
  {as : List Nat} {T x : Nat} →
  Coverage as T → Valid as x → x < T → ⊥
coverage-lower-bound cov valid x<T = valid (cov x x<T)

-- Existing collision witnesses survive adding a generator.
keep :
  {as : List Nat} {K d : Nat} →
  Blocked as d → Blocked (K ∷ as) d
keep (blocked l r p) = blocked (O ∷ l) (O ∷ r) p

+-assoc : (a b c : Nat) → (a + b) + c ≡ a + (b + c)
+-assoc zero b c = refl
+-assoc (suc a) b c rewrite +-assoc a b c = refl

-- And the entire blocked prefix is copied starting at K.
copy :
  {as : List Nat} {K d : Nat} →
  Blocked as d → Blocked (K ∷ as) (K + d)
copy {K = K} {d = d} (blocked l r p) =
  blocked (I ∷ l) (O ∷ r) q
  where
  q : (K + d) + sum as r ≡ K + sum as l
  q rewrite +-assoc K d (sum as r) | p = refl

-- Arithmetic witnesses are carried explicitly rather than hidden behind subtraction.
record Offset (K x : Nat) : Set where
  constructor offset
  field
    d : Nat
    equation : K + d ≡ x
open Offset public

-- If x is K+d and d<T, copied coverage blocks x.
copy-blocks-offset :
  {as : List Nat} {K T x : Nat} →
  Coverage as T →
  (o : Offset K x) →
  d o < T →
  Blocked (K ∷ as) x
copy-blocks-offset cov (offset d refl) d<T = copy (cov d d<T)

-- This is the five-line induction stripped to its exact data.
--
-- Given:
--   (1) all d<T are blocked by the old prefix;
--   (2) K is a valid selected extension, hence (by (1)) K is not < T;
--   (3) L is a later selected value, so K<L;
--   (4) L<2T (the contradiction branch).
--
-- Arithmetic gives L=K+d with d<T.  Then copy-blocks-offset blocks L,
-- contradicting its validity.  Therefore no valid later L>K can lie below 2T.
--
-- The remaining implementation is only the Peano lemma producing d<T from
-- K not<T, K<L, and L<T+T.  It contains no subset-sum mathematics.
--
-- We leave that lemma as a *type to implement*, not an assumption:
record DoublingArithmetic (T K L : Nat) : Set where
  constructor doubling
  field
    offsetWitness : Offset K L
    residual<T : d offsetWitness < T
open DoublingArithmetic public

doubling-step :
  {as : List Nat} {T K L : Nat} →
  Coverage as T →
  Valid as K →
  Valid (K ∷ as) L →
  DoublingArithmetic T K L →
  ⊥
doubling-step cov validK validL ar =
  validL (copy-blocks-offset cov (offsetWitness ar) (residual<T ar))

-- Note: Valid as K plus Coverage as T is exactly the proof that K is not<T:
K-not-below-T :
  {as : List Nat} {T K : Nat} →
  Coverage as T → Valid as K → ¬ (K < T)
K-not-below-T cov validK K<T = coverage-lower-bound cov validK K<T

-- No postulates. No holes. --safe.
-- To finish the fully packaged theorem, implement the routine Nat lemma:
--
--   ¬ K<T → K<L → L<T+T → DoublingArithmetic T K L
--
-- and feed it to doubling-step.
