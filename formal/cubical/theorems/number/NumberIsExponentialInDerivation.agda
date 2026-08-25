{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NumberIsExponentialInDerivation
--
-- `TheTrajectoryIsAChain` removed one class of answers to "where does the
-- walk's e^ψ(k) come from?" — it is not the width of the lattice, since
-- the walk never visits an incomparable pair.  This module supplies the
-- mechanism that is left, and supplies it without a single asymptotic.
--
-- ────────────────────────────────────────────────────────────────────
-- THE MECHANISM
--
-- The walk's state, honestly described, is a DERIVATION: the exponent
-- vector against the installed prime powers (`SumProductTorus`).  The
-- number is what `val` produces from it, and `val` EXPONENTIATES.  So at
-- every single coordinate:
--
--     suc≤^ :  suc e  ≤  b ^ e        for every base b ≥ 2
--
-- The exponent the walk actually needs to record is e.  The numeric
-- factor it records instead is b^e, which exceeds e.  Coordinatewise,
-- **the number is exponential in the derivation**, and this is a bound
-- with no ψ, no π, and no Chebyshev in it — an induction on e.
--
-- That is where the size goes.  Not the lattice's width; the encoding.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS IS THE SAME SENTENCE `SumProductTorus` ALREADY WROTE
--
-- That module says: "Factorisation is hard only for someone who threw the
-- derivation away and is trying to invert `val` from the outside."  This
-- one says the state SIZE is inflated by exactly the same act.  The walk
-- holds its derivation by construction — it installs its prime powers —
-- and then stores their product.  The product is not more informative
-- (`val` is injective on a prime basis); it is only bigger, and bigger by
-- an exponential at every coordinate.
--
-- Pāṇini's architecture, quoted in that module, is the same point: a form
-- is not stored, it is derived, and the derivation carries the context
-- that produced it.  The walk derives and then discards, and the discard
-- is the bill.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, AND IT IS THE INTERESTING HALF.
--
-- ψ(k) ≈ k is NOT proved here and is not used.  Turning
-- "coordinatewise exponential" into "ψ(k) versus its derivation's size"
-- requires summing over primes p ≤ k with exponents ⌊log_p k⌋, which is
-- Chebyshev's estimate and belongs to the analytic lane (`formal/
-- pairfield/`), not to this one.  CLAUDE.md's HOLOGRAM §7 lesson applies
-- directly: a constant measured at one scale hides its scaling, so the
-- comparison is stated at every coordinate and at no particular k.
--
-- Nor is it claimed that a derivation-stepping machine is realisable, or
-- that the walk could store exponents without changing what it computes.
-- The bound is on the encoding, and only on the encoding.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NumberIsExponentialInDerivation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _^_ ; +-zero ; +-suc)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-+-≤ ; ≤SumLeft)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (tt)

open import SumProductTorus using (Exp ; val ; primes4)

------------------------------------------------------------------------
-- 1.  Any base ≥ 2 raised to e is at least 1, and exceeds e
--
-- Bases are written `suc (suc b)` so that `b ^ suc e` reduces to a sum
-- with `b ^ e` as its head — the shape the two inductions need.
------------------------------------------------------------------------

1≤^ : (b e : ℕ) → 1 ≤ (suc (suc b)) ^ e
1≤^ b zero    = ≤-refl
1≤^ b (suc e) = ≤-trans (1≤^ b e) ≤SumLeft

-- THE BOUND.  The numeric factor is strictly larger than the exponent it
-- encodes, at every coordinate, for every base ≥ 2.
suc≤^ : (b e : ℕ) → suc e ≤ (suc (suc b)) ^ e
suc≤^ b zero    = ≤-refl
suc≤^ b (suc e) = subst (_≤ ((suc (suc b)) ^ suc e)) shape
                        (≤-+-≤ (suc≤^ b e) tail)
  where
  tail : 1 ≤ ((suc (suc b)) ^ e) + (b · ((suc (suc b)) ^ e))
  tail = ≤-trans (1≤^ b e) ≤SumLeft

  shape : suc e + 1 ≡ suc (suc e)
  shape = +-suc (suc e) 0 ∙ cong suc (+-zero (suc e))

-- stated as strict inequality, which is what `_<_` unfolds to
exponent-is-dwarfed : (b e : ℕ) → e < (suc (suc b)) ^ e
exponent-is-dwarfed = suc≤^

------------------------------------------------------------------------
-- 2.  On the walk's own state.
--
-- cap 8 = 840 = 2³·3·5·7.  Its 2-coordinate is the number 3; the numeric
-- factor storing that 3 is 8.  Every coordinate is like this and the
-- ratio grows with the coordinate.
------------------------------------------------------------------------

cap8 : Exp primes4
cap8 = 3 , 1 , 1 , 1 , tt

cap8-is-840 : val primes4 cap8 ≡ 840
cap8-is-840 = refl

-- the exponent 3 costs the factor 2³ = 8
two-coordinate : 3 < 2 ^ 3
two-coordinate = exponent-is-dwarfed 0 3

-- and at exponent 10 the factor is already 1024
ten-coordinate : 10 < 2 ^ 10
ten-coordinate = exponent-is-dwarfed 0 10

------------------------------------------------------------------------
-- 3.  The sentence, with its boundary marked.
--
-- The walk's number is exponential in the walk's derivation, coordinate
-- by coordinate, provably and without asymptotics.  Whether that
-- coordinatewise fact sums to the ψ(k)-versus-log-k gap is a question
-- about ∑_{p ≤ k} ⌊log_p k⌋, i.e. about Chebyshev, and this module does
-- not touch it.
--
-- What it does settle: the class of answer.  The walk's size is an
-- ENCODING cost, not a lattice cost (`TheTrajectoryIsAChain`) and not an
-- overlap cost (`JoinSavesTheMeet` — overlap is a saving).  Three classes
-- eliminated, one identified, the magnitude still open.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  CORRECTION, same session — §3's table over-reaches.
--
-- §3 files the walk's size under "IDENTIFIED: the numeric encoding".
-- "Identified" says the encoding ACCOUNTS for the gap, and that does not
-- follow from a coordinatewise bound: it says nothing about how many
-- coordinates there are.
--
-- There are many.  `TheDerivationIsDenseToo` checks that
-- the walk's derivation is DENSE — cap(k) is divisible by every prime
-- p ≤ k, so there is a nonzero entry at each, support 4 out of 4 at
-- frontier 8.  The exponential saving `suc e ≤ b ^ e` is a saving WITHIN
-- a coordinate; density is a cost ACROSS them; and which dominates is a
-- question about ∑_{p≤k} versus π(k) that this file explicitly declines
-- to touch, two paragraphs above the table that assumed the answer.
--
-- §§1–2 are unaffected.  The word "IDENTIFIED" is withdrawn; that row is
-- OPEN, for the reason the boundary paragraph already gave.
------------------------------------------------------------------------
