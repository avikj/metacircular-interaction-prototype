{-# OPTIONS --safe --cubical --guardedness #-}

------------------------------------------------------------------------
-- GoalCoherenceIsATransportInvariant — the goal-coherence of a form (the
-- exactness / holonomy class of its preference field) is a TRANSPORT
-- INVARIANT of the state space: it ingresses LOSSLESSLY into every
-- embodiment, and it is a property of the FORM, not of the carrier or its
-- history.  This is the checked bridge between the two largest lanes of
-- the corpus — the univalent universe of forms (theorems/logic/,
-- Anekantatva, DravyaParyaya) and the cochain/holonomy calculus
-- (HolonomyCriterionForExactness) — and it is exactly the statement of
-- Michael Levin's "agential gifts / free lunches from Platonic space".
--
-- ====================================================================
-- THE READING (zero empiricism; three kinds of claim, never blurred).
--
-- FORMALIZATION.  Levin's "Platonic space" is the univalent universe of
--   forms; a "form" (a pattern of body or mind) is a type; a physical
--   body that "ingresses" the form is an INTERFACE / POINTER onto it — a
--   presentation, i.e. an equivalence e : Carrier ≃ Form (Anekantatva:
--   the space of such presentations is contractible, so a form is
--   DISCOVERED, not invented, and no embodiment is privileged;
--   DravyaParyaya: transport along e is the free, lossless road, and
--   there is none between distinct forms).  A form's AGENCY is the extra
--   structure it carries over that bare type — Levin's VARIABLE-AGENCY
--   SPECTRUM as increasing structure:
--       bare type                         (a "low-agency" pattern: e, π, a
--                                          triangle — it just sits there)
--     + a preference field  ω : Cochain   (a value/potential landscape —
--                                          a policy / dynamical propensity)
--     + Exact ω                           (a COHERENT global goal: the
--                                          policy descends one potential —
--                                          "a kind of mind" that wants one
--                                          consistent thing)
--     + nonabelian ω                       (anticipatory / counterfactual
--                                          goals — the value group here is
--                                          already arbitrary, no extension).
--
-- THEOREM (this file, --safe, no postulates).  Fix any value group G
--   (not assumed abelian) and any discovery e : V ≃ V′ of a form by a
--   carrier.  For every preference field ω on the form:
--     coherenceIngresses  a coherent form has a coherent embodiment —
--                         Exact ω ⇒ Exact (ingress ω): the potential is
--                         carried along e (f ↦ f ∘ e⁻¹).
--     coherenceReflects   and conversely — Exact (ingress ω) ⇒ Exact ω:
--                         a coherent embodiment witnesses a coherent form.
--     substrateIndependenceOfCoherence
--                         hence the exactness (holonomy) class is
--                         PRESERVED AND REFLECTED by transport: coherence
--                         is a property of the form itself, independent of
--                         which carrier discovers it or how.
--
-- WHY THIS IS THE "FREE LUNCH".  A Xenobot / Anthrobot has no
--   evolutionary history selecting for its competency; yet it exhibits a
--   coherent goal-directed behaviour.  The theorem says WHERE that comes
--   from with zero appeal to history: the coherence lives in the FORM,
--   and any interface onto the form (any e : Carrier ≃ Form) inherits it
--   by transport — the free road of DravyaParyaya, now carrying not a bare
--   property but the WHOLE goal-coherence class.  Ingression of agency is
--   transport of exactness.  "Discovered, not invented" (Anekantatva) is
--   why two carriers of the one form get the SAME coherence: their
--   presentations are canonically identified.
--
-- WHAT LEVIN LEAVES OPEN, AND HOW MUCH PURE STRUCTURE CLOSES.
--   · "Are the patterns eternal / unchanging?"  The coherence class is a
--     transport invariant (this file): it is a property of the form, not
--     of any embodiment's time or history — as eternal as the form is.
--   · "Can patterns interact laterally within the space?"  Yes, and the
--     interaction is cohomological: coupling two forms' preference fields
--     is coherent iff the coupling is consistent
--     (GoalCoherenceUnderBindingIsCohomologicalAndNotCompositional).
--   · "Sparse or dense?  Finite or infinite?"  Pure structure does NOT
--     decide this — the universe is a proper ∞-groupoid, each form's
--     presentations contractible, but the CARDINALITY / density of forms
--     is a choice of subuniverse, a modelling parameter, not a theorem.
--     That is the honest boundary of what "zero empiricism" settles, and
--     it is stated, not left dangling.
--
-- SOURCES.  Levin, "A short argument on Platonic Space" and "Free
--   Lunches: Model Systems for the Agential Gifts from the Platonic Space"
--   (thoughtforms.life); Fields–Levin, ingression of variable-agency
--   patterns.  Doctrine of forms-as-discovered is Platonic/Jaina
--   (anekāntavāda, Anekantatva); the mechanization is Voevodsky's
--   univalence; the identification is the corpus's.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module GoalCoherenceIsATransportInvariantSoAgencyIngressesLosslesslyIntoEveryEmbodimentOfTheForm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import HolonomyCriterionForExactness using (GroupOn)
import HolonomyCriterionForExactness as H

private
  variable
    ℓ ℓw : Level

------------------------------------------------------------------------
-- A form V, a carrier V′, and a discovery e : V ≃ V′ of one by the other.
-- The value group G is arbitrary (nonabelian allowed).
------------------------------------------------------------------------

module _ {W : Type ℓw} (G : GroupOn W) {V V′ : Type ℓ} (e : V ≃ V′) where

  private
    module TV  = H.Traces V  G     -- the form's own trace/cochain calculus
    module TV′ = H.Traces V′ G     -- the embodiment's

  f→ : V → V′
  f→ = equivFun e

  f← : V′ → V
  f← = invEq e

  ------------------------------------------------------------------------
  -- INGRESSION: the form's preference field, read on the embodiment via
  -- the interface.  (Pull ω back along the inverse of the discovery.)
  ------------------------------------------------------------------------

  ingress : TV.Cochain → TV′.Cochain
  ingress ω a′ b′ = ω (f← a′) (f← b′)

  ------------------------------------------------------------------------
  -- A coherent FORM has a coherent EMBODIMENT: the potential ingresses.
  -- If ω = d f on the form, then ingress ω = d (f ∘ f←) on the carrier —
  -- the potential is transported along the interface, on the nose.
  ------------------------------------------------------------------------

  coherenceIngresses : (ω : TV.Cochain) → TV.Exact ω → TV′.Exact (ingress ω)
  coherenceIngresses ω (f , h) =
    (λ a′ → f (f← a′)) , λ a′ b′ → h (f← a′) (f← b′)

  ------------------------------------------------------------------------
  -- And conversely, a coherent EMBODIMENT witnesses a coherent FORM:
  -- pull the carrier's potential back along the interface (f′ ∘ f→), and
  -- the round-trip equation (retEq e : f← (f→ a) ≡ a) closes it.
  ------------------------------------------------------------------------

  coherenceReflects : (ω : TV.Cochain) → TV′.Exact (ingress ω) → TV.Exact ω
  coherenceReflects ω (f′ , h′) =
    (λ a → f′ (f→ a)) ,
    λ a b → cong₂ ω (sym (retEq e a)) (sym (retEq e b)) ∙ h′ (f→ a) (f→ b)

  ------------------------------------------------------------------------
  -- SUBSTRATE INDEPENDENCE OF COHERENCE.  The exactness (holonomy) class
  -- is both preserved and reflected by the discovery: goal-coherence is a
  -- transport invariant — a property of the FORM, not of the carrier.
  ------------------------------------------------------------------------

  substrateIndependenceOfCoherence : (ω : TV.Cochain)
    → (TV.Exact ω → TV′.Exact (ingress ω))
    × (TV′.Exact (ingress ω) → TV.Exact ω)
  substrateIndependenceOfCoherence ω =
    coherenceIngresses ω , coherenceReflects ω
