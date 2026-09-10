{-# OPTIONS --safe #-}

module TheoremCompiledObservation where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Bool
open import Agda.Builtin.Sigma

-- A sufficient quotient is executable mathematics: the commuting equation is
-- exactly the license to replace a large-state observation by a small-state
-- one.  No certificate is passed to a separate runtime.
record Sufficient (X Q O : Set) : Set where
  constructor sufficient
  field
    quotient : X → Q
    observeLarge : X → O
    observeSmall : Q → O
    factors : (x : X) → observeLarge x ≡ observeSmall (quotient x)

open Sufficient

compileObservation : {X Q O : Set} → Sufficient X Q O → Q → O
compileObservation S = observeSmall S

compiled-sound : {X Q O : Set} (S : Sufficient X Q O) (x : X)
  → observeLarge S x ≡ compileObservation S (quotient S x)
compiled-sound S = factors S

-- An action descends when the quotient commutes with it.  Iteration then runs
-- entirely on Q; the theorem, not a scheduler heuristic, makes that legal.
record DescendingAction {X Q O : Set} (S : Sufficient X Q O) : Set where
  constructor descending
  field
    largeStep : X → X
    smallStep : Q → Q
    descends : (x : X) → quotient S (largeStep x) ≡ smallStep (quotient S x)

open DescendingAction

iterate : {A : Set} → Nat → (A → A) → A → A
iterate zero f x = x
iterate (suc n) f x = iterate n f (f x)

iterate-descends : {X Q O : Set} (S : Sufficient X Q O)
  (A : DescendingAction S) (n : Nat) (x : X)
  → quotient S (iterate n (largeStep A) x)
    ≡ iterate n (smallStep A) (quotient S x)
iterate-descends S A zero x = refl
iterate-descends S A (suc n) x
  rewrite iterate-descends S A n (largeStep A x)
  | descends A x = refl

future-observation-sound : {X Q O : Set} (S : Sufficient X Q O)
  (A : DescendingAction S) (n : Nat) (x : X)
  → observeLarge S (iterate n (largeStep A) x)
    ≡ compileObservation S (iterate n (smallStep A) (quotient S x))
future-observation-sound S A n x
  rewrite factors S (iterate n (largeStep A) x)
  | iterate-descends S A n x = refl

-- Imported arithmetic instance: parity is the sufficient quotient of Nat for
-- parity observation, and successor descends to Boolean negation.
not : Bool → Bool
not false = true
not true = false

parity : Nat → Bool
parity zero = false
parity (suc n) = not (parity n)

paritySufficient : Sufficient Nat Bool Bool
paritySufficient = sufficient parity parity (λ b → b) (λ n → refl)

successorDescends : DescendingAction paritySufficient
successorDescends = descending suc not (λ n → refl)

parity-future-compiled : (steps start : Nat)
  → parity (iterate steps suc start)
    ≡ iterate steps not (parity start)
parity-future-compiled = future-observation-sound paritySufficient successorDescends

-- Exact counted reads.  Direct parity structurally inspects the unary state;
-- the imported quotient is already one bit, so its observation is one step.
Counted : Set → Set
Counted A = Σ A (λ _ → Nat)

directParity : Nat → Counted Bool
directParity zero = false , suc zero
directParity (suc n) with directParity n
... | b , c = not b , suc c

compiledParity : Bool → Counted Bool
compiledParity b = b , suc zero

directParity-value : (n : Nat) → fst (directParity n) ≡ parity n
directParity-value zero = refl
directParity-value (suc n) with directParity n | directParity-value n
... | b , c | refl = refl

directParity-cost : (n : Nat) → snd (directParity n) ≡ suc n
directParity-cost zero = refl
directParity-cost (suc n) with directParity n | directParity-cost n
... | b , .(suc n) | refl = refl

compiledParity-value : (n : Nat)
  → fst (compiledParity (quotient paritySufficient n)) ≡ fst (directParity n)
compiledParity-value n rewrite directParity-value n = refl

data Less : Nat → Nat → Set where
  z<s : {n : Nat} → Less zero (suc n)
  s<s : {m n : Nat} → Less m n → Less (suc m) (suc n)

-- Every nonzero large state is strictly more expensive to observe directly.
strict-parity-saving : (n : Nat)
  → Less (snd (compiledParity (parity (suc n)))) (snd (directParity (suc n)))
strict-parity-saving n rewrite directParity-cost (suc n) = s<s z<s

-- Extracted controls.
directParityValue : Nat → Bool
directParityValue n = fst (directParity n)

compiledParityValue : Nat → Bool
compiledParityValue n = fst (compiledParity (parity n))

double : Nat → Nat
double zero = zero
double (suc n) = suc (suc (double n))

parity-double : (n : Nat) → parity (double n) ≡ false
parity-double zero = refl
parity-double (suc n) rewrite parity-double n = refl

directEvenValue : Nat → Bool
directEvenValue n = directParityValue (double n)

compiledEvenValue : Bool
compiledEvenValue = fst (compiledParity false)

even-values-agree : (n : Nat) → directEvenValue n ≡ compiledEvenValue
even-values-agree n rewrite directParity-value (double n) | parity-double n = refl
