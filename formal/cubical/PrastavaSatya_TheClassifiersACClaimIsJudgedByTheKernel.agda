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
-- The classifier's definitions are IMPORTED from PrastavaHrdaya — the
-- one spelling shared with the executable proposer — so nothing here
-- is a transcription and nothing is asserted to coincide; the theorems
-- are the machine's, posed as holes and closed through the warm
-- conduit by split/solve/give, the carrier emitting only mechanical
-- candidates.
------------------------------------------------------------------------

module PrastavaSatya_TheClassifiersACClaimIsJudgedByTheKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; +-assoc ; +-zero ; ·-comm ; ·-assoc ; ·-identityʳ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ ; _,_)

-- the ONE spelling of the classifier, shared with the extracted proposer
open import PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem

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

mutual
  gcdGo : ℕ → ℕ → ℕ → ℕ → ℕ
  gcdGo f (suc zero) a b = gcdF f a (b ∸' a)
  gcdGo f _ a b = gcdF f (a ∸' b) b

  gcdF : ℕ → ℕ → ℕ → ℕ
  gcdF zero a _ = a
  gcdF (suc f) a zero = a
  gcdF (suc f) zero b = b
  gcdF (suc f) (suc a) (suc b) = gcdGo f (le (suc a) (suc b)) (suc a) (suc b)

gcd' : ℕ → ℕ → ℕ
gcd' a b = gcdF (a + b) a b

eval : (ℕ → ℕ) → Tm → ℕ
eval e (V i) = e i
eval e Z = zero
eval e (S t) = suc (eval e t)
eval e (Bin plus a b)  = eval e a + eval e b
eval e (Bin times a b) = eval e a · eval e b
eval e (Bin monus a b) = eval e a ∸' eval e b
eval e (Bin leS a b)   = le (eval e a) (eval e b)
eval e (Bin maxS a b)  = max' (eval e a) (eval e b)
eval e (Bin gcdS a b)  = gcd' (eval e a) (eval e b)


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
sum-leaves e (Bin gcdS t t₁) = +-zero _

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
prod-leaves e (Bin gcdS t t₁) = ·-identityʳ _

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
  leaves-shape (Bin gcdS a b) = Bin gcdS a b , ([] , refl)
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
acCanon-sound e (Bin gcdS t t₁) =
  cong₂ gcd' (acCanon-sound e t) (acCanon-sound e t₁)

------------------------------------------------------------------------
-- the bridge: a comparison verdict of eq IS a syntactic equality.
-- The executable refuses when eqTm (acCanon l) (acCanon r) = true, i.e.
-- cmpTm (acCanon l) (acCanon r) ≡ 1.  Below, that numeral is judged to
-- carry a path — so a classifier hit denotes one function, end to end.
------------------------------------------------------------------------

open import Cubical.Data.Empty using () renaming (rec to ⊥rec)
open import Cubical.Data.Nat using (znots ; snotz ; injSuc)
open import Cubical.Data.Sigma using (_×_ ; fst ; snd)

cmpN-eq : (i j : ℕ) → cmpN i j ≡ 1 → i ≡ j
cmpN-eq zero zero _ = refl
cmpN-eq zero (suc j) p = ⊥rec (znots p)
cmpN-eq (suc i) zero p = ⊥rec (snotz (injSuc p))
cmpN-eq (suc i) (suc j) p = cong suc (cmpN-eq i j p)

lex2-eq : (c o : ℕ) → lex2 c o ≡ 1 → (c ≡ 1) × (o ≡ 1)
lex2-eq zero o p = ⊥rec (znots p)
lex2-eq (suc zero) o p = refl , p
lex2-eq (suc (suc c)) o p = ⊥rec (snotz (injSuc p))

-- injectivity of the symbol code by decode-roundtrip, five clauses
symDec : ℕ → Sym
symDec zero = plus
symDec (suc zero) = times
symDec (suc (suc zero)) = monus
symDec (suc (suc (suc zero))) = leS
symDec (suc (suc (suc (suc zero)))) = maxS
symDec _ = gcdS

symDec-code : (s : Sym) → symDec (symCode s) ≡ s
symDec-code plus = refl
symDec-code times = refl
symDec-code monus = refl
symDec-code leS = refl
symDec-code maxS = refl
symDec-code gcdS = refl

symCode-inj : (s s' : Sym) → symCode s ≡ symCode s' → s ≡ s'
symCode-inj s s' p = sym (symDec-code s) ∙ cong symDec p ∙ symDec-code s'

cmpTm-eq : (x y : Tm) → cmpTm x y ≡ 1 → x ≡ y
cmpTm-eq (V i) (V j) p = cong V (cmpN-eq i j p)
cmpTm-eq (V _) Z p = ⊥rec (znots p)
cmpTm-eq (V _) (S _) p = ⊥rec (znots p)
cmpTm-eq (V _) (Bin _ _ _) p = ⊥rec (znots p)
cmpTm-eq Z (V _) p = ⊥rec (snotz (injSuc p))
cmpTm-eq Z Z _ = refl
cmpTm-eq Z (S _) p = ⊥rec (znots p)
cmpTm-eq Z (Bin _ _ _) p = ⊥rec (znots p)
cmpTm-eq (S _) (V _) p = ⊥rec (snotz (injSuc p))
cmpTm-eq (S _) Z p = ⊥rec (snotz (injSuc p))
cmpTm-eq (S a) (S b) p = cong S (cmpTm-eq a b p)
cmpTm-eq (S _) (Bin _ _ _) p = ⊥rec (znots p)
cmpTm-eq (Bin _ _ _) (V _) p = ⊥rec (snotz (injSuc p))
cmpTm-eq (Bin _ _ _) Z p = ⊥rec (snotz (injSuc p))
cmpTm-eq (Bin _ _ _) (S _) p = ⊥rec (snotz (injSuc p))
cmpTm-eq (Bin s a b) (Bin s' a' b') p =
  let outer = lex2-eq (cmpN (symCode s) (symCode s'))
                      (lex2 (cmpTm a a') (cmpTm b b')) p
      inner = lex2-eq (cmpTm a a') (cmpTm b b') (snd outer)
  in λ i → Bin (symCode-inj s s' (cmpN-eq (symCode s) (symCode s') (fst outer)) i)
               (cmpTm-eq a a' (fst inner) i)
               (cmpTm-eq b b' (snd inner) i)

-- the closed loop's refusal, judged end to end: when the classifier
-- says a pair is a pure AC shuffle, the two sides denote one function.
acShuffle-sound : (e : ℕ → ℕ) (l r : Tm)
  → cmpTm (acCanon l) (acCanon r) ≡ 1
  → eval e l ≡ eval e r
acShuffle-sound e l r p =
  sym (acCanon-sound e l)
  ∙ cong (eval e) (cmpTm-eq (acCanon l) (acCanon r) p)
  ∙ acCanon-sound e r

------------------------------------------------------------------------
-- the normalizer, judged: nf (one erasure pass + AC canonicalisation)
-- preserves denotation.  The syntactic tests inside simpB are eqTm,
-- and their truth becomes a path through the bridge above — the
-- machine's earlier landing is the tool that checks its next organ.
-- With nf-sound, a pair whose sides share a normal form is provable by
-- two soundness applications around a definitional middle; the checked
-- proposer emits exactly that term (the reflection rung).
------------------------------------------------------------------------

open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)

is1-≡ : (n : ℕ) → is1 n ≡ true → n ≡ 1
is1-≡ zero p = ⊥rec (false≢true p)
is1-≡ (suc zero) _ = refl
is1-≡ (suc (suc n)) p = ⊥rec (false≢true p)

eqTm-≡ : (x y : Tm) → eqTm x y ≡ true → x ≡ y
eqTm-≡ x y p = cmpTm-eq x y (is1-≡ (cmpTm x y) p)

private
  mul0 : (n : ℕ) → n · zero ≡ zero
  mul0 zero = refl
  mul0 (suc n) = mul0 n

  monus0 : (n : ℕ) → zero ∸' n ≡ zero
  monus0 zero = refl
  monus0 (suc n) = refl

  max0 : (n : ℕ) → max' n zero ≡ n
  max0 zero = refl
  max0 (suc n) = refl

  gcd0r : (n : ℕ) → gcd' n zero ≡ n
  gcd0r zero = refl
  gcd0r (suc n) = refl

  gcd0l : (n : ℕ) → gcd' zero n ≡ n
  gcd0l zero = refl
  gcd0l (suc n) = refl

-- `with … in eq` desugars through builtin REFL, unavailable under
-- --cubical (2.6.3), so each if-ladder is walked by a helper that
-- carries the scrutinised Bool NEXT TO its own equation, instantiated
-- with refl at the call site.
private
  plusGo2 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm b Z ≡ c
    → eval e (if c then a else Bin plus a b) ≡ eval e (Bin plus a b)
  plusGo2 e a b true p =
    sym (cong (λ u → eval e a + eval e u) (eqTm-≡ b Z p) ∙ +-zero (eval e a))
  plusGo2 e a b false p = refl

  plusGo1 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm a Z ≡ c
    → eval e (if c then b else if eqTm b Z then a else Bin plus a b)
      ≡ eval e (Bin plus a b)
  plusGo1 e a b true p = sym (cong (λ u → eval e u + eval e b) (eqTm-≡ a Z p))
  plusGo1 e a b false p = plusGo2 e a b (eqTm b Z) refl

  timesGo4 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm b one ≡ c
    → eval e (if c then a else Bin times a b) ≡ eval e (Bin times a b)
  timesGo4 e a b true p =
    sym (cong (λ u → eval e a · eval e u) (eqTm-≡ b one p)
         ∙ ·-identityʳ (eval e a))
  timesGo4 e a b false p = refl

  timesGo3 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm a one ≡ c
    → eval e (if c then b else if eqTm b one then a else Bin times a b)
      ≡ eval e (Bin times a b)
  timesGo3 e a b true p =
    sym (cong (λ u → eval e u · eval e b) (eqTm-≡ a one p)
         ∙ +-zero (eval e b))
  timesGo3 e a b false p = timesGo4 e a b (eqTm b one) refl

  timesGo2 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm b Z ≡ c
    → eval e (if c then Z else
              if eqTm a one then b else
              if eqTm b one then a else Bin times a b)
      ≡ eval e (Bin times a b)
  timesGo2 e a b true p =
    sym (cong (λ u → eval e a · eval e u) (eqTm-≡ b Z p) ∙ mul0 (eval e a))
  timesGo2 e a b false p = timesGo3 e a b (eqTm a one) refl

  timesGo1 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm a Z ≡ c
    → eval e (if c then Z else
              if eqTm b Z then Z else
              if eqTm a one then b else
              if eqTm b one then a else Bin times a b)
      ≡ eval e (Bin times a b)
  timesGo1 e a b true p = sym (cong (λ u → eval e u · eval e b) (eqTm-≡ a Z p))
  timesGo1 e a b false p = timesGo2 e a b (eqTm b Z) refl

  monusGo2 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm a Z ≡ c
    → eval e (if c then Z else Bin monus a b) ≡ eval e (Bin monus a b)
  monusGo2 e a b true p =
    sym (cong (λ u → eval e u ∸' eval e b) (eqTm-≡ a Z p) ∙ monus0 (eval e b))
  monusGo2 e a b false p = refl

  monusGo1 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm b Z ≡ c
    → eval e (if c then a else if eqTm a Z then Z else Bin monus a b)
      ≡ eval e (Bin monus a b)
  monusGo1 e a b true p = sym (cong (λ u → eval e a ∸' eval e u) (eqTm-≡ b Z p))
  monusGo1 e a b false p = monusGo2 e a b (eqTm a Z) refl

  leGo1 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm a Z ≡ c
    → eval e (if c then one else Bin leS a b) ≡ eval e (Bin leS a b)
  leGo1 e a b true p = sym (cong (λ u → le (eval e u) (eval e b)) (eqTm-≡ a Z p))
  leGo1 e a b false p = refl

  maxGo2 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm b Z ≡ c
    → eval e (if c then a else Bin maxS a b) ≡ eval e (Bin maxS a b)
  maxGo2 e a b true p =
    sym (cong (λ u → max' (eval e a) (eval e u)) (eqTm-≡ b Z p)
         ∙ max0 (eval e a))
  maxGo2 e a b false p = refl

  maxGo1 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm a Z ≡ c
    → eval e (if c then b else if eqTm b Z then a else Bin maxS a b)
      ≡ eval e (Bin maxS a b)
  maxGo1 e a b true p =
    sym (cong (λ u → max' (eval e u) (eval e b)) (eqTm-≡ a Z p))
  maxGo1 e a b false p = maxGo2 e a b (eqTm b Z) refl

  gcdGo2 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm a Z ≡ c
    → eval e (if c then b else Bin gcdS a b) ≡ eval e (Bin gcdS a b)
  gcdGo2 e a b true p =
    sym (cong (λ u → gcd' (eval e u) (eval e b)) (eqTm-≡ a Z p)
         ∙ gcd0l (eval e b))
  gcdGo2 e a b false p = refl

  gcdGo1 : (e : ℕ → ℕ) (a b : Tm) (c : Bool) → eqTm b Z ≡ c
    → eval e (if c then a else if eqTm a Z then b else Bin gcdS a b)
      ≡ eval e (Bin gcdS a b)
  gcdGo1 e a b true p =
    sym (cong (λ u → gcd' (eval e a) (eval e u)) (eqTm-≡ b Z p)
         ∙ gcd0r (eval e a))
  gcdGo1 e a b false p = gcdGo2 e a b (eqTm a Z) refl

simpB-sound : (e : ℕ → ℕ) (s : Sym) (a b : Tm)
  → eval e (simpB s a b) ≡ eval e (Bin s a b)
simpB-sound e plus a b  = plusGo1 e a b (eqTm a Z) refl
simpB-sound e times a b = timesGo1 e a b (eqTm a Z) refl
simpB-sound e monus a b = monusGo1 e a b (eqTm b Z) refl
simpB-sound e leS a b   = leGo1 e a b (eqTm a Z) refl
simpB-sound e maxS a b  = maxGo1 e a b (eqTm a Z) refl
simpB-sound e gcdS a b  = gcdGo1 e a b (eqTm b Z) refl

binCong : (e : ℕ → ℕ) (s : Sym) {a a' b b' : Tm}
  → eval e a ≡ eval e a' → eval e b ≡ eval e b'
  → eval e (Bin s a b) ≡ eval e (Bin s a' b')
binCong e plus p q  = cong₂ _+_ p q
binCong e times p q = cong₂ _·_ p q
binCong e monus p q = cong₂ _∸'_ p q
binCong e leS p q   = cong₂ le p q
binCong e maxS p q  = cong₂ max' p q
binCong e gcdS p q  = cong₂ gcd' p q

simp-sound : (e : ℕ → ℕ) (t : Tm) → eval e (simp t) ≡ eval e t
simp-sound e (V i) = refl
simp-sound e Z = refl
simp-sound e (S t) = cong suc (simp-sound e t)
simp-sound e (Bin s a b) =
  simpB-sound e s (simp a) (simp b)
  ∙ binCong e s (simp-sound e a) (simp-sound e b)

-- the unfolding pass.  suc a + b and suc a · b unfold definitionally;
-- a · suc b needs the lemma the library does not carry:
mulSuc : (m n : ℕ) → m · suc n ≡ m + m · n
mulSuc zero n = refl
mulSuc (suc m) n = cong suc
  (cong (n +_) (mulSuc m n)
   ∙ +-assoc n m (m · n)
   ∙ cong (_+ m · n) (+-comm n m)
   ∙ sym (+-assoc m n (m · n)))

unfP-sound : (e : ℕ → ℕ) (a b : Tm)
  → eval e (unfP a b) ≡ eval e a + eval e b
unfP-sound e (S a) b = cong suc (unfP-sound e a b)
unfP-sound e (V i) b = refl
unfP-sound e Z b = refl
unfP-sound e (Bin s x y) b = refl

unfT-sound : (e : ℕ → ℕ) (a b : Tm)
  → eval e (unfT a b) ≡ eval e a · eval e b
unfT-sound e (S a) b =
  unfP-sound e b (unfT a b) ∙ cong (eval e b +_) (unfT-sound e a b)
unfT-sound e (V i) (S b) =
  unfP-sound e (V i) (unfT (V i) b)
  ∙ cong (e i +_) (unfT-sound e (V i) b)
  ∙ sym (mulSuc (e i) (eval e b))
unfT-sound e (V i) (V j) = refl
unfT-sound e (V i) Z = refl
unfT-sound e (V i) (Bin s x y) = refl
unfT-sound e Z b = refl
unfT-sound e (Bin s x y) (S b) =
  unfP-sound e (Bin s x y) (unfT (Bin s x y) b)
  ∙ cong (eval e (Bin s x y) +_) (unfT-sound e (Bin s x y) b)
  ∙ sym (mulSuc (eval e (Bin s x y)) (eval e b))
unfT-sound e (Bin s x y) (V j) = refl
unfT-sound e (Bin s x y) Z = refl
unfT-sound e (Bin s x y) (Bin s' x' y') = refl

unf-sound : (e : ℕ → ℕ) (t : Tm) → eval e (unf t) ≡ eval e t
unf-sound e (V i) = refl
unf-sound e Z = refl
unf-sound e (S t) = cong suc (unf-sound e t)
unf-sound e (Bin plus a b) =
  unfP-sound e (unf a) (unf b) ∙ cong₂ _+_ (unf-sound e a) (unf-sound e b)
unf-sound e (Bin times a b) =
  unfT-sound e (unf a) (unf b) ∙ cong₂ _·_ (unf-sound e a) (unf-sound e b)
unf-sound e (Bin monus a b) =
  cong₂ _∸'_ (unf-sound e a) (unf-sound e b)
unf-sound e (Bin leS a b) =
  cong₂ le (unf-sound e a) (unf-sound e b)
unf-sound e (Bin maxS a b) =
  cong₂ max' (unf-sound e a) (unf-sound e b)
unf-sound e (Bin gcdS a b) =
  cong₂ gcd' (unf-sound e a) (unf-sound e b)

-- one sound round, then nf = canon ∘ round ∘ canon ∘ round
round-sound : (e : ℕ → ℕ) (t : Tm) → eval e (simp (unf t)) ≡ eval e t
round-sound e t = simp-sound e (unf t) ∙ unf-sound e t

nf-sound : (e : ℕ → ℕ) (t : Tm) → eval e (nf t) ≡ eval e t
nf-sound e t =
  acCanon-sound e (simp (unf (acCanon (simp (unf t)))))
  ∙ round-sound e (acCanon (simp (unf t)))
  ∙ acCanon-sound e (simp (unf t))
  ∙ round-sound e t

------------------------------------------------------------------------
-- मर्यादा.  What stands: acCanon preserves denotation, and a comparison
-- verdict of 1 is a path, so a classifier hit means the two sides denote
-- one function (acShuffle-sound) — the content of the refusal, judged
-- end to end.  The transcription debt is PAID structurally, not by a
-- proof: the classifier now has one spelling (PrastavaHrdaya, checked
-- --cubical-compatible), imported both here and by the extracted
-- proposer, so there are no longer two functions to identify.
------------------------------------------------------------------------
