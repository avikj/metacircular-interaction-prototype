{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्वर्णसीमा — विरहाङ्क-युग्मे वल्ली दीर्घतमा, सर्ववल्ली विरहाङ्क-व्युत्क्रमात् ह्रस्वा ।
-- Svarnasima — the golden boundary: the vallī of two consecutive
-- Virahāṅka numbers is the longest, and every vallī is shorter than the
-- Virahāṅka inverse of its divisor.
--
-- THE ABSENCE THIS FILE CLOSES.  `KuttakaSamapti_TheValliIsFiniteForEveryPair`
-- proves that Āryabhaṭa's pulverizer (आर्यभटीयम्, गणितपादः ३२–३३, 499 CE)
-- terminates on every pair of naturals and that its column has at most b
-- rows.  Its scope section then says, verbatim:
--
--     "The SHARP length bound.  `≤ b` is what the measure gives directly and
--      it is honest.  The true worst case is logarithmic in b — attained on
--      consecutive Virahāṅka numbers (Virahāṅka, c. 700, the recurrence
--      usually credited to Fibonacci), where every quotient is 1 — and that
--      is NOT proved here.  Quoting `≤ b` as the truth about the length would
--      be the error `HOLOGRAM.md` §7 records: a bound stated without its real
--      scaling, which looks like knowledge.  So: `≤ b` is CHECKED, O(log b) is
--      TRUE, and the gap is named and open."
--
-- Hieroglyphics II names the same boundary: χ = 1 ⇝ स्वर्णसीमा, the golden
-- boundary where the rate of reach equals the rate of kill — every quotient
-- is 1.  This module proves both halves of that sentence, in the vallī
-- representation of the earlier module and with its Virahāṅka sequence
-- taken from the corpus's own metre lane (`PingalaPrastara.matra`, the
-- count of mātrā-metres, M 0 = M 1 = 1, M (n+2) = M (n+1) + M n).
--
-- WHAT IS PROVED.  No postulates, no holes, --safe, Agda 2.8.0 + cubical
-- v0.9.  Nothing here uses a ring solver.
--
--   स्वर्ण-वल्ली      THE LOWER BOUND, constructed.  For every n an explicit
--                   vallī of the consecutive pair (M (n+2), M (n+1)), built
--                   by induction: each row is M (n+3) = 1·M (n+2) + M (n+1)
--                   with M (n+1) < M (n+2), down to the last row
--                   2 = 2·1 + 0.  Its length is n+1 (`स्वर्ण-दैर्घ्यम्`) and its
--                   column is n ones followed by a single 2 (`स्वर्ण-सूचिः`).
--                   ON "EVERY QUOTIENT IS 1": every quotient is 1 except
--                   the LAST, which is forced to be 2 — the column of (2,1)
--                   is the single row 2 = 2·1 + 0, and no vallī of (2,1) has
--                   quotient 1, since 2 = 1·1 + 1 would need 1 < 1.  The
--                   informal sentence is exact about every row that has a
--                   successor; this file states the last row honestly.
--   भाजक-सीमा       LAMÉ'S THEOREM, THE UPPER BOUND, in the vallī
--   भाज्य-सीमा       representation: if a vallī of (a, b) with b ≥ 1 has n
--                   division steps then M n ≤ b; and if moreover b < a then
--                   M (n+1) ≤ a.  Mutual induction on the vallī.  Its only
--                   inputs are the `r < b` each row carries (which is also
--                   what makes every quotient after the first ≥ 1) and the
--                   division equation.  (Lamé, 1844, is the European
--                   restatement; the descent and its measure are
--                   Āryabhaṭa's, the sequence Virahāṅka's.)
--   तीक्ष्ण-सीमा      THE SHARP FORM.  For every vallī of (a, b) with b ≥ 1
--                   and every n with b < M n, the length is < n.  In
--                   particular the length is below the LEAST n with M n > b
--                   — the Virahāṅka inverse of b.  No `log` is defined in
--                   the pinned library, and none is needed: this is the
--                   honest sharp statement, and `द्विघात-सीमा` gives its
--                   logarithmic reading without a logarithm —
--                   b < 2^k  →  length < 2k — from M (k+k) ≥ 2^k.
--   स्वर्ण-उत्कर्षः    THE GOLDEN PAIR IS THE WORST CASE.  Every vallī whose
--                   divisor is ≤ M (n+1) is no longer than `स्वर्ण-वल्ली n`.
--                   Lower and upper bound meet: the bound is attained, so it
--                   is sharp, not merely true.
--   §5              Refl checks: M 6 ≡ 13, M 10 ≡ 89; the vallī the earlier
--                   module's termination proof COMPUTES for (13, 8) has 5
--                   rows and column 1 1 1 1 2, and for (89, 55) has 9 rows;
--                   these agree with `स्वर्ण-वल्ली 4` and `स्वर्ण-वल्ली 8`.
--
-- WHAT IS NOT PROVED.  A statement with a real-valued logarithm — there is
-- no `log` in cubical v0.9 and the corpus does not define one.  The
-- Virahāṅka-inverse form and the 2^k form above are what "O(log b)" means
-- over ℕ, and both are checked; nothing sharper is claimed.  Nothing here
-- touches the इष्ट section or the cakravāla, which stay as the earlier
-- module leaves them.
------------------------------------------------------------------------

module Svarnasima_TheValliOfConsecutiveVirahankaNumbersIsTheLongestAndEveryValliIsShorterThanTheVirahankaInverse where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _^_ ; +-zero ; +-suc ; +-comm ; ·-identityˡ)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-trans ; ≤-refl ; suc-≤-suc ; pred-≤-pred ; zero-≤
        ; ≤SumLeft ; ≤-k+ ; ≤-+k ; ≤-+-≤ ; <-asym ; <-weaken ; <≤-trans
        ; ¬-<-zero ; splitℕ-≤)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)

open import PingalaPrastara using (matra)
open import KuttakaSamapti_TheValliIsFiniteForEveryPair
  using (वल्ली ; विश्रामः ; छेदः ; दैर्घ्यम् ; सूचिः ; कुट्टक-समाप्तिः)

------------------------------------------------------------------------
-- १ · विरहाङ्कः — the sequence, from the metre lane, and what it does.
--
-- `matra n` counts the metres of duration n (PingalaPrastara.matraCount);
-- M 0 = M 1 = 1, M (n+2) = M (n+1) + M n.  Three facts about it are used:
-- it is positive, it is monotone, and from index 1 on it is STRICTLY
-- increasing — the last is exactly the `r < b` a golden row must carry.
------------------------------------------------------------------------

विरहाङ्कः : ℕ → ℕ
विरहाङ्कः = matra

विरह-धनम् : (n : ℕ) → 0 < विरहाङ्कः n
विरह-धनम् zero          = ≤-refl
विरह-धनम् (suc zero)    = ≤-refl
विरह-धनम् (suc (suc n)) = ≤-trans (विरह-धनम् (suc n)) ≤SumLeft

-- M n ≤ M (n+1)
विरह-सोपानम् : (n : ℕ) → विरहाङ्कः n ≤ विरहाङ्कः (suc n)
विरह-सोपानम् zero    = ≤-refl
विरह-सोपानम् (suc n) = ≤SumLeft

-- M (n+1) < M (n+2): the second summand M n is positive.
विरह-वर्धते : (n : ℕ) → विरहाङ्कः (suc n) < विरहाङ्कः (suc (suc n))
विरह-वर्धते n =
  subst (_≤ विरहाङ्कः (suc n) + विरहाङ्कः n)
        (+-comm (विरहाङ्कः (suc n)) 1)
        (≤-k+ (विरह-धनम् n))

private
  विरह-एकदिक् : (k n : ℕ) → विरहाङ्कः n ≤ विरहाङ्कः (k + n)
  विरह-एकदिक् zero    n = ≤-refl
  विरह-एकदिक् (suc k) n = ≤-trans (विरह-एकदिक् k n) (विरह-सोपानम् (k + n))

विरह-अनुलोमम् : {m n : ℕ} → m ≤ n → विरहाङ्कः m ≤ विरहाङ्कः n
विरह-अनुलोमम् {m} (k , p) =
  subst (λ x → विरहाङ्कः m ≤ विरहाङ्कः x) p (विरह-एकदिक् k m)

-- M (k+k) ≥ 2^k: two steps of the recurrence at least double.
विरह-द्विघातः : (k : ℕ) → 2 ^ k ≤ विरहाङ्कः (k + k)
विरह-द्विघातः zero    = ≤-refl
विरह-द्विघातः (suc k) =
  subst (λ x → 2 ^ suc k ≤ विरहाङ्कः (suc x)) (sym (+-suc k k))
        (≤-+-≤ (≤-trans ih (विरह-सोपानम् (k + k)))
               (subst (_≤ विरहाङ्कः (k + k)) (sym (+-zero (2 ^ k))) ih))
  where
    ih : 2 ^ k ≤ विरहाङ्कः (k + k)
    ih = विरह-द्विघातः k

------------------------------------------------------------------------
-- २ · स्वर्ण-वल्ली — THE LOWER BOUND, constructed.
--
-- The vallī of (M (n+2), M (n+1)).  Every row but the last is
-- M (n+3) = 1·M (n+2) + M (n+1), with the measure M (n+1) < M (n+2) supplied
-- by `विरह-वर्धते`; the last row is 2 = 2·1 + 0.
------------------------------------------------------------------------

स्वर्ण-वल्ली : (n : ℕ) → वल्ली (विरहाङ्कः (suc (suc n))) (विरहाङ्कः (suc n)) 1
स्वर्ण-वल्ली zero    = छेदः 2 1 2 0 1 ≤-refl refl (विश्रामः 1)
स्वर्ण-वल्ली (suc n) =
  छेदः (विरहाङ्कः (suc (suc (suc n)))) (विरहाङ्कः (suc (suc n)))
       1 (विरहाङ्कः (suc n)) 1
       (विरह-वर्धते n)
       (cong (_+ विरहाङ्कः (suc n)) (sym (·-identityˡ (विरहाङ्कः (suc (suc n))))))
       (स्वर्ण-वल्ली n)

-- its length is n+1: one row per index, down to (2, 1).
स्वर्ण-दैर्घ्यम् : (n : ℕ) → दैर्घ्यम् (स्वर्ण-वल्ली n) ≡ suc n
स्वर्ण-दैर्घ्यम् zero    = refl
स्वर्ण-दैर्घ्यम् (suc n) = cong suc (स्वर्ण-दैर्घ्यम् n)

-- its column: n ones, then the forced final 2.
एकाः : ℕ → List ℕ
एकाः zero    = []
एकाः (suc n) = 1 ∷ एकाः n

स्वर्ण-सूचिः : (n : ℕ) → सूचिः (स्वर्ण-वल्ली n) ≡ एकाः n ++ (2 ∷ [])
स्वर्ण-सूचिः zero    = refl
स्वर्ण-सूचिः (suc n) = cong (1 ∷_) (स्वर्ण-सूचिः n)

------------------------------------------------------------------------
-- ३ · लामे-सीमा — THE UPPER BOUND (Lamé), in the vallī representation.
--
-- Mutual induction.  `भाजक-सीमा` bounds the divisor: a vallī of (a, b) with
-- b ≥ 1 and n rows has M n ≤ b.  `भाज्य-सीमा` bounds the dividend: if b < a
-- then M (n+1) ≤ a.  The dividend bound is the one that carries the
-- induction — a row a = q·b + r with b < a has q ≥ 1, so a ≥ b + r, and
-- b, r are bounded by the two Virahāṅka numbers the sub-column supplies.
-- The hypothesis b < a is needed only at the top: every row after the
-- first has it for free, since the sub-column's pair is (b, r) with r < b.
------------------------------------------------------------------------

private
  -- a = q·b + r with r < b < a forces q ≥ 1, hence b + r ≤ a.
  योग-सीमा : (a b q r : ℕ) → a ≡ q · b + r → r < b → b < a → b + r ≤ a
  योग-सीमा a b zero    r eq r<b b<a =
    ⊥rec (<-asym b<a (subst (_≤ b) (sym eq) (<-weaken r<b)))
  योग-सीमा a b (suc q) r eq r<b b<a =
    subst (b + r ≤_) (sym eq)
          (≤-+k {m = b} {n = b + q · b} {k = r} (≤SumLeft {n = b} {k = q · b}))

भाजक-सीमा : {a b g : ℕ} (v : वल्ली a b g) → 0 < b → विरहाङ्कः (दैर्घ्यम् v) ≤ b
भाज्य-सीमा : {a b g : ℕ} (v : वल्ली a b g) → b < a
           → विरहाङ्कः (suc (दैर्घ्यम् v)) ≤ a

भाजक-सीमा (विश्रामः g)               0<0 = ⊥rec (¬-<-zero 0<0)
भाजक-सीमा (छेदः a b q r g r<b eq v) _   = भाज्य-सीमा v r<b

भाज्य-सीमा (विश्रामः g) 0<g = 0<g
-- the sub-column is empty: r = 0, one row, and a > b ≥ 1 gives a ≥ 2 = M 2.
भाज्य-सीमा (छेदः a b q r g r<b eq (विश्रामः _)) b<a =
  ≤-trans (suc-≤-suc r<b) b<a
-- the sub-column is not empty: r > 0, and
--   M (n+2) = M (n+1) + M n ≤ b + r ≤ a.
भाज्य-सीमा (छेदः a b q r g r<b eq v@(छेदः _ _ _ r' _ r'<r _ _)) b<a =
  ≤-trans (≤-+-≤ (भाज्य-सीमा v r<b)
                 (भाजक-सीमा v (≤-trans (suc-≤-suc zero-≤) r'<r)))
          (योग-सीमा a b q r eq r<b b<a)

------------------------------------------------------------------------
-- ४ · तीक्ष्ण-सीमा — THE SHARP FORM, and that it is attained.
------------------------------------------------------------------------

-- the length is below every n whose Virahāṅka number exceeds the divisor;
-- in particular below the least such n, the Virahāṅka inverse of b.
तीक्ष्ण-सीमा : {a b g : ℕ} (v : वल्ली a b g) → 0 < b
           → (n : ℕ) → b < विरहाङ्कः n → दैर्घ्यम् v < n
तीक्ष्ण-सीमा v 0<b n b<Mn with splitℕ-≤ n (दैर्घ्यम् v)
... | inl n≤len = ⊥rec (<-asym b<Mn (≤-trans (विरह-अनुलोमम् n≤len) (भाजक-सीमा v 0<b)))
... | inr len<n = len<n

-- the logarithmic reading, with no logarithm: b < 2^k  →  fewer than 2k rows.
द्विघात-सीमा : {a b g : ℕ} (v : वल्ली a b g) → 0 < b
           → (k : ℕ) → b < 2 ^ k → दैर्घ्यम् v < k + k
द्विघात-सीमा v 0<b k b<2^k =
  तीक्ष्ण-सीमा v 0<b (k + k) (<≤-trans b<2^k (विरह-द्विघातः k))

-- THE GOLDEN PAIR IS THE WORST CASE: no vallī whose divisor is ≤ M (n+1)
-- is longer than स्वर्ण-वल्ली n, whose divisor is exactly M (n+1).
स्वर्ण-उत्कर्षः : {a b g : ℕ} (v : वल्ली a b g) → 0 < b
            → (n : ℕ) → b ≤ विरहाङ्कः (suc n)
            → दैर्घ्यम् v ≤ दैर्घ्यम् (स्वर्ण-वल्ली n)
स्वर्ण-उत्कर्षः v 0<b n b≤M =
  subst (दैर्घ्यम् v ≤_) (sym (स्वर्ण-दैर्घ्यम् n))
        (pred-≤-pred (तीक्ष्ण-सीमा v 0<b (suc (suc n))
                                   (≤-trans (suc-≤-suc b≤M) (विरह-वर्धते n))))

-- and the upper bound is met with equality on the golden pair itself:
-- Lamé says M (length) ≤ divisor, and here both sides are M (n+1).
स्वर्ण-स्पर्शः : (n : ℕ) → विरहाङ्कः (दैर्घ्यम् (स्वर्ण-वल्ली n)) ≡ विरहाङ्कः (suc n)
स्वर्ण-स्पर्शः n = cong विरहाङ्कः (स्वर्ण-दैर्घ्यम् n)

------------------------------------------------------------------------
-- ५ · अ-रिक्तता — the numbers, by computation.
--
-- The vallī is taken from `कुट्टक-समाप्तिः`, the earlier module's
-- termination proof, so this checks that the pulverizer it COMPUTES lands
-- on the golden column, not only that a hand-built one does.
------------------------------------------------------------------------

विरह-६ : विरहाङ्कः 6 ≡ 13
विरह-६ = refl

विरह-१० : विरहाङ्कः 10 ≡ 89
विरह-१० = refl

-- (13, 8) = (M 6, M 5): five rows, column 1 1 1 1 2.
दैर्घ्यम्-१३-८ : दैर्घ्यम् (snd (कुट्टक-समाप्तिः 13 8)) ≡ 5
दैर्घ्यम्-१३-८ = refl

सूचिः-१३-८ : सूचिः (snd (कुट्टक-समाप्तिः 13 8)) ≡ 1 ∷ 1 ∷ 1 ∷ 1 ∷ 2 ∷ []
सूचिः-१३-८ = refl

स्वर्ण-१३-८ : सूचिः (स्वर्ण-वल्ली 4) ≡ सूचिः (snd (कुट्टक-समाप्तिः 13 8))
स्वर्ण-१३-८ = refl

-- (89, 55) = (M 10, M 9): nine rows.
दैर्घ्यम्-८९-५५ : दैर्घ्यम् (snd (कुट्टक-समाप्तिः 89 55)) ≡ 9
दैर्घ्यम्-८९-५५ = refl

स्वर्ण-८९-५५ : सूचिः (स्वर्ण-वल्ली 8) ≡ सूचिः (snd (कुट्टक-समाप्तिः 89 55))
स्वर्ण-८९-५५ = refl

-- the sharp bound at b = 8: M 6 = 13 > 8, so fewer than 6 rows — and there
-- are 5; the earlier module's `≤ b` said 8.
सीमा-१३-८ : दैर्घ्यम् (snd (कुट्टक-समाप्तिः 13 8)) < 6
सीमा-१३-८ = तीक्ष्ण-सीमा (snd (कुट्टक-समाप्तिः 13 8)) (suc-≤-suc zero-≤) 6 (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc zero-≤)))))))))
