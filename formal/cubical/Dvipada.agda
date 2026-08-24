-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्विपदः — मेरु-सङ्ख्या (n क र), नारायणस्य वार-सङ्कलितस्य बद्ध-रूपम् ।
--
-- हलायुधस्य मेरु-प्रस्तारः (Meru.agda) पङ्क्ति-रूपेण ; अत्र सूचित-द्विपदः
-- C(n,k), पार्श्वयोग-आवृत्त्या एव (न भाज्य-क्रमेण/factorials) ।  मुख्य-फलम् :
-- नारायणस्य वार-सङ्कलितम् (VaraSankalita.वार) बद्ध-रूपेण = मेरु-कर्ण-योगः
-- (hockey-stick) : V_r(n) = C(n+r, r+1) ।  एतत् VaraSankalita-शीर्षके
-- अवक्तव्यम् आसीत् — अधुना निवृत्तम्, केवलं पार्श्वयोग-आवृत्त्या ।
--
-- (An indexed binomial C(n,k) by the Pascal recurrence alone — no factorials.
-- Main result: Nārāyaṇa's vāra-saṅkalita in closed form is the hockey-stick
-- identity, V_r(n) = C(n+r, r+1) — the avaktavya left in VaraSankalita is
-- retired.  So the figurate numbers (triangular V₁, tetrahedral V₂, …) are
-- exactly the meru diagonals, established from the recurrence, not the factorial.)
--
-- स्रोतांसि : पिङ्गलः/हलायुधः (मेरु-प्रस्तारः) ; नारायणः (वार-सङ्कलितम्) ।
------------------------------------------------------------------------

module Dvipada where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-suc ; +-zero ; +-comm)
open import VaraSankalita using (वार)

------------------------------------------------------------------------
-- C — मेरु-सङ्ख्या (n choose k), पार्श्वयोग-आवृत्त्या ।
------------------------------------------------------------------------

C : ℕ → ℕ → ℕ
C n       zero    = suc zero
C zero    (suc k) = zero
C (suc n) (suc k) = C n k + C n (suc k)

------------------------------------------------------------------------
-- C-एक : C(n,1) = n ।
------------------------------------------------------------------------

C-एक : (n : ℕ) → C n 1 ≡ n
C-एक zero    = refl
C-एक (suc m) = cong suc (C-एक m)

------------------------------------------------------------------------
-- शून्य-वाम : C(n, n+k+1) = 0 (कर्ण-ऊर्ध्वं शून्यम्) ।
------------------------------------------------------------------------

शून्य-वाम : (n k : ℕ) → C n (suc (k + n)) ≡ 0
शून्य-वाम zero    k = refl
शून्य-वाम (suc m) k =
  cong₂ _+_ (cong (C m) (+-suc k m) ∙ शून्य-वाम m k)
            (cong (C m) (cong suc (+-suc k m)) ∙ शून्य-वाम m (suc k))

------------------------------------------------------------------------
-- वार-बद्धम् — मुख्य-सिद्धिः (hockey-stick) : V_r(n) = C(n+r, r+1) ।
------------------------------------------------------------------------

वार-बद्धम् : (r n : ℕ) → वार r n ≡ C (n + r) (suc r)
वार-बद्धम् zero    n       = sym (C-एक (n + 0) ∙ +-zero n)
वार-बद्धम् (suc r) zero    = sym (शून्य-वाम (suc r) 0)
वार-बद्धम् (suc r) (suc n) =
    cong₂ _+_ (वार-बद्धम् (suc r) n)
              (वार-बद्धम् r (suc n) ∙ cong (λ z → C z (suc r)) (sym (+-suc n r)))
  ∙ +-comm (C (n + suc r) (suc (suc r))) (C (n + suc r) (suc r))

------------------------------------------------------------------------
-- उदाहरणानि — आयत-सङ्ख्याः मेरु-कर्णाः (refl-सिद्धानि) ।
--   त्रिकोणम् V₁(n)=C(n+1,2) ; वृन्दम् V₂(4)=C(6,3)=20 ; V₃(4)=C(7,4)=35 ।
------------------------------------------------------------------------

द्विपद-६-३ : C 6 3 ≡ 20
द्विपद-६-३ = refl

द्विपद-७-४ : C 7 4 ≡ 35
द्विपद-७-४ = refl

-- वार 2 4 = 20 = C(4+2, 3), by वार-बद्धम् 2 4 (न पुनर्-गणना) :
वृन्द-बद्धम् : वार 2 4 ≡ C 6 3
वृन्द-बद्धम् = वार-बद्धम् 2 4
