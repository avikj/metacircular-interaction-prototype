{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DSOMinPlusFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; min)
open import Cubical.Data.Nat.Properties using (+-comm ; +-assoc ; minComm)
open import NaturalMachine.DSOContinuationFullAbstract
  using (Cost ; fin ; ∞ ; _⊗_ ; minC ; min-∞-right
        ; ⊗-zero-right ; ⊗-∞-right)

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

⊗-zero-left : (a : Cost) → fin zero ⊗ a ≡ a
⊗-zero-left (fin a) = refl
⊗-zero-left ∞ = refl

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

fold-min : {n : ℕ} (f g : Ix n → Cost)
  → foldMin (λ i → minC (f i) (g i)) ≡ minC (foldMin f) (foldMin g)
fold-min {zero} f g = refl
fold-min {suc n} f g =
  cong (minC (minC (f iz) (g iz))) (fold-min (λ i → f (is i)) (λ i → g (is i)))
  ∙ minC-medial (f iz) (g iz)
      (foldMin (λ i → f (is i))) (foldMin (λ i → g (is i)))

fold-swap : {m n : ℕ} (f : Ix m → Ix n → Cost)
  → foldMin (λ i → foldMin (f i)) ≡ foldMin (λ j → foldMin (λ i → f i j))
fold-swap {zero} {n} f = sym (fold-∞ {n})
fold-swap {suc m} {zero} f = fold-∞ {suc m}
fold-swap {suc m} {suc n} f =
  cong (minC (minC (f iz iz) (foldMin (λ j → f iz (is j)))))
       (fold-swap (λ i j → f (is i) j))
  ∙ minC-medial (f iz iz)
      (foldMin (λ j → f iz (is j)))
      (foldMin (λ i → f (is i) iz))
      (foldMin (λ j → foldMin (λ i → f (is i) (is j))))
  ∙ cong (minC (minC (f iz iz) (foldMin (λ i → f (is i) iz))))
       (sym (fold-min (λ j → f iz (is j))
                      (λ j → foldMin (λ i → f (is i) (is j)))))

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

⋆-assoc : {l m n p : ℕ} (R : Matrix l m) (S : Matrix m n) (T : Matrix n p)
  → (R ⋆ S) ⋆ T ≡ R ⋆ (S ⋆ T)
⋆-assoc R S T = funExt λ x → funExt λ w →
  cong (λ V → V x) (bellman-compose R S (λ z → T z w))

identity : {n : ℕ} → Matrix n n
identity {suc n} iz iz = fin zero
identity {suc n} iz (is j) = ∞
identity {suc n} (is i) iz = ∞
identity {suc n} (is i) (is j) = identity i j

fold-right-unit : {n : ℕ} (f : Ix n → Cost) (z : Ix n)
  → foldMin (λ y → f y ⊗ identity y z) ≡ f z
fold-right-unit {suc n} f iz =
  cong₂ minC (⊗-zero-right (f iz))
    (fold-cong (λ i → ⊗-∞-right (f (is i))) ∙ fold-∞ {n})
  ∙ min-∞-right (f iz)
fold-right-unit {suc n} f (is z) =
  cong (λ q → minC q (foldMin (λ i → f (is i) ⊗ identity i z)))
       (⊗-∞-right (f iz))
  ∙ fold-right-unit (λ i → f (is i)) z

fold-left-unit : {n : ℕ} (f : Ix n → Cost) (x : Ix n)
  → foldMin (λ y → identity x y ⊗ f y) ≡ f x
fold-left-unit {suc n} f iz =
  cong₂ minC (⊗-zero-left (f iz))
    (fold-cong {f = λ i → identity iz (is i) ⊗ f (is i)}
               {g = λ _ → ∞} (λ i → refl)
     ∙ fold-∞ {n})
  ∙ min-∞-right (f iz)
fold-left-unit {suc n} f (is x) = fold-left-unit (λ i → f (is i)) x

⋆-identity-right : {m n : ℕ} (R : Matrix m n) → R ⋆ identity ≡ R
⋆-identity-right R = funExt λ x → funExt λ z → fold-right-unit (R x) z

⋆-identity-left : {m n : ℕ} (R : Matrix m n) → identity ⋆ R ≡ R
⋆-identity-left R = funExt λ x → funExt λ z → fold-left-unit (λ y → R y z) x

-- Optimization witnesses remain a dependent fiber over the scalar Bellman
-- consequence.  Matrix equality never quotients these active derivations.
record Argmin {m n : ℕ} (R : Matrix m n) (V : Continuation n)
              (x : Ix m) : Type₀ where
  constructor active
  field
    witness : Ix n
    realizes : bellman R V x ≡ R x witness ⊗ V witness
