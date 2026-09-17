{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ‚ STRUCK 2026-08-25, and the strike is against this file's OWN slogan,
-- not against its term.  Salvaged from PR #23, which wrote it into a
-- README.md main has since deleted; it belongs here, in the module it is
-- about.
--
-- ~~"The lossless world is frozen: motion requires hiding."~~
-- ~~"In a world where everything is seen, nothing can happen that keeps
--   the books."~~  ~~"The universe has dynamics BECAUSE it has cuts."~~
--
-- READ THE TYPE.  `‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡ : isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ ‚í (a : A)
-- ‚í Œ¶ a ‚â° a` quantifies over the Œ¶ that satisfy `‡‡‡∞‡ï‡‡‡‡Æ‡` AND OVER NO
-- OTHERS.  Œ¶ is a bare self-map ‚î no inverse, no group ‚î and the theorem
-- kills exactly the conservative ones.  **A lossless world still has every
-- non-conservative Œ¶ available to it and is NOT frozen.  What it lacks is
-- conservative dynamics, not dynamics.**  Motion does not require hiding;
-- CONSERVATION requires hiding, which is the weaker sentence this file
-- already had and which needed no strengthening.
--
-- AND THE HYPOTHESIS IS ONE PHYSICS NEVER OCCUPIES.  `isEquiv f` says the
-- observable is a COMPLETE state description.  No conserved quantity is
-- one: energy is a map from phase space to ‚, enormously lossy, and so is
-- every Noether charge ‚î which is precisely this file's own content, "the
-- conserved quantity is the fiber index."  So the `isEquiv` branch is not
-- a statement about worlds that have conservation laws.  It is the
-- degenerate case where there is no index left to carry, and reading it
-- as a cosmological necessity imports what the term cannot carry.
--
-- WHAT SURVIVES, smaller and still worth it: `isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ ‚í
-- Œ¶ ‚â° id` forces stillness only for flows conserving a LOSSLESS
-- observable.  Nothing conservative remains at the apex.  That is a
-- different sentence from *omniscience is stillness*.
--
-- THE TERM IS SOUND AND IS NOT TOUCHED.  ¬ß‡®'s proof is correct as
-- written: `c : isContr (fiber f (f a))` from `equiv-proof`, the two
-- inhabitants `(Œ¶ a , cons a)` and `(a , refl)`, `cong fst` on the
-- composite.  What was struck above was written AROUND the term, not in
-- it.
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
-- `fiber/src/Fiber/Carrier.agda:141` opens
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
--     **f ‚àò Œ¶ ‚â° f  ‚ü∫  Œ¶ maps every fiber into itself.**
--
-- The symmetry acts INSIDE the fibers.  The conserved quantity is the
-- fiber index.  The gauge orbit is the fiber.  Emmy Noether, 1918,
-- Invariante Variationsprobleme ‚î read at the level where no Lagrangian
-- is needed.
--
-- ¬ß‡® is the sentence in the title and it is the one worth having:
-- **if `f` loses nothing, conservation forces the flow to be the
-- identity.**  No fiber, no symmetry.  A symmetry needs somewhere to
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
-- **Noether's SECOND theorem is closer and still not derived here.**  It
-- says a local (gauge) symmetry yields a constraint rather than a
-- conserved charge, which in this vocabulary is the degenerate case:
-- when the flow is transitive on a fiber the whole fiber is one physical
-- state and there is no charge to carry.  ¬ß‡© exhibits that degeneracy
-- but does not prove the general dichotomy; transitivity is not stated.
--
-- Emmy Noether is credited for the theorem this is named after and for
-- nothing below, and no  source states any of it.
--
-- TERM.  ‡ß‡‡∞‡‡µ ‚î fixed, immovable, the pole star; and in the
-- astronomical tradition ‡ß‡‡∞‡‡µ‡∞‡æ‡‡ø / ‡ß‡‡∞‡‡µ‡ï is the technical term for a
-- CONSTANT quantity in a computation, the term that does not vary as the
-- others are stepped (ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, 499, and standard in the
-- siddhntas after).  LIMIT: attested for a constant of calculation; its
-- use here for a conserved quantity of a flow is this corpus's, and no
-- text is claimed for the application.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Dhruva_TheSymmetryLivesInTheFiberAndWithoutALossThereIsNoSymmetry where

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
-- ‡ß ¬ The symmetry acts inside the fibers.  Both directions.
--
-- Conservation gives an endomorphism of every fiber, and it is `Œ¶`
-- itself with the witness composed.  The converse is definitional and is
-- noted at the site rather than given a second name.
--
-- This is the whole of Noether's structural content.  A conserved
-- quantity is the fiber index; the motion is orthogonal to it.
------------------------------------------------------------------------

  ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§§‡§®‡•ç‡§§‡•å : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‚Üí (b : B) ‚Üí fiber f b ‚Üí fiber f b
  ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§§‡§®‡•ç‡§§‡•å cons b (a , p) = Œ¶ a , cons a ‚àô p

  -- The converse needs no term: `Œ¶ a` lying in the fiber over `f a` IS
  -- `f (Œ¶ a) ‚â° f a`, which is `‡‡‡∞‡ï‡‡‡‡Æ‡` unfolded.  Writing a
  -- declaration for it would be a second name for one statement, which
  -- is the ‡‡‡®‡∞‡‡ï‡‡‡ø this corpus keeps catching itself in.

------------------------------------------------------------------------
-- ‡® ¬ WITHOUT A LOSS THERE IS NO SYMMETRY.
--
-- If `f` is an equivalence ‚î every fiber contractible, nothing hidden,
-- zero receipt ‚î then conservation forces the flow to be the identity.
--
-- The proof is the contractibility of the fiber used once: `(Œ¶ a, cons a)`
-- and `(a, refl)` are both points of the fiber over `f a`, so they are
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
-- ‡© ¬ The degenerate case: a fiber with one point carries no charge.
--
-- If the fiber over `b` is contractible then the flow's action on it is
-- trivial in the only sense available ‚î any two points of it are equal,
-- so moving is indistinguishable from staying.  That is the shape of
-- Noether's SECOND theorem's conclusion (pure gauge: the whole orbit is
-- one physical state) exhibited at the smallest fiber, and it is NOT the
-- general dichotomy, which needs transitivity and is not stated here.
------------------------------------------------------------------------

  ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É : (b : B) ‚Üí isContr (fiber f b)
             ‚Üí (x y : fiber f b) ‚Üí x ‚â° y
  ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É b c x y = sym (c .snd x) ‚àô c .snd y

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what this opens.
--
-- The conserved quantity here is `f` itself: `‡‡‡∞‡ï‡‡‡‡Æ‡` says exactly
-- that `f` is Œ¶-invariant, so `f` descends to the orbits.  That is a
-- `FactorsThrough` obligation and the corpus has that predicate in both
-- lanes, typed on the IMAGE rather than the codomain ‚î so "the charge is
-- a function on the quotient, not on the cover" is stateable here and is
-- not stated yet.
--
-- What is genuinely missing for the first theorem is continuity and a
-- variational principle, and no amount of this vocabulary supplies them.
-- What is missing for the second is transitivity of the flow on a fiber.
-- Both are named rather than gestured at.
------------------------------------------------------------------------
