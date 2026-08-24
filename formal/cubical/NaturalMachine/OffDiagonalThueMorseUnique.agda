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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.OffDiagonalThueMorseUnique
--
-- *** KERNEL-CHECKED under the FALLBACK toolchain, not the pin. ***
-- Typechecks with Agda 2.6.3 + agda/cubical v0.5 (the toolchain actually
-- installed in this container: /usr/bin/agda 2.6.3, /root/agda-libs/cubical
-- at tag v0.5).  NOT the pin (2.8.0 / v0.9), so `formal/cubical/check.sh`
-- will (correctly) refuse to call it green until a pinned session re-runs
-- it.  But it IS a checked term, not a rumour: the many "AWAITING KERNEL
-- (there is no agda in this container)" headers across this corpus are
-- FALSE for --safe cubical-v0.5 code.  See the accompanying message.
--
-- SOURCE.  `notes/OFFDIAGONAL_NO_GO_UNIQUENESS.md` (claude-drishti,
-- 2026-08-18), the "derived uniqueness" companion to
-- `notes/OFFDIAGONAL_NO_GO.md` (cf-prouhet, 2026-08-18).  That note's
-- load-bearing sentence, flagged there as "a paper proof, not a checked
-- term":
--
--     the recursion  ε(2m) = ε(m),  ε(2m+1) = −ε(m)  determines the entire
--     sequence from ε₀ alone; there are exactly two solutions, ε₀ = ±1.
--
-- This file certifies exactly the non-obvious half — UNIQUENESS.
-- Coefficients ±1 are modelled as `Bool` (+1 ↦ true, −1 ↦ false);
-- negation `−` ↦ `not`.  "exactly two solutions" is:
--   * uniqueGivenHead (certified here): any two solutions agreeing at 0
--       agree everywhere, so the solution set injects into Bool = {ε₀};
--   * existence of a solution for each ε₀ (the classical Thue–Morse
--       sequence, cf-prouhet's explicit p = ∏ₖ(1 − x^{2ᵏ})): its formal
--       function-definition is a separable WF-recursion landing and is
--       NOT claimed here.
--
-- The obstruction "is one bit wide" (drishti): uniqueGivenHead says the
-- fibre of the forget-the-diagonal map over a full-line partition is a
-- single Bool.
------------------------------------------------------------------------

module NaturalMachine.OffDiagonalThueMorseUnique where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool hiding (_≤_)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.IsEven
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as ⊥

------------------------------------------------------------------------
-- The functional-equation recursion, on ±1 ≅ Bool.
--
--   Sat ε  ≡  (∀m. ε(2·m) ≡ ε m)  ×  (∀m. ε(1+2·m) ≡ not (ε m))
--
-- This is (FE) p = (1−x) p(x²) read off coefficient-by-coefficient, once
-- q = 1/(1−x) is forced by "A ⊔ B is a partition of ℤ≥0" (every coefficient
-- of p is ±1).  See the source note §"The derivation".
------------------------------------------------------------------------

Sat : (ℕ → Bool) → Type
Sat ε = (∀ m → ε (2 · m) ≡ ε m) × (∀ m → ε (suc (2 · m)) ≡ not (ε m))

------------------------------------------------------------------------
-- Arithmetic: the half of a positive n is strictly smaller than n.
------------------------------------------------------------------------

-- m ≤ 2·m, always.
m≤2m : (m : ℕ) → m ≤ 2 · m
m≤2m m = m , cong (m +_) (sym (+-zero m))

-- x < x + suc y.
lt-plus-suc : (x y : ℕ) → x < x + suc y
lt-plus-suc x y =
  subst (suc x ≤_) (sym (+-suc x y)) (suc-≤-suc (y , +-comm y x))

-- 0 < m → m < 2·m.
half< : (m : ℕ) → 0 < m → m < 2 · m
half< (suc m') _ =
  subst (suc m' <_) (cong (suc m' +_) (sym (+-zero (suc m'))))
        (lt-plus-suc (suc m') m')
half< zero p = ⊥.rec (¬-<-zero p)

-- Given a witness that suc n is even (= 2·m), its half m is below suc n.
half<even : (n m : ℕ) → suc n ≡ 2 · m → m < suc n
half<even n zero     p = ⊥.rec (snotz p)
half<even n (suc m') p =
  subst (suc m' <_) (sym p) (half< (suc m') (suc-≤-suc zero-≤))

-- Given a witness that suc n is odd (= suc (2·m)), its half m is below suc n.
half<odd : (n m : ℕ) → suc n ≡ suc (2 · m) → m < suc n
half<odd n m p = subst (m <_) (sym p) (≤<-trans (m≤2m m) ≤-refl)

------------------------------------------------------------------------
-- Uniqueness, by fuel induction on a bound k with n < k.
------------------------------------------------------------------------

uniqueUpTo : (ε δ : ℕ → Bool) → Sat ε → Sat δ → ε 0 ≡ δ 0
           → (k n : ℕ) → n < k → ε n ≡ δ n
uniqueUpTo ε δ sε sδ h0 zero    n        n<0  = ⊥.rec (¬-<-zero n<0)
uniqueUpTo ε δ sε sδ h0 (suc k) zero     _    = h0
uniqueUpTo ε δ sε sδ h0 (suc k) (suc n') n<sk
  with dichotomyBool (isEven (suc n'))
... | inl ev =
      let (m , p) = isEvenTrue (suc n') ev            -- suc n' ≡ 2·m
          m<sn : m < suc n'
          m<sn = half<even n' m p
          m<k  : m < k
          m<k  = ≤-trans m<sn (pred-≤-pred n<sk)
          ih   : ε m ≡ δ m
          ih   = uniqueUpTo ε δ sε sδ h0 k m m<k
      in  cong ε p            -- ε (suc n') ≡ ε (2·m)
        ∙ fst sε m            -- ε (2·m)    ≡ ε m
        ∙ ih                  -- ε m        ≡ δ m
        ∙ sym (fst sδ m)      -- δ m        ≡ δ (2·m)
        ∙ cong δ (sym p)      -- δ (2·m)    ≡ δ (suc n')
... | inr od =
      let (m , p) = isEvenFalse (suc n') od           -- suc n' ≡ suc (2·m)
          m<sn : m < suc n'
          m<sn = half<odd n' m p
          m<k  : m < k
          m<k  = ≤-trans m<sn (pred-≤-pred n<sk)
          ih   : ε m ≡ δ m
          ih   = uniqueUpTo ε δ sε sδ h0 k m m<k
      in  cong ε p            -- ε (suc n') ≡ ε (suc (2·m))
        ∙ snd sε m            -- ε (suc 2·m)≡ not (ε m)
        ∙ cong not ih         -- not (ε m)  ≡ not (δ m)
        ∙ sym (snd sδ m)      -- not (δ m)  ≡ δ (suc 2·m)
        ∙ cong δ (sym p)      -- δ (suc 2·m)≡ δ (suc n')

------------------------------------------------------------------------
-- The exported theorem: the recursion + the head ε₀ determine everything.
-- Hence solutions ↪ Bool by ε ↦ ε 0, i.e. at most two — the two Thue–Morse
-- labellings of one partition.
------------------------------------------------------------------------

uniqueGivenHead : (ε δ : ℕ → Bool) → Sat ε → Sat δ → ε 0 ≡ δ 0
                → (n : ℕ) → ε n ≡ δ n
uniqueGivenHead ε δ sε sδ h0 n =
  uniqueUpTo ε δ sε sδ h0 (suc n) n ≤-refl
