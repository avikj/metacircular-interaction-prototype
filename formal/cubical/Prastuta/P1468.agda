{-# OPTIONS --cubical --safe #-}
-- uttered by the checked proposer: the sides share a normal form
-- (nf, PrastavaHrdaya), so the proof is two applications of the
-- kernel-judged nf-sound (PrastavaSatya) around a definitional middle.
module Prastuta.P1468 where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem
open import PrastavaSatya_TheClassifiersACClaimIsJudgedByTheKernel
  using (eval ; nf-sound ; _∸'_ ; le ; max' ; gcd')

prastava : (a b c : ℕ) → ((a + (b · c)) + (b · zero)) ≡ (a + (b · (c + zero)))
prastava a b c =
  sym (nf-sound env (Bin plus (Bin plus (V 0) (Bin times (V 1) (V 2))) (Bin times (V 1) Z))) ∙ nf-sound env (Bin plus (V 0) (Bin times (V 1) (Bin plus (V 2) Z)))
  where
  env : ℕ → ℕ
  env 0 = a
  env 1 = b
  env 2 = c
  env _ = zero
