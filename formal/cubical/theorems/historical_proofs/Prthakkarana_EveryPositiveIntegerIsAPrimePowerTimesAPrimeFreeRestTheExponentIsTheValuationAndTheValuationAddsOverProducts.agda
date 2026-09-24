{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- पृथक्करणम् — the p-adic splitting, as a composition of what is there.
--
-- (separation: every positive integer is a power of the firm number p
--  times a rest that p does not divide; the exponent is the valuation,
--  uniquely; and the valuation adds over products.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE ABSENCE THIS CLOSES, IN THE WORDS OF THE MODULES THAT RECORD IT.
--
-- Three modules of theorems/number record the same missing thing —
-- prime-power / valuation machinery — and each says so in its own
-- ledger:
--
--   `SieveRoughBridge` (under "Nothing is proved about the visible
--   state `q`"):
--       "The valuations `(v₂ , v₃ , v₅)` and the factorisation
--        `n ≡ smooth n · rough n` would need the exponent component of
--        `stripF`, which §3 deliberately does not track: the bridge does
--        not use it, and tracking it would drag in `pow` and a second
--        induction for no gain here."
--
--   `WalkInduction` (under "WHAT IS WEAKENED, honestly", on the claim
--   that the installs are exactly the ordered prime powers):
--       "— is NOT attempted.  It needs prime-power machinery beyond
--        WalkForcing's \"no proper coprime splitting\"."
--
--   `CoprimeSplitting`: its §"WHAT REMAINS OPEN" lists two items, and
--   its own 2026-08-15/18 audit marks both CLOSED (the WalkBridge
--   composition and `PrimalityDecision.decIsPrime`), so that section
--   records no open valuation item.  What the file does record, in
--   "WHAT IS PROVED" (A), is that its p-part is "a = p^e is the full
--   p-part of n and b its p-free cofactor, both produced by
--   `WalkJumps.strip` -- the fuel recursion … so no valuation function
--   and no decidable divisibility enters here".  That is, the exponent
--   there is a fuel recursion's output, related to no valuation because
--   the corpus had none.
--
-- Since those ledgers were written, the corpus acquired unique
-- factorisation in theorems/historical_proofs:
--
--   `Drdha_…`  : दृढम् (= prime), वधः (list product), सर्वे, _सदस्यः_,
--                विभाजनम् (every n ≥ 1 is the product of a list of firm
--                numbers), युक्लिड-वाक्यम् (Euclid VII.30), अन्तर्भावः (a
--                firm p dividing the product of a firm list occurs in it).
--   `Ekatva_…` : एकत्वम् (two firm lists with one product are a Perm),
--                एकत्व-गणना (hence same count of every p), and the
--                valuation मानम् p n pos := count of p in Drdha's list,
--                well defined by मान-निश्चयः.
--
-- This module is the composition of those two with a filter and a
-- replicate on lists.  Nothing new is assumed.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED.
--
--   §१  शेषः p L — L with every occurrence of p struck out (a filter by
--       `discreteℕ`), and the product identity, by induction on L:
--           वध-शेषः : वधः L ≡ p ^ गणना p L · वधः (शेषः p L)
--       together with: शेषः preserves सर्वे, p is not a member of
--       शेषः p L, and hence (by अन्तर्भावः) p ∤ वधः (शेषः p L) when L
--       is firm.
--
--   §२  पृथक्करणम् — EXISTENCE of the p-adic splitting.  For firm p and
--       n ≥ 1:
--           Σ[ m ∈ ℕ ] ((n ≡ p ^ मानम् p n pos · m) × (¬ (p ∣ m)))
--       with m := वधः (शेषः p L) for L Drdha's list of n.  The exponent
--       is LITERALLY Ekatva's valuation, not a new counter.
--
--   §३  मान-एकत्वम् — UNIQUENESS of the exponent.  If n ≡ p ^ e · m with
--       ¬ (p ∣ m) then e ≡ मानम् p n pos.  Proof: expand m into its own
--       firm list M (Drdha §५); पुनः e p ++ M is a firm list with product
--       n, so मान-निश्चयः gives its p-count, e + गणना p M, equals the
--       valuation; and गणना p M ≡ 0 because p ∈ M would give p ∣ m
--       (सदस्य-भाजकः).  No cancellation of p's is needed for this half.
--       पृथक्करण-एकत्वम् adds that m is unique too, by one cancellation
--       of p ^ e (which is positive since p > 1).
--       Corollaries: मान-अभाज्यः (p ∤ n → मानम् p n ≡ 0) and मान-घातः
--       (मानम् p (p ^ e) ≡ e).
--
--   §४  मान-गुणनम् — the valuation is MULTIPLICATIVE-TO-ADDITIVE:
--           मानम् p (a · b) posab ≡ मानम् p a posa + मानम् p b posb
--       by एकत्व-गणना (through मान-निश्चयः) on the concatenation of the
--       two Drdha lists, using वध-++ and सर्वे-++, and गणना-++.
--
--   §५  दृढ? — a bonus that costs four lines given Drdha's अन्वेषणम्:
--       firmness of n > 1 is DECIDABLE.  Used only to make the kernel
--       tests below honest (the prime hypotheses are computed, not
--       hand-built).
--
--   §६  परीक्षा — the kernel runs the splitting: for n = 12 the p-free
--       rests at p = 2, 3, 5 are 3, 4, 12 by refl, and the valuation
--       identity 2 = मानम् 2 12 = मानम् 2 4 + मानम् 2 3 is refl on both
--       sides.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS **NOT** CLAIMED.
--
--   · दृढम् is Drdha's predicate ("1 < p and every divisor is 1 or p"),
--     and IsPrime / IsPrimePower are theorems/number's.  This module does
--     NOT identify them, and so does NOT literally discharge the three
--     ledgers above in their own vocabulary: it supplies the valuation
--     and the splitting THEY say are missing, phrased over दृढम्.  The
--     bridge दृढम् p ↔ IsPrime p is a separate (easy) module and is not
--     written here.
--   · The SIMULTANEOUS splitting n ≡ smooth n · rough n over several
--     primes at once (the (v₂ , v₃ , v₅) of SieveRoughBridge) is not
--     stated; it is three applications of §२ and §४, and the extra
--     bookkeeping is not done here.
--   · Nothing is said about the walk's installs (WalkInduction); this is
--     the arithmetic it asks for, not the induction along the walk.
--   · `मानम् p n pos` for p NOT firm is a count in a list of firm numbers
--     and is therefore 0; that is true but not stated, since the
--     valuation is meaningful only at firm p.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes, no TERMINATING pragma.
------------------------------------------------------------------------

module Prthakkarana_EveryPositiveIntegerIsAPrimePowerTimesAPrimeFreeRestTheExponentIsTheValuationAndTheValuationAddsOverProducts where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; m∣sn→m≤sn)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr) renaming (rec to ⊎-rec)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIsDecidedByDivision
  using (दृढम् ; वधः ; सर्वे ; _सदस्यः_ ; विभाजनम् ; अन्तर्भावः ; सदस्य-भाजकः
       ; वध-++ ; सर्वे-++ ; दृढत्वम् ; अन्वेषणम्)
open import Ekatva_TheFirmFactorisationIsUniqueTwoPrimeListsWithOneProductAreAPermutationSoTheValuationIsWellDefinedAndPermIsExactlySameCount
  using (module Bahulya ; मानम् ; मान-निश्चयः)

open Bahulya discreteℕ using (दश ; दश-स्वयम् ; एकः ; गणना)

------------------------------------------------------------------------
-- १ · शेषः — the list with every p struck out, and the product identity
------------------------------------------------------------------------

चयनम् : (p x : ℕ) → Dec (p ≡ x) → List ℕ → List ℕ
चयनम् p x (yes _) r = r
चयनम् p x (no  _) r = x ∷ r

शेषः : ℕ → List ℕ → List ℕ
शेषः p []       = []
शेषः p (x ∷ xs) = चयनम् p x (discreteℕ p x) (शेषः p xs)

-- the product of L is p to the count of p, times the product of the rest
वध-शेषः : (p : ℕ) (L : List ℕ) → वधः L ≡ p ^ गणना p L · वधः (शेषः p L)
वध-शेषः p []       = refl
वध-शेषः p (x ∷ xs) = cong (x ·_) (वध-शेषः p xs) ∙ पदम् (discreteℕ p x)
  where
  c = गणना p xs
  r = वधः (शेषः p xs)

  पदम् : (d : Dec (p ≡ x))
       → x · (p ^ c · r) ≡ p ^ (दश d + c) · वधः (चयनम् p x d (शेषः p xs))
  पदम् (yes e) = cong (_· (p ^ c · r)) (sym e) ∙ ·-assoc p (p ^ c) r
  पदम् (no  _) = ·-assoc x (p ^ c) r
               ∙ cong (_· r) (·-comm x (p ^ c))
               ∙ sym (·-assoc (p ^ c) x r)

-- striking out preserves any pointwise property
शेष-सर्वे : {P : ℕ → Type₀} (p : ℕ) (L : List ℕ) → सर्वे P L → सर्वे P (शेषः p L)
शेष-सर्वे     p []       _        = tt
शेष-सर्वे {P} p (x ∷ xs) (h , hs) = पदम् (discreteℕ p x)
  where
  पदम् : (d : Dec (p ≡ x)) → सर्वे P (चयनम् p x d (शेषः p xs))
  पदम् (yes _) = शेष-सर्वे p xs hs
  पदम् (no  _) = h , शेष-सर्वे p xs hs

-- and p is not a member of what remains
शेष-असदस्यः : (p : ℕ) (L : List ℕ) → ¬ (p सदस्यः शेषः p L)
शेष-असदस्यः p []       ()
शेष-असदस्यः p (x ∷ xs) = पदम् (discreteℕ p x)
  where
  पदम् : (d : Dec (p ≡ x)) → ¬ (p सदस्यः चयनम् p x d (शेषः p xs))
  पदम् (yes _)  m       = शेष-असदस्यः p xs m
  पदम् (no ¬e) (inl e)  = ¬e e
  पदम् (no ¬e) (inr m)  = शेष-असदस्यः p xs m

-- hence, on a firm list, p does not divide the product of the rest
शेष-अभाज्यः : (p : ℕ) → दृढम् p → (L : List ℕ) → सर्वे दृढम् L
           → ¬ (p ∣ वधः (शेषः p L))
शेष-अभाज्यः p दृ L दृL dv =
  शेष-असदस्यः p L (अन्तर्भावः p दृ (शेषः p L) (शेष-सर्वे p L दृL) dv)

------------------------------------------------------------------------
-- २ · पृथक्करणम् — EXISTENCE: n ≡ p ^ (मानम् p n) · m with p ∤ m
------------------------------------------------------------------------

पृथक्करणम् : (p : ℕ) → दृढम् p → (n : ℕ) (pos : 0 < n)
          → Σ[ m ∈ ℕ ] ((n ≡ p ^ मानम् p n pos · m) × (¬ (p ∣ m)))
पृथक्करणम् p दृ n pos =
  वधः (शेषः p L) , (sym prodL ∙ वध-शेषः p L) , शेष-अभाज्यः p दृ L allP
  where
  L     = fst (विभाजनम् n pos)
  allP  = fst (snd (विभाजनम् n pos))
  prodL = snd (snd (विभाजनम् n pos))

------------------------------------------------------------------------
-- ३ · मान-एकत्वम् — UNIQUENESS of the exponent (and of the rest)
------------------------------------------------------------------------

-- e copies of p
पुनः : ℕ → ℕ → List ℕ
पुनः zero    p = []
पुनः (suc e) p = p ∷ पुनः e p

पुनः-वधः : (e p : ℕ) → वधः (पुनः e p) ≡ p ^ e
पुनः-वधः zero    p = refl
पुनः-वधः (suc e) p = cong (p ·_) (पुनः-वधः e p)

पुनः-गणना : (e p : ℕ) → गणना p (पुनः e p) ≡ e
पुनः-गणना zero    p = refl
पुनः-गणना (suc e) p = cong₂ _+_ (दश-स्वयम् (discreteℕ p p)) (पुनः-गणना e p)

पुनः-सर्वे : {P : ℕ → Type₀} (e p : ℕ) → P p → सर्वे P (पुनः e p)
पुनः-सर्वे zero    p h = tt
पुनः-सर्वे (suc e) p h = h , पुनः-सर्वे e p h

-- count over concatenation
गणना-++ : (z : ℕ) (L M : List ℕ) → गणना z (L ++ M) ≡ गणना z L + गणना z M
गणना-++ z []       M = refl
गणना-++ z (x ∷ L) M =
  cong (एकः z x +_) (गणना-++ z L M) ∙ +-assoc (एकः z x) (गणना z L) (गणना z M)

-- a non-member has count zero
असदस्य-गणना : (p : ℕ) (L : List ℕ) → ¬ (p सदस्यः L) → गणना p L ≡ 0
असदस्य-गणना p []       _  = refl
असदस्य-गणना p (x ∷ xs) nm = पदम् (discreteℕ p x)
  where
  पदम् : (d : Dec (p ≡ x)) → दश d + गणना p xs ≡ 0
  पदम् (yes e) = ⊥-rec (nm (inl e))
  पदम् (no  _) = असदस्य-गणना p xs (λ m → nm (inr m))

-- positivity bookkeeping
गुण-धनः : (a b : ℕ) → 0 < a → 0 < b → 0 < a · b
गुण-धनः zero    b       h _ = ⊥-rec (¬-<-zero h)
गुण-धनः (suc a) zero    _ h = ⊥-rec (¬-<-zero h)
गुण-धनः (suc a) (suc b) _ _ = suc-≤-suc zero-≤

घात-धनः : (p e : ℕ) → 0 < p → 0 < p ^ e
घात-धनः p zero    _ = suc-≤-suc zero-≤
घात-धनः p (suc e) h = गुण-धनः p (p ^ e) h (घात-धनः p e h)

-- the rest of a splitting of a positive number is positive
शेष-धनः : (n q : ℕ) → 0 < n → (m : ℕ) → n ≡ q · m → 0 < m
शेष-धनः n q pos zero    e = ⊥-rec (<→≢ pos (sym (e ∙ sym (0≡m·0 q))))
शेष-धनः n q pos (suc k) _  = suc-≤-suc zero-≤

-- THE THEOREM: any p-free splitting has the valuation as its exponent
मान-एकत्वम् : (p : ℕ) → दृढम् p → (n : ℕ) (pos : 0 < n) (e m : ℕ)
           → n ≡ p ^ e · m → ¬ (p ∣ m) → e ≡ मानम् p n pos
मान-एकत्वम् p दृ n pos e m n≡ p∤m =
    sym (+-zero e)
  ∙ cong₂ _+_ (sym (पुनः-गणना e p)) (sym cM)
  ∙ sym (गणना-++ p (पुनः e p) M)
  ∙ मान-निश्चयः p n pos L' allL' prodL'
  where
  0<m : 0 < m
  0<m = शेष-धनः n (p ^ e) pos m n≡

  M     = fst (विभाजनम् m 0<m)
  allM  = fst (snd (विभाजनम् m 0<m))
  prodM = snd (snd (विभाजनम् m 0<m))

  L' : List ℕ
  L' = पुनः e p ++ M

  allL' : सर्वे दृढम् L'
  allL' = सर्वे-++ (पुनः e p) M (पुनः-सर्वे e p दृ) allM

  prodL' : वधः L' ≡ n
  prodL' = वध-++ (पुनः e p) M ∙ cong₂ _·_ (पुनः-वधः e p) prodM ∙ sym n≡

  cM : गणना p M ≡ 0
  cM = असदस्य-गणना p M
         (λ mem → p∤m (subst (p ∣_) prodM (सदस्य-भाजकः p M mem)))

-- and the rest is unique as well: the splitting is a single pair
पृथक्करण-एकत्वम् : (p : ℕ) (दृ : दृढम् p) (n : ℕ) (pos : 0 < n) (e m : ℕ)
                → n ≡ p ^ e · m → ¬ (p ∣ m)
                → (e ≡ मानम् p n pos) × (m ≡ fst (पृथक्करणम् p दृ n pos))
पृथक्करण-एकत्वम् p दृ n pos e m n≡ p∤m = e≡ , m≡
  where
  e≡ : e ≡ मानम् p n pos
  e≡ = मान-एकत्वम् p दृ n pos e m n≡ p∤m

  m' = fst (पृथक्करणम् p दृ n pos)

  n≡' : n ≡ p ^ e · m'
  n≡' = subst (λ w → n ≡ p ^ w · m') (sym e≡) (fst (snd (पृथक्करणम् p दृ n pos)))

  pᵉ≢0 : ¬ p ^ e ≡ 0
  pᵉ≢0 z = <→≢ (घात-धनः p e (<-trans ≤-refl (fst दृ))) (sym z)

  m≡ : m ≡ m'
  m≡ = inj-sm· {m = predℕ (p ^ e)}
         (subst (λ w → w · m ≡ w · m') (suc-predℕ (p ^ e) pᵉ≢0) (sym n≡ ∙ n≡'))

-- corollaries: a number p does not divide has valuation 0,
-- and the valuation of p ^ e is e
मान-अभाज्यः : (p : ℕ) → दृढम् p → (n : ℕ) (pos : 0 < n) → ¬ (p ∣ n) → मानम् p n pos ≡ 0
मान-अभाज्यः p दृ n pos p∤n = sym (मान-एकत्वम् p दृ n pos 0 n (sym (·-identityˡ n)) p∤n)

मान-घातः : (p : ℕ) (दृ : दृढम् p) (e : ℕ) (pos : 0 < p ^ e) → मानम् p (p ^ e) pos ≡ e
मान-घातः p दृ e pos =
  sym (मान-एकत्वम् p दृ (p ^ e) pos e 1 (sym (·-identityʳ (p ^ e)))
                  (λ p∣1 → <-asym (fst दृ) (m∣sn→m≤sn p∣1)))

------------------------------------------------------------------------
-- ४ · मान-गुणनम् — the valuation adds over products
------------------------------------------------------------------------

मान-गुणनम् : (p a b : ℕ) (posa : 0 < a) (posb : 0 < b) (posab : 0 < a · b)
          → मानम् p (a · b) posab ≡ मानम् p a posa + मानम् p b posb
मान-गुणनम् p a b posa posb posab =
    sym (मान-निश्चयः p (a · b) posab (La ++ Lb)
           (सर्वे-++ La Lb allA allB)
           (वध-++ La Lb ∙ cong₂ _·_ prodA prodB))
  ∙ गणना-++ p La Lb
  where
  La    = fst (विभाजनम् a posa)
  allA  = fst (snd (विभाजनम् a posa))
  prodA = snd (snd (विभाजनम् a posa))
  Lb    = fst (विभाजनम् b posb)
  allB  = fst (snd (विभाजनम् b posb))
  prodB = snd (snd (विभाजनम् b posb))

-- the same with the positivity of a · b supplied rather than assumed
मान-गुणनम्' : (p a b : ℕ) (posa : 0 < a) (posb : 0 < b)
           → मानम् p (a · b) (गुण-धनः a b posa posb) ≡ मानम् p a posa + मानम् p b posb
मान-गुणनम्' p a b posa posb = मान-गुणनम् p a b posa posb (गुण-धनः a b posa posb)

------------------------------------------------------------------------
-- ५ · दृढ? — firmness of n > 1 is decidable (Drdha's search, both arms)
------------------------------------------------------------------------

दृढ? : (n : ℕ) → 1 < n → Dec (दृढम् n)
दृढ? n 1<n with अन्वेषणम् n n
... | inr nod                    = yes (दृढत्वम् n 1<n nod)
... | inl (d , 1<d , d<n , d∣n) = no λ दृ →
        ⊎-rec (λ d≡1 → <→≢ 1<d (sym d≡1))
              (λ d≡n → <→≢ d<n d≡n)
              (snd दृ d d∣n)

------------------------------------------------------------------------
-- ६ · परीक्षा — the kernel runs the splitting
------------------------------------------------------------------------

private
  सत्यम् : {A : Type₀} → Dec A → Type₀
  सत्यम् (yes _) = Unit
  सत्यम् (no  _) = ⊥

  सिद्धम् : {A : Type₀} (d : Dec A) → सत्यम् d → A
  सिद्धम् (yes a) _ = a

  ०<१२ : 0 < 12
  ०<१२ = suc-≤-suc zero-≤

  दृ-२ : दृढम् 2
  दृ-२ = सिद्धम् (दृढ? 2 (suc-≤-suc (suc-≤-suc zero-≤))) tt

  दृ-३ : दृढम् 3
  दृ-३ = सिद्धम् (दृढ? 3 (suc-≤-suc (suc-≤-suc zero-≤))) tt

  दृ-५ : दृढम् 5
  दृ-५ = सिद्धम् (दृढ? 5 (suc-≤-suc (suc-≤-suc zero-≤))) tt

  -- 12 = 2² · 3 = 3¹ · 4 = 5⁰ · 12
  शेष-२-१२ : fst (पृथक्करणम् 2 दृ-२ 12 ०<१२) ≡ 3
  शेष-२-१२ = refl

  शेष-३-१२ : fst (पृथक्करणम् 3 दृ-३ 12 ०<१२) ≡ 4
  शेष-३-१२ = refl

  शेष-५-१२ : fst (पृथक्करणम् 5 दृ-५ 12 ०<१२) ≡ 12
  शेष-५-१२ = refl

  -- the exponents, read off the same splitting, are Ekatva's valuations
  घात-२-१२ : मानम् 2 12 ०<१२ ≡ 2
  घात-२-१२ = refl

  -- additivity at 12 = 4 · 3: both sides compute to 2
  ०<४ : 0 < 4
  ०<४ = suc-≤-suc zero-≤
  ०<३ : 0 < 3
  ०<३ = suc-≤-suc zero-≤

  योगः-२ : मानम् 2 (4 · 3) (गुण-धनः 4 3 ०<४ ०<३) ≡ मानम् 2 4 ०<४ + मानम् 2 3 ०<३
  योगः-२ = refl

  योगः-३ : मानम् 3 (4 · 3) (गुण-धनः 4 3 ०<४ ०<३) ≡ मानम् 3 4 ०<४ + मानम् 3 3 ०<३
  योगः-३ = refl
