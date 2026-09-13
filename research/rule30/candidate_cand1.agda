{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module Candidate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Fin.Base using (Fin ; toℕ ; toℕ-injective)
open import Cubical.Data.Fin.Properties using (pigeonhole)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Empty as E using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

-- ---------------------------------------------------------------- the column of a rational
-- long division of a by (suc b) in base 2: the remainder after n doublings,
-- and the digit read at step n (whether the doubled remainder overflows).

śeṣa : (a b : ℕ) → ℕ → ℕ
śeṣa a b zero    = a mod (suc b)
śeṣa a b (suc n) = (2 · śeṣa a b n) mod (suc b)

dec→bool : {A : Type} → Dec A → Bool
dec→bool (yes _) = true
dec→bool (no _)  = false

aṅka : (a b : ℕ) → ℕ → Bool
aṅka a b n = dec→bool (≤Dec (suc b) (2 · śeṣa a b n))

-- ---------------------------------------------------------------- eventually periodic
EventuallyPeriodic : {A : Type} → (ℕ → A) → Type
EventuallyPeriodic s = Σ[ p ∈ ℕ ] Σ[ N ∈ ℕ ] (0 < p) × ((n : ℕ) → N ≤ n → s (n + p) ≡ s n)

-- ---------------------------------------------------------------- the theorem
-- the remainder is a state below suc b; a repeat of state propagates forever
śeṣa< : (a b n : ℕ) → śeṣa a b n < suc b
śeṣa< a b zero    = mod< b a
śeṣa< a b (suc n) = mod< b (2 · śeṣa a b n)

punar : (a b i j : ℕ) → śeṣa a b i ≡ śeṣa a b j → (k : ℕ) → śeṣa a b (i + k) ≡ śeṣa a b (j + k)
punar a b i j e zero    = subst2 (λ x y → śeṣa a b x ≡ śeṣa a b y) (sym (+-zero i)) (sym (+-zero j)) e
punar a b i j e (suc k) =
  subst2 (λ x y → śeṣa a b x ≡ śeṣa a b y) (sym (+-suc i k)) (sym (+-suc j k))
         (cong (λ r → (2 · r) mod (suc b)) (punar a b i j e k))

sthiti : (a b : ℕ) → Fin (suc (suc b)) → Fin (suc b)
sthiti a b (k , _) = śeṣa a b k , śeṣa< a b k

-- from a collision i ≠ j with equal state, an ordered pair i < j with equal state
krama : (a b : ℕ) (i j : Fin (suc (suc b))) → ¬ i ≡ j → sthiti a b i ≡ sthiti a b j
      → Σ[ u ∈ ℕ ] Σ[ v ∈ ℕ ] (u < v) × (śeṣa a b u ≡ śeṣa a b v)
krama a b (i , _) (j , _) ne e with i ≟ j
... | lt i<j = i , j , i<j , cong fst e
... | gt j<i = j , i , j<i , sym (cong fst e)
... | eq i≡j = E.rec (ne (toℕ-injective i≡j))

rational→periodic : (a b : ℕ) → EventuallyPeriodic (aṅka a b)
rational→periodic a b =
  let (i , j , ne , e) = pigeonhole ≤-refl (sthiti a b)
      (u , v , (d , du) , eu) = krama a b i j ne e
  in suc d , u , (d , +-suc d 0 ∙ cong suc (+-zero d)) , λ n (l , lu) →
       cong (λ r → dec→bool (≤Dec (suc b) (2 · r)))
            (subst2 (λ x y → śeṣa a b x ≡ śeṣa a b y)
                    (sym (cong (_+ l) du) ∙ sym (samīkaraṇa d u l) ∙ cong (_+ suc d) lu)
                    (+-comm u l ∙ lu)
                    (punar a b v u (sym eu) l))
  where
  -- (l + u) + suc d ≡ (d + suc u) + l
  samīkaraṇa : (d u l : ℕ) → (l + u) + suc d ≡ (d + suc u) + l
  samīkaraṇa d u l = solveℕ!
