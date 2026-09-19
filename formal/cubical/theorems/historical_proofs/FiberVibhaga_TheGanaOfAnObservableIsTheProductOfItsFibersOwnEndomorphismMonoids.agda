{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡‡‡µ‡ø‡‡æ‡ó‡ ‚î ‡‡µ‡≤‡ã‡ï‡®‡‡‡Ø ‡ó‡‡ ‡‡‡-‡‡®‡‡‡‡®‡æ‡Æ‡ ‡‡‡µ-‡‡®‡‡‡‡ï‡‡∞‡ø‡Ø‡æ-‡ó‡‡æ‡®‡æ‡ ‡ó‡‡‡®‡Æ‡ ‡‡µ ‡
--
-- (the fiber decomposition: the gaa of an observable IS the product,
--  over the codomain, of its fibers' own endomorphism monoids.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  `SvaTantuVasa` ¬ß‡(a) and `SamraksakaGana` ¬ß‡(a) both
-- hand the same remainder forward: currying along A ‚â Œ B (fiber f)
-- identifies the section CARRIER with (b : B) ‚í fiber f b ‚í fiber f b,
-- "but carrying ‚ã onto pointwise composition needs the transport
-- coherence of that currying, and it is not given here."  This module
-- gives it, over set carriers:
--
--   ‡µ‡ø‡‡æ‡ó‡      :  ‡‡‡¶‡ f  ‚â  ((b : B) ‚í fiber f b ‚í fiber f b)
--   ‡µ‡ø‡‡æ‡ó-‡ó‡-‡‡Æ‡‡æ : MonoidEquiv ‡‡‡¶‡ó‡‡ ‡‡®‡‡‡‡ó‡‡
--   ‡‡‡∞‡µ‡æ‡-‡‡®‡‡‡-‡‡Æ‡‡æ : MonoidEquiv ‡‡‡∞‡µ‡æ‡‡ó‡‡ ‡‡®‡‡‡‡ó‡‡
--
-- where ‡‡®‡‡‡‡ó‡‡ is the PRODUCT monoid Œ†_b End(fiber f b) under
-- pointwise composition.  Composing with `SamraksakaGana.‡ó‡-‡‡Æ‡‡æ`
-- (whose preservation fields are refl), the chain becomes: conserving
-- flows ‚â sections of one's own fibers ‚â the product of the fibers'
-- endomorphism monoids ‚î the typal shadow of "the commutant decomposes
-- over the spectrum", now exact and checked end to end.
--
-- THE ONE COHERENCE, and why it is small.  The transport that currying
-- introduces is `subst (fiber f) p`, and over a SET codomain the only
-- fact needed about it is that it fixes the point:
--
--   ‡≤‡Æ‡‡‡ : subst (fiber f) p w .fst ‚â° w .fst        (one J)
--
-- because equality of sections and of fiber-endomorphisms alike reduces
-- to their point components (the path components are propositions).
-- All four preservation/round-trip proofs are ‡≤‡Æ‡‡‡ plus plumbing; the
-- coherence tax the ‚àû-version would pay (the full subst-action law
-- subst p (x , r) ‚â° (x , r ‚àô p) and its associativity) is named in ¬ß‡
-- and not paid here, because at set level nothing consumes it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERMS.  ‡‡®‡‡‡ for the fiber follows this corpus's own use
-- (`Vargaprakrtitantu`); ‡µ‡ø‡‡æ‡ó in its plain sense, division into parts.
-- The compound ‡‡®‡‡‡‡µ‡ø‡‡æ‡ó is built here; no text is claimed for it.
-- ‡ó‡ as in `SamraksakaGana` (gaapha, Pini, ~500 BCE, applied to
-- flows in this corpus).
--
-- CHECKED: Agda 2.8.0 + agda/cubical (installed bundle), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module TantuVibhaga_TheGanaOfAnObservableIsTheProductOfItsFibersOwnEndomorphismMonoids where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
  using (isSetŒ£ ; isSetŒ† ; isPropŒ†)
open import Cubical.Data.Sigma
open import Cubical.Algebra.Monoid

open import SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibers
open import SamraksakaGana_TheConservingFlowsFormAGanaAndTheSectionIdentificationPreservesItByRefl

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ¬ß‡ß ¬ THE TWO SIDES, over any f.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  -- the product of the fibers' endomorphism types
  ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É : Type ‚Ñì
  ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É = (b : B) ‚Üí fiber f b ‚Üí fiber f b

  _‚àò‡§§_ : ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É ‚Üí ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É ‚Üí ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É
  (t ‚àò‡§§ t') b x = t b (t' b x)

  ‡§§-‡§è‡§ï‡§É : ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É
  ‡§§-‡§è‡§ï‡§É b x = x

  -- currying: a section of one's own fibers acts on each fiber, the
  -- transport along x's residence certificate doing the bookkeeping ‚¶
  ‡§™‡•ç‡§∞‡§§‡§ø : ‡§õ‡•á‡§¶‡§É f ‚Üí ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É
  ‡§™‡•ç‡§∞‡§§‡§ø s b x = subst (fiber f) (x .snd) (s (x .fst))

  -- ‚¶ and every fiber-endomorphism family reads back as a section.
  ‡§Ü‡§ó‡§Æ‡§É : ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É ‚Üí ‡§õ‡•á‡§¶‡§É f
  ‡§Ü‡§ó‡§Æ‡§É t a = t (f a) (a , refl)

------------------------------------------------------------------------
-- ¬ß‡® ¬ THE COHERENCE, over a set codomain: transport fixes the point.
------------------------------------------------------------------------

module ‡§§‡§®‡•ç‡§§‡•å {A B : Type ‚Ñì} (setA : isSet A) (setB : isSet B) (f : A ‚Üí B) where

  open ‡§ó‡§£‡•á setA setB f using (‡§õ‡•á‡§¶-‡§∏‡§Æ‡§§‡§æ ; ‡§õ‡•á‡§¶‡§ó‡§£‡§É ; ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§ó‡§£‡§É ; ‡§ó‡§£-‡§∏‡§Æ‡§§‡§æ)

  ‡§≤‡§Æ‡•ç‡§¨‡§É : {y b : B} (p : y ‚â° b) (w : fiber f y)
        ‚Üí subst (fiber f) p w .fst ‚â° w .fst
  ‡§≤‡§Æ‡•ç‡§¨‡§É {y = y} p w =
    J (Œª b' q ‚Üí subst (fiber f) q w .fst ‚â° w .fst)
      (cong fst (substRefl {B = fiber f} w)) p

  ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§Æ‡§§‡§æ : (t t' : ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É f)
             ‚Üí ((b : B) (x : fiber f b) ‚Üí t b x .fst ‚â° t' b x .fst)
             ‚Üí t ‚â° t'
  ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§Æ‡§§‡§æ t t' h =
    funExt (Œª b ‚Üí funExt (Œª x ‚Üí Œ£‚â°Prop (Œª _ ‚Üí setB _ _) (h b x)))

  ------------------------------------------------------------------
  -- ¬ß‡© ¬ THE CARRIER EQUIVALENCE.
  ------------------------------------------------------------------

  ‡§µ‡§ø‡§≠‡§æ‡§ó-Iso : Iso (‡§õ‡•á‡§¶‡§É f) (‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É f)
  Iso.fun ‡§µ‡§ø‡§≠‡§æ‡§ó-Iso = ‡§™‡•ç‡§∞‡§§‡§ø f
  Iso.inv ‡§µ‡§ø‡§≠‡§æ‡§ó-Iso = ‡§Ü‡§ó‡§Æ‡§É f
  Iso.rightInv ‡§µ‡§ø‡§≠‡§æ‡§ó-Iso t = ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§Æ‡§§‡§æ _ _ (Œª b x ‚Üí
      ‡§≤‡§Æ‡•ç‡§¨‡§É (x .snd) (‡§Ü‡§ó‡§Æ‡§É f t (x .fst))
    ‚àô (Œª i ‚Üí t (x .snd i) (x .fst , (Œª j ‚Üí x .snd (i ‚àß j))) .fst))
  Iso.leftInv ‡§µ‡§ø‡§≠‡§æ‡§ó-Iso s = ‡§õ‡•á‡§¶-‡§∏‡§Æ‡§§‡§æ _ _ (Œª a ‚Üí ‡§≤‡§Æ‡•ç‡§¨‡§É refl (s a))

  ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É : ‡§õ‡•á‡§¶‡§É f ‚âÉ ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É f
  ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É = isoToEquiv ‡§µ‡§ø‡§≠‡§æ‡§ó-Iso

  ------------------------------------------------------------------
  -- ¬ß‡ ¬ THE MONOIDS, AND THE IDENTIFICATION CARRIES THEM.
  ------------------------------------------------------------------

  ‡§§‡§®‡•ç‡§§‡•Å‡§ó‡§£‡§É : Monoid ‚Ñì
  ‡§§‡§®‡•ç‡§§‡•Å‡§ó‡§£‡§É = makeMonoid {M = ‡§§‡§®‡•ç‡§§‡•Å-‡§Ö‡§®‡•ç‡§§‡§É f} (‡§§-‡§è‡§ï‡§É f) (_‚àò‡§§_ f)
    (isSetŒ† (Œª b ‚Üí isSetŒ† (Œª _ ‚Üí isSetŒ£ setA (Œª _ ‚Üí isProp‚ÜíisSet (setB _ _)))))
    (Œª _ _ _ ‚Üí refl) (Œª _ ‚Üí refl) (Œª _ ‚Üí refl)

  -- currying carries the unit to the identity ‚¶
  ‡§™‡•ç‡§∞‡§§‡§ø-‡§è‡§ï‡§É : ‡§™‡•ç‡§∞‡§§‡§ø f (‡§õ‡•á‡§¶-‡§è‡§ï‡§É f) ‚â° ‡§§-‡§è‡§ï‡§É f
  ‡§™‡•ç‡§∞‡§§‡§ø-‡§è‡§ï‡§É = ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§Æ‡§§‡§æ _ _ (Œª b x ‚Üí ‡§≤‡§Æ‡•ç‡§¨‡§É (x .snd) (x .fst , refl))

  -- ‚¶ and the convolution ‚ã to pointwise composition.
  ‡§™‡•ç‡§∞‡§§‡§ø-‡§ó‡•Å‡§£‡§É : (s s' : ‡§õ‡•á‡§¶‡§É f)
             ‚Üí ‡§™‡•ç‡§∞‡§§‡§ø f (_‚ãÜ_ f s s') ‚â° _‚àò‡§§_ f (‡§™‡•ç‡§∞‡§§‡§ø f s) (‡§™‡•ç‡§∞‡§§‡§ø f s')
  ‡§™‡•ç‡§∞‡§§‡§ø-‡§ó‡•Å‡§£‡§É s s' = ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§Æ‡§§‡§æ _ _ (Œª b x ‚Üí
      ‡§≤‡§Æ‡•ç‡§¨‡§É (x .snd) (_‚ãÜ_ f s s' (x .fst))
    ‚àô sym ( ‡§≤‡§Æ‡•ç‡§¨‡§É (‡§™‡•ç‡§∞‡§§‡§ø f s' b x .snd) (s (‡§™‡•ç‡§∞‡§§‡§ø f s' b x .fst))
          ‚àô cong (Œª w ‚Üí s w .fst) (‡§≤‡§Æ‡•ç‡§¨‡§É (x .snd) (s' (x .fst)))))

  ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§ó‡§£-‡§∏‡§Æ‡§§‡§æ : MonoidEquiv ‡§õ‡•á‡§¶‡§ó‡§£‡§É ‡§§‡§®‡•ç‡§§‡•Å‡§ó‡§£‡§É
  ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§ó‡§£-‡§∏‡§Æ‡§§‡§æ = ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É , monoidequiv ‡§™‡•ç‡§∞‡§§‡§ø-‡§è‡§ï‡§É ‡§™‡•ç‡§∞‡§§‡§ø-‡§ó‡•Å‡§£‡§É

  ------------------------------------------------------------------
  -- ¬ß‡‚≤ ¬ THE COMPOSITE: flows ‚â the product of the fibers' monoids.
  -- `‡ó‡-‡‡Æ‡‡æ`'s preservation fields are refl, so the composite's are
  -- exactly this module's ‚î no path algebra joins the two legs.
  ------------------------------------------------------------------

  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§Æ‡§§‡§æ : MonoidEquiv ‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§ó‡§£‡§É ‡§§‡§®‡•ç‡§§‡•Å‡§ó‡§£‡§É
  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§Æ‡§§‡§æ =
      compEquiv (‡§µ‡§æ‡§∏‡§É f) ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É
    , monoidequiv ‡§™‡•ç‡§∞‡§§‡§ø-‡§è‡§ï‡§É
        (Œª œÉ œÑ ‚Üí ‡§™‡•ç‡§∞‡§§‡§ø-‡§ó‡•Å‡§£‡§É (equivFun (‡§µ‡§æ‡§∏‡§É f) œÉ) (equivFun (‡§µ‡§æ‡§∏‡§É f) œÑ))

------------------------------------------------------------------------
-- ¬ß‡ ¬ ‡‡‡‡.
--
-- (a) THE ‚àû-VERSION.  Over arbitrary carriers the point-reduction of
--     ‡≤‡Æ‡‡‡ is not available: the full action law subst (fiber f) p
--     (x , r) ‚â° (x , r ‚àô p) and its compatibility with ‚àô-assoc must be
--     carried through every preservation proof.  Named, not paid.
-- (b) THE GROUP LEG.  `SamraksakaSamuha`'s symmetry group should ride
--     ‡‡‡∞‡µ‡æ‡-‡‡®‡‡‡-‡‡Æ‡‡æ to a subgroup of Œ†_b Aut(fiber f b); pointwise
--     that is ¬ß‡© of that module repeated here, and it is not written.
-- (c) THE POLES.  At zero loss every fiber is contractible and ‡‡®‡‡‡‡ó‡‡
--     is trivial pointwise; at total loss over a pointed connected
--     codomain the product collapses to one factor.  Both are
--     transports of the poles already proved in SamraksakaGana and are
--     not restated.
------------------------------------------------------------------------
