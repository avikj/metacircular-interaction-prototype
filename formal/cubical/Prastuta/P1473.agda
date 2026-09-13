{-# OPTIONS --cubical --safe #-}
-- uttered by the checked proposer: the sides share a normal form
-- (nf, PrastavaHrdaya), so the proof is two applications of the
-- kernel-judged nf-sound (PrastavaSatya) around a definitional middle.
module Prastuta.P1473 where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem
open import PrastavaSatya_TheClassifiersACClaimIsJudgedByTheKernel
  using (eval ; nf-sound ; _∸'_ ; le ; max' ; gcd')

prastava : (a : ℕ) → ((a + zero) + (a + zero)) ≡ ((a + a) + (suc (suc (zero)) · zero))
prastava a =
  sym (nf-sound env (Bin plus (Bin plus (V 0) Z) (Bin plus (V 0) Z))) ∙ nf-sound env (Bin plus (Bin plus (V 0) (V 0)) (Bin times (S (S Z)) Z))
  where
  env : ℕ → ℕ
  env 0 = a
  env _ = zero
