{-# OPTIONS --cubical --safe #-}
-- àààµà¾à¦à â” a conversation.
-- The batch gate refuses (+ x y) â‰¡ (+ y x) because
-- its step shapes cannot reach it; here the same claim is put to the kernel
-- hole by hole.
module Samvada_TheFirstConversationWithTheWarmKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat

comm : (x y : â„•) â†’ x + y â‰¡ y + x
comm zero    y = sym (+-zero y)
comm (suc x) y = cong suc (comm x y) âˆ™ sym (+-suc y x)
