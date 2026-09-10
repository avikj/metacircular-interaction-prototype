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
import Cubical.Data.Nat
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

-- (4/49 + 4/9 + 4 + 4/25) = 51664/11025, on representatives by computation.
-- The sum of squares is named and kept opaque: its one computation (≈ 10⁵
-- unary sucℤ steps) happens here, inside the abstract block, and outside
-- it every comparison against Σ² is structural.
abstract
  Σ² : ℚ
  Σ² = (((F 0 · F 0) + (F 1 · F 1)) + (F 2 · F 2)) + (F 3 · F 3)

  dvitīya : Σ² ≡ [ pos 51664 / 1+ 11024 ]
  dvitīya = refl

-- (1/64) · (51664/11025) = 51664/705600, on representatives: the ℤ
-- product pos 1 · pos 51664 is one step, the ℕ₊₁ product is builtin.
caturtha : [ pos 1 / 1+ 63 ] · [ pos 51664 / 1+ 11024 ] ≡ [ pos 51664 / 1+ 705599 ]
caturtha = refl

-- and 51664/705600 = 3229/44100: cancelling the common factor 16.
--
-- The library's ℤ product is unary (pos (suc n) · m = m + pos n · m, and
-- _+_ iterates sucℤ), and Agda's conversion checker unfolds any ℤ
-- product it meets in a type, so a cross-multiplication of size 10⁹
-- can never appear in a signature.  The cancellation is therefore a
-- lemma whose only numeric hypotheses are equations between builtin
-- ℕ literals, which Agda's primitive arithmetic decides at once; the
-- ℤ products live only inside the generic proof.
sāmya : (n m k l M L : ℕ) → suc m ≡ M → suc l ≡ L
      → n Cubical.Data.Nat.· L ≡ k Cubical.Data.Nat.· M
      → [ pos n / 1+ m ] ≡ [ pos k / 1+ l ]
sāmya n m k l M L pM pL h = eq/ (pos n , 1+ m) (pos k , 1+ l) sākṣī
  where
  sākṣī : pos n ℤ.· pos (suc l) ≡ pos k ℤ.· pos (suc m)
  sākṣī = sym (ℤ.pos·pos n (suc l))
        ∙ cong (λ z → pos (n Cubical.Data.Nat.· z)) pL
        ∙ cong pos h
        ∙ cong (λ z → pos (k Cubical.Data.Nat.· z)) (sym pM)
        ∙ ℤ.pos·pos k (suc m)

tṛtīya : [ pos 51664 / 1+ 705599 ] ≡ [ pos 3229 / 1+ 44099 ]
tṛtīya = sāmya 51664 705599 3229 44099 705600 44100 refl refl refl

-- The second series, assembled: (1/64)(F 0² + F 1² + F 2² + F 3²) = 3229/44100.
dvitīya-sīmā : [ pos 1 / 1+ 63 ] · Σ² ≡ [ pos 3229 / 1+ 44099 ]
dvitīya-sīmā = cong ([ pos 1 / 1+ 63 ] ·_) dvitīya ∙ caturtha ∙ tṛtīya
