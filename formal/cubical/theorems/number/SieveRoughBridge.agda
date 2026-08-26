{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SieveRoughBridge
--
-- THE BRIDGE `SieveFiber` §4 SAYS IS UNBUILT.
--
-- `NaturalMachine/SieveFiber.agda` §4 proves "ε really is one bit" — the
-- rough part of every n in its 30-element domain is 1 or a prime above
-- the horizon — by EXHAUSTION at X = 30, and its own pointer says what
-- is missing:
--
--   "What is still open is the BRIDGE: `rough n` as computed here (by
--    `stripF`) has not been shown to satisfy `roughSplitSqrt`'s
--    hypothesis, so §4 below remains this file's own X = 30 exhaustion
--    and is not yet a corollary of the general theorem."
--
-- This module builds it.  `RoughSplit.roughSplitSqrt` asks for
--
--     0 < m,  m ≤ X,  AllPrimeFactorsAbove (isqrt X) m
--
-- and delivers `(m ≡ 1) ⊎ IsPrime m`.  Instantiating `m := rough n`
-- needs `rough n` to be understood, and `rough` is computed — by a
-- fuel-bounded division `_rem_`/`_div_` written inside `SieveFiber`
-- precisely so that `refl` would normalise, with no specification
-- attached.  So the bridge is, in order: verify that division, verify
-- `stripF` against it, and only then meet the hypothesis.
--
--
-- THE HYPOTHESIS NEITHER MODULE HAS, AND WHY IT IS UNAVOIDABLE.
--
-- `SieveFiber` strips the FIXED primes 2, 3, 5.  `RoughSplit` quantifies
-- over primes ≤ `isqrt X`.  These agree only while `isqrt X ≤ 5`, i.e.
-- while X ≤ 35; past that the sieve stops removing everything below the
-- horizon and `rough n` may keep a prime the theorem's hypothesis
-- forbids.  So the honest bridge is CONDITIONAL, and the condition is an
-- explicit argument:
--
--     roughIsOneOrPrime :
--       (X n : ℕ) → 0 < n → n ≤ X → isqrt X ≤ 5
--                 → (rough n ≡ 1) ⊎ IsPrime (rough n)
--
-- §8 shows the hypothesis is not slack: at X = 49 (the first X where the
-- CONCLUSION fails, not merely the proof) `rough 49 ≡ 49`, which is
-- neither 1 nor prime, and `isqrt 49 ≡ 7 ≰ 5` is the only hypothesis it
-- violates.  Between X = 36 and X = 48 the conclusion happens to survive
-- and this proof does not reach it; that gap is stated, not hidden.
--
--
-- WHAT IS CHECKED
--
--   §1  `divmod-spec`    `SieveFiber`'s fuel-bounded division, verified:
--       `rem-spec`       `d · (n div d) + (n rem d) ≡ n` and
--                        `n rem d < d`, for every `0 < d`.  Both by one
--                        induction on the fuel.  (`SieveFiber` needed
--                        these functions to COMPUTE and never said what
--                        they compute; this is that statement.)
--
--   §2  `rem0→∣`         zero remainder IS divisibility, both ways.  The
--       `∣→rem0`         converse is the uniqueness of the remainder,
--                        proved by comparing the two quotients — no
--                        library `_mod_`, because `SieveFiber`'s
--                        division is its own.
--
--   §3  `strip-spec`     THE STRIPPER, VERIFIED: for `1 < p`, `0 < n`
--                        and enough fuel, the cofactor `snd (stripF f p n)`
--                        divides `n`, is positive, and is NOT divisible
--                        by `p`.  Induction on the fuel; the recursive
--                        call is justified by `n div p < n`, which is
--                        where `1 < p` is used.
--
--   §4  `rough-facts`    `rough n ∣ n`, `0 < rough n`, and none of
--                        2, 3, 5 divides `rough n` — the three strips
--                        composed, each one's conclusion carried through
--                        the later ones by divisibility.
--
--   §5  `prime≤5`        a prime at or below 5 is 2, 3 or 5 (4 is
--       `rough-primes-above`  refuted by its own divisor 2), hence every
--                        prime factor of `rough n` exceeds 5 — which is
--                        `RoughSplit.AllPrimeFactorsAbove 5 (rough n)`,
--                        the hypothesis the bridge needed.
--
--   §6  `roughIsOneOrPrime`  **THE BRIDGE**, as displayed above.
--       `rough-is-large`     and in the prime case `5 < rough n`, so the
--                            two disjuncts are genuinely "1" and "a
--                            prime above the horizon".
--
--   §7  `roughSplit-30`  SieveFiber §4 AS A COROLLARY, at X = 30 —
--       `roughSplit-30′` and stronger than §4 in two ways: it holds for
--                        EVERY n with 0 < n ≤ 30, not only the thirty
--                        listed in `domain`, and its conclusion is
--                        `IsPrime`, a theorem about the number, rather
--                        than `Ω (rough n) ≡ 1`, a value computed by a
--                        second trial-division loop.
--
--   §8  `bridge-needs-the-horizon-bound`  sharpness, as above.
--
--
-- WHAT IS *NOT* CLAIMED
--
--  * **`Ω` is not bridged.**  `SieveFiber` §4's exhaustion concludes
--    `(Ω (rough n) ≡ 1) × (5 < rough n)`; this module concludes
--    `IsPrime (rough n) × (5 < rough n)`.  `Ω` is `SieveFiber`'s own
--    trial-division counter (`omegaF`), and `IsPrime m → Ω m ≡ 1` is a
--    correctness proof for THAT loop — a third verification, of the same
--    shape as §1 and §3 here, and independent of this bridge.  It is not
--    done here and §4 of `SieveFiber` is therefore not literally
--    re-derived; what is re-derived is the fact §4 exists to support,
--    which its own header states as "the rough part is 1 or a single
--    prime > 5".
--
--  * **Nothing is proved about the visible state `q`.**  Only `rough`.
--    The valuations `(v₂ , v₃ , v₅)` and the factorisation
--    `n ≡ smooth n · rough n` would need the exponent component of
--    `stripF`, which §3 deliberately does not track: the bridge does not
--    use it, and tracking it would drag in `pow` and a second induction
--    for no gain here.
--
--  * **No X-uniform statement about the SIEVE.**  The bridge is uniform
--    in X only up to the horizon bound `isqrt X ≤ 5`, which is a bound
--    on X (X ≤ 35).  A sieve that strips every prime below `isqrt X`
--    would remove the bound, but that is a different (X-indexed) sieve
--    and `SieveFiber` does not have one.
--
--  * `SieveFiber` and `RoughSplit` are untouched; this module imports
--    both and neither imports it.
--
-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  Whole file, cold interface: 4.1 s.  No postulates, no
-- holes, no TERMINATING pragma (every recursion here is on fuel, and
-- the fuel is what `SieveFiber` already used to make its functions
-- total).
------------------------------------------------------------------------

module SieveRoughBridge where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
  using (_∣_ ; ∣-untrunc ; ∣-refl ; ∣-trans ; ∣-left ; ∣-right ; m∣n→m≤n)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; if_then_else_ ; true≢false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum as Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import SieveFiber
  using (ltᵇ ; eqᵇ ; divF ; modF ; _div_ ; _rem_ ; stripF ; rough)
open import RoughSplit
  using (isqrt ; isqrt-30 ; isqrt-49 ; AllPrimeFactorsAbove ; roughSplitSqrt
        ; 49≢1 ; ¬prime49)
open import WalkJumps using (IsPrime ; 0<→≢0)

------------------------------------------------------------------------
-- 0.  Small change: order and Booleans.
------------------------------------------------------------------------

≢0→0< : (x : ℕ) → ¬ (x ≡ 0) → 0 < x
≢0→0< zero    h = Empty.rec (h refl)
≢0→0< (suc x) _ = suc-≤-suc zero-≤

1<→0< : {p : ℕ} → 1 < p → 0 < p
1<→0< = ≤-trans (suc-≤-suc zero-≤)

k<k+d : (k d : ℕ) → 0 < d → k < k + d
k<k+d k d 0<d = subst (_≤ k + d) (+-comm k 1) (≤-k+ {k = k} 0<d)

-- x ≤ x + y, in the Σ-form the library's `_≤_` actually is
≤-self+ : (x y : ℕ) → x ≤ x + y
≤-self+ x y = y , +-comm y x

plus∸ : (c x : ℕ) → (c + x) ∸ x ≡ c
plus∸ c zero    = +-zero c
plus∸ c (suc x) = cong (_∸ suc x) (+-suc c x) ∙ plus∸ c x

∸-inv : (d n : ℕ) → d ≤ n → d + (n ∸ d) ≡ n
∸-inv d n (k , kd≡n) =
  cong (d +_) (cong (_∸ d) (sym kd≡n) ∙ plus∸ k d) ∙ +-comm d k ∙ kd≡n

-- multiplication by anything above 1 strictly grows a positive number
mult-grows : (p x : ℕ) → 1 < p → 0 < x → x < p · x
mult-grows zero          x 1<p 0<x = Empty.rec (¬-<-zero 1<p)
mult-grows (suc zero)    x 1<p 0<x = Empty.rec (¬m<m 1<p)
mult-grows (suc (suc p)) x 1<p 0<x =
  k<k+d x (x + p · x) (<≤-trans 0<x (≤-self+ x (p · x)))

boolCase : (b : Bool) → (b ≡ true) ⊎ (b ≡ false)
boolCase true  = inl refl
boolCase false = inr refl

ltᵇ→< : (m n : ℕ) → ltᵇ m n ≡ true → m < n
ltᵇ→< zero    zero    p = Empty.rec (false≢true p)
ltᵇ→< zero    (suc n) p = suc-≤-suc zero-≤
ltᵇ→< (suc m) zero    p = Empty.rec (false≢true p)
ltᵇ→< (suc m) (suc n) p = suc-≤-suc (ltᵇ→< m n p)

ltᵇ-false→≤ : (m n : ℕ) → ltᵇ m n ≡ false → n ≤ m
ltᵇ-false→≤ zero    zero    p = ≤-refl
ltᵇ-false→≤ zero    (suc n) p = Empty.rec (true≢false p)
ltᵇ-false→≤ (suc m) zero    p = zero-≤
ltᵇ-false→≤ (suc m) (suc n) p = suc-≤-suc (ltᵇ-false→≤ m n p)

eqᵇ-refl : (m : ℕ) → eqᵇ m m ≡ true
eqᵇ-refl zero    = refl
eqᵇ-refl (suc m) = eqᵇ-refl m

≡→eqᵇ : (m n : ℕ) → m ≡ n → eqᵇ m n ≡ true
≡→eqᵇ m n p = subst (λ z → eqᵇ m z ≡ true) p (eqᵇ-refl m)

≢→eqᵇ : (m n : ℕ) → ¬ (m ≡ n) → eqᵇ m n ≡ false
≢→eqᵇ zero    zero    h = Empty.rec (h refl)
≢→eqᵇ zero    (suc n) h = refl
≢→eqᵇ (suc m) zero    h = refl
≢→eqᵇ (suc m) (suc n) h = ≢→eqᵇ m n (λ p → h (cong suc p))

------------------------------------------------------------------------
-- 1.  THE DIVISION, VERIFIED.
--
-- `SieveFiber` writes its own `divF`/`modF` because its whole method is
-- `refl` normalising, and `Cubical.Data.Nat.Mod` routes through
-- `+induction`, which does not.  The price is that nothing said what
-- they compute.  This is the statement, and it is one induction on the
-- fuel: the fuel is enough exactly when it bounds the argument.
------------------------------------------------------------------------

divF-lt : (f d n : ℕ) → ltᵇ n d ≡ true → divF (suc f) d n ≡ zero
divF-lt f d n t = cong (λ z → if z then zero else suc (divF f d (n ∸ d))) t

divF-ge : (f d n : ℕ) → ltᵇ n d ≡ false
        → divF (suc f) d n ≡ suc (divF f d (n ∸ d))
divF-ge f d n t = cong (λ z → if z then zero else suc (divF f d (n ∸ d))) t

modF-lt : (f d n : ℕ) → ltᵇ n d ≡ true → modF (suc f) d n ≡ n
modF-lt f d n t = cong (λ z → if z then n else modF f d (n ∸ d)) t

modF-ge : (f d n : ℕ) → ltᵇ n d ≡ false → modF (suc f) d n ≡ modF f d (n ∸ d)
modF-ge f d n t = cong (λ z → if z then n else modF f d (n ∸ d)) t

divmod-spec : (f d n : ℕ) → 0 < d → n ≤ f
            → (d · divF f d n + modF f d n ≡ n) × (modF f d n < d)
divmod-spec zero d n 0<d n≤0 =
    cong (_+ n) (sym (0≡m·0 d))
  , subst (_< d) (sym n≡0) 0<d
  where
  n≡0 : n ≡ 0
  n≡0 = ≤0→≡0 n≤0
divmod-spec (suc f) d n 0<d n≤sf with boolCase (ltᵇ n d)
... | inl t =
      ( cong₂ (λ u v → d · u + v) (divF-lt f d n t) (modF-lt f d n t)
      ∙ cong (_+ n) (sym (0≡m·0 d)) )
    , subst (_< d) (sym (modF-lt f d n t)) (ltᵇ→< n d t)
... | inr fa =
      ( cong₂ (λ u v → d · u + v) (divF-ge f d n fa) (modF-ge f d n fa)
      ∙ cong (_+ modF f d (n ∸ d)) (·-suc d (divF f d (n ∸ d)))
      ∙ sym (+-assoc d (d · divF f d (n ∸ d)) (modF f d (n ∸ d)))
      ∙ cong (d +_) (ih .fst)
      ∙ ∸-inv d n d≤n )
    , subst (_< d) (sym (modF-ge f d n fa)) (ih .snd)
  where
  d≤n : d ≤ n
  d≤n = ltᵇ-false→≤ n d fa

  n∸d<n : (n ∸ d) < n
  n∸d<n = subst ((n ∸ d) <_)
            (+-comm (n ∸ d) d ∙ ∸-inv d n d≤n)
            (k<k+d (n ∸ d) d 0<d)

  ih : (d · divF f d (n ∸ d) + modF f d (n ∸ d) ≡ n ∸ d)
     × (modF f d (n ∸ d) < d)
  ih = divmod-spec f d (n ∸ d) 0<d (pred-≤-pred (<≤-trans n∸d<n n≤sf))

-- The two functions `SieveFiber` actually exports, specified.
rem-spec : (d n : ℕ) → 0 < d
         → (d · (n div d) + (n rem d) ≡ n) × ((n rem d) < d)
rem-spec d n 0<d = divmod-spec n d n 0<d ≤-refl

------------------------------------------------------------------------
-- 2.  ZERO REMAINDER IS DIVISIBILITY.
--
-- Forward is the specification read off.  Backward is uniqueness of the
-- remainder: a second factorisation `c · d ≡ n` is compared with the
-- computed one by comparing `c` with the computed quotient, and each
-- side of that comparison contradicts one of the two facts in §1.
------------------------------------------------------------------------

rem0→∣ : (d n : ℕ) → 0 < d → (n rem d) ≡ 0 → d ∣ n
rem0→∣ d n 0<d r≡0 =
  ∣ (n div d) , ·-comm (n div d) d ∙ sym (+-zero (d · (n div d)))
                ∙ cong (d · (n div d) +_) (sym r≡0)
                ∙ rem-spec d n 0<d .fst ∣₁

-- Uniqueness of the remainder, as the only statement it is needed in:
-- a second factorisation `c · d ≡ n` forces the computed remainder to
-- vanish.  `c ≤ q` squeezes `r` to 0; `q < c` puts `d` below `r`.
rem-unique : (d n c q r : ℕ) → c · d ≡ n → d · q + r ≡ n → r < d → r ≡ 0
rem-unique d n c q r cd≡n spec r<d with splitℕ-≤ c q
... | inl c≤q = inj-m+ {m = d · q} (upper ∙ sym (+-zero (d · q)))
  where
  cd≤dq : c · d ≤ d · q
  cd≤dq = subst (c · d ≤_) (·-comm q d) (≤-·k c≤q)

  dqr≤dq : d · q + r ≤ d · q
  dqr≤dq = subst (_≤ d · q) (sym (spec ∙ sym cd≡n)) cd≤dq

  upper : d · q + r ≡ d · q
  upper = ≤-antisym dqr≤dq (≤-self+ (d · q) r)
... | inr q<c = Empty.rec (¬m<m (<≤-trans r<d d≤r))
  where
  step : q · d + d ≤ q · d + r
  step = subst2 _≤_ (+-comm d (q · d))
                    (cong (_+ r) (·-comm d q))
                    (subst (suc q · d ≤_) (cd≡n ∙ sym spec) (≤-·k q<c))

  d≤r : d ≤ r
  d≤r = ≤-k+-cancel step

∣→rem0 : (d n : ℕ) → 0 < d → d ∣ n → (n rem d) ≡ 0
∣→rem0 d n 0<d h =
  rem-unique d n (∣-untrunc h .fst) (n div d) (n rem d)
    (∣-untrunc h .snd) (rem-spec d n 0<d .fst) (rem-spec d n 0<d .snd)

------------------------------------------------------------------------
-- 3.  THE STRIPPER, VERIFIED.
--
-- The exponent is deliberately not tracked (see the header): what the
-- bridge needs of `stripF` is only its COFACTOR, and of that only three
-- facts.  The recursion terminates because `n div p < n` when `1 < p`,
-- and that is the only place the hypothesis `1 < p` is used.
------------------------------------------------------------------------

stripF-suc-zero : (f p n : ℕ) → (n rem p) ≡ 0
                → snd (stripF (suc f) p n) ≡ snd (stripF f p (n div p))
stripF-suc-zero f p n e =
  cong (λ z → snd (if z
                     then ( suc (fst (stripF f p (n div p)))
                          , snd (stripF f p (n div p)) )
                     else (zero , n)))
       (≡→eqᵇ (n rem p) zero e)

stripF-suc-nonzero : (f p n : ℕ) → ¬ ((n rem p) ≡ 0)
                   → snd (stripF (suc f) p n) ≡ n
stripF-suc-nonzero f p n e =
  cong (λ z → snd (if z
                     then ( suc (fst (stripF f p (n div p)))
                          , snd (stripF f p (n div p)) )
                     else (zero , n)))
       (≢→eqᵇ (n rem p) zero e)

strip-spec : (f p n : ℕ) → 1 < p → 0 < n → n ≤ f
           → (snd (stripF f p n) ∣ n)
           × (0 < snd (stripF f p n))
           × (¬ (p ∣ snd (stripF f p n)))
strip-spec zero p n 1<p 0<n n≤0 =
  Empty.rec (¬-<-zero (<≤-trans 0<n n≤0))
strip-spec (suc f) p n 1<p 0<n n≤sf with discreteℕ (n rem p) 0
... | no ¬e =
      subst (_∣ n) (sym red) (∣-refl refl)
    , subst (0 <_) (sym red) 0<n
    , subst (λ z → ¬ (p ∣ z)) (sym red)
        (λ pn → ¬e (∣→rem0 p n (1<→0< 1<p) pn))
  where
  red : snd (stripF (suc f) p n) ≡ n
  red = stripF-suc-nonzero f p n ¬e
... | yes e =
      subst (_∣ n) (sym red) (∣-trans (ih .fst) n'∣n)
    , subst (0 <_) (sym red) (ih .snd .fst)
    , subst (λ z → ¬ (p ∣ z)) (sym red) (ih .snd .snd)
  where
  n' : ℕ
  n' = n div p

  pn'≡n : p · n' ≡ n
  pn'≡n = sym (+-zero (p · n'))
        ∙ cong (p · n' +_) (sym e)
        ∙ rem-spec p n (1<→0< 1<p) .fst

  n'∣n : n' ∣ n
  n'∣n = subst (n' ∣_) pn'≡n (∣-right p)

  0<n' : 0 < n'
  0<n' = ≢0→0< n' (λ z → ¬-<-zero
           (subst (0 <_)
             (sym pn'≡n ∙ cong (p ·_) z ∙ sym (0≡m·0 p)) 0<n))

  n'<n : n' < n
  n'<n = subst (n' <_) pn'≡n (mult-grows p n' 1<p 0<n')

  ih : (snd (stripF f p n') ∣ n')
     × (0 < snd (stripF f p n'))
     × (¬ (p ∣ snd (stripF f p n')))
  ih = strip-spec f p n' 1<p 0<n' (pred-≤-pred (<≤-trans n'<n n≤sf))

  red : snd (stripF (suc f) p n) ≡ snd (stripF f p n')
  red = stripF-suc-zero f p n e

------------------------------------------------------------------------
-- 4.  `rough`, UNDERSTOOD.
--
-- `visRough` strips 2, then 3, then 5, each with fuel n.  The three
-- specifications compose: each strip's cofactor divides the previous
-- one, so a prime excluded at one stage stays excluded at the next.
------------------------------------------------------------------------

1<2 : 1 < 2
1<2 = suc-≤-suc (suc-≤-suc zero-≤)

1<3 : 1 < 3
1<3 = ≤-trans 1<2 (≤-suc ≤-refl)

1<5 : 1 < 5
1<5 = ≤-trans 1<3 (≤-suc (≤-suc ≤-refl))

-- `rough` is the third cofactor; this is `refl`, and is stated so that
-- the composition below reads as arithmetic rather than as unfolding.
rough-unfold : (n : ℕ)
             → rough n ≡ snd (stripF n 5 (snd (stripF n 3 (snd (stripF n 2 n)))))
rough-unfold n = refl

rough-facts : (n : ℕ) → 0 < n
            → (rough n ∣ n) × (0 < rough n)
            × (¬ (2 ∣ rough n)) × (¬ (3 ∣ rough n)) × (¬ (5 ∣ rough n))
rough-facts n 0<n =
    ∣-trans r∣b (∣-trans b∣a a∣n)
  , 0<r
  , (λ h → ¬2∣a (∣-trans h (∣-trans r∣b b∣a)))
  , (λ h → ¬3∣b (∣-trans h r∣b))
  , ¬5∣r
  where
  n≢0 : ¬ (n ≡ 0)
  n≢0 = 0<→≢0 n 0<n

  a : ℕ
  a = snd (stripF n 2 n)

  sa : (a ∣ n) × (0 < a) × (¬ (2 ∣ a))
  sa = strip-spec n 2 n 1<2 0<n ≤-refl

  a∣n = sa .fst
  0<a = sa .snd .fst
  ¬2∣a = sa .snd .snd

  a≤n : a ≤ n
  a≤n = m∣n→m≤n n≢0 a∣n

  b : ℕ
  b = snd (stripF n 3 a)

  sb : (b ∣ a) × (0 < b) × (¬ (3 ∣ b))
  sb = strip-spec n 3 a 1<3 0<a a≤n

  b∣a = sb .fst
  0<b = sb .snd .fst
  ¬3∣b = sb .snd .snd

  b≤n : b ≤ n
  b≤n = ≤-trans (m∣n→m≤n (0<→≢0 a 0<a) b∣a) a≤n

  sc : (rough n ∣ b) × (0 < rough n) × (¬ (5 ∣ rough n))
  sc = strip-spec n 5 b 1<5 0<b b≤n

  r∣b = sc .fst
  0<r = sc .snd .fst
  ¬5∣r = sc .snd .snd

------------------------------------------------------------------------
-- 5.  THE HYPOTHESIS `roughSplitSqrt` ASKS FOR.
--
-- A prime at or below 5 is 2, 3 or 5.  The only work is 4, and it is
-- refuted by its own divisor: primality would force 2 ≡ 1 or 2 ≡ 4.
------------------------------------------------------------------------

2∣4 : 2 ∣ 4
2∣4 = ∣ 2 , refl ∣₁

prime≤5 : (p : ℕ) → IsPrime p → p ≤ 5 → (p ≡ 2) ⊎ ((p ≡ 3) ⊎ (p ≡ 5))
prime≤5 zero pp p≤5 = Empty.rec (¬-<-zero (pp .fst))
prime≤5 (suc zero) pp p≤5 = Empty.rec (¬m<m (pp .fst))
prime≤5 (suc (suc zero)) pp p≤5 = inl refl
prime≤5 (suc (suc (suc zero))) pp p≤5 = inr (inl refl)
prime≤5 (suc (suc (suc (suc zero)))) pp p≤5 with pp .snd 2 2∣4
... | inl 2≡1 = Empty.rec (snotz (injSuc 2≡1))
... | inr 2≡4 = Empty.rec (znots (injSuc (injSuc 2≡4)))
prime≤5 (suc (suc (suc (suc (suc zero))))) pp p≤5 = inr (inr refl)
prime≤5 (suc (suc (suc (suc (suc (suc p)))))) pp p≤5 =
  Empty.rec (¬-<-zero
    (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred p≤5))))))

-- Every prime factor of `rough n` exceeds 5: it is not 2, 3 or 5 by §4,
-- and by `prime≤5` there is nothing else at or below 5.
rough-primes-above : (n : ℕ) → 0 < n → AllPrimeFactorsAbove 5 (rough n)
rough-primes-above n 0<n p pp p∣r with splitℕ-≤ p 5
... | inr 5<p = 5<p
... | inl p≤5 with prime≤5 p pp p≤5
...   | inl p≡2       =
        Empty.rec (rough-facts n 0<n .snd .snd .fst
                    (subst (_∣ rough n) p≡2 p∣r))
...   | inr (inl p≡3) =
        Empty.rec (rough-facts n 0<n .snd .snd .snd .fst
                    (subst (_∣ rough n) p≡3 p∣r))
...   | inr (inr p≡5) =
        Empty.rec (rough-facts n 0<n .snd .snd .snd .snd
                    (subst (_∣ rough n) p≡5 p∣r))

------------------------------------------------------------------------
-- 6.  THE BRIDGE.
--
-- `isqrt X ≤ 5` is the compatibility hypothesis: below it the primes
-- `SieveFiber` strips (2, 3, 5) exhaust the primes `RoughSplit`'s
-- horizon quantifies over.  Everything else is now in place.
------------------------------------------------------------------------

roughIsOneOrPrime : (X n : ℕ) → 0 < n → n ≤ X → isqrt X ≤ 5
                  → (rough n ≡ 1) ⊎ IsPrime (rough n)
roughIsOneOrPrime X n 0<n n≤X h≤5 =
  roughSplitSqrt X (rough n) 0<r (≤-trans r≤n n≤X) above
  where
  facts = rough-facts n 0<n

  0<r : 0 < rough n
  0<r = facts .snd .fst

  r≤n : rough n ≤ n
  r≤n = m∣n→m≤n (0<→≢0 n 0<n) (facts .fst)

  above : AllPrimeFactorsAbove (isqrt X) (rough n)
  above p pp p∣r = ≤<-trans h≤5 (rough-primes-above n 0<n p pp p∣r)

-- In the second disjunct the prime really is above the horizon: it
-- divides itself, so §5 applies to it.
rough-is-large : (n : ℕ) → 0 < n → IsPrime (rough n) → 5 < rough n
rough-is-large n 0<n pp = rough-primes-above n 0<n (rough n) pp (∣-refl refl)

------------------------------------------------------------------------
-- 7.  X = 30:  `SieveFiber` §4, no longer an exhaustion.
--
-- `isqrt 30 ≡ 5` (RoughSplit), so the hypothesis holds, and the
-- statement now ranges over EVERY n in (0,30], not over a list.
------------------------------------------------------------------------

isqrt-30≤5 : isqrt 30 ≤ 5
isqrt-30≤5 = subst (_≤ 5) (sym isqrt-30) ≤-refl

roughSplit-30 : (n : ℕ) → 0 < n → n ≤ 30 → (rough n ≡ 1) ⊎ IsPrime (rough n)
roughSplit-30 n 0<n n≤30 = roughIsOneOrPrime 30 n 0<n n≤30 isqrt-30≤5

-- …and in the form `SieveFiber` §4 states it: 1, or a prime above 5.
--
-- NOTE ON THE `Sum.rec`, and it is a MEASUREMENT, not a diagnosis.
-- Written as `roughSplit-30′ n 0<n n≤30 with roughSplit-30 n 0<n n≤30`
-- and two `...` clauses, this definition did not finish typechecking in
-- 120 s; written with the eliminator, the whole file checks in 4.2 s.
-- Nothing else changed between the two runs.  I do not know what the
-- `with` costs here and I am not guessing: README §1 records that
-- `WalkFast`'s twin symptom was misdiagnosed twice as a `with` problem
-- and was in fact the conversion checker comparing two independently
-- elaborated copies of one term.  Recorded because the next person to
-- write this line will write the `with` first, not because the cause is
-- understood.
roughSplit-30′ : (n : ℕ) → 0 < n → n ≤ 30
               → (rough n ≡ 1) ⊎ (IsPrime (rough n) × (5 < rough n))
roughSplit-30′ n 0<n n≤30 =
  Sum.rec inl (λ pp → inr (pp , rough-is-large n 0<n pp))
          (roughSplit-30 n 0<n n≤30)

-- Fired on the three numbers `SieveFiber`'s negative results turn on,
-- so the implication is not left uninhabited.
rough-1  : (rough 1 ≡ 1) ⊎ (IsPrime (rough 1) × (5 < rough 1))
rough-1  = roughSplit-30′ 1 (suc-≤-suc zero-≤) (29 , refl)

rough-7  : (rough 7 ≡ 1) ⊎ (IsPrime (rough 7) × (5 < rough 7))
rough-7  = roughSplit-30′ 7 (suc-≤-suc zero-≤) (23 , refl)

rough-30 : (rough 30 ≡ 1) ⊎ (IsPrime (rough 30) × (5 < rough 30))
rough-30 = roughSplit-30′ 30 (suc-≤-suc zero-≤) (0 , refl)

------------------------------------------------------------------------
-- 8.  SHARPNESS:  the horizon bound is not slack.
--
-- Drop `isqrt X ≤ 5` and the CONCLUSION fails, not merely the proof:
-- at X = n = 49 the sieve strips nothing (49 is coprime to 2, 3, 5), so
-- `rough 49 ≡ 49`, which is neither 1 nor prime.  `RoughSplit` already
-- owns both refutations (they are its own §6 sharpness witnesses), and
-- `isqrt 49 ≡ 7` is the hypothesis that fails.
--
-- Honest gap: 36 ≤ X ≤ 48 also violates `isqrt X ≤ 5` while the
-- conclusion still holds there.  The bound is sharp for THIS proof and
-- the conclusion is false from 49 on; between the two this module says
-- nothing.
------------------------------------------------------------------------

rough-49 : rough 49 ≡ 49
rough-49 = refl

¬7≤5 : ¬ (7 ≤ 5)
¬7≤5 h = ¬-<-zero
  (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred h)))))

horizon-bound-fails-at-49 : ¬ (isqrt 49 ≤ 5)
horizon-bound-fails-at-49 h = ¬7≤5 (subst (_≤ 5) isqrt-49 h)

bridge-needs-the-horizon-bound :
    (rough 49 ≡ 49)
  × (¬ (rough 49 ≡ 1))
  × (¬ (IsPrime (rough 49)))
  × (¬ (isqrt 49 ≤ 5))
bridge-needs-the-horizon-bound =
    rough-49
  , (λ p → 49≢1 (sym rough-49 ∙ p))
  , (λ pp → ¬prime49 (subst IsPrime rough-49 pp))
  , horizon-bound-fails-at-49
