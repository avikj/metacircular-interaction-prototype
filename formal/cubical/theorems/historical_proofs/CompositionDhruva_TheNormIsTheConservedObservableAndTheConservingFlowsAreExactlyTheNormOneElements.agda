{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡æ‡µ‡®‡æ‡ß‡‡∞‡‡µ ‚î ‡‡æ‡µ‡®‡æ is the flow, the norm is the ‡ß‡‡∞‡‡µ.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- SOURCE, FIRST AND EARLIEST ESTABLISHABLE.
--
--   ‡‡æ‡µ‡®‡æ (bhvan, "production", "composition") ‚î Brahmagupta,
--   ‡‡‡∞‡æ‡‡‡Æ‡‡‡‡‡ü‡‡ø‡¶‡‡ß‡æ‡®‡‡ (Brhmasphuasiddhnta), 628 CE, chapter 18
--   (‡ï‡‡ü‡‡ü‡ï‡æ‡ß‡‡Ø‡æ‡Ø).  Brahmagupta states the composition of two
--   solutions of the ‡µ‡∞‡‡ó‡‡‡∞‡ï‡‡‡ø x¬≤ ‚àí D y¬≤ = k, in both the ‡‡Æ‡æ‡
--   ("sum") and ‡‡®‡‡‡∞ ("difference") forms.  The algebra itself is
--   checked in this repository in `Bhavana.agda` (`bhavana`,
--   `bhavanaMinus`), over an arbitrary commutative ring, and is
--   imported here rather than restated.
--
--   ‡ß‡‡∞‡‡µ (dhruva) ‚î fixed, immovable; and in the astronomical
--   tradition ‡ß‡‡∞‡‡µ‡∞‡æ‡‡ø / ‡ß‡‡∞‡‡µ‡ï is the technical term for the CONSTANT
--   quantity in a computation, the term that does not vary while the
--   others are stepped: ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, 499 CE, and standard in
--   the siddhntas after.  The conservation predicate `‡‡‡∞‡ï‡‡‡‡Æ‡` used
--   below is `Dhruva_‚¶agda`'s, imported.
--
--   The cyclic method that consumes the bhvan is the ‡‡ï‡‡∞‡µ‡æ‡≤ ‚î
--   Jayadeva (~950 CE, preserved by Udayadivkara) and Bhskara II,
--   ‡‡‡‡ó‡‡ø‡, 1150 CE.  Every later European name for x¬≤ ‚àí D y¬≤ = 1 is a
--   restatement six centuries downstream and is not used here.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS CHECKED.  Over an arbitrary commutative ring R and a fixed
-- D : R, with the pair set R ó R, the observable
--
--     ‡®‡ø‡Ø‡Æ (a , b)  =  N D a b  =  a¬≤ ‚àí D b¬≤
--
-- and, for a fixed u = (u‚ , u‚), the flow
--
--     ‡‡‡∞‡µ‡æ‡ u  =  compose-with-u, by Brahmagupta's ‡‡Æ‡æ‡‡‡æ‡µ‡®‡æ.
--
-- ¬ß‡ß  ‡‡‡∞‡ï‡‡‡‡Æ‡-‡Ø‡¶‡ø : N D u‚ u‚ ‚â° 1  ‚í  ‡‡‡∞‡ï‡‡‡‡Æ‡ ‡®‡ø‡Ø‡Æ (‡‡‡∞‡µ‡æ‡ u).
--     The norm is conserved by composition with a norm-one element.
--     `‡‡‡∞‡ï‡‡‡‡Æ‡` is Dhruva's predicate verbatim; this is an INSTANCE of
--     that abstract frame, not a new one.
--
-- ¬ß‡®  ‡‡‡∞‡ï‡‡‡‡Æ‡-‡ï‡‡µ‡≤‡Æ‡-‡Ø‡¶‡ø : ‡‡‡∞‡ï‡‡‡‡Æ‡ ‡®‡ø‡Ø‡Æ (‡‡‡∞‡µ‡æ‡ u) ‚í N D u‚ u‚ ‚â° 1.
--     The converse, by evaluating conservation at the unit pair (1,0).
--     Together ¬ß‡ß+¬ß‡®: **for a bhvan flow, conservation of the norm is
--     EQUIVALENT to the flowing element having norm one.**
--
-- ¬ß‡©  ‡‡ï‡‡‡µ-‡‡‡µ‡‡‡ø : the norm-one elements are closed under bhvan,
--     and (1,0) is one of them ‚î so the conserving flows are closed
--     under composition and contain the identity.
--
-- ¬ß‡  ‡‡®‡‡‡-‡ó‡‡ø : the fibre action, obtained by feeding ¬ß‡ß to Dhruva's
--     `‡ß‡‡∞‡‡µ-‡‡®‡‡‡`.  A norm-one element carries the solution set of
--     x¬≤ ‚àí D y¬≤ = k into itself, for every k at once.  This is the one
--     line of the ‡‡ï‡‡∞‡µ‡æ‡≤ that is pure conservation.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- Brahmagupta
-- states the composition identity; the reading of it as a conserved
-- observable with a flow, and the biconditional ¬ß‡®, are this
-- corpus's, and the compound ‡‡æ‡µ‡®‡æ‡ß‡‡∞‡‡µ is built here.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO SOLVER.  Every step is a hand chain over the CommRing structure,
-- for the reason `Bhavana.agda` gives: `solve!` is a v0.9 spelling and
-- this container carries an older cubical, where "Not in scope: solve!"
-- is container skew and not a mathematical verdict.
------------------------------------------------------------------------

module BhavanaDhruva_TheNormIsTheConservedObservableAndTheConservingFlowsAreExactlyTheNormOneElements where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.Ring.Properties using (module RingTheory)

open import Bhavana
open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry

private variable ‚Ñì : Level

module Samrakshana (CR : CommRing ‚Ñì) (D : fst CR) where

  open CommRingStr (snd CR)
  open RingTheory (CommRing‚ÜíRing CR)
  open Form CR

  ‡§Ø‡•Å‡§ó‡•ç‡§Æ : Type ‚Ñì
  ‡§Ø‡•Å‡§ó‡•ç‡§Æ = R √ó R

  -- the observable: Brahmagupta's norm of the pair.
  ‡§®‡§ø‡§Ø‡§Æ : ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‚Üí R
  ‡§®‡§ø‡§Ø‡§Æ (a , b) = N D a b

  -- the flow: ‡‡Æ‡æ‡‡‡æ‡µ‡®‡æ with a fixed element on the right.
  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π : ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‚Üí ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‚Üí ‡§Ø‡•Å‡§ó‡•ç‡§Æ
  ‡§™‡•ç‡§∞‡§µ‡§æ‡§π (u‚ÇÅ , u‚ÇÇ) (a , b) = bhA D a b u‚ÇÅ u‚ÇÇ , bhB D a b u‚ÇÅ u‚ÇÇ

  -- the unit pair has norm one:  1¬1 ‚àí D¬(0¬0) = 1.
  ‡§®‡§ø‡§Ø‡§Æ-‡§è‡§ï‡§Æ‡•ç : N D 1r 0r ‚â° 1r
  ‡§®‡§ø‡§Ø‡§Æ-‡§è‡§ï‡§Æ‡•ç =
      cong‚ÇÇ _-_ (¬∑IdR 1r) (cong (D ¬∑_) (0RightAnnihilates 0r) ‚àô 0RightAnnihilates D)
    ‚àô cong (1r +_) 0Selfinverse
    ‚àô +IdR 1r

  ----------------------------------------------------------------------
  -- ‡ß ¬ A norm-one element conserves the norm.
  --
  -- This is `Bhavana.bhavana` read backwards: the norm of the composite
  -- is the product of the norms, so composing with a 1 leaves it alone.
  ----------------------------------------------------------------------

  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§Ø‡§¶‡§ø : (u : ‡§Ø‡•Å‡§ó‡•ç‡§Æ) ‚Üí ‡§®‡§ø‡§Ø‡§Æ u ‚â° 1r
                ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§®‡§ø‡§Ø‡§Æ (‡§™‡•ç‡§∞‡§µ‡§æ‡§π u)
  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§Ø‡§¶‡§ø (u‚ÇÅ , u‚ÇÇ) nu (a , b) =
      sym (bhavana D a b u‚ÇÅ u‚ÇÇ)
    ‚àô cong (N D a b ¬∑_) nu
    ‚àô ¬∑IdR (N D a b)

  ----------------------------------------------------------------------
  -- ‡® ¬ ‚¶and only a norm-one element does.
  --
  -- Evaluate conservation at the unit pair.  ‡‡‡∞‡µ‡æ‡ u (1,0) is u itself
  -- on the nose up to the two identity lemmas, and ‡®‡ø‡Ø‡Æ (1,0) is 1.
  ----------------------------------------------------------------------

  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§ï‡•á‡§µ‡§≤‡§Æ‡•ç-‡§Ø‡§¶‡§ø : (u : ‡§Ø‡•Å‡§ó‡•ç‡§Æ) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§®‡§ø‡§Ø‡§Æ (‡§™‡•ç‡§∞‡§µ‡§æ‡§π u)
                       ‚Üí ‡§®‡§ø‡§Ø‡§Æ u ‚â° 1r
  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§ï‡•á‡§µ‡§≤‡§Æ‡•ç-‡§Ø‡§¶‡§ø (u‚ÇÅ , u‚ÇÇ) cons =
      cong‚ÇÇ (N D) (sym (bhA-idL D u‚ÇÅ u‚ÇÇ)) (sym (bhB-idL D u‚ÇÅ u‚ÇÇ))
    ‚àô cons (1r , 0r)
    ‚àô ‡§®‡§ø‡§Ø‡§Æ-‡§è‡§ï‡§Æ‡•ç

  ----------------------------------------------------------------------
  -- ‡© ¬ The conserving elements are closed under bhvan.
  --
  -- So the conserving flows compose; with (1,0) conserving, they are a
  -- submonoid of the bhvan monoid.
  ----------------------------------------------------------------------

  ‡§è‡§ï‡§§‡•ç‡§µ-‡§∏‡§Ç‡§µ‡•É‡§§‡§ø : (u v : ‡§Ø‡•Å‡§ó‡•ç‡§Æ) ‚Üí ‡§®‡§ø‡§Ø‡§Æ u ‚â° 1r ‚Üí ‡§®‡§ø‡§Ø‡§Æ v ‚â° 1r
               ‚Üí ‡§®‡§ø‡§Ø‡§Æ (‡§™‡•ç‡§∞‡§µ‡§æ‡§π v u) ‚â° 1r
  ‡§è‡§ï‡§§‡•ç‡§µ-‡§∏‡§Ç‡§µ‡•É‡§§‡§ø (u‚ÇÅ , u‚ÇÇ) (v‚ÇÅ , v‚ÇÇ) nu nv =
      sym (bhavana D u‚ÇÅ u‚ÇÇ v‚ÇÅ v‚ÇÇ)
    ‚àô cong‚ÇÇ _¬∑_ nu nv
    ‚àô ¬∑IdR 1r

  ‡§è‡§ï‡§§‡•ç‡§µ-‡§Ü‡§¶‡§ø : ‡§®‡§ø‡§Ø‡§Æ (1r , 0r) ‚â° 1r
  ‡§è‡§ï‡§§‡•ç‡§µ-‡§Ü‡§¶‡§ø = ‡§®‡§ø‡§Ø‡§Æ-‡§è‡§ï‡§Æ‡•ç

  ----------------------------------------------------------------------
  -- ‡ ¬ The fibre action, straight out of Dhruva.
  --
  -- `fiber ‡®‡ø‡Ø‡Æ k` is the solution set of x¬≤ ‚àí D y¬≤ = k.  A norm-one
  -- element carries it into itself ‚î every k at once, one term.
  -- Nothing new is proved here: this is ¬ß‡ß handed to ‡ß‡‡∞‡‡µ-‡‡®‡‡‡, and
  -- that is exactly the claim, that the abstract frame already had it.
  ----------------------------------------------------------------------

  ‡§§‡§®‡•ç‡§§‡•Å-‡§ó‡§§‡§ø : (u : ‡§Ø‡•Å‡§ó‡•ç‡§Æ) ‚Üí ‡§®‡§ø‡§Ø‡§Æ u ‚â° 1r
            ‚Üí (k : R) ‚Üí fiber ‡§®‡§ø‡§Ø‡§Æ k ‚Üí fiber ‡§®‡§ø‡§Ø‡§Æ k
  ‡§§‡§®‡•ç‡§§‡•Å-‡§ó‡§§‡§ø u nu = ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§§‡§®‡•ç‡§§‡•å ‡§®‡§ø‡§Ø‡§Æ (‡§™‡•ç‡§∞‡§µ‡§æ‡§π u) (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç-‡§Ø‡§¶‡§ø u nu)
