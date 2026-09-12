{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusSelfPresentation
--
-- The corpus calculus already gives the universal interactive object:
--
--   Point ℓ          = Σ[ A ∈ Type ℓ ] A
--   Question (A , a) = Σ[ B ∈ Type ℓ ] (A → B)
--
-- and Prashna gives the coinductive machine:
--
--   respond : (q : Q s) → Σ s' . E s q s' × ISC S Q E s'.
--
-- CorpusLosslessPresentation says every question f : A → B is exactly
-- the lossless presentation A ≃ Σ b . fiber f b.  This module wires those
-- two existing facts together: every response carries BOTH the visible
-- target and the exact source fibre, then continues coinductively from the
-- target.  Nothing is reconstructed from files, names, imports, or syntax.
--
-- CorpusTraceCompression closes the loop: any finite dependent interaction
-- trace compiles to one Question at the original point.  `install` below is
-- literally that compile map, so a traversed history becomes a native future
-- interaction of the SAME calculus.  The compiled question has exactly the
-- same endpoint and inherits the exact source fibre.
--
-- Thus the single object `present s` is the desired lossless productive
-- presentation at s:
--
--   question
--      ↦ visible answer
--      × exact residual fibre
--      × next productive presentation
--
-- and a finite path through it can be folded back into the question space.
------------------------------------------------------------------------

module CorpusSelfPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse
  using (ISC ; respond)

import CorpusCalculus as C
import CorpusLosslessPresentation as LP
import CorpusTraceCompression as TC

private
  variable
    ℓ ℓt : Level

------------------------------------------------------------------------
-- One response is a visible target together with the exact residual.
------------------------------------------------------------------------

Event : {ℓ : Level}
      → (s : C.Point ℓ)
      → C.Question s
      → C.Point ℓ
      → Type (ℓ-suc ℓ)
Event s q s' = (C.target s q ≡ s') × LP.Residual s q

SelfPresentation : {ℓ : Level} → C.Point ℓ → Type (ℓ-suc ℓ)
SelfPresentation {ℓ} = ISC (C.Point ℓ) C.Question Event

-- The whole productive object.  For every typed question, return its visible
-- target, the fibre point witnessing which source realization produced that
-- answer, and the same presentation continued at the target.
present : {ℓ : Level} (s : C.Point ℓ) → SelfPresentation s
respond (present s) q =
  C.target s q ,
  (refl , LP.current-residual s q) ,
  present (C.target s q)

------------------------------------------------------------------------
-- Readouts of one productive response.
------------------------------------------------------------------------

next : {s : C.Point ℓ} → C.Question s → C.Point ℓ
next {s = s} q = fst (respond (present s) q)

next-is-target : {s : C.Point ℓ} (q : C.Question s)
               → next q ≡ C.target s q
next-is-target q = refl

residual : {s : C.Point ℓ} (q : C.Question s)
         → LP.Residual s q
residual {s = s} q = snd (fst (snd (respond (present s) q)))

residual-is-source : {s : C.Point ℓ} (q : C.Question s)
                   → residual q ≡ LP.current-residual s q
residual-is-source q = refl

continue : {s : C.Point ℓ} (q : C.Question s)
         → SelfPresentation (C.target s q)
continue {s = s} q = snd (snd (respond (present s) q))

continue-is-present : {s : C.Point ℓ} (q : C.Question s)
                    → continue q ≡ present (C.target s q)
continue-is-present q = refl

------------------------------------------------------------------------
-- Exact refinement criterion, inherited from the finite-information kernel.
------------------------------------------------------------------------

Descends : (s : C.Point ℓ) (q : C.Question s)
         {T : Type ℓt} → (LP.Source s → T) → Type _
Descends = LP.Descends

NeedsRefinement : (s : C.Point ℓ) (q : C.Question s)
                {T : Type ℓt} → (LP.Source s → T) → Type _
NeedsRefinement s q t = ¬ Descends s q t

-- If a demanded read descends, it is already a function of the visible
-- presentation.  Equivalently (for set-valued targets), it is constant on
-- every residual fibre.  This is the exact no-refinement criterion.
descends-iff-constant-on-residual :
    (s : C.Point ℓ) (q : C.Question s)
    {T : Type ℓt} (isSetT : isSet T) (t : LP.Source s → T)
  → Iso (Descends s q t) (LP.ConstantOnResidual s q t)
descends-iff-constant-on-residual = LP.descends-iff-constant-on-residual

------------------------------------------------------------------------
-- Finite history becomes a native future interaction.
------------------------------------------------------------------------

Trace : C.Point ℓ → Type (ℓ-suc ℓ)
Trace = TC.Trace

endpoint : {s : C.Point ℓ} → Trace s → C.Point ℓ
endpoint = TC.endpoint

-- Installation is not a foreign operation: the compiled trace lands back in
-- the same dependent Question type admitted by `present`.
install : {s : C.Point ℓ} → Trace s → C.Question s
install = TC.compile

install-target : {s : C.Point ℓ} (trace : Trace s)
               → C.target s (install trace) ≡ endpoint trace
install-target = TC.compile-target

-- Asking the installed history is therefore immediately another step of the
-- same coinductive self-presentation.
installed-next : {s : C.Point ℓ} (trace : Trace s) → C.Point ℓ
installed-next {s = s} trace = next (install trace)

installed-next-is-endpoint : {s : C.Point ℓ} (trace : Trace s)
                           → installed-next trace ≡ endpoint trace
installed-next-is-endpoint trace = install-target trace

-- The contraction of the entire finite history is lossless: source ≃ visible
-- composite result plus its exact fibre.
installed-lossless : {s : C.Point ℓ} (trace : Trace s)
                   → LP.Source s ≃ LP.Presentation s (install trace)
installed-lossless = TC.trace-lossless

------------------------------------------------------------------------
-- Compact identity of the wired object.
------------------------------------------------------------------------

-- `present` is productive; `install` returns to its own question space; and
-- each visible projection carries the exact residual required to reconstruct
-- the source.  These three terms are the closed self-presentation loop:
--
--   present : Point → SelfPresentation Point
--   install : Trace Point → Question Point
--   installed-lossless : Source ≃ Σ visible . fiber
--
-- Nothing else is required to make the calculus self-presenting.
------------------------------------------------------------------------
