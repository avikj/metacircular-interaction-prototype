{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GalerkinJets — the time evolution of the triangular pair beyond
-- t = 0, at the exact layer: the Taylor jets ∂ₜⁿv(0) of the advected
-- component, computed to all orders from the equation
--
--     ∂ₜv = −a ∂₂v + νΔv,     ∂ₜa = νΔa   (a = 2cos(N x₁), heat flow)
--
-- by Leibniz: ∂ₜⁿ⁺¹v = −Σ_{m≤n} C(n,m) (∂ₜᵐa) ∗ ∂₂(∂ₜⁿ⁻ᵐv) + νΔ ∂ₜⁿv, with
-- ∂ₜᵐa = (−νN²)ᵐ a.  Integer coefficients throughout; no denominator.
--
-- WHAT THIS IS.  TorusFourierLayer derived the pair at t = 0 and stopped
-- there because the advected v(t) leaves every finite mode set.  It
-- leaves it one mode per order: a has k₁ = ±1, so each jet widens the
-- k₁-support by one.  Hence
--
--   §1  the jets: Jet₀ = v, Jet₁ = −a∗∂₂v + νΔv (the t = 0 continuation of
--       TorusFourierLayer, recovered), Jet₂, Jet₃, on the box [−4, 4]²;
--   §2  support: Jetₙ vanishes on the rows |k₁| > n + 1, and the boundary
--       row k₁ = n + 1 is nonzero — the jet reaches exactly that far;
--   §3  Galerkin truncation: with T_M keeping |k₁| ≤ M and the truncated
--       recursion applying T_M after each step, the truncated jets agree
--       with the exact ones for every order n with n + 1 ≤ M and differ
--       at order n = M exactly on the rows |k₁| = M + 1 — the truncation
--       residual is the boundary row, the WindowShiftResidual shape
--       (the residual retreats to the edges) at the pair's own equation.
--
-- READING.  The pressure stays constant for all time because the field
-- keeps the form (0, a(t), σv(t)) with no x₃-dependence, so the nonlinear
-- term stays (0, 0, σ a∂₂v) and divergence-free; that is why the v-jets
-- alone carry the evolution.
--
-- SYĀT — THE CLAIM, EXACTLY.  Finite integer computations on a box,
-- decided and reflected, at ν = 1.  The convergence of the Taylor series
-- and the existence of v(t) are the linear theory and are NOT here; what
-- is here is every Taylor coefficient the linear theory would produce,
-- and where truncation loses them.
------------------------------------------------------------------------

module GalerkinJets_TheTaylorJetsOfThePairAtTimeZeroAreExactOnAWideningWindowAndTheTruncationResidualSitsOnTheBoundaryRow where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _+_ ; _·_ ; -_ ; _-_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _∸_)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_)
open import Cubical.Data.List using (List ; [] ; _∷_)

open import TorusFourierLayer_TheTriangularPairIsDerivedFromItsVelocityFieldTheNonlinearTermIsDivergenceFreeSoThePressureIsConstantAndTheCoarseStressAndContinuationAreComputed

------------------------------------------------------------------------
-- §0  binomials, the a-jets, the wider box
------------------------------------------------------------------------

binom : ℕ → ℕ → ℤ
binom _ zero = pos 1
binom zero (suc _) = pos 0
binom (suc n) (suc m) = binom n m + binom n (suc m)

ν : ℤ
ν = pos 1

-- (−νN²)ᵐ
decay : ℕ → ℤ
decay zero = pos 1
decay (suc m) = (- (ν · (N · N))) · decay m

-- ∂ₜᵐ a = (−νN²)ᵐ a
a-jet : ℕ → Field
a-jet m = ι (decay m) ·f a

box4 : List ℤ
box4 = negsuc 3 ∷ negsuc 2 ∷ negsuc 1 ∷ negsuc 0 ∷ pos 0 ∷ pos 1 ∷ pos 2 ∷ pos 3 ∷ pos 4 ∷ []

eqBox4 : Field → Field → Bool
eqBox4 f g = allL box4 (λ k₁ → allL box4 (λ k₂ → eqc (f k₁ k₂) (g k₁ k₂)))

-- a field vanishes on the given rows (all k₂ in box4)
zeroRows : List ℤ → Field → Bool
zeroRows rows f = allL rows (λ k₁ → allL box4 (λ k₂ → eqc (f k₁ k₂) 0c))

------------------------------------------------------------------------
-- §1  the jets
------------------------------------------------------------------------

-- Σ_{m ≤ n} C(n,m) · (∂ₜᵐa ∗ ∂₂ Jet(n−m)), with Jet given
leib : (ℕ → Field) → (n : ℕ) → ℕ → Field
leib G n zero = ι (binom n zero) ·f (a-jet zero ∗ ∂₂ (G n))
leib G n (suc m) = ι (binom n (suc m)) ·f (a-jet (suc m) ∗ ∂₂ (G (n ∸ suc m))) +f leib G n m

-- one step of the recursion: order n + 1 from a table of orders ≤ n
step : (ℕ → Field) → ℕ → Field
step G n = negf (leib G n n) +f ι ν ·f Δ (G n)

-- the table of jets up to order n (a function that is correct on k ≤ n)
open import Cubical.Data.Nat using (discreteℕ)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)

extend : (ℕ → Field) → ℕ → Field → (ℕ → Field)
extend G n F k with discreteℕ k (suc n)
... | yes _ = F
... | no _ = G k

table : ℕ → (ℕ → Field)
table zero = λ _ → v
table (suc n) = extend (table n) n (step (table n) n)

-- the exact jets
Jet : ℕ → Field
Jet n = table n n

-- Galerkin truncation to |k₁| ≤ M
T : ℕ → Field → Field
T M f k₁ k₂ = keep (inRow M k₁) (f k₁ k₂)
  where
    open import Cubical.Data.Int using (abs)
    open import Cubical.Data.Nat.Order using (_≤_ ; ≤Dec)
    open import Cubical.Relation.Nullary using (Dec ; yes ; no)
    inRow : ℕ → ℤ → Bool
    inRow M k with ≤Dec (abs k) M
    ... | yes _ = true
    ... | no _ = false
    keep : Bool → ℤi → ℤi
    keep true z = z
    keep false _ = 0c

-- the truncated jets: T_M after every step
tableT : ℕ → ℕ → (ℕ → Field)
tableT M zero = λ _ → v
tableT M (suc n) = extend (tableT M n) n (T M (step (tableT M n) n))

JT : ℕ → ℕ → Field
JT M n = tableT M n n

------------------------------------------------------------------------
-- §2  Jet₁ is the t = 0 continuation; supports; boundary rows
------------------------------------------------------------------------

-- Jet₁ = −a∗∂₂v + νΔv, the u₃-component of ∂ₜ at t = 0 in TorusFourierLayer
Jet₁-is-continuation : eqBox4 (Jet 1) (u₃ (∂ₜ ν (u (pos 1)))) ≡ true
Jet₁-is-continuation = refl

-- Jetₙ vanishes beyond |k₁| = n + 1 …
support-Jet₀ : zeroRows (negsuc 3 ∷ negsuc 2 ∷ negsuc 1 ∷ pos 2 ∷ pos 3 ∷ pos 4 ∷ []) (Jet 0) ≡ true
support-Jet₀ = refl

support-Jet₁ : zeroRows (negsuc 3 ∷ negsuc 2 ∷ pos 3 ∷ pos 4 ∷ []) (Jet 1) ≡ true
support-Jet₁ = refl

support-Jet₂ : zeroRows (negsuc 3 ∷ pos 4 ∷ []) (Jet 2) ≡ true
support-Jet₂ = refl

-- … and reaches the boundary row exactly
boundary-Jet₁ : Jet 1 (pos 2) (pos 1) ≡ (pos 0 , negsuc 0)
boundary-Jet₁ = refl

boundary-Jet₂ : Jet 2 (pos 3) (pos 1) ≡ (negsuc 0 , pos 0)
boundary-Jet₂ = refl

boundary-Jet₃ : Jet 3 (pos 4) (pos 1) ≡ (pos 0 , pos 1)
boundary-Jet₃ = refl

------------------------------------------------------------------------
-- §3  the truncation residual is the boundary row
------------------------------------------------------------------------

-- window M = 3: exact through order 2 …
trunc₃-exact-1 : eqBox4 (JT 3 1) (Jet 1) ≡ true
trunc₃-exact-1 = refl

trunc₃-exact-2 : eqBox4 (JT 3 2) (Jet 2) ≡ true
trunc₃-exact-2 = refl

-- … and at order 3 the difference lives only on the rows |k₁| = 4
residual₃ : Field
residual₃ = Jet 3 +f negf (JT 3 3)

trunc₃-residual-rows : zeroRows (negsuc 2 ∷ negsuc 1 ∷ negsuc 0 ∷ pos 0 ∷ pos 1 ∷ pos 2 ∷ pos 3 ∷ []) residual₃ ≡ true
trunc₃-residual-rows = refl

trunc₃-residual-nonzero : residual₃ (pos 4) (pos 1) ≡ (pos 0 , pos 1)
trunc₃-residual-nonzero = refl

-- window M = 2: exact through order 1, residual at order 2 on |k₁| = 3
trunc₂-exact-1 : eqBox4 (JT 2 1) (Jet 1) ≡ true
trunc₂-exact-1 = refl

residual₂ : Field
residual₂ = Jet 2 +f negf (JT 2 2)

trunc₂-residual-rows : zeroRows (negsuc 1 ∷ negsuc 0 ∷ pos 0 ∷ pos 1 ∷ pos 2 ∷ pos 4 ∷ []) residual₂ ≡ true
trunc₂-residual-rows = refl

trunc₂-residual-nonzero : residual₂ (pos 3) (pos 1) ≡ (negsuc 0 , pos 0)
trunc₂-residual-nonzero = refl
