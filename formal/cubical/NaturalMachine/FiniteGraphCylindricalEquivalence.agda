-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

-- Network-level cylindrical consistency for the finite fork/loop graph.
-- Generator assignments on the subdivided graph, modulo gauge at the new
-- bivalent vertex, are univalently equivalent to coarse assignments.

module NaturalMachine.FiniteGraphCylindricalEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Sigma using (Σ≡Prop)
open import Cubical.Data.Prod using (_×_ ; _,_)
open import Cubical.Data.Prod.Properties using (isOfHLevelProd)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)

private variable ℓ : Level

module _ (G : Group ℓ) where
  private
    module G = GroupStr (snd G)
    module GT = GroupTheory G

  -- Coordinates are stem, branch and root-loop holonomies.  Refinement
  -- replaces the stem coordinate by its two ordered segments.
  CoarseNetwork : Type ℓ
  CoarseNetwork = ⟨ G ⟩ × (⟨ G ⟩ × ⟨ G ⟩)

  RefinedNetwork : Type ℓ
  RefinedNetwork = (⟨ G ⟩ × ⟨ G ⟩) × (⟨ G ⟩ × ⟨ G ⟩)

  collapseNetwork : RefinedNetwork → CoarseNetwork
  collapseNetwork ((a , b) , branch , loop) =
    (b G.· a) , (branch , loop)

  canonicalRefinement : CoarseNetwork → RefinedNetwork
  canonicalRefinement (stem , branch , loop) =
    (G.1g , stem) , (branch , loop)

  collapse-canonical : (x : CoarseNetwork)
    → collapseNetwork (canonicalRefinement x) ≡ x
  collapse-canonical (stem , branch , loop) i =
    G.·IdR stem i , (branch , loop)

  midpointGauge : ⟨ G ⟩ → RefinedNetwork → RefinedNetwork
  midpointGauge h ((a , b) , branch , loop) =
    ((h G.· a) , (b G.· G.inv h)) , (branch , loop)

  collapse-midpointGauge : (h : ⟨ G ⟩) (x : RefinedNetwork)
    → collapseNetwork (midpointGauge h x) ≡ collapseNetwork x
  collapse-midpointGauge h ((a , b) , branch , loop) i =
    stemPath i , (branch , loop)
    where
    stemPath : (b G.· G.inv h) G.· (h G.· a) ≡ b G.· a
    stemPath =
        G.·Assoc (b G.· G.inv h) h a
      ∙ cong (G._· a) (sym (G.·Assoc b (G.inv h) h))
      ∙ cong (λ z → (b G.· z) G.· a) (G.·InvL h)
      ∙ cong (G._· a) (G.·IdR b)

  MidpointRel : RefinedNetwork → RefinedNetwork → Type ℓ
  MidpointRel x y = Σ[ h ∈ ⟨ G ⟩ ] midpointGauge h x ≡ y

  RefinedModuloMidpoint : Type ℓ
  RefinedModuloMidpoint = RefinedNetwork / MidpointRel

  networkClass : RefinedNetwork → RefinedModuloMidpoint
  networkClass = [_]

  quotientCollapse : RefinedModuloMidpoint → CoarseNetwork
  quotientCollapse = SQ.rec
    (isOfHLevelProd 2 G.is-set (isOfHLevelProd 2 G.is-set G.is-set))
    collapseNetwork
    (λ x y r → sym (collapse-midpointGauge (fst r) x)
      ∙ cong collapseNetwork (snd r))

  coarseNetworkClass : CoarseNetwork → RefinedModuloMidpoint
  coarseNetworkClass x = networkClass (canonicalRefinement x)

  quotientCollapse-coarse : (x : CoarseNetwork)
    → quotientCollapse (coarseNetworkClass x) ≡ x
  quotientCollapse-coarse = collapse-canonical

  canonicalizeNetwork : (x : RefinedNetwork)
    → networkClass x ≡ coarseNetworkClass (collapseNetwork x)
  canonicalizeNetwork ((a , b) , branch , loop) =
    eq/ _ _ (G.inv a , refinedPath)
    where
    firstPath : G.inv a G.· a ≡ G.1g
    firstPath = G.·InvL a

    secondPath : b G.· G.inv (G.inv a) ≡ b G.· a
    secondPath = cong (b G.·_) (GT.invInv a)

    refinedPath : midpointGauge (G.inv a) ((a , b) , branch , loop)
      ≡ canonicalRefinement (collapseNetwork ((a , b) , branch , loop))
    refinedPath i = ((firstPath i , secondPath i) , (branch , loop))

  coarse-quotientCollapse : (q : RefinedModuloMidpoint)
    → coarseNetworkClass (quotientCollapse q) ≡ q
  coarse-quotientCollapse =
    SQ.elimProp (λ _ → squash/ _ _) (λ x → sym (canonicalizeNetwork x))

  networkCylindricalIso : Iso RefinedModuloMidpoint CoarseNetwork
  Iso.fun networkCylindricalIso = quotientCollapse
  Iso.inv networkCylindricalIso = coarseNetworkClass
  Iso.rightInv networkCylindricalIso = quotientCollapse-coarse
  Iso.leftInv networkCylindricalIso = coarse-quotientCollapse

  networkCylindricalEquiv : RefinedModuloMidpoint ≃ CoarseNetwork
  networkCylindricalEquiv = isoToEquiv networkCylindricalIso

  networkCylindricalPath : RefinedModuloMidpoint ≡ CoarseNetwork
  networkCylindricalPath = ua networkCylindricalEquiv

  -- Transport across the universe path computes to the collapsed stem while
  -- leaving the branch and loop coordinates unchanged.
  networkCylindricalTransport : (x : RefinedNetwork)
    → subst (λ X → X) networkCylindricalPath (networkClass x)
      ≡ collapseNetwork x
  networkCylindricalTransport x = uaβ networkCylindricalEquiv (networkClass x)
