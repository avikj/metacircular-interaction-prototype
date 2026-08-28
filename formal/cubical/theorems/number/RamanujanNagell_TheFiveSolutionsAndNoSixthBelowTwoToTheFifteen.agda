{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्–नागेल् — THE FIVE SOLUTIONS, AND NO SIXTH BELOW 2¹⁵.
--
-- Ramanujan asked (J. Indian Math. Soc., 1913): when is 2ⁿ − 7 a
-- perfect square?  He listed n = 3, 4, 5, 7, 15 — squares 1, 9, 25,
-- 121, 32761 — and conjectured there are no others.  Nagell proved
-- the full conjecture in 1948 in ℤ[√−2]; that argument is beyond
-- this file's exact-arithmetic discipline and is not claimed.  What
-- IS proved, completely:
--
--   `sol₃ … sol₁₅` — the five solutions, subtraction-free
--     (x² + 7 ≡ 2ⁿ), each by refl; the famous 181² + 7 ≡ 32768
--     among them.
--
--   `ramanujan-nagell-below-15` — THERE IS NO SIXTH SOLUTION with
--     n ≤ 15: every pair (n, x) with x² + 7 ≡ 2ⁿ and n ≤ 15 is one
--     of Ramanujan's five.  The proof is the bounded-reflection
--     engine of the taxicab file, re-imported: a square-growth bound
--     confines x to 0..181 (182² = 33124 already exceeds 2¹⁵), the
--     kernel normalizes the 16 × 182 grid in one refl, and soundness
--     lemmas convert the scan into the theorem.
--
-- So the conjecture's full range up to and including its largest
-- solution is settled by computation-with-witnesses, and the
-- remainder — n beyond 15, where Nagell's descent lives — is exactly
-- the part the tradition proved by other instruments.
------------------------------------------------------------------------

module RamanujanNagell_TheFiveSolutionsAndNoSixthBelowTwoToTheFifteen where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ¬m<m ;
         ≤-trans ; ≤<-trans ; <-split ; splitℕ-≤ ; ≤-refl ; ≤-·k ; ≤SumLeft)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le? ; eq?-complete ; mand ; mand-just ; loop ; loop-sound ; ≤-k·)

------------------------------------------------------------------------
-- §1  The five, by computation.
------------------------------------------------------------------------

pow2 : ℕ → ℕ
pow2 zero    = 1
pow2 (suc n) = 2 · pow2 n

sol₃ : 1 · 1 + 7 ≡ pow2 3
sol₃ = refl

sol₄ : 3 · 3 + 7 ≡ pow2 4
sol₄ = refl

sol₅ : 5 · 5 + 7 ≡ pow2 5
sol₅ = refl

sol₇ : 11 · 11 + 7 ≡ pow2 7
sol₇ = refl

sol₁₅ : 181 · 181 + 7 ≡ pow2 15
sol₁₅ = refl

------------------------------------------------------------------------
-- §2  The scanner.
------------------------------------------------------------------------

-- One of the five, as a pair check with witnesses.
pairCk : ℕ → ℕ → ℕ → ℕ → Maybe Unit → Maybe Unit
pairCk n x a b rest =
  rec rest (λ _ → rec rest (λ _ → just tt) (eq? x b)) (eq? n a)

known : ℕ → ℕ → Maybe Unit
known n x =
  pairCk n x 3 1 (pairCk n x 4 3 (pairCk n x 5 5
    (pairCk n x 7 11 (pairCk n x 15 181 nothing))))

leafRN : ℕ → ℕ → ℕ → Maybe Unit
leafRN P n x = rec (just tt) (λ _ → known n x) (eq? (x · x + 7) P)

col : ℕ → ℕ → ℕ → Maybe Unit
col P n x = leafRN P n x

row : ℕ → Maybe Unit
row n = loop (col (pow2 n) n) 181

scan : Maybe Unit
scan = loop row 15

-- 16 × 182 cells, one normalization.
scan-ok : scan ≡ just tt
scan-ok = refl

------------------------------------------------------------------------
-- §3  Soundness.
------------------------------------------------------------------------

Five : ℕ → ℕ → Type
Five n x =
  ((n ≡ 3) × (x ≡ 1)) ⊎ (((n ≡ 4) × (x ≡ 3)) ⊎ (((n ≡ 5) × (x ≡ 5))
    ⊎ (((n ≡ 7) × (x ≡ 11)) ⊎ ((n ≡ 15) × (x ≡ 181)))))

pairCk-sound : (n x a b : ℕ) (rest : Maybe Unit) {O : Type} →
  (((n ≡ a) × (x ≡ b)) → O) → (rest ≡ just tt → O) →
  pairCk n x a b rest ≡ just tt → O
pairCk-sound n x a b rest {O} hit miss h = g (eq? n a) refl
  where
  F : Maybe (n ≡ a) → Maybe Unit
  F = rec rest (λ _ → rec rest (λ _ → just tt) (eq? x b))

  g2 : (p : n ≡ a) (w : Maybe (x ≡ b)) → eq? x b ≡ w →
       rec rest (λ _ → just tt) (eq? x b) ≡ just tt → O
  g2 p (just q) _  _  = hit (p , q)
  g2 p nothing  pw h2 =
    miss (sym (cong (rec rest (λ _ → just tt)) pw) ∙ h2)

  g : (w : Maybe (n ≡ a)) → eq? n a ≡ w → O
  g (just p) pw = g2 p (eq? x b) refl (sym (cong F pw) ∙ h)
  g nothing  pw = miss (sym (cong F pw) ∙ h)

known-sound : (n x : ℕ) → known n x ≡ just tt → Five n x
known-sound n x h =
  pairCk-sound n x 3 1 _ (λ e → inl e) (λ h1 →
    pairCk-sound n x 4 3 _ (λ e → inr (inl e)) (λ h2 →
      pairCk-sound n x 5 5 _ (λ e → inr (inr (inl e))) (λ h3 →
        pairCk-sound n x 7 11 _ (λ e → inr (inr (inr (inl e)))) (λ h4 →
          pairCk-sound n x 15 181 _ (λ e → inr (inr (inr (inr e))))
            (λ h5 → Empty.rec (¬nothing≡just h5)) h4) h3) h2) h1) h

leafRN-sound : (P n x : ℕ) → leafRN P n x ≡ just tt →
               x · x + 7 ≡ P → Five n x
leafRN-sound P n x h sq = g (eq? (x · x + 7) P) refl
  where
  g : (w : Maybe (x · x + 7 ≡ P)) → eq? (x · x + 7) P ≡ w → Five n x
  g (just _) pw =
    known-sound n x
      (sym (cong (rec (just tt) (λ _ → known n x)) pw) ∙ h)
  g nothing  pw = Empty.rec (eq?-complete _ _ pw sq)

------------------------------------------------------------------------
-- §4  The bound: 182² already exceeds 2¹⁵.
------------------------------------------------------------------------

sq-mono : {m n : ℕ} → m ≤ n → m · m ≤ n · n
sq-mono {m} {n} h = ≤-trans (≤-·k h) (≤-k· n h)

pow2-mono : {a b : ℕ} → a ≤ b → pow2 a ≤ pow2 b
pow2-mono {a} {zero}  h = go (<-split (suc-≤-suc h))
  where
  go : (a < zero) ⊎ (a ≡ zero) → pow2 a ≤ pow2 zero
  go (inl a0) = Empty.rec (¬-<-zero a0)
  go (inr a0) = subst (λ z → pow2 z ≤ pow2 zero) (sym a0) ≤-refl
pow2-mono {a} {suc b} h = go (<-split (suc-≤-suc h))
  where
  go : (a < suc b) ⊎ (a ≡ suc b) → pow2 a ≤ pow2 (suc b)
  go (inl ab) = ≤-trans (pow2-mono (pred-≤-pred ab)) ≤SumLeft
  go (inr ab) = subst (λ z → pow2 z ≤ pow2 (suc b)) (sym ab) ≤-refl

32768<33124 : 32768 < 33124
32768<33124 = 355 , refl

x-bounded : (n x : ℕ) → n ≤ 15 → x · x + 7 ≡ pow2 n → x ≤ 181
x-bounded n x hn sq = go (splitℕ-≤ x 181)
  where
  go : (x ≤ 181) ⊎ (181 < x) → x ≤ 181
  go (inl h)  = h
  go (inr hx) =
    Empty.rec (¬m<m (≤<-trans big 32768<33124))
    where
    x²≤2ⁿ : x · x ≤ pow2 n
    x²≤2ⁿ = 7 , +-comm 7 (x · x) ∙ sq

    big : 33124 ≤ 32768
    big = ≤-trans (sq-mono hx) (≤-trans x²≤2ⁿ (pow2-mono hn))

------------------------------------------------------------------------
-- §5  THE THEOREM.
------------------------------------------------------------------------

-- Every solution of x² + 7 = 2ⁿ with n ≤ 15 is one of Ramanujan's
-- five.  The range includes his largest; what lies beyond is
-- Nagell's, by other instruments, and is not claimed here — it is
-- named.
ramanujan-nagell-below-15 : (n x : ℕ) → n ≤ 15 →
  x · x + 7 ≡ pow2 n → Five n x
ramanujan-nagell-below-15 n x hn sq =
  leafRN-sound (pow2 n) n x
    (loop-sound (col (pow2 n) n) 181
      (loop-sound row 15 scan-ok n hn)
      x (x-bounded n x hn sq))
    sq
