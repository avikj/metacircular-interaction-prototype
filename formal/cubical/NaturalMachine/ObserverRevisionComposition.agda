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
-- NaturalMachine.ObserverRevisionComposition
--
-- Exact Cubical adapter for composition of finite observer revisions.
-- A revision carries states backwards and probes forwards.  Pointwise
-- response preservation composes by path composition.  With decidable
-- equality of response values, a composite defect lies in the union of the
-- two stage defects.
--
-- The final three-value control kills the scalar translation in which only
-- the two Boolean stage-defect flags are retained.  The chains 0 -> 1 -> 0
-- and 0 -> 1 -> 2 have identical stage flags and different composite flags,
-- so no function Bool x Bool -> Bool can reconstruct composition in general.
------------------------------------------------------------------------

module NaturalMachine.ObserverRevisionComposition where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; isSetBool)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.FiniteInformation as FI

private
  variable
    ℓX₀ ℓX₁ ℓX₂ ℓQ₀ ℓQ₁ ℓQ₂ ℓV ℓS : Level
    X₀ : Type ℓX₀
    X₁ : Type ℓX₁
    X₂ : Type ℓX₂
    Q₀ : Type ℓQ₀
    Q₁ : Type ℓQ₁
    Q₂ : Type ℓQ₂
    V  : Type ℓV

------------------------------------------------------------------------
-- 1.  Observer revisions and their exact composition
------------------------------------------------------------------------

-- The response type is shared.  State maps are contravariant and probe maps
-- covariant, exactly as in the finite observer-revision theorem.
record Revision
    {X₀ : Type ℓX₀} {Q₀ : Type ℓQ₀}
    {X₁ : Type ℓX₁} {Q₁ : Type ℓQ₁}
    {V : Type ℓV}
    (oldResponse : Q₀ → X₀ → V)
    (newResponse : Q₁ → X₁ → V)
    : Type (ℓ-max (ℓ-max ℓX₀ ℓX₁) (ℓ-max ℓQ₀ ℓQ₁)) where
  field
    stateMap : X₁ → X₀
    probeMap : Q₀ → Q₁

open Revision public

composeRevision :
    {oldResponse : Q₀ → X₀ → V}
    {middleResponse : Q₁ → X₁ → V}
    {newResponse : Q₂ → X₂ → V}
  → Revision oldResponse middleResponse
  → Revision middleResponse newResponse
  → Revision oldResponse newResponse
composeRevision first second = record
  { stateMap = λ state → stateMap first (stateMap second state)
  ; probeMap = λ probe → probeMap second (probeMap first probe)
  }

PreservesAt :
    {oldResponse : Q₀ → X₀ → V}
    {newResponse : Q₁ → X₁ → V}
  → Revision oldResponse newResponse → Q₀ → X₁ → Type _
PreservesAt {oldResponse = oldResponse} {newResponse = newResponse}
  revision probe state =
  oldResponse probe (stateMap revision state)
    ≡ newResponse (probeMap revision probe) state

DefectiveAt :
    {oldResponse : Q₀ → X₀ → V}
    {newResponse : Q₁ → X₁ → V}
  → Revision oldResponse newResponse → Q₀ → X₁ → Type _
DefectiveAt revision probe state = ¬ PreservesAt revision probe state

-- Exact preservation needs the intermediate response value: the two paths
-- meet there and compose.  No finiteness, set truncation, or decidability is
-- used in this direction.
preservation-composes :
    {oldResponse : Q₀ → X₀ → V}
    {middleResponse : Q₁ → X₁ → V}
    {newResponse : Q₂ → X₂ → V}
    (first : Revision oldResponse middleResponse)
    (second : Revision middleResponse newResponse)
    (probe : Q₀) (state : X₂)
  → PreservesAt first probe (stateMap second state)
  → PreservesAt second (probeMap first probe) state
  → PreservesAt (composeRevision first second) probe state
preservation-composes first second probe state first-ok second-ok =
  first-ok ∙ second-ok

DecidableEquality : Type ℓV → Type ℓV
DecidableEquality V =
  (left right : V) → (left ≡ right) ⊎ (¬ (left ≡ right))

-- Pointwise form of
--
--   D(composite) ⊆ pullback D(first) ∪ D(second).
--
-- The prose theorem concerns finite response tables, hence decidable
-- equality.  The assumption is exposed here rather than silently importing
-- excluded middle from the set-theoretic statement.
composite-defect-contained :
    {oldResponse : Q₀ → X₀ → V}
    {middleResponse : Q₁ → X₁ → V}
    {newResponse : Q₂ → X₂ → V}
  → DecidableEquality V
  → (first : Revision oldResponse middleResponse)
  → (second : Revision middleResponse newResponse)
  → (probe : Q₀) (state : X₂)
  → DefectiveAt (composeRevision first second) probe state
  → DefectiveAt first probe (stateMap second state)
      ⊎ DefectiveAt second (probeMap first probe) state
composite-defect-contained
  {oldResponse = oldResponse} {middleResponse = middleResponse}
  decide first second probe state composite-defect
  with decide
    (oldResponse probe (stateMap first (stateMap second state)))
    (middleResponse (probeMap first probe) (stateMap second state))
... | inl first-ok =
  inr (λ second-ok → composite-defect (first-ok ∙ second-ok))
... | inr first-defect = inl first-defect

------------------------------------------------------------------------
-- 2.  Minimal cancellation and persistence controls
------------------------------------------------------------------------

data Response₃ : Type₀ where
  zero one two : Response₃

responseTag : Response₃ → Bool × Bool
responseTag zero = false , false
responseTag one  = false , true
responseTag two  = true  , false

zero≢one : ¬ (zero ≡ one)
zero≢one equality = false≢true (cong snd (cong responseTag equality))

one≢zero : ¬ (one ≡ zero)
one≢zero equality = false≢true (sym (cong snd (cong responseTag equality)))

one≢two : ¬ (one ≡ two)
one≢two equality = false≢true (cong fst (cong responseTag equality))

zero≢two : ¬ (zero ≡ two)
zero≢two equality = false≢true (cong fst (cong responseTag equality))

unitResponse : Response₃ → Unit → Unit → Response₃
unitResponse value _ _ = value

unitRevision : (old new : Response₃)
  → Revision (unitResponse old) (unitResponse new)
unitRevision old new = record
  { stateMap = λ _ → tt
  ; probeMap = λ _ → tt
  }

recovery-first-defective :
  DefectiveAt (unitRevision zero one) tt tt
recovery-first-defective = zero≢one

recovery-second-defective :
  DefectiveAt (unitRevision one zero) tt tt
recovery-second-defective = one≢zero

-- Both stage squares fail, but their mismatches cancel in the composite.
recovery-composite-preserved :
  PreservesAt
    (composeRevision (unitRevision zero one) (unitRevision one zero)) tt tt
recovery-composite-preserved = refl

persistent-first-defective :
  DefectiveAt (unitRevision zero one) tt tt
persistent-first-defective = zero≢one

persistent-second-defective :
  DefectiveAt (unitRevision one two) tt tt
persistent-second-defective = one≢two

-- The same two stage-failure verdicts can instead leave a composite defect.
persistent-composite-defective :
  DefectiveAt
    (composeRevision (unitRevision zero one) (unitRevision one two)) tt tt
persistent-composite-defective = zero≢two

------------------------------------------------------------------------
-- 3.  Boolean stage ledgers do not determine composition
------------------------------------------------------------------------

defectFlag : Response₃ → Response₃ → Bool
defectFlag zero zero = false
defectFlag one  one  = false
defectFlag two  two  = false
defectFlag _    _    = true

stageFlags : Response₃ → Response₃ → Response₃ → Bool × Bool
stageFlags old middle new =
  defectFlag old middle , defectFlag middle new

compositeFlag : Response₃ → Response₃ → Response₃ → Bool
compositeFlag old middle new = defectFlag old new

recovery-stage-flags : stageFlags zero one zero ≡ (true , true)
recovery-stage-flags = refl

persistent-stage-flags : stageFlags zero one two ≡ (true , true)
persistent-stage-flags = refl

recovery-composite-flag : compositeFlag zero one zero ≡ false
recovery-composite-flag = refl

persistent-composite-flag : compositeFlag zero one two ≡ true
persistent-composite-flag = refl

StageDecoderLaw : (Bool × Bool → Bool) → Type₀
StageDecoderLaw decode =
  (old middle new : Response₃)
  → decode (stageFlags old middle new) ≡ compositeFlag old middle new

-- This kills the unsound translation, for every proposed Boolean decoder.
-- The contradiction uses the same input `(true , true)` with two required
-- outputs.  Keeping the intermediate response value is therefore not an
-- implementation detail: it is information absent from the scalar ledger.
no-stage-defect-decoder :
  (decode : Bool × Bool → Bool) → ¬ StageDecoderLaw decode
no-stage-defect-decoder decode law =
  false≢true
    (sym (law zero one zero) ∙ law zero one two)

------------------------------------------------------------------------
-- 4.  Exact criterion for any proposed response-span summary
------------------------------------------------------------------------

ResponseSpan : Type₀
ResponseSpan = Response₃ × (Response₃ × Response₃)

stageSummary : ResponseSpan → Bool × Bool
stageSummary (old , middle , new) = stageFlags old middle new

compositeTarget : ResponseSpan → Bool
compositeTarget (old , middle , new) = compositeFlag old middle new

-- A supplied summary determines composite defects exactly when the target
-- factors through its realized image.  This reuses the repository's
-- choice-free image factorization rather than inventing a second quotient.
DeterminesComposite : {S : Type ℓS} → (ResponseSpan → S) → Type _
DeterminesComposite summary = FI.FactorsThrough summary compositeTarget

-- Kernel criterion: a summary is sufficient iff the composite flag is
-- constant on every one of its fibers.  The decoder lives only on the
-- realized image, so no arbitrary default or choice is hidden here.
summary-kernel-criterion : {S : Type ℓS} (summary : ResponseSpan → S)
  → Iso (DeterminesComposite summary)
      (FI.FiberConstant summary compositeTarget)
summary-kernel-criterion summary =
  FI.factorsThroughIsoFiberConstant isSetBool summary compositeTarget

recoverySpan : ResponseSpan
recoverySpan = zero , one , zero

persistentSpan : ResponseSpan
persistentSpan = zero , one , two

same-stage-summary : stageSummary recoverySpan ≡ stageSummary persistentSpan
same-stage-summary = refl

different-composite-target :
  ¬ (compositeTarget recoverySpan ≡ compositeTarget persistentSpan)
different-composite-target = false≢true

-- The Boolean pair fails the exact kernel criterion on the same collision
-- that killed total Boolean decoders above.  This form applies even when a
-- decoder is permitted to exist only on actually realized summaries.
stage-summary-does-not-determine :
  ¬ DeterminesComposite stageSummary
stage-summary-does-not-determine determines =
  different-composite-target
    (FI.factorsThrough→fiberConstant
      stageSummary compositeTarget determines
      recoverySpan persistentSpan same-stage-summary)

-- Positive control: retaining the complete comparison span is sufficient.
-- The theorem does not assert that this is a minimal sufficient summary.
full-span-determines : DeterminesComposite (λ span → span)
full-span-determines =
  FI.fiberConstant→factorsThrough isSetBool
    (λ span → span) compositeTarget
    (λ left right same → cong compositeTarget same)
