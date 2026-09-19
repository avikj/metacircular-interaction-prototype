{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Ø‡ã‡ó‡ï‡‡‡‡‡‡∞ ‚î the conserving flows of addition are exactly the shear
-- fields, so the freedom of the cut is a function space.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  `Dhruva_‚¶.agda` proves the frame (conservation acts
-- inside the fibres; lossless forces Œ¶ ‚â° id) and `YogaDhruva_‚¶.agda`
-- instantiates it (fiber ‡Ø‡ã‡ó n is a ‚-torsor under the shears) ‚î and its
-- own header fences that it did NOT classify the conserving
-- endomorphisms.  This module is that classification, for this
-- observable, over an ARBITRARY commutative ring:
--
--   ¬ß‡ß  every shear FIELD ‚î a shear whose parameter varies with the
--       point, k : R ó R ‚í R ‚î conserves the sum;
--   ¬ß‡®  every conserving flow IS the shear field of its own
--       displacement ‡ï‡‡‡‡‡‡∞-‡Æ‡æ‡‡ Œ¶ p = fst (Œ¶ p) ‚àí fst p;
--   ¬ß‡©  the two constructions are inverse, so
--
--         (Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡ ‡Ø‡ã‡ó Œ¶)  ‚â  (R ó R ‚í R)
--
--       ‚î the space of conserving flows of addition IS the function
--       space.  One parameter of R per point, no more, no less.
--
-- Read with Dhruva ¬ß‡® this exhibits the two poles of one statement: a
-- LOSSLESS observable has a contractible flow space (Œ¶ ‚â° id, nothing
-- hidden, no room to move), and THIS cut ‚î each fibre a full R-torsor ‚î
-- has a flow space as large as a function space.  The freedom of a cut
-- is measured by its conserving flows, and here the measure is exact.
--
-- PROOF-SHAPE NOTE, following the precedent of `PraksepaTantu_‚¶.agda`
-- (landed 2026-08-22 as the shape a ‡‡‡‡ fst/snd emitter instantiates):
-- everything below is parametric in the CommRing, and every ring fact is
-- discharged by the solver, so this is the shape a future T-SHEAR
-- emitter would instantiate at any additive observable the census
-- meets.  The ‚ instance is taken at the end in one line.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- TERM.  ‡ï‡‡‡‡‡‡∞ ‚î field ‚î is the standard term of the gaita tradition
-- for a plane figure: ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, Gaitapda (499), and the
-- ‡ï‡‡‡‡‡‡∞‡µ‡‡Ø‡µ‡‡æ‡∞ chapter of Bhskara II's ‡≤‡‡≤‡æ‡µ‡‡ (1150).  LIMIT: the
-- sources attest the word for a geometric figure/ground; its use here
-- for a QUANTITY ASSIGNED OVER A DOMAIN (the sense physics gives
-- "field") is this corpus's, and no text is claimed for the compound
-- ‡Ø‡ã‡ó‡ï‡‡‡‡‡‡∞.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (installed version), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module YogaKsetra_TheConservingFlowsOfAdditionAreExactlyTheShearFields where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels using (isPropŒ†)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry

module ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç {‚Ñì : Level} (R' : CommRing ‚Ñì) where

  open CommRingStr (R' .snd)

  private
    R : Type ‚Ñì
    R = fst R'

  -- the observable, and a shear whose parameter varies with the point
  ‡§Ø‡•ã‡§ó : R √ó R ‚Üí R
  ‡§Ø‡•ã‡§ó (a , b) = a + b

  ‡§∂‡§ø‡§Ø‡§∞‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ : (R √ó R ‚Üí R) ‚Üí R √ó R ‚Üí R √ó R
  ‡§∂‡§ø‡§Ø‡§∞‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ k (a , b) = (a + k (a , b)) , (b - k (a , b))

  -- the displacement a flow shows in the first coordinate
  ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§Æ‡§æ‡§™‡§É : (R √ó R ‚Üí R √ó R) ‚Üí R √ó R ‚Üí R
  ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§Æ‡§æ‡§™‡§É Œ¶ p = fst (Œ¶ p) - fst p

  -- ring arithmetic, discharged by the solver over the abstract ring ---
  private
    A1 : (a x : R) ‚Üí a + (x - a) ‚â° x
    A1 _ _ = solve! R'
    A2a : (a b x : R) ‚Üí b - (x - a) ‚â° (a + b) - x
    A2a _ _ _ = solve! R'
    A2b : (x y : R) ‚Üí (x + y) - x ‚â° y
    A2b _ _ = solve! R'
    A3 : (a x : R) ‚Üí (a + x) - a ‚â° x
    A3 _ _ = solve! R'
    A4 : (a b k : R) ‚Üí (a + k) + (b - k) ‚â° a + b
    A4 _ _ _ = solve! R'

    -- b ‚àí (x ‚àí a) ‚â° y, given that x + y and a + b agree
    A2 : (x y a b : R) ‚Üí x + y ‚â° a + b ‚Üí b - (x - a) ‚â° y
    A2 x y a b h = A2a a b x ‚àô cong (_- x) (sym h) ‚àô A2b x y

  ------------------------------------------------------------------
  -- ¬ß‡ß ¬ every shear field conserves the sum
  ------------------------------------------------------------------

  ‡§µ‡•ç‡§Ø‡§æ‡§™‡§ï-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£ : (k : R √ó R ‚Üí R) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó (‡§∂‡§ø‡§Ø‡§∞‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ k)
  ‡§µ‡•ç‡§Ø‡§æ‡§™‡§ï-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£ k (a , b) = A4 a b (k (a , b))

  ------------------------------------------------------------------
  -- ¬ß‡® ¬ every conserving flow is the shear field of its displacement
  ------------------------------------------------------------------

  ‡§è‡§ï‡§∞‡•Ç‡§™‡§§‡§æ : (Œ¶ : R √ó R ‚Üí R √ó R) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó Œ¶
          ‚Üí (p : R √ó R) ‚Üí ‡§∂‡§ø‡§Ø‡§∞‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§Æ‡§æ‡§™‡§É Œ¶) p ‚â° Œ¶ p
  ‡§è‡§ï‡§∞‡•Ç‡§™‡§§‡§æ Œ¶ cons p i =
    A1 (fst p) (fst (Œ¶ p)) i ,
    A2 (fst (Œ¶ p)) (snd (Œ¶ p)) (fst p) (snd p) (cons p) i

  ------------------------------------------------------------------
  -- ¬ß‡© ¬ the classification: conserving flows ‚â fields
  ------------------------------------------------------------------

  ‡§∏‡§Æ‡§§‡§æ-Iso : Iso (Œ£[ Œ¶ ‚àà (R √ó R ‚Üí R √ó R) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó Œ¶)
                 (R √ó R ‚Üí R)
  Iso.fun ‡§∏‡§Æ‡§§‡§æ-Iso (Œ¶ , _)      = ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§Æ‡§æ‡§™‡§É Œ¶
  Iso.inv ‡§∏‡§Æ‡§§‡§æ-Iso k            = ‡§∂‡§ø‡§Ø‡§∞‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ k , ‡§µ‡•ç‡§Ø‡§æ‡§™‡§ï-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£ k
  Iso.rightInv ‡§∏‡§Æ‡§§‡§æ-Iso k       = funExt (Œª p ‚Üí A3 (fst p) (k p))
  Iso.leftInv ‡§∏‡§Æ‡§§‡§æ-Iso (Œ¶ , cons) =
    Œ£‚â°Prop (Œª Œ¶' ‚Üí isPropŒ† (Œª p ‚Üí is-set _ _))
           (funExt (‡§è‡§ï‡§∞‡•Ç‡§™‡§§‡§æ Œ¶ cons))

  ‡§∏‡§Æ‡§§‡§æ : (Œ£[ Œ¶ ‚àà (R √ó R ‚Üí R √ó R) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó Œ¶) ‚âÉ (R √ó R ‚Üí R)
  ‡§∏‡§Æ‡§§‡§æ = isoToEquiv ‡§∏‡§Æ‡§§‡§æ-Iso

------------------------------------------------------------------------
-- The ‚ instance, one line: the conserving flows of integer addition
-- are exactly the maps ‚ ó ‚ ‚í ‚.
------------------------------------------------------------------------

module ‚Ñ§‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç = ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç ‚Ñ§CommRing
