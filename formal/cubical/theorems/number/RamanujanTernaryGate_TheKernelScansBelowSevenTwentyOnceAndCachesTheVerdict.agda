{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The gate layer of RamanujanTernary: the form, the witness finders,
-- the seventeen, and the three kernel scans, in their own module so
-- the twenty-minute normalization is paid once and cached.  The
-- theorems live in RamanujanTernary_…TowardTheOpenList, which imports
-- this and pays seconds.
------------------------------------------------------------------------

module RamanujanTernaryGate_TheKernelScansBelowSevenTwentyOnceAndCachesTheVerdict where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ¬m<m ;
         ≤-trans ; ≤<-trans ; <≤-trans ; splitℕ-≤ ; ≤SumLeft ; ≤SumRight)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le? ; eq?-complete ; mand ; mand-just ; loop ; loop-sound ; ≤-k·)
open import RamanujanNagell_TheFiveSolutionsAndNoSixthBelowTwoToTheFifteen
  using (sq-mono)

------------------------------------------------------------------------
-- §1  The form, and the witness finder.
------------------------------------------------------------------------

Q : ℕ → ℕ → ℕ → ℕ
Q x y z = x · x + y · y + 10 · (z · z)

Rep : ℕ → Type
Rep n = Σ ℕ (λ x → Σ ℕ (λ y → Σ ℕ (λ z → Q x y z ≡ n)))

findZ : (x y n b : ℕ) → Maybe (Σ ℕ (λ z → Q x y z ≡ n))
findZ x y n zero    = map-Maybe (λ p → zero , p) (eq? (Q x y zero) n)
findZ x y n (suc b) =
  rec (findZ x y n b) (λ p → just (suc b , p)) (eq? (Q x y (suc b)) n)

findY : (x n b : ℕ) → Maybe (Σ ℕ (λ y → Σ ℕ (λ z → Q x y z ≡ n)))
findY x n zero    = map-Maybe (λ w → zero , w) (findZ x zero n 8)
findY x n (suc b) =
  rec (findY x n b) (λ w → just (suc b , w)) (findZ x (suc b) n 8)

findX : (n b : ℕ) → Maybe (Rep n)
findX n zero    = map-Maybe (λ w → zero , w) (findY zero n 26)
findX n (suc b) =
  rec (findX n b) (λ w → just (suc b , w)) (findY (suc b) n 26)

findRep : (n : ℕ) → Maybe (Rep n)
findRep n = findX n 26

------------------------------------------------------------------------
-- §2  The seventeen, indexed.
------------------------------------------------------------------------

exc : ℕ → ℕ
exc 0 = 3 ; exc 1 = 7 ; exc 2 = 21 ; exc 3 = 31 ; exc 4 = 33
exc 5 = 43 ; exc 6 = 67 ; exc 7 = 79 ; exc 8 = 87 ; exc 9 = 133
exc 10 = 217 ; exc 11 = 219 ; exc 12 = 223 ; exc 13 = 253
exc 14 = 307 ; exc 15 = 391 ; exc 16 = 679 ; exc _ = 0

In17 : ℕ → Type
In17 n = Σ ℕ (λ i → (i ≤ 16) × (n ≡ exc i))

numCk : ℕ → ℕ → Maybe Unit → Maybe Unit
numCk n e rest = rec rest (λ _ → just tt) (eq? n e)

numCk-sound : (n e : ℕ) (rest : Maybe Unit) {O : Type} →
  (n ≡ e → O) → (rest ≡ just tt → O) → numCk n e rest ≡ just tt → O
numCk-sound n e rest {O} hit miss h = g (eq? n e) refl
  where
  g : (w : Maybe (n ≡ e)) → eq? n e ≡ w → O
  g (just p) pw = hit p
  g nothing  pw =
    miss (sym (cong (rec rest (λ _ → just tt)) pw) ∙ h)

excCk : ℕ → Maybe Unit
excCk n =
  numCk n 3 (numCk n 7 (numCk n 21 (numCk n 31 (numCk n 33
    (numCk n 43 (numCk n 67 (numCk n 79 (numCk n 87 (numCk n 133
      (numCk n 217 (numCk n 219 (numCk n 223 (numCk n 253
        (numCk n 307 (numCk n 391 (numCk n 679 nothing))))))))))))))))

excCk-sound : (n : ℕ) → excCk n ≡ just tt → In17 n
excCk-sound n h =
  numCk-sound n 3 _ (λ p → 0 , (16 , refl) , p) (λ h1 →
  numCk-sound n 7 _ (λ p → 1 , (15 , refl) , p) (λ h2 →
  numCk-sound n 21 _ (λ p → 2 , (14 , refl) , p) (λ h3 →
  numCk-sound n 31 _ (λ p → 3 , (13 , refl) , p) (λ h4 →
  numCk-sound n 33 _ (λ p → 4 , (12 , refl) , p) (λ h5 →
  numCk-sound n 43 _ (λ p → 5 , (11 , refl) , p) (λ h6 →
  numCk-sound n 67 _ (λ p → 6 , (10 , refl) , p) (λ h7 →
  numCk-sound n 79 _ (λ p → 7 , (9 , refl) , p) (λ h8 →
  numCk-sound n 87 _ (λ p → 8 , (8 , refl) , p) (λ h9 →
  numCk-sound n 133 _ (λ p → 9 , (7 , refl) , p) (λ h10 →
  numCk-sound n 217 _ (λ p → 10 , (6 , refl) , p) (λ h11 →
  numCk-sound n 219 _ (λ p → 11 , (5 , refl) , p) (λ h12 →
  numCk-sound n 223 _ (λ p → 12 , (4 , refl) , p) (λ h13 →
  numCk-sound n 253 _ (λ p → 13 , (3 , refl) , p) (λ h14 →
  numCk-sound n 307 _ (λ p → 14 , (2 , refl) , p) (λ h15 →
  numCk-sound n 391 _ (λ p → 15 , (1 , refl) , p) (λ h16 →
  numCk-sound n 679 _ (λ p → 16 , (0 , refl) , p)
    (λ h17 → Empty.rec (¬nothing≡just h17))
    h16) h15) h14) h13) h12) h11) h10) h9) h8) h7) h6) h5) h4) h3) h2) h1) h

------------------------------------------------------------------------
-- §3  Direction one: every odd n < 720 is represented or listed.
------------------------------------------------------------------------

leafOdd : ℕ → Maybe Unit
leafOdd m = rec (excCk (suc (2 · m))) (λ _ → just tt) (findRep (suc (2 · m)))

scanOdd : Maybe Unit
scanOdd = loop leafOdd 359

scanOdd-ok : scanOdd ≡ just tt
scanOdd-ok = refl

leafOdd-sound : (m : ℕ) → leafOdd m ≡ just tt →
                In17 (suc (2 · m)) ⊎ Rep (suc (2 · m))
leafOdd-sound m h = g (findRep (suc (2 · m))) refl
  where
  n : ℕ
  n = suc (2 · m)

  g : (w : Maybe (Rep n)) → findRep n ≡ w → In17 n ⊎ Rep n
  g (just w) _  = inr w
  g nothing  pw =
    inl (excCk-sound n
      (sym (cong (rec (excCk n) (λ _ → just tt)) pw) ∙ h))

-- THE FIRST DIRECTION.  Every odd number below 720: listed, or
-- represented with the triple handed out as data.
represented-or-listed : (m : ℕ) → m ≤ 359 →
  In17 (suc (2 · m)) ⊎ Rep (suc (2 · m))
represented-or-listed m hm =
  leafOdd-sound m (loop-sound leafOdd 359 scanOdd-ok m hm)

------------------------------------------------------------------------
-- §4  Direction two: the listed are not represented, unbounded.
------------------------------------------------------------------------

noHit : ℕ → ℕ → ℕ → ℕ → Maybe Unit
noHit e x y z = rec (just tt) (λ _ → nothing) (eq? (Q x y z) e)

noHit-sound : (e x y z : ℕ) → noHit e x y z ≡ just tt → ¬ Q x y z ≡ e
noHit-sound e x y z h = g (eq? (Q x y z) e) refl
  where
  g : (w : Maybe (Q x y z ≡ e)) → eq? (Q x y z) e ≡ w → ¬ Q x y z ≡ e
  g (just p) pw =
    Empty.rec (¬nothing≡just
      (sym (cong (rec (just tt) (λ _ → nothing)) pw) ∙ h))
  g nothing  pw = eq?-complete _ _ pw

scanBox : ℕ → Maybe Unit
scanBox e = loop (λ x → loop (λ y → loop (λ z → noHit e x y z) 8) 26) 26

scanExc : Maybe Unit
scanExc = loop (λ i → scanBox (exc i)) 16

scanExc-ok : scanExc ≡ just tt
scanExc-ok = refl


-- Each listed value is below the bound: one scan, one refl.
leafSm : ℕ → Maybe Unit
leafSm i = rec nothing (λ _ → just tt) (le? (suc (exc i)) 720)

scanSm-ok : loop leafSm 16 ≡ just tt
scanSm-ok = refl

