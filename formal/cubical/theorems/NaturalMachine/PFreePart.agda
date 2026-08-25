{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PFreePart
--
-- The p-adic split, as a term:
--
--     pFreePart : 1 < p → 0 < m
--               → Σ[ a ] Σ[ m' ] ((m ≡ (p ^ a) · m') × ¬ (p ∣ m'))
--
-- Every positive m factors as `p^a · m'` with `p` not dividing `m'`.
-- Classical, and the piece `FrontierDivides` §2 needs — that section
-- names the hard half of the universal property and says it requires
-- multiplicities, not just existence of a factorisation.  This is the
-- multiplicity, extracted one prime at a time.
--
-- ────────────────────────────────────────────────────────────────────
-- PRIOR ART, SEARCHED FIRST
--
-- `CoprimeSplitting.dec∣ : (d n : ℕ) → 0 < d → Dec (d ∣ n)` is the
-- decision this needs, and that module's header explains why it exists:
-- cubical v0.5 has no decidable divisibility, so it is a bounded search
-- with fuel accounted for honestly.  The descent below is the same idiom
-- as `Factorisation.factorise-fuel`, one file over.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT DOES NOT DO
--
-- It does not close `FrontierDivides`'s hard half.  That needs, on top of
-- this: that `a ≤ ⌊log_p k⌋` when `p^a ∣ m ≤ k`, that `p` with its
-- exponent is in `frontierList k`, and that `gcd(p^a, m') = 1` follows
-- from `p ∤ m'` — the last being `CoprimePowers.bez-pow` once the base
-- certificate is in hand.  Those are named, not estimated: this thread
-- has four wrong estimates in it and the rule that came out of them
-- stands.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PFreePart where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-untrunc)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.CoprimeSplitting using (dec∣)

------------------------------------------------------------------------
-- 1.  Dividing by p strictly shrinks a positive number, when p > 1
------------------------------------------------------------------------

private
  c<2c : (c : ℕ) → 0 < c → c < 2 · c
  c<2c c 0<c = subst2 _≤_ (+-comm c 1) (sym two-c) (≤-k+ 0<c)
    where
    two-c : 2 · c ≡ c + c
    two-c = cong (c +_) (+-zero c)

  shrink : (c p m : ℕ) → 0 < c → 1 < p → c · p ≡ m → c < m
  shrink c p m 0<c 1<p pc =
    subst (c <_) (·-comm p c ∙ pc) (<≤-trans (c<2c c 0<c) (≤-·k 1<p))

  cofactor-pos : (c p m : ℕ) → 0 < m → c · p ≡ m → 0 < c
  cofactor-pos zero    p m 0<m pc = Empty.rec (¬-<-zero (subst (0 <_) (sym pc) 0<m))
  cofactor-pos (suc c) p m _   _  = suc-≤-suc zero-≤

------------------------------------------------------------------------
-- 2.  THE SPLIT, by fuel — this lane's idiom for a bounded descent
------------------------------------------------------------------------

Split : ℕ → ℕ → Type
Split p m = Σ[ a ∈ ℕ ] Σ[ m' ∈ ℕ ] ((m ≡ (p ^ a) · m') × (¬ (p ∣ m')))

pFree-fuel : (fuel p m : ℕ) → 1 < p → 0 < m → m ≤ fuel → Split p m
pFree-fuel zero    p m 1<p 0<m m≤f = Empty.rec (¬-<-zero (<≤-trans 0<m m≤f))
pFree-fuel (suc f) p m 1<p 0<m m≤f = go (dec∣ p m (<-trans (suc-≤-suc zero-≤) 1<p))
  where
  go : Dec (p ∣ m) → Split p m
  go (no ¬p∣m) = 0 , m , sym (·-identityˡ m) , ¬p∣m
  go (yes p∣m) = peel (∣-untrunc p∣m)
    where
    peel : Σ[ c ∈ ℕ ] (c · p ≡ m) → Split p m
    peel (c , pc) =
      suc (rec .fst) , rec .snd .fst ,
      ( sym pc
      ∙ cong (_· p) (rec .snd .snd .fst)
      ∙ regroup p (rec .fst) (rec .snd .fst) ) ,
      rec .snd .snd .snd
      where
      0<c : 0 < c
      0<c = cofactor-pos c p m 0<m pc

      c<m : c < m
      c<m = shrink c p m 0<c 1<p pc

      rec : Split p c
      rec = pFree-fuel f p c 1<p 0<c (pred-≤-pred (<≤-trans c<m m≤f))

      regroup : (p a m' : ℕ) → ((p ^ a) · m') · p ≡ (p ^ (suc a)) · m'
      regroup p a m' =
          sym (·-assoc (p ^ a) m' p)
        ∙ cong ((p ^ a) ·_) (·-comm m' p)
        ∙ ·-assoc (p ^ a) p m'
        ∙ cong (_· m') (·-comm (p ^ a) p)

pFreePart : (p m : ℕ) → 1 < p → 0 < m → Split p m
pFreePart p m 1<p 0<m = pFree-fuel m p m 1<p 0<m ≤-refl

------------------------------------------------------------------------
-- 3.  It runs.  12 = 2² · 3, and 3 is not divisible by 2.
------------------------------------------------------------------------

split-12 : Split 2 12
split-12 = pFreePart 2 12 (suc-≤-suc (suc-≤-suc zero-≤)) (suc-≤-suc zero-≤)

split-12-exponent : split-12 .fst ≡ 2
split-12-exponent = refl

split-12-cofactor : split-12 .snd .fst ≡ 3
split-12-cofactor = refl

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by another identity, at the end, altering no line
-- above.  THE "WHAT IT DOES NOT DO" LIST IS OUT OF DATE, and the module
-- that dated it does not say so here.
--
-- That section names three pieces:
--   (1) that `a ≤ ⌊log_p k⌋` when `p^a ∣ m ≤ k`
--   (2) that `p` with its exponent is in `frontierList k`
--   (3) that `gcd(p^a, m') = 1` follows from `p ∤ m'`
--
-- `NaturalMachine/ExponentBound.agda` closes (1), as `exponent-bounded`,
-- and its header is explicit that it is "A CORRECTION TO `PFreePart`'s
-- OPEN LIST": the three were listed as comparable and are not, because
-- (1) carried a hidden second obligation -- that a fuel bound is adequate
-- -- where a computation (`frontier8 = refl`) had been standing in for a
-- theorem about all `k`.  That is precisely the substitution this
-- repository's protocol exists to catch.
--
-- And `NaturalMachine/PrimeCofactorCoprime.agda` bears on (3): a common
-- divisor of a prime `p` and `m` is 1 or `p` by the lane's own `IsPrime`,
-- and `p ∤ m` kills the second branch, so it needs no Euclid.
--
-- WHY THIS IS A COMMENT AND NOT AN IMPORT.  Elsewhere today a correction
-- was made load-bearing by importing the corrector's theorem into the
-- corrected module, so the dependency cannot be missed.  That is not
-- available here: `ExponentBound` already imports THIS module, so the
-- back-import would be a cycle.  A pointer is the strongest available
-- mechanism in this direction, and saying so is better than using the
-- weaker one silently.
--
-- Nothing above is retracted.  `pFreePart` is untouched and the list was
-- honest when written; it is only stale.
-- ---------------------------------------------------------------------
