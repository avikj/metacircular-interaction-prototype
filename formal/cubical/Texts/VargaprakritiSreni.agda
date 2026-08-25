{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- वर्गप्रकृति-श्रेढी — एकस्मात् साधनात् अनन्तानि (Brahmagupta's consequence) ।
-- मूल-साधनात् (x₁,y₁), x²−N·y²=1, भावनया श्रेढी जायते ; प्रत्येकं पदं
-- मानं १ इति (आगमनेन, चक्रवाल-संयोगेन सिद्धम्) ।  अतः वर्गप्रकृतेः
-- अनन्तानि साधनानि — ब्रह्मगुप्तस्य दृष्टिः, प्रत्यक्षम् आगमनेन ।
--
-- (Infinitely many solutions of वर्गप्रकृति (varga-prakṛti, "square-nature",
-- x²−N·y²=1) from one: from a fundamental (x₁,y₁), iterating bhāvanā gives a
-- sequence whose every term has norm 1 — proved by induction on चक्रवाल-
-- संयोगः.  Brahmagupta's insight (Brāhmasphuṭasiddhānta, 628 CE), made an
-- explicit induction; the cyclic completion is the cakravāla of Jayadeva
-- (~950) and Bhāskara II (1150).  The European name "Pell's equation" is
-- Euler's ~1730 misattribution — Pell never solved it, and Lagrange's proof
-- (1766) is six centuries downstream.  See notes/NOT_PELL_IT_IS_VARGAPRAKRITI.md.)
------------------------------------------------------------------------

module Texts.VargaprakritiSreni where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Texts.Brahmagupta
  using (मान ; संयोग-प्र ; संयोग-द्वि ; चक्रवाल-संयोगः)

------------------------------------------------------------------------
-- सोल — n-तमं साधनम् : मूलेन पुनः पुनः भावितम् ।
------------------------------------------------------------------------

सोल : (N x₁ y₁ : ℤ) → ℕ → (ℤ × ℤ)
सोल N x₁ y₁ zero    = (x₁ , y₁)
सोल N x₁ y₁ (suc n) =
  ( संयोग-प्र N (fst (सोल N x₁ y₁ n)) (snd (सोल N x₁ y₁ n)) x₁ y₁
  , संयोग-द्वि (fst (सोल N x₁ y₁ n)) (snd (सोल N x₁ y₁ n)) x₁ y₁ )

------------------------------------------------------------------------
-- श्रेढी-मान — प्रत्येकं पदं मानं १ (all terms solve x²−N·y²=1) ।
------------------------------------------------------------------------

श्रेढी-मान : (N x₁ y₁ : ℤ) → मान N x₁ y₁ ≡ pos 1
          → (n : ℕ) → मान N (fst (सोल N x₁ y₁ n)) (snd (सोल N x₁ y₁ n)) ≡ pos 1
श्रेढी-मान N x₁ y₁ h zero    = h
श्रेढी-मान N x₁ y₁ h (suc n) =
  चक्रवाल-संयोगः N (fst (सोल N x₁ y₁ n)) (snd (सोल N x₁ y₁ n)) x₁ y₁
                 (श्रेढी-मान N x₁ y₁ h n) h

------------------------------------------------------------------------
-- उदाहरणम् — x²−2y²=1 : मूल (3,2) → श्रेढी (17,12), (99,70), … सर्वे मानं १ ।
------------------------------------------------------------------------

मूल-२ : मान (pos 2) (pos 3) (pos 2) ≡ pos 1
मूल-२ = refl

-- तृतीयं पदम् (99, 70) : 99² − 2·70² = 9801 − 9800 = 1 ; आगमनेन ।
पदम्-२ : मान (pos 2)
            (fst (सोल (pos 2) (pos 3) (pos 2) 2))
            (snd (सोल (pos 2) (pos 3) (pos 2) 2))
       ≡ pos 1
पदम्-२ = श्रेढी-मान (pos 2) (pos 3) (pos 2) मूल-२ 2

------------------------------------------------------------------------
-- वर्ग-N-अपकर्षः — किमर्थं N अवर्गः स्यात् ?  यदि N = k² (वर्गः), तर्हि
-- x²−N·y² = (x−k·y)·(x+k·y) — गुणनं द्विधा भिद्यते, वर्गप्रकृतिः च
-- तुच्छा भवति ।  अतः ब्रह्मगुप्त-भास्करौ चक्रवालं केवलम् अवर्गे N प्रयुज्येते ।
--
-- (Why must N be non-square?  If N = k², then x²−N·y² factors as
--  (x−ky)(x+ky) — a degenerate difference-of-squares — and the vargaprakṛti
--  becomes trivial.  This is why Brahmagupta and Bhāskara applied the
--  cakravāla only to non-square N.  A polynomial identity over ℤ.)
------------------------------------------------------------------------

वर्ग-N-अपकर्षः : (k x y : ℤ) → x · x - (k · k) · (y · y) ≡ (x - k · y) · (x + k · y)
वर्ग-N-अपकर्षः k x y = solve! ℤCommRing
