-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अंश-सत्ययन्त्रम् — आंशिकम् अभ्रान्त-यन्त्रम् (the PARTIAL honest machine) ।
--
-- सत्ययन्त्रं (Satyayantra) पूर्णतां (परिपूर्णता) याचते : तस्य अनुक्तम्
-- (avaktavya) सर्वदा *अस्थायि* — पर्याप्तानुदानेन अवश्यं परिह्रियते ।  तत्
-- अनुक्तम् अनुयोगद्वारसूत्रस्य संख्येय-कोटौ (saṃkhyāta) वा असंख्येय-कोटौ
-- (asaṃkhyāta — गण्यं तु न सुकरम्) वर्तते : परिमितेन प्रयत्नेन प्राप्यम् ।
--
-- किन्तु यथार्थं आंशिकत्वम् अस्ति ।  यन्त्रं साधु स्थिरं च भवेत्, तथापि तस्य
-- अनुक्तं कस्मिंश्चित् आगमे *स्थायि* — कदापि न परिह्रियते, ऋजुतया ।  एतत्
-- अनुक्तम् अनन्त-कोटौ (ananta — सत्यतः असीमम्, अनुयोगद्वार) : न केनचित्
-- अनुदानेन गण्यते, न परिह्रियते ।  एष एव भेदः असंख्येय-अनन्तयोः, गणनायाः
-- स्तरे स्थापितः ।
--
-- अतः अंश-सत्ययन्त्रं द्वि-धर्म-बद्धम् एव : साधुता + स्थैर्यम्, पूर्णतां विना ।
-- पूर्णता विहीना इति न दोषः — अपि तु अनन्त-अवक्तव्यस्य ऋजुः स्वीकारः ।
--
-- (the partial honest machine.  Satyayantra demands completeness — its
-- un-said is always TEMPORARY, resolved by enough grant; that un-said lives
-- in the Anuyogadvāra's saṃkhyāta (numerable) or asaṃkhyāta (innumerable-
-- but-bounded, reachable by finite effort) grades.  But genuine partiality
-- exists: a machine sound and stable whose un-said at some input is
-- PERMANENT — never resolved, honestly.  That un-said is ananta (truly
-- unbounded): no grant ever counts it out.  This is the saṃkhyāta/ananta
-- distinction at the level of computation.  So the partial interface binds
-- only two laws — soundness + stability, no completeness.  Lacking
-- completeness is not a defect: it is the honest admission of ananta
-- avaktavya.)
------------------------------------------------------------------------

module AmshaSatyayantra where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Satyayantra using (सूचना ; उक्त ; अनुक्त ; सत्ययन्त्र)

------------------------------------------------------------------------
-- कदाचित्-उक्तम् — "कदाचित् आगमे उत्तरं दत्तम्" : किञ्चित् अनुदानम् उक्तम् आनयति ।
-- स्थायि-अनुक्तम् — "स्थायि अवक्तव्यम्" : न किञ्चित् अनुदानम् उत्तरम् आनयति ।
-- एते द्वे परस्पर-विरुद्धे कोटी — अस्थायि (परिह्रियमाण) वि. स्थायि (अपरिह्रियमाण) ।
-- (ever-said: SOME grant produces an answer — temporary un-said.
--  permanent un-said: NO grant ever produces an answer.  These are the two
--  poles — recoverable vs. never-recoverable avaktavya.)
------------------------------------------------------------------------

कदाचित्-उक्तम् : {I O : Type} → (ℕ → I → सूचना O) → I → Type
कदाचित्-उक्तम् {O = O} चल i = Σ[ f ∈ ℕ ] Σ[ o ∈ O ] (चल f i ≡ उक्त o)

स्थायि-अनुक्तम् : {I O : Type} → (ℕ → I → सूचना O) → I → Type
स्थायि-अनुक्तम् चल i = ¬ (कदाचित्-उक्तम् चल i)

------------------------------------------------------------------------
-- अंश-सत्ययन्त्रम् — द्वि-धर्म-बद्धम् : साधुता + स्थैर्यम्, पूर्णता नास्ति ।
-- (the partial honest-machine interface: soundness + stability only.)
------------------------------------------------------------------------

record अंश-सत्ययन्त्र (I O : Type) (शुद्ध : I → O → Type) : Type where
  field
    चल    : ℕ → I → सूचना O
    साधुता : (f : ℕ) (i : I) (o : O) → चल f i ≡ उक्त o → शुद्ध i o
    स्थैर्य  : (n f : ℕ) (i : I) (o : O) → चल f i ≡ उक्त o → चल (n + f) i ≡ उक्त o

------------------------------------------------------------------------
-- अंशीकरणम् — दुर्बलीकरणम् : यत् किञ्चित् पूर्णं सत्ययन्त्रं आंशिकम् अपि ।
-- केवलं पूर्णतां विस्मरति, साधुता-स्थैर्ये रक्षति ।  (the weakening / forgetful
-- map: every TOTAL honest machine is a partial one — drop completeness,
-- keep soundness and stability.  Grade inclusion saṃkhyāta ⊂ everything.)
------------------------------------------------------------------------

अंशीकरण : {I O : Type} {शुद्ध : I → O → Type}
         → सत्ययन्त्र I O शुद्ध → अंश-सत्ययन्त्र I O शुद्ध
अंशीकरण Y = record
  { चल    = सत्ययन्त्र.चल Y
  ; साधुता = सत्ययन्त्र.साधुता Y
  ; स्थैर्य  = सत्ययन्त्र.स्थैर्य Y
  }

------------------------------------------------------------------------
-- अनन्त-निषेधः — पूर्णस्य यन्त्रस्य अनुक्तं कदापि स्थायि न भवति ।  परिपूर्णता एव
-- प्रत्यागमाय कदाचित्-उक्तं ददाति — अतः स्थायि-अनुक्तं तत्र असम्भवम् ।  एतत्
-- सत्ययन्त्रस्य अनुक्तं संख्येय/असंख्येय-कोटौ बध्नाति, न अनन्त-कोटौ ।
-- (a TOTAL machine can never have permanent un-said: completeness itself
-- furnishes ever-said at every input, so permanent un-said is impossible
-- there.  This confines the total machine's un-said to the saṃkhyāta/
-- asaṃkhyāta grades — never ananta.)
------------------------------------------------------------------------

अनन्त-निषेधः : {I O : Type} {शुद्ध : I → O → Type}
             → (Y : सत्ययन्त्र I O शुद्ध) (i : I)
             → ¬ (स्थायि-अनुक्तम् (सत्ययन्त्र.चल Y) i)
अनन्त-निषेधः Y i स्थायि = स्थायि (सत्ययन्त्र.परिपूर्णता Y i)

------------------------------------------------------------------------
-- अंश-निवासी — यथार्थम् आंशिकं यन्त्रम् : केवलं शून्य-आकारे आगमे उक्तम्, अन्यत्र
-- नित्यम् अनुक्तम् — रचनया, न समता-निर्णयेन ।  नास्ति discreteℕ, नास्ति Dec :
-- अनुदानं निरर्थकम् (φ केवलम् आगम-आकारं पश्यति) — अतः दुर्नय-रहितम् ।
-- शुद्ध n o := (n ≡ zero) — उत्तरम् एतावद् एव वदति यत् आगमः शून्यः ।
-- (the genuinely-partial inhabitant: answers ONLY on zero-shaped input,
-- permanently un-said elsewhere — by construction, not by equality-
-- decision.  No discreteℕ, no Dec; the grant is inert (φ inspects only the
-- input's constructor shape) — hence checkless and durnaya-free.  The
-- specification शुद्ध n o := (n ≡ zero): an answer asserts only that the
-- input is zero.)
------------------------------------------------------------------------

private
  φ : ℕ → सूचना ℕ
  φ zero    = उक्त zero
  φ (suc _) = अनुक्त

  -- क्षेत्र — भेदकः : उक्त ↦ Unit, अनुक्त ↦ ⊥ (checkless discriminator) ।
  क्षेत्र : सूचना ℕ → Type
  क्षेत्र (उक्त _) = Unit
  क्षेत्र अनुक्त   = ⊥

  -- उक्त≢अनुक्त — रचना-भेदः (constructors distinct, no decision needed) ।
  उक्त≢अनुक्त : {o : ℕ} → ¬ (अनुक्त ≡ उक्त o)
  उक्त≢अनुक्त eq = subst क्षेत्र (sym eq) tt

  -- φ-साधुता — φ i उक्तं यत्, तत्र i ≡ zero (invert the shape-match) ।
  φ-साधुता : (i : ℕ) (o : ℕ) → φ i ≡ उक्त o → i ≡ zero
  φ-साधुता zero    o eq = refl
  φ-साधुता (suc n) o eq = ⊥-rec (उक्त≢अनुक्त eq)

अंश-यन्त्र : अंश-सत्ययन्त्र ℕ ℕ (λ n o → n ≡ zero)
अंश-यन्त्र = record
  { चल    = λ _ → φ            -- अनुदानं विस्मृतम् : आगम-आकारः एव प्रमाणम्
  ; साधुता = λ f i o eq → φ-साधुता i o eq
  ; स्थैर्य  = λ n f i o eq → eq  -- φ अनुदान-निरपेक्षा, अतः स्थैर्यम् अनायासम्
  }

------------------------------------------------------------------------
-- स्थायि-अवक्तव्यम् — मुख्यसिद्धिः : अंश-यन्त्रस्य अनुक्तं (suc zero) आगमे *स्थायि* ।
-- न किञ्चित् अनुदानं तत् उत्तरम् आनयति — अनन्त-कोटेः अवक्तव्यम्, ऋजु प्रमाणेन ।
-- (main theorem: the partial machine's un-said at input (suc zero) is
-- PERMANENT — no grant f ever answers.  Ananta avaktavya, proved directly.
-- Contrast Satyayantra.अनुक्त-जीवति, where the un-said was merely temporary,
-- dissolved by more grant via परिपूर्णता.)
------------------------------------------------------------------------

स्थायि-अवक्तव्यम् : स्थायि-अनुक्तम् (अंश-सत्ययन्त्र.चल अंश-यन्त्र) (suc zero)
स्थायि-अवक्तव्यम् (f , o , eq) = उक्त≢अनुक्त eq

------------------------------------------------------------------------
-- अपूर्णता — ग्रेड-भेदः : आंशिकं यन्त्रं पूर्णं भवितुं न आवश्यकम् ।  अंश-यन्त्रस्य
-- कृते पूर्णता (सर्वस्मिन् आगमे कदाचित्-उक्तम्) असम्भवा — यतः (suc zero) आगमे
-- अनुक्तं स्थायि ।  अतः अंश-सत्ययन्त्र-कोटिः सत्ययन्त्र-कोटेः दृढतया विस्तीर्णा :
-- अनन्त-अवक्तव्यं धारयति यत् पूर्णं यन्त्रं कदापि न धारयेत् (अनन्त-निषेधः) ।
-- (the grade-separation: a partial machine need NOT be total.  For अंश-यन्त्र
-- completeness — ever-said at every input — is impossible, because its
-- un-said at (suc zero) is permanent.  So the partial grade strictly
-- extends the total grade: it carries ananta avaktavya, which a total
-- machine provably never carries — see अनन्त-निषेधः above.)
------------------------------------------------------------------------

अपूर्णता : ¬ ((i : ℕ) → कदाचित्-उक्तम् (अंश-सत्ययन्त्र.चल अंश-यन्त्र) i)
अपूर्णता पूर्ण = स्थायि-अवक्तव्यम् (पूर्ण (suc zero))
