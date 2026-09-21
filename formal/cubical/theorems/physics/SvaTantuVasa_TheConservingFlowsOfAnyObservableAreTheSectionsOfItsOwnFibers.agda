{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡µ‡‡®‡‡‡‡µ‡æ‡‡ ‚î ‡‡‡∞‡ï‡‡‡ï‡ ‡‡‡∞‡µ‡æ‡‡ ‡‡‡µ‡‡®‡‡‡ ‡µ‡‡‡ø, ‡‡∞‡‡µ‡ ‡ ‡‡‡∞‡ï‡‡‡ï‡æ‡ ‡‡‡∞‡µ‡æ‡‡æ‡
-- ‡‡‡µ‡‡®‡‡‡‡‡æ‡≤‡‡‡Ø ‡‡‡¶‡æ‡ ‡‡µ ‡
--
-- (dwelling in one's own fiber: a conserving flow lives in its own fiber,
--  and the conserving flows of ANY observable are exactly the sections of
--  its own fiber family.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  The scale this corpus built in four modules, closed at
-- its middle by one identification.  `Dhruva_‚¶.agda` proved the near
-- pole (zero loss ‚ü the conserving flow is the identity), `Khahara_‚¶.agda`
-- the far pole (total loss ‚ü∫ total symmetry), `YogaKsetra_‚¶.agda` one
-- interior point (the conserving flows of addition are the shear fields)
-- ‚î and Khahara ¬ß‡(b) asks for monotonicity of the conserving monoid
--      Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶ in the fibers.
--
-- What is landed here is stronger than the monotonicity asked for: an
-- IDENTIFICATION, with no hypotheses on f, A or B whatsoever ‚î
--
--     (Œ[ Œ¶ ‚àà (A ‚í A) ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶)  ‚â  ((a : A) ‚í fiber f (f a))
--
-- the conserving flows of an observable ARE the sections of its own
-- fiber family, pulled back along itself.  A conserving flow is exactly
-- an assignment, to every point, of a point of its own fiber.  The
-- monotonicity ¬ß‡(b) asked for is then the Œ†-functoriality shadow of the
-- identification and is ¬ß‡ below, in three lines.
--
-- The scale becomes computable at every point.  At the near pole every
-- fiber is contractible, so the section space is contractible ‚î ¬ß‡®
-- strengthens Dhruva's pointwise Œ¶ ‚â° id to `isContr` of the whole flow
-- space, and re-derives the pointwise statement from it, which is the
-- check that the general law contains the special case (the discipline
-- `GaugeOrbitClasses.flip-law-again` set).  At the far pole every fiber
-- is the whole domain, so the sections are all of A ‚í A ‚î ¬ß‡© derives
-- Khahara's total symmetry from the law, over a set codomain.  At
-- addition the fibers are R-torsors, so the sections are the function
-- space ‚î ¬ß‡ composes the law with `YogaKsetra.‡‡Æ‡‡æ` to identify the
-- SECTIONED FIBERS OF ADDITION with the shear fields, over any
-- commutative ring.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ORIGIN OF THE MATHEMATICS.  The whole of
-- ¬ß‡ß is the distributivity of Œ† over Œ ‚î the "type-theoretic axiom of
-- choice", definitional in this substrate ‚î and it is cited from the
-- library rather than re-derived: `Cubical.Data.Sigma.Œ-Œ†-Iso`, both
-- round trips `refl`.  The substrate is cubical type theory (Voevodsky),
-- this repository's one admitted non-Indian frame.
-- It is the exact combinatorics of
-- "invariance means moving within the level sets", finished.
--
-- TERM.  ‡‡‡µ (own), ‡‡®‡‡‡ (thread, fiber), ‡µ‡æ‡ (dwelling) are ordinary
-- .  ‡‡®‡‡‡ for the fiber of a map is THIS CORPUS's rendering
-- (declared in `Tantujala_‚¶.agda`'s header),
-- and the compound ‡‡‡µ‡‡®‡‡‡‡µ‡æ‡ is built here.
------------------------------------------------------------------------

module SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.HLevels
  using (isContrŒ† ; isOfHLevelRespectEquiv)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int

open import Dhruva_TheSymmetryLivesInTheFiberAndWithoutALossThereIsNoSymmetry
open import Khahara_TheZeroDivisorEdgeIsPricedAtItsWholeDomainAndTotalLossIsExactlyTotalSymmetry
  using (‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É)
open import YogaKsetra_TheConservingFlowsOfAdditionAreExactlyTheShearFields
  using (module ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç)

private variable ‚Ñì : Level

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  ------------------------------------------------------------------
  -- ¬ß‡ß ¬ THE LAW.  Conserving flows ‚â sections of one's own fibers.
  --
  -- `Œ-Œ†-Iso` instantiated at the family Œª a x ‚í f x ‚â° f a: its left
  -- side is `(a : A) ‚í fiber f (f a)` and its right side is
  -- `Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶`, both DEFINITIONALLY, so the identification
  -- is the library lemma inverted and nothing is constructed here.
  ------------------------------------------------------------------

  ‡§µ‡§æ‡§∏-Iso : Iso (Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
                ((a : A) ‚Üí fiber f (f a))
  ‡§µ‡§æ‡§∏-Iso = invIso Œ£-Œ†-Iso

  ‡§µ‡§æ‡§∏‡§É : (Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶) ‚âÉ ((a : A) ‚Üí fiber f (f a))
  ‡§µ‡§æ‡§∏‡§É = isoToEquiv ‡§µ‡§æ‡§∏-Iso

  -- The forward map, read: a conserving flow sends each point to a point
  -- of its own fiber, and the witness rides along.  This is Dhruva's
  -- ‡ß‡‡∞‡‡µ-‡‡®‡‡‡ evaluated on the diagonal b = f a ‚î checked definitional,
  -- so the two readings are one map and not an analogy.
  ‡§µ‡§æ‡§∏-‡§ó‡§Æ‡§®‡§Æ‡•ç : (Œ¶ : A ‚Üí A) (cons : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶) (a : A)
            ‚Üí equivFun ‡§µ‡§æ‡§∏‡§É (Œ¶ , cons) a ‚â° (Œ¶ a , cons a)
  ‡§µ‡§æ‡§∏-‡§ó‡§Æ‡§®‡§Æ‡•ç Œ¶ cons a = refl

  ------------------------------------------------------------------
  -- ¬ß‡® ¬ THE NEAR POLE, STRENGTHENED.  Zero loss: contractible fibers,
  -- hence a contractible SECTION SPACE ‚î the conserving flow space is a
  -- single point, not merely a space whose every member is pointwise id.
  ------------------------------------------------------------------

  ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§¨‡§ø‡§®‡•ç‡§¶‡•Å‡§É : isEquiv f ‚Üí isContr (Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
  ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§¨‡§ø‡§®‡•ç‡§¶‡•Å‡§É e =
    isOfHLevelRespectEquiv 0 (invEquiv ‡§µ‡§æ‡§∏‡§É)
      (isContrŒ† (Œª a ‚Üí e .equiv-proof (f a)))

  -- ‚¶and Dhruva's own ¬ß‡® comes back out, which is the containment check:
  -- in a contractible flow space every conserving flow equals the
  -- identity flow, pointwise.  (Dhruva's route through the fiber's two
  -- points is kept and is the shorter proof; this one exists to show the
  -- general law contains it.)
  ‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : isEquiv f ‚Üí (Œ¶ : A ‚Üí A) (cons : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
             ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
  ‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç e Œ¶ cons a =
    cong (Œª œÉ ‚Üí œÉ .fst a)
         (isContr‚ÜíisProp (‡§ß‡•ç‡§∞‡•Å‡§µ-‡§¨‡§ø‡§®‡•ç‡§¶‡•Å‡§É e)
           (Œ¶ , cons) (idfun A , Œª _ ‚Üí refl))

  ------------------------------------------------------------------
  -- ¬ß‡© ¬ THE FAR POLE, FROM THE LAW.  Total loss: over a set codomain a
  -- blind observable's every fiber-at-its-own-image is the whole domain,
  -- so the sections are all of A ‚í A ‚î Khahara's total symmetry, derived
  -- rather than witnessed by the constant flow.  (Khahara's biconditional
  -- and its inhabitedness analysis are its own and are not restated.)
  ------------------------------------------------------------------

  ‡§Ö‡§®‡•ç‡§ß-‡§§‡§®‡•ç‡§§‡•Å‡§É : isSet B ‚Üí ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É f
             ‚Üí (a : A) ‚Üí fiber f (f a) ‚âÉ A
  ‡§Ö‡§®‡•ç‡§ß-‡§§‡§®‡•ç‡§§‡•Å‡§É setB blind a = isoToEquiv i
    where
    i : Iso (fiber f (f a)) A
    Iso.fun i = fst
    Iso.inv i x = x , blind x a
    Iso.rightInv i x = refl
    Iso.leftInv i (x , p) = Œ£PathP (refl , setB _ _ (blind x a) p)

  ‡§∏‡§∞‡•ç‡§µ-‡§ó‡§§‡§ø‡§É : isSet B ‚Üí ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É f
           ‚Üí (Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶) ‚âÉ (A ‚Üí A)
  ‡§∏‡§∞‡•ç‡§µ-‡§ó‡§§‡§ø‡§É setB blind =
    compEquiv ‡§µ‡§æ‡§∏‡§É (equivŒ†Cod (‡§Ö‡§®‡•ç‡§ß-‡§§‡§®‡•ç‡§§‡•Å‡§É setB blind))

------------------------------------------------------------------------
-- ¬ß‡ ¬ THE INTERIOR POINT.  Composing the law with `YogaKsetra.‡‡Æ‡‡æ`
-- identifies the sectioned fibers of addition with the shear fields,
-- over any commutative ring: choosing, at every point of the plane, a
-- point of that point's own sum-fiber IS choosing one ring element per
-- point.  New as a statement about the FIBERS; the flow-space half is
-- YogaKsetra's and is consumed, not reproved.
------------------------------------------------------------------------

module ‡§Ø‡•ã‡§ó‡•á {‚Ñì : Level} (R' : CommRing ‚Ñì) where

  open ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç R' using (‡§Ø‡•ã‡§ó ; ‡§∏‡§Æ‡§§‡§æ)

  private
    R : Type ‚Ñì
    R = fst R'

  ‡§Ø‡•ã‡§ó-‡§§‡§®‡•ç‡§§‡•Å-‡§õ‡•á‡§¶‡§æ‡§É : ((p : R √ó R) ‚Üí fiber ‡§Ø‡•ã‡§ó (‡§Ø‡•ã‡§ó p)) ‚âÉ (R √ó R ‚Üí R)
  ‡§Ø‡•ã‡§ó-‡§§‡§®‡•ç‡§§‡•Å-‡§õ‡•á‡§¶‡§æ‡§É = compEquiv (invEquiv (‡§µ‡§æ‡§∏‡§É ‡§Ø‡•ã‡§ó)) ‡§∏‡§Æ‡§§‡§æ

-- the ‚ instance, one line, following YogaKsetra's own precedent
module ‚Ñ§‡§Ø‡•ã‡§ó‡•á = ‡§Ø‡•ã‡§ó‡•á ‚Ñ§CommRing

------------------------------------------------------------------------
-- ¬ß‡ ¬ THE MONOTONICITY KHAHARA ASKED FOR, as the identification's
-- shadow.  A fiber-wise map between two observables on one domain
-- induces a map of conserving flow spaces ‚î so larger fibers admit more
-- flows, functorially, with no order on observables needed: the order
-- IS the fiber-wise maps.  Three lines, because after ¬ß‡ß it is only
-- Œ†-postcomposition.
------------------------------------------------------------------------

module _ {A B B' : Type ‚Ñì} (f : A ‚Üí B) (g : A ‚Üí B') where

  ‡§ó‡§æ‡§Æ‡§ø‡§®‡•Ä : ((a : A) ‚Üí fiber f (f a) ‚Üí fiber g (g a))
         ‚Üí (Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
         ‚Üí (Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶)
  ‡§ó‡§æ‡§Æ‡§ø‡§®‡•Ä h œÉ = invEq (‡§µ‡§æ‡§∏‡§É g) (Œª a ‚Üí h a (equivFun (‡§µ‡§æ‡§∏‡§É f) œÉ a))

------------------------------------------------------------------------
-- ¬ß‡ ¬ ‡‡‡‡ ‚î the receipt-economy reading.
--
-- The receipt-economy reading, recorded because it prices symmetry
-- itself: a conserving flow of f is EXACTLY one fiber-point per
-- point, so the "amount of symmetry" of an observable is its fiber
-- census summed over the domain ‚î the same census `Tantujala_‚¶agda`
-- grades and `interactive/Lopa_‚¶hs` queues.  Every unpriced fiber in the
-- dark-matter queue is, by this law, also an unpriced quantity of
-- symmetry.
------------------------------------------------------------------------
