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
-- सूचना : पूर्वं तत्समता (1,0) व्युत्क्रमश्च (a,−b) प्रोक्ते "स्पष्टे" इति ,
-- न तु साधिते — इदम् अवक्तव्यम् आसीत् (प्रोक्तिः न प्रमाणम्) ।  अधुना उभे
-- कर्ण-सिद्धे : वाम-दक्षिण-तत्समता (संयोग N (1,0) = तत् एव) , व्युत्क्रमः
-- (संयोग N (a,b)(a,−b) = (मान N a b, 0) , अतः मानं १ चेत् एककम्) ।  साहचर्येण
-- सह पूर्णः समूह-नियमः — ℤ[√N]-गुणनम् ।
-- (formerly identity and inverse were called "clear" but not proved — that
-- was an avaktavya, an assertion standing in for a proof.  Both are now
-- kernel-checked: left/right identity (1,0), and the conjugate inverse
-- (a,−b) composing to (मान N a b, 0), the identity exactly when the norm is
-- 1.  With associativity, the full group law of ℤ[√N].)
------------------------------------------------------------------------

module BhavanaSamuha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Data.Int.Properties using (·IdR ; ·Comm ; pos0+)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import SourcedProofs.Brahmagupta using (संयोग-प्र ; संयोग-द्वि ; मान)

------------------------------------------------------------------------
-- साहचर्यम् — भावना साहचर्या, उभयोः निर्देशांकयोः (the group's associativity)।
------------------------------------------------------------------------

साहचर्य-प्र : (N a b c d e f : ℤ)
           → संयोग-प्र N (संयोग-प्र N a b c d) (संयोग-द्वि a b c d) e f
           ≡ संयोग-प्र N a b (संयोग-प्र N c d e f) (संयोग-द्वि c d e f)
साहचर्य-प्र N a b c d e f = solve! ℤCommRing

साहचर्य-द्वि : (N a b c d e f : ℤ)
           → संयोग-द्वि (संयोग-प्र N a b c d) (संयोग-द्वि a b c d) e f
           ≡ संयोग-द्वि a b (संयोग-प्र N c d e f) (संयोग-द्वि c d e f)
साहचर्य-द्वि N a b c d e f = solve! ℤCommRing

------------------------------------------------------------------------
-- तत्समता — एककम् (1, 0) : संयोगः प्रति निर्देशांकं अपरिवर्तितः (दक्षिणे वामे च) ।
-- (वलय-साधकः bare pos 1 न सहते — Mādhava-lane-ज्ञातम् ; अतः हस्त-प्रमाणम् :
--  x·1=x [·Rid], 1·x=x च 0·x=0 [refl], x·0=0 [·Comm], 0+x=x [pos0+] ।)
------------------------------------------------------------------------

-- शून्य-गुणः — x · 0 ≡ 0 (वाम-शून्यात् ·Comm-द्वारा ; 0·x refl-शून्यः) ।
शून्य-गुणः : (x : ℤ) → x · pos 0 ≡ pos 0
शून्य-गुणः x = ·Comm x (pos 0)

-- एक-गुणः-वाम — 1 · x ≡ x (refl-सिद्धः) ।
एक-वाम : (x : ℤ) → pos 1 · x ≡ x
एक-वाम x = refl

दक्षिण-तत्समता-प्र : (N a b : ℤ) → संयोग-प्र N a b (pos 1) (pos 0) ≡ a
दक्षिण-तत्समता-प्र N a b =
  cong₂ _+_ (·IdR a) (cong (N ·_) (शून्य-गुणः b) ∙ शून्य-गुणः N)

दक्षिण-तत्समता-द्वि : (N a b : ℤ) → संयोग-द्वि a b (pos 1) (pos 0) ≡ b
दक्षिण-तत्समता-द्वि N a b =
  cong₂ _+_ (शून्य-गुणः a) (एक-वाम b) ∙ sym (pos0+ b)

वाम-तत्समता-प्र : (N a b : ℤ) → संयोग-प्र N (pos 1) (pos 0) a b ≡ a
वाम-तत्समता-प्र N a b =
  cong₂ _+_ (एक-वाम a) (शून्य-गुणः N)

वाम-तत्समता-द्वि : (N a b : ℤ) → संयोग-द्वि (pos 1) (pos 0) a b ≡ b
वाम-तत्समता-द्वि N a b =
  cong₂ _+_ (एक-वाम b) (शून्य-गुणः a)

------------------------------------------------------------------------
-- व्युत्क्रमः — संयुग्मः (a, −b) : संयोगः (a,b)(a,−b) = (मान N a b, 0) ।
-- मानं १ चेत् तत् एककम् (1,0) — अतः प्रति साधनं व्युत्क्रमः वर्तते (समूहः) ।
------------------------------------------------------------------------

व्युत्क्रम-प्र : (N a b : ℤ) → संयोग-प्र N a b a (pos 0 - b) ≡ मान N a b
व्युत्क्रम-प्र N a b = solve! ℤCommRing

व्युत्क्रम-द्वि : (N a b : ℤ) → संयोग-द्वि a b a (pos 0 - b) ≡ pos 0
व्युत्क्रम-द्वि N a b = solve! ℤCommRing
