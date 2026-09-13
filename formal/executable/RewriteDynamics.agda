{-# OPTIONS --safe #-}

module RewriteDynamics where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Sigma

data Tm : Set where
  var zeroT : Tm
  sucT : Tm → Tm
  add : Tm → Tm → Tm

data Step : Tm → Tm → Set where
  add-zero : (x : Tm) → Step (add x zeroT) x
  add-suc : (x y : Tm) → Step (add x (sucT y)) (sucT (add x y))

data Derivation : Tm → Tm → Set where
  done : (x : Tm) → Derivation x x
  then-step : {x y z : Tm} → Step x y → Derivation y z → Derivation x z

eval : Tm → Nat → Nat
eval var n = n
eval zeroT n = zero
eval (sucT t) n = suc (eval t n)
eval (add l r) n = eval l n + eval r n

+-zero-right : (n : Nat) → n + zero ≡ n
+-zero-right zero = refl
+-zero-right (suc n) rewrite +-zero-right n = refl

+-suc-right : (m n : Nat) → m + suc n ≡ suc (m + n)
+-suc-right zero n = refl
+-suc-right (suc m) n rewrite +-suc-right m n = refl

step-sound : {a b : Tm} → Step a b → (n : Nat) → eval a n ≡ eval b n
step-sound (add-zero x) n = +-zero-right (eval x n)
step-sound (add-suc x y) n = +-suc-right (eval x n) (eval y n)

trans : {A : Set} {x y z : A} → x ≡ y → y ≡ z → x ≡ z
trans refl q = q

derivation-sound : {a b : Tm} → Derivation a b → (n : Nat) → eval a n ≡ eval b n
derivation-sound (done x) n = refl
derivation-sound (then-step p d) n = trans (step-sound p n) (derivation-sound d n)

RootResult : Tm → Set
RootResult t = Σ Tm (Derivation t)

-- This is the executable dynamics.  There is no separately proposed result:
-- the output term and its semantics-preserving derivation are one value.
rootStep : (t : Tm) → RootResult t
rootStep (add x zeroT) = x , then-step (add-zero x) (done x)
rootStep (add x (sucT y)) = sucT (add x y) , then-step (add-suc x y) (done (sucT (add x y)))
rootStep t = t , done t

rootStep-sound : (t : Tm) (n : Nat) → eval t n ≡ eval (fst (rootStep t)) n
rootStep-sound t n = derivation-sound (snd (rootStep t)) n
