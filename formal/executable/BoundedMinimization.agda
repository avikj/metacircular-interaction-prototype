{-# OPTIONS --safe #-}

module BoundedMinimization where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Bool
open import Agda.Builtin.Sigma
import TheoremCompiledObservation as TC

data Maybe (A : Set) : Set where
  nothing : Maybe A
  just : A → Maybe A

data Less : Nat → Nat → Set where
  z<s : {n : Nat} → Less zero (suc n)
  s<s : {m n : Nat} → Less m n → Less (suc m) (suc n)

data Le : Nat → Nat → Set where
  z≤n : {n : Nat} → Le zero n
  s≤s : {m n : Nat} → Le m n → Le (suc m) (suc n)

record Least (P : Nat → Bool) (n : Nat) : Set where
  constructor least
  field
    hit : P n ≡ true
    earlier : (m : Nat) → Less m n → P m ≡ false

open Least

-- The partial unbounded μ-operator is total exactly on its domain of
-- termination: a predicate paired with its least witness.
MuDomain : (Nat → Bool) → Set
MuDomain P = Σ Nat (Least P)

mu : {P : Nat → Bool} → MuDomain P → Nat
mu = fst

-- Executable bounded search tests 0..B.  Its totality needs no termination
-- oracle; coverage will identify its result with partial μ.
boundedSearch : (P : Nat → Bool) → Nat → Maybe Nat
boundedSearch P zero with P zero
... | false = nothing
... | true = just zero
boundedSearch P (suc B) with P zero
... | true = just zero
... | false with boundedSearch (λ n → P (suc n)) B
...   | nothing = nothing
...   | just n = just (suc n)

shiftLeast : {P : Nat → Bool} {n : Nat} → Least P (suc n)
  → Least (λ m → P (suc m)) n
shiftLeast {P} {zero} L = least (hit L) (λ m ())
shiftLeast {P} {suc n} L = least (hit L)
  (λ m m<n → earlier L (suc m) (s<s m<n))

-- Independent B plus coverage `μ P ≤ B` compiles the partial operator to
-- the bounded total search, with exact result equality.
bounded-finds : (P : Nat → Bool) (B n : Nat) → Least P n → Le n B
  → boundedSearch P B ≡ just n
bounded-finds P zero zero L cov rewrite hit L = refl
bounded-finds P (suc B) zero L cov rewrite hit L = refl
bounded-finds P (suc B) (suc n) L (s≤s cov)
  rewrite earlier L zero z<s
  | bounded-finds (λ m → P (suc m)) B n (shiftLeast L) cov = refl

record CompiledMu (P : Nat → Bool) (B : Nat) : Set where
  constructor compiledMu
  field
    result : Nat
    result-is-bounded-search : boundedSearch P B ≡ just result
    result-is-least : Least P result
    within-bound : Le result B
    exact-budget : Nat
    budget-is-B+1 : exact-budget ≡ suc B

compileMu : (P : Nat → Bool) (B : Nat) (M : MuDomain P) → Le (mu M) B
  → CompiledMu P B
compileMu P B (n , L) coverage = compiledMu n
  (bounded-finds P B n L coverage) L coverage (suc B) refl

compileMu-result : (P : Nat → Bool) (B : Nat) (M : MuDomain P)
  (coverage : Le (mu M) B) → CompiledMu.result (compileMu P B M coverage) ≡ mu M
compileMu-result P B (n , L) coverage = refl

-- Connection to theorem-induced observation: after compilation, observing the
-- partial result factors through the bounded total result representation.
muObservation : (P : Nat → Bool) (B : Nat) (M : MuDomain P)
  → Le (mu M) B → TC.Sufficient (MuDomain P) Nat Nat
muObservation P B M coverage = TC.sufficient mu (λ D → mu D) (λ n → n)
  (λ D → refl)

-- Non-prime executable control: the first n with n >= 3 under a saturating
-- three-state predicate is exactly 3, and bound 5 compiles it in six tests.
atLeastThree : Nat → Bool
atLeastThree zero = false
atLeastThree (suc zero) = false
atLeastThree (suc (suc zero)) = false
atLeastThree (suc (suc (suc n))) = true

threeLeast : Least atLeastThree (suc (suc (suc zero)))
threeLeast = least refl before
  where
  before : (m : Nat) → Less m (suc (suc (suc zero))) → atLeastThree m ≡ false
  before zero p = refl
  before (suc zero) p = refl
  before (suc (suc zero)) p = refl
  before (suc (suc (suc m))) (s<s (s<s (s<s ())))

three≤five : Le (suc (suc (suc zero))) (suc (suc (suc (suc (suc zero)))))
three≤five = s≤s (s≤s (s≤s z≤n))

compiledThree : CompiledMu atLeastThree (suc (suc (suc (suc (suc zero)))))
compiledThree = compileMu atLeastThree _ (suc (suc (suc zero)) , threeLeast) three≤five

compiledThreeResult : Nat
compiledThreeResult = CompiledMu.result compiledThree

compiledThreeBudget : Nat
compiledThreeBudget = CompiledMu.exact-budget compiledThree
