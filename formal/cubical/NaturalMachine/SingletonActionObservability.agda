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

------------------------------------------------------------------------
-- NaturalMachine.SingletonActionObservability
--
-- Equality under every word in a one-action machine is exactly equality
-- along every iterate of its underlying endomap.  The index change is the
-- checked equivalence ℕ ≃ List Unit from FreeMonoid, rather than an informal
-- identification of words with their lengths.
--
-- Composing this equivalence with ProductiveObservabilityBridge identifies
-- productive-Net bisimulation with unary FutureBehavior.  ObservableHorizon
-- then supplies the bounded-to-coinductive implication precisely when its
-- action-closure premise is present.
------------------------------------------------------------------------

module NaturalMachine.SingletonActionObservability where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivΠ ; compEquiv ; invEquiv ; equivFun ; invEq)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)

import NaturalMachine.FreeMonoid as FM
import NaturalMachine.FutureBehavior as FB
import NaturalMachine.ObservabilityQuotient as OQ
import NaturalMachine.ObservableHorizon as OH
import NaturalMachine.ProductiveIndraNet as PIN
import NaturalMachine.ProductiveObservabilityBridge as POB

private
  variable
    ℓX ℓO : Level
    X : Type ℓX
    O : Type ℓO
    Root Jewel : Type₀

------------------------------------------------------------------------
-- One action word is one natural-number iteration
------------------------------------------------------------------------

unitStep : (X → X) → X → Unit → X
unitStep transition state tt = transition state

-- Executing the canonical word of length n is the n-fold iterate.  Both
-- definitions apply the next step before recurring, so no reversal occurs.
run-unlen : (transition : X → X) (observe : X → O)
  (state : X) (depth : ℕ)
  → FB.run (unitStep transition) state (FM.unlen depth)
    ≡ OQ.iterT transition observe depth state
run-unlen transition observe state zero = refl
run-unlen transition observe state (suc depth) =
  run-unlen transition observe (transition state) depth

-- Every Unit-word is propositionally its canonical length presentation.
-- This is where the already-checked FreeMonoid equivalence enters.
run-len : (transition : X → X) (observe : X → O)
  (state : X) (word : List Unit)
  → FB.run (unitStep transition) state word
    ≡ OQ.iterT transition observe (FM.len word) state
run-len transition observe state word =
  cong (FB.run (unitStep transition) state) (sym (FM.unlen-len word))
  ∙ run-unlen transition observe state (FM.len word)

-- At each word, run-len identifies the two endpoint observations and hence
-- the corresponding path types.
wordPath≃depthPath :
    (transition : X → X) (observe : X → O) (left right : X)
    (word : List Unit)
  → (FB.behavior (unitStep transition) observe left word
      ≡ FB.behavior (unitStep transition) observe right word)
    ≃ (OQ.obsAt transition observe (FM.len word) left
      ≡ OQ.obsAt transition observe (FM.len word) right)
wordPath≃depthPath transition observe left right word =
  pathToEquiv
    (cong₂ _≡_
      (cong observe (run-len transition observe left word))
      (cong observe (run-len transition observe right word)))

-- The full dependent products are equivalent.  `invEquiv FM.ℕ≃Tally`
-- reindexes a Unit-word by its length; equivΠ supplies both inverse laws.
singletonFuture≃forever :
    (transition : X → X) (observe : X → O) {left right : X}
  → FB.FutureEq (unitStep transition) observe left right
    ≃ OQ.ForeverEq transition observe left right
singletonFuture≃forever transition observe {left} {right} =
  equivΠ (invEquiv FM.ℕ≃Tally)
    (wordPath≃depthPath transition observe left right)

------------------------------------------------------------------------
-- Productive Indra Net specialization
------------------------------------------------------------------------

productiveBisim≃singletonFuture :
    {left right : PIN.Net Root Jewel}
  → PIN.Bisim left right
    ≃ FB.FutureEq (unitStep PIN.Net.next) PIN.Net.view left right
productiveBisim≃singletonFuture =
  compEquiv POB.bisim≃forever
    (invEquiv (singletonFuture≃forever PIN.Net.next PIN.Net.view))

-- If a bounded unary observation kernel is closed under the unique action,
-- ObservableHorizon upgrades it to full FutureEq and therefore to Bisim.
productiveBounded→bisim :
    (fuel : ℕ)
  → OH.ObservableClosesAt
      (unitStep (PIN.Net.next {Root} {Jewel})) PIN.Net.view fuel
  → {left right : PIN.Net Root Jewel}
  → OH.BoundedFutureEq
      (unitStep PIN.Net.next) PIN.Net.view fuel left right
  → PIN.Bisim left right
productiveBounded→bisim fuel closes bounded =
  invEq productiveBisim≃singletonFuture
    (OH.boundedClosure→futureEq
      (unitStep PIN.Net.next) PIN.Net.view fuel closes bounded)

-- Bisimilarity always restricts to the bounded word window; no closure
-- premise is needed in this direction.
bisim→productiveBounded :
    (fuel : ℕ) {left right : PIN.Net Root Jewel}
  → PIN.Bisim left right
  → OH.BoundedFutureEq
      (unitStep PIN.Net.next) PIN.Net.view fuel left right
bisim→productiveBounded fuel related =
  OH.futureEq→bounded (unitStep PIN.Net.next) PIN.Net.view fuel
    (equivFun productiveBisim≃singletonFuture related)

-- Under action closure the bounded kernel and productive bisimulation have
-- maps in both directions.  This is deliberately not advertised as an
-- equivalence of witness types: TotalView is not assumed set-valued.
productive-stabilized-kernel :
    (fuel : ℕ)
  → OH.ObservableClosesAt
      (unitStep (PIN.Net.next {Root} {Jewel})) PIN.Net.view fuel
  → {left right : PIN.Net Root Jewel}
  → (OH.BoundedFutureEq
        (unitStep PIN.Net.next) PIN.Net.view fuel left right
      → PIN.Bisim left right)
    × (PIN.Bisim left right
      → OH.BoundedFutureEq
          (unitStep PIN.Net.next) PIN.Net.view fuel left right)
productive-stabilized-kernel fuel closes =
  productiveBounded→bisim fuel closes ,
  bisim→productiveBounded fuel
