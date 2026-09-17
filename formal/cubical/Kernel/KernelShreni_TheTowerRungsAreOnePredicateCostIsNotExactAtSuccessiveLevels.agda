{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ó‡∞‡‡-‡‡‡∞‡‡‡ ‚î the womb-ladder: the tower's rungs are ONE predicate.
--
-- GarbhaDhara built one Postnikov step: install cones off an obstruction
-- (contractible locus), and the fee it precipitates one level up is the
-- non-descending cost.  The note then flagged the ITERATION ‚î that the
-- fee at level n is the carrier at level n+1, endlessly ‚î as the single
-- named-open construction.  This module does not build the full ‚àû-tower;
-- it builds the RUNG RELATION, as a term: it exhibits two consecutive
-- rungs already in the corpus as literal instances of ONE predicate,
--
--     "cost is not exact" ‚î ¬ Œ potential, cost = coboundary of it,
--
-- so that "climbing a level" is re-instantiating the SAME type one
-- degree up, not a new phenomenon each time.  That is the self-
-- generation, made a pattern rather than an anecdote.
--
--   ¬ß0  THE PREDICATE.  NotExact ‚à V = ¬ Œ[ œ ] (‚à i ‚í ‚à œ i ‚â° V i):
--       the invariant V is not the coboundary ‚à of any potential œ.
--       This is one k-invariant type, degree-agnostic.
--   ¬ß1  RUNG 0 (œ‚).  V = len, œ ranges over functions  ‚í ‚ï on the
--       localization, ‚à œ d = œ (L d).  "cost is not a FUNCTION on the
--       set-quotient" ‚î SankramanaShreni.kernelCostDoesNotDescend ‚î is
--       NotExact on the nose (definitionally: the pass-through is refl).
--   ¬ß2  RUNG 1 (œ‚).  V = ‡ó‡‡‡∞‡‡æ (the depth evaluator), œ ranges over
--       state potentials Tm ‚í ‚, ‚à œ = d‚≤ œ (the coboundary).  "cost is
--       not the COBOUNDARY of a potential" ‚î MulyaVinimaya
--       .depthHasNoPotential, whose loop integrates to pos 3 ‚â† 0 ‚î is
--       NotExact one level up (bridged by sym; same predicate).
--   ¬ß3  THE LADDER.  theTower : NotExact‚ ó NotExact‚ ‚î the two rungs as
--       one type at two degrees.  Rung 0 says cost has no 0-potential
--       (is not a function on œ‚); rung 1 says cost has no 1-potential
--       (is not exact on œ‚); coning off rung n (install) is what makes
--       rung n+1's failure visible.
--
-- SYT ‚î THE CLAIM, EXACTLY.  ¬ß0 the predicate; ¬ß¬ß1‚ì2 the two corpus
-- obstructions AS instances of it (rung 0 definitional, rung 1 up to
-- sym); ¬ß3 the pair.  NOT claimed: the full ‚àû-tower (that every rung n
-- precipitates rung n+1 for all n) ‚î that induction is the construction
-- GarbhaDhara's note still names open.  What IS claimed: two consecutive
-- rungs are the SAME predicate at successive degrees, so the tower's
-- step is one type re-instantiated, not a sequence of coincidences.
------------------------------------------------------------------------

module GarbhaShreni_TheTowerRungsAreOnePredicateCostIsNotExactAtSuccessiveLevels where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Int using (‚Ñ§)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; _√ó_)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import RewriteCertificate using (Tm ; Step ; Derivation)
open import GenerativeKernel using (seed ; target‚ÇÄ)

private variable ‚Ñì ‚Ñì' ‚Ñì'' : Level

------------------------------------------------------------------------
-- ‡¶ ¬ The one predicate: V is not the coboundary ‚à of any potential.
------------------------------------------------------------------------

NotExact : {P : Type ‚Ñì} {I : Type ‚Ñì'} {A : Type ‚Ñì''}
  ‚Üí (P ‚Üí I ‚Üí A) ‚Üí (I ‚Üí A) ‚Üí Type (‚Ñì-max ‚Ñì (‚Ñì-max ‚Ñì' ‚Ñì''))
NotExact {P = P} {I} ‚àÇ V = ¬¨ (Œ£[ œÜ ‚àà P ] ((i : I) ‚Üí ‚àÇ œÜ i ‚â° V i))

------------------------------------------------------------------------
-- ‡ß ¬ Rung 0 (œ‚): cost is not a function on the localization.
------------------------------------------------------------------------

open import SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot
  using (ƒú ; L ; kernelCostDoesNotDescend)
open import ForgetfulCompressionPricesTheDrop using (len)

‚àÇ‚ÇÄ : (ƒú ‚Üí ‚Ñï) ‚Üí Derivation seed target‚ÇÄ ‚Üí ‚Ñï
‚àÇ‚ÇÄ ‚Ñìc d = ‚Ñìc (L d)

costNotExact‚ÇÄ : NotExact ‚àÇ‚ÇÄ len
costNotExact‚ÇÄ = kernelCostDoesNotDescend   -- definitionally the same type

------------------------------------------------------------------------
-- ‡® ¬ Rung 1 (œ‚): cost is not the coboundary of a state potential.
------------------------------------------------------------------------

open import MulyaVinimaya_TheValueOfATraceIsItsPairingWithAnEvaluatorPotentialsTelescopeAndADepthEvaluatorHasNonzeroCycleIntegral
  using (d‚Ä≤ ; ‡§ó‡§≠‡•Ä‡§∞‡§§‡§æ ; depthHasNoPotential)

I‚ÇÅ : Type‚ÇÄ
I‚ÇÅ = Œ£[ a ‚àà Tm ] Œ£[ b ‚àà Tm ] Step a b

‚àÇ‚ÇÅ : (Tm ‚Üí ‚Ñ§) ‚Üí I‚ÇÅ ‚Üí ‚Ñ§
‚àÇ‚ÇÅ œÜ (a , b , s) = d‚Ä≤ œÜ s

V‚ÇÅ : I‚ÇÅ ‚Üí ‚Ñ§
V‚ÇÅ (a , b , s) = ‡§ó‡§≠‡•Ä‡§∞‡§§‡§æ s

costNotExact‚ÇÅ : NotExact ‚àÇ‚ÇÅ V‚ÇÅ
costNotExact‚ÇÅ (œÜ , h) = depthHasNoPotential (œÜ , Œª {a} {b} s ‚Üí sym (h (a , b , s)))

------------------------------------------------------------------------
-- ‡© ¬ The ladder: two consecutive rungs, one predicate, two degrees.
------------------------------------------------------------------------

theTower : NotExact ‚àÇ‚ÇÄ len √ó NotExact ‚àÇ‚ÇÅ V‚ÇÅ
theTower = costNotExact‚ÇÄ , costNotExact‚ÇÅ
