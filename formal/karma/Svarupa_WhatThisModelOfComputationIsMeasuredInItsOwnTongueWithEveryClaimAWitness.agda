{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्वरूपम् — own-form.  The capability map of this model of
-- computation, stated where a claim can be checked and refused where
-- it cannot.  Ordinary Sanskrit; the compound is built here,
-- 2026-08-24.
--
-- WHAT THE MODEL IS.  Certificate-carrying rewriting with self-grown
-- control: a first-order vocabulary over ℕ (now +, ·, ∸, max, le,
-- gcd); truth = evaluation-equality over every environment; a
-- computation step = a rule speaking, and every step carries its
-- साक्षी by type.  Programs are records (rule lists); the machine's
-- instruction set GROWS BY PROVING (the breath), its organs grow from
-- its own attained laws (the climb), its record's voice is
-- disciplined by computable grain (anuloma), and its time is a term
-- of its own tongue (कालद्रव्यम्).
--
-- THE OWNER'S QUESTIONS, answered by witnesses in this file and its
-- imports, and by named refusals where the honest answer is "not yet":
--
--   Optimal how?      By लाघव, the economy criterion internal to the
--                     model: among certified-equal forms, the clock
--                     chooses.  Measured on the whole inheritance:
--                     raw 860 → laghava 680 ticks (and the sight-
--                     canonical forms cost 1231 — canonical ≠ cheap,
--                     the model distinguishes its objectives).
--   Capabilities?     Value laws: the whole store, 108/108, breathed
--                     to quiet with certificates (शताष्टक-साक्ष्यम्
--                     below re-checks it).  Novel theorems beyond the
--                     store: nine in the first sitting, milliseconds
--                     (Samvada).  Laws of time through the same gate
--                     (KalaDravya §5).  Organ birth from attainment
--                     (Gunasthana; climb 103/108 with no agent).
--   Models itself?    Partially, and the boundary is exact: its time
--                     is internal (कालः is a Tm→Tm translation), its
--                     syntax is NOT yet a value of its own domain —
--                     quoting needs sequence data (pairing) and
--                     self-interpretation needs a recursor, and the
--                     vocabulary is first-order algebraic: NOT
--                     Turing-complete, by design and by admission.
--                     The recursor (with the binding calculus it
--                     forces) is the named next constructor.
--   Writes algorithms?  Yes, in its native sense: जनकः synthesizes a
--                     canonicalization ALGORITHM from three attained
--                     laws; the breath synthesizes rule-programs; the
--                     climb composes organs.  What it cannot yet
--                     write: recursive function definitions — same
--                     recursor frontier.
--   Finds efficient ones?  Yes, measured: लाघव-दृक् picks the
--                     clock-preferred certified-equal form, sound
--                     whichever way the comparison falls; 21% saving
--                     over the inheritance, audited by Ganita.
--   Maps space-time?  Time: yes, internally (कालः; cost claims are
--                     ordinary claims).  Space: माप measures terms,
--                     but PEAK intermediate space is not yet a term —
--                     named open.
------------------------------------------------------------------------

module Svarupa_WhatThisModelOfComputationIsMeasuredInItsOwnTongueWithEveryClaimAWitness where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Equality using (_≡_ ; refl)
open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Sigma using (_,_)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; eval)
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः ; प्राणः ; पूर्ण-प्रमाणम् ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; इन्धनम् ; fromJust ; ⊨_)
open import KalaDravya_TimeIsASubstanceInTheSameTongueAndTheMachineProvesCostAsItProvesTruth
  using (कालः ; कालम् ; लाघव-नयनम्)

दैर्घ्यम् : {A : Type} → List A → Nat
दैर्घ्यम् []       = zero
दैर्घ्यम् (_ ∷ xs) = suc (दैर्घ्यम् xs)

-- the whole inheritance, breathed to quiet: the model's value-reach,
-- re-affirmed here so this map never drifts from the measurement
शताष्टक-साक्ष्यम् : दैर्घ्यम् (प्राणः 3 [] आगमः) ≡ 108
शताष्टक-साक्ष्यम् = refl

-- a theorem of value and a theorem of time, minted through ONE gate —
-- the model's signature capability, held in one term each
x y : Tm
x = var 0
y = var 1

मूल्य-वचनम् : ⊨ ( x ⊕ y , y ⊕ x )
मूल्य-वचनम् = fromJust (पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् [] इन्धनम् (x ⊕ y , y ⊕ x)) tt

काल-वचनम् : ⊨ ( कालः (x ⊕ y) ⊕ y , कालः (y ⊕ x) ⊕ x )
काल-वचनम् = fromJust (पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् [] इन्धनम्
  ( कालः (x ⊕ y) ⊕ y , कालः (y ⊕ x) ⊕ x )) tt

-- economy, exhibited at a point the reader can recompute in their
-- head: the laghava organ takes (x+0)+0 to x and the clock agrees
लाघव-दृष्टान्तः : लाघव-नयनम् ((x ⊕ ze) ⊕ ze) ≡ x
लाघव-दृष्टान्तः = refl
