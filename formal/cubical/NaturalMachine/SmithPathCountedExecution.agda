{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SmithPathCountedExecution where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.CountedExecution using (run)

-- Signed integer data used by the concrete 3 by 3 certificates below.
-- `neg n` denotes -n; this module stores the already-verified matrices rather
-- than reimplementing integer matrix arithmetic.
data Z : Type₀ where
  zro : Z
  pos : ℕ → Z
  neg : ℕ → Z

record Mat3 : Type₀ where
  constructor mat3
  field
    a00 a01 a02 : Z
    a10 a11 a12 : Z
    a20 a21 a22 : Z

open Mat3

I3 : Mat3
I3 = mat3 (pos 1) zro zro zro (pos 1) zro zro zro (pos 1)

-- Cumulative left transformations for the two legal adjacent-pair schedules
-- on diag(2,3,2).  They are the exact certificates Up and Uq from
-- notes/SMITH_PATH_HOLONOMY.md.
Up : Mat3
Up = mat3 (neg 1) (pos 1) zro
          zro zro (pos 1)
          (pos 3) (neg 2) (pos 3)

Uq : Mat3
Uq = mat3 zro (pos 1) (neg 1)
          (neg 1) (pos 2) (neg 2)
          zro (neg 2) (pos 3)

data Diagonal : Type₀ where
  d232 d162 d216 d126 : Diagonal

-- The two target-cokernel classes used by the holonomy witness.  In the
-- coordinates coker(diag(1,2,6)), these are (0,0,1) and (0,1,4).
data FiberClass : Type₀ where
  c001 c014 : FiberClass

data SmithState : Type₀ where
  p0 p1 p2 q0 q1 q2 : SmithState

endpoint : SmithState → Diagonal
endpoint p0 = d232
endpoint p1 = d162
endpoint p2 = d126
endpoint q0 = d232
endpoint q1 = d216
endpoint q2 = d126

-- The path coordinate is retained as state.  At the common endpoint it is
-- the cumulative unimodular transformation, not the Smith diagonal.
leftAction : SmithState → Mat3
leftAction p0 = I3
leftAction p1 = mat3 (neg 1) (pos 1) zro
                     (neg 3) (pos 2) zro
                     zro zro (pos 1)
leftAction p2 = Up
leftAction q0 = I3
leftAction q1 = mat3 (pos 1) zro zro
                     zro (pos 1) (neg 1)
                     zro (neg 2) (pos 3)
leftAction q2 = Uq

transportedClass : SmithState → FiberClass
transportedClass p0 = c001
transportedClass p1 = c001
transportedClass p2 = c001
transportedClass q0 = c001
transportedClass q1 = c001
transportedClass q2 = c014

pStep : SmithState → SmithState
pStep p0 = p1
pStep p1 = p2
pStep x  = x

qStep : SmithState → SmithState
qStep q0 = q1
qStep q1 = q2
qStep x  = x

pExecution qExecution : ℕ → SmithState
pExecution = run p0 pStep
qExecution = run q0 qStep

-- CountedExecution computes both schedules to the same Smith endpoint.
same-endpoint-at-two : endpoint (pExecution 2) ≡ endpoint (qExecution 2)
same-endpoint-at-two = refl

-- It simultaneously retains the distinct presentation changes.
p-action-at-two : leftAction (pExecution 2) ≡ Up
p-action-at-two = refl

q-action-at-two : leftAction (qExecution 2) ≡ Uq
q-action-at-two = refl

classCode : FiberClass → ℕ
classCode c001 = 0
classCode c014 = 1

c001≠c014 : ¬ (c001 ≡ c014)
c001≠c014 path = znots (cong classCode path)

different-fiber-at-two : ¬ (transportedClass (pExecution 2)
                               ≡ transportedClass (qExecution 2))
different-fiber-at-two = c001≠c014

-- Therefore no endpoint-only observation can reproduce both transported
-- classes.  This is the precise boundary on compiling a Smith schedule to
-- its normal diagonal: the endpoint projection is sound only for observables
-- invariant under the schedule holonomy.
no-endpoint-only-readout
  : (read : Diagonal → FiberClass)
  → read (endpoint (pExecution 2)) ≡ transportedClass (pExecution 2)
  → read (endpoint (qExecution 2)) ≡ transportedClass (qExecution 2)
  → ⊥
no-endpoint-only-readout read rp rq =
  c001≠c014 (sym rp ∙ cong read same-endpoint-at-two ∙ rq)
