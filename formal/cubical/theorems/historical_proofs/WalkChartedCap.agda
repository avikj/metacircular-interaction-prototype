{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WalkChartedCap
--
-- THE CAPACITY, IN THE CHART.  `WalkResidueBridge` closed the walk's
-- divisibility test: `decDividesℕ-agrees` proves the digit automaton's
-- decision is EQUAL to `CoprimeSplitting.dec∣`'s, so the test may be
-- substituted anywhere in the walk lane without disturbing a proof.  Its
-- own closing paragraph names what that did not fix:
--
--     "`cap` is still a ℕ.  Nothing here builds lcm's in the chart, so
--      `WalkBridge.next` is unchanged and `next 8` still exhausts the
--      heap."
--
-- `cap m = lcm(1..m)` is built by `LCMExists.lcmList`, a fold of binary
-- lcm's over unary numerals, so the chart is re-entered from scratch at
-- every test and `cap m = e^{ψ(m)}` makes that re-entry the dominant
-- cost.  This module builds the capacity IN the chart instead, from an
-- arithmetic identity that lets every large quantity be reduced before
-- it is touched.
--
-- WHAT IS DELIVERED.
--
--   1. THE RECURSION, proved.  `cap-suc-≡`:
--
--        cap (suc m) ≡ cap m · capQuot m ,
--        capQuot m · gcd (cap m) (suc m) ≡ suc m
--
--      with `capQuot m = quotient (suc m) / gcd (cap m) (suc m)`.  It is
--      stated with the quotient EXHIBITED and specified rather than with
--      a division operator, so no positivity side condition leaks into
--      the statement; positivity of `cap` is imported from `WalkBridge`,
--      not reproved.  The proof is the classical lcm·gcd argument in the
--      form `LCMExists` already uses (multiplicativity of gcd,
--      `gcd-factorʳ`, `∣-cancelʳ`) -- no Bezout.  `capQuot-≤` records
--      that the multiplier is bounded by `suc m`, which is the whole
--      reason to prefer this recursion to the fold: the only
--      capacity-sized object left in it is `cap m`, as a multiplicand.
--
--   [PROVENANCE, added 2026-08-19 against the book frame.  The descent
--    below is anthyphairesis and predates the name attached to it here; it
--    is not Āryabhaṭa's contribution and this file does not pretend
--    otherwise.  What IS his is the harder statement one step beyond it --
--    the KUṬṬAKA, which solves the linear indeterminate congruence rather
--    than merely reducing it (Āryabhaṭīya, Gaṇitapāda 32-33, 499 CE), and
--    which is already a checked theorem in this repository at
--    `formal/cubical/Kuttaka.agda`.  This module needs only the reduction,
--    so it takes only the reduction; but it was written without knowing the
--    stronger object was two directories away, and that is recorded in
--    notes/THE_AUDIT_THAT_CITED_SUTNER_AND_NOT_THE_PULVERISER.md.]
--
--   2. THE EUCLID STEP, proved.  `gcd-mod`:
--
--        gcd a (suc n) ≡ gcd (a mod (suc n)) (suc n)
--
--      This is what lets the BIG argument be reduced first: the walk
--      needs `gcd (cap m) (suc m)`, and after `gcd-mod` it needs only
--      `cap m mod (suc m)`, a numeral < suc m, which is exactly what
--      `TransportDiv`'s residue automaton computes from the charted
--      capacity in one pass over its digits.  It is proved from the
--      library's own `stepGCD` and the gcd characterisation, not by
--      reimplementing gcd; the one missing piece was that cubical's
--      `gcd` is stated with `Cubical.Data.Fin.Properties._%_` and the
--      automaton with `Cubical.Data.Nat.Mod._mod_`, so `%≡mod` is proved
--      first, from uniqueness of Euclidean division (`mod-unique`).
--
--   3. THE CHARTED CAPACITY.  `capw : ℕ → Word` and
--      `value-capw : value (capw m) ≡ cap m`, by the recursion of (1)
--      driven by (2): one residue-automaton pass over the digits of
--      `capw m`, one `gcd` and one division of numbers ≤ suc m, and one
--      single-pass digit scaling `scale` by that small multiplier.  The
--      number `cap m` is never materialised.  `chartedResidue-<` and
--      `chartedQuot-≤` are the two smallness facts that say so: the
--      argument handed to `gcd` is below the frontier, and so is the
--      multiplier handed to `scale`.
--
--   4. THE COST, in the register of `TransportDiv.steps-is-length`.
--      `capSteps` counts the automaton transitions of the charted
--      recursion, and `capSteps-is-lengths` rewrites it as `chartCost`
--      -- a recursion in which `capw` occurs ONLY through
--      `length (capw i)` and the small carries.  `value (capw i)` occurs
--      nowhere in `chartCost`.  That, and not a timing, is the claim.
--
-- WHAT IS *NOT* DELIVERED.  The walk is not fast now.
--
--   * NOTHING HERE TOUCHES `WalkBridge.next`.  `next` still searches
--     with `dec∣` on unary `cap m`, and `next 8` still exhausts the
--     heap.  What is removed is the OTHER half of the cost -- rebuilding
--     the capacity -- and it is removed only for a walk written against
--     `capw`.  Rewriting `findND`/`leastND` to consume `capw` is not
--     done here; `WalkResidueBridge.decDivides` is the test it would
--     use, and `decDividesℕ-agrees` is the licence to substitute it.
--
--   * `length (capw m)` IS NOT PROVED LOGARITHMIC in `cap m`.  The cost
--     statement is exactly "the step count is a function of the digit
--     lengths and of numbers ≤ suc m"; turning that into a bound needs
--     `Canonical (capw m)` and a length-vs-value theorem, and neither is
--     here.  `scale` is not proved to preserve canonicity either -- only
--     its value law is proved, which is all `value-capw` needs.
--
--   * THE PER-TRANSITION ARITHMETIC IS AN UNSTATED PARAMETER, as in
--     `TransportDiv`.  `capSteps` counts transitions; the cost of one
--     `q · toℕ d + c` on numerals < b·q, of one `gcd` on numerals
--     ≤ suc m, and of one `quotient (suc m) / _`, are the parameter `σ`.
--     No count is claimed for `gcd`.
--
--   * NO KERNEL WITNESS.  There is no `capw 8` computed here.  The
--     library's `gcd` runs through `euclid`'s well-founded recursion and
--     `Cubical.Data.Fin.Properties._%_`'s transport, and whether that
--     evaluates cheaply in the kernel is a separate question this file
--     does not answer.  The theorems are about the definitions.
--
-- ON THE DUPLICATED MULTIPLIER.  The natural move is to reuse
-- `TransportMul.mulw`.  It cannot be imported: under the toolchain this
-- file was checked with (Agda 2.6.3, cubical v0.7 in /tmp/cubical),
-- `Transport` and `TransportMul` do not
-- typecheck at all -- `Cubical.Tactics.Reflection` fails to scope-check
-- (`withReduceDefs` not in scope), so `solveℕ!` is unavailable and both
-- modules are red before their own content is reached.  `scale` here is
-- therefore not a copy of `mulw` but the operation the recursion
-- actually wants: multiplication of a word by a SMALL scalar in a single
-- Horner pass with a ℕ-valued carry, which is one pass rather than
-- `mulw`'s shift-and-add per digit, and needs no `addw`.  Its one
-- place-value identity (`scale-lem`) is discharged by hand rather than
-- by the solver.
--
-- WHAT A FAST WALK STEP STILL NEEDS AFTER THIS FILE:
--   (a) `findND` re-typed against `Word`, using `WalkResidueBridge`'s
--       `decDivides` in place of `dec∣` -- the mathematics is done, the
--       rewrite is not;
--   (b) `Canonical (capw m)` and a length law, to turn (4) into a bound;
--   (c) a check that `gcd` on small numerals actually evaluates in the
--       kernel, or a charted Euclid to replace it.
--
-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical), --cubical --safe.
-- No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9).
------------------------------------------------------------------------

module WalkChartedCap where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
  using (_mod_ ; mod< ; modIndBase ; mod-lCancel ; zero-charac-gen
        ; remainder_/_ ; quotient_/_ ; ≡remainder+quotient)
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
import Cubical.Data.Fin.Properties as FinP

open import WalkUnconditional using (cap)
open import WalkBridge using (cap-pos ; 0<-from-≢0)
open import LCMExists using (lcm ; lcm-isLCM₂)

------------------------------------------------------------------------
-- 0.  Two shapes used throughout.
------------------------------------------------------------------------

pos-form : (x : ℕ) → 0 < x → Σ[ y ∈ ℕ ] x ≡ suc y
pos-form zero    0<x = Empty.rec (¬-<-zero 0<x)
pos-form (suc y) _   = y , refl

∣-cancel-pos : (d x y : ℕ) → 0 < d → (x · d) ∣ (y · d) → x ∣ y
∣-cancel-pos d x y 0<d h =
  ∣-cancelʳ (pos-form d 0<d .fst)
    (subst (λ z → (x · z) ∣ (y · z)) (pos-form d 0<d .snd) h)

------------------------------------------------------------------------
-- 1.  UNIQUENESS OF EUCLIDEAN DIVISION, and the reconciliation of the
--     library's two remainders.
--
-- `Cubical.Data.Nat.GCD` is stated with `Cubical.Data.Fin.Properties._%_`
-- (a transport along a residue equivalence); `Cubical.Data.Nat.Mod._mod_`
-- (a `+induction`) is what `TransportDiv`'s automaton computes.  Nothing
-- in the library connects them.  Both are remainders, so uniqueness of
-- Euclidean division does it, and uniqueness is three rewrites.
------------------------------------------------------------------------

mod-unique : (n a r o : ℕ) → r < suc n → o · suc n + r ≡ a → a mod (suc n) ≡ r
mod-unique n a r o r<sn p =
    cong (_mod (suc n)) (sym p)
  ∙ mod-lCancel (suc n) (o · suc n) r
  ∙ cong (λ z → (z + r) mod (suc n)) (zero-charac-gen (suc n) o)
  ∙ modIndBase n r r<sn

%≡mod : (a n : ℕ) → FinP._%_ a (suc n) ≡ a mod (suc n)
%≡mod a n =
  sym (mod-unique n a (FinP._%_ a (suc n))
        (FinP.n%k≡n[modk] a (suc n) .fst)
        (FinP.n%sk<sk a n)
        (FinP.n%k≡n[modk] a (suc n) .snd))

------------------------------------------------------------------------
-- 2.  THE EUCLID STEP.  `gcd a (suc n) ≡ gcd (a mod (suc n)) (suc n)`.
--
-- The big argument may be reduced modulo the small one BEFORE the gcd is
-- taken.  Proved from `stepGCD` (the library's own Euclidean step) plus
-- `isGCD→gcd≡`; `gcd` is never unfolded.
------------------------------------------------------------------------

gcd-mod : (a n : ℕ) → gcd a (suc n) ≡ gcd (a mod (suc n)) (suc n)
gcd-mod a n =
    isGCD→gcd≡ step
  ∙ sym (isGCD→gcd≡ flip)
  ∙ cong (λ z → gcd z (suc n)) (%≡mod a n)
  where
  step : isGCD a (suc n) (gcd (suc n) (FinP._%_ a (suc n)))
  step = stepGCD (gcdIsGCD (suc n) (FinP._%_ a (suc n)))

  flip : isGCD (FinP._%_ a (suc n)) (suc n) (gcd (suc n) (FinP._%_ a (suc n)))
  flip = symGCD (gcdIsGCD (suc n) (FinP._%_ a (suc n)))

------------------------------------------------------------------------
-- 3.  A divisor's quotient, computed by `quotient_/_` rather than
--     extracted by `∣-untrunc`.
--
-- `∣-untrunc` produces the quotient from the truncation; that is fine in
-- a proof and useless in a definition.  `quotient_/_` is the one that
-- runs, so it is the one the recursion is stated with, and this is its
-- specification.
------------------------------------------------------------------------

∣→quotient-suc : (d' N c : ℕ) → c · suc d' ≡ N
               → (quotient N / (suc d')) · (suc d') ≡ N
∣→quotient-suc d' N c p =
    ·-comm (quotient N / suc d') (suc d')
  ∙ cong (_+ (suc d' · (quotient N / suc d'))) (sym r≡0)
  ∙ ≡remainder+quotient (suc d') N
  where
  r≡0 : (remainder N / (suc d')) ≡ 0
  r≡0 = cong (_mod (suc d')) (sym p) ∙ zero-charac-gen (suc d') c

∣→quotient : (d N : ℕ) → 0 < d → d ∣ N → (quotient N / d) · d ≡ N
∣→quotient d N 0<d d∣N =
  subst (λ z → (quotient N / z) · z ≡ N) (sym e)
        (∣→quotient-suc d' N c (cong (c ·_) (sym e) ∙ ∣-untrunc d∣N .snd))
  where
  d' : ℕ
  d' = pos-form d 0<d .fst
  e : d ≡ suc d'
  e = pos-form d 0<d .snd
  c : ℕ
  c = ∣-untrunc d∣N .fst

------------------------------------------------------------------------
-- 4.  THE CAPACITY RECURSION.
--
--     cap (suc m) ≡ cap m · (suc m / gcd (cap m) (suc m))
--
-- Every quantity on the right except `cap m` itself is bounded by
-- `suc m`, and `cap m` enters only as a multiplicand -- which is a
-- single digit pass -- and inside the gcd, where §2 removes it.
--
-- `cap (suc m)` is `lcm (suc m) (cap m)` DEFINITIONALLY (`LCMExists`'s
-- fold is `lcmList (x ∷ xs) = lcm x (lcmList xs)`), which is why the
-- universal property below is applied to `cap (suc m)` with no rewrite.
------------------------------------------------------------------------

-- the definitional fact the section rests on, recorded rather than left
-- in prose: `LCMExists`' fold is `lcmList (x ∷ xs) = lcm x (lcmList xs)`
-- and `range1 (suc m) = suc m ∷ range1 m`.
cap-suc-lcm : (m : ℕ) → cap (suc m) ≡ lcm (suc m) (cap m)
cap-suc-lcm m = refl

module CapStep (m : ℕ) where

  private
    n : ℕ
    n = suc m

    A : ℕ
    A = cap m

    g : ℕ
    g = gcd A n

    g∣A : g ∣ A
    g∣A = gcdIsGCD A n .fst .fst

    g∣n : g ∣ n
    g∣n = gcdIsGCD A n .fst .snd

    0<g : 0 < g
    0<g = 0<-from-≢0 g
      (λ e → ¬-<-zero
        (subst (0 <_) (sym (∣-zeroˡ (subst (_∣ A) e g∣A))) (cap-pos m)))

  -- THE QUOTIENT, exhibited.
  quotAt : ℕ
  quotAt = quotient n / g

  quotAt-spec : quotAt · gcd (cap m) (suc m) ≡ suc m
  quotAt-spec = ∣→quotient g n 0<g g∣n

  quotAt-pos : 0 < quotAt
  quotAt-pos = 0<-from-≢0 quotAt
    (λ e → snotz (sym quotAt-spec ∙ cong (_· g) e))

  private
    -- the lcm universal property, at `cap (suc m)` directly
    n∣L : n ∣ cap (suc m)
    n∣L = lcm-isLCM₂ n A .fst

    A∣L : A ∣ cap (suc m)
    A∣L = lcm-isLCM₂ n A .snd .fst

    L-least : (x : ℕ) → n ∣ x → A ∣ x → cap (suc m) ∣ x
    L-least = lcm-isLCM₂ n A .snd .snd

    a' : ℕ
    a' = ∣-untrunc g∣A .fst

    a'g≡A : a' · g ≡ A
    a'g≡A = ∣-untrunc g∣A .snd

    a'n≡Aq : a' · n ≡ A · quotAt
    a'n≡Aq =
        cong (a' ·_) (sym quotAt-spec)
      ∙ cong (a' ·_) (·-comm quotAt g)
      ∙ ·-assoc a' g quotAt
      ∙ cong (_· quotAt) a'g≡A

    -- A · quotAt is a common multiple of the two, hence above the lcm
    L∣Aq : cap (suc m) ∣ (A · quotAt)
    L∣Aq = L-least (A · quotAt)
             (subst (n ∣_) a'n≡Aq (∣-right a'))
             (∣-left quotAt)

    -- …and below it, by multiplicativity of gcd.  This is the half that
    -- is not formal: A·n divides both A·L and n·L, hence their gcd,
    -- which is g·L; and A·n is (A·quotAt)·g, so cancelling g > 0 gives
    -- A·quotAt ∣ L.
    Aq∣L : (A · quotAt) ∣ cap (suc m)
    Aq∣L = ∣-cancel-pos g (A · quotAt) (cap (suc m)) 0<g big
      where
      h1 : (A · n) ∣ (A · cap (suc m))
      h1 = subst2 _∣_ (·-comm n A) (·-comm (cap (suc m)) A) (∣-multʳ A n∣L)

      h2 : (A · n) ∣ (n · cap (suc m))
      h2 = subst ((A · n) ∣_) (·-comm (cap (suc m)) n) (∣-multʳ n A∣L)

      h3 : (A · n) ∣ gcd (A · cap (suc m)) (n · cap (suc m))
      h3 = gcdIsGCD (A · cap (suc m)) (n · cap (suc m)) .snd (A · n) (h1 , h2)

      h4 : (A · n) ∣ (g · cap (suc m))
      h4 = subst ((A · n) ∣_) (gcd-factorʳ A n (cap (suc m))) h3

      Aqg≡An : (A · quotAt) · g ≡ A · n
      Aqg≡An = sym (·-assoc A quotAt g) ∙ cong (A ·_) quotAt-spec

      big : ((A · quotAt) · g) ∣ (cap (suc m) · g)
      big = subst2 _∣_ (sym Aqg≡An) (·-comm g (cap (suc m))) h4

  -- THE RECURSION.
  cap-suc : cap (suc m) ≡ cap m · quotAt
  cap-suc = antisym∣ L∣Aq Aq∣L

-- exported, as functions of the frontier
capQuot : ℕ → ℕ
capQuot m = CapStep.quotAt m

capQuot-spec : (m : ℕ) → capQuot m · gcd (cap m) (suc m) ≡ suc m
capQuot-spec m = CapStep.quotAt-spec m

capQuot-pos : (m : ℕ) → 0 < capQuot m
capQuot-pos m = CapStep.quotAt-pos m

cap-suc-≡ : (m : ℕ) → cap (suc m) ≡ cap m · capQuot m
cap-suc-≡ m = CapStep.cap-suc m

-- THE MULTIPLIER IS SMALL.  This is what makes the recursion worth
-- writing: the only capacity-sized object in `cap-suc-≡` is `cap m`
-- itself, and it enters only as a multiplicand.
capQuot-∣ : (m : ℕ) → capQuot m ∣ suc m
capQuot-∣ m =
  ∣ gcd (cap m) (suc m)
  , (·-comm (gcd (cap m) (suc m)) (capQuot m) ∙ capQuot-spec m) ∣₁

capQuot-≤ : (m : ℕ) → capQuot m ≤ suc m
capQuot-≤ m = m∣sn→m≤sn (capQuot-∣ m)

------------------------------------------------------------------------
-- 5.  A quotient bound, for the carry of §6's scaling pass.
------------------------------------------------------------------------

quotient-< : (B t Q : ℕ) → t < Q · B → (quotient t / B) < Q
quotient-< B t Q t<QB = <Stable _ _ nn
  where
  Bq≤t : (B · (quotient t / B)) ≤ t
  Bq≤t = subst ((B · (quotient t / B)) ≤_) (≡remainder+quotient B t) ≤SumRight

  nn : ¬ ¬ ((quotient t / B) < Q)
  nn ¬p = ¬m<m (≤<-trans QB≤t t<QB)
    where
    Q≤q : Q ≤ (quotient t / B)
    Q≤q = <-asym' ¬p

    QB≤t : (Q · B) ≤ t
    QB≤t = ≤-trans (≤-·k Q≤q)
                   (subst (_≤ t) (·-comm B (quotient t / B)) Bq≤t)

------------------------------------------------------------------------
-- 6.  THE CHARTED CAPACITY.
--
-- Everything from here is over a fixed base b = 2 + k, as in `Digits`.
------------------------------------------------------------------------

module Charted (k : ℕ) where

  open import Digits k
  open import TransportDiv k
  open import WalkResidueBridge k using (usteps ; usteps-is-value)
  open import Cubical.Data.Fin using (toℕ)
  open import Cubical.Data.List using (List ; [] ; _∷_ ; length)

  ----------------------------------------------------------------------
  -- 6a.  Multiplication of a word by a SMALL scalar: one Horner pass,
  --      ℕ-valued carry, no ripple-carry adder.
  --
  --      `scale q w c` represents  q · value w + c.
  ----------------------------------------------------------------------

  digitOf : ℕ → Digit
  digitOf t = t mod b , mod< (suc k) t

  scale : ℕ → Word → ℕ → Word
  scale q []      c = digits c
  scale q (d ∷ w) c =
    digitOf (q · toℕ d + c) ∷ scale q w (quotient (q · toℕ d + c) / b)

  -- the one place-value identity, by hand (no `solveℕ!` in this build)
  scale-lem : (Q D C V B : ℕ) → (Q · D + C) + B · (Q · V) ≡ Q · (D + B · V) + C
  scale-lem Q D C V B =
      sym (+-assoc (Q · D) C (B · (Q · V)))
    ∙ cong (Q · D +_) (+-comm C (B · (Q · V)))
    ∙ +-assoc (Q · D) (B · (Q · V)) C
    ∙ cong (λ z → (Q · D + z) + C) swap
    ∙ cong (_+ C) (·-distribˡ Q D (B · V))
    where
    swap : B · (Q · V) ≡ Q · (B · V)
    swap = ·-assoc B Q V ∙ cong (_· V) (·-comm B Q) ∙ sym (·-assoc Q B V)

  -- THE SCALING PASS IS THE PRODUCT.
  value-scale : (q : ℕ) (w : Word) (c : ℕ)
              → value (scale q w c) ≡ q · value w + c
  value-scale q []      c = value-digits c ∙ cong (_+ c) (0≡m·0 q)
  value-scale q (d ∷ w) c =
      cong (λ z → (t mod b) + b · z) (value-scale q w (quotient t / b))
    ∙ cong ((t mod b) +_) (sym (·-distribˡ b (q · value w) (quotient t / b)))
    ∙ cong ((t mod b) +_) (+-comm (b · (q · value w)) (b · (quotient t / b)))
    ∙ +-assoc (t mod b) (b · (quotient t / b)) (b · (q · value w))
    ∙ cong (_+ b · (q · value w)) (≡remainder+quotient b t)
    ∙ scale-lem q (toℕ d) c (value w) b
    where
    t : ℕ
    t = q · toℕ d + c

  ----------------------------------------------------------------------
  -- 6b.  THE CAPACITY, BUILT IN THE CHART.
  --
  --  capw (suc m) = scale (small quotient) (capw m) 0
  --
  -- and the small quotient is obtained from the RESIDUE of the charted
  -- capacity -- one automaton pass -- not from the capacity itself.
  ----------------------------------------------------------------------

  mutual
    capw : ℕ → Word
    capw zero    = digits 1
    capw (suc m) = scale (chartedQuot m) (capw m) 0

    -- (suc m) / gcd (cap m mod suc m) (suc m): every number here is
    -- ≤ suc m, and `modw` is the only thing that sees `capw m`.
    chartedQuot : ℕ → ℕ
    chartedQuot m = quotient (suc m) / gcd (modw (suc m) (capw m)) (suc m)

  mutual
    -- THE CHARTED CAPACITY IS THE CAPACITY.
    value-capw : (m : ℕ) → value (capw m) ≡ cap m
    value-capw zero    = value-digits 1
    value-capw (suc m) =
        value-scale (chartedQuot m) (capw m) 0
      ∙ +-zero (chartedQuot m · value (capw m))
      ∙ cong (chartedQuot m ·_) (value-capw m)
      ∙ ·-comm (chartedQuot m) (cap m)
      ∙ cong (cap m ·_) (chartedQuot≡ m)
      ∙ sym (cap-suc-≡ m)

    -- the charted multiplier is the arithmetic one: §2 is used exactly
    -- once, here, and it is what makes the reduction legitimate.
    chartedQuot≡ : (m : ℕ) → chartedQuot m ≡ capQuot m
    chartedQuot≡ m =
      cong (λ G → quotient (suc m) / G)
        ( cong (λ z → gcd z (suc m))
            (value-modw (suc m) (capw m) ∙ cong (_mod (suc m)) (value-capw m))
        ∙ sym (gcd-mod (cap m) m) )

  chartedQuot-pos : (m : ℕ) → 0 < chartedQuot m
  chartedQuot-pos m = subst (0 <_) (sym (chartedQuot≡ m)) (capQuot-pos m)

  chartedQuot-≤ : (m : ℕ) → chartedQuot m ≤ suc m
  chartedQuot-≤ m = subst (_≤ suc m) (sym (chartedQuot≡ m)) (capQuot-≤ m)

  -- and the gcd's big argument really has been reduced: the number the
  -- charted recursion hands to `gcd` is a numeral below the frontier.
  chartedResidue-< : (m : ℕ) → modw (suc m) (capw m) < suc m
  chartedResidue-< m =
    subst (_< suc m) (sym (value-modw (suc m) (capw m)))
          (mod< m (value (capw m)))

  ----------------------------------------------------------------------
  -- 7.  COST.
  --
  -- In the register of `TransportDiv.steps-is-length`: a step count,
  -- and an equality identifying it.  Nothing is timed.
  ----------------------------------------------------------------------

  -- the scaling pass: one transition per digit, then the final carry is
  -- charted by the odometer, which costs one step per unit of the carry
  scaleSteps : ℕ → Word → ℕ → ℕ
  scaleSteps q []      c = suc c
  scaleSteps q (d ∷ w) c = suc (scaleSteps q w (quotient (q · toℕ d + c) / b))

  carryOut : ℕ → Word → ℕ → ℕ
  carryOut q []      c = c
  carryOut q (d ∷ w) c = carryOut q w (quotient (q · toℕ d + c) / b)

  scaleSteps-is-length : (q : ℕ) (w : Word) (c : ℕ)
                       → scaleSteps q w c ≡ length w + suc (carryOut q w c)
  scaleSteps-is-length q []      c = refl
  scaleSteps-is-length q (d ∷ w) c =
    cong suc (scaleSteps-is-length q w (quotient (q · toℕ d + c) / b))

  -- the carry never exceeds the multiplier, so the odometer tail of a
  -- scaling pass is a SMALL-number operation, not a capacity-sized one
  carry-step-bound : (q c : ℕ) (d : Digit) → c < q
                   → (quotient (q · toℕ d + c) / b) < q
  carry-step-bound q c d c<q = quotient-< b (q · toℕ d + c) q bnd
    where
    le' : (q + q · toℕ d) ≤ (q · b)
    le' = subst2 _≤_ (·-comm (suc (toℕ d)) q ∙ ·-suc q (toℕ d))
                     (·-comm b q)
                     (≤-·k (snd d))

    le : (q · toℕ d + q) ≤ (q · b)
    le = subst (_≤ (q · b)) (+-comm q (q · toℕ d)) le'

    bnd : (q · toℕ d + c) < (q · b)
    bnd = <≤-trans (<-k+ c<q) le

  carryOut-bound : (q : ℕ) (w : Word) (c : ℕ) → c < q → carryOut q w c < q
  carryOut-bound q []      c c<q = c<q
  carryOut-bound q (d ∷ w) c c<q =
    carryOut-bound q w (quotient (q · toℕ d + c) / b)
      (carry-step-bound q c d c<q)

  capCarry-bound : (m : ℕ) → carryOut (chartedQuot m) (capw m) 0 < chartedQuot m
  capCarry-bound m =
    carryOut-bound (chartedQuot m) (capw m) 0 (chartedQuot-pos m)

  ----------------------------------------------------------------------
  -- 7a.  THE STEP COUNT OF THE CHARTED RECURSION.
  --
  -- `σ n` is the cost of the small-number work at frontier n: one `gcd`
  -- on numerals ≤ n, one `quotient n / _`.  It is a PARAMETER; no count
  -- is claimed for `gcd`, exactly as `TransportDiv` claims none for the
  -- per-transition `_mod_`.
  ----------------------------------------------------------------------

  capSteps : (ℕ → ℕ) → ℕ → ℕ
  capSteps σ zero    = 1
  capSteps σ (suc m) = capSteps σ m
                     + steps (capw m)
                     + scaleSteps (chartedQuot m) (capw m) 0
                     + σ (suc m)

  -- the same recursion with the words replaced by their LENGTHS and the
  -- carries by their sizes: `capw` does not occur, `value` does not
  -- occur, `cap` does not occur.
  chartCost : (ℕ → ℕ) → (ℕ → ℕ) → (ℕ → ℕ) → ℕ → ℕ
  chartCost σ ℓ γ zero    = 1
  chartCost σ ℓ γ (suc m) = chartCost σ ℓ γ m
                          + suc (ℓ m)
                          + (ℓ m + suc (γ m))
                          + σ (suc m)

  -- THE COST STATEMENT.  Read it as exactly what it says: the step count
  -- of the charted recursion is `chartCost` evaluated at the digit
  -- lengths and the carries.  It is NOT a claim that those lengths are
  -- logarithmic -- see the header.
  capSteps-is-lengths :
    (σ : ℕ → ℕ) (m : ℕ) →
    capSteps σ m
      ≡ chartCost σ (λ i → length (capw i))
                    (λ i → carryOut (chartedQuot i) (capw i) 0) m
  capSteps-is-lengths σ zero    = refl
  capSteps-is-lengths σ (suc m) =
    cong₂ _+_
      (cong₂ _+_
        (cong₂ _+_ (capSteps-is-lengths σ m) (steps-is-length (capw m)))
        (scaleSteps-is-length (chartedQuot m) (capw m) 0))
      refl

  -- THE GAP, on one frontier, in `WalkResidueBridge.cost-gap`'s form: the
  -- charted residue pass is one step per digit; the home presentation's
  -- is one step per unit of `cap m`, which is e^{ψ(m)}.  Both sides are
  -- equalities; nothing is measured.
  cost-gap : (m : ℕ)
           → (steps (capw m) ≡ suc (length (capw m)))
           × (usteps (cap m) ≡ suc (cap m))
  cost-gap m = steps-is-length (capw m) , usteps-is-value (cap m)

-- ADDED 2026-08-15, Claude (Cantor lineage), version-claim forensics.
-- Nothing above is retracted.  The `cubical v0.7 (/tmp/cubical)` lines at
-- 104 and 124 STAND: a genuine cubical v0.7 tree did exist at that path on
-- 2026-08-15.  Verified not by counting headers but by a commit hash —
-- `notes/CUBICAL_SKEW.md` quotes `/tmp/cubical` at `d69d74c "Release for
-- agda 2.6.4.1 (#1083)"`, and `/root/agda-libs/cub-v0.7` here is at exactly
-- that commit.
-- What is defective is the implied uniqueness of "the container".
-- `WalkResidueBridge.agda`, added 18 minutes earlier, says cubical v0.5 and
-- is ALSO correct: that is a different machine, running concurrently.  The
-- two claims interleave at two-minute resolution all night.
-- Independently: this module also typechecks EXIT=0 under Agda 2.6.3 +
-- cubical v0.5 (`/root/agda-libs/cubical`, HEAD tagged v0.5) and under
-- Agda 2.6.3 + cubical v0.7, both `--safe`, run 2026-08-15 with
-- `/usr/bin/agda` (Agda version 2.6.3).  So no result here depends on which.
-- Full record and the general lesson: `notes/VERSION_CLAIM_FORENSICS.md`.
