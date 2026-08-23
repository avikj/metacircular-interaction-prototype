{-# OPTIONS --cubical --safe #-}

-- Capability theorem for the concrete finite S₃ label.  Every equivariant
-- endomorphism of the natural transitive Fin3 action is the identity map,
-- while changing the output interface to the terminal action permits a
-- genuine information-collapsing intertwiner.  No linear representation or
-- Hilbert-space claim is involved.

module NaturalMachine.S3EquivariantEndomorphismRigidity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.SumFin using (fzero ; fsuc ; isSetFin)

open import NaturalMachine.StabilizerTorsor using (Action)
open Action
open import NaturalMachine.AbstractSpinNetworkKinematics
open Intertwiner
open import NaturalMachine.FiniteNonabelianHolonomy
open import NaturalMachine.S3ConjugacyObservation
  using (outerInject3 ; zeroNotSucc2 ; succNotZero2 ; zeroNotSucc3)
open import NaturalMachine.S3FiniteSpinNetwork

-- The stabilizer transposition (12) fixes only vertex zero.
s₁₂-fixed-only-zero : (x : Fin3)
  → (_▸_ naturalFin3Action s₁₂ x ≡ x) → x ≡ fzero
s₁₂-fixed-only-zero fzero p = refl
s₁₂-fixed-only-zero (fsuc fzero) p =
  Empty.rec (succNotZero2 (outerInject3 p))
s₁₂-fixed-only-zero (fsuc (fsuc fzero)) p =
  Empty.rec (zeroNotSucc2 (outerInject3 p))

module _ (f : Intertwiner S₃ naturalFin3Action naturalFin3Action) where

  map-zero : map f fzero ≡ fzero
  map-zero = s₁₂-fixed-only-zero (map f fzero) fixed
    where
    fixed : _▸_ naturalFin3Action s₁₂ (map f fzero) ≡ map f fzero
    fixed = equivariant f s₁₂ fzero

  map-one : map f (fsuc fzero) ≡ fsuc fzero
  map-one =
      sym (equivariant f s₀₁ fzero)
    ∙ cong (_▸_ naturalFin3Action s₀₁) map-zero

  map-two : map f (fsuc (fsuc fzero)) ≡ fsuc (fsuc fzero)
  map-two =
      sym (equivariant f s₁₂ (fsuc fzero))
    ∙ cong (_▸_ naturalFin3Action s₁₂) map-one

  endomorphism-rigid : (x : Fin3) → map f x ≡ x
  endomorphism-rigid fzero = map-zero
  endomorphism-rigid (fsuc fzero) = map-one
  endomorphism-rigid (fsuc (fsuc fzero)) = map-two

  endomorphism-map-identity : map f ≡ (λ x → x)
  endomorphism-map-identity = funExt endomorphism-rigid

intertwinerPath :
  (f g : Intertwiner S₃ naturalFin3Action naturalFin3Action)
  → map f ≡ map g → f ≡ g
map (intertwinerPath f g p i) = p i
equivariant (intertwinerPath f g p i) h x =
  isProp→PathP
    (λ j → isSetFin
      (_▸_ naturalFin3Action h (p j x))
      (p j (_▸_ naturalFin3Action h x)))
    (equivariant f h x) (equivariant g h x) i

-- Full classification, including proof fields: the endomorphism type is
-- contractible, centered at the identity intertwiner.
naturalEndomorphisms-contractible :
  isContr (Intertwiner S₃ naturalFin3Action naturalFin3Action)
fst naturalEndomorphisms-contractible = identityVertex
snd naturalEndomorphisms-contractible f =
  intertwinerPath identityVertex f (sym (endomorphism-map-identity f))

-- The terminal interface changes the theorem: it is equivariant precisely
-- because it is allowed to forget distinctions that no Fin3 endomorphism can.
terminal-collapses-zero-one :
  map terminalVertex fzero ≡ map terminalVertex (fsuc fzero)
terminal-collapses-zero-one = refl

one3 : Fin3
one3 = fsuc fzero

source-zero-one-distinct : fzero ≡ one3 → ⊥
source-zero-one-distinct = zeroNotSucc3
