{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पुनरागमनं शून्ये एव — return is only at zero.  (Saṃrakṣaṇa-sūtra १६
-- reads: पुनरागमनं शून्य-व्ययेन एव, return is only at zero cost.  The
-- sūtra names the discipline; this module proves the sūtra's shape as a
-- theorem about a concrete priced cycle, and the identification of the
-- two is a READING, said as one.)
--
-- DEEPER than the witnesses.  Anirdharita_IntegerHullMultiplicity_
-- AllFourSections killed the queue's four section guesses at t = 1.
-- The host's price theorems license the general law, every t at once:
-- hull's census is six per unit (hullN : N (hull t) ≡ t · 6) and eight
-- per unit squared (hullSQ : SQ (hull t) ≡ t · 8), so the loop
-- ℕ → Config → ℕ through hull returns to its argument EXACTLY at zero:
--
--     N  (hull t) ≡ t   ⟺   t ≡ 0
--     SQ (hull t) ≡ t   ⟺   t ≡ 0
--
-- The engine underneath is one lemma with no solver and no ordering
-- theory: a cycle whose price per turn is a positive multiplier has no
-- fixed point above zero — suc (k + s · suc m) ≡ s is refutable by
-- descent on s, the multiplier peeling one suc into the additive debt k
-- each round.  The probe measured this negatively (no section); this
-- states it positively: the fibre of "returned" is the singleton {0}.
-- Zero cost, zero content, the only weightless walk — and the walked
-- ledger's own chronology-protection reading (README movement 6), here
-- as a two-line term about lists of naturals.
------------------------------------------------------------------------

module Ratri.Nirdharana_Hull_PunaragamanaSunyeEva where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ; zero; suc; _+_; _·_; snotz; injSuc; +-suc; +-assoc)
open import Cubical.Data.Empty as Empty using (⊥)
open import IntegerHullMultiplicity using (Config; hull; N; SQ; hullN; hullSQ)

-- A positively-priced loop cannot close above zero: descent on s,
-- each round converting one unit of the multiplier into standing debt.
noReturn : (m s k : ℕ) → suc (k + s · suc m) ≡ s → ⊥
noReturn m zero    k p = snotz p
noReturn m (suc s) k p = noReturn m s (k + m) (sym step ∙ injSuc p)
  where
  step : k + (suc m + s · suc m) ≡ suc ((k + m) + s · suc m)
  step = +-suc k (m + s · suc m) ∙ cong suc (+-assoc k m (s · suc m))

-- t · 6 ≡ t forces t ≡ 0 …
six≡self→zero : (t : ℕ) → t · 6 ≡ t → t ≡ 0
six≡self→zero zero    _ = refl
six≡self→zero (suc s) p = Empty.rec (noReturn 5 s 4 (injSuc p))

-- … and t · 8 ≡ t likewise.
eight≡self→zero : (t : ℕ) → t · 8 ≡ t → t ≡ 0
eight≡self→zero zero    _ = refl
eight≡self→zero (suc s) p = Empty.rec (noReturn 7 s 6 (injSuc p))

------------------------------------------------------------------------
-- THE LAW, both loops, both directions.

N-returns-only-at-zero : (t : ℕ) → N (hull t) ≡ t → t ≡ 0
N-returns-only-at-zero t p = six≡self→zero t (sym (hullN t) ∙ p)

SQ-returns-only-at-zero : (t : ℕ) → SQ (hull t) ≡ t → t ≡ 0
SQ-returns-only-at-zero t p = eight≡self→zero t (sym (hullSQ t) ∙ p)

-- and at zero, both return:
N-returns-at-zero : N (hull 0) ≡ 0
N-returns-at-zero = refl

SQ-returns-at-zero : SQ (hull 0) ≡ 0
SQ-returns-at-zero = refl
