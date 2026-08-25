{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RootedGrothendieck
--
-- The synchronic rooted whole associated to a dependent family.  This is the
-- type-theoretic Grothendieck total space Σ r , Jewel r and its projection.
-- It does not by itself supply a category of roots, a functor, an infinite
-- reflective net, or the diachronic history of a weaving process.
--
-- Repository prior: IndraNet.Rooted (origin commit f5314e9) already checks
-- the Σ/projection/fiberEquiv core under the pinned Agda 2.6.3 toolchain.
-- This Agda 2.8 extension exposes inverse/round-trip equations, totalization
-- by actual fibers, and two-sided rooted-versus-fiber controls.  It does not
-- claim the first T25.B formalization.
------------------------------------------------------------------------

module RootedGrothendieck where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Functions.Fibration using (fiberEquiv; totalEquiv)
open import Cubical.Data.Bool using (Bool; false; true; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit)
open import Cubical.Data.Unit.Properties using (isPropUnit)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- Rooted dependent total space and Grothendieck projection
------------------------------------------------------------------------

RootedTotal : {ℓR ℓJ : Level}
  (Root : Type ℓR) → (Root → Type ℓJ) → Type (ℓ-max ℓR ℓJ)
RootedTotal Root Jewel = Σ Root Jewel

-- Delta 25's notation: U₂ = Σ (x : U) , View x.
U₂ : {ℓU ℓV : Level}
  (U : Type ℓU) → (U → Type ℓV) → Type (ℓ-max ℓU ℓV)
U₂ = RootedTotal

projectRoot : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) → RootedTotal Root Jewel → Root
projectRoot Jewel = fst

π₂ : {ℓU ℓV : Level} {U : Type ℓU}
  (View : U → Type ℓV) → U₂ U View → U
π₂ = projectRoot

atRoot : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root)
  → Jewel root → RootedTotal Root Jewel
atRoot Jewel root jewel = root , jewel

project-atRoot : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root) (jewel : Jewel root)
  → projectRoot Jewel (atRoot Jewel root jewel) ≡ root
project-atRoot Jewel root jewel = refl

RootFiber : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) → Root → Type (ℓ-max ℓR ℓJ)
RootFiber Jewel root = fiber (projectRoot Jewel) root

-- HoTT 4.8.1 specialized to the rooted family: the actual fiber of the
-- projection is canonically equivalent to the family value at that root.
rootFiberEquiv : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root)
  → RootFiber Jewel root ≃ Jewel root
rootFiberEquiv Jewel root = fiberEquiv Jewel root

π₂-fiber-equation : {ℓU ℓV : Level} {U : Type ℓU}
  (View : U → Type ℓV) (root : U)
  → fiber (π₂ View) root ≃ View root
π₂-fiber-equation = rootFiberEquiv

rootFiberIso : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root)
  → Iso (RootFiber Jewel root) (Jewel root)
rootFiberIso Jewel root = equivToIso (rootFiberEquiv Jewel root)

decodeFiber : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root)
  → RootFiber Jewel root → Jewel root
decodeFiber Jewel root = Iso.fun (rootFiberIso Jewel root)

encodeFiber : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root)
  → Jewel root → RootFiber Jewel root
encodeFiber Jewel root = Iso.inv (rootFiberIso Jewel root)

decode-encode : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root) (jewel : Jewel root)
  → decodeFiber Jewel root (encodeFiber Jewel root jewel) ≡ jewel
decode-encode Jewel root = Iso.rightInv (rootFiberIso Jewel root)

encode-decode : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) (root : Root)
  (point : RootFiber Jewel root)
  → encodeFiber Jewel root (decodeFiber Jewel root point) ≡ point
encode-decode Jewel root = Iso.leftInv (rootFiberIso Jewel root)

-- Re-totalizing all projection fibers recovers the rooted total space.
total-by-root-fibers : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ)
  → RootedTotal Root Jewel ≃ (Σ[ root ∈ Root ] RootFiber Jewel root)
total-by-root-fibers Jewel = totalEquiv (projectRoot Jewel)

------------------------------------------------------------------------
-- Rootwise change acts on the whole but does not become a history.
------------------------------------------------------------------------

RootwiseUpdate : {ℓR ℓJ : Level} {Root : Type ℓR}
  (Jewel : Root → Type ℓJ) → Type (ℓ-max ℓR ℓJ)
RootwiseUpdate {Root = Root} Jewel = (root : Root) → Jewel root → Jewel root

updateTotal : {ℓR ℓJ : Level} {Root : Type ℓR}
  {Jewel : Root → Type ℓJ}
  → RootwiseUpdate Jewel → RootedTotal Root Jewel → RootedTotal Root Jewel
updateTotal update (root , jewel) = root , update root jewel

update-preserves-root : {ℓR ℓJ : Level} {Root : Type ℓR}
  {Jewel : Root → Type ℓJ} (update : RootwiseUpdate Jewel)
  (point : RootedTotal Root Jewel)
  → projectRoot Jewel (updateTotal update point) ≡ projectRoot Jewel point
update-preserves-root update (root , jewel) = refl

------------------------------------------------------------------------
-- Non-reduction controls
------------------------------------------------------------------------

-- Equality in the total space exposes equality of roots.  No comparison of
-- jewels living over different roots is even typed until a root path is
-- supplied.
totalPath→rootPath : {ℓR ℓJ : Level} {Root : Type ℓR}
  {Jewel : Root → Type ℓJ} {left right : RootedTotal Root Jewel}
  → left ≡ right → projectRoot Jewel left ≡ projectRoot Jewel right
totalPath→rootPath = cong fst

differentRootsSeparateTotal : {ℓR ℓJ : Level} {Root : Type ℓR}
  {Jewel : Root → Type ℓJ} {left right : Root}
  → ¬ (left ≡ right)
  → (x : Jewel left) (y : Jewel right)
  → ¬ ((left , x) ≡ (right , y))
differentRootsSeparateTotal rootsDiffer x y totalPath =
  rootsDiffer (totalPath→rootPath totalPath)

-- Even arbitrary representatives of two projection fibers cannot have the
-- same underlying total point when their roots are provably different.
differentRootsSeparateFibers : {ℓR ℓJ : Level} {Root : Type ℓR}
  {Jewel : Root → Type ℓJ} {left right : Root}
  → ¬ (left ≡ right)
  → (x : RootFiber Jewel left) (y : RootFiber Jewel right)
  → ¬ (fst x ≡ fst y)
differentRootsSeparateFibers rootsDiffer x y samePoint =
  rootsDiffer (sym (snd x) ∙ cong (projectRoot _) samePoint ∙ snd y)

-- Control A: two different roots may carry equivalent fibers.  Fiber
-- equivalence therefore does not identify roots.
constantJewel : Bool → Type
constantJewel root = Unit

constant-root-fibers-equivalent :
  RootFiber constantJewel false ≃ RootFiber constantJewel true
constant-root-fibers-equivalent =
  compEquiv
    (rootFiberEquiv constantJewel false)
    (invEquiv (rootFiberEquiv constantJewel true))

constant-roots-still-different : ¬ (false ≡ true)
constant-roots-still-different = false≢true

-- Control B: different roots also do not manufacture an equivalence between
-- their fibers.  This family has Unit over false and Bool over true.
varyingJewel : Bool → Type
varyingJewel false = Unit
varyingJewel true  = Bool

Unit-not-equivalent-Bool : ¬ (Unit ≃ Bool)
Unit-not-equivalent-Bool equiv = false≢true
  (sym (secEq equiv false)
    ∙ cong (fst equiv) (isPropUnit (invEq equiv false) (invEq equiv true))
    ∙ secEq equiv true)

varying-root-fibers-not-equivalent :
  ¬ (RootFiber varyingJewel false ≃ RootFiber varyingJewel true)
varying-root-fibers-not-equivalent fiberEquivalence =
  Unit-not-equivalent-Bool
    (compEquiv
      (compEquiv
        (invEquiv (rootFiberEquiv varyingJewel false))
        fiberEquivalence)
      (rootFiberEquiv varyingJewel true))
