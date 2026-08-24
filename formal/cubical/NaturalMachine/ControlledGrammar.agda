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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.ControlledGrammar where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_ ; map ; length)
open import Cubical.Data.Nat using (suc)

open import NaturalMachine.RewriteCertificate using (Tm ; Derivation)

record NativeOperation : Type₁ where
  field
    source target : Tm
    checked : Derivation source target
    Control : Tm → Type₀
    control-sound : {t : Tm} → Control t → t ≡ source

  apply : (t : Tm) → Control t → Tm
  apply _ _ = target

  apply-checked : (t : Tm) (c : Control t) → Derivation t (apply t c)
  apply-checked t c =
    subst (λ q → Derivation q target) (sym (control-sound c)) checked

-- Installing a theorem does not make it globally applicable. Its native
-- control is exactly evidence that the current term is its certified source.
install : {lhs rhs : Tm} → Derivation lhs rhs → NativeOperation
NativeOperation.source (install {lhs} d) = lhs
NativeOperation.target (install {rhs = rhs} d) = rhs
NativeOperation.checked (install d) = d
NativeOperation.Control (install {lhs} d) t = t ≡ lhs
NativeOperation.control-sound (install d) c = c

record EnabledFuture (seed : Tm) : Type₁ where
  field
    operation : NativeOperation
    control : NativeOperation.Control operation seed

  target : Tm
  target = NativeOperation.apply operation seed control

  derivation : Derivation seed target
  derivation = NativeOperation.apply-checked operation seed control

record CheckedFuture (seed : Tm) : Type₀ where
  field
    target : Tm
    derivation : Derivation seed target

execute : {seed : Tm} → EnabledFuture seed → CheckedFuture seed
CheckedFuture.target (execute f) = EnabledFuture.target f
CheckedFuture.derivation (execute f) = EnabledFuture.derivation f

-- Parallel advance maps branches without quotienting, sorting, or deduping.
advance : {seed : Tm} → List (EnabledFuture seed) → List (CheckedFuture seed)
advance = map execute

-- Exact no-premature-collapse law: branch multiplicity is invariant.
advance-preserves-branch-count : {seed : Tm} (fs : List (EnabledFuture seed))
  → length (advance fs) ≡ length fs
advance-preserves-branch-count [] = refl
advance-preserves-branch-count (f ∷ fs) =
  cong suc (advance-preserves-branch-count fs)
