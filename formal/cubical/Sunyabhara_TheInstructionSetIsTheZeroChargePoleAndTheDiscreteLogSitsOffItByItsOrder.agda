-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शून्यभारः — यन्त्रस्य आज्ञाः शून्यभाराः ; घातः तु स्व-आवृत्त्या तस्मात् बहिः ।
--
-- (the instruction set carries zero charge; the power map sits off it by
--  exactly its own period.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  One edge, between three modules that cite each other in
-- no direction.  Nothing new is proved: two existing theorems are
-- composed and the composite is instantiated once.  The whole file is
-- the composition; if it is worth anything it is because the two ends
-- had not been put together.
--
--   `Yantra_…`          Program A B = A ≃ B — every instruction of this
--                       computer is an equivalence.
--   `SvaTantuVasa_…`    ध्रुव-बिन्दुः : isEquiv f → isContr (Σ[ Φ ] संरक्षणम् f Φ)
--                       — a lossless observable's conserving-flow space
--                       is a POINT (itself `invIso Σ-Π-Iso` evaluated).
--   `GhataTantu_…`      powg = घात g in C₃, whose fibre over ε is not
--                       contractible: 0, 3 and 6 all land there.
--
-- §१ composes the first two: **every instruction of the machine has a
-- contractible space of conserving flows.**  The groupoid has exactly one
-- conserving flow at each of its own operations, and it is the identity.
-- No gauge freedom, no charge, nothing conserved — because nothing is
-- hidden.  `Dhruva_…`'s सूत्र read at the machine: no loss, no symmetry,
-- and the machine is all equivalences.
--
-- §२–३ exhibit the contrast at the map the crypto arc runs on, and the
-- contrast is what keeps §१ from being vacuous.  Translation by the
-- ORDER conserves `powg`, and it is not the identity flow, so `powg`'s
-- conserving-flow space is not a point — hence `powg` is not an
-- instruction of this machine.  §४ is that as a one-line corollary.
--
-- WHAT THE JOIN SAYS, and it is a reading of the terms and not a further
-- theorem: by `वासः` a conserving flow IS a section of the map's own
-- fibre family, so the flow `n ↦ 3 + n` is the section `a ↦ (3 + a , …)`
-- — at every exponent, the NEXT exponent with the same public value.
-- That section is the discrete log's ambiguity, and it is also the map's
-- symmetry.  **The thing an attacker cannot recover and the thing that
-- can move without being seen are one fibre.**  §५ states the limits of
-- that sentence rather than leaving it to be over-read.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
--   * No physics.  "Charge", "gauge", "conserved" are used as
--     `Dhruva_…`/`Khahara_…` use them — for `संरक्षणम्` and the fibre —
--     and Dhruva's fence transfers verbatim: this is NOT Noether's first
--     theorem, there is no Lagrangian, variation, continuity or current.
--   * No computational hardness.  §२–४ are about a three-element group
--     and say nothing about the difficulty of anything.  `GhataTantu_…`'s
--     own fence stands: the general coset statement for arbitrary cyclic
--     groups is owed, and §२ below is C₃ and only C₃.
--   * Not that the repository's running apparatus is the groupoid —
--     `Yantra_…` disclaims that at its site and this file inherits it.
--   * Nothing is deprecated.  `Dhruva_…`'s pointwise route, `Khahara_…`'s
--     far pole and `GhataTantu_…`'s reading are untouched; this is a
--     fifth path between existing ones (`SvaTantuVasa_…`'s "ROUTES KEPT",
--     precedent `MadhyaVinimaya_…`).
--
-- TERM.  शून्य-भार is `Dhruva_…` §३'s own compound for a contractible
-- fibre carrying no charge, and is reused rather than coined.  आवृत्ति
-- (period, recurrence) is ordinary Sanskrit.  No text is claimed for any
-- statement below.
--
-- CHECKED: exit code reported in the session log; --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Sunyabhara_TheInstructionSetIsTheZeroChargePoleAndTheDiscreteLogSitsOffItByItsOrder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; isEquiv ; equivFun ; fiber)
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (znots)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)
open import SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres
  using (ध्रुव-बिन्दुः ; तादात्म्यम् ; वासः)
open import Yantra_TheComputerIsTheGroupoidOfProofsOfTransportNotTheMonoidOfIrreversibleSteps
  using (Program ; चालनम्)
open import GhataTantu_TheDiscreteLogIsTheFibreOfPingalasPowerAndShorsPeriodQueryIsWhatReadsIt
  using (powg ; εC)
open import BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded
  using (C₃ ; e₀ ; g ; g² ; _∘_)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · THE MACHINE'S POLE.  Every instruction has a contractible space of
--     conserving flows: one flow, the identity, no charge.
--
-- One line, and that is the point — `Program` is `_≃_`, and a lossless
-- observable's flow space is `isContr` by `SvaTantuVasa`.  The two
-- modules had never been in the same room.
------------------------------------------------------------------------

यन्त्र-शून्य-भारः : {A B : Type ℓ} (p : Program A B)
                 → isContr (Σ[ Φ ∈ (A → A) ] संरक्षणम् (चालनम् p) Φ)
यन्त्र-शून्य-भारः p = ध्रुव-बिन्दुः (चालनम् p) (snd p)

-- and therefore the only conserving flow of an instruction is the
-- identity, pointwise — `SvaTantuVasa`'s containment check, read here.
यन्त्रे-न-गतिः : {A B : Type ℓ} (p : Program A B)
              → (Φ : A → A) → संरक्षणम् (चालनम् p) Φ → (a : A) → Φ a ≡ a
यन्त्रे-न-गतिः p = तादात्म्यम् (चालनम् p) (snd p)

------------------------------------------------------------------------
-- २ · THE CONTRAST.  Translation by the order conserves the power map.
--
-- `घात g 3 ≡ ε` is refl in `BijamulaKrida`, so three successor steps
-- prepend g³.  PUT TO THE KERNEL RATHER THAN ARGUED, and the first
-- attempt was wrong: `refl` fails, because `powg (3 + n)` reduces only
-- to `g ∘ (g ∘ (g ∘ powg n))` and stalls on the variable.  What is
-- needed is g³ acting as the unit ON EVERY ELEMENT — three cases, each
-- `refl` — and then the period law is `cong` of it.  The failed `refl`
-- is recorded here rather than quietly replaced: `g³ ≡ ε` and
-- `∀ x. g³ ∘ x ≡ x` are two statements and only the second reduces
-- under a bound exponent.
------------------------------------------------------------------------

त्रिघात-एकम् : (x : C₃) → g ∘ (g ∘ (g ∘ x)) ≡ x
त्रिघात-एकम् e₀ = refl
त्रिघात-एकम् g  = refl
त्रिघात-एकम् g² = refl

आवृत्तिः : (n : ℕ) → powg (3 + n) ≡ powg n
आवृत्तिः n = त्रिघात-एकम् (powg n)

-- the flow itself, and its conservation witness
आवृत्ति-प्रवाहः : ℕ → ℕ
आवृत्ति-प्रवाहः n = 3 + n

आवृत्ति-संरक्षणम् : संरक्षणम् powg आवृत्ति-प्रवाहः
आवृत्ति-संरक्षणम् = आवृत्तिः

------------------------------------------------------------------------
-- ३ · TWO FLOWS, SO NOT A POINT.  The identity flow and the period flow
--     are both conserving and are distinct at 0.
------------------------------------------------------------------------

एक-प्रवाहः : Σ[ Φ ∈ (ℕ → ℕ) ] संरक्षणम् powg Φ
एक-प्रवाहः = idfun ℕ , λ _ → refl

आवृत्ति-प्रवाह-युग्मम् : Σ[ Φ ∈ (ℕ → ℕ) ] संरक्षणम् powg Φ
आवृत्ति-प्रवाह-युग्मम् = आवृत्ति-प्रवाहः , आवृत्ति-संरक्षणम्

द्वौ-प्रवाहौ : ¬ (एक-प्रवाहः ≡ आवृत्ति-प्रवाह-युग्मम्)
द्वौ-प्रवाहौ p = znots (cong (λ σ → σ .fst 0) p)

घात-न-शून्य-भारः : ¬ isContr (Σ[ Φ ∈ (ℕ → ℕ) ] संरक्षणम् powg Φ)
घात-न-शून्य-भारः c =
  द्वौ-प्रवाहौ (sym (c .snd एक-प्रवाहः) ∙ c .snd आवृत्ति-प्रवाह-युग्मम्)

------------------------------------------------------------------------
-- ४ · THE COROLLARY.  So the power map is not an instruction of this
--     machine — not "hard to invert", but not in the instruction set at
--     all, and §२ names by how much: its own period.
------------------------------------------------------------------------

घातः-न-आज्ञा : ¬ (Σ[ p ∈ Program ℕ C₃ ] (चालनम् p ≡ powg))
घातः-न-आज्ञा (p , q) =
  घात-न-शून्य-भारः
    (subst (λ h → isContr (Σ[ Φ ∈ (ℕ → ℕ) ] संरक्षणम् h Φ)) q
           (यन्त्र-शून्य-भारः p))

------------------------------------------------------------------------
-- ५ · शेषः — the limits of the reading in the header.
--
-- `वासः powg` carries आवृत्ति-प्रवाह-युग्मम् to the section
-- `a ↦ (3 + a , आवृत्तिः a)`: at every exponent, the next exponent with
-- the same public value.  That section is a point of the same fibre
-- family whose non-contractibility at ε is `GhataTantu.तन्तुः-द्विपदः`.
-- The two are the same family; the sentence "the ambiguity and the
-- symmetry are one object" says that and no more.
--
-- NOT settled here: that the flow space is EXACTLY the ℤ/3 of
-- translations — §३ exhibits two flows and refutes contractibility; it
-- does not compute the space, and the sections of a fibre family over ℕ
-- are far larger than the translations (any pointwise choice will do).
-- Computing it needs the fibres identified uniformly in `a`, which is
-- `GhataTantu`'s owed general coset statement.  §३ is a witness, not a
-- census.
--
-- NOT settled here: anything about C₃'s successors.  §२'s `refl` is a
-- fact about this group's definitional behaviour and is not a proof that
-- translation-by-the-order conserves in any other cyclic group.
------------------------------------------------------------------------
