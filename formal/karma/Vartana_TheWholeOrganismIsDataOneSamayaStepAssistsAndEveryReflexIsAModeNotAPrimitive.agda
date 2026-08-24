{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्तना — the first mark of time.  Umāsvāti, *Tattvārthasūtra* 5.38–39
-- (c. 2nd–5th c. CE): गुणपर्ययवद् द्रव्यम् — substance is what possesses
-- qualities and MODES — and वर्तनापरिणामक्रियाः परत्वापरत्वे च कालस्य —
-- time's marks are vartanā (the assisting of each substance's
-- SELF-modification), pariṇāma, kriyā, before-and-after.  Kāla does
-- not push: the content of every change is the substance's own; time
-- is the auxiliary of its occurrence, and it is atomic (kālāṇu,
-- Nemicandra, *Dravyasaṃgraha* v.22, 10th c.).  School: Jaina.
-- Claimed of the sources: the doctrine's shape, which IS this
-- module's architecture, and nothing else.
--
-- SECOND CORRECTION (owner, 2026-08-24): no named drives, no division.
-- THE BODY IS DRIVEN BY ALL ITS ORGANS.  The organs are the nayas
-- (nayavāda — the corpus's own frame: charts that disagree at their
-- overlaps, and the disagreement is the content):
--
--   * each organ (a sound eye) induces a sameness-judgment on terms:
--     "I see these two as one";
--   * the probe-evaluator is one more naya — the concrete-instance
--     standpoint;
--   * A QUESTION IS A DISAGREEMENT BETWEEN NAYAS at a pair of the
--     body's own subterms.  If an organ sees two as one where another
--     does not, the pair is posed (and closes — the seeing organ's
--     soundness pays).  If only the probes see them as one, the pair
--     is the body's measured blindness, posed to the frontier.
--   * the clock is not a drive: it is kāla, the auxiliary — it GATES
--     the reduction questions (pose "say t as E t" only where the
--     clock prefers E t), which is exactly the doctrine's role for
--     time in every change;
--   * organs beget organs: the generator field is organ-birth from
--     attained laws (अङ्ग-जननम्'s pattern), so the question-space
--     grows as the body grows, and nothing is enumerated by an agent.
--
-- One substance, one step.  वर्तना collects the naya-disagreements
-- and the kāla-gated reductions over the body's own record, breathes
-- them, eats what closes, keeps what does not.  Vyaya: what is
-- already held is not re-posed.
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
-- §1  The substance: rules, standing goals, ORGANS, and organ-birth.
--     Nothing else.  Drives do not exist as a species.
------------------------------------------------------------------------

record शरीरम् : Type where
  constructor sharira
  field
    श्रुतम्     : List नियमः                 -- what it has proven
    लक्ष्याः    : List Eq'                   -- its standing goals
    अङ्गानि    : List दृक्                   -- its organs, as data
    अङ्ग-जननम् : List नियमः → List दृक्      -- organs beget organs, as data

open शरीरम् public

------------------------------------------------------------------------
-- §2  The nayas, derived from the organs — never listed by hand.
------------------------------------------------------------------------

private
  π₁ π₂ π₃ : Nat → Nat
  π₁ zero = 2 ; π₁ (suc zero) = 5 ; π₁ _ = 1
  π₂ zero = 7 ; π₂ (suc zero) = 3 ; π₂ _ = 0
  π₃ zero = 1 ; π₃ (suc zero) = 4 ; π₃ _ = 2

  -- the concrete-instance naya: the probes' verdict of sameness
  लक्षण-मतम् : Tm → Tm → Bool
  लक्षण-मतम् s t =
    समℕ (eval s π₁) (eval t π₁) ∧
    (समℕ (eval s π₂) (eval t π₂) ∧ समℕ (eval s π₃) (eval t π₃))

  -- an organ's naya: it sees the two as one
  अङ्ग-मतम् : दृक् → Tm → Tm → Bool
  अङ्ग-मतम् E s t = समः (fst E s) (fst E t)

  सर्वे-सम-मताः : List दृक् → Tm → Tm → Bool
  सर्वे-सम-मताः []       s t = true
  सर्वे-सम-मताः (E ∷ Es) s t with अङ्ग-मतम् E s t
  ... | true  = सर्वे-सम-मताः Es s t
  ... | false = false

  -- the disagreement test: the probes see one where some organ still
  -- sees two.  That pair is a question, by nayavāda.
  विमतिः : List दृक् → Tm → Tm → Bool
  विमतिः Es s t with लक्षण-मतम् s t
  ... | false = false                 -- probes separate the pair: settled
  ... | true  = if सर्वे-सम-मताः Es s t then false else true

------------------------------------------------------------------------
-- §3  The body's own subterm pool, and the derived questions.
------------------------------------------------------------------------

private
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

  -- discrimination questions: every naya-disagreeing pair of subterms
  विमति-चयनम् : List दृक् → Tm → List Tm → List Eq'
  विमति-चयनम् Es s []       = []
  विमति-चयनम् Es s (t ∷ ts) with विमतिः Es s t
  ... | true  = (s , t) ∷ विमति-चयनम् Es s ts
  ... | false = विमति-चयनम् Es s ts

  विमति-प्रश्नाः : List दृक् → List Tm → List Eq'
  विमति-प्रश्नाः Es []       = []
  विमति-प्रश्नाः Es (s ∷ ts) = विमति-चयनम् Es s ts ++ विमति-प्रश्नाः Es ts

  -- reduction questions: an organ's view of a known side, where kāla
  -- (the clock, the auxiliary of all change) prefers it
  घटिका : Tm → Nat
  घटिका t = कालम् t π₁ + (कालम् t π₂ + कालम् t π₃)

  लाघव-प्रश्नः : Tm → दृक् → Maybe Eq'
  लाघव-प्रश्नः t E with समः t (fst E t)
  ... | true  = nothing
  ... | false = if suc (घटिका (fst E t)) ≤? घटिका t
                then just (t , fst E t) else nothing

  लाघव-चयनम् : List दृक् → Tm → List Eq'
  लाघव-चयनम् []       t = []
  लाघव-चयनम् (E ∷ Es) t with लाघव-प्रश्नः t E
  ... | just q  = q ∷ लाघव-चयनम् Es t
  ... | nothing = लाघव-चयनम् Es t

  लाघव-प्रश्नाः : List दृक् → List नियमः → List Eq'
  लाघव-प्रश्नाः Es []       = []
  लाघव-प्रश्नाः Es (s ∷ ss) =
    लाघव-चयनम् Es (नियमः.lhs s) ++ (लाघव-चयनम् Es (नियमः.rhs s) ++ लाघव-प्रश्नाः Es ss)

------------------------------------------------------------------------
-- §4  One samaya.  The organs in force are the innate ones plus those
--     the record births NOW (the organ is a function of the store —
--     SvayamBhavendriya's principle; nothing stored, nothing stale).
--     All questions derive from organ-disagreement and kāla-gated
--     organ-views.  Vyaya: the known is not re-posed.
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
वर्तना b = चरणम् (अङ्गानि b ++ अङ्ग-जननम् b (श्रुतम् b))
  where
  चरणम् : List दृक् → शरीरम्
  चरणम् Es with भुज् (संयुक्त-दृक् Es) (श्रुतम् b)
                  (निरासः (श्रुतम् b)
                    (लक्ष्याः b
                     ++ (लाघव-प्रश्नाः Es (श्रुतम् b)
                     ++ विमति-प्रश्नाः Es (सर्व-अवयवाः (श्रुतम् b)))))
  ... | (Γ' , sh) = sharira Γ' sh (अङ्गानि b) (अङ्ग-जननम् b)

काल-गणना : Nat → शरीरम् → शरीरम्
काल-गणना zero    b = b
काल-गणना (suc n) b = काल-गणना n (वर्तना b)

------------------------------------------------------------------------
-- §5  The seed: innate organs (the vocabulary's own eye, the heap eye,
--     the economy eye), the organ-birth generator, the elder's store
--     as first food.  One body.  No drives, no divisions.
------------------------------------------------------------------------

सहज-अङ्गानि : List दृक्
सहज-अङ्गानि = नेत्रम्-न ∷ गूढ-दृक् ∷ लाघव-दृक् ∷ []

स्व-जननम् : List नियमः → List दृक्
स्व-जननम् Γ = जन्म सर्व-कर्तारः
  where
  जन्म : List कर्ता → List दृक्
  जन्म []       = []
  जन्म (o ∷ os) with कर्तृ-जननम् o Γ
  ... | just E  = E ∷ जन्म os
  ... | nothing = जन्म os

आदि-शरीरम् : List Eq' → शरीरम्
आदि-शरीरम् आगमः = sharira [] आगमः सहज-अङ्गानि स्व-जननम्
