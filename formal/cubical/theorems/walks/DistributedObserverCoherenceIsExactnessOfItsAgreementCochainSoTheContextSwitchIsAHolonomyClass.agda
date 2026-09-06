{-# OPTIONS --safe --cubical --guardedness #-}

------------------------------------------------------------------------
-- DistributedObserverCoherence — the coherence of an observer assembled
-- from local views (a cone–cocone diagram of classifiers, in the sense of
-- Fields–Glazebrook–Levin) is EXACTNESS of its agreement cochain, and the
-- obstruction — Fields' "context switch / raised free energy / inconsistent
-- local logic" — is a HOLONOMY class.  This is the single checked term the
-- corpus was missing: it fuses the classifier / cocone side (an observer is
-- a quotient/colimit — SamgrahaNaya) with the exactness ⟺ holonomy side
-- (HolonomyCriterionForExactness).  Until now that identification lived
-- only as prose in the AgencyAsCohomology entrypoint header.
--
-- ====================================================================
-- THE READING (zero empiricism).  Three kinds of claim, never blurred.
--
-- FORMALIZATION.  Fields–Friston–Glazebrook–Levin ("A free energy
--   principle for generic quantum systems"; "Minimal physicalism…";
--   Fields–Glazebrook–Marciano, "Sequential measurements, TQFTs, TQNNs")
--   formalize an observer as a Barwise–Seligman CLASSIFIER and assemble
--   classifiers into a cone–cocone diagram (CCCD); the cocone core C′ is
--   the colimit that "picks out a unique element" — the identified system
--   / self / global reference frame.  Their load-bearing criterion, in
--   their own words:
--       "Commutativity within a cone–cocone structure … enforces Bayesian
--        coherence on inferences made by the structure; failures of
--        commutativity indicate 'quantum' context switches"        [MP]
--   and a context switch "generates apparent 'hidden variables' and hence
--   variational free energy" and makes "the local logic inconsistent"
--   [QFEP §3.4].  They describe this obstruction ONLY operationally: they
--   do NOT name it as a cohomology class (a genuine open framing gap).
--
--   Here a distributed observer is exactly that CCCD: sites V (the types of
--   the classifier), a frame group W (the reference-frame / QRF values),
--   and a signed AGREEMENT cochain `agree a b` = how site b's local frame
--   reads relative to site a's on their overlap (the infomorphism
--   comparison; reversing an overlap edge inverts the comparison — Signed).
--   The cocone core C′ / a GLOBAL reference frame is a single value per
--   site whose differences are the local comparisons: `agree = d g`, i.e.
--   Exact agree.  "The CCCD commutes / is Bayesian-coherent" is: every
--   overlap loop composes to the identity — trivial holonomy.
--
-- THEOREM (this file, --safe, no postulates).
--   coherenceIsGlobalFrame
--        on a pointed connected overlap graph: the CCCD commutes (Coherent)
--        IFF a global reference frame exists (GlobalFrame = Exact agree).
--        Forward is loops-vanish-for-a-coboundary; backward CONSTRUCTS the
--        frame — the value at a site is the comparison carried along any
--        route to it, and commutativity is exactly what makes the route
--        irrelevant (HolonomyCriterionForExactness.Complete).
--   contextSwitchRefutesEveryGlobalFrame
--        ONE non-commuting overlap cycle refutes EVERY global frame at once
--        — the context switch is a nonzero holonomy class, and it is a
--        certificate (a single closed walk), not a suspicion.
--   frustrated (concrete)
--        three sites, ℤ frames, one overlap edge carrying a unit mismatch:
--        the triangle overlap-cycle prices to `pos 1 ≠ 0`, so NO global
--        reference frame exists — genuine contextuality, the checked naming
--        of Fields' context-switch / free-energy for a concrete CCCD.  (The
--        corpus already carries other concrete nonzero classes this could
--        borrow: the carry of positional notation, CarryClassNonzero, and
--        the Peres–Mermin local system, PMIncidenceLocalSystem.)
--
-- WHAT IS NOT CLAIMED.  Nothing about quantum mechanics is proven; W is an
--   arbitrary group, the setting is a graph of overlaps.  The claim is the
--   STRUCTURE: their commutativity-criterion IS a holonomy/exactness
--   criterion, now a term rather than a prose analogy.  Biology/physics is
--   cited nowhere as established; it is the modelling correspondence.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module DistributedObserverCoherenceIsExactnessOfItsAgreementCochainSoTheContextSwitchIsAHolonomyClass where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)

open import HolonomyCriterionForExactness using (GroupOn ; ℤGroupOn)
import HolonomyCriterionForExactness as H

private
  variable
    ℓ ℓw : Level

------------------------------------------------------------------------
-- A DISTRIBUTED OBSERVER over sites V with frame group W: the agreement
-- (overlap/transition) cochain of a cocone of local frames.
------------------------------------------------------------------------

module _ {W : Type ℓw} (G : GroupOn W) {V : Type ℓ} where

  open H.Traces V G
  open GroupOn G using (ε)

  record DistributedObserver : Type (ℓ-max ℓ ℓw) where
    field
      agree  : Cochain      -- b's local frame relative to a's, on the overlap
      signed : Signed agree  -- reversing an overlap edge inverts the comparison

  open DistributedObserver

  -- the cocone core C′ / a GLOBAL reference frame: one value per site whose
  -- differences ARE the local comparisons.
  GlobalFrame : DistributedObserver → Type (ℓ-max ℓ ℓw)
  GlobalFrame O = Exact (agree O)

  -- the CCCD COMMUTES / is Bayesian-coherent at basepoint u₀: every overlap
  -- loop composes to the identity (trivial holonomy).
  Coherent : V → DistributedObserver → Type (ℓ-max ℓ ℓw)
  Coherent u₀ O = (w : Walk u₀ u₀) → ⟨ agree O , w ⟩ ≡ ε

  -- a GLOBAL frame ⇒ the CCCD commutes: a coboundary has no holonomy.
  coherentFromGlobalFrame : (u₀ : V) (O : DistributedObserver)
    → GlobalFrame O → Coherent u₀ O
  coherentFromGlobalFrame u₀ O (f , h) w =
    pairCong h w ∙ loopsVanishForExact f w

  -- the CCCD commutes ⇒ a GLOBAL frame EXISTS, and it is constructed: the
  -- value at a site is the comparison carried along any chosen route to it.
  globalFrameFromCoherent : (u₀ : V) (connect : ∀ v → Walk u₀ v)
    (O : DistributedObserver) → Coherent u₀ O → GlobalFrame O
  globalFrameFromCoherent u₀ connect O coh =
    Complete.potentialFromVanishingHolonomy u₀ connect (agree O) (signed O) coh

  -- THE FUSION, one biconditional term.
  coherenceIsGlobalFrame : (u₀ : V) (connect : ∀ v → Walk u₀ v)
    (O : DistributedObserver)
    → (Coherent u₀ O → GlobalFrame O) × (GlobalFrame O → Coherent u₀ O)
  coherenceIsGlobalFrame u₀ connect O =
    globalFrameFromCoherent u₀ connect O , coherentFromGlobalFrame u₀ O

  -- CONTEXTUALITY: one non-commuting overlap cycle refutes EVERY global
  -- frame at once — the context switch is a nonzero holonomy class.
  contextSwitchRefutesEveryGlobalFrame : (O : DistributedObserver) {u : V}
    (w : Walk u u) → ¬ (⟨ agree O , w ⟩ ≡ ε) → ¬ GlobalFrame O
  contextSwitchRefutesEveryGlobalFrame O w nz =
    oneLoopRefutesExactness (agree O) w nz

------------------------------------------------------------------------
-- A CONCRETE FRUSTRATED CCCD.  Three sites, ℤ frames, one overlap edge
-- (s₂–s₀) carrying a unit mismatch; every other overlap agrees.  The
-- triangle overlap-cycle does not commute, so no global frame exists.
------------------------------------------------------------------------

data Site : Type where
  s₀ s₁ s₂ : Site

open H.Traces Site ℤGroupOn

-- the agreement cochain: a unit mismatch on the oriented overlap s₂→s₀.
agreeℤ : Cochain
agreeℤ s₂ s₀ = pos 1
agreeℤ s₀ s₂ = negsuc 0
agreeℤ _  _  = pos 0

-- it is signed: reversing any overlap edge inverts the comparison.
signedℤ : Signed agreeℤ
signedℤ s₀ s₀ = refl
signedℤ s₀ s₁ = refl
signedℤ s₀ s₂ = refl
signedℤ s₁ s₀ = refl
signedℤ s₁ s₁ = refl
signedℤ s₁ s₂ = refl
signedℤ s₂ s₀ = refl
signedℤ s₂ s₁ = refl
signedℤ s₂ s₂ = refl

frustrated : DistributedObserver ℤGroupOn
DistributedObserver.agree  frustrated = agreeℤ
DistributedObserver.signed frustrated = signedℤ

-- the fundamental triangle overlap-cycle s₀ → s₁ → s₂ → s₀.
triangle : Walk s₀ s₀
triangle = step (step (step (done {u = s₀}) s₁) s₂) s₀

-- it prices to the unit mismatch: the CCCD does NOT commute.
triangleHolonomy : ⟨ agreeℤ , triangle ⟩ ≡ pos 1
triangleHolonomy = refl

-- pos 1 is not the identity frame value pos 0.
private
  z→b : ℤ → Bool
  z→b (pos 0) = false
  z→b _       = true

  pos1≢0 : ¬ (pos 1 ≡ pos 0)
  pos1≢0 p = true≢false (cong z→b p)

-- hence the concrete frustrated CCCD has NO global reference frame: a
-- distributed observer whose local views cannot be glued into one — the
-- context switch, as a checked nonzero holonomy class.
noGlobalFrame : ¬ GlobalFrame ℤGroupOn frustrated
noGlobalFrame =
  contextSwitchRefutesEveryGlobalFrame ℤGroupOn frustrated triangle
    (λ p → pos1≢0 (sym triangleHolonomy ∙ p))
