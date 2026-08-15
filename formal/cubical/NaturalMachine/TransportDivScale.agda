{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TransportDivScale
--
-- THE X-DEPENDENCE OF THE FRONTIER.
--
-- `TransportDivWitness` pins one point: base ten, the word 1000, chart
-- work 5 against home work 1000, detour 14, branch ↝.  A single point
-- is a number without its scaling, and CLAUDE.md is explicit that such a
-- number "looks like knowledge".  This module supplies the exponent.
--
-- Two laws, both proved, neither measured:
--
--   CHART  steps w ≡ suc (length w)                  -- linear in L
--          (this is `TransportDiv.steps-is-length`, imported, not re-run)
--
--   HOME   Canonical (d ∷ w) → b ^ (length w) ≤ value (d ∷ w)
--                                                    -- exponential in L
--
-- The second is the positional lower bound: canonicity says the most
-- significant digit is nonzero, and the positional sum then dominates
-- b^(L−1) for a word of length L.  Nothing here is fitted; the constant
-- in front of the exponential is 1 and the exponent is exactly L−1.
--
-- The consequence, and the point of the module: for FIXED edge costs the
-- detour beats staying home for EVERY canonical word past a stated
-- length, not merely at the four sizes exhibited below.  That threshold
-- is 4 + (2·chart + unchart) digits after the leading one, and it is
-- derived, so it comes with its base-dependence attached.
--
-- The four numeric instances (10³, 10⁴, 10⁵, 10⁶ in base ten) are then
-- not four measurements: each is (S1) — the scaling law with one
-- kernel-checked numeric gap — and a fifth instance at 10¹³ is (S2)
-- itself, with no numeric gap at all.  They are here to show the law has
-- the points in it, which is the only thing a point is good for.
------------------------------------------------------------------------

module NaturalMachine.TransportDivScale where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Maybe using (just)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)

import NaturalMachine.Digits as Dig
import NaturalMachine.TransportDiv as TD

open import NaturalMachine.CostGeometry
open import NaturalMachine.Residual

------------------------------------------------------------------------
-- 0.  The branch, in the direction `Residual` did not need.
--
-- `Residual.↝-is-speedup` reads a branch and produces an inequality.
-- Here the inequality is what the scaling law produces, so the converse
-- is what is needed: a speedup *is* the third branch.  Truncated
-- subtraction is positive exactly when the subtrahend is smaller.
------------------------------------------------------------------------

<→⊖-pos : (m n : ℕ) → n < m → Σ[ j ∈ ℕ ] (m ⊖ n ≡ suc j)
<→⊖-pos zero    n       h = Empty.rec (¬-<-zero h)
<→⊖-pos (suc m) zero    h = m , refl
<→⊖-pos (suc m) (suc n) h = <→⊖-pos m n (pred-≤-pred h)

speedup-is-↝ :
    {A B : Presentation} (bg : Bridge A B) (wHere wThere : Work)
  → Speedup (fst bg) (snd bg) wHere wThere
  → respond (just bg) wHere wThere ≡ ↝
speedup-is-↝ (out , back) wHere wThere sp =
  cong branchOf (snd (<→⊖-pos wHere (detour out back wThere) sp))

------------------------------------------------------------------------
-- 1.  The scaling, for an arbitrary base b = 2 + k.
------------------------------------------------------------------------

module Scaling (k : ℕ) where

  open Dig k public
  open TD  k public

  ----------------------------------------------------------------------
  -- 1a.  Powers of the base.  Only b ≥ 2 is used, and it is used as the
  --      definitional unfolding b · x = x + (x + k · x).
  ----------------------------------------------------------------------

  pow-suc-eq : (n : ℕ) → b ^ suc n ≡ b ^ n + (b ^ n + k · b ^ n)
  pow-suc-eq n = refl

  pow-mono-suc : (n : ℕ) → b ^ n ≤ b ^ suc n
  pow-mono-suc n = subst (b ^ n ≤_) (sym (pow-suc-eq n)) ≤SumLeft

  pow-pos : (n : ℕ) → 1 ≤ b ^ n
  pow-pos zero    = ≤-refl
  pow-pos (suc n) = ≤-trans (pow-pos n) (pow-mono-suc n)

  -- doubling is available at every step, because b ≥ 2
  pow-double : (n : ℕ) → b ^ n + b ^ n ≤ b ^ suc n
  pow-double n =
    subst (b ^ n + b ^ n ≤_) (sym (pow-suc-eq n))
          (≤-k+ {m = b ^ n} {n = b ^ n + k · b ^ n} {k = b ^ n}
                (≤SumLeft {n = b ^ n} {k = k · b ^ n}))

  two≤pow-suc : (n : ℕ) → 2 ≤ b ^ suc n
  two≤pow-suc n = ≤-trans (≤-+-≤ (pow-pos n) (pow-pos n)) (pow-double n)

  four≤pow2 : 4 ≤ b ^ 2
  four≤pow2 = ≤-trans (≤-+-≤ (two≤pow-suc 0) (two≤pow-suc 0)) (pow-double 1)

  eight≤pow3 : 8 ≤ b ^ 3
  eight≤pow3 = ≤-trans (≤-+-≤ four≤pow2 four≤pow2) (pow-double 2)

  sixteen≤pow4 : 16 ≤ b ^ 4
  sixteen≤pow4 = ≤-trans (≤-+-≤ eight≤pow3 eight≤pow3) (pow-double 3)

  six<pow4 : 6 < b ^ 4
  six<pow4 = <≤-trans (9 , refl) sixteen≤pow4

  ----------------------------------------------------------------------
  -- 1b.  Linear loses to exponential, with an explicit threshold.
  --
  --      For every constant A: A + n + 2 < b ^ n as soon as n ≥ 4 + A.
  --      The threshold is uniform in the base — it is the b = 2 answer,
  --      so for larger b it is sufficient but far from sharp.  §3d–3f
  --      therefore go through (S1) with an explicit gap; §3g exhibits a
  --      word past the threshold and uses (S2) unaided.
  ----------------------------------------------------------------------

  lin<pow-base : (A : ℕ) → A + (4 + A) + 2 < b ^ (4 + A)
  lin<pow-base zero    = six<pow4
  lin<pow-base (suc a) =
    subst (λ z → suc (suc z) ≤ b ^ suc (4 + a)) (sym shift)
      (≤-trans (≤-+-≤ (two≤pow-suc (3 + a)) (lin<pow-base a))
               (pow-double (4 + a)))
    where
      shift : a + suc (4 + a) + 2 ≡ suc (a + (4 + a) + 2)
      shift = cong (_+ 2) (+-suc a (4 + a))

  lin<pow-step : (A n : ℕ) → A + n + 2 < b ^ n → A + suc n + 2 < b ^ suc n
  lin<pow-step A n ih =
    subst (λ z → suc z ≤ b ^ suc n) (sym shift)
      (≤-trans (≤-+-≤ (pow-pos n) ih) (pow-double n))
    where
      shift : A + suc n + 2 ≡ suc (A + n + 2)
      shift = cong (_+ 2) (+-suc A n)

  lin<pow-offset : (A r : ℕ) → A + (r + (4 + A)) + 2 < b ^ (r + (4 + A))
  lin<pow-offset A zero    = lin<pow-base A
  lin<pow-offset A (suc r) = lin<pow-step A (r + (4 + A)) (lin<pow-offset A r)

  lin<pow : (A n : ℕ) → 4 + A ≤ n → A + n + 2 < b ^ n
  lin<pow A n (r , p) =
    subst (λ m → A + m + 2 < b ^ m) p (lin<pow-offset A r)

  ----------------------------------------------------------------------
  -- 1c.  HOME COST IS EXPONENTIAL IN THE LENGTH.
  --
  --      `Canonical (d ∷ w)` says the most significant digit of the word
  --      is positive.  The positional sum then dominates b^(length w),
  --      i.e. b^(L−1) for a word of length L.  This is the whole content
  --      of "the unary test walks the value": the value it walks is
  --      exponential in the number of digits the automaton reads.
  ----------------------------------------------------------------------

  ·-mono-right : (c x y : ℕ) → x ≤ y → c · x ≤ c · y
  ·-mono-right c x y p = subst2 _≤_ (·-comm x c) (·-comm y c) (≤-·k p)

  pow≤value : (d : Digit) (w : Word) → Canonical (d ∷ w)
            → b ^ (length w) ≤ value (d ∷ w)
  pow≤value d []      c =
    ≤-trans c (≤SumLeft {n = toℕ d} {k = b · value []})
  pow≤value d (e ∷ w) c =
    ≤-trans (·-mono-right b (b ^ length w) (value (e ∷ w)) (pow≤value e w c))
            (≤SumRight {n = b · value (e ∷ w)} {k = toℕ d})

  ----------------------------------------------------------------------
  -- 1d.  THE SCALING STATEMENT, in one place.
  --
  --      Chart cost: linear in the length.  Home cost: exponential in
  --      the length.  Both exact; no constant is fitted and no exponent
  --      is estimated.
  ----------------------------------------------------------------------

  scaling-law : (d : Digit) (w : Word) → Canonical (d ∷ w)
              → (steps (d ∷ w) ≡ suc (suc (length w)))
              × (b ^ (length w) ≤ value (d ∷ w))
  scaling-law d w c = steps-is-length (d ∷ w) , pow≤value d w c

  ----------------------------------------------------------------------
  -- 2.  THE COST GEOMETRY, QUANTIFIED.
  --
  --     The presentations and edges of `TransportDivWitness`, with the
  --     edge weights left as parameters, exactly as `CostGeometry`
  --     insists they must be: a path licenses a substitution, it never
  --     pays for one.
  ----------------------------------------------------------------------

  unaryP : Presentation
  unaryP = pres ℕ _+_

  chartP : Presentation
  chartP = pres Word (λ u v → u)

  chartE : ℕ → Edge unaryP chartP
  chartE c = edge digits c

  unchartE : ℕ → Edge chartP unaryP
  unchartE c = edge value c

  bridgeE : ℕ → ℕ → Bridge unaryP chartP
  bridgeE c c' = chartE c , unchartE c'

  -- The detour, in closed form: 2·(chart) + (unchart) + (L + 2).
  detour-eq : (c c' : ℕ) (d : Digit) (w : Word)
            → detour (chartE c) (unchartE c') (steps (d ∷ w))
              ≡ ((c + c) + c') + length w + 2
  detour-eq c c' d w =
      cong (λ s → (c + c) + (c' + s)) (steps-is-length (d ∷ w))
    ∙ +-assoc (c + c) c' (2 + length w)
    ∙ cong (((c + c) + c') +_) (+-comm 2 (length w))
    ∙ +-assoc ((c + c) + c') (length w) 2

  -- (S1)  A numeric gap at one length gives the speedup at that length.
  speedup-from-gap :
      (c c' : ℕ) (d : Digit) (w : Word) → Canonical (d ∷ w)
    → ((c + c) + c') + length w + 2 < b ^ (length w)
    → Speedup (chartE c) (unchartE c') (value (d ∷ w)) (steps (d ∷ w))
  speedup-from-gap c c' d w can gap =
    subst (_< value (d ∷ w)) (sym (detour-eq c c' d w))
          (<≤-trans gap (pow≤value d w can))

  -- (S2)  THE QUANTIFIED SPEEDUP.  Fixed edge costs, every canonical
  --       word past a stated length.  No instance is consulted.
  canonical-speedup :
      (c c' : ℕ) (d : Digit) (w : Word) → Canonical (d ∷ w)
    → 4 + ((c + c) + c') ≤ length w
    → Speedup (chartE c) (unchartE c') (value (d ∷ w)) (steps (d ∷ w))
  canonical-speedup c c' d w can long =
    speedup-from-gap c c' d w can
      (lin<pow ((c + c) + c') (length w) long)

  -- (S3)  … and therefore the third branch of `Residual`, for every such
  --       word: the residual ϱ is nonzero at every length past the
  --       threshold, so the frontier is not an artefact of one numeral.
  canonical-↝ :
      (c c' : ℕ) (d : Digit) (w : Word) → Canonical (d ∷ w)
    → 4 + ((c + c) + c') ≤ length w
    → respond (just (bridgeE c c')) (value (d ∷ w)) (steps (d ∷ w)) ≡ ↝
  canonical-↝ c c' d w can long =
    speedup-is-↝ (bridgeE c c') (value (d ∷ w)) (steps (d ∷ w))
                 (canonical-speedup c c' d w can long)

  -- (S4)  The chart presentation is strictly cheaper, at every such
  --       length.  This is `chart-is-better` of the witness file, freed
  --       from its single numeral.
  canonical-chart-is-better :
      (c c' : ℕ) (d : Digit) (w : Word) → Canonical (d ∷ w)
    → 4 + ((c + c) + c') ≤ length w
    → steps (d ∷ w) < value (d ∷ w)
  canonical-chart-is-better c c' d w can long =
    ↝-forces-better-presentation (bridgeE c c')
      (value (d ∷ w)) (steps (d ∷ w)) (canonical-↝ c c' d w can long)

------------------------------------------------------------------------
-- 3.  Base ten, four sizes.  Everything below is kernel-computed.
--
-- The words are little-endian, so 10^j is `fone` preceded by j zeros,
-- and each size is the previous one with a zero pushed on the front —
-- value (fzero ∷ w) = 10 · value w, which is the scaling made visible in
-- the data structure itself.
------------------------------------------------------------------------

open Scaling 8

base-is-ten : b ≡ 10
base-is-ten = refl

t3 e3 e4 e5 e6 : Word
t3 = fzero ∷ fzero ∷ fone ∷ []
e3 = fzero ∷ t3
e4 = fzero ∷ e3
e5 = fzero ∷ e4
e6 = fzero ∷ e5

------------------------------------------------------------------------
-- 3a.  Home cost at each size: the value the unary test would walk.
------------------------------------------------------------------------

value-e3 : value e3 ≡ 10 ^ 3
value-e4 : value e4 ≡ 10 ^ 4
value-e5 : value e5 ≡ 10 ^ 5
value-e6 : value e6 ≡ 10 ^ 6
value-e3 = refl
value-e4 = refl
value-e5 = refl
value-e6 = refl

value-e6-literal : value e6 ≡ 1000000
value-e6-literal = refl

------------------------------------------------------------------------
-- 3b.  Chart cost at each size: one step per digit, plus one.
--      The exponent of §1 is already visible here: the home column is
--      multiplied by ten, the chart column gains one.
------------------------------------------------------------------------

steps-e3 : steps e3 ≡ 3 + 2
steps-e4 : steps e4 ≡ 4 + 2
steps-e5 : steps e5 ≡ 5 + 2
steps-e6 : steps e6 ≡ 6 + 2
steps-e3 = refl
steps-e4 = refl
steps-e5 = refl
steps-e6 = refl

------------------------------------------------------------------------
-- 3c.  Canonicity: the most significant digit is 1, at every size.
------------------------------------------------------------------------

can3 : Canonical e3
can4 : Canonical e4
can5 : Canonical e5
can6 : Canonical e6
can3 = ≤-refl
can4 = can3
can5 = can4
can6 = can5

------------------------------------------------------------------------
-- 3d.  The numeric gaps.  These are the ONLY numbers the instances add
--      to §1: at each size, the linear detour against b^(L−1).
------------------------------------------------------------------------

gap3 : ((3 + 3) + 3) + length t3 + 2
         < b ^ length t3
gap3 = 985 , refl

gap4 : ((3 + 3) + 3) + length e3 + 2 < b ^ length e3
gap4 = 9984 , refl

gap5 : ((3 + 3) + 3) + length e4 + 2 < b ^ length e4
gap5 = 99983 , refl

gap6 : ((3 + 3) + 3) + length e5 + 2 < b ^ length e5
gap6 = 999982 , refl

------------------------------------------------------------------------
-- 3e.  The speedups.  Edge costs 3 and 3, as in `TransportDivWitness`.
--      Each is (S1) applied: the law with one gap discharged, not a
--      separate observation.
------------------------------------------------------------------------

speedup-e3 : Speedup (chartE 3) (unchartE 3) (value e3) (steps e3)
speedup-e3 = speedup-from-gap 3 3 fzero t3 can3 gap3

speedup-e4 : Speedup (chartE 3) (unchartE 3) (value e4) (steps e4)
speedup-e4 = speedup-from-gap 3 3 fzero e3 can4 gap4

speedup-e5 : Speedup (chartE 3) (unchartE 3) (value e5) (steps e5)
speedup-e5 = speedup-from-gap 3 3 fzero e4 can5 gap5

speedup-e6 : Speedup (chartE 3) (unchartE 3) (value e6) (steps e6)
speedup-e6 = speedup-from-gap 3 3 fzero e5 can6 gap6

------------------------------------------------------------------------
-- 3f.  The detours, and the third branch at each size.
------------------------------------------------------------------------

detour-e3 : detour (chartE 3) (unchartE 3) (steps e3) ≡ 14
detour-e4 : detour (chartE 3) (unchartE 3) (steps e4) ≡ 15
detour-e5 : detour (chartE 3) (unchartE 3) (steps e5) ≡ 16
detour-e6 : detour (chartE 3) (unchartE 3) (steps e6) ≡ 17
detour-e3 = refl
detour-e4 = refl
detour-e5 = refl
detour-e6 = refl

residual-e6 : ϱ (bridgeE 3 3) (value e6) (steps e6) ≡ 999983
residual-e6 = refl

branch-e3 : respond (just (bridgeE 3 3)) (value e3) (steps e3) ≡ ↝
branch-e4 : respond (just (bridgeE 3 3)) (value e4) (steps e4) ≡ ↝
branch-e5 : respond (just (bridgeE 3 3)) (value e5) (steps e5) ≡ ↝
branch-e6 : respond (just (bridgeE 3 3)) (value e6) (steps e6) ≡ ↝
branch-e3 = refl
branch-e4 = refl
branch-e5 = refl
branch-e6 = refl

------------------------------------------------------------------------
-- 3g.  NON-VACUITY OF THE THRESHOLD.
--
--      The four instances above are below the threshold of (S2) — they
--      are (S1) with a gap supplied.  So the quantified theorem is shown
--      to have an inhabitant too: a canonical word of length 14, where
--      4 + (2·3 + 3) = 13 ≤ 13 = length of the tail, and NO numeric gap
--      is supplied.  `speedup-e13` is the law alone.
------------------------------------------------------------------------

t13 : Word
t13 = fzero ∷ fzero ∷ fzero ∷ fzero ∷ fzero ∷ fzero
    ∷ fzero ∷ fzero ∷ fzero ∷ fzero ∷ fzero ∷ fzero ∷ fone ∷ []

e13 : Word
e13 = fzero ∷ t13

can13 : Canonical e13
can13 = ≤-refl

value-e13 : value e13 ≡ 10 ^ 13
value-e13 = refl

long-enough : 4 + ((3 + 3) + 3) ≤ length t13
long-enough = 0 , refl

speedup-e13 : Speedup (chartE 3) (unchartE 3) (value e13) (steps e13)
speedup-e13 = canonical-speedup 3 3 fzero t13 can13 long-enough

branch-e13 : respond (just (bridgeE 3 3)) (value e13) (steps e13) ≡ ↝
branch-e13 = canonical-↝ 3 3 fzero t13 can13 long-enough

chart-is-better-e13 : steps e13 < value e13
chart-is-better-e13 = canonical-chart-is-better 3 3 fzero t13 can13 long-enough

------------------------------------------------------------------------
-- 4.  What the four points are worth, and what they are not.
--
-- The detours read 14, 15, 16, 17 while the home costs read 10³ … 10⁶:
-- the chart column gains 1 per decade, the home column a factor of ten.
-- That is the exponent — and it is §1 that proves it, at every length,
-- in every base b ≥ 2, for every canonical word.  Four points cannot
-- establish an exponent, and are not asked to here; `TransportDivWitness`
-- had one point and therefore had no exponent at all, which is the defect
-- this module removes.
--
-- SHARPNESS.  `canonical-speedup` demands 4 + (2c + c′) ≤ length w, which
-- at c = c′ = 3 is 13 digits after the leading one, while the instances
-- win at 3.  The gap is the price of a threshold uniform in the base:
-- `lin<pow` uses b ≥ 2 and nothing else, so it proves the binary
-- statement and applies it everywhere.  Nothing here fits a base-ten
-- threshold, because (S1) already accepts whatever numeric gap a given
-- base supplies and the kernel checks it — a fitted threshold would be
-- strictly worse than either.
--
-- WHAT IS NOT CLAIMED.  That the chart is optimal; that 3 is the right
-- price for an edge; that `value` is the cheapest home algorithm.  Edge
-- costs stay parameters and the theorems are quantified over them, which
-- is the whole discipline of `CostGeometry`: the maps are the
-- mathematics, the weights are the physics, and they are separate fields
-- because a path does not determine a cost.
--
-- COST OF CHECKING.  Nothing here was too expensive for the kernel.  All
-- of §3 — including value e6 ≡ 10⁶ and value e13 ≡ 10¹³ by `refl` —
-- checks in about three seconds, because `Cubical.Data.Nat` is
-- `Agda.Builtin.Nat` and its `+` and `·` are GMP-backed on closed
-- literals; the numerals are never walked in unary.  One practical
-- caveat, recorded because it cost an hour: the numeric gaps of §3d must
-- be NAMED definitions.  Inlining `(9984 , refl)` as an argument to
-- `speedup-from-gap` sends the elaborator down a path that normalises
-- the ≤-witness arithmetic symbolically and exhausts a 3 GB heap by
-- 10⁴ — a fact about Agda's constraint solver, not about the
-- mathematics, and one that the named form avoids entirely.
------------------------------------------------------------------------
