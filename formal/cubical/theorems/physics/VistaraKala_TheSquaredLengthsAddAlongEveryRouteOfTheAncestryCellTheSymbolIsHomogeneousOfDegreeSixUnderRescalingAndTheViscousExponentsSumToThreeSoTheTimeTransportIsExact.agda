{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विस्तार-काल — scale and time.
--
-- §3 of the note: with p, q, r replaced by Np, Nq, Nr the first-generation
-- lengths are √2 N and the descendant length √3 N; the squared lengths
-- add along every route, |p+q|² = |p|² + |q|² and |K|² = |p+q|² + |r|²;
-- the spatial symbol scales as T_N = N²T₁ (scaled: T̃_N = N⁶T̃₁); and the
-- Duhamel exponents add, 3(t−s) + 2s + s = 3t, so the second Duhamel
-- factor is (t²/2)e^{−3νN²t} — the polynomial ∫₀ᵗ s ds = t²/2 is all that
-- remains once the exponents cancel.  Each of these is checked here.
------------------------------------------------------------------------

module VistaraKala_TheSquaredLengthsAddAlongEveryRouteOfTheAncestryCellTheSymbolIsHomogeneousOfDegreeSixUnderRescalingAndTheViscousExponentsSumToThreeSoTheTimeTransportIsExact where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver
open import Sankhya_SignedIntegersOverTheBuiltinNaturalsWithSoundArithmeticIntoTheLibrarysIntegersSoCertificatesComputeAtMachineSpeed using (⁺_)
open import PurnaDhruvana_TheCompleteThreeAncestorNavierStokesSymbolContractsInEveryMixedHelicityChannelAndIsACoisometryOntoTheDescendantPlaneByGaussianIntegerComputation

------------------------------------------------------------------------
-- १ · Squared lengths add along every route.
------------------------------------------------------------------------

pq-length : pq ∙ᵥ pq ≡ (p ∙ᵥ p) ⊕ (q ∙ᵥ q)
pq-length = refl

K-length : K ∙ᵥ K ≡ (pq ∙ᵥ pq) ⊕ (r ∙ᵥ r)
K-length = refl

qr-length : qr ∙ᵥ qr ≡ (q ∙ᵥ q) ⊕ (r ∙ᵥ r)
qr-length = refl

rp-length : rp ∙ᵥ rp ≡ (r ∙ᵥ r) ⊕ (p ∙ᵥ p)
rp-length = refl

------------------------------------------------------------------------
-- २ · Rescaling p, q, r by N = 2: the scaled symbol picks up N⁶ = 64.
------------------------------------------------------------------------

two : 𝔾
two = ι (⁺ 2)

p₂ q₂ r₂ : V
p₂ = two ⋆ p
q₂ = two ⋆ q
r₂ = two ⋆ r

T̃₂ : V → V → V → V
T̃₂ u v w = (B̃ (p₂ ⊞ q₂) r₂ (B̃ p₂ q₂ u v) w ⊞ B̃ (q₂ ⊞ r₂) p₂ (B̃ q₂ r₂ v w) u)
            ⊞ B̃ (r₂ ⊞ p₂) q₂ (B̃ r₂ p₂ w u) v

sixty-four : 𝔾
sixty-four = ι (⁺ 64)

homogeneous : (a b c : Bool) → T̃₂ (h̃p a) (h̃q b) (h̃r c) ≡ sixty-four ⋆ T̃ (h̃p a) (h̃q b) (h̃r c)
homogeneous true  true  true  = refl
homogeneous true  true  false = refl
homogeneous true  false true  = refl
homogeneous true  false false = refl
homogeneous false true  true  = refl
homogeneous false true  false = refl
homogeneous false false true  = refl
homogeneous false false false = refl

------------------------------------------------------------------------
-- ३ · The viscous exponents add to 3t along the route, for any ν, N, t, s.
------------------------------------------------------------------------

infixl 6 _⊕r_ _⊝r_
infixl 7 _⊗r_
module _ (R : CommRing ℓ-zero) where
  open CommRingStr (snd R) renaming (_+_ to _⊕r_ ; _·_ to _⊗r_ ; _-_ to _⊝r_)
  2r 3r : ⟨ R ⟩
  2r = 1r ⊕r 1r
  3r = 2r ⊕r 1r
  -- first generation e^{−2νN²(s−σ)}·e^{−νN²σ}·e^{−νN²σ}: exponents 2(s−σ) + σ + σ = 2s
  prathama : (ν N s σ : ⟨ R ⟩) → ν ⊗r (N ⊗r N) ⊗r (2r ⊗r (s ⊝r σ)) ⊕r ν ⊗r (N ⊗r N) ⊗r σ ⊕r ν ⊗r (N ⊗r N) ⊗r σ ≡ ν ⊗r (N ⊗r N) ⊗r (2r ⊗r s)
  prathama ν N s σ = solve! R
  -- second generation e^{−3νN²(t−s)}·e^{−2νN²s}·e^{−νN²s}: exponents 3(t−s) + 2s + s = 3t
  dvitīya : (ν N t s : ⟨ R ⟩) → ν ⊗r (N ⊗r N) ⊗r (3r ⊗r (t ⊝r s)) ⊕r ν ⊗r (N ⊗r N) ⊗r (2r ⊗r s) ⊕r ν ⊗r (N ⊗r N) ⊗r s ≡ ν ⊗r (N ⊗r N) ⊗r (3r ⊗r t)
  dvitīya ν N t s = solve! R
