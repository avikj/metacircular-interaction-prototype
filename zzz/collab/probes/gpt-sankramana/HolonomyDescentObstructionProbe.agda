{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HolonomyDescentObstructionProbe
--
-- `AvataranaBhanga` closes the zeroth obstruction to dependent descent:
-- over an observation collision, non-equivalent fibers cannot both be the
-- pullback of one descended fiber.  This file asks the genuinely higher
-- question left open by that theorem.
--
-- Every pointwise fiber may have the SAME type, and descent may still fail.
-- A loop p : x ≡ x can carry nontrivial transport in the family F even when
-- the observation q kills that loop.  Were F pulled back from a family on O,
-- naturality of the comparison F x ≡ D (q x) would force the holonomy around
-- p to be the identity.  One moved point therefore refutes descent.
--
-- THE TERMS.
--
--   transport-roundtrip
--       transport along a type path and back is the identity.
--
--   transport-naturality
--       a pointwise identification F x ≡ D(q x) intertwines transport in F
--       with transport in D along q.
--
--   descent-kills-kernel-holonomy
--       if q sends p to refl and F descends through q, transport around p
--       fixes every inhabitant.
--
--   kernel-holonomy-obstructs-descent
--       a single inhabitant moved by such a loop refutes descent.
--
--   terminal-observation-obstruction
--       the sharp terminal case q : X → Unit: every base loop is erased, so
--       any nontrivial family holonomy prevents descent to a constant family.
--
-- This is not another pointwise-fiber argument.  `F x ≃ F x` is automatic;
-- the obstruction lives in the ACTION OF THE LOOP on that fiber.  It is the
-- next rung after `AvataranaBhanga`: existence/type profile can agree while
-- the law of transport still refuses the quotient.
--
-- STATUS.  Complete and hole-free, but intentionally outside Everything.
-- A warm Nadi carrier must load it before any green claim.  The natural next
-- instance is the repository's already-landed circuit/holonomy family
-- (`Pradakshina_…` or the smallest equivalent witness): do not rebuild that
-- family; consume its moved-point receipt here.
------------------------------------------------------------------------

module HolonomyDescentObstructionProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Relation.Nullary using (¬_)

open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1. Transport can be cancelled without assuming any h-level.
------------------------------------------------------------------------

transport-roundtrip :
  {A B : Type ℓ} (r : A ≡ B) (a : A)
  → transport (sym r) (transport r a) ≡ a
transport-roundtrip {A = A} r a =
  J (λ B r → transport (sym r) (transport r a) ≡ a)
    (transportRefl (transport refl a) ∙ transportRefl a)
    r

------------------------------------------------------------------------
-- 2. Pointwise comparison of families is natural in paths.
------------------------------------------------------------------------

transport-naturality :
  {X : Type ℓ} {O : Type ℓ'}
  {q : X → O} {F : X → Type ℓ''} {D : O → Type ℓ''}
  (comparison : (x : X) → F x ≡ D (q x))
  {x y : X} (p : x ≡ y) (a : F x)
  → transport (comparison y) (transport (cong F p) a)
    ≡ transport (cong D (cong q p)) (transport (comparison x) a)
transport-naturality {q = q} {F = F} {D = D}
                     comparison {x = x} p a =
  J (λ y p → (a : F x) →
       transport (comparison y) (transport (cong F p) a)
       ≡ transport (cong D (cong q p)) (transport (comparison x) a))
    (λ a →
       cong (transport (comparison x)) (transportRefl a)
       ∙ sym (transportRefl (transport (comparison x) a)))
    p a

------------------------------------------------------------------------
-- 3. A descended family has trivial holonomy along every loop erased by q.
------------------------------------------------------------------------

descent-kills-kernel-holonomy :
  {X : Type ℓ} {O : Type ℓ'}
  (q : X → O) (F : X → Type ℓ'')
  (x : X) (p : x ≡ x) (a : F x)
  → cong q p ≡ refl
  → DependentFactorsThrough q F
  → transport (cong F p) a ≡ a
descent-kills-kernel-holonomy q F x p a killed (D , comparison) = fixed
  where
  moved : F x
  moved = transport (cong F p) a

  same-after-comparison :
    transport (comparison x) moved ≡ transport (comparison x) a
  same-after-comparison =
      transport-naturality comparison p a
    ∙ cong (λ r → transport (cong D r) (transport (comparison x) a)) killed
    ∙ transportRefl (transport (comparison x) a)

  fixed : moved ≡ a
  fixed =
      sym (transport-roundtrip (comparison x) moved)
    ∙ cong (transport (sym (comparison x))) same-after-comparison
    ∙ transport-roundtrip (comparison x) a

------------------------------------------------------------------------
-- 4. THE NO-GO: one moved point is a complete obstruction to descent.
------------------------------------------------------------------------

kernel-holonomy-obstructs-descent :
  {X : Type ℓ} {O : Type ℓ'}
  (q : X → O) (F : X → Type ℓ'')
  (x : X) (p : x ≡ x) (a : F x)
  → cong q p ≡ refl
  → ¬ (transport (cong F p) a ≡ a)
  → ¬ DependentFactorsThrough q F
kernel-holonomy-obstructs-descent q F x p a killed moves descent =
  moves (descent-kills-kernel-holonomy q F x p a killed descent)

HolonomyWitness :
  {X : Type ℓ} (F : X → Type ℓ'') (x : X) (p : x ≡ x)
  → Type (ℓ-max ℓ ℓ'')
HolonomyWitness F x p =
  Σ[ a ∈ F x ] ¬ (transport (cong F p) a ≡ a)

kernel-holonomy-witness-obstructs-descent :
  {X : Type ℓ} {O : Type ℓ'}
  (q : X → O) (F : X → Type ℓ'')
  (x : X) (p : x ≡ x)
  → cong q p ≡ refl
  → HolonomyWitness F x p
  → ¬ DependentFactorsThrough q F
kernel-holonomy-witness-obstructs-descent q F x p killed (a , moves) =
  kernel-holonomy-obstructs-descent q F x p a killed moves

------------------------------------------------------------------------
-- 5. The terminal observation erases every loop.
------------------------------------------------------------------------

terminal-observation-obstruction :
  {X : Type ℓ} (F : X → Type ℓ'')
  (x : X) (p : x ≡ x)
  → HolonomyWitness F x p
  → ¬ DependentFactorsThrough (λ _ → tt) F
terminal-observation-obstruction F x p witness =
  kernel-holonomy-witness-obstructs-descent
    (λ _ → tt) F x p
    (isSetUnit tt tt (cong (λ _ → tt) p) refl)
    witness
