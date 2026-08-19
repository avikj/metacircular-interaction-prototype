{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- बहु-समास-मेरुः — नारायणस्य समास-भावना यथेच्छ-अंश-गणे (गणितकौमुदी, १३५६) ।
--
-- SamasaMeru.agda {१,L}-कुलं (द्वि-अंशं) साधितवत् ; इदं तत् विशाल-अवक्तव्यं
-- निवारयति : यथेच्छः अंश-गणः S = {s₀, s₁, …} (त्रि-अधिक-मानः अपि) ।  अंश-गणः
-- अत्र सूची (ps : List ℕ) रूपेण, यत्र प्रति p अंशस्य मानम् = suc p (अतः ≥ १) ।
-- समासः = List ℕ (प्रति पदं ps-तः गृहीतम्) ।  आवृत्तिः : a(n) = Σ_{p∈S} a(n−sₚ) ।
--
-- (The samāsa-bhāvanā over an ARBITRARY finite part-set: SamasaMeru.agda did
-- the two-part {1,L} family; this addresses the broad avaktavya — any set of
-- part-sizes S, three or more allowed.  The set is a list ps : List ℕ, each
-- entry p meaning a part of size suc p (so every part ≥ 1).  A composition is
-- a List ℕ of chosen entries.  The count recurrence is a SUM over the parts,
-- a(n) = Σ_{p} a(n − size p) — Virahāṅka {1,2} and Nārāyaṇa {1,3} are the
-- two-part instances; {1,2,3} gives the "tribonacci" count, {2,3} a gapped set.)
--
-- जननम्, न निर्णयः : प्रति अंशाय संरचना-अपाकरणेन (अपाकरणम्) मानं शोध्यते ;
-- इन्धने (fuel) संरचनया आवर्तनम्, यथा SamasaMeru — refl-गणना रक्ष्यते ।
--
-- अस्मिन् पदे : जनन-सूत्रम् + प्रति-रूप-उदाहरणे (refl) + साधुता (साधु : जनितं
-- प्रत्येकं रूपं मानं n वहति, प्रति-अंश-योग्यता-विभागेन splitℕ-≤) ।  आवृत्तिः
-- (a(n)=Σ_p a(n−sₚ), योग-रूपा) पूर्णता च उत्तर-पदेषु (इन्धन-अनपेक्षतया) ।
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module SamasaMeruN where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; snotz)
open import Cubical.Data.Nat.Properties using (+-suc)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-suc ; pred-≤-pred ; zero-≤ ; splitℕ-≤)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map ; length)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
import Cubical.Data.Empty as ⊥

------------------------------------------------------------------------
-- समासः = List ℕ — प्रति पदं p अर्थात् suc p-मानः अंशः ।  मानम् = योगः ।
------------------------------------------------------------------------

समासः : Type
समासः = List ℕ

मानम् : समासः → ℕ
मानम् []       = zero
मानम् (p ∷ xs) = suc (p + मानम् xs)

------------------------------------------------------------------------
-- अंश-गण-आश्रितं जननम् : ps = अंश-सूची (प्रति p → suc p मानः) ।
------------------------------------------------------------------------

module _ (ps : List ℕ) where

  mutual
    go : ℕ → ℕ → List समासः
    go zero    zero    = [] ∷ []
    go zero    (suc n) = []
    go (suc f) zero    = [] ∷ []
    go (suc f) (suc n) = विभागः f (suc n) ps

    -- विभागः f n qs : प्रति अंशाय p ∈ qs, p उपसृज्य (suc p अपाकृत्य) go f (शेषः) ।
    विभागः : ℕ → ℕ → List ℕ → List समासः
    विभागः f n []       = []
    विभागः f n (p ∷ qs) = map (p ∷_) (अपाकरणम् f n (suc p)) ++ विभागः f n qs

    -- अपाकरणम् f t r : t-तः r सुक्-पदानि संरचनया अपाकृत्य, शेषस्य go f ।
    अपाकरणम् : ℕ → ℕ → ℕ → List समासः
    अपाकरणम् f t       zero    = go f t
    अपाकरणम् f zero    (suc r) = []
    अपाकरणम् f (suc t) (suc r) = अपाकरणम् f t r

  सर्गः : ℕ → List समासः
  सर्गः n = go n n

  ----------------------------------------------------------------------
  -- साधुता — जनितं प्रत्येकं रूपं मानं n वहति (soundness) ।  प्रति अंशाय
  -- दीर्घ-योग्यता-विभागः (splitℕ-≤) : suc p ≤ n चेत् मानं (शेष-रद्दनेन) n ;
  -- अन्यथा तत् अंश-भागः रिक्तः (रिक्त-अपाकरणम्) ।
  ----------------------------------------------------------------------

  data समास-All (P : समासः → Type) : List समासः → Type where
    []  : समास-All P []
    _∷_ : {x : समासः} {xs : List समासः}
        → P x → समास-All P xs → समास-All P (x ∷ xs)

  All-++ : {P : समासः → Type} {xs ys : List समासः}
         → समास-All P xs → समास-All P ys → समास-All P (xs ++ ys)
  All-++ []        bs = bs
  All-++ (p ∷ ps') bs = p ∷ All-++ ps' bs

  All-map : {P Q : समासः → Type} {g : समासः → समासः}
          → ((x : समासः) → P x → Q (g x))
          → {xs : List समासः} → समास-All P xs → समास-All Q (map g xs)
  All-map h []        = []
  All-map h (p ∷ ps') = h _ p ∷ All-map h ps'

  ¬s≤z : {m : ℕ} → suc m ≤ zero → ⊥.⊥
  ¬s≤z {m} (k , pf) = snotz (sym (+-suc k m) ∙ pf)

  शेष-रद्दनम् : (b a : ℕ) → b ≤ a → b + (a ∸ b) ≡ a
  शेष-रद्दनम् zero    a       le = refl
  शेष-रद्दनम् (suc b) zero    le = ⊥.rec (¬s≤z le)
  शेष-रद्दनम् (suc b) (suc a) le = cong suc (शेष-रद्दनम् b a (pred-≤-pred le))

  ∸-suc-≤ : (a b c : ℕ) → a ≤ suc c → a ∸ suc b ≤ c
  ∸-suc-≤ zero    b       c le = zero-≤
  ∸-suc-≤ (suc a) zero    c le = pred-≤-pred le
  ∸-suc-≤ (suc a) (suc b) c le = ∸-suc-≤ a b c (≤-suc (pred-≤-pred le))

  रिक्त-अपाकरणम् : (f t r : ℕ) → suc t ≤ r → अपाकरणम् f t r ≡ []
  रिक्त-अपाकरणम् f t       zero    le = ⊥.rec (¬s≤z le)
  रिक्त-अपाकरणम् f zero    (suc r) le = refl
  रिक्त-अपाकरणम् f (suc t) (suc r) le = रिक्त-अपाकरणम् f t r (pred-≤-pred le)

  साधु-अपाकरणम् : (f t r : ℕ)
              → समास-All (λ ys → मानम् ys ≡ t ∸ r) (go f (t ∸ r))
              → समास-All (λ ys → मानम् ys ≡ t ∸ r) (अपाकरणम् f t r)
  साधु-अपाकरणम् f t       zero    H = H
  साधु-अपाकरणम् f zero    (suc r) H = []
  साधु-अपाकरणम् f (suc t) (suc r) H = साधु-अपाकरणम् f t r H

  mutual
    साधु-go : (f n : ℕ) → n ≤ f → समास-All (λ ys → मानम् ys ≡ n) (go f n)
    साधु-go zero    zero    le = refl ∷ []
    साधु-go (suc f) zero    le = refl ∷ []
    साधु-go zero    (suc n) le = ⊥.rec (¬s≤z le)
    साधु-go (suc f) (suc n) le = साधु-विभागः f (suc n) le ps

    साधु-विभागः : (f n : ℕ) → n ≤ suc f → (qs : List ℕ)
               → समास-All (λ ys → मानम् ys ≡ n) (विभागः f n qs)
    साधु-विभागः f n n≤sf []       = []
    साधु-विभागः f n n≤sf (p ∷ qs) = All-++ (part p) (साधु-विभागः f n n≤sf qs)
      where
        part : (p : ℕ)
             → समास-All (λ ys → मानम् ys ≡ n) (map (p ∷_) (अपाकरणम् f n (suc p)))
        part p with splitℕ-≤ (suc p) n
        ... | inl fit =
              All-map (λ ys pf → cong suc (cong (p +_) pf) ∙ शेष-रद्दनम् (suc p) n fit)
                      (साधु-अपाकरणम् f n (suc p)
                        (साधु-go f (n ∸ suc p) (∸-suc-≤ n p f n≤sf)))
        ... | inr q =
              subst (λ l → समास-All (λ ys → मानम् ys ≡ n) (map (p ∷_) l))
                    (sym (रिक्त-अपाकरणम् f n (suc p) q))
                    []

  साधु : (n : ℕ) → समास-All (λ ys → मानम् ys ≡ n) (सर्गः n)
  साधु n = साधु-go n n ≤-refl

  ----------------------------------------------------------------------
  -- इन्धन-अनपेक्षता (canon) : पर्याप्तेन्धनं go न परिणमयति ।  यथेच्छ-अंश-गणे
  -- विभागः-अपाकरण-संगतिभ्याम् — SamasaMeru-रीत्या, बद्ध-प्रबल-आगमनेन ।
  ----------------------------------------------------------------------

  go-शून्य : (f : ℕ) → go f zero ≡ [] ∷ []
  go-शून्य zero    = refl
  go-शून्य (suc f) = refl

  अपाकरणम्-संगतिः : (a₁ a₂ t r : ℕ)
              → (H : (x : ℕ) → x ≤ t → go a₁ x ≡ go a₂ x)
              → अपाकरणम् a₁ t r ≡ अपाकरणम् a₂ t r
  अपाकरणम्-संगतिः a₁ a₂ t       zero    H = H t ≤-refl
  अपाकरणम्-संगतिः a₁ a₂ zero    (suc r) H = refl
  अपाकरणम्-संगतिः a₁ a₂ (suc t) (suc r) H =
    अपाकरणम्-संगतिः a₁ a₂ t r (λ x x≤t → H x (≤-trans x≤t (≤-suc ≤-refl)))

  विभागः-संगतिः : (a₁ a₂ n : ℕ) (qs : List ℕ)
              → (H : (x : ℕ) → x ≤ n → go a₁ x ≡ go a₂ x)
              → विभागः a₁ (suc n) qs ≡ विभागः a₂ (suc n) qs
  विभागः-संगतिः a₁ a₂ n []       H = refl
  विभागः-संगतिः a₁ a₂ n (p ∷ qs) H =
    cong₂ _++_ (cong (map (p ∷_)) (अपाकरणम्-संगतिः a₁ a₂ n p H))
               (विभागः-संगतिः a₁ a₂ n qs H)

  canon : (b f n : ℕ) → n ≤ b → n ≤ f → go f n ≡ go n n
  canon b       f       zero    le lf = go-शून्य f
  canon zero    f       (suc n) le lf = ⊥.rec (¬s≤z le)
  canon (suc b) zero    (suc n) le lf = ⊥.rec (¬s≤z lf)
  canon (suc b) (suc f) (suc n) le lf = विभागः-संगतिः f n n ps Hs
    where
      n≤b : n ≤ b
      n≤b = pred-≤-pred le
      n≤f : n ≤ f
      n≤f = pred-≤-pred lf
      Hs : (x : ℕ) → x ≤ n → go f x ≡ go n x
      Hs x x≤n = canon b f x (≤-trans x≤n n≤b) (≤-trans x≤n n≤f)
               ∙ sym (canon b n x (≤-trans x≤n n≤b) x≤n)

------------------------------------------------------------------------
-- प्रति-रूप-उदाहरणे — यथेच्छ-अंश-गणात् नाना-मेरवः (refl-सिद्धाः) ।
--   {१,२}   ps=[0,1]   — विरहाङ्कः : १,१,२,३,५,८,१३ ।
--   {१,३}   ps=[0,2]   — नारायणः  : १,१,१,२,३,४,६ ।
--   {१,२,३} ps=[0,1,2] — त्रि-मेरु : १,१,२,४,७,१३,२४ (tribonacci) ।
--   {२,३}   ps=[1,2]   — छिद्र-गणः : १,०,१,१,१,२,२,३ ।
------------------------------------------------------------------------

विरहाङ्क-५ : length (सर्गः (0 ∷ 1 ∷ []) 5) ≡ 8
विरहाङ्क-५ = refl

नारायण-६ : length (सर्गः (0 ∷ 2 ∷ []) 6) ≡ 6
नारायण-६ = refl

त्रिमेरु-५ : length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) 5) ≡ 13     -- tribonacci
त्रिमेरु-५ = refl

त्रिमेरु-६ : length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) 6) ≡ 24
त्रिमेरु-६ = refl

छिद्र-५ : length (सर्गः (1 ∷ 2 ∷ []) 5) ≡ 2             -- {2,3}: [2,3],[3,2]
छिद्र-५ = refl

छिद्र-७ : length (सर्गः (1 ∷ 2 ∷ []) 7) ≡ 3             -- {2,3}: [2,2,3]&perms
छिद्र-७ = refl
