{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ग्राही-विभाजन — the receiver split on its knots.
--
-- The note's §5: with q = 4·1_{[0,1/4]}, f = e^{−4s}(q∗q), g = f∗f̃, the
-- receiver g is piecewise
--
--   0 ≤ t ≤ ¼:  g = [(4t−1)e⁻⁴ + (8t−4)e⁻²] e^{4t} + (8te⁻² + 4t + 1) e^{−4t},
--   ¼ ≤ t ≤ ½:  g = (3−4t) e⁻⁴ e^{4t} + (1−4t) e^{−4t},
--
-- and (5.1) says (D² − 16)² g = Σ_{j=−2}^{2} b_j δ_{j/4}, equivalently
-- g(t) = Σ_j b_j E(t − j/4) with E(x) = (1 + 4|x|)e^{−4|x|}/256 the
-- fundamental solution, b_0 = 256(1 + 4e⁻² + e⁻⁴), b_{±1} = −512e⁻¹(1+e⁻²),
-- b_{±2} = 256e⁻².  On each piece the absolute values resolve, and the
-- identity g = Σ b_j E(· − x_j) becomes a POLYNOMIAL identity in
-- t, ε = e⁻¹ and y = e^{4t} (after clearing y⁻¹ and ε⁻¹).  Those two
-- identities are proved here over any commutative ring by the solver;
-- with E the fundamental solution of (D²−16)² they are (5.1).
------------------------------------------------------------------------

module GrahiVibhajana_TheArithmeticWeilReceiverIsTheBiHelmholtzGreensFunctionOnFiveKnotsSoTheDistributionalIdentityIsTwoPolynomialIdentities where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module _ (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)

  -- small constants as sums of 1r
  2r 3r 4r 8r : ⟨ R ⟩
  2r = 1r + 1r
  3r = 2r + 1r
  4r = 2r + 2r
  8r = 4r + 4r
  256r : ⟨ R ⟩
  256r = 8r · 8r · 4r
  512r : ⟨ R ⟩
  512r = 256r · 2r

  -- the knot weights, ε = e⁻¹
  b₀ b₁ b₂ : ⟨ R ⟩ → ⟨ R ⟩
  b₀ ε = 256r · (1r + 4r · (ε · ε) + (ε · ε) · (ε · ε))
  b₁ ε = - (512r · ε · (1r + ε · ε))
  b₂ ε = 256r · (ε · ε)

  -- piece one, 0 ≤ t ≤ ¼, everything multiplied by 256·y:
  --   256·y·g(t) = b₀(1+4t) + b₋₁(2+4t)ε + b₋₂(3+4t)ε² + b₁(2−4t)ε y² + b₂(3−4t)ε² y²
  g₁ : ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩          -- 256·y·g on [0,¼], as a polynomial
  g₁ t ε y = 256r · (((4r · t - 1r) · (ε · ε) · (ε · ε) + (8r · t - 4r) · (ε · ε)) · (y · y)
                     + (8r · t · (ε · ε) + 4r · t + 1r))

  knots₁ : ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩
  knots₁ t ε y = b₀ ε · (1r + 4r · t)
               + b₁ ε · (2r + 4r · t) · ε
               + b₂ ε · (3r + 4r · t) · (ε · ε)
               + b₁ ε · (2r - 4r · t) · ε · (y · y)
               + b₂ ε · (3r - 4r · t) · (ε · ε) · (y · y)

  piece-one : (t ε y : ⟨ R ⟩) → g₁ t ε y ≡ knots₁ t ε y
  piece-one t ε y = solve! R

  -- piece two, ¼ ≤ t ≤ ½, multiplied by 256·y·ε (the knot j = 1 now lies below t):
  --   256·y·ε·g = ε[b₀(1+4t) + b₋₁(2+4t)ε + b₋₂(3+4t)ε²] + b₁(4t)·1 + b₂(3−4t)ε³ y²
  g₂ : ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩          -- 256·y·ε·g on [¼,½]
  g₂ t ε y = 256r · ε · ((3r - 4r · t) · (ε · ε) · (ε · ε) · (y · y) + (1r - 4r · t))

  knots₂ : ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩
  knots₂ t ε y = ε · (b₀ ε · (1r + 4r · t) + b₁ ε · (2r + 4r · t) · ε + b₂ ε · (3r + 4r · t) · (ε · ε))
               + b₁ ε · (4r · t)
               + b₂ ε · (3r - 4r · t) · (ε · ε · ε) · (y · y)

  piece-two : (t ε y : ⟨ R ⟩) → g₂ t ε y ≡ knots₂ t ε y
  piece-two t ε y = solve! R
