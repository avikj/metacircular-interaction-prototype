{-# OPTIONS --cubical --safe #-}
-- संवादः — a conversation.  Written live against the warm kernel (नाडी,
-- stdin mode) 2026-08-23: the batch gate refused (+ x y) ≡ (+ y x) because
-- its step shapes cannot reach it; here the same claim is put to the kernel
-- hole by hole, each proposal judged in the warm process.  The terms below
-- are the ones the kernel accepted in that conversation.
module Samvada_TheFirstConversationWithTheWarmKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat

comm : (x y : ℕ) → x + y ≡ y + x
comm zero    y = sym (+-zero y)
comm (suc x) y = cong suc (comm x y) ∙ sym (+-suc y x)
