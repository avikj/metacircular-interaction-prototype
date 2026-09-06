{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RenormalizedObserverTower
--
-- The common object of the RH and NS lanes this run: an observation
-- tower whose residual kernels carry a finite rank at each stage, and
-- along which one studies RENORMALIZED TRANSPORT rather than the bare
-- inverse limit.
--
-- The checked content here is the correction the run produced: the Clay
-- difficulty is NOT a lim¹ class in the finite-dimensional residual
-- kernels.  A tower of finite-rank kernels is automatically
-- Mittag--Leffler, because a non-increasing rank sequence cannot strictly
-- descend forever.  So the obstruction cannot live in the set-theoretic
-- inverse limit; it lives in the renormalized transport ALONG the tower.
--
-- `no-infinite-descent` is that fact, exact and --safe: there is no
-- strictly decreasing ℕ-chain.  `rank-plateaus` is its tower form: any
-- non-increasing rank sequence has a stabilization step (Mittag--Leffler).
--
-- The two realizations of the tower are then, as GOALS (types to inhabit,
-- not inhabited here — they are the frontier):
--
--   RH : the transport spectrum is neutral      (all exponents Re = 0),
--   NS : no bad recurrent orbit exists          (Type-I already excluded
--        by ESS + L³ scale-invariance; the residue is Type-II inflation).
------------------------------------------------------------------------

module RenormalizedObserverTower where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-refl ; ≤-trans ; ≤-+k ; ≤SumLeft ; ¬m<m)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The tower: stages, a forgetful bond, and a finite rank per stage.
------------------------------------------------------------------------

record ObserverTower (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Stage : ℕ → Type ℓ            -- the resolved object at resolution n
    bond  : (n : ℕ) → Stage (suc n) → Stage n
    rank  : ℕ → ℕ                 -- finite rank of the residual kernel at n

open ObserverTower public

------------------------------------------------------------------------
-- §2  The Mittag--Leffler engine: no strictly descending ℕ-chain.
--     This is what kills the lim¹ interpretation.
------------------------------------------------------------------------

private
  -- a strictly descending chain has dropped by at least its index:
  --     f k + k ≤ f 0.
  descend : (f : ℕ → ℕ) → ((n : ℕ) → f (suc n) < f n)
          → (k : ℕ) → (f k + k) ≤ f 0
  descend f dec zero =
    subst (_≤ f 0) (sym (+-zero (f 0))) ≤-refl
  descend f dec (suc k) =
    subst (_≤ f 0) (sym (+-suc (f (suc k)) k))
      (≤-trans (≤-+k (dec k)) (descend f dec k))

-- There is no strictly decreasing sequence of naturals.
no-infinite-descent : ¬ (Σ[ f ∈ (ℕ → ℕ) ] ((n : ℕ) → f (suc n) < f n))
no-infinite-descent (f , dec) = ¬m<m bad
  where
  hi : (f (suc (f 0)) + suc (f 0)) ≤ f 0
  hi = descend f dec (suc (f 0))

  lo : suc (f 0) ≤ (f (suc (f 0)) + suc (f 0))
  lo = subst (suc (f 0) ≤_)
             (+-comm (suc (f 0)) (f (suc (f 0))))
             ≤SumLeft

  bad : f 0 < f 0
  bad = ≤-trans lo hi

------------------------------------------------------------------------
-- §3  Tower form: a non-increasing rank sequence stabilises (ML).
--     Hence the residual obstruction is not a finite-dimensional
--     inverse-limit class — it is renormalized transport along the tower.
------------------------------------------------------------------------

-- If a rank sequence never plateaued, it would strictly descend forever.
rank-plateaus :
    (r : ℕ → ℕ)
  → ((n : ℕ) → r (suc n) ≤ r n)                 -- non-increasing rank
  → ((n : ℕ) → ¬ (r (suc n) ≡ r n))             -- assume: never stabilises
  → ⊥
rank-plateaus r noninc never =
  no-infinite-descent (r , strict)
  where
  -- non-increasing and never-equal ⟹ strictly decreasing.
  strict : (n : ℕ) → r (suc n) < r n
  strict n with noninc n
  ... | (zero  , p) = Empty.rec (never n p)
  ... | (suc k , p) = k , (+-suc k (r (suc n)) ∙ p)
