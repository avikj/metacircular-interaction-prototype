{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusPresentation — the corpus running the corpus's own mathematics
-- on its own checked declarations.
--
-- The cold-start handoff's flow, realised with EXISTING machinery only:
--
--   checked declaration
--     ── reflection only (ReflectedFormation) ──▶ formed presentation
--     ── native checked actions/observations   ──▶ FutureBehavior machine
--     ── greatest behavioural congruence        ──▶ Meaning
--
--   and losslessly     formed presentations ≃ Σ_{m : Meaning} RealizationFiber(m).
--
-- WHAT IS FORMED.  A formed presentation is a reflected `Term` — inert,
-- first-class data after elaboration.  No second execution/certificate
-- representation is created; the states ARE the reflected syntax.
--
-- THE ACTIONS ARE CHECKED, NOT SYNTHETIC.  The only action is structural
-- descent into an argument position (`step t n` = the n-th argument's
-- term).  It is a total pure function of the reflected syntax — a
-- checked observation context, in the spirit of IntrinsicRewrite's
-- Locus/plug — NOT a similarity metric or an invented distance.
--
-- THE OBSERVATION IS SET-VALUED.  `headCode` reads the outermost shape
-- of a term as a natural number (a set), so `isSetℕ` discharges
-- FutureBehavior's `isSetObs`.
--
-- MEANING IS THE EXISTING QUOTIENT.  `Meaning = Term / FutureEq`, from
-- FutureBehavior.FutureQuotient — the greatest behavioural congruence.
-- No new minimiser, no MDL objective.  Two reflected terms are one
-- meaning exactly when every finite descent word yields the same head
-- shape: same observable syntactic unfolding.
--
-- THE REMAINDER IS AN EXACT FIBRE.  `RealizationFiber m = fiber pres m`,
-- and `lossless : Term ≃ Σ Meaning RealizationFiber` is the library's
-- `totalEquiv` — the fibre law (Carrier) for the presentation map.  No
-- distinction is erased: what the compact meaning drops sits, exactly,
-- in the fibre.  Effectivity (`realization-is-future-equality`) gives the
-- proof-relevant form: a path of meanings IS future equality.
--
-- THE PRESENT OBSERVATION IS EXACTLY WHAT DESCENDS.  Via FiniteInformation:
-- `headCode` is constant on future-equivalence fibres, so it factors
-- through the presentation (`headCode-factors`).  A demanded finer view
-- needs refinement precisely when it is NOT so constant.
--
-- Checked, --safe, at the pin (Agda 2.8.0, agda/cubical v0.9): EXIT 0.
------------------------------------------------------------------------

module CorpusPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)
open import Cubical.HITs.SetQuotients using (_/_ ; [_])
open import Cubical.Functions.Fibration using (totalEquiv)

open import Agda.Builtin.Reflection hiding (Type)
open import Agda.Builtin.List renaming (List to BList ; [] to bnil ; _∷_ to _b∷_)
open import Agda.Builtin.Unit

import FutureBehavior as FB
import FiniteInformation as FI
import RewriteCertificate as RC
open import ReflectedFormation using (Decl ; decl ; declType ; rawView)

------------------------------------------------------------------------
-- §1  Reflected syntax as formed state; the checked descent action.
------------------------------------------------------------------------

-- The observation: the outermost shape of a term, as a set (ℕ).
headCode : Term → ℕ
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
  argsOf : Term → BList (Arg Term)
  argsOf (var _ a)     = a
  argsOf (con _ a)     = a
  argsOf (def _ a)     = a
  argsOf (meta _ a)    = a
  argsOf (pat-lam _ a) = a
  argsOf _             = bnil

  nth : BList (Arg Term) → ℕ → Term
  nth bnil            _       = unknown
  nth (arg _ t b∷ _)  zero    = t
  nth (arg _ _ b∷ as) (suc n) = nth as n

-- One structural-descent step: the n-th subterm of the head.
step : Term → ℕ → Term
step t n = nth (argsOf t) n

------------------------------------------------------------------------
-- §2  The FutureBehavior machine over reflected syntax, and its Meaning.
------------------------------------------------------------------------

presentationMachine : FB.Machine ℓ-zero ℓ-zero ℓ-zero
presentationMachine = record
  { State    = Term
  ; Action   = ℕ
  ; Obs      = ℕ
  ; isSetObs = isSetℕ
  ; step     = step
  ; observe  = headCode
  }

open FB.FutureQuotient step isSetℕ headCode public
  -- brings: Meaning, _≈_, quotStep, quotObserve, []-effective,
  --         []-effectiveIso, quotBehavior, factor, factor-unique, …

-- The presentation map: a formed state to its compact meaning.
pres : Term → Meaning
pres x = [ x ]

------------------------------------------------------------------------
-- §3  The lossless decomposition — the fibre law for the presentation.
--
--   formed presentations ≃ Σ_{m : Meaning} RealizationFiber(m)
--
-- via the library's totalEquiv (HoTT 4.8.2), which is exactly Carrier's
-- Σ-law for the map `pres`.  Nothing is lost: the meaning is the base,
-- the residual proof-relevant choice is the fibre.
------------------------------------------------------------------------

RealizationFiber : Meaning → Type ℓ-zero
RealizationFiber m = fiber pres m

lossless : Term ≃ Σ Meaning RealizationFiber
lossless = totalEquiv pres

------------------------------------------------------------------------
-- §4  The proof-relevant future fibre: a path of meanings IS future
--     equality (effectivity), the checked analogue of
--     BisimClass(x) ≃ FutureViewFiber(x).
------------------------------------------------------------------------

realization-is-future-equality :
  (x y : Term) → (pres x ≡ pres y) → x ≈ y
realization-is-future-equality = []-effective

------------------------------------------------------------------------
-- §5  FiniteInformation bridge: the present observation is EXACTLY what
--     descends through the presentation.
------------------------------------------------------------------------

-- headCode is constant on future-equivalence fibres: identify two
-- presentations and their present observations already agreed.
headCode-fiberConstant : FI.FiberConstant pres headCode
headCode-fiberConstant x y p = []-effective x y p []

-- Therefore it factors through the compact presentation: no refinement
-- of the demanded present view is needed.  (A finer target would need
-- refinement exactly when this fails — FiniteInformation's dichotomy.)
headCode-factors : FI.FactorsThrough pres headCode
headCode-factors =
  FI.fiberConstant→factorsThrough isSetℕ pres headCode headCode-fiberConstant

-- The descent realised as the quotient's own present observation, and it
-- computes on representatives by refl.
presentObserve : Meaning → ℕ
presentObserve = factor isSetℕ headCode (λ h → h [])

presentObserve-[] : (x : Term) → presentObserve (pres x) ≡ headCode x
presentObserve-[] x = refl

------------------------------------------------------------------------
-- §6  End-to-end on REAL declarations.
--
-- `observeDecl ref` forms the named declaration by reflection, takes its
-- type as the formed state, and returns that state's present observation
-- in the machine — checked declaration ▶ formed presentation ▶ Obs of
-- FutureBehavior.  The refl tests fix the outputs, so a green proves the
-- pipeline executed on the corpus's own checked declarations.
------------------------------------------------------------------------

private
  headName : Term → TC Name
  headName (def n _) = returnTC n
  headName (con n _) = returnTC n
  headName _         = typeError (strErr "expected a defined-name reference" ∷ bnil)

macro
  -- checked declaration → reflected type Term (formed state) → headCode
  observeDecl : Term → Term → TC ⊤
  observeDecl ref hole =
    bindTC (headName ref)                         λ n →
    bindTC (decl n)                               λ d →
    bindTC (quoteTC (headCode (rawView d)))       λ r →
    unify hole r

-- RewriteCertificate.Tm is a datatype ⇒ its TYPE is a sort (headCode 6);
-- FutureBehavior.behavior is a function ⇒ its type is a pi (headCode 5).
-- Distinct outputs, both computed through the reflection→formation→observe
-- pipeline on the corpus's own checked declarations.
Tm-type-is-sort : observeDecl RC.Tm ≡ 6
Tm-type-is-sort = refl

behavior-type-is-pi : observeDecl FB.behavior ≡ 5
behavior-type-is-pi = refl
