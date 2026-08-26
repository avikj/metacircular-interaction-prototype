{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PairReflectionSector
--
-- A randomly encountered prime-pair plot (`figures/exp4_singular.png`)
-- returned one exact map to the checked core:
--
--     J (u , v) = (u , - v).
--
-- At every finite prime, the admissibility predicate is invariant under
-- negation, so J restricts to the admissible sector.  Consequently the
-- sum forms (x , k-x) and difference forms (x , x-k) have equivalent
-- admissible fibres, hence equal finite cardinality.  This is the exact
-- local statement behind their common Hardy--Littlewood singular series.
--
-- On an ordered positive cone the SAME ambient J does not restrict:
-- (1,1) is positive while J(1,1)=(1,-1) is not.  The failure is packaged
-- as `PerspectiveCore.SectorBreak`, not described by analogy.
--
-- WHAT IS CHECKED
--
--   JEquiv                 J is an ambient equivalence.
--   admissible-reflection  a negation-invariant predicate restricts J.
--   local-fibre-equiv      sum and difference admissible fibres agree.
--   local-count-equal      finite instances therefore have equal counts.
--   positive-break         positivity gives an exact SectorBreak witness.
--   positive-not-invariant no fibrewise restriction can exist.
--
-- RIGOR BOUNDARY
--
-- This proves the finite-place transport, including equality of local
-- counts.  It proves no prime-pair asymptotic: the passage from the local
-- Euler product to Goldbach or twin-prime counts contains the global
-- section 2 already states the signed-space reflection in prose.  The
-- contribution here is its executable contact with the Natural Machine's
-- restriction/boundary API.
------------------------------------------------------------------------

module PairReflectionSector where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Sigma
open import Cubical.Data.FinSet using (isFinSet ; card)
open import Cubical.Data.FinSet.Cardinality using (cardEquiv)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Algebra.CommRing
import Cubical.Algebra.Ring.Properties as RingProps

open import PerspectiveCore
  using (SectorBreak ; sector-not-inv ; restricts-suff)

private
  variable
    ℓ ℓ' : Level

module Reflection (R : CommRing ℓ) where
  open CommRingStr (snd R)
  module RT = RingProps.RingTheory (CommRing→Ring R)

  Carrier : Type ℓ
  Carrier = fst R

  Pair : Type ℓ
  Pair = Carrier × Carrier

  private
    negneg : (x : Carrier) → - (- x) ≡ x
    negneg = RT.-Idempotent

    negSub : (k x : Carrier) → - (k - x) ≡ x - k
    negSub k x =
        sym (RT.-Dist k (- x))
      ∙ cong ((- k) +_) (RT.-Idempotent x)
      ∙ +Comm (- k) x

  ----------------------------------------------------------------------
  -- 1.  The ambient reflection.
  ----------------------------------------------------------------------

  -- `J` is already the cubical path eliminator in Prelude, so the term is
  -- named `reflect`; `JEquiv` below retains the mathematical notation.
  reflect : Pair → Pair
  reflect (u , v) = u , - v

  J-involutive : (z : Pair) → reflect (reflect z) ≡ z
  J-involutive (u , v) = ≡-× refl (negneg v)

  JIso : Iso Pair Pair
  JIso = iso reflect reflect J-involutive J-involutive

  JEquiv : Pair ≃ Pair
  JEquiv = isoToEquiv JIso

  ----------------------------------------------------------------------
  -- 2.  Predicates invariant under finite-place reflection.
  ----------------------------------------------------------------------

  Both : (Carrier → Type ℓ') → Pair → Type ℓ'
  Both U (u , v) = U u × U v

  NegInvariant : (Carrier → Type ℓ') → Type (ℓ-max ℓ ℓ')
  NegInvariant U = (x : Carrier) → U x ≃ U (- x)

  module Invariant {U : Carrier → Type ℓ'} (neg-invariant : NegInvariant U) where

    private
      bothIso : (u v : Carrier) → Iso (U u × U v) (U u × U (- v))
      Iso.fun (bothIso u v) (pu , pv) =
        pu , equivFun (neg-invariant v) pv
      Iso.inv (bothIso u v) (pu , p-v) =
        pu , invEq (neg-invariant v) p-v
      Iso.rightInv (bothIso u v) (pu , p-v) =
        ≡-× refl (secEq (neg-invariant v) p-v)
      Iso.leftInv (bothIso u v) (pu , pv) =
        ≡-× refl (retEq (neg-invariant v) pv)

    both-fibrewise : (z : Pair) → Both U z ≃ Both U (equivFun JEquiv z)
    both-fibrewise (u , v) = isoToEquiv (bothIso u v)

    -- Exact contact with T14.6: J restricts because the predicate is
    -- fibrewise invariant.  For the finite-prime application U is the
    -- unit/nonzero predicate, whose invariance is multiplication by -1.
    admissible-reflection : (Σ Pair (Both U)) ≃ (Σ Pair (Both U))
    admissible-reflection =
      restricts-suff JEquiv (Both U) (Both U) both-fibrewise

    --------------------------------------------------------------------
    -- 3.  Pull J back to the one-parameter sum and difference fibres.
    --------------------------------------------------------------------

    SumCondition DiffCondition : Carrier → Carrier → Type ℓ'
    SumCondition  k x = U x × U (k - x)
    DiffCondition k x = U x × U (x - k)

    LocalSum LocalDiff : Carrier → Type (ℓ-max ℓ ℓ')
    LocalSum  k = Σ Carrier (SumCondition k)
    LocalDiff k = Σ Carrier (DiffCondition k)

    private
      second-leg-equiv : (k x : Carrier) → U (k - x) ≃ U (x - k)
      second-leg-equiv k x =
        compEquiv
          (neg-invariant (k - x))
          (pathToEquiv (cong U (negSub k x)))

      conditionIso : (k x : Carrier)
                   → Iso (SumCondition k x) (DiffCondition k x)
      Iso.fun (conditionIso k x) (px , py) =
        px , equivFun (second-leg-equiv k x) py
      Iso.inv (conditionIso k x) (px , py) =
        px , invEq (second-leg-equiv k x) py
      Iso.rightInv (conditionIso k x) (px , py) =
        ≡-× refl (secEq (second-leg-equiv k x) py)
      Iso.leftInv (conditionIso k x) (px , py) =
        ≡-× refl (retEq (second-leg-equiv k x) py)

    condition-fibrewise : (k x : Carrier)
                        → SumCondition k x ≃ DiffCondition k x
    condition-fibrewise k x = isoToEquiv (conditionIso k x)

    -- The exact equality of local solution spaces.  This is stronger than
    -- equality of their sizes and does not require finiteness.
    local-fibre-equiv : (k : Carrier) → LocalSum k ≃ LocalDiff k
    local-fibre-equiv k =
      restricts-suff (idEquiv Carrier)
        (SumCondition k) (DiffCondition k) (condition-fibrewise k)

    -- The density statement used by the singular series: on any finite
    -- instance, equivalent admissible fibres have exactly equal counts.
    local-count-equal :
      (k : Carrier)
      (finSum : isFinSet (LocalSum k))
      (finDiff : isFinSet (LocalDiff k))
      → card (LocalSum k , finSum) ≡ card (LocalDiff k , finDiff)
    local-count-equal k finSum finDiff =
      cardEquiv (LocalSum k , finSum) (LocalDiff k , finDiff)
        ∣ local-fibre-equiv k ∣₁

  ----------------------------------------------------------------------
  -- 4.  The same ambient equivalence fails on a positive cone.
  ----------------------------------------------------------------------

  module Positive
    (P : Carrier → Type ℓ')
    (positive-one : P 1r)
    (not-positive-minus-one : P (- 1r) → ⊥)
    where

    Cone : Pair → Type ℓ'
    Cone = Both P

    positive-break : SectorBreak JEquiv Cone Cone
    positive-break =
      (1r , 1r) , ((positive-one , positive-one)
        , λ z → not-positive-minus-one (z .snd))

    positive-not-invariant :
      ((z : Pair) → Cone z ≃ Cone (equivFun JEquiv z)) → ⊥
    positive-not-invariant =
      sector-not-inv JEquiv Cone Cone positive-break
