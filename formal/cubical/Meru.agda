{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मेरुः — हलायुधस्य मेरुप्रस्तारः (मृतसञ्जीवनी, ~१० शताब्दी ; पिङ्गल-भाष्यम्) ।
-- "पास्कल-त्रिकोणम्" इति ख्यातः, षट्-शताब्दीभिः पूर्वः (Pascal, १६५४) ।
-- रचना-नियमः : अग्रिम-पङ्क्तिः पूर्व-पङ्क्तेः पार्श्व-योगैः (Pascal's rule) ।
-- प्रत्येका पङ्क्तिः 2ⁿ इति योजयति — n-अक्षर-छन्दसां कुल-सङ्ख्या ।
--
-- (Halāyudha's meru-prastāra — Pascal's triangle, ~10th c., 600 years before
-- Pascal.  The next row is built from adjacent sums of the previous; each row
-- sums to 2ⁿ, the total number of n-syllable metres.)
------------------------------------------------------------------------

module Meru where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-assoc ; +-comm)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)

------------------------------------------------------------------------
-- योगः (sum), zipWith, अग्रिम-पङ्क्तिः (Pascal step) ।
------------------------------------------------------------------------

योग : List ℕ → ℕ
योग []       = zero
योग (x ∷ xs) = x + योग xs

zipWith+ : List ℕ → List ℕ → List ℕ
zipWith+ []       _        = []
zipWith+ (_ ∷ _)  []       = []
zipWith+ (x ∷ xs) (y ∷ ys) = (x + y) ∷ zipWith+ xs ys

-- अग्रिम-पङ्क्तिः : (0 ∷ row) आदि (row ++ [0]) च योजिते — Pascal's rule ।
अग्रिम : List ℕ → List ℕ
अग्रिम xs = zipWith+ (zero ∷ xs) (xs ++ (zero ∷ []))

------------------------------------------------------------------------
-- योग-सहायाः ।
------------------------------------------------------------------------

योग-++ : (xs ys : List ℕ) → योग (xs ++ ys) ≡ योग xs + योग ys
योग-++ []       ys = refl
योग-++ (x ∷ xs) ys = cong (x +_) (योग-++ xs ys) ∙ +-assoc x (योग xs) (योग ys)

-- योग (xs ++ [0]) ≡ योग xs
योग-++०  : (xs : List ℕ) → योग (xs ++ (zero ∷ [])) ≡ योग xs
योग-++० xs = योग-++ xs (zero ∷ []) ∙ +-comm (योग xs) zero

-- सम-दैर्घ्ये : योग (zipWith+ xs ys) ≡ योग xs + योग ys
योग-zip : (xs ys : List ℕ) → length xs ≡ length ys
        → योग (zipWith+ xs ys) ≡ योग xs + योग ys
योग-zip []       []       _ = refl
योग-zip []       (y ∷ ys) p = ⊥-rec (znots p)
  where open import Cubical.Data.Nat using (znots)
        open import Cubical.Data.Empty renaming (rec to ⊥-rec)
योग-zip (x ∷ xs) []       p = ⊥-rec (snotz p)
  where open import Cubical.Data.Nat using (snotz)
        open import Cubical.Data.Empty renaming (rec to ⊥-rec)
योग-zip (x ∷ xs) (y ∷ ys) p =
    cong ((x + y) +_) (योग-zip xs ys (injSuc p))
  ∙ मध्य x y (योग xs) (योग ys)
  where
  open import Cubical.Data.Nat using (injSuc)
  मध्य : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
  मध्य a b c d =
      sym (+-assoc a b (c + d))
    ∙ cong (a +_) (+-assoc b c d ∙ cong (_+ d) (+-comm b c) ∙ sym (+-assoc c b d))
    ∙ +-assoc a c (b + d)

------------------------------------------------------------------------
-- अग्रिम-द्विगुण — अग्रिम-पङ्क्तेः योगः पूर्व-योगस्य द्विगुणः ।
------------------------------------------------------------------------

length-++० : (xs : List ℕ) → length (zero ∷ xs) ≡ length (xs ++ (zero ∷ []))
length-++० xs = sym (लen xs)
  where
  लen : (xs : List ℕ) → length (xs ++ (zero ∷ [])) ≡ suc (length xs)
  लen []       = refl
  लen (x ∷ xs) = cong suc (लen xs)

अग्रिम-द्विगुण : (xs : List ℕ) → योग (अग्रिम xs) ≡ योग xs + योग xs
अग्रिम-द्विगुण xs =
    योग-zip (zero ∷ xs) (xs ++ (zero ∷ [])) (length-++० xs)
  ∙ cong (योग xs +_) (योग-++० xs)              -- योग(0∷xs)=योग xs ; योग(xs++[0])=योग xs

------------------------------------------------------------------------
-- मेरु-पङ्क्तिः च तस्याः योगः = 2ⁿ ।
------------------------------------------------------------------------

द्वि-घात : ℕ → ℕ
द्वि-घात zero    = suc zero
द्वि-घात (suc n) = द्वि-घात n + द्वि-घात n

मेरु-पङ्क्ति : ℕ → List ℕ
मेरु-पङ्क्ति zero    = suc zero ∷ []
मेरु-पङ्क्ति (suc n) = अग्रिम (मेरु-पङ्क्ति n)

पङ्क्ति-योग : (n : ℕ) → योग (मेरु-पङ्क्ति n) ≡ द्वि-घात n
पङ्क्ति-योग zero    = refl
पङ्क्ति-योग (suc n) =
    अग्रिम-द्विगुण (मेरु-पङ्क्ति n)
  ∙ cong₂ _+_ (पङ्क्ति-योग n) (पङ्क्ति-योग n)

------------------------------------------------------------------------
-- उदाहरणम् — मेरु-पङ्क्ति 4 = [1,4,6,4,1], योगः = 16 = 2⁴ (refl) ।
------------------------------------------------------------------------

उदाहरणम् : योग (मेरु-पङ्क्ति 4) ≡ 16
उदाहरणम् = refl
