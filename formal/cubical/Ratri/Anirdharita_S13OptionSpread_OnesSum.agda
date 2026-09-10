{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनिर्धारित — the sum field does NOT determine the state, and the host
-- module knew: its own header exhibits caches {1,2,4,5} and {1,2,3,6}
-- with one scalar summary.  The probe's open obligation "ones ⇄ sum"
-- (notes/SADHYA_OPEN_OBLIGATIONS.md, rung ५, blocked on induction on
-- List) was never going to close as a green: ones (sum w) ≡ w is FALSE,
-- and the honest landing is road two, the separating pair.  Discharged
-- by hand, smallest witnesses: [2] and [1,1] share the fibre of sum at
-- 2, and ones routes the summary to [1,1], missing [2] forever.
--
-- This closes the Swarm.S13OptionSpread : ones ⇄ sum row of the queue
-- as दोषलेख — written defect, not defeat: the fibre of sum IS the
-- module's subject (its §3), and this term pins the smallest instance.
------------------------------------------------------------------------

module Ratri.Anirdharita_S13OptionSpread_OnesSum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Swarm.S13OptionSpread using (sum; ones)

-- The two inhabitants of one fibre of the summary.
state₁ state₂ : List ℕ
state₁ = 2 ∷ []
state₂ = 1 ∷ 1 ∷ []

sameSummary : sum state₁ ≡ sum state₂
sameSummary = refl

-- ones reconstructs the second from the shared summary …
onesLands : ones (sum state₁) ≡ state₂
onesLands = refl

-- … and the two states are distinct: heads 2 ≢ 1.
head≢ : (2 ∷ []) ≡ (1 ∷ (1 ∷ [])) → ⊥
head≢ p = snotz (injSuc (cong headOr0 p))
  where
  headOr0 : List ℕ → ℕ
  headOr0 []      = 0
  headOr0 (a ∷ _) = a

-- THE VERDICT.  Green here means the field is NOT determined:
-- ones ∘ sum is not the identity, witnessed at the smallest fibre.
NOT-DETERMINED : ones (sum state₁) ≡ state₁ → ⊥
NOT-DETERMINED p = head≢ (sym p)
