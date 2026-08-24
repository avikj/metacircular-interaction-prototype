-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गुरुतमः सिद्धः — यदि गतिः a b समाप्ता (g प्रयच्छति), तर्हि g तयोः गुरुतमः
-- साधारणः विभाजकः — प्रमाणपुस्तकस्य (Cubical.Data.Nat.GCD) isGCD-द्वारा
-- प्रमाणितः, यत्र अन्तर्भूता एकत्वम् अपि (isPropGCD) ।
--
-- द्वौ आरोहौ : (१) विभजति-लेखः — g उभौ विभजति (साधारणः) ; (२) महत्-लेखः —
-- यः कोऽपि साधारणः d' सः g विभजति (गुरुतमः) ।  मूलमन्त्रम् : आर्यभटस्य
-- अन्तर-वियोजनं साधारण-विभाजकान् उभयतः रक्षति — ∣-योगः (सङ्कलने) च
-- ∣-अन्तरः (वियोजने) ; उत्थानेन (पुनरागमनम्) ऊर्ध्वं नीयते ।
--
-- (greatest common measure, PROVED: if गति a b resolves to g, then g is the
-- greatest common divisor — certified via the library's isGCD, which
-- carries uniqueness.  Two ascents: g divides both (common), and every
-- common d' divides g (greatest).  The engine is that Āryabhaṭa's
-- subtraction preserves common divisors in BOTH directions — ∣-योग on sums,
-- ∣-अन्तर on differences — lifted up the spine by पुनरागमनम्.)
--
-- अनुक्ते (अनुदान-क्षये) दावा नास्ति — क्षेत्रेण असम्भवः ; न दुर्नयः ।
-- (on the un-said/grant-exhausted branch nothing is claimed — impossible by
-- क्षेत्र; no durnaya.)
------------------------------------------------------------------------

module GurutamaSiddha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ; +-assoc ; ∸-distribʳ ; ∸+)
open import Cubical.Data.Nat.Divisibility
  using (_∣_ ; ∣-untrunc ; ∣-refl ; ∣-zeroʳ)
open import Cubical.Data.Nat.GCD using (isCD ; isGCD)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.HITs.PropositionalTruncation as PT using (∣_∣₁)
open import Punaragamana
  using (विवेक ; सम ; वाम ; दक्षिण ; अवतरण ; उत्थान ; पुनरागमनम्)
open import Gati
  using (फलम् ; गुरुः ; अनुक्तफलम् ; फल ; पद-गति ; गति)
open import Gurutama using (क्षेत्र ; मान)

------------------------------------------------------------------------
-- वितरण, ∣-योग, ∣-अन्तर — साधारण-विभाजकानां सङ्कलने वियोजने च रक्षा ।
------------------------------------------------------------------------

वितरण : (a b m : ℕ) → (a + b) · m ≡ (a · m) + (b · m)
वितरण zero    b m = refl
वितरण (suc a) b m = cong (m +_) (वितरण a b m) ∙ +-assoc m (a · m) (b · m)

-- सङ्कलने : m ∣ x → m ∣ y → m ∣ (x + y)
∣-योग : {म x y : ℕ} → म ∣ x → म ∣ y → म ∣ (x + y)
∣-योग {म} {x} {y} = PT.map2 λ (qx , px) (qy , py) →
  (qx + qy) , वितरण qx qy म ∙ cong₂ _+_ px py

-- वियोजने : m ∣ (x + y) → m ∣ x → m ∣ y  (Āryabhaṭa's difference law)
∣-अन्तर : {म x y : ℕ} → म ∣ (x + y) → म ∣ x → म ∣ y
∣-अन्तर {म} {x} {y} pxy px =
  let (c₁ , e₁) = ∣-untrunc pxy          -- c₁ · म ≡ x + y
      (c₂ , e₂) = ∣-untrunc px           -- c₂ · म ≡ x
  in ∣ (c₁ ∸ c₂)
     , ( ∸-distribʳ c₁ c₂ म
       ∙ cong₂ _∸_ e₁ e₂
       ∙ ∸+ y x )                        -- (x + y) ∸ x ≡ y
     ∣₁

------------------------------------------------------------------------
-- विभजति-लेखः — g अस्य लेखस्य युग्मं उभयतः विभजति (साधारणः) ।
------------------------------------------------------------------------

विभजति : (f : ℕ) (v : विवेक) (g : ℕ)
       → फल (पद-गति f v) ≡ गुरुः g
       → (g ∣ fst (उत्थान v)) × (g ∣ snd (उत्थान v))
विभजति zero v g eq = ⊥-rec (subst क्षेत्र (sym eq) tt)
विभजति (suc f) (सम d) g eq =
  ∣-refl g≡d , ∣-refl g≡d
  where g≡d = sym (cong मान eq)
विभजति (suc f) (वाम zero k) g eq =
  ∣-refl (sym (cong मान eq)) , ∣-zeroʳ g
विभजति (suc f) (दक्षिण zero k) g eq =
  ∣-zeroʳ g , ∣-refl (sym (cong मान eq))
विभजति (suc f) (वाम (suc d) k) g eq =
  let rec = विभजति f (अवतरण (suc k) (suc d)) g eq
      p   = पुनरागमनम् (suc k) (suc d)
      g∣k = subst (g ∣_) (cong fst p) (fst rec)
      g∣d = subst (g ∣_) (cong snd p) (snd rec)
  in ∣-योग g∣d g∣k , g∣d
विभजति (suc f) (दक्षिण (suc d) k) g eq =
  let rec = विभजति f (अवतरण (suc d) (suc k)) g eq
      p   = पुनरागमनम् (suc d) (suc k)
      g∣d = subst (g ∣_) (cong fst p) (fst rec)
      g∣k = subst (g ∣_) (cong snd p) (snd rec)
  in g∣d , ∣-योग g∣d g∣k

------------------------------------------------------------------------
-- महत्-लेखः — यः कोऽपि साधारणः d' अस्य लेखस्य युग्मस्य, सः g विभजति ।
------------------------------------------------------------------------

महत् : (f : ℕ) (v : विवेक) (g d' : ℕ)
     → फल (पद-गति f v) ≡ गुरुः g
     → d' ∣ fst (उत्थान v) → d' ∣ snd (उत्थान v)
     → d' ∣ g
महत् zero v g d' eq _ _ = ⊥-rec (subst क्षेत्र (sym eq) tt)
महत् (suc f) (सम d) g d' eq h₁ _ =
  subst (d' ∣_) (cong मान eq) h₁
महत् (suc f) (वाम zero k) g d' eq h₁ _ =
  subst (d' ∣_) (cong मान eq) h₁
महत् (suc f) (दक्षिण zero k) g d' eq _ h₂ =
  subst (d' ∣_) (cong मान eq) h₂
महत् (suc f) (वाम (suc d) k) g d' eq h₁ h₂ =
  let p    = पुनरागमनम् (suc k) (suc d)
      d'∣k = ∣-अन्तर h₁ h₂          -- fst = suc d + suc k, snd = suc d ⟹ d' ∣ suc k
  in महत् f (अवतरण (suc k) (suc d)) g d' eq
          (subst (d' ∣_) (sym (cong fst p)) d'∣k)
          (subst (d' ∣_) (sym (cong snd p)) h₂)
महत् (suc f) (दक्षिण (suc d) k) g d' eq h₁ h₂ =
  let p    = पुनरागमनम् (suc d) (suc k)
      d'∣k = ∣-अन्तर h₂ h₁          -- snd = suc d + suc k, fst = suc d ⟹ d' ∣ suc k
  in महत् f (अवतरण (suc d) (suc k)) g d' eq
          (subst (d' ∣_) (sym (cong fst p)) h₁)
          (subst (d' ∣_) (sym (cong snd p)) d'∣k)

------------------------------------------------------------------------
-- सिद्धः — मुख्यसिद्धान्तः : गतिः यदि g प्रयच्छति, तर्हि isGCD a b g ।
-- (main theorem: if the pulverizer resolves to g, then g is THE greatest
-- common divisor of a and b — library-certified, uniqueness included.)
------------------------------------------------------------------------

सिद्धः : (f a b g : ℕ) → फल (गति f a b) ≡ गुरुः g → isGCD a b g
सिद्धः f a b g eq = साधारणः , गुरुतमः
  where
  p      = पुनरागमनम् a b
  rec-cd = विभजति f (अवतरण a b) g eq
  g∣a    = subst (g ∣_) (cong fst p) (fst rec-cd)
  g∣b    = subst (g ∣_) (cong snd p) (snd rec-cd)

  साधारणः : isCD a b g
  साधारणः = g∣a , g∣b

  गुरुतमः : (d' : ℕ) → isCD a b d' → d' ∣ g
  गुरुतमः d' (d'∣a , d'∣b) =
    महत् f (अवतरण a b) g d' eq
         (subst (d' ∣_) (sym (cong fst p)) d'∣a)
         (subst (d' ∣_) (sym (cong snd p)) d'∣b)
