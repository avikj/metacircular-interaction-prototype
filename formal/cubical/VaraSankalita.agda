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
-- वार-सङ्कलितम् — नारायणस्य पुनः-पुनः-सङ्कलनम् (गणितकौमुदी, १३५६ ई.) ।
--
-- नारायणपण्डितः सामान्यं "वार-सङ्कलितम्" (r-वारं सङ्कलनम्) निर्दिशति : सङ्कलन-
-- क्रियां पुनः-पुनः प्रयुज्य आयत-सङ्ख्याः (figurate) जायन्ते ।  आवृत्तिः (मेरु-
-- सदृशी) : V_{r+1}(n) = V_{r+1}(n−1) + V_r(n) — एषा एव समास-भावना क्षेत्रान्तरे ।
-- विशेषाः : V₀(n)=n ; V₁(n)=∑k (त्रिकोणम्, Sankalita) ; V₂(n)=चिति (वृन्दम्,
-- Citighana) ।  एवं आर्यभटस्य त्रिकोण-वृन्दे नारायणस्य सामान्य-क्रमे एकीक्रियेते ।
--
-- (Nārāyaṇa's vāra-saṅkalita — repeated summation of order r, the figurate
-- numbers, Gaṇitakaumudī 1356.  The meru-like recurrence V_{r+1}(n) =
-- V_{r+1}(n−1) + V_r(n) is the samāsa-bhāvanā in another domain.  Orders:
-- V₀(n)=n, V₁=∑k (Āryabhaṭa's triangular, Sankalita), V₂=citighana (his
-- tetrahedral, Citighana) — the general operator UNIFIES both, proved here.
-- The closed form V_r(n) = C(n+r, r+1) — the hockey-stick — is proved in
-- Dvipada.agda from the Pascal recurrence alone (no factorials); once
-- avaktavya, now retired.)
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी (वार-सङ्कलितम्) ; आर्यभटः (त्रिकोण/वृन्दम्) ।
------------------------------------------------------------------------

module VaraSankalita where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-comm)
open import Sankalita  using (∑)
open import Citighana using (चिति)

------------------------------------------------------------------------
-- वार — r-वार-सङ्कलितम् ।  आवृत्तिः स्वयंसिद्धा : V_{r+1}(n)=V_{r+1}(n−1)+V_r(n) ।
------------------------------------------------------------------------

वार : ℕ → ℕ → ℕ
वार zero    n       = n
वार (suc r) zero    = zero
वार (suc r) (suc n) = वार (suc r) n + वार r (suc n)

------------------------------------------------------------------------
-- वार-१ — प्रथम-वारः = त्रिकोण-सङ्ख्या (∑k) ।
------------------------------------------------------------------------

वार-१ : (n : ℕ) → वार 1 n ≡ ∑ n
वार-१ zero    = refl
वार-१ (suc n) = cong (_+ suc n) (वार-१ n) ∙ +-comm (∑ n) (suc n)

------------------------------------------------------------------------
-- वार-२ — द्वितीय-वारः = वृन्द-सङ्ख्या (चिति, आर्यभटस्य चितिघनः) ।
------------------------------------------------------------------------

वार-२ : (n : ℕ) → वार 2 n ≡ चिति n
वार-२ zero    = refl
वार-२ (suc n) = cong₂ _+_ (वार-२ n) (वार-१ (suc n)) ∙ +-comm (चिति n) (∑ (suc n))

------------------------------------------------------------------------
-- उदाहरणानि — figurate : V₂(4)=20 (वृन्दम्) ; V₃(4)=35 (पञ्च-कोण, C(7,4)) ।
------------------------------------------------------------------------

उदाहरणम्-वृन्द : वार 2 4 ≡ 20
उदाहरणम्-वृन्द = refl

उदाहरणम्-पञ्च : वार 3 4 ≡ 35          -- 1+4+10+20 = 35 = C(7,4)
उदाहरणम्-पञ्च = refl
