{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सर्व-ग्राही — the receiver that takes everything.
--
-- The proof note's elementary receiver is h = e^{−s} b(s−1) with b the
-- cubic B-spline, and its Laplace transform H(z) has zeros only at
-- z = −1 + 8πik, so H(ρ − ½) ≠ 0 for every zero ρ: the receiver is
-- faithful on every mode of the explicit formula, and attenuates to
-- fourth order.  The B-spline is the fourfold convolution of the box;
-- its discrete shadow is the fourfold convolution of (1,1), the binomial
-- receiver g = (1, 4, 6, 4, 1), and its transfer on the geometric mode
-- k ↦ m^k is Σ g_k m^k = (1 + m)^4.
--
--   §1  THE RECEIVER AND ITS TRANSFER, over any commutative ring: the
--       binomial identity Σ_{k≤4} g_k m^k ≡ (1+m)^4 by the ring solver.
--   §2  FOURTH-ORDER ATTENUATION.  At m = −1 + ε the transfer is ε^4,
--       exactly.
--   §3  OVER ℚ THE RECEIVER SEES EVERY MODE BUT ONE.  If m ≠ −1 then
--       (1+m)^4 > 0, hence ≠ 0: by trichotomy 1+m is negative or
--       positive, its square is positive, and the square of that is
--       positive.  No zero-product law is used; the order does it.
--
-- ग्राही (grāhī, receiver) and सर्व (sarva, all) are ordinary Sanskrit.
------------------------------------------------------------------------

module SarvaGrahi_TheBinomialReceiversTransferOnAGeometricModeIsTheFourthPowerOfOnePlusTheRatioSoItVanishesOnlyAtMinusOneAndToFourthOrderThereAndOverQItSeesEveryOtherMode where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  ----------------------------------------------------------------------
  -- १ · The binomial receiver and its transfer on a geometric mode.
  ----------------------------------------------------------------------

  -- the receiver's taps: 1, 4, 6, 4, 1, then 0
  grāhī : ℕ → ⟨ R ⟩
  grāhī zero                              = 1r
  grāhī (suc zero)                        = 1r + 1r + 1r + 1r
  grāhī (suc (suc zero))                  = 1r + 1r + 1r + 1r + 1r + 1r
  grāhī (suc (suc (suc zero)))            = 1r + 1r + 1r + 1r
  grāhī (suc (suc (suc (suc zero))))      = 1r
  grāhī (suc (suc (suc (suc (suc _)))))   = 0r

  -- powers
  _^_ : ⟨ R ⟩ → ℕ → ⟨ R ⟩
  m ^ zero  = 1r
  m ^ suc k = m · (m ^ k)

  -- the transfer: Σ_{k ≤ 4} g_k · m^k
  saṅkramaṇa : ⟨ R ⟩ → ⟨ R ⟩
  saṅkramaṇa m = grāhī 0 · (m ^ 0) + grāhī 1 · (m ^ 1) + grāhī 2 · (m ^ 2)
               + grāhī 3 · (m ^ 3) + grāhī 4 · (m ^ 4)

  caturtha : ⟨ R ⟩ → ⟨ R ⟩
  caturtha x = (x · x) · (x · x)

  -- Σ g_k m^k = (1 + m)^4
  sarva-grāhī : (m : ⟨ R ⟩) → saṅkramaṇa m ≡ caturtha (1r + m)
  sarva-grāhī m = solve! R

  ----------------------------------------------------------------------
  -- २ · Fourth-order attenuation at m = −1.
  ----------------------------------------------------------------------

  caturtha-kṣaya : (ε : ⟨ R ⟩) → saṅkramaṇa ((- 1r) + ε) ≡ caturtha ε
  caturtha-kṣaya ε = solve! R

  -- and the transfer vanishes at −1
  ṛṇa-eka-śūnya : saṅkramaṇa (- 1r) ≡ 0r
  ṛṇa-eka-śūnya = solve! R

  ----------------------------------------------------------------------
  -- २′ · The receiver is the fourfold convolution of the box (1, 1):
  --      the discrete cubic B-spline, not a table.
  ----------------------------------------------------------------------

  peṭikā : ℕ → ⟨ R ⟩           -- the box
  peṭikā zero       = 1r
  peṭikā (suc zero) = 1r
  peṭikā (suc (suc _)) = 0r

  -- convolution with the box: (f ⋆ box) n = f n + f (n − 1)
  ⋆peṭikā : (ℕ → ⟨ R ⟩) → ℕ → ⟨ R ⟩
  ⋆peṭikā f zero    = f zero
  ⋆peṭikā f (suc n) = f (suc n) + f n

  -- box ⋆ box ⋆ box ⋆ box
  catuṣ-peṭikā : ℕ → ⟨ R ⟩
  catuṣ-peṭikā = ⋆peṭikā (⋆peṭikā (⋆peṭikā peṭikā))

  -- and that is the receiver, tap by tap
  peṭikā-grāhī : (k : ℕ) → catuṣ-peṭikā k ≡ grāhī k
  peṭikā-grāhī zero = refl
  peṭikā-grāhī (suc zero) = solve! R
  peṭikā-grāhī (suc (suc zero)) = solve! R
  peṭikā-grāhī (suc (suc (suc zero))) = solve! R
  peṭikā-grāhī (suc (suc (suc (suc zero)))) = solve! R
  peṭikā-grāhī (suc (suc (suc (suc (suc zero))))) = solve! R
  peṭikā-grāhī (suc (suc (suc (suc (suc (suc k)))))) = solve! R

  ----------------------------------------------------------------------
  -- २″ · The convolution theorem for the box: convolving with the box
  --      multiplies the transfer by (1 + m).  So (1+m)^4 is structural —
  --      the fourth power counts the four boxes — and every further box
  --      raises the attenuation order by one.
  ----------------------------------------------------------------------

  -- Σ_{k < N} f k
  Σ⟨_⟩ : ℕ → (ℕ → ⟨ R ⟩) → ⟨ R ⟩
  Σ⟨ zero ⟩  f = 0r
  Σ⟨ suc N ⟩ f = Σ⟨ N ⟩ f + f N

  -- the transfer of a sequence on [0, N) at the mode m
  T : ℕ → (ℕ → ⟨ R ⟩) → ⟨ R ⟩ → ⟨ R ⟩
  T N f m = Σ⟨ N ⟩ (λ k → f k · (m ^ k))

  -- T_{N+1}(f ⋆ box) = T_{N+1}(f) + m · T_N(f)
  peṭikā-T : (N : ℕ) (f : ℕ → ⟨ R ⟩) (m : ⟨ R ⟩)
           → T (suc N) (⋆peṭikā f) m ≡ T (suc N) f m + m · T N f m
  peṭikā-T zero    f m = solve! R
  peṭikā-T (suc N) f m =
      cong (_+ (f (suc N) + f N) · (m · (m ^ N))) (peṭikā-T N f m)
    ∙ punar (T (suc N) f m) (T N f m) (f (suc N)) (f N) m (m ^ N)
    where
    punar : (a b c d m p : ⟨ R ⟩)
          → (a + m · b) + (c + d) · (m · p) ≡ (a + c · (m · p)) + m · (b + d · p)
    punar a b c d m p = solve! R

  -- on a sequence supported below N the transfer is multiplied by (1 + m)
  peṭikā-guṇa : (N : ℕ) (f : ℕ → ⟨ R ⟩) (m : ⟨ R ⟩) → f N ≡ 0r
              → T (suc N) (⋆peṭikā f) m ≡ (1r + m) · T N f m
  peṭikā-guṇa N f m z =
      peṭikā-T N f m
    ∙ cong (λ v → (T N f m + v · (m ^ N)) + m · T N f m) z
    ∙ punar (T N f m) m (m ^ N)
    where
    punar : (a m p : ⟨ R ⟩) → (a + 0r · p) + m · a ≡ (1r + m) · a
    punar a m p = solve! R

  -- the box's own transfer on [0, 2) is 1 + m
  peṭikā-T₂ : (m : ⟨ R ⟩) → T 2 peṭikā m ≡ 1r + m
  peṭikā-T₂ m = solve! R

  -- hence, structurally: T₆(box⁴) = (1+m)^4
  catuṣ-T : (m : ⟨ R ⟩) → T 5 catuṣ-peṭikā m ≡ caturtha (1r + m)
  catuṣ-T m =
      peṭikā-guṇa 4 (⋆peṭikā (⋆peṭikā peṭikā)) m z₄
    ∙ cong ((1r + m) ·_) (peṭikā-guṇa 3 (⋆peṭikā peṭikā) m z₃)
    ∙ cong (λ v → (1r + m) · ((1r + m) · v)) (peṭikā-guṇa 2 peṭikā m refl)
    ∙ cong (λ v → (1r + m) · ((1r + m) · ((1r + m) · v))) (peṭikā-T₂ m)
    ∙ punar (1r + m)
    where
    punar : (u : ⟨ R ⟩) → u · (u · (u · u)) ≡ (u · u) · (u · u)
    punar u = solve! R
    z₃ : ⋆peṭikā peṭikā 3 ≡ 0r
    z₃ = solve! R
    z₄ : ⋆peṭikā (⋆peṭikā peṭikā) 4 ≡ 0r
    z₄ = solve! R

------------------------------------------------------------------------
-- ३ · Over ℚ the receiver sees every mode but m = −1.
------------------------------------------------------------------------

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_<_ ; <-·o ; isIrrefl< ; _≟_ ; lt ; eq ; gt ; <-+o)
open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; ṛṇa-viparīta)

-- x < 0 or 0 < x gives 0 < x · x
dhana-varga : (x : ℚ) → 0 < x → 0 < x · x
dhana-varga x 0<x = subst (_< x · x) (·AnnihilL x) (<-·o 0 x x 0<x 0<x)

ṛṇa-varga : (x : ℚ) → x < 0 → 0 < x · x
ṛṇa-varga x x<0 = subst (0 <_) (vipa x) (dhana-varga (- x) (ṛṇa-viparīta x x<0))
  where vipa : (x : ℚ) → (- x) · (- x) ≡ x · x
        vipa x = ·Assoc (- x) (- 1) x ∙ cong (_· x) (·Comm (- x) (- 1) ∙ -Invol x)

-- a nonzero rational has positive square
anasta-varga : (x : ℚ) → ¬ (x ≡ 0) → 0 < x · x
anasta-varga x ne with x ≟ 0
... | lt x<0 = ṛṇa-varga x x<0
... | eq p   = ⊥-elim (ne p)
... | gt 0<x = dhana-varga x 0<x

-- so its fourth power is positive, hence nonzero
anasta-caturtha : (x : ℚ) → ¬ (x ≡ 0) → ¬ (caturtha ℚRing x ≡ 0)
anasta-caturtha x ne p =
  isIrrefl< 0 (subst (0 <_) p (dhana-varga (x · x) (anasta-varga x ne)))

-- m ≠ −1 gives 1 + m ≠ 0
na-ṛṇa-eka : (m : ℚ) → ¬ (m ≡ - 1) → ¬ (1 + m ≡ 0)
na-ṛṇa-eka m ne p = ne (sym (+IdL m) ∙ cong (_+ m) (sym (+InvL 1)) ∙ sym (+Assoc (- 1) 1 m)
                       ∙ cong ((- 1) +_) p ∙ +IdR (- 1))

-- THE THEOREM: on every geometric mode other than −1 the receiver's
-- transfer is nonzero — the discrete H(ρ − ½) ≠ 0.
sarva-grāhī-ℚ : (m : ℚ) → ¬ (m ≡ - 1) → ¬ (saṅkramaṇa ℚRing m ≡ 0)
sarva-grāhī-ℚ m ne p = anasta-caturtha (1 + m) (na-ṛṇa-eka m ne) (sym (sarva-grāhī ℚRing m) ∙ p)
