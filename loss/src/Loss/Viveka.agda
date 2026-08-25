{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- विवेक -- the arithmetic instance.
--
-- विवेक = Carrier योग  where  योग (s , l) = s + l.
--
-- The fibre Σ[ r ∈ ℕ ] (s + l ≡ r) is singl (s + l), contractible.
-- That is why (ℕ × ℕ) ≃ विवेक.  It is also the constraint: a record
-- carrying anything NOT determined by (सम , वाम) would not be
-- equivalent to ℕ × ℕ at all.
------------------------------------------------------------------------

module Loss.Viveka where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat using (ℕ; suc; _+_)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd)

open import Loss.Carrier
open import Loss.Orbit
open import Loss.Nucleus

योग : ℕ × ℕ → ℕ
योग x = fst x + snd x

विवेक : Type
विवेक = Carrier योग

-- the four coordinates
सम : विवेक → ℕ
सम v = fst (base v)

वाम : विवेक → ℕ
वाम v = snd (base v)

दक्षिण : विवेक → ℕ
दक्षिण v = carried v

प्रमाण : (v : विवेक) → सम v + वाम v ≡ दक्षिण v
प्रमाण v = witness v

-- exact geometric fibre
दक्षिण-क्षेत्र : ℕ → ℕ → Type
दक्षिण-क्षेत्र s l = singl (s + l)

दक्षिण-क्षेत्र-सम्पूर्ण : (s l : ℕ) → isContr (दक्षिण-क्षेत्र s l)
दक्षिण-क्षेत्र-सम्पूर्ण s l = isContrSingl (s + l)

-- pair ↔ विवेक
अवतरण : ℕ × ℕ → विवेक
अवतरण = descend योग

उत्थान : विवेक → ℕ × ℕ
उत्थान = ascend योग

पुनरागमनम् : (x : ℕ × ℕ) → उत्थान (अवतरण x) ≡ x
पुनरागमनम् = ascend-descend योग

अवतरण-उत्थान : (v : विवेक) → अवतरण (उत्थान v) ≡ v
अवतरण-उत्थान = descend-ascend योग

-- iso / equivalence / univalence / transport
युग्म-विवेक-Iso : Iso (ℕ × ℕ) विवेक
युग्म-विवेक-Iso = Carrier-Iso योग

युग्म≃विवेक : (ℕ × ℕ) ≃ विवेक
युग्म≃विवेक = Carrier≃ योग

युग्म≡विवेक : (ℕ × ℕ) ≡ विवेक
युग्म≡विवेक = Carrier≡ योग

परिवहन : ℕ × ℕ → विवेक
परिवहन = carry-transport योग

परिवहन-अवतरण : (x : ℕ × ℕ) → परिवहन x ≡ अवतरण x
परिवहन-अवतरण = carry-transport-descend योग

-- developmental action
Φ : ℕ × ℕ → ℕ × ℕ
Φ x = suc (fst x) , suc (snd x)

Φ-विवेक : विवेक → विवेक
Φ-विवेक = Φ-carrier योग Φ

Φ-सम : (v : विवेक) → सम (Φ-विवेक v) ≡ suc (सम v)
Φ-सम v = refl

Φ-वाम : (v : विवेक) → वाम (Φ-विवेक v) ≡ suc (वाम v)
Φ-वाम v = refl

Φ-दक्षिण : (v : विवेक) → दक्षिण (Φ-विवेक v) ≡ suc (सम v) + suc (वाम v)
Φ-दक्षिण v = refl

Φ-प्रमाण : (v : विवेक) → suc (सम v) + suc (वाम v) ≡ दक्षिण (Φ-विवेक v)
Φ-प्रमाण v = प्रमाण (Φ-विवेक v)

-- the square, definitional, opaque argument
Φ-पुनरागमनम् : (v : विवेक) → उत्थान (Φ-विवेक v) ≡ Φ (उत्थान v)
Φ-पुनरागमनम् = Φ-ascend योग Φ

Φ-अवतरण : (x : ℕ × ℕ) → Φ-विवेक (अवतरण x) ≡ अवतरण (Φ x)
Φ-अवतरण = Φ-square योग Φ

Φ-परिवहन : (x : ℕ × ℕ) → परिवहन (Φ x) ≡ Φ-विवेक (अवतरण x)
Φ-परिवहन = Φ-transport योग Φ

-- जाल, the orbit
जाल : Type
जाल = Orbit विवेक

इदम् : जाल → विवेक
इदम् = here

पुनः : जाल → जाल
पुनः = next

बुन : विवेक → जाल
बुन = unfold Φ-विवेक

आरम्भ : ℕ × ℕ → जाल
आरम्भ x = बुन (अवतरण x)

आरम्भ-इदम् : (x : ℕ × ℕ) → इदम् (आरम्भ x) ≡ अवतरण x
आरम्भ-इदम् x = refl

आरम्भ-पुनरागमनम् : (x : ℕ × ℕ) → उत्थान (इदम् (आरम्भ x)) ≡ x
आरम्भ-पुनरागमनम् = पुनरागमनम्

एक-पद : (v : विवेक) → इदम् (पुनः (बुन v)) ≡ Φ-विवेक v
एक-पद v = refl

एक-पद-उत्थान : (v : विवेक) → उत्थान (इदम् (पुनः (बुन v))) ≡ Φ (उत्थान v)
एक-पद-उत्थान = Φ-पुनरागमनम्

एक-पद-परिवहन : (x : ℕ × ℕ) → परिवहन (Φ x) ≡ इदम् (पुनः (आरम्भ x))
एक-पद-परिवहन = Φ-परिवहन

------------------------------------------------------------------------
-- Beyond the original: the return holds at INFINITE depth.
-- These cannot even be STATED for a bare coinductive record; they need
-- Orbit's bisimulation principle.
------------------------------------------------------------------------

अनन्त-अवतरण : (x : ℕ × ℕ) → mapO अवतरण (unfold Φ x) ≡ आरम्भ x
अनन्त-अवतरण = descend-orbit योग Φ

अनन्त-पुनरागमनम् : (x : ℕ × ℕ) → mapO उत्थान (आरम्भ x) ≡ unfold Φ x
अनन्त-पुनरागमनम् = ascend-orbit योग Φ

अनन्त-परिवहन : (x : ℕ × ℕ) → mapO परिवहन (unfold Φ x) ≡ आरम्भ x
अनन्त-परिवहन = transport-orbit योग Φ

अनन्त-निरीक्षण : (x : ℕ × ℕ) (n : ℕ)
               → lookup (आरम्भ x) n ≡ अवतरण (iterate Φ n x)
अनन्त-निरीक्षण = orbit-lookup योग Φ
