{-# OPTIONS --cubical --safe --no-import-sorts #-}
module NaturalMachine.WFIScratch1 where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import NaturalMachine.CoprimeSplitting using (IsPrimePower)
open import NaturalMachine.WalkBridge using (next)
open import NaturalMachine.WalkFast
  using ( next-isPP ; next-> ; next-least
        ; decIsPrimePower ; acceptDec ; refuteDec ; noneIn )

P1m6 : (q : ℕ) → 6 < q → q < next 6 → ¬ IsPrimePower q
P1m6 = next-least 6 (suc-≤-suc zero-≤)
