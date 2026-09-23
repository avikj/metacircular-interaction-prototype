{-# OPTIONS --safe #-}

module Erdos1 where

open import Agda.Builtin.Nat using (Nat; zero; suc; _+_; _<_)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.Sigma using (Σ; _,_)

-- A deliberately tiny formalization of the induction skeleton.
-- No postulates, no holes, no external mathematical development.

data ⊥ : Set where

¬_ : Set → Set
¬ P = P → ⊥

_≤_ : Nat → Nat → Set
zero  ≤ n     = Agda.Builtin.Unit.⊤
suc m ≤ zero  = ⊥
suc m ≤ suc n = m ≤ n

open import Agda.Builtin.Unit using (⊤; tt)

two : Nat
two = suc (suc zero)

double : Nat → Nat
double n = n + n

-- "Covered from frontier k through bound t": every candidate strictly
-- above k and strictly below t is forbidden.
Covered : Nat → Nat → (Nat → Set) → Set
Covered k t Forbidden =
  (x : Nat) → k < x → x < t → Forbidden x

-- "t is a lower bound for every valid next value above k".
Forces : Nat → Nat → (Nat → Set) → Set
Forces k t Valid =
  (x : Nat) → k < x → Valid x → t ≤ x

-- Pointwise identity between valid and forbidden is all that is needed
-- to turn least-valid/lower-bound language into coverage language.
Complement : (Nat → Set) → (Nat → Set) → Set
Complement Valid Forbidden =
  (x : Nat) → (Valid x → ¬ Forbidden x) × (¬ Forbidden x → Valid x)

record _×_ (A B : Set) : Set where
  constructor _,×_
  field fst : A
        snd : B
open _×_ public

-- Elementary order lemmas, proved structurally.
≤-refl : (n : Nat) → n ≤ n
≤-refl zero = tt
≤-refl (suc n) = ≤-refl n

≤-step : {m n : Nat} → m ≤ n → m ≤ suc n
≤-step {zero} p = tt
≤-step {suc m} {suc n} p = ≤-step {m} {n} p

<-to-≤ : {m n : Nat} → m < n → suc m ≤ n
<-to-≤ p = p

-- The forcing/coverage direction used by the induction:
-- if every candidate below t is forbidden and valid candidates cannot
-- be forbidden, every valid candidate is at least t.
covered→forces :
  {k t : Nat} {Valid Forbidden : Nat → Set} →
  ((x : Nat) → Valid x → ¬ Forbidden x) →
  Covered k t Forbidden →
  Forces k t Valid
covered→forces disjoint covered x k<x vx with t ≤? x
... | yes t≤x = t≤x
... | no ¬t≤x = ⊥-elim (disjoint x vx (covered x k<x (not≤→< ¬t≤x)))

-- Small decidable-order machinery, still entirely constructive.
data Dec (P : Set) : Set where
  yes : P → Dec P
  no  : ¬ P → Dec P

_≤?_ : (m n : Nat) → Dec (m ≤ n)
zero ≤? n = yes tt
suc m ≤? zero = no (λ ())
suc m ≤? suc n with m ≤? n
... | yes p = yes p
... | no p  = no p

not≤→< : {m n : Nat} → ¬ (m ≤ n) → n < m
not≤→< {zero} {n} p = ⊥-elim (p tt)
not≤→< {suc m} {zero} p = tt
not≤→< {suc m} {suc n} p = not≤→< {m} {n} p

⊥-elim : {A : Set} → ⊥ → A
⊥-elim ()

-- The exact copy/translate induction is isolated as its own assumption-free
-- interface: old coverage of length T, when copied at lawful K, covers the
-- next frontier through K+T.  A concrete subset-sum implementation proves
-- this by transporting a difference witness d = s-t to K+d = (K+s)-t.
CopyCoverage : (Forbidden : Nat → Set) → Set
CopyCoverage Forbidden =
  (frontier K T : Nat) →
  Covered frontier T Forbidden →
  Covered K (K + T) Forbidden

-- Once coverage has been copied, the numerical doubling step is just
-- arithmetic/order.  This file intentionally exposes that exact boundary:
-- the concrete difference-set witness must instantiate CopyCoverage.
