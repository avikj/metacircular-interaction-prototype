{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡à‡ß‡∞‡‡Æ‡‡Ø ‚î ‡µ‡ø‡∞‡‡¶‡‡ß‡ß‡∞‡‡Æ‡ ‡‡µ ‡‡∞‡‡Ø‡æ‡‡‡‡, ‡® ‡¶‡‡µ‡à‡µ‡ø‡ß‡‡Ø‡Æ‡ ‡
--
-- (dissimilarity alone suffices; two-valuedness is not needed.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  `QuotientFiberLaw` is this corpus's
-- general obstruction theorem ‚î an observation class sees exactly a
-- quotient, what it cannot see is the fibre, no post-processing
-- manufactures the fibre.  It has essentially NO hypotheses on the state
-- space: `X : Type ‚ì`, arbitrary, no `isSet`, no `Discrete`, no
-- finiteness, and `Separates` quantifies over EVERY decoder, computable
-- or not, deliberately.
--
-- AND IT IS TWO-VALUED IN THREE PLACES, WHICH NOBODY HAD SAID.
--
--   Query   = X ‚í Bool                        (a query IS a bit)
--   Charged o x y = o x ‚â° not (o y)           (separation IS negation)
--   obs     : List Query ‚í X ‚í List Bool      (the transcript is bits)
--
-- and `no-decision` runs on `not-fix : (b : Bool) ‚í ¬ (b ‚â° not b)`,
-- proved by case-splitting `true` and `false`.
--
-- So the corpus's general theorem about what a collapsed verdict cannot
-- see is itself stated in a collapsed verdict ‚î the register
-- `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` proves must identify two of any three seeds.  It
-- is not wrong.  It is a naya, and it cannot see its own limit from
-- inside.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS PROVES, AND IT IS ONE LINE OF ACTUAL CONTENT.
--
-- Replace `Bool` by an arbitrary answer type `V`, and `‚â° not` by any
-- relation `_#_` that is merely IRREFLEXIVE.  The negative half of the
-- law survives verbatim.  ¬ß‡®'s proof mentions no constructor, no
-- decidability, no h-level, and no two-valuedness: blind queries give
-- EQUAL transcripts, `cong decide` carries that equality to the
-- decoder's output, and irreflexivity kills the separation.
--
-- **THE OBSTRUCTION WAS NEVER CLASSICAL.**  It holds for a spectral
-- observable with an apartness relation, for a real-valued measurement
-- with `‚â`, for a complex amplitude ‚î for any answer type whatever, so
-- long as a thing is not apart from itself.  The `Bool` in the original
-- was carrying no weight and was hiding the theorem's reach.
--
-- ¬ß‡© recovers the original as the instance `V := Bool`,
-- `a # b := a ‚â° not b`, so nothing is lost and the old theorem is a
-- corollary of this one.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- The POSITIVE half ‚î charge suffices, a separator can be BUILT ‚î does
-- NOT generalise for free.  Over `Bool` it projects the transcript with
-- `hd`, which needs a value at the empty list.  So ¬ß‡ states it with `V`
-- POINTED, and that hypothesis is real: to exhibit a separator you must
-- be able to produce an answer, and over an arbitrary type you cannot.
--
-- **That asymmetry is the content, not a defect.**  Blindness is free and
-- universal; separation costs a point.  Which is the same shape as
-- everything else here: ‡‡‡ is cheap to be stuck in and expensive to get
-- out of, and `Tantujala` proves `isContr` merges the two ends.
--
-- Nothing below computes a rank, a PSD dimension, or an entropy.  The
-- tables, ordinary rank 4 both, PSD dimensions 2 and 4) is NOT derived
-- here and is not a consequence of this module.  What this removes is
-- only the excuse that the obstruction was about bits.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡µ‡à‡ß‡∞‡‡Æ‡‡Ø ‚î dissimilarity ‚î is the technical term of the Nyya
-- and Buddhist logical traditions for the DISSIMILAR class, against
-- ‡‡æ‡ß‡∞‡‡Æ‡‡Ø for the similar: the ‡µ‡à‡ß‡∞‡‡Æ‡‡Ø-‡¶‡‡‡‡ü‡æ‡®‡‡ is the negative
-- example, and Dignga's third condition of the ‡‡‡∞‡à‡∞‡‡‡‡Ø is exactly
-- absence of the reason throughout the dissimilar class.  Sources:
-- Gautama, ‡®‡‡Ø‡æ‡Ø‡‡‡‡‡∞‡Æ‡ (the ‡¶‡‡‡‡ü‡æ‡®‡‡ members); Dignga, ~5th‚ì6th c.;
-- ‡ß‡∞‡‡Æ‡ï‡‡∞‡‡‡ø, ‡®‡‡Ø‡æ‡Ø‡‡ø‡®‡‡¶‡‡ ‡®.‡, where the placement of the particle ‡‡µ
-- fixes the scope of exactly this condition.
--
-- LIMIT: the term is used here for an irreflexive separation relation on
-- an answer type.  No text states an apartness relation, no logician
-- proved anything below, and the connection asserted is that both name
-- the same job ‚î the condition under which two things count as told
-- apart.
------------------------------------------------------------------------

module Vaidharmya_TheObstructionWasNeverClassicalAndTheAnswerTypeNeedOnlyBeApart where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true‚â¢false)
open import Cubical.Relation.Nullary using (¬¨_)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ The law, over an arbitrary answer type.
--
-- `V` is what a query returns.  `_#_` is what it means to be told apart.
-- The ONLY thing asked of `_#_` is that nothing is apart from itself.
------------------------------------------------------------------------

module Law (X : Type ‚Ñì) (V : Type ‚Ñì)
           (_#_ : V ‚Üí V ‚Üí Type ‚Ñì)
           (#-irrefl : (v : V) ‚Üí ¬¨ (v # v)) where

  Query : Type ‚Ñì
  Query = X ‚Üí V

  obs : List Query ‚Üí X ‚Üí List V
  obs []       x = []
  obs (o ‚à∑ os) x = o x ‚à∑ obs os x

  Blind Charged : Query ‚Üí X ‚Üí X ‚Üí Type ‚Ñì
  Blind   o x y = o x ‚â° o y
  Charged o x y = o x # o y

  AllBlind : List Query ‚Üí X ‚Üí X ‚Üí Type ‚Ñì
  AllBlind []       x y = Unit*
  AllBlind (o ‚à∑ os) x y = Blind o x y √ó AllBlind os x y

  -- Quantifies over EVERY analysis of the transcript, computable or not.
  Separates : List Query ‚Üí X ‚Üí X ‚Üí Type ‚Ñì
  Separates os x y =
    Œ£[ decide ‚àà (List V ‚Üí V) ] (decide (obs os x) # decide (obs os y))

------------------------------------------------------------------------
-- ‡® ¬ The negative half, and it never mentions a constructor.
--
-- Blind queries give EQUAL transcripts ‚î not close, equal ‚î so `cong`
-- carries the equality through any decoder whatever, and then the
-- separation is a thing apart from itself.
------------------------------------------------------------------------

  obs-agree : (os : List Query) (x y : X)
            ‚Üí AllBlind os x y ‚Üí obs os x ‚â° obs os y
  obs-agree []       x y _        = refl
  obs-agree (o ‚à∑ os) x y (b , bs) = cong‚ÇÇ _‚à∑_ b (obs-agree os x y bs)

  no-decision : (os : List Query) (x y : X)
              ‚Üí AllBlind os x y ‚Üí ¬¨ Separates os x y
  no-decision os x y bs (decide , sep) =
    #-irrefl (decide (obs os y))
      (subst (Œª z ‚Üí z # decide (obs os y))
             (cong decide (obs-agree os x y bs))
             sep)

------------------------------------------------------------------------
-- ‡© ¬ The original is the instance `V := Bool`, `a # b := a ‚â° not b`.
--
-- So `QuotientFiberLaw`'s negative half is a corollary of ¬ß‡® and nothing
-- has been given up.  The `Bool` was carrying no weight.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§µ‡•à‡§ß‡§∞‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : Bool ‚Üí Bool ‚Üí Type
‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§µ‡•à‡§ß‡§∞‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç a b = a ‚â° not b

‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§Ö‡§∏‡•ç‡§µ‡§µ‡§ø‡§∞‡•ã‡§ß‡§É : (b : Bool) ‚Üí ¬¨ (‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§µ‡•à‡§ß‡§∞‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç b b)
‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§Ö‡§∏‡•ç‡§µ‡§µ‡§ø‡§∞‡•ã‡§ß‡§É true  e = true‚â¢false e
‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§Ö‡§∏‡•ç‡§µ‡§µ‡§ø‡§∞‡•ã‡§ß‡§É false e = true‚â¢false (sym e)

module ‡§™‡•Ç‡§∞‡•ç‡§µ‡§É (X : Type‚ÇÄ) =
  Law X Bool ‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§µ‡•à‡§ß‡§∞‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç ‡§¶‡•ç‡§µ‡§ø‡§Æ‡•Ç‡§≤-‡§Ö‡§∏‡•ç‡§µ‡§µ‡§ø‡§∞‡•ã‡§ß‡§É

------------------------------------------------------------------------
-- ‡ ¬ Any type at all, with `‚â` as the separation.
--
-- Irreflexivity is then immediate, so EVERY answer type carries the
-- obstruction with no structure supplied whatever.  This is the
-- statement that the law is not about bits.
------------------------------------------------------------------------

‡§Ö‡§≠‡•á‡§¶‡§É : {V : Type ‚Ñì} ‚Üí V ‚Üí V ‚Üí Type ‚Ñì
‡§Ö‡§≠‡•á‡§¶‡§É a b = ¬¨ (a ‚â° b)

‡§Ö‡§≠‡•á‡§¶-‡§Ö‡§∏‡•ç‡§µ‡§µ‡§ø‡§∞‡•ã‡§ß‡§É : {V : Type ‚Ñì} (v : V) ‚Üí ¬¨ (‡§Ö‡§≠‡•á‡§¶‡§É v v)
‡§Ö‡§≠‡•á‡§¶-‡§Ö‡§∏‡•ç‡§µ‡§µ‡§ø‡§∞‡•ã‡§ß‡§É v ne = ne refl

module ‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ {‚Ñì‚ÇÄ : Level} (X : Type ‚Ñì‚ÇÄ) (V : Type ‚Ñì‚ÇÄ) =
  Law X V ‡§Ö‡§≠‡•á‡§¶‡§É ‡§Ö‡§≠‡•á‡§¶-‡§Ö‡§∏‡•ç‡§µ‡§µ‡§ø‡§∞‡•ã‡§ß‡§É

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î blindness is free, separation costs a point.
--
-- The positive half of `QuotientFiberLaw` (charge suffices ‚î a separator
-- can be exhibited) projects the transcript with a head function, which
-- needs a value at `[]`.  Over `Bool` that is silent.  Over an arbitrary
-- `V` it is a hypothesis: **to exhibit a separator you must be able to
-- produce an answer.**
--
-- The asymmetry is the finding.  Being unable to tell two things apart
-- is universal and costs nothing to prove.  Telling them apart requires
-- an inhabitant of the answer type ‚î you must be able to SAY something.
-- Nothing here supplies that, and no default is invented, because an
-- arbitrary default on an unobservable value is precisely the move both
-- lanes' `FactorsThrough` refuses by typing its decoder on the image.
------------------------------------------------------------------------
