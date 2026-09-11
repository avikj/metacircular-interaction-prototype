{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module Candidate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; sucℤ ; predℤ ; sucPred)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; _or_ ; _⊕_ ; true≢false)
open import Cubical.Data.Empty as E using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- Jen (1986): from the single seed, no two adjacent columns of Rule 30
-- are both eventually periodic.  Two-sided evolution, positions in ℤ.
------------------------------------------------------------------------

r30 : Bool → Bool → Bool → Bool
r30 l c r = l ⊕ (c or r)

x : ℕ → ℤ → Bool
x zero    (pos zero)    = true
x zero    (pos (suc _)) = false
x zero    (negsuc _)    = false
x (suc t) i             = r30 (x t (predℤ i)) (x t i) (x t (sucℤ i))

Col : ℤ → ℕ → Bool
Col i t = x t i

Periodic : (ℕ → Bool) → ℕ → ℕ → Type
Periodic s N P = (t : ℕ) → N ≤ t → s (t + P) ≡ s t

-- §1  the light cone: at time t everything left of −t is 0, and the cell at −(t+1) at time t+1 is 1
cone : (t k : ℕ) → x t (negsuc (t + k)) ≡ false
cone zero    k = refl
cone (suc t) k =
  cong₃ r30 (cong (x t) (cong negsuc (cong suc (sym (+-suc t k)) ∙ sym (+-suc t (suc k)))) ∙ cone t (suc (suc k)))
            (cong (x t) (cong negsuc (sym (+-suc t k))) ∙ cone t (suc k))
            (cone t k)

edge : (t : ℕ) → x (suc t) (negsuc t) ≡ true
edge zero    = refl
edge (suc t) =
  cong₂ (λ l c → r30 l c (x (suc t) (negsuc t)))
        (cong (x (suc t)) (cong negsuc (cong suc (sym (+-comm t 1)))) ∙ cone (suc t) 1)
        (cong (x (suc t)) (cong negsuc (sym (+-zero (suc t)))) ∙ cone (suc t) 0)
  ∙ cong (r30 false false) (edge t)

-- §2  left-permutivity inverted: two periodic columns force the one to their left
⊕-inv : (l m : Bool) → (l ⊕ m) ⊕ m ≡ l
⊕-inv true  true  = refl
⊕-inv true  false = refl
⊕-inv false true  = refl
⊕-inv false false = refl

-- the left cell is recovered from the next row and the two cells to its right
recover : (t : ℕ) (i : ℤ) → x t (predℤ i) ≡ x (suc t) i ⊕ (x t i or x t (sucℤ i))
recover t i = sym (⊕-inv (x t (predℤ i)) (x t i or x t (sucℤ i)))

PerPair : ℤ → ℕ → ℕ → Type
PerPair i N P = Periodic (Col i) N P × Periodic (Col (sucℤ i)) N P

left : (i : ℤ) (N P : ℕ) → PerPair i N P → Periodic (Col (predℤ i)) N P
left i N P (pi , psi) t N≤t =
  recover (t + P) i
  ∙ cong₂ (λ a b → a ⊕ b) (pi (suc t) (≤-suc N≤t)) (cong₂ _or_ (pi t N≤t) (psi t N≤t))
  ∙ sym (recover t i)

predⁿ : ℕ → ℤ → ℤ
predⁿ zero    i = i
predⁿ (suc k) i = predⁿ k (predℤ i)

down : (i : ℤ) (N P : ℕ) → PerPair i N P → (k : ℕ) → PerPair (predⁿ k i) N P
down i N P pp zero    = pp
down i N P pp (suc k) =
  down (predℤ i) N P (left i N P pp , subst (λ j → Periodic (Col j) N P) (sym (sucPred i)) (fst pp)) k

-- §3  where the descent lands
predⁿ-neg : (k q : ℕ) → predⁿ k (negsuc q) ≡ negsuc (q + k)
predⁿ-neg zero    q = cong negsuc (sym (+-zero q))
predⁿ-neg (suc k) q = predⁿ-neg k (suc q) ∙ cong negsuc (sym (+-suc q k))

predⁿ-pos : (n m : ℕ) → predⁿ (suc (n + m)) (pos n) ≡ negsuc m
predⁿ-pos zero    m = predⁿ-neg m zero
predⁿ-pos (suc n) m = predⁿ-pos n m

-- §4  the contradiction: a column left of the light cone that is periodic
--     from N with period suc P′ is 0 at time N′ and 1 at time N′ + suc P′
clash : (q N′ P′ : ℕ) → N′ + P′ ≡ q → Periodic (Col (negsuc q)) N′ (suc P′) → ⊥
clash q N′ P′ e per = true≢false (sym eka ∙ per N′ ≤-refl ∙ śūnya)
  where
  eka : x (N′ + suc P′) (negsuc q) ≡ true
  eka = cong (λ t → x t (negsuc q)) (+-suc N′ P′ ∙ cong suc e) ∙ edge q
  śūnya : x N′ (negsuc q) ≡ false
  śūnya = cong (x N′) (cong negsuc (sym e)) ∙ cone N′ P′

jen : (i : ℤ) (N P′ : ℕ) → PerPair i N (suc P′) → ⊥
jen (pos n) N P′ pp =
  clash (N + P′) N P′ refl
        (subst (λ j → Periodic (Col j) N (suc P′)) (predⁿ-pos n (N + P′))
               (fst (down (pos n) N (suc P′) pp (suc (n + (N + P′))))))
jen (negsuc n) N P′ pp =
  clash (suc n + (N + P′)) (suc n + N) P′ (sym (+-assoc (suc n) N P′))
        (λ t N′≤t → per t (≤-trans (suc n , refl) N′≤t))
  where
  per : Periodic (Col (negsuc (suc n + (N + P′)))) N (suc P′)
  per = subst (λ j → Periodic (Col j) N (suc P′)) (predⁿ-neg (suc (N + P′)) n ∙ cong negsuc (+-suc n (N + P′)))
              (fst (down (negsuc n) N (suc P′) pp (suc (N + P′))))

-- §5  any two periodicities of adjacent columns align to a common one
per-mono : (s : ℕ → Bool) (N N′ P : ℕ) → N ≤ N′ → Periodic s N P → Periodic s N′ P
per-mono s N N′ P N≤ per t N′≤t = per t (≤-trans N≤ N′≤t)

per-mult : (s : ℕ → Bool) (N P : ℕ) → Periodic s N P → (k : ℕ) → Periodic s N (k · P)
per-mult s N P per zero    t N≤t = cong s (+-zero t)
per-mult s N P per (suc k) t N≤t =
  cong s (+-assoc t P (k · P) ∙ cong (_+ k · P) (+-comm t P) ∙ sym (+-assoc P t (k · P)) ∙ +-comm P (t + k · P))
  ∙ per (t + k · P) (≤-trans N≤t (k · P , +-comm (k · P) t))
  ∙ per-mult s N P per k t N≤t

adjacent : (i : ℤ) (N₁ a N₂ b : ℕ)
         → Periodic (Col i) N₁ (suc a) → Periodic (Col (sucℤ i)) N₂ (suc b) → ⊥
adjacent i N₁ a N₂ b p₁ p₂ =
  jen i (N₁ + N₂) (b + a · suc b)
      ( per-mono (Col i) N₁ (N₁ + N₂) _ (N₂ , +-comm N₂ N₁)
                 (subst (Periodic (Col i) N₁) (·-comm (suc b) (suc a)) (per-mult (Col i) N₁ (suc a) p₁ (suc b)))
      , per-mono (Col (sucℤ i)) N₂ (N₁ + N₂) _ (N₁ , refl)
                 (per-mult (Col (sucℤ i)) N₂ (suc b) p₂ (suc a)) )

-- the centre column and either neighbour are never both eventually periodic
centre-right : (N₁ a N₂ b : ℕ) → Periodic (Col (pos 0)) N₁ (suc a) → Periodic (Col (pos 1)) N₂ (suc b) → ⊥
centre-right = adjacent (pos 0)

centre-left : (N₁ a N₂ b : ℕ) → Periodic (Col (negsuc 0)) N₁ (suc a) → Periodic (Col (pos 0)) N₂ (suc b) → ⊥
centre-left = adjacent (negsuc 0)
