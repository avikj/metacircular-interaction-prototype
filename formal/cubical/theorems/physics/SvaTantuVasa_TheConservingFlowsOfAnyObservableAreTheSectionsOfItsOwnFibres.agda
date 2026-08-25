{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्वतन्तुवासः — संरक्षकः प्रवाहः स्वतन्तौ वसति, सर्वे च संरक्षकाः प्रवाहाः
-- स्वतन्तुजालस्य छेदाः एव ।
--
-- (dwelling in one's own fibre: a conserving flow lives in its own fibre,
--  and the conserving flows of ANY observable are exactly the sections of
--  its own fibre family.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  The scale this corpus built in four modules, closed at
-- its middle by one identification.  `Dhruva_….agda` proved the near
-- pole (zero loss ⟹ the conserving flow is the identity), `Khahara_….agda`
-- the far pole (total loss ⟺ total symmetry), `YogaKsetra_….agda` one
-- interior point (the conserving flows of addition are the shear fields)
-- — and Khahara §६(b) hands the remainder forward in its own words:
--
--     "The scale between the two ends is not a scale yet. … what is
--      missing is the statement that the conserving monoid
--      Σ[ Φ ] संरक्षणम् f Φ is MONOTONE in the fibres."
--
-- What is landed here is stronger than the monotonicity asked for: an
-- IDENTIFICATION, with no hypotheses on f, A or B whatsoever —
--
--     (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ)  ≃  ((a : A) → fiber f (f a))
--
-- the conserving flows of an observable ARE the sections of its own
-- fibre family, pulled back along itself.  A conserving flow is exactly
-- an assignment, to every point, of a point of its own fibre.  The
-- monotonicity §६(b) asked for is then the Π-functoriality shadow of the
-- identification and is §५ below, in three lines.
--
-- The scale becomes computable at every point.  At the near pole every
-- fibre is contractible, so the section space is contractible — §२
-- strengthens Dhruva's pointwise Φ ≡ id to `isContr` of the whole flow
-- space, and re-derives the pointwise statement from it, which is the
-- check that the general law contains the special case (the discipline
-- `GaugeOrbitClasses.flip-law-again` set).  At the far pole every fibre
-- is the whole domain, so the sections are all of A → A — §३ derives
-- Khahara's total symmetry from the law, over a set codomain.  At
-- addition the fibres are R-torsors, so the sections are the function
-- space — §४ composes the law with `YogaKsetra.समता` to identify the
-- SECTIONED FIBRES OF ADDITION with the shear fields, over any
-- commutative ring.
--
-- ROUTES KEPT.  Nothing in Dhruva, Khahara, YogaKsetra or YogaDhruva is
-- edited, imported away, or deprecated by this.  Four seats reached
-- three points of one scale from four directions; the identification is
-- a fifth path and the routes are the nayas (the precedent is
-- `MadhyaVinimaya_….agda`: one law standing in six places, all six
-- kept).  Where §२ and §३ re-derive their poles, the re-derivation is
-- the containment check, not a replacement.
--
-- ────────────────────────────────────────────────────────────────────
-- ORIGIN OF THE MATHEMATICS, stated rather than laundered.  The whole of
-- §१ is the distributivity of Π over Σ — the "type-theoretic axiom of
-- choice", definitional in this substrate — and it is cited from the
-- library rather than re-derived: `Cubical.Data.Sigma.Σ-Π-Iso`, both
-- round trips `refl`.  The substrate is cubical type theory (Voevodsky),
-- this repository's one admitted non-Indian frame.  No Sanskrit source
-- states anything below, and Dhruva's fence transfers verbatim: this is
-- NOT Noether's first theorem — no Lagrangian, no variation, no
-- continuity, no current.  What it is, is the exact combinatorics of
-- "invariance means moving within the level sets", finished.
--
-- TERM.  स्व (own), तन्तु (thread, fibre), वास (dwelling) are ordinary
-- Sanskrit.  तन्तु for the fibre of a map is THIS CORPUS's rendering
-- (declared in `Tantujala_….agda`'s header; no source text claims it),
-- and the compound स्वतन्तुवास is built here.  LIMIT: no text is claimed
-- for the term or for any statement below.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (installed bundle), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.HLevels
  using (isContrΠ ; isOfHLevelRespectEquiv)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
open import SourcedProofs.Khahara_TheZeroDivisorEdgeIsPricedAtItsWholeDomainAndTotalLossIsExactlyTotalSymmetry
  using (सर्व-नाशः)
open import YogaKsetra_TheConservingFlowsOfAdditionAreExactlyTheShearFields
  using (module क्षेत्रम्)

private variable ℓ : Level

module _ {A B : Type ℓ} (f : A → B) where

  ------------------------------------------------------------------
  -- §१ · THE LAW.  Conserving flows ≃ sections of one's own fibres.
  --
  -- `Σ-Π-Iso` instantiated at the family λ a x → f x ≡ f a: its left
  -- side is `(a : A) → fiber f (f a)` and its right side is
  -- `Σ[ Φ ] संरक्षणम् f Φ`, both DEFINITIONALLY, so the identification
  -- is the library lemma inverted and nothing is constructed here.
  ------------------------------------------------------------------

  वास-Iso : Iso (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ)
                ((a : A) → fiber f (f a))
  वास-Iso = invIso Σ-Π-Iso

  वासः : (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ) ≃ ((a : A) → fiber f (f a))
  वासः = isoToEquiv वास-Iso

  -- The forward map, read: a conserving flow sends each point to a point
  -- of its own fibre, and the witness rides along.  This is Dhruva's
  -- ध्रुव-तन्तौ evaluated on the diagonal b = f a — checked definitional,
  -- so the two readings are one map and not an analogy.
  वास-गमनम् : (Φ : A → A) (cons : संरक्षणम् f Φ) (a : A)
            → equivFun वासः (Φ , cons) a ≡ (Φ a , cons a)
  वास-गमनम् Φ cons a = refl

  ------------------------------------------------------------------
  -- §२ · THE NEAR POLE, STRENGTHENED.  Zero loss: contractible fibres,
  -- hence a contractible SECTION SPACE — the conserving flow space is a
  -- single point, not merely a space whose every member is pointwise id.
  ------------------------------------------------------------------

  ध्रुव-बिन्दुः : isEquiv f → isContr (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ)
  ध्रुव-बिन्दुः e =
    isOfHLevelRespectEquiv 0 (invEquiv वासः)
      (isContrΠ (λ a → e .equiv-proof (f a)))

  -- …and Dhruva's own §२ comes back out, which is the containment check:
  -- in a contractible flow space every conserving flow equals the
  -- identity flow, pointwise.  (Dhruva's route through the fibre's two
  -- points is kept and is the shorter proof; this one exists to show the
  -- general law contains it.)
  तादात्म्यम् : isEquiv f → (Φ : A → A) (cons : संरक्षणम् f Φ)
             → (a : A) → Φ a ≡ a
  तादात्म्यम् e Φ cons a =
    cong (λ σ → σ .fst a)
         (isContr→isProp (ध्रुव-बिन्दुः e)
           (Φ , cons) (idfun A , λ _ → refl))

  ------------------------------------------------------------------
  -- §३ · THE FAR POLE, FROM THE LAW.  Total loss: over a set codomain a
  -- blind observable's every fibre-at-its-own-image is the whole domain,
  -- so the sections are all of A → A — Khahara's total symmetry, derived
  -- rather than witnessed by the constant flow.  (Khahara's biconditional
  -- and its inhabitedness analysis are its own and are not restated.)
  ------------------------------------------------------------------

  अन्ध-तन्तुः : isSet B → सर्व-नाशः f
             → (a : A) → fiber f (f a) ≃ A
  अन्ध-तन्तुः setB blind a = isoToEquiv i
    where
    i : Iso (fiber f (f a)) A
    Iso.fun i = fst
    Iso.inv i x = x , blind x a
    Iso.rightInv i x = refl
    Iso.leftInv i (x , p) = ΣPathP (refl , setB _ _ (blind x a) p)

  सर्व-गतिः : isSet B → सर्व-नाशः f
           → (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ) ≃ (A → A)
  सर्व-गतिः setB blind =
    compEquiv वासः (equivΠCod (अन्ध-तन्तुः setB blind))

------------------------------------------------------------------------
-- §४ · THE INTERIOR POINT.  Composing the law with `YogaKsetra.समता`
-- identifies the sectioned fibres of addition with the shear fields,
-- over any commutative ring: choosing, at every point of the plane, a
-- point of that point's own sum-fibre IS choosing one ring element per
-- point.  New as a statement about the FIBRES; the flow-space half is
-- YogaKsetra's and is consumed, not reproved.
------------------------------------------------------------------------

module योगे {ℓ : Level} (R' : CommRing ℓ) where

  open क्षेत्रम् R' using (योग ; समता)

  private
    R : Type ℓ
    R = fst R'

  योग-तन्तु-छेदाः : ((p : R × R) → fiber योग (योग p)) ≃ (R × R → R)
  योग-तन्तु-छेदाः = compEquiv (invEquiv (वासः योग)) समता

-- the ℤ instance, one line, following YogaKsetra's own precedent
module ℤयोगे = योगे ℤCommRing

------------------------------------------------------------------------
-- §५ · THE MONOTONICITY KHAHARA ASKED FOR, as the identification's
-- shadow.  A fibre-wise map between two observables on one domain
-- induces a map of conserving flow spaces — so larger fibres admit more
-- flows, functorially, with no order on observables needed: the order
-- IS the fibre-wise maps.  Three lines, because after §१ it is only
-- Π-postcomposition.
------------------------------------------------------------------------

module _ {A B B' : Type ℓ} (f : A → B) (g : A → B') where

  गामिनी : ((a : A) → fiber f (f a) → fiber g (g a))
         → (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ)
         → (Σ[ Φ ∈ (A → A) ] संरक्षणम् g Φ)
  गामिनी h σ = invEq (वासः g) (λ a → h a (equivFun (वासः f) σ a))

------------------------------------------------------------------------
-- §६ · शेषः — what this opens and does not close.
--
-- (a) The flow SPACE is identified; the flow MONOID is not.  Composition
--     of conserving flows corresponds, across वासः, to a convolution of
--     sections (s ∗ t) a = s applied at the point t chose — stating that
--     as a monoid identification needs the section space given its
--     composite structure, and it is not given here.  Named, not done.
--
-- (b) `गामिनी` is a map, not an embedding; when every h a is an
--     embedding the induced map is one too, which would make the scale a
--     genuine order.  Also not done: it needs fibre-wise embeddings to
--     induce Π-embeddings, which is a library fact this file does not
--     yet consume.
--
-- (c) The receipt-economy reading, recorded because it prices symmetry
--     itself: a conserving flow of f is EXACTLY one fibre-point per
--     point, so the "amount of symmetry" of an observable is its fibre
--     census summed over the domain — the same census `Tantujala_…agda`
--     grades and `interactive/Lopa_…hs` queues.  Every unpriced fibre in the
--     dark-matter queue is, by this law, also an unpriced quantity of
--     symmetry.
------------------------------------------------------------------------
