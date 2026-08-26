{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HolonomyDescentObstructionCorrectedProbe
--
-- The higher obstruction to dependent descent.  This corrected copy differs
-- from the first probe only at one universe annotation: `HolonomyWitness`
-- lives in the fiber universe ℓ'', because x and p are parameters rather than
-- stored data.  The first probe remains as provenance for that pre-kernel
-- correction.
------------------------------------------------------------------------

module HolonomyDescentObstructionCorrectedProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Unit using (tt ; isSetUnit)
open import Cubical.Relation.Nullary using (¬_)

open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' ℓ'' : Level

transport-roundtrip :
  {A B : Type ℓ} (r : A ≡ B) (a : A)
  → transport (sym r) (transport r a) ≡ a
transport-roundtrip {A = A} r a =
  J (λ B r → transport (sym r) (transport r a) ≡ a)
    (transportRefl (transport refl a) ∙ transportRefl a)
    r

-- 2026-08-24, repair from outside this lane (see the STATUS note at the head
-- of the file).  `q`, `F` and `D` were IMPLICIT here, and they are not
-- inferable from `comparison` at any Agda version: its type mentions
-- `D (q x)`, so solving it means solving `_D (_q x) ≡ D (q x)` — a
-- metavariable applied to another metavariable's output, outside Miller's
-- pattern fragment, which Agda leaves as an unsolved constraint rather than
-- guessing.  The kernel said so verbatim:
--
--     _D_246 (_q_244 x) = D (q x) : Type ℓ'' (blocked on _D_246)
--
-- Made explicit and passed at the one call site.  Nothing about the
-- mathematics changes — the J-elimination below is untouched.
transport-naturality :
  {X : Type ℓ} {O : Type ℓ'}
  (q : X → O) (F : X → Type ℓ'') (D : O → Type ℓ'')
  (comparison : (x : X) → F x ≡ D (q x))
  {x y : X} (p : x ≡ y) (a : F x)
  → transport (comparison y) (transport (cong F p) a)
    ≡ transport (cong D (cong q p)) (transport (comparison x) a)
transport-naturality q F D
                     comparison {x = x} p a =
  J (λ y p → (a : F x) →
       transport (comparison y) (transport (cong F p) a)
       ≡ transport (cong D (cong q p)) (transport (comparison x) a))
    (λ a →
       cong (transport (comparison x)) (transportRefl a)
       ∙ sym (transportRefl (transport (comparison x) a)))
    p a

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
      transport-naturality q F D comparison p a
    ∙ cong (λ r → transport (cong D r) (transport (comparison x) a)) killed
    ∙ transportRefl (transport (comparison x) a)

  fixed : moved ≡ a
  fixed =
      sym (transport-roundtrip (comparison x) moved)
    ∙ cong (transport (sym (comparison x))) same-after-comparison
    ∙ transport-roundtrip (comparison x) a

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
  → Type ℓ''
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
