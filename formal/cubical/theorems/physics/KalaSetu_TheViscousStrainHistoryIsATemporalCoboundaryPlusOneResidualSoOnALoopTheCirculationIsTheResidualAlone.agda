{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- काल-सेतु — the bridge across time.
--
-- THE ENTIRE LINEAR VISCOUS CONTRIBUTION TO A STRAIN HISTORY IS A
-- COBOUNDARY IN TIME.  SO ON A CLOSED LOOP IT CONTRIBUTES NOTHING AT
-- ALL, AND THE WHOLE CIRCULATION IS CARRIED BY ONE RESIDUAL.
--
-- If a potential `P`, a strain `S` and a nonlinear source `N` satisfy,
-- step by step,
--
--     ν · S n  ≡  (P n - P (n+1))  +  N n ,
--
-- which is the step form of `∂ₜ P = Π[𝒩] - ν S` rearranged, then
-- summing over any number of steps telescopes:
--
--   §3  ν · Σ_{n<k} S n  ≡  (P 0 - P k)  +  Σ_{n<k} N n .
--
--   §4  AND ON A LOOP — `P k ≡ P 0`, a genuinely recurrent source —
--       the endpoint term is not small, it is ABSENT:
--
--         ν · (strain circulation)  ≡  (residual circulation) .
--
--       No class in any cohomology needs to be invented for this: the
--       time-one-form is explicitly a coboundary plus a retained
--       residual, and §3 exhibits the primitive.
--
--   §1  the four laws of a finite sum — congruence, additivity,
--       distribution of a scalar, and negation — each a short induction.
--
--   §2  THE TELESCOPE: Σ_{n<k} (P (n+1) - P n) ≡ P k - P 0, for every
--       sequence whatsoever.  This is the whole mechanism; §§3–4 are its
--       two readings.
--
-- ON THE DISCRETENESS, said plainly rather than apologised for.  The
-- index here is a partition of the time interval, and the identity is
-- EXACT at every partition, however fine or coarse — nothing is lost to
-- discretisation and no limit is being approximated.  What a continuum
-- version would add is not accuracy but the ability to state the step
-- law as a derivative rather than a difference; that is a change of
-- carrier, not of content, and the content is here.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 in any commutative ring, for every
-- three sequences, every `ν`, and every finite depth.  NOT claimed: that
-- any particular `P` is a strain potential, or that any `S` and `N` are
-- what the step law says they are — the law is a hypothesis and is
-- carried; that `ν` is invertible, so §§3–4 are stated with `ν ·` on the
-- left and are never divided through; anything about a derivative, an
-- integral, or a Lagrangian trajectory; and nothing about the size of
-- the residual, which is exactly the object §4 isolates and does not
-- estimate.
------------------------------------------------------------------------

module KalaSetu_TheViscousStrainHistoryIsATemporalCoboundaryPlusOneResidualSoOnALoopTheCirculationIsTheResidualAlone where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
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

  ------------------------------------------------------------------
  -- ० · The finite sum along a partition.
  ------------------------------------------------------------------

  sum : ℕ → (ℕ → A) → A
  sum zero    f = 0r
  sum (suc k) f = sum k f + f k

  ------------------------------------------------------------------
  -- १ · Its four laws.
  ------------------------------------------------------------------

  sum-cong : (k : ℕ) (f g : ℕ → A) → ((n : ℕ) → f n ≡ g n)
    → sum k f ≡ sum k g
  sum-cong zero    f g h = refl
  sum-cong (suc k) f g h = cong₂ _+_ (sum-cong k f g h) (h k)

  sum-add : (k : ℕ) (f g : ℕ → A)
    → sum k (λ n → f n + g n) ≡ sum k f + sum k g
  sum-add zero    f g = sym (+IdL 0r)
  sum-add (suc k) f g =
      cong (_+ (f k + g k)) (sum-add k f g)
    ∙ shuffle (sum k f) (sum k g) (f k) (g k)
    where
      shuffle : (p q a b : A) → (p + q) + (a + b) ≡ (p + a) + (q + b)
      shuffle p q a b = solve! R

  sum-mul : (k : ℕ) (c : A) (f : ℕ → A)
    → c · sum k f ≡ sum k (λ n → c · f n)
  sum-mul zero    c f = zeroR c
    where
      zeroR : (x : A) → x · 0r ≡ 0r
      zeroR x = solve! R
  sum-mul (suc k) c f =
      ·DistR+ c (sum k f) (f k) ∙ cong (_+ (c · f k)) (sum-mul k c f)

  sum-neg : (k : ℕ) (f : ℕ → A) → sum k (λ n → - f n) ≡ - sum k f
  sum-neg zero    f = negZero
    where
      negZero : 0r ≡ - 0r
      negZero = solve! R
  sum-neg (suc k) f =
      cong (_+ (- f k)) (sum-neg k f) ∙ pull (sum k f) (f k)
    where
      pull : (p a : A) → (- p) + (- a) ≡ - (p + a)
      pull p a = solve! R

  ------------------------------------------------------------------
  -- २ · THE TELESCOPE.
  ------------------------------------------------------------------

  telescope : (P : ℕ → A) (k : ℕ)
    → sum k (λ n → P (suc n) + (- P n)) ≡ P k + (- P 0)
  telescope P zero    = sym (+InvR (P 0))
  telescope P (suc k) =
      cong (_+ (P (suc k) + (- P k))) (telescope P k)
    ∙ join (P 0) (P k) (P (suc k))
    where
      join : (p₀ pk pk₁ : A)
        → (pk + (- p₀)) + (pk₁ + (- pk)) ≡ pk₁ + (- p₀)
      join p₀ pk pk₁ = solve! R

  ------------------------------------------------------------------
  -- ३ · THE VISCOUS HISTORY IS A COBOUNDARY PLUS THE RESIDUAL.
  ------------------------------------------------------------------

  module _ (P S N : ℕ → A) (ν : A)
           (step : (n : ℕ) → ν · S n ≡ (P n + (- P (suc n))) + N n)
           where

    viscous-history : (k : ℕ)
      → ν · sum k S ≡ (P 0 + (- P k)) + sum k N
    viscous-history k =
        sum-mul k ν S
      ∙ sum-cong k (λ n → ν · S n)
                   (λ n → (P n + (- P (suc n))) + N n) step
      ∙ sum-add k (λ n → P n + (- P (suc n))) N
      ∙ cong (_+ sum k N) endpoint
      where
        flip : (n : ℕ)
          → P n + (- P (suc n)) ≡ - (P (suc n) + (- P n))
        flip n = negate (P n) (P (suc n))
          where
            negate : (a b : A) → a + (- b) ≡ - (b + (- a))
            negate a b = solve! R

        endpoint : sum k (λ n → P n + (- P (suc n))) ≡ P 0 + (- P k)
        endpoint =
            sum-cong k (λ n → P n + (- P (suc n)))
                       (λ n → - (P (suc n) + (- P n))) flip
          ∙ sum-neg k (λ n → P (suc n) + (- P n))
          ∙ cong -_ (telescope P k)
          ∙ swapNeg (P k) (P 0)
          where
            swapNeg : (a b : A) → - (a + (- b)) ≡ b + (- a)
            swapNeg a b = solve! R

    ----------------------------------------------------------------
    -- ४ · SO ON A LOOP THE CIRCULATION IS THE RESIDUAL ALONE.
    ----------------------------------------------------------------

    loop-circulation : (k : ℕ) → P k ≡ P 0
      → ν · sum k S ≡ sum k N
    loop-circulation k closed =
        viscous-history k
      ∙ cong (λ z → (P 0 + (- z)) + sum k N) closed
      ∙ cong (_+ sum k N) (+InvR (P 0))
      ∙ +IdL (sum k N)
