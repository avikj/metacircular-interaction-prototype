{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MergingASeparatedPairBreaksAtTheSeparatingContinuation
--
--
--   "Theorem 28.10 (no free compression): merging projectively distinct
--    states admits a separating continuation ‚î the global optimum
--    becomes wrong for some admissible downstream world."
--
-- ¬ß2 is that, with the separating continuation as an INPUT rather than
-- something asserted to exist, and with the failure located: the
-- compressed evaluation cannot agree with the original at that
-- continuation, on both merged states.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- AND THE PART THAT IS NOT A RESTATEMENT
--
-- ¬ß3: WHICH of the two states the compression is wrong about is NOT
-- determined.  What is proved is `¬ (A ó B)` ‚î the two agreement
-- equations cannot both hold ‚î and NOT `¬ A ‚ä ¬ B`, which would name
-- the guilty state.  Getting from one to the other needs a decision,
-- and none is available.  So "the global optimum becomes wrong for some
-- admissible downstream world" is exactly right, and "wrong for THIS
-- state" is not something the argument gives.
--
-- HOW THIS DIFFERS FROM THE STANDING LEMMA, since it is close.
-- `TranscriptDescent.collisionObstructsDecoder` concludes
-- `¬ FactorsThrough q t` ‚î a statement about decoders on the image, with
-- the collision supplied.  ¬ß2 takes the separating continuation as a
-- parameter, ranges over ARBITRARY quotient types and compressions, and
-- returns the failing conjunction at that continuation.  Same family,
-- different shape of conclusion: a located failure rather than a
-- non-existence.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module MergingASeparatedPairBreaksAtTheSeparatingContinuation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- 1.  States, continuations, and what a compression claims
------------------------------------------------------------------------

module _ (State Cont Value : Type) (v : State ‚Üí Cont ‚Üí Value) where

  -- a continuation that tells two states apart
  Separates : Cont ‚Üí State ‚Üí State ‚Üí Type
  Separates c s‚ÇÅ s‚ÇÇ = ¬¨ (v s‚ÇÅ c ‚â° v s‚ÇÇ c)

  -- a compression: a quotient of states and an evaluation on it
  Agrees : {Q : Type} (q : State ‚Üí Q) (v' : Q ‚Üí Cont ‚Üí Value) ‚Üí Type
  Agrees {Q} q v' = (s : State) (c : Cont) ‚Üí v' (q s) c ‚â° v s c

  --------------------------------------------------------------------
  -- 2.  Merging a separated pair cannot agree at the separator
  --------------------------------------------------------------------

  noFreeCompression :
    (s‚ÇÅ s‚ÇÇ : State) (c : Cont) ‚Üí Separates c s‚ÇÅ s‚ÇÇ
    ‚Üí {Q : Type} (q : State ‚Üí Q) ‚Üí q s‚ÇÅ ‚â° q s‚ÇÇ
    ‚Üí (v' : Q ‚Üí Cont ‚Üí Value)
    ‚Üí ¬¨ Agrees q v'
  noFreeCompression s‚ÇÅ s‚ÇÇ c sep q merged v' agrees =
    sep ( sym (agrees s‚ÇÅ c)
        ‚àô cong (Œª x ‚Üí v' x c) merged
        ‚àô agrees s‚ÇÇ c )

  --------------------------------------------------------------------
  -- 3.  But which state it is wrong about is not determined
  --
  -- The failure is located at the continuation `c` and at the PAIR: the
  -- two agreement equations cannot both hold.  Naming which one fails
  -- would be `¬ A ‚ä ¬ B`, and that is not what the argument gives.
  --------------------------------------------------------------------

  bothCannotHoldAtTheSeparator :
    (s‚ÇÅ s‚ÇÇ : State) (c : Cont) ‚Üí Separates c s‚ÇÅ s‚ÇÇ
    ‚Üí {Q : Type} (q : State ‚Üí Q) ‚Üí q s‚ÇÅ ‚â° q s‚ÇÇ
    ‚Üí (v' : Q ‚Üí Cont ‚Üí Value)
    ‚Üí ¬¨ ((v' (q s‚ÇÅ) c ‚â° v s‚ÇÅ c) √ó (v' (q s‚ÇÇ) c ‚â° v s‚ÇÇ c))
  bothCannotHoldAtTheSeparator s‚ÇÅ s‚ÇÇ c sep q merged v' (a‚ÇÅ , a‚ÇÇ) =
    sep (sym a‚ÇÅ ‚àô cong (Œª x ‚Üí v' x c) merged ‚àô a‚ÇÇ)

------------------------------------------------------------------------
-- 4.  The reading
--
-- ¬ß2 is "no free compression" with the separating continuation handed
-- in: whatever quotient type and whatever compressed evaluation, if the
-- quotient identifies a pair some continuation separates, the
-- compression is not faithful.
--
-- ¬ß3 is the honest form of "for SOME admissible downstream world".  The
-- statement is about the pair at that continuation; it does not, and
-- constructively cannot without a decision, say which of the two merged
-- states the compressed model now gets wrong.
------------------------------------------------------------------------
