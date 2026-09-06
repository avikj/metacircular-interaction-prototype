{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- युग्म-व्यय — the paired budget.
--
-- TWO BUDGETS WHOSE DIFFERENCE IS FIXED DIVERGE TOGETHER.
--
-- A two-sector evolution in which both sectors are driven by ONE common
-- production term has, after compensating each sector by its own
-- accumulated dissipation, budgets whose DIFFERENCE is an exact
-- constant of the motion: the signed difference is conserved even
-- though neither budget is monotone and the common production may
-- change sign.  This module is the order-theoretic content of what that
-- costs a hypothetical blow-up — it cannot be carried by one sector.
--
--   §0b  A cancellation the library does not carry: `m + m ≤ n + n`
--        implies `m ≤ n`.  It is needed because a bound on the SUM of
--        two comparable quantities bounds the larger one only after
--        halving, and that halving is the whole reason the argument
--        needs the two sectors to be comparable at all.
--
--   §1   If the two budgets differ by a fixed constant, each dominates
--        its own sector quantity, and the SUM of the sector quantities
--        is unbounded, then BOTH budgets are unbounded.
--
--   §2   And the fixed-difference hypothesis is strictly stronger than
--        the asymptotic statement usually quoted.  §2 records the exact
--        form: each budget is within the SAME constant of the other, at
--        EVERY index, with no limit taken.
--
-- The shape of the argument: `Unbounded (k₊ + k₋)` is what a critical
-- criterion supplies — the SUM blows up.  The conserved difference is
-- what upgrades that to "each compensated budget blows up separately".
-- Neither step is analytic, and neither is about any particular
-- evolution.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§0b–2 over ℕ, for all sequences and all
-- indices, with `Unbounded f = (M : ℕ) → Σ[ n ] M ≤ f n` — the
-- constructive reading, so §1 RETURNS the index at which each budget
-- exceeds a given bound.  NOT claimed: anything about the evolution
-- that produces such budgets, about which sequences arise from one,
-- about limits, monotonicity, or rates.  The direction of the constant
-- is fixed (`b₊` the larger); the mirrored case is this theorem with
-- the two arguments exchanged.
------------------------------------------------------------------------

module YugmaVyaya_TwoBudgetsWithAFixedDifferenceDivergeTogetherSoNeitherSectorCanCarryTheBlowupAlone where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; snotz)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤-refl ; ≤-trans ; ≤-k+ ; ≤-+-≤ ; ≤-k+-cancel ; ≤SumRight
        ; zero-≤ ; suc-≤-suc ; pred-≤-pred)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Empty as Empty using (⊥)

------------------------------------------------------------------------
-- ० · Unboundedness, constructively: a function meeting every bound,
--     together with the index at which it does.
------------------------------------------------------------------------

Unbounded : (ℕ → ℕ) → Type₀
Unbounded f = (M : ℕ) → Σ[ n ∈ ℕ ] (M ≤ f n)

------------------------------------------------------------------------
-- ०ब · Doubling reflects the order.
------------------------------------------------------------------------

double-cancel : (m n : ℕ) → (m + m) ≤ (n + n) → m ≤ n
double-cancel zero    n       _ = zero-≤
double-cancel (suc m) zero    h = Empty.rec (¬suc≤zero h)
  where
    ¬suc≤zero : (suc m + suc m) ≤ zero → ⊥
    ¬suc≤zero (k , p) = snotz (sym (+-suc k (m + suc m)) ∙ p)
double-cancel (suc m) (suc n) h =
  suc-≤-suc (double-cancel m n (pred-≤-pred (pred-≤-pred h')))
  where
    h' : suc (suc (m + m)) ≤ suc (suc (n + n))
    h' = subst2 _≤_ (cong suc (+-suc m m)) (cong suc (+-suc n n)) h

------------------------------------------------------------------------
-- १ · THE PAIRED DIVERGENCE.
--
-- Hypotheses, in the order they are used:
--   diff  : the budgets differ by the fixed constant c, at every index
--   dom±  : each budget dominates its own sector quantity
--   grow  : the sum of the sector quantities is unbounded
--
-- Route: the sum of the budgets dominates the sum of the sectors, so it
-- is unbounded; `b₊` dominates `b₋` (by `diff`), so `b₊` alone is
-- unbounded after halving; and `diff` then transfers that to `b₋` by
-- cancelling the constant — the step that would fail if the difference
-- were merely bounded rather than fixed.
------------------------------------------------------------------------

module _ (b₊ b₋ k₊ k₋ : ℕ → ℕ) (c : ℕ)
         (diff : (n : ℕ) → b₊ n ≡ c + b₋ n)
         (dom₊ : (n : ℕ) → k₊ n ≤ b₊ n)
         (dom₋ : (n : ℕ) → k₋ n ≤ b₋ n)
         where

  -- the sum of the budgets dominates the sum of the sectors
  sum-dominates : (n : ℕ) → (k₊ n + k₋ n) ≤ (b₊ n + b₋ n)
  sum-dominates n = ≤-+-≤ (dom₊ n) (dom₋ n)

  -- `b₋` is never larger than `b₊`: they differ by `c`, and `c ≥ 0`
  right-below-left : (n : ℕ) → b₋ n ≤ b₊ n
  right-below-left n = subst (b₋ n ≤_) (sym (diff n)) ≤SumRight

  -- hence the sum of the budgets is at most twice `b₊`
  sum-below-double : (n : ℕ) → (b₊ n + b₋ n) ≤ (b₊ n + b₊ n)
  sum-below-double n = ≤-k+ (right-below-left n)

  -- §1a · the larger budget is unbounded
  left-unbounded : Unbounded (λ n → k₊ n + k₋ n) → Unbounded b₊
  left-unbounded grow M with grow (M + M)
  ... | n , M+M≤sum =
    n , double-cancel M (b₊ n)
          (≤-trans (≤-trans M+M≤sum (sum-dominates n)) (sum-below-double n))

  -- §1b · and so is the smaller: cancel the fixed constant
  right-unbounded : Unbounded (λ n → k₊ n + k₋ n) → Unbounded b₋
  right-unbounded grow M with left-unbounded grow (c + M)
  ... | n , c+M≤b₊ =
    n , ≤-k+-cancel (subst ((c + M) ≤_) (diff n) c+M≤b₊)

  -- §1 · both, together
  both-unbounded :
      Unbounded (λ n → k₊ n + k₋ n)
    → Unbounded b₊ × Unbounded b₋
  both-unbounded grow = left-unbounded grow , right-unbounded grow

  ----------------------------------------------------------------------
  -- २ · The exact comparison, at every index, with no limit taken:
  --     each budget is within the SAME constant `c` of the other.
  ----------------------------------------------------------------------

  within-c-above : (n : ℕ) → b₊ n ≤ (c + b₋ n)
  within-c-above n = subst (_≤ (c + b₋ n)) (sym (diff n)) ≤-refl

  within-c-below : (n : ℕ) → b₋ n ≤ (c + b₊ n)
  within-c-below n = ≤-trans (right-below-left n) ≤SumRight
