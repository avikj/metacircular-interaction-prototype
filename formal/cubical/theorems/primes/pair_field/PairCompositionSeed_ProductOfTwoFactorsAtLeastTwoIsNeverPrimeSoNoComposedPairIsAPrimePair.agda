{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PairCompositionSeed_ProductOfTwoFactorsAtLeastTwoIsNeverPrimeSoNoComposedPairIsAPrimePair
--
-- Closes the seed left open in PairComposition, which states (header,
-- "SEED"):
--
--   "SEED (stated, not proved here): for u₁,v₁,u₂,v₂ ≥ 2 every composed
--    leg is a product of two factors ≥ 2, hence composite; so no
--    composite of two ≥2-legged pairs is ever a prime pair.  Primality
--    is exactly the condition of falling out of every proper
--    composition.  The general lemma is a two-line
--    ¬isPrime-of-product; only the finite witness is checked below."
--
-- WHAT IS PROVED.
--
--   §1  The propositional two-liner, against the firm-number predicate
--       दृढम् of the Drdha module (p firm ⇔ 1 < p and every divisor is
--       1 or p):
--
--         ¬prime-product : 1 < a → 1 < b → ¬ दृढम् (a · b)
--
--       since a ∣ a · b, a ≢ 1 (a > 1) and a ≢ a · b (a < a · b).
--
--   §2–§3  The Boolean form PairComposition actually uses.  Its tester
--       isPrime is built from divides, whose countdown kernel divH and
--       whose divisor scan noDiv are `private`.  A specification of the
--       kernel is proved from its defining clauses:
--
--         divH*-shift      : divH* c d (c + n) ≡ divH* zero d n
--         divides-multiple : divides (suc d) (m · suc d) ≡ true
--         divides-product  : divides (suc d) (suc d · b) ≡ true
--         noDiv*-false     : 1 < d → d ≤ k → divides d n ≡ true
--                            → noDiv* k n ≡ false
--         isPrime-false    : 1 < d → d < n → divides d n ≡ true
--                            → isPrime n ≡ false
--         isPrime-product  : 1 < a → 1 < b → isPrime (a · b) ≡ false
--
--   §4  The seed itself: for pairs whose four legs are all ≥ 2, both
--       legs of compose p q and of compose' p q test false, hence
--       neither composite is a prime pair (Boolean and propositional
--       readings).  PairComposition's four refl witnesses
--       isPrime 15/35/21/25 ≡ false are re-derived as instances.
--
-- HOW THE PRIVATE KERNEL IS REACHED.  divH and noDiv cannot be named
-- from outside PairComposition.  Definitional unfolding does work on
-- closed numerals (that is how the module's own witnesses check), but
-- it does NOT bridge to a textual copy on open terms: for a variable n,
-- `divides (suc d) n` is the stuck term `divH zero d n`, and a copy
-- divH' zero d n is a different stuck head, so `refl` is rejected
-- ("PairComposition.divH 0 d n != divH' 0 d n").  No induction on n can
-- repair this from outside, because the intermediate countdown states
-- divH c d n with 0 < c < d are not denotable through `divides` at all.
-- Instead §2 recovers the internal names themselves, with the safe
-- reflection primitives: getDefinition (quote divides) returns the
-- clauses of divides, the last of which is `divides (suc d) n = divH
-- zero d n`, and its body is headed by the Name of divH; likewise the
-- last clause of isPrime is headed by noDiv.
-- Binding those Names as divH* and noDiv* gives functions that are
-- definitionally the module's own helpers, so the two bridges
--
--         divides (suc d) n           ≡ divH* zero d n
--         isPrime (suc (suc k))       ≡ noDiv* (suc k) (suc (suc k))
--
-- hold by refl for OPEN d, n, k, and the kernel's clauses fire on
-- divH*/noDiv* under pattern matching.  Nothing is postulated: if the
-- recovered Name were wrong, those two refls would fail to check.
--
-- WHAT IS NOT PROVED.  Nothing from the seed is left open.  The
-- converse direction of the tester's specification (divides d n ≡ true
-- → d ∣ n, and isPrime n ≡ true → दृढम् n) is not needed for the seed
-- and is not attempted here.
------------------------------------------------------------------------

module PairCompositionSeed_ProductOfTwoFactorsAtLeastTwoIsNeverPrimeSoNoComposedPairIsAPrimePair where

open import Cubical.Foundations.Prelude hiding (comp)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-left)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_ ; and-zeroʳ ; false≢true ; isSetBool)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr) renaming (rec to ⊎-rec)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.Unit using (Unit)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Relation.Nullary using (¬_)
open import Agda.Builtin.Reflection
  using (Term ; Name ; TC ; Clause ; Definition ; def ; clause ; function
        ; bindTC ; returnTC ; getDefinition ; unify ; typeError ; strErr ; termErr ; nameErr)

open import PairComposition
open import Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIsDecidedByDivision
  using (दृढम्)

------------------------------------------------------------------------
-- §1  The propositional two-liner
------------------------------------------------------------------------

-- a < a · b whenever a ≥ 1 and b ≥ 2:  a · b = a + (a + a · b') ≥ a + 1.
<-·ᵣ : (a b : ℕ) → 1 ≤ a → 1 < b → a < a · b
<-·ᵣ a zero          _   1<0 = ⊥-rec (¬-<-zero 1<0)
<-·ᵣ a (suc zero)    _   1<1 = ⊥-rec (¬m<m 1<1)
<-·ᵣ a (suc (suc b)) 1≤a _   =
  subst (suc a ≤_) (sym (·-suc a (suc b) ∙ cong (a +_) (·-suc a b)))
        (subst (_≤ a + (a + a · b)) (+-comm a 1)
               (≤-k+ {k = a} (≤-trans 1≤a (a · b , +-comm (a · b) a))))

-- The two-liner: a divides a · b, and a is neither 1 nor a · b.
¬prime-product : (a b : ℕ) → 1 < a → 1 < b → ¬ दृढम् (a · b)
¬prime-product a b 1<a 1<b (_ , only) with only a (∣-left b)
... | inl a≡1  = <→≢ 1<a (sym a≡1)
... | inr a≡ab = <→≢ (<-·ᵣ a b (<-weaken 1<a) 1<b) a≡ab

------------------------------------------------------------------------
-- §2  Reaching the private kernel of the Boolean tester
------------------------------------------------------------------------

private
  -- head symbol of a clause body; anything else is a loud failure,
  -- never a silent default
  headName : Term → TC Name
  headName (def f _) = returnTC f
  headName t         = typeError (strErr "no head symbol in " ∷ termErr t ∷ [])

  -- body of the last clause of a function definition
  lastBody : List Clause → TC Term
  lastBody (clause _ _ t ∷ []) = returnTC t
  lastBody (_ ∷ cs)            = lastBody cs
  lastBody []                  = typeError (strErr "no clauses" ∷ [])

  -- the head symbol of the last clause of the function named `nm`:
  -- `divides (suc d) n = divH zero d n` and
  -- `isPrime (suc (suc k)) = noDiv (suc k) (suc (suc k))`
  fish : Name → Term → TC Unit
  fish nm hole =
    bindTC (getDefinition nm) λ where
      (function cs) → bindTC (lastBody cs) λ t →
                      bindTC (headName t) λ f → unify hole (def f [])
      _             → typeError (strErr "not a function: " ∷ nameErr nm ∷ [])

macro
  divHName : Term → TC Unit
  divHName = fish (quote divides)

  noDivName : Term → TC Unit
  noDivName = fish (quote isPrime)

-- The module's own countdown kernel and divisor scan, by their
-- internal names.  Both are definitionally PairComposition's helpers.
divH* : ℕ → ℕ → ℕ → Bool
divH* = divHName

noDiv* : ℕ → ℕ → Bool
noDiv* = noDivName

-- The two bridges, on open terms, by refl.
divides≡divH* : (d n : ℕ) → divides (suc d) n ≡ divH* zero d n
divides≡divH* d n = refl

isPrime≡noDiv* : (k : ℕ) → isPrime (suc (suc k)) ≡ noDiv* (suc k) (suc (suc k))
isPrime≡noDiv* k = refl

-- The kernel's clauses, visible on divH*.
divH*-zero : (d : ℕ) → divH* zero d zero ≡ true
divH*-zero d = refl

divH*-step : (c d n : ℕ) → divH* (suc c) d (suc n) ≡ divH* c d n
divH*-step c d n = refl

divH*-wrap : (d n : ℕ) → divH* zero d (suc n) ≡ divH* d d n
divH*-wrap d n = refl

------------------------------------------------------------------------
-- §3  Specification of the tester
------------------------------------------------------------------------

-- Countdown semantics: c steps of countdown consume c of the input.
divH*-shift : (c d n : ℕ) → divH* c d (c + n) ≡ divH* zero d n
divH*-shift zero    d n = refl
divH*-shift (suc c) d n = divH*-shift c d n

-- Hence the tester accepts every multiple of suc d.
divides-multiple : (d m : ℕ) → divides (suc d) (m · suc d) ≡ true
divides-multiple d zero    = refl
divides-multiple d (suc m) = divH*-shift d d (m · suc d) ∙ divides-multiple d m

divides-product : (d b : ℕ) → divides (suc d) (suc d · b) ≡ true
divides-product d b = cong (divides (suc d)) (·-comm (suc d) b) ∙ divides-multiple d b

-- The scan answers false as soon as one d with 2 ≤ d ≤ k divides n.
noDiv*-false : (k n d : ℕ) → 1 < d → d ≤ k → divides d n ≡ true → noDiv* k n ≡ false
noDiv*-false zero          n d 1<d d≤k _  = ⊥-rec (¬-<-zero (<≤-trans 1<d d≤k))
noDiv*-false (suc zero)    n d 1<d d≤k _  = ⊥-rec (¬m<m (<≤-trans 1<d d≤k))
noDiv*-false (suc (suc k)) n d 1<d d≤k dv =
  ⊎-rec (λ d<ssk → cong (not (divides (suc (suc k)) n) and_)
                        (noDiv*-false (suc k) n d 1<d (pred-≤-pred d<ssk) dv)
                   ∙ and-zeroʳ _)
        (λ d≡ssk → cong (λ b → not b and noDiv* (suc k) n)
                        (subst (λ z → divides z n ≡ true) d≡ssk dv))
        (≤-split d≤k)

-- A proper divisor ≥ 2 that the tester sees makes isPrime answer false.
isPrime-false : (n d : ℕ) → 1 < d → d < n → divides d n ≡ true → isPrime n ≡ false
isPrime-false zero          d 1<d d<n _  = ⊥-rec (¬-<-zero d<n)
isPrime-false (suc zero)    d 1<d d<n _  = ⊥-rec (¬m<m (<-trans 1<d d<n))
isPrime-false (suc (suc k)) d 1<d d<n dv =
  noDiv*-false (suc k) (suc (suc k)) d 1<d (pred-≤-pred d<n) dv

-- The Boolean two-liner: a product of two factors ≥ 2 tests false.
isPrime-product : (a b : ℕ) → 1 < a → 1 < b → isPrime (a · b) ≡ false
isPrime-product zero    b 1<a _   = ⊥-rec (¬-<-zero 1<a)
isPrime-product (suc d) b 1<a 1<b =
  isPrime-false (suc d · b) (suc d) 1<a (<-·ᵣ (suc d) b (<-weaken 1<a) 1<b)
                (divides-product d b)

------------------------------------------------------------------------
-- §4  The seed
------------------------------------------------------------------------

-- Both legs at least 2.
Legs≥2 : Pair → Type₀
Legs≥2 (u , v) = (1 < u) × (1 < v)

-- A prime pair, in the module's Boolean sense, and propositionally.
PrimePair : Pair → Type₀
PrimePair (u , v) = (isPrime u ≡ true) × (isPrime v ≡ true)

FirmPair : Pair → Type₀
FirmPair (u , v) = दृढम् u × दृढम् v

-- Straight composition: both legs test false …
seed : (p q : Pair) → Legs≥2 p → Legs≥2 q
     → (isPrime (fst (compose p q)) ≡ false) × (isPrime (snd (compose p q)) ≡ false)
seed (u₁ , v₁) (u₂ , v₂) (hu₁ , hv₁) (hu₂ , hv₂) =
  isPrime-product u₁ u₂ hu₁ hu₂ , isPrime-product v₁ v₂ hv₁ hv₂

-- … and so do both legs of the twisted composition.
seed' : (p q : Pair) → Legs≥2 p → Legs≥2 q
      → (isPrime (fst (compose' p q)) ≡ false) × (isPrime (snd (compose' p q)) ≡ false)
seed' (u₁ , v₁) (u₂ , v₂) (hu₁ , hv₁) (hu₂ , hv₂) =
  isPrime-product u₁ v₂ hu₁ hv₂ , isPrime-product v₁ u₂ hv₁ hu₂

-- No composite of two ≥2-legged pairs is a prime pair.
notPrimePair-compose : (p q : Pair) → Legs≥2 p → Legs≥2 q → ¬ PrimePair (compose p q)
notPrimePair-compose p q hp hq (l , _) = false≢true (sym (fst (seed p q hp hq)) ∙ l)

notPrimePair-compose' : (p q : Pair) → Legs≥2 p → Legs≥2 q → ¬ PrimePair (compose' p q)
notPrimePair-compose' p q hp hq (l , _) = false≢true (sym (fst (seed' p q hp hq)) ∙ l)

-- The same, propositionally, against दृढम्.
notFirmPair-compose : (p q : Pair) → Legs≥2 p → Legs≥2 q → ¬ FirmPair (compose p q)
notFirmPair-compose (u₁ , v₁) (u₂ , v₂) (hu₁ , _) (hu₂ , _) (l , _) =
  ¬prime-product u₁ u₂ hu₁ hu₂ l

notFirmPair-compose' : (p q : Pair) → Legs≥2 p → Legs≥2 q → ¬ FirmPair (compose' p q)
notFirmPair-compose' (u₁ , v₁) (u₂ , v₂) (hu₁ , _) (_ , hv₂) (l , _) =
  ¬prime-product u₁ v₂ hu₁ hv₂ l

------------------------------------------------------------------------
-- §5  The module's four refl witnesses, as instances of the seed
------------------------------------------------------------------------

legs35 : Legs≥2 p35
legs35 = (1 , refl) , (3 , refl)

legs57 : Legs≥2 p57
legs57 = (3 , refl) , (5 , refl)

-- compose p35 p57 = (15 , 35), compose' p35 p57 = (21 , 25), by refl,
-- so these types are definitionally PairComposition's notPrime15/35/21/25.
notPrime15-seed : isPrime 15 ≡ false
notPrime15-seed = fst (seed p35 p57 legs35 legs57)

notPrime35-seed : isPrime 35 ≡ false
notPrime35-seed = snd (seed p35 p57 legs35 legs57)

notPrime21-seed : isPrime 21 ≡ false
notPrime21-seed = fst (seed' p35 p57 legs35 legs57)

notPrime25-seed : isPrime 25 ≡ false
notPrime25-seed = snd (seed' p35 p57 legs35 legs57)

-- And they agree with the module's own refl witnesses (Bool is a set).
notPrime15-agree : notPrime15-seed ≡ notPrime15
notPrime15-agree = isSetBool _ _ _ _
