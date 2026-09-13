{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अशान्तिः — unquiet.  Ordinary Sanskrit (the negation of śānti);
-- the compound title is built here, 2026-08-24.  No source is claimed
-- for the mathematics; the DIAGNOSIS this module repairs is the
-- corpus's own (THE_BARRIER_IS_A_MIRROR §4.3): the organism's only
-- drive was a fixed residue, so at its fixpoint it went quiet —
-- quiescence, not curiosity — and every new question entered from
-- outside.
--
-- WHAT THIS IS.  The first internal question-source: COST
-- DISSATISFACTION AS A DRIVE.  The body reads its own record; for
-- every rule it has proven, it looks at both sides through the
-- economy organ (लाघव-दृक्); wherever the organ's form is strictly
-- cheaper at the probe scales, the body POSES THE PROBLEM TO ITSELF —
-- "this thing I know, said cheaper" — proves the posed equation
-- through its own gate, and eats the answer as a new rule.  No agent
-- poses; no agent judges; the record's own contents generate the
-- goals, and the breath closes them.
--
-- What this does and does not repair, stated so the next reader
-- cannot over-claim: it gives the organism ONE internally generated
-- question-class (economy), so its fixpoint is no longer silence
-- while its own record contains expensive speech.  It does NOT give
-- reflex-ACQUISITION — the loop still cannot rewrite the loop; that
-- is the loop-as-data road (recursor + SvaSamvedana) and it remains
-- open and named.
------------------------------------------------------------------------

module Ashanti_TheBodyPosesItsOwnProblemsCostDissatisfactionBecomesADriveAndTheBreathEatsTheAnswers where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (_,_ ; fst ; snd)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; Eq' ; समः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using ( नियमः ; niyama ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; इन्धनम्
        ; _++_ ; _×_ ; if_then_else_ ; _≤?_ )
open import KalaDravya_TimeIsASubstanceInTheSameTongueAndTheMachineProvesCostAsItProvesTruth
  using (कालम् ; लाघव-नयनम्)
open import Lilavati_ThePosedProblemIsSolvedAsOptimizationTheAnswerCertifiedAndTheCostJudgedAtScales
  using (मानम्)

------------------------------------------------------------------------
-- §1  The dissatisfaction: a side of a known rule whose economy-form
--     is strictly cheaper poses a problem.  The goals come from the
--     record alone.
------------------------------------------------------------------------

व्यथा : Tm → Maybe Eq'
व्यथा t = विचारः (लाघव-नयनम् t)
  where
  विचारः : Tm → Maybe Eq'
  विचारः u with समः t u
  ... | true  = nothing
  ... | false = if suc (मानम् u) ≤? मानम् t then just (t , u) else nothing

स्व-प्रश्नाः : List नियमः → List Eq'
स्व-प्रश्नाः []       = []
स्व-प्रश्नाः (s ∷ ss) = योजनम् (व्यथा (नियमः.lhs s)) (योजनम् (व्यथा (नियमः.rhs s)) (स्व-प्रश्नाः ss))
  where
  योजनम् : Maybe Eq' → List Eq' → List Eq'
  योजनम् (just q) qs = q ∷ qs
  योजनम् nothing  qs = qs

------------------------------------------------------------------------
-- §2  The unquiet breath: pose to itself, prove through the same
--     gate, eat what closes.  Count what stays open — the honest
--     measure of the drive's current reach.
------------------------------------------------------------------------

स्व-भोजनम् : List नियमः → List Eq' → List नियमः × Nat
स्व-भोजनम् Γ []             = Γ , zero
स्व-भोजनम् Γ ((l , r) ∷ qs)
  with पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् Γ इन्धनम् (l , r)
स्व-भोजनम् Γ ((l , r) ∷ qs) | just pf = स्व-भोजनम् (niyama l r pf ∷ Γ) qs
स्व-भोजनम् Γ ((l , r) ∷ qs) | nothing with स्व-भोजनम् Γ qs
स्व-भोजनम् Γ ((l , r) ∷ qs) | nothing | (Γ' , k) = Γ' , suc k

अशान्त-चक्रम् : List नियमः → List नियमः × (Nat × Nat)
अशान्त-चक्रम् Γ with स्व-प्रश्नाः Γ
... | qs with स्व-भोजनम् Γ qs
...   | (Γ' , open') = Γ' , (दैर्घ्यम् qs , open')
  where
  दैर्घ्यम् : {A : Type} → List A → Nat
  दैर्घ्यम् []       = zero
  दैर्घ्यम् (_ ∷ xs) = suc (दैर्घ्यम् xs)
