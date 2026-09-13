{-# OPTIONS --cubical --safe #-}
-- uttered by the checked proposer: the sides share a normal form
-- (nf, PrastavaHrdaya), so the proof is two applications of the
-- kernel-judged nf-sound (PrastavaSatya) around a definitional middle.
module Prastuta.P1338 where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem
open import PrastavaSatya_TheClassifiersACClaimIsJudgedByTheKernel
  using (eval ; nf-sound ; _∸'_ ; le ; max' ; gcd')

prastava : (a : ℕ) → (a · ((zero + zero) + (zero + zero))) ≡ zero
prastava a =
  sym (nf-sound env (Bin times (V 0) (Bin plus (Bin plus Z Z) (Bin plus Z Z)))) ∙ nf-sound env Z
  where
  env : ℕ → ℕ
  env 0 = a
  env _ = zero
