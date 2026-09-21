{-# OPTIONS --cubical --guardedness --safe #-}
module Yojana where
-- योजन: valuations add over products.  vₚ(m·n) = vₚ(m) + vₚ(n),
-- read through the canonical factorizations, for every prime at once.

open import Prakriti
open import Vibhajana using (Prati; product; factor)
open import Ananyata using (countP; sameCount)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List; []; _∷_; _++_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary

pos· : (m n : ℕ) → 1 ≤ m → 1 ≤ n → 1 ≤ m · n
pos· m zero _ hn = Empty.rec (¬-<-zero hn)
pos· m (suc k) hm _ =
  ≤-trans hm (subst (m ≤_) (sym (·-suc m k)) ≤SumLeft)

productAppend : (l₁ l₂ : List Prati)
              → product (l₁ ++ l₂) ≡ product l₁ · product l₂
productAppend [] l₂ = sym (·-identityˡ (product l₂))
productAppend ((q , _) ∷ l₁) l₂ =
  cong (q ·_) (productAppend l₁ l₂) ∙ ·-assoc q (product l₁) (product l₂)

countAppend : (p : ℕ) (l₁ l₂ : List Prati)
            → countP p (l₁ ++ l₂) ≡ countP p l₁ + countP p l₂
countAppend p [] l₂ = refl
countAppend p ((q , _) ∷ l₁) l₂ with discreteℕ p q
... | yes _ = cong suc (countAppend p l₁ l₂)
... | no  _ = countAppend p l₁ l₂

-- ═══ the theorem ═══
vpAdd : (m n : ℕ) (hm : 1 ≤ m) (hn : 1 ≤ n) (p : ℕ) → IsPrime p
      → countP p (fst (factor (m · n) (pos· m n hm hn)))
      ≡ countP p (fst (factor m hm)) + countP p (fst (factor n hn))
vpAdd m n hm hn p prP =
  sameCount (fst (factor (m · n) (pos· m n hm hn)))
            (fst (factor m hm) ++ fst (factor n hn))
            (snd (factor (m · n) (pos· m n hm hn))
             ∙ sym (cong₂ _·_ (snd (factor m hm)) (snd (factor n hn)))
             ∙ sym (productAppend (fst (factor m hm)) (fst (factor n hn))))
            p prP
  ∙ countAppend p (fst (factor m hm)) (fst (factor n hn))
