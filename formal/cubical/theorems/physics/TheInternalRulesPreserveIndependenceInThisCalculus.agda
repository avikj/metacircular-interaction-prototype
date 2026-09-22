{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheInternalRulesPreserveIndependenceInThisCalculus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false‚â¢true)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)
open import GodelSeparation using (Theory ; Sent ; Pf ; neg ; prov ; Consistent ; OmegaBad)
open import IndependenceNeedsAnInternalImplication using (Independent)
open import ASmallTheoryWithAnIndependentSentence
  using (impB ; impB-refl ; impB-mp)
open import ADiagonalSentenceIndependentInAConcreteTheory
  using (S ; gs ; ng ; im ; pv ; sem‚ÇÅ ; sem‚ÇÇ ; P)

------------------------------------------------------------------------
-- TheInternalRulesPreserveIndependenceInThisCalculus
--
-- Independence survives the three internal rules.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE QUESTION
--
-- `ADiagonalSentenceIndependentInAConcreteTheory` gets `gs` independent
-- in a calculus with `taut`, `mp`, `hbl` and the two diagonal halves.
-- The natural test is to add the three internal rules
-- `TheDiagonalLemmaDischargesGoedelFix` needs ‚î contraposition,
-- double-negation elimination, transitivity ‚î and see which one kills
-- independence.
--
-- ALL
-- THREE are sound in BOTH models, and independence survives all of
-- them.
--
-- The reason, once seen, is not an accident of these models: the
-- soundness of contraposition, of double-negation elimination and of
-- transitivity are facts about `impB` and `not` on `Bool` alone.  They
-- say nothing about how `pv` is interpreted, and `pv` is the only place
-- the two models differ.  A rule whose soundness is a propositional
-- tautology cannot distinguish two models that agree on the
-- propositional connectives.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß1  three Boolean lemmas: contraposition, double-negation
--       elimination, transitivity, all for `impB`.
--   ¬ß2  `Der‚∫` ‚î the previous calculus plus those three as rules ‚î and
--       soundness for both models, by induction.
--   ¬ß3  so `gs` is still independent, and the calculus is still
--       consistent.
--   ¬ß4  and the abstract derivation finally has a concrete instance:
--       the internal fixed point `im (ng gs) (pv gs)` is DERIVABLE in
--       `Der‚∫` (contraposition on `dbwd`, then transitivity with double
--       negation elimination), and œâ-consistency holds here because
--       `pv gs` is underivable ‚î `sem‚` refutes it, since `P gs` is
--       `false`.  So the hypotheses of
--       `TheDiagonalLemmaDischargesGoedelFix`'s second conjunct are all
--       met, and its conclusion agrees with ¬ß3's, which was obtained by
--       a completely different route.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THE MEASUREMENT SAYS
--
-- œâ-consistency is doing real work in the abstract derivation, and here
-- it HOLDS ‚î because this calculus is too weak to derive `pv gs`.  So
-- this instance does not exhibit the tension Gdel's argument manages;
-- it exhibits the case where there is none.  A calculus that derives
-- `pv gs` without deriving `gs` would be œâ-inconsistent, and that is
-- what a real arithmetic must avoid.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The three rules are propositionally valid
------------------------------------------------------------------------

contraB : (x y : Bool) ‚Üí impB x y ‚â° true ‚Üí impB (not y) (not x) ‚â° true
contraB false false _ = refl
contraB false true  _ = refl
contraB true  false h = Empty.rec (false‚â¢true h)
contraB true  true  _ = refl

dneB : (x : Bool) ‚Üí impB (not (not x)) x ‚â° true
dneB false = refl
dneB true  = refl

transB : (x y z : Bool) ‚Üí impB x y ‚â° true ‚Üí impB y z ‚â° true ‚Üí impB x z ‚â° true
transB false y z _   _   = refl
transB true  y z hxy hyz = impB-mp true z (impB-mp-lemma) refl
  where
  yTrue : y ‚â° true
  yTrue = hxy
  impB-mp-lemma : impB true z ‚â° true
  impB-mp-lemma = subst (Œª w ‚Üí impB w z ‚â° true) yTrue hyz

------------------------------------------------------------------------
-- 2.  The calculus with the three internal rules, and both models
------------------------------------------------------------------------

data Der‚Å∫ : S ‚Üí Type‚ÇÄ where
  taut  : (a : S) ‚Üí Der‚Å∫ (im a a)
  mp    : (a b : S) ‚Üí Der‚Å∫ (im a b) ‚Üí Der‚Å∫ a ‚Üí Der‚Å∫ b
  hbl   : (a : S) ‚Üí Der‚Å∫ a ‚Üí Der‚Å∫ (pv a)
  dfwd  : Der‚Å∫ (im gs (ng (pv gs)))
  dbwd  : Der‚Å∫ (im (ng (pv gs)) gs)
  contra : (a b : S) ‚Üí Der‚Å∫ (im a b) ‚Üí Der‚Å∫ (im (ng b) (ng a))
  dne    : (a : S) ‚Üí Der‚Å∫ (im (ng (ng a)) a)
  trans  : (a b c : S) ‚Üí Der‚Å∫ (im a b) ‚Üí Der‚Å∫ (im b c) ‚Üí Der‚Å∫ (im a c)

sound‚ÇÅ‚Å∫ : (s : S) ‚Üí Der‚Å∫ s ‚Üí sem‚ÇÅ s ‚â° true
sound‚ÇÅ‚Å∫ _ (taut a)         = impB-refl (sem‚ÇÅ a)
sound‚ÇÅ‚Å∫ _ (mp a b da db)   = impB-mp (sem‚ÇÅ a) (sem‚ÇÅ b) (sound‚ÇÅ‚Å∫ (im a b) da) (sound‚ÇÅ‚Å∫ a db)
sound‚ÇÅ‚Å∫ _ (hbl a _)        = refl
sound‚ÇÅ‚Å∫ _ dfwd             = refl
sound‚ÇÅ‚Å∫ _ dbwd             = refl
sound‚ÇÅ‚Å∫ _ (contra a b d)   = contraB (sem‚ÇÅ a) (sem‚ÇÅ b) (sound‚ÇÅ‚Å∫ (im a b) d)
sound‚ÇÅ‚Å∫ _ (dne a)          = dneB (sem‚ÇÅ a)
sound‚ÇÅ‚Å∫ _ (trans a b c d e) =
  transB (sem‚ÇÅ a) (sem‚ÇÅ b) (sem‚ÇÅ c) (sound‚ÇÅ‚Å∫ (im a b) d) (sound‚ÇÅ‚Å∫ (im b c) e)

gsUnderivable‚Å∫ : ¬¨ Der‚Å∫ gs
gsUnderivable‚Å∫ d = false‚â¢true (sound‚ÇÅ‚Å∫ gs d)

PmarksDerivable‚Å∫ : (a : S) ‚Üí Der‚Å∫ a ‚Üí P a ‚â° true
PmarksDerivable‚Å∫ gs       d = Empty.rec (gsUnderivable‚Å∫ d)
PmarksDerivable‚Å∫ (ng a)   _ = refl
PmarksDerivable‚Å∫ (im a b) _ = refl
PmarksDerivable‚Å∫ (pv a)   _ = refl

sound‚ÇÇ‚Å∫ : (s : S) ‚Üí Der‚Å∫ s ‚Üí sem‚ÇÇ s ‚â° true
sound‚ÇÇ‚Å∫ _ (taut a)         = impB-refl (sem‚ÇÇ a)
sound‚ÇÇ‚Å∫ _ (mp a b da db)   = impB-mp (sem‚ÇÇ a) (sem‚ÇÇ b) (sound‚ÇÇ‚Å∫ (im a b) da) (sound‚ÇÇ‚Å∫ a db)
sound‚ÇÇ‚Å∫ _ (hbl a d)        = PmarksDerivable‚Å∫ a d
sound‚ÇÇ‚Å∫ _ dfwd             = refl
sound‚ÇÇ‚Å∫ _ dbwd             = refl
sound‚ÇÇ‚Å∫ _ (contra a b d)   = contraB (sem‚ÇÇ a) (sem‚ÇÇ b) (sound‚ÇÇ‚Å∫ (im a b) d)
sound‚ÇÇ‚Å∫ _ (dne a)          = dneB (sem‚ÇÇ a)
sound‚ÇÇ‚Å∫ _ (trans a b c d e) =
  transB (sem‚ÇÇ a) (sem‚ÇÇ b) (sem‚ÇÇ c) (sound‚ÇÇ‚Å∫ (im a b) d) (sound‚ÇÇ‚Å∫ (im b c) e)

negGsUnderivable‚Å∫ : ¬¨ Der‚Å∫ (ng gs)
negGsUnderivable‚Å∫ d = false‚â¢true (sound‚ÇÇ‚Å∫ (ng gs) d)

------------------------------------------------------------------------
-- 3.  Independence survives all three rules
------------------------------------------------------------------------

Th‚Å∫ : Theory ‚Ñì-zero
Sent Th‚Å∫ = S
Pf   Th‚Å∫ = Der‚Å∫
neg  Th‚Å∫ = ng
prov Th‚Å∫ = pv

gsIndependent‚Å∫ : Independent Th‚Å∫ gs
gsIndependent‚Å∫ = gsUnderivable‚Å∫ , negGsUnderivable‚Å∫

consistent‚Å∫ : Consistent Th‚Å∫
consistent‚Å∫ s ds dns =
  false‚â¢true (sym (cong not (sound‚ÇÅ‚Å∫ s ds)) ‚àô sound‚ÇÅ‚Å∫ (ng s) dns)

------------------------------------------------------------------------
-- 4.  The abstract derivation's hypotheses, all met concretely
------------------------------------------------------------------------

internalFix‚Å∫ : Der‚Å∫ (im (ng gs) (pv gs))
internalFix‚Å∫ =
  trans (ng gs) (ng (ng (pv gs))) (pv gs)
    (contra (ng (pv gs)) gs dbwd)
    (dne (pv gs))

pvGsUnderivable : ¬¨ Der‚Å∫ (pv gs)
pvGsUnderivable d = false‚â¢true (sound‚ÇÇ‚Å∫ (pv gs) d)

notOmegaBad‚Å∫ : ¬¨ OmegaBad Th‚Å∫ gs
notOmegaBad‚Å∫ ob = pvGsUnderivable (fst ob)
