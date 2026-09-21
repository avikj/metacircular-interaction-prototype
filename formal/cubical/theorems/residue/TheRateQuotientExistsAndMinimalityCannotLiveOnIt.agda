{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheRateQuotientExistsAndMinimalityCannotLiveOnIt
--
-- Two results on this line now end at the same sentence.
-- `WhichThresholdStatementsDescendToTheRate` says "no quotient TYPE is
-- formed â” `â‰ˆ` is a relation, with no set-quotient, no truncation and
-- no univalence", and
-- `TheThresholdChainIsDenseAndTheMediantWitnessesIt` says density "is
-- proved for pairs â¦ nothing is said about density of the RATES â”
-- that needs the quotient Â§4 above explicitly does not form."
--
-- When the SAME limitation ends two different results, that limitation
-- is the object, not either result.  The quotient is formed here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Rate = (â• — â•) / _â‰ˆ_        the set-quotient, a genuine HIT
--   AtLeastOnRate               `AtLeast` LIFTS: a function of the RATE,
--                               not of the pair
--   AboveOnRate                 and so does `Above`
--   atLeastOnRateComputes       the lift agrees with the old definition
--                               on every representative, by `refl`
--   noMinimalityOnTheRate       and NO function on `Rate` can agree with
--                               `Minimal` on all representatives â” an
--                               impossibility, not an absence
--
-- The last one is what the earlier modules could not state.  They
-- exhibited a pair where minimality holds of one representative and
-- fails of another, which shows a PARTICULAR definition does not
-- descend.  With the quotient in hand the statement becomes: no
-- definition does, because `[ oneHalf ] â‰¡ [ twoQuarters ]` is a PATH,
-- `cong` transports along it, and the two verdicts would have to agree.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE THE UNIVALENCE IS, since this corpus's remit names it.  The
-- lift is by `SetQuotients.rec`, which needs the target to be a set;
-- the target is `List Bool â’ hProp`, a set because `hProp` is
-- (`isSetHProp`), and THAT is propositional univalence â” `â”toPath`
-- turns a two-way implication between propositions into a path, and it
-- is what makes `atLeastRespects` a path rather than a pair of
-- functions.  `AtLeast p q bs` is a proposition because cubical's `â‰`
-- is (`isPropâ‰`), so nothing had to be truncated.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Set-quotients, lifting along a respectful map, and
-- propositional extensionality are standard cubical practice; the
-- rationals are built this way in the library itself.  What is
-- contributed is only which of THIS corpus's threshold predicates
-- survive the quotient, and the proof that one provably does not.
------------------------------------------------------------------------

module TheRateQuotientExistsAndMinimalityCannotLiveOnIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (âŸ¨_âŸ©)
open import Cubical.Foundations.HLevels using (hProp ; isSetHProp ; isSetÎ )
open import Cubical.Functions.Logic using (â‡”toPath)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.Order using (isPropâ‰¤)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above)
open import WhichThresholdStatementsDescendToTheRate
  using (_â‰ˆ_ ; atLeastDescends ; aboveDescends ; Minimal
        ; oneHalf ; twoQuarters ; oneHalfIsTwoQuarters
        ; shortIsMinimalAtOneHalf ; shortIsNotMinimalAtTwoQuarters)
open import MinimalityOfABoundaryPopulationNeedsLowestTerms
  using (short)

------------------------------------------------------------------------
-- 1.  The quotient
------------------------------------------------------------------------

Rate : Type
Rate = (â„• Ã— â„•) / _â‰ˆ_

------------------------------------------------------------------------
-- 2.  AtLeast and Above lift
------------------------------------------------------------------------

AtLeastP : â„• Ã— â„• â†’ List Bool â†’ hProp â„“-zero
AtLeastP (p , q) bs = AtLeast p q bs , isPropâ‰¤

AboveP : â„• Ã— â„• â†’ List Bool â†’ hProp â„“-zero
AboveP (p , q) bs = Above p q bs , isPropâ‰¤

atLeastRespects :
  (a b : â„• Ã— â„•) â†’ a â‰ˆ b â†’ AtLeastP a â‰¡ AtLeastP b
atLeastRespects a b r = funExt Î» bs â†’
  â‡”toPath (fst (atLeastDescends a b r bs)) (snd (atLeastDescends a b r bs))

aboveRespects :
  (a b : â„• Ã— â„•) â†’ a â‰ˆ b â†’ AboveP a â‰¡ AboveP b
aboveRespects a b r = funExt Î» bs â†’
  â‡”toPath (fst (aboveDescends a b r bs)) (snd (aboveDescends a b r bs))

AtLeastOnRate : Rate â†’ List Bool â†’ hProp â„“-zero
AtLeastOnRate =
  SQ.rec (isSetÎ  (Î» _ â†’ isSetHProp)) AtLeastP atLeastRespects

AboveOnRate : Rate â†’ List Bool â†’ hProp â„“-zero
AboveOnRate =
  SQ.rec (isSetÎ  (Î» _ â†’ isSetHProp)) AboveP aboveRespects

atLeastOnRateComputes :
  (p q : â„•) (bs : List Bool)
  â†’ âŸ¨ AtLeastOnRate [ (p , q) ] bs âŸ© â‰¡ AtLeast p q bs
atLeastOnRateComputes p q bs = refl

------------------------------------------------------------------------
-- 3.  And minimality provably cannot
--
-- Not "the obvious definition fails to descend" â” NO function on the
-- quotient agrees with `Minimal` on representatives, because
-- `[ oneHalf ] â‰¡ [ twoQuarters ]` is a path and `cong` transports along
-- it.
------------------------------------------------------------------------

noMinimalityOnTheRate :
  (M : Rate â†’ List Bool â†’ hProp â„“-zero)
  â†’ ((a : â„• Ã— â„•) (bs : List Bool) â†’ âŸ¨ M [ a ] bs âŸ© â‰¡ Minimal a bs)
  â†’ âŠ¥
noMinimalityOnTheRate M agrees =
  shortIsNotMinimalAtTwoQuarters (transport chain shortIsMinimalAtOneHalf)
  where
    same : Path Rate [ oneHalf ] [ twoQuarters ]
    same = eq/ oneHalf twoQuarters oneHalfIsTwoQuarters

    step : âŸ¨ M [ oneHalf ] short âŸ© â‰¡ âŸ¨ M [ twoQuarters ] short âŸ©
    step = cong (Î» r â†’ âŸ¨ M r short âŸ©) same

    chain : Minimal oneHalf short â‰¡ Minimal twoQuarters short
    chain = sym (agrees oneHalf short) âˆ™ step âˆ™ agrees twoQuarters short

------------------------------------------------------------------------
-- DENSITY OF THE RATES is proved in
-- `TheRatesAreDenseAndTheMediantSurvivesTheQuotient`:
--   âŠâŠ-trans / âŠâŠ-trans   mixed transitivities, by the same
--                         multiplyâ“rearrangeâ“cancel as `âŠ-trans`
--   âŠ-respects-â‰ˆ          hence `âŠ` respects `â‰ˆ` on both sides
--   _âŠR_                  `âŠ` lifted by `SetQuotients.rec2` into hProp
--   theRatesAreDense      between two rates lies a third
--
-- **AND THE MEDIANT NEVER HAS TO DESCEND.**  `mediant` is a function on
-- PAIRS and nothing shows it respects `â‰ˆ`.  It does not need to:
-- density is a MERE EXISTENCE, so its target is a proposition, so
-- `elimProp2` puts the whole claim at representatives, where the
-- pair-level mediant is already a witness.  A witness that need not be
-- canonical need not be well-defined on the quotient â” which is worth
-- keeping, because the instinct after building a quotient is to lift
-- everything in sight.
--
------------------------------------------------------------------------
