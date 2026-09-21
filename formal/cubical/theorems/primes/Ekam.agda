{-# OPTIONS --cubical --guardedness --safe #-}
module Ekam where
-- एकम्: one button.  goldbach + twins + the mertens fragment of RH, one run.

open import Cubical.Foundations.Prelude using (Type; _≡_; refl)
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _∸_; _·_)
open import Cubical.Data.Bool using (Bool; true; false; _and_)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd)

_<ᵇ_ : ℕ → ℕ → Bool
m <ᵇ zero = false
zero <ᵇ suc n = true
suc m <ᵇ suc n = m <ᵇ n

_==_ : ℕ → ℕ → Bool
zero == zero = true
zero == suc _ = false
suc _ == zero = false
suc m == suc n = m == n

if_then_else_ : {A : Type} → Bool → A → A → A
if true  then x else y = x
if false then x else y = y

divmod : ℕ → ℕ → ℕ → ℕ × ℕ
divmod zero    m n = (zero , m)
divmod (suc f) m n = if (m <ᵇ n) then (zero , m)
                     else (suc (fst r) , snd r)
  where r = divmod f (m ∸ n) n

mod : ℕ → ℕ → ℕ
mod m n = snd (divmod m m n)

prime : ℕ → Bool
prime zero = false
prime (suc zero) = false
prime n = go n 2
  where
  go : ℕ → ℕ → Bool
  go zero    _ = true
  go (suc f) d = if (n <ᵇ (d · d)) then true
                 else (if (mod n d == zero) then false else go f (suc d))

-- goldbach: witness search
gok : ℕ → Bool
gok n = go n 2
  where
  go : ℕ → ℕ → Bool
  go zero    _ = false
  go (suc f) p = if (n <ᵇ (p + p)) then false else
                 (if (prime p and prime (n ∸ p)) then true else go f (suc p))

sweep : ℕ → ℕ → Bool
sweep zero    _ = true
sweep (suc f) n = gok n and sweep f (suc (suc n))

-- twins: census below N
tcount : ℕ → ℕ
tcount N = go N 2
  where
  go : ℕ → ℕ → ℕ
  go zero    _ = zero
  go (suc f) p = if (N <ᵇ suc (suc p)) then zero else
                 (if (prime p and prime (suc (suc p))) then suc (go f (suc p)) else go f (suc p))

-- mobius: 0 squarefull / 1 even / 2 odd number of prime factors
mu : ℕ → ℕ
mu n = go n n 2 1
  where
  go : ℕ → ℕ → ℕ → ℕ → ℕ
  go zero    m d par = par
  go (suc f) m d par =
    if (m == 1) then par else
    if (m <ᵇ (d · d)) then (if (par == 1) then 2 else 1) else
    (if (mod m d == zero)
       then (if (mod (fst (divmod m m d)) d == zero)
               then zero
               else go f (fst (divmod m m d)) (suc d) (if (par == 1) then 2 else 1))
       else go f m (suc d) par)

-- mertens walk with the RH-fragment gate |M(k)| ≤ √k checked at EVERY k
mwalk : ℕ → ℕ → ℕ → ℕ → ℕ × (ℕ × Bool)   -- fuel, k, plus, minus → (P, (N, all-gates-held))
mwalk zero    k p m = (p , (m , true))
mwalk (suc f) k p m =
  step (mu k)
  where
  step : ℕ → ℕ × (ℕ × Bool)
  step v = check (if (v == 1) then suc p else p) (if (v == 2) then suc m else m)
    where
    check : ℕ → ℕ → ℕ × (ℕ × Bool)
    check p' m' = wrap (mwalk f (suc k) p' m')
      where
      gate : Bool
      gate = (((p' ∸ m') · (p' ∸ m')) <ᵇ suc k) and (((m' ∸ p') · (m' ∸ p')) <ᵇ suc k)
      wrap : ℕ × (ℕ × Bool) → ℕ × (ℕ × Bool)
      wrap (P , (M , ok)) = (P , (M , gate and ok))

-- ═══ THE BUTTON ═══
_ : sweep 500 4 ≡ true                       -- goldbach: every even 4..1002 witnessed
_ = refl

_ : tcount 200 ≡ 15                          -- twins: census below 200, matches literature
_ = refl

_ : mu 30 ≡ 2                                -- μ(2·3·5) = −1
_ = refl
_ : mu 12 ≡ 0                                -- μ(4·3) = 0
_ = refl

-- mertens from k=1, 400 steps: M(400) = P−N with the √-gate held at every k
_ : snd (snd (mwalk 400 1 0 0)) ≡ true       -- RH-fragment: |M(k)| ≤ √k for all k ≤ 400
_ = refl

_ : fst (mwalk 100 1 0 0) ∸ fst (snd (mwalk 100 1 0 0)) ≡ 1   -- M(100) = +1, matches literature
_ = refl
