{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Delta 29 residual synthesis, audited only on the four explicitly generated
-- middle profiles.  Boolean comparison is the decision procedure for the
-- pointwise integer order, so the finite equalities below check both truth and
-- falsity cases without assuming either side.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusResidualAudit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_)
open import Cubical.Data.Int using (ℤ ; min)
  renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_)
open import Cubical.Data.Int.Order using (_≤_ ; ≤Dec)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)

import NaturalMachine.DSONucleusExecutionCalibration as E
import NaturalMachine.DSONucleusOneSidedProduct as L
open import NaturalMachine.DSONucleusMiddleProduct

leq : ℤ → ℤ → Bool
leq x y with ≤Dec x y
... | yes _ = true
... | no  _ = false

_≤P_ : Profile → Profile → Bool
f ≤P g =
  (leq (f E.e) (g E.e) and leq (f E.a) (g E.a))
  and (leq (f E.c) (g E.c) and leq (f E.d) (g E.d))

leftResidual : Profile → Profile → Profile
leftResidual f r z =
  L.min4
    (r (E.e E.·C z) +ℤ E.M E.e z -ℤ f E.e)
    (r (E.a E.·C z) +ℤ E.M E.a z -ℤ f E.a)
    (r (E.c E.·C z) +ℤ E.M E.c z -ℤ f E.c)
    (r (E.d E.·C z) +ℤ E.M E.d z -ℤ f E.d)

rightResidual : Profile → Profile → Profile
rightResidual f ell x =
  L.min4
    (ell (x E.·C E.e) +ℤ E.M x E.e -ℤ f E.e)
    (ell (x E.·C E.a) +ℤ E.M x E.a -ℤ f E.a)
    (ell (x E.·C E.c) +ℤ E.M x E.c -ℤ f E.c)
    (ell (x E.·C E.d) +ℤ E.M x E.d -ℤ f E.d)

raw-left-residuation : (x y z : Generator)
  → (L.rawConvolution (middleSeed x) (middleSeed y) ≤P middleSeed z)
    ≡ (middleSeed y ≤P leftResidual (middleSeed x) (middleSeed z))
raw-left-residuation genZero genZero genZero = refl
raw-left-residuation genZero genZero genA = refl
raw-left-residuation genZero genZero genC = refl
raw-left-residuation genZero genZero genControl = refl
raw-left-residuation genZero genA genZero = refl
raw-left-residuation genZero genA genA = refl
raw-left-residuation genZero genA genC = refl
raw-left-residuation genZero genA genControl = refl
raw-left-residuation genZero genC genZero = refl
raw-left-residuation genZero genC genA = refl
raw-left-residuation genZero genC genC = refl
raw-left-residuation genZero genC genControl = refl
raw-left-residuation genZero genControl genZero = refl
raw-left-residuation genZero genControl genA = refl
raw-left-residuation genZero genControl genC = refl
raw-left-residuation genZero genControl genControl = refl
raw-left-residuation genA genZero genZero = refl
raw-left-residuation genA genZero genA = refl
raw-left-residuation genA genZero genC = refl
raw-left-residuation genA genZero genControl = refl
raw-left-residuation genA genA genZero = refl
raw-left-residuation genA genA genA = refl
raw-left-residuation genA genA genC = refl
raw-left-residuation genA genA genControl = refl
raw-left-residuation genA genC genZero = refl
raw-left-residuation genA genC genA = refl
raw-left-residuation genA genC genC = refl
raw-left-residuation genA genC genControl = refl
raw-left-residuation genA genControl genZero = refl
raw-left-residuation genA genControl genA = refl
raw-left-residuation genA genControl genC = refl
raw-left-residuation genA genControl genControl = refl
raw-left-residuation genC genZero genZero = refl
raw-left-residuation genC genZero genA = refl
raw-left-residuation genC genZero genC = refl
raw-left-residuation genC genZero genControl = refl
raw-left-residuation genC genA genZero = refl
raw-left-residuation genC genA genA = refl
raw-left-residuation genC genA genC = refl
raw-left-residuation genC genA genControl = refl
raw-left-residuation genC genC genZero = refl
raw-left-residuation genC genC genA = refl
raw-left-residuation genC genC genC = refl
raw-left-residuation genC genC genControl = refl
raw-left-residuation genC genControl genZero = refl
raw-left-residuation genC genControl genA = refl
raw-left-residuation genC genControl genC = refl
raw-left-residuation genC genControl genControl = refl
raw-left-residuation genControl genZero genZero = refl
raw-left-residuation genControl genZero genA = refl
raw-left-residuation genControl genZero genC = refl
raw-left-residuation genControl genZero genControl = refl
raw-left-residuation genControl genA genZero = refl
raw-left-residuation genControl genA genA = refl
raw-left-residuation genControl genA genC = refl
raw-left-residuation genControl genA genControl = refl
raw-left-residuation genControl genC genZero = refl
raw-left-residuation genControl genC genA = refl
raw-left-residuation genControl genC genC = refl
raw-left-residuation genControl genC genControl = refl
raw-left-residuation genControl genControl genZero = refl
raw-left-residuation genControl genControl genA = refl
raw-left-residuation genControl genControl genC = refl
raw-left-residuation genControl genControl genControl = refl

raw-right-residuation : (x y z : Generator)
  → (L.rawConvolution (middleSeed x) (middleSeed y) ≤P middleSeed z)
    ≡ (middleSeed x ≤P rightResidual (middleSeed y) (middleSeed z))
raw-right-residuation genZero genZero genZero = refl
raw-right-residuation genZero genZero genA = refl
raw-right-residuation genZero genZero genC = refl
raw-right-residuation genZero genZero genControl = refl
raw-right-residuation genZero genA genZero = refl
raw-right-residuation genZero genA genA = refl
raw-right-residuation genZero genA genC = refl
raw-right-residuation genZero genA genControl = refl
raw-right-residuation genZero genC genZero = refl
raw-right-residuation genZero genC genA = refl
raw-right-residuation genZero genC genC = refl
raw-right-residuation genZero genC genControl = refl
raw-right-residuation genZero genControl genZero = refl
raw-right-residuation genZero genControl genA = refl
raw-right-residuation genZero genControl genC = refl
raw-right-residuation genZero genControl genControl = refl
raw-right-residuation genA genZero genZero = refl
raw-right-residuation genA genZero genA = refl
raw-right-residuation genA genZero genC = refl
raw-right-residuation genA genZero genControl = refl
raw-right-residuation genA genA genZero = refl
raw-right-residuation genA genA genA = refl
raw-right-residuation genA genA genC = refl
raw-right-residuation genA genA genControl = refl
raw-right-residuation genA genC genZero = refl
raw-right-residuation genA genC genA = refl
raw-right-residuation genA genC genC = refl
raw-right-residuation genA genC genControl = refl
raw-right-residuation genA genControl genZero = refl
raw-right-residuation genA genControl genA = refl
raw-right-residuation genA genControl genC = refl
raw-right-residuation genA genControl genControl = refl
raw-right-residuation genC genZero genZero = refl
raw-right-residuation genC genZero genA = refl
raw-right-residuation genC genZero genC = refl
raw-right-residuation genC genZero genControl = refl
raw-right-residuation genC genA genZero = refl
raw-right-residuation genC genA genA = refl
raw-right-residuation genC genA genC = refl
raw-right-residuation genC genA genControl = refl
raw-right-residuation genC genC genZero = refl
raw-right-residuation genC genC genA = refl
raw-right-residuation genC genC genC = refl
raw-right-residuation genC genC genControl = refl
raw-right-residuation genC genControl genZero = refl
raw-right-residuation genC genControl genA = refl
raw-right-residuation genC genControl genC = refl
raw-right-residuation genC genControl genControl = refl
raw-right-residuation genControl genZero genZero = refl
raw-right-residuation genControl genZero genA = refl
raw-right-residuation genControl genZero genC = refl
raw-right-residuation genControl genZero genControl = refl
raw-right-residuation genControl genA genZero = refl
raw-right-residuation genControl genA genA = refl
raw-right-residuation genControl genA genC = refl
raw-right-residuation genControl genA genControl = refl
raw-right-residuation genControl genC genZero = refl
raw-right-residuation genControl genC genA = refl
raw-right-residuation genControl genC genC = refl
raw-right-residuation genControl genC genControl = refl
raw-right-residuation genControl genControl genZero = refl
raw-right-residuation genControl genControl genA = refl
raw-right-residuation genControl genControl genC = refl
raw-right-residuation genControl genControl genControl = refl

-- For middle-closed inputs, test the closure-aware candidate residuals.
middle-left-residuation : (x y z : Generator)
  → ((middleSeed x ⊙M middleSeed y) ≤P middleSeed z)
    ≡ (middleSeed y ≤P clMid (leftResidual (middleSeed x) (middleSeed z)))
middle-left-residuation genZero genZero genZero = refl
middle-left-residuation genZero genZero genA = refl
middle-left-residuation genZero genZero genC = refl
middle-left-residuation genZero genZero genControl = refl
middle-left-residuation genZero genA genZero = refl
middle-left-residuation genZero genA genA = refl
middle-left-residuation genZero genA genC = refl
middle-left-residuation genZero genA genControl = refl
middle-left-residuation genZero genC genZero = refl
middle-left-residuation genZero genC genA = refl
middle-left-residuation genZero genC genC = refl
middle-left-residuation genZero genC genControl = refl
middle-left-residuation genZero genControl genZero = refl
middle-left-residuation genZero genControl genA = refl
middle-left-residuation genZero genControl genC = refl
middle-left-residuation genZero genControl genControl = refl
middle-left-residuation genA genZero genZero = refl
middle-left-residuation genA genZero genA = refl
middle-left-residuation genA genZero genC = refl
middle-left-residuation genA genZero genControl = refl
middle-left-residuation genA genA genZero = refl
middle-left-residuation genA genA genA = refl
middle-left-residuation genA genA genC = refl
middle-left-residuation genA genA genControl = refl
middle-left-residuation genA genC genZero = refl
middle-left-residuation genA genC genA = refl
middle-left-residuation genA genC genC = refl
middle-left-residuation genA genC genControl = refl
middle-left-residuation genA genControl genZero = refl
middle-left-residuation genA genControl genA = refl
middle-left-residuation genA genControl genC = refl
middle-left-residuation genA genControl genControl = refl
middle-left-residuation genC genZero genZero = refl
middle-left-residuation genC genZero genA = refl
middle-left-residuation genC genZero genC = refl
middle-left-residuation genC genZero genControl = refl
middle-left-residuation genC genA genZero = refl
middle-left-residuation genC genA genA = refl
middle-left-residuation genC genA genC = refl
middle-left-residuation genC genA genControl = refl
middle-left-residuation genC genC genZero = refl
middle-left-residuation genC genC genA = refl
middle-left-residuation genC genC genC = refl
middle-left-residuation genC genC genControl = refl
middle-left-residuation genC genControl genZero = refl
middle-left-residuation genC genControl genA = refl
middle-left-residuation genC genControl genC = refl
middle-left-residuation genC genControl genControl = refl
middle-left-residuation genControl genZero genZero = refl
middle-left-residuation genControl genZero genA = refl
middle-left-residuation genControl genZero genC = refl
middle-left-residuation genControl genZero genControl = refl
middle-left-residuation genControl genA genZero = refl
middle-left-residuation genControl genA genA = refl
middle-left-residuation genControl genA genC = refl
middle-left-residuation genControl genA genControl = refl
middle-left-residuation genControl genC genZero = refl
middle-left-residuation genControl genC genA = refl
middle-left-residuation genControl genC genC = refl
middle-left-residuation genControl genC genControl = refl
middle-left-residuation genControl genControl genZero = refl
middle-left-residuation genControl genControl genA = refl
middle-left-residuation genControl genControl genC = refl
middle-left-residuation genControl genControl genControl = refl

middle-right-residuation : (x y z : Generator)
  → ((middleSeed x ⊙M middleSeed y) ≤P middleSeed z)
    ≡ (middleSeed x ≤P clMid (rightResidual (middleSeed y) (middleSeed z)))
middle-right-residuation genZero genZero genZero = refl
middle-right-residuation genZero genZero genA = refl
middle-right-residuation genZero genZero genC = refl
middle-right-residuation genZero genZero genControl = refl
middle-right-residuation genZero genA genZero = refl
middle-right-residuation genZero genA genA = refl
middle-right-residuation genZero genA genC = refl
middle-right-residuation genZero genA genControl = refl
middle-right-residuation genZero genC genZero = refl
middle-right-residuation genZero genC genA = refl
middle-right-residuation genZero genC genC = refl
middle-right-residuation genZero genC genControl = refl
middle-right-residuation genZero genControl genZero = refl
middle-right-residuation genZero genControl genA = refl
middle-right-residuation genZero genControl genC = refl
middle-right-residuation genZero genControl genControl = refl
middle-right-residuation genA genZero genZero = refl
middle-right-residuation genA genZero genA = refl
middle-right-residuation genA genZero genC = refl
middle-right-residuation genA genZero genControl = refl
middle-right-residuation genA genA genZero = refl
middle-right-residuation genA genA genA = refl
middle-right-residuation genA genA genC = refl
middle-right-residuation genA genA genControl = refl
middle-right-residuation genA genC genZero = refl
middle-right-residuation genA genC genA = refl
middle-right-residuation genA genC genC = refl
middle-right-residuation genA genC genControl = refl
middle-right-residuation genA genControl genZero = refl
middle-right-residuation genA genControl genA = refl
middle-right-residuation genA genControl genC = refl
middle-right-residuation genA genControl genControl = refl
middle-right-residuation genC genZero genZero = refl
middle-right-residuation genC genZero genA = refl
middle-right-residuation genC genZero genC = refl
middle-right-residuation genC genZero genControl = refl
middle-right-residuation genC genA genZero = refl
middle-right-residuation genC genA genA = refl
middle-right-residuation genC genA genC = refl
middle-right-residuation genC genA genControl = refl
middle-right-residuation genC genC genZero = refl
middle-right-residuation genC genC genA = refl
middle-right-residuation genC genC genC = refl
middle-right-residuation genC genC genControl = refl
middle-right-residuation genC genControl genZero = refl
middle-right-residuation genC genControl genA = refl
middle-right-residuation genC genControl genC = refl
middle-right-residuation genC genControl genControl = refl
middle-right-residuation genControl genZero genZero = refl
middle-right-residuation genControl genZero genA = refl
middle-right-residuation genControl genZero genC = refl
middle-right-residuation genControl genZero genControl = refl
middle-right-residuation genControl genA genZero = refl
middle-right-residuation genControl genA genA = refl
middle-right-residuation genControl genA genC = refl
middle-right-residuation genControl genA genControl = refl
middle-right-residuation genControl genC genZero = refl
middle-right-residuation genControl genC genA = refl
middle-right-residuation genControl genC genC = refl
middle-right-residuation genControl genC genControl = refl
middle-right-residuation genControl genControl genZero = refl
middle-right-residuation genControl genControl genA = refl
middle-right-residuation genControl genControl genC = refl
middle-right-residuation genControl genControl genControl = refl

admissible : Generator → Generator → Generator → Bool
admissible x z y = (middleSeed x ⊙M middleSeed y) ≤P middleSeed z

probe-zero : admissible genC genControl genZero ≡ true
probe-zero = refl

probe-a : admissible genC genControl genA ≡ true
probe-a = refl

probe-c : admissible genC genControl genC ≡ true
probe-c = refl

probe-control : admissible genC genControl genControl ≡ true
probe-control = refl

-- Rigor boundary: exhaustive only for Generator^3.  The formulas are generic,
-- but no unbounded residuated-lattice theorem is claimed.
