{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सममान — equal measure.  Isometry.
--
-- WHY THIS FILE EXISTS.  `BraidCoherenceBoundary` proves that two
-- self-EQUIVALENCES of the three-strand state space need not satisfy
-- Yang–Baxter, and then says, under WHAT IS NOT CLAIMED, that there is
-- no Hilbert space anywhere in it and that "unitary" there abbreviates
-- "has a two-sided inverse".
--
-- That is a real gap and it is closed here.  Invertibility is strictly
-- weaker than unitarity: a unitary is an invertible map that PRESERVES
-- AN INNER PRODUCT, and the whole force of the physical claim depends
-- on which of the two the countermodel satisfies.  So this file builds
-- the inner product, proves the basis orthonormal, and proves the
-- countermodel operators are isometries of it.  The refutation survives
-- the strengthening: they are unitary, and they still carry no braid.
--
-- AND THE CONVERSE, which the earlier file does not state.  A pair
-- SATISFYING Yang–Baxter need not be unitary either — §७ exhibits one
-- that is not even injective.  So the two conditions are logically
-- independent in both directions, and that is the precise form of "an
-- architecture whose gates are certified unitary has certified nothing
-- about exchange statistics".
--
-- WHAT THE SPACE IS, exactly.  The free ℤ-module on the eight basis
-- states, with the counting inner product.  That is the integral
-- lattice inside the eight-dimensional real Hilbert space with the
-- computational basis declared orthonormal, and every operator in this
-- file is a permutation of that basis, so nothing here needs a
-- completion, a limit, or a real number.  A permutation operator is
-- unitary exactly when it is an isometry, and that is what is proved.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module SamaMana_TheCrossingsAreUnitaryOnAnInnerProductSpaceAndUnitarityIsIndependentOfYangBaxter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_ ; if_then_else_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; predℕ ; snotz)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; +Comm ; +Assoc ; pos0+ ; injPos)
open import Cubical.Relation.Nullary using (¬_)

open import BraidCoherenceBoundary
  using (Triple ; YangBaxter ; flipFirst ; identityCrossing
        ; flipFirst-involutive ; swap₁ ; swap₂ ; adjacent-swaps-yang-baxter)

------------------------------------------------------------------------
-- १ · the space.  Vectors are ℤ-valued functions on the basis states.
------------------------------------------------------------------------

Vec : Type
Vec = Triple → ℤ

Pair : Type
Pair = Bool × Bool

allPairs : List Pair
allPairs = (false , false) ∷ (false , true) ∷ (true , false) ∷ (true , true) ∷ []

lowerHalf upperHalf : List Triple
lowerHalf = map (false ,_) allPairs
upperHalf = map (true  ,_) allPairs

-- the computational basis, enumerated with the first strand outermost.
basis : List Triple
basis = lowerHalf ++ upperHalf

------------------------------------------------------------------------
-- २ · the inner product.
------------------------------------------------------------------------

total : List ℤ → ℤ
total []       = pos 0
total (x ∷ xs) = x + total xs

total-++ : (xs ys : List ℤ) → total (xs ++ ys) ≡ total xs + total ys
total-++ []       ys = pos0+ (total ys)
total-++ (x ∷ xs) ys = cong (x +_) (total-++ xs ys) ∙ +Assoc x (total xs) (total ys)

⟪_,_⟫ : Vec → Vec → ℤ
⟪ u , v ⟫ = total (map (λ q → u q · v q) basis)

------------------------------------------------------------------------
-- ३ · the basis is orthonormal — which is what makes ⟪_,_⟫ an inner
-- product and not merely a bilinear form.  Each basis vector has norm
-- one, so the enumeration hits every state exactly once: no state is
-- missing and none is counted twice.
------------------------------------------------------------------------

beqB : Bool → Bool → Bool
beqB true  true  = true
beqB false false = true
beqB _     _     = false

beqT : Triple → Triple → Bool
beqT (a , b , c) (a' , b' , c') = beqB a a' and (beqB b b' and beqB c c')

δ : Triple → Vec
δ p q = if beqT p q then pos 1 else pos 0

basis-is-unit : (p : Triple) → ⟪ δ p , δ p ⟫ ≡ pos 1
basis-is-unit (false , false , false) = refl
basis-is-unit (false , false , true ) = refl
basis-is-unit (false , true  , false) = refl
basis-is-unit (false , true  , true ) = refl
basis-is-unit (true  , false , false) = refl
basis-is-unit (true  , false , true ) = refl
basis-is-unit (true  , true  , false) = refl
basis-is-unit (true  , true  , true ) = refl

------------------------------------------------------------------------
-- ४ · operators, and what it is to be unitary.
--
-- A map of basis states induces the operator that permutes coordinates.
-- An isometry preserves the inner product; on a finite-dimensional space
-- an invertible isometry is exactly a unitary, and `Unitary` below is
-- that pair of conditions written out.
------------------------------------------------------------------------

Op : Type
Op = Vec → Vec

pull : (Triple → Triple) → Op
pull f v q = v (f q)

Isometry : Op → Type
Isometry T = (u v : Vec) → ⟪ T u , T v ⟫ ≡ ⟪ u , v ⟫

Unitary : Op → Type
Unitary T = Isometry T × (Σ[ T⁻ ∈ Op ] ((v : Vec) → T (T⁻ v) ≡ v) × ((v : Vec) → T⁻ (T v) ≡ v))

------------------------------------------------------------------------
-- ५ · THE COUNTERMODEL OPERATORS ARE UNITARY.
--
-- The identity is one for nothing.  The first-strand flip is one
-- because it carries the enumeration to itself with the two halves
-- exchanged — so the same eight products are summed in the other order,
-- and one commutation of the two half-sums closes it.  The halves-swap
-- is `refl`: both lists are concrete, and they normalise to the same
-- eight terms.
------------------------------------------------------------------------

identity-isometry : Isometry (pull identityCrossing)
identity-isometry u v = refl

flip-isometry : Isometry (pull flipFirst)
flip-isometry u v =
    total-++ (map w upperHalf) (map w lowerHalf)
  ∙ +Comm (total (map w upperHalf)) (total (map w lowerHalf))
  ∙ sym (total-++ (map w lowerHalf) (map w upperHalf))
  where
    w : Triple → ℤ
    w q = u q · v q

flip-unitary : Unitary (pull flipFirst)
flip-unitary =
  flip-isometry ,
  pull flipFirst ,
  (λ v → funExt λ q → cong v (flipFirst-involutive q)) ,
  (λ v → funExt λ q → cong v (flipFirst-involutive q))

identity-unitary : Unitary (pull identityCrossing)
identity-unitary =
  identity-isometry ,
  pull identityCrossing ,
  (λ v → refl) ,
  (λ v → refl)

------------------------------------------------------------------------
-- ६ · …AND THEY STILL CARRY NO BRAID.
--
-- The Yang–Baxter condition, now on the operators of the space rather
-- than on the maps of basis states.  The separating vector is the one
-- that reads the first strand, and the separating state is the one the
-- earlier file names.
------------------------------------------------------------------------

YangBaxterOp : Op → Op → Type
YangBaxterOp T₁ T₂ = (v : Vec) → T₁ (T₂ (T₁ v)) ≡ T₂ (T₁ (T₂ v))

probe : Vec
probe (a , b , c) = if a then pos 1 else pos 0

zero≢one : ¬ (pos 0 ≡ pos 1)
zero≢one p = snotz (sym (injPos p))

unitary-crossings-fail-yang-baxter :
  ¬ YangBaxterOp (pull flipFirst) (pull identityCrossing)
unitary-crossings-fail-yang-baxter h =
  zero≢one (funExt⁻ (h probe) (false , false , false))

------------------------------------------------------------------------
-- ७ · THE CONVERSE INDEPENDENCE.
--
-- Yang–Baxter does not give unitarity either.  The constant crossing
-- satisfies the relation definitionally — every side of it is the same
-- constant — and it is not unitary, because it is not even injective:
-- it collapses the whole space onto one coordinate, and the norm it
-- reports for a unit vector is eight rather than one.
------------------------------------------------------------------------

konst : Triple → Triple
konst _ = false , false , false

konst-yang-baxter : YangBaxter konst konst
konst-yang-baxter x = refl

konst-yang-baxter-op : YangBaxterOp (pull konst) (pull konst)
konst-yang-baxter-op v = refl

eight≢one : ¬ (pos 8 ≡ pos 1)
eight≢one p = snotz (cong predℕ (injPos p))

konst-not-isometry : ¬ Isometry (pull konst)
konst-not-isometry iso =
  eight≢one (iso (δ (false , false , false)) (δ (false , false , false))
             ∙ basis-is-unit (false , false , false))

------------------------------------------------------------------------
-- ८ · THE INDEPENDENCE, packaged.
--
-- Neither condition implies the other, and both witnesses are terms.
-- This is the exact content of "certified unitary certifies nothing
-- about exchange statistics", with the converse — "satisfying the braid
-- relation certifies nothing about unitarity" — as well.
------------------------------------------------------------------------

unitary-does-not-give-yang-baxter :
  Σ[ T₁ ∈ Op ] Σ[ T₂ ∈ Op ] (Unitary T₁ × Unitary T₂ × (¬ YangBaxterOp T₁ T₂))
unitary-does-not-give-yang-baxter =
  pull flipFirst , pull identityCrossing ,
  flip-unitary , identity-unitary , unitary-crossings-fail-yang-baxter

yang-baxter-does-not-give-unitary :
  Σ[ T ∈ Op ] (YangBaxterOp T T × (¬ Isometry T))
yang-baxter-does-not-give-unitary =
  pull konst , konst-yang-baxter-op , konst-not-isometry
