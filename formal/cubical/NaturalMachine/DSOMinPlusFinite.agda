{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DSOMinPlusFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; min)
open import Cubical.Data.Nat.Properties using (+-comm ; +-assoc ; minComm)
open import NaturalMachine.DSOContinuationFullAbstract
  using (Cost ; fin ; ∞ ; _⊗_ ; minC ; min-∞-right)

-- An inductive finite index is used rather than assuming an enumeration axiom.
data Ix : ℕ → Type₀ where
  iz : {n : ℕ} → Ix (suc n)
  is : {n : ℕ} → Ix n → Ix (suc n)

foldMin : {n : ℕ} → (Ix n → Cost) → Cost
foldMin {zero} f = ∞
foldMin {suc n} f = minC (f iz) (foldMin (λ i → f (is i)))

min-assocℕ : (a b c : ℕ) → min a (min b c) ≡ min (min a b) c
min-assocℕ zero b c = refl
min-assocℕ (suc a) zero c = refl
min-assocℕ (suc a) (suc b) zero = refl
min-assocℕ (suc a) (suc b) (suc c) = cong suc (min-assocℕ a b c)

+-min-left : (a b c : ℕ) → a + min b c ≡ min (a + b) (a + c)
+-min-left zero b c = refl
+-min-left (suc a) b c = cong suc (+-min-left a b c)

+-min-right : (a b c : ℕ) → min a b + c ≡ min (a + c) (b + c)
+-min-right a b c =
  +-comm (min a b) c
  ∙ +-min-left c a b
  ∙ cong₂ min ( +-comm c a) (+-comm c b)

minC-comm : (a b : Cost) → minC a b ≡ minC b a
minC-comm (fin a) (fin b) = cong fin (minComm a b)
minC-comm (fin a) ∞ = refl
minC-comm ∞ (fin b) = refl
minC-comm ∞ ∞ = refl

minC-assoc : (a b c : Cost) → minC a (minC b c) ≡ minC (minC a b) c
minC-assoc (fin a) (fin b) (fin c) = cong fin (min-assocℕ a b c)
minC-assoc (fin a) (fin b) ∞ = refl
minC-assoc (fin a) ∞ c = refl
minC-assoc ∞ b c = refl

⊗-assoc : (a b c : Cost) → a ⊗ (b ⊗ c) ≡ (a ⊗ b) ⊗ c
⊗-assoc (fin a) (fin b) (fin c) = cong fin (+-assoc a b c)
⊗-assoc (fin a) (fin b) ∞ = refl
⊗-assoc (fin a) ∞ c = refl
⊗-assoc ∞ b c = refl

⊗-min-left : (a b c : Cost) → a ⊗ minC b c ≡ minC (a ⊗ b) (a ⊗ c)
⊗-min-left (fin a) (fin b) (fin c) = cong fin (+-min-left a b c)
⊗-min-left (fin a) (fin b) ∞ = refl
⊗-min-left (fin a) ∞ c = refl
⊗-min-left ∞ b c = refl

⊗-min-right : (a b c : Cost) → minC a b ⊗ c ≡ minC (a ⊗ c) (b ⊗ c)
⊗-min-right (fin a) (fin b) (fin c) = cong fin (+-min-right a b c)
⊗-min-right (fin a) (fin b) ∞ = refl
⊗-min-right (fin a) ∞ c = sym (min-∞-right (fin a ⊗ c))
⊗-min-right ∞ b c = refl

⊗-fold-left : {n : ℕ} (a : Cost) (f : Ix n → Cost)
  → a ⊗ foldMin f ≡ foldMin (λ i → a ⊗ f i)
⊗-fold-left {zero} (fin a) f = refl
⊗-fold-left {zero} ∞ f = refl
⊗-fold-left {suc n} a f =
  ⊗-min-left a (f iz) (foldMin (λ i → f (is i)))
  ∙ cong (minC (a ⊗ f iz)) (⊗-fold-left a (λ i → f (is i)))

⊗-fold-right : {n : ℕ} (f : Ix n → Cost) (a : Cost)
  → foldMin f ⊗ a ≡ foldMin (λ i → f i ⊗ a)
⊗-fold-right {zero} f a = refl
⊗-fold-right {suc n} f a =
  ⊗-min-right (f iz) (foldMin (λ i → f (is i))) a
  ∙ cong (minC (f iz ⊗ a)) (⊗-fold-right (λ i → f (is i)) a)

fold-cong : {n : ℕ} {f g : Ix n → Cost}
  → ((i : Ix n) → f i ≡ g i) → foldMin f ≡ foldMin g
fold-cong {zero} p = refl
fold-cong {suc n} p = cong₂ minC (p iz) (fold-cong (λ i → p (is i)))

fold-∞ : {n : ℕ} → foldMin {n} (λ _ → ∞) ≡ ∞
fold-∞ {zero} = refl
fold-∞ {suc n} = fold-∞ {n}

minC-medial : (a b c d : Cost)
  → minC (minC a b) (minC c d) ≡ minC (minC a c) (minC b d)
minC-medial a b c d =
  sym (minC-assoc a b (minC c d))
  ∙ cong (minC a) (minC-assoc b c d)
  ∙ cong (λ q → minC a (minC q d)) (minC-comm b c)
  ∙ cong (minC a) (sym (minC-assoc c b d))
  ∙ minC-assoc a c (minC b d)

fold-swap : {m n : ℕ} (f : Ix m → Ix n → Cost)
  → foldMin (λ i → foldMin (f i)) ≡ foldMin (λ j → foldMin (λ i → f i j))
fold-swap {zero} {n} f = sym fold-∞
fold-swap {suc m} {zero} f = fold-∞
fold-swap {suc m} {suc n} f =
  cong (minC (minC (f iz iz) (foldMin (λ j → f iz (is j)))))
       (fold-swap (λ i j → f (is i) j))
  ∙ minC-medial (f iz iz)
      (foldMin (λ j → f iz (is j)))
      (foldMin (λ i → f (is i) iz))
      (foldMin (λ j → foldMin (λ i → f (is i) (is j))))
  ∙ cong (minC (minC (f iz iz) (foldMin (λ i → f (is i) iz))))
       (sym (fold-swap (λ i j → f (is i) (is j))))

Matrix : ℕ → ℕ → Type₀
Matrix m n = Ix m → Ix n → Cost

Continuation : ℕ → Type₀
Continuation n = Ix n → Cost

bellman : {m n : ℕ} → Matrix m n → Continuation n → Continuation m
bellman R V x = foldMin (λ y → R x y ⊗ V y)

_⋆_ : {m n p : ℕ} → Matrix m n → Matrix n p → Matrix m p
(R ⋆ S) x z = foldMin (λ y → R x y ⊗ S y z)

bellman-compose : {m n p : ℕ} (R : Matrix m n) (S : Matrix n p)
  (V : Continuation p) → bellman (R ⋆ S) V ≡ bellman R (bellman S V)
bellman-compose R S V = funExt λ x →
  fold-cong (λ z → ⊗-fold-right (λ y → R x y ⊗ S y z) (V z))
  ∙ fold-swap (λ z y → (R x y ⊗ S y z) ⊗ V z)
  ∙ fold-cong (λ y → fold-cong (λ z → sym (⊗-assoc (R x y) (S y z) (V z))))
  ∙ fold-cong (λ y → sym (⊗-fold-left (R x y) (λ z → S y z ⊗ V z)))
