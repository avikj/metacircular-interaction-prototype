{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheOmegaInconsistentExtensionDerivesTheNegation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; falseâ‰¢true)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)
open import GodelSeparation using (Theory ; Sent ; Pf ; neg ; prov ; Consistent ; OmegaBad)
open import IndependenceNeedsAnInternalImplication using (Independent)
open import ASmallTheoryWithAnIndependentSentence
  using (impB ; impB-refl ; impB-mp)
open import ADiagonalSentenceIndependentInAConcreteTheory
  using (S ; gs ; ng ; im ; pv ; semâ‚)
open import TheInternalRulesPreserveIndependenceInThisCalculus
  using (contraB ; dneB ; transB)

------------------------------------------------------------------------
-- TheOmegaInconsistentExtensionDerivesTheNegation
--
-- The case the previous module said it did not exhibit: a calculus that
-- derives `pv gs` without deriving `gs`.  It is Ï‰-inconsistent by
-- construction, it is still consistent, and it DERIVES `ng gs`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT WAS PREDICTED AND WHAT HAPPENED
--
-- Prediction before building: adding the axiom `pv gs` would break the
-- syntax-indexed model (which marks `gs` unprovable) and thereby the
-- second conjunct, while the truth-functional model would survive and
-- keep the first.  That is what happened.  Additionally â” not predicted
-- â” `ng gs` becomes DERIVABLE once double-negation INTRODUCTION is
-- available, so the failure is not merely a lost proof: independence is
-- refuted outright (Â§4).
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  `DerÂ°` â” the previous calculus plus double-negation
--       introduction and the axiom `pv gs`.
--   Â§2  the truth-functional model is still sound, so `Â DerÂ° gs`: the
--       FIRST conjunct survives untouched, and the calculus is still
--       consistent.
--   Â§3  `DerÂ° (ng gs)`, in three steps: `dni` on the axiom gives
--       `ÂÂ pv gs`; contraposition on `dfwd` gives `ÂÂ pv gs â’ Â gs`;
--       modus ponens.
--   Â§4  so independence FAILS at `gs`, and `OmegaBad` holds â” `pv gs`
--       derivable, `gs` not.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS CONFIRMS ACROSS THE ABSTRACT/CONCRETE DIVIDE
--
-- `GodelSeparation.noHalfTwo` refutes the second conjunct from
-- consistency, HBL1 and the fixed point, using the four-sentence
-- countermodel `Wit`, whose Ï‰-inconsistency is recorded as
-- `witOmegaBad` and which proves `Âg` by fiat of its truth table.  Â§3
-- is the same phenomenon with a DERIVATION in place of a truth table:
-- the negation is not stipulated, it is deduced, and the deduction uses
-- exactly the Ï‰-inconsistency.
--
-- And it confirms the previous module's reading from the other side.
-- There, Ï‰-consistency held and the second conjunct survived; here it
-- fails and the second conjunct is refuted.  The hypothesis was doing
-- work, and this is the instance where removing it changes the answer â”
-- which is what `WitSatisfiesEveryHypothesisButOmegaConsistency` could
-- not show, its witness being overdetermined.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE HONEST LIMIT, INHERITED AND UNCHANGED
--
-- Not Gdel's theorem.  `hbl` is a RULE, not a proved derivability
-- condition; `pv` is uninterpreted; the Ï‰-inconsistency is an AXIOM
-- rather than something forced by arithmetic, which is the whole
-- difference between this and a theory anyone would use.  What is shown
-- is that the shape of the argument behaves as the abstract modules
-- said it would, in a calculus small enough to check.
--
-- Also inherited: `gs` was independent in the weaker calculus partly
-- because the rules were few, and Â§3 shows one more rule plus one axiom
-- is enough to end that.
--
-- PRIOR ART, grep run and quoted: searching `formal/cubical` for
-- `omega-inconsistent`, `OmegaInconsistent`, `dni` and `DerÂ°` returns
-- nothing at all.  A version adding the axiom as a hypothesis of a
-- parameter block rather than as a constructor would evade that grep.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The calculus, with double-negation introduction and the axiom
------------------------------------------------------------------------

data DerÂ° : S â†’ Typeâ‚€ where
  taut   : (a : S) â†’ DerÂ° (im a a)
  mp     : (a b : S) â†’ DerÂ° (im a b) â†’ DerÂ° a â†’ DerÂ° b
  hbl    : (a : S) â†’ DerÂ° a â†’ DerÂ° (pv a)
  dfwd   : DerÂ° (im gs (ng (pv gs)))
  dbwd   : DerÂ° (im (ng (pv gs)) gs)
  contra : (a b : S) â†’ DerÂ° (im a b) â†’ DerÂ° (im (ng b) (ng a))
  dne    : (a : S) â†’ DerÂ° (im (ng (ng a)) a)
  dni    : (a : S) â†’ DerÂ° (im a (ng (ng a)))
  trans  : (a b c : S) â†’ DerÂ° (im a b) â†’ DerÂ° (im b c) â†’ DerÂ° (im a c)
  omega  : DerÂ° (pv gs)

------------------------------------------------------------------------
-- 2.  The truth-functional model survives, so the first conjunct does
------------------------------------------------------------------------

dniB : (x : Bool) â†’ impB x (not (not x)) â‰¡ true
dniB false = refl
dniB true  = refl

soundÂ° : (s : S) â†’ DerÂ° s â†’ semâ‚ s â‰¡ true
soundÂ° _ (taut a)          = impB-refl (semâ‚ a)
soundÂ° _ (mp a b da db)    = impB-mp (semâ‚ a) (semâ‚ b) (soundÂ° (im a b) da) (soundÂ° a db)
soundÂ° _ (hbl a _)         = refl
soundÂ° _ dfwd              = refl
soundÂ° _ dbwd              = refl
soundÂ° _ (contra a b d)    = contraB (semâ‚ a) (semâ‚ b) (soundÂ° (im a b) d)
soundÂ° _ (dne a)           = dneB (semâ‚ a)
soundÂ° _ (dni a)           = dniB (semâ‚ a)
soundÂ° _ (trans a b c d e) =
  transB (semâ‚ a) (semâ‚ b) (semâ‚ c) (soundÂ° (im a b) d) (soundÂ° (im b c) e)
soundÂ° _ omega             = refl

gsUnderivableÂ° : Â¬ DerÂ° gs
gsUnderivableÂ° d = falseâ‰¢true (soundÂ° gs d)

------------------------------------------------------------------------
-- 3.  â¦and the negation is DERIVABLE
------------------------------------------------------------------------

doubleNegProv : DerÂ° (ng (ng (pv gs)))
doubleNegProv = mp (pv gs) (ng (ng (pv gs))) (dni (pv gs)) omega

negGsDerivable : DerÂ° (ng gs)
negGsDerivable =
  mp (ng (ng (pv gs))) (ng gs)
     (contra gs (ng (pv gs)) dfwd)
     doubleNegProv

------------------------------------------------------------------------
-- 4.  So independence fails, and Ï‰-consistency is what failed
------------------------------------------------------------------------

ThÂ° : Theory â„“-zero
Sent ThÂ° = S
Pf   ThÂ° = DerÂ°
neg  ThÂ° = ng
prov ThÂ° = pv

notIndependentÂ° : Â¬ Independent ThÂ° gs
notIndependentÂ° ind = snd ind negGsDerivable

omegaBadÂ° : OmegaBad ThÂ° gs
omegaBadÂ° = omega , gsUnderivableÂ°

consistentÂ° : Consistent ThÂ°
consistentÂ° s ds dns =
  falseâ‰¢true (sym (cong not (soundÂ° s ds)) âˆ™ soundÂ° (ng s) dns)
