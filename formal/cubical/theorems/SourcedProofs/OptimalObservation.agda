{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.OptimalObservation
--
-- "Optimal" has been a word in three module headers.  Here it is a
-- definition, with the three instances proved against it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE DEFINITION
--
--     Optimal X Y obs  =  Injective obs  ×  (card Y ≡ card X)
--
-- A scheme is optimal when it loses nothing and wastes nothing: injective,
-- and with no more outcomes than there are inputs.  The content is that
-- this forces minimality among ALL schemes:
--
--     optimal→minimal :
--       Optimal X Y obs → (Z : FinSet) (g : X → Z .fst) → Injective g
--       → card Y ≤ card Z
--
-- — an optimal scheme's outcome count is a lower bound for every lossless
-- scheme on the same inputs, by `LosslessLowerBound`'s pigeonhole.
--
-- ────────────────────────────────────────────────────────────────────
-- THE INSTANCES, ALREADY IN THIS REPOSITORY AND NOT PREVIOUSLY COMPARED
--
--   Piṅgala, uddiṣṭa       Vak n     ≃ Fin (saṅkhyā n)     c. 300 BCE
--   Virahāṅka, mātrāmeru   Metre n   ≃ Fin (mātrā n)       c. 600–800
--   the walk, frontier 8   Fin 840   ≃ residue vector      (CRT)
--
-- Three enumeration problems, three explicit decodes, one notion of
-- optimality, one proof.  The first two come with their inverses named as
-- algorithms — naṣṭa is the inverse of uddiṣṭa and has its own word — and
-- the third comes with CRT.
--
-- WHAT IS NOT CLAIMED.  That optimality in this sense is interesting for
-- infinite families, where `card` does not exist; that an optimal scheme
-- is unique (it is not — any bijection onto the same target is optimal);
-- or anything about the COST of computing the decode, which is
-- `Laghava`'s subject and is invisible here by construction.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.OptimalObservation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (compEquiv ; invEquiv)
open import Cubical.Functions.Embedding using (injEmbedding)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.FinSet using (FinSet ; card ; isFinSet→isSet)
open import Cubical.Data.FinSet.Cardinality using (card↪Inequality')
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Data.SumFin using () renaming (SumFin≃Fin to sumFin≃Fin)

open import SourcedProofs.PingalaPrastara using (Vak ; sankhya ; uddistaIso ; Metre ; matra ; matraCount)
open import NaturalMachine.WalkObservationCount using (walk-observation-space)

------------------------------------------------------------------------
-- 1.  Losslessness and optimality
------------------------------------------------------------------------

Injective : {A B : Type} → (A → B) → Type
Injective {A = A} f = {x y : A} → f x ≡ f y → x ≡ y

Lossless : (X Y : FinSet ℓ-zero) → (X .fst → Y .fst) → Type
Lossless X Y obs = Injective obs

Optimal : (X Y : FinSet ℓ-zero) → (X .fst → Y .fst) → Type
Optimal X Y obs = Lossless X Y obs × (card Y ≡ card X)

------------------------------------------------------------------------
-- 2.  An optimal scheme is minimal among all lossless schemes
------------------------------------------------------------------------

lossless-needs-room :
  (X Y : FinSet ℓ-zero) (g : X .fst → Y .fst) → Lossless X Y g
  → card X ≤ card Y
lossless-needs-room X Y g inj =
  card↪Inequality' X Y g (injEmbedding (isFinSet→isSet (Y .snd)) inj)

optimal→minimal :
  (X Y : FinSet ℓ-zero) (obs : X .fst → Y .fst) → Optimal X Y obs
  → (Z : FinSet ℓ-zero) (g : X .fst → Z .fst) → Lossless X Z g
  → card Y ≤ card Z
optimal→minimal X Y obs (_ , tight) Z g inj =
  subst (_≤ card Z) (sym tight) (lossless-needs-room X Z g inj)

------------------------------------------------------------------------
-- 3.  An isomorphism gives an optimal scheme
------------------------------------------------------------------------

isoInjective : {A B : Type} (i : Iso A B) → Injective (Iso.fun i)
isoInjective i {x} {y} p =
    sym (Iso.leftInv i x)
  ∙ cong (Iso.inv i) p
  ∙ Iso.leftInv i y

------------------------------------------------------------------------
-- 4.  The three instances
------------------------------------------------------------------------

-- Piṅgala, c. 300 BCE — uddiṣṭa, with naṣṭa as its named inverse
VakSet : (n : ℕ) → FinSet ℓ-zero
VakSet n = Vak n , sankhya n ,
  ∣ compEquiv (isoToEquiv (uddistaIso n)) (invEquiv (sumFin≃Fin (sankhya n))) ∣₁

RowSet : (n : ℕ) → FinSet ℓ-zero
RowSet n = Fin (sankhya n) , sankhya n , ∣ invEquiv (sumFin≃Fin (sankhya n)) ∣₁

pingala-optimal : (n : ℕ) → Optimal (VakSet n) (RowSet n) (Iso.fun (uddistaIso n))
pingala-optimal n = isoInjective (uddistaIso n) , refl

-- Virahāṅka, c. 600–800 — the mātrāmeru count
MetreSet : (n : ℕ) → FinSet ℓ-zero
MetreSet n = Metre n , matra n ,
  ∣ compEquiv (isoToEquiv (matraCount n)) (invEquiv (sumFin≃Fin (matra n))) ∣₁

MatraRowSet : (n : ℕ) → FinSet ℓ-zero
MatraRowSet n = Fin (matra n) , matra n , ∣ invEquiv (sumFin≃Fin (matra n)) ∣₁

virahanka-optimal :
  (n : ℕ) → Optimal (MetreSet n) (MatraRowSet n) (Iso.fun (matraCount n))
virahanka-optimal n = isoInjective (matraCount n) , refl

-- the walk at frontier 8 — the residue vector, counted by CRT
InputSet8 : FinSet ℓ-zero
InputSet8 = Fin 840 , 840 , ∣ invEquiv (sumFin≃Fin 840) ∣₁

ResidueSet8 : FinSet ℓ-zero
ResidueSet8 =
  (((Fin 8 × Fin 3) × Fin 5) × Fin 7) , 840 ,
  ∣ compEquiv (invEquiv walk-observation-space) (invEquiv (sumFin≃Fin 840)) ∣₁

walk8-optimal :
  Optimal InputSet8 ResidueSet8 (walk-observation-space .fst)
walk8-optimal = inj , refl
  where
  open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq)
  inj : Injective (walk-observation-space .fst)
  inj {x} {y} p =
      sym (retEq walk-observation-space x)
    ∙ cong (invEq walk-observation-space) p
    ∙ retEq walk-observation-space y

------------------------------------------------------------------------
-- 5.  So all three are minimal, by one theorem.
--
-- `optimal→minimal` applied to each says: no lossless scheme on those
-- inputs has fewer outcomes.  Piṅgala's 2ⁿ, Virahāṅka's mātrāmeru, and
-- the walk's 840 are not counts that happen to be small — they are
-- minima, and the same four lines prove it for all three.
------------------------------------------------------------------------

pingala-minimal :
  (n : ℕ) (Z : FinSet ℓ-zero) (g : Vak n → Z .fst) → Lossless (VakSet n) Z g
  → sankhya n ≤ card Z
pingala-minimal n = optimal→minimal (VakSet n) (RowSet n) _ (pingala-optimal n)

virahanka-minimal :
  (n : ℕ) (Z : FinSet ℓ-zero) (g : Metre n → Z .fst) → Lossless (MetreSet n) Z g
  → matra n ≤ card Z
virahanka-minimal n = optimal→minimal (MetreSet n) (MatraRowSet n) _ (virahanka-optimal n)

walk8-minimal :
  (Z : FinSet ℓ-zero) (g : Fin 840 → Z .fst) → Lossless InputSet8 Z g
  → 840 ≤ card Z
walk8-minimal = optimal→minimal InputSet8 ResidueSet8 _ walk8-optimal
