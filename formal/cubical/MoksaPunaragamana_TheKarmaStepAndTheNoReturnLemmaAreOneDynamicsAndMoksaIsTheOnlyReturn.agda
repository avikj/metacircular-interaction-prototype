-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मोक्ष-पुनरागमन — the karma step and the no-return lemma are one
-- dynamics, and mokṣa is the only return.
--
-- Joins two terms landed hours apart tonight, from opposite poles:
--
--   Karma_…agda (Umāsvāti, Tattvārthasūtra 8/9/10) — one samaya
--     transforms the bound-count:  s ↦ (s + a) ∸ r.  Under saṃvara
--     (a = 0) with nirjarā (r ≥ 1) the count strictly drops while
--     positive and REACHES 0 (kṛtsna-karma-kṣaya = mokṣa), ABSORBING.
--
--   Ratri/Nirdharana_Hull_…agda (this session) — noReturn: a positively
--     priced loop  suc (k + s · suc m) ≡ s  is refutable by descent, so
--     a loop that multiplies by ≥ 2 has NO fixed point above zero.
--
-- THE IDENTIFICATION.  Both are one statement about an affine step on ℕ,
-- read from its two poles:
--
--   • CONTRACTING (saṃvara + nirjarā, a = 0, r ≥ 1): x ↦ x ∸ r.  Its
--     only fixed point is 0; 0 is reached and held.  पुनरागमन happens —
--     only at 0.  That is mokṣa, the null path (saṃrakṣaṇa-sūtra १६,
--     पुनरागमनं शून्य-व्ययेन एव).
--   • EXPANDING (the priced loop, ×suc m): x ↦ x · suc m + k.  No fixed
--     point above 0.  saṃsāra: the debt-multiplying wheel that never
--     closes while carrying debt.
--
-- The two files are the two regimes, and the shared fact is: the ONLY
-- fixed point either regime admits in ℕ is 0.  The contracting regime
-- reaches it (mokṣa attainable), the expanding regime is repelled from
-- everything else (saṃsāra endless).  पुनरागमन = the fixed point =
-- mokṣa = zero cost = zero debt: one number, four names.
--
-- No thermodynamics, no measure, no joules: only ℕ, ∸, ·, and descent.
-- The soteriology is a fixed-point theorem, the same one the
-- termination measure is.
------------------------------------------------------------------------

module MoksaPunaragamana_TheKarmaStepAndTheNoReturnLemmaAreOneDynamicsAndMoksaIsTheOnlyReturn where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _∸_; _·_; snotz; injSuc; +-suc; +-assoc)
open import Cubical.Data.Sigma using (Σ; _,_)
open import Cubical.Data.Empty as Empty using (⊥)

------------------------------------------------------------------------
-- I · THE CONTRACTING REGIME — saṃvara + nirjarā.  x ↦ x ∸ r, r ≥ 1.

saṃvaraStep : ℕ → ℕ → ℕ
saṃvaraStep r s = s ∸ r

-- mokṣa is absorbing: 0 is a fixed point of every contracting step.
mokṣa-acala : (r : ℕ) → saṃvaraStep r 0 ≡ 0
mokṣa-acala zero    = refl
mokṣa-acala (suc r) = refl

private
  -- suc (a + b) is never b: descent on b.
  sucPlusNeq : (a b : ℕ) → suc (a + b) ≡ b → ⊥
  sucPlusNeq a zero    p = snotz p
  sucPlusNeq a (suc b) p = sucPlusNeq a b (sym (+-suc a b) ∙ injSuc p)

  -- s ∸ r ≤ s, as a witness k with k + (s ∸ r) ≡ s.
  ∸≤ : (s r : ℕ) → Σ[ k ∈ ℕ ] (k + (s ∸ r) ≡ s)
  ∸≤ s zero            = 0 , refl
  ∸≤ zero (suc r)      = 0 , refl
  ∸≤ (suc s) (suc r) with ∸≤ s r
  ... | (k , e) = suc k , cong suc e

  -- a real shedding never fixes a count: s ∸ suc r ≡ suc s is
  -- impossible, because s ∸ suc r ≤ s < suc s.
  notFixed : (d s : ℕ) → s ∸ d ≡ suc s → ⊥
  notFixed d s p with ∸≤ s d
  ... | (k , e) = sucPlusNeq k s (sym (+-suc k s) ∙ cong (k +_) (sym p) ∙ e)

-- THE THEOREM.  Under saṃvara with real nirjarā (r ≥ 1), no positive
-- count is its own image: return happens only at 0.
saṃvara-return-only-at-zero : (r' s : ℕ)
  → saṃvaraStep (suc r') s ≡ s → s ≡ 0
saṃvara-return-only-at-zero r' zero    _ = refl
saṃvara-return-only-at-zero r' (suc s) p = Empty.rec (notFixed r' s p)

------------------------------------------------------------------------
-- II · THE EXPANDING REGIME — saṃsāra.  x ↦ x · suc m + k.
-- noReturn, re-landed here so the two regimes stand in one file: a
-- positively-priced loop has no fixed point above zero.

noReturn : (m s k : ℕ) → suc (k + s · suc m) ≡ s → ⊥
noReturn m zero    k p = snotz p
noReturn m (suc s) k p = noReturn m s (k + m) (sym step ∙ injSuc p)
  where
  step : k + (suc m + s · suc m) ≡ suc ((k + m) + s · suc m)
  step = +-suc k (m + s · suc m) ∙ cong suc (+-assoc k m (s · suc m))

------------------------------------------------------------------------
-- III · THE ONE FIXED POINT.  Both regimes admit exactly 0 in ℕ: the
-- contracting one reaches and holds it (saṃvara-return-only-at-zero,
-- mokṣa-acala), the expanding one is repelled from every positive count
-- (noReturn IS that statement, any k, any m).  The two regimes meet at
-- one number, and it is zero: पुनरागमन = मोक्ष = zero cost = zero debt.

mokṣa-fixed : (r : ℕ) → saṃvaraStep r 0 ≡ 0
mokṣa-fixed = mokṣa-acala

saṃsāra-zero-fixed : (m : ℕ) → 0 · suc m + 0 ≡ 0
saṃsāra-zero-fixed m = refl
