-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वि-घात-वर्गणा-सेतुः — एकं 2ⁿ, द्वे जननी : योगेन (द्विगुणनम्) वा गुणेन (घातः) ।
--
-- पिङ्गलस्य द्वि-घात (PanktiYoga) 2ⁿ योगेन जनयति : 2^(n+1) = 2ⁿ + 2ⁿ (द्विगुणनम्) ।
-- वर्गणायाः घात (Vargana) तत् एव गुणेन : 2^(n+1) = 2 · 2ⁿ ।  जनन्यौ भिन्ने ,
-- फलं समानम् : द्वि-घात n ≡ घात 2 n (समता प्रमाणेन) ।  अनेन सेतुना वर्गणायाः
-- घात-घात-नियमः (जैन-वर्गित-संवर्गितम् (aᵐ)ⁿ=a^(mn)) द्वि-घाते अपि लभ्यते :
-- 2^(m·n) = (2ᵐ)ⁿ — योग-रूप-द्वि-घातः गुण-रूप-घातेन घात्यते ।
--
-- (One 2ⁿ, two generators: Piṅgala's द्वि-घात builds it additively (doubling,
-- 2^(n+1)=2ⁿ+2ⁿ), Vargana's घात multiplicatively (2·2ⁿ).  Different generators,
-- same value: द्वि-घात n ≡ घात 2 n, samatā by a proof.  The bridge carries
-- Vargana's घात-घात (the Jain (aᵐ)ⁿ=a^(mn), vargita-saṃvargita) over to द्वि-घात:
-- 2^(m·n)=(2ᵐ)ⁿ, the additive tower raised by the multiplicative power.)
--
-- स्रोतांसि : पिङ्गलः, छन्दःशास्त्रम् (द्विगुणन-2ⁿ) ; जैन-घात-नियमाः, अनुयोगद्वारम्
-- (घात-योग, घात-घात) ।
------------------------------------------------------------------------

module DviGhataVargana where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (+-zero)
open import PanktiYoga using (द्वि-घात)
open import Vargana using (घात ; घात-घात)
open import Ardhaccheda using (अर्धच्छेद ; लघुगणकः)

------------------------------------------------------------------------
-- द्विघात≡घात२ — योग-रूपः गुण-रूपश्च समौ : द्वि-घात n ≡ घात 2 n ।
------------------------------------------------------------------------

द्विघात≡घात२ : (n : ℕ) → द्वि-घात n ≡ घात 2 n
द्विघात≡घात२ zero    = refl
द्विघात≡घात२ (suc m) =
    cong₂ _+_ (द्विघात≡घात२ m) (द्विघात≡घात२ m)
  ∙ cong (घात 2 m +_) (sym (+-zero (घात 2 m)))

------------------------------------------------------------------------
-- द्विघात-घातघातः — वर्गणा-घात-घातः द्वि-घाते : 2^(m·n) = (2ᵐ)ⁿ ।
------------------------------------------------------------------------

द्विघात-घातघातः : (m n : ℕ) → द्वि-घात (m · n) ≡ घात (द्वि-घात m) n
द्विघात-घातघातः m n =
    द्विघात≡घात२ (m · n)
  ∙ sym (घात-घात 2 m n)
  ∙ cong (λ z → घात z n) (sym (द्विघात≡घात२ m))

------------------------------------------------------------------------
-- लघुगणक-घातः — जैन-लघुगणक-नियमः (घात-रूपः) : अर्धच्छेद(xⁿ) = n · अर्धच्छेद(x) ।
-- २-घातयोः : अर्धच्छेद((2ᵐ)ⁿ) = m · n = अर्धच्छेद(2^(m·n)) ।  पूर्व-सिद्धेन
-- लघुगणक-योगेन (गुणः → योगः) सह अयं (घातः → गुणः) अर्धच्छेदं पूर्ण-लघुगणकं करोति :
-- द्वौ लघुगणक-मूल-नियमौ (उत्पाद-घात) उभौ साधितौ ।
--
-- (The power-law for the Jain logarithm: ardhaccheda of a power is the
-- exponent times the ardhaccheda.  For powers of two, ardhaccheda((2ᵐ)ⁿ)=m·n.
-- With last step's log-of-a-product law (× → +), this (power → ×) makes
-- ardhaccheda a full logarithm — both of the two defining identities checked.)
------------------------------------------------------------------------

लघुगणक-घातः : (m n : ℕ) → अर्धच्छेद (घात (द्वि-घात m) n) ≡ m · n
लघुगणक-घातः m n =
    cong अर्धच्छेद (sym (द्विघात-घातघातः m n))
  ∙ लघुगणकः (m · n)
