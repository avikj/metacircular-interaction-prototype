{-# OPTIONS --cubical --guardedness --safe #-}

module Samkramana where

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

record rāśi-traya : Type where
  constructor nyāsa
  field
    ādya     : ℕ
    dvitīya    : ℕ
    phala : ℕ
    pramā : phala ≡ ādya + dvitīya
open rāśi-traya public

anuloma : ℕ × ℕ → rāśi-traya
anuloma (s , l) = nyāsa s l (s + l) refl

viloma : rāśi-traya → ℕ × ℕ
viloma v = ādya v , dvitīya v

viloma-anuloma : (x : ℕ × ℕ) → viloma (anuloma x) ≡ x
viloma-anuloma (s , l) = refl

anuloma-viloma : (v : rāśi-traya) → anuloma (viloma v) ≡ v
anuloma-viloma (nyāsa s l r p) i = nyāsa s l (p (~ i)) (λ j → p (~ i ∨ j))

yugma-rāśi-traya-Iso : Iso (ℕ × ℕ) rāśi-traya
yugma-rāśi-traya-Iso = iso anuloma viloma anuloma-viloma viloma-anuloma

yugma≃rāśi-traya : (ℕ × ℕ) ≃ rāśi-traya
yugma≃rāśi-traya = isoToEquiv yugma-rāśi-traya-Iso

yugma≡rāśi-traya : (ℕ × ℕ) ≡ rāśi-traya
yugma≡rāśi-traya = ua yugma≃rāśi-traya

saṃkramaṇa : ℕ × ℕ → rāśi-traya
saṃkramaṇa x = transport (λ i → yugma≡rāśi-traya i) x

saṃkramaṇa-anuloma : (x : ℕ × ℕ) → saṃkramaṇa x ≡ anuloma x
saṃkramaṇa-anuloma x = refl

pratisaṃkramaṇa : (v : rāśi-traya) → transport (λ i → yugma≡rāśi-traya (~ i)) v ≡ viloma v
pratisaṃkramaṇa v = refl

Φ : ℕ × ℕ → ℕ × ℕ
Φ (s , l) = suc s , suc l

Φ-rāśi-traya : rāśi-traya → rāśi-traya
Φ-rāśi-traya v = anuloma (Φ (viloma v))

Φ-saṃkramaṇa : transport (λ i → yugma≡rāśi-traya i → yugma≡rāśi-traya i) Φ ≡ Φ-rāśi-traya
Φ-saṃkramaṇa = refl

Φ-patha : PathP (λ i → yugma≡rāśi-traya i → yugma≡rāśi-traya i) Φ Φ-rāśi-traya
Φ-patha = transport-filler (λ i → yugma≡rāśi-traya i → yugma≡rāśi-traya i) Φ

Φ-injective : (a b : ℕ × ℕ) → Φ a ≡ Φ b → a ≡ b
Φ-injective (s , l) (s' , l') p i = injSuc (cong fst p) i , injSuc (cong snd p) i

Φ-not-equiv : isEquiv Φ → ⊥
Φ-not-equiv e = snotz (cong fst (snd (fst (equiv-proof e (0 , 0)))))

Φ-rāśi-traya-injective : (u v : rāśi-traya) → Φ-rāśi-traya u ≡ Φ-rāśi-traya v → u ≡ v
Φ-rāśi-traya-injective = transport (λ i → (u v : yugma≡rāśi-traya i) → Φ-patha i u ≡ Φ-patha i v → u ≡ v) Φ-injective

Φ-rāśi-traya-not-equiv : isEquiv Φ-rāśi-traya → ⊥
Φ-rāśi-traya-not-equiv = transport (λ i → isEquiv (Φ-patha i) → ⊥) Φ-not-equiv

Φ-ādya : (v : rāśi-traya) → ādya (Φ-rāśi-traya v) ≡ suc (ādya v)
Φ-ādya v = refl

Φ-dvitīya : (v : rāśi-traya) → dvitīya (Φ-rāśi-traya v) ≡ suc (dvitīya v)
Φ-dvitīya v = refl

Φ-nyāsa : (v : rāśi-traya) → phala (Φ-rāśi-traya v) ≡ ādya (Φ-rāśi-traya v) + dvitīya (Φ-rāśi-traya v)
Φ-nyāsa v = pramā (Φ-rāśi-traya v)

Φ-phala-dvi : (v : rāśi-traya) → phala (Φ-rāśi-traya v) ≡ suc (suc (phala v))
Φ-phala-dvi v = cong suc (+-suc (ādya v) (dvitīya v)) ∙ cong (λ z → suc (suc z)) (sym (pramā v))

santāna : Type
santāna = S.Stream rāśi-traya

grathana : rāśi-traya → santāna
S.Stream.head (grathana v) = v
S.Stream.tail (grathana v) = grathana (Φ-rāśi-traya v)

ārambha : ℕ × ℕ → santāna
ārambha x = grathana (anuloma x)

pada : ℕ → santāna → rāśi-traya
pada zero    s = S.Stream.head s
pada (suc n) s = pada n (S.Stream.tail s)

eka-pada : (v : rāśi-traya) → pada 1 (grathana v) ≡ Φ-rāśi-traya v
eka-pada v = refl

eka-pada-viloma : (v : rāśi-traya) → viloma (pada 1 (grathana v)) ≡ Φ (viloma v)
eka-pada-viloma v = refl

eka-pada-saṃkramaṇa : (v : rāśi-traya) → saṃkramaṇa (Φ (viloma v)) ≡ pada 1 (grathana v)
eka-pada-saṃkramaṇa v = refl

ārambha-viloma-anuloma : (x : ℕ × ℕ) → viloma (pada 0 (ārambha x)) ≡ x
ārambha-viloma-anuloma x = refl

_ : pada 0 (ārambha (3 , 4)) ≡ nyāsa 3 4 7  refl
_ = refl
_ : pada 1 (ārambha (3 , 4)) ≡ nyāsa 4 5 9  refl
_ = refl
_ : pada 2 (ārambha (3 , 4)) ≡ nyāsa 5 6 11 refl
_ = refl
_ : pada 3 (ārambha (3 , 4)) ≡ nyāsa 6 7 13 refl
_ = refl
_ : pada 4 (ārambha (3 , 4)) ≡ nyāsa 7 8 15 refl
_ = refl
