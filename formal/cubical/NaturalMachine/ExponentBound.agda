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
-- NaturalMachine.ExponentBound
--
-- The first of the three pieces `PFreePart` named:
--
--     exponent-bounded : 1 < p → 0 < n → n ≤ k → (p ^ a) ∣ n
--                      → a ≤ logOf p k
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT WAS ACTUALLY MISSING, WHICH WAS NOT WHAT WAS NAMED
--
-- `PFreePart` said this piece was "a ≤ ⌊log_p k⌋ when p^a ∣ m ≤ k",
-- as though ⌊log_p k⌋ were a known quantity with known properties.  It
-- is not.  `FrontierList.logOf` is
--
--     expOf p k zero    = 0
--     expOf p k (suc g) = if p ^ suc (expOf p k g) ≤ k then suc … else …
--     logOf p k         = expOf p k k
--
-- — a gas-driven climb whose gas budget is `k` itself, and NOTHING in
-- this repository proved that it climbs far enough.  `frontierList`
-- has been used for the walk's counts on the strength of `refl` at
-- k = 8.  So the content here is the SPECIFICATION of `logOf`, in both
-- directions, and the divisor bound is a corollary of it:
--
--     logOf-le : 0 < k → p ^ (logOf p k)       ≤ k
--     logOf-lt : 1 < p → k < p ^ (suc (logOf p k))
--
-- The second is the one that needed an argument.  It holds because the
-- climb obeys a dichotomy: after `g` steps EITHER it has advanced once
-- per step (`g ≤ expOf p k g`) OR it has already saturated, and once it
-- saturates the same `no` recurs forever.  Saturation must happen by
-- step `k` because a climb that never saturates gives `p ^ k ≤ k`,
-- against `k < p ^ k`.
--
-- That last inequality is the load-bearing one and is proved here from
-- nothing: `k < p^k` for `1 < p`, by induction, using only that
-- `x < p · x` for positive `x`.
--
-- ────────────────────────────────────────────────────────────────────
-- CORRECTION TO `PFreePart`'s OPEN LIST
--
-- That module listed three pieces and treated them as comparable.  They
-- are not.  This one contained a hidden second obligation — that a fuel
-- bound is adequate — of exactly the kind this repository's protocol
-- exists to catch: a computation (`frontier8 = refl`) had been standing
-- in for a theorem about all `k`.  The correction is recorded rather
-- than edited in, per the standing rule.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.ExponentBound where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-refl ; m∣n→m≤n)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.FrontierList using (expOf ; logOf)

------------------------------------------------------------------------
-- 1.  Positivity, and the one strict inequality everything rests on
------------------------------------------------------------------------

private
  0<p-of : {p : ℕ} → 1 < p → 0 < p
  0<p-of 1<p = ≤-trans ≤-sucℕ 1<p

  pos· : (a b : ℕ) → 0 < a → 0 < b → 0 < (a · b)
  pos· zero    b       0<a _   = Empty.rec (¬-<-zero 0<a)
  pos· (suc a) zero    _   0<b = Empty.rec (¬-<-zero 0<b)
  pos· (suc a) (suc b) _   _   = suc-≤-suc zero-≤

  -- the same shape as `PFreePart.shrink`, which is private there
  c<2c : (c : ℕ) → 0 < c → c < 2 · c
  c<2c c 0<c = subst2 _≤_ (+-comm c 1) (sym two-c) (≤-k+ 0<c)
    where
    two-c : 2 · c ≡ c + c
    two-c = cong (c +_) (+-zero c)

-- exported: `FrontierDividesHard` needs it to see m' < p^a · m'
x<p·x : (p x : ℕ) → 1 < p → 0 < x → x < (p · x)
x<p·x p x 1<p 0<x = <≤-trans (c<2c x 0<x) (≤-·k 1<p)

^-pos : (p a : ℕ) → 0 < p → 0 < (p ^ a)
^-pos p zero    _   = ≤-refl
^-pos p (suc a) 0<p = pos· p (p ^ a) 0<p (^-pos p a 0<p)

-- THE inequality that makes the fuel budget `k` adequate.
k<p^k : (p k : ℕ) → 1 < p → k < (p ^ k)
k<p^k p zero    1<p = ≤-refl
k<p^k p (suc k) 1<p =
  ≤<-trans (k<p^k p k 1<p)
           (x<p·x p (p ^ k) 1<p (^-pos p k (0<p-of 1<p)))

------------------------------------------------------------------------
-- 2.  Powers are monotone in the exponent
------------------------------------------------------------------------

private
  ^-mono-shift : (p a d : ℕ) → 0 < p → (p ^ a) ≤ (p ^ (d + a))
  ^-mono-shift p a zero    _   = ≤-refl
  ^-mono-shift p a (suc d) 0<p = ≤-trans (^-mono-shift p a d 0<p) step
    where
    step : (p ^ (d + a)) ≤ (p ^ (suc d + a))
    step = subst (_≤ (p · (p ^ (d + a))))
                 (·-identityˡ (p ^ (d + a)))
                 (≤-·k 0<p)

^-mono : (p a b : ℕ) → 0 < p → a ≤ b → (p ^ a) ≤ (p ^ b)
^-mono p a b 0<p (d , q) =
  subst (λ z → (p ^ a) ≤ (p ^ z)) q (^-mono-shift p a d 0<p)

------------------------------------------------------------------------
-- 3.  The climb: it never overshoots
------------------------------------------------------------------------

expOf-le : (p k gas : ℕ) → 0 < k → (p ^ (expOf p k gas)) ≤ k
expOf-le p k zero      0<k = 0<k
expOf-le p k (suc gas) 0<k with ≤Dec (p ^ (suc (expOf p k gas))) k
... | yes h = h
... | no  _ = expOf-le p k gas 0<k

------------------------------------------------------------------------
-- 4.  The climb: advance-or-saturate, and it cannot advance forever
------------------------------------------------------------------------

private
  ¬≤→< : (a b : ℕ) → ¬ (a ≤ b) → b < a
  ¬≤→< a b h with splitℕ-≤ a b
  ... | inl le = Empty.rec (h le)
  ... | inr strict = strict

  yesStep : (p k gas : ℕ)
          → (p ^ (suc (expOf p k gas))) ≤ k
          → ((gas ≤ expOf p k gas) ⊎ (k < (p ^ (suc (expOf p k gas)))))
          → ((suc gas ≤ suc (expOf p k gas))
             ⊎ (k < (p ^ (suc (suc (expOf p k gas))))))
  yesStep p k gas h (inl le) = inl (suc-≤-suc le)
  yesStep p k gas h (inr strict) = Empty.rec (<-asym strict h)

expOf-dich : (p k gas : ℕ)
           → (gas ≤ expOf p k gas) ⊎ (k < (p ^ (suc (expOf p k gas))))
expOf-dich p k zero      = inl zero-≤
expOf-dich p k (suc gas) with ≤Dec (p ^ (suc (expOf p k gas))) k
... | yes h = yesStep p k gas h (expOf-dich p k gas)
... | no  h = inr (¬≤→< (p ^ (suc (expOf p k gas))) k h)

------------------------------------------------------------------------
-- 5.  THE SPECIFICATION of `logOf`, both directions
------------------------------------------------------------------------

logOf-le : (p k : ℕ) → 0 < k → (p ^ (logOf p k)) ≤ k
logOf-le p k 0<k = expOf-le p k k 0<k

logOf-lt : (p k : ℕ) → 1 < p → k < (p ^ (suc (logOf p k)))
logOf-lt p zero    1<p = pos· p 1 (0<p-of 1<p) ≤-refl
logOf-lt p (suc k) 1<p = go (expOf-dich p (suc k) (suc k))
  where
  e : ℕ
  e = expOf p (suc k) (suc k)

  go : ((suc k ≤ e) ⊎ (suc k < (p ^ (suc e)))) → suc k < (p ^ (suc e))
  go (inr strict) = strict
  go (inl le) = Empty.rec (¬m<m (≤<-trans chain (k<p^k p (suc k) 1<p)))
    where
    chain : (p ^ (suc k)) ≤ suc k
    chain = ≤-trans (^-mono p (suc k) e (0<p-of 1<p) le)
                    (expOf-le p (suc k) (suc k) (suc-≤-suc zero-≤))

------------------------------------------------------------------------
-- 6.  THE PIECE `PFreePart` NAMED
------------------------------------------------------------------------

exponent-bounded : (p k n a : ℕ) → 1 < p → 0 < n → n ≤ k
                 → (p ^ a) ∣ n → a ≤ logOf p k
exponent-bounded p k n a 1<p 0<n n≤k div = go (splitℕ-≤ a (logOf p k))
  where
  n≢0 : ¬ (n ≡ 0)
  n≢0 q = ¬-<-zero (subst (0 <_) q 0<n)

  p^a≤k : (p ^ a) ≤ k
  p^a≤k = ≤-trans (m∣n→m≤n n≢0 div) n≤k

  go : ((a ≤ logOf p k) ⊎ (logOf p k < a)) → a ≤ logOf p k
  go (inl le) = le
  go (inr strict) =
    Empty.rec (<-asym (logOf-lt p k 1<p)
                      (≤-trans (^-mono p (suc (logOf p k)) a (0<p-of 1<p) strict)
                               p^a≤k))

------------------------------------------------------------------------
-- 7.  It runs, on the walk's own frontier
--
--   `FrontierList.frontier8` records (2,3) ∷ … and asserts it by `refl`.
--   Here the entry is derived: 2³ ≤ 8 < 2⁴, and any 2-power dividing any
--   n ≤ 8 has exponent at most 3.
------------------------------------------------------------------------

log-2-8 : logOf 2 8 ≡ 3
log-2-8 = refl

log-3-8 : logOf 3 8 ≡ 1
log-3-8 = refl

log-7-8 : logOf 7 8 ≡ 1
log-7-8 = refl

-- the specification, instantiated
spec-2-8-le : (2 ^ (logOf 2 8)) ≤ 8
spec-2-8-le = logOf-le 2 8 (suc-≤-suc zero-≤)

spec-2-8-lt : 8 < (2 ^ (suc (logOf 2 8)))
spec-2-8-lt = logOf-lt 2 8 (suc-≤-suc (suc-≤-suc zero-≤))

-- 2³ ∣ 8 and 8 ≤ 8, so 3 ≤ log₂ 8 — the exponent the frontier records
bound-8 : 3 ≤ logOf 2 8
bound-8 = exponent-bounded 2 8 8 3
            (suc-≤-suc (suc-≤-suc zero-≤))
            (suc-≤-suc zero-≤)
            ≤-refl
            (∣-refl refl)

------------------------------------------------------------------------
-- 8.  What is left of the hard half.
--
-- CLOSED here: `logOf` has a specification, its fuel budget is proved
-- adequate, and the exponent bound follows.
--
-- STILL OPEN, and unchanged in count because this one split into two:
--   * membership of (p , logOf p k) in `frontierList k` for prime p ≤ k;
--   * gcd(p^a, m') = 1 from p ∤ m', which is `CoprimePowers.bez-pow`
--     once the base certificate is in hand.
--
-- No estimate is offered for either.  The reason is in §1 of this file:
-- the last estimate offered in this thread was for the piece that turned
-- out to hide a fuel-adequacy theorem.
------------------------------------------------------------------------
