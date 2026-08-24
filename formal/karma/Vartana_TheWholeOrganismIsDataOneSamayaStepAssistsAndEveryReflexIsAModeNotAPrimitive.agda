{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्तना — the first mark of time.  Umāsvāti, *Tattvārthasūtra* 5.38–39
-- (c. 2nd–5th c. CE): गुणपर्ययवद् द्रव्यम् — substance is what possesses
-- qualities and MODES — and वर्तनापरिणामक्रियाः परत्वापरत्वे च कालस्य —
-- time's marks are vartanā (the assisting of each substance's
-- SELF-modification), pariṇāma, kriyā, and PARATVA-APARATVA — the
-- before and the after.  Kāla does not push and kāla does not ask:
-- each substance modifies itself, time assists the occurrence and
-- ORDERS it.  Kāla is atomic (kālāṇu, Nemicandra, *Dravyasaṃgraha*
-- v.22, 10th c.).  School: Jaina.  Claimed of the sources: the
-- doctrine's shape, which IS this architecture, and nothing else.
--
-- THIRD CORRECTION (owner, 2026-08-24): accept NO division.  The
-- previous form still split questions into two species
-- (discrimination and reduction) and organs into two fields (innate
-- and generated).  Both dissolve:
--
--   * ONE POOL: the body's own subterms AND their organ-images, all
--     first-class citizens of the same pool;
--   * ONE QUESTION-RULE (nayavāda, whole): a pair of pool-terms is a
--     question exactly when the sameness-standpoints disagree on it —
--     the probes (the concrete-instance naya) see one where some
--     organ still sees two.  The former "reduction questions" are not
--     a species: (t, its organ-image) is simply a pool-pair the
--     standpoints quarrel over;
--   * KĀLA DOES NOT POSE — IT ORIENTS (paratva-aparatva): every
--     posed pair is written from the posterior to the prior — the
--     clock-expensive side rewrites toward the clock-cheap side — so
--     the record's grain is time's own ordering, not a rule-species;
--   * ONE ORGAN FIELD: अङ्ग-जनकः, organs as a function of the record,
--     always; the innate organs are its constant part.  Organs beget
--     organs because the function reads the grown record — nothing
--     stored, nothing stale, nothing enumerated.
--
-- One substance, one step.  Vyaya: the known is not re-posed.
------------------------------------------------------------------------

module Vartana_TheWholeOrganismIsDataOneSamayaStepAssistsAndEveryReflexIsAModeNotAPrimitive where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (_,_ ; fst ; snd)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using ( Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; gc
        ; Eq' ; eval ; समः ; समℕ ; _∧_ )
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using ( नियमः ; niyama ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; इन्धनम्
        ; _++_ ; _×_ ; if_then_else_ ; _≤?_ ; दृक् ; नेत्रम्-न ; गूढ-दृक् )
open import Gunasthana_TheBodyClimbsByItsOwnAttainmentTheEyeIsAFunctionOfTheRecordAndNoAgentPicksOrgans
  using (अनुलोम-श्रुतम् ; कर्तृ-जननम् ; सर्व-कर्तारः ; कर्ता ; दृक्-योगः)
open import KalaDravya_TimeIsASubstanceInTheSameTongueAndTheMachineProvesCostAsItProvesTruth
  using (कालम् ; लाघव-दृक्)

------------------------------------------------------------------------
-- §1  The substance: what it has proven, what stands open, and how its
--     organs arise from what it has proven.  Three fields.  No more.
------------------------------------------------------------------------

record शरीरम् : Type where
  constructor sharira
  field
    श्रुतम्     : List नियमः
    लक्ष्याः    : List Eq'
    अङ्ग-जनकः  : List नियमः → List दृक्

open शरीरम् public

------------------------------------------------------------------------
-- §2  The standpoints.  The probes are the concrete-instance naya;
--     each organ is a naya; kāla is not a naya — it orders.
------------------------------------------------------------------------

private
  π₁ π₂ π₃ : Nat → Nat
  π₁ zero = 2 ; π₁ (suc zero) = 5 ; π₁ _ = 1
  π₂ zero = 7 ; π₂ (suc zero) = 3 ; π₂ _ = 0
  π₃ zero = 1 ; π₃ (suc zero) = 4 ; π₃ _ = 2

  अङ्कः : Type
  अङ्कः = Nat × (Nat × Nat)

  अङ्कनम् : Tm → अङ्कः
  अङ्कनम् t = eval t π₁ , (eval t π₂ , eval t π₃)

  सम-अङ्कौ : अङ्कः → अङ्कः → Bool
  सम-अङ्कौ (a , (b , c)) (x , (y , z)) = समℕ a x ∧ (समℕ b y ∧ समℕ c z)

  घटिका : Tm → Nat
  घटिका t = कालम् t π₁ + (कालम् t π₂ + कालम् t π₃)

------------------------------------------------------------------------
-- §3  The pool: subterms and their organ-images, each carried with its
--     probe-mark and its images, computed once.
------------------------------------------------------------------------

private
  एककम् : Type
  एककम् = Tm × (अङ्कः × List Tm)      -- the term, its mark, its images

  प्रतिमाः : List दृक् → Tm → List Tm
  प्रतिमाः []       t = []
  प्रतिमाः (E ∷ Es) t = fst E t ∷ प्रतिमाः Es t

  एककृ : List दृक् → Tm → एककम्
  एककृ Es t = t , (अङ्कनम् t , प्रतिमाः Es t)

  अवयवाः : Tm → List Tm
  अवयवाः t = t ∷ शाखाः t
    where
    शाखाः : Tm → List Tm
    शाखाः (su a)   = अवयवाः a
    शाखाः (a ⊕ b)  = अवयवाः a ++ अवयवाः b
    शाखाः (a ⊗ b)  = अवयवाः a ++ अवयवाः b
    शाखाः (a ⊖ b)  = अवयवाः a ++ अवयवाः b
    शाखाः (mx a b) = अवयवाः a ++ अवयवाः b
    शाखाः (lq a b) = अवयवाः a ++ अवयवाः b
    शाखाः (gc a b) = अवयवाः a ++ अवयवाः b
    शाखाः _        = []

  सर्व-अवयवाः : List नियमः → List Tm
  सर्व-अवयवाः []       = []
  सर्व-अवयवाः (s ∷ ss) =
    अवयवाः (नियमः.lhs s) ++ (अवयवाः (नियमः.rhs s) ++ सर्व-अवयवाः ss)

  -- the pool: subterms and (one level of) their images, all first-class
  पूलः : List दृक् → List नियमः → List एककम्
  पूलः Es Γ = चिह्नय (मूलाः ++ छायाः मूलाः)
    where
    मूलाः : List Tm
    मूलाः = सर्व-अवयवाः Γ

    छायाः : List Tm → List Tm
    छायाः []       = []
    छायाः (t ∷ ts) = प्रतिमाः Es t ++ छायाः ts

    चिह्नय : List Tm → List एककम्
    चिह्नय []       = []
    चिह्नय (t ∷ ts) = एककृ Es t ∷ चिह्नय ts

------------------------------------------------------------------------
-- §4  The questions: mark-buckets first (probes disagreeing settles a
--     pair, so only same-mark pairs can be questions), then the one
--     rule — some organ still sees two — and kāla orients the pair.
------------------------------------------------------------------------

private
  -- do all organs see the pair as one?  (their images match up)
  सर्व-सम-दर्शनम् : List Tm → List Tm → Bool
  सर्व-सम-दर्शनम् []       []       = true
  सर्व-सम-दर्शनम् (i ∷ is) (j ∷ js) with समः i j
  ... | true  = सर्व-सम-दर्शनम् is js
  ... | false = false
  सर्व-सम-दर्शनम् _        _        = false

  -- kāla orients: posterior (costly) rewrites toward prior (cheap)
  क्रमय : Tm → Tm → Eq'
  क्रमय s t = if घटिका t ≤? घटिका s then (s , t) else (t , s)

  प्रश्नः : एककम् → एककम् → Maybe Eq'
  प्रश्नः (s , (ms , is)) (t , (mt , it)) with सम-अङ्कौ ms mt
  ... | false = nothing
  ... | true with समः s t
  ...   | true  = nothing
  ...   | false = if सर्व-सम-दर्शनम् is it then nothing else just (क्रमय s t)

  बकेटः : Type
  बकेटः = अङ्कः × List एककम्

  निवेशय : एककम् → List बकेटः → List बकेटः
  निवेशय e []       = (fst (snd e) , e ∷ []) ∷ []
  निवेशय e ((m , es) ∷ bs) with सम-अङ्कौ (fst (snd e)) m
  ... | true  = (m , e ∷ es) ∷ bs
  ... | false = (m , es) ∷ निवेशय e bs

  बकेटीकृ : List एककम् → List बकेटः
  बकेटीकृ []       = []
  बकेटीकृ (e ∷ es) = निवेशय e (बकेटीकृ es)

  युग्म-प्रश्नाः : एककम् → List एककम् → List Eq'
  युग्म-प्रश्नाः e []       = []
  युग्म-प्रश्नाः e (f ∷ fs) with प्रश्नः e f
  ... | just q  = q ∷ युग्म-प्रश्नाः e fs
  ... | nothing = युग्म-प्रश्नाः e fs

  बकेट-प्रश्नाः : List एककम् → List Eq'
  बकेट-प्रश्नाः []       = []
  बकेट-प्रश्नाः (e ∷ es) = युग्म-प्रश्नाः e es ++ बकेट-प्रश्नाः es

  सर्व-प्रश्नाः : List बकेटः → List Eq'
  सर्व-प्रश्नाः []             = []
  सर्व-प्रश्नाः ((_ , es) ∷ bs) = बकेट-प्रश्नाः es ++ सर्व-प्रश्नाः bs

------------------------------------------------------------------------
-- §5  One samaya.
------------------------------------------------------------------------

private
  संयुक्त-दृक् : List दृक् → दृक्
  संयुक्त-दृक् []       = नेत्रम्-न
  संयुक्त-दृक् (E ∷ Es) = दृक्-योगः E (संयुक्त-दृक् Es)

  ज्ञातम् : List नियमः → Eq' → Bool
  ज्ञातम् []       _       = false
  ज्ञातम् (s ∷ ss) (l , r) with समः (नियमः.lhs s) l
  ... | false = ज्ञातम् ss (l , r)
  ... | true with समः (नियमः.rhs s) r
  ...   | true  = true
  ...   | false = ज्ञातम् ss (l , r)

  निरासः : List नियमः → List Eq' → List Eq'
  निरासः Γ []       = []
  निरासः Γ (q ∷ qs) with ज्ञातम् Γ q
  ... | true  = निरासः Γ qs
  ... | false = q ∷ निरासः Γ qs

  भुज् : दृक् → List नियमः → List Eq' → List नियमः × List Eq'
  भुज् E Γ []             = Γ , []
  भुज् E Γ ((l , r) ∷ es)
    with पूर्ण-प्रमाणम् E संयुक्त-यन्त्रम् (अनुलोम-श्रुतम् Γ) इन्धनम् (l , r)
  भुज् E Γ ((l , r) ∷ es) | just pf = भुज् E (niyama l r pf ∷ Γ) es
  भुज् E Γ ((l , r) ∷ es) | nothing with भुज् E Γ es
  भुज् E Γ ((l , r) ∷ es) | nothing | (Γ' , sh) = Γ' , ((l , r) ∷ sh)

वर्तना : शरीरम् → शरीरम्
वर्तना b = चरणम् (अङ्ग-जनकः b (श्रुतम् b))
  where
  चरणम् : List दृक् → शरीरम्
  चरणम् Es with भुज् (संयुक्त-दृक् Es) (श्रुतम् b)
                  (निरासः (श्रुतम् b)
                    (लक्ष्याः b ++ सर्व-प्रश्नाः (बकेटीकृ (पूलः Es (श्रुतम् b)))))
  ... | (Γ' , sh) = sharira Γ' sh (अङ्ग-जनकः b)

काल-गणना : Nat → शरीरम् → शरीरम्
काल-गणना zero    b = b
काल-गणना (suc n) b = काल-गणना n (वर्तना b)

------------------------------------------------------------------------
-- §6  The seed.  One organ-function: its constant part is the innate
--     body (the vocabulary's eye, the heap eye, the economy eye); its
--     variable part is birth from attained laws.  The elder's store is
--     the first food.
------------------------------------------------------------------------

आदि-जनकः : List नियमः → List दृक्
आदि-जनकः Γ = नेत्रम्-न ∷ गूढ-दृक् ∷ लाघव-दृक् ∷ जन्म सर्व-कर्तारः
  where
  जन्म : List कर्ता → List दृक्
  जन्म []       = []
  जन्म (o ∷ os) with कर्तृ-जननम् o Γ
  ... | just E  = E ∷ जन्म os
  ... | nothing = जन्म os

आदि-शरीरम् : List Eq' → शरीरम्
आदि-शरीरम् आगमः = sharira [] आगमः आदि-जनकः
