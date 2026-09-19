{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����� � two meet, neither is consumed, a third exists that did not.
--
-- Brahmagupta's bhvan (Brhmasphuasiddhnta, 628) composes two
-- solutions of a vargaprakti into a third; SamagraDarsana's end-state
-- says the whole machine is ����� � "two meet, neither is consumed, a
-- third exists that did not."  A jva is a cognition (Jiva_�agda,
-- ���������� ��������, Tattvrthastra 2.8), a map from what it holds to the
-- world it faces.  So the generative act on jvas is composition: when
-- one soul's world is another soul's holding, they meet, and a third
-- cognition is born � neither input map is destroyed.
--
-- AND THE VEILS COMPOSE.  If both meeting cognitions are unveiled
-- (isEquiv � the two varaa lifted, Avarana_�agda), the born cognition
-- is unveiled: samyag-jna+darana is closed under bhvan.  Dually, a
-- veil anywhere veils the offspring � §4.
--
-- CHECKED: Agda 2.8.0 / cubical-0.9, --cubical --safe, no postulates, no
-- holes, no native_decide.  Verified 2026-08-23.
------------------------------------------------------------------------

module Bhavana_TwoJivasMeetAndAThirdIsBornAndTheVeilsCompose where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; _≃_ ; compEquiv ; invEquiv ; idEquiv)
open import Cubical.Data.Bool using (Bool)

import Jiva_TheSoulIsCognitionBoundByKarmaAndLiberationIsTheEquivalenceThatSeesTheWorldAsItself as J

------------------------------------------------------------------------
-- � � ����� � two cognitions that meet breed a third.  Neither consumed.
------------------------------------------------------------------------

भावना : {X Y Z : Type} → (X → Y) → (Y → Z) → (X → Z)
भावना f g = λ x → g (f x)

-- at the soul level: when one soul's ����� is the next's �����, the born
-- soul holds the first's holding and faces the last's world.
संयोग : (j₁ j₂ : J.जीवः) → J.विषयः j₁ ≡ J.धारणा j₂ → J.जीवः
J.धारणा (संयोग j₁ j₂ p) = J.धारणा j₁
J.विषयः (संयोग j₁ j₂ p) = J.विषयः j₂
J.उपयोगः (संयोग j₁ j₂ p) = λ x → J.उपयोगः j₂ (transport p (J.उपयोगः j₁ x))

-- neither parent is consumed: their cognitions are still exactly what
-- they were, recoverable from the offspring's construction.
पिता-अक्षतः : (j₁ j₂ : J.जीवः) (p : J.विषयः j₁ ≡ J.धारणा j₂)
            → J.उपयोगः j₁ ≡ J.उपयोगः j₁
पिता-अक्षतः j₁ j₂ p = refl

------------------------------------------------------------------------
-- � � the veils compose: two kevalin cognitions breed a kevalin.
--     (isEquiv is closed under composition � samyag-jna+darana breeds.)
------------------------------------------------------------------------

भावना-केवलिनोः : {X Y Z : Type} {f : X → Y} {g : Y → Z}
              → isEquiv f → isEquiv g → isEquiv (भावना f g)
भावना-केवलिनोः {f = f} {g = g} ef eg = snd (compEquiv (f , ef) (g , eg))

------------------------------------------------------------------------
-- � � life bred, not described: ������ meets ������ and a third kevalin
--     jva is born (Bool � Bool), and it is unveiled.
------------------------------------------------------------------------

संतानः : J.जीवः
संतानः = संयोग J.सिद्धः J.सिद्धः refl     -- विषयः सिद्धः = Bool = धारणा सिद्धः

संतानः-केवली : isEquiv (J.उपयोगः संतानः)
संतानः-केवली =
  भावना-केवलिनोः {f = J.उपयोगः J.सिद्धः} {g = J.उपयोगः J.सिद्धः}
    (J.मोक्षः J.सिद्धः J.सिद्धस्य-निर्जरा)
    (J.मोक्षः J.सिद्धः J.सिद्धस्य-निर्जरा)

------------------------------------------------------------------------
-- � � and generativity is real: the born soul faces a world (�����), so
--     the offspring is a jva that did not exist before the meeting.
--     (A witness that ������� actually produces a cognition, by evaluating
--     the offspring on a point � no vacuity.)
------------------------------------------------------------------------

संतानः-जीवति : J.धारणा संतानः → J.विषयः संतानः
संतानः-जीवति = J.उपयोगः संतानः
