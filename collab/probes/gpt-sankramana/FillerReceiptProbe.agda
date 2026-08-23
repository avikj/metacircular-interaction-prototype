{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FillerReceiptProbe
--
-- A daemon-facing complete candidate, not yet a landed theorem.  The previous
-- YugapatSankramana proposal did two things separately:
--
--   (1) proved that the two coordinatewise compiler composites are equal
--       as equivalences;
--   (2) drew the two-dimensional family (i , j) ↦ ua e i × ua f j.
--
-- It did not identify the family as a Square whose four boundary paths are
-- the compiler paths.  That missing identification is the actual receipt.
--
-- Closed below as one no-hole file:
--   * the explicit product square;
--   * its boundary-composition equality by Square→compPath;
--   * the equality of executable compiler composites;
--   * the compiler-boundary equality via uaCompEquiv;
--   * a Square whose boundaries are exactly the four compiler paths;
--   * the two edge receipts identifying pathToEquiv of the explicit product
--     paths with the hand-built coordinate compilers, componentwise by uaβ;
--   * the corresponding equalities between the explicit edges and compiler
--     edges in the universe.
--
-- STATUS.  The two uaβ terms were formerly interaction holes.  They now stand
-- in the file so one warm Nadi load yields an exact acceptance or the first
-- exact refusal.  Nothing here is called checked until that load is recorded.
--
-- The guardedness pragma is load-bearing even though this probe defines no
-- coinductive object: the imported cubical world is infective. Omitting it
-- can refuse the file before the mathematical question is posed.
------------------------------------------------------------------------

module FillerReceiptProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; secEq ; retEq ; equivEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence
  using (ua ; uaβ ; uaη ; uaCompEquiv ; pathToEquiv)
open import Cubical.Foundations.Path using (Square→compPath ; compPath→Square)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; ΣPathP)

private
  variable
    ℓ : Level
    A B C D : Type ℓ

------------------------------------------------------------------------
-- 1. The executable coordinate compilers.
------------------------------------------------------------------------

leftCompiler : {A B : Type ℓ} → A ≃ B → (C : Type ℓ)
             → (A × C) ≃ (B × C)
leftCompiler e C = isoToEquiv is
  where
  is : Iso (A × C) (B × C)
  Iso.fun is (a , c) = equivFun e a , c
  Iso.inv is (b , c) = invEq e b , c
  Iso.rightInv is (b , c) = ΣPathP (secEq e b , refl)
  Iso.leftInv  is (a , c) = ΣPathP (retEq e a , refl)

rightCompiler : (A : Type ℓ) → {C D : Type ℓ} → C ≃ D
              → (A × C) ≃ (A × D)
rightCompiler A f = isoToEquiv is
  where
  is : Iso (A × C) (A × D)
  Iso.fun is (a , c) = a , equivFun f c
  Iso.inv is (a , d) = a , invEq f d
  Iso.rightInv is (a , d) = ΣPathP (refl , secEq f d)
  Iso.leftInv  is (a , c) = ΣPathP (refl , retEq f c)

leftThenRight : A ≃ B → C ≃ D → (A × C) ≃ (B × D)
leftThenRight e f =
  compEquiv (leftCompiler e C) (rightCompiler B f)

rightThenLeft : A ≃ B → C ≃ D → (A × C) ≃ (B × D)
rightThenLeft e f =
  compEquiv (rightCompiler A f) (leftCompiler e D)

compilerRoutesEqual : (e : A ≃ B) (f : C ≃ D)
                    → leftThenRight e f ≡ rightThenLeft e f
compilerRoutesEqual e f = equivEq (funExt λ { (a , c) → refl })

------------------------------------------------------------------------
-- 2. The explicit cubical family, now given its actual Square type.
--
-- Square's outer interval is vertical and its inner interval horizontal,
-- hence the argument order below is f first, e second.
------------------------------------------------------------------------

topPath : A ≃ B → (C : Type ℓ) → (A × C) ≡ (B × C)
topPath e C i = ua e i × C

sidePath : (A : Type ℓ) → C ≃ D → (A × C) ≡ (A × D)
sidePath A f i = A × ua f i

explicitSquare : (e : A ≃ B) (f : C ≃ D)
  → Square (topPath e C) (topPath e D)
           (sidePath A f) (sidePath B f)
explicitSquare e f i j = ua e j × ua f i

-- The filler itself emits the equality of its two boundary routes.
explicitBoundary : (e : A ≃ B) (f : C ≃ D)
  → sidePath A f ∙ topPath e D ≡ topPath e C ∙ sidePath B f
explicitBoundary e f = Square→compPath (explicitSquare e f)

------------------------------------------------------------------------
-- 3. The same boundary, stated in the executable compiler paths.
------------------------------------------------------------------------

compiledBoundary : (e : A ≃ B) (f : C ≃ D)
  → ua (rightCompiler A f) ∙ ua (leftCompiler e D)
  ≡ ua (leftCompiler e C) ∙ ua (rightCompiler B f)
compiledBoundary e f =
    sym (uaCompEquiv (rightCompiler A f) (leftCompiler e D))
  ∙ sym (cong ua (compilerRoutesEqual e f))
  ∙ uaCompEquiv (leftCompiler e C) (rightCompiler B f)

-- This is a genuine filler whose four edges are exactly the executable
-- compiler paths.  It does not rely on a picture of a square.
compiledSquare : (e : A ≃ B) (f : C ≃ D)
  → Square (ua (leftCompiler e C)) (ua (leftCompiler e D))
           (ua (rightCompiler A f)) (ua (rightCompiler B f))
compiledSquare e f = compPath→Square (compiledBoundary e f)

------------------------------------------------------------------------
-- 4. The missing edge receipts, now supplied as terms.
--
-- Transport along the explicit product path acts componentwise.  Cubical
-- univalence computes the moving component by uaβ; the fixed component is
-- refl.  equivEq promotes pointwise computation to equality of equivalences.
------------------------------------------------------------------------

leftTransportIsCompiler : (e : A ≃ B) (C : Type ℓ)
  → pathToEquiv (topPath e C) ≡ leftCompiler e C
leftTransportIsCompiler e C =
  equivEq (funExt λ { (a , c) → ΣPathP (uaβ e a , refl) })

rightTransportIsCompiler : (A : Type ℓ) (f : C ≃ D)
  → pathToEquiv (sidePath A f) ≡ rightCompiler A f
rightTransportIsCompiler A f =
  equivEq (funExt λ { (a , c) → ΣPathP (refl , uaβ f c) })

-- Univalence now identifies each explicit edge with the corresponding compiler
-- edge in the universe.  These are the receipts absent from the first proposal.

topIsCompiled : (e : A ≃ B) (C : Type ℓ)
  → topPath e C ≡ ua (leftCompiler e C)
topIsCompiled e C =
  sym (uaη (topPath e C)) ∙ cong ua (leftTransportIsCompiler e C)

sideIsCompiled : (A : Type ℓ) (f : C ≃ D)
  → sidePath A f ≡ ua (rightCompiler A f)
sideIsCompiled A f =
  sym (uaη (sidePath A f)) ∙ cong ua (rightTransportIsCompiler A f)
