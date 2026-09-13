{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकघात — the unipotent.
--
-- JetPravaha gave the Leibniz seam its first inhabitant, the first-order
-- jet with the Euler derivation, and showed scalars are its kernel: a
-- representation with no tangent component is invisible to the flux.
-- Over ℕ, and over any ring without 2-torsion, ℤ/2 is forced into the
-- scalars — an ε-part squares to 2aa′ε, so a self-inverse element has
-- none.  The insertion needs a group element of infinite order.
--
--   §1  THE JET OVER ℤ.  The same algebra with integer coefficients:
--       dual-number product, pointwise sum, Euler derivation, Leibniz
--       from the ring laws of ℤ alone.
--
--   §2  THE UNIPOTENT REPRESENTATION.  n ↦ 1 + nε represents the
--       additive group ℤ: (1 + nε)(1 + mε) = 1 + (n + m)ε because
--       ε² = 0.  This is the exponential of the tangent, taken exactly.
--
--   §3  THE INSERTION IS NONZERO.  The flux of a represented holonomy n
--       is (0 , n), and for n = 1 that is not zero.  flux-subdivision
--       specialised here is a statement with content: the insertion on
--       a subdivided edge (n , m) is (0 , n + m), and it splits into the
--       two edge insertions as the seam says.
--
-- एकघात (eka-ghāta, "one-power") is the corpus's own word for the rank-one
-- product (EkaGhataVivrtti); here it names 1 + nε, the element whose
-- every power is one plus a tangent.
------------------------------------------------------------------------

module Ekaghata_TheUnipotentRepresentationOfTheIntegersHasATangentSoTheFluxInsertionIsNonzero where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Int
  using (ℤ ; pos ; _+_ ; _·_ ; +Comm ; pos0+ ; ·IdL ; ·IdR ; ·AnnihilL ; ·AnnihilR ; injPos)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Algebra.Group.Base using (GroupStr)
open import Cubical.Algebra.Group.Instances.Int using (ℤGroup)
import Cubical.Data.Prod as P

open import HolonomyFluxDerivation using (FluxDerivation)
import RelationalHolonomyRefinement as RHR

private
  module Z = GroupStr (snd ℤGroup)

------------------------------------------------------------------------
-- १ · The jet over ℤ.
------------------------------------------------------------------------

Jet : Type₀
Jet = ℤ × ℤ

_⊞_ : Jet → Jet → Jet
(a , a′) ⊞ (b , b′) = (a + b , a′ + b′)

_⊠_ : Jet → Jet → Jet
(a , a′) ⊠ (b , b′) = (a · b , a · b′ + a′ · b)

pravāha : Jet → Jet
pravāha (a , a′) = ((pos 0) , a′)

leibniz : (x y : Jet) → pravāha (x ⊠ y) ≡ (pravāha x ⊠ y) ⊞ (x ⊠ pravāha y)
leibniz (a , a′) (b , b′) = cong₂ _,_ mūla śeṣa
  where
  mūla : (pos 0) ≡ (pos 0) · b + a · (pos 0)
  mūla = sym (cong₂ _+_ (·AnnihilL b) (·AnnihilR a) ∙ sym (pos0+ (pos 0)))

  r₁ : (pos 0) · b′ + a′ · b ≡ a′ · b
  r₁ = cong (_+ a′ · b) (·AnnihilL b′) ∙ sym (pos0+ (a′ · b))

  r₂ : a · b′ + a′ · (pos 0) ≡ a · b′
  r₂ = cong (a · b′ +_) (·AnnihilR a′) ∙ +Comm (a · b′) (pos 0) ∙ sym (pos0+ (a · b′))

  śeṣa : a · b′ + a′ · b ≡ ((pos 0) · b′ + a′ · b) + (a · b′ + a′ · (pos 0))
  śeṣa = sym (cong₂ _+_ r₁ r₂ ∙ +Comm (a′ · b) (a · b′))

jetPravāha : FluxDerivation ℓ-zero
FluxDerivation.Carrier jetPravāha = Jet
FluxDerivation._⋆_     jetPravāha = _⊠_
FluxDerivation._⊕_     jetPravāha = _⊞_
FluxDerivation.flux    jetPravāha = pravāha
FluxDerivation.leibniz jetPravāha = leibniz

------------------------------------------------------------------------
-- २ · The unipotent representation n ↦ 1 + nε of the additive group ℤ.
------------------------------------------------------------------------

ekaghāta : ℤ → Jet
ekaghāta n = ((pos 1) , n)

ekaghāta-mul : (n m : ℤ) → ekaghāta (n Z.· m) ≡ ekaghāta n ⊠ ekaghāta m
ekaghāta-mul n m =
  cong₂ _,_ (sym (·IdR (pos 1)))
            (sym (cong₂ _+_ (·IdL m) (·IdR n) ∙ +Comm m n))

------------------------------------------------------------------------
-- ३ · The insertion is nonzero, and the seam has content.
------------------------------------------------------------------------

-- The flux of a represented holonomy reads off its tangent.
pravāha-ekaghāta : (n : ℤ) → pravāha (ekaghāta n) ≡ ((pos 0) , n)
pravāha-ekaghāta n = refl

-- and at n = 1 that is not zero.
ekaghāta-anasta : pravāha (ekaghāta (pos 1)) ≡ ((pos 0) , (pos 0)) → ⊥
ekaghāta-anasta p = snotz (injPos (cong snd p))

-- flux-subdivision with every parameter concrete and a nonzero flux.
int-jet-subdivision =
  HolonomyFluxDerivation.flux-subdivision ℤGroup jetPravāha ekaghāta ekaghāta-mul

-- On the edge (2 , 3), whose holonomy is 3 + 2, the insertion computes.
udāharaṇa : pravāha (ekaghāta (RHR.holonomy ℤGroup (P._,_ (pos 2) (pos 3)))) ≡ ((pos 0) , (pos 5))
udāharaṇa = refl
