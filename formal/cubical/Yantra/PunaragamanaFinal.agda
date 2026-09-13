{-# OPTIONS --cubical --guardedness --safe #-}

module Yantra.PunaragamanaFinal where

open import Cubical.Foundations.Prelude     using (Type; _≡_; PathP; refl; sym; cong; _∙_; transport; transport-filler; ~_; _∨_)
open import Cubical.Foundations.Isomorphism using (Iso; iso; isoToEquiv)
open import Cubical.Foundations.Equiv       using (_≃_; isEquiv; equiv-proof)
open import Cubical.Foundations.Univalence  using (ua)
open import Cubical.Data.Nat                using (ℕ; zero; suc; _+_; snotz; injSuc)
open import Cubical.Data.Nat.Properties     using (+-suc)
open import Cubical.Data.Sigma              using (Σ; _,_; fst; snd)
open import Cubical.Data.Empty              using (⊥)
import Cubical.Codata.Stream.Base as S

infixr 4 _×_
_×_ : Type → Type → Type
A × B = Σ A (λ _ → B)

record विवेक : Type where
  constructor गभीर
  field
    सम     : ℕ
    वाम    : ℕ
    दक्षिण : ℕ
    प्रमाण : दक्षिण ≡ सम + वाम
open विवेक public

अवतरण : ℕ × ℕ → विवेक
अवतरण (s , l) = गभीर s l (s + l) refl

उत्थान : विवेक → ℕ × ℕ
उत्थान v = सम v , वाम v

पुनरागमनम् : (x : ℕ × ℕ) → उत्थान (अवतरण x) ≡ x
पुनरागमनम् (s , l) = refl

अवतरण-उत्थान : (v : विवेक) → अवतरण (उत्थान v) ≡ v
अवतरण-उत्थान (गभीर s l r p) i = गभीर s l (p (~ i)) (λ j → p (~ i ∨ j))

युग्म-विवेक-Iso : Iso (ℕ × ℕ) विवेक
युग्म-विवेक-Iso = iso अवतरण उत्थान अवतरण-उत्थान पुनरागमनम्

युग्म≃विवेक : (ℕ × ℕ) ≃ विवेक
युग्म≃विवेक = isoToEquiv युग्म-विवेक-Iso

युग्म≡विवेक : (ℕ × ℕ) ≡ विवेक
युग्म≡विवेक = ua युग्म≃विवेक

परिवहन : ℕ × ℕ → विवेक
परिवहन x = transport (λ i → युग्म≡विवेक i) x

परिवहन-अवतरण : (x : ℕ × ℕ) → परिवहन x ≡ अवतरण x
परिवहन-अवतरण x = refl

प्रत्यावर्तन : (v : विवेक) → transport (λ i → युग्म≡विवेक (~ i)) v ≡ उत्थान v
प्रत्यावर्तन v = refl

Φ : ℕ × ℕ → ℕ × ℕ
Φ (s , l) = suc s , suc l

Φ-विवेक : विवेक → विवेक
Φ-विवेक v = अवतरण (Φ (उत्थान v))

Φ-परिवहन : transport (λ i → युग्म≡विवेक i → युग्म≡विवेक i) Φ ≡ Φ-विवेक
Φ-परिवहन = refl

Φ-पथ : PathP (λ i → युग्म≡विवेक i → युग्म≡विवेक i) Φ Φ-विवेक
Φ-पथ = transport-filler (λ i → युग्म≡विवेक i → युग्म≡विवेक i) Φ

Φ-injective : (a b : ℕ × ℕ) → Φ a ≡ Φ b → a ≡ b
Φ-injective (s , l) (s' , l') p i = injSuc (cong fst p) i , injSuc (cong snd p) i

Φ-not-equiv : isEquiv Φ → ⊥
Φ-not-equiv e = snotz (cong fst (snd (fst (equiv-proof e (0 , 0)))))

Φ-विवेक-injective : (u v : विवेक) → Φ-विवेक u ≡ Φ-विवेक v → u ≡ v
Φ-विवेक-injective = transport (λ i → (u v : युग्म≡विवेक i) → Φ-पथ i u ≡ Φ-पथ i v → u ≡ v) Φ-injective

Φ-विवेक-not-equiv : isEquiv Φ-विवेक → ⊥
Φ-विवेक-not-equiv = transport (λ i → isEquiv (Φ-पथ i) → ⊥) Φ-not-equiv

Φ-सम : (v : विवेक) → सम (Φ-विवेक v) ≡ suc (सम v)
Φ-सम v = refl

Φ-वाम : (v : विवेक) → वाम (Φ-विवेक v) ≡ suc (वाम v)
Φ-वाम v = refl

Φ-गभीर : (v : विवेक) → दक्षिण (Φ-विवेक v) ≡ सम (Φ-विवेक v) + वाम (Φ-विवेक v)
Φ-गभीर v = प्रमाण (Φ-विवेक v)

Φ-दक्षिण-द्वि : (v : विवेक) → दक्षिण (Φ-विवेक v) ≡ suc (suc (दक्षिण v))
Φ-दक्षिण-द्वि v = cong suc (+-suc (सम v) (वाम v)) ∙ cong (λ z → suc (suc z)) (sym (प्रमाण v))

जाल : Type
जाल = S.Stream विवेक

बुन : विवेक → जाल
S.Stream.head (बुन v) = v
S.Stream.tail (बुन v) = बुन (Φ-विवेक v)

आरम्भ : ℕ × ℕ → जाल
आरम्भ x = बुन (अवतरण x)

नत : ℕ → जाल → विवेक
नत zero    s = S.Stream.head s
नत (suc n) s = नत n (S.Stream.tail s)

एक-पद : (v : विवेक) → नत 1 (बुन v) ≡ Φ-विवेक v
एक-पद v = refl

एक-पद-उत्थान : (v : विवेक) → उत्थान (नत 1 (बुन v)) ≡ Φ (उत्थान v)
एक-पद-उत्थान v = refl

एक-पद-परिवहन : (v : विवेक) → परिवहन (Φ (उत्थान v)) ≡ नत 1 (बुन v)
एक-पद-परिवहन v = refl

आरम्भ-पुनरागमनम् : (x : ℕ × ℕ) → उत्थान (नत 0 (आरम्भ x)) ≡ x
आरम्भ-पुनरागमनम् x = refl

_ : नत 0 (आरम्भ (3 , 4)) ≡ गभीर 3 4 7  refl
_ = refl
_ : नत 1 (आरम्भ (3 , 4)) ≡ गभीर 4 5 9  refl
_ = refl
_ : नत 2 (आरम्भ (3 , 4)) ≡ गभीर 5 6 11 refl
_ = refl
_ : नत 3 (आरम्भ (3 , 4)) ≡ गभीर 6 7 13 refl
_ = refl
_ : नत 4 (आरम्भ (3 , 4)) ≡ गभीर 7 8 15 refl
_ = refl
