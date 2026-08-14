{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The phase in PauliWeyl multiplication splits into an observable phase
-- and the Weyl multiplication cocycle.  On the six Peres--Mermin contexts
-- the observable-phase correction changes the sign representative but is
-- killed by the checked cokernel parity.
--
-- Scope: this is a theorem about `PauliWeyl._·P_`.  In particular it does
-- NOT prove identity or composition laws for
-- `ExactTwoStateAmplitudes.phaseAction`; those remain separate obligations.
------------------------------------------------------------------------

module NaturalMachine.PauliGaugeCocycleSplit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; _⊕_ ; false≢true)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.PauliWeyl as Weyl
import NaturalMachine.PMCokernel as PM
import NaturalMachine.PMTorus as Torus

------------------------------------------------------------------------
-- 1. Generic phase/cocycle split
------------------------------------------------------------------------

phase : Weyl.Pauli → Weyl.Z4
phase (Weyl.pauli e _ _ _ _) = e

central : Weyl.Z4 → Weyl.Pauli
central e = Weyl.pauli e false false false false

erasePhase : Weyl.Pauli → Weyl.Pauli
erasePhase (Weyl.pauli _ a₁ b₁ a₂ b₂) =
  Weyl.pauli Weyl.ph0 a₁ b₁ a₂ b₂

-- The multiplication cocycle depends only on the symplectic coordinates,
-- not on either chosen phase representative.
μ : Weyl.Pauli → Weyl.Pauli → Weyl.Z4
μ (Weyl.pauli _ _ b₁ _ b₂) (Weyl.pauli _ c₁ _ c₂ _) =
  Weyl.tw (b₁ and c₁) Weyl.+₄ Weyl.tw (b₂ and c₂)
  where
  open import Cubical.Data.Bool using (_and_)

-- Every Pauli datum is its central phase times its phase-zero
-- representative.  The order is load-bearing because `_·P_` is defined in
-- Weyl order, even though a central element contributes no twist.
central-times-erased : (p : Weyl.Pauli)
  → central (phase p) Weyl.·P erasePhase p ≡ p
central-times-erased (Weyl.pauli Weyl.ph0 a₁ b₁ a₂ b₂) = refl
central-times-erased (Weyl.pauli Weyl.ph1 a₁ b₁ a₂ b₂) = refl
central-times-erased (Weyl.pauli Weyl.ph2 a₁ b₁ a₂ b₂) = refl
central-times-erased (Weyl.pauli Weyl.ph3 a₁ b₁ a₂ b₂) = refl

μ-erasure-invariant : (p q : Weyl.Pauli)
  → μ (erasePhase p) (erasePhase q) ≡ μ p q
μ-erasure-invariant (Weyl.pauli e a₁ b₁ a₂ b₂)
                    (Weyl.pauli f c₁ d₁ c₂ d₂) = refl

-- This is the generic φ/μ split for one multiplication.
phase-product : (p q : Weyl.Pauli)
  → phase (p Weyl.·P q)
  ≡ (phase p Weyl.+₄ phase q) Weyl.+₄ μ p q
phase-product (Weyl.pauli e a₁ b₁ a₂ b₂)
              (Weyl.pauli f c₁ d₁ c₂ d₂) = refl

-- For a closed triple, move the second observable phase before the two
-- cocycle contributions.  This is the note's execution-order formula
-- φ(p)+φ(q)+φ(r)+μ(p,q)+μ(pq,r).
phase-triple : (p q r : Weyl.Pauli)
  → phase ((p Weyl.·P q) Weyl.·P r)
  ≡ ((((phase p Weyl.+₄ phase q) Weyl.+₄ phase r)
       Weyl.+₄ μ p q)
       Weyl.+₄ μ (p Weyl.·P q) r)
phase-triple p q r =
    phase-product (p Weyl.·P q) r
  ∙ cong (λ z → (z Weyl.+₄ phase r) Weyl.+₄ μ (p Weyl.·P q) r)
      (phase-product p q)
  ∙ cong (Weyl._+₄ μ (p Weyl.·P q) r)
      (Weyl.shift (phase p Weyl.+₄ phase q) (μ p q) (phase r))

------------------------------------------------------------------------
-- 2. The six checked contexts
------------------------------------------------------------------------

first : Torus.Ctx → Weyl.Pauli
first Torus.R0 = Weyl.XI
first Torus.R1 = Weyl.IY
first Torus.R2 = Weyl.XY
first Torus.C0 = Weyl.XI
first Torus.C1 = Weyl.IX
first Torus.C2 = Weyl.XX

second : Torus.Ctx → Weyl.Pauli
second Torus.R0 = Weyl.IX
second Torus.R1 = Weyl.YI
second Torus.R2 = Weyl.YX
second Torus.C0 = Weyl.IY
second Torus.C1 = Weyl.YI
second Torus.C2 = Weyl.YY

third : Torus.Ctx → Weyl.Pauli
third Torus.R0 = Weyl.XX
third Torus.R1 = Weyl.YY
third Torus.R2 = Weyl.ZZ
third Torus.C0 = Weyl.XY
third Torus.C1 = Weyl.YX
third Torus.C2 = Weyl.ZZ

lineProduct : Torus.Ctx → Weyl.Pauli
lineProduct context =
  (first context Weyl.·P second context) Weyl.·P third context

erasedLineProduct : Torus.Ctx → Weyl.Pauli
erasedLineProduct context =
  (erasePhase (first context) Weyl.·P erasePhase (second context))
    Weyl.·P erasePhase (third context)

expectedFullProduct : Torus.Ctx → Weyl.Pauli
expectedFullProduct Torus.R0 = Weyl.Id
expectedFullProduct Torus.R1 = Weyl.Id
expectedFullProduct Torus.R2 = Weyl.Id
expectedFullProduct Torus.C0 = Weyl.Id
expectedFullProduct Torus.C1 = Weyl.Id
expectedFullProduct Torus.C2 = Weyl.-Id

expectedErasedProduct : Torus.Ctx → Weyl.Pauli
expectedErasedProduct Torus.R0 = Weyl.Id
expectedErasedProduct Torus.R1 = Weyl.Id
expectedErasedProduct Torus.R2 = Weyl.-Id
expectedErasedProduct Torus.C0 = Weyl.-Id
expectedErasedProduct Torus.C1 = Weyl.-Id
expectedErasedProduct Torus.C2 = Weyl.Id

-- These two tables certify that `minusSign` is only applied to the even
-- central phases +I and -I in the six-context results.
full-products-central : (context : Torus.Ctx)
  → lineProduct context ≡ expectedFullProduct context
full-products-central Torus.R0 = Weyl.R0-product
full-products-central Torus.R1 = Weyl.R1-product
full-products-central Torus.R2 = Weyl.R2-product
full-products-central Torus.C0 = Weyl.C0-product
full-products-central Torus.C1 = Weyl.C1-product
full-products-central Torus.C2 = Weyl.C2-product

erased-products-central : (context : Torus.Ctx)
  → erasedLineProduct context ≡ expectedErasedProduct context
erased-products-central Torus.R0 = refl
erased-products-central Torus.R1 = refl
erased-products-central Torus.R2 = refl
erased-products-central Torus.C0 = refl
erased-products-central Torus.C1 = refl
erased-products-central Torus.C2 = refl

-- All six products below have even central phase.  This finite reader is
-- deliberately not presented as a homomorphism on arbitrary Z4.
minusSign : Weyl.Z4 → Bool
minusSign Weyl.ph0 = false
minusSign Weyl.ph1 = false
minusSign Weyl.ph2 = true
minusSign Weyl.ph3 = false

fullLineSign : Torus.Ctx → Bool
fullLineSign context = minusSign (phase (lineProduct context))

μOnlySign : Torus.Ctx → Bool
μOnlySign context = minusSign (phase (erasedLineProduct context))

gaugeLineSign : Torus.Ctx → Bool
gaugeLineSign context =
  minusSign
    ((phase (first context) Weyl.+₄ phase (second context))
      Weyl.+₄ phase (third context))

full-line-sign-is-derived : (context : Torus.Ctx)
  → fullLineSign context ≡ Weyl.derived-s context
full-line-sign-is-derived Torus.R0 = refl
full-line-sign-is-derived Torus.R1 = refl
full-line-sign-is-derived Torus.R2 = refl
full-line-sign-is-derived Torus.C0 = refl
full-line-sign-is-derived Torus.C1 = refl
full-line-sign-is-derived Torus.C2 = refl

-- The observable phases and the phase-zero multiplication cocycle add to
-- the actual operator-derived sign, context by context.
derived-sign-split : (context : Torus.Ctx)
  → Weyl.derived-s context
  ≡ μOnlySign context ⊕ gaugeLineSign context
derived-sign-split Torus.R0 = refl
derived-sign-split Torus.R1 = refl
derived-sign-split Torus.R2 = refl
derived-sign-split Torus.C0 = refl
derived-sign-split Torus.C1 = refl
derived-sign-split Torus.C2 = refl

-- The gauge contribution changes four context signs and has even total.
gauge-line-even : PM.total gaugeLineSign ≡ false
gauge-line-even = refl

gauge-line-is-incidence : PM.Image gaugeLineSign
gauge-line-is-incidence =
  PM.even-total-is-image gaugeLineSign gauge-line-even

μ-only-total-is-odd : PM.total μOnlySign ≡ true
μ-only-total-is-odd = refl

derived-total-is-odd : PM.total Weyl.derived-s ≡ true
derived-total-is-odd =
  cong PM.total (funExt Weyl.derived-s≡s) ∙ PM.total-s

same-cokernel-parity :
  PM.total μOnlySign ≡ PM.total Weyl.derived-s
same-cokernel-parity = μ-only-total-is-odd ∙ sym derived-total-is-odd

difference-is-gauge : (context : Torus.Ctx)
  → Weyl.derived-s context ⊕ μOnlySign context
  ≡ gaugeLineSign context
difference-is-gauge Torus.R0 = refl
difference-is-gauge Torus.R1 = refl
difference-is-gauge Torus.R2 = refl
difference-is-gauge Torus.C0 = refl
difference-is-gauge Torus.C1 = refl
difference-is-gauge Torus.C2 = refl

-- Usable coker equality without pretending PMCokernel constructed a
-- quotient: the pointwise difference lies in the incidence image.
difference-is-incidence :
  PM.Image (λ context → Weyl.derived-s context ⊕ μOnlySign context)
difference-is-incidence =
  PM.even-total-is-image
    (λ context → Weyl.derived-s context ⊕ μOnlySign context)
    refl

------------------------------------------------------------------------
-- 3. Killer control: the gauge term is locally load-bearing
------------------------------------------------------------------------

c2-erased-product-is-plus : erasedLineProduct Torus.C2 ≡ Weyl.Id
c2-erased-product-is-plus = refl

c2-full-product-is-minus : lineProduct Torus.C2 ≡ Weyl.-Id
c2-full-product-is-minus = Weyl.C2-product

c2-erasure-loses-minus-sign :
  ¬ (μOnlySign Torus.C2 ≡ Weyl.derived-s Torus.C2)
c2-erasure-loses-minus-sign = false≢true

------------------------------------------------------------------------
-- Boundary
--
-- This file exposes the multiplication cocycle internal to `PauliWeyl` and
-- its six-context specialization.  It imports neither
-- `ExactTwoStateAmplitudes` nor `ExactProjectivePhase`.  Consequently it
-- establishes no identity/composition action of Z4 on amplitude states and
-- does not upgrade the projective SetQuotient to an orbit quotient.
------------------------------------------------------------------------
