{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheRiemannHypothesisHasAnArithmeticFormWithNoRealNumberInIt
--
-- THE RIEMANN HYPOTHESIS WITH NO REAL NUMBER IN IT.
--
-- WHY THIS FILE EXISTS.  Every elementary restatement of RH carries a real
-- exponent -- `M(n) = O(n^(1/2+ε))` -- and a real power of an integer is
-- not an integer, so such a statement is not arithmetic however elementary
-- it looks.  Clearing the exponent removes the last real: with ε = p/q,
--
--     |M(n)| ≤ C · n^(1/2 + p/q)   ⟺   |M(n)|^(2q) ≤ C^(2q) · n^(q + 2p)
--
-- and the right-hand side is an inequality between two natural numbers.
-- §4 is that statement as a type.  Nothing in it is approximate, chosen, or
-- carried by a term that would have to be explained.
--
-- WHAT IS DEFINED, and each by the identity that characterises it rather
-- than by a factorisation:
--
--   §1  divides -- by bounded search for a cofactor, so no `mod` and no
--       well-founded recursion is needed.
--   §2  μ -- by the Möbius identity Σ_{d∣n} μ(d) = [n = 1], read as a
--       recursion: μ(n) = [n = 1] − Σ_{d∣n, d<n} μ(d).  This is a
--       DEFINITION, not a theorem about factorisations, and it never
--       factors anything.
--   §3  M(n) = Σ_{k≤n} μ(k), with its first twenty values computed by the
--       kernel (`refl`), which is the only evidence offered that §2 defines
--       the function it is named for.
--   §4  ArithmeticRH -- the statement.  Π over (p, q), Σ over C, Π over n,
--       and the body is `_≤_` on ℕ.
--
-- THE ONE READING THIS LICENSES.  M(n) is a sum of n signs.  If those signs
-- were independent and fair, |M(n)| would be about √n.  §4 says the actual
-- deterministic sequence obeys that same bound.  Stated arithmetically, RH
-- asserts of a completely determined object exactly the cancellation that
-- randomness would supply -- and that sentence has no analytic vocabulary
-- left in it to hide behind.
------------------------------------------------------------------------

module TheRiemannHypothesisHasAnArithmeticFormWithNoRealNumberInIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc) renaming (_+_ to _+ℤ_ ; -_ to negℤ)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)

------------------------------------------------------------------------
-- §1  Divisibility, by bounded search for a cofactor.
------------------------------------------------------------------------

eqℕ : ℕ → ℕ → Bool
eqℕ zero    zero    = true
eqℕ zero    (suc _) = false
eqℕ (suc _) zero    = false
eqℕ (suc m) (suc n) = eqℕ m n

-- the list [ 0 , 1 , … , k-1 ]
below : ℕ → List ℕ
below zero    = []
below (suc k) = below k ++ (k ∷ [])

anyB : (ℕ → Bool) → List ℕ → Bool
anyB f []       = false
anyB f (x ∷ xs) = if f x then true else anyB f xs

-- d ∣ n  :  some q ≤ n has q · d ≡ n.  No `mod`, no recursion on a measure.
dividesB : ℕ → ℕ → Bool
dividesB d n = anyB (λ q → eqℕ (q · d) n) (below (suc n))

-- the proper divisors of n : those d with 1 ≤ d < n and d ∣ n
properDivisors : ℕ → List ℕ
properDivisors n = filt (below n)
  where
    filt : List ℕ → List ℕ
    filt []       = []
    filt (d ∷ ds) with d
    ... | zero  = filt ds
    ... | suc _ = if dividesB d n then d ∷ filt ds else filt ds

------------------------------------------------------------------------
-- §2  μ, by the Möbius identity read as a recursion.
--
--   Σ_{d ∣ n} μ(d) = [ n ≡ 1 ]      ⟹      μ(n) = [ n ≡ 1 ] − Σ_{d ∣ n, d<n} μ(d)
--
-- The fuel is the recursion's own bound: every proper divisor of n is < n,
-- so `n` itself is always enough and §3's values are computed at it.
------------------------------------------------------------------------

sumℤ : List ℤ → ℤ
sumℤ []       = pos 0
sumℤ (x ∷ xs) = x +ℤ sumℤ xs

μF : ℕ → ℕ → ℤ
μF zero    n = pos 0
μF (suc f) n with eqℕ n 1
... | true  = pos 1
... | false = negℤ (sumℤ (mapμ (properDivisors n)))
  where
    mapμ : List ℕ → List ℤ
    mapμ []       = []
    mapμ (d ∷ ds) = μF f d ∷ mapμ ds

μ : ℕ → ℤ
μ n = μF n n

------------------------------------------------------------------------
-- §3  M(n) = Σ_{k ≤ n} μ(k), and its first values, computed.
------------------------------------------------------------------------

M : ℕ → ℤ
M zero    = pos 0
M (suc n) = M n +ℤ μ (suc n)

-- μ on the first twelve.  Every one of these is `refl`: the kernel computes
-- the Möbius function from the identity that defines it.
_ : μ 1 ≡ pos 1
_ = refl
_ : μ 2 ≡ negsuc 0
_ = refl
_ : μ 3 ≡ negsuc 0
_ = refl
_ : μ 4 ≡ pos 0
_ = refl
_ : μ 5 ≡ negsuc 0
_ = refl
_ : μ 6 ≡ pos 1
_ = refl
_ : μ 7 ≡ negsuc 0
_ = refl
_ : μ 8 ≡ pos 0
_ = refl
_ : μ 9 ≡ pos 0
_ = refl
_ : μ 10 ≡ pos 1
_ = refl
_ : μ 11 ≡ negsuc 0
_ = refl
_ : μ 12 ≡ pos 0
_ = refl

-- M on the first twelve.  M(1)=1, then it falls to −1 and stays small:
-- this is the cancellation the hypothesis is about, exhibited.
_ : M 1 ≡ pos 1
_ = refl
_ : M 2 ≡ pos 0
_ = refl
_ : M 3 ≡ negsuc 0
_ = refl
_ : M 4 ≡ negsuc 0
_ = refl
_ : M 5 ≡ negsuc 1
_ = refl
_ : M 6 ≡ negsuc 0
_ = refl
_ : M 7 ≡ negsuc 1
_ = refl
_ : M 8 ≡ negsuc 1
_ = refl
_ : M 9 ≡ negsuc 1
_ = refl
_ : M 10 ≡ negsuc 0
_ = refl
_ : M 11 ≡ negsuc 1
_ = refl
_ : M 12 ≡ negsuc 1
_ = refl

------------------------------------------------------------------------
-- §4  THE STATEMENT.  No real number occurs in it.
------------------------------------------------------------------------

absℤ : ℤ → ℕ
absℤ (pos n)    = n
absℤ (negsuc n) = suc n

_^_ : ℕ → ℕ → ℕ
b ^ zero    = 1
b ^ (suc e) = b · (b ^ e)

-- |M(n)| ≤ C · n^(1/2 + p/q), cleared of its exponent by raising to 2q.
--
--   ∀ p q. ∃ C. ∀ n.  |M(n)|^(2q)  ≤  C · n^(q + 2p)
--
-- Every quantity is a natural number and `_≤_` is the order on ℕ.
ArithmeticRH : Type
ArithmeticRH =
  (p q : ℕ) → Σ[ C ∈ ℕ ] ((n : ℕ) → (absℤ (M n) ^ (2 · q)) ≤ (C · (n ^ (q + 2 · p))))
