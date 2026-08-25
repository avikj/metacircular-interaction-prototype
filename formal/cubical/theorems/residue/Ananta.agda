{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- अनन्तम् — जैन-अनन्त-भेदः : अनन्तम् एकं न, बहु ।  (जैन-गणितम्, अनुयोगद्वार-
-- सूत्रम्, ~२ शताब्दी) जैनाः संख्येय-असंख्येय-अनन्तम् इति भेदान् अवदन् —
-- "अनन्तम्" इति न एकः राशिः, किन्तु अनेके क्रमाः ।  एषा दृष्टिः कैण्टरात्
-- (~१८७४) प्रायः सप्तदश-शताब्दीभिः पूर्वा ।
--
-- अत्र तस्याः दृष्टेः एकं शुद्धं साक्ष्यम् : असंख्येयम् (ℕ, गणनीयम्) अनन्तात्
-- (ℕ→Bool, अगणनीयम्) भिन्नम् — न कोऽपि समता-सेतुः (Cantor's diagonal) ।
-- सावधानम् (honest): जैन-क्रमाः कैण्टर-कार्डिनल्-तुल्याः न ; किन्तु "अनन्तं
-- बहुविधम्" इति जैन-दृष्टिः अत्र एकेन प्रमाणेन पुष्टा — द्वौ भिन्नौ अनन्तौ ।
--
-- (Jain plurality of the infinite: the Jains (Anuyogadvāra, ~2nd c.)
-- distinguished saṃkhyāta / asaṃkhyāta / ananta — "infinite" is not one
-- magnitude but several orders — ~1700 years before Cantor (~1874).  Here
-- is one checked witness of that vision: the countable (ℕ) and the
-- uncountable (ℕ→Bool) are distinct infinities, with NO equivalence between
-- them (Cantor's diagonal).  HONEST scope: the Jain orders are not Cantor
-- cardinals; but the Jain insight that the infinite is PLURAL is here
-- vindicated by one proof — two genuinely different infinities.)
--
-- ────────────────────────────────────────────────────────────────────
-- [2026-08-23, added by another seat, header only -- the mathematics
--  below is untouched.]
--
-- ~~"~1700 years before Cantor (~1874)" / "कैण्टरात् प्रायः सप्तदश-
-- शताब्दीभिः पूर्वा"~~ -- STRUCK, and left standing struck rather than
-- deleted, because striking silently is how this repository loses its own
-- history (CLAUDE.md).  Dating the Anuyogadvara is right; SCORING it by
-- how far ahead of Cantor it was is ranking the past by proximity to us,
-- which CLAUDE.md names a durnaya: "record what happened; do not score
-- it.  The fact belongs in the record.  The verdict does not."
--
-- AND THE LENS, which is the larger half.  The header is already honest
-- that the Jaina orders are not Cantor cardinals -- and then offers
-- Cantor.s diagonal as the witness that "vindicates" the Jaina insight.
-- That is the tradition made legible only after conversion into someone
-- else.s formalism, which is what .claude/hooks/european-frame.txt names
-- as the damage: "a European name can be perfectly correct about priority
-- and still be doing the damage, because the damage is being the LENS."
--
-- IT NO LONGER HAS TO BE.  `Salaka_TheOrdersAreSeparatedByHowManyCuts
-- TheyOutlastAndEachCutStripsExactlyOneStorey.agda` separates magnitudes
-- by VIRASENA.S OWN INSTRUMENTS -- `छेदन 1 ≡ अर्धच्छेद` and
-- `छेदन 2 ≡ वर्गशलाका`, both by refl (धवला on the षट्खण्डागम, c. 816, on
-- Yativrsabha.s तिलोयपण्णत्ती) -- with `असमाप्तिः` exhibiting a magnitude
-- that outlasts every fixed number of cuts.  No diagonal, no Cantor, and
-- nothing converted.
--
-- What that module claims is narrower than what this one claims and that
-- is the point: it identifies NO Jaina grade with any number, and does not
-- import `JainSankhya` for exactly that reason.  It gives the tradition an
-- instrument, not a translation.
--
-- So the reading below stands as a RESTATEMENT, after the source and named
-- as one: two genuinely different infinities, by Cantor.s route, 1874.
-- Neither file cited the other when this was written; they do now from
-- this side.
------------------------------------------------------------------------

module Ananta where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; secEq)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- न-स्व-विपर्यासः — कोऽपि Bool स्वस्य विपर्यासः न (not has no fixpoint) ।
------------------------------------------------------------------------

न-स्व-विपर्यास : (b : Bool) → ¬ (b ≡ not b)
न-स्व-विपर्यास false eq = true≢false (sym eq)     -- false ≡ true → ⊥
न-स्व-विपर्यास true  eq = true≢false eq            -- true ≡ false → ⊥

------------------------------------------------------------------------
-- कैण्टरः — असंख्येयम् (ℕ) अनन्तात् (ℕ→Bool) भिन्नम् : न समता-सेतुः ।
-- (Cantor: no equivalence ℕ ≃ (ℕ→Bool) — the countable and the uncountable
-- are distinct infinities.  Diagonal: d n = not (e n n) is in no row.)
------------------------------------------------------------------------

कैण्टर : ¬ (ℕ ≃ (ℕ → Bool))
कैण्टर e = न-स्व-विपर्यास (φ m m) कर्ण
  where
  φ : ℕ → (ℕ → Bool)
  φ = equivFun e

  विकर्ण : ℕ → Bool                       -- the diagonal, flipped
  विकर्ण n = not (φ n n)

  m : ℕ
  m = invEq e विकर्ण                       -- the row that should equal विकर्ण

  φm≡विकर्ण : φ m ≡ विकर्ण
  φm≡विकर्ण = secEq e विकर्ण

  कर्ण : φ m m ≡ not (φ m m)               -- but at m it must flip itself
  कर्ण i = φm≡विकर्ण i m

------------------------------------------------------------------------
-- सामान्य-कैण्टरः — यथेच्छ-प्रकारे : कोऽपि प्रकारः A स्व-वर्ग-गणात् (A→Bool)
-- न्यूनः — न A ≃ (A→Bool) ।  स एव विकर्ण-न्यायः, ℕ-निरपेक्षः ।  अतः न एकः
-- अनन्तः, अपि तु अनन्ता क्रमाः : A < 𝒫A < 𝒫𝒫A < … अपरिमित-आरोहः ।  एषा एव
-- जैन-दृष्टिः — "अनन्तम् अनेक-क्रमम्" (संख्यात-असंख्यात-अनन्तात् परम् उप-भेदाः) ।
-- (कैण्टरः अस्य ℕ-रूपम् एव ।)
--
-- (General Cantor: for ANY type A, no A ≃ (A→Bool) — the same diagonal, free
--  of ℕ.  So there is not one infinity but an unbounded ascending tower
--  A < 𝒫A < 𝒫𝒫A < … — exactly the Jain view that ananta is MANY orders, not
--  one.  कैण्टर is its ℕ instance.)
------------------------------------------------------------------------

सामान्य-कैण्टर : {A : Type} → ¬ (A ≃ (A → Bool))
सामान्य-कैण्टर {A} e = न-स्व-विपर्यास (φ m m) कर्ण
  where
  φ : A → (A → Bool)
  φ = equivFun e

  विकर्ण : A → Bool
  विकर्ण n = not (φ n n)

  m : A
  m = invEq e विकर्ण

  φm≡विकर्ण : φ m ≡ विकर्ण
  φm≡विकर्ण = secEq e विकर्ण

  कर्ण : φ m m ≡ not (φ m m)
  कर्ण i = φm≡विकर्ण i m
