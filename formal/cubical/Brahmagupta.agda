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

module Brahmagupta where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

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
अन्तर-भावना-मान = solve ℤCommRing

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
भावना-मान = solve ℤCommRing

------------------------------------------------------------------------
-- एक· — १ · n ≡ n (वलयतः) ।
------------------------------------------------------------------------

एक· : (n : ℤ) → (pos 1 · n) ≡ n
एक· = solve ℤCommRing

------------------------------------------------------------------------
-- चक्रवाल-द्वारम् — पेल्ल-समीकरणस्य समूह-नियमः : यदि उभे साधने मानं १,
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
-- ऋण-भावना — ब्रह्मगुप्तस्य पेल्ल-कुञ्जिका : मानं (−1) यत् साधनम्, तत्
-- स्वेन भावितं मानं (+1) साधनं ददाति (यतः (−1)·(−1) = 1) ।  अतः x²−N·y²=−1
-- इति साधनात् x²−N·y²=1 साधनं जायते ।  (Brahmagupta's key: a norm −1
-- solution composed with itself gives a norm +1 solution — the bridge
-- from x²−Ny²=−1 to the true Pell equation.)
------------------------------------------------------------------------

वर्ग-ऋण : (n : ℤ) → (pos 0 - n) · (pos 0 - n) ≡ n · n
वर्ग-ऋण = solve ℤCommRing

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
द्विवर्ग-गुणः = solve ℤCommRing
