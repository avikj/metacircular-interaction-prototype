{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- ����-�� � the half-plane.
--
-- The Hardy/Bergman geometry of the receiver zeros (handoff §58�60,
-- [S09]).  In the half-plane Re z < s the Hardy feature has
-- ⟨�_z, �_w⟩ = 1/(2s − z − w�), norm² 1/(2d_z), d_z = s − Re z, and the
-- Bergman feature has the squared kernel.  Everything reduces to
-- polynomial identities in the real and imaginary parts, with
-- x_i = s − z_i, y_j = s − z�_j for the Cauchy determinants:
--
--   �  |2s − z − w�|² − |z − w|² = 4 d_z d_w,  so
--      |⟨h_z,h_w⟩|² = 1 − �²  and  |⟨F_z,F_w⟩| = 1 − �²,
--      � = |z − w| / |2s − z − w�|;
--   �  on a reflection pair z, �z = −� + iγ:
--      det Gram(h_z, h_�z) = �²/s²  and  �F_z − F_�z�² = 2�²/s²;
--      the curvature readings ��(0)/4 = � w �² = s² � w det = (s²/2) � w ���²
--      agree mode by mode;
--   �  the holonomy defect of one mode:  e^{−2t�} + e^{2t�} − 2 = 4 sinh²(t�);
--   �  the Cauchy determinants (rows cleared of denominators):
--        2�2:  det = (x� − x�)(y� − y�),
--        3�3:  det = (x�−x�)(x�−x�)(x�−x�)(y�−y�)(y�−y�)(y�−y�),
--      which is  det C_F = Π_{i<j} �(z_i,z_j)²  for the normalized atoms
--      and the new-atom residual  dist² = Π_{w∈F} �(z,w)²  (Schur);
--   �  the amplitude-weighted Vandermonde:  det V = Π a_i � Π_{i<j}(z_j − z_i);
--   �  the polarized pair coordinates of §56 are jointly invertible and
--      the pair exponent (z+w)C + (w−z)D is zT + wU.
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
  -- � � the overlap identity:  z = x + iy,  w = u + iv
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
  -- � � the reflection pair  z = � + iγ,  �z = −� + iγ
  ----------------------------------------------------------------
  -- 2s − z − �z� = 2s, d_z d_�z = (s − �)(s + �):  Gram det = 1 − (s−�)(s+�)/s²
  reflection-gram-determinant : (s σ : A) → s · s + (- ((s + (- σ)) · (s + σ))) ≡ σ · σ
  reflection-gram-determinant s σ = solve! R

  -- �F_z − F_�z�² = 2 − 2⟨F_z,F_�z⟩ = 2 − 2(s−�)(s+�)/s²
  bergman-reflection-difference : (s σ : A)
    → ι 2 · (s · s) + (- (ι 2 · ((s + (- σ)) · (s + σ)))) ≡ ι 2 · (σ · σ)
  bergman-reflection-difference s σ = shape s σ
    where
      shape : (s σ : A) → (1r + (1r + 0r)) · (s · s) + (- ((1r + (1r + 0r)) · ((s + (- σ)) · (s + σ)))) ≡ (1r + (1r + 0r)) · (σ · σ)
      shape s σ = solve! R

  -- the three curvature readings agree mode by mode:
  -- 4�² = 4 s² det = 2 s² �F_z − F_�z�²
  curvature-readings : (s σ det diff : A)
    → (s · s) · det ≡ σ · σ → (s · s) · diff ≡ ι 2 · (σ · σ)
    → (ι 4 · (σ · σ) ≡ ι 4 · ((s · s) · det)) × (ι 4 · (σ · σ) ≡ ι 2 · ((s · s) · diff))
  curvature-readings s σ det diff hdet hdiff =
    cong (ι 4 ·_) (sym hdet) , (shape σ ∙ cong (ι 2 ·_) (sym hdiff))
    where
      shape : (σ : A) → (1r + (1r + (1r + (1r + 0r)))) · (σ · σ) ≡ (1r + (1r + 0r)) · ((1r + (1r + 0r)) · (σ · σ))
      shape σ = solve! R

  ----------------------------------------------------------------
  -- � � one mode's holonomy defect is 4 sinh²(t�)
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
  -- � � Cauchy determinants with the rows cleared of denominators
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
  -- � � the amplitude-weighted Vandermonde
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

  ----------------------------------------------------------------
  -- � � the polarized pair coordinates of §56:  � = z + w, Δ = w − z,
  --     C = (T + U)/2, D = (U − T)/2  are jointly invertible and
  --     (z + w) C + (w − z) D = z T + w U
  ----------------------------------------------------------------
  pair-exponent : (z w T U C D : A) → ι 2 · C ≡ T + U → ι 2 · D ≡ U + (- T)
    → ι 2 · ((z + w) · C + (w + (- z)) · D) ≡ ι 2 · (z · T + w · U)
  pair-exponent z w T U C D hC hD =
      shape z w C D
    ∙ cong₂ (λ u v → (z + w) · u + (w + (- z)) · v) hC hD
    ∙ shape' z w T U
    where
      shape : (z w C D : A) → (1r + (1r + 0r)) · ((z + w) · C + (w + (- z)) · D) ≡ (z + w) · ((1r + (1r + 0r)) · C) + (w + (- z)) · ((1r + (1r + 0r)) · D)
      shape z w C D = solve! R
      shape' : (z w T U : A) → (z + w) · (T + U) + (w + (- z)) · (U + (- T)) ≡ (1r + (1r + 0r)) · (z · T + w · U)
      shape' z w T U = solve! R

  joint-inversion : (z w : A) → (ι 2 · z ≡ (z + w) + (- (w + (- z)))) × (ι 2 · w ≡ (z + w) + (w + (- z)))
  joint-inversion z w = shape₁ z w , shape₂ z w
    where
      shape₁ : (z w : A) → (1r + (1r + 0r)) · z ≡ (z + w) + (- (w + (- z)))
      shape₁ z w = solve! R
      shape₂ : (z w : A) → (1r + (1r + 0r)) · w ≡ (z + w) + (w + (- z))
      shape₂ z w = solve! R
