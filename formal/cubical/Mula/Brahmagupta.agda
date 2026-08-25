{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ब्रह्मगुप्तस्य भावना — वर्ग-प्रकृतेः संयोग-नियमः (ब्राह्मस्फुटसिद्धान्तः, ६२८ ई.) ।
-- मानम् (norm) : N(x, y) = x² − N·y² ।  भावना द्वयोः साधनयोः संयोगः, यत्र
-- मानानि गुण्यन्ते : N(संयोगः) = N₁ · N₂ ।  एषा एव "ब्रह्मगुप्त-फिबोनाची"
-- समिका, गाउस्-संयोगस्य च चक्रवालस्य (Pell) च मूलम् ।
--
-- (Brahmagupta's bhāvanā — the composition law on the quadratic form
-- x² − N·y² (Brāhmasphuṭasiddhānta, 628 CE).  Two solutions compose so
-- that their norms MULTIPLY: N(composite) = N₁·N₂.  This is the
-- "Brahmagupta–Fibonacci" identity, and the root of both Gauss composition
-- and the cakravāla — the method that solves what Europe later miscalled
-- "Pell's equation" (Pell never solved it; Euler misattributed it).)
--
-- मानः न विचारः — शुद्धा वलय-समिका, ℤ-वलय-साधकेन (solve) प्रमाणिता ।
-- (the identity is a pure ring equation, discharged by the ℤ ring solver —
-- exact certified symbolic computation, which is proof, not measurement.)
------------------------------------------------------------------------

module Mula.Brahmagupta where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- मानम् — वर्ग-प्रकृति-मानम् N(x, y) = x² − N·y² ।
------------------------------------------------------------------------

मान : ℤ → ℤ → ℤ → ℤ
मान N x y = (x · x) - (N · (y · y))

-- अन्तर-भावना (समास-भावनायाः प्रतिरूपम्) : ऋण-चिह्नेन अपि मानानि गुण्यन्ते ।
-- (the antara/difference bhāvanā: with the minus signs, norms still multiply.
-- Brahmagupta gave BOTH compositions — samāsa and antara.)
अन्तर-प्र : ℤ → ℤ → ℤ → ℤ → ℤ → ℤ
अन्तर-प्र N x1 y1 x2 y2 = (x1 · x2) - (N · (y1 · y2))

अन्तर-द्वि : ℤ → ℤ → ℤ → ℤ → ℤ
अन्तर-द्वि x1 y1 x2 y2 = (x1 · y2) - (x2 · y1)

अन्तर-भावना-मान : (N x1 y1 x2 y2 : ℤ)
                → मान N (अन्तर-प्र N x1 y1 x2 y2) (अन्तर-द्वि x1 y1 x2 y2)
                ≡ (मान N x1 y1) · (मान N x2 y2)
अन्तर-भावना-मान N x1 y1 x2 y2 = solve! ℤCommRing

------------------------------------------------------------------------
-- संयोग-प्रथमम्, संयोग-द्वितीयम् — भावनायाः द्वे अङ्गे ।
--   प्रथमम् = x₁x₂ + N·y₁y₂ ;  द्वितीयम् = x₁y₂ + x₂y₁ ।
------------------------------------------------------------------------

संयोग-प्र : ℤ → ℤ → ℤ → ℤ → ℤ → ℤ
संयोग-प्र N x1 y1 x2 y2 = (x1 · x2) + (N · (y1 · y2))

संयोग-द्वि : ℤ → ℤ → ℤ → ℤ → ℤ
संयोग-द्वि x1 y1 x2 y2 = (x1 · y2) + (x2 · y1)

------------------------------------------------------------------------
-- भावना-मानः — मूलमन्त्रम् : संयोगस्य मानं मानयोः गुणः ।
--   N(भावना) = N(x₁,y₁) · N(x₂,y₂) ।  वलय-समिका, solve-सिद्धा ।
------------------------------------------------------------------------

भावना-मान : (N x1 y1 x2 y2 : ℤ)
          → मान N (संयोग-प्र N x1 y1 x2 y2) (संयोग-द्वि x1 y1 x2 y2)
          ≡ (मान N x1 y1) · (मान N x2 y2)
भावना-मान N x1 y1 x2 y2 = solve! ℤCommRing

------------------------------------------------------------------------
-- एक· — १ · n ≡ n (वलयतः) ।
------------------------------------------------------------------------

एक· : (n : ℤ) → (pos 1 · n) ≡ n
एक· n = solve! ℤCommRing

------------------------------------------------------------------------
-- चक्रवाल-द्वारम् — वर्ग-प्रकृतेः समूह-नियमः : यदि उभे साधने मानं १,
-- तर्हि संयोगः अपि मानं १ ।  (x² − N·y² = 1 इति साधनानां संयोगः पुनः साधनम् —
-- अनन्तानि साधनानि एकस्मात्, ब्रह्मगुप्तस्य दृष्टिः, चक्रवालस्य बीजम् ।)
--
-- (the gateway to the cakravāla: solutions of x² − N·y² = 1 form a group
-- under bhāvanā — compose two and you get another, so one solution breeds
-- infinitely many.  Brahmagupta's insight, the seed of the cakravāla.)
------------------------------------------------------------------------

चक्रवाल-संयोगः : (N x1 y1 x2 y2 : ℤ)
              → मान N x1 y1 ≡ pos 1
              → मान N x2 y2 ≡ pos 1
              → मान N (संयोग-प्र N x1 y1 x2 y2) (संयोग-द्वि x1 y1 x2 y2) ≡ pos 1
चक्रवाल-संयोगः N x1 y1 x2 y2 h1 h2 =
    भावना-मान N x1 y1 x2 y2
  ∙ cong₂ _·_ h1 h2
  ∙ एक· (pos 1)

------------------------------------------------------------------------
-- उदाहरणम् — x² − 2·y² = 1 : मूल-साधनम् (3, 2) ; भावनया अग्रिमम् (17, 12) ।
-- एकस्मात् साधनात् अनन्तानि — ब्रह्मगुप्तस्य समूह-नियमः प्रत्यक्षः ।
-- (from one solution, infinitely many — the group law, concretely.)
------------------------------------------------------------------------

मूल-साधनम् : मान (pos 2) (pos 3) (pos 2) ≡ pos 1     -- 9 − 8 = 1
मूल-साधनम् = refl

-- (17, 12) = भावना((3,2),(3,2)) ; 17² − 2·12² = 289 − 288 = 1
अग्रिम-x : संयोग-प्र (pos 2) (pos 3) (pos 2) (pos 3) (pos 2) ≡ pos 17
अग्रिम-x = refl

अग्रिम-y : संयोग-द्वि (pos 3) (pos 2) (pos 3) (pos 2) ≡ pos 12
अग्रिम-y = refl

अग्रिम-साधनम् : मान (pos 2)
                 (संयोग-प्र (pos 2) (pos 3) (pos 2) (pos 3) (pos 2))
                 (संयोग-द्वि (pos 3) (pos 2) (pos 3) (pos 2))
              ≡ pos 1
अग्रिम-साधनम् = चक्रवाल-संयोगः (pos 2) (pos 3) (pos 2) (pos 3) (pos 2)
                              मूल-साधनम् मूल-साधनम्

------------------------------------------------------------------------
-- ऋण-भावना — ब्रह्मगुप्तस्य वर्ग-प्रकृति-कुञ्जिका : मानं (−1) यत् साधनम्, तत्
-- स्वेन भावितं मानं (+1) साधनं ददाति (यतः (−1)·(−1) = 1) ।  अतः x²−N·y²=−1
-- इति साधनात् x²−N·y²=1 साधनं जायते ।  (Brahmagupta's key: a norm −1
-- solution composed with itself gives a norm +1 solution — the bridge
-- from x²−Ny²=−1 to the true Pell equation.)
------------------------------------------------------------------------

वर्ग-ऋण : (n : ℤ) → (pos 0 - n) · (pos 0 - n) ≡ n · n
वर्ग-ऋण n = solve! ℤCommRing

ऋण-भावना : (N x1 y1 x2 y2 : ℤ)
         → मान N x1 y1 ≡ (pos 0 - pos 1)
         → मान N x2 y2 ≡ (pos 0 - pos 1)
         → मान N (संयोग-प्र N x1 y1 x2 y2) (संयोग-द्वि x1 y1 x2 y2) ≡ pos 1
ऋण-भावना N x1 y1 x2 y2 h1 h2 =
    भावना-मान N x1 y1 x2 y2
  ∙ cong₂ _·_ h1 h2
  ∙ वर्ग-ऋण (pos 1)
  ∙ एक· (pos 1)

-- उदाहरणम् : x²−2y²=−1 इति (1,1) ; ऋण-भावनया (3,2), मानं +1 ।
ऋण-मूलम् : मान (pos 2) (pos 1) (pos 1) ≡ (pos 0 - pos 1)     -- 1 − 2 = −1
ऋण-मूलम् = refl

ऋणात्-साधनम् : मान (pos 2)
                (संयोग-प्र (pos 2) (pos 1) (pos 1) (pos 1) (pos 1))
                (संयोग-द्वि (pos 1) (pos 1) (pos 1) (pos 1))
             ≡ pos 1
ऋणात्-साधनम् = ऋण-भावना (pos 2) (pos 1) (pos 1) (pos 1) (pos 1)
                        ऋण-मूलम् ऋण-मूलम्

------------------------------------------------------------------------
-- द्विवर्ग-योग-गुणः — ब्रह्मगुप्त-समिका (N = −1) : द्वयोः वर्ग-योगयोः गुणः
-- अपि वर्ग-योगः ।  (a²+b²)(c²+d²) = (ac−bd)² + (ad+bc)² ।  एषा गाउस्-पूर्णाङ्क-
-- मानस्य गुणनीयता ; दियोफान्तस्-ब्रह्मगुप्त-समिका इति ख्याता ।
-- (Brahmagupta–Fibonacci identity, the N = −1 case: a product of two
-- sums of squares is itself a sum of squares — the multiplicativity of the
-- Gaussian-integer norm.)
------------------------------------------------------------------------

द्विवर्ग-गुणः : (a b c d : ℤ)
             → (a · a + b · b) · (c · c + d · d)
             ≡ (a · c - b · d) · (a · c - b · d) + (a · d + b · c) · (a · d + b · c)
द्विवर्ग-गुणः a b c d = solve! ℤCommRing

------------------------------------------------------------------------
-- मान-संयुग्म — मानं y-मध्ये सम-रूपम् : N(x, −y) = N(x, y) ।  संयुग्म-रचना
-- (x,y)↦(x,−y) मानं रक्षति , यतः मानम् y-वर्गे एव अपेक्षते (y² = (−y)²) ।
--
-- एतत् एव हेतुः यत् व्युत्क्रमः (a,−b) तस्मिन् एव मान-वर्गे तिष्ठति (BhavanaSamuha.
-- व्युत्क्रम) — समूहः मान-अनुगतः (norm-graded) ।  ब्रह्मगुप्तस्य द्वे भावने
-- (समास-अन्तर) अनेन एक-मूले : अन्तरः = संयुग्म-समासः , समानं मानम् ।
--
-- (The norm is even in y: N(x,−y)=N(x,y), because it depends on y only
-- through y².  This is exactly why the conjugate inverse (a,−b) lands in the
-- same norm class — the group is graded by the norm.  Brahmagupta's two
-- bhāvanās, samāsa and antara, share this root: the antara is composition
-- with the conjugate, and conjugation preserves the norm.)
------------------------------------------------------------------------

मान-संयुग्म : (N x y : ℤ) → मान N x (pos 0 - y) ≡ मान N x y
मान-संयुग्म N x y = cong (λ t → (x · x) - (N · t)) (वर्ग-ऋण y)

------------------------------------------------------------------------
-- अन्तर-संयुग्मः — अन्तर-भावना = संयुग्म-समास-भावना (शीर्षस्थ-प्रोक्तेः प्रमाणम्) ।
-- अन्तरः (x₁,y₁)(x₂,y₂) = समासः (x₁,y₁)(x₂,−y₂) : प्रथमे निर्देशांके यथावत् ,
-- द्वितीये संयुग्म-चिह्न-व्यत्ययेन (अन्तर-द्वि = −संयोग-द्वि संयुग्मे) ।  अनेन
-- ब्रह्मगुप्तस्य द्वे भावने एक-मूले , मान-संयुग्मेन (N(x,−y)=N(x,y)) समान-मानम् ।
--
-- (Brahmagupta's antara bhāvanā IS the samāsa bhāvanā against the conjugate
-- (x₂,−y₂): the first coordinate matches outright, the second up to the sign
-- conjugation introduces.  With मान-संयुग्म this is why both compositions share
-- one norm — the prose claim of the previous section, now a checked term.)
------------------------------------------------------------------------

अन्तर-संयुग्म-प्र : (N x1 y1 x2 y2 : ℤ)
                 → अन्तर-प्र N x1 y1 x2 y2 ≡ संयोग-प्र N x1 y1 x2 (pos 0 - y2)
अन्तर-संयुग्म-प्र N x1 y1 x2 y2 = solve! ℤCommRing

अन्तर-संयुग्म-द्वि : (N x1 y1 x2 y2 : ℤ)
                 → अन्तर-द्वि x1 y1 x2 y2 ≡ (pos 0 - संयोग-द्वि x1 y1 x2 (pos 0 - y2))
अन्तर-संयुग्म-द्वि N x1 y1 x2 y2 = solve! ℤCommRing

------------------------------------------------------------------------
-- अन्तर-मानः-भावनातः — अन्तर-भावना-मानः न स्वतन्त्रः , अपि तु समास-भावना-मानात्
-- संयुग्मेन जायते ।  पूर्वं (अन्तर-भावना-मान) वलय-साधकेन स्वतन्त्रं साधितम् ;
-- अत्र दर्शितम् : सः एव भावना-मानस्य (संयुग्म-सहितस्य) परिणामः — द्वौ मान-नियमौ
-- एकः एव ।  मार्गः : अन्तरः = संयुग्म-समासः (अन्तर-संयुग्म) , मानं y-सम-रूपम्
-- (मान-संयुग्म) , अतः भावना-मानं संयुग्म-पदे प्रयुज्य अन्तर-मानं लभ्यते ।
--
-- (The antara norm-law is not independent: it follows from the samāsa
-- norm-law by conjugation.  अन्तर-भावना-मान was proved by the ring solver on
-- its own; here it is re-derived from भावना-मान — via अन्तर = conjugate-samāsa
-- and the norm's evenness in y — exhibiting the two as ONE theorem.  This
-- reduces two facts to one, the collision resolved rather than left doubled.)
------------------------------------------------------------------------

अन्तर-मानः-भावनातः : (N x1 y1 x2 y2 : ℤ)
                  → मान N (अन्तर-प्र N x1 y1 x2 y2) (अन्तर-द्वि x1 y1 x2 y2)
                  ≡ (मान N x1 y1) · (मान N x2 y2)
अन्तर-मानः-भावनातः N x1 y1 x2 y2 =
    cong₂ (मान N) (अन्तर-संयुग्म-प्र N x1 y1 x2 y2) (अन्तर-संयुग्म-द्वि N x1 y1 x2 y2)
  ∙ मान-संयुग्म N (संयोग-प्र N x1 y1 x2 (pos 0 - y2)) (संयोग-द्वि x1 y1 x2 (pos 0 - y2))
  ∙ भावना-मान N x1 y1 x2 (pos 0 - y2)
  ∙ cong ((मान N x1 y1) ·_) (मान-संयुग्म N x2 y2)

------------------------------------------------------------------------
-- तुल्य-भावना — भास्करस्य "समयोः भावना" (बीजगणितम्, चक्रवालम्) : साधनं स्वेन
-- भावितम् ।  अतुल्य-भावना (द्वयोः असमयोः साधनयोः, उपरिष्टात् भावना-मान) इति
-- भिन्ना ; तुल्य-भावना तु एकस्य एव आत्म-संयोगः ।  पदे द्विगुणिते :
--   तुल्य-प्रथमम् = x² + N·y² ,  तुल्य-द्वितीयम् = x·y + x·y (= 2xy) ,
-- मानं च वर्गितम् : N(तुल्य) = (N(x,y))² ।  यत् क्षेपः k, तत् तुल्ये k² भवति —
-- अनेन भास्करः चक्रवाले क्षेपं वर्ग-रूपेण नयति, ततः विभजनेन आरोहति ।
--
-- (Bhāskara's tulya-bhāvanā, "composition of equals" (Bījagaṇita, cakravāla):
--  a solution composed with ITSELF, as opposed to atulya-bhāvanā of two
--  UNEQUAL solutions (भावना-मान above).  The doubled coordinates are
--  (x²+Ny², 2xy) and the kṣepa squares: N(tulya) = (N(x,y))².  A kṣepa k
--  becomes k², which is how the cakravāla drives the additive term to a
--  square and then descends by division.  The closed coordinate forms are
--  definitional here; the norm-square is the general lemma at x₁=x₂, y₁=y₂.)
------------------------------------------------------------------------

तुल्य-प्रथमम् : (N x y : ℤ) → संयोग-प्र N x y x y ≡ (x · x) + (N · (y · y))
तुल्य-प्रथमम् N x y = refl

तुल्य-द्वितीयम् : (x y : ℤ) → संयोग-द्वि x y x y ≡ (x · y) + (x · y)
तुल्य-द्वितीयम् x y = refl

तुल्य-भावना-मान : (N x y : ℤ)
               → मान N (संयोग-प्र N x y x y) (संयोग-द्वि x y x y)
               ≡ (मान N x y) · (मान N x y)
तुल्य-भावना-मान N x y = भावना-मान N x y x y

-- उदाहरणम् — क्षेपः वर्ग-रूपं भवति : N=3, (1,1) क्षेपः −2 ; तुल्य-भावनया
-- (4,2), क्षेपः 16−12 = 4 = (−2)² ।  (a non-±1 kṣepa squaring under tulya.)
तुल्य-मूलम् : मान (pos 3) (pos 1) (pos 1) ≡ (pos 0 - pos 2)     -- 1 − 3 = −2
तुल्य-मूलम् = refl

तुल्य-क्षेप-वर्गः : मान (pos 3)
                    (संयोग-प्र (pos 3) (pos 1) (pos 1) (pos 1) (pos 1))
                    (संयोग-द्वि (pos 1) (pos 1) (pos 1) (pos 1))
                 ≡ pos 4                                        -- 16 − 12 = 4 = (−2)²
तुल्य-क्षेप-वर्गः = refl
