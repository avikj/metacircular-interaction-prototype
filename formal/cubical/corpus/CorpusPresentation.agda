{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusPresentation
--
-- The corpus's self-presentation, from its own existing machinery:
--
--   checked declaration
--     --reflection only-->      formed presentation  (ReflectedFormation)
--     --checked contexts/actions--> FutureBehavior machine
--     --greatest behavioral congruence--> Meaning
--
-- and, losslessly,
--
--   formed presentations  ≃  Σ (m : Meaning) RealizationFiber m.
--
-- No new semantic theory is introduced.  The presentation quotient is
-- FutureBehavior.FutureQuotient.Meaning; the exact remainder is the
-- corresponding fibre; factorization (FiniteInformation) decides
-- whether a demanded view needs refinement; presentation changes of the
-- meaning codomain are invariant (ObservationPresentation);
-- TranscriptDescent decides when residual information can be erased;
-- LawfulContinuationCore names the shapes of residual fibres; and an
-- installed derivation (RewriteCertificate / IntrinsicRewrite) is a
-- checked path in Meaning — the explanation IS the path.
--
-- The literal Tm rewrite language is one concrete instance below
-- (KernelInstance), NOT the corpus: the deeper invariant is the
-- fibre/interaction calculus instantiated generically by `Present`.
------------------------------------------------------------------------

module CorpusPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; fiber)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ)
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit)
open import Cubical.HITs.SetQuotients using ([_] ; eq/)
open import Cubical.Relation.Nullary using (¬_)

open import Agda.Builtin.Reflection
  using (Name ; Term ; TC ; bindTC ; quoteTC ; unify)

import FutureBehavior as FB
import FiniteInformation as FI
import ObservationPresentation as OP
import ProductiveObservationFiber as POF
import ProductiveFiberQuotientAdapter as PFQ
import TranscriptDescent as TD
import CompositionalContextAdapter as CCA
import LawfulContinuationCore as LCC
import IntrinsicRewrite as IR
import RewriteCertificate as RC
import ProductiveIndraNet as PIN

import CorpusNames as CN
import ReflectedFormation as RF

------------------------------------------------------------------------
-- §1  The generic presentation of ANY observed machine.
--
-- States are formed presentations; actions are only the machine's own
-- checked actions; the presentation quotient is the existing
-- FutureQuotient.Meaning (no new minimality layer); the exact remainder
-- is the realization fibre.
------------------------------------------------------------------------

module Present {ℓX ℓA ℓO : Level} (M : FB.Machine ℓX ℓA ℓO) where

  open FB.Machine M
  open FB.MachineFutureBehavior M public
    -- Meaning, isSetMeaning, quotStep, quotObserve, quotRun-[],
    -- []-effective(Iso), quotBehavior(-injective), factor(-unique),
    -- crystal(-minimal/-sound/-fullyAbstract), Terminal, …

  -- compact meaning of one formed presentation
  present : State → Meaning
  present = [_]

  -- the exact proof-relevant remainder over one meaning locus
  RealizationFiber : Meaning → Type (ℓ-max ℓX (ℓ-max ℓA ℓO))
  RealizationFiber = fiber present

  -- LOSSLESSNESS:  compact meaning + exact realization fibre
  --                  ≃  full formed mathematics.
  presentation : Iso State (Σ[ m ∈ Meaning ] RealizationFiber m)
  Iso.fun presentation x = present x , x , refl
  Iso.inv presentation total = fst (snd total)
  Iso.rightInv presentation total i =
    snd (snd total) i , fst (snd total) , (λ j → snd (snd total) (i ∧ j))
  Iso.leftInv presentation x = refl

  presentation≃ : State ≃ (Σ[ m ∈ Meaning ] RealizationFiber m)
  presentation≃ = isoToEquiv presentation

  ----------------------------------------------------------------------
  -- The information lens on the presentation map.  A demanded target
  -- adds no independent information exactly when it is constant on
  -- current realization fibres; a lossless change of the meaning
  -- codomain's presentation preserves exactly what can descend.
  ----------------------------------------------------------------------

  module Lens {ℓT : Level} {T : Type ℓT} (setT : isSet T) (t : State → T) where

    noIndependentInformation :
      Iso (FI.FactorsThrough present t) (FI.FiberConstant present t)
    noIndependentInformation =
      FI.factorsThroughIsoFiberConstant setT present t

    presentationInvariance : {ℓZ : Level} {Z : Type ℓZ} (e : Meaning ≃ Z)
      → Iso (FI.FactorsThrough present t)
            (FI.FactorsThrough (equivFun e ∘ present) t)
    presentationInvariance e =
      OP.factorsThrough-postEquivIso setT present t e

    ----------------------------------------------------------------------
    -- The exact contraction rule: retain while reconstruction is
    -- obstructed; erase exactly when reconstruction exists.
    ----------------------------------------------------------------------

    retainWhileObstructed : {x x' : State}
      → present x ≡ present x'
      → ¬ (t x ≡ t x')
      → ¬ (FI.FactorsThrough present t)
    retainWhileObstructed = TD.collisionObstructsDecoder present t

    eraseWhenDetermined : {ℓR : Level} {R : Type ℓR} (r : State → R)
      → FI.FiberConstant present r
      → ((x x' : State) → present x ≡ present x' → r x ≡ r x' → t x ≡ t x')
      → FI.FactorsThrough present t
    eraseWhenDetermined r = TD.eraseDeterminedRecord setT present r t

  ----------------------------------------------------------------------
  -- Residual fibre shapes, in LawfulContinuationCore's vocabulary.
  -- A contractible (unique) fibre is zero independent residual choice;
  -- a branching fibre is retained proof-relevant mass.  No distinction
  -- is erased before this evidence exists.
  ----------------------------------------------------------------------

  Reconstructible : Meaning → Type (ℓ-max ℓX (ℓ-max ℓA ℓO))
  Reconstructible m = LCC.UniqueFiber (RealizationFiber m)

  Crowded : Meaning → Type (ℓ-max ℓX (ℓ-max ℓA ℓO))
  Crowded m = LCC.BranchingFiber (RealizationFiber m)

  reconstructible-not-crowded : (m : Meaning)
    → Reconstructible m → LCC.EmptyFiber (Crowded m)
  reconstructible-not-crowded m = LCC.unique-not-branching

  ----------------------------------------------------------------------
  -- The human-facing projection of one compact locus: provenance
  -- pointer, one exhibited realization, and replay of its meaning.
  -- Expansion traverses the actual fibre.
  ----------------------------------------------------------------------

  record MeaningLocus (m : Meaning) : Type (ℓ-max ℓX (ℓ-max ℓA ℓO)) where
    field
      provenance  : List Name
      realization : RealizationFiber m

    expand : State
    expand = fst realization

    replay : present expand ≡ m
    replay = snd realization

------------------------------------------------------------------------
-- §2  The reflected corpus machine.
--
-- States are formed reflected declarations (their checked reflected
-- syntax); actions are the structural navigation actions of
-- ReflectedFormation; the observation is the structural head code.
-- FutureEq is then agreement of observation along every finite
-- navigation address, and Meaning is its FutureQuotient — everything
-- the observation cannot see remains exactly in the fibre.
------------------------------------------------------------------------

SyntaxMachine : FB.Machine ℓ-zero ℓ-zero ℓ-zero
SyntaxMachine = record
  { State    = Term
  ; Action   = ℕ
  ; Obs      = ℕ
  ; isSetObs = isSetℕ
  ; step     = RF.child
  ; observe  = RF.headCode
  }

module Corpus = Present SyntaxMachine

-- A formed reflected declaration, as a state of the corpus machine, and
-- its compact meaning.
formedState : RF.Decl → Term
formedState = RF.rawView

meaningOf : RF.Decl → Corpus.Meaning
meaningOf d = Corpus.present (formedState d)

------------------------------------------------------------------------
-- §3  The bridge runs on the corpus's own checked declarations, at
-- typechecking time.  Every enumerated name is reached as a formed
-- presentation by reflection alone; the count below is computed by
-- actually forming all of them.
------------------------------------------------------------------------

private
  countAll : Term → TC Unit
  countAll hole =
    bindTC (RF.declAll CN.corpusNames) λ ds →
    bindTC (quoteTC (length ds)) λ t →
    unify hole t

  countRefsOf : Name → Term → TC Unit
  countRefsOf nm hole =
    bindTC (RF.decl nm) λ d →
    bindTC (quoteTC (length (RF.refs d))) λ t →
    unify hole t

macro
  corpusFormedCount : Term → TC Unit
  corpusFormedCount = countAll

  futureEqRefCount : Term → TC Unit
  futureEqRefCount = countRefsOf (quote FB.FutureEq)

-- All included checked declarations are reachable as formed
-- presentations: forming them succeeds, and covers the enumeration.
allNamesForm : ℕ
allNamesForm = corpusFormedCount

allNamesForm-covers : allNamesForm ≡ length CN.corpusNames
allNamesForm-covers = refl

-- One formed declaration's structural reference list, materialized
-- through the bridge (provenance only, no semantics).
futureEqRefs : ℕ
futureEqRefs = futureEqRefCount

------------------------------------------------------------------------
-- §4  The kernel instance: the literal Tm rewrite language, presented
-- through contextual closure.  One concrete instance of the calculus,
-- explicitly NOT identified with the corpus.
--
-- Actions are checked one-hole contexts of the kernel's own binary
-- operation; the observation is the kernel's checked evaluator at a
-- fixed environment.  Every semantic identification below is backed by
-- a checked inhabitant: a Run, a Derivation, an evaluator law.
------------------------------------------------------------------------

module KernelInstance where

  rho₀ : RC.Env
  rho₀ = RC.env 1 2 3 4 5 6

  observeTm : RC.Tm → ℕ
  observeTm t = RC.eval t rho₀

  TmMachine : FB.Machine ℓ-zero ℓ-zero ℓ-zero
  TmMachine = record
    { State    = RC.Tm
    ; Action   = CCA.ContextAction RC.Tm
    ; Obs      = ℕ
    ; isSetObs = isSetℕ
    ; step     = CCA.contextStep RC.add
    ; observe  = observeTm
    }

  module TmCorpus = Present TmMachine

  -- Contextual equality is the same relation as machine future
  -- equality, as an Iso of proof spaces (CompositionalContextAdapter).
  syntactic≃behavioral : (left right : RC.Tm)
    → Iso (CCA.SyntacticContextEq RC.add observeTm left right)
          (CCA.ContextEq RC.add observeTm left right)
  syntactic≃behavioral = CCA.syntactic-futureIso RC.add isSetℕ observeTm

  -- The binary operation itself descends to the presentation quotient.
  module TmContext = CCA.ContextQuotient RC.add isSetℕ observeTm

  addQ : TmCorpus.Meaning → TmCorpus.Meaning → TmCorpus.Meaning
  addQ = TmContext._opQ_

  ----------------------------------------------------------------------
  -- Checked inhabitants become checked identifications of meaning.
  ----------------------------------------------------------------------

  EvalEq : RC.Tm → RC.Tm → Type₀
  EvalEq s t = (rho : RC.Env) → RC.eval s rho ≡ RC.eval t rho

  evalEq-context : {s t : RC.Tm} → EvalEq s t
    → (a : CCA.ContextAction RC.Tm)
    → EvalEq (CCA.contextStep RC.add s a) (CCA.contextStep RC.add t a)
  evalEq-context h (false , fixed) rho = cong (_+ RC.eval fixed rho) (h rho)
  evalEq-context h (true  , fixed) rho = cong (RC.eval fixed rho +_) (h rho)

  evalEq→futureEq : {s t : RC.Tm} → EvalEq s t
    → FB.FutureEq (CCA.contextStep RC.add) observeTm s t
  evalEq→futureEq h []      = h rho₀
  evalEq→futureEq h (a ∷ w) = evalEq→futureEq (evalEq-context h a) w

  -- An intrinsic formed execution identifies its endpoints in Meaning:
  -- execution and correctness are eliminations of the same object, and
  -- that object is the checked inhabitant behind the identification.
  runMeaning : {t : RC.Tm} (r : IR.Run t)
    → Path TmCorpus.Meaning [ t ] [ IR.result r ]
  runMeaning r = eq/ _ _ (evalEq→futureEq (IR.run-sound r))

  -- An installed derivation is future capability: it identifies the two
  -- endpoints for every future context, while the derivation itself is
  -- retained as the trace.
  derivationMeaning : {a b : RC.Tm} → RC.Derivation a b
    → Path TmCorpus.Meaning [ a ] [ b ]
  derivationMeaning d = eq/ _ _ (evalEq→futureEq (RC.derivation-sound d))

  -- A cross-domain explanation is an actual checked path: this one is
  -- the kernel's own two-motion execution, traversed, not summarized.
  explanation :
    Path TmCorpus.Meaning [ RC.add RC.var (RC.suc RC.zero) ] [ RC.suc RC.var ]
  explanation = runMeaning IR.add-one

------------------------------------------------------------------------
-- §5  The productive remainder.  Complete future observation retains
-- its exact proof-relevant fibre (no truncation), and that fibre maps
-- to — without being identified with — set-level future meaning.
------------------------------------------------------------------------

module ProductiveRemainder {Root Jewel : Type₀} where

  completeFutureExactness : (center : PIN.Net Root Jewel)
    → POF.BisimClass center ≃ POF.FutureViewFiber center
  completeFutureExactness = POF.bisimClass≃futureViewFiber

  module ToMeaning (setJewel : isSet Jewel) where
    open PFQ.Adapter {Root} {Jewel} setJewel public
      -- fiberToMeaning, fiberToCenter, fiberToMeaning-constant
