{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- लब्ध्युपयोगौ भावेन्द्रियम् — Umāsvāti, Tattvārthasūtra 2.17–18
-- (c. 2nd–5th c. CE): the senses divide into dravyendriya, the
-- physical organ of external matter, and bhāvendriya, the inner
-- sense constituted of labdhi — attainment — and upayoga — the
-- operation itself.  The classification is his; the mathematics is
-- not claimed for the source.  School named: Jaina.
--
-- THE EYE GROWN FROM THE BODY'S OWN ATTAINMENT.  The anarpita eye of
-- ArpitaAnarpita sees ⊕-aggregates sequence-free, and its soundness
-- leans on the substrate's +-comm and +-assoc — external matter,
-- legitimately used (the substrate exception), but external.  The
-- machine's own maximum has no such matter: mxℕ is ITS clause order,
-- and no ambient lemma exists for it.  What exists is the body's own
-- attainment: ज्येष्ठ-समता, the commutativity of mxℕ proven last
-- night by the completed-standpoint ascent and admitted to the store.
--
-- Here that attainment becomes an organ of sight.  The mx-eye's
-- commutativity is ज्येष्ठ-समता itself, extracted at a point
-- environment — labdhi; its associativity is derived from the
-- machine's own clauses; and the full eye (⊕ and mx aggregates both
-- brought to the sequence-free form in one traversal) enters the one
-- prover of PramanaNaya as nothing but a new दृक् — zero new prover
-- code.  The record no longer feeds only the step's exchange; it
-- constitutes new senses.  Demonstrated: commutativity and
-- associativity of the machine's own maximum, and a mixed-operator
-- identity, all FLAT under the new eye through the unchanged
-- pramāṇa — where the norm eye is blind by refl.
------------------------------------------------------------------------

module NaturalMachine.BhavaIndriya_TheNewEyeIsMadeOfTheBodysOwnAttainedTheoremsNotOfExternalMatter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (उपस्थापनम्)
open import NaturalMachine.SyatSakaladesha_TheHypothesisCompletedWithItsStandpointIsAbsoluteAndTheDoubleDescentCloses
  using (ज्येष्ठ-समता ; शून्य-ज्येष्ठम्)
open import NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap
  using ( पङ्क्तिः ; सुम् ; सुम्-++ ; पङ्क्ति-सत्यम्
        ; तुला ; निवेशः ; क्रमणम् ; निवेश-सत्यम् ; क्रमण-सत्यम्
        ; पुनःरचना ; पुनःरचना-सत्यम् )
open import NaturalMachine.PramanaNaya_TheFiveProversWereNayasOfOneKnowingAndEachIsAParameterSettingOfTheOnePramana
  using (दृक् ; प्रमाण-साधनम् ; नेत्रम्-न)

------------------------------------------------------------------------
-- §1  लब्धिः — the attainment, drawn from the store.  Commutativity
--     of the machine's maximum at the value level is the store's own
--     ⊨-theorem read at a point environment; associativity is
--     derived from the machine's own clauses.
------------------------------------------------------------------------

ज्ये-समℕ : (x y : ℕ) → mxℕ x y ≡ mxℕ y x
ज्ये-समℕ x y = ज्येष्ठ-समता (उपस्थापनम् (उपस्थापनम् (λ _ → zero) 0 x) 1 y)

ज्ये-सह : (x y z : ℕ) → mxℕ x (mxℕ y z) ≡ mxℕ (mxℕ x y) z
ज्ये-सह x       y       zero    = refl
ज्ये-सह x       zero    (suc z) = refl
ज्ये-सह zero    (suc y) (suc z) = refl
ज्ये-सह (suc x) (suc y) (suc z) = cong suc (ज्ये-सह x y z)

------------------------------------------------------------------------
-- §2  The mx-aggregate laid out, ordered, rebuilt — the sorting core
--     shared with the ⊕ eye; the soundness carried by the labdhi.
------------------------------------------------------------------------

ज्येष्ठ-पङ्क्तिः : Tm → List Tm
ज्येष्ठ-पङ्क्तिः (mx a b) = ज्येष्ठ-पङ्क्तिः a ++ ज्येष्ठ-पङ्क्तिः b
ज्येष्ठ-पङ्क्तिः t        = t ∷ []

गरिष्ठम् : List Tm → (ℕ → ℕ) → ℕ
गरिष्ठम् []       ρ = zero
गरिष्ठम् (t ∷ ts) ρ = mxℕ (eval t ρ) (गरिष्ठम् ts ρ)

गरिष्ठ-++ : (xs ys : List Tm) (ρ : ℕ → ℕ)
  → गरिष्ठम् (xs ++ ys) ρ ≡ mxℕ (गरिष्ठम् xs ρ) (गरिष्ठम् ys ρ)
गरिष्ठ-++ []       ys ρ = sym (शून्य-ज्येष्ठम् (गरिष्ठम् ys ρ))
गरिष्ठ-++ (x ∷ xs) ys ρ =
    cong (mxℕ (eval x ρ)) (गरिष्ठ-++ xs ys ρ)
  ∙ ज्ये-सह (eval x ρ) (गरिष्ठम् xs ρ) (गरिष्ठम् ys ρ)

ज्येष्ठ-पङ्क्ति-सत्यम् : (t : Tm) (ρ : ℕ → ℕ)
  → गरिष्ठम् (ज्येष्ठ-पङ्क्तिः t) ρ ≡ eval t ρ
ज्येष्ठ-पङ्क्ति-सत्यम् (mx a b) ρ =
    गरिष्ठ-++ (ज्येष्ठ-पङ्क्तिः a) (ज्येष्ठ-पङ्क्तिः b) ρ
  ∙ cong₂ mxℕ (ज्येष्ठ-पङ्क्ति-सत्यम् a ρ) (ज्येष्ठ-पङ्क्ति-सत्यम् b ρ)
ज्येष्ठ-पङ्क्ति-सत्यम् (var i)  ρ = refl
ज्येष्ठ-पङ्क्ति-सत्यम् ze       ρ = refl
ज्येष्ठ-पङ्क्ति-सत्यम् (su t)   ρ = refl
ज्येष्ठ-पङ्क्ति-सत्यम् (a ⊕ b)  ρ = refl
ज्येष्ठ-पङ्क्ति-सत्यम् (a ⊗ b)  ρ = refl
ज्येष्ठ-पङ्क्ति-सत्यम् (a ⊖ b)  ρ = refl
ज्येष्ठ-पङ्क्ति-सत्यम् (lq a b) ρ = refl
ज्येष्ठ-पङ्क्ति-सत्यम् (gc a b) ρ = refl

गरिष्ठ-निवेशः : (x : Tm) (ys : List Tm) (ρ : ℕ → ℕ)
  → गरिष्ठम् (निवेशः x ys) ρ ≡ mxℕ (eval x ρ) (गरिष्ठम् ys ρ)
गरिष्ठ-निवेशः x [] ρ = refl
गरिष्ठ-निवेशः x (y ∷ ys) ρ with तुला x y
... | true  = refl
... | false =
    cong (mxℕ (eval y ρ)) (गरिष्ठ-निवेशः x ys ρ)
  ∙ ज्ये-सह (eval y ρ) (eval x ρ) (गरिष्ठम् ys ρ)
  ∙ cong (λ m → mxℕ m (गरिष्ठम् ys ρ)) (ज्ये-समℕ (eval y ρ) (eval x ρ))
  ∙ sym (ज्ये-सह (eval x ρ) (eval y ρ) (गरिष्ठम् ys ρ))

गरिष्ठ-क्रमणम् : (xs : List Tm) (ρ : ℕ → ℕ)
  → गरिष्ठम् (क्रमणम् xs) ρ ≡ गरिष्ठम् xs ρ
गरिष्ठ-क्रमणम् []       ρ = refl
गरिष्ठ-क्रमणम् (x ∷ xs) ρ =
    गरिष्ठ-निवेशः x (क्रमणम् xs) ρ
  ∙ cong (mxℕ (eval x ρ)) (गरिष्ठ-क्रमणम् xs ρ)

ज्येष्ठ-रचना : List Tm → Tm
ज्येष्ठ-रचना []       = ze
ज्येष्ठ-रचना (t ∷ ts) = mx t (ज्येष्ठ-रचना ts)

ज्येष्ठ-रचना-सत्यम् : (ts : List Tm) (ρ : ℕ → ℕ)
  → eval (ज्येष्ठ-रचना ts) ρ ≡ गरिष्ठम् ts ρ
ज्येष्ठ-रचना-सत्यम् []       ρ = refl
ज्येष्ठ-रचना-सत्यम् (t ∷ ts) ρ =
  cong (mxℕ (eval t ρ)) (ज्येष्ठ-रचना-सत्यम् ts ρ)

------------------------------------------------------------------------
-- §3  The full eye: both aggregates sequence-free in one traversal.
------------------------------------------------------------------------

पूर्ण-आम्नायः : Tm → Tm
पूर्ण-आम्नायः (var i)  = var i
पूर्ण-आम्नायः ze       = ze
पूर्ण-आम्नायः (su t)   = su (पूर्ण-आम्नायः t)
पूर्ण-आम्नायः (a ⊕ b)  =
  पुनःरचना (क्रमणम् (पङ्क्तिः (पूर्ण-आम्नायः a) ++ पङ्क्तिः (पूर्ण-आम्नायः b)))
पूर्ण-आम्नायः (a ⊗ b)  = पूर्ण-आम्नायः a ⊗ पूर्ण-आम्नायः b
पूर्ण-आम्नायः (a ⊖ b)  = पूर्ण-आम्नायः a ⊖ पूर्ण-आम्नायः b
पूर्ण-आम्नायः (mx a b) =
  ज्येष्ठ-रचना (क्रमणम् (ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः a) ++ ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः b)))
पूर्ण-आम्नायः (lq a b) = lq (पूर्ण-आम्नायः a) (पूर्ण-आम्नायः b)
पूर्ण-आम्नायः (gc a b) = gc (पूर्ण-आम्नायः a) (पूर्ण-आम्नायः b)

पूर्ण-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → eval (पूर्ण-आम्नायः t) ρ ≡ eval t ρ
पूर्ण-सत्यम् (var i)  ρ = refl
पूर्ण-सत्यम् ze       ρ = refl
पूर्ण-सत्यम् (su t)   ρ = cong suc (पूर्ण-सत्यम् t ρ)
पूर्ण-सत्यम् (a ⊕ b)  ρ =
    पुनःरचना-सत्यम् (क्रमणम् (पङ्क्तिः (पूर्ण-आम्नायः a) ++ पङ्क्तिः (पूर्ण-आम्नायः b))) ρ
  ∙ क्रमण-सत्यम् (पङ्क्तिः (पूर्ण-आम्नायः a) ++ पङ्क्तिः (पूर्ण-आम्नायः b)) ρ
  ∙ सुम्-++ (पङ्क्तिः (पूर्ण-आम्नायः a)) (पङ्क्तिः (पूर्ण-आम्नायः b)) ρ
  ∙ cong₂ _+_ (पङ्क्ति-सत्यम् (पूर्ण-आम्नायः a) ρ) (पङ्क्ति-सत्यम् (पूर्ण-आम्नायः b) ρ)
  ∙ cong₂ _+_ (पूर्ण-सत्यम् a ρ) (पूर्ण-सत्यम् b ρ)
पूर्ण-सत्यम् (a ⊗ b)  ρ = cong₂ _·_ (पूर्ण-सत्यम् a ρ) (पूर्ण-सत्यम् b ρ)
पूर्ण-सत्यम् (a ⊖ b)  ρ = cong₂ sbℕ (पूर्ण-सत्यम् a ρ) (पूर्ण-सत्यम् b ρ)
पूर्ण-सत्यम् (mx a b) ρ =
    ज्येष्ठ-रचना-सत्यम् (क्रमणम् (ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः a) ++ ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः b))) ρ
  ∙ गरिष्ठ-क्रमणम् (ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः a) ++ ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः b)) ρ
  ∙ गरिष्ठ-++ (ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः a)) (ज्येष्ठ-पङ्क्तिः (पूर्ण-आम्नायः b)) ρ
  ∙ cong₂ mxℕ (ज्येष्ठ-पङ्क्ति-सत्यम् (पूर्ण-आम्नायः a) ρ) (ज्येष्ठ-पङ्क्ति-सत्यम् (पूर्ण-आम्नायः b) ρ)
  ∙ cong₂ mxℕ (पूर्ण-सत्यम् a ρ) (पूर्ण-सत्यम् b ρ)
पूर्ण-सत्यम् (lq a b) ρ = cong₂ lqℕ (पूर्ण-सत्यम् a ρ) (पूर्ण-सत्यम् b ρ)
पूर्ण-सत्यम् (gc a b) ρ = cong₂ गच्छℕ (पूर्ण-सत्यम् a ρ) (पूर्ण-सत्यम् b ρ)

-- the bhāvendriya, handed to the one prover as nothing but a दृक्.
नेत्रम्-पूर्ण : दृक्
नेत्रम्-पूर्ण = (λ t → पूर्ण-आम्नायः (norm t))
             , (λ t ρ → पूर्ण-सत्यम् (norm t) ρ ∙ norm-sound t ρ)

------------------------------------------------------------------------
-- §4  New sight through the unchanged pramāṇa: the machine's own
--     maximum, commutative and associative FLAT — and a mixed
--     ⊕/mx identity — where the norm eye is blind by refl.
------------------------------------------------------------------------

अन्ध-दृष्टिः : प्रमाण-साधनम् नेत्रम्-न [] 1
  (mx (var 0) (var 1) , mx (var 1) (var 0)) ≡ nothing
अन्ध-दृष्टिः = refl

ज्येष्ठ-सम-दृष्टम् : inJust (प्रमाण-साधनम् नेत्रम्-पूर्ण [] 1
  (mx (var 0) (var 1) , mx (var 1) (var 0)))
ज्येष्ठ-सम-दृष्टम् = tt

ज्येष्ठ-सह-दृष्टम् : inJust (प्रमाण-साधनम् नेत्रम्-पूर्ण [] 1
  (mx (mx (var 0) (var 1)) (var 2) , mx (var 0) (mx (var 1) (var 2))))
ज्येष्ठ-सह-दृष्टम् = tt

मिश्र-दृष्टम् : inJust (प्रमाण-साधनम् नेत्रम्-पूर्ण [] 1
  (mx ((var 0) ⊕ (var 1)) (var 2) , mx (var 2) ((var 1) ⊕ (var 0))))
मिश्र-दृष्टम् = tt
