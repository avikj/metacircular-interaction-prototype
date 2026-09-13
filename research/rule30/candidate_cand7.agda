{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module Candidate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; sucℤ ; predℤ ; sucPred ; predSuc)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; _or_ ; _⊕_ ; not ; _and_ ; true≢false ; false≢true)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Empty as E using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- The right diagonals of Rule 30 from a single seed: d k t = x t (t − k).
-- They satisfy the closed recurrence
--     d (k+2) (t+1) = d (k+2) t ⊕ (d (k+1) t ∨ d k t),   d 0 ≡ 1,  d 1 t = t odd,
-- and every d k is purely periodic with period 2^k (Theorem R).  The
-- centre column is c t = d t t: it samples each diagonal at a time
-- before that diagonal's period can have elapsed, which is why the
-- column inherits no periodicity from them.
------------------------------------------------------------------------

r30 : Bool → Bool → Bool → Bool
r30 l c r = l ⊕ (c or r)

x : ℕ → ℤ → Bool
x zero    (pos zero)    = true
x zero    (pos (suc _)) = false
x zero    (negsuc _)    = false
x (suc t) i             = r30 (x t (predℤ i)) (x t i) (x t (sucℤ i))

predⁿ : ℕ → ℤ → ℤ
predⁿ zero    i = i
predⁿ (suc k) i = predⁿ k (predℤ i)

d : ℕ → ℕ → Bool
d k t = x t (predⁿ k (pos t))

-- §1  the right light cone: at time t everything right of +t is 0
cone-r : (t k : ℕ) → x t (pos (suc (t + k))) ≡ false
cone-r zero    k = refl
cone-r (suc t) k =
  cong₂ (λ c r → r30 (x t (pos (suc (t + k)))) c r)
        (cong (x t) (cong pos (cong suc (sym (+-suc t k)))) ∙ cone-r t (suc k))
        (cong (x t) (cong pos (cong suc (cong suc (sym (+-suc t k)) ∙ sym (+-suc t (suc k))))) ∙ cone-r t (suc (suc k)))
  ∙ cong (_⊕ false) (cone-r t k)

-- §2  predⁿ commutes with predℤ, and sucℤ undoes one step of it
predⁿ-pred : (k : ℕ) (i : ℤ) → predℤ (predⁿ k i) ≡ predⁿ k (predℤ i)
predⁿ-pred zero    i = refl
predⁿ-pred (suc k) i = predⁿ-pred k (predℤ i)

predⁿ-suc : (k : ℕ) (i : ℤ) → sucℤ (predⁿ (suc k) i) ≡ predⁿ k i
predⁿ-suc zero    i = sucPred i
predⁿ-suc (suc k) i = predⁿ-suc k (predℤ i)

-- §3  the recurrence, definitionally from the rule
diag-rec : (k t : ℕ) → d (suc (suc k)) (suc t) ≡ d (suc (suc k)) t ⊕ (d (suc k) t or d k t)
diag-rec k t =
  cong₂ (λ l r → l ⊕ (d (suc k) t or r))
        (cong (x t) (predⁿ-pred (suc k) (pos t)))
        (cong (x t) (predⁿ-suc k (pos t)))

⊕-false : (b : Bool) → b ⊕ false ≡ b
⊕-false true  = refl
⊕-false false = refl

⊕-true : (b : Bool) → b ⊕ true ≡ not b
⊕-true true  = refl
⊕-true false = refl

d0 : (t : ℕ) → d 0 t ≡ true
d0 zero    = refl
d0 (suc t) =
  cong₂ (λ c r → r30 (d 0 t) c r)
        (cong (x t) (cong pos (cong suc (sym (+-zero t)))) ∙ cone-r t 0)
        (cong (x t) (cong pos (cong suc (sym (+-comm t 1)))) ∙ cone-r t 1)
  ∙ ⊕-false (d 0 t) ∙ d0 t

d1 : (t : ℕ) → d 1 (suc t) ≡ not (d 1 t)
d1 t =
  cong₂ (λ c r → r30 (d 1 t) c r) (d0 t) (cong (x t) (cong pos (cong suc (sym (+-zero t)))) ∙ cone-r t 0)
  ∙ ⊕-true (d 1 t)

-- §4  Theorem R: every right diagonal is purely periodic with period 2^k
Purely : (ℕ → Bool) → ℕ → Type
Purely s P = (t : ℕ) → s (t + P) ≡ s t

purely-double : (s : ℕ → Bool) (P : ℕ) → Purely s P → Purely s (P + P)
purely-double s P per t = cong s (+-assoc t P P) ∙ per (t + P) ∙ per t

-- the running parity of f over [t, t+L)
xorRange : (ℕ → Bool) → ℕ → ℕ → Bool
xorRange f t zero    = false
xorRange f t (suc L) = xorRange f t L ⊕ f (t + L)

⊕-assoc : (a b c : Bool) → (a ⊕ b) ⊕ c ≡ a ⊕ (b ⊕ c)
⊕-assoc true  true  true  = refl
⊕-assoc true  true  false = refl
⊕-assoc true  false true  = refl
⊕-assoc true  false false = refl
⊕-assoc false true  true  = refl
⊕-assoc false true  false = refl
⊕-assoc false false true  = refl
⊕-assoc false false false = refl

⊕-cancel : (a b : Bool) → (a ⊕ b) ⊕ b ≡ a
⊕-cancel true  true  = refl
⊕-cancel true  false = refl
⊕-cancel false true  = refl
⊕-cancel false false = refl

-- a sequence driven by s (t+1) = s t ⊕ f t advances over L steps by the parity of f
drive : (s f : ℕ → Bool) → ((t : ℕ) → s (suc t) ≡ s t ⊕ f t) → (t L : ℕ) → s (t + L) ≡ s t ⊕ xorRange f t L
drive s f h t zero    = cong s (+-zero t) ∙ sym (⊕-false (s t))
drive s f h t (suc L) = cong s (+-suc t L) ∙ h (t + L) ∙ cong (_⊕ f (t + L)) (drive s f h t L) ∙ ⊕-assoc (s t) (xorRange f t L) (f (t + L))

-- the parity over one period is the same from every starting point that is one period later
xorRange-shift : (f : ℕ → Bool) (L : ℕ) → Purely f L → (t : ℕ) → xorRange f (t + L) L ≡ xorRange f t L
xorRange-shift f L per t = go L
  where
  go : (M : ℕ) → xorRange f (t + L) M ≡ xorRange f t M
  go zero    = refl
  go (suc M) = cong₂ _⊕_ (go M) (cong f (samī t L M) ∙ per (t + M))
    where
    samī : (t L M : ℕ) → (t + L) + M ≡ (t + M) + L
    samī t L M = sym (+-assoc t L M) ∙ cong (t +_) (+-comm L M) ∙ +-assoc t M L

-- driven by an L-periodic f, s is 2L-periodic
driven-periodic : (s f : ℕ → Bool) → ((t : ℕ) → s (suc t) ≡ s t ⊕ f t) → (L : ℕ) → Purely f L → Purely s (L + L)
driven-periodic s f h L per t =
  cong s (+-assoc t L L)
  ∙ drive s f h (t + L) L
  ∙ cong₂ _⊕_ (drive s f h t L) (xorRange-shift f L per t)
  ∙ ⊕-cancel (s t) (xorRange f t L)

-- common period of two diagonals: the or of two L-periodic sequences is L-periodic
or-periodic : (a b : ℕ → Bool) (L : ℕ) → Purely a L → Purely b L → Purely (λ t → a t or b t) L
or-periodic a b L pa pb t = cong₂ _or_ (pa t) (pb t)

pow2-double : (k : ℕ) → 2 ^ suc k ≡ 2 ^ k + 2 ^ k
pow2-double k = cong ((2 ^ k) +_) (+-zero (2 ^ k))

theoremR : (k : ℕ) → Purely (d k) (2 ^ k) × Purely (d (suc k)) (2 ^ suc k)
theoremR zero = (λ t → d0 (t + 1) ∙ sym (d0 t))
              , (λ t → cong (d 1) (+-comm t 2) ∙ d1 (suc t) ∙ cong not (d1 t) ∙ notnot (d 1 t))
  where
  notnot : (b : Bool) → not (not b) ≡ b
  notnot true  = refl
  notnot false = refl
theoremR (suc k) =
  let (pk , psk) = theoremR k
      pk′ : Purely (d k) (2 ^ suc k)
      pk′ = subst (Purely (d k)) (sym (pow2-double k)) (purely-double (d k) (2 ^ k) pk)
  in psk
   , subst (Purely (d (suc (suc k)))) (sym (pow2-double (suc k)))
           (driven-periodic (d (suc (suc k))) (λ t → d (suc k) t or d k t) (diag-rec k) (2 ^ suc k)
                            (or-periodic (d (suc k)) (d k) (2 ^ suc k) psk pk′))

-- §5  the centre column is the diagonal of the diagonals
centre : (t : ℕ) → x t (pos 0) ≡ d t t
centre t = cong (x t) (sym (predⁿ-pos-zero t))
  where
  predⁿ-pos-zero : (t : ℕ) → predⁿ t (pos t) ≡ pos 0
  predⁿ-pos-zero zero    = refl
  predⁿ-pos-zero (suc t) = predⁿ-pos-zero t
