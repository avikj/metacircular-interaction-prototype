{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Ø‡ã‡ó‡ß‡‡∞‡‡µ ‚î the first Noether charge of arithmetic.
--
-- `Dhruva_‚¶.agda` proves the frame: an observable `f` and a flow `Œ¶`
-- with ‡‡‡∞‡ï‡‡‡‡Æ‡ (f ‚àò Œ¶ ‚â° f pointwise) give a flow INSIDE every fibre
-- (‡ß‡‡∞‡‡µ-‡‡®‡‡‡), and the conserved quantity is the fibre index.  That
-- file is deliberately abstract.  This file is its canonical instance,
-- the smallest one arithmetic offers:
--
--     f  =  ‡Ø‡ã‡ó : ‚ ó ‚ ‚í ‚,   ‡Ø‡ã‡ó (a , b) = a + b
--     Œ¶‚ñ =  ‡‡ø‡Ø‡∞ k : (a , b) ‚¶ (a + k , b ‚àí k)
--
-- THE CONSERVED QUANTITY IS THE FIBRE INDEX ‚î the sum n.  The shears
-- are the invisible motion: they move every pair, and ‡Ø‡ã‡ó cannot see
-- them.  What is proved:
--
--   ¬ß‡ß  ‡‡‡∞‡ï‡‡‡ : every shear satisfies Dhruva's ‡‡‡∞‡ï‡‡‡‡Æ‡ for ‡Ø‡ã‡ó
--       ((a + k) + (b ‚àí k) ‚â° a + b, by ring arithmetic via solve!).
--   ¬ß‡®  ‡‡‡∞‡µ‡æ‡ : the induced action on fiber ‡Ø‡ã‡ó n, obtained through
--       Dhruva's ‡ß‡‡∞‡‡µ-‡‡®‡‡‡ ‚î imported, not restated.
--   ¬ß‡©  action laws: ‡‡‡∞‡µ‡æ‡ 0 is the identity and shears compose
--       (‡‡‡∞‡µ‡æ‡ k ‚àò ‡‡‡∞‡µ‡æ‡ k' ‚â° ‡‡‡∞‡µ‡æ‡ (k' + k)) ‚î so ‚ genuinely acts.
--   ¬ß‡  ‡Æ‡‡ï‡‡‡‡æ (freeness): ‡‡‡∞‡µ‡æ‡ k x ‚â° x forces k ‚â° 0, by projecting
--       to the first coordinate and cancelling.
--   ¬ß‡  ‡‡‡ï‡‡∞‡æ‡Æ‡ø‡‡æ (transitivity): any two points of fiber ‡Ø‡ã‡ó n are
--       joined by a shear ‚î k = a' ‚àí a works, because both pairs sum
--       to the same n.
--   ¬ß‡  ‡‡ï‡‡ø‡Ø‡∞‡‡æ (uniqueness): the joining shear is unique.
--
-- ¬ß‡©‚ì¬ß‡ together say: **fiber ‡Ø‡ã‡ó n is a ‚-torsor.**  The fibre has no
-- preferred origin ‚î knowing the sum n tells you the orbit exactly and
-- the point not at all.  That is the charge/gauge split at its
-- smallest: n is the charge, the shear is the gauge motion.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- TERM.  ‡Ø‡ã‡ó ‚î addition, the standard arithmetical term (‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡
-- and the siddhntas throughout); ‡ß‡‡∞‡‡µ as in Dhruva's header.  The
-- compound is this corpus's; no  source states any theorem
-- below.
------------------------------------------------------------------------

module YogaDhruva_TheFibreOfAdditionIsATorsorAndEveryConservingFlowIsATranslation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry

open CommRingStr (‚Ñ§CommRing .snd)

private
  R : Type
  R = fst ‚Ñ§CommRing

-- the observable and the flow ----------------------------------------

‡§Ø‡•ã‡§ó : R √ó R ‚Üí R
‡§Ø‡•ã‡§ó (a , b) = a + b

‡§∂‡§ø‡§Ø‡§∞ : R ‚Üí R √ó R ‚Üí R √ó R
‡§∂‡§ø‡§Ø‡§∞ k (a , b) = (a + k) , (b - k)

-- ring arithmetic, discharged by the solver --------------------------

private
  L1 : (a b k : R) ‚Üí (a + k) + (b - k) ‚â° a + b
  L1 _ _ _ = solve! ‚Ñ§CommRing
  L2 : (a k : R) ‚Üí k ‚â° (a + k) - a
  L2 _ _ = solve! ‚Ñ§CommRing
  L3 : (a : R) ‚Üí a - a ‚â° 0r
  L3 _ = solve! ‚Ñ§CommRing
  L4 : (a a' : R) ‚Üí a + (a' - a) ‚â° a'
  L4 _ _ = solve! ‚Ñ§CommRing
  L5 : (a b a' : R) ‚Üí b - (a' - a) ‚â° (a + b) - a'
  L5 _ _ _ = solve! ‚Ñ§CommRing
  L6 : (a' b' : R) ‚Üí (a' + b') - a' ‚â° b'
  L6 _ _ = solve! ‚Ñ§CommRing
  L7 : (a k k' : R) ‚Üí (a + k') + k ‚â° a + (k' + k)
  L7 _ _ _ = solve! ‚Ñ§CommRing
  L8 : (b k k' : R) ‚Üí (b - k') - k ‚â° b - (k' + k)
  L8 _ _ _ = solve! ‚Ñ§CommRing
  L9 : (a : R) ‚Üí a + 0r ‚â° a
  L9 _ = solve! ‚Ñ§CommRing
  L10 : (b : R) ‚Üí b - 0r ‚â° b
  L10 _ = solve! ‚Ñ§CommRing

-- ¬ß‡ß ¬ every shear conserves the sum ---------------------------------

‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£ : (k : R) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó (‡§∂‡§ø‡§Ø‡§∞ k)
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£ k (a , b) = L1 a b k

-- ¬ß‡® ¬ the induced action inside the fibre, through Dhruva -----------

‡§™‡•ç‡§∞‡§µ‡§æ‡§π : (k n : R) ‚Üí fiber ‡§Ø‡•ã‡§ó n ‚Üí fiber ‡§Ø‡•ã‡§ó n
‡§™‡•ç‡§∞‡§µ‡§æ‡§π k = ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§§‡§®‡•ç‡§§‡•å ‡§Ø‡•ã‡§ó (‡§∂‡§ø‡§Ø‡§∞ k) (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£ k)

-- paths in the fibre are paths of pairs: the equation is a prop ------

private
  fib‚â° : {n : R} {x y : fiber ‡§Ø‡•ã‡§ó n} ‚Üí fst x ‚â° fst y ‚Üí x ‚â° y
  fib‚â° {n = n} = Œ£‚â°Prop (Œª ab ‚Üí is-set (‡§Ø‡•ã‡§ó ab) n)

-- ¬ß‡© ¬ the action laws: ‚ acts on the fibre --------------------------

‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø : (n : R) (x : fiber ‡§Ø‡•ã‡§ó n) ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π 0r n x ‚â° x
‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø n ((a , b) , _) = fib‚â° (Œª i ‚Üí L9 a i , L10 b i)

‡§∏‡§Ç‡§Ø‡•ã‡§ó : (k k' n : R) (x : fiber ‡§Ø‡•ã‡§ó n)
      ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π k n (‡§™‡•ç‡§∞‡§µ‡§æ‡§π k' n x) ‚â° ‡§™‡•ç‡§∞‡§µ‡§æ‡§π (k' + k) n x
‡§∏‡§Ç‡§Ø‡•ã‡§ó k k' n ((a , b) , _) = fib‚â° (Œª i ‚Üí L7 a k k' i , L8 b k k' i)

-- ¬ß‡ ¬ freeness: a shear fixing any fibre point is the zero shear ----

‡§Æ‡•Å‡§ï‡•ç‡§§‡§§‡§æ : (k n : R) (x : fiber ‡§Ø‡•ã‡§ó n) ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π k n x ‚â° x ‚Üí k ‚â° 0r
‡§Æ‡•Å‡§ï‡•ç‡§§‡§§‡§æ k n ((a , b) , _) h =
  L2 a k ‚àô cong (_- a) (cong (Œª w ‚Üí fst (fst w)) h) ‚àô L3 a

-- ¬ß‡ ¬ transitivity: any two fibre points differ by a shear ----------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§Æ‡§ø‡§§‡§æ : (n : R) (x y : fiber ‡§Ø‡•ã‡§ó n) ‚Üí Œ£[ k ‚àà R ] ‡§™‡•ç‡§∞‡§µ‡§æ‡§π k n x ‚â° y
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§Æ‡§ø‡§§‡§æ n ((a , b) , p) ((a' , b') , q) =
  (a' - a) , fib‚â° (Œª i ‚Üí L4 a a' i , sndPath i)
  where
    sndPath : b - (a' - a) ‚â° b'
    sndPath = L5 a b a' ‚àô cong (_- a') (p ‚àô sym q) ‚àô L6 a' b'

-- ¬ß‡ ¬ and by only one: the joining shear is unique ------------------

‡§è‡§ï‡§∂‡§ø‡§Ø‡§∞‡§§‡§æ : (k k' n : R) (x y : fiber ‡§Ø‡•ã‡§ó n)
         ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π k n x ‚â° y ‚Üí ‡§™‡•ç‡§∞‡§µ‡§æ‡§π k' n x ‚â° y ‚Üí k ‚â° k'
‡§è‡§ï‡§∂‡§ø‡§Ø‡§∞‡§§‡§æ k k' n ((a , b) , _) _ h h' =
  L2 a k
  ‚àô cong (_- a) (cong (Œª w ‚Üí fst (fst w)) h ‚àô sym (cong (Œª w ‚Üí fst (fst w)) h'))
  ‚àô sym (L2 a k')
