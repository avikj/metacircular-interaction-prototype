{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TransportDivWitness
--
-- The frontier, with numbers in it.  Base ten, the word 1000, and the
-- two presentations of one divisibility test:
--
--   HOME   walk the value            work = 1000
--   CHART  run the residue automaton work = steps w = 5
--
-- The chart is not free: charting and uncharting are given cost 3 each,
-- so the detour is (3+3) + (3+5) = 14.  It still wins by two orders of
-- magnitude, and `Residual.respond` returns the third branch — the one
-- no equivalence-invariant response can see, since both edges here are
-- the identity on values and differ only in weight.
--
-- Everything below is computed by the kernel; no numeral is asserted.
------------------------------------------------------------------------

module TransportDivWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Fin using (Fin ; fzero ; fone)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Maybe using (just)
open import Cubical.Data.Sigma

open import Digits 8
open import TransportDiv 8
open import CostGeometry
open import Residual

-- base ten
base-is-ten : b ≡ 10
base-is-ten = refl

-- little-endian 0,0,0,1
thousand : Word
thousand = fzero ∷ fzero ∷ fzero ∷ fone ∷ []

value-thousand : value thousand ≡ 1000
value-thousand = refl

steps-thousand : steps thousand ≡ 5
steps-thousand = refl

------------------------------------------------------------------------
-- The two presentations and the round trip between them
------------------------------------------------------------------------

unaryP : Presentation
unaryP = pres ℕ _+_

chartP : Presentation
chartP = pres Word (λ u v → u)

chart : Edge unaryP chartP
chart = edge digits 3

unchart : Edge chartP unaryP
unchart = edge value 3

bridge : Bridge unaryP chartP
bridge = chart , unchart

------------------------------------------------------------------------
-- The residual is nonzero and the branch is ↝
------------------------------------------------------------------------

detour-cost : detour chart unchart 5 ≡ 14
detour-cost = refl

residual-thousand : ϱ bridge 1000 5 ≡ 986
residual-thousand = refl

horner-speedup : Speedup chart unchart 1000 5
horner-speedup = 985 , refl

horner-branch : respond (just bridge) 1000 5 ≡ ↝
horner-branch = refl

-- and therefore the chart presentation is strictly the better one
chart-is-better : 5 < 1000
chart-is-better =
  ↝-forces-better-presentation bridge 1000 5 horner-branch

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.

-- here because this file is where the numbers live.
--
-- Two corrections to what the numbers above support:
--
--  (i)  The packet built on this witness claimed the comparison "survives
--       any charting price below 497".  It does not: at 496 the detour is
--       exactly 1000 and the branch is flat, so 495 is the true bound.
--       An off-by-one in the one file whose boast is that no numeral is
--       asserted.
--
--  (ii) More seriously, the weights 3 and 3 are STIPULATED, and charting
--       is not free: `digits m` iterates the odometer m times, so the
--       honest price of the chart edge is Θ(m) in the very quantity the
--       chart is supposed to make cheap.  Priced that way the conclusion
--       REVERSES -- the breaker checked it, and `↝` becomes `↻` on this
--       word.  `TransportDivScale`'s quantified threshold does not repair
--       this: `Edge.cost` is a scalar, so quantifying over the weights
--       quantifies over CONSTANT weights only, and the threshold
--       4 + (2c + c′) ≤ length w bounds the word by the weights rather
--       than the other way round.
--
-- What survives is the statement with the chart already built: given a
-- word, testing divisibility costs suc (length w) automaton steps against
-- a recursion of depth value w.  That is `WalkChartedLength`'s content and
-- it is real.  What does not survive is the claim that the ROUND TRIP
-- pays, which is what a cost geometry is supposed to be about.
