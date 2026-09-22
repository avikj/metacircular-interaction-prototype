{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- चितिघनः — आर्यभटस्य वृन्द-सङ्कलितम् (आर्यभटीयम्, गणितपादः २१, ४९९ ई.) ।
--
-- आर्यभटः "सङ्कलित-सङ्कलितम्" (द्वितीय-क्रम-योगम्) निर्दिशति : त्रिकोण-सङ्ख्यानां
-- (T_k = 1+2+…+k) योगः = वृन्दम् (गोल-राशिः) = n(n+1)(n+2)/6 ।  विभाग-वर्जनार्थं
-- अत्र : ६·(∑_{k=1}^{n} T_k) ≡ n(n+1)(n+2) ।  (Sankalita.agda-तः ∑ (त्रिकोणम्)
-- द्विगुण-सङ्कलितं च गृह्यते — लाने पूर्व-सिद्धम्, पुनर् न साध्यते ।)
--
-- (Āryabhaṭa's citighana / vṛnda — the "solid pile", Āryabhaṭīya Gaṇitapāda
-- 2.21: the sum of the triangular numbers T_k = k(k+1)/2 is n(n+1)(n+2)/6,
-- the tetrahedral number.  Stated integrally as 6·Σ T_k ≡ n(n+1)(n+2) to
-- avoid division.  This is the second-order summation — a saṅkalita of
-- saṅkalitas — distinct from Sankalita.agda's ∑k and ∑k³.  Proved by
-- induction; the cubic step (क्रुक्स) is hand-derived since the ℕ solver
-- chokes on suc-headed products.)
--
-- स्रोतांसि : आर्यभटः, आर्यभटीयम्, गणितपादः २१ (वृन्द/चितिघन-सूत्रम्) ।
------------------------------------------------------------------------

module Citighana where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties
  using (+-zero ; ·-comm ; ·-assoc ; ·-distribʳ ; ·-distribˡ)
open import Sankalita_AryabhatasSeriesSumsAndTheCubeSumIsTheSquareOfTheSum using (∑ ; द्विगुण-सङ्कलितम्)

------------------------------------------------------------------------
-- चिति — त्रिकोण-सङ्ख्यानां योगः : ∑_{k=1}^{n} ∑k (वृन्दम्) ।
------------------------------------------------------------------------

चिति : ℕ → ℕ
चिति zero    = zero
चिति (suc n) = ∑ (suc n) + चिति n

------------------------------------------------------------------------
-- सहायकाः — २·x = x+x ; ६·∑(suc n) = ३·(suc n · suc(suc n)) ।
------------------------------------------------------------------------

द्वि· : (x : ℕ) → 2 · x ≡ x + x
द्वि· x = cong (x +_) (+-zero x)

षड्∑ : (n : ℕ) → 6 · ∑ (suc n) ≡ 3 · (suc n · suc (suc n))
षड्∑ n = sym (·-assoc 3 2 (∑ (suc n)))
       ∙ cong (3 ·_) (द्वि· (∑ (suc n)) ∙ द्विगुण-सङ्कलितम् (suc n))

------------------------------------------------------------------------
-- क्रुक्स — घन-पदम् : 3·A + (n·suc n)·suc(suc n) ≡ A·suc(suc(suc n)),
-- A = suc n · suc(suc n) ।  (3+n) = suc(suc(suc n)) इति स्वयंसिद्धम् ।
------------------------------------------------------------------------

क्रुक्स : (n : ℕ)
       → 3 · (suc n · suc (suc n)) + (n · suc n) · suc (suc n)
       ≡ suc n · suc (suc n) · suc (suc (suc n))
क्रुक्स n =
    cong (3 · (suc n · suc (suc n)) +_)
         (sym (·-assoc n (suc n) (suc (suc n))))
  ∙ ·-distribʳ 3 n (suc n · suc (suc n))
  ∙ ·-comm (3 + n) (suc n · suc (suc n))

------------------------------------------------------------------------
-- चितिघनः — मुख्य-सिद्धिः : ६·(∑ त्रिकोणानि) = n(n+1)(n+2) ।
------------------------------------------------------------------------

चितिघनः : (n : ℕ) → 6 · चिति n ≡ n · suc n · suc (suc n)
चितिघनः zero    = refl
चितिघनः (suc n) =
    sym (·-distribˡ 6 (∑ (suc n)) (चिति n))
  ∙ cong₂ _+_ (षड्∑ n) (चितिघनः n)
  ∙ क्रुक्स n

------------------------------------------------------------------------
-- उदाहरणम् — चिति 4 = 1+3+6+10 = 20 ; 6·20 = 120 = 4·5·6 (refl-सिद्धम्) ।
------------------------------------------------------------------------

उदाहरणम्-चिति : चिति 4 ≡ 20
उदाहरणम्-चिति = refl

उदाहरणम्-वृन्द : 6 · चिति 4 ≡ 120
उदाहरणम्-वृन्द = refl
