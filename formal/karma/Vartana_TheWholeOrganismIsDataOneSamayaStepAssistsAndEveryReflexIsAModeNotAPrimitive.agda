{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्तना — the first mark of time.  Umāsvāti, *Tattvārthasūtra* 5.38–39
-- (c. 2nd–5th c. CE): गुणपर्ययवद् द्रव्यम् — substance is what possesses
-- qualities and MODES — and वर्तनापरिणामक्रियाः परत्वापरत्वे च कालस्य —
-- time's marks are vartanā (the assisting of each substance's
-- SELF-modification), pariṇāma, kriyā, before-and-after.  Kāla does
-- not push: the content of every change is the substance's own; time
-- is the auxiliary of its occurrence.  And kāla is atomic — kālāṇu,
-- time-atoms standing one per space-point "like heaps of jewels"
-- (Nemicandra, *Dravyasaṃgraha* v.22, 10th c.).  School: Jaina.
-- Claimed of the sources: the doctrine's shape, which IS this
-- module's architecture, and nothing else.
--
-- THE REPAIR THIS IS (owner's correction, 2026-08-24): reflex classes
-- are NOT primitive.  Until now every behavior — the breath, the
-- climb, the unquiet — was a separate hand-wired loop: an agent's
-- function, outside the organism.  Wrong, and the core said so all
-- along (UtpadaVyayaDhrauvya: the store turns ITSELF).  Here:
--
--   * the WHOLE ORGANISM IS DATA — शरीरम्: its proven rules, its
--     standing goals, its DRIVES, and its drive-generators, all
--     fields, all modes (paryāya) of one substance;
--   * ONE step is primitive — वर्तना : शरीरम् → शरीरम्, one samaya,
--     generic and content-free: it collects the goals the body's own
--     drives pose, breathes them with the eye BORN FROM the body's
--     own record, eats what closes, keeps what does not, and lets the
--     body's drive-generators append new drives — so even
--     reflex-acquisition is a mode arising in the state, not an
--     agent's edit;
--   * every previous behavior is an INITIAL STATE, not a function:
--     the elder-fed breath, the unquiet economy drive — same step,
--     different seed;
--   * काल-गणना iterates the step: kālāṇu after kālāṇu, and
--     utpāda-vyaya-dhrauvya holds at each — goals arise, closed goals
--     decay, the substance persists.
------------------------------------------------------------------------

module Vartana_TheWholeOrganismIsDataOneSamayaStepAssistsAndEveryReflexIsAModeNotAPrimitive where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (_,_ ; fst ; snd)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; Eq' ; समः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using ( नियमः ; niyama ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; इन्धनम् ; _++_ ; _×_ )
open import Gunasthana_TheBodyClimbsByItsOwnAttainmentTheEyeIsAFunctionOfTheRecordAndNoAgentPicksOrgans
  using (जात-चक्षुः ; अनुलोम-श्रुतम्)
open import Ashanti_TheBodyPosesItsOwnProblemsCostDissatisfactionBecomesADriveAndTheBreathEatsTheAnswers
  using (स्व-प्रश्नाः)

------------------------------------------------------------------------
-- §1  The substance.  A drive is data: it reads the body's knowledge
--     and its standing goals and poses questions.  A drive-generator
--     is data: it reads the knowledge and yields NEW drives — so the
--     set of reflexes is itself a mode of the state.
------------------------------------------------------------------------

दृष्टिः : Type
दृष्टिः = List नियमः → List Eq' → List Eq'

record शरीरम् : Type where
  constructor sharira
  field
    श्रुतम्       : List नियमः          -- what it has proven (dhrauvya grows here)
    लक्ष्याः      : List Eq'            -- its standing goals, kept across samayas
    दृष्टयः       : List दृष्टिः         -- its reflexes, AS DATA
    दृष्टि-जननम्  : List नियमः → List दृष्टिः   -- reflex-acquisition, AS DATA

open शरीरम् public

------------------------------------------------------------------------
-- §2  One samaya.  Vartanā assists; the content is the body's own:
--     the eye is born from its record, the goals from its drives, the
--     new reflexes from its generator.  Nothing else enters.
------------------------------------------------------------------------

private
  प्रश्न-सङ्ग्रहः : List दृष्टिः → List नियमः → List Eq' → List Eq'
  प्रश्न-सङ्ग्रहः []       Γ gs = gs
  प्रश्न-सङ्ग्रहः (d ∷ ds) Γ gs = d Γ gs ++ प्रश्न-सङ्ग्रहः ds Γ gs

  भुज् : List नियमः → List Eq' → List नियमः × List Eq'
  भुज् Γ []             = Γ , []
  भुज् Γ ((l , r) ∷ es)
    with पूर्ण-प्रमाणम् (जात-चक्षुः Γ) संयुक्त-यन्त्रम् (अनुलोम-श्रुतम् Γ) इन्धनम् (l , r)
  भुज् Γ ((l , r) ∷ es) | just pf = भुज् (niyama l r pf ∷ Γ) es
  भुज् Γ ((l , r) ∷ es) | nothing with भुज् Γ es
  भुज् Γ ((l , r) ∷ es) | nothing | (Γ' , sh) = Γ' , ((l , r) ∷ sh)

-- vyaya: a goal the body already holds as a rule is not re-posed —
-- decay clears what arose, and the substance stays lean
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

वर्तना : शरीरम् → शरीरम्
वर्तना b with भुज् (श्रुतम् b) (निरासः (श्रुतम् b) (प्रश्न-सङ्ग्रहः (दृष्टयः b) (श्रुतम् b) (लक्ष्याः b)))
... | (Γ' , sh) =
  sharira Γ' sh (दृष्टयः b ++ दृष्टि-जननम् b Γ') (दृष्टि-जननम् b)

काल-गणना : Nat → शरीरम् → शरीरम्
काल-गणना zero    b = b
काल-गणना (suc n) b = काल-गणना n (वर्तना b)

------------------------------------------------------------------------
-- §3  The previous behaviors, re-founded as SEEDS of the one step —
--     states, not functions.
------------------------------------------------------------------------

-- the drive that offers a fixed received text once: śruta as food.
आगम-दृष्टिः : List Eq' → दृष्टिः
आगम-दृष्टिः es Γ gs = es

-- the economy drive: the body's own record, judged by its own clock,
-- poses "say this cheaper" — the internal question-source.
अशान्ति-दृष्टिः : दृष्टिः
अशान्ति-दृष्टिः Γ gs = स्व-प्रश्नाः Γ

-- no reflex-acquisition yet: the honest constant generator.  (A
-- generator that births drives from attained law-shapes is the next
-- mode — the machinery is अङ्ग-जननम्'s, the field is already here.)
निर्-जननम् : List नियमः → List दृष्टिः
निर्-जननम् _ = []

-- the elder-fed unquiet body: eats the received store AND its own
-- dissatisfaction, one substance, one step.
प्रथम-शरीरम् : List Eq' → शरीरम्
प्रथम-शरीरम् आगमः =
  sharira [] आगमः (अशान्ति-दृष्टिः ∷ []) निर्-जननम्
