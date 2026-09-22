{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheInternalRulesPreserveIndependenceInThisCalculus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import GodelSeparation using (Theory ; Sent ; Pf ; neg ; prov ; Consistent ; OmegaBad)
open import IndependenceNeedsAnInternalImplication using (Independent)
open import ASmallTheoryWithAnIndependentSentence
  using (impB ; impB-refl ; impB-mp)
open import ADiagonalSentenceIndependentInAConcreteTheory
  using (S ; gs ; ng ; im ; pv ; sem₁ ; sem₂ ; P)

------------------------------------------------------------------------
-- TheInternalRulesPreserveIndependenceInThisCalculus
--
-- Independence survives the three internal rules.
--
-- ────────────────────────────────────────────────────────────────────
-- THE QUESTION
--
-- `ADiagonalSentenceIndependentInAConcreteTheory` gets `gs` independent
-- in a calculus with `taut`, `mp`, `hbl` and the two diagonal halves.
-- The natural test is to add the three internal rules
-- `TheDiagonalLemmaDischargesGoedelFix` needs — contraposition,
-- double-negation elimination, transitivity — and see which one kills
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
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  three Boolean lemmas: contraposition, double-negation
--       elimination, transitivity, all for `impB`.
--   §2  `Der⁺` — the previous calculus plus those three as rules — and
--       soundness for both models, by induction.
--   §3  so `gs` is still independent, and the calculus is still
--       consistent.
--   §4  and the abstract derivation finally has a concrete instance:
--       the internal fixed point `im (ng gs) (pv gs)` is DERIVABLE in
--       `Der⁺` (contraposition on `dbwd`, then transitivity with double
--       negation elimination), and ω-consistency holds here because
--       `pv gs` is underivable — `sem₂` refutes it, since `P gs` is
--       `false`.  So the hypotheses of
--       `TheDiagonalLemmaDischargesGoedelFix`'s second conjunct are all
--       met, and its conclusion agrees with §3's, which was obtained by
--       a completely different route.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE MEASUREMENT SAYS
--
-- ω-consistency is doing real work in the abstract derivation, and here
-- it HOLDS — because this calculus is too weak to derive `pv gs`.  So
-- this instance does not exhibit the tension Gdel's argument manages;
-- it exhibits the case where there is none.  A calculus that derives
-- `pv gs` without deriving `gs` would be ω-inconsistent, and that is
-- what a real arithmetic must avoid.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The three rules are propositionally valid
------------------------------------------------------------------------

contraB : (x y : Bool) → impB x y ≡ true → impB (not y) (not x) ≡ true
contraB false false _ = refl
contraB false true  _ = refl
contraB true  false h = Empty.rec (false≢true h)
contraB true  true  _ = refl

dneB : (x : Bool) → impB (not (not x)) x ≡ true
dneB false = refl
dneB true  = refl

transB : (x y z : Bool) → impB x y ≡ true → impB y z ≡ true → impB x z ≡ true
transB false y z _   _   = refl
transB true  y z hxy hyz = impB-mp true z (impB-mp-lemma) refl
  where
  yTrue : y ≡ true
  yTrue = hxy
  impB-mp-lemma : impB true z ≡ true
  impB-mp-lemma = subst (λ w → impB w z ≡ true) yTrue hyz

------------------------------------------------------------------------
-- 2.  The calculus with the three internal rules, and both models
------------------------------------------------------------------------

data Der⁺ : S → Type₀ where
  taut  : (a : S) → Der⁺ (im a a)
  mp    : (a b : S) → Der⁺ (im a b) → Der⁺ a → Der⁺ b
  hbl   : (a : S) → Der⁺ a → Der⁺ (pv a)
  dfwd  : Der⁺ (im gs (ng (pv gs)))
  dbwd  : Der⁺ (im (ng (pv gs)) gs)
  contra : (a b : S) → Der⁺ (im a b) → Der⁺ (im (ng b) (ng a))
  dne    : (a : S) → Der⁺ (im (ng (ng a)) a)
  trans  : (a b c : S) → Der⁺ (im a b) → Der⁺ (im b c) → Der⁺ (im a c)

sound₁⁺ : (s : S) → Der⁺ s → sem₁ s ≡ true
sound₁⁺ _ (taut a)         = impB-refl (sem₁ a)
sound₁⁺ _ (mp a b da db)   = impB-mp (sem₁ a) (sem₁ b) (sound₁⁺ (im a b) da) (sound₁⁺ a db)
sound₁⁺ _ (hbl a _)        = refl
sound₁⁺ _ dfwd             = refl
sound₁⁺ _ dbwd             = refl
sound₁⁺ _ (contra a b d)   = contraB (sem₁ a) (sem₁ b) (sound₁⁺ (im a b) d)
sound₁⁺ _ (dne a)          = dneB (sem₁ a)
sound₁⁺ _ (trans a b c d e) =
  transB (sem₁ a) (sem₁ b) (sem₁ c) (sound₁⁺ (im a b) d) (sound₁⁺ (im b c) e)

gsUnderivable⁺ : ¬ Der⁺ gs
gsUnderivable⁺ d = false≢true (sound₁⁺ gs d)

PmarksDerivable⁺ : (a : S) → Der⁺ a → P a ≡ true
PmarksDerivable⁺ gs       d = Empty.rec (gsUnderivable⁺ d)
PmarksDerivable⁺ (ng a)   _ = refl
PmarksDerivable⁺ (im a b) _ = refl
PmarksDerivable⁺ (pv a)   _ = refl

sound₂⁺ : (s : S) → Der⁺ s → sem₂ s ≡ true
sound₂⁺ _ (taut a)         = impB-refl (sem₂ a)
sound₂⁺ _ (mp a b da db)   = impB-mp (sem₂ a) (sem₂ b) (sound₂⁺ (im a b) da) (sound₂⁺ a db)
sound₂⁺ _ (hbl a d)        = PmarksDerivable⁺ a d
sound₂⁺ _ dfwd             = refl
sound₂⁺ _ dbwd             = refl
sound₂⁺ _ (contra a b d)   = contraB (sem₂ a) (sem₂ b) (sound₂⁺ (im a b) d)
sound₂⁺ _ (dne a)          = dneB (sem₂ a)
sound₂⁺ _ (trans a b c d e) =
  transB (sem₂ a) (sem₂ b) (sem₂ c) (sound₂⁺ (im a b) d) (sound₂⁺ (im b c) e)

negGsUnderivable⁺ : ¬ Der⁺ (ng gs)
negGsUnderivable⁺ d = false≢true (sound₂⁺ (ng gs) d)

------------------------------------------------------------------------
-- 3.  Independence survives all three rules
------------------------------------------------------------------------

Th⁺ : Theory ℓ-zero
Sent Th⁺ = S
Pf   Th⁺ = Der⁺
neg  Th⁺ = ng
prov Th⁺ = pv

gsIndependent⁺ : Independent Th⁺ gs
gsIndependent⁺ = gsUnderivable⁺ , negGsUnderivable⁺

consistent⁺ : Consistent Th⁺
consistent⁺ s ds dns =
  false≢true (sym (cong not (sound₁⁺ s ds)) ∙ sound₁⁺ (ng s) dns)

------------------------------------------------------------------------
-- 4.  The abstract derivation's hypotheses, all met concretely
------------------------------------------------------------------------

internalFix⁺ : Der⁺ (im (ng gs) (pv gs))
internalFix⁺ =
  trans (ng gs) (ng (ng (pv gs))) (pv gs)
    (contra (ng (pv gs)) gs dbwd)
    (dne (pv gs))

pvGsUnderivable : ¬ Der⁺ (pv gs)
pvGsUnderivable d = false≢true (sound₂⁺ (pv gs) d)

notOmegaBad⁺ : ¬ OmegaBad Th⁺ gs
notOmegaBad⁺ ob = pvGsUnderivable (fst ob)
