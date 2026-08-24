-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- चक्रवालम् — जयदेव-भास्करयोः चक्रीय-विधिः (~९५० / ११५० ई.) : वर्ग-प्रकृतेः
-- साधनम्, यत् यूरोपः लाग्रांज-पर्यन्तम् (१७६६) न अशक्नोत् ।  अस्य केन्द्रं :
-- चक्रीय-पदम् एव ब्रह्मगुप्तस्य भावना, (m, 1)-साधनेन विशेषिता ।
--
-- चक्रीय-पदम् : (a, b, k) यत्र a²−N·b² = k ; अन्तर्वेशकः (m, 1, m²−N) ;
-- भावनया : मानम् (संयोगस्य) = k · (m²−N) — नवं रूपम् ।  एतत् भावना-मानस्य
-- (m, 1)-विशेषः, अत्र प्रमाणितः ।
--
-- सूचना (honest scope) : "चक्रम्" इति यत् m-वरणम् (k ∣ (a+bm) यथा, |m²−N|
-- अल्पतमं यथा) च k-भाजनम् (a',b',k' पूर्णाङ्काः), तत् अल्गोरिदम-भागः अत्र न
-- साधितः — केवलं पदस्य बीजगणित-सारः (भावना-रूप-रक्षा) ।  समाप्ति-प्रमाणं च
-- वरण-न्यूनीकरणं अग्रिमे ।  (only the step's algebraic core — that the cyclic
-- step is bhāvanā with (m,1), preserving the form — is proved.  The m-choice
-- and the exact division by k, the actual "cakra", are the algorithmic parts
-- left for later; not faked.)
------------------------------------------------------------------------

module Cakravala where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_ ; ·IdR)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Brahmagupta using (मान ; संयोग-प्र ; संयोग-द्वि ; भावना-मान)

------------------------------------------------------------------------
-- चक्रीय-पदम् — अन्तर्वेशकेन (m, 1) भावना : संयोगस्य मानं = k · (m²−N) ।
-- (the cyclic step as bhāvanā with (m,1): the composite's norm is k·(m²−N).)
------------------------------------------------------------------------

चक्रीय-पद : (N a b m : ℤ)
          → मान N (संयोग-प्र N a b m (pos 1)) (संयोग-द्वि a b m (pos 1))
          ≡ (मान N a b) · (मान N m (pos 1))
चक्रीय-पद N a b m = भावना-मान N a b m (pos 1)

-- मानम् (m, 1) = m² − N·1² (अन्तर्वेशकस्य मानम्) ; अतः संयोगस्य मानम् =
-- k · (m² − N) — रूपं रक्षितम्, k नवः हरः ।
-- (so the new triple's "k-times form" is k·(m²−N): the form is preserved,
-- with k the new divisor — the heart of the cakravāla's cycle.)

------------------------------------------------------------------------
-- अन्तर्वेशक-मानम् — अन्तर्वेशकस्य (m,1) मानम् = m² − N (वलय-साधकेन) ।
------------------------------------------------------------------------

अन्तर्वेशक-मानम् : (N m : ℤ) → मान N m (pos 1) ≡ (m · m) - N
अन्तर्वेशक-मानम् N m =
    cong (λ z → (m · m) - (N · z)) (·IdR (pos 1))
  ∙ cong (λ z → (m · m) - z) (·IdR N)

------------------------------------------------------------------------
-- चक्रीय-पद-रूपम् — चक्रवालस्य हृदयम्, बद्ध-रूपे : संयोगस्य मानम् = k·(m²−N) ,
-- यत्र k = पूर्व-मानम् (मान N a b) ।  रूपं रक्षितम् ; m² − N नवः गुणकः ।
-- (The cakravāla cycle's heart in closed form: the composite's norm is
--  k·(m²−N), k the previous norm.  The form is preserved and m²−N is the new
--  factor — चक्रीय-पद with the interpolator's norm substituted.)
------------------------------------------------------------------------

चक्रीय-पद-रूपम् : (N a b m : ℤ)
              → मान N (संयोग-प्र N a b m (pos 1)) (संयोग-द्वि a b m (pos 1))
              ≡ (मान N a b) · ((m · m) - N)
चक्रीय-पद-रूपम् N a b m =
    चक्रीय-पद N a b m ∙ cong ((मान N a b) ·_) (अन्तर्वेशक-मानम् N m)
