{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Digits
--
-- Three presentations of the natural numbers, each defined
-- independently, and a *constructed* equivalence between two of them.
--
--   (i)   ℕ            : the initial algebra of X ↦ 1 + X  (imported)
--   (ii)  List Unit    : the free monoid on one generator  (Presentations)
--   (iii) CanWord      : base-b digit words in canonical form  (here)
--
-- Nothing is identified by fiat.  `value` is defined by the positional
-- sum; `digits` is defined by iterating schoolbook increment-with-carry
-- (`sucw`), and the two round trips are proved.  Carrying is where the
-- content is: `sucw` is the odometer, and `value-sucw` is the statement
-- that the odometer computes the successor.
--
-- The base is a module parameter b = 2 + k, so b ≥ 2 always.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module Digits (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ ; isSetFin ; Fin-fst-≡)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List
open import Cubical.Data.Unit
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

------------------------------------------------------------------------
-- 0.  The alphabet and raw words
------------------------------------------------------------------------

b : ℕ
b = suc (suc k)

Digit : Type₀
Digit = Fin b

-- Words are little-endian: the head is the *least* significant digit.
Word : Type₀
Word = List Digit

-- Positional evaluation.  This is the chart map.
value : Word → ℕ
value []      = 0
value (d ∷ w) = toℕ d + b · value w

carryVal : Bool → ℕ
carryVal false = 0
carryVal true  = 1

------------------------------------------------------------------------
-- 1.  Canonicity: no leading zeros.
--
-- Little-endian, so the *most* significant digit is the last one.
-- `Canonical w` says: w is empty, or its last digit is positive.
------------------------------------------------------------------------

Canonical : Word → Type₀
Canonical []          = Unit
Canonical (d ∷ [])    = 0 < toℕ d
Canonical (d ∷ e ∷ w) = Canonical (e ∷ w)

isPropCanonical : (w : Word) → isProp (Canonical w)
isPropCanonical []          = isPropUnit
isPropCanonical (d ∷ [])    = isProp≤
isPropCanonical (d ∷ e ∷ w) = isPropCanonical (e ∷ w)

canonical-tail : (d : Digit) (w : Word) → Canonical (d ∷ w) → Canonical w
canonical-tail d []      _ = tt
canonical-tail d (e ∷ w) c = c

-- The canonical-word presentation.
CanWord : Type₀
CanWord = Σ[ w ∈ Word ] Canonical w

isSetWord : isSet Word
isSetWord = isOfHLevelList 0 isSetFin

isSetCanWord : isSet CanWord
isSetCanWord = isSetΣ isSetWord (λ w → isProp→isSet (isPropCanonical w))

------------------------------------------------------------------------
-- 2.  Digit successor, certified.  This is one carry step.
------------------------------------------------------------------------

-- The result is packaged with its specification so that later proofs
-- can destructure the certificate together with the value; this avoids
-- the usual `with`-abstraction blindness.
dsucΣ : (d : Digit)
      → Σ[ r ∈ Digit × Bool ] (suc (toℕ d) ≡ toℕ (fst r) + carryVal (snd r) · b)
dsucΣ d with ≤-split (snd d)
... | inl p = ((suc (toℕ d) , p) , false) , sym (+-zero (suc (toℕ d)))
... | inr q = (fzero , true) , (q ∙ sym (+-zero b))

dsuc : Digit → Digit × Bool
dsuc d = fst (dsucΣ d)

------------------------------------------------------------------------
-- 3.  Schoolbook increment on words: the odometer.
------------------------------------------------------------------------

mutual
  sucw : Word → Word
  sucw []      = fone ∷ []
  sucw (d ∷ w) = sucwAux (dsuc d) w

  sucwAux : Digit × Bool → Word → Word
  sucwAux (d' , false) w = d' ∷ w
  sucwAux (d' , true)  w = d' ∷ sucw w

-- 3a.  The odometer computes the successor.

value-sucw-step :
    (d : Digit) (w : Word)
  → value (sucw w) ≡ suc (value w)
  → (r : Digit × Bool)
  → suc (toℕ d) ≡ toℕ (fst r) + carryVal (snd r) · b
  → value (sucwAux r w) ≡ suc (value (d ∷ w))
value-sucw-step d w ih (d' , false) spec =
  cong (_+ b · value w) (sym (spec ∙ +-zero (toℕ d')))
value-sucw-step d w ih (d' , true) spec =
    cong (λ v → toℕ d' + b · v) ih
  ∙ cong (toℕ d' +_) (·-suc b (value w))
  ∙ +-assoc (toℕ d') b (b · value w)
  ∙ cong (_+ b · value w)
      (cong (toℕ d' +_) (sym (+-zero b)) ∙ sym spec)

value-sucw : (w : Word) → value (sucw w) ≡ suc (value w)
value-sucw []      = cong suc (sym (0≡m·0 b))
value-sucw (d ∷ w) =
  value-sucw-step d w (value-sucw w) (fst (dsucΣ d)) (snd (dsucΣ d))

-- 3b.  The odometer never empties a word, and preserves canonicity.

sucw-nonempty : (w : Word) → Σ[ d ∈ Digit ] Σ[ v ∈ Word ] (sucw w ≡ d ∷ v)
sucw-nonempty []      = fone , [] , refl
sucw-nonempty (d ∷ w) = aux (fst (dsucΣ d))
  where
    aux : (r : Digit × Bool) → Σ[ e ∈ Digit ] Σ[ v ∈ Word ] (sucwAux r w ≡ e ∷ v)
    aux (d' , false) = d' , w , refl
    aux (d' , true)  = d' , sucw w , refl

-- Prepending a digit to a *nonempty* canonical word keeps it canonical:
-- canonicity constrains only the most significant end.
canonical-cons : (d : Digit) (u : Word)
               → Σ[ e ∈ Digit ] Σ[ v ∈ Word ] (u ≡ e ∷ v)
               → Canonical u → Canonical (d ∷ u)
canonical-cons d u (e , v , p) c =
  subst (λ z → Canonical (d ∷ z)) (sym p) (subst Canonical p c)

canonical-sucw-step :
    (d : Digit) (w : Word)
  → (Canonical w → Canonical (sucw w))
  → Canonical (d ∷ w)
  → (r : Digit × Bool)
  → suc (toℕ d) ≡ toℕ (fst r) + carryVal (snd r) · b
  → Canonical (sucwAux r w)
canonical-sucw-step d [] ih c (d' , false) spec =
  subst (0 <_) (spec ∙ +-zero (toℕ d')) (suc-≤-suc zero-≤)
canonical-sucw-step d (e ∷ w) ih c (d' , false) spec = c
canonical-sucw-step d w ih c (d' , true) spec =
  canonical-cons d' (sucw w) (sucw-nonempty w) (ih (canonical-tail d w c))

canonical-sucw : (w : Word) → Canonical w → Canonical (sucw w)
canonical-sucw [] c = suc-≤-suc zero-≤
canonical-sucw (d ∷ w) c =
  canonical-sucw-step d w (canonical-sucw w) c (fst (dsucΣ d)) (snd (dsucΣ d))

------------------------------------------------------------------------
-- 4.  digits : ℕ → Word, by iterating the odometer.
------------------------------------------------------------------------

digits : ℕ → Word
digits zero    = []
digits (suc n) = sucw (digits n)

canonical-digits : (n : ℕ) → Canonical (digits n)
canonical-digits zero    = tt
canonical-digits (suc n) = canonical-sucw (digits n) (canonical-digits n)

-- Round trip 1: reading back a generated numeral gives the number.
value-digits : (n : ℕ) → value (digits n) ≡ n
value-digits zero    = refl
value-digits (suc n) = value-sucw (digits n) ∙ cong suc (value-digits n)

------------------------------------------------------------------------
-- 5.  `value` is injective on canonical words.
--
-- This is the uniqueness half of positional notation, and it is what
-- makes the second round trip free.
------------------------------------------------------------------------

-- Uniqueness of Euclidean division, in the only form needed.
digit-split : (d e : Digit) (x y : ℕ)
            → toℕ d + b · x ≡ toℕ e + b · y
            → (toℕ d ≡ toℕ e) × (x ≡ y)
digit-split d e zero zero p =
  (sym (+-zero (toℕ d)) ∙ cong (toℕ d +_) (0≡m·0 b)
    ∙ p ∙ cong (toℕ e +_) (sym (0≡m·0 b)) ∙ +-zero (toℕ e)) , refl
digit-split d e zero (suc y) p =
  Empty.rec (¬m<m (≤<-trans big (snd d)))
  where
    p' : toℕ d ≡ b + (toℕ e + b · y)
    p' = sym (+-zero (toℕ d)) ∙ cong (toℕ d +_) (0≡m·0 b) ∙ p
       ∙ cong (toℕ e +_) (·-suc b y)
       ∙ +-assoc (toℕ e) b (b · y)
       ∙ cong (_+ b · y) (+-comm (toℕ e) b)
       ∙ sym (+-assoc b (toℕ e) (b · y))

    big : b ≤ toℕ d
    big = (toℕ e + b · y) , (+-comm (toℕ e + b · y) b ∙ sym p')
digit-split d e (suc x) zero p =
  Empty.rec (¬m<m (≤<-trans big (snd e)))
  where
    p' : toℕ e ≡ b + (toℕ d + b · x)
    p' = sym (+-zero (toℕ e)) ∙ cong (toℕ e +_) (0≡m·0 b) ∙ sym p
       ∙ cong (toℕ d +_) (·-suc b x)
       ∙ +-assoc (toℕ d) b (b · x)
       ∙ cong (_+ b · x) (+-comm (toℕ d) b)
       ∙ sym (+-assoc b (toℕ d) (b · x))

    big : b ≤ toℕ e
    big = (toℕ d + b · x) , (+-comm (toℕ d + b · x) b ∙ sym p')
digit-split d e (suc x) (suc y) p = fstEq , cong suc sndEq
  where
    shuffle : (a c z : ℕ) → a + (c + z) ≡ c + (a + z)
    shuffle a c z = +-assoc a c z ∙ cong (_+ z) (+-comm a c) ∙ sym (+-assoc c a z)

    p' : b + (toℕ d + b · x) ≡ b + (toℕ e + b · y)
    p' = sym (shuffle (toℕ d) b (b · x))
       ∙ cong (toℕ d +_) (sym (·-suc b x))
       ∙ p
       ∙ cong (toℕ e +_) (·-suc b y)
       ∙ shuffle (toℕ e) b (b · y)

    recursiveSplit : (toℕ d ≡ toℕ e) × (x ≡ y)
    recursiveSplit = digit-split d e x y (inj-m+ {m = b} p')

    fstEq : toℕ d ≡ toℕ e
    fstEq = fst recursiveSplit

    sndEq : x ≡ y
    sndEq = snd recursiveSplit

-- A canonical nonempty word has positive value.
canonical-pos : (d : Digit) (w : Word) → Canonical (d ∷ w)
              → Σ[ m ∈ ℕ ] value (d ∷ w) ≡ suc m
canonical-pos d [] c =
  fst c + b · 0 , cong (_+ b · 0) (sym (snd c) ∙ +-comm (fst c) 1)
canonical-pos d (e ∷ w) c = suc (k + (toℕ d + b · m)) , veq
  where
    ih : Σ[ m ∈ ℕ ] value (e ∷ w) ≡ suc m
    ih = canonical-pos e w c

    m : ℕ
    m = fst ih

    veq : toℕ d + b · value (e ∷ w) ≡ suc (suc (k + (toℕ d + b · m)))
    veq = cong (λ v → toℕ d + b · v) (snd ih)
        ∙ cong (toℕ d +_) (·-suc b m)
        ∙ +-assoc (toℕ d) b (b · m)
        ∙ cong (_+ b · m) (+-comm (toℕ d) b)
        ∙ sym (+-assoc b (toℕ d) (b · m))

value-inj : (w w' : Word) → Canonical w → Canonical w'
          → value w ≡ value w' → w ≡ w'
value-inj [] [] _ _ _ = refl
value-inj [] (e ∷ w') _ c' p =
  Empty.rec (znots (p ∙ snd (canonical-pos e w' c')))
value-inj (d ∷ w) [] c _ p =
  Empty.rec (znots (sym p ∙ snd (canonical-pos d w c)))
value-inj (d ∷ w) (e ∷ w') c c' p =
  cong₂ _∷_ (Fin-fst-≡ (fst sp))
            (value-inj w w' (canonical-tail d w c) (canonical-tail e w' c') (snd sp))
  where
    sp : (toℕ d ≡ toℕ e) × (value w ≡ value w')
    sp = digit-split d e (value w) (value w') p

-- Round trip 2, now free.
digits-value : (w : Word) → Canonical w → digits (value w) ≡ w
digits-value w c =
  value-inj (digits (value w)) w (canonical-digits (value w)) c (value-digits (value w))

------------------------------------------------------------------------
-- 6.  The equivalence, constructed.
------------------------------------------------------------------------

valueC : CanWord → ℕ
valueC (w , _) = value w

digitsC : ℕ → CanWord
digitsC n = digits n , canonical-digits n

ℕ≃CanWord : ℕ ≃ CanWord
ℕ≃CanWord = isoToEquiv (iso digitsC valueC sec ret)
  where
    sec : (x : CanWord) → digitsC (valueC x) ≡ x
    sec (w , c) = Σ≡Prop isPropCanonical (digits-value w c)

    ret : (n : ℕ) → valueC (digitsC n) ≡ n
    ret n = value-digits n

-- The genuine path, produced by univalence.
ℕ≡CanWord : ℕ ≡ CanWord
ℕ≡CanWord = ua ℕ≃CanWord
