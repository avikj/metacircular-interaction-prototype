{-# OPTIONS --cubical --safe #-}
-- uttered by the checked proposer: the sides share a normal form
-- (nf, PrastavaHrdaya), so the proof is two applications of the
-- kernel-judged nf-sound (PrastavaSatya) around a definitional middle.
module Prastuta.P1304 where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem
open import PrastavaSatya_TheClassifiersACClaimIsJudgedByTheKernel
  using (eval ; nf-sound ; _∸'_ ; le ; max' ; gcd')

prastava : (a b : ℕ) → ((a · zero) + (a · b)) ≡ (a · b)
prastava a b =
  sym (nf-sound env (Bin plus (Bin times (V 0) Z) (Bin times (V 0) (V 1)))) ∙ nf-sound env (Bin times (V 0) (V 1))
  where
  env : ℕ → ℕ
  env 0 = a
  env 1 = b
  env _ = zero
