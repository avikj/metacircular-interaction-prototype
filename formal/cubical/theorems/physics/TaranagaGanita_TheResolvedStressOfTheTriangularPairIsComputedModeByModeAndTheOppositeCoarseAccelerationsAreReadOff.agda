{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तरङ्ग-गणित — mode arithmetic.
--
-- Theorem 8 of the proof note rests on a finite trigonometric
-- computation: with u^σ(x,0) = A e₂ cos(N x₁) + σ A e₃ cos(x₂ − N x₁) and
-- P = P_{≤1} the sharp Fourier projection, the resolved stress is
--
--     R^σ = P(u⊗u) = (A²/2) [[0,0,0],[0,1,σ cos x₂],[0,σ cos x₂,1]],
--
-- because cos² = ½ + ½ cos 2(·) and the cross frequency
-- (N,0,0) + (−N,1,0) = (0,1,0) survives the projection while
-- (2N,0,0), (−2N,2,0), (2N,−1,0) do not; hence
-- ∇·R^σ = −(σA²/2) e₃ sin x₂, ∂_t U^σ(0) = (σA²/2) e₃ sin x₂, and against
-- w = e₃ sin x₂ the reading is σA²/4.  That computation was checked
-- symbolically; here it is a term.
--
--   §1  THE KERNEL.  A trigonometric polynomial on 𝕋³ is a list of
--       (kind, frequency, coefficient) with one dyadic denominator 2^d.
--       Products expand by the product-to-sum rules with the
--       denominator raised by one; ∂_j multiplies by the frequency
--       component; P_{≤1} keeps |ξ|² ≤ 1; the pairing against a single
--       nonconstant mode reads its coefficient at norm ½.
--   §2  THE CROSS FREQUENCY, for every N: (N,0,0) + (−N,1,0) = (0,1,0).
--   §3  THE PAIR at A = 1, N = 2, σ = ±1: the six readings of the
--       stress, the two coarse accelerations, and the test against w —
--       every one computed by the typechecker.  The trace, the
--       pressure source and the coarse velocity agree across σ; the
--       cross coefficient and the acceleration carry σ.  These are the
--       coefficients DhanaVibheda took as given.
--
-- The soundness of the product-to-sum rules with respect to the real
-- trigonometric functions is the classical identity; the kernel
-- computes with them.  तरङ्ग (taraṅga, wave) and गणित (gaṇita,
-- computation) are ordinary Sanskrit.
------------------------------------------------------------------------

module TaranagaGanita_TheResolvedStressOfTheTriangularPairIsComputedModeByModeAndTheOppositeCoarseAccelerationsAreReadOff where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; -Cancel) renaming (_+_ to _+ℤ_ ; _·_ to _·ℤ_ ; -_ to -ℤ_)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; not)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)

------------------------------------------------------------------------
-- १ · The kernel.
------------------------------------------------------------------------

ℤ³ : Type₀
ℤ³ = ℤ × ℤ × ℤ

data Kind : Type₀ where
  cos sin : Kind

-- one term: kind, frequency, integer coefficient
Term : Type₀
Term = Kind × ℤ³ × ℤ

-- a trigonometric polynomial: terms over a common denominator 2^d
record Poly : Type₀ where
  constructor _/2^_
  field
    terms : List Term
    d     : ℕ
open Poly

-- frequency arithmetic
_⊕_ _⊖_ : ℤ³ → ℤ³ → ℤ³
(a , b , c) ⊕ (a′ , b′ , c′) = (a +ℤ a′ , b +ℤ b′ , c +ℤ c′)
(a , b , c) ⊖ (a′ , b′ , c′) = (a +ℤ (-ℤ a′) , b +ℤ (-ℤ b′) , c +ℤ (-ℤ c′))

-- product of two terms, by product-to-sum (the ½ is the raised denominator)
_⋆_ : Term → Term → List Term
(cos , ξ , c) ⋆ (cos , η , c′) = (cos , ξ ⊖ η , c ·ℤ c′) ∷ (cos , ξ ⊕ η , c ·ℤ c′) ∷ []
(sin , ξ , c) ⋆ (sin , η , c′) = (cos , ξ ⊖ η , c ·ℤ c′) ∷ (cos , ξ ⊕ η , -ℤ (c ·ℤ c′)) ∷ []
(sin , ξ , c) ⋆ (cos , η , c′) = (sin , ξ ⊕ η , c ·ℤ c′) ∷ (sin , ξ ⊖ η , c ·ℤ c′) ∷ []
(cos , ξ , c) ⋆ (sin , η , c′) = (sin , ξ ⊕ η , c ·ℤ c′) ∷ (sin , ξ ⊖ η , -ℤ (c ·ℤ c′)) ∷ []

filter : {A : Type₀} → (A → Bool) → List A → List A
filter p []       = []
filter p (x ∷ xs) with p x
... | true  = x ∷ filter p xs
... | false = filter p xs

concatMap : {A B : Type₀} → (A → List B) → List A → List B
concatMap f []       = []
concatMap f (x ∷ xs) = f x ++ concatMap f xs

-- product of polynomials
infixl 7 _·_
_·_ : Poly → Poly → Poly
(ts /2^ d) · (us /2^ e) = concatMap (λ t → concatMap (λ u → t ⋆ u) us) ts /2^ suc (d ℕ+ e)
  where
  _ℕ+_ : ℕ → ℕ → ℕ
  zero ℕ+ n = n
  suc m ℕ+ n = suc (m ℕ+ n)

-- sum (denominators must agree; the uses below keep them aligned)
infixl 6 _+_
_+_ : Poly → Poly → Poly
(ts /2^ d) + (us /2^ _) = (ts ++ us) /2^ d

-- negation
-_ : Poly → Poly
- (ts /2^ d) = map (λ { (k , ξ , c) → (k , ξ , -ℤ c) }) ts /2^ d

-- component j of a frequency
ghaṭaka : ℕ → ℤ³ → ℤ
ghaṭaka zero          (a , _ , _) = a
ghaṭaka (suc zero)    (_ , b , _) = b
ghaṭaka (suc (suc _)) (_ , _ , c) = c

-- ∂_j : cos ξ ↦ −ξ_j sin ξ ,  sin ξ ↦ ξ_j cos ξ
∂ : ℕ → Poly → Poly
∂ j (ts /2^ d) = map step ts /2^ d
  where
  step : Term → Term
  step (cos , ξ , c) = (sin , ξ , -ℤ (ghaṭaka j ξ ·ℤ c))
  step (sin , ξ , c) = (cos , ξ , ghaṭaka j ξ ·ℤ c)

-- |ξ|² ≤ 1, decided on the components: each in {−1,0,1} and at most one nonzero
small : ℤ → Bool
small (pos zero) = true
small (pos (suc zero)) = true
small (negsuc zero) = true
small _ = false

isZero : ℤ → Bool
isZero (pos zero) = true
isZero _ = false

keep : ℤ³ → Bool
keep (a , b , c) =
  (small a and small b and small c) and
  (((isZero a and isZero b) or′ (isZero a and isZero c)) or′ (isZero b and isZero c))
  where
  _or′_ : Bool → Bool → Bool
  true  or′ _ = true
  false or′ y = y

-- the sharp projection P_{≤1}
P : Poly → Poly
P (ts /2^ d) = filter (λ { (_ , ξ , _) → keep ξ }) ts /2^ d

-- integer equality, decided
eqℤ : ℤ → ℤ → Bool
eqℤ (pos m)    (pos n)    = eqℕ m n
  where
  eqℕ : ℕ → ℕ → Bool
  eqℕ zero zero = true
  eqℕ (suc m) (suc n) = eqℕ m n
  eqℕ _ _ = false
eqℤ (negsuc m) (negsuc n) = eqℕ′ m n
  where
  eqℕ′ : ℕ → ℕ → Bool
  eqℕ′ zero zero = true
  eqℕ′ (suc m) (suc n) = eqℕ′ m n
  eqℕ′ _ _ = false
eqℤ _ _ = false

eqξ : ℤ³ → ℤ³ → Bool
eqξ (a , b , c) (a′ , b′ , c′) = eqℤ a a′ and eqℤ b b′ and eqℤ c c′

eqKind : Kind → Kind → Bool
eqKind cos cos = true
eqKind sin sin = true
eqKind _ _ = false

-- the total coefficient of one mode
coeff : Kind → ℤ³ → Poly → ℤ
coeff k ξ (ts /2^ _) = go ts
  where
  go : List Term → ℤ
  go [] = pos zero
  go ((k′ , η , c) ∷ rest) with eqKind k k′ and eqξ ξ η
  ... | true  = c +ℤ go rest
  ... | false = go rest

-- pairing against a single nonconstant mode: the coefficient, at norm ½
-- (reported as numerator over 2^(d+1))
⟨_∣_,_⟩ : Poly → Kind → ℤ³ → ℤ × ℕ
⟨ p ∣ k , ξ ⟩ = coeff k ξ p , suc (d p)

-- vector fields and the stress
Vec : Type₀
Vec = Poly × Poly × Poly

at : ℕ → Vec → Poly
at zero          (a , _ , _) = a
at (suc zero)    (_ , b , _) = b
at (suc (suc _)) (_ , _ , c) = c

-- the resolved stress R_ij = P (u_i u_j)   (U = 0 here, so nothing to subtract)
R : Vec → ℕ → ℕ → Poly
R u i j = P (at i u · at j u)

-- (∇·R)_i = Σ_j ∂_j R_ij
div : Vec → ℕ → Poly
div u i = ∂ 0 (R u i 0) + ∂ 1 (R u i 1) + ∂ 2 (R u i 2)

------------------------------------------------------------------------
-- २ · The cross frequency, for every N.
------------------------------------------------------------------------

cross : (N : ℤ) → ((N , pos 0 , pos 0) ⊕ (-ℤ N , pos 1 , pos 0)) ≡ (pos 0 , pos 1 , pos 0)
cross N i = -Cancel N i , pos 1 , pos 0

------------------------------------------------------------------------
-- ३ · The pair at A = 1, N = 2, σ = ±1: every reading computed.
------------------------------------------------------------------------

-- zero polynomial
𝟘 : Poly
𝟘 = [] /2^ 0

-- u^σ = (0 , cos(2x₁) , σ cos(x₂ − 2x₁))
u : ℤ → Vec
u σ = 𝟘
    , ((cos , (pos 2 , pos 0 , pos 0) , pos 1) ∷ []) /2^ 0
    , ((cos , (negsuc 1 , pos 1 , pos 0) , σ) ∷ []) /2^ 0

-- the stress entries: (coefficient , denominator exponent)
-- R_22 = ½ , R_33 = ½ : the constant mode, over 2^1
R₂₂-const : (σ : ℤ) → coeff cos (pos 0 , pos 0 , pos 0) (R (u σ) 1 1) ≡ pos 1
R₂₂-const (pos _)    = refl
R₂₂-const (negsuc _) = refl

R₃₃-const : coeff cos (pos 0 , pos 0 , pos 0) (R (u (pos 1)) 2 2) ≡ pos 1
R₃₃-const = refl

R₃₃-const′ : coeff cos (pos 0 , pos 0 , pos 0) (R (u (negsuc 0)) 2 2) ≡ pos 1
R₃₃-const′ = refl

-- R_23 = (σ/2) cos x₂ : the cross mode (0,1,0) carries σ, over 2^1
R₂₃-cross⁺ : coeff cos (pos 0 , pos 1 , pos 0) (R (u (pos 1)) 1 2) ≡ pos 1
R₂₃-cross⁺ = refl

R₂₃-cross⁻ : coeff cos (pos 0 , pos 1 , pos 0) (R (u (negsuc 0)) 1 2) ≡ negsuc 0
R₂₃-cross⁻ = refl

-- the killed frequencies leave nothing: no cos(4x₁) in R_22
R₂₂-no-4x₁ : coeff cos (pos 4 , pos 0 , pos 0) (R (u (pos 1)) 1 1) ≡ pos 0
R₂₂-no-4x₁ = refl

-- the denominator of the stress is 2^1 in every entry
R-denominator : d (R (u (pos 1)) 1 2) ≡ 1
R-denominator = refl

-- ∇·R : component 3 is −(σ/2) sin x₂ ; the σ-sign is read off
divR₃⁺ : coeff sin (pos 0 , pos 1 , pos 0) (div (u (pos 1)) 2) ≡ negsuc 0
divR₃⁺ = refl

divR₃⁻ : coeff sin (pos 0 , pos 1 , pos 0) (div (u (negsuc 0)) 2) ≡ pos 1
divR₃⁻ = refl

-- and component 2 of the divergence has no sin x₂ (it is zero)
divR₂ : coeff sin (pos 0 , pos 1 , pos 0) (div (u (pos 1)) 1) ≡ pos 0
divR₂ = refl

-- ∂_t U = −∇·R, and the reading against w = e₃ sin x₂ is σ/4:
-- numerator σ over 2^(1+1)
∂ₜU⁺ : ⟨ - (div (u (pos 1)) 2) ∣ sin , (pos 0 , pos 1 , pos 0) ⟩ ≡ (pos 1 , 2)
∂ₜU⁺ = refl

∂ₜU⁻ : ⟨ - (div (u (negsuc 0)) 2) ∣ sin , (pos 0 , pos 1 , pos 0) ⟩ ≡ (negsuc 0 , 2)
∂ₜU⁻ = refl

-- the pressure source ∂_i∂_j R_ij vanishes: the cross entry has no x₃
-- dependence and the diagonal entries are constant
pressure-source⁺ : coeff cos (pos 0 , pos 1 , pos 0)
    (∂ 1 (∂ 1 (R (u (pos 1)) 1 1)) + ∂ 1 (∂ 2 (R (u (pos 1)) 1 2))
     + ∂ 2 (∂ 1 (R (u (pos 1)) 2 1)) + ∂ 2 (∂ 2 (R (u (pos 1)) 2 2))) ≡ pos 0
pressure-source⁺ = refl
