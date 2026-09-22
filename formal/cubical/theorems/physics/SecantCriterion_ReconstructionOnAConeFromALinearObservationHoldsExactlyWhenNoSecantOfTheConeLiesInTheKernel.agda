{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SecantCriterion — reconstruction on a cone C from a homomorphic
-- observation O holds exactly when no secant of C lies in the kernel:
--
--     O injective on C   ⟺   ker O ∩ (C − C) = {0}.
--
-- WHAT THIS IS.  The reconstruction test of the prime-boundary document
-- (§5): a linear observation O of a set C of states recovers the state
-- exactly when no difference of two states in C is invisible to O.  The
-- corpus's descent lemma (DescentObstructionUnified.factorObstruction)
-- is the "⇐ fails" half at one pair; this module is the whole
-- equivalence, over any group G, any group H, any homomorphism O and any
-- subset C.  Nothing is assumed about C — no positivity, no convexity —
-- because the criterion does not need it: positivity of a cone is what
-- makes C − C large, not what makes the criterion true.
--
--   §1  Secant O C : every x, y ∈ C with O (x · y⁻¹) = 1 have x · y⁻¹ = 1.
--       Injective O C : every x, y ∈ C with O x = O y have x = y.
--       secant→injective and injective→secant, from the homomorphism
--       law and the two group cancellations.
--   §2  Over ℤ × ℤ with O (a , b) = a + b: the cone of pairs with both
--       entries non-negative has the secant (1 , 0) − (0 , 1) in ker O,
--       so O does not reconstruct it (the corpus lemma, applied); the
--       sub-cone of pairs (a , 0) has no such secant, and O reconstructs
--       it.  Same observation, two cones, the criterion deciding both.
--
-- SYĀT — THE CLAIM, EXACTLY.  A group-theoretic equivalence and one
-- two-cone witness.  No topology, no linear span, no measure.  The
-- document's operator is on a function space; here O is any hom.
------------------------------------------------------------------------

module SecantCriterion_ReconstructionOnAConeFromALinearObservationHoldsExactlyWhenNoSecantOfTheConeLiesInTheKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Group
open import Cubical.Algebra.Group.Properties
open import Cubical.Algebra.Group.DirProd using (DirProd)
open import Cubical.Algebra.Group.Instances.Int using (ℤGroup)

open import DescentObstructionUnified using (FactorsThrough ; factorObstruction)

private
  T : ℤ → Type₀
  T (pos _) = Unit
  T (negsuc _) = ⊥

  pos≢negsuc : {m n : ℕ} → pos m ≡ negsuc n → ⊥
  pos≢negsuc p = subst T p tt

------------------------------------------------------------------------
-- §1  The criterion, over any two groups.
------------------------------------------------------------------------

module Criterion {ℓ ℓ' : Level} (G : Group ℓ) (H : Group ℓ') where

  private
    module G = GroupStr (G .snd)
    module H = GroupStr (H .snd)
    module GT = GroupTheory G

  -- a homomorphism, as a function with its law
  IsHom : (⟨ G ⟩ → ⟨ H ⟩) → Type (ℓ-max ℓ ℓ')
  IsHom O = (x y : ⟨ G ⟩) → O (x G.· y) ≡ O x H.· O y

  -- the difference x · y⁻¹ ("x − y")
  _−_ : ⟨ G ⟩ → ⟨ G ⟩ → ⟨ G ⟩
  x − y = x G.· G.inv y

  Injective : (O : ⟨ G ⟩ → ⟨ H ⟩) (C : ⟨ G ⟩ → Type ℓ) → Type (ℓ-max ℓ ℓ')
  Injective O C = (x y : ⟨ G ⟩) → C x → C y → O x ≡ O y → x ≡ y

  Secant : (O : ⟨ G ⟩ → ⟨ H ⟩) (C : ⟨ G ⟩ → Type ℓ) → Type (ℓ-max ℓ ℓ')
  Secant O C = (x y : ⟨ G ⟩) → C x → C y → O (x − y) ≡ H.1g → x − y ≡ G.1g

  -- a hom sends 1 to 1 and inverses to inverses
  hom1 : (O : ⟨ G ⟩ → ⟨ H ⟩) → IsHom O → O G.1g ≡ H.1g
  hom1 O h = GroupTheory.1gUniqueL H (O G.1g)
    (sym (h G.1g G.1g) ∙ cong O (G.·IdL G.1g))

  homInv : (O : ⟨ G ⟩ → ⟨ H ⟩) → IsHom O → (x : ⟨ G ⟩) → O (G.inv x) ≡ H.inv (O x)
  homInv O h x = GroupTheory.invUniqueR H
    (sym (h x (G.inv x)) ∙ cong O (G.·InvR x) ∙ hom1 O h)

  -- x − y = 1 ⟹ x = y, and x = y ⟹ x − y = 1
  diff1→eq : (x y : ⟨ G ⟩) → x − y ≡ G.1g → x ≡ y
  diff1→eq x y p = GT.invUniqueL p ∙ GT.invInv y

  eq→diff1 : (x y : ⟨ G ⟩) → x ≡ y → x − y ≡ G.1g
  eq→diff1 x y p = cong (_− y) p ∙ G.·InvR y

  secant→injective : (O : ⟨ G ⟩ → ⟨ H ⟩) → IsHom O → (C : ⟨ G ⟩ → Type ℓ)
                   → Secant O C → Injective O C
  secant→injective O h C s x y cx cy e = diff1→eq x y (s x y cx cy kill)
    where
      kill : O (x − y) ≡ H.1g
      kill = h x (G.inv y)
           ∙ cong (O x H.·_) (homInv O h y)
           ∙ cong (λ z → O x H.· H.inv z) (sym e)
           ∙ H.·InvR (O x)

  injective→secant : (O : ⟨ G ⟩ → ⟨ H ⟩) → IsHom O → (C : ⟨ G ⟩ → Type ℓ)
                   → Injective O C → Secant O C
  injective→secant O h C inj x y cx cy k = eq→diff1 x y (inj x y cx cy same)
    where
      -- O x · (O y)⁻¹ = 1  ⟹  O x = O y
      same : O x ≡ O y
      same = GroupTheory.invUniqueL H
               (sym (cong (O x H.·_) (homInv O h y)) ∙ sym (h x (G.inv y)) ∙ k)
           ∙ GroupTheory.invInv H (O y)

------------------------------------------------------------------------
-- §2  Two cones under one observation over ℤ × ℤ.
------------------------------------------------------------------------

ℤ² : Group₀
ℤ² = DirProd ℤGroup ℤGroup

open Criterion ℤ² ℤGroup

open import Cubical.Data.Int using (_+_)

sum : ℤ × ℤ → ℤ
sum (a , b) = a + b

sum-hom : IsHom sum
sum-hom (a , b) (c , d) = lemma a b c d
  where
    open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
    open import Cubical.Algebra.CommRing
    open import Cubical.Tactics.CommRingSolver
    lemma : (a b c d : ℤ) → (a + c) + (b + d) ≡ (a + b) + (c + d)
    lemma a b c d = solve! ℤCommRing

-- the quadrant: both entries are `pos`
IsPos : ℤ → Type₀
IsPos (pos _) = Unit
IsPos (negsuc _) = ⊥

Quadrant : ℤ × ℤ → Type₀
Quadrant (a , b) = IsPos a × IsPos b

-- the axis: second entry zero
Axis : ℤ × ℤ → Type₀
Axis (a , b) = b ≡ pos 0

-- (1 , 0) and (0 , 1) are both in the quadrant, agree under `sum`,
-- and differ.  So `sum` is not injective on the quadrant — stated as the
-- corpus's descent obstruction: the first coordinate does not factor
-- through `sum` on the quadrant …
quadrant-secant : ¬ FactorsThrough sum fst
quadrant-secant = factorObstruction sum fst (pos 1 , pos 0) (pos 0 , pos 1) refl
  (λ e → pos≢negsuc (cong (λ z → z + negsuc 0) e))
  -- pos 1 + (−1) = pos 0, pos 0 + (−1) = negsuc 0

-- … and the corresponding secant is in the kernel
quadrant-secant-in-kernel : sum ((pos 1 , pos 0) − (pos 0 , pos 1)) ≡ pos 0
quadrant-secant-in-kernel = refl

-- on the axis, `sum` reconstructs: O (a , 0) = a
axis-injective : Injective sum Axis
axis-injective (a , b) (c , d) pb pd e =
  cong₂ _,_ (sym (+0 a) ∙ cong (a +_) (sym pb) ∙ e ∙ cong (c +_) pd ∙ +0 c) (pb ∙ sym pd)
  where
    +0 : (z : ℤ) → z + pos 0 ≡ z
    +0 z = refl

axis-secant : Secant sum Axis
axis-secant = injective→secant sum sum-hom Axis axis-injective
