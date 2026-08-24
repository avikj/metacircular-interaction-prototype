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
-- NaturalMachine.DSOOption
--
-- A small checked seam for Dependent System Optimization (Delta 26).
-- An interface is a map q : X -> Z.  A task is supported when it factors
-- through q.  Coarsening q can reduce the representation, but cannot add
-- exactly supported tasks: every task visible after coarsening was already
-- visible before it.
--
-- This is deliberately an interface theorem, not an optimizer or a claim
-- about a particular cost model.  The byte anchor requested for this return
-- was unavailable in the checkout, so no semantic content is attributed to
-- it; the theorem is retained as an independent finite DSO core.
------------------------------------------------------------------------

module NaturalMachine.DSOOption where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ ; _,_)

infixr 9 _∘_
_∘_ : {A B C : Type₀} → (B → C) → (A → B) → A → C
(g ∘ k) x = g (k x)

-- Exact support of a task f through an interface q.
Task : {X Z Y : Type₀} → (X → Z) → (X → Y) → Type₀
Task q f = Σ[ g ∈ (_ → _) ] ((x : _) → f x ≡ g (q x))

-- If q₂ is a coarsening of q₁, every q₂-supported task is q₁-supported.
option-monotonicity
  : {X Z₁ Z₂ Y : Type₀}
  → (q₁ : X → Z₁)
  → (h : Z₁ → Z₂)
  → (f : X → Y)
  → Task (h ∘ q₁) f
  → Task q₁ f
option-monotonicity q₁ h f (g , witness) =
  (g ∘ h) , (λ x → witness x)

-- The transport is judgmentally the expected composition: no information
-- about the task is fabricated when moving to the finer interface.
option-witness
  : {X Z₁ Z₂ Y : Type₀}
  → (q₁ : X → Z₁)
  → (h : Z₁ → Z₂)
  → (f : X → Y)
  → (g : Z₂ → Y)
  → ((x : X) → f x ≡ g ((h ∘ q₁) x))
  → ((x : X) → f x ≡ (g ∘ h) (q₁ x))
option-witness q₁ h f g w x = w x
