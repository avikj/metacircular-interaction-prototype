{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PauliJointPhaseRealization
--
-- The Bool joint-phase seam is realized inside the checked two-qubit Weyl
-- presentation as the central sign sector {+I,-I}.  Multiplication by -I
-- executes its phase exchange, and the Peres--Mermin R0/C2 line products
-- realize the two endpoints.
--
-- This earns an operator-algebra connection without adding matrices,
-- Hilbert space, eigenstates, or a measurement postulate beyond PauliWeyl.
------------------------------------------------------------------------

module PauliJointPhaseRealization where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivFun)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Empty using (⊥ ; rec)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import PauliWeyl as Weyl
import PMTorus as PM
import UnivalentTensorInteraction as Joint

------------------------------------------------------------------------
-- 1. The central sign sector is a faithful realization of the phase chart
------------------------------------------------------------------------

realizePhase : Joint.JointCoherence → Weyl.Pauli
realizePhase true  = Weyl.Id
realizePhase false = Weyl.-Id

phaseCoordinate : Weyl.Pauli → Weyl.Z4
phaseCoordinate (Weyl.pauli e a₁ b₁ a₂ b₂) = e

ph0≢ph2 : ¬ (Weyl.ph0 ≡ Weyl.ph2)
ph0≢ph2 path = subst distinguish path tt
  where
    distinguish : Weyl.Z4 → Type₀
    distinguish Weyl.ph0 = Unit
    distinguish Weyl.ph1 = ⊥
    distinguish Weyl.ph2 = ⊥
    distinguish Weyl.ph3 = ⊥

Id≢-Id : ¬ (Weyl.Id ≡ Weyl.-Id)
Id≢-Id path = ph0≢ph2 (cong phaseCoordinate path)

realizePhase-injective :
  {x y : Joint.JointCoherence}
  → realizePhase x ≡ realizePhase y → x ≡ y
realizePhase-injective {true}  {true}  equality = refl
realizePhase-injective {true}  {false} equality = rec (Id≢-Id equality)
realizePhase-injective {false} {true}  equality =
  rec (Id≢-Id (sym equality))
realizePhase-injective {false} {false} equality = refl

------------------------------------------------------------------------
-- 2. The univalent phase exchange is central Pauli multiplication
------------------------------------------------------------------------

toggleCentral : Weyl.Pauli → Weyl.Pauli
toggleCentral p = Weyl.-Id Weyl.·P p

pauli-toggle-realizes-exchange :
  (phase : Joint.JointCoherence)
  → realizePhase (equivFun Joint.phaseExchange phase)
    ≡ toggleCentral (realizePhase phase)
pauli-toggle-realizes-exchange true  = refl
pauli-toggle-realizes-exchange false = refl

toggle-closes-on-realized-sector :
  (phase : Joint.JointCoherence)
  → toggleCentral (toggleCentral (realizePhase phase))
    ≡ realizePhase phase
toggle-closes-on-realized-sector true  = refl
toggle-closes-on-realized-sector false = refl

------------------------------------------------------------------------
-- 3. Existing joint Pauli contexts instantiate both coherent phases
------------------------------------------------------------------------

-- PauliWeyl's sign convention is false for +I and true for -I, opposite to
-- Joint's constructor names (plus=true, minus=false).  This explicit `not`
-- is the entire chart transition; silently identifying the two Bool labels
-- would reverse the physical sign.
contextPhase : PM.Ctx → Joint.JointCoherence
contextPhase context = not (Weyl.derived-s context)

r0-context-is-plus : contextPhase PM.R0 ≡ Joint.plus
r0-context-is-plus = refl

c2-context-is-minus : contextPhase PM.C2 ≡ Joint.minus
c2-context-is-minus = refl

r0-product-realizes-plus :
  Weyl.XI Weyl.·P Weyl.IX Weyl.·P Weyl.XX
  ≡ realizePhase Joint.plus
r0-product-realizes-plus = Weyl.R0-product

c2-product-realizes-minus :
  Weyl.XX Weyl.·P Weyl.YY Weyl.·P Weyl.ZZ
  ≡ realizePhase Joint.minus
c2-product-realizes-minus = Weyl.C2-product

-- The joint port is therefore not an arbitrary Bool oracle: on these two
-- checked commuting contexts it records which central Pauli product occurs.
record CheckedJointPort : Type₀ where
  field
    plusContext : contextPhase PM.R0 ≡ Joint.plus
    minusContext : contextPhase PM.C2 ≡ Joint.minus
    plusOperator :
      Weyl.XI Weyl.·P Weyl.IX Weyl.·P Weyl.XX
      ≡ realizePhase Joint.plus
    minusOperator :
      Weyl.XX Weyl.·P Weyl.YY Weyl.·P Weyl.ZZ
      ≡ realizePhase Joint.minus
    exchangeOperator :
      (phase : Joint.JointCoherence)
      → realizePhase (equivFun Joint.phaseExchange phase)
        ≡ toggleCentral (realizePhase phase)

checked-joint-port : CheckedJointPort
checked-joint-port .CheckedJointPort.plusContext = r0-context-is-plus
checked-joint-port .CheckedJointPort.minusContext = c2-context-is-minus
checked-joint-port .CheckedJointPort.plusOperator = r0-product-realizes-plus
checked-joint-port .CheckedJointPort.minusOperator = c2-product-realizes-minus
checked-joint-port .CheckedJointPort.exchangeOperator =
  pauli-toggle-realizes-exchange

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: faithful embedding of the two phase labels into PauliWeyl's
-- central sign sector, exact realization of exchange by -I multiplication,
-- and the R0/C2 products at its two endpoints.
--
-- Not claimed: that the Bool phase labels are quantum states, that central
-- signs alone reconstruct the nine observables, or that this supplies a Born
-- rule or Hilbert-space entanglement.  `PauliWeyl` itself explicitly stops
-- short of a faithful matrix representation, and this module inherits that
-- boundary.
------------------------------------------------------------------------
