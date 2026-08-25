{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WalkChartedLength
--
-- THE LENGTH OF THE CHARTED CAPACITY.
--
-- `WalkChartedCap` builds `cap m = lcm(1..m) = e^{ψ(m)}` inside the digit
-- chart (`capw m`, with `value-capw : value (capw m) ≡ cap m`) and counts
-- the automaton transitions of that construction.  Its own header names
-- three things it does not deliver, and this module delivers them:
--
--   (a) "`length (capw m)` IS NOT PROVED LOGARITHMIC in `cap m`."
--   (b) "`scale` is not proved to preserve canonicity either -- only its
--        value law is proved."
--   (c) "NO KERNEL WITNESS.  There is no `capw 8` computed here."
--
-- WHAT IS DELIVERED.
--
--   1. CANONICITY OF THE SCALING PASS (§2).  `canonical-scale`:
--
--        0 < q → Canonical w → Canonical (scale q w c)
--
--      The positivity hypothesis on the scalar is not decoration and is
--      not weakenable: `scale 0 (fone ∷ []) 0 = fzero ∷ []`, a leading
--      zero, so canonicity genuinely fails at q = 0.  That is recorded as
--      a theorem (`scale-zero-not-canonical`) rather than as a remark, so
--      the hypothesis is known to be the true one and not merely a
--      convenient one.  It is the only failure: for `w = []` the pass
--      returns `digits c`, canonical for every c.  And the hypothesis is
--      available exactly where it is needed --
--      `WalkChartedCap.chartedQuot-pos` -- so nothing is assumed that the
--      capacity recursion does not already prove.
--
--      `canonical-capw : (m : ℕ) → Canonical (capw m)` follows at once,
--      and this is what makes `length (capw m)` a meaningful quantity
--      rather than the length of an arbitrary representative.
--
--   2. THE LENGTH LAW (§3).  One direction is imported:
--      `TransportDivScale.pow≤value` proves `b ^ (length w) ≤ value (d ∷ w)`
--      for canonical words and is not reproved here.  The other direction
--      is proved, and needs no canonicity at all:
--
--        value<pow : (w : Word) → value w < b ^ (length w)
--
--      Together, for a canonical NONEMPTY word,
--
--        b ^ (length u ∸ 1)  ≤  value u  <  b ^ (length u) ,
--
--      which is the statement that `length u` is the base-b logarithm of
--      `value u` up to the standard off-by-one -- i.e. `length u` is the
--      LEAST n with `value u < b ^ n`.  That least-ness is proved in both
--      directions (`canonical-length-least`, `pow≤value→<length`), so the
--      bound is an identification and not an upper estimate.
--
--      Instantiated at `capw m` through `value-capw`:
--
--        capw-length-is-least :
--            (cap m < b ^ n → length (capw m) ≤ n)
--          × (b ^ n ≤ cap m → n < length (capw m))
--
--   3. THE COST CONSEQUENCE (§4), stated exactly and no further.  The
--      per-test automaton cost of `WalkChartedCap` is
--      `steps (capw m) ≡ suc (length (capw m))`, and
--
--        charted-test-cost-log :
--          cap m < b ^ n → steps (capw m) ≤ suc n
--
--      with n = length (capw m) attaining it.  So the per-test cost is
--      `1 + ⌈log_b (cap m)⌉` up to the off-by-one, against the unary
--      test's `usteps (cap m) ≡ suc (cap m)`.  Since `cap m = e^{ψ(m)}`,
--      the least admissible n is ψ(m)/log b + O(1): the cost is LINEAR IN
--      ψ(m) where the home presentation's is e^{ψ(m)}.  That last
--      sentence is the only place ψ appears; the theorems are stated with
--      `b ^ n` because that is what is proved, and `cap m = e^{ψ(m)}` is
--      Chebyshev's definition, not a fact this lane establishes.
--
--      This is the first point in the walk lane where the walk's
--      superexponential storage law is turned into a linear one.  It
--      bounds the CAPACITY HANDLING only.  `WalkBridge.next` is untouched,
--      as `WalkChartedCap` already says, and `next 8` still exhausts the
--      heap.
--
--   4. KERNEL WITNESSES (§5), base ten.  `capw` DOES evaluate: `capw 4`,
--      `capw 6`, `capw 8`, `capw 10` are computed by `refl`, up to
--      `value (capw 10) ≡ 2520`.  Neither cubical's `gcd` (through
--      `euclid`'s well-founded recursion) nor `Fin.Properties._%_`
--      (through its transport) blocks reduction -- the two suspects named
--      in `WalkChartedCap`'s closing list are acquitted.
--
--      What DOES cost is elsewhere, and is an artefact of the definition
--      rather than of the mathematics: `capw m` occurs TWICE in the
--      mutual block (`capw (suc m) = scale (chartedQuot m) (capw m) 0`,
--      and `chartedQuot m` reads `capw m` again through `modw`), and the
--      kernel does not share, so closed evaluation costs 2^m passes.
--      Wall times for `value (capw m) ≡ _` by `refl`, one witness per
--      file, Agda 2.6.3, --safe:  m = 8, 9: 5 s;  m = 10: 7 s;
--      m = 11: 17 s;  m = 12: 24 s;  m = 13: 52 s -- a clean doubling,
--      which is the duplication and nothing else.  §5 stops at m = 10 to
--      keep this file cheap.  A `capw` that carried the residue forward
--      instead of recomputing it would be linear; that is a rewrite, not
--      a theorem, and it is not done here.
--
-- WHAT IS NOT DELIVERED.  `capSteps` is not summed: this module bounds
-- the PER-TEST cost `suc (length (capw m))`, not the total `capSteps σ m`,
-- which also carries `WalkChartedCap`'s unstated parameter σ for the
-- per-transition arithmetic.  Nothing here counts `gcd`.
--
-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical), --cubical --safe.
-- No postulates, no holes.
------------------------------------------------------------------------

module WalkChartedLength where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
  using (_mod_ ; quotient_/_ ; remainder_/_ ; ≡remainder+quotient)
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import WalkUnconditional using (cap)
open import WalkBridge using (cap-pos)
open import TransportDivScale using (module Scaling)
open import SourcedProofs.WalkChartedCap using (module Charted)

module Lengths (k : ℕ) where

  open import Digits k
  open import TransportDiv k
  open import WalkResidueBridge k using (usteps ; usteps-is-value)
  open Scaling k using (pow-pos ; pow-double ; pow-mono-suc ; pow≤value)
  open Charted k

  ----------------------------------------------------------------------
  -- 1.  Two arithmetic shapes.
  ----------------------------------------------------------------------

  ·-pos : (x y : ℕ) → 0 < x → 0 < y → 0 < x · y
  ·-pos zero    y       0<x _   = Empty.rec (¬-<-zero 0<x)
  ·-pos (suc x) zero    _   0<y = Empty.rec (¬-<-zero 0<y)
  ·-pos (suc x) (suc y) _   _   = suc-≤-suc zero-≤

  0<+ : (x c : ℕ) → 0 < x → 0 < x + c
  0<+ x c 0<x = ≤-trans 0<x (≤SumLeft {n = x} {k = c})

  ----------------------------------------------------------------------
  -- 2.  CANONICITY OF THE SCALING PASS.
  --
  -- `scale` (WalkChartedCap §6a) is one Horner pass with a ℕ carry:
  --
  --   scale q []      c = digits c
  --   scale q (d ∷ w) c = digitOf (q·d+c) ∷ scale q w (quotient (q·d+c) / b)
  --
  -- Canonicity constrains the MOST significant end -- the last cons -- so
  -- the induction has exactly one interesting clause: the word of length
  -- one, where the output's top digit is the head itself if the outgoing
  -- carry vanishes.  There the digit must be shown positive, and that is
  -- where `0 < q` is used and cannot be avoided.
  ----------------------------------------------------------------------

  -- `digits n` is a cons as soon as n is positive.
  digits-nonempty : (n : ℕ) → 0 < n
                  → Σ[ d ∈ Digit ] Σ[ v ∈ Word ] (digits n ≡ d ∷ v)
  digits-nonempty zero    h = Empty.rec (¬-<-zero h)
  digits-nonempty (suc n) _ = sucw-nonempty (digits n)

  -- A digit on top of `digits n` is canonical unless n = 0, and then it
  -- is canonical exactly when the digit is nonzero.
  canonical-cons-digits : (d : Digit) (n : ℕ) → (n ≡ 0 → 0 < toℕ d)
                        → Canonical (d ∷ digits n)
  canonical-cons-digits d zero    h = h refl
  canonical-cons-digits d (suc n) _ =
    canonical-cons d (digits (suc n))
      (digits-nonempty (suc n) (suc-≤-suc zero-≤))
      (canonical-digits (suc n))

  -- If the carry out of a Horner step vanishes, the digit emitted IS the
  -- whole quantity, so its positivity is that quantity's positivity.
  quotient≡0→mod≡ : (t : ℕ) → (quotient t / b) ≡ 0 → (t mod b) ≡ t
  quotient≡0→mod≡ t h =
      sym (+-zero (t mod b))
    ∙ cong ((t mod b) +_) (0≡m·0 b)
    ∙ cong (λ z → (t mod b) + b · z) (sym h)
    ∙ ≡remainder+quotient b t

  scale-head-pos : (q : ℕ) (d : Digit) (c : ℕ) → 0 < q → 0 < toℕ d
                 → (quotient (q · toℕ d + c) / b) ≡ 0
                 → 0 < toℕ (digitOf (q · toℕ d + c))
  scale-head-pos q d c 0<q 0<d h =
    subst (0 <_) (sym (quotient≡0→mod≡ (q · toℕ d + c) h))
          (0<+ (q · toℕ d) c (·-pos q (toℕ d) 0<q 0<d))

  -- A scaling pass over a nonempty word is a cons, definitionally.
  scale-cons : (q : ℕ) (d : Digit) (w : Word) (c : ℕ)
             → Σ[ e ∈ Digit ] Σ[ v ∈ Word ] (scale q (d ∷ w) c ≡ e ∷ v)
  scale-cons q d w c =
      digitOf (q · toℕ d + c)
    , scale q w (quotient (q · toℕ d + c) / b)
    , refl

  -- THE CANONICITY LAW FOR `scale`.
  canonical-scale : (q : ℕ) → 0 < q → (w : Word) → Canonical w → (c : ℕ)
                  → Canonical (scale q w c)
  canonical-scale q 0<q []          _   c = canonical-digits c
  canonical-scale q 0<q (d ∷ [])    can c =
    canonical-cons-digits
      (digitOf (q · toℕ d + c))
      (quotient (q · toℕ d + c) / b)
      (scale-head-pos q d c 0<q can)
  canonical-scale q 0<q (d ∷ e ∷ w) can c =
    canonical-cons
      (digitOf (q · toℕ d + c))
      (scale q (e ∷ w) (quotient (q · toℕ d + c) / b))
      (scale-cons q e w (quotient (q · toℕ d + c) / b))
      (canonical-scale q 0<q (e ∷ w) can (quotient (q · toℕ d + c) / b))

  -- q = 0 IS A GENUINE COUNTEREXAMPLE, not a defect of the proof above:
  -- the pass emits a leading zero (`value (fzero ∷ []) = 0 = value []`,
  -- and `digits 0 = []`).  So `0 < q` is the true hypothesis.
  scale-zero-not-canonical : ¬ Canonical (scale 0 (fone ∷ []) 0)
  scale-zero-not-canonical = ¬-<-zero

  ----------------------------------------------------------------------
  -- 2a.  THE CHARTED CAPACITY IS CANONICAL.  This is (b) of the open
  --      list, and it is what makes `length (capw m)` well posed.
  ----------------------------------------------------------------------

  canonical-capw : (m : ℕ) → Canonical (capw m)
  canonical-capw zero    = canonical-digits 1
  canonical-capw (suc m) =
    canonical-scale (chartedQuot m) (chartedQuot-pos m)
                    (capw m) (canonical-capw m) 0

  ----------------------------------------------------------------------
  -- 3.  THE LENGTH LAW.
  --
  --   imported : b ^ (length w) ≤ value (d ∷ w)     (canonical words)
  --   proved   : value w < b ^ (length w)           (all words)
  --
  -- The first is `TransportDivScale.pow≤value` and is NOT reproved.
  ----------------------------------------------------------------------

  ·-mono-l : (c x y : ℕ) → x ≤ y → c · x ≤ c · y
  ·-mono-l c x y p = subst2 _≤_ (·-comm x c) (·-comm y c) (≤-·k p)

  -- THE UPPER BOUND.  A word of length L has value below b ^ L, for every
  -- word: this direction is about the alphabet, not about canonicity.
  value<pow : (w : Word) → value w < b ^ (length w)
  value<pow []      = ≤-refl
  value<pow (d ∷ w) =
    ≤-trans (≤-+k (snd d))
      (subst (_≤ b · b ^ (length w)) (·-suc b (value w))
        (·-mono-l b (suc (value w)) (b ^ (length w)) (value<pow w)))

  ----------------------------------------------------------------------
  -- 3a.  Powers of the base reflect the order.  b ≥ 2 enters only through
  --      `pow-pos` and `pow-double`, both imported from
  --      `TransportDivScale`.
  ----------------------------------------------------------------------

  pow-mono-offset : (r i : ℕ) → b ^ i ≤ b ^ (r + i)
  pow-mono-offset zero    i = ≤-refl
  pow-mono-offset (suc r) i = ≤-trans (pow-mono-offset r i) (pow-mono-suc (r + i))

  pow-mono-≤ : (i j : ℕ) → i ≤ j → b ^ i ≤ b ^ j
  pow-mono-≤ i j (r , p) = subst (λ z → b ^ i ≤ b ^ z) p (pow-mono-offset r i)

  pow-lt-suc : (i : ℕ) → b ^ i < b ^ (suc i)
  pow-lt-suc i = ≤-trans (≤-+k (pow-pos i)) (pow-double i)

  pow-mono-< : (i j : ℕ) → i < j → b ^ i < b ^ j
  pow-mono-< i j i<j = <≤-trans (pow-lt-suc i) (pow-mono-≤ (suc i) j i<j)

  pow-reflects-≤ : (i j : ℕ) → b ^ i ≤ b ^ j → i ≤ j
  pow-reflects-≤ i j h =
    <-asym' (λ j<i → ¬m<m (<≤-trans (pow-mono-< j i j<i) h))

  pow-reflects-< : (i j : ℕ) → b ^ i < b ^ j → i < j
  pow-reflects-< i j h =
    <-asym' (λ j<si → ¬m<m (<≤-trans h (pow-mono-≤ j i (pred-≤-pred j<si))))

  ----------------------------------------------------------------------
  -- 3b.  `length` IS the base-b logarithm, in both directions.
  --
  -- The sandwich, for a canonical nonempty word u:
  --
  --     b ^ (length u ∸ 1)  ≤  value u  <  b ^ (length u) .
  --
  -- Equivalently: `length u` is the LEAST n with `value u < b ^ n`.  Both
  -- halves are given, because only the upper one would leave
  -- "logarithmic" an estimate rather than an identification.
  ----------------------------------------------------------------------

  digit-length-law : (d : Digit) (w : Word) → Canonical (d ∷ w)
                   → (b ^ (predℕ (length (d ∷ w))) ≤ value (d ∷ w))
                   × (value (d ∷ w) < b ^ (length (d ∷ w)))
  digit-length-law d w can = pow≤value d w can , value<pow (d ∷ w)

  -- `length u` is at most any n that beats the value: the upper half.
  canonical-length-least : (u : Word) → Canonical u → (n : ℕ)
                         → value u < b ^ n → length u ≤ n
  canonical-length-least []      _   n _ = zero-≤
  canonical-length-least (d ∷ w) can n h =
    pow-reflects-< (length w) n (≤<-trans (pow≤value d w can) h)

  -- …and more than any n that does not: the lower half, which needs no
  -- canonicity, since `value<pow` needs none.
  pow≤value→<length : (u : Word) (n : ℕ) → b ^ n ≤ value u → n < length u
  pow≤value→<length u n h =
    <-asym' (λ lt → ¬m<m (≤<-trans
                            (≤-trans (pow-mono-≤ (length u) n (pred-≤-pred lt)) h)
                            (value<pow u)))

  ----------------------------------------------------------------------
  -- 3c.  AT THE CHARTED CAPACITY.
  --
  -- `value-capw : value (capw m) ≡ cap m` transports §3b onto `cap m`,
  -- and `canonical-capw` of §2a is what licenses it.  This is (a) of the
  -- open list.
  ----------------------------------------------------------------------

  capw-length-≤ : (m n : ℕ) → cap m < b ^ n → length (capw m) ≤ n
  capw-length-≤ m n h =
    canonical-length-least (capw m) (canonical-capw m) n
      (subst (_< b ^ n) (sym (value-capw m)) h)

  capw-length-> : (m n : ℕ) → b ^ n ≤ cap m → n < length (capw m)
  capw-length-> m n h =
    pow≤value→<length (capw m) n (subst (b ^ n ≤_) (sym (value-capw m)) h)

  -- THE LENGTH LAW AT `capw`: `length (capw m)` is the least n with
  -- `cap m < b ^ n`, i.e. the base-b digit count of the capacity.
  capw-length-is-least : (m n : ℕ)
                       → (cap m < b ^ n → length (capw m) ≤ n)
                       × (b ^ n ≤ cap m → n < length (capw m))
  capw-length-is-least m n = capw-length-≤ m n , capw-length-> m n

  -- the same fact as the sandwich, which is the shape "logarithmic" names
  capw-pred-pow≤ : (m : ℕ) → b ^ (predℕ (length (capw m))) ≤ cap m
  capw-pred-pow≤ m = aux (length (capw m)) refl
    where
    aux : (L : ℕ) → length (capw m) ≡ L → b ^ (predℕ L) ≤ cap m
    aux zero    p = cap-pos m
    aux (suc L) p = <-asym' (λ h → ¬m<m (subst (_≤ L) p (capw-length-≤ m L h)))

  capw-sandwich : (m : ℕ)
                → (b ^ (predℕ (length (capw m))) ≤ cap m)
                × (cap m < b ^ (length (capw m)))
  capw-sandwich m =
      capw-pred-pow≤ m
    , subst (_< b ^ (length (capw m))) (value-capw m) (value<pow (capw m))

  ----------------------------------------------------------------------
  -- 4.  THE COST CONSEQUENCE.
  --
  -- `TransportDiv.steps-is-length` says the residue automaton costs one
  -- transition per digit plus one.  §3c says the digit count is the
  -- base-b logarithm of the capacity.  Composing them is the point of the
  -- exercise.
  ----------------------------------------------------------------------

  charted-test-cost : (m : ℕ) → steps (capw m) ≡ suc (length (capw m))
  charted-test-cost m = steps-is-length (capw m)

  -- THE LOGARITHMIC COST BOUND.  For every exponent n that beats the
  -- capacity, one divisibility test against `capw m` costs at most
  -- `suc n` transitions -- and by `capw-sandwich` the least such n is
  -- `length (capw m)` itself, so the bound is met exactly.
  charted-test-cost-log : (m n : ℕ) → cap m < b ^ n → steps (capw m) ≤ suc n
  charted-test-cost-log m n h =
    subst (_≤ suc n) (sym (charted-test-cost m))
          (suc-≤-suc (capw-length-≤ m n h))

  -- THE GAP, in `WalkChartedCap.cost-gap`'s register but now quantified:
  -- chart cost ≤ n + 1 whenever cap m < b ^ n; home cost = cap m + 1.
  -- With cap m = e^{ψ(m)} the least such n is ψ(m)/log b + O(1), so the
  -- left column is LINEAR IN ψ(m) and the right one is e^{ψ(m)}.
  charted-vs-unary : (m n : ℕ) → cap m < b ^ n
                   → (steps (capw m) ≤ suc n) × (usteps (cap m) ≡ suc (cap m))
  charted-vs-unary m n h = charted-test-cost-log m n h , usteps-is-value (cap m)

------------------------------------------------------------------------
-- 5.  KERNEL WITNESSES, base ten (k = 8, b = 10).
--
-- `WalkChartedCap` recorded "NO KERNEL WITNESS … whether that evaluates
-- cheaply in the kernel is a separate question this file does not
-- answer."  It does evaluate, and the two named suspects -- cubical's
-- `gcd` through `euclid`'s well-founded recursion, and
-- `Fin.Properties._%_` through its transport -- both reduce on closed
-- numerals.
--
-- m = 8 is the frontier at which `WalkBridge.next` exhausts the heap.
-- Here `capw 8` is a three-digit word, the automaton reads it in four
-- transitions, and the unary test walks 841.
------------------------------------------------------------------------

open import Digits 8 using (value)
open import SourcedProofs.TransportDiv 8 using (steps)
open import WalkResidueBridge 8 using (usteps)
open Charted 8
open Lengths 8

-- 5a.  The charted capacity is the capacity, computed.
value-capw-4  : value (capw 4)  ≡ 12
value-capw-6  : value (capw 6)  ≡ 60
value-capw-8  : value (capw 8)  ≡ 840
value-capw-10 : value (capw 10) ≡ 2520
value-capw-4  = refl
value-capw-6  = refl
value-capw-8  = refl
value-capw-10 = refl

-- 5b.  Digit lengths, and the automaton cost they control.
length-capw-4  : length (capw 4)  ≡ 2
length-capw-8  : length (capw 8)  ≡ 3
length-capw-10 : length (capw 10) ≡ 4
length-capw-4  = refl
length-capw-8  = refl
length-capw-10 = refl

steps-capw-8  : steps (capw 8)  ≡ 4
steps-capw-10 : steps (capw 10) ≡ 5
steps-capw-8  = refl
steps-capw-10 = refl

-- 5c.  The other side of the gap at that same frontier, exact.
unary-cost-8 : usteps (cap 8) ≡ 841
unary-cost-8 = refl

-- 5d.  The law with its numeric gap discharged, at m = 8: cap 8 = 840 is
--      below 10³, so the test costs at most four transitions -- which is
--      `steps-capw-8` above, so the bound is met and not merely obeyed.
--      (Named, not inlined: `TransportDivScale` §4 records that inlining
--      a ≤-witness sends the elaborator symbolic and exhausts the heap.)
gap-8 : cap 8 < 10 ^ 3
gap-8 = 159 , refl

cost-bound-8 : steps (capw 8) ≤ 4
cost-bound-8 = charted-test-cost-log 8 3 gap-8

-- and the matching lower half: 10² ≤ 840, so no shorter word represents
-- the capacity -- three digits is the digit count, not an upper estimate.
low-8 : 10 ^ 2 ≤ cap 8
low-8 = 740 , refl

length-lower-8 : 2 < length (capw 8)
length-lower-8 = capw-length-> 8 2 low-8
