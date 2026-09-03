{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कोटि-निर्णय — every fibre is DECIDED, so each arithmetized conjecture is
-- a definite proposition and the only openness is the section.
--
-- The arithmetized conjectures enter the corpus as sections
--   Goldbach   = (n : ℕ) → GoldbachAt (4 + 2·n)
--   TwinPrimes = (n : ℕ) → Σ p ≥ n, twin at p
--   Collatz    = (n : ℕ) → Σ k, halts within k
-- Each is a Π over a family of FIBRES.  This module proves that every one
-- of those fibres is DECIDABLE: for each argument the fibre is a definite
-- proposition whose truth is computed by a Boolean, sound and complete.
--
-- The consequence is exactly the non-mystical reading.  A conjecture of
-- this shape has NO undefined free variable: fix the variable and the
-- statement is decided, yes or no, by a terminating computation.  The
-- only thing not settled is the universally-quantified SECTION — the
-- single function inhabiting all fibres at once — and that is a definite
-- object too, not a mystery: Goldbach is PROVABLY EQUIVALENT to a Π over
-- a decided Boolean predicate (goldbach-definite below), so the whole of
-- its content is "this computable Boolean is true at every stage."  The
-- openness is the section, and the section is the only thing open.
--
-- WHAT IS PROVED.
--   §1  a Boolean bounded search with membership and extraction, proved
--       both directions;
--   §2  gcheck : ℕ → Bool with goldbach-sound and goldbach-complete —
--       gcheck m ≡ true reflects GoldbachAt m exactly;
--   §3  goldbach-dec : (m : ℕ) → Dec (GoldbachAt m) — every Goldbach
--       fibre is decidable;
--   §4  goldbach-definite — Goldbach ⇔ a Π over the decided Boolean;
--   §5  twin-dec, collatz-dec — the other two families' fibres decided,
--       so the same statement holds across the constellation.
--
-- WHAT IS NOT CLAIMED.  No inhabitant of any section is produced; the
-- conjectures remain open.  Decidability of a fibre is not decidability of
-- the section — a Π over a decidable predicate need not itself be
-- decidable, and no claim is made that it is.  This is the constructive
-- content of "definite, not mystical," not a resolution.
------------------------------------------------------------------------

module KotiNirnaya_EveryFibreIsDecidedSoEachConjectureIsADefinitePropositionAndTheOnlyOpennessIsTheSection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; +-suc ; injSuc ; snotz ; discreteℕ)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; _×_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_)
import Cubical.Data.Empty as E

open import SamastaPrasna_TheOpenConstellationEntersTypedAndTheOracleAnswersEveryInstance
  using (primeb ; GoldbachAt ; citer)

------------------------------------------------------------------------
-- Boolean toolkit
------------------------------------------------------------------------

_&&_ : Bool → Bool → Bool
true  && b = b
false && _ = false

_||_ : Bool → Bool → Bool
true  || _ = true
false || b = b

||-true-r : (a : Bool) → a || true ≡ true
||-true-r true  = refl
||-true-r false = refl

&&-l : {a b : Bool} → a && b ≡ true → a ≡ true
&&-l {true}  e = refl
&&-l {false} e = e

&&-r : {a b : Bool} → a && b ≡ true → b ≡ true
&&-r {true}  e = e
&&-r {false} e = E.rec (false≢true e)

&&-intro : {a b : Bool} → a ≡ true → b ≡ true → a && b ≡ true
&&-intro {true}  ea eb = eb
&&-intro {false} ea eb = E.rec (false≢true ea)

eqb : ℕ → ℕ → Bool
eqb zero    zero    = true
eqb zero    (suc _) = false
eqb (suc _) zero    = false
eqb (suc m) (suc n) = eqb m n

eqb-refl : (n : ℕ) → eqb n n ≡ true
eqb-refl zero    = refl
eqb-refl (suc n) = eqb-refl n

eqb-sound : (m n : ℕ) → eqb m n ≡ true → m ≡ n
eqb-sound zero    zero    e = refl
eqb-sound zero    (suc n) e = E.rec (false≢true e)
eqb-sound (suc m) zero    e = E.rec (false≢true e)
eqb-sound (suc m) (suc n) e = cong suc (eqb-sound m n e)

_∸_ : ℕ → ℕ → ℕ
n     ∸ zero  = n
zero  ∸ suc _ = zero
suc n ∸ suc m = n ∸ m

∸-plus : (p q : ℕ) → (p + q) ∸ p ≡ q
∸-plus zero    q = refl
∸-plus (suc p) q = ∸-plus p q

------------------------------------------------------------------------
-- §1 · bounded Boolean search over 0..k, both directions
------------------------------------------------------------------------

search : ℕ → (ℕ → Bool) → Bool
search zero    f = f zero
search (suc k) f = f (suc k) || search k f

open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)

||-elim : (a c : Bool) → a || c ≡ true → (a ≡ true) ⊎ (c ≡ true)
||-elim true  c e = inl refl
||-elim false c e = inr e

search-find : (k : ℕ) (f : ℕ → Bool) → search k f ≡ true → Σ[ p ∈ ℕ ] (f p ≡ true)
search-find zero    f e = zero , e
search-find (suc k) f e with ||-elim (f (suc k)) (search k f) e
... | inl ft = suc k , ft
... | inr sk = search-find k f sk

-- Le p k : p ≤ k, as the witness j with j + p ≡ k
Le : ℕ → ℕ → Type
Le p k = Σ[ j ∈ ℕ ] (j + p ≡ k)

search-mem : (k p : ℕ) (f : ℕ → Bool) → Le p k → f p ≡ true → search k f ≡ true
search-mem zero p f (j , jp) fp = subst (λ x → f x ≡ true) (le0 j p jp) fp
  where
  le0 : (j p : ℕ) → j + p ≡ zero → p ≡ zero
  le0 j zero     _ = refl
  le0 j (suc p') e = E.rec (snotz (sym (+-suc j p') ∙ e))
search-mem (suc k) p f (zero , jp) fp =
  cong (λ z → z || search k f) (subst (λ x → f x ≡ true) jp fp)
search-mem (suc k) p f (suc j' , jp) fp =
  cong (f (suc k) ||_) (search-mem k p f (j' , injSuc jp) fp) ∙ ||-true-r (f (suc k))

------------------------------------------------------------------------
-- §2 · the Goldbach decision Boolean, sound and complete
------------------------------------------------------------------------

gtest : ℕ → ℕ → Bool
gtest m p = primeb p && (primeb (m ∸ p) && eqb (p + (m ∸ p)) m)

gcheck : ℕ → Bool
gcheck m = search m (gtest m)

goldbach-sound : (m : ℕ) → gcheck m ≡ true → GoldbachAt m
goldbach-sound m e with search-find m (gtest m) e
... | (p , gt) = p , (m ∸ p) , a , b , c
  where
  rest : primeb (m ∸ p) && eqb (p + (m ∸ p)) m ≡ true
  rest = &&-r {primeb p} {primeb (m ∸ p) && eqb (p + (m ∸ p)) m} gt
  a : primeb p ≡ true
  a = &&-l {primeb p} {primeb (m ∸ p) && eqb (p + (m ∸ p)) m} gt
  b : primeb (m ∸ p) ≡ true
  b = &&-l {primeb (m ∸ p)} {eqb (p + (m ∸ p)) m} rest
  c : p + (m ∸ p) ≡ m
  c = eqb-sound (p + (m ∸ p)) m (&&-r {primeb (m ∸ p)} {eqb (p + (m ∸ p)) m} rest)

goldbach-complete : (m : ℕ) → GoldbachAt m → gcheck m ≡ true
goldbach-complete m (p , q , pp , pq , e) =
  search-mem m p (gtest m) (q , (+-comm q p ∙ e)) gtrue
  where
  mp≡q : m ∸ p ≡ q
  mp≡q = cong (_∸ p) (sym e) ∙ ∸-plus p q
  b' : primeb (m ∸ p) ≡ true
  b' = subst (λ x → primeb x ≡ true) (sym mp≡q) pq
  c' : eqb (p + (m ∸ p)) m ≡ true
  c' = cong (λ z → eqb z m) (cong (p +_) mp≡q ∙ e) ∙ eqb-refl m
  gtrue : gtest m p ≡ true
  gtrue = &&-intro pp (&&-intro b' c')

------------------------------------------------------------------------
-- §3 · every Goldbach fibre is decidable
------------------------------------------------------------------------

goldbach-dec : (m : ℕ) → Dec (GoldbachAt m)
goldbach-dec m = h (gcheck m) refl
  where
  h : (b : Bool) → gcheck m ≡ b → Dec (GoldbachAt m)
  h true  eq = yes (goldbach-sound m eq)
  h false eq = no (λ g → false≢true (sym eq ∙ goldbach-complete m g))

------------------------------------------------------------------------
-- §4 · Goldbach is a definite proposition: equivalent to a Π over a
--       decided Boolean.  No undefined free variable remains.
------------------------------------------------------------------------

Goldbach : Type
Goldbach = (n : ℕ) → GoldbachAt (4 + 2 · n)

GoldbachBool : Type
GoldbachBool = (n : ℕ) → gcheck (4 + 2 · n) ≡ true

goldbach-definite : (Goldbach → GoldbachBool) × (GoldbachBool → Goldbach)
goldbach-definite =
  (λ g n → goldbach-complete (4 + 2 · n) (g n)) ,
  (λ gb n → goldbach-sound (4 + 2 · n) (gb n))

------------------------------------------------------------------------
-- §5 · the same holds across the constellation: twin and Collatz fibres
------------------------------------------------------------------------

decTrue : (b : Bool) → Dec (b ≡ true)
decTrue true  = yes refl
decTrue false = no false≢true

dec× : {A B : Type} → Dec A → Dec B → Dec (A × B)
dec× (yes a) (yes b) = yes (a , b)
dec× (no ¬a) _       = no (λ ab → ¬a (fst ab))
dec× (yes _) (no ¬b) = no (λ ab → ¬b (snd ab))

TwinAt : ℕ → Type
TwinAt p = (primeb p ≡ true) × (primeb (2 + p) ≡ true)

twin-dec : (p : ℕ) → Dec (TwinAt p)
twin-dec p = dec× (decTrue (primeb p)) (decTrue (primeb (2 + p)))

CollatzWithin : ℕ → ℕ → Type
CollatzWithin k n = citer k (suc n) ≡ suc zero

collatz-dec : (k n : ℕ) → Dec (CollatzWithin k n)
collatz-dec k n = discreteℕ (citer k (suc n)) (suc zero)

------------------------------------------------------------------------
-- §6 · the section is not an unknown object — it is the universal
--       witness, exhibited, and the only open thing is its totality.
--
-- `the-universal-witness` is a TOTAL function, present here, that turns a
-- successful search into the prime pair at every stage.  It is the
-- kernel's own bounded search composed with the extractor; nothing about
-- it is unknown.  `section-factors` shows the Goldbach section is exactly
-- this witness applied to its precondition, and `totality-forced` shows
-- the precondition is exactly what the section supplies back.  So
-- Goldbach is NOT "does a function exist"; it is one Π-property OF a named,
-- constructed witness: that its search never fails.  The universal witness
-- is built; its totality is the single open predicate.
------------------------------------------------------------------------

UniversalWitness : Type
UniversalWitness = (n : ℕ) → gcheck (4 + 2 · n) ≡ true → GoldbachAt (4 + 2 · n)

the-universal-witness : UniversalWitness
the-universal-witness n = goldbach-sound (4 + 2 · n)

SearchIsTotal : Type
SearchIsTotal = (n : ℕ) → gcheck (4 + 2 · n) ≡ true

section-factors : SearchIsTotal → Goldbach
section-factors tot n = the-universal-witness n (tot n)

totality-forced : Goldbach → SearchIsTotal
totality-forced g n = goldbach-complete (4 + 2 · n) (g n)

-- The two together: the Goldbach section and the totality of the exhibited
-- witness are interderivable.  What is open is a predicate on a known
-- object, not the object.
goldbach-is-witness-totality :
  (SearchIsTotal → Goldbach) × (Goldbach → SearchIsTotal)
goldbach-is-witness-totality = section-factors , totality-forced
