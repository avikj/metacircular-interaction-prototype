{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- दृढम् — दृढानां वधः सर्वं धनं जनयति ; तेषां सदस्यता भागेन निर्णीयते ।
--
-- (the firm ones: the product of the firm numbers makes every positive
--  quantity, and which of them occur is decided by division.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, AND WHAT IT IS FOR.
--
-- `Sarvasthana_…agda` proves the ACCOUNTING half of ∑_v log|x|_v = 0: for
-- any assignment of exponents to places and any weights, the finite
-- entries and the archimedean entry cancel.  Its header says, in as many
-- words, what it does NOT do — it does not say the places are the primes,
-- nor that a divisor determines a number, "that last needs unique
-- factorisation, which is exactly the work this module does not do."
--
-- This is that work, as far as it goes, and NO further.  It is the
-- ARITHMETIC half, and it is carried out multiplicatively over ℕ: no
-- reals, no logarithms, no absolute values.  In that form the target is
--
--     for every n ≥ 1 there is a list of firm numbers whose product is n
--
-- and the places that see n are exactly the entries of that list.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE.
--
--   §३  भाग? — divisibility by a positive number is DECIDABLE (via mod).
--   §४  अन्वेषणम् — bounded search: either a nontrivial divisor below a
--       bound, or the proof that there is none below it.
--   §५  विभाजनम् — EXISTENCE.  Every n ≥ 1 is the product of a finite
--       list of firm numbers.  By well-founded recursion on n.
--   §६  युक्लिड-वाक्यम् — a firm number dividing a product divides one of
--       the factors.  Proved from the library's `gcd`, not assumed.
--   §७  अन्तर्भावः — a firm p divides the product of a list of firm
--       numbers exactly when p is IN the list.  Hence:
--   §८  स्थान-निर्णयः — the SUPPORT of the factorisation is determined by
--       n alone: for firm p, p ∣ n ↔ p occurs in the list §५ produced.
--   §९  मूल्यम् — the bridge to `Sarvasthana`'s विभागः: the map
--       D ↦ ∏ p^e from exponent-lists to ℕ has an INHABITED fibre over
--       every n ≥ 1.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS **NOT** CLAIMED.  Stated at the same grain as the claims,
-- because "not proven here" without its extent is a forged absence.
--
--   · UNIQUENESS IS NOT PROVED.  §५ produces *a* list; nothing here says
--     two such lists are permutations of each other.  §८ proves the
--     support is canonical — WHICH primes occur is fixed by n — and says
--     nothing about HOW MANY times each occurs.  So the multiplicities
--     are not shown well defined, and consequently
--   · v_p IS NOT DEFINED HERE at all, and `∏_p p^(v_p n) ≡ n` is NOT the
--     statement proved.  What is proved is the surjection: every n ≥ 1 is
--     SOME product of primes, and the prime support is determined.  The
--     step from "some" to "the" is the uniqueness half, and it is absent.
--   · §९'s fibre is shown INHABITED, not contractible.  Contractibility
--     of that fibre IS unique factorisation, and it is exactly what is
--     missing; the module is careful to state only the inhabitation.
--     (Contrast `Sarvasthana` §५, where the fibre of the conservation
--     observable over zero is *everything* — proved there, and a fact of
--     a different kind: blindness, not rigidity.)
--   · NOTHING about ℚˣ, negatives, valuations on a field, or the product
--     formula.  This module never leaves ℕ.
--   · The finite places of `Sarvasthana` are still not identified with
--     the firm numbers here; that module's ℕ index remains an index.
--     What this module supplies is the fact that WOULD justify such an
--     identification for the finite half — nothing more.
--
-- ────────────────────────────────────────────────────────────────────
-- TERMS, AND WHAT IS AND IS NOT CLAIMED OF THE SOURCES.
--
-- दृढ · dṛḍha — "firm, solid, that which stands after abrasion".  In the
-- kuṭṭaka the dividend (भाज्य) and divisor (भाजक) are first divided by
-- their common measure — the अपवर्तन — and the pair that remains is
-- called दृढ, because no further reduction is possible on it.
--   Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 2.32–33 (499) for the kuṭṭaka
--   the reduction serves; the vallī and the reduction step worked out in
--   Bhāskara I, *Āryabhaṭīyabhāṣya* (629); अपवर्तन stated in Brahmagupta,
--   *Brāhmasphuṭasiddhānta* 18 (628) and in Bhāskara II, *Bījagaṇita*
--   (1150), whose kuṭṭaka rule directs the reduction to दृढ before the
--   vallī is begun.
--
-- **What is NOT claimed of दृढ.**  In those texts दृढ is a property of a
-- PAIR — two magnitudes with no common measure left — and it is a step in
-- a solving procedure, not a classification of numbers.  Using it here
-- for a SINGLE number that admits no nontrivial factorisation is an
-- extension, and it is ours, not theirs.  None of these authors states
-- the theorem in §५, and no claim is made that they did.  The choice of
-- the word is because it names the right thing — what remains when
-- reduction can do no more — not because the theorem is in the source.
--
-- **§६ is Greek and is named so.**  The lemma "a prime dividing a product
-- divides a factor" is Euclid, *Elements* VII.30 (c. 300 BCE).  It is not
-- in the Indian sources cited above, and inventing a Sanskrit label for
-- it would be the mirror of the scrubbing the naming rule corrects, so it
-- carries its own name transliterated.  The PROOF used here is not
-- Euclid's: it runs through the library's `gcd` and `gcd-factorʳ`, and
-- the gcd it uses is computed by the mutual-subtraction descent that the
-- kuṭṭaka is — which is a remark about the substrate, not a priority
-- claim about VII.30.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIsDecidedByDivision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod using (_mod_ ; zero-charac-gen ; ≡remainder+quotient ; quotient_/_)
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD using (gcd ; gcdIsGCD ; gcd-factorʳ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr) renaming (rec to ⊎-rec)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Induction.WellFounded using (Acc ; acc)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

private
  variable
    A : Type₀

------------------------------------------------------------------------
-- १ · दृढम् — the firm number: bigger than one, and no reduction on it
--     is possible except the two that always are.
------------------------------------------------------------------------

दृढम् : ℕ → Type₀
दृढम् p = (1 < p) × ((d : ℕ) → d ∣ p → (d ≡ 1) ⊎ (d ≡ p))

------------------------------------------------------------------------
-- २ · वधः, सर्वे, सदस्यः — the product of a list, "every entry has", and
--     membership.  All three by recursion; nothing here is a HIT.
------------------------------------------------------------------------

वधः : List ℕ → ℕ
वधः []       = 1
वधः (x ∷ xs) = x · वधः xs

सर्वे : (A → Type₀) → List A → Type₀
सर्वे P []       = Unit
सर्वे P (x ∷ xs) = P x × सर्वे P xs

_सदस्यः_ : A → List A → Type₀
x सदस्यः []       = ⊥
x सदस्यः (y ∷ ys) = (x ≡ y) ⊎ (x सदस्यः ys)

वध-++ : (L M : List ℕ) → वधः (L ++ M) ≡ वधः L · वधः M
वध-++ []       M = sym (·-identityˡ (वधः M))
वध-++ (x ∷ L) M = cong (x ·_) (वध-++ L M) ∙ ·-assoc x (वधः L) (वधः M)

सर्वे-++ : {P : A → Type₀} (L M : List A)
        → सर्वे P L → सर्वे P M → सर्वे P (L ++ M)
सर्वे-++ []       M _        hM = hM
सर्वे-++ (x ∷ L) M (h , hL) hM = h , सर्वे-++ L M hL hM

------------------------------------------------------------------------
-- ३ · भाग? — division by a POSITIVE number is decidable.
--
--     The decision is `n mod d ≟ 0`, and both directions come out of the
--     library's remainder-quotient identity.  This is what makes §४'s
--     search a program rather than a classical case split.
------------------------------------------------------------------------

भाग? : (d n : ℕ) → 0 < d → Dec (d ∣ n)
भाग? zero    n 0<0 = ⊥-rec (¬-<-zero 0<0)
भाग? (suc d) n _  with discreteℕ (n mod suc d) 0
... | yes r = yes ∣ q , (·-comm q (suc d)
                        ∙ sym (cong (_+ (suc d · q)) r)
                        ∙ ≡remainder+quotient (suc d) n) ∣₁
  where
  q : ℕ
  q = quotient n / suc d
... | no ¬r = no λ p → ¬r (सिद्धिः (∣-untrunc p))
  where
  सिद्धिः : Σ[ c ∈ ℕ ] c · suc d ≡ n → (n mod suc d) ≡ 0
  सिद्धिः (c , e) = cong (_mod suc d) (sym e) ∙ zero-charac-gen (suc d) c

------------------------------------------------------------------------
-- ४ · अन्वेषणम् — bounded search for a nontrivial divisor.
--
--     Either a witness d with 1 < d < b dividing n, or the statement that
--     NO such d exists below b.  The second disjunct is what makes n firm
--     when b is taken to be n itself: it is an absence with its whole
--     field named, which is the only kind this corpus accepts.
------------------------------------------------------------------------

अन्वेषणम् : (n b : ℕ)
          → (Σ[ d ∈ ℕ ] (1 < d) × (d < b) × (d ∣ n))
          ⊎ ((d : ℕ) → 1 < d → d < b → ¬ (d ∣ n))
अन्वेषणम् n zero    = inr λ d _ lt → ⊥-rec (¬-<-zero lt)
अन्वेषणम् n (suc b) with अन्वेषणम् n b
... | inl (d , h1 , h2 , h3) = inl (d , h1 , ≤-suc h2 , h3)
... | inr h with <Dec 1 b
...   | no ¬1<b = inr λ d h1 lt →
          ⊎-rec (h d h1)
                (λ e → ⊥-rec (¬1<b (subst (1 <_) e h1)))
                (<-split lt)
...   | yes 1<b with भाग? b n (<-trans ≤-refl 1<b)
...     | yes dv = inl (b , 1<b , ≤-refl , dv)
...     | no ndv = inr λ d h1 lt →
            ⊎-rec (h d h1)
                  (λ e → subst (λ z → ¬ (z ∣ n)) (sym e) ndv)
                  (<-split lt)

------------------------------------------------------------------------
-- ५ · विभाजनम् — EXISTENCE OF A FIRM FACTORISATION.
--
--     दृढत्वम् first: a number above one with no nontrivial divisor below
--     itself IS firm.  Then the recursion: search; if nothing is found
--     the number is firm and stands alone; if a divisor is found, both
--     sides are strictly smaller and the lists concatenate.
------------------------------------------------------------------------

दृढत्वम् : (n : ℕ) → 1 < n → ((d : ℕ) → 1 < d → d < n → ¬ (d ∣ n)) → दृढम् n
दृढत्वम् n 1<n nod = 1<n , विवेकः
  where
  n≢0 : ¬ n ≡ 0
  n≢0 e = <→≢ (<-trans ≤-refl 1<n) (sym e)

  विवेकः : (d : ℕ) → d ∣ n → (d ≡ 1) ⊎ (d ≡ n)
  विवेकः d dv with splitℕ-< 1 d
  ... | inr d≤1 = ⊎-rec (λ d<1 → ⊥-rec (शून्यम् (≤0→≡0 (pred-≤-pred d<1))))
                        (λ e → inl e)
                        (≤-split d≤1)
    where
    शून्यम् : d ≡ 0 → ⊥
    शून्यम् e = n≢0 (sym (∣-zeroˡ (subst (_∣ n) e dv)))
  ... | inl 1<d = ⊎-rec (λ d<n → ⊥-rec (nod d 1<d d<n dv))
                        inr
                        (≤-split (m∣n→m≤n n≢0 dv))

विभाजनम्' : (n : ℕ) → Acc _<_ n → 0 < n
          → Σ[ L ∈ List ℕ ] (सर्वे दृढम् L × (वधः L ≡ n))
विभाजनम्' n (acc rec) pos with splitℕ-< 1 n
... | inr n≤1 = [] , tt , ≤-antisym pos n≤1
... | inl 1<n with अन्वेषणम् n n
...   | inr nod = (n ∷ []) , (दृढत्वम् n 1<n nod , tt) , ·-identityʳ n
...   | inl (d , 1<d , d<n , d∣n) = चूर्णनम् (∣-untrunc d∣n)
  where
  0<d : 0 < d
  0<d = <-trans ≤-refl 1<d

  चूर्णनम् : Σ[ c ∈ ℕ ] c · d ≡ n
          → Σ[ L ∈ List ℕ ] (सर्वे दृढम् L × (वधः L ≡ n))
  चूर्णनम् (zero  , e) = ⊥-rec (<→≢ pos e)
  चूर्णनम् (suc k , e) = (L₁ ++ L₂) , सर्वे-++ L₁ L₂ p₁ p₂ ,
      (वध-++ L₁ L₂ ∙ cong₂ _·_ q₁ q₂ ∙ ·-comm d (suc k) ∙ e)
    where
    k<n : suc k < n
    k<n = subst2 _<_ (·-identityˡ (suc k)) (·-comm d (suc k) ∙ e) (<-·sk 1<d)

    रेखा₁ = विभाजनम्' d (rec d d<n) 0<d
    रेखा₂ = विभाजनम्' (suc k) (rec (suc k) k<n) (suc-≤-suc zero-≤)

    L₁ = fst रेखा₁
    L₂ = fst रेखा₂
    p₁ = fst (snd रेखा₁)
    p₂ = fst (snd रेखा₂)
    q₁ = snd (snd रेखा₁)
    q₂ = snd (snd रेखा₂)

विभाजनम् : (n : ℕ) → 0 < n → Σ[ L ∈ List ℕ ] (सर्वे दृढम् L × (वधः L ≡ n))
विभाजनम् n = विभाजनम्' n (<-wellfounded n)

------------------------------------------------------------------------
-- ६ · युक्लिड-वाक्यम् — Euclid, *Elements* VII.30 (c. 300 BCE).  Named for
--     its source, not dressed in a Sanskrit label it has no claim to.
--
--     The proof is by gcd: gcd p a divides p, so by firmness it is 1 or
--     p.  If p, then p divides a.  If 1, then gcd (p·b) (a·b) = b, and p
--     divides both arguments, hence divides b.
------------------------------------------------------------------------

युक्लिड-वाक्यम् : (p a b : ℕ) → दृढम् p → p ∣ (a · b) → (p ∣ a) ⊎ (p ∣ b)
युक्लिड-वाक्यम् p a b (_ , विवेकः) p∣ab
  with विवेकः (gcd p a) (fst (fst (gcdIsGCD p a)))
... | inr g≡p = inl (subst (_∣ a) g≡p (snd (fst (gcdIsGCD p a))))
... | inl g≡1 = inr (subst (p ∣_) समता p∣both)
  where
  p∣both : p ∣ gcd (p · b) (a · b)
  p∣both = snd (gcdIsGCD (p · b) (a · b)) p (∣-left b , p∣ab)

  समता : gcd (p · b) (a · b) ≡ b
  समता = gcd-factorʳ p a b ∙ cong (_· b) g≡1 ∙ ·-identityˡ b

------------------------------------------------------------------------
-- ७ · अन्तर्भावः — a firm number divides the product of a list of firm
--     numbers exactly when it OCCURS in the list.  Both directions.
------------------------------------------------------------------------

सदस्य-भाजकः : (q : ℕ) (L : List ℕ) → q सदस्यः L → q ∣ वधः L
सदस्य-भाजकः q (x ∷ xs) (inl e) = subst (_∣ (x · वधः xs)) (sym e) (∣-left (वधः xs))
सदस्य-भाजकः q (x ∷ xs) (inr m) = ∣-trans (सदस्य-भाजकः q xs m) (∣-right x)

अन्तर्भावः : (p : ℕ) → दृढम् p → (L : List ℕ) → सर्वे दृढम् L
           → p ∣ वधः L → p सदस्यः L
अन्तर्भावः p (1<p , _) []       _         p∣1  = ⊥-rec (<-asym 1<p (m∣sn→m≤sn p∣1))
अन्तर्भावः p दृ (x ∷ xs) (दृx , दृxs) p∣xs =
  ⊎-rec वामम् (λ p∣rest → inr (अन्तर्भावः p दृ xs दृxs p∣rest))
        (युक्लिड-वाक्यम् p x (वधः xs) दृ p∣xs)
  where
  वामम् : p ∣ x → p सदस्यः (x ∷ xs)
  वामम् p∣x = ⊎-rec (λ p≡1 → ⊥-rec (<→≢ (fst दृ) (sym p≡1)))
                    inl
                    (snd दृx p p∣x)

------------------------------------------------------------------------
-- ८ · स्थान-निर्णयः — THE SUPPORT IS DETERMINED BY n.
--
--     For the list §५ produced from n, and for any firm p:
--         p divides n   ↔   p occurs in that list.
--     So WHICH firm numbers see n is fixed by n and not by the run of the
--     search.  HOW MANY TIMES each occurs is NOT settled here, and that
--     gap is exactly unique factorisation.
------------------------------------------------------------------------

स्थान-निर्णयः : (n : ℕ) (pos : 0 < n) (p : ℕ) → दृढम् p
              → (p ∣ n → p सदस्यः fst (विभाजनम् n pos))
              × (p सदस्यः fst (विभाजनम् n pos) → p ∣ n)
स्थान-निर्णयः n pos p दृ =
    (λ p∣n → अन्तर्भावः p दृ L allP (subst (p ∣_) (sym prodL) p∣n))
  , (λ mem → subst (p ∣_) prodL (सदस्य-भाजकः p L mem))
  where
  L     = fst (विभाजनम् n pos)
  allP  = fst (snd (विभाजनम् n pos))
  prodL = snd (snd (विभाजनम् n pos))

------------------------------------------------------------------------
-- ९ · मूल्यम् — THE BRIDGE TO `Sarvasthana`'s विभागः.
--
--     There a divisor is a list of (place, exponent) and the module's
--     whole point is that it never has to say what the places are.  Here
--     the value map D ↦ ∏ p^e is written down, and the theorem is that
--     its fibre over every n ≥ 1 is INHABITED by a divisor all of whose
--     places are firm.
--
--     INHABITED, not contractible.  Contractibility of this fibre is
--     unique factorisation and is not proved anywhere in this module; the
--     statement below is deliberately the weaker one, and the difference
--     between it and `Sarvasthana` §५ — where the fibre is *everything* —
--     is the difference between an arithmetic fact and a bookkeeping one.
------------------------------------------------------------------------

मूल्यम् : List (ℕ × ℕ) → ℕ
मूल्यम् []             = 1
मूल्यम् ((p , e) ∷ r) = (p ^ e) · मूल्यम् r

एकघातः : (L : List ℕ) → मूल्यम् (map (λ p → (p , 1)) L) ≡ वधः L
एकघातः []       = refl
एकघातः (x ∷ xs) = cong₂ _·_ (·-identityʳ x) (एकघातः xs)

दृढ-स्थानानि : (L : List ℕ) → सर्वे दृढम् L
             → सर्वे (λ (pe : ℕ × ℕ) → दृढम् (fst pe)) (map (λ p → (p , 1)) L)
दृढ-स्थानानि []       _        = tt
दृढ-स्थानानि (x ∷ xs) (h , hs) = h , दृढ-स्थानानि xs hs

तन्तुः-अरिक्तः : (n : ℕ) → 0 < n
               → Σ[ D ∈ List (ℕ × ℕ) ]
                   (सर्वे (λ (pe : ℕ × ℕ) → दृढम् (fst pe)) D × (मूल्यम् D ≡ n))
तन्तुः-अरिक्तः n pos =
    map (λ p → (p , 1)) L
  , दृढ-स्थानानि L allP
  , (एकघातः L ∙ prodL)
  where
  L     = fst (विभाजनम् n pos)
  allP  = fst (snd (विभाजनम् n pos))
  prodL = snd (snd (विभाजनम् n pos))

------------------------------------------------------------------------
-- १० · परीक्षा — the search is a PROGRAM, and these are its runs.
--
--     Not evidence for the theorem — §५ is the evidence for the theorem.
--     These are here because a decidable search can typecheck and still
--     be vacuous, and `refl` at these three values shows it is not: the
--     recursion terminates, the bound is right, and the list it returns
--     is the expected one.  Each is checked by the kernel, not measured.
------------------------------------------------------------------------

private
  ०<१ : 0 < 1
  ०<१ = suc-≤-suc zero-≤

  परीक्षा-१ : fst (विभाजनम् 1 ०<१) ≡ []
  परीक्षा-१ = refl

  परीक्षा-१२ : fst (विभाजनम् 12 (suc-≤-suc zero-≤)) ≡ (2 ∷ 2 ∷ 3 ∷ [])
  परीक्षा-१२ = refl

  परीक्षा-३० : fst (विभाजनम् 30 (suc-≤-suc zero-≤)) ≡ (2 ∷ 3 ∷ 5 ∷ [])
  परीक्षा-३० = refl
