{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡®‡‡® ‚î ‡‡‡®‡‡®‡ã ‡µ‡‡‡‡‡‡∞‡ø‡‡æ‡‡ ‡
--
-- (this is the APPROXIMATE circumference of a circle.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- last open PROVE item ‚î asks that the BARRIER Structure Proposition be
-- made a theorem: WL observables factor through the blurred spectral
-- measure, hence no post-processing recovers what the blur merged.
--
-- It was proposed that the item SPLITS: the analytic half (that WL
-- observables do factor through the blur) stays open, while the second
-- half (that once they do, no refinement recovers the fibre) is already
-- available in general form from
-- `Vaidharmya_TheObstructionWasNeverClassicalAndTheAnswerTypeNeedOnlyBeApart`,
-- which removed `Bool` from `QuotientFiberLaw` and left
-- the negative half standing over an arbitrary answer type with an
-- arbitrary irreflexive separation.
--
-- **THE SPLIT AS PROPOSED IS NOT VALID, AND THIS MODULE IS WHY.**
--
-- `Vaidharmya`'s `AllBlind` demands that blind queries return EQUAL
-- answers ‚î its own header says "not close, equal" ‚î because its whole
-- proof is `cong decide` applied to an equality of transcripts.  An
-- analytic barrier lemma does not deliver equality.  It delivers
-- agreement to within Œµ: `BARRIER.md`'s own Corollary B2 asks only that
-- œ_k ‚àí œ_k‚≤ be "annihilated at that resolution", with mismatch
-- O((Œ¥L)^{2p‚àí1}), and `BARRIER_ERROR_WINDOW.md` Theorem U1 puts the
-- window's error term E at C_E X‚^{‚àí1/2} Œò_œ(L/2), a NONZERO quantity
-- that depends on the configuration through the (k‚àí1)-fold wave layer
-- íµ_{k‚àí1}.  Two configurations agreeing under the blur therefore give
-- transcripts that are CLOSE, never equal, and `cong` fires on nothing.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED HERE.  Three statements, no analysis, no numerics.
--
--   ¬ß‡®  **The near-law.**  Replace equality of answers by an arbitrary
--       tolerance relation `_‚âà_` and the law survives ‚î PROVIDED the
--       decoder respects the tolerance and the tolerance excludes the
--       separation.  Proof is four lines and mentions no constructor.
--
--   ¬ß‡©  **Where the exact case got its hypothesis for free.**  Take
--       `_‚âà_ := _‚â°_` and `Respects decide` is inhabited for EVERY
--       decoder, by `cong`.  That is precisely the hypothesis
--       `Vaidharmya` never had to state, and precisely the one the
--       analytic setting must now pay for.
--
--   ¬ß‡  **The gap is real, and here is a counterexample.**  Near
--       blindness ALONE ‚î with the arbitrary post-processing that
--       `BARRIER.md`'s Proposition B3 explicitly insists on ("even
--       non-computable") ‚î implies NO obstruction whatever.  One state
--       space of two points, one query, answers 1 and 0, tolerance
--       "differ by at most one": the pair is near-blind and the head
--       decoder separates it.  Checked, not argued.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- SO WHAT MUST THE ANALYTIC BARRIER LEMMA SUPPLY?  Exactly one of two
-- things, and this module's content is that there is no third:
--
--   (a) EXACT agreement of the full observable, not of the blur ‚î which
--       is `BARRIER_SMOOTH_TERM.md`'s corrected B2‚≤ (every lower-arity
--       layer, at precision ŒµX^{‚àír/2}), and is a strictly stronger
--       demand than B2 as `BARRIER.md` still states it; or
--
--   (b) a MODULUS on Œ¶ ‚î a bound on how far a WL post-processing may
--       amplify a sub-resolution difference.  ¬ß‡®'s `Respects` is the
--       weakest form of that hypothesis.
--
-- And (b) is in direct contradiction with Proposition B3 as written,
-- whose entire force is that Œ¶ is arbitrary.  **B3's generality is what
-- kills the Œµ-version of its own corollary.**  That collision is the
-- finding; it is a missing distinction in the WL definition, not a
-- failure to resolve.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡‡‡®‡‡® ‚î "approached", hence approximate ‚î is the tradition's
-- own word for a value given AS an approximation and marked so in the
-- statement itself.  ryabhaa, *ryabhaya*, Gaitapda 10 (499):
-- the ratio 62832/20000 is introduced with ‡‡‡®‡‡®‡ã ‡µ‡‡‡‡‡‡∞‡ø‡‡æ‡‡, "this is
-- the approximate circumference" ‚î the approximation declared in the
-- verse rather than left for a reader to discover.  That declaration is
-- the whole subject of this module: a quantity known to within a
-- tolerance is a different object from a quantity known, and a theorem
-- proved for the second does not transfer to the first.
--
-- LIMIT.  The term is used here for an arbitrary tolerance relation on
-- an answer type.  No text states a tolerance relation, ryabhaa
-- proved nothing below, and the connection asserted is only that both
-- name the same job ‚î marking, in the statement, that what is in hand
-- is near and not equal.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module Asanna_TheNearIsNotTheEqualAndTheBarrierDiesInTheGap where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Data.Empty using (‚ä•* ; rec*)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; snotz)
open import Cubical.Relation.Nullary using (¬¨_)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ The observation class, with a tolerance in place of equality.
--
-- `V` is what a query returns; `_‚âà_` is "indistinguishable to within the
-- window"; `_#_` is "told apart".  Nothing is assumed of either ‚î not
-- reflexivity, not symmetry, not transitivity, not irreflexivity.  The
-- hypotheses arrive at the theorems that need them, so it is visible
-- which theorem pays for what.
------------------------------------------------------------------------

module Def (X : Type ‚Ñì) (V : Type ‚Ñì)
           (_‚âà_ : V ‚Üí V ‚Üí Type ‚Ñì)
           (_#_ : V ‚Üí V ‚Üí Type ‚Ñì) where

  Query : Type ‚Ñì
  Query = X ‚Üí V

  obs : List Query ‚Üí X ‚Üí List V
  obs []       x = []
  obs (o ‚à∑ os) x = o x ‚à∑ obs os x

  -- Transcripts within tolerance, pointwise.
  _‚âà·¥∏_ : List V ‚Üí List V ‚Üí Type ‚Ñì
  []      ‚âà·¥∏ []      = Unit*
  []      ‚âà·¥∏ (_ ‚à∑ _) = ‚ä•*
  (_ ‚à∑ _) ‚âà·¥∏ []      = ‚ä•*
  (a ‚à∑ s) ‚âà·¥∏ (b ‚à∑ t) = (a ‚âà b) √ó (s ‚âà·¥∏ t)

  -- Every query fails to resolve the pair ‚î to within the tolerance.
  -- This, and not equality, is what a windowed observable delivers.
  NearBlind : List Query ‚Üí X ‚Üí X ‚Üí Type ‚Ñì
  NearBlind []       x y = Unit*
  NearBlind (o ‚à∑ os) x y = (o x ‚âà o y) √ó NearBlind os x y

  -- Post-processing, arbitrary: `BARRIER.md` Prop. B3's Œ¶.
  Separates : List Query ‚Üí X ‚Üí X ‚Üí Type ‚Ñì
  Separates os x y =
    Œ£[ decide ‚àà (List V ‚Üí V) ] (decide (obs os x) # decide (obs os y))

  -- A decoder carrying a modulus: it may not turn a within-tolerance
  -- difference into an out-of-tolerance one.
  Respects : (List V ‚Üí V) ‚Üí Type ‚Ñì
  Respects decide = (s t : List V) ‚Üí s ‚âà·¥∏ t ‚Üí decide s ‚âà decide t

  SeparatesRespectfully : List Query ‚Üí X ‚Üí X ‚Üí Type ‚Ñì
  SeparatesRespectfully os x y =
    Œ£[ decide ‚àà (List V ‚Üí V) ]
      (Respects decide √ó (decide (obs os x) # decide (obs os y)))

------------------------------------------------------------------------
-- ‡® ¬ The near-law.  Two hypotheses, both stated, neither free.
--
--   (i)  the decoder respects the tolerance;
--   (ii) the tolerance excludes the separation ‚î being within tolerance
--        is incompatible with being told apart.
--
-- Given those, near-blindness obstructs, and the proof never mentions a
-- constructor, a decidability, or an h-level, exactly as in ¬ß‡® of
-- `Vaidharmya`.  The `cong` there has become the hypothesis here; that
-- substitution IS the content of this module.
------------------------------------------------------------------------

  obs-near : (os : List Query) (x y : X)
           ‚Üí NearBlind os x y ‚Üí obs os x ‚âà·¥∏ obs os y
  obs-near []       x y _        = tt*
  obs-near (o ‚à∑ os) x y (b , bs) = b , obs-near os x y bs

  near-no-decision :
      ((a b : V) ‚Üí a ‚âà b ‚Üí ¬¨ (a # b))
    ‚Üí (os : List Query) (x y : X)
    ‚Üí NearBlind os x y ‚Üí ¬¨ SeparatesRespectfully os x y
  near-no-decision excl os x y nb (decide , resp , sep) =
    excl (decide (obs os x)) (decide (obs os y))
         (resp (obs os x) (obs os y) (obs-near os x y nb))
         sep

  -- Non-vacuity: respectful decoders exist, so the conclusion of
  -- `near-no-decision` is not a statement about the empty class.
  const-respects : (v : V) ‚Üí ((w : V) ‚Üí w ‚âà w) ‚Üí Respects (Œª _ ‚Üí v)
  const-respects v ‚âàrefl s t _ = ‚âàrefl v

------------------------------------------------------------------------
-- ‡© ¬ Where the exact law got its hypothesis for free.
--
-- Instantiate the tolerance at equality.  Then `Respects` is inhabited
-- for EVERY decoder ‚î that is `cong` ‚î so `SeparatesRespectfully` and
-- `Separates` coincide and ¬ß‡® collapses to `Vaidharmya`'s
-- `no-decision`, hypothesis (i) having cost nothing.
--
-- The point is negative and it is the whole reason the split fails:
-- hypothesis (i) is invisible at `_‚â°_` and load-bearing anywhere else.
------------------------------------------------------------------------

module ‡§∏‡§Æ‡§§‡§æ (X : Type ‚Ñì) (V : Type ‚Ñì) (_#_ : V ‚Üí V ‚Üí Type ‚Ñì) where

  open Def X V _‚â°_ _#_ public

  ‚âà·¥∏‚Üí‚â° : (s t : List V) ‚Üí s ‚âà·¥∏ t ‚Üí s ‚â° t
  ‚âà·¥∏‚Üí‚â° []      []      _       = refl
  ‚âà·¥∏‚Üí‚â° []      (_ ‚à∑ _) e       = rec* e
  ‚âà·¥∏‚Üí‚â° (_ ‚à∑ _) []      e       = rec* e
  ‚âà·¥∏‚Üí‚â° (a ‚à∑ s) (b ‚à∑ t) (p , q) = cong‚ÇÇ _‚à∑_ p (‚âà·¥∏‚Üí‚â° s t q)

  -- The hypothesis that costs nothing at equality.
  every-decoder-respects : (decide : List V ‚Üí V) ‚Üí Respects decide
  every-decoder-respects decide s t e = cong decide (‚âà·¥∏‚Üí‚â° s t e)

  -- ‚¶hence the arbitrary-decoder statement follows, with irreflexivity
  -- as the only surviving hypothesis: `Vaidharmya` ¬ß‡®, recovered.
  exact-no-decision : ((v : V) ‚Üí ¬¨ (v # v))
                    ‚Üí (os : List Query) (x y : X)
                    ‚Üí NearBlind os x y ‚Üí ¬¨ Separates os x y
  exact-no-decision irr os x y nb (decide , sep) =
    near-no-decision (Œª a b p ‚Üí subst (Œª z ‚Üí ¬¨ (z # b)) (sym p) (irr b))
                     os x y nb
                     (decide , every-decoder-respects decide , sep)

------------------------------------------------------------------------
-- ‡ ¬ The gap, as a checked counterexample.
--
-- Drop hypothesis (i) ‚î which is exactly what `BARRIER.md` Prop. B3
-- does when it insists Œ¶ be arbitrary and even non-computable ‚î and
-- near-blindness implies nothing at all.
--
-- Two states.  One query.  Answers 1 and 0.  Tolerance: differ by at
-- most one.  Separation: inequality.  The pair is near-blind; the head
-- decoder tells it apart.
--
-- The tolerance here is deliberately NOT excluded by the separation
-- (adjacent naturals are within tolerance and unequal), which is
-- precisely the analytic situation: two configurations agreeing under
-- the blur have observable values that are close and different.
------------------------------------------------------------------------

_‚âà‚ÇÅ_ : ‚Ñï ‚Üí ‚Ñï ‚Üí Type‚ÇÄ
m ‚âà‚ÇÅ n = (m ‚â° n) ‚äé ((suc m ‚â° n) ‚äé (m ‚â° suc n))

_‚â†‚ÇÅ_ : ‚Ñï ‚Üí ‚Ñï ‚Üí Type‚ÇÄ
m ‚â†‚ÇÅ n = ¬¨ (m ‚â° n)

open Def Bool ‚Ñï _‚âà‚ÇÅ_ _‚â†‚ÇÅ_

-- The one query: it reads 1 on the first state and 0 on the second.
‡§Æ‡§æ‡§™‡§É : Query
‡§Æ‡§æ‡§™‡§É true  = 1
‡§Æ‡§æ‡§™‡§É false = 0

‡§∂‡§ø‡§∞‡§É : List ‚Ñï ‚Üí ‚Ñï
‡§∂‡§ø‡§∞‡§É []      = 0
‡§∂‡§ø‡§∞‡§É (n ‚à∑ _) = n

‡§Ü‡§∏‡§®‡•ç‡§®-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç : NearBlind (‡§Æ‡§æ‡§™‡§É ‚à∑ []) true false
‡§Ü‡§∏‡§®‡•ç‡§®-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç = inr (inr refl) , tt*

-- ‚¶and yet it is separated, by a decoder as tame as they come.
‡§Ü‡§∏‡§®‡•ç‡§®-‡§®-‡§¨‡§æ‡§ß‡§æ : Separates (‡§Æ‡§æ‡§™‡§É ‚à∑ []) true false
‡§Ü‡§∏‡§®‡•ç‡§®-‡§®-‡§¨‡§æ‡§ß‡§æ = ‡§∂‡§ø‡§∞‡§É , snotz

-- Stated as the refutation it is: near-blindness plus arbitrary
-- post-processing does NOT obstruct.  Any barrier claim of that shape
-- is false, and the two admissible repairs are ¬ß‡®'s hypotheses.
‡§ó‡§æ‡§™‡§É : NearBlind (‡§Æ‡§æ‡§™‡§É ‚à∑ []) true false √ó Separates (‡§Æ‡§æ‡§™‡§É ‚à∑ []) true false
‡§ó‡§æ‡§™‡§É = ‡§Ü‡§∏‡§®‡•ç‡§®-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç , ‡§Ü‡§∏‡§®‡•ç‡§®-‡§®-‡§¨‡§æ‡§ß‡§æ

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what this leaves standing, and what it hands back.
--
-- Standing: `Vaidharmya` is untouched.  Over an answer type with EXACT
-- blindness the obstruction holds for any irreflexive separation and
-- any decoder whatever, and ¬ß‡© re-derives it from ¬ß‡®.
--
-- Handed back to the analytic lane, and this is the deliverable:
-- `METHOD.md` ¬ß3 item 1 does not reduce to a formal half plus an
-- analytic half.  The analytic half must additionally produce ONE of
--
--   (a) exact layerwise agreement ‚î B2‚≤ of `BARRIER_SMOOTH_TERM.md`,
--       which `BARRIER.md`'s Corollary B2 does not state; or
--   (b) a modulus on WL post-processing ‚î which `BARRIER.md`'s
--       Proposition B3 currently rules out by construction.
--
-- Until one of the two is supplied, ¬ß‡ is the counterexample the claim
-- has to survive, and it is one query long.
------------------------------------------------------------------------
