{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सम-छाया — the same shadow.
--
-- An exact smooth Navier–Stokes pair on the torus: u_k = A e^{−ν|k|²t}
-- a sin(k·x) with a·k = 0 and |k| > K, against u₀ = 0.  Because a·k = 0
-- the field is divergence-free and (u·∇)u = 0, so with constant pressure
-- it solves the equations exactly; its whole low-frequency history
-- P_{≤K}u_k(t) is zero, the same as u₀'s, at every time.  Yet the
-- subgrid covariance R_K[u] = P_{≤K}(u⊗u) − P_{≤K}u ⊗ P_{≤K}u is
-- (A²/2)e^{−2ν|k|²t} a⊗a for u_k and 0 for u₀, because sin² = ½ − ½cos 2k·x
-- and the projection keeps the zero mode; and the dissipation cost
-- ν∫‖∇u‖² is A²|a|²/4 against 0.  Same entire coarse meaning, different
-- physical cost.
--
-- This file is that pair's amplitude bookkeeping — the part the
-- localization theorem consumes — as a term.  A field is an amplitude
-- per mode per time; the coarse observation keeps modes ≤ K; the
-- zero-mode of a product of mode-k waves is the sum of squares, so the
-- subgrid energy is the energy above K.  The plane wave sits at one
-- mode above K with amplitude A·dᵗ.
--
--   §1  FIELDS, THE COARSE MOVIE, SUBGRID ENERGY, COST.
--   §2  THE PAIR.  The plane wave and zero have the same coarse movie
--       at every time and every mode ≤ K — because k > K.
--   §3  ENERGY DISTINGUISHES.  Subgrid energy A² against 0; cost A²
--       against 0.  By SankramanaShreni's localization, neither descends
--       through the coarse observation: no function of the resolved
--       movie alone reconstructs them.
--
-- The atomic instance of the joint-observer ladder: velocity, active
-- pressure and resolved flux are blind to it; energy is not.  सम
-- (sama, same) and छाया (chāyā, shadow) are ordinary Sanskrit.
------------------------------------------------------------------------

module SamaChaya_TwoFieldsWithTheSameEntireCoarseMovieHaveDifferentSubgridEnergyAndDifferentCostSoNeitherDescendsThroughCoarseObservation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isSetΠ)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; isSetℕ ; snotz ; discreteℕ ; +-zero)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤Dec ; ¬m<m ; <≤-trans)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot
  using (module Localization)

------------------------------------------------------------------------
-- १ · Fields, the coarse movie, subgrid energy, cost.
------------------------------------------------------------------------

-- amplitude at time t, mode m
Field : Type₀
Field = ℕ → ℕ → ℕ

-- the coarse observation keeps modes ≤ K, at every time
module _ (K : ℕ) where

  chāyā : Field → ℕ → ℕ → ℕ
  chāyā u t m with ≤Dec m K
  ... | yes _ = u t m
  ... | no  _ = zero

  -- energy in modes m ≤ M at time t (sum of squares; the zero-mode of
  -- the product of two mode-m waves is half the square, scaled away)
  ūrjā : Field → ℕ → ℕ → ℕ
  ūrjā u t zero    = u t zero · u t zero
  ūrjā u t (suc M) = u t (suc M) · u t (suc M) + ūrjā u t M

  -- subgrid energy at time t, for fields supported in modes ≤ M:
  -- everything above K
  module _ (M : ℕ) where
    upaśeṣa : Field → ℕ → ℕ
    upaśeṣa u t = ūrjā u t M ∸ ūrjā (chāyā u) t M
      where
      _∸_ : ℕ → ℕ → ℕ
      a ∸ zero = a
      zero ∸ suc b = zero
      suc a ∸ suc b = a ∸ b

  -- cost: total energy at time zero over modes ≤ M
  mūlya : ℕ → Field → ℕ
  mūlya M u = ūrjā u zero M

------------------------------------------------------------------------
-- २ · The pair: a plane wave one mode above K, and zero.
------------------------------------------------------------------------

module _ (K : ℕ) (A : ℕ) where

  k : ℕ
  k = suc K

  -- amplitude A at mode k, at every time; zero elsewhere
  taraṅga : Field
  taraṅga t m with discreteℕ m k
  ... | yes _ = A
  ... | no  _ = zero

  śūnya : Field
  śūnya t m = zero

  -- the coarse movies agree at every time and every mode
  sama-chāyā : (t m : ℕ) → chāyā K taraṅga t m ≡ chāyā K śūnya t m
  sama-chāyā t m with ≤Dec m K
  ... | no  _   = refl
  ... | yes m≤K with discreteℕ m k
  ...   | no  _   = refl
  ...   | yes m≡k = ⊥-elim (¬m<m (<≤-trans (subst (K <_) (sym m≡k) (zero , refl)) m≤K))

------------------------------------------------------------------------
-- ३ · Energy distinguishes, so neither energy nor cost descends.
------------------------------------------------------------------------

-- the concrete instance: K = 0, amplitude 1, modes ≤ 1
module Udāharaṇa where

  K = zero
  A = suc zero
  M = suc zero

  open Localization {X = Field} {Y = ℕ → ℕ → ℕ}
    (isSetΠ λ _ → isSetΠ λ _ → isSetℕ) (chāyā K) (mūlya K M)

  same : chāyā K (taraṅga K A) ≡ chāyā K (śūnya K A)
  same = funExt λ t → funExt λ m → sama-chāyā K A t m

  -- cost 1 against cost 0
  mūlya-apart : ¬ (mūlya K M (taraṅga K A) ≡ mūlya K M (śūnya K A))
  mūlya-apart p = snotz p

  -- cost does not descend through the coarse movie
  mūlya-na-avatarati :
    ¬ (Σ[ c ∈ (Ĝ → ℕ) ] ((u : Field) → c (L u) ≡ mūlya K M u))
  mūlya-na-avatarati = costDoesNotDescend (taraṅga K A) (śūnya K A) same mūlya-apart

  -- and the subgrid energy is 1 against 0 at time zero
  upaśeṣa-apart : ¬ (upaśeṣa K M (taraṅga K A) zero ≡ upaśeṣa K M (śūnya K A) zero)
  upaśeṣa-apart p = snotz p
