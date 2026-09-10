{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अंश-विभाग — the partial fractions.
--
-- Theorem 3 of the note needs two exact sums over λ_k = 2k + ½:
--
--   Σ_{k≥0} −32/(λ_k(λ_k²−16)) = 352/105,
--   Σ_{k≥0} λ_k/(4(λ_k²−16)²)  = 3229/44100.
--
-- Both are telescoping: since λ_k ∓ 4 = λ_{k∓2},
--
--   −32/(λ(λ²−16)) = 2/λ − 1/(λ−4) − 1/(λ+4),
--   λ/(4(λ²−16)²)  = (1/64)(1/(λ−4)² − 1/(λ+4)²),
--
-- so the partial sums are four boundary terms minus four tail terms,
-- and the tails vanish in the limit.  Here:
--
--   §1  THE PARTIAL FRACTIONS as polynomial identities (cleared of
--       denominators), over any commutative ring.
--   §2  THE TELESCOPING of Σ_{k<K} (f(k−2) − f(k+2)) and of
--       Σ_{k<K} (2f(k) − f(k−2) − f(k+2)) over any abelian group, with
--       f indexed by integers, as exact finite identities.
--   §3  THE FOUR BOUNDARY TERMS, evaluated in ℚ: 352/105 and 3229/44100.
--
-- The passage from the finite identity to the infinite sum is the
-- vanishing of the tail f(K) → 0, which is the analytic trust boundary.
------------------------------------------------------------------------

module AmshaVibhaga_TheTwoRationalSumsOfTheArchimedeanEvaluatorArePartialFractionsThatTelescopeOnTheShiftedOddLatticeSoTheyAreFourBoundaryTerms where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
import Cubical.Data.Int as ℤ
open ℤ using (ℤ ; pos ; negsuc)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

------------------------------------------------------------------------
-- १ · Partial fractions, cleared of denominators.
------------------------------------------------------------------------

module _ (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  2r 4r 16r 32r 64r : ⟨ R ⟩
  2r = 1r + 1r
  4r = 2r + 2r
  16r = 4r · 4r
  32r = 16r · 2r
  64r = 32r · 2r

  -- −32 = 2(λ−4)(λ+4) − λ(λ+4) − λ(λ−4)
  aṃśa₁ : (l : ⟨ R ⟩) → - 32r ≡ 2r · ((l - 4r) · (l + 4r)) - l · (l + 4r) - l · (l - 4r)
  aṃśa₁ l = solve! R

  -- 16·λ = (λ+4)² − (λ−4)², i.e. λ/(4(λ²−16)²) = (1/64)(1/(λ−4)² − 1/(λ+4)²)
  aṃśa₂ : (l : ⟨ R ⟩) → 16r · l ≡ (l + 4r) · (l + 4r) - (l - 4r) · (l - 4r)
  aṃśa₂ l = solve! R

------------------------------------------------------------------------
-- २ · Telescoping over a commutative ring: gap 2 and gap 4.
------------------------------------------------------------------------

module Telescope (R : CommRing ℓ-zero) where
  open CommRingStr (snd R) renaming (_+_ to _⊕_ ; _-_ to _⊝_ ; _·_ to _⊗_)

  Σ⟨_⟩ : ℕ → (ℕ → ⟨ R ⟩) → ⟨ R ⟩
  Σ⟨ zero ⟩  h = 0r
  Σ⟨ suc K ⟩ h = Σ⟨ K ⟩ h ⊕ h K

  -- Σ_{k<K} (F k − F (k+2)) + F K + F (K+1) = F 0 + F 1
  tele₂ : (F : ℕ → ⟨ R ⟩) (K : ℕ)
        → (Σ⟨ K ⟩ (λ k → F k ⊝ F (suc (suc k))) ⊕ F K) ⊕ F (suc K) ≡ F 0 ⊕ F 1
  tele₂ F zero    = lemma (F 0) (F 1)
    where lemma : (a b : ⟨ R ⟩) → (0r ⊕ a) ⊕ b ≡ a ⊕ b
          lemma a b = solve! R
  tele₂ F (suc K) = step ∙ tele₂ F K
    where
    step : ((Σ⟨ K ⟩ (λ k → F k ⊝ F (suc (suc k))) ⊕ (F K ⊝ F (suc (suc K)))) ⊕ F (suc K)) ⊕ F (suc (suc K))
         ≡ (Σ⟨ K ⟩ (λ k → F k ⊝ F (suc (suc k))) ⊕ F K) ⊕ F (suc K)
    step = lemma _ (F K) (F (suc K)) (F (suc (suc K)))
      where lemma : (S a b c : ⟨ R ⟩) → ((S ⊕ (a ⊝ c)) ⊕ b) ⊕ c ≡ (S ⊕ a) ⊕ b
            lemma S a b c = solve! R

  -- Σ_{k<K} (F k − F (k+4)) + F K + … + F (K+3) = F 0 + F 1 + F 2 + F 3
  tele₄ : (F : ℕ → ⟨ R ⟩) (K : ℕ)
        → (((Σ⟨ K ⟩ (λ k → F k ⊝ F (suc (suc (suc (suc k))))) ⊕ F K) ⊕ F (suc K)) ⊕ F (suc (suc K))) ⊕ F (suc (suc (suc K)))
        ≡ ((F 0 ⊕ F 1) ⊕ F 2) ⊕ F 3
  tele₄ F zero    = lemma (F 0) (F 1) (F 2) (F 3)
    where lemma : (a b c d : ⟨ R ⟩) → (((0r ⊕ a) ⊕ b) ⊕ c) ⊕ d ≡ ((a ⊕ b) ⊕ c) ⊕ d
          lemma a b c d = solve! R
  tele₄ F (suc K) = step ∙ tele₄ F K
    where
    step : (((( Σ⟨ K ⟩ (λ k → F k ⊝ F (suc (suc (suc (suc k))))) ⊕ (F K ⊝ F (suc (suc (suc (suc K)))))) ⊕ F (suc K)) ⊕ F (suc (suc K))) ⊕ F (suc (suc (suc K)))) ⊕ F (suc (suc (suc (suc K))))
         ≡ (((Σ⟨ K ⟩ (λ k → F k ⊝ F (suc (suc (suc (suc k))))) ⊕ F K) ⊕ F (suc K)) ⊕ F (suc (suc K))) ⊕ F (suc (suc (suc K)))
    step = lemma _ (F K) (F (suc K)) (F (suc (suc K))) (F (suc (suc (suc K))) ) (F (suc (suc (suc (suc K)))))
      where lemma : (S a b c d e : ⟨ R ⟩) → ((((S ⊕ (a ⊝ e)) ⊕ b) ⊕ c) ⊕ d) ⊕ e ≡ (((S ⊕ a) ⊕ b) ⊕ c) ⊕ d
            lemma S a b c d e = solve! R

  -- the first series' summand 2F(k+2) − F k − F(k+4) is a difference of two gap-2 terms
  dvi-antara : (F : ⟨ R ⟩ → ⟨ R ⟩) (a b c : ⟨ R ⟩)
             → (2r R ⊗ b) ⊝ a ⊝ c ≡ (b ⊝ c) ⊝ (a ⊝ b)
  dvi-antara F a b c = solve! R

------------------------------------------------------------------------
-- ३ · The boundary terms in ℚ.  F k = 1/λ_{k−2}: F 0 = −2/7, F 1 = −2/3,
--     F (k+2) = 2/(4k+1).  First series: F 2 + F 3 − F 0 − F 1 = 352/105.
--     Second: (F 0² + F 1² + F 2² + F 3²)/64 = 51664/705600 = 3229/44100.
------------------------------------------------------------------------

open import Cubical.Data.NatPlusOne using (ℕ₊₁ ; 1+_ ; _·₊₁_)
open import Cubical.Data.Rationals

F : ℕ → ℚ
F zero          = [ negsuc 1 / 1+ 6 ]
F (suc zero)    = [ negsuc 1 / 1+ 2 ]
F (suc (suc k)) = [ pos 2 / 1+ (4 Cubical.Data.Nat.· k) ]

-- 2 + 2/5 + 2/7 + 2/3 = 352/105, on representatives by computation
prathama : ((F 2 + F 3) - F 0) - F 1 ≡ [ pos 352 / 1+ 104 ]
prathama = refl

-- (4/49 + 4/9 + 4 + 4/25) = 51664/11025, then /64 = 51664/705600
dvitīya : (((F 0 · F 0) + (F 1 · F 1)) + (F 2 · F 2)) + (F 3 · F 3) ≡ [ pos 51664 / 1+ 11024 ]
dvitīya = refl

-- and 51664/705600 = 3229/44100: cancelling the common factor 16 exactly
cancel : (k : ℕ) (a : ℤ) (m : ℕ) → [ pos (suc k) ℤ.· a / (1+ k) ·₊₁ (1+ m) ] ≡ [ a / 1+ m ]
cancel k a m = eq/ _ _ sākṣī
  where
  sākṣī : (pos (suc k) ℤ.· a) ℤ.· pos (suc m) ≡ a ℤ.· pos (suc k Cubical.Data.Nat.· suc m)
  sākṣī = cong (ℤ._· pos (suc m)) (ℤ.·Comm (pos (suc k)) a)
        ∙ sym (ℤ.·Assoc a (pos (suc k)) (pos (suc m)))
        ∙ cong (a ℤ.·_) (sym (ℤ.pos·pos (suc k) (suc m)))

tṛtīya : [ pos 51664 / 1+ 705599 ] ≡ [ pos 3229 / 1+ 44099 ]
tṛtīya = cancel 15 (pos 3229) 44099
