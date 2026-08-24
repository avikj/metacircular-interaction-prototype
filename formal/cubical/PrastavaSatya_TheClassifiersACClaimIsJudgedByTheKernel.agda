{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- प्रस्ताव-सत्य — the proposer's AC claim, judged.
--
-- The checked proposer (formal/executable/Prastava.agda) refuses a pair
-- whose sides are equal after AC-canonicalisation, ASSERTING they are
-- "equal modulo associativity-commutativity of +/·".  Until this module
-- nothing had judged that assertion: the classifier was total and
-- well-typed, but its semantic claim was prose.  Here the claim is a
-- term: acCanon preserves denotation over every environment, so a
-- classifier hit really is a true equation, kernel-said.
--
-- The definitions below are a TRANSCRIPTION of the checked proposer's
-- (same clauses, flat helpers in place of where-blocks so the kernel
-- can case-split them); the theorems are the machine's — posed as holes
-- and closed through the warm conduit by split/solve/give, the carrier
-- emitting only mechanical candidates.
------------------------------------------------------------------------

module PrastavaSatya_TheClassifiersACClaimIsJudgedByTheKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; +-assoc ; +-zero ; ·-comm ; ·-assoc ; ·-identityʳ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (Σ ; _,_)

data Sym : Type₀ where
  plus times monus leS maxS : Sym

data Tm : Type₀ where
  V   : ℕ → Tm
  Z   : Tm
  S   : Tm → Tm
  Bin : Sym → Tm → Tm → Tm

-- the candidate prelude's functions, as the semantics
_∸'_ : ℕ → ℕ → ℕ
n ∸' zero = n
zero ∸' suc _ = zero
suc n ∸' suc m = n ∸' m

le : ℕ → ℕ → ℕ
le zero _ = suc zero
le (suc _) zero = zero
le (suc a) (suc b) = le a b

max' : ℕ → ℕ → ℕ
max' zero n = n
max' (suc m) zero = suc m
max' (suc m) (suc n) = suc (max' m n)

eval : (ℕ → ℕ) → Tm → ℕ
eval e (V i) = e i
eval e Z = zero
eval e (S t) = suc (eval e t)
eval e (Bin plus a b)  = eval e a + eval e b
eval e (Bin times a b) = eval e a · eval e b
eval e (Bin monus a b) = eval e a ∸' eval e b
eval e (Bin leS a b)   = le (eval e a) (eval e b)
eval e (Bin maxS a b)  = max' (eval e a) (eval e b)

-- the proposer's comparison and canonicalisation, transcribed flat
cmpN : ℕ → ℕ → ℕ
cmpN zero zero = 1
cmpN zero (suc _) = 0
cmpN (suc _) zero = 2
cmpN (suc a) (suc b) = cmpN a b

symCode : Sym → ℕ
symCode plus = 0
symCode times = 1
symCode monus = 2
symCode leS = 3
symCode maxS = 4

lex2 : ℕ → ℕ → ℕ
lex2 1 o = o
lex2 o _ = o

cmpTm : Tm → Tm → ℕ
cmpTm (V i) (V j) = cmpN i j
cmpTm (V _) _ = 0
cmpTm Z (V _) = 2
cmpTm Z Z = 1
cmpTm Z _ = 0
cmpTm (S _) (V _) = 2
cmpTm (S _) Z = 2
cmpTm (S a) (S b) = cmpTm a b
cmpTm (S _) (Bin _ _ _) = 0
cmpTm (Bin _ _ _) (V _) = 2
cmpTm (Bin _ _ _) Z = 2
cmpTm (Bin _ _ _) (S _) = 2
cmpTm (Bin s a b) (Bin s' a' b') =
  lex2 (cmpN (symCode s) (symCode s')) (lex2 (cmpTm a a') (cmpTm b b'))

data Where : Type₀ where lt eq gt : Where

whereOf : ℕ → Where
whereOf 0 = lt
whereOf 1 = eq
whereOf _ = gt

-- constructor-dispatched helper in place of a with-block, so lemma
-- clauses can case on the same scrutinee and compute
mutual
  insGo : Where → Tm → Tm → List Tm → List Tm
  insGo gt t u us = u ∷ insertBy t us
  insGo lt t u us = t ∷ u ∷ us
  insGo eq t u us = t ∷ u ∷ us

  insertBy : Tm → List Tm → List Tm
  insertBy t [] = t ∷ []
  insertBy t (u ∷ us) = insGo (whereOf (cmpTm t u)) t u us

sortTm : List Tm → List Tm
sortTm [] = []
sortTm (t ∷ ts) = insertBy t (sortTm ts)

sameSym : Sym → Sym → Where
sameSym s s' = whereOf (cmpN (symCode s) (symCode s'))

mutual
  lvGo : Where → Sym → Tm → Tm → Sym → List Tm
  lvGo eq s a b s' = leavesOf s a ++ leavesOf s b
  lvGo lt s a b s' = Bin s' a b ∷ []
  lvGo gt s a b s' = Bin s' a b ∷ []

  leavesOf : Sym → Tm → List Tm
  leavesOf s (Bin s' a b) = lvGo (sameSym s s') s a b s'
  leavesOf s (V i) = V i ∷ []
  leavesOf s Z = Z ∷ []
  leavesOf s (S t) = S t ∷ []

rebuild : Sym → List Tm → Tm
rebuild s [] = Z
rebuild s (t ∷ []) = t
rebuild s (t ∷ u ∷ us) = Bin s t (rebuild s (u ∷ us))

acCanon : Tm → Tm
acCanon (V i) = V i
acCanon Z = Z
acCanon (S t) = S (acCanon t)
acCanon (Bin plus a b) =
  rebuild plus (sortTm (leavesOf plus (acCanon a) ++ leavesOf plus (acCanon b)))
acCanon (Bin times a b) =
  rebuild times (sortTm (leavesOf times (acCanon a) ++ leavesOf times (acCanon b)))
acCanon (Bin monus a b) = Bin monus (acCanon a) (acCanon b)
acCanon (Bin leS a b)   = Bin leS (acCanon a) (acCanon b)
acCanon (Bin maxS a b)  = Bin maxS (acCanon a) (acCanon b)

------------------------------------------------------------------------
-- the machine's questions: additive chain
------------------------------------------------------------------------

sumT : (ℕ → ℕ) → List Tm → ℕ
sumT e [] = zero
sumT e (t ∷ ts) = eval e t + sumT e ts

sum-++ : (e : ℕ → ℕ) (xs ys : List Tm)
  → sumT e (xs ++ ys) ≡ sumT e xs + sumT e ys
sum-++ e [] ys = refl
sum-++ e (x ∷ xs) ys =
  cong (eval e x +_) (sum-++ e xs ys)
  ∙ +-assoc (eval e x) (sumT e xs) (sumT e ys)

sum-insert : (e : ℕ → ℕ) (t : Tm) (ts : List Tm)
  → sumT e (insertBy t ts) ≡ eval e t + sumT e ts
sum-insert e t [] = refl
sum-insert e t (x ∷ ts) with whereOf (cmpTm t x)
... | gt = cong (eval e x +_) (sum-insert e t ts)
           ∙ +-assoc (eval e x) (eval e t) (sumT e ts)
           ∙ cong (_+ sumT e ts) (+-comm (eval e x) (eval e t))
           ∙ sym (+-assoc (eval e t) (eval e x) (sumT e ts))
... | lt = refl
... | eq = refl

sum-sort : (e : ℕ → ℕ) (ts : List Tm)
  → sumT e (sortTm ts) ≡ sumT e ts
sum-sort e [] = refl
sum-sort e (x ∷ ts) =
  sum-insert e x (sortTm ts) ∙ cong (eval e x +_) (sum-sort e ts)

sum-rebuild : (e : ℕ → ℕ) (ts : List Tm)
  → eval e (rebuild plus ts) ≡ sumT e ts
sum-rebuild e [] = refl
sum-rebuild e (x ∷ []) = sym (+-zero _)
sum-rebuild e (x ∷ y ∷ ts) = cong (eval e x +_) (sum-rebuild e (y ∷ ts))

sum-leaves : (e : ℕ → ℕ) (t : Tm)
  → sumT e (leavesOf plus t) ≡ eval e t
sum-leaves e (V x) = +-zero _
sum-leaves e Z = refl
sum-leaves e (S t) = +-zero _
sum-leaves e (Bin plus t t₁) =
  sum-++ e (leavesOf plus t) (leavesOf plus t₁)
  ∙ cong₂ _+_ (sum-leaves e t) (sum-leaves e t₁)
sum-leaves e (Bin times t t₁) = +-zero _
sum-leaves e (Bin monus t t₁) = +-zero _
sum-leaves e (Bin leS t t₁) = +-zero _
sum-leaves e (Bin maxS t t₁) = +-zero _

------------------------------------------------------------------------
-- multiplicative chain
------------------------------------------------------------------------

prodT : (ℕ → ℕ) → List Tm → ℕ
prodT e [] = suc zero
prodT e (t ∷ ts) = eval e t · prodT e ts

prod-++ : (e : ℕ → ℕ) (xs ys : List Tm)
  → prodT e (xs ++ ys) ≡ prodT e xs · prodT e ys
prod-++ e [] ys = sym (+-zero _)
prod-++ e (x ∷ xs) ys =
  cong (eval e x ·_) (prod-++ e xs ys)
  ∙ ·-assoc (eval e x) (prodT e xs) (prodT e ys)

prod-insert : (e : ℕ → ℕ) (t : Tm) (ts : List Tm)
  → prodT e (insertBy t ts) ≡ eval e t · prodT e ts
prod-insert e t [] = refl
prod-insert e t (x ∷ ts) with whereOf (cmpTm t x)
... | gt = cong (eval e x ·_) (prod-insert e t ts)
           ∙ ·-assoc (eval e x) (eval e t) (prodT e ts)
           ∙ cong (_· prodT e ts) (·-comm (eval e x) (eval e t))
           ∙ sym (·-assoc (eval e t) (eval e x) (prodT e ts))
... | lt = refl
... | eq = refl

prod-sort : (e : ℕ → ℕ) (ts : List Tm)
  → prodT e (sortTm ts) ≡ prodT e ts
prod-sort e [] = refl
prod-sort e (x ∷ ts) =
  prod-insert e x (sortTm ts) ∙ cong (eval e x ·_) (prod-sort e ts)

prod-rebuild : (e : ℕ → ℕ) (t : Tm) (ts : List Tm)
  → eval e (rebuild times (t ∷ ts)) ≡ prodT e (t ∷ ts)
prod-rebuild e t [] = sym (·-identityʳ _)
prod-rebuild e t (x ∷ ts) = cong (eval e t ·_) (prod-rebuild e x ts)

prod-leaves : (e : ℕ → ℕ) (t : Tm)
  → prodT e (leavesOf times t) ≡ eval e t
prod-leaves e (V x) = ·-identityʳ _
prod-leaves e Z = ·-identityʳ _
prod-leaves e (S t) = ·-identityʳ _
prod-leaves e (Bin times t t₁) =
  prod-++ e (leavesOf times t) (leavesOf times t₁)
  ∙ cong₂ _·_ (prod-leaves e t) (prod-leaves e t₁)
prod-leaves e (Bin plus t t₁) = ·-identityʳ _
prod-leaves e (Bin monus t t₁) = ·-identityʳ _
prod-leaves e (Bin leS t t₁) = ·-identityʳ _
prod-leaves e (Bin maxS t t₁) = ·-identityʳ _

-- insertBy never returns [], so sortTm of a cons never does: the shape
-- the times chain rides through
insert-cons : (t : Tm) (ts : List Tm)
  → Σ Tm (λ h → Σ (List Tm) (λ rest → insertBy t ts ≡ h ∷ rest))
insert-cons t [] = t , ([] , refl)
insert-cons t (x ∷ ts) with whereOf (cmpTm t x)
... | gt = x , (insertBy t ts , refl)
... | lt = t , ((x ∷ ts) , refl)
... | eq = t , ((x ∷ ts) , refl)

-- rebuild∘sort computes the product on any cons, transported through
-- insert-cons's shape
times-sort : (e : ℕ → ℕ) (x : Tm) (xs : List Tm)
  → eval e (rebuild times (sortTm (x ∷ xs))) ≡ prodT e (sortTm (x ∷ xs))
times-sort e x xs with insert-cons x (sortTm xs)
... | h , (rest , p) =
  cong (λ l → eval e (rebuild times l)) p
  ∙ prod-rebuild e h rest
  ∙ cong (prodT e) (sym p)

------------------------------------------------------------------------
-- the judgment
------------------------------------------------------------------------

acCanon-sound : (e : ℕ → ℕ) (t : Tm)
  → eval e (acCanon t) ≡ eval e t
acCanon-sound e (V x) = refl
acCanon-sound e Z = refl
acCanon-sound e (S t) = cong suc (acCanon-sound e t)
acCanon-sound e (Bin plus t t₁) =
  sum-rebuild e (sortTm (leavesOf plus (acCanon t) ++ leavesOf plus (acCanon t₁)))
  ∙ sum-sort e (leavesOf plus (acCanon t) ++ leavesOf plus (acCanon t₁))
  ∙ sum-++ e (leavesOf plus (acCanon t)) (leavesOf plus (acCanon t₁))
  ∙ cong₂ _+_ (sum-leaves e (acCanon t) ∙ acCanon-sound e t)
              (sum-leaves e (acCanon t₁) ∙ acCanon-sound e t₁)
acCanon-sound e (Bin times t t₁) = timesCase (leavesOf times (acCanon t))
  (leaves-shape (acCanon t)) refl
  where
  -- leavesOf never returns [], exhibited by cases
  leaves-shape : (u : Tm)
    → Σ Tm (λ h → Σ (List Tm) (λ rest → leavesOf times u ≡ h ∷ rest))
  leaves-shape (V i) = V i , ([] , refl)
  leaves-shape Z = Z , ([] , refl)
  leaves-shape (S u) = S u , ([] , refl)
  leaves-shape (Bin plus a b) = Bin plus a b , ([] , refl)
  leaves-shape (Bin monus a b) = Bin monus a b , ([] , refl)
  leaves-shape (Bin leS a b) = Bin leS a b , ([] , refl)
  leaves-shape (Bin maxS a b) = Bin maxS a b , ([] , refl)
  leaves-shape (Bin times a b) with leaves-shape a
  ... | h , (rest , p) =
    h , ((rest ++ leavesOf times b) , cong (_++ leavesOf times b) p)

  timesCase : (la : List Tm)
    → Σ Tm (λ h → Σ (List Tm) (λ rest → la ≡ h ∷ rest))
    → la ≡ leavesOf times (acCanon t)
    → eval e (rebuild times (sortTm (la ++ leavesOf times (acCanon t₁))))
      ≡ eval e t · eval e t₁
  timesCase la (h , (rest , p)) q =
    cong (λ l → eval e (rebuild times (sortTm (l ++ leavesOf times (acCanon t₁))))) p
    ∙ times-sort e h (rest ++ leavesOf times (acCanon t₁))
    ∙ prod-sort e (h ∷ rest ++ leavesOf times (acCanon t₁))
    ∙ cong (prodT e) (sym (cong (_++ leavesOf times (acCanon t₁)) p))
    ∙ cong (prodT e) (cong (_++ leavesOf times (acCanon t₁)) q)
    ∙ prod-++ e (leavesOf times (acCanon t)) (leavesOf times (acCanon t₁))
    ∙ cong₂ _·_ (prod-leaves e (acCanon t) ∙ acCanon-sound e t)
                (prod-leaves e (acCanon t₁) ∙ acCanon-sound e t₁)
acCanon-sound e (Bin monus t t₁) =
  cong₂ _∸'_ (acCanon-sound e t) (acCanon-sound e t₁)
acCanon-sound e (Bin leS t t₁) =
  cong₂ le (acCanon-sound e t) (acCanon-sound e t₁)
acCanon-sound e (Bin maxS t t₁) =
  cong₂ max' (acCanon-sound e t) (acCanon-sound e t₁)

------------------------------------------------------------------------
-- मर्यादा.  What stands: acCanon preserves denotation, so any pair whose
-- canonical forms COINCIDE denotes one function — the content of the
-- classifier's refusal, judged.  The named debt: the bridge from the
-- executable's `eqTm x y ≡ true` to `x ≡ y` (soundness of the flat
-- comparison) is not yet a term, and the two insertBy/leavesOf spellings
-- (with-blocks there, constructor-dispatched helpers here) are one
-- function by clause-for-clause transcription, asserted not checked.
-- Both belong to the same future landing.
------------------------------------------------------------------------
