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
-- NaturalMachine.TheImpossibilityNeedsNeitherHPropNorEveryRepresentative
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- `notes/` grepped.  **No tradition term is claimed and none is
-- invented.**  Set-quotients and transport along `eq/` are Voevodsky's
-- substrate, which this repository declares as a tool and not a frame;
-- the threshold predicates are this corpus's own.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  Target: `TheRateQuotientExistsAndMinimalityCannotLiveOnIt`.
-- Two claim-words.
--
-- **`EXISTS` IS EARNED OUTRIGHT** — `Rate = (ℕ × ℕ) / _≈_` is
-- constructed, and `atLeastOnRateComputes` shows the lift is not a
-- relabelling.
--
-- **`CANNOT` IS EARNED AND IS ALREADY NON-VACUOUS**, which diagnostic
-- (3) asks first.  It is a LOCATION claim — minimality cannot live ON
-- the quotient — and the constrained thing exists downstairs:
-- `shortIsMinimalAtOneHalf` and `shortIsNotMinimalAtTwoQuarters` are
-- both in hand.  Unlike `CurvatureCannotLive…` (cc8a3e16), this one
-- needed no witness supplied from outside.
--
-- **THE FAULT IS THAT THE IMPOSSIBILITY IS STATED FOR A NARROWER CLASS
-- OF WOULD-BE DEFINITIONS THAN IT NEEDS, AND THE MODULE NAMES THAT
-- NARROWNESS AS A LIMIT INSTEAD OF REMOVING IT.**  Its §"WHAT IS STILL
-- NOT CLAIMED" says:
--
--   "The impossibility theorem is about functions into `hProp`; a
--    would-be `Minimal` landing in an arbitrary `Type` is not covered,
--    and could not be lifted by `rec` anyway."
--
-- The first clause is a real gap and the second is a red herring that
-- makes the gap look necessary.  **`SQ.rec` needing a set target
-- constrains how such an `M` could be BUILT; the impossibility theorem
-- quantifies over every `M` and does not care how it was built.**  And
-- the proof never touches the h-level: it is `cong` along `eq/`, and
-- `⟨_⟩` appears only to extract a carrier that need not have been
-- wrapped.
--
-- **AND THE HYPOTHESIS IS STRONGER THAN NEEDED IN A SECOND WAY.**  The
-- audited statement assumes agreement at EVERY representative and EVERY
-- population.  The proof uses two representatives and one population.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   twoRepresentativesSuffice
--       the sharp form: any `M : Rate → List Bool → Type` agreeing with
--       `Minimal` at `oneHalf` and at `twoQuarters`, on the single
--       population `short`, is contradictory.  No h-level, no
--       universally quantified agreement.
--   noMinimalityAtAnyTarget
--       hence the `Type`-valued impossibility the audited module says
--       is not covered
--   theHPropVersionIsAnInstance
--       and its own theorem, recovered by composing with `⟨_⟩` — so
--       nothing there is lost and the narrower statement is visibly a
--       special case
--
-- WHAT IS NOT CLAIMED.  Nothing new about `Rate` itself: no arithmetic,
-- no normal form, no decidability of `≈`, no lowest-terms section.
-- DENSITY and the mediant are untouched — the audited module's own
-- append settles those and its open item (whether `mediant` descends)
-- stays open.  Nothing here says a `Type`-valued `M` could be
-- CONSTRUCTED — it could not be, by `rec`; the point is that the
-- impossibility does not depend on how it would be.  `short`,
-- `oneHalf`, `twoQuarters` and their two minimality facts are imported
-- unchanged and nothing re-proves them.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheImpossibilityNeedsNeitherHPropNorEveryRepresentative where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels using (hProp)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import NaturalMachine.WhichThresholdStatementsDescendToTheRate
  using (_≈_ ; Minimal ; oneHalf ; twoQuarters ; oneHalfIsTwoQuarters
        ; shortIsMinimalAtOneHalf ; shortIsNotMinimalAtTwoQuarters)
open import NaturalMachine.MinimalityOfABoundaryPopulationNeedsLowestTerms
  using (short)
open import NaturalMachine.TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)

------------------------------------------------------------------------
-- 1.  The sharp form: two representatives, one population, any target
------------------------------------------------------------------------

twoRepresentativesSuffice :
  (M : Rate → List Bool → Type)
  → M [ oneHalf ]     short ≡ Minimal oneHalf     short
  → M [ twoQuarters ] short ≡ Minimal twoQuarters short
  → ⊥
twoRepresentativesSuffice M agree₁ agree₂ =
  shortIsNotMinimalAtTwoQuarters (transport chain shortIsMinimalAtOneHalf)
  where
    same : Path Rate [ oneHalf ] [ twoQuarters ]
    same = eq/ oneHalf twoQuarters oneHalfIsTwoQuarters

    step : M [ oneHalf ] short ≡ M [ twoQuarters ] short
    step = cong (λ r → M r short) same

    chain : Minimal oneHalf short ≡ Minimal twoQuarters short
    chain = sym agree₁ ∙ step ∙ agree₂

------------------------------------------------------------------------
-- 2.  So the Type-valued impossibility, said to be uncovered, is free
------------------------------------------------------------------------

noMinimalityAtAnyTarget :
  (M : Rate → List Bool → Type)
  → ((a : ℕ × ℕ) (bs : List Bool) → M [ a ] bs ≡ Minimal a bs)
  → ⊥
noMinimalityAtAnyTarget M agrees =
  twoRepresentativesSuffice M
    (agrees oneHalf short) (agrees twoQuarters short)

------------------------------------------------------------------------
-- 3.  And the audited theorem is a special case, by composing with ⟨_⟩
------------------------------------------------------------------------

theHPropVersionIsAnInstance :
  (M : Rate → List Bool → hProp ℓ-zero)
  → ((a : ℕ × ℕ) (bs : List Bool) → ⟨ M [ a ] bs ⟩ ≡ Minimal a bs)
  → ⊥
theHPropVersionIsAnInstance M agrees =
  noMinimalityAtAnyTarget (λ r bs → ⟨ M r bs ⟩) agrees
