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
-- सिद्धम् : जनन-सूत्रम् + प्रति-रूप-उदाहरणे (refl) ; साधुता (साधु) ; इन्धन-
-- अनपेक्षता (canon) ; पूर्णता (पूर्णता : मानं यस्य=n सर्वे च पदाः ps-गताः, तत्
-- सर्गे n उदेति) ।  साधुता-पूर्णताभ्यां जनित-गणः = यथार्थतः ps-गत-पद-n-मानाः
-- समासाः — यथेच्छ-अंश-गणे नारायणस्य समास-भावना पूर्णतया साधिता ।
-- आवृत्तिः (समास-आवृत्तिः : a(n)=Σ_{p∈ps} p-भाग-गणना ; अंश-गणना : योग्ये
-- p-भागः a(n−sₚ)) — योग-रूपा, अंश-गणस्य आवर्तनम् एव ।  एवं यथेच्छ-अंश-गणे
-- नारायणस्य समास-भावना सर्वाङ्गीणतया साधिता : जननम्, साधुता, पूर्णता,
-- इन्धन-अनपेक्षता, गणना-आवृत्तिश्च ।
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module SamasaMeruN where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; snotz)
open import Cubical.Data.Nat.Properties using (+-suc ; +-zero ; +-assoc ; +-comm)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-suc ; suc-≤-suc ; pred-≤-pred ; zero-≤ ; ∸-≤ ; splitℕ-≤)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map ; length)
open import Cubical.Data.List.Properties using (length-map)
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

  ----------------------------------------------------------------------
  -- पूर्णता — मानं यस्य = n, सर्वे च पदाः ps-गताः, तत् सर्गे n उदेति ।
  -- (completeness, over compositions whose parts are all drawn from ps).
  ----------------------------------------------------------------------

  data _∈ℕ_ (a : ℕ) : List ℕ → Type where
    hereℕ  : {xs : List ℕ} → a ∈ℕ (a ∷ xs)
    thereℕ : {b : ℕ} {xs : List ℕ} → a ∈ℕ xs → a ∈ℕ (b ∷ xs)

  data सुघटित : समासः → Type where
    ∅   : सुघटित []
    _◂_ : {p : ℕ} {ys : समासः} → p ∈ℕ ps → सुघटित ys → सुघटित (p ∷ ys)

  data _∈_ (x : समासः) : List समासः → Type where
    here  : {xs : List समासः} → x ∈ (x ∷ xs)
    there : {y : समासः} {xs : List समासः} → x ∈ xs → x ∈ (y ∷ xs)

  ∈-++ˡ : {x : समासः} {xs ys : List समासः} → x ∈ xs → x ∈ (xs ++ ys)
  ∈-++ˡ here      = here
  ∈-++ˡ (there p) = there (∈-++ˡ p)

  ∈-++ʳ : {x : समासः} (xs : List समासः) {ys : List समासः} → x ∈ ys → x ∈ (xs ++ ys)
  ∈-++ʳ []       p = p
  ∈-++ʳ (z ∷ zs) p = there (∈-++ʳ zs p)

  ∈-map : {g : समासः → समासः} {x : समासः} {xs : List समासः} → x ∈ xs → (g x) ∈ map g xs
  ∈-map here      = here
  ∈-map (there p) = there (∈-map p)

  -- अपाकरण-मूल्य : suc p सुक्-पदानि अपाकृत्य शेषः q (go f q) ।
  अपाकरण-मूल्य : (f p q : ℕ) → अपाकरणम् f (suc p + q) (suc p) ≡ go f q
  अपाकरण-मूल्य f zero    q = refl
  अपाकरण-मूल्य f (suc p) q = अपाकरण-मूल्य f p q

  -- विभागः-∈ : p ∈ℕ qs चेत् p-भागस्य सदस्यः विभागे उदेति (स्थान-अनुसारेण) ।
  -- (qs गूढम् ; ∈ℕ-प्रमाणस्य सूचकेन निश्चीयते — अतः न injectivity-आश्रयः ।)
  विभागः-∈ : (a N : ℕ) {qs : List ℕ} (p : ℕ) → p ∈ℕ qs
           → (z : समासः) → z ∈ map (p ∷_) (अपाकरणम् a N (suc p))
           → z ∈ विभागः a N qs
  विभागः-∈ a N p (hereℕ)              z z∈ = ∈-++ˡ z∈
  विभागः-∈ a N p (thereℕ {b} p∈qs)   z z∈ =
    ∈-++ʳ (map (b ∷_) (अपाकरणम् a N (suc b))) (विभागः-∈ a N p p∈qs z z∈)

  पूर्णता′ : (ys : समासः) → सुघटित ys → ys ∈ go (मानम् ys) (मानम् ys)
  पूर्णता′ .([])      ∅                    = here
  पूर्णता′ .(p ∷ ys) (_◂_ {p} {ys} p∈ps wf) =
    विभागः-∈ (p + मानम् ys) (suc (p + मानम् ys)) p p∈ps (p ∷ ys)
      (subst ((p ∷ ys) ∈_)
             (sym (cong (map (p ∷_)) (अपाकरण-मूल्य (p + मानम् ys) p (मानम् ys))))
             (∈-map
               (subst (ys ∈_)
                      (sym (canon (p + मानम् ys) (p + मानम् ys) (मानम् ys)
                                  (p , refl) (p , refl)))
                      (पूर्णता′ ys wf))))

  पूर्णता : (n : ℕ) (ys : समासः) → सुघटित ys → मानम् ys ≡ n → ys ∈ सर्गः n
  पूर्णता n ys wf pf = subst (λ k → ys ∈ go k k) pf (पूर्णता′ ys wf)

  ----------------------------------------------------------------------
  -- समास-आवृत्तिः — गणना अंश-गणे योगेन : a(n) = Σ_{p∈ps} (p-भागस्य गणना) ।
  -- एषा एव नारायणस्य समास-भावना — प्रति-अंशं शेषस्य गणनां योजयति ।
  -- (the count recurrence as a fold over the part-set — the essence of the
  --  samāsa-bhāvanā: sum, over each part, the count of the remainder.)
  ----------------------------------------------------------------------

  length-++ : (xs ys : List समासः)
            → length (xs ++ ys) ≡ length xs + length ys
  length-++ []       ys = refl
  length-++ (x ∷ xs) ys = cong suc (length-++ xs ys)

  योगः : List ℕ → ℕ
  योगः []       = zero
  योगः (x ∷ xs) = x + योगः xs

  विभागः-गणना : (f n : ℕ) (qs : List ℕ)
             → length (विभागः f n qs)
             ≡ योगः (map (λ p → length (अपाकरणम् f n (suc p))) qs)
  विभागः-गणना f n []       = refl
  विभागः-गणना f n (p ∷ qs) =
      length-++ (map (p ∷_) (अपाकरणम् f n (suc p))) (विभागः f n qs)
    ∙ cong₂ _+_ (length-map (p ∷_) (अपाकरणम् f n (suc p)))
                (विभागः-गणना f n qs)

  समास-आवृत्तिः : (n : ℕ)
              → length (सर्गः (suc n))
              ≡ योगः (map (λ p → length (अपाकरणम् n (suc n) (suc p))) ps)
  समास-आवृत्तिः n = विभागः-गणना n (suc n) ps

  ----------------------------------------------------------------------
  -- अंश-गणना — प्रति-अंश-भागस्य गणना = a(n − sₚ) (योग्ये) ; suc p ≤ suc n चेत्
  -- p-भागः a(n∸p) आनयति (इन्धन-अनपेक्षतया) ।  एवं आवृत्तिः शास्त्रीय-रूपम्
  -- a(n) = Σ_{p : sₚ≤n} a(n−sₚ) लभते ।
  ----------------------------------------------------------------------

  अंश-गणना : (n p : ℕ) → p ≤ n
           → length (अपाकरणम् n (suc n) (suc p)) ≡ length (सर्गः (n ∸ p))
  अंश-गणना n p p≤n =
      cong (λ t → length (अपाकरणम् n t (suc p))) (sym cancel)
    ∙ cong length (अपाकरण-मूल्य n p (n ∸ p))
    ∙ cong length (canon n n (n ∸ p) (∸-≤ n p) (∸-≤ n p))
    where
      cancel : suc p + (n ∸ p) ≡ suc n
      cancel = cong suc (शेष-रद्दनम् p n p≤n)

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

------------------------------------------------------------------------
-- द्वि-नयैक-तत्त्वम् — सामान्य-आवृत्तेः विशेषौ द्वौ नयौ (नयवादः) ।
--
-- समास-आवृत्तिः यथेच्छ-अंश-गणे योग-रूपा ; अत्र दर्शितम् : एक-अंश-गणं गृहीत्वा
-- सा शास्त्रीयं द्वि-पद-आवृत्तिं जनयति ।  {१,२}-नयात् (ps=[0,1]) विरहाङ्कस्य
-- मात्रा-मेरुः a(n+2)=a(n+1)+a(n) (Fibonacci) ; {१,३}-नयात् (ps=[0,2])
-- नारायणस्य गो-श्रेढी a(n+3)=a(n+2)+a(n) — Narayana.agda-मध्ये स्वतन्त्रं
-- साधिता, अत्र सामान्यायाः विशेषः ।  एका समास-भावना, नये-नये अन्यत् रूपम् —
-- नयवादः, न दुर्नयः : कोऽपि नयः अन्यं न निषेधति ।
--
-- (One samāsa-bhāvanā, two standpoints: the general fold recurrence, read at
-- the {1,2} part-set, IS Virahāṅka's Fibonacci recurrence; read at {1,3}, it
-- IS Nārāyaṇa's cow recurrence — the same law Narayana.agda proves on its own.
-- nayavāda: neither standpoint denies the other; each is the whole seen from
-- one part-set.)
------------------------------------------------------------------------

विरहाङ्क-आवृत्तिः : (n : ℕ)
  → length (सर्गः (0 ∷ 1 ∷ []) (suc (suc n)))
  ≡ length (सर्गः (0 ∷ 1 ∷ []) (suc n)) + length (सर्गः (0 ∷ 1 ∷ []) n)
विरहाङ्क-आवृत्तिः n =
    समास-आवृत्तिः (0 ∷ 1 ∷ []) (suc n)
  ∙ cong₂ _+_ (अंश-गणना (0 ∷ 1 ∷ []) (suc n) 0 zero-≤)
              ( cong (_+ 0) (अंश-गणना (0 ∷ 1 ∷ []) (suc n) 1 (suc-≤-suc zero-≤))
              ∙ +-zero (length (सर्गः (0 ∷ 1 ∷ []) n)) )

नारायण-आवृत्तिः : (n : ℕ)
  → length (सर्गः (0 ∷ 2 ∷ []) (suc (suc (suc n))))
  ≡ length (सर्गः (0 ∷ 2 ∷ []) (suc (suc n))) + length (सर्गः (0 ∷ 2 ∷ []) n)
नारायण-आवृत्तिः n =
    समास-आवृत्तिः (0 ∷ 2 ∷ []) (suc (suc n))
  ∙ cong₂ _+_ (अंश-गणना (0 ∷ 2 ∷ []) (suc (suc n)) 0 zero-≤)
              ( cong (_+ 0) (अंश-गणना (0 ∷ 2 ∷ []) (suc (suc n)) 2
                              (suc-≤-suc (suc-≤-suc zero-≤)))
              ∙ +-zero (length (सर्गः (0 ∷ 2 ∷ []) n)) )

------------------------------------------------------------------------
-- त्रिमेरु-आवृत्तिः — {१,२,३}-नयः (ps=[0,1,2]) : सामान्य-योगः त्रि-पदम् जनयति ।
--
-- द्वि-अंश-नयौ (विरहाङ्क, नारायण) स्थगित-द्वि-पदम् आवर्तनं दर्शयतः ; त्रि-अंश-
-- गणे तु योगः यथार्थतः त्रीणि पदानि रक्षति : a(n+3)=a(n+2)+a(n+1)+a(n)
-- (त्रि-सोपान-श्रेढी, "tribonacci") ।  एतत् एव यथेच्छ-अंश-गणस्य सारः — न
-- स्थगनम् अपि तु अंश-गण-परिमाणेन पद-सङ्ख्या ।  शीर्षे १,१,२,४,७,१३-दृष्टान्तः
-- refl-मात्रः आसीत् ; इयम् आवृत्तिः तस्य हेतुः ।
--
-- (The {1,2,3} standpoint: the general fold keeps THREE surviving terms,
-- a(n+3)=a(n+2)+a(n+1)+a(n) — a genuine tribonacci, not a shifted two-term.
-- This is the substance of an arbitrary part-set: the number of terms tracks
-- the size of the set, not merely a shift.  The header's 1,1,2,4,7,13 example
-- was a single refl; this is the recurrence behind it.)
------------------------------------------------------------------------

त्रिमेरु-आवृत्तिः : (n : ℕ)
  → length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) (suc (suc (suc n))))
  ≡ length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) (suc (suc n)))
  + ( length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) (suc n))
    + length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) n) )
त्रिमेरु-आवृत्तिः n =
    समास-आवृत्तिः (0 ∷ 1 ∷ 2 ∷ []) (suc (suc n))
  ∙ cong₂ _+_ (अंश-गणना (0 ∷ 1 ∷ 2 ∷ []) (suc (suc n)) 0 zero-≤)
      ( cong₂ _+_ (अंश-गणना (0 ∷ 1 ∷ 2 ∷ []) (suc (suc n)) 1 (suc-≤-suc zero-≤))
          ( cong (_+ 0) (अंश-गणना (0 ∷ 1 ∷ 2 ∷ []) (suc (suc n)) 2
                          (suc-≤-suc (suc-≤-suc zero-≤)))
          ∙ +-zero (length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) n)) ) )

------------------------------------------------------------------------
-- छिद्र-आवृत्तिः — {२,३}-नयः (ps=[1,2], अ-एकक-अंश-गणः) : a(n+3)=a(n+1)+a(n) ।
--
-- पूर्व-नयेषु (विरहाङ्क, नारायण, त्रिमेरु) एकः अंशः मानेन १ आसीत् — अतः प्रति n
-- साधनम् आसीत् ।  अत्र अंश-गणः {२,३} , एकक-रहितः , अतः श्रेढी छिद्रवती
-- (१,०,१,१,१,२,२,३,…) : n=1 इति मानाय न किमपि साधनम् (छिद्रम्) ।  सामान्य-योगः
-- तथापि आवर्तते : a(n) = a(n−2) + a(n−3) — २-अंशः a(n−2), ३-अंशः a(n−3) ।  एवं
-- समास-भावना अ-एकक-अंश-गणे अपि (यत्र श्रेढी शून्य-युक्ता) सम्यक् चलति ।
--
-- (The {2,3} standpoint: a part-set with NO size-1 part, so the sequence has
-- genuine gaps (1,0,1,1,1,2,2,3,…) — nothing of value 1.  The general fold still
-- gives the recurrence a(n)=a(n−2)+a(n−3): the size-2 part contributes a(n−2),
-- the size-3 part a(n−3).  The samāsa-bhāvanā works over a gapped, unit-free set
-- exactly as over the classical ones.)
------------------------------------------------------------------------

छिद्र-आवृत्तिः : (n : ℕ)
  → length (सर्गः (1 ∷ 2 ∷ []) (suc (suc (suc n))))
  ≡ length (सर्गः (1 ∷ 2 ∷ []) (suc n)) + length (सर्गः (1 ∷ 2 ∷ []) n)
छिद्र-आवृत्तिः n =
    समास-आवृत्तिः (1 ∷ 2 ∷ []) (suc (suc n))
  ∙ cong₂ _+_ (अंश-गणना (1 ∷ 2 ∷ []) (suc (suc n)) 1 (suc-≤-suc zero-≤))
              ( cong (_+ 0) (अंश-गणना (1 ∷ 2 ∷ []) (suc (suc n)) 2
                              (suc-≤-suc (suc-≤-suc zero-≤)))
              ∙ +-zero (length (सर्गः (1 ∷ 2 ∷ []) n)) )

------------------------------------------------------------------------
-- त्रि-योग-फलम् — {१,२,३}-त्रि-मेरोः धावद्-योगः : 2·∑_{k≤n} T(k) + 1 = T(n+2) + T(n) ।
--
-- द्वि-पद-नयेषु ({१,२},{१,३}) धावद्-योग-नियमः सरलः (∑+1 = a(n+L)) ; त्रि-पद-नये
-- (tribonacci, त्रि-आवृत्तिः a(n+3)=a(n+2)+a(n+1)+a(n)) रूपम् भिन्नम् : द्वि-गुणित-
-- योगः एकेन सह द्वयोः पदयोः योगः (T(n+2)+T(n)) — त्रि-पद-आवृत्तेः लक्षणम् ।  ऋण-रहितम् ।
--
-- (The running total of the {1,2,3} tribonacci counts: 2·∑_{k≤n} T(k) + 1 =
--  T(n+2)+T(n).  Where the two-part nayas give the simple ∑+1 = a(n+L), the
--  three-term recurrence gives this doubled form — a genuinely different shape,
--  proved from त्रिमेरु-आवृत्तिः, subtraction-free.)
------------------------------------------------------------------------

private
  T : ℕ → ℕ
  T k = length (सर्गः (0 ∷ 1 ∷ 2 ∷ []) k)

त्रि-योग : ℕ → ℕ
त्रि-योग zero    = T zero
त्रि-योग (suc n) = त्रि-योग n + T (suc n)

त्रि-योग-फलम् : (n : ℕ) → (त्रि-योग n + त्रि-योग n) + 1 ≡ T (suc (suc n)) + T n
त्रि-योग-फलम् zero    = refl
त्रि-योग-फलम् (suc n) =
    -- ((S+u)+(S+u)) + 1  ≡  (S+S)+(u+u) + 1
    cong (_+ 1) मध्य
    -- ((S+S)+(u+u)) + 1  ≡  ((S+S)+1) + (u+u)
  ∙ ( sym (+-assoc (S + S) (u + u) 1)
    ∙ cong ((S + S) +_) (+-comm (u + u) 1)
    ∙ +-assoc (S + S) 1 (u + u) )
    -- ((S+S)+1) + (u+u)  ≡  (T(n+2)+T(n)) + (u+u)
  ∙ cong (_+ (u + u)) (त्रि-योग-फलम् n)
    -- (A+B)+(C+C)  ≡  T(n+3) + T(n+1)
  ∙ folded
  where
    S = त्रि-योग n
    u = T (suc n)
    A = T (suc (suc n))
    B = T n
    C = T (suc n)
    मध्य : (S + u) + (S + u) ≡ (S + S) + (u + u)
    मध्य = sym (+-assoc S u (S + u))
         ∙ cong (S +_) (+-assoc u S u)
         ∙ cong (S +_) (cong (_+ u) (+-comm u S))
         ∙ cong (S +_) (sym (+-assoc S u u))
         ∙ +-assoc S S (u + u)
    folded : (A + B) + (C + C) ≡ T (suc (suc (suc n))) + T (suc n)
    folded = sym (+-assoc A B (C + C))
           ∙ cong (A +_) (+-assoc B C C)
           ∙ cong (A +_) (cong (_+ C) (+-comm B C))
           ∙ +-assoc A (C + B) C
           ∙ cong (_+ C) (sym (त्रिमेरु-आवृत्तिः n))

-- उदाहरणम् — 1+1+2+4 = 8 ; 2·8+1 = 17 = T(5)+T(3) = 13+4 (refl-सिद्धम्) ।
त्रि-योग-३ : त्रि-योग 3 ≡ 8
त्रि-योग-३ = refl
