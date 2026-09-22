{-# OPTIONS --cubical --guardedness --safe #-}
module Yantra.Kuttaka where

open import Cubical.Foundations.Prelude using (Type; _≡_; refl)
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _∸_; _·_)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Sigma using (Σ; _,_; fst; snd; _×_)

_<ᵇ_ : ℕ → ℕ → Bool
m <ᵇ zero = false
zero <ᵇ suc n = true
suc m <ᵇ suc n = m <ᵇ n

if_then_else_ : {A : Type} → Bool → A → A → A
if true  then x else y = x
if false then x else y = y

divmod : ℕ → ℕ → ℕ → ℕ × ℕ
divmod zero    m n = (zero , m)
divmod (suc f) m n = if (m <ᵇ n) then (zero , m)
                     else (suc (fst r) , snd r)
  where r = divmod f (m ∸ n) n

-- वल्ली: the creeper of quotients.  the remainder is KEPT and recursed on.
valli : ℕ → ℕ → ℕ → List ℕ
valli zero    _ _ = []
valli (suc f) a zero = []
valli (suc f) a b = fst qr ∷ valli f b (snd qr)
  where qr = divmod a a b

-- आरोहणम्: climb back up the creeper.  convergents hₙ = qₙhₙ₋₁+hₙ₋₂.
climb : List ℕ → (ℕ × ℕ) × (ℕ × ℕ)   -- ((h prev , k prev) , (h cur , k cur))
climb [] = ((zero , suc zero) , (suc zero , zero))
climb (q ∷ qs) = go q (climb qs)
  where
  go : ℕ → (ℕ × ℕ) × (ℕ × ℕ) → (ℕ × ℕ) × (ℕ × ℕ)
  go q ((hp , kp) , (hc , kc)) = ((hc , kc) , (q · hc + hp , q · kc + kp))

-- forward fold instead (left-to-right over the valli)
conv : List ℕ → (ℕ × ℕ) × (ℕ × ℕ)
conv = go ((zero , suc zero) , (suc zero , zero))
  where
  go : (ℕ × ℕ) × (ℕ × ℕ) → List ℕ → (ℕ × ℕ) × (ℕ × ℕ)
  go st [] = st
  go ((hpp , kpp) , (hp , kp)) (q ∷ qs) = go ((hp , kp) , (q · hp + hpp , q · kp + kpp)) qs

penult : List ℕ → ℕ × ℕ
penult qs = fst (conv qs)

-- THE RUN, sutra §17's own numbers: 137 and 60.
_ : valli 200 137 60 ≡ 2 ∷ 3 ∷ 1 ∷ 1 ∷ 8 ∷ []
_ = refl

_ : penult (valli 200 137 60) ≡ (16 , 7)     -- 16·60 − 7·137 = ±1
_ = refl

_ : 16 · 60 ∸ 7 · 137 ≡ 1                     -- the climb read the answer
_ = refl

-- 137·x ≡ 10 (mod 60): x = 50, checked by direct computation
_ : snd (divmod 7000 (137 · 50) 60) ≡ 10
_ = refl
