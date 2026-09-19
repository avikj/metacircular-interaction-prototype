{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheRatesAreDenseAndTheMediantSurvivesTheQuotient
--
-- Two modules left the same half-sentence open.
-- `TheThresholdChainIsDenseAndTheMediantWitnessesIt` says density "is
-- proved for pairs, and ‚ä is a preorder, so nothing is said about
-- density of the RATES", and
-- `TheRateQuotientExistsAndMinimalityCannotLiveOnIt` says "DENSITY OF
-- THE RATES is NOT proved: the mediant module's `‚ä` is not lifted here,
-- and lifting it needs `‚ä` to respect `‚âà` on BOTH sides, which is not
-- checked."
--
-- Both are closed here, and the second sentence turns out to describe
-- the harder half correctly: the lifting is the work, and the density
-- then follows WITHOUT the mediant itself having to descend.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ‚ä‚ä-trans / ‚ä‚ä-trans   the mixed transitivities, by the same
--                         multiply‚ìrearrange‚ìcancel as `‚ä-trans`, with
--                         `‚â<-trans` / `<‚â-trans` at the join
--   ‚ä-respects-‚âà          hence `‚ä` respects `‚âà` on BOTH sides
--   _‚äR_                  the strict order LIFTED to `Rate`, by
--                         `SetQuotients.rec2` into `hProp`
--   ‚äR-computes           agreeing with `‚ä` on representatives, by refl
--   theRatesAreDense      between two rates lies a third
--
-- **The mediant never has to descend.**  That is the point worth
-- keeping: `mediant` is a function on PAIRS and nothing here shows it
-- respects `‚âà` ‚î it may or may not.  Density is a MERE EXISTENCE
-- statement, so its target is a proposition, so `elimProp2` reduces the
-- whole claim to representatives, where the pair-level mediant is
-- already available.  A witness that need not be canonical does not
-- need to be well-defined on the quotient.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  Density of the rationals via the mediant is classical
-- (Haros 1802; Farey 1816; Stern 1858; Brocot 1861), and lifting a
-- respectful relation along a set-quotient is standard cubical
-- practice.  What is contributed is that this corpus's own two open
-- half-sentences are closed, and the observation about the witness.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheRatesAreDenseAndTheMediantSurvivesTheQuotient where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (‚ü®_‚ü©)
open import Cubical.Foundations.HLevels using (hProp ; isSetHProp ; isPropŒ†)
open import Cubical.Functions.Logic using (‚áîtoPath)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; elimProp2)
open import Cubical.HITs.PropositionalTruncation as PT using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; isPropPropTrunc)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _¬∑_)
open import Cubical.Data.Nat.Order
  using (_‚â§_ ; _<_ ; isProp‚â§ ; ‚â§-¬∑k ; <-¬∑sk ; ‚â§<-trans ; <‚â§-trans)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)

open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (_‚äë_ ; swapOuter ; ¬∑sk-cancel-‚â§)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (¬∑sk-cancel-<)
open import WhichThresholdStatementsDescendToTheRate
  using (_‚âà_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (_‚äè_ ; mediant ; mediantIsAbove ; mediantIsBelow)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)

------------------------------------------------------------------------
-- 1.  Mixed transitivities
------------------------------------------------------------------------

‚äë‚äè-trans : (a b c : ‚Ñï √ó ‚Ñï) ‚Üí a ‚äë b ‚Üí b ‚äè c ‚Üí a ‚äè c
‚äë‚äè-trans (p , q) (p' , q') (p'' , q'') h1 h2 = ¬∑sk-cancel-< q' scaled
  where
    b2 : (p ¬∑ suc q'') ¬∑ suc q' ‚â§ (p' ¬∑ suc q) ¬∑ suc q''
    b2 = subst (_‚â§ (p' ¬∑ suc q) ¬∑ suc q'')
               (sym (swapOuter p (suc q'') (suc q'))) (‚â§-¬∑k h1)

    b3 : (p ¬∑ suc q'') ¬∑ suc q' ‚â§ (p' ¬∑ suc q'') ¬∑ suc q
    b3 = subst ((p ¬∑ suc q'') ¬∑ suc q' ‚â§_) (swapOuter p' (suc q) (suc q'')) b2

    scaled : (p ¬∑ suc q'') ¬∑ suc q' < (p'' ¬∑ suc q) ¬∑ suc q'
    scaled = subst ((p ¬∑ suc q'') ¬∑ suc q' <_)
                   (swapOuter p'' (suc q') (suc q)) (‚â§<-trans b3 (<-¬∑sk h2))

‚äè‚äë-trans : (a b c : ‚Ñï √ó ‚Ñï) ‚Üí a ‚äè b ‚Üí b ‚äë c ‚Üí a ‚äè c
‚äè‚äë-trans (p , q) (p' , q') (p'' , q'') h1 h2 = ¬∑sk-cancel-< q' scaled
  where
    b2 : (p ¬∑ suc q'') ¬∑ suc q' < (p' ¬∑ suc q) ¬∑ suc q''
    b2 = subst (_< (p' ¬∑ suc q) ¬∑ suc q'')
               (sym (swapOuter p (suc q'') (suc q'))) (<-¬∑sk h1)

    b3 : (p ¬∑ suc q'') ¬∑ suc q' < (p' ¬∑ suc q'') ¬∑ suc q
    b3 = subst ((p ¬∑ suc q'') ¬∑ suc q' <_) (swapOuter p' (suc q) (suc q'')) b2

    scaled : (p ¬∑ suc q'') ¬∑ suc q' < (p'' ¬∑ suc q) ¬∑ suc q'
    scaled = subst ((p ¬∑ suc q'') ¬∑ suc q' <_)
                   (swapOuter p'' (suc q') (suc q)) (<‚â§-trans b3 (‚â§-¬∑k h2))

‚äè-respects-‚âà :
  (a a' b b' : ‚Ñï √ó ‚Ñï) ‚Üí a ‚âà a' ‚Üí b ‚âà b' ‚Üí a ‚äè b ‚Üí a' ‚äè b'
‚äè-respects-‚âà a a' b b' aa bb h =
  ‚äè‚äë-trans a' b b' (‚äë‚äè-trans a' a b (snd aa) h) (fst bb)

------------------------------------------------------------------------
-- 2.  So ‚ä lifts to the rates
------------------------------------------------------------------------

‚äèP : ‚Ñï √ó ‚Ñï ‚Üí ‚Ñï √ó ‚Ñï ‚Üí hProp ‚Ñì-zero
‚äèP a b = (a ‚äè b) , isProp‚â§

‚äè-respectsÀ° : (a b c : ‚Ñï √ó ‚Ñï) ‚Üí a ‚âà b ‚Üí ‚äèP a c ‚â° ‚äèP b c
‚äè-respectsÀ° a b c r =
  ‚áîtoPath (‚äè-respects-‚âà a b c c r (‚âàrefl c))
          (‚äè-respects-‚âà b a c c (snd r , fst r) (‚âàrefl c))
  where
    ‚âàrefl : (x : ‚Ñï √ó ‚Ñï) ‚Üí x ‚âà x
    ‚âàrefl (p , q) = ‚â§-refl' , ‚â§-refl'
      where ‚â§-refl' : p ¬∑ suc q ‚â§ p ¬∑ suc q
            ‚â§-refl' = 0 , refl

‚äè-respects ≥ : (a b c : ‚Ñï √ó ‚Ñï) ‚Üí b ‚âà c ‚Üí ‚äèP a b ‚â° ‚äèP a c
‚äè-respects ≥ a b c r =
  ‚áîtoPath (‚äè-respects-‚âà a a b c (‚âàrefl a) r)
          (‚äè-respects-‚âà a a c b (‚âàrefl a) (snd r , fst r))
  where
    ‚âàrefl : (x : ‚Ñï √ó ‚Ñï) ‚Üí x ‚âà x
    ‚âàrefl (p , q) = ‚â§-refl' , ‚â§-refl'
      where ‚â§-refl' : p ¬∑ suc q ‚â§ p ¬∑ suc q
            ‚â§-refl' = 0 , refl

_‚äèR_ : Rate ‚Üí Rate ‚Üí hProp ‚Ñì-zero
_‚äèR_ = SQ.rec2 isSetHProp ‚äèP ‚äè-respectsÀ° ‚äè-respects ≥

‚äèR-computes : (a b : ‚Ñï √ó ‚Ñï) ‚Üí ‚ü® [ a ] ‚äèR [ b ] ‚ü© ‚â° (a ‚äè b)
‚äèR-computes a b = refl

------------------------------------------------------------------------
-- 3.  And the rates are dense
--
-- The target is a mere existence, hence a proposition, hence
-- `elimProp2` puts us at representatives ‚î where the PAIR-level
-- mediant is already a witness.  Nothing requires `mediant` itself to
-- descend.
------------------------------------------------------------------------

Between : Rate ‚Üí Rate ‚Üí Type
Between x y = ‚à• Œ£[ z ‚àà Rate ] (‚ü® x ‚äèR z ‚ü© √ó ‚ü® z ‚äèR y ‚ü©) ‚à•‚ÇÅ

theRatesAreDense : (x y : Rate) ‚Üí ‚ü® x ‚äèR y ‚ü© ‚Üí Between x y
theRatesAreDense =
  elimProp2 (Œª x y ‚Üí isPropŒ† (Œª _ ‚Üí isPropPropTrunc))
    (Œª where (p , q) (p' , q') h ‚Üí
               ‚à£ [ mediant (p , q) (p' , q') ]
               , mediantIsAbove p q p' q' h
               , mediantIsBelow p q p' q' h ‚à£‚ÇÅ)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "`‚äR` is a relation into `hProp`, not an order: irreflexivity,
--    transitivity, and its relation to `AtLeastOnRate`/`AboveOnRate`
--    are unproved on `Rate`."
--
-- All three in
-- `TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin ‚î check.sh returns 1 and says so):
--
--   ‚ä-irrefl-pair / ‚ä-trans-pair   at the pair level; transitivity is
--                                  `‚ä‚ä-trans` composed with `<-weaken`,
--                                  so the MIXED transitivity proved
--                                  here for the lifting is what makes
--                                  the plain one free
--   ‚äR-irrefl / ‚äR-trans           the same on `Rate`, by `elimProp`
--                                  and `elimProp3`
--   aboveIsAntitoneOnRates         the strict claim is antitone along
--                                  `‚äR`, stated entirely on `Rate`
--
-- NONE OF IT NEEDED A NEW IDEA, and that is the payoff of having lifted
-- along `rec2`: every statement is a PROPOSITION, so `elimProp` puts it
-- at representatives where ¬ß1's pair-level facts finish it in a line.
-- The density result above therefore now sits on an ORDER, not a bare
-- relation.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The open item stated above and repeated in
-- `TheRateQuotientExistsAndMinimalityCannotLiveOnIt` ‚î "whether
-- `mediant` DESCENDS is open" ‚î is now CLOSED, and the answer is NO:
-- `TheMediantDoesNotDescendToTheRate` exhibits
-- (1,1) ‚âà (2,3) whose mediants with (1,2) are 2/5 and 3/7 (--safe, no
-- postulates, no holes; container green under Agda 2.6.3 + cubical
-- v0.5, NOT the declared pin ‚î check.sh returns 1 and says so).
--
-- Nothing above is affected.  The density theorem is stated with
-- `‚à_‚à‚` and eliminates into a proposition, so the witness only ever
-- lived at the level of representatives ‚î which is what "the mediant
-- never has to descend" says.  What the refutation removes is the
-- possibility of upgrading that truncated existence to a CANONICAL
-- between-rate by this route: no `Rate ‚í Rate ‚í Rate` extends the
-- mediant, and the classical fix is reduced representatives (Haros
-- 1802, Farey 1816, Stern 1858, Brocot 1861), which needs coprimality
-- and hence another identity's kuaka line ‚î to be asked for, not
-- rebuilt.
------------------------------------------------------------------------
