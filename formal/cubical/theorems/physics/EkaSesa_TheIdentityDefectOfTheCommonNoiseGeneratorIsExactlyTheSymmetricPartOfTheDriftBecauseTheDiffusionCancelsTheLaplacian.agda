{-# OPTIONS --cubical --safe --no-import-sorts --lossy-unification #-}

------------------------------------------------------------------------
-- एक-शेष — the remainder at one.
--
-- THE COMMON-NOISE GENERATOR APPLIED TO THE IDENTITY IS EXACTLY THE
-- SYMMETRIC PART OF THE DRIFT.  NOT BOUNDED BY IT — EQUAL TO IT.
--
-- `VahanaSamata` proves that the generator
--
--     𝒢 (x)  =  L·x + x·L†  +  2 Σⱼ Dⱼ·x·Dⱼ†
--
-- carries real to real: a covariance stays a covariance.  Positivity of
-- a map is not contractivity, though, and the missing half is what the
-- map does to the UNIT.  This module computes that, exactly.
--
-- Write the drift as a skew part plus the Laplacian it carries,
--
--     L  =  J + Λ ,        Λ  =  Σ_{j<k} Dⱼ · Dⱼ ,
--
-- with every direction SKEW, `† Dⱼ ≡ - Dⱼ`.  Then:
--
--   §1  conj Dⱼ 1 ≡ - (Dⱼ · Dⱼ) — each diffusion term at the unit is
--       MINUS a square, because skewness turns the right factor over.
--
--   §2  so the whole diffusion term at the unit is `- Λ`.
--
--   §3  Λ is real: a square of a skew element is real, so the drift's
--       Laplacian part contributes to `L + L†` twice, not once.
--
--   §4  lyap L 1 ≡ L + L† — the congruence at the unit is the
--       symmetrization, with no residue.
--
--   §5  THE DEFECT.  Putting §§2–4 together, the `Λ` from the drift and
--       the doubled `-Λ` from the noise cancel EXACTLY:
--
--         𝒢 (1)  =  (J + Λ) + (J† + Λ)  +  (-Λ) + (-Λ)  =  J + J† .
--
--       There is no unspecified correction in that formula.  Whatever
--       the family of directions is — however many, in whatever order,
--       commuting or not — it contributes nothing at the unit beyond
--       cancelling the Laplacian it generated.
--
--   §6  and therefore UNITALITY IS SKEW-ADJOINTNESS OF THE DRIFT, in
--       both directions:
--
--         𝒢 (1) ≡ 0   ⟺   J† ≡ - J .
--
--       The channel preserves the unit exactly when the drift has no
--       symmetric part at all.  This is the algebraic half of the
--       rigidity statement; which flows have vanishing symmetric part is
--       a question about a model and is not asked here.
--
--   §7  the defect is REAL — `† (J + J†) ≡ J + J†` — which is why it can
--       be read as a strain and compared against the unit at all.
--
-- WHAT §5 SAYS ABOUT THE TWO OBJECTS.  The map is positive and its
-- normalization moves; the initial motion of the normalization is the
-- symmetric part of the drift and nothing else.  A bound on the
-- normalization is therefore NOT a bound on what the map does to a
-- particular real element: the two differ already in first order, by
-- exactly `J + J†`.  Replacing the second by the first discards that
-- difference.  §5 is the identity that makes the discarding visible;
-- it does not estimate either side.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–7 in any ring with involution, for
-- every drift `J`, every family `D` of skew directions, and every finite
-- `k`.  NOT claimed: positivity, which is not expressible here beyond
-- the real/skew split `VahanaSamata` establishes; anything about norms,
-- spectra, or contractivity — no order relation appears in this file;
-- anything about SOLVING the evolution, only about its right-hand side
-- at one point; that any particular drift is or is not skew, which is
-- the modelling step; and nothing about the exponential or the
-- stochastic lift, which are not constructed anywhere in this corpus.
------------------------------------------------------------------------

module EkaSesa_TheIdentityDefectOfTheCommonNoiseGeneratorIsExactlyTheSymmetricPartOfTheDriftBecauseTheDiffusionCancelsTheLaplacian where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import LeakageCommutator using (IsInvolution)
import VahanaSamata_TheCongruenceAndTheDiffusionTermPreserveAdjointParitySoARealCovarianceStaysRealUnderCommonSourceTransport as VS

private
  variable
    ℓ : Level

module _ (R : Ring ℓ) (†_ : ⟨ R ⟩ → ⟨ R ⟩) (inv : IsInvolution R †_) where
  open RingStr (snd R)
  open RingTheory R
  open IsInvolution inv

  private
    A : Type ℓ
    A = ⟨ R ⟩

  --------------------------------------------------------------------
  -- ० · The pieces, taken from `VahanaSamata` rather than restated.
  --------------------------------------------------------------------

  conj : A → A → A
  conj = VS.conj R †_ inv

  lyap : A → A → A
  lyap = VS.lyap R †_ inv

  sum : ℕ → (ℕ → A) → A
  sum = VS.sum R †_ inv

  -- the Laplacian the directions generate
  Λ : (ℕ → A) → ℕ → A
  Λ D k = sum k (λ j → D j · D j)

  -- the generator, with the diffusion term doubled as it stands in the
  -- covariance evolution.  The doubling is written `y + y`: no scalar
  -- is available in a bare ring and none is needed.
  gen : A → (ℕ → A) → ℕ → A → A
  gen L D k x =
    lyap L x + (sum k (λ j → conj (D j) x) + sum k (λ j → conj (D j) x))

  --------------------------------------------------------------------
  -- १ · A SKEW DIRECTION CONJUGATES THE UNIT TO MINUS ITS SQUARE.
  --------------------------------------------------------------------

  conj-one : (D : A) → († D ≡ - D) → conj D 1r ≡ - (D · D)
  conj-one D hD =
      (D · 1r) · († D)
    ≡⟨ cong₂ _·_ (·IdR D) hD ⟩
      D · (- D)
    ≡⟨ -DistR· D D ⟩
      - (D · D) ∎

  --------------------------------------------------------------------
  -- २ · SO THE WHOLE DIFFUSION TERM AT THE UNIT IS MINUS THE LAPLACIAN.
  --------------------------------------------------------------------

  diffusion-one : (D : ℕ → A) (k : ℕ)
    → ((j : ℕ) → † (D j) ≡ - (D j))
    → sum k (λ j → conj (D j) 1r) ≡ - (Λ D k)
  diffusion-one D zero    hD = sym 0Selfinverse
  diffusion-one D (suc k) hD =
      conj (D k) 1r + sum k (λ j → conj (D j) 1r)
    ≡⟨ cong₂ _+_ (conj-one (D k) (hD k)) (diffusion-one D k hD) ⟩
      (- (D k · D k)) + (- (Λ D k))
    ≡⟨ -Dist (D k · D k) (Λ D k) ⟩
      - ((D k · D k) + Λ D k) ∎

  --------------------------------------------------------------------
  -- ३ · THE LAPLACIAN IS REAL.  A square of a skew element is real:
  --     (-D)·(-D) ≡ D·D, and `†` reverses the order of a product of
  --     two copies of the same thing to no effect.
  --------------------------------------------------------------------

  square-real : (D : A) → († D ≡ - D) → † (D · D) ≡ D · D
  square-real D hD =
      † (D · D)
    ≡⟨ †-· D D ⟩
      († D) · († D)
    ≡⟨ cong₂ _·_ hD hD ⟩
      (- D) · (- D)
    ≡⟨ -DistL· D (- D) ⟩
      - (D · (- D))
    ≡⟨ cong (λ z → - z) (-DistR· D D) ⟩
      - (- (D · D))
    ≡⟨ -Idempotent (D · D) ⟩
      D · D ∎

  Λ-real : (D : ℕ → A) (k : ℕ)
    → ((j : ℕ) → † (D j) ≡ - (D j))
    → † (Λ D k) ≡ Λ D k
  Λ-real D k hD =
    VS.sum-real R †_ inv k (λ j → D j · D j) (λ j → square-real (D j) (hD j))

  --------------------------------------------------------------------
  -- ४ · THE CONGRUENCE AT THE UNIT IS THE SYMMETRIZATION.
  --------------------------------------------------------------------

  lyap-one : (L : A) → lyap L 1r ≡ L + († L)
  lyap-one L = cong₂ _+_ (·IdR L) (·IdL († L))

  --------------------------------------------------------------------
  -- ५ · THE IDENTITY DEFECT, EXACTLY.  The `Λ` the drift carries and
  --     the doubled `-Λ` the noise produces cancel with nothing over.
  --------------------------------------------------------------------

  generator-at-one : (J : A) (D : ℕ → A) (k : ℕ)
    → ((j : ℕ) → † (D j) ≡ - (D j))
    → gen (J + Λ D k) D k 1r ≡ J + († J)
  generator-at-one J D k hD =
      lyap (J + Λ D k) 1r
        + (sum k (λ j → conj (D j) 1r) + sum k (λ j → conj (D j) 1r))
    ≡⟨ cong₂ _+_ (lyap-one (J + Λ D k))
                 (cong₂ _+_ (diffusion-one D k hD) (diffusion-one D k hD)) ⟩
      ((J + Λ D k) + († (J + Λ D k))) + ((- (Λ D k)) + (- (Λ D k)))
    ≡⟨ cong (λ z → ((J + Λ D k) + z) + ((- (Λ D k)) + (- (Λ D k))))
            (†-+ J (Λ D k) ∙ cong ((† J) +_) (Λ-real D k hD)) ⟩
      ((J + Λ D k) + ((† J) + Λ D k)) + ((- (Λ D k)) + (- (Λ D k)))
    ≡⟨ cong₂ _+_ (+ShufflePairs J (Λ D k) († J) (Λ D k))
                 (-Dist (Λ D k) (Λ D k)) ⟩
      ((J + († J)) + (Λ D k + Λ D k)) + (- (Λ D k + Λ D k))
    ≡⟨ sym (+Assoc (J + († J)) (Λ D k + Λ D k) (- (Λ D k + Λ D k))) ⟩
      (J + († J)) + ((Λ D k + Λ D k) + (- (Λ D k + Λ D k)))
    ≡⟨ cong ((J + († J)) +_) (+InvR (Λ D k + Λ D k)) ⟩
      (J + († J)) + 0r
    ≡⟨ +IdR (J + († J)) ⟩
      J + († J) ∎

  --------------------------------------------------------------------
  -- ६ · UNITALITY IS SKEW-ADJOINTNESS OF THE DRIFT, BOTH WAYS.
  --------------------------------------------------------------------

  unital→skew : (J : A) (D : ℕ → A) (k : ℕ)
    → ((j : ℕ) → † (D j) ≡ - (D j))
    → gen (J + Λ D k) D k 1r ≡ 0r
    → † J ≡ - J
  unital→skew J D k hD h =
    implicitInverse J († J) (sym (generator-at-one J D k hD) ∙ h)

  skew→unital : (J : A) (D : ℕ → A) (k : ℕ)
    → ((j : ℕ) → † (D j) ≡ - (D j))
    → † J ≡ - J
    → gen (J + Λ D k) D k 1r ≡ 0r
  skew→unital J D k hD hJ =
      generator-at-one J D k hD
    ∙ cong (J +_) hJ
    ∙ +InvR J

  --------------------------------------------------------------------
  -- ७ · AND THE DEFECT IS REAL.
  --------------------------------------------------------------------

  defect-real : (J : A) → † (J + († J)) ≡ J + († J)
  defect-real J =
      † (J + († J))
    ≡⟨ †-+ J († J) ⟩
      († J) + († († J))
    ≡⟨ cong ((† J) +_) (†-invol J) ⟩
      († J) + J
    ≡⟨ +Comm († J) J ⟩
      J + († J) ∎
