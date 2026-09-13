{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्तना — THE EXACT JAIN COMPUTER.  One jīva, its veils, its
-- shedding, one samaya.  Every field and every phase of the step is a
-- category of the Tattvārthasūtra (Umāsvāti, c. 2nd–5th c. CE), in
-- the tradition's own order, and nothing else is in the machine:
--
--   TS 2.8   उपयोगो लक्षणम् — upayoga is the MARK of the jīva: its
--            consciousness-in-operation, vision (darśana — the organ
--            eyes) and knowing (jñāna — the pramāṇa).  Held here as
--            the one capacity field: the organs as a function of what
--            stands unveiled.
--   TS 1.9   the kinds of jñāna already live in this corpus by name:
--            mati (the prover's own inference), śruta (the record's
--            voice), avadhi (the probes — direct sight within bound);
--            kevala is disclaimed (PurnaPramana's header).
--   TS 6.1-2 yoga — activity — is āsrava, the INFLUX: the body's own
--            naya-crossing over its pool is its activity, and what it
--            surfaces flows in.  Unrestrained activity floods: this
--            was MEASURED before it was framed (the ungated samaya ran
--            >10 minutes and was still binding karma when killed).
--   TS 9.2   gupti — restraint of activity — is a cause of saṃvara:
--            the jīva carries its restraint as a mode (गुप्तिः), and
--            only so much influx per samaya is admitted.  Not an
--            optimization: the doctrine's own remedy for the doctrine's
--            own predicted flood.
--   TS 9.1   saṃvara — stoppage: a veil already destroyed does not
--            flow in again (the ledger is consulted; no re-bondage).
--   TS 8.2   what enters and is not at once destroyed BINDS (bandha):
--            the standing veil-set आवरणम् — jñānāvaraṇa, the
--            knowledge-veiling karma — is exactly the body's open
--            goal-set.  A goal is not a "question" the body is curious
--            about: it is a VEIL over a knowing the body already has
--            by nature (the semantic truth is eternal; the proof does
--            not create it, it removes what hides it).
--   TS 9.3   tapasā nirjarā ca — by exertion, shedding: the breath
--            over the bound veils.  What sheds is kṣaya, and each
--            shed veil enters the ledger NAMED, WITH ITS WARRANT —
--            the repo's own standing law (an act is legitimate only
--            if it names the veil it destroys) made structural: a
--            नियमः IS a named destroyed veil carrying its साक्षी.
--   TS 5.39  kāla poses nothing and orders everything
--            (paratva-aparatva): each influx pair is written
--            posterior-to-prior, costly toward cheap.
--   TS 5.30  utpāda-vyaya-dhrauvya at every samaya: influx arises,
--            shed veils perish as veils, the jīva persists.
--
-- School: Jaina, throughout.  Claimed of the sources: the categories,
-- their names, and their order.  The theorems are the machine's own.
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
-- §1  The jīva.  Its mark is upayoga (TS 2.8); its bound karma is the
--     veil-set; its ledger is the record of named destructions; its
--     restraint is a mode.  Four fields; each is a sūtra's category.
------------------------------------------------------------------------

record जीवः : Type where
  constructor jiva
  field
    उपयोगः     : List नियमः → List दृक्   -- TS 2.8: the mark — vision from the unveiled
    आवरणम्     : List Eq'                 -- TS 8.2: bound knowledge-veils (the open set)
    निर्जीर्णम्  : List नियमः               -- TS 9.3: shed veils, each named with its warrant
    गुप्तिः     : Nat                      -- TS 9.2: restraint of activity, as a mode

open जीवः public

------------------------------------------------------------------------
-- §2  The standpoints (nayas) and kāla's ordering.  Avadhi — the
--     probes — is direct sight within a bound; each organ is a naya;
--     kāla orders (TS 5.39).
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
-- §3  Yoga: the jīva's activity — its pool, crossed by its own
--     standpoints.  What activity surfaces is the āsrava.
------------------------------------------------------------------------

private
  एककम् : Type
  एककम् = Tm × (अङ्कः × List Tm)

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

  सर्व-सम-दर्शनम् : List Tm → List Tm → Bool
  सर्व-सम-दर्शनम् []       []       = true
  सर्व-सम-दर्शनम् (i ∷ is) (j ∷ js) with समः i j
  ... | true  = सर्व-सम-दर्शनम् is js
  ... | false = false
  सर्व-सम-दर्शनम् _        _        = false

  क्रमय : Tm → Tm → Eq'
  क्रमय s t = if घटिका t ≤? घटिका s then (s , t) else (t , s)

  विमर्शः : एककम् → एककम् → Maybe Eq'
  विमर्शः (s , (ms , is)) (t , (mt , it)) with सम-अङ्कौ ms mt
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

  युग्म-विमर्शाः : एककम् → List एककम् → List Eq'
  युग्म-विमर्शाः e []       = []
  युग्म-विमर्शाः e (f ∷ fs) with विमर्शः e f
  ... | just q  = q ∷ युग्म-विमर्शाः e fs
  ... | nothing = युग्म-विमर्शाः e fs

  बकेट-विमर्शाः : List एककम् → List Eq'
  बकेट-विमर्शाः []       = []
  बकेट-विमर्शाः (e ∷ es) = युग्म-विमर्शाः e es ++ बकेट-विमर्शाः es

  योगः : List दृक् → List नियमः → List Eq'
  योगः Es Γ = सङ्ग्रह (बकेटीकृ (पूलः Es Γ))
    where
    सङ्ग्रह : List बकेटः → List Eq'
    सङ्ग्रह []             = []
    सङ्ग्रह ((_ , es) ∷ bs) = बकेट-विमर्शाः es ++ सङ्ग्रह bs

------------------------------------------------------------------------
-- §4  Saṃvara, gupti, bandha, tapas.
------------------------------------------------------------------------

private
  -- TS 9.1: what is already destroyed does not flow in again
  क्षीणम् : List नियमः → Eq' → Bool
  क्षीणम् []       _       = false
  क्षीणम् (s ∷ ss) (l , r) with समः (नियमः.lhs s) l
  ... | false = क्षीणम् ss (l , r)
  ... | true with समः (नियमः.rhs s) r
  ...   | true  = true
  ...   | false = क्षीणम् ss (l , r)

  संवरः : List नियमः → List Eq' → List Eq'
  संवरः Γ []       = []
  संवरः Γ (q ∷ qs) with क्षीणम् Γ q
  ... | true  = संवरः Γ qs
  ... | false = q ∷ संवरः Γ qs

  -- TS 9.2: gupti — only so much activity's influx is admitted
  गुप्त-ग्रहणम् : Nat → List Eq' → List Eq'
  गुप्त-ग्रहणम् zero    _        = []
  गुप्त-ग्रहणम् (suc g) []       = []
  गुप्त-ग्रहणम् (suc g) (q ∷ qs) = q ∷ गुप्त-ग्रहणम् g qs

  संयुक्त-दृक् : List दृक् → दृक्
  संयुक्त-दृक् []       = नेत्रम्-न
  संयुक्त-दृक् (E ∷ Es) = दृक्-योगः E (संयुक्त-दृक् Es)

  -- TS 9.3: tapasā nirjarā — the exertion that sheds; each shed veil
  -- enters the ledger named, with its warrant
  तपस् : दृक् → List नियमः → List Eq' → List नियमः × List Eq'
  तपस् E Γ []             = Γ , []
  तपस् E Γ ((l , r) ∷ es)
    with पूर्ण-प्रमाणम् E संयुक्त-यन्त्रम् (अनुलोम-श्रुतम् Γ) इन्धनम् (l , r)
  तपस् E Γ ((l , r) ∷ es) | just pf = तपस् E (niyama l r pf ∷ Γ) es
  तपस् E Γ ((l , r) ∷ es) | nothing with तपस् E Γ es
  तपस् E Γ ((l , r) ∷ es) | nothing | (Γ' , sh) = Γ' , ((l , r) ∷ sh)

------------------------------------------------------------------------
-- §5  One samaya: yoga → saṃvara → gupti → bandha → tapas → nirjarā.
--     The order is the sūtras' own.  The jīva persists (dhrauvya);
--     its veils arise and perish (utpāda, vyaya).
------------------------------------------------------------------------

वर्तना : जीवः → जीवः
वर्तना j = चरणम् (उपयोगः j (निर्जीर्णम् j))
  where
  चरणम् : List दृक् → जीवः
  चरणम् Es with तपस् (संयुक्त-दृक् Es) (निर्जीर्णम् j)
                 (आवरणम् j
                  ++ गुप्त-ग्रहणम् (गुप्तिः j)
                       (संवरः (निर्जीर्णम् j) (योगः Es (निर्जीर्णम् j))))
  ... | (Γ' , बद्धम्) = jiva (उपयोगः j) बद्धम् Γ' (गुप्तिः j)

काल-गणना : Nat → जीवः → जीवः
काल-गणना zero    j = j
काल-गणना (suc n) j = काल-गणना n (वर्तना j)

------------------------------------------------------------------------
-- §6  The seed jīva: upayoga whose constant part is the innate vision
--     (the vocabulary's eye, the heap eye, the economy eye) and whose
--     variable part is vision born of what stands unveiled; the
--     elder's store as the first bound veil-set; a stated restraint.
------------------------------------------------------------------------

आदि-उपयोगः : List नियमः → List दृक्
आदि-उपयोगः Γ = नेत्रम्-न ∷ गूढ-दृक् ∷ लाघव-दृक् ∷ जन्म सर्व-कर्तारः
  where
  जन्म : List कर्ता → List दृक्
  जन्म []       = []
  जन्म (o ∷ os) with कर्तृ-जननम् o Γ
  ... | just E  = E ∷ जन्म os
  ... | nothing = जन्म os

आदि-जीवः : Nat → List Eq' → जीवः
आदि-जीवः g आगमः = jiva आदि-उपयोगः आगमः [] g
