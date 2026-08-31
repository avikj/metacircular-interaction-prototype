{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मध्य-बिन्दु — the midpoint form and the sum form are one question,
-- proved both ways.
--
-- The first sentence of the frame: "the set of midpoints of pairs of
-- primes covers the naturals."  Here it is as a type, and here is the
-- proof that it is THE SAME question as the sum form already living in
-- SamastaPrasna — two functions, one in each direction, at the pin.
--
--   SumAt n       =  Σ p q primes with p + q = n + n
--   MidpointAt n  =  Σ a k with a + k = n, a prime, a + 2k prime
--                    (the pair (n−k, n+k) written additively: a is the
--                     lower prime AND the ≤-witness, so no monus)
--
-- The forward direction is the working half: given p + q = 2n it must
-- SPLIT the pair around the center, and the split needs two lemmas that
-- are the arithmetic heart of the reflection frame:
--
--   halve  : a + a + d = n + n  →  d is even        (the offset doubles)
--   centre : (a+k) + (a+k) = n + n  →  a + k = n    (doubling injects)
--
-- both by double induction, both total, no classical steps.
--
-- WHAT IS NOT CLAIMED.  Neither type is inhabited for all n here; the
-- theorem is that the two questions are interderivable, so the open
-- section of one is the open section of the other — the midpoint
-- phrasing and the Goldbach phrasing stand or fall together.
------------------------------------------------------------------------

module MadhyaBindu_TheMidpointFormAndTheSumFormAreOneQuestionProvedBothWays where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-comm ; +-assoc ; +-suc ; injSuc ; snotz)
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
import Cubical.Data.Empty as E

open import SamastaPrasna_TheOpenConstellationEntersTypedAndTheOracleAnswersEveryInstance
  using (primeb)

------------------------------------------------------------------------
-- the two forms
------------------------------------------------------------------------

SumAt : ℕ → Type
SumAt n = Σ[ p ∈ ℕ ] Σ[ q ∈ ℕ ]
          (primeb p ≡ true) × (primeb q ≡ true) × (p + q ≡ n + n)

MidpointAt : ℕ → Type
MidpointAt n = Σ[ a ∈ ℕ ] Σ[ k ∈ ℕ ]
               (a + k ≡ n) × (primeb a ≡ true) × (primeb (a + (k + k)) ≡ true)

------------------------------------------------------------------------
-- arithmetic lemmas
------------------------------------------------------------------------

-- every pair of naturals is ordered, with the difference exhibited
split : (p q : ℕ) → (Σ[ d ∈ ℕ ] p + d ≡ q) ⊎ (Σ[ d ∈ ℕ ] q + d ≡ p)
split zero q    = inl (q , refl)
split (suc p) zero = inr (suc p , refl)
split (suc p) (suc q) with split p q
... | inl (d , e) = inl (d , cong suc e)
... | inr (d , e) = inr (d , cong suc e)

-- unfold a + a + d = n + n to suc suc (a + a + d') form and descend
double-suc : (a : ℕ) → suc a + suc a ≡ suc (suc (a + a))
double-suc a = cong suc (+-suc a a)

halve : (a n d : ℕ) → (a + a) + d ≡ n + n → Σ[ k ∈ ℕ ] d ≡ k + k
halve zero n d e = n , e
halve (suc a) zero d e = E.rec (snotz e)
halve (suc a) (suc n) d e =
  halve a n d (injSuc (injSuc
    (sym (cong (_+ d) (double-suc a)) ∙ e ∙ double-suc n)))

centre : (m n : ℕ) → m + m ≡ n + n → m ≡ n
centre zero zero e = refl
centre zero (suc n) e = E.rec (snotz (sym e))
centre (suc m) zero e = E.rec (snotz e)
centre (suc m) (suc n) e =
  cong suc (centre m n (injSuc (injSuc
    (sym (double-suc m) ∙ e ∙ double-suc n))))

------------------------------------------------------------------------
-- the equivalence of the two questions, both directions
------------------------------------------------------------------------

midpoint→sum : (n : ℕ) → MidpointAt n → SumAt n
midpoint→sum n (a , k , ctr , pa , pq) =
  a , (a + (k + k)) , pa , pq ,
  ( a + (a + (k + k))     ≡⟨ +-assoc a a (k + k) ⟩
    (a + a) + (k + k)     ≡⟨ rearrange a k ⟩
    (a + k) + (a + k)     ≡⟨ cong₂ _+_ ctr ctr ⟩
    n + n ∎ )
  where
  rearrange : (a k : ℕ) → (a + a) + (k + k) ≡ (a + k) + (a + k)
  rearrange a k =
    (a + a) + (k + k)   ≡⟨ +-assoc (a + a) k k ⟩
    ((a + a) + k) + k   ≡⟨ cong (_+ k) (sym (+-assoc a a k)) ⟩
    (a + (a + k)) + k   ≡⟨ cong (λ t → (a + t) + k) (+-comm a k) ⟩
    (a + (k + a)) + k   ≡⟨ cong (_+ k) (+-assoc a k a) ⟩
    ((a + k) + a) + k   ≡⟨ sym (+-assoc (a + k) a k) ⟩
    (a + k) + (a + k) ∎

sum→midpoint : (n : ℕ) → SumAt n → MidpointAt n
sum→midpoint n (p , q , pp , pq , e) with split p q
... | inl (d , pd≡q) =
  let k , d≡2k = halve p n d
        (cong (p + p +_) refl ∙ lem-l p d q e pd≡q)
      ctr = centre-of p k n (lem-l p (k + k) q
              e (cong (p +_) (sym d≡2k) ∙ pd≡q))
  in  p , k , ctr , pp ,
      subst (λ t → primeb t ≡ true)
        (sym pd≡q ∙ cong (p +_) d≡2k) pq
  where
  lem-l : (p d q : ℕ) → p + q ≡ n + n → p + d ≡ q → (p + p) + d ≡ n + n
  lem-l p d q e' pd =
    (p + p) + d   ≡⟨ sym (+-assoc p p d) ⟩
    p + (p + d)   ≡⟨ cong (p +_) pd ⟩
    p + q         ≡⟨ e' ⟩
    n + n ∎
  centre-of : (p k n' : ℕ) → (p + p) + (k + k) ≡ n' + n' → p + k ≡ n'
  centre-of p k n' e' = centre (p + k) n'
    ( (p + k) + (p + k) ≡⟨ sym (rearr p k) ⟩
      (p + p) + (k + k) ≡⟨ e' ⟩
      n' + n' ∎ )
    where
    rearr : (a k' : ℕ) → (a + a) + (k' + k') ≡ (a + k') + (a + k')
    rearr a k' =
      (a + a) + (k' + k')   ≡⟨ +-assoc (a + a) k' k' ⟩
      ((a + a) + k') + k'   ≡⟨ cong (_+ k') (sym (+-assoc a a k')) ⟩
      (a + (a + k')) + k'   ≡⟨ cong (λ t → (a + t) + k') (+-comm a k') ⟩
      (a + (k' + a)) + k'   ≡⟨ cong (_+ k') (+-assoc a k' a) ⟩
      ((a + k') + a) + k'   ≡⟨ sym (+-assoc (a + k') a k') ⟩
      (a + k') + (a + k') ∎
... | inr (d , qd≡p) =
  let k , d≡2k = halve q n d (lem-r q d p e qd≡p)
      ctr = centre-of q k n (lem-r q (k + k) p
              e (cong (q +_) (sym d≡2k) ∙ qd≡p))
  in  q , k , ctr , pq ,
      subst (λ t → primeb t ≡ true)
        (sym qd≡p ∙ cong (q +_) d≡2k) pp
  where
  lem-r : (q d p : ℕ) → p + q ≡ n + n → q + d ≡ p → (q + q) + d ≡ n + n
  lem-r q d p e' qd =
    (q + q) + d   ≡⟨ sym (+-assoc q q d) ⟩
    q + (q + d)   ≡⟨ cong (q +_) qd ⟩
    q + p         ≡⟨ +-comm q p ⟩
    p + q         ≡⟨ e' ⟩
    n + n ∎
  centre-of : (p' k n' : ℕ) → (p' + p') + (k + k) ≡ n' + n' → p' + k ≡ n'
  centre-of p' k n' e' = centre (p' + k) n'
    ( (p' + k) + (p' + k) ≡⟨ sym (rearr p' k) ⟩
      (p' + p') + (k + k) ≡⟨ e' ⟩
      n' + n' ∎ )
    where
    rearr : (a k' : ℕ) → (a + a) + (k' + k') ≡ (a + k') + (a + k')
    rearr a k' =
      (a + a) + (k' + k')   ≡⟨ +-assoc (a + a) k' k' ⟩
      ((a + a) + k') + k'   ≡⟨ cong (_+ k') (sym (+-assoc a a k')) ⟩
      (a + (a + k')) + k'   ≡⟨ cong (λ t → (a + t) + k') (+-comm a k') ⟩
      (a + (k' + a)) + k'   ≡⟨ cong (_+ k') (+-assoc a k' a) ⟩
      ((a + k') + a) + k'   ≡⟨ sym (+-assoc (a + k') a k') ⟩
      (a + k') + (a + k') ∎

------------------------------------------------------------------------
-- the theorem: one question, two phrasings
------------------------------------------------------------------------

one-question : (n : ℕ) → (MidpointAt n → SumAt n) × (SumAt n → MidpointAt n)
one-question n = midpoint→sum n , sum→midpoint n
