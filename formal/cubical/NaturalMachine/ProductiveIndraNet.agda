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

module NaturalMachine.ProductiveIndraNet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; false ; true)

open import NaturalMachine.FiniteIndraWeave
  using (TotalView ; LocalAction ; reweave ; baseView ; rootAction ; woven)

record Net (Root Jewel : Type₀) : Type₀ where
  coinductive
  field
    view : TotalView Root Jewel
    next : Net Root Jewel

open Net

-- One productive layer of local propagation. Recursive use is guarded by
-- the coinductive `next` field.
propagate : {Root Jewel : Type₀}
  → LocalAction Root Jewel → Net Root Jewel → Net Root Jewel
view (propagate action net) = reweave action (view net)
next (propagate action net) = propagate action (next net)

observe : {Root Jewel : Type₀}
  → ℕ → Net Root Jewel → List (TotalView Root Jewel)
observe zero net = []
observe (suc n) net = view net ∷ observe n (next net)

record Bisim {Root Jewel : Type₀}
             (left right : Net Root Jewel) : Type₀ where
  coinductive
  field
    now : view left ≡ view right
    later : Bisim (next left) (next right)

open Bisim

-- Local propagation is a congruence of productive behavior.
propagate-bisim : {Root Jewel : Type₀}
  (action : LocalAction Root Jewel) {left right : Net Root Jewel}
  → Bisim left right → Bisim (propagate action left) (propagate action right)
now (propagate-bisim action related) = cong (reweave action) (now related)
later (propagate-bisim action related) =
  propagate-bisim action (later related)

-- Every finite observer sees equal prefixes of bisimilar nets.
observe-bisim : {Root Jewel : Type₀} {left right : Net Root Jewel}
  → Bisim left right → (n : ℕ) → observe n left ≡ observe n right
observe-bisim related zero = refl
observe-bisim related (suc n) =
  cong₂ _∷_ (now related) (observe-bisim (later related) n)

mutual
  pulse flipped : Net Bool Bool
  view pulse = baseView
  next pulse = flipped
  view flipped = woven
  next flipped = pulse

reweave-woven : reweave rootAction woven ≡ baseView
reweave-woven = funExt λ
  { false → funExt λ target → refl
  ; true  → funExt λ target → refl }

-- The pointwise local action toggles the productive net by one phase.
mutual
  propagated-pulse≈flipped : Bisim (propagate rootAction pulse) flipped
  now propagated-pulse≈flipped = refl
  later propagated-pulse≈flipped = propagated-flipped≈pulse

  propagated-flipped≈pulse : Bisim (propagate rootAction flipped) pulse
  now propagated-flipped≈pulse = reweave-woven
  later propagated-flipped≈pulse = propagated-pulse≈flipped

-- Nontrivial finite execution: four observations alternate and propagation
-- shifts the phase, all by kernel reduction of the productive object.
run-four : observe 4 pulse ≡
  baseView ∷ woven ∷ baseView ∷ woven ∷ []
run-four = refl

run-propagated-four : observe 4 (propagate rootAction pulse) ≡
  woven ∷ baseView ∷ woven ∷ baseView ∷ []
run-propagated-four =
  cong₂ _∷_ refl
    (cong₂ _∷_ reweave-woven
      (cong₂ _∷_ refl
        (cong₂ _∷_ reweave-woven refl)))
