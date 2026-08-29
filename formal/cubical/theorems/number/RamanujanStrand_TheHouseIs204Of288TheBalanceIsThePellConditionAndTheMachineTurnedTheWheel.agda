{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, स्ट्रैण्ड — THE HOUSE IS 204 OF 288, THE BALANCE IS THE
-- PELL CONDITION, AND THE MACHINE TURNED THE WHEEL.
--
-- The Strand puzzle Mahalanobis read to Ramanujan (1914): houses
-- 1..n; find the house k whose left neighbours sum like its right
-- neighbours.  Ramanujan dictated the continued fraction from the
-- stove.  This file checks the mathematics his flash contained:
--
--   `the-house-balances` — Σ(1..203) + Σ(1..204) ≡ Σ(1..288), the
--     subtraction-free form of "left sum equals right sum" at
--     n = 288, k = 204: by refl, the kernel summing all three.
--
--   `the-wheel's-solution` — 577² ≡ 2·408² + 1 by refl, with
--     2·288+1 ≡ 577 and 2·204 ≡ 408 by refl: the balanced house IS
--     the Pell point.  The wheel itself was turned by the yantra:
--     asked vargaprakrti D = 2 over the wire, it answered the
--     fundamental (3, 2) with its composition law CHECKED
--     multiplicative at every turn, and named in its vyaya exactly
--     what it does not re-prove (the descent's termination, asserted
--     and used since 628).  577/408 is the fourth turn of that wheel.
--
--   `balance-is-pell` / `pell-is-balance` — THE BRIDGE, for every n
--     and k: 2k² ≡ n(n+1) exactly when (2n+1)² ≡ 2(2k)² + 1.  The
--     proof is semiring algebra made explicit — an interchange lemma
--     and two four-fold regroupings, with the converse by
--     cancellation of ·4 and of the trailing +1.  No division and no
--     subtraction occur anywhere: the tradition's own discipline.
--
-- So Ramanujan's answer is verified, and his method is honored: the
-- balance is a point on Brahmagupta's wheel, and the wheel is an
-- organ of this repository's machine.
------------------------------------------------------------------------

module RamanujanStrand_TheHouseIs204Of288TheBalanceIsThePellConditionAndTheMachineTurnedTheWheel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; +-assoc ; +-zero ;
         ·-suc ; ·-distribʳ ; ·-distribˡ ; injSuc ; inj-·sm ; 0≡m·0)

------------------------------------------------------------------------
-- §1  The balance, by computation.
------------------------------------------------------------------------

sumTo : ℕ → ℕ
sumTo zero    = zero
sumTo (suc n) = suc n + sumTo n

-- Left of the house plus through the house equals the whole street:
-- Σ(1..k−1) = Σ(1..n) − Σ(1..k), said without subtraction.
the-house-balances : sumTo 203 + sumTo 204 ≡ sumTo 288
the-house-balances = refl

------------------------------------------------------------------------
-- §2  The Pell point, by computation, on the machine's wheel.
------------------------------------------------------------------------

pell-instance : 577 · 577 ≡ 2 · (408 · 408) + 1
pell-instance = refl

house-to-pell-x : 2 · 288 + 1 ≡ 577
house-to-pell-x = refl

house-to-pell-y : 2 · 204 ≡ 408
house-to-pell-y = refl

-- And the balanced-house condition itself, at Ramanujan's numbers.
house-288 : 2 · (204 · 204) ≡ 288 · suc 288
house-288 = refl

------------------------------------------------------------------------
-- §3  The interchange, and four-fold regrouping.
------------------------------------------------------------------------

interchange : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
interchange a b c d =
  sym (+-assoc a b (c + d))
  ∙ cong (a +_) (+-assoc b c d
                 ∙ cong (_+ d) (+-comm b c)
                 ∙ sym (+-assoc c b d))
  ∙ +-assoc a c (b + d)

·2-unfold : (x : ℕ) → 2 · x ≡ x + x
·2-unfold x = cong (x +_) (+-zero x)

·4-unfold : (x : ℕ) → x · 4 ≡ (x + x) + (x + x)
·4-unfold x =
  ·-suc x 3
  ∙ cong (x +_) (·-suc x 2
      ∙ cong (x +_) (·-suc x 1
          ∙ cong (x +_) (·-suc x 0
              ∙ cong (x +_) (sym (0≡m·0 x))
              ∙ +-zero x)))
  ∙ +-assoc x x (x + x)

double-square : (x : ℕ) →
  (x + x) · (x + x) ≡ (x · x + x · x) + (x · x + x · x)
double-square x =
  sym (·-distribʳ x x (x + x))
  ∙ cong (λ z → z + z) (sym (·-distribˡ x x x))

------------------------------------------------------------------------
-- §4  The key identity: (2n+1)² ≡ (n(n+1))·4 + 1.
------------------------------------------------------------------------

odd-square : (n : ℕ) →
  suc (n + n) · suc (n + n) ≡ (n · suc n) · 4 + 1
odd-square n =
  step1 ∙ cong suc step2 ∙ sym step3
  where
  m : ℕ
  m = n + n

  s : ℕ
  s = n · n

  step1 : suc m · suc m ≡ suc (m + (m + m · m))
  step1 = cong (λ z → suc (m + z)) (·-suc m m)

  step2 : m + (m + m · m) ≡ ((n + n) + (n + n)) + ((s + s) + (s + s))
  step2 =
    cong (λ z → m + (m + z)) (double-square n)
    ∙ +-assoc m m ((s + s) + (s + s))

  step3 : (n · suc n) · 4 + 1
            ≡ suc (((n + n) + (n + n)) + ((s + s) + (s + s)))
  step3 =
    +-comm ((n · suc n) · 4) 1
    ∙ cong suc
        ( ·4-unfold (n · suc n)
        ∙ cong (λ t → (t + t) + (t + t)) (·-suc n n)
        ∙ cong (λ z → z + z) (interchange n s n s)
        ∙ interchange (n + n) (s + s) (n + n) (s + s) )

------------------------------------------------------------------------
-- §5  THE BRIDGE.
------------------------------------------------------------------------

Balanced : ℕ → ℕ → Type
Balanced n k = 2 · (k · k) ≡ n · suc n

Pell : ℕ → ℕ → Type
Pell x y = x · x ≡ 2 · (y · y) + 1

double-of-square : (k : ℕ) →
  2 · ((k + k) · (k + k)) ≡ (2 · (k · k)) · 4
double-of-square k =
  ·2-unfold ((k + k) · (k + k))
  ∙ cong (λ z → z + z) (double-square k)
  ∙ sym (·4-unfold (k · k + k · k))
  ∙ cong (_· 4) (sym (·2-unfold (k · k)))

balance-is-pell : (n k : ℕ) → Balanced n k → Pell (suc (n + n)) (k + k)
balance-is-pell n k bal =
  odd-square n
  ∙ cong (_+ 1) (cong (_· 4) (sym bal) ∙ sym (double-of-square k))

pell-is-balance : (n k : ℕ) → Pell (suc (n + n)) (k + k) → Balanced n k
pell-is-balance n k pl =
  inj-·sm {m = 3} (injSuc peeled)
  where
  E : (2 · (k · k)) · 4 + 1 ≡ (n · suc n) · 4 + 1
  E = sym (cong (_+ 1) (double-of-square k))
      ∙ sym pl
      ∙ odd-square n

  peeled : suc ((2 · (k · k)) · 4) ≡ suc ((n · suc n) · 4)
  peeled =
    sym (+-comm ((2 · (k · k)) · 4) 1)
    ∙ E
    ∙ +-comm ((n · suc n) · 4) 1

-- At Ramanujan's numbers the bridge and the instance meet: the house
-- is the Pell point, 288 = 144+144 and 204 = 102+102 definitionally.
the-flash-was-exact : Pell 577 408
the-flash-was-exact = balance-is-pell 288 204 house-288
