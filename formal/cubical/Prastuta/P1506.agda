{-# OPTIONS --cubical --safe #-}
-- uttered by the checked proposer: the sides share a normal form
-- (nf, PrastavaHrdaya), so the proof is two applications of the
-- kernel-judged nf-sound (PrastavaSatya) around a definitional middle.
module Prastuta.P1506 where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem
open import PrastavaSatya_TheClassifiersACClaimIsJudgedByTheKernel
  using (eval ; nf-sound ; _∸'_ ; le ; max' ; gcd')

prastava : (a b : ℕ) → (b · ((a + zero) + (a + zero))) ≡ ((b · (a + a)) + ((b + b) · zero))
prastava a b =
  sym (nf-sound env (Bin times (V 1) (Bin plus (Bin plus (V 0) Z) (Bin plus (V 0) Z)))) ∙ nf-sound env (Bin plus (Bin times (V 1) (Bin plus (V 0) (V 0))) (Bin times (Bin plus (V 1) (V 1)) Z))
  where
  env : ℕ → ℕ
  env 0 = a
  env 1 = b
  env _ = zero
