{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PMMonodromyDerivationNoGo
--
-- PauliWeyl derives the six context signs, but those vertex signs do not by
-- themselves select an edge carrying the incidence-local-system twist.
-- Any uniform rule depending only on the signs at an edge's two endpoint
-- contexts has even holonomy around the chosen six-edge cover cycle, whereas
-- the checked Peres--Mermin obstruction has odd total sign.
--
-- Therefore the ZZ-supported representative in PMIncidenceLocalSystem is a
-- gauge/representative choice, not something canonically derived from the
-- context sign vector alone.  The cohomology class is checked; locating it on
-- one edge requires extra structure.
------------------------------------------------------------------------

module NaturalMachine.PMMonodromyDerivationNoGo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; _⊕_ ; false≢true)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.PMTorus as Torus
import NaturalMachine.PMCokernel as PM
import NaturalMachine.PauliWeyl as Weyl

------------------------------------------------------------------------
-- 1. Endpoint-only edge rules
------------------------------------------------------------------------

EndpointRule : Type₀
EndpointRule = Bool → Bool → Bool

edgeCharge : EndpointRule → Torus.Obs → Bool
edgeCharge rule observable =
  rule
    (Weyl.derived-s (fst (Torus.pmContexts observable)))
    (Weyl.derived-s (snd (Torus.pmContexts observable)))

-- The same six edges as PMIncidenceLocalSystem.coverCycle.  Orientation does
-- not change a Z/2 charge because every element is self-inverse.
endpointCycleCharge : EndpointRule → Bool
endpointCycleCharge rule =
  ((((edgeCharge rule Torus.XI
  ⊕ edgeCharge rule Torus.IY)
  ⊕ edgeCharge rule Torus.YI)
  ⊕ edgeCharge rule Torus.YX)
  ⊕ edgeCharge rule Torus.ZZ)
  ⊕ edgeCharge rule Torus.XX

-- Four edges join (+,+) contexts and two join (+,-) contexts.  Every
-- endpoint-only rule therefore occurs an even number of times.
endpoint-cycle-is-trivial :
  (rule : EndpointRule) → endpointCycleCharge rule ≡ false
endpoint-cycle-is-trivial rule with rule false false | rule false true
... | false | false = refl
... | false | true  = refl
... | true  | false = refl
... | true  | true  = refl

------------------------------------------------------------------------
-- 2. The operator-derived PM obstruction is odd
------------------------------------------------------------------------

derived-sign-vector-is-s : Weyl.derived-s ≡ PM.s
derived-sign-vector-is-s = funExt Weyl.derived-s≡s

derived-total-is-odd : PM.total Weyl.derived-s ≡ true
derived-total-is-odd =
  cong PM.total derived-sign-vector-is-s ∙ PM.total-s

endpoint-rule-cannot-carry-obstruction :
  (rule : EndpointRule)
  → ¬ (endpointCycleCharge rule ≡ PM.total Weyl.derived-s)
endpoint-rule-cannot-carry-obstruction rule equality =
  false≢true
    (sym (endpoint-cycle-is-trivial rule)
    ∙ equality
    ∙ derived-total-is-odd)

------------------------------------------------------------------------
-- 3. A representative requires additional gauge data
------------------------------------------------------------------------

EdgeRepresentative : Type₀
EdgeRepresentative = Torus.Obs → Bool

cycleCharge : EdgeRepresentative → Bool
cycleCharge charge =
  ((((charge Torus.XI
  ⊕ charge Torus.IY)
  ⊕ charge Torus.YI)
  ⊕ charge Torus.YX)
  ⊕ charge Torus.ZZ)
  ⊕ charge Torus.XX

-- This is the representative used by PMIncidenceLocalSystem.  It is written
-- here explicitly so its status is honest: PauliWeyl derives the odd class,
-- while this extra gauge choice locates that class on one overlap.
zzRepresentative : EdgeRepresentative
zzRepresentative Torus.XI = false
zzRepresentative Torus.IX = false
zzRepresentative Torus.XX = false
zzRepresentative Torus.IY = false
zzRepresentative Torus.YI = false
zzRepresentative Torus.YY = false
zzRepresentative Torus.XY = false
zzRepresentative Torus.YX = false
zzRepresentative Torus.ZZ = true

zz-representative-is-odd : cycleCharge zzRepresentative ≡ true
zz-representative-is-odd = refl

representative-matches-derived-class :
  cycleCharge zzRepresentative ≡ PM.total Weyl.derived-s
representative-matches-derived-class =
  zz-representative-is-odd ∙ sym derived-total-is-odd

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: all endpoint-derived edge rules give trivial cycle charge, the
-- operator-derived PM sign vector has odd total, and the explicit ZZ gauge
-- representative has that same odd class.
--
-- Not claimed: uniqueness or canonicity of ZZ.  Other edge representatives
-- can carry the same class.  Selecting one is gauge fixing; the invariant
-- content proved here is its cycle parity, not its support.
------------------------------------------------------------------------
