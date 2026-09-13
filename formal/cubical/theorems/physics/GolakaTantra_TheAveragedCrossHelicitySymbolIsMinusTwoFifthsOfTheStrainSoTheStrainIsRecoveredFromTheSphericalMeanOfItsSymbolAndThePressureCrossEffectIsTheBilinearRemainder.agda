{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- गोलक-तन्त्र — the sphere's loom (strain tomography).
--
-- Uses the contractions of GolakaMatra:  with the averaged tensors
--     15·⟨nᵢnⱼ⟩ = 5δᵢⱼ,   15·⟨nᵢnⱼnₖnₗ⟩ = δᵢⱼδₖₗ + δᵢₖδⱼₗ + δᵢₗδⱼₖ
-- and the cross-helicity symbol  q_u(n) = −P_n S P_n − ½(nᵀSn)P_n,
--     30·⟨q⟩ ≡ −11 S − Sᵀ − 6 (tr S) I,
-- so for symmetric trace-free S,  30⟨q⟩ = −12 S:  S = −(5/2)⟨q_u⟩
-- (handoff §18, [S11]).  Also the pressure cross-effect of §20:
--     7H[u] + 2(S²)₀ = 7(2H(u₂,u⊥) + H[u⊥])   when  7H[u₂] = −2(S²)₀.
------------------------------------------------------------------------
module GolakaTantra_TheAveragedCrossHelicitySymbolIsMinusTwoFifthsOfTheStrainSoTheStrainIsRecoveredFromTheSphericalMeanOfItsSymbolAndThePressureCrossEffectIsTheBilinearRemainder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import GolakaMatra_TheFourthMomentOfTheSphereContractsToTheSymmetrizedEntryPlusTraceTimesIdentityAndTheSecondMomentContractsToFiveTimesTheEntry

private
  variable
    ℓ : Level

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A = ⟨ R ⟩

  open Contractions R

  -- 15·⟨(P_n S P_n)ᵢₗ⟩
  PSP15 : Mat → Mat
  PSP15 S i l =
      ((ι 15 · S i l + (- (Σ₃ (λ j → (ι 5 · δ i j) · S j l))))
       + (- (Σ₃ (λ k → S i k · (ι 5 · δ k l)))))
    + Σ₃ (λ j → Σ₃ (λ k → m4 i j k l · S j k))

  -- 15·⟨(nᵀSn)(P_n)ᵢₗ⟩
  nSnP15 : Mat → Mat
  nSnP15 S i l =
      (Σ₃ (λ j → Σ₃ (λ k → S j k · (ι 5 · δ j k)))) · δ i l
    + (- (Σ₃ (λ j → Σ₃ (λ k → m4 i j k l · S j k))))

  -- 30·⟨q_u⟩  with  q_u = −P S P − ½ (nᵀSn) P
  q30 : Mat → Mat
  q30 S i l = (- (ι 2 · PSP15 S i l)) + (- (nSnP15 S i l))

  -- general S:  30⟨q⟩ = −11 S − Sᵀ − 6 (tr S) I
  tomography : (a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ : A) (i l : Ix)
    → let S = mat a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ in
      q30 S i l ≡ (- (ι 11 · S i l + S l i)) + (- (ι 6 · (tr S · δ i l)))
  tomography a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ i l =
      cong₂ (λ u v → (- (ι 2 · u)) + (- v))
            (cong₂ (λ u v → ((ι 15 · S i l + (- u)) + (- v)) + Σ₃ (λ j → Σ₃ (λ k → m4 i j k l · S j k)))
                   (left5 a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ i l) (right5 a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ i l)
             ∙ cong (((ι 15 · S i l + (- (ι 5 · S i l))) + (- (ι 5 · S i l))) +_) (fourth-contraction a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ i l))
            (cong₂ (λ u v → u · δ i l + (- v)) (trace5 a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃) (fourth-contraction a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ i l))
    ∙ shape (S i l) (S l i) (tr S) (δ i l)
    where
      S = mat a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃
      shape : (x y t d : A)
        → (- ((1r + (1r + 0r)) · ((((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))))))) · x + (- ((1r + (1r + (1r + (1r + (1r + 0r))))) · x))) + (- ((1r + (1r + (1r + (1r + (1r + 0r))))) · x))) + ((x + y) + d · t))))
          + (- (((1r + (1r + (1r + (1r + (1r + 0r))))) · t) · d + (- ((x + y) + d · t))))
          ≡ (- ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))) · x + y)) + (- ((1r + (1r + (1r + (1r + (1r + (1r + 0r)))))) · (t · d)))
      shape x y t d = solve! R

  -- symmetric trace-free S:  30⟨q⟩ = −12 S,  i.e.  S = −(5/2)⟨q_u⟩
  tomography-tracefree : (a₁₁ a₁₂ a₁₃ a₂₂ a₂₃ a₃₃ : A) → let S = symm a₁₁ a₁₂ a₁₃ a₂₂ a₂₃ a₃₃ in tr S ≡ 0r
    → (i l : Ix) → q30 S i l ≡ - (ι 12 · S i l)
  tomography-tracefree a₁₁ a₁₂ a₁₃ a₂₂ a₂₃ a₃₃ h i l =
      tomography a₁₁ a₁₂ a₁₃ a₁₂ a₂₂ a₂₃ a₁₃ a₂₃ a₃₃ i l
    ∙ cong (λ u → (- (ι 11 · S i l + S l i)) + (- (ι 6 · (u · δ i l)))) h
    ∙ cong (λ u → (- (ι 11 · S i l + u)) + (- (ι 6 · (0r · δ i l)))) (symmetric i l)
    ∙ finish (S i l) (δ i l)
    where
      S = symm a₁₁ a₁₂ a₁₃ a₂₂ a₂₃ a₃₃
      symmetric : (i l : Ix) → S l i ≡ S i l
      symmetric i₁ i₁ = refl
      symmetric i₁ i₂ = refl
      symmetric i₁ i₃ = refl
      symmetric i₂ i₁ = refl
      symmetric i₂ i₂ = refl
      symmetric i₂ i₃ = refl
      symmetric i₃ i₁ = refl
      symmetric i₃ i₂ = refl
      symmetric i₃ i₃ = refl
      finish : (x d : A) → (- ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))) · x + x)) + (- ((1r + (1r + (1r + (1r + (1r + (1r + 0r)))))) · (0r · d))) ≡ - ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))))))) · x)
      finish x d = solve! R

  ----------------------------------------------------------------
  -- ३ · the pressure cross-effect
  ----------------------------------------------------------------
  module _ (H : A → A → A)
           (H-addL : (a b c : A) → H (a + b) c ≡ H a c + H b c)
           (H-addR : (a b c : A) → H a (b + c) ≡ H a b + H a c)
           (H-sym  : (a b : A) → H a b ≡ H b a)
           where

    cross-effect : (a b : A) → H (a + b) (a + b) ≡ (H a a + ι 2 · H a b) + H b b
    cross-effect a b =
        H-addL a b (a + b)
      ∙ cong₂ _+_ (H-addR a a b) (H-addR b a b ∙ cong (_+ H b b) (H-sym b a))
      ∙ shape (H a a) (H a b) (H b b)
      where
        shape : (p q r : A) → (p + q) + (q + r) ≡ (p + (1r + (1r + 0r)) · q) + r
        shape p q r = solve! R

    -- 7H[u₂] = −2(S²)₀  ⟹  7H[u] + 2(S²)₀ = 7(2H(u₂,u⊥) + H[u⊥])
    pressure-residual : (u₂ u⊥ S² : A) → ι 7 · H u₂ u₂ ≡ - (ι 2 · S²)
      → ι 7 · H (u₂ + u⊥) (u₂ + u⊥) + ι 2 · S² ≡ ι 7 · (ι 2 · H u₂ u⊥ + H u⊥ u⊥)
    pressure-residual u₂ u⊥ S² h =
        cong (λ u → ι 7 · u + ι 2 · S²) (cross-effect u₂ u⊥)
      ∙ shape (H u₂ u₂) (H u₂ u⊥) (H u⊥ u⊥) S²
      ∙ cong (λ u → (u + ι 2 · S²) + ι 7 · (ι 2 · H u₂ u⊥ + H u⊥ u⊥)) h
      ∙ finish (S²) (ι 2 · H u₂ u⊥ + H u⊥ u⊥)
      where
        shape : (p q r s : A) → (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))) · ((p + (1r + (1r + 0r)) · q) + r) + (1r + (1r + 0r)) · s ≡ ((1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))) · p + (1r + (1r + 0r)) · s) + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))) · ((1r + (1r + 0r)) · q + r)
        shape p q r s = solve! R
        finish : (s w : A) → ((- ((1r + (1r + 0r)) · s)) + (1r + (1r + 0r)) · s) + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))) · w ≡ (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))) · w
        finish s w = solve! R
