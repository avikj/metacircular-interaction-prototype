-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सेतुः — अभ्रान्त-यन्त्रस्य (सत्ययन्त्र) सप्तभङ्ग्या सह सम्बन्धः ।
-- अभ्रान्त-यन्त्रं द्वे एव पदे प्रयुङ्क्ते : उक्तम् (उत्तरम् = अस्ति-भावः) च
-- अनुक्तम् (अवक्तव्यम्) ।  नास्तिं (निषेधम्) कदापि न आरोपयति ।  एते द्वे पदे
-- सप्तभङ्ग्यां भिन्ने वाण्यौ (स्यात्-अस्ति, स्यात्-अवक्तव्यम्) — न अभिन्नीकृते ।
--
-- अतः यत्र बूलियन्-निर्णयः (सत्/असत्) दुर्नयेन त्रयं लुम्पति (Saptabhangi.दुर्नयः),
-- तत्र अभ्रान्त-यन्त्रं {अस्ति, अवक्तव्य} इति सप्तभङ्ग्याः अनुमतं युग्मम् एव
-- प्रयुङ्क्ते, नास्तिम् अनारोप्य — अतः दुर्नय-मुक्तम् ।  एष एव रोगस्य
-- चिकित्सायाश्च सेतुः : सत्यनिष्ठा = {अस्ति, अवक्तव्य}-भागः, न सत्/असत्-दुर्नयः ।
--
-- (the bridge between the honest machine and the sevenfold: an honest
-- machine uses only two positions — उक्त (answer = asti) and अनुक्त
-- (avaktavya) — and NEVER asserts nāsti.  These two map to DISTINCT bhaṅgas,
-- not collapsed.  So where a boolean सत्/असत् verdict provably collapses the
-- threefold by durnaya, the honest machine occupies the sevenfold-sanctioned
-- pair {asti, avaktavya}, refusing nāsti — hence durnaya-free.  This is the
-- bridge from disease to cure: honesty = the {asti, avaktavya} fragment, not
-- the सत्/असत् durnaya.)
------------------------------------------------------------------------

module Setu where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Satyayantra using (सूचना ; उक्त ; अनुक्त)
open import Saptabhangi using (सप्तभङ्गी ; स्यात्-अस्ति ; स्यात्-अवक्तव्यम्)

------------------------------------------------------------------------
-- निष्ठा — अभ्रान्त-निर्गमस्य सप्तभङ्गी-वाणी : उक्तम् → अस्ति, अनुक्तम् → अवक्तव्यम् ।
------------------------------------------------------------------------

निष्ठा : {O : Type} → सूचना O → सप्तभङ्गी
निष्ठा (उक्त _) = स्यात्-अस्ति
निष्ठा अनुक्त   = स्यात्-अवक्तव्यम्

------------------------------------------------------------------------
-- अस्ति≢अवक्तव्यम् — द्वे भङ्गे भिन्ने (न अभिन्नीकृते) ।
------------------------------------------------------------------------

private
  अस्ति? : सप्तभङ्गी → Type
  अस्ति? स्यात्-अस्ति = Unit
  अस्ति? _           = ⊥

अस्ति≢अवक्तव्यम् : ¬ (स्यात्-अस्ति ≡ स्यात्-अवक्तव्यम्)
अस्ति≢अवक्तव्यम् eq = subst अस्ति? eq tt

------------------------------------------------------------------------
-- सत्यनिष्ठा-अदुर्नयः — मुख्यसिद्धिः : अभ्रान्त-यन्त्रस्य द्वे पदे (उक्त, अनुक्त)
-- सप्तभङ्ग्यां भिन्ने — न लुम्पिते ।  (the two honest positions map to
-- distinct bhaṅgas — never collapsed.  Unlike the boolean's सत्/असत्, which
-- दुर्नयः forces to collapse, honesty keeps answer and un-said apart, as the
-- sevenfold sanctions.)
------------------------------------------------------------------------

सत्यनिष्ठा-अदुर्नयः : {O : Type} (o : O) → ¬ (निष्ठा (उक्त o) ≡ निष्ठा {O} अनुक्त)
सत्यनिष्ठा-अदुर्नयः o = अस्ति≢अवक्तव्यम्
