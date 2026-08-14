{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ActionResidualPhase
--
-- The exact response-character port of ActionResidual.
--
-- A sign character converts the additive equivariance residual
--
--   delta(x) = q(step x) - predict(q x)
--
-- into the relative phase
--
--   chi(q(step x)) chi(predict(q x)).
--
-- For a reversible state action this is the pointwise phase of the usual
-- conjugated diagonal-oracle product.  The checked statement is algebraic:
-- it does not assume a Hilbert-space or gate library.
--
-- The hostile integer instance is decisive.  ActionResidual proves that
-- square under successor forms the injective residual delta(x)=2x.  Every
-- sign character is nevertheless trivial on every double, so this strict
-- classical refinement compiles to the identity sign phase.
------------------------------------------------------------------------

module NaturalMachine.ActionResidualPhase where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Empty using (elim)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Algebra.AbGroup.Base
  using (AbGroup ; AbGroupStr)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

import ResponseCharacterKickback as RK
import NaturalMachine.ActionResidual as AR

------------------------------------------------------------------------
-- 1. Sign characters turn subtraction into relative multiplication
------------------------------------------------------------------------

open RK using
  ( Sign ; plus ; minus ; _·s_ ; plus≢minus ; Character )

sign-square : (a : Sign) → a ·s a ≡ plus
sign-square plus  = refl
sign-square minus = refl

-- Every sign is its own inverse.  The formulation below is the exact
-- cancellation fact needed to derive chi(-a)=chi(a) without postulating an
-- inverse operation on Sign.
sign-right-inverse-self :
  (a b : Sign) → a ·s b ≡ plus → b ≡ a
sign-right-inverse-self plus  plus  h = refl
sign-right-inverse-self plus  minus h =
  elim (plus≢minus (sym h))
sign-right-inverse-self minus plus  h =
  elim (plus≢minus (sym h))
sign-right-inverse-self minus minus h = refl

module RelativeSignPhase
  {ℓx : Level} {X : Type ℓx}
  (A : AbGroup 0ℓ)
  (q : X → ⟨ A ⟩)
  (step : X → X)
  (predict : ⟨ A ⟩ → ⟨ A ⟩)
  (χ : Character ⟨ A ⟩
        (AbGroupStr._+_ (snd A))
        (AbGroupStr.0g (snd A)))
  where

  open AbGroupStr (snd A)
    using (_+_ ; -_ ; _-_ ; 0g ; +InvR)
  module D = AR.DefectCoordinate A q step predict

  char : ⟨ A ⟩ → Sign
  char = RK.Character.char χ

  char-neg : (a : ⟨ A ⟩) → char (- a) ≡ char a
  char-neg a = sign-right-inverse-self (char a) (char (- a))
    (  sym (RK.Character.char-mul χ a (- a))
     ∙ cong char (+InvR a)
     ∙ RK.Character.char-unit χ )

  relativePhase : X → Sign
  relativePhase x = char (D.after x) ·s char (predict (q x))

  -- Exact pointwise phase identity.  Because every sign is self-inverse,
  -- multiplication by the predicted phase is multiplication by its inverse.
  character-residual-is-relative :
    (x : X) → char (D.residual x) ≡ relativePhase x
  character-residual-is-relative x =
      RK.Character.char-mul χ (D.after x) (- predict (q x))
    ∙ cong (char (D.after x) ·s_) (char-neg (predict (q x)))

  relative-phase-is-character-residual :
    (x : X) → relativePhase x ≡ char (D.residual x)
  relative-phase-is-character-residual x =
    sym (character-residual-is-relative x)

------------------------------------------------------------------------
-- 2. The checked R0044 event is classically faithful and sign-phase trivial
------------------------------------------------------------------------

module IntegerSquareSuccessorNoGo where

  module I = AR.IntegerFormationEvent
  module S = I.S

  open CommRingStr (snd ℤCommRing)
    using (_+_ ; _·_ ; 1r ; ·IdR)

  IntegerSignCharacter : Type₀
  IntegerSignCharacter = Character ℤ _+_ (pos 0)

  squareResidual-as-double-sum :
    (x : ℤ) → I.squareResidual x ≡ x + x
  squareResidual-as-double-sum x =
      S.translation-residual 1r x
    ∙ cong₂ _+_ (·IdR x) (·IdR x)

  -- The no-go: every possible clean Boolean/sign response character erases
  -- the entire injective residual, not merely the witness pair {1,-1}.
  every-sign-phase-is-identity :
    (χ : IntegerSignCharacter) (x : ℤ)
    → RK.Character.char χ (I.squareResidual x) ≡ plus
  every-sign-phase-is-identity χ x =
      cong (RK.Character.char χ) (squareResidual-as-double-sum x)
    ∙ RK.Character.char-mul χ x x
    ∙ sign-square (RK.Character.char χ x)

  every-pair-phase-collides :
    (χ : IntegerSignCharacter) (x y : ℤ)
    → RK.Character.char χ (I.squareResidual x)
      ≡ RK.Character.char χ (I.squareResidual y)
  every-pair-phase-collides χ x y =
      every-sign-phase-is-identity χ x
    ∙ sym (every-sign-phase-is-identity χ y)

  -- Hostile comparison retained from R0044 in the same checked module:
  -- the underlying classical residual has no collisions at all.
  classical-residual-is-injective :
    (x y : ℤ) → I.squareResidual x ≡ I.squareResidual y → x ≡ y
  classical-residual-is-injective = I.residual-injective

  faithful-classical-trivial-phase :
    ((x y : ℤ) → I.squareResidual x ≡ I.squareResidual y → x ≡ y)
    × ((χ : IntegerSignCharacter) (x : ℤ)
      → RK.Character.char χ (I.squareResidual x) ≡ plus)
  faithful-classical-trivial-phase =
    classical-residual-is-injective , every-sign-phase-is-identity

