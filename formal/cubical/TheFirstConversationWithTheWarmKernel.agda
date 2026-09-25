{-# OPTIONS --cubical --safe #-}
--  — a conversation.
-- The batch gate refuses (+ x y) ≡ (+ y x) because
-- its step shapes cannot reach it; here the same claim is put to the kernel
-- hole by hole.
module TheFirstConversationWithTheWarmKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat

comm : (x y : ℕ) → x + y ≡ y + x
comm zero    y = sym (+-zero y)
comm (suc x) y = cong suc (comm x y) ∙ sym (+-suc y x)
