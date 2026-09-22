{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ï‡ï‡‡‡‡Ø‡æ ‚î ‡ß‡‡∞‡‡µ‡ ‡ï‡ï‡‡‡‡Ø‡æ‡Ø‡æ‡ ‡‡‡‡ø‡∞‡Æ‡ ‡
--
-- (the conserved quantity is constant along the orbit.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  In `Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThere
-- IsNoSymmetry.agda` ¬ß‡ß the conserved quantity is `f` itself: `‡‡‡∞‡ïÔøΩ‡ÔøΩ‡ÆÔøΩ`
-- says exactly that `f` is Œ¶-invariant, so `f` descends to the orbits ‡
-- "the charge is a function on the quotient, not on the cover".
--
-- This module states that.  Dhruva's ¬ß‡ß gives one step ‚î `f (Œ¶ a) ‚â° f a` ‚î and that
-- alone leaves open whether the charge could drift along a long orbit.  It
-- cannot: ¬ß‡® below is the induction, and its content is that the charge
-- cannot distinguish ANY two points of an orbit, at ANY distance.  That is
-- what "a function on the quotient rather than on the cover" says without
-- introducing a quotient type: the cover's points are separated by Œ¶, and
-- the charge is blind to every one of those separations.
--
-- WHY IT IS WORTH A TERM AND NOT A REMARK.  The one-step law is a
-- hypothesis about a generator; the orbit law is a statement about the
-- ORBIT, which is the object `Dhruva` ¬ß‡ß actually identifies with the
-- gauge orbit and the fibre.  Without ¬ß‡®, "the gauge orbit is the fibre"
-- is asserted of a set nothing has been proved constant on.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- TERM.  ‡ï‡ï‡‡‡‡Ø‡æ ‚î in the siddhntic astronomical tradition, the orbit or
-- orbital circle of a planet (standard from ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, 499,
-- and through the Sryasiddhnta).  Its use here for
-- the forward orbit of an endomorphism is this corpus's.
------------------------------------------------------------------------

module Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç)

private variable ‚Ñì : Level

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

------------------------------------------------------------------------
-- ‡ß ¬ ‡ï‡ï‡‡‡‡Ø‡æ ‚î the forward orbit, as an iteration of the flow.
--
-- `Œ¶` is a bare endomorphism, so this is the forward orbit and nothing
-- more: no inverse is available and none is used.
------------------------------------------------------------------------

  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ : ‚Ñï ‚Üí A ‚Üí A
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ zero    a = a
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ (suc n) a = Œ¶ (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ n a)

------------------------------------------------------------------------
-- ‡® ¬ ‡ß‡‡∞‡‡µ‡ ‡ï‡ï‡‡‡‡Ø‡æ‡Ø‡æ‡ ‡‡‡‡ø‡∞‡Æ‡ ‚î THE CHARGE IS CONSTANT ALONG THE ORBIT.
--
-- Dhruva ¬ß‡ß gives one step.  This is every step, by induction, and the
-- proof is the one-step law composed with the tail.
--
-- Read at the physics: the observable cannot distinguish any two points
-- of one orbit, however far apart along the flow.  That is the exact
-- content of "the charge is a function on the quotient, not on the
-- cover" ‚î stated on the cover, where it is provable without building a
-- quotient.
------------------------------------------------------------------------

  ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (n : ‚Ñï) (a : A) ‚Üí f (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ n a) ‚â° f a
  ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç cons zero    a = refl
  ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç cons (suc n) a = cons (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ n a) ‚àô ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç cons n a

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡‡¶‡ ‚î and therefore no two points of an orbit are separated by
--     the charge.  This is ¬ß‡® read as the blindness it is: for any two
--     stations `m`, `n` on one orbit, the observable agrees.
------------------------------------------------------------------------

  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ö‡§≠‡•á‡§¶‡§É : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (m n : ‚Ñï) (a : A)
                ‚Üí f (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ m a) ‚â° f (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ n a)
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ö‡§≠‡•á‡§¶‡§É cons m n a =
    ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç cons m a ‚àô sym (‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç cons n a)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î scope.
--
-- `Œ¶` is a bare endomorphism.  ¬ß‡®‚ì¬ß‡© are stated on the cover and need
-- no orbit relation, no quotient, and no inverse.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ‡ ¬ ‡®‡‡‡ü‡æ‡‡æ‡µ‡ ‡ï‡ï‡‡‡‡Ø‡æ ‡‡ï‡‡¶‡æ ‚î WITHOUT LOSS THE ORBIT IS A SINGLE POINT.
--
-- `Dhruva` ¬ß‡® proves that losslessness plus conservation force `Œ¶ a ‚â° a`
-- ‚î one step.  With ¬ß‡ß's iteration that is every step: the whole forward
-- orbit collapses onto its own basepoint.
--
-- This is README movement 30's sentence made literal.  It says there that
-- a lossless world is FROZEN, and what ¬ß‡® of Dhruva supports on its own is
-- only that the generator is the identity.  The frozen claim is about the
-- ORBIT ‚î that nothing goes anywhere ‚î and that is this.
--
-- Note what it does NOT need: `Œ¶` is still a bare endomorphism.  No group,
-- no inverse, no continuity.  Losslessness alone kills the whole forward
-- trajectory.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (isEquiv)

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

  open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
    using (‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É)

  ‡§®‡§∑‡•ç‡§ü‡§æ‡§≠‡§æ‡§µ‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ : isEquiv f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶
                          ‚Üí (n : ‚Ñï) (a : A) ‚Üí ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ f Œ¶ n a ‚â° a
  ‡§®‡§∑‡•ç‡§ü‡§æ‡§≠‡§æ‡§µ‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ e cons zero    a = refl
  ‡§®‡§∑‡•ç‡§ü‡§æ‡§≠‡§æ‡§µ‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ e cons (suc n) a =
    cong Œ¶ (‡§®‡§∑‡•ç‡§ü‡§æ‡§≠‡§æ‡§µ‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ e cons n a) ‚àô ‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É f Œ¶ e cons a

------------------------------------------------------------------------
-- ‡ ¬ ‡ï‡ï‡‡‡‡Ø‡æ ‡‡®‡‡‡ ‡µ‡‡‡ø ‚î THE WHOLE ORBIT LIES IN ONE FIBRE.
--
-- `Dhruva` ¬ß‡ß proves that `Œ¶` carries a fibre into itself ‚î one step ‚î
-- and its prose then reads that as "the gauge orbit IS the fibre".  The
-- orbit is a set ¬ß‡ß never quantifies over.  This is that set: every
-- station of the forward orbit of `a` is a point of the fibre over
-- `f a`, with ¬ß‡® supplying its membership witness.
--
-- So the sentence "the gauge orbit lies in the fibre" has a term
-- whose subject is the orbit.  The converse -- that the fibre is
-- exhausted by one orbit -- is transitivity of the flow on the fibre,
-- which ¬ß‡ß takes as a hypothesis.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (fiber)

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§§‡§®‡•ç‡§§‡•å : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (n : ‚Ñï) (a : A) ‚Üí fiber f (f a)
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§§‡§®‡•ç‡§§‡•å cons n a = ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ f Œ¶ n a , ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç f Œ¶ cons n a

------------------------------------------------------------------------
-- ‡ ¬ ‡‡ô‡‡ï‡‡∞‡Æ‡‡ ‡‡æ‡∞‡ã ‡®‡æ‡‡‡‡ø ‚î WHERE THE FLOW IS TRANSITIVE, NO INVARIANT
--     CARRIES A CHARGE.
--
-- ¬ß‡ above: the orbit lies IN the fibre, and whether it EXHAUSTS the
-- fibre is transitivity.
--
-- Here transitivity is stated, as a hypothesis, and its consequence
-- proved: if the flow reaches every point of a fibre from every other,
-- then EVERY Œ¶-invariant observable is constant on that fibre.  Not just
-- `f` ‚î every one.  So there is no further conserved quantity to carry
-- there, and the whole fibre is one state as far as any invariant can
-- tell.
--
-- That is Noether's SECOND theorem's conclusion ‚î a local symmetry gives
-- a constraint rather than a charge ‚î at the level where no Lagrangian is
-- needed.  As in `Dhruva`: no variation, no continuity, no action.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

  -- the flow reaches every point of the fibre from every other
  ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç : B ‚Üí Type ‚Ñì
  ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç b = (x y : fiber f b) ‚Üí Œ£[ n ‚àà ‚Ñï ] ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ f Œ¶ n (fst x) ‚â° fst y

  -- and then NO invariant separates two points of that fibre
  ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§≠‡§æ‡§∞‡•ã-‡§®‡§æ‡§∏‡•ç‡§§‡§ø :
      {C : Type ‚Ñì} (g : A ‚Üí C) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶
    ‚Üí (b : B) ‚Üí ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç b
    ‚Üí (x y : fiber f b) ‚Üí g (fst x) ‚â° g (fst y)
  ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§≠‡§æ‡§∞‡•ã-‡§®‡§æ‡§∏‡•ç‡§§‡§ø g gcons b tr x y =
    sym (‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç g Œ¶ gcons (fst (tr x y)) (fst x))
    ‚àô cong g (snd (tr x y))
