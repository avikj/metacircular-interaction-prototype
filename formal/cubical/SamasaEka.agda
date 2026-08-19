{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समास-एकः — नारायणस्य समास-भावनायाः निम्नतम-रूपम् : एक-अंश-गणः {१} ।
--
-- यदा अंश-गणः केवलम् एकम् एककम् अंशं वहति (ps = 0 ∷ [], अर्थात् {१}), तदा
-- प्रति n-मानाय एकः एव समासः — सर्वे पदाः एककाः (१+१+…+१) ।  अतः
--     length (सर्गः {१} n) ≡ 1   (सर्वेषु n) ।
-- एषा समास-मेरु-कुलस्य ध्रुव-रेखा : {१,२} विरहाङ्कः, {१,३} नारायणः — सर्वे
-- अस्याः एक-रूप-श्रेढेः (१,१,१,…) परिवर्धनाः ।  अत्र go/विभागः/अपाकरणम्-यन्त्रं
-- साक्षात् चाल्यते : suc-पदे map (० ∷_) एकम् एव पूर्व-रूपं वहति, अन्यत् किमपि न ।
--
-- (The degenerate base of Nārāyaṇa's samāsa-bhāvanā: when the part-set holds
--  only the single unit part (ps = [0], i.e. {1}), every n has exactly ONE
--  composition — all ones (1+1+…+1) — so length(सर्गः {1} n) ≡ 1 for all n.
--  This is the fixed line of the whole samāsa-meru family: Virahāṅka {1,2} and
--  Nārāyaṇa {1,3} are perturbations of this constant 1,1,1,… .  The proof
--  drives the actual go/विभागः/अपाकरणम् machinery: at each successor the map
--  (0 ∷_) carries exactly the one previous form, nothing else.)
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module SamasaEka where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-zero)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map ; length)
open import Cubical.Data.List.Properties using (length-map)
open import SamasaMeruN using (सर्गः ; समासः)

------------------------------------------------------------------------
-- length-++ — दैर्घ्यं योगे (स्वयं सिद्धम्, यथा Narayana.agda-मध्ये) ।
------------------------------------------------------------------------

length-++ : {A : Type} (xs ys : List A)
          → length (xs ++ ys) ≡ length xs + length ys
length-++ []       ys = refl
length-++ (x ∷ xs) ys = cong suc (length-++ xs ys)

------------------------------------------------------------------------
-- एक-अंशः — {१}-समास-मेरुः ध्रुवः : length (सर्गः {१} n) ≡ 1 (एक-रूप-श्रेढी) ।
------------------------------------------------------------------------

एक-अंशः : (n : ℕ) → length (सर्गः (0 ∷ []) n) ≡ 1
एक-अंशः zero    = refl
एक-अंशः (suc m) =
    length-++ (map (0 ∷_) (सर्गः (0 ∷ []) m)) []
  ∙ +-zero (length (map (0 ∷_) (सर्गः (0 ∷ []) m)))
  ∙ length-map (0 ∷_) (सर्गः (0 ∷ []) m)
  ∙ एक-अंशः m

------------------------------------------------------------------------
-- उदाहरणे — {१}-श्रेढी सर्वदा एकम् (refl-सिद्धानि) ।
------------------------------------------------------------------------

एक-५ : length (सर्गः (0 ∷ []) 5) ≡ 1
एक-५ = refl

एक-९ : length (सर्गः (0 ∷ []) 9) ≡ 1
एक-९ = refl

------------------------------------------------------------------------
-- शून्य-अंश-गणः — रिक्तः अंश-गणः {} : कुलस्य शून्यम् ।  न कश्चित् अंशः, अतः
-- केवलं शून्य-मानस्य रिक्तः समासः जायते ; धन-मानस्य किमपि न ।  अतः
--     length (सर्गः {} 0) ≡ 1 ,  length (सर्गः {} (n+1)) ≡ 0 ।
-- ({१}-गणः ध्रुव-श्रेढी, {}-गणः शून्य-सूचकः — कुलस्य द्वौ अन्तौ ।  जनकः एतत्
-- साक्षात् गणयति, आगमनं विना ।)
--
-- (The empty part-set {}: the zero of the family.  With no parts, only the
--  empty composition of 0 arises, nothing of any positive value — so
--  length(सर्गः {} 0) ≡ 1 and length(सर्गः {} (n+1)) ≡ 0.  Where {1} is the
--  constant line, {} is the 0-indicator: the two degenerate ends.  The
--  generator decides both outright, no induction.)
------------------------------------------------------------------------

शून्य-अंश-० : length (सर्गः [] 0) ≡ 1
शून्य-अंश-० = refl

शून्य-अंश-सुक् : (n : ℕ) → length (सर्गः [] (suc n)) ≡ 0
शून्य-अंश-सुक् n = refl
