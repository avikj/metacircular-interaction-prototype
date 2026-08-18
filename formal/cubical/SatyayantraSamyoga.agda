{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सत्ययन्त्र-संयोगः — अभ्रान्त-यन्त्राणि संयुज्यन्ते ।  यदि I→O अभ्रान्तम्, O→P च
-- अभ्रान्तम्, तर्हि I→P अपि अभ्रान्तम् — प्रमाणानां संयोगः (न्याय-दृष्ट्या) ।
-- अनुदाने स्थैर्येण एकीक्रियेते ।  अतः सत्ययन्त्र-रूपं संयोग-बद्धम् (category-वत्) ।
--
-- (honest machines compose: if I→O and O→P are honest, so is I→P — the
-- Nyāya chaining of valid means of knowledge (pramāṇa).  Grants are aligned
-- by stability.  So the honest-machine interface is closed under
-- composition — a category-like structure.)
--
-- संयोग-शुद्ध i p = Σ[ o ] (श१ i o × श२ o p) — सम्बन्ध-संयोगः (relational
-- composition), साक्षि-सहितः ।  (the composite's soundness relation is the
-- relational composition, carrying both witnesses.)
------------------------------------------------------------------------

module SatyayantraSamyoga where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; +-comm)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Satyayantra using (सत्ययन्त्र ; सूचना ; उक्त ; अनुक्त)

------------------------------------------------------------------------
-- सूचना-योजना — विकल्प-योजना (bind) : उक्तं वहति, अनुक्तं धारयति ।
------------------------------------------------------------------------

सूचना-योजना : {O P : Type} → सूचना O → (O → सूचना P) → सूचना P
सूचना-योजना (उक्त o) f = f o
सूचना-योजना अनुक्त   _ = अनुक्त

private
  क्षेत्र : {O : Type} → सूचना O → Type
  क्षेत्र (उक्त _) = ⊥
  क्षेत्र अनुक्त   = Unit

  अनुक्त≢उक्त : {O : Type} {p : O} → ¬ (अनुक्त ≡ उक्त p)
  अनुक्त≢उक्त eq = subst क्षेत्र eq tt

-- योजना-व्युत्क्रमः — योजना उक्तं ददाति चेत्, उभे अङ्गे उक्ते आस्ताम् ।
योजना-व्युत्क्रम : {O P : Type} (s : सूचना O) (f : O → सूचना P) (p : P)
              → सूचना-योजना s f ≡ उक्त p
              → Σ[ o ∈ O ] ((s ≡ उक्त o) × (f o ≡ उक्त p))
योजना-व्युत्क्रम (उक्त o) f p eq = o , refl , eq
योजना-व्युत्क्रम अनुक्त   f p eq = ⊥-rec (अनुक्त≢उक्त eq)

------------------------------------------------------------------------
-- संयोगः — द्वयोः सत्ययन्त्रयोः संयोगः ।
------------------------------------------------------------------------

संयोग : {I O P : Type} {श१ : I → O → Type} {श२ : O → P → Type}
      → सत्ययन्त्र I O श१ → सत्ययन्त्र O P श२
      → सत्ययन्त्र I P (λ i p → Σ[ o ∈ O ] (श१ i o × श२ o p))
संयोग {I} {O} {P} {श१} {श२} Y१ Y२ = record
  { चल    = λ g i → सूचना-योजना (चल१ g i) (λ o → चल२ g o)
  ; साधुता = λ g i p eq →
      let (o , e१ , e२) = योजना-व्युत्क्रम (चल१ g i) (λ o → चल२ g o) p eq
      in o , साधुता१ g i o e१ , साधुता२ g o p e२
  ; स्थैर्य  = λ n f i p eq →
      let (o , e१ , e२) = योजना-व्युत्क्रम (चल१ f i) (λ o → चल२ f o) p eq
      in cong (λ s → सूचना-योजना s (λ o' → चल२ (n + f) o')) (स्थैर्य१ n f i o e१)
       ∙ स्थैर्य२ n f o p e२
  ; परिपूर्णता = λ i →
      let (g१ , o , e१) = परिपूर्णता१ i
          (g२ , p , e२) = परिपूर्णता२ o
          Y१b : चल१ (g२ + g१) i ≡ उक्त o
          Y१b = स्थैर्य१ g२ g१ i o e१
          Y२b : चल२ (g२ + g१) o ≡ उक्त p
          Y२b = subst (λ g → चल२ g o ≡ उक्त p) (+-comm g१ g२)
                      (स्थैर्य२ g१ g२ o p e२)
      in (g२ + g१) , p ,
         ( cong (λ s → सूचना-योजना s (λ o' → चल२ (g२ + g१) o')) Y१b ∙ Y२b )
  }
  where
  open सत्ययन्त्र Y१ renaming (चल to चल१ ; साधुता to साधुता१ ; स्थैर्य to स्थैर्य१ ; परिपूर्णता to परिपूर्णता१)
  open सत्ययन्त्र Y२ renaming (चल to चल२ ; साधुता to साधुता२ ; स्थैर्य to स्थैर्य२ ; परिपूर्णता to परिपूर्णता२)

------------------------------------------------------------------------
-- तत्समता-यन्त्रम् — तत्पुरुष-प्रमाणम् : यत् अस्ति तत् एव ददाति (identity) ।
-- शुद्ध i o = (i ≡ o) ; सदा उक्तम् ।  संयोगेन सह अभ्रान्त-यन्त्राणि संयोग-
-- बद्धानि (composition + identity) ।
-- (the identity honest machine — returns what is, शुद्ध = equality — the
-- identity pramāṇa, completing the compositional picture with संयोग.)
------------------------------------------------------------------------

open import Satyayantra using (उक्त-एकैकम्)

तत्समता-यन्त्र : {I : Type} → सत्ययन्त्र I I (λ i o → i ≡ o)
तत्समता-यन्त्र = record
  { चल    = λ _ i → उक्त i
  ; साधुता = λ _ i o eq → उक्त-एकैकम् eq          -- उक्त i ≡ उक्त o ⟹ i ≡ o
  ; स्थैर्य  = λ _ _ _ _ eq → eq                   -- अनुदान-निरपेक्षः
  ; परिपूर्णता = λ i → 0 , i , refl                 -- सदा उक्तम्
  }
