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
