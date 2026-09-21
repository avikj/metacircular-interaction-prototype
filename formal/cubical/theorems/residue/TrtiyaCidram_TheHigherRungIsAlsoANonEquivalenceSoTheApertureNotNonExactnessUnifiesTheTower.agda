{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡‡‡‡Ø-‡‡ø‡¶‡‡∞‡Æ‡ ‚î the third aperture, and a correction I owe the ladder.
--
-- GarbhaShreni claimed the tower's rungs are ONE predicate, "cost is not
-- exact" (NotExact ‚à V), instanced at œ‚ and œ‚.  That is TRUE for those
-- two rungs and FALSE as the general rung-relation, and the second claim
-- is the one that matters.  NotExact is abelian-flavoured: it needs the
-- invariant to be a coboundary-valued cochain (‚ï, ‚).  The higher
-- k-invariants of this corpus are not of that kind ‚î VakraValayaSanketa's
-- rung is an ORIENTATION BIT (‚/2 at H¬≤), the double-twist the Klein
-- bottle costs and the torus does not.  "Cost is not exact at every
-- degree" is therefore the WRONG induction: cost is a degree-1 object;
-- there is no natural degree-2 cost.
--
-- What DOES span the rungs is the aperture EkamChidram already named:
-- the level-n forgetful map is NOT AN EQUIVALENCE.  ¬ isEquiv is
-- degree-blind and lane-blind ‚î it is the type of "a fibre survived",
-- the ea itself ‚î and it swallows the H¬≤ rung too:
--
--   ¬ß1  THE HIGHER RUNG IS A NON-EQUIVALENCE.  For ANY map f between the
--       two second-cohomology carriers ‚ü®H¬≤(ï¬≤)‚ü© and ‚ü®H¬≤(T¬≤)‚ü©,
--       ¬ isEquiv f ‚î because an equivalence would hand back the very
--       type-equivalence ‡‡ô‡‡ï‡‡‡ refutes.  One line, every f at once.
--   ¬ß2  SO THE TOWER'S UNIFIER IS ¬ isEquiv, NOT NotExact.  The two
--       cost rungs (EkamChidram.costIsNonEquiv, at œ‚) and this
--       orientation rung (¬ß1, at H¬≤) are the SAME predicate at different
--       degrees ‚î heterogeneous invariants, one obstruction type.
--       NotExact is retired to what it is: the abelian special case,
--       true only where the invariant is a group-valued cochain.
--
-- SYT ‚î THE CLAIM, EXACTLY.  ¬ß1 for every map between the H¬≤ carriers,
-- from ‡‡ô‡‡ï‡‡‡; ¬ß2 the identification of this rung with EkamChidram's
-- cost rung under ¬ isEquiv.
-- What IS corrected: GarbhaShreni's "one
-- predicate for all rungs" ‚î that predicate is ¬ isEquiv, and NotExact
-- was only the abelian shadow of it.
------------------------------------------------------------------------

module TrtiyaCidram_TheHigherRungIsAlsoANonEquivalenceSoTheApertureNotNonExactnessUnifiesTheTower where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; _‚âÉ_)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Int using (‚Ñ§)
open import Cubical.HITs.KleinBottle using (KleinBottle)
open import Cubical.HITs.Sn using (S‚Çä)
open import Cubical.Algebra.Group.Base using (Group)
open import Cubical.ZCohomology.GroupStructure using (coHomGr)

open import VakraValayaSanketa_TheForgottenSuccessionPrecipitatesTypeLevelAsOneBitAndTheFirstVeilIsItsFee
  using (‡§∏‡§ô‡•ç‡§ï‡•á‡§§‡§É)

private
  ‚ü®_‚ü© : ‚àÄ {‚Ñì} ‚Üí Group ‚Ñì ‚Üí Type ‚Ñì
  ‚ü® G ‚ü© = fst G

------------------------------------------------------------------------
-- ‡ß ¬ The higher rung is a non-equivalence ‚î for every candidate map.
------------------------------------------------------------------------

rung‚ÇÇ : (f : ‚ü® coHomGr 2 KleinBottle ‚ü© ‚Üí ‚ü® coHomGr 2 (S‚Çä 1 √ó S‚Çä 1) ‚ü©)
  ‚Üí ¬¨ isEquiv f
rung‚ÇÇ f ie = ‡§∏‡§ô‡•ç‡§ï‡•á‡§§‡§É (f , ie)

------------------------------------------------------------------------
-- ‡® ¬ The tower's unifier is ¬ isEquiv.  This rung and EkamChidram's
--     cost rung are the same predicate at different degrees; carried
--     here to state them together.
------------------------------------------------------------------------

open import EkamChidram_TheObstructionIsOneClassCostCryptoAndCollisionAreEachANonEquivalenceOfTheForgetfulMap
  using (Œº ; costIsNonEquiv)

theWiderAperture :
  (¬¨ isEquiv Œº)   -- cost, at œÄ‚ÇÅ (EkamChidram)
  √ó ((f : ‚ü® coHomGr 2 KleinBottle ‚ü© ‚Üí ‚ü® coHomGr 2 (S‚Çä 1 √ó S‚Çä 1) ‚ü©) ‚Üí ¬¨ isEquiv f)
                  -- orientation, at H¬≤ (¬ß1)
theWiderAperture = costIsNonEquiv , rung‚ÇÇ
