{-# OPTIONS --cubical --safe #-}
--
-- मूल-शक्तिः — the root is a power, and ζ is a translation.
--
-- Six questions, asked at once of the same object, because they are one
-- question wearing six faces.  The object is `घातः t bs` from
-- `EkaGhataVivrtti_...`: one rank-one product over the places, ∏ᵢ (χ(bᵢ) +
-- σ(bᵢ)·t), whose k-th coefficient is the k-marked squarefree charge.
--
--   1.  घातः t bs        ≡ (t − 1) ^ ω        — the product has a closed form
--   2.  ज्योति-घातः t bs   ≡ t ^ ω             — so does its ζ twist
--   3.  ज्योति-घातः t bs   ≡ घातः (t + 1) bs    — hence THE ζ TWIST IS t ↦ t+1
--   4.  विवृत्तिः bs k      ≡ बिन्दुः ω k         — every level factors through ω
--   5.  बिन्दुः is Piṅgala's array with the Möbius sign: (−1)^{ω−k}·C(ω,k)
--   6.  बिन्दुः m k        ≡ 0 for k > m        — the tower is finite
--
-- (3) is the one worth naming.  Dirichlet convolution with the constant
-- function, applied at every place at once, is EXACTLY a unit translation of
-- the marking parameter; Möbius inversion is t ↦ t − 1.  The μ/ζ duality
-- that the sieve lane spends its life managing is, in this coordinate, a
-- shift by one.
--
-- (4) is the one that bites.  `NaturalMachine/QuotientFiberLaw.agda`: an
-- observation class sees exactly a quotient.  The whole hierarchy of marked
-- charges is blind to WHICH places are active and sees only HOW MANY — the
-- quotient is ω, on the nose, and the fiber is everything the tower cannot
-- distinguish.  Which is why no amount of work with these tensors can see
-- an individual prime.
module MulaShakti_TheMarkingParameterIsAPowerAndTheZetaTwistIsTranslationByOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Nat using (ℕ; zero; suc; +-suc) renaming (_+_ to _+ℕ_)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Int using (ℤ; pos; -_; _+_; _·_; pos0+; +Comm; +Assoc)

open import OjaYugma_TheSquarefreeChargeIsTheActivePlaceCountTimesTheParityCharacter
  using (चिह्नम्; सक्रियम्; ओजः; पर्यायः; आवेशः)
open import EkaGhataVivrtti_TheWholeChargeIsTheFirstOrderTermOfOneRankOneProduct
  using (घातः; विवृत्तिः)
open import JyotiVivrtti_TheZetaTwistSendsTheMarkedChargeTowerToTheOmegaStratification
  using (निष्क्रियम्)

एकम् : ℤ
एकम् = pos (suc zero)

-- ------------------------------------------------------------------ power
शक्तिः : ℤ → ℕ → ℤ
शक्तिः t zero = एकम्
शक्तिः t (suc n) = t · शक्तिः t n

-- ---------------------------------------------- 1. the product is a power
घात-शक्तिः : (t : ℤ) (bs : List Bool)
  → घातः t bs ≡ शक्तिः ((- एकम्) + t) (ओजः bs)
घात-शक्तिः t [] = refl
घात-शक्तिः t (false ∷ bs) = घात-शक्तिः t bs
घात-शक्तिः t (true ∷ bs) = cong (((- एकम्) + t) ·_) (घात-शक्तिः t bs)

-- ------------------------------------------- 2. the twisted product too
-- the same product with the ζ-twisted factors: 1 at an inactive place,
-- t at an active one.
ज्योति-घातः : ℤ → List Bool → ℤ
ज्योति-घातः t [] = एकम्
ज्योति-घातः t (b ∷ bs) = (निष्क्रियम् b + सक्रियम् b · t) · ज्योति-घातः t bs

ज्योति-शक्तिः : (t : ℤ) (bs : List Bool)
  → ज्योति-घातः t bs ≡ शक्तिः t (ओजः bs)
ज्योति-शक्तिः t [] = refl
ज्योति-शक्तिः t (false ∷ bs) = ज्योति-शक्तिः t bs
ज्योति-शक्तिः t (true ∷ bs) = cong₂ _·_ (sym (pos0+ t)) (ज्योति-शक्तिः t bs)

-- ------------------------------------- 3. so the ζ twist is t ↦ t + 1
-- Dirichlet convolution with the constant function, at every place at once,
-- is a unit translation of the marking parameter.  Nothing is approximated.
ज्योतिः-अनुवादः : (t : ℤ) (bs : List Bool)
  → ज्योति-घातः t bs ≡ घातः (एकम् + t) bs
ज्योतिः-अनुवादः t bs =
  ज्योति-शक्तिः t bs
  ∙ cong (λ z → शक्तिः z (ओजः bs)) (pos0+ t ∙ sym (+Assoc (- एकम्) एकम् t))
  ∙ sym (घात-शक्तिः (एकम् + t) bs)

-- ------------------------------------ 4-5. every level factors through ω
-- Piṅgala's array carrying the Möbius sign: बिन्दुः m k = (−1)^{m−k} C(m,k),
-- written as the recursion rather than as a formula.
बिन्दुः : ℕ → ℕ → ℤ
बिन्दुः zero zero = एकम्
बिन्दुः zero (suc k) = pos zero
बिन्दुः (suc m) zero = (- एकम्) · बिन्दुः m zero
बिन्दुः (suc m) (suc k) = (- एकम्) · बिन्दुः m (suc k) + बिन्दुः m k

विवृत्ति-बिन्दुः : (bs : List Bool) (k : ℕ)
  → विवृत्तिः bs k ≡ बिन्दुः (ओजः bs) k
विवृत्ति-बिन्दुः [] zero = refl
विवृत्ति-बिन्दुः [] (suc k) = refl
विवृत्ति-बिन्दुः (false ∷ bs) zero = विवृत्ति-बिन्दुः bs zero
विवृत्ति-बिन्दुः (true ∷ bs) zero = cong ((- एकम्) ·_) (विवृत्ति-बिन्दुः bs zero)
विवृत्ति-बिन्दुः (false ∷ bs) (suc k) = विवृत्ति-बिन्दुः bs (suc k)
विवृत्ति-बिन्दुः (true ∷ bs) (suc k) =
  cong₂ _+_ (cong ((- एकम्) ·_) (विवृत्ति-बिन्दुः bs (suc k))) (विवृत्ति-बिन्दुः bs k)

-- the blindness, stated as the corollary it is: two place-sets with the same
-- COUNT are indistinguishable at every level of the tower.
स्तर-अन्धता : (bs cs : List Bool) (k : ℕ)
  → ओजः bs ≡ ओजः cs
  → विवृत्तिः bs k ≡ विवृत्तिः cs k
स्तर-अन्धता bs cs k e =
  विवृत्ति-बिन्दुः bs k ∙ cong (λ m → बिन्दुः m k) e ∙ sym (विवृत्ति-बिन्दुः cs k)

-- --------------------------------------------- 6. the tower is finite
बिन्दु-शून्यम् : (m k : ℕ) → बिन्दुः m (suc (m +ℕ k)) ≡ pos zero
बिन्दु-शून्यम् zero k = refl
बिन्दु-शून्यम् (suc m) k =
  cong₂ _+_ (cong ((- एकम्) ·_)
              (cong (बिन्दुः m) (sym (cong suc (+-suc m k))) ∙ बिन्दु-शून्यम् m (suc k)))
            (बिन्दु-शून्यम् m k)
