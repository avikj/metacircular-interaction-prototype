{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Ø‡‡ó‡‡Æ-‡‡‡∞‡‡Æ‡ ‚î ‡µ‡≤‡‡≤‡ ‡‡‡µ‡¶‡à‡∞‡‡ò‡‡Ø‡ ‡¶‡‡µ‡æ‡‡‡Ø‡æ‡ ‡‡æ‡ó‡ ‡‡‡Æ‡∞‡‡ø, ‡® ‡‡‡ ‡‡∞‡Æ‡ ‡
--
-- (the even padding: the vall recovers its length modulo two, and no
--  further.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  This corpus holds THREE no-decoder theorems, in two
-- lanes and two languages, proved by three unrelated arguments ‚î and all
-- three are sharp at exactly ‚/2.  None of them says so, and none cites
-- another.  A uniform random draw found the coincidence; this module is
-- the one line that explains it.
--
--   `KuttakaValli.detReplay`     (Agda)  det (replay v) ‚â° sgn v, where
--       sgn = (‚àí1)^length.  A PARTIAL DECODER: the endpoint matrix does
--       recover the vall's length mod 2, because every step matrix
--       L q = (q 1 / 1 0) has determinant ‚àí1.
--
--   `Pairfield/DiagonalSmithRoute.lean.no_historical_actionCost_decoder`
--       refutes a length decoder with [0,1,1,2] against [0,0,0,1,1,2] ‚î
--       a padding of **+2**.  `IntMat2.euclidStep q = ‚ü®0,1,1,‚àíq‚ü©` is the
--       same matrix family, determinant ‚àí1, always.
--
--   `Pairfield/EuclidCoefficientTrace.lean.no_value_cost_decoder`
--       uses [inc] against [inc,inc,dec] ‚î **+2** again, by a completely
--       different argument, where value = #inc ‚àí #dec and cost = #inc +
--       #dec, so cost ‚â° value (mod 2) identically.
--
-- THE PADDING HAD TO BE EVEN, and ¬ß2 is the proof.  An odd padding is
-- IMPOSSIBLE as a counterexample: the determinant would separate the two
-- words.  So those theorems are not merely true, they are TIGHT, and the
-- quotient at which they are tight is the parity quotient.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- READ AGAINST THE CRITERION.  For `replay : Valli ‚í M`, the question is
-- which side of `f a ‚â° b` is bound.  Bind the vall and the matrix rides
-- free (that is `replay` being a function).  Bind the MATRIX and you have
-- the preimage ‚î and this module computes exactly how much of it the
-- matrix sees: the parity, and nothing else.
--
-- So the three verdicts of `Tantujala_TheFibreHasThreeVerdictsAndIsContr-
-- MergesTwoOfThem.agda` are not the whole story at a lossy map.  A fibre
-- with MANY points still admits an exact statement of WHAT IS RECOVERED,
-- and here it is a quotient group.  ‡®‡‡‡ü‡ø is not "everything is lost":
-- ¬ß‡ of ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡ says ‡Ø‡‡ ‡‡ø‡‡‡†‡‡ø, ‡ï‡ ‡®‡‡‡Ø‡‡ø ‚î the THAT
-- survives and the WHICH is destroyed.  This module names the surviving
-- THAT precisely: it is ‚/2, and no more.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module YugmaPurana_TheValliRecoversItsLengthModuloTwoAndNoFurther where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; length)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver using (solve!)

open import Gamma0Partner using (R ; M)
open import M2Unimodular using (det)
open import KuttakaValli using (Valli ; L ; replay ; sgn ; detReplay)

open CommRingStr (‚Ñ§CommRing .snd)

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡ø‡‡‡®‡ ‡¶‡à‡∞‡‡ò‡‡Ø‡Æ‡ ‡‡µ ‡‡‡‡Ø‡‡ø ‚î the sign sees only the length.
--
-- `sgn` recurses on the list and never inspects a quotient, so two valls
-- of equal length have equal sign.  Written as an induction on both, so
-- the statement is about the LENGTHS and not about the lists.
------------------------------------------------------------------------

‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç : (v w : Valli) ‚Üí length v ‚â° length w ‚Üí sgn v ‚â° sgn w
‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç [] [] _ = refl
‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç (q ‚à∑ v) (r ‚à∑ w) p =
  cong ((- 1r) ¬∑_) (‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç v w (cong pred' p))
  where
  pred' : ‚Ñï ‚Üí ‚Ñï
  pred' zero    = zero
  pred' (suc n) = n
‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç [] (r ‚à∑ w) p = ‚ä•-elim (znots' p)
  where
  open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-elim)
  open import Cubical.Data.Nat using (znots)
  znots' : zero ‚â° suc (length w) ‚Üí _
  znots' = znots
‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç (q ‚à∑ v) [] p = ‚ä•-elim (snotz' p)
  where
  open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-elim)
  open import Cubical.Data.Nat using (snotz)
  snotz' : suc (length v) ‚â° zero ‚Üí _
  snotz' = snotz

------------------------------------------------------------------------
-- ‡® ¬ ‡Ø‡‡ó‡‡Æ-‡‡‡∞‡‡Æ‡ ‡‡¶‡‡‡‡Ø‡Æ‡ ‚î AN EVEN PADDING IS INVISIBLE.
--
-- Two steps prepended leave the determinant exactly where it was, because
-- (‚àí1)¬(‚àí1) = 1.  This is the whole reason the two Lean counterexamples
-- both pad by +2 and could not have padded by +1: the padding must be
-- invisible to the determinant, and only even paddings are.
------------------------------------------------------------------------

‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç : (q r : R) (v : Valli) ‚Üí sgn (q ‚à∑ r ‚à∑ v) ‚â° sgn v
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç q r v = ‡§¶‡•ç‡§µ‡§ø‡§ã‡§£ (sgn v)
  where
  ‡§¶‡•ç‡§µ‡§ø‡§ã‡§£ : (x : R) ‚Üí (- 1r) ¬∑ ((- 1r) ¬∑ x) ‚â° x
  ‡§¶‡•ç‡§µ‡§ø‡§ã‡§£ x = solve! ‚Ñ§CommRing

-- the same, read at the determinant, which is where a decoder would look
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§ï‡•á : (q r : R) (v : Valli)
                      ‚Üí det (replay (q ‚à∑ r ‚à∑ v)) ‚â° det (replay v)
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§ï‡•á q r v =
  detReplay (q ‚à∑ r ‚à∑ v) ‚àô ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç q r v ‚àô sym (detReplay v)

------------------------------------------------------------------------
-- ‡© ¬ ‡µ‡ø‡‡Æ-‡‡‡∞‡‡Æ‡ ‡¶‡‡‡‡Ø‡Æ‡ ‚î AN ODD PADDING IS VISIBLE.
--
-- One step prepended NEGATES the determinant.  So parity is not merely
-- preserved by the even paddings ‚î it is genuinely READ by the
-- determinant, and a would-be counterexample of odd length difference is
-- separated on the spot.
------------------------------------------------------------------------

‡§µ‡§ø‡§∑‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç : (q : R) (v : Valli) ‚Üí sgn (q ‚à∑ v) ‚â° (- 1r) ¬∑ sgn v
‡§µ‡§ø‡§∑‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç q v = refl

‡§µ‡§ø‡§∑‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§ï‡•á : (q : R) (v : Valli)
                      ‚Üí det (replay (q ‚à∑ v)) ‚â° (- 1r) ¬∑ det (replay v)
‡§µ‡§ø‡§∑‡§Æ-‡§™‡•Ç‡§∞‡§£‡§Æ‡•ç-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§ï‡•á q v =
  detReplay (q ‚à∑ v) ‚àô cong ((- 1r) ¬∑_) (sym (detReplay v))

------------------------------------------------------------------------
-- ‡ ¬ ‡Ø‡‡ ‡‡ø‡‡‡†‡‡ø ‚î WHAT SURVIVES, EXACTLY.
--
-- Put ¬ß1 and ¬ß2 together.  The determinant of a replay is a function of
-- the vall's length alone (¬ß1), and it is blind to every even change in
-- that length (¬ß2) while separating every odd one (¬ß3).  So what a replay
-- retains of its trace is precisely the length modulo two.
--
-- This is the sharpening the three no-decoder theorems were missing.  They
-- prove a decoder does not exist; this says the obstruction is exactly the
-- parity quotient and not one bit more, and it says WHY their witnesses
-- have the shape they have.
------------------------------------------------------------------------

‡§Ø‡§§‡•ç-‡§§‡§ø‡§∑‡•ç‡§†‡§§‡§ø : (v w : Valli) ‚Üí length v ‚â° length w
            ‚Üí det (replay v) ‚â° det (replay w)
‡§Ø‡§§‡•ç-‡§§‡§ø‡§∑‡•ç‡§†‡§§‡§ø v w p = detReplay v ‚àô ‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç v w p ‚àô sym (detReplay w)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what this does NOT say.
--
-- It does not say the fibre of `replay` is the set of valls of a given
-- parity: `replay` forgets far more than length, and two valls of one
-- parity generally have different matrices.  The claim is only about what
-- the DETERMINANT sees, which is the coordinate all three no-decoder
-- theorems' witnesses were built to defeat.
--
-- It does not compute the fibre of `replay` itself.  That fibre is the
-- subject rather than a defect ‚î `Gamma0Freeness` is where it lives ‚î and
-- computing it would be a different module.
--
-- And it does not transfer to the Lean lane as a term.  The two
-- `IntMat2`/`euclidStep` results are stated there over a different matrix
-- type in a system without univalence, so the identification is grade
-- three: a real channel, to be constructed rather than asserted.  Stated
-- here as owed, not as done.
--
-- [2026-08-22 ‚î PAID, and paid the only way a grade-three channel can be.]
-- `formal/lean/Pairfield/YugmaPurana_TheEvenPaddingIsForcedAndThe-
-- DeterminantSaysWhy.lean` proves ¬ß‡®‚ì¬ß‡ again over `IntMat2`, natively, and
-- states the tightness at the two Lean sites:
--   ¬ `DiagonalEuclidTranscript.det_leftWord`  ‚î det of an n-letter Euclidean
--     word is (‚àí1)^n, the counterpart of `KuttakaValli.detReplay`;
--   ¬ `leftWord_cons_ne`                       ‚î ¬ß‡© here, an odd padding is
--     visible;
--   ¬ `endpoints_force_even_actionCost_gap`    ‚î every witness refuting
--     `no_historical_actionCost_decoder` has an even gap;
--   ¬ `CoefficientWitness.value_forces_cost_parity` ‚î the same for
--     `no_value_cost_decoder`, whose proof mentions no matrix at all.
-- NOTHING WAS TRANSPORTED.  No term crosses the lane boundary, the two
-- matrix families are not even equal (`L q = (q 1 / 1 0)` against
-- `euclidStep q = (0 1 / 1 ‚àíq)`); both lie in {M : det M = ‚àí1} and the
-- argument needs nothing else of either.  The channel is two independent
-- proofs that agree, which is what construction means here.
------------------------------------------------------------------------
