{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- प्रतिरोध — the impedance.
--
-- The finite identities under the positive-real/Stieltjes reading of
-- the receiver (handoff §61, [S02],[S14]) and the Goldbach dyadic
-- normalization (§63, [S22]):
--
--   १  one spectral mode of the Laplace impedance,  1/(w − iγ)  at
--      w = x + iy, has real part  x/(x² + (y−γ)²):
--         (x + i(y−γ))(x − i(y−γ)) = x² + (y−γ)²  and the real part of
--         the numerator is x;
--   २  pairing ±γ:  1/(w−iγ) + 1/(w+iγ) = 2w/(w² + γ²),  so
--         𝒮(q) = Y(√q)/√q = Σ p/(q + λ),  λ = γ²  (Stieltjes form);
--   ३  the Cayley coefficient (α − Y)/(α + Y) is contractive exactly
--      when Re(ᾱY) ≥ 0:   |α + Y|² − |α − Y|² = 4 Re(ᾱ Y);
--   ४  the dyadic Goldbach normalization:  with 𝒢(t) = t² G_R(t),
--         4t²(G_R(2t) − ¼G_R(t)) = 𝒢(2t) − 𝒢(t),  and  𝒢 = (tA)²  when
--         G_R = A².
------------------------------------------------------------------------
module Pratirodha_OneSpectralModeOfTheImpedanceHasRealPartXOverXSquaredPlusTheOffsetSquaredThePairedModesAreAStieltjesTermTheCayleyCoefficientIsContractiveExactlyOnTheRightHalfPlaneAndTheDyadicGoldbachResidualIsTheNormalizedDifference where

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

  -- complex numbers as pairs (re, im)
  ℂ : Type ℓ
  ℂ = A × A

  _⊗_ : ℂ → ℂ → ℂ
  (a , b) ⊗ (c , d) = (a · c + (- (b · d))) , (a · d + b · c)

  conj : ℂ → ℂ
  conj (a , b) = a , (- b)

  ∣_∣² : ℂ → A
  ∣ (a , b) ∣² = a · a + b · b

  ----------------------------------------------------------------
  -- १ · one mode:  (w − iγ) · conj(w − iγ) = |w − iγ|²,  real part x
  ----------------------------------------------------------------
  mode-denominator : (x y γ : A)
    → (x , y + (- γ)) ⊗ conj (x , y + (- γ)) ≡ (x · x + (y + (- γ)) · (y + (- γ)) , 0r)
  mode-denominator x y γ = λ t → (p t , q t)
    where
      p : x · x + (- ((y + (- γ)) · (- (y + (- γ))))) ≡ x · x + (y + (- γ)) · (y + (- γ))
      p = solve! R
      q : x · (- (y + (- γ))) + (y + (- γ)) · x ≡ 0r
      q = solve! R

  -- so  1/(w − iγ) = conj(w − iγ)/|w − iγ|²  has real part  x/|w − iγ|²  (x > 0 for x > 0)
  mode-real-part : (x y γ : A) → fst (conj (x , y + (- γ))) ≡ x
  mode-real-part x y γ = refl

  ----------------------------------------------------------------
  -- २ · the ±γ pair is a Stieltjes term
  ----------------------------------------------------------------
  -- (w + iγ) + (w − iγ) = 2w  and  (w − iγ)(w + iγ) = w² + γ²  (w real here: q = w²)
  paired-modes : (w γ : A)
    → ((w , γ) ⊗ (w , - γ) ≡ (w · w + γ · γ , 0r)) × ((w , γ) ⊗ (1r , 0r) ≡ (w , γ))
  paired-modes w γ = (λ t → (p t , q t)) , (λ t → (r t , s t))
    where
      p : w · w + (- (γ · (- γ))) ≡ w · w + γ · γ
      p = solve! R
      q : w · (- γ) + γ · w ≡ 0r
      q = solve! R
      r : w · 1r + (- (γ · 0r)) ≡ w
      r = solve! R
      s : w · 0r + γ · 1r ≡ γ
      s = solve! R

  stieltjes-numerator : (w γ : A) → (w + γ) + (w + (- γ)) ≡ ι 2 · w
  stieltjes-numerator w γ = shape w γ
    where shape : (w γ : A) → (w + γ) + (w + (- γ)) ≡ (1r + (1r + 0r)) · w
          shape w γ = solve! R

  ----------------------------------------------------------------
  -- ३ · the Cayley coefficient
  ----------------------------------------------------------------
  cayley : (α Y : ℂ) → ∣ (fst α + fst Y , snd α + snd Y) ∣² + (- ∣ (fst α + (- fst Y) , snd α + (- snd Y)) ∣²)
                       ≡ ι 4 · fst (conj α ⊗ Y)
  cayley (a , b) (c , d) = shape a b c d
    where
      shape : (a b c d : A)
        → ((a + c) · (a + c) + (b + d) · (b + d)) + (- ((a + (- c)) · (a + (- c)) + (b + (- d)) · (b + (- d))))
          ≡ (1r + (1r + (1r + (1r + 0r)))) · (a · c + (- ((- b) · d)))
      shape a b c d = solve! R

  ----------------------------------------------------------------
  -- ४ · the dyadic Goldbach normalization
  ----------------------------------------------------------------
  -- 4t²·(G_R(2t) − ¼G_R(t)) = 𝒢(2t) − 𝒢(t):  cleared of the quarter,
  -- 4·[(2t)²G₂ − t²G₁]/4 … stated as   (2t)² G₂ − t² G₁ ≡ 4t² G₂ − t² G₁
  dyadic-normalization : (t G₁ G₂ : A)
    → ((ι 2 · t) · (ι 2 · t)) · G₂ + (- ((t · t) · G₁)) ≡ (ι 4 · ((t · t) · G₂)) + (- ((t · t) · G₁))
  dyadic-normalization t G₁ G₂ = shape t G₁ G₂
    where
      shape : (t G₁ G₂ : A)
        → (((1r + (1r + 0r)) · t) · ((1r + (1r + 0r)) · t)) · G₂ + (- ((t · t) · G₁))
          ≡ ((1r + (1r + (1r + (1r + 0r)))) · ((t · t) · G₂)) + (- ((t · t) · G₁))
      shape t G₁ G₂ = solve! R

  -- 𝒢 = (tA)²  when  G_R = A²
  normalized-square : (t Aₜ : A) → (t · t) · (Aₜ · Aₜ) ≡ (t · Aₜ) · (t · Aₜ)
  normalized-square t Aₜ = solve! R
