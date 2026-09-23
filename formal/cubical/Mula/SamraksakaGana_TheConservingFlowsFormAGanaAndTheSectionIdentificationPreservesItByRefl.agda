{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡∞‡ï‡‡‡ï‡ó‡‡ ‚î ‡‡‡∞‡ï‡‡‡ï‡æ‡ ‡‡‡∞‡µ‡æ‡‡æ‡ ‡ó‡‡ ‡∞‡‡Ø‡®‡‡‡ø, ‡‡‡µ‡‡®‡‡‡‡µ‡æ‡‡‡‡ ‡‡ ‡ó‡‡
-- ‡Ø‡‡æ‡µ‡‡ ‡µ‡‡‡ø ‚î refl-‡Æ‡æ‡‡‡∞‡‡ ‡
--
-- (the gaa of conservers: the conserving flows form a monoid, and the
--  section identification carries the monoid ‚î by refl.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  `SvaFiberVasa_‚¶.agda`, landed earlier today, closes the
-- loss‚ìsymmetry scale's middle with the identification
--
--     ‡‡‡∞‡µ‡æ‡‡ f  =  (Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶)  ‚â  ((a : A) ‚í fiber f (f a))
--
-- and its ¬ß‡(a) hands one remainder forward in its own words: "the flow
-- SPACE is identified; the flow MONOID is not.  Composition of
-- conserving flows corresponds, across ‡µ‡æ‡‡, to a convolution of
-- sections ‚¶ and it is not given here."  This module gives it, and the
-- finding is better than the ea asked: the convolution
--
--     (s ‚ã t) a  =  ( s (t a .fst) .fst , s (t a .fst) .snd ‚àô t a .snd )
--
-- ‚î move by t, then move by s from where t landed, composing the
-- witnesses ‚î is carried onto flow composition BY refl, in both the
-- operation and the unit (¬ß‡ß, ‡ó‡-‡ó‡Æ‡®‡Æ‡ / ‡‡ï-‡ó‡Æ‡®‡Æ‡).  The identification
-- of the spaces was already an identification of the DYNAMICS, and the
-- cost of seeing it is zero.
--
-- At set level (¬ß‡®‚ì¬ß‡©) both sides are genuine `Monoid`s of the library's
-- own algebra and ‡µ‡æ‡‡ is a `MonoidEquiv`, with both preservation fields
-- refl.  ¬ß‡ prices the poles: at zero loss the gaa is trivial ‚î every
-- conserving flow IS the unit, no h-level needed (‡ß‡‡∞‡‡µ-‡‡ø‡®‡‡¶‡‡ consumed);
-- at total loss the gaa is the FULL transformation monoid of the
-- domain, as monoids, again by refl on the homomorphism.  So the scale
-- of `Dhruva`/`Khahara` is now a scale of MONOIDS: trivial at the near
-- pole, everything at the far pole, and in between exactly the sections
-- of one's own fibres under ‚ã.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡ó‡ ‚î the class, the troop; in the grammatical tradition the
-- gaapha is the appended list of items that BEHAVE ALIKE under a rule
-- (Pini, Adhyy, ~500 BCE, whose stras cite gaas by their first
-- member; the gaapha is transmitted beside the strapha).  A
-- conserving flow is exactly an item that behaves alike toward the
-- observable ‚î f cannot tell it acted ‚î so the monoid of all of them is
-- named the gaa of conservers.  LIMIT: ‡ó‡ is attested as the
-- tradition's own device for "the class behaving alike under a rule";
-- the compound ‡‡‡∞‡ï‡‡‡ï‡ó‡ and the application to a monoid of flows are
-- built here, and no text is claimed for them.  "Monoid" itself is
-- modern (the structure is used from the library, not re-derived).
--
-- CHECKED: Agda 2.8.0 + agda/cubical (installed bundle), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module Mula.SamraksakaGana_TheConservingFlowsFormAGanaAndTheSectionIdentificationPreservesItByRefl where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.HLevels
  using (isSetŒ£ ; isSetŒ† ; isPropŒ†)
open import Cubical.Data.Sigma
open import Cubical.Algebra.Monoid

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
open import Mula.Khahara_TheZeroDivisorEdgeIsPricedAtItsWholeDomainAndTotalLossIsExactlyTotalSymmetry
  using (‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É)
open import SvaFiberVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres

private variable ‚Ñì : Level

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  ------------------------------------------------------------------
  -- ¬ß‡ß ¬ THE OPERATIONS, AND THE refl-TRANSPORT.
  --
  -- Conserving flows are closed under composition ‚î the witness of the
  -- composite is the composite of the witnesses ‚î and the identity flow
  -- conserves everything.  Sections carry the convolution ‚ã: act by t,
  -- then act by s from where t landed, and compose the two receipts.
  ------------------------------------------------------------------

  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É : Type ‚Ñì
  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É = Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶

  _‚àò‡§™‡•ç‡§∞_ : ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É
  (Œ¶ , c) ‚àò‡§™‡•ç‡§∞ (Œ® , d) = (Œª a ‚Üí Œ¶ (Œ® a)) , (Œª a ‚Üí c (Œ® a) ‚àô d a)

  ‡§è‡§ï‡§É : ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É
  ‡§è‡§ï‡§É = idfun A , (Œª _ ‚Üí refl)

  ‡§õ‡•á‡§¶‡§É : Type ‚Ñì
  ‡§õ‡•á‡§¶‡§É = (a : A) ‚Üí fiber f (f a)

  _‚ãÜ_ : ‡§õ‡•á‡§¶‡§É ‚Üí ‡§õ‡•á‡§¶‡§É ‚Üí ‡§õ‡•á‡§¶‡§É
  (s ‚ãÜ t) a = s (t a .fst) .fst , s (t a .fst) .snd ‚àô t a .snd

  ‡§õ‡•á‡§¶-‡§è‡§ï‡§É : ‡§õ‡•á‡§¶‡§É
  ‡§õ‡•á‡§¶-‡§è‡§ï‡§É a = a , refl

  -- THE JEWEL.  `‡µ‡æ‡‡` does not merely identify the two spaces: it
  -- carries the operation and the unit, definitionally.  The dynamics
  -- was in the identification all along, at no cost.
  ‡§ó‡§£-‡§ó‡§Æ‡§®‡§Æ‡•ç : (œÉ œÑ : ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É)
           ‚Üí equivFun (‡§µ‡§æ‡§∏‡§É f) (œÉ ‚àò‡§™‡•ç‡§∞ œÑ)
           ‚â° (equivFun (‡§µ‡§æ‡§∏‡§É f) œÉ) ‚ãÜ (equivFun (‡§µ‡§æ‡§∏‡§É f) œÑ)
  ‡§ó‡§£-‡§ó‡§Æ‡§®‡§Æ‡•ç œÉ œÑ = refl

  ‡§è‡§ï-‡§ó‡§Æ‡§®‡§Æ‡•ç : equivFun (‡§µ‡§æ‡§∏‡§É f) ‡§è‡§ï‡§É ‚â° ‡§õ‡•á‡§¶-‡§è‡§ï‡§É
  ‡§è‡§ï-‡§ó‡§Æ‡§®‡§Æ‡•ç = refl

------------------------------------------------------------------------
-- ¬ß‡® ¬ THE GAA, AT SET LEVEL.  Over set carriers the witness component
-- is proposition-valued, so every law is a Œ‚â°Prop away from refl and
-- both sides are `Monoid`s of the library's own algebra.
------------------------------------------------------------------------

module ‡§ó‡§£‡•á {A B : Type ‚Ñì} (setA : isSet A) (setB : isSet B) (f : A ‚Üí B) where

  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Æ‡§§‡§æ : (œÉ œÑ : ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É f) ‚Üí œÉ .fst ‚â° œÑ .fst ‚Üí œÉ ‚â° œÑ
  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Æ‡§§‡§æ _ _ = Œ£‚â°Prop (Œª Œ¶ ‚Üí isPropŒ† (Œª a ‚Üí setB _ _))

  ‡§õ‡•á‡§¶-‡§∏‡§Æ‡§§‡§æ : (s t : ‡§õ‡•á‡§¶‡§É f) ‚Üí ((a : A) ‚Üí s a .fst ‚â° t a .fst) ‚Üí s ‚â° t
  ‡§õ‡•á‡§¶-‡§∏‡§Æ‡§§‡§æ s t h = funExt (Œª a ‚Üí Œ£‚â°Prop (Œª _ ‚Üí setB _ _) (h a))

  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§ó‡§£‡§É : Monoid ‚Ñì
  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§ó‡§£‡§É = makeMonoid {M = ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É f} (‡§è‡§ï‡§É f) (_‚àò‡§™‡•ç‡§∞_ f)
    (isSetŒ£ (isSetŒ† (Œª _ ‚Üí setA))
            (Œª Œ¶ ‚Üí isProp‚ÜíisSet (isPropŒ† (Œª a ‚Üí setB _ _))))
    (Œª œÉ œÑ œÖ ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Æ‡§§‡§æ _ _ refl)
    (Œª œÉ ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Æ‡§§‡§æ _ _ refl)
    (Œª œÉ ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Æ‡§§‡§æ _ _ refl)

  ‡§õ‡•á‡§¶‡§ó‡§£‡§É : Monoid ‚Ñì
  ‡§õ‡•á‡§¶‡§ó‡§£‡§É = makeMonoid {M = ‡§õ‡•á‡§¶‡§É f} (‡§õ‡•á‡§¶-‡§è‡§ï‡§É f) (_‚ãÜ_ f)
    (isSetŒ† (Œª _ ‚Üí isSetŒ£ setA (Œª _ ‚Üí isProp‚ÜíisSet (setB _ _))))
    (Œª s t u ‚Üí ‡§õ‡•á‡§¶-‡§∏‡§Æ‡§§‡§æ _ _ (Œª _ ‚Üí refl))
    (Œª s ‚Üí ‡§õ‡•á‡§¶-‡§∏‡§Æ‡§§‡§æ _ _ (Œª _ ‚Üí refl))
    (Œª s ‚Üí ‡§õ‡•á‡§¶-‡§∏‡§Æ‡§§‡§æ _ _ (Œª _ ‚Üí refl))

  ------------------------------------------------------------------
  -- ¬ß‡© ¬ ‡µ‡æ‡‡ IS A MONOID EQUIVALENCE, and both preservation fields
  -- are the refl theorems of ¬ß‡ß.
  ------------------------------------------------------------------

  ‡§ó‡§£-‡§∏‡§Æ‡§§‡§æ : MonoidEquiv ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§ó‡§£‡§É ‡§õ‡•á‡§¶‡§ó‡§£‡§É
  ‡§ó‡§£-‡§∏‡§Æ‡§§‡§æ = ‡§µ‡§æ‡§∏‡§É f , monoidequiv refl (Œª _ _ ‚Üí refl)

------------------------------------------------------------------------
-- ¬ß‡ ¬ THE POLES, AS MONOIDS.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  -- Near pole: zero loss, trivial gaa.  No h-level hypothesis ‚î the
  -- flow space is contractible (SvaFiberVasa's ‡ß‡‡∞‡‡µ-‡‡ø‡®‡‡¶‡‡), so every
  -- conserving flow already IS the unit.
  ‡§§‡•Å‡§ö‡•ç‡§õ‡§§‡§æ : isEquiv f ‚Üí (œÉ : ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É f) ‚Üí œÉ ‚â° ‡§è‡§ï‡§É f
  ‡§§‡•Å‡§ö‡•ç‡§õ‡§§‡§æ e œÉ = isContr‚ÜíisProp (‡§ß‡•ç‡§∞‡•Å‡§µ-‡§¨‡§ø‡§®‡•ç‡§¶‡•Å‡§É f e) œÉ (‡§è‡§ï‡§É f)

module ‡§Ö‡§®‡•ç‡§ß‡•á {A B : Type ‚Ñì} (setA : isSet A) (setB : isSet B)
             (f : A ‚Üí B) (blind : ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É f) where

  open ‡§ó‡§£‡•á setA setB f

  -- Far pole: total loss, and the gaa is the FULL transformation
  -- monoid of the domain.  The forward map is the bare projection ‚î
  -- which is a monoid homomorphism by refl, since the map component of
  -- a flow composite is the composite of the map components.
  ‡§∏‡§Æ‡§æ‡§™‡§ï‡§ó‡§£‡§É : Monoid ‚Ñì
  ‡§∏‡§Æ‡§æ‡§™‡§ï‡§ó‡§£‡§É = makeMonoid {M = A ‚Üí A} (idfun A) (Œª g h a ‚Üí g (h a))
    (isSetŒ† (Œª _ ‚Üí setA))
    (Œª _ _ _ ‚Üí refl) (Œª _ ‚Üí refl) (Œª _ ‚Üí refl)

  ‡§∏‡§∞‡•ç‡§µ-‡§ó‡§£-‡§∏‡§Æ‡§§‡§æ : MonoidEquiv ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§ó‡§£‡§É ‡§∏‡§Æ‡§æ‡§™‡§ï‡§ó‡§£‡§É
  ‡§∏‡§∞‡•ç‡§µ-‡§ó‡§£-‡§∏‡§Æ‡§§‡§æ = isoToEquiv i , monoidequiv refl (Œª _ _ ‚Üí refl)
    where
    i : Iso (‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É f) (A ‚Üí A)
    Iso.fun i = fst
    Iso.inv i Œ¶ = Œ¶ , (Œª a ‚Üí blind (Œ¶ a) a)
    Iso.rightInv i _ = refl
    Iso.leftInv i œÉ = ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Æ‡§§‡§æ _ _ refl

------------------------------------------------------------------------
-- ¬ß‡ ¬ ‡‡‡‡ ‚î what this opens and does not close.
--
-- (a) THE FIBREWISE LEG.  Currying along `Avaccheda`'s A ‚â Œ B (fibre)
--     identifies the section CARRIER with (b : B) ‚í fiber f b ‚í fiber
--     f b ‚î the product over the codomain of each fibre's endomorphism
--     type ‚î but carrying ‚ã onto pointwise composition needs the
--     transport coherence of that currying, and it is not given here.
--     With it, the slogan becomes exact: the gaa of an observable is
--     the product of its fibres' own endomorphism monoids, which is the
--     typal shadow of "the commutant decomposes over the spectrum."
--
-- (b) THE GROUP INSIDE.  The invertible elements of the gaa ‚î flows
--     with conserving inverses ‚î are the observable's symmetry GROUP,
--     and at the far pole they are the symmetric group of the domain.
--     Not constructed.
--
-- (c) THE ‚àû-VERSION.  Over arbitrary types the witness component's
--     associativity is ‚àô-assoc, a path of paths; the flows form an
--     ‚àû-monoid (an A‚àû-structure this substrate can in principle state).
--     Named, not built.
--
-- (d) THE INSTANCES.  Across `YogaKsetra.‡‡Æ‡‡æ` the gaa of addition
--     induces a monoid on the shear fields (k ‚ä k' = act by k' then by
--     k from where k' landed); across `GaugeOrbitClasses` the gaa of a
--     transcript map is the section monoid of its coset fibres.  Both
--     are transports of ¬ß‡© and neither is written out.
------------------------------------------------------------------------
