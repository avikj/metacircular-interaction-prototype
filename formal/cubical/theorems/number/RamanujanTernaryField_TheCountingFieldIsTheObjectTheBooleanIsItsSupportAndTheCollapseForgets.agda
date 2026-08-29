{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, क्षेत्र — THE COUNTING FIELD IS THE OBJECT, THE BOOLEAN IS
-- ITS SUPPORT, AND THE COLLAPSE FORGETS.
--
-- The corpus's Goldbach lane established the method: the quantitative
-- field (the counts) is the mathematical object; the boolean
-- (representable or not) is its support predicate; and collapsing the
-- field to its support destroys exactly the structure the analysis
-- runs on.  This file builds the same two-layer reading for
-- Ramanujan's form x² + y² + 10z²:
--
--   `rC` — the octant counting field: for n below 720, the number of
--     ℕ-triples representing n, counted over the box the growth
--     bounds prove sufficient.  This is the theta-coefficient of the
--     form, restricted to the octant, and it is the object.
--
--   `the-boolean-is-the-support` — for n < 720, Rep n holds exactly
--     when 1 ≤ rC n: the boolean IS the support of the field, both
--     directions proved (a witness pushes its indicator through the
--     three sum layers; silence of the finders zeroes every
--     indicator).
--
--   `the-collapse-forgets` — the loss, witnessed: 1 and 2 are both
--     represented — the boolean identifies them — while the field
--     separates them, rC 1 ≡ 2 against rC 2 ≡ 1.  What the genus
--     theory of the form reads is in the counts; the support has
--     already thrown it away.  This is BooleanGoldbachInformationLoss
--     said at a ternary form.
------------------------------------------------------------------------

module RamanujanTernaryField_TheCountingFieldIsTheObjectTheBooleanIsItsSupportAndTheCollapseForgets where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ;
         ≤-trans ; <-split ; ≤SumLeft ; ≤SumRight)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; ¬nothing≡just)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (eq?-complete)
open import RamanujanTernaryGate_TheKernelScansBelowSevenTwentyOnceAndCachesTheVerdict
  using (Q ; Rep)
open import RamanujanTernary_BelowSevenTwentyTheOddExceptionsAreExactlyHisSeventeenTowardTheOpenList
  using (xy-bound ; z-bound)
open import RamanujanTernaryUpadhi_TheUniversalClaimIsATypeTheGateRestrictsItAndNoTermRunsBackwards
  using (rep-decidable-below-720)

------------------------------------------------------------------------
-- §1  The field.
------------------------------------------------------------------------

ind : ℕ → ℕ → ℕ → ℕ → ℕ
ind n x y z = rec 0 (λ _ → 1) (eq? (Q x y z) n)

countZ : ℕ → ℕ → ℕ → ℕ → ℕ
countZ n x y zero    = ind n x y zero
countZ n x y (suc b) = ind n x y (suc b) + countZ n x y b

countY : ℕ → ℕ → ℕ → ℕ
countY n x zero    = countZ n x zero 8
countY n x (suc b) = countZ n x (suc b) 8 + countY n x b

countX : ℕ → ℕ → ℕ
countX n zero    = countY n zero 26
countX n (suc b) = countY n (suc b) 26 + countX n b

-- The octant counting field, on the window the bounds certify.
rC : ℕ → ℕ
rC n = countX n 26

------------------------------------------------------------------------
-- §2  A witness pushes its indicator through the sums.
------------------------------------------------------------------------

ind-hit : (n x y z : ℕ) → Q x y z ≡ n → 1 ≤ ind n x y z
ind-hit n x y z p = g (eq? (Q x y z) n) refl
  where
  g : (w : Maybe (Q x y z ≡ n)) → eq? (Q x y z) n ≡ w → 1 ≤ ind n x y z
  g (just _) pw =
    subst (λ v → 1 ≤ rec 0 (λ _ → 1) v) (sym pw) (zero , refl)
  g nothing  pw = Empty.rec (eq?-complete _ _ pw p)

lbZ : (n x y z b : ℕ) → z ≤ b → 1 ≤ ind n x y z → 1 ≤ countZ n x y b
lbZ n x y z zero    hz hi = go (<-split (suc-≤-suc hz))
  where
  go : (z < zero) ⊎ (z ≡ zero) → 1 ≤ countZ n x y zero
  go (inl z0) = Empty.rec (¬-<-zero z0)
  go (inr z0) = subst (λ v → 1 ≤ ind n x y v) z0 hi
lbZ n x y z (suc b) hz hi = go (<-split (suc-≤-suc hz))
  where
  go : (z < suc b) ⊎ (z ≡ suc b) → 1 ≤ countZ n x y (suc b)
  go (inl zb) =
    ≤-trans (lbZ n x y z b (pred-≤-pred zb) hi)
            (≤SumRight {n = countZ n x y b} {k = ind n x y (suc b)})
  go (inr zb) =
    ≤-trans (subst (λ v → 1 ≤ ind n x y v) zb hi)
            (≤SumLeft {n = ind n x y (suc b)} {k = countZ n x y b})

lbY : (n x y b : ℕ) → y ≤ b → 1 ≤ countZ n x y 8 → 1 ≤ countY n x b
lbY n x y zero    hy hc = go (<-split (suc-≤-suc hy))
  where
  go : (y < zero) ⊎ (y ≡ zero) → 1 ≤ countY n x zero
  go (inl y0) = Empty.rec (¬-<-zero y0)
  go (inr y0) = subst (λ v → 1 ≤ countZ n x v 8) y0 hc
lbY n x y (suc b) hy hc = go (<-split (suc-≤-suc hy))
  where
  go : (y < suc b) ⊎ (y ≡ suc b) → 1 ≤ countY n x (suc b)
  go (inl yb) =
    ≤-trans (lbY n x y b (pred-≤-pred yb) hc)
            (≤SumRight {n = countY n x b} {k = countZ n x (suc b) 8})
  go (inr yb) =
    ≤-trans (subst (λ v → 1 ≤ countZ n x v 8) yb hc)
            (≤SumLeft {n = countZ n x (suc b) 8} {k = countY n x b})

lbX : (n x b : ℕ) → x ≤ b → 1 ≤ countY n x 26 → 1 ≤ countX n b
lbX n x zero    hx hc = go (<-split (suc-≤-suc hx))
  where
  go : (x < zero) ⊎ (x ≡ zero) → 1 ≤ countX n zero
  go (inl x0) = Empty.rec (¬-<-zero x0)
  go (inr x0) = subst (λ v → 1 ≤ countY n v 26) x0 hc
lbX n x (suc b) hx hc = go (<-split (suc-≤-suc hx))
  where
  go : (x < suc b) ⊎ (x ≡ suc b) → 1 ≤ countX n (suc b)
  go (inl xb) =
    ≤-trans (lbX n x b (pred-≤-pred xb) hc)
            (≤SumRight {n = countX n b} {k = countY n (suc b) 26})
  go (inr xb) =
    ≤-trans (subst (λ v → 1 ≤ countY n v 26) xb hc)
            (≤SumLeft {n = countY n (suc b) 26} {k = countX n b})

------------------------------------------------------------------------
-- §3  Absence zeroes every indicator.
------------------------------------------------------------------------

ind-miss : (n x y z : ℕ) → ¬ Rep n → ind n x y z ≡ 0
ind-miss n x y z nr = g (eq? (Q x y z) n) refl
  where
  g : (w : Maybe (Q x y z ≡ n)) → eq? (Q x y z) n ≡ w → ind n x y z ≡ 0
  g (just p) pw = Empty.rec (nr (x , y , z , p))
  g nothing  pw = cong (rec 0 (λ _ → 1)) pw

zZ : (n x y b : ℕ) → ¬ Rep n → countZ n x y b ≡ 0
zZ n x y zero    nr = ind-miss n x y zero nr
zZ n x y (suc b) nr =
  cong (_+ countZ n x y b) (ind-miss n x y (suc b) nr) ∙ zZ n x y b nr

zY : (n x b : ℕ) → ¬ Rep n → countY n x b ≡ 0
zY n x zero    nr = zZ n x zero 8 nr
zY n x (suc b) nr =
  cong (_+ countY n x b) (zZ n x (suc b) 8 nr) ∙ zY n x b nr

zX : (n b : ℕ) → ¬ Rep n → countX n b ≡ 0
zX n zero    nr = zY n zero 26 nr
zX n (suc b) nr =
  cong (_+ countX n b) (zY n (suc b) 26 nr) ∙ zX n b nr

------------------------------------------------------------------------
-- §4  THE SUPPORT THEOREM, and the loss.
------------------------------------------------------------------------

-- For n in the certified window, the boolean IS the support of the
-- counting field: represented exactly when the count is positive.
the-boolean-is-the-support : (n : ℕ) → n < 720 →
  (Rep n → 1 ≤ rC n) × ((1 ≤ rC n) → Rep n)
the-boolean-is-the-support n n< = fore , back
  where
  fore : Rep n → 1 ≤ rC n
  fore (x , y , z , p) =
    lbX n x 26
      (xy-bound x n n< (subst (x · x ≤_) p
        (≤-trans (≤SumLeft {n = x · x} {k = y · y})
                 (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)}))))
      (lbY n x y 26
        (xy-bound y n n< (subst (y · y ≤_) p
          (≤-trans (≤SumRight {n = y · y} {k = x · x})
                   (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)}))))
        (lbZ n x y z 8
          (z-bound z n n< (subst (10 · (z · z) ≤_) p
            (≤SumRight {n = 10 · (z · z)} {k = x · x + y · y})))
          (ind-hit n x y z p)))

  back : 1 ≤ rC n → Rep n
  back h = g (rep-decidable-below-720 n n<)
    where
    g : Rep n ⊎ (¬ Rep n) → Rep n
    g (inl r)  = r
    g (inr nr) =
      Empty.rec (¬-<-zero (subst (1 ≤_) (zX n 26 nr) h))

-- THE LOSS, witnessed.  The boolean identifies 1 and 2 — both
-- represented — while the field separates them.  The collapse from
-- count to support is the destruction, exhibited.
the-collapse-forgets :
  (rC 1 ≡ 2) × (rC 2 ≡ 1) × Rep 1 × Rep 2
the-collapse-forgets =
  refl , refl , (1 , 0 , 0 , refl) , (1 , 1 , 0 , refl)
