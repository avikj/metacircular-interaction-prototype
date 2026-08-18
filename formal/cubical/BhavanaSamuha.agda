{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- भावना-समूहः — ब्रह्मगुप्तस्य भावना समूह-नियमः (group law) ।  न केवलं
-- मान-गुणनम् (Brahmagupta.भावना-मान), किन्तु ℤ[√N]-गुणनस्य समूह-रचना ।
-- केन्द्रम् : साहचर्यम् (associativity), उभयोः निर्देशांकयोः — गाउस्-संयोगस्य
-- (composition of forms) मूल-रचना, ब्रह्मगुप्तेन (६२८) दत्ता ।
--
-- (Brahmagupta's bhāvanā is a GROUP law, not merely a norm product: the
-- associative multiplication of ℤ[√N] — the structure Gauss later
-- generalized to composition of quadratic forms.  Associativity of both
-- coordinates is established here as ℤ ring identities via the solver.)
--
-- सूचना : तत्समता (1,0) च व्युत्क्रमः (a,−b) च समूह-तत्त्वे स्पष्टे (संयोग-प्र
-- N a b 1 0 = a·1+N·(b·0) = a इत्यादि) ; अत्र गभीरं साहचर्यम् एव साधितम् ।
-- (identity (1,0) and inverse (a,−b) hold by direct computation; here the
-- deep part — associativity — is what is proved.)
------------------------------------------------------------------------

module BhavanaSamuha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)
open import Brahmagupta using (संयोग-प्र ; संयोग-द्वि)

------------------------------------------------------------------------
-- साहचर्यम् — भावना साहचर्या, उभयोः निर्देशांकयोः (the group's associativity)।
------------------------------------------------------------------------

साहचर्य-प्र : (N a b c d e f : ℤ)
           → संयोग-प्र N (संयोग-प्र N a b c d) (संयोग-द्वि a b c d) e f
           ≡ संयोग-प्र N a b (संयोग-प्र N c d e f) (संयोग-द्वि c d e f)
साहचर्य-प्र = solve ℤCommRing

साहचर्य-द्वि : (N a b c d e f : ℤ)
           → संयोग-द्वि (संयोग-प्र N a b c d) (संयोग-द्वि a b c d) e f
           ≡ संयोग-द्वि a b (संयोग-प्र N c d e f) (संयोग-द्वि c d e f)
साहचर्य-द्वि = solve ℤCommRing
