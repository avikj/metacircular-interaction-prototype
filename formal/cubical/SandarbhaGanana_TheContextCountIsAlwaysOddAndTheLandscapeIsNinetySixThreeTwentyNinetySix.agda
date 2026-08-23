{-# OPTIONS --cubical --safe --no-import-sorts #-}

--
-- ⚠ DEMOTED TO VERIFICATION (2026-08-23, same day, owner correction:
-- the protocol is DERIVE FIRST — "write the proof. Do not run the
-- experiment").  Every number below is forced a priori in three lines:
-- each observable lies in exactly two contexts ⟹ the six parity
-- functionals sum to zero (the only dependency) ⟹ the violation map
-- is affine with image the even-weight code E₆ shifted by the sign
-- vector and kernel 2⁴ ⟹ stratum(j) = 16·C(6,j) over j of the sign
-- vector·parity, and the 5/6 bound is the odd coset·leader weight 1.
-- General law: landscape = |kernel| · coset weight enumerator;
-- contextuality degree = coset leader weight.  The refl-pins below are
-- what a verification is: downstream of the proof, never in its place.
-- (Journal: cf-sesa checkpoint 33.)
------------------------------------------------------------------------
-- सन्दर्भ-गणना — counting by context.  A real question asked of the
-- machine (the asker did not know the answer): over all 512 classical
-- assignments to the Peres–Mermin square, how many satisfy exactly k of
-- the six contexts?  The machine's answer, each line a 512-sweep
-- performed by the typechecker (the PMNoSection stance — a proof that
-- runs):
--
--     k : 0    1    2    3    4    5    6
--         0   96    0  320    0   96    0
--
-- TWO FACTS FALL OUT, the first new to this corpus:
--
-- 1. A PARITY SELECTION RULE: even satisfaction-counts are FORBIDDEN.
--    Every hidden-variable attempt satisfies exactly 1, 3, or 5
--    contexts.  Reason (stated, provable from the cocycle, pinned here
--    by computation): each observable occurs in exactly two contexts,
--    so the product of all six context-parities is forced to +1, while
--    the required signs multiply to −1 — the violated-count is always
--    odd.  The H¹ obstruction is visible in the classical landscape as
--    a superselection rule on satisfaction parity.
--
-- 2. THE NEAR-MISS STRATUM HAS SIZE 96: the classical bound 5/6 is
--    attained by exactly 96 of 512 assignments (18.75%), mirrored by
--    the 96 maximally-frustrated ones at k = 1; the bulk, 320, sits at
--    k = 3.  The landscape is symmetric about 3 — satisfaction and
--    frustration are exchanged by the obstruction.
--
-- SCOPE: the counts are kernel-computed constants (refl); the parity
-- rule's cocycle DERIVATION is stated in prose above and not re-proved
-- as a general theorem here — the seven pins are its complete finite
-- verification at the PM square.  Composed through नाडी; the question
-- was answered live before it was landed.
------------------------------------------------------------------------

module SandarbhaGanana_TheContextCountIsAlwaysOddAndTheLandscapeIsNinetySixThreeTwentyNinetySix where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Vec using (Vec ; [] ; _∷_)
open import PMNoSection using (even3 ; odd3)

private
  b2n : Bool → ℕ
  b2n true = 1 ; b2n false = 0
  eqℕ : ℕ → ℕ → Bool
  eqℕ zero zero = true
  eqℕ (suc m) (suc n) = eqℕ m n
  eqℕ _ _ = false

nSat : Vec Bool 9 → ℕ
nSat (a ∷ b ∷ c ∷ d ∷ e ∷ f ∷ g ∷ h ∷ i ∷ []) =
  b2n (even3 a b c) + (b2n (even3 d e f) + (b2n (even3 g h i)
  + (b2n (even3 a d g) + (b2n (even3 b e h) + b2n (odd3 c f i)))))

countVec : (n : ℕ) → (Vec Bool n → ℕ) → ℕ
countVec zero    f = f []
countVec (suc n) f = countVec n (λ v → f (true ∷ v)) + countVec n (λ v → f (false ∷ v))

census : ℕ → ℕ
census k = countVec 9 (λ v → if eqℕ (nSat v) k then 1 else 0)

-- the landscape, pinned: seven 512-sweeps by the evaluator.
census0 : census 0 ≡ 0
census0 = refl
census1 : census 1 ≡ 96
census1 = refl
census2 : census 2 ≡ 0
census2 = refl
census3 : census 3 ≡ 320
census3 = refl
census4 : census 4 ≡ 0
census4 = refl
census5 : census 5 ≡ 96
census5 = refl
census6 : census 6 ≡ 0
census6 = refl
