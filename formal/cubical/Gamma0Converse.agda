{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Gamma0Converse
--
-- The other half of R0033, constructively: if ANY integral K
-- stabilizes (H·D·K ≡ D, D = diag(d₁, q·d₁), d₁ ≠ 0, det H = ε,
-- ε² = 1), then q divides the lower-left entry c of H — and the
-- witness is EXTRACTED from the stabilizer:  k = -ε·K₂₁.
--
-- With Gamma0Partner (witness → partner) this closes the iff over all
-- of ℤ: membership in Γ₀(q) is exactly two-sided stabilization, and
-- both directions are programs — one builds the partner from the
-- witness, the other reads the witness off the partner.  The proof
-- eliminates K₁₁ between the two first-column entries of H·D·K ≡ D,
-- then cancels d₁ by integrality (isIntegralℤ) — the only
-- non-equational step, and it is exactly the d₁ ≠ 0 hypothesis.
--
-- Python finite shadow: gamma0-stabilizer in machinery/core_knowledge.
--
-- POINTER (genius-15, 2026-08-14, not a fix — see Gamma0ConverseSharp):
-- the hypothesis `hε : ε · ε ≡ 1r` below is never used in this proof
-- term, so this theorem holds over all of M₂(ℤ);  and for q ≠ 0 it is
-- derivable from `hstab` (Gamma0ConverseSharp.Derived.epsSquare), so it
-- is redundant rather than merely inert.  It is strictly restrictive
-- only at q = 0, where a concrete non-unimodular stabilizer exists
-- (Gamma0ConverseSharp.q0).  Nothing here is edited.
------------------------------------------------------------------------

module Gamma0Converse where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Int using (isIntegralℤ)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)

open CommRingStr (ℤCommRing .snd)

-- solver lemmas: pure polynomial regroupings over ℤ ------------------

regA : (a b c e d1 q k11 k21 : R)
     → c · ((a · d1 + b · 0r) · k11 + (a · 0r + b · (q · d1)) · k21)
       - a · ((c · d1 + e · 0r) · k11 + (c · 0r + e · (q · d1)) · k21)
       ≡ (b · c - a · e) · ((q · d1) · k21)
regA _ _ _ _ _ _ _ _ = solve! ℤCommRing

regB : (a c d1 : R) → c · d1 - a · 0r ≡ c · d1
regB _ _ _ = solve! ℤCommRing

regNeg : (a b c e : R) → b · c - a · e ≡ - (a · e - b · c)
regNeg _ _ _ _ = solve! ℤCommRing

regZ : (c d1 q ε k21 : R)
     → d1 · (c - (- (ε · k21)) · q)
       ≡ c · d1 - (- ε) · ((q · d1) · k21)
regZ _ _ _ _ _ = solve! ℤCommRing

cancelSelf : (x : R) → x - x ≡ 0r
cancelSelf _ = solve! ℤCommRing

regF : (c kq : R) → c ≡ (c - kq) + kq
regF _ _ = solve! ℤCommRing

zeroL : (x : R) → 0r + x ≡ x
zeroL _ = solve! ℤCommRing

-- the theorem ---------------------------------------------------------

module _ (a b c e d1 q ε : R)
         (k11 k12 k21 k22 : R)
         (d1n : (d1 ≡ 0r) → ⊥)
         (hdet : a · e - b · c ≡ ε)
         (hε : ε · ε ≡ 1r)
         (hstab : mul (mul (a , b , c , e) (dia d1 (q · d1)))
                      (k11 , k12 , k21 , k22)
                  ≡ dia d1 (q · d1)) where

  -- first-column entries of the stabilization, projected
  e11 : (a · d1 + b · 0r) · k11 + (a · 0r + b · (q · d1)) · k21 ≡ d1
  e11 i = fst (hstab i)

  e21 : (c · d1 + e · 0r) · k11 + (c · 0r + e · (q · d1)) · k21 ≡ 0r
  e21 i = fst (snd (snd (hstab i)))

  -- eliminate k11 between the two equations
  chain : (b · c - a · e) · ((q · d1) · k21) ≡ c · d1
  chain = sym (regA a b c e d1 q k11 k21)
          ∙ cong₂ (λ x y → c · x - a · y) e11 e21
          ∙ regB a c d1

  factor : (b · c - a · e) ≡ - ε
  factor = regNeg a b c e ∙ cong (λ x → - x) hdet

  main : (- ε) · ((q · d1) · k21) ≡ c · d1
  main = cong (_· ((q · d1) · k21)) (sym factor) ∙ chain

  -- d₁ · (c - k·q) ≡ 0 with k the extracted witness
  zeroprod : d1 · (c - (- (ε · k21)) · q) ≡ 0r
  zeroprod = regZ c d1 q ε k21
             ∙ cong (λ x → c · d1 - x) main
             ∙ cancelSelf (c · d1)

  -- cancel d₁: the one non-equational step, integrality of ℤ
  diff0 : c - (- (ε · k21)) · q ≡ 0r
  diff0 = isIntegralℤ d1 (c - (- (ε · k21)) · q) zeroprod d1n

  -- q | c, with its witness
  membership : Σ[ k ∈ R ] c ≡ k · q
  membership = - (ε · k21)
             , (regF c ((- (ε · k21)) · q)
                ∙ cong (_+ ((- (ε · k21)) · q)) diff0
                ∙ zeroL ((- (ε · k21)) · q))
