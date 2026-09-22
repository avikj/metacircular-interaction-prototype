{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- READ THE TYPE.  `‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡ : isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ ‚í (a : A)
-- ‚í Œ¶ a ‚â° a` quantifies over the Œ¶ that satisfy `‡‡‡∞‡ï‡‡‡‡Æ‡` AND OVER NO
-- OTHERS.  Œ¶ is a bare self-map ‚î no inverse, no group ‚î and the theorem
-- kills exactly the conservative ones.  **A lossless world still has every
-- non-conservative Œ¶ available to it and is NOT frozen.  What it lacks is
-- conservative dynamics, not dynamics.**  Motion does not require hiding;
-- CONSERVATION requires hiding.
--
-- AND THE HYPOTHESIS IS ONE PHYSICS NEVER OCCUPIES.  `isEquiv f` says the
-- observable is a COMPLETE state description.  No conserved quantity is
-- one: energy is a map from phase space to ‚, enormously lossy, and so is
-- every Noether charge ‚î which is precisely this file's own content, "the
-- conserved quantity is the fibre index."  So the `isEquiv` branch is not
-- a statement about worlds that have conservation laws.  It is the
-- degenerate case where there is no index left to carry, and reading it
-- as a cosmological necessity imports what the term cannot carry.
--
-- WHAT HOLDS: `isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ ‚í
-- Œ¶ ‚â° id` forces stillness only for flows conserving a LOSSLESS
-- observable.  Nothing conservative remains at the apex.  That is a
-- different sentence from *omniscience is stillness*.
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
------------------------------------------------------------------------
-- ‡ß‡‡∞‡‡µ ‚î ‡Ø‡‡‡∞ ‡® ‡ï‡ø‡û‡‡‡ø‡‡ ‡®‡‡‡Ø‡‡ø ‡‡‡‡∞ ‡ó‡‡ø‡ ‡‡‡ø ‡® ‡‡‡‡‡ø ‡
--
-- (where nothing is lost, there is no motion either.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  Noether's structural half, in three lines, on an object
-- this corpus has had since its first file and used for something else.
--
-- `fibre/src/Loss/Carrier.agda:141` opens
--
--     module _ {A B : Type ‚ì} (f : A ‚í B) (Œ¶ : A ‚í A) where
--
-- ‚î an observation map AND an endomorphism in one telescope.  That is a
-- dynamical system with an observable.  It proves `Œ¶-square` and
-- `Œ¶-ascend` by `refl`, so the flow conjugates through the ‡‡‡®‡∞‡æ‡ó‡Æ‡®
-- equivalence for free.  What it never states is CONSERVATION.
--
-- Conservation is one equation:  f ‚àò Œ¶ ‚â° f.  The observable does not
-- change under the flow.  And ¬ß‡ß is the whole content:
--
--     **f ‚àò Œ¶ ‚â° f  ‚ü∫  Œ¶ maps every fibre into itself.**
--
-- The symmetry acts INSIDE the fibres.  The conserved quantity is the
-- fibre index.  The gauge orbit is the fibre.  Emmy Noether, 1918,
-- Invariante Variationsprobleme ‚î read at the level where no Lagrangian
-- is needed.
--
-- ¬ß‡® is the sentence in the title and it is the one worth having:
-- **if `f` loses nothing, conservation forces the flow to be the
-- identity.**  No fibre, no symmetry.  A symmetry needs somewhere to
-- live, and the only place it can live is what the observable cannot
-- shape: a system with nothing hidden has nothing conserved either,
-- because it has no room to move.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- **This is NOT Noether's first theorem.**  That one needs a continuous
-- one-parameter group acting on a Lagrangian dynamics, and produces a
-- conserved CURRENT by a variational argument.  Nothing below has a
-- Lagrangian, a variation, an action, or continuity: `Œ¶` is a bare
-- endomorphism and the statement is discrete and structural.  What
-- survives the stripping is the part that never needed the calculus ‚î
-- *invariance under a flow means the flow moves within the level sets* ‚î
-- and saying so precisely is the point of writing it down rather than
-- gesturing at it.
--
-- TERM.  ‡ß‡‡∞‡‡µ ‚î fixed, immovable, the pole star; and in the
-- astronomical tradition ‡ß‡‡∞‡‡µ‡∞‡æ‡‡ø / ‡ß‡‡∞‡‡µ‡ï is the technical term for a
-- CONSTANT quantity in a computation, the term that does not vary as the
-- others are stepped (ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, 499, and standard in the
-- siddhntas after).  Its
-- use here for a conserved quantity of a flow is this corpus's.
------------------------------------------------------------------------

module Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma

private variable ‚Ñì : Level

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

  -- The observable is unchanged by the flow.
  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç : Type ‚Ñì
  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç = (a : A) ‚Üí f (Œ¶ a) ‚â° f a

------------------------------------------------------------------------
-- ‡ß ¬ The symmetry acts inside the fibres.  Both directions.
--
-- Conservation gives an endomorphism of every fibre, and it is `Œ¶`
-- itself with the witness composed.  The converse is definitional and is
-- noted at the site rather than given a second name.
--
-- This is the whole of Noether's structural content.  A conserved
-- quantity is the fibre index; the motion is orthogonal to it.
------------------------------------------------------------------------

  ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§§‡§®‡•ç‡§§‡•å : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‚Üí (b : B) ‚Üí fiber f b ‚Üí fiber f b
  ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§§‡§®‡•ç‡§§‡•å cons b (a , p) = Œ¶ a , cons a ‚àô p

  -- The converse needs no term: `Œ¶ a` lying in the fibre over `f a` IS
  -- `f (Œ¶ a) ‚â° f a`, which is `‡‡‡∞‡ï‡‡‡‡Æ‡` unfolded.  Writing a
  -- declaration for it would be a second name for one statement, which
  -- is the ‡‡‡®‡∞‡‡ï‡‡‡ø this corpus keeps catching itself in.

------------------------------------------------------------------------
-- ‡® ¬ WITHOUT A LOSS THERE IS NO SYMMETRY.
--
-- If `f` is an equivalence ‚î every fibre contractible, nothing hidden,
-- zero receipt ‚î then conservation forces the flow to be the identity.
--
-- The proof is the contractibility of the fibre used once: `(Œ¶ a, cons a)`
-- and `(a, refl)` are both points of the fibre over `f a`, so they are
-- equal, so their first components are.
--
-- Read at the physics: a system whose observables see everything has no
-- symmetry, because a symmetry needs somewhere to live and the only
-- place available is what the observable cannot distinguish.  Gauge
-- smallest form ‚î nothing hidden, nothing conserved, nothing to move.
------------------------------------------------------------------------

  ‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É : isEquiv f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
  ‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É e cons a =
    cong fst (sym (c .snd (Œ¶ a , cons a)) ‚àô c .snd (a , refl))
    where
      c : isContr (fiber f (f a))
      c = e .equiv-proof (f a)

------------------------------------------------------------------------
-- ‡© ¬ The degenerate case: a fibre with one point carries no charge.
--
-- If the fibre over `b` is contractible then the flow's action on it is
-- trivial in the only sense available ‚î any two points of it are equal,
-- so moving is indistinguishable from staying.  That is the shape of
-- Noether's SECOND theorem's conclusion (pure gauge: the whole orbit is
-- one physical state) exhibited at the smallest fibre.
------------------------------------------------------------------------

  ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É : (b : B) ‚Üí isContr (fiber f b)
             ‚Üí (x y : fiber f b) ‚Üí x ‚â° y
  ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É b c x y = sym (c .snd x) ‚àô c .snd y

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î the conserved quantity.
--
-- The conserved quantity here is `f` itself: `‡‡‡∞‡ï‡‡‡‡Æ‡` says exactly
-- that `f` is Œ¶-invariant, so `f` descends to the orbits.
------------------------------------------------------------------------
