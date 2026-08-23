{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नियन्त्रण-गणना — the control censuses, and the complete law they force.
--
-- SandarbhaGanana measured the Peres–Mermin landscape (96/320/96 on odd
-- satisfied-counts, evens forbidden) and conjectured the parity rule
-- from the cocycle.  THE CONTROL EXPERIMENT, run through नाडी before
-- landing: flip the sign vector to CONSISTENT (all-even, and two-odd —
-- both with required-sign product +1) and re-census.  The machine's
-- answers, pinned below by 512-sweeps:
--
--     consistent (both controls, identical):  k: 6   5   4   3   2   1   0
--                                                16   0 240   0 240   0  16
--     inconsistent (SandarbhaGanana):              0  96   0 320   0  96   0
--
-- THE COMPLETE LAW, visible once the controls exist: every count is
-- 16 · C(6,v) over the allowed violation-sizes v.  Consistent:
-- 16·(1,15,15,1) at v = 0,2,4,6.  Inconsistent: 16·(6,20,6) at
-- v = 1,3,5.  REASON (stated; the pins are its finite verification):
-- the assignment ↦ violation-pattern map is AFFINE over 𝔽₂ — nine
-- unknowns, six constraints, one dependency (each observable lies in
-- exactly two contexts, so the six context-parities always multiply to
-- +1) — hence rank 5, every fibre of size 2⁴ = 16, and the image is
-- EXACTLY the coset of the 5-dimensional image subspace selected by the
-- obstruction class: the trivial coset for consistent signs, the
-- nontrivial one for the PM square.  The classical landscape IS the H¹
-- coset, binomially profiled, 16-to-1.
--
-- So the obstruction's full classical price: the 16 global sections of
-- any consistent square redistribute, under the odd class, into 96
-- near-misses at 5/6 — nothing is lost, everything is displaced one
-- violation.  (The same shape as StaraArpana one lane over: the
-- obstruction never destroys; it displaces by one stratum.)
--
-- SCOPE: the affine-fibration derivation is prose here; the seven pins
-- of SandarbhaGanana plus the twelve below are its complete finite
-- verification at the PM square.  The general theorem (any F₂ context
-- hypergraph: landscape = kernel-size · binomial profile of the
-- obstruction coset) is stated as the reading and owed as a term.
------------------------------------------------------------------------

module NiyantranaGanana_TheLandscapeIsTheCosetOfTheObstructionSixteenToOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Vec using (Vec ; [] ; _∷_)
open import PMNoSection using (even3 ; odd3)
open import SandarbhaGanana_TheContextCountIsAlwaysOddAndTheLandscapeIsNinetySixThreeTwentyNinetySix
  using (countVec)

private
  b2n : Bool → ℕ
  b2n true = 1 ; b2n false = 0
  eqℕ : ℕ → ℕ → Bool
  eqℕ zero zero = true
  eqℕ (suc m) (suc n) = eqℕ m n
  eqℕ _ _ = false

-- the all-even (consistent) square, and a two-odd (still consistent) one.
nSatE nSat2 : Vec Bool 9 → ℕ
nSatE (a ∷ b ∷ c ∷ d ∷ e ∷ f ∷ g ∷ h ∷ i ∷ []) =
  b2n (even3 a b c) + (b2n (even3 d e f) + (b2n (even3 g h i)
  + (b2n (even3 a d g) + (b2n (even3 b e h) + b2n (even3 c f i)))))
nSat2 (a ∷ b ∷ c ∷ d ∷ e ∷ f ∷ g ∷ h ∷ i ∷ []) =
  b2n (even3 a b c) + (b2n (even3 d e f) + (b2n (odd3 g h i)
  + (b2n (even3 a d g) + (b2n (even3 b e h) + b2n (odd3 c f i)))))

censusE census2 : ℕ → ℕ
censusE k = countVec 9 (λ v → if eqℕ (nSatE v) k then 1 else 0)
census2 k = countVec 9 (λ v → if eqℕ (nSat2 v) k then 1 else 0)

-- the consistent landscape: 16·(1,15,15,1) on even counts, odds zero.
cE6 : censusE 6 ≡ 16
cE6 = refl
cE5 : censusE 5 ≡ 0
cE5 = refl
cE4 : censusE 4 ≡ 240
cE4 = refl
cE3 : censusE 3 ≡ 0
cE3 = refl
cE2 : censusE 2 ≡ 240
cE2 = refl
cE1 : censusE 1 ≡ 0
cE1 = refl
cE0 : censusE 0 ≡ 16
cE0 = refl

-- the two-odd consistent square: the SAME landscape — the law depends
-- only on the obstruction class, not on the representative sign vector.
c26 : census2 6 ≡ 16
c26 = refl
c24 : census2 4 ≡ 240
c24 = refl
c22 : census2 2 ≡ 240
c22 = refl
c20 : census2 0 ≡ 16
c20 = refl
c25 : census2 5 ≡ 0
c25 = refl
