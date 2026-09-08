{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- अर्ध-तल — the half-plane.
--
-- The Hardy/Bergman geometry of the receiver zeros (handoff §58–60,
-- [S09]).  In the half-plane Re z < s the Hardy feature has
-- ⟨φ_z, φ_w⟩ = 1/(2s − z − w̄), norm² 1/(2d_z), d_z = s − Re z, and the
-- Bergman feature has the squared kernel.  Everything reduces to
-- polynomial identities in the real and imaginary parts, with
-- x_i = s − z_i, y_j = s − z̄_j for the Cauchy determinants:
--
--   १  |2s − z − w̄|² − |z − w|² = 4 d_z d_w,  so
--      |⟨h_z,h_w⟩|² = 1 − ρ²  and  |⟨F_z,F_w⟩| = 1 − ρ²,
--      ρ = |z − w| / |2s − z − w̄|;
--   २  on a reflection pair z, θz = −σ + iγ:
--      det Gram(h_z, h_θz) = σ²/s²  and  ‖F_z − F_θz‖² = 2σ²/s²;
--      the curvature readings 𝒫″(0)/4 = Σ w σ² = s² Σ w det = (s²/2) Σ w ‖·‖²
--      agree mode by mode;
--   ३  the holonomy defect of one mode:  e^{−2tσ} + e^{2tσ} − 2 = 4 sinh²(tσ);
--   ४  the Cauchy determinants (rows cleared of denominators):
--        2×2:  det = (x₂ − x₁)(y₂ − y₁),
--        3×3:  det = (x₂−x₁)(x₃−x₁)(x₃−x₂)(y₂−y₁)(y₃−y₁)(y₃−y₂),
--      which is  det C_F = Π_{i<j} ρ(z_i,z_j)²  for the normalized atoms
--      and the new-atom residual  dist² = Π_{w∈F} ρ(z,w)²  (Schur);
--   ५  the amplitude-weighted Vandermonde:  det V = Π a_i · Π_{i<j}(z_j − z_i).
------------------------------------------------------------------------
module ArdhaTala_TheHardyAndBergmanOverlapsOfTwoZerosAreOneMinusTheSameHyperbolicRatioTheReflectionPairReadsSigmaSquaredOverSSquaredInEveryReadingAndTheFiniteGramDeterminantIsTheProductOfTheRatios where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A = ⟨ R ⟩

  ι : ℕ → A
  ι zero    = 0r
  ι (suc n) = 1r + ι n

  ----------------------------------------------------------------
  -- १ · the overlap identity:  z = x + iy,  w = u + iv
  ----------------------------------------------------------------
  overlap-identity : (s x y u v : A)
    → (ι 2 · s + (- x) + (- u)) · (ι 2 · s + (- x) + (- u)) + (y + (- v)) · (y + (- v))
      ≡ ((x + (- u)) · (x + (- u)) + (y + (- v)) · (y + (- v))) + ι 4 · ((s + (- x)) · (s + (- u)))
  overlap-identity s x y u v = shape s x y u v
    where
      shape : (s x y u v : A)
        → ((1r + (1r + 0r)) · s + (- x) + (- u)) · ((1r + (1r + 0r)) · s + (- x) + (- u)) + (y + (- v)) · (y + (- v))
          ≡ ((x + (- u)) · (x + (- u)) + (y + (- v)) · (y + (- v))) + (1r + (1r + (1r + (1r + 0r)))) · ((s + (- x)) · (s + (- u)))
      shape s x y u v = solve! R

  ----------------------------------------------------------------
  -- २ · the reflection pair  z = σ + iγ,  θz = −σ + iγ
  ----------------------------------------------------------------
  -- 2s − z − θz̄ = 2s, d_z d_θz = (s − σ)(s + σ):  Gram det = 1 − (s−σ)(s+σ)/s²
  reflection-gram-determinant : (s σ : A) → s · s + (- ((s + (- σ)) · (s + σ))) ≡ σ · σ
  reflection-gram-determinant s σ = solve! R

  -- ‖F_z − F_θz‖² = 2 − 2⟨F_z,F_θz⟩ = 2 − 2(s−σ)(s+σ)/s²
  bergman-reflection-difference : (s σ : A)
    → ι 2 · (s · s) + (- (ι 2 · ((s + (- σ)) · (s + σ)))) ≡ ι 2 · (σ · σ)
  bergman-reflection-difference s σ = shape s σ
    where
      shape : (s σ : A) → (1r + (1r + 0r)) · (s · s) + (- ((1r + (1r + 0r)) · ((s + (- σ)) · (s + σ)))) ≡ (1r + (1r + 0r)) · (σ · σ)
      shape s σ = solve! R

  -- the three curvature readings agree mode by mode:
  -- 4σ² = 4 s² det = 2 s² ‖F_z − F_θz‖²
  curvature-readings : (s σ det diff : A)
    → (s · s) · det ≡ σ · σ → (s · s) · diff ≡ ι 2 · (σ · σ)
    → (ι 4 · (σ · σ) ≡ ι 4 · ((s · s) · det)) × (ι 4 · (σ · σ) ≡ ι 2 · ((s · s) · diff))
  curvature-readings s σ det diff hdet hdiff =
    cong (ι 4 ·_) (sym hdet) , (shape σ ∙ cong (ι 2 ·_) (sym hdiff))
    where
      shape : (σ : A) → (1r + (1r + (1r + (1r + 0r)))) · (σ · σ) ≡ (1r + (1r + 0r)) · ((1r + (1r + 0r)) · (σ · σ))
      shape σ = solve! R

  ----------------------------------------------------------------
  -- ३ · one mode's holonomy defect is 4 sinh²(tσ)
  ----------------------------------------------------------------
  sinh-defect : (c sh : A) → c · c ≡ 1r + sh · sh
    → ((c + (- sh)) · (c + (- sh)) + (c + sh) · (c + sh)) + (- ι 2) ≡ ι 4 · (sh · sh)
  sinh-defect c sh h = shape c sh ∙ cong (λ u → ι 2 · u + ι 2 · (sh · sh) + (- ι 2)) h ∙ shape' sh
    where
      shape : (c sh : A) → ((c + (- sh)) · (c + (- sh)) + (c + sh) · (c + sh)) + (- (1r + (1r + 0r)))
                           ≡ (1r + (1r + 0r)) · (c · c) + (1r + (1r + 0r)) · (sh · sh) + (- (1r + (1r + 0r)))
      shape c sh = solve! R
      shape' : (sh : A) → (1r + (1r + 0r)) · (1r + sh · sh) + (1r + (1r + 0r)) · (sh · sh) + (- (1r + (1r + 0r))) ≡ (1r + (1r + (1r + (1r + 0r)))) · (sh · sh)
      shape' sh = solve! R

  ----------------------------------------------------------------
  -- ४ · Cauchy determinants with the rows cleared of denominators
  ----------------------------------------------------------------
  cauchy-2 : (x₁ x₂ y₁ y₂ : A)
    → (x₁ + y₂) · (x₂ + y₁) + (- ((x₁ + y₁) · (x₂ + y₂)))
      ≡ (x₂ + (- x₁)) · (y₂ + (- y₁))
  cauchy-2 x₁ x₂ y₁ y₂ = solve! R

  -- entry (i,j) of the cleared matrix is Π_{k≠j} (x_i + y_k)
  cauchy-3 : (x₁ x₂ x₃ y₁ y₂ y₃ : A)
    → let m₁₁ = (x₁ + y₂) · (x₁ + y₃) ; m₁₂ = (x₁ + y₁) · (x₁ + y₃) ; m₁₃ = (x₁ + y₁) · (x₁ + y₂)
          m₂₁ = (x₂ + y₂) · (x₂ + y₃) ; m₂₂ = (x₂ + y₁) · (x₂ + y₃) ; m₂₃ = (x₂ + y₁) · (x₂ + y₂)
          m₃₁ = (x₃ + y₂) · (x₃ + y₃) ; m₃₂ = (x₃ + y₁) · (x₃ + y₃) ; m₃₃ = (x₃ + y₁) · (x₃ + y₂)
      in  (m₁₁ · (m₂₂ · m₃₃ + (- (m₂₃ · m₃₂))) + (- (m₁₂ · (m₂₁ · m₃₃ + (- (m₂₃ · m₃₁))))))
          + m₁₃ · (m₂₁ · m₃₂ + (- (m₂₂ · m₃₁)))
          ≡ ((x₂ + (- x₁)) · (x₃ + (- x₁)) · (x₃ + (- x₂))) · ((y₂ + (- y₁)) · (y₃ + (- y₁)) · (y₃ + (- y₂)))
  cauchy-3 x₁ x₂ x₃ y₁ y₂ y₃ = solve! R

  ----------------------------------------------------------------
  -- ५ · the amplitude-weighted Vandermonde
  ----------------------------------------------------------------
  vandermonde-2 : (a₁ a₂ z₁ z₂ : A)
    → a₁ · (a₂ · z₂) + (- ((a₁ · z₁) · a₂)) ≡ (a₁ · a₂) · (z₂ + (- z₁))
  vandermonde-2 a₁ a₂ z₁ z₂ = solve! R

  vandermonde-3 : (a₁ a₂ a₃ z₁ z₂ z₃ : A)
    → let v₁₁ = a₁ ; v₁₂ = a₁ · z₁ ; v₁₃ = a₁ · (z₁ · z₁)
          v₂₁ = a₂ ; v₂₂ = a₂ · z₂ ; v₂₃ = a₂ · (z₂ · z₂)
          v₃₁ = a₃ ; v₃₂ = a₃ · z₃ ; v₃₃ = a₃ · (z₃ · z₃)
      in  (v₁₁ · (v₂₂ · v₃₃ + (- (v₂₃ · v₃₂))) + (- (v₁₂ · (v₂₁ · v₃₃ + (- (v₂₃ · v₃₁))))))
          + v₁₃ · (v₂₁ · v₃₂ + (- (v₂₂ · v₃₁)))
          ≡ (a₁ · a₂ · a₃) · ((z₂ + (- z₁)) · (z₃ + (- z₁)) · (z₃ + (- z₂)))
  vandermonde-3 a₁ a₂ a₃ z₁ z₂ z₃ = solve! R
