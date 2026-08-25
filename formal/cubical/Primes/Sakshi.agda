{-# OPTIONS --cubical --guardedness --safe #-}
module Primes.Sakshi where
-- साक्षी: the witnessed census.  Every step of the count is a Dec object —
-- each twin carries its Σ-certificate, each non-twin its refutation.
-- No boolean is trusted anywhere in this count.

open import Primes.Prakriti
open import Primes.Vada using (primeDec; dec×)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary

Twin : ℕ → Type₀
Twin k = IsPrime k × IsPrime (suc (suc k))

twinDec : (k : ℕ) → Dec (Twin k)
twinDec k = dec× (primeDec k) (primeDec (suc (suc k)))

-- fold the DECISIONS, not booleans: the count is born certified
walk : ℕ → ℕ → ℕ → ℕ
walk zero    k c = c
walk (suc f) k c with twinDec k
... | yes _ = walk f (suc k) (suc c)
... | no  _ = walk f (suc k) c

-- pressed: eight twin pairs start below 100, counted through certificates
_ : walk 98 2 0 ≡ 8
_ = refl
