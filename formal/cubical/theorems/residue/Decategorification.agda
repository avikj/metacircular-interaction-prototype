{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Decategorification
--
-- A natural number is a connected component; the space over it has
-- geometry that the numeral forgets.
--
-- FinSet is a groupoid.  `card` collapses it to ℕ.  What this module
-- checks is that the collapse is exactly a π₀ statement:
--
--   * card is invariant along paths                (card-invariant)
--   * its fibres are connected, in the mere sense  (fibre-connected)
--   * every n is hit                               (card-Fin)
--   * and the π₀ statement itself, assembled:      (ℕ≃π₀FinSet)
--       ℕ ≃ ∥ FinSet ℓ-zero ∥₂
--
-- and that what the collapse throws away is exactly the loop space:
--
--   * FinSetLoop≃Sym : the identity type of the finite set n, computed
--     in FinSet, is the symmetric group Sₙ.
--
-- Two identifications ℕ ≃ FinSet-component and Fin n ≃ Fin n are the
-- *same kind of thing* in a univalent foundation: a path.  The first
-- carries no information, the second carries n! of it.
------------------------------------------------------------------------

module Decategorification where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin ; isSetFin)
open import Cubical.Data.Sigma
open import Cubical.Data.FinSet
open import Cubical.Data.SumFin.Properties using (SumFin≃Fin)
open import Cubical.Data.FinSet.Cardinality
open import Cubical.HITs.PropositionalTruncation as Prop
  using (∥_∥₁ ; ∣_∣₁ ; isPropPropTrunc)
open import Cubical.HITs.SetTruncation as SetTrunc
  using (∥_∥₂ ; ∣_∣₂ ; squash₂)
open import Cubical.Algebra.Group
open import Cubical.Algebra.Group.Morphisms
-- see NaturalMachine/PathIsSymmetry.agda for why this is not imported from
-- Cubical.Algebra.SymmetricGroup (the name differs between v0.5 and v0.9)

open import PathIsSymmetry using (ΩGroup ; ΩGroup≃Symmetric ; SymGroup)

------------------------------------------------------------------------
-- 1.  The standard finite set as an object of FinSet.
------------------------------------------------------------------------

-- `isFinSet` is stated with `Cubical.Data.SumFin.Fin`, so the witness
-- for the Σ-based `Cubical.Data.Fin.Fin` goes through the standard
-- comparison equivalence.
isFinSetFinℕ : {n : ℕ} → isFinSet (Fin n)
isFinSetFinℕ {n} = n , ∣ invEquiv (SumFin≃Fin n) ∣₁

𝔽 : ℕ → FinSet ℓ-zero
𝔽 n = Fin n , isFinSetFinℕ

card-Fin : (n : ℕ) → card (𝔽 n) ≡ n
card-Fin n = refl

------------------------------------------------------------------------
-- 2.  ℕ is π₀ of FinSet.
------------------------------------------------------------------------

card-invariant : (X Y : FinSet ℓ-zero) → X ≡ Y → card X ≡ card Y
card-invariant X Y = cong card

fibre-connected : (X Y : FinSet ℓ-zero) → card X ≡ card Y → ∥ X ≡ Y ∥₁
fibre-connected X Y p =
  Prop.rec isPropPropTrunc
           (λ e → ∣ equivFun (FinSet≡ X Y) (ua e) ∣₁)
           (cardInj {X = X} {Y = Y} p)

-- The two together: card X ≡ card Y is *exactly* mere equality of X and
-- Y in FinSet.  A numeral is a name for a connected component.
card≡MereEq : (X Y : FinSet ℓ-zero) → (card X ≡ card Y) ≃ ∥ X ≡ Y ∥₁
card≡MereEq X Y =
  propBiimpl→Equiv (isSetℕ _ _) isPropPropTrunc
    (fibre-connected X Y)
    (Prop.rec (isSetℕ _ _) (card-invariant X Y))

-- The π₀ statement itself, assembled from the fiberwise ingredients
-- above: ℕ IS the set truncation of FinSet.  Forward: n names the
-- component of the standard n-element set.  Backward: card descends to
-- components because ℕ is a set.  The round trips are card-Fin and
-- fibre-connected.
π₀FinSet : Type₁
π₀FinSet = ∥ FinSet ℓ-zero ∥₂

cardπ₀ : π₀FinSet → ℕ
cardπ₀ = SetTrunc.rec isSetℕ card

ℕ≃π₀FinSet : ℕ ≃ π₀FinSet
ℕ≃π₀FinSet = isoToEquiv (iso (λ n → ∣ 𝔽 n ∣₂) cardπ₀ sect retr)
  where
    sect : (x : π₀FinSet) → ∣ 𝔽 (cardπ₀ x) ∣₂ ≡ x
    sect = SetTrunc.elim (λ x → isProp→isSet (squash₂ _ _))
             (λ X → Prop.rec (squash₂ _ _) (cong ∣_∣₂)
                      (fibre-connected (𝔽 (card X)) X (card-Fin (card X))))

    retr : (n : ℕ) → cardπ₀ ∣ 𝔽 n ∣₂ ≡ n
    retr = card-Fin

------------------------------------------------------------------------
-- 3.  What the numeral forgets: the loop space of the component.
------------------------------------------------------------------------

-- Paths in FinSet are paths of underlying types (isFinSet is a prop) ...
FinSetPath≃TypePath : (X Y : FinSet ℓ-zero) → (X ≡ Y) ≃ (X .fst ≡ Y .fst)
FinSetPath≃TypePath X Y = invEquiv (FinSet≡ X Y)

-- ... and by univalence a loop at Fin n is a permutation of n letters.
FinSetLoop≃Sym : (n : ℕ) → (𝔽 n ≡ 𝔽 n) ≃ (Fin n ≃ Fin n)
FinSetLoop≃Sym n = compEquiv (FinSetPath≃TypePath (𝔽 n) (𝔽 n)) univalence

-- Stated as a group: Ω(Type, Fin n) is Sₙ.  (The FinSet loop group is
-- isomorphic to this one by FinSetLoop≃Sym; only the Type-level version
-- is packaged as a group here.)
ΩFin≃Symₙ : (n : ℕ) → GroupEquiv (ΩGroup (Fin n) isSetFin) (SymGroup (Fin n) isSetFin)
ΩFin≃Symₙ n = ΩGroup≃Symmetric (Fin n) isSetFin
