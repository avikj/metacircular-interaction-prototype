{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- आबेल-रूप — the Abel normal form.
--
-- THE RESOLVENT OF THE DAMPED SHIFT TURNS THE SHIFT DEFECT INTO A
-- CONTRACTION, SO ITS POWERS INVERT THE DEFECT AT EVERY ORDER; AND THE
-- ITERATED DIFFERENCES OF THE NORMALIZED SOURCE ARE EXACTLY THE
-- RESIDUAL TOWER, RESCALED.
--
-- Two identities from the repaired arithmetic inverse [S19 §§8–10],
-- both pure algebra, both stated so that the analytic step — the strong
-- limit ρ ↑ 1 — is visibly the only thing not here.
--
--   §1  THE NORMAL FORM.  With `T` the shift, `ρ` the damping, and `c`
--       the resolvent  c · (1 - ρ T) ≡ 1 , put  B = (1 - ρ) T c .  Then
--
--         1 - B  ≡  c · (1 - T) ,
--
--       so the shift defect `1 - T` and the contraction defect `1 - B`
--       differ by the invertible factor `c` — nothing else.
--
--   §2  AT EVERY ORDER:  (1 - B)^m ≡ c^m · (1 - T)^m .  This is
--       `(I - ρT)^{-m}(I - T)^m = (I - B_ρ)^m` with the negative power
--       written as the power of the resolvent.  The right side is what
--       tends to the identity as ρ ↑ 1; the left side is the m-th order
--       inverse applied to the m-th order defect.  Both sides are
--       finite ring elements here, and equal.
--
--   §3  THE RESIDUAL TOWER.  For a source `S` on the lattice, the
--       normalized readings  Y k = c̄^k · S k  (c̄ the inverse of the
--       scale character c) have iterated forward differences
--
--         Δ^m Y k  ≡  c̄^{k+m} · (A m) k ,      A m = (shift - c)^m S ,
--
--       exactly, for every m and k.  So the m-th residual of the actual
--       source and the m-th difference of the normalized source are one
--       object read at two normalizations — which is why an inverse for
--       differences is an inverse for residuals.
--
-- WHERE THE ANALYSIS ENTERS, NAMED.  §§1–3 are what the Abel inverse
-- uses; what it adds is that `B` is a contraction on c₀ and `B x → 0`
-- strongly, hence `(1-B)^m → 1`.  That is a statement about a limit in
-- a Banach space and is not made here.  Everything up to it is ring
-- algebra, checked.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–2 in any commutative ring, for every
-- `T`, `ρ`, and every resolvent `c` of `1 - ρT`.  §3 in any commutative
-- ring, for every source, every invertible scale character, every order
-- and every lattice point.  NOT claimed: existence of the resolvent
-- (carried); anything about norms, c₀, contractions, or limits; that the
-- actual arithmetic source's normalized readings converge — which is
-- (32) there and needs the explicit formula; and nothing about zeta.
------------------------------------------------------------------------

module AbelaRupa_TheResolventOfTheDampedShiftNormalizesTheShiftDefectSoItsPowersInvertEveryOrderAndTheDyadicDifferencesOfTheNormalizedSourceAreTheResidualTower where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; +-suc ; +-zero) renaming (_+_ to _+ℕ_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  pow : A → ℕ → A
  pow x zero    = 1r
  pow x (suc n) = x · pow x n

  pow-· : (x y : A) (n : ℕ) → pow (x · y) n ≡ pow x n · pow y n
  pow-· x y zero    = sym (·IdR 1r)
  pow-· x y (suc n) =
      cong ((x · y) ·_) (pow-· x y n)
    ∙ shuffle x y (pow x n) (pow y n)
    where
      shuffle : (a b p q : A) → (a · b) · (p · q) ≡ (a · p) · (b · q)
      shuffle a b p q = solve! R

  ------------------------------------------------------------------
  -- १ · THE NORMAL FORM.
  ------------------------------------------------------------------

  module _ (T ρ c : A) (resolvent : c · (1r + (- (ρ · T))) ≡ 1r) where

    B : A
    B = ((1r + (- ρ)) · T) · c

    normal-form : 1r + (- B) ≡ c · (1r + (- T))
    normal-form =
        cong (_+ (- B)) (sym resolvent)
      ∙ shape c ρ T
      where
        shape : (a r t : A)
          → (a · (1r + (- (r · t)))) + (- (((1r + (- r)) · t) · a))
            ≡ a · (1r + (- t))
        shape a r t = solve! R

    ----------------------------------------------------------------
    -- २ · AT EVERY ORDER.
    ----------------------------------------------------------------

    normal-form-power : (m : ℕ) → pow (1r + (- B)) m ≡ pow c m · pow (1r + (- T)) m
    normal-form-power m =
      cong (λ z → pow z m) normal-form ∙ pow-· c (1r + (- T)) m

  ------------------------------------------------------------------
  -- ३ · THE RESIDUAL TOWER.
  ------------------------------------------------------------------

  module _ (S : ℕ → A) (c c̄ : A) (cc̄ : c · c̄ ≡ 1r) where

    -- the normalized reading, and the two iterated operators
    Y : ℕ → A
    Y k = pow c̄ k · S k

    Δ : (ℕ → A) → ℕ → A
    Δ f k = f (suc k) + (- f k)

    Δ^ : ℕ → (ℕ → A) → ℕ → A
    Δ^ zero    f = f
    Δ^ (suc m) f = Δ (Δ^ m f)

    -- (shift − c) applied to a source
    res : (ℕ → A) → ℕ → A
    res f k = f (suc k) + (- (c · f k))

    A^ : ℕ → ℕ → A
    A^ zero    = S
    A^ (suc m) = res (A^ m)

    private
      pow-suc : (k : ℕ) → pow c̄ k ≡ (pow c̄ (suc k) · c)
      pow-suc k =
          sym (·IdR (pow c̄ k))
        ∙ cong (pow c̄ k ·_) (sym (·Comm c̄ c ∙ cc̄))
        ∙ shape (pow c̄ k) c̄ c
        where
          shape : (p a b : A) → p · (a · b) ≡ (a · p) · b
          shape p a b = solve! R

    difference-is-rescaled-residual :
        (m k : ℕ) → Δ^ m Y k ≡ pow c̄ (k +ℕ m) · A^ m k
    difference-is-rescaled-residual zero k =
      cong (λ n → pow c̄ n · S k) (sym (+-zero k))
    difference-is-rescaled-residual (suc m) k =
        cong₂ (λ p q → p + (- q))
              (difference-is-rescaled-residual m (suc k))
              (difference-is-rescaled-residual m k)
      ∙ cong (λ z → pow c̄ (suc (k +ℕ m)) · A^ m (suc k) + (- (z · A^ m k)))
             (pow-suc (k +ℕ m))
      ∙ collect (pow c̄ (suc (k +ℕ m))) c (A^ m (suc k)) (A^ m k)
      ∙ cong (λ n → pow c̄ n · res (A^ m) k) (sym (+-suc k m))
      where
        collect : (p a u v : A)
          → p · u + (- ((p · a) · v)) ≡ p · (u + (- (a · v)))
        collect p a u v = solve! R
