{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusPresentation â” the corpus running the corpus's own mathematics
-- on its own checked declarations.
--
-- The flow, realised with EXISTING machinery only:
--
--   checked declaration
--     â”â” reflection only (ReflectedFormation) â”â”â– formed presentation
--     â”â” native checked actions/observations   â”â”â– MyhillNerodeMinimalMachine machine
--     â”â” greatest behavioural congruence        â”â”â– Meaning
--
--   and losslessly     formed presentations â‰ Î_{m : Meaning} RealizationFiber(m).
--
-- WHAT IS FORMED.  A formed presentation is a reflected `Term` â” inert,
-- first-class data after elaboration.  No second execution/certificate
-- representation is created; the states ARE the reflected syntax.
--
-- THE ACTIONS ARE CHECKED, NOT SYNTHETIC.  The only action is structural
-- descent into an argument position (`step t n` = the n-th argument's
-- term).  It is a total pure function of the reflected syntax â” a
-- checked observation context, in the spirit of IntrinsicRewrite's
-- Locus/plug â” NOT a similarity metric or an invented distance.
--
-- THE OBSERVATION IS SET-VALUED.  `headCode` reads the outermost shape
-- of a term as a natural number (a set), so `isSetâ•` discharges
-- MyhillNerodeMinimalMachine's `isSetObs`.
--
-- MEANING IS THE EXISTING QUOTIENT.  `Meaning = Term / NerodeCongruence`, from
-- MyhillNerodeMinimalMachine.MinimalMachine â” the greatest behavioural congruence.
-- No new minimiser, no MDL objective.  Two reflected terms are one
-- meaning exactly when every finite descent word yields the same head
-- shape: same observable syntactic unfolding.
--
-- THE REMAINDER IS AN EXACT FIBRE.  `RealizationFiber m = fiber pres m`,
-- and `lossless : Term â‰ Î Meaning RealizationFiber` is the library's
-- `totalEquiv` â” the fibre law (Carrier) for the presentation map.  No
-- distinction is erased: what the compact meaning drops sits, exactly,
-- in the fibre.  Effectivity (`realization-is-future-equality`) gives the
-- proof-relevant form: a path of meanings IS future equality.
--
-- THE PRESENT OBSERVATION IS EXACTLY WHAT DESCENDS.  Via FiniteInformation:
-- `headCode` is constant on future-equivalence fibres, so it factors
-- through the presentation (`headCode-factors`).  A demanded finer view
-- needs refinement precisely when it is NOT so constant.
------------------------------------------------------------------------

module CorpusPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; fiber)
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; isSetâ„•)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (Î£ ; _,_ ; fst ; snd)
open import Cubical.HITs.SetQuotients using (_/_ ; [_])
open import Cubical.Functions.Fibration using (totalEquiv)

open import Agda.Builtin.Reflection hiding (Type)
open import Agda.Builtin.List renaming (List to BList ; [] to bnil ; _âˆ·_ to _bâˆ·_)
open import Agda.Builtin.Unit

import MyhillNerodeMinimalMachine as FB
import FiniteInformation as FI
import RewriteCertificate as RC
open import ReflectedFormation using (Decl ; decl ; declType ; rawView)

------------------------------------------------------------------------
-- Â§1  Reflected syntax as formed state; the checked descent action.
------------------------------------------------------------------------

-- The observation: the outermost shape of a term, as a set (â•).
headCode : Term â†’ â„•
headCode (var _ _)     = 0
headCode (con _ _)     = 1
headCode (def _ _)     = 2
headCode (lam _ _)     = 3
headCode (pat-lam _ _) = 4
headCode (pi _ _)      = 5
headCode (agda-sort _) = 6
headCode (lit _)       = 7
headCode (meta _ _)    = 8
headCode unknown       = 9

-- The checked action: descend into an argument position.
private
  argsOf : Term â†’ BList (Arg Term)
  argsOf (var _ a)     = a
  argsOf (con _ a)     = a
  argsOf (def _ a)     = a
  argsOf (meta _ a)    = a
  argsOf (pat-lam _ a) = a
  argsOf _             = bnil

  nth : BList (Arg Term) â†’ â„• â†’ Term
  nth bnil            _       = unknown
  nth (arg _ t bâˆ· _)  zero    = t
  nth (arg _ _ bâˆ· as) (suc n) = nth as n

-- One structural-descent step: the n-th subterm of the head.
step : Term â†’ â„• â†’ Term
step t n = nth (argsOf t) n

------------------------------------------------------------------------
-- Â§2  The MyhillNerodeMinimalMachine machine over reflected syntax, and its Meaning.
------------------------------------------------------------------------

presentationMachine : FB.Machine â„“-zero â„“-zero â„“-zero
presentationMachine = record
  { State    = Term
  ; Action   = â„•
  ; Obs      = â„•
  ; isSetObs = isSetâ„•
  ; step     = step
  ; observe  = headCode
  }

open FB.MinimalMachine step isSetâ„• headCode public
  -- brings: Meaning, _â‰ˆ_, quotStep, quotObserve, nerodeCongruence-effective,
  --         nerodeCongruence-effectiveIso, quotBehavior, factor, factor-unique, â¦

-- The presentation map: a formed state to its compact meaning.
pres : Term â†’ Meaning
pres x = [ x ]

------------------------------------------------------------------------
-- Â§3  The lossless decomposition â” the fibre law for the presentation.
--
--   formed presentations â‰ Î_{m : Meaning} RealizationFiber(m)
--
-- via the library's totalEquiv (HoTT 4.8.2), which is exactly Carrier's
-- Î-law for the map `pres`.  Nothing is lost: the meaning is the base,
-- the residual proof-relevant choice is the fibre.
------------------------------------------------------------------------

RealizationFiber : Meaning â†’ Type â„“-zero
RealizationFiber m = fiber pres m

lossless : Term â‰ƒ Î£ Meaning RealizationFiber
lossless = totalEquiv pres

------------------------------------------------------------------------
-- Â§4  The proof-relevant future fibre: a path of meanings IS future
--     equality (effectivity), the checked analogue of
--     BisimClass(x) â‰ FutureViewFiber(x).
------------------------------------------------------------------------

realization-is-future-equality :
  (x y : Term) â†’ (pres x â‰¡ pres y) â†’ x â‰ˆ y
realization-is-future-equality = nerodeCongruence-effective

------------------------------------------------------------------------
-- Â§5  FiniteInformation bridge: the present observation is EXACTLY what
--     descends through the presentation.
------------------------------------------------------------------------

-- headCode is constant on future-equivalence fibres: identify two
-- presentations and their present observations already agreed.
headCode-fiberConstant : FI.FiberConstant pres headCode
headCode-fiberConstant x y p = nerodeCongruence-effective x y p []

-- Therefore it factors through the compact presentation: no refinement
-- of the demanded present view is needed.  (A finer target would need
-- refinement exactly when this fails â” FiniteInformation's dichotomy.)
headCode-factors : FI.FactorsThrough pres headCode
headCode-factors =
  FI.fiberConstantâ†’factorsThrough isSetâ„• pres headCode headCode-fiberConstant

-- The descent realised as the quotient's own present observation, and it
-- computes on representatives by refl.
presentObserve : Meaning â†’ â„•
presentObserve = factor isSetâ„• headCode (Î» h â†’ h [])

presentObserve-[] : (x : Term) â†’ presentObserve (pres x) â‰¡ headCode x
presentObserve-[] x = refl

------------------------------------------------------------------------
-- Â§6  End-to-end on REAL declarations.
--
-- `observeDecl ref` forms the named declaration by reflection, takes its
-- type as the formed state, and returns that state's present observation
-- in the machine â” checked declaration â– formed presentation â– Obs of
-- MyhillNerodeMinimalMachine.  The refl tests fix the outputs, so a green proves the
-- pipeline executed on the corpus's own checked declarations.
------------------------------------------------------------------------

private
  headName : Term â†’ TC Name
  headName (def n _) = returnTC n
  headName (con n _) = returnTC n
  headName _         = typeError (strErr "expected a defined-name reference" âˆ· bnil)

macro
  -- checked declaration â’ reflected type Term (formed state) â’ headCode
  observeDecl : Term â†’ Term â†’ TC âŠ¤
  observeDecl ref hole =
    bindTC (headName ref)                         Î» n â†’
    bindTC (decl n)                               Î» d â†’
    bindTC (quoteTC (headCode (rawView d)))       Î» r â†’
    unify hole r

-- RewriteCertificate.Tm is a datatype â’ its TYPE is a sort (headCode 6);
-- MyhillNerodeMinimalMachine.behavior is a function â’ its type is a pi (headCode 5).
-- Distinct outputs, both computed through the reflectionâ’formationâ’observe
-- pipeline on the corpus's own checked declarations.
Tm-type-is-sort : observeDecl RC.Tm â‰¡ 6
Tm-type-is-sort = refl

behavior-type-is-pi : observeDecl FB.behavior â‰¡ 5
behavior-type-is-pi = refl

------------------------------------------------------------------------
-- Â§7  The WHOLE corpus, formed and observed.
--
-- CorpusNames.corpusNames is every public declaration of every --safe
-- module (all of it minus must_fail).  `observeAll` folds the reflection
-- bridge over the entire list: for each name it forms the declaration
-- (getType), takes its type as the formed state, reads the machine's
-- present observation (headCode), and accumulates.  The single â• it
-- returns therefore DEPENDS ON observing every declaration; a green check
-- is proof the whole flow ran end-to-end over the entire corpus at once.
------------------------------------------------------------------------

open import CorpusNames using (corpusNames)

private
  observeAll : BList Name â†’ TC â„•
  observeAll bnil        = returnTC zero
  observeAll (n bâˆ· rest) =
    bindTC (decl n)         Î» d â†’
    bindTC (observeAll rest) Î» acc â†’
    returnTC (headCode (rawView d) + acc)

macro
  -- forces getType + headCode over the ENTIRE corpus at elaboration time.
  corpusObservationSum : Term â†’ TC âŠ¤
  corpusObservationSum hole =
    bindTC (observeAll corpusNames) Î» s â†’
    bindTC (quoteTC s)              Î» r â†’
    unify hole r

-- The whole corpus, formed and observed, as one checked natural number.
-- Its very construction runs the pipeline over all ~15k declarations.
corpusPresentationRuns : â„•
corpusPresentationRuns = corpusObservationSum
