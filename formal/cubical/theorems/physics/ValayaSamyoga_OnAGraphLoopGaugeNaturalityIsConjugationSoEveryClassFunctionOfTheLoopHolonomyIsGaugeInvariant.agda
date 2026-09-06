{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वलय-संयोग — the loop's conjugation.
--
-- FiniteGraphHolonomyGroupoid realises a gauge transformation as a
-- natural transformation between connection functors, GaugeNatural, and
-- proves loop-gauge-square: on a loop, naturality reads
--
--     hol B p · g  ≡  g · hol A p        (g the gauge at the base point)
--
-- — "endpoint conjugacy before any trace-like quotient is taken."  This
-- file takes the quotient's worth of consequences without a quotient.
--
--   §1  THE SQUARE SOLVED.  Multiply by g⁻¹ on the right and cancel:
--       hol B p ≡ g · hol A p · g⁻¹.  The transformed loop holonomy IS
--       the conjugate, as a term, for any connection pair, any natural
--       transformation, any loop in any graph.
--
--   §2  CLASS FUNCTIONS OF THE GRAPH LOOP ARE GAUGE INVARIANT.  The
--       conjugate is RelationalHolonomyRefinement's endpointGauge (g , g),
--       verbatim, so closedLoopGaugeInvariant lifts to graph loops: for
--       every conjugation-invariant f, f (hol B p) ≡ f (hol A p).
--
--   §3  ON THE FORK-AND-LOOP GRAPH.  Specialised to the HIT's own loop
--       at its root, and to the flatness class function of AvinimayaSetu:
--       whether the loop's holonomy is trivial is a gauge-invariant
--       question on the graph.
--
-- With AvinimayaSetu the picture closes from both ends: the lattice
-- chain telescopes to the endpoint law, the graph groupoid's naturality
-- squares to the same law, and on a closed loop both are conjugation.
-- वलय (valaya, ring/loop) is ordinary Sanskrit.
------------------------------------------------------------------------

module ValayaSamyoga_OnAGraphLoopGaugeNaturalityIsConjugationSoEveryClassFunctionOfTheLoopHolonomyIsGaugeInvariant where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
import Cubical.Data.Prod as P

open import FiniteGraphHolonomyGroupoid
  using (Connection ; GaugeNatural ; loop-gauge-square ; BranchLoop ; root ; loop)
open Connection
open GaugeNatural
import RelationalHolonomyRefinement as RHR
import AvinimayaSetu_TheNonabelianChainTelescopesToTheEndpointLawSoTheLoopIsCovariantByConjugationAndTheAbelianInvarianceWasAnArtifactOfCommutativity
  as Setu

private
  variable
    ℓg ℓv ℓo : Level

module _ {G : Group ℓg} {V : Type ℓv} where

  private
    module G = GroupStr (snd G)
    open G using (_·_ ; inv)

  ----------------------------------------------------------------------
  -- १ · The square solved: the transformed loop holonomy is the conjugate.
  ----------------------------------------------------------------------

  valaya-saṃyoga : {A B : Connection G V} (η : GaugeNatural A B)
                   {x : V} (p : x ≡ x)
                 → hol B p ≡ (gauge η x · hol A p) · inv (gauge η x)
  valaya-saṃyoga {A} {B} η {x} p =
      sym (G.·IdR (hol B p))
    ∙ cong (hol B p ·_) (sym (G.·InvR g))
    ∙ G.·Assoc (hol B p) g (inv g)
    ∙ cong (_· inv g) (loop-gauge-square η p)
    where
    g = gauge η x

  -- and that conjugate is the endpoint law at a closed loop, verbatim.
  valaya-endpoint : {A B : Connection G V} (η : GaugeNatural A B)
                    {x : V} (p : x ≡ x)
                  → hol B p ≡ RHR.endpointGauge G (P._,_ (gauge η x) (gauge η x)) (hol A p)
  valaya-endpoint = valaya-saṃyoga

  ----------------------------------------------------------------------
  -- २ · Every class function of the loop holonomy is gauge invariant.
  ----------------------------------------------------------------------

  varga-avikāra : {O : Type ℓo} (f : ⟨ G ⟩ → O)
                → RHR.ConjugationInvariant G f
                → {A B : Connection G V} (η : GaugeNatural A B)
                  {x : V} (p : x ≡ x)
                → f (hol B p) ≡ f (hol A p)
  varga-avikāra f invariant {A} {B} η {x} p =
      cong f (valaya-saṃyoga η p)
    ∙ RHR.closedLoopGaugeInvariant G f invariant (gauge η x) (hol A p)

------------------------------------------------------------------------
-- ३ · On the fork-and-loop graph, at its own loop, for flatness.
------------------------------------------------------------------------

module _ (G : Group ℓg) where

  -- The HIT's loop at the root: transformed holonomy is the conjugate.
  mūla-valaya : (A B : Connection G BranchLoop) (η : GaugeNatural A B)
              → hol B loop
              ≡ GroupStr._·_ (snd G)
                  (GroupStr._·_ (snd G) (gauge η root) (hol A loop))
                  (GroupStr.inv (snd G) (gauge η root))
  mūla-valaya A B η = valaya-saṃyoga η loop

  -- Whether the root loop is flat is a gauge-invariant question.
  samatala-valaya : (A B : Connection G BranchLoop) (η : GaugeNatural A B)
                  → Setu.samatala G (hol B loop) ≡ Setu.samatala G (hol A loop)
  samatala-valaya A B η =
    varga-avikāra (Setu.samatala G) (Setu.samatala-varga G) η loop
