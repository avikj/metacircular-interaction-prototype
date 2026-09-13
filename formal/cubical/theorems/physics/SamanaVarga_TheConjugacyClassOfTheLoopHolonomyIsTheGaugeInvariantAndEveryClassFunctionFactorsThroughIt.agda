{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समान-वर्ग — the same class.
--
-- ValayaSamyoga solved the gauge square on a loop: the transformed
-- holonomy is the conjugate g · W · g⁻¹.  FiniteGraphHolonomyGroupoid
-- called this "conjugacy before any trace-like quotient is taken."  This
-- file takes the quotient — the conjugacy class — and shows it is the
-- gauge invariant, in the universal sense.
--
--   §1  THE CLASS.  Conjugacy on a group is the relation h ~ (k·h)·k⁻¹;
--       the set quotient ⟨G⟩ / ~ is the type of conjugacy classes, and
--       [_] sends an element to its class.
--
--   §2  THE LOOP'S CLASS IS GAUGE INVARIANT.  On any graph loop, for any
--       connection pair and natural transformation, [hol B p] ≡ [hol A p]
--       — one step of eq/ from the solved square.  No trace, no matrix,
--       no representation: the class itself is the invariant.
--
--   §3  EVERY CLASS FUNCTION FACTORS THROUGH THE CLASS.  A conjugation-
--       invariant f into a set is the composite of [_] with a function
--       on classes (SetQuotients.rec), and the factorisation computes on
--       representatives.  So "class function" and "function on conjugacy
--       classes" are the same thing, and §2 is the reason every one of
--       them is gauge invariant at once.  This is the trace-like quotient
--       made an object, without a trace.
--
-- The lattice (AvinimayaSetu) and the graph (ValayaSamyoga) both land
-- here: on a closed loop the connection is coordinates, the class is the
-- observable.  समान (samāna, same) and वर्ग (varga, class) are ordinary
-- Sanskrit.
------------------------------------------------------------------------

module SamanaVarga_TheConjugacyClassOfTheLoopHolonomyIsTheGaugeInvariantAndEveryClassFunctionFactorsThroughIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst)
open import Cubical.Data.List using (map)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

open import FiniteGraphHolonomyGroupoid
  using (Connection ; GaugeNatural ; BranchLoop ; root ; loop)
open Connection
open GaugeNatural
import RelationalHolonomyRefinement as RHR
open import ValayaSamyoga_OnAGraphLoopGaugeNaturalityIsConjugationSoEveryClassFunctionOfTheLoopHolonomyIsGaugeInvariant
  using (valaya-saṃyoga)
import AvinimayaSetu_TheNonabelianChainTelescopesToTheEndpointLawSoTheLoopIsCovariantByConjugationAndTheAbelianInvarianceWasAnArtifactOfCommutativity
  as Setu

private
  variable
    ℓg ℓv ℓo : Level

module _ (G : Group ℓg) where

  private
    module G = GroupStr (snd G)
    open G using (_·_ ; inv)

  ----------------------------------------------------------------------
  -- १ · Conjugacy and the type of classes.
  ----------------------------------------------------------------------

  -- h is a conjugate of g.
  Saṃyukta : ⟨ G ⟩ → ⟨ G ⟩ → Type ℓg
  Saṃyukta g h = Σ[ k ∈ ⟨ G ⟩ ] ((k · g) · inv k ≡ h)

  Varga : Type ℓg
  Varga = ⟨ G ⟩ / Saṃyukta

  varga : ⟨ G ⟩ → Varga
  varga = [_]

  ----------------------------------------------------------------------
  -- २ · The class of a graph loop's holonomy is gauge invariant.
  ----------------------------------------------------------------------

  valaya-varga : {V : Type ℓv} {A B : Connection G V} (η : GaugeNatural A B)
                 {x : V} (p : x ≡ x)
               → varga (hol A p) ≡ varga (hol B p)
  valaya-varga {A = A} {B} η {x} p =
    eq/ (hol A p) (hol B p) (gauge η x , sym (valaya-saṃyoga η p))

  ----------------------------------------------------------------------
  -- ३ · Every class function factors through the class, computably.
  ----------------------------------------------------------------------

  module _ {O : Type ℓo} (setO : isSet O)
           (f : ⟨ G ⟩ → O) (invariant : RHR.ConjugationInvariant G f) where

    -- the function on classes that f descends to
    varga-f : Varga → O
    varga-f = SQ.rec setO f
      (λ g h (k , e) → sym (invariant k g) ∙ cong f e)

    -- and it computes on representatives: f is [_] followed by varga-f.
    varga-factor : (g : ⟨ G ⟩) → varga-f (varga g) ≡ f g
    varga-factor g = refl

    -- so f's gauge invariance on any graph loop is §2 read through varga-f.
    varga-avikāra : {V : Type ℓv} {A B : Connection G V} (η : GaugeNatural A B)
                    {x : V} (p : x ≡ x)
                  → f (hol A p) ≡ f (hol B p)
    varga-avikāra η p = cong varga-f (valaya-varga η p)

------------------------------------------------------------------------
-- ४ · The fork-and-loop graph, at its root loop.
------------------------------------------------------------------------

mūla-varga : (G : Group ℓg) (A B : Connection G BranchLoop) (η : GaugeNatural A B)
           → varga G (hol A loop) ≡ varga G (hol B loop)
mūla-varga G A B η = valaya-varga G η loop

------------------------------------------------------------------------
-- ५ · The lattice lands in the same class.  A closed chain's Wilson loop,
--     gauge-transformed link by link, has the same conjugacy class as
--     the original: AvinimayaSetu's conjugation read through eq/.
------------------------------------------------------------------------

setu-varga : (G : Group ℓg) (h : ⟨ G ⟩) (c : Setu.Setu G)
           → Setu.anta G h c ≡ h
           → varga G (Setu.wilson G (map fst c))
           ≡ varga G (Setu.wilson G (Setu.parivartana G h c))
setu-varga G h c band =
  eq/ _ _ (h , sym (Setu.cakra-saṃyoga G h c band))
