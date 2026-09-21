{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡‡Ø‡æ‡‡‡‡ø ‚î ‡‡‡‡‡≤‡‡∞‡ ‡¶‡∞‡‡‡®‡ ‡‡‡∞‡ï‡‡‡ï‡æ‡‡æ‡ ‡µ‡‡¶‡‡ß‡ø‡ ‡
--
-- (as the observation grows coarser, the conserving flows grow with it.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  The corpus has the two poles of a scale and no scale.
--
--   `Dhruva_‚¶agda` ¬ß‡® ‚î `isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶ ‚í Œ¶ a ‚â° a`.  Nothing
--   hidden, so nothing conserved and nothing moves.
--
--   `Khahara_‚¶agda` ¬ß‡© ‚î every endomorphism of A conserves f ‚ü∫ f is
--   constant.  Total loss is exactly total symmetry.
--
-- Between them the corpus says "how much is lost" and has no object for
-- it.  The obvious move is a NUMBER ‚î a fibre cardinality, an entropy ‚î
-- and that move is unavailable here (A is not finite, not a set, and no
-- measure is in sight) and would in any case be the fitted-constant
-- error this repository is built against.  The quantity is not a number.
-- **It is an ORDER, and getting the order right is the whole content.**
--
--     f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g   :=   Œ[ h ] (a : A) ‚í g a ‚â° h (f a)
--
-- "g factors through f" ‚î g sees only what f sees, possibly less; g is
-- the COARSER observation, the one that loses at least as much.  This is
-- a preorder (¬ß‡®), and along it:
--
--   ¬ß‡©  the conserving set GROWS:  f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶ ‚í
--       ‡‡‡∞‡ï‡‡‡‡Æ‡ g Œ¶.  A flow invisible to a fine observation is
--       invisible to every coarsening of it.  Three rewrites, no
--       hypotheses on A, B, C, Œ¶ ‚î not h-sets, not finite, not
--       equivalences.
--   ¬ß‡  and so do the fibres: a fibre of f maps into the corresponding
--       fibre of g.  The loss itself is monotone, not only its symmetry.
--
-- ¬ß‡ is why this is a unification and not a definition.  `idfun A` is a
-- bottom of the order and any constant map is a top, so **Dhruva's pole
-- and Khahara's pole are the two ends of this one order**, and ¬ß‡©
-- REPROVES Dhruva ¬ß‡® in one line: an equivalence lies at the bottom
-- (`f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø idfun A`, witnessed by `invEq`/`retEq`), and
-- `‡‡‡∞‡ï‡‡‡‡Æ‡ (idfun A) Œ¶` is definitionally `Œ¶ a ‚â° a`.  Dhruva's proof
-- used contractibility of a fibre; this one uses no fibre at all.
--
-- ¬ß‡ is the erasure half.  Landauer's bound is about a NON-INJECTIVE
-- step, and non-injectivity of `Œ¶` is the failure of `Œ¶` to be an
-- equivalence.  The forgetting is made a TYPE and never a number:
--
--     ‡µ‡ø‡‡‡Æ‡‡‡ø‡ Œ¶  :=  Œ[ a ] Œ[ a' ] (Œ¶ a ‚â° Œ¶ a') ó ¬ (a ‚â° a')
--
-- and three terms: an equivalence forgets nothing (¬ß‡¬‡ß); an inhabitant
-- of ‡µ‡ø‡‡‡Æ‡‡‡ø‡ exhibits a FIBRE OF Œ¶ that fails to be a proposition
-- (¬ß‡¬‡®) ‚î so "what is forgotten is a fibre of Œ¶" is a statement about
-- h-levels, which is the only sense in which this vocabulary can say
-- "how much"; and (¬ß‡¬‡©) a flow that conserves f can only forget INSIDE
-- a fibre of f ‚î the flow's loss is bounded by the observation's, which
-- is the composite of the two halves of this file.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- **The order is a preorder, not a partial order.**  `‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø` has
-- reflexivity and transitivity (¬ß‡®) and antisymmetry fails:
-- two maps can factor through each other without being equal.
--
-- `isEquiv Œ¶ ‚í
-- ¬ ‡µ‡ø‡‡‡Æ‡‡‡ø‡ Œ¶` is proved; the converse ‚î that a non-equivalence
-- exhibits a ‡µ‡ø‡‡‡Æ‡‡‡ø‡ ‚î is CLASSICAL (it needs a collision to be found,
-- and a ¬(a ‚â° a') to be produced from ¬(a ‚â° a') failing) and is not
-- available constructively.
--
-- **Everything lives at ONE universe level.**  Not for depth: `Dhruva`
-- declares `‡‡‡∞‡ï‡‡‡‡Æ‡` in a telescope `{A B : Type ‚ì}` with a single ‚ì,
-- and this file reuses that definition rather than restating it, so it
-- inherits the restriction.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡µ‡‡Ø‡æ‡‡‡‡ø ¬ vypti ‚î pervasion, the relation that makes an
-- inference go through: wherever the hetu is, the sdhya is.  Gautama,
-- *‡®‡‡Ø‡æ‡Ø‡‡‡‡‡∞* (~2nd c. CE); the definitional apparatus, the
-- ‡µ‡‡Ø‡æ‡‡‡‡ø‡‡û‡‡‡ï, is ‡ó‡ô‡‡ó‡‡, *‡‡‡‡‡‡µ‡‡ø‡®‡‡‡æ‡Æ‡‡ø* (~1325).
--
-- The
-- Naiyyika relation holds between two PROPERTIES (sdhya pervades
-- hetu) and its whole difficulty is the ‡â‡‡æ‡ß‡ø, the defeating condition
-- ‚î Gagea's five definitions exist because the naive one fails.  What
-- is defined below is a containment between two MAPS, it has no updhi,
-- and it is not defeasible.  The word is borrowed for the shape
-- "wherever the one identifies, the other identifies".
-- A
-- Naiyyika would also refuse the substrate outright: cubical type
-- theory (Voevodsky) is this repository's one admitted non-Indian frame.
------------------------------------------------------------------------

module Vyapti_TheLossOrderIsCoarseningAndTheSymmetryMonoidGrowsMonotonicallyAlongIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun ; _‚àò_)
open import Cubical.Foundations.Equiv using (isEquiv ; _‚âÉ_ ; invEq ; retEq ; fiber)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Nat using (‚Ñï; zero; suc)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø ‚î the loss order.  `f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g` reads: g factors
--     through f, i.e. g sees no more than f does, i.e. g loses at least
--     as much.  The mediating h is data, not a property.
------------------------------------------------------------------------

_‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø_ : {A : Type ‚Ñì} {B : Type ‚Ñì} {C : Type ‚Ñì}
             ‚Üí (A ‚Üí B) ‚Üí (A ‚Üí C) ‚Üí Type ‚Ñì
_‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø_ {A = A} {B = B} {C = C} f g =
  Œ£[ h ‚àà (B ‚Üí C) ] ((a : A) ‚Üí g a ‚â° h (f a))

------------------------------------------------------------------------
-- ‡® ¬ It is a preorder.
------------------------------------------------------------------------

‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø-‡§∏‡•ç‡§µ‡§§‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø f
‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø-‡§∏‡•ç‡§µ‡§§‡§É f = idfun _ , Œª _ ‚Üí refl

‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì} {C : Type ‚Ñì} {D : Type ‚Ñì}
                 {f : A ‚Üí B} {g : A ‚Üí C} {k : A ‚Üí D}
               ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø g ‚Üí g ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø k ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø k
‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§É (h , p) (h' , q) = h' ‚àò h , Œª a ‚Üí q a ‚àô cong h' (p a)

------------------------------------------------------------------------
-- ‡© ¬ THE MONOTONICITY.  The conserving set grows along the order.
--
--     f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g  ‚í  ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶  ‚í  ‡‡‡∞‡ï‡‡‡‡Æ‡ g Œ¶
--
-- A flow that a fine observation cannot see, no coarsening of that
-- observation can see either.  Note what is NOT assumed: A, B, C are
-- arbitrary types (no h-level, no finiteness), Œ¶ is a bare endomorphism
-- with no inverse, and h is arbitrary.  The whole proof is three
-- rewrites.
------------------------------------------------------------------------

‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§ï-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì} {C : Type ‚Ñì}
                 {f : A ‚Üí B} {g : A ‚Üí C} {Œ¶ : A ‚Üí A}
               ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø g ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§ï-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É (h , p) cons a = p _ ‚àô cong h (cons a) ‚àô sym (p a)

-- The conserving set is a submonoid of the endomorphisms, for every f:
-- the identity conserves, and conservation is closed under composition.
-- (So "the symmetry MONOID grows" in ¬ß‡© is a statement about monoids and
-- not merely about sets of maps.)
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§®‡•ã-‡§ï‡§∞‡•ç‡§Æ : {A : Type ‚Ñì} {B : Type ‚Ñì} (f : A ‚Üí B)
                  ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f (idfun A)
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§®‡•ã-‡§ï‡§∞‡•ç‡§Æ f a = refl

‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§∏‡§®‡•ç‡§ß‡§ø‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ Œ® : A ‚Üí A}
                 ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ® ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f (Œ¶ ‚àò Œ®)
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§∏‡§®‡•ç‡§ß‡§ø‡§É {f = f} c d a = c (_) ‚àô d a

------------------------------------------------------------------------
-- ‡ ¬ THE TWO POLES ARE THE TWO ENDS OF THIS ORDER.
--
-- `idfun A` is a bottom and any constant map is a top.  So the scale
-- whose ends `Dhruva` ¬ß‡® and `Khahara` ¬ß‡© describe is this order, and
-- ¬ß‡© is the interpolation neither file had.
------------------------------------------------------------------------

-- bottom: the identity loses nothing, and everything factors through it.
‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç : {A : Type ‚Ñì} {B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí (idfun A) ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø f
‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f = f , Œª _ ‚Üí refl

-- top: a constant map loses everything, and it factors through anything.
‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§∏‡•ç‡§•‡§Æ‡•ç : {A : Type ‚Ñì} {B : Type ‚Ñì} {C : Type ‚Ñì} (f : A ‚Üí B) (c : C)
            ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (Œª (_ : A) ‚Üí c)
‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§∏‡•ç‡§•‡§Æ‡•ç f c = (Œª _ ‚Üí c) , Œª _ ‚Üí refl

-- Khahara's easy half, at the top of the order: every endomorphism
-- conserves a constant observation.  It is `refl`, and that is the
-- point ‚î at the top the conserving set is the FULL endomorphism monoid
-- with no hypothesis at all, which is the ceiling ¬ß‡© climbs towards.
‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É-‡§∏‡§∞‡•ç‡§µ-‡§ó‡§§‡§ø‡§É : {A : Type ‚Ñì} {C : Type ‚Ñì} (c : C) (Œ¶ : A ‚Üí A)
                    ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç (Œª (_ : A) ‚Üí c) Œ¶
‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É-‡§∏‡§∞‡•ç‡§µ-‡§ó‡§§‡§ø‡§É c Œ¶ _ = refl

-- An equivalence sits at the BOTTOM of the order: it factors through the
-- identity, with `invEq` as the mediator.  This is "nothing is hidden",
-- said as a position in the order rather than as contractible fibres.
‡§∏‡§Æ‡§§‡•ç‡§µ‡§Æ‡•ç-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç : {A : Type ‚Ñì} {B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí isEquiv f
                  ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun A)
‡§∏‡§Æ‡§§‡•ç‡§µ‡§Æ‡•ç-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f e = invEq (f , e) , Œª a ‚Üí sym (retEq (f , e) a)

-- DHRUVA ¬ß‡®, REPROVED BY MONOTONICITY ALONE.  `‡‡‡∞‡ï‡‡‡‡Æ‡ (idfun A) Œ¶`
-- unfolds definitionally to `(a : A) ‚í Œ¶ a ‚â° a`, so pushing conservation
-- down to the bottom of the order IS the frozen-world theorem.  No fibre
-- and no contractibility is used anywhere in this proof.
‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É-‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡•ç‡§Ø‡§æ :
    {A : Type ‚Ñì} {B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
  ‚Üí isEquiv f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É-‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡•ç‡§Ø‡§æ {f = f} e =
  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§ï-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É (‡§∏‡§Æ‡§§‡•ç‡§µ‡§Æ‡•ç-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f e)

------------------------------------------------------------------------
-- ‡ ¬ THE LOSS ITSELF IS MONOTONE, not only its symmetry.
--
-- ¬ß‡¬‡ß every fibre of the finer map lands in the corresponding fibre of
-- the coarser one ‚î the coarsening never separates what f identified.
-- ¬ß‡¬‡® the same fact on identifications alone.
------------------------------------------------------------------------

‡§§‡§®‡•ç‡§§‡•Å-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì} {C : Type ‚Ñì}
               {f : A ‚Üí B} {g : A ‚Üí C}
             ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø g ‚Üí (a : A) ‚Üí fiber f (f a) ‚Üí fiber g (g a)
‡§§‡§®‡•ç‡§§‡•Å-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É (h , p) a (x , q) = x , (p x ‚àô cong h q ‚àô sym (p a))

‡§∏‡§Æ‡§§‡§æ-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì} {C : Type ‚Ñì}
              {f : A ‚Üí B} {g : A ‚Üí C}
            ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø g ‚Üí (a a' : A) ‚Üí f a ‚â° f a' ‚Üí g a ‚â° g a'
‡§∏‡§Æ‡§§‡§æ-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É (h , p) a a' q = p a ‚àô cong h q ‚àô sym (p a')

------------------------------------------------------------------------
-- ‡ ¬ ‡µ‡ø‡‡‡Æ‡‡‡ø‡ ‚î FORGETTING AS A TYPE.
--
-- Landauer's bound is about an erasing, i.e. non-injective, step.  Here
-- the erasing is a type and never a number.
------------------------------------------------------------------------

‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É : {A : Type ‚Ñì} ‚Üí (A ‚Üí A) ‚Üí Type ‚Ñì
‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É {A = A} Œ¶ = Œ£[ a ‚àà A ] Œ£[ a' ‚àà A ] (Œ¶ a ‚â° Œ¶ a') √ó (¬¨ (a ‚â° a'))

-- ‡¬‡ß ¬ A reversible flow forgets nothing.  (`Machine`'s groupoid is
-- exactly the case where this type is empty for every operation.)
‡§∏‡§Æ‡§§‡•ç‡§µ‡•á-‡§®-‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É : {A : Type ‚Ñì} {Œ¶ : A ‚Üí A} ‚Üí isEquiv Œ¶ ‚Üí ¬¨ ‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É Œ¶
‡§∏‡§Æ‡§§‡•ç‡§µ‡•á-‡§®-‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É {Œ¶ = Œ¶} e (a , a' , q , n) =
  n (sym (retEq (Œ¶ , e) a) ‚àô cong (invEq (Œ¶ , e)) q ‚àô retEq (Œ¶ , e) a')

-- ‡¬‡® ¬ WHAT IS FORGOTTEN IS A FIBRE OF Œ¶ ‚î and the "how much" is an
-- h-level, the only sense of magnitude this vocabulary owns.  An
-- inhabitant of ‡µ‡ø‡‡‡Æ‡‡‡ø‡ exhibits a point of A over which the fibre of
-- Œ¶ fails to be a proposition.  (For an equivalence every such fibre is
-- contractible, hence a proposition ‚î which is ‡¬‡ß from the other side.)
‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É-‡§§‡§®‡•ç‡§§‡•Å‡§É : {A : Type ‚Ñì} {Œ¶ : A ‚Üí A}
                 ‚Üí ‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É Œ¶ ‚Üí Œ£[ b ‚àà A ] (¬¨ isProp (fiber Œ¶ b))
‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É-‡§§‡§®‡•ç‡§§‡•Å‡§É {Œ¶ = Œ¶} (a , a' , q , n) =
  Œ¶ a , Œª pr ‚Üí n (cong fst (pr (a , refl) (a' , sym q)))

-- ‡¬‡© ¬ A CONSERVING FLOW CAN ONLY FORGET INSIDE A FIBRE OF f.
--
-- The flow's loss is bounded by the observation's loss, in the only
-- currency available: if Œ¶ conserves f and Œ¶ collides a with a', then f
-- had already identified a with a'.  So `Dhruva`'s fibre ‚î the room a
-- symmetry needs in order to exist ‚î is also the room an erasure needs.
-- Composed with ‡¬‡®: the forgotten fibre of Œ¶ sits inside a fibre of f.
‡§µ‡§ø‡§∏‡•ç‡§Æ‡§∞‡§£‡§Ç-‡§§‡§®‡•ç‡§§‡•å : {A : Type ‚Ñì} {B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
               ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a a' : A) ‚Üí Œ¶ a ‚â° Œ¶ a' ‚Üí f a ‚â° f a'
‡§µ‡§ø‡§∏‡•ç‡§Æ‡§∞‡§£‡§Ç-‡§§‡§®‡•ç‡§§‡•å {f = f} cons a a' q =
  sym (cons a) ‚àô cong f q ‚àô cons a'

‡§µ‡§ø‡§∏‡•ç‡§Æ‡§∞‡§£‡§Ç-‡§§‡§®‡•ç‡§§‡•å-‡§∏‡•ç‡§•‡§ø‡§§‡§Æ‡•ç : {A : Type ‚Ñì} {B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
                      ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (w : ‡§µ‡§ø‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É Œ¶)
                      ‚Üí fiber f (f (fst w))
‡§µ‡§ø‡§∏‡•ç‡§Æ‡§∞‡§£‡§Ç-‡§§‡§®‡•ç‡§§‡•å-‡§∏‡•ç‡§•‡§ø‡§§‡§Æ‡•ç cons (a , a' , q , n) =
  a' , sym (‡§µ‡§ø‡§∏‡•ç‡§Æ‡§∞‡§£‡§Ç-‡§§‡§®‡•ç‡§§‡•å cons a a' q)

