{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheImpossibilityNeedsNeitherHPropNorEveryRepresentative
--
-- ON THE NAME.  Set-quotients and transport along `eq/` are Voevodsky's
-- substrate, which this repository declares as a tool and not a frame;
-- the threshold predicates are this corpus's own.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE AUDIT.  Target: `TheRateQuotientExistsAndMinimalityCannotLiveOnIt`.
-- Two claim-words.
--
-- **`EXISTS` IS EARNED OUTRIGHT** ‚î `Rate = (‚ï ó ‚ï) / _‚âà_` is
-- constructed, and `atLeastOnRateComputes` shows the lift is not a
-- relabelling.
--
-- **`CANNOT` IS EARNED AND IS ALREADY NON-VACUOUS**, which diagnostic
-- (3) asks first.  It is a LOCATION claim ‚î minimality cannot live ON
-- the quotient ‚î and the constrained thing exists downstairs:
-- `shortIsMinimalAtOneHalf` and `shortIsNotMinimalAtTwoQuarters` are
-- both in hand.  Unlike `CurvatureCannotLive‚¶` (cc8a3e16), this one
-- needed no witness supplied from outside.
--
-- **THE FAULT IS THAT THE IMPOSSIBILITY IS STATED FOR A NARROWER CLASS
-- OF WOULD-BE DEFINITIONS THAN IT NEEDS, AND THE MODULE NAMES THAT
-- NARROWNESS AS A LIMIT INSTEAD OF REMOVING IT.**  It says:
--
--   "The impossibility theorem is about functions into `hProp`; a
--    would-be `Minimal` landing in an arbitrary `Type` is not covered,
--    and could not be lifted by `rec` anyway."
--
-- The first clause is a real gap and the second is a red herring that
-- makes the gap look necessary.  **`SQ.rec` needing a set target
-- constrains how such an `M` could be BUILT; the impossibility theorem
-- quantifies over every `M` and does not care how it was built.**  And
-- the proof never touches the h-level: it is `cong` along `eq/`, and
-- `‚ü®_‚ü©` appears only to extract a carrier that need not have been
-- wrapped.
--
-- **AND THE HYPOTHESIS IS STRONGER THAN NEEDED IN A SECOND WAY.**  The
-- audited statement assumes agreement at EVERY representative and EVERY
-- population.  The proof uses two representatives and one population.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   twoRepresentativesSuffice
--       the sharp form: any `M : Rate ‚í List Bool ‚í Type` agreeing with
--       `Minimal` at `oneHalf` and at `twoQuarters`, on the single
--       population `short`, is contradictory.  No h-level, no
--       universally quantified agreement.
--   noMinimalityAtAnyTarget
--       hence the `Type`-valued impossibility the audited module says
--       is not covered
--   theHPropVersionIsAnInstance
--       and its own theorem, recovered by composing with `‚ü®_‚ü©` ‚î so
--       nothing there is lost and the narrower statement is visibly a
--       special case
------------------------------------------------------------------------

module TheImpossibilityNeedsNeitherHPropNorEveryRepresentative where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (‚ü®_‚ü©)
open import Cubical.Foundations.HLevels using (hProp)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)

open import WhichThresholdStatementsDescendToTheRate
  using (_‚âà_ ; Minimal ; oneHalf ; twoQuarters ; oneHalfIsTwoQuarters
        ; shortIsMinimalAtOneHalf ; shortIsNotMinimalAtTwoQuarters)
open import MinimalityOfABoundaryPopulationNeedsLowestTerms
  using (short)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)

------------------------------------------------------------------------
-- 1.  The sharp form: two representatives, one population, any target
------------------------------------------------------------------------

twoRepresentativesSuffice :
  (M : Rate ‚Üí List Bool ‚Üí Type)
  ‚Üí M [ oneHalf ]     short ‚â° Minimal oneHalf     short
  ‚Üí M [ twoQuarters ] short ‚â° Minimal twoQuarters short
  ‚Üí ‚ä•
twoRepresentativesSuffice M agree‚ÇÅ agree‚ÇÇ =
  shortIsNotMinimalAtTwoQuarters (transport chain shortIsMinimalAtOneHalf)
  where
    same : Path Rate [ oneHalf ] [ twoQuarters ]
    same = eq/ oneHalf twoQuarters oneHalfIsTwoQuarters

    step : M [ oneHalf ] short ‚â° M [ twoQuarters ] short
    step = cong (Œª r ‚Üí M r short) same

    chain : Minimal oneHalf short ‚â° Minimal twoQuarters short
    chain = sym agree‚ÇÅ ‚àô step ‚àô agree‚ÇÇ

------------------------------------------------------------------------
-- 2.  So the Type-valued impossibility, said to be uncovered, is free
------------------------------------------------------------------------

noMinimalityAtAnyTarget :
  (M : Rate ‚Üí List Bool ‚Üí Type)
  ‚Üí ((a : ‚Ñï √ó ‚Ñï) (bs : List Bool) ‚Üí M [ a ] bs ‚â° Minimal a bs)
  ‚Üí ‚ä•
noMinimalityAtAnyTarget M agrees =
  twoRepresentativesSuffice M
    (agrees oneHalf short) (agrees twoQuarters short)

------------------------------------------------------------------------
-- 3.  And the audited theorem is a special case, by composing with ‚ü®_‚ü©
------------------------------------------------------------------------

theHPropVersionIsAnInstance :
  (M : Rate ‚Üí List Bool ‚Üí hProp ‚Ñì-zero)
  ‚Üí ((a : ‚Ñï √ó ‚Ñï) (bs : List Bool) ‚Üí ‚ü® M [ a ] bs ‚ü© ‚â° Minimal a bs)
  ‚Üí ‚ä•
theHPropVersionIsAnInstance M agrees =
  noMinimalityAtAnyTarget (Œª r bs ‚Üí ‚ü® M r bs ‚ü©) agrees
