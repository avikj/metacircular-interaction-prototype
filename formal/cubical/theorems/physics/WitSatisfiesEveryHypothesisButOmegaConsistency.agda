{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module WitSatisfiesEveryHypothesisButOmegaConsistency where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg ; prov ; Consistent ; HBL1 ; OmegaBad
        ; W ; wtop ; wbot ; wg ; wng ; wneg ; wPf
        ; Wit ; witCon ; witHBL1 ; witProvesNegG ; witOmegaBad )
open import IndependenceNeedsAnInternalImplication
  using (Independent)
open import TheDiagonalLemmaDischargesGoedelFix
  using (HasDiagonal ; goedelSentence ; imp)
open import RepresentabilityIsNotEnoughForIndependence
  using (wimp ; wmp ; witHasDiagonal ; witNotIndependent)

------------------------------------------------------------------------
-- WitSatisfiesEveryHypothesisButOmegaConsistency
--
-- `TheDiagonalLemmaDischargesGoedelFix` derives independence from six
-- things: consistency, HBL1, representability, and three internal rules
-- â” contraposition, double-negation elimination, transitivity â” plus
-- Ï‰-consistency.  `RepresentabilityIsNotEnoughForIndependence` showed
-- the first three are satisfied by a model where independence fails.
-- This checks the three internal rules in that same model.
--
-- All three hold.  So `Wit` satisfies EVERY hypothesis of that
-- derivation except Ï‰-consistency, and fails independence.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THE THREE HOLD, WHICH IS NOT AN ACCIDENT OF THE MODEL
--
-- `wPf (wimp a b)` is inhabited exactly when provability of `a` entails
-- provability of `b` (Â§1, both directions).  `wneg` is an involution
-- and `wPf (wneg s)` is inhabited exactly when `wPf s` is not (Â§2).  So
-- the four sentences carry a two-valued classical propositional
-- semantics, and the three rules are its standard validities.  A model
-- built to be Ï‰-inconsistent is not thereby built to be
-- propositionally deviant, and it is not.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  `wimp` is exactly entailment of provability
--
-- One direction is `wmp`.  The other is by exhaustion; the two
-- unprovable antecedents are uniform, so ten clauses suffice.
------------------------------------------------------------------------

impIntro : (a b : W) â†’ (wPf a â†’ wPf b) â†’ wPf (wimp a b)
impIntro wbot _    _ = tt
impIntro wg   _    _ = tt
impIntro wtop wtop _ = tt
impIntro wtop wng  _ = tt
impIntro wtop wbot h = Empty.rec (h tt)
impIntro wtop wg   h = Empty.rec (h tt)
impIntro wng  wtop _ = tt
impIntro wng  wng  _ = tt
impIntro wng  wbot h = Empty.rec (h tt)
impIntro wng  wg   h = Empty.rec (h tt)

------------------------------------------------------------------------
-- 2.  `wneg` is an involution, and negates provability
------------------------------------------------------------------------

wnegInvol : (s : W) â†’ wneg (wneg s) â‰¡ s
wnegInvol wtop = refl
wnegInvol wbot = refl
wnegInvol wg   = refl
wnegInvol wng  = refl

negPfâ†’ : (s : W) â†’ wPf (wneg s) â†’ Â¬ wPf s
negPfâ†’ wtop p  = Î» _ â†’ p
negPfâ†’ wbot _  = Î» q â†’ q
negPfâ†’ wg   _  = Î» q â†’ q
negPfâ†’ wng  p  = Î» _ â†’ p

â†’negPf : (s : W) â†’ (Â¬ wPf s) â†’ wPf (wneg s)
â†’negPf wtop h = Empty.rec (h tt)
â†’negPf wbot _ = tt
â†’negPf wg   _ = tt
â†’negPf wng  h = Empty.rec (h tt)

------------------------------------------------------------------------
-- 3.  The three internal rules, in `Wit`
------------------------------------------------------------------------

witTrans : (a b c : Sent Wit)
         â†’ Pf Wit (imp witHasDiagonal a b)
         â†’ Pf Wit (imp witHasDiagonal b c)
         â†’ Pf Wit (imp witHasDiagonal a c)
witTrans a b c hab hbc =
  impIntro a c (Î» pa â†’ wmp b c hbc (wmp a b hab pa))

witContra : (a b : Sent Wit)
          â†’ Pf Wit (imp witHasDiagonal a b)
          â†’ Pf Wit (imp witHasDiagonal (neg Wit b) (neg Wit a))
witContra a b hab =
  impIntro (wneg b) (wneg a)
    (Î» pnb â†’ â†’negPf a (Î» pa â†’ negPfâ†’ b pnb (wmp a b hab pa)))

witDne : (a : Sent Wit)
       â†’ Pf Wit (imp witHasDiagonal (neg Wit (neg Wit a)) a)
witDne a =
  impIntro (wneg (wneg a)) a (Î» p â†’ subst wPf (wnegInvol a) p)

------------------------------------------------------------------------
-- 4.  So Ï‰-consistency is the one hypothesis the derivation needs and
--     this model does not have
------------------------------------------------------------------------

omegaConsistencyIsTheSeparatingHypothesis :
  ( (T : Theory â„“-zero) (D : HasDiagonal T)
    â†’ Consistent T â†’ HBL1 T
    â†’ ((a b : Sent T) â†’ Pf T (imp D a b)
                      â†’ Pf T (imp D (neg T b) (neg T a)))
    â†’ ((a : Sent T) â†’ Pf T (imp D (neg T (neg T a)) a))
    â†’ ((a b c : Sent T) â†’ Pf T (imp D a b) â†’ Pf T (imp D b c)
                        â†’ Pf T (imp D a c))
    â†’ Independent T (goedelSentence T D) )
  â†’ âŠ¥
omegaConsistencyIsTheSeparatingHypothesis f =
  witNotIndependent
    (f Wit witHasDiagonal witCon witHBL1 witContra witDne witTrans)

-- and the hypothesis that is absent, as a term rather than as prose
theAbsentHypothesis : OmegaBad Wit wg
theAbsentHypothesis = witOmegaBad

------------------------------------------------------------------------
-- `Wit` also fails independence for a second, unrelated reason:
-- `AProvabilityDeterminedImplicationForbidsIndependence` proves that
-- any theory whose internal implication is provability-determined
-- (`impIntro` here) and which has contraposition and an unprovable
-- sentence with provable negation has NO independent sentence at all,
-- whatever its Ï‰-status.  `Wit` is in that class, by `impIntro` and
-- `witContra`, both proved above.  Â§4 is a correct separation of
-- Ï‰-consistency from the other five hypotheses.
--
-- The separation of Ï‰-consistency by a PAIR of concrete calculi
-- differing in exactly that hypothesis is elsewhere in the corpus:
--
--   `TheInternalRulesPreserveIndependenceInThisCalculus`: Ï‰-consistency
--   HOLDS (`pv gs` is underivable) and `gs` is independent;
--
--   `TheOmegaInconsistentExtensionDerivesTheNegation`: the same
--   calculus plus double-negation introduction and the axiom `pv gs`;
--   Ï‰-consistency FAILS, the first conjunct still holds, and `ng gs` is
--   DERIVED in three steps.
--
-- Same connectives, same diagonal pair, same first conjunct; the second
-- conjunct changes with Ï‰-consistency and with nothing else that was
-- varied.
------------------------------------------------------------------------
