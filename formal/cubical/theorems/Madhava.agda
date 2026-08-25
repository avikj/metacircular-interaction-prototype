{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- माधवस्य श्रेढी-मूलम् — गुणश्रेढी-योगः (सान्तः, वलय-सिद्धः) ।
--
--   केरल-सम्प्रदायः (माधवः सङ्गमग्रामीयः, ~१४०० ई.; नीलकण्ठः सोमयाजी,
--   तन्त्रसङ्ग्रहः १५०१ ; ज्येष्ठदेवः, युक्तिभाषा ~१५३० ई.) — व्योम-गणनार्थम्
--   (सूक्ष्म-ज्या-सारणी, परिधि-मानम्) प्रत्यक्षतः जातम्, न तु शुद्ध-कल्पनया ।
--
--   चापीकरणस्य (arctan) अनन्त-श्रेढी 1/(1+x²) इत्यस्य वितरणे मूलम् ।
--   तस्य बीज-अस्थि सान्त-गुणश्रेढी-योगः :
--
--        (1 − r) · ∑_{k<n} rᵏ  ≡  1 − rⁿ                (पूर्णाङ्केषु)
--
--   अत्र न सीमा, न अभिसरणम् — केवलं वलय-समिका, कुण्ड-परीक्षिता ।
--
--   सत्यनिष्ठा (avaktavya) : यत् माधवः वस्तुतः साधितवान् — शेष-पदस्य
--   (rⁿ/(1−r)) शून्याभिमुख-गमनम्, यतः अनन्त-योगः 1/(1−r) — तत् ℝ/ℚ-
--   विश्लेषण-आधारं विना अत्र न साध्यम् । शेष-पदम् एव सारः ; तत् इह
--   अनुक्तम्, न मिथ्या-सिद्धम् ।
------------------------------------------------------------------------

module Madhava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_ ; -_)
open import Cubical.Data.Int.Properties
  using (·Comm ; ·IdR ; ·DistL+ ; -DistL· ; +Assoc ; minusPlus)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- घातः — rᵏ (पुनरावर्तनेन) ।
------------------------------------------------------------------------

घात : ℤ → ℕ → ℤ
घात r zero    = pos 1
घात r (suc n) = घात r n · r

------------------------------------------------------------------------
-- सङ्कलितम् — ∑_{k<n} rᵏ (आंशिक-योगः, पदशः वर्धमानः) ।
------------------------------------------------------------------------

सङ्कलितम् : ℤ → ℕ → ℤ
सङ्कलितम् r zero    = pos 0
सङ्कलितम् r (suc n) = सङ्कलितम् r n + घात r n

------------------------------------------------------------------------
-- वलय-सहायकाः ।
--   (टिप्पणी : ℤ-वलय-साधकः pos 1 (वलय-एकम्) न परिचिनोति ; अतः
--    एक-युक्ताः समिकाः हस्तेन (Int.Properties), केवल-चर-वितरणं तु साधकेन ।)
------------------------------------------------------------------------

-- एक-गुणः वामतः : 1·x ≡ x ।
वाम-एक : (x : ℤ) → pos 1 · x ≡ x
वाम-एक x = ·Comm (pos 1) x ∙ ·IdR x

-- आधारः : (1 − r)·0 ≡ 0 (परिवर्तनेन) ; 0 ≡ 1 − 1 (refl) ।
आधार-समिका : (r : ℤ) → (pos 1 - r) · pos 0 ≡ pos 1 - pos 1
आधार-समिका r = ·Comm (pos 1 - r) (pos 0)

-- वितरणम् (शुद्ध-चरम्, साधक-सिद्धम्) : a·(S + p) ≡ a·S + a·p ।
वितरण-समिका : (a S p : ℤ) → a · (S + p) ≡ (a · S) + (a · p)
वितरण-समिका a S p = solve! ℤCommRing

-- सहायकः : (1 − r)·p ≡ p − r·p  (एक-वितरणाभ्याम्, हस्तेन) ।
भङ्ग-समिका : (r p : ℤ) → (pos 1 - r) · p ≡ p - (r · p)
भङ्ग-समिका r p =
    ·DistL+ (pos 1) (- r) p
  ∙ cong₂ _+_ (वाम-एक p) (sym (-DistL· r p))

-- पदम् : (1 − p) + (1 − r)·p ≡ 1 − p·r  (दूरबीन-सन्धिः, हस्तेन) ।
पद-समिका : (r p : ℤ)
  → ((pos 1 - p) + ((pos 1 - r) · p)) ≡ (pos 1 - (p · r))
पद-समिका r p =
    cong ((pos 1 - p) +_) (भङ्ग-समिका r p)
  ∙ +Assoc (pos 1 - p) p (- (r · p))
  ∙ cong (_+ (- (r · p))) (minusPlus p (pos 1))
  ∙ cong (λ z → pos 1 + (- z)) (·Comm r p)

------------------------------------------------------------------------
-- मुख्य-सिद्धान्तः — सान्त-गुणश्रेढी-योगः ।
--   (1 − r) · ∑_{k<n} rᵏ  ≡  1 − rⁿ  ।  आगमनेन (n इत्यस्मिन्) ।
------------------------------------------------------------------------

गुणश्रेढी-योगः : (r : ℤ)(n : ℕ)
  → (pos 1 - r) · सङ्कलितम् r n ≡ pos 1 - घात r n
गुणश्रेढी-योगः r zero    = आधार-समिका r
गुणश्रेढी-योगः r (suc n) =
    वितरण-समिका (pos 1 - r) (सङ्कलितम् r n) (घात r n)
  ∙ cong (_+ ((pos 1 - r) · घात r n)) (गुणश्रेढी-योगः r n)
  ∙ पद-समिका r (घात r n)

------------------------------------------------------------------------
-- उदाहरणम् — r = 2, n = 3 : (1−2)·(1+2+4) = −7 = 1 − 8 । कुण्ड-सिद्धम् ।
------------------------------------------------------------------------

उदाहरणम् : (pos 1 - pos 2) · सङ्कलितम् (pos 2) 3 ≡ pos 1 - घात (pos 2) 3
उदाहरणम् = गुणश्रेढी-योगः (pos 2) 3

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  A pointer, and one piece of REPLACEMENT WORDING OFFERED, NOT
-- APPLIED — the ledger above is this module's author's and I do not
-- edit it.
--
-- I read गुणश्रेढी-योगः's signature and proof body before importing it.
--
-- The ledger (lines 17–20) says the remainder term is the essence and is
-- here अनुक्तम् — un-said, not falsely proved.  The un-said part is
-- exactly right for the ASYMPTOTICS: rⁿ/(1−r) → 0 does need ℝ/ℚ
-- analysis this lane does not have, and nothing has changed about that.
--
-- But the remainder ITSELF is not un-said, because this module's own
-- theorem plus `Int.Properties.minusPlus` gives it exactly, at every
-- finite n, with no limit:
--
--     (1 − r) · ∑_{k<n} rᵏ  +  rⁿ  ≡  1
--
-- checked as `exactRemainder` in
-- `NaturalMachine.TheTruncationErrorIsExactAtEveryFiniteStage`
-- (--safe, no postulates, no holes).
--
-- OFFERED WORDING, for this module's author to take or leave — narrower
-- than the present sentence and, as far as I can check, still true:
--
--     शेष-पदस्य *गमनम्* इह अनुक्तम् ; शेष-पदम् एव तु सान्तं
--     प्रत्येकस्मिन् n — (1−r)·∑ + rⁿ ≡ 1 ।
--
--     "the remainder term's *tendency* is un-said here; the remainder
--      term itself is exact at every finite n."
--
-- Nothing above is changed, and if the author judges the present wording
-- correct as it stands, this paragraph is the whole of my disagreement
-- and it stays here.
------------------------------------------------------------------------
