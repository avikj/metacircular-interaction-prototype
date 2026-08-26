{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheOmegaInconsistentExtensionDerivesTheNegation where

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
  using (S ; gs ; ng ; im ; pv ; sem₁)
open import TheInternalRulesPreserveIndependenceInThisCalculus
  using (contraB ; dneB ; transB)

------------------------------------------------------------------------
-- TheOmegaInconsistentExtensionDerivesTheNegation
--
-- The case the previous module said it did not exhibit: a calculus that
-- derives `pv gs` without deriving `gs`.  It is ω-inconsistent by
-- construction, it is still consistent, and it DERIVES `ng gs`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT WAS PREDICTED AND WHAT HAPPENED
--
-- Prediction before building: adding the axiom `pv gs` would break the
-- syntax-indexed model (which marks `gs` unprovable) and thereby the
-- second conjunct, while the truth-functional model would survive and
-- keep the first.  That is what happened.  Additionally — not predicted
-- — `ng gs` becomes DERIVABLE once double-negation INTRODUCTION is
-- available, so the failure is not merely a lost proof: independence is
-- refuted outright (§4).
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `Der°` — the previous calculus plus double-negation
--       introduction and the axiom `pv gs`.
--   §2  the truth-functional model is still sound, so `¬ Der° gs`: the
--       FIRST conjunct survives untouched, and the calculus is still
--       consistent.
--   §3  `Der° (ng gs)`, in three steps: `dni` on the axiom gives
--       `¬¬ pv gs`; contraposition on `dfwd` gives `¬¬ pv gs → ¬ gs`;
--       modus ponens.
--   §4  so independence FAILS at `gs`, and `OmegaBad` holds — `pv gs`
--       derivable, `gs` not.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS CONFIRMS ACROSS THE ABSTRACT/CONCRETE DIVIDE
--
-- `GodelSeparation.noHalfTwo` refutes the second conjunct from
-- consistency, HBL1 and the fixed point, using the four-sentence
-- countermodel `Wit`, whose ω-inconsistency is recorded as
-- `witOmegaBad` and which proves `¬g` by fiat of its truth table.  §3
-- is the same phenomenon with a DERIVATION in place of a truth table:
-- the negation is not stipulated, it is deduced, and the deduction uses
-- exactly the ω-inconsistency.
--
-- And it confirms the previous module's reading from the other side.
-- There, ω-consistency held and the second conjunct survived; here it
-- fails and the second conjunct is refuted.  The hypothesis was doing
-- work, and this is the instance where removing it changes the answer —
-- which is what `WitSatisfiesEveryHypothesisButOmegaConsistency` could
-- not show, its witness being overdetermined.
--
-- ────────────────────────────────────────────────────────────────────
-- THE HONEST LIMIT, INHERITED AND UNCHANGED
--
-- Not Gödel's theorem.  `hbl` is a RULE, not a proved derivability
-- condition; `pv` is uninterpreted; the ω-inconsistency is an AXIOM
-- rather than something forced by arithmetic, which is the whole
-- difference between this and a theory anyone would use.  What is shown
-- is that the shape of the argument behaves as the abstract modules
-- said it would, in a calculus small enough to check.
--
-- Also inherited: `gs` was independent in the weaker calculus partly
-- because the rules were few, and §3 shows one more rule plus one axiom
-- is enough to end that.
--
-- PRIOR ART, grep run and quoted: searching `formal/cubical` for
-- `omega-inconsistent`, `OmegaInconsistent`, `dni` and `Der°` returns
-- nothing at all.  A version adding the axiom as a hypothesis of a
-- parameter block rather than as a constructor would evade that grep.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The calculus, with double-negation introduction and the axiom
------------------------------------------------------------------------

data Der° : S → Type₀ where
  taut   : (a : S) → Der° (im a a)
  mp     : (a b : S) → Der° (im a b) → Der° a → Der° b
  hbl    : (a : S) → Der° a → Der° (pv a)
  dfwd   : Der° (im gs (ng (pv gs)))
  dbwd   : Der° (im (ng (pv gs)) gs)
  contra : (a b : S) → Der° (im a b) → Der° (im (ng b) (ng a))
  dne    : (a : S) → Der° (im (ng (ng a)) a)
  dni    : (a : S) → Der° (im a (ng (ng a)))
  trans  : (a b c : S) → Der° (im a b) → Der° (im b c) → Der° (im a c)
  omega  : Der° (pv gs)

------------------------------------------------------------------------
-- 2.  The truth-functional model survives, so the first conjunct does
------------------------------------------------------------------------

dniB : (x : Bool) → impB x (not (not x)) ≡ true
dniB false = refl
dniB true  = refl

sound° : (s : S) → Der° s → sem₁ s ≡ true
sound° _ (taut a)          = impB-refl (sem₁ a)
sound° _ (mp a b da db)    = impB-mp (sem₁ a) (sem₁ b) (sound° (im a b) da) (sound° a db)
sound° _ (hbl a _)         = refl
sound° _ dfwd              = refl
sound° _ dbwd              = refl
sound° _ (contra a b d)    = contraB (sem₁ a) (sem₁ b) (sound° (im a b) d)
sound° _ (dne a)           = dneB (sem₁ a)
sound° _ (dni a)           = dniB (sem₁ a)
sound° _ (trans a b c d e) =
  transB (sem₁ a) (sem₁ b) (sem₁ c) (sound° (im a b) d) (sound° (im b c) e)
sound° _ omega             = refl

gsUnderivable° : ¬ Der° gs
gsUnderivable° d = false≢true (sound° gs d)

------------------------------------------------------------------------
-- 3.  …and the negation is DERIVABLE
------------------------------------------------------------------------

doubleNegProv : Der° (ng (ng (pv gs)))
doubleNegProv = mp (pv gs) (ng (ng (pv gs))) (dni (pv gs)) omega

negGsDerivable : Der° (ng gs)
negGsDerivable =
  mp (ng (ng (pv gs))) (ng gs)
     (contra gs (ng (pv gs)) dfwd)
     doubleNegProv

------------------------------------------------------------------------
-- 4.  So independence fails, and ω-consistency is what failed
------------------------------------------------------------------------

Th° : Theory ℓ-zero
Sent Th° = S
Pf   Th° = Der°
neg  Th° = ng
prov Th° = pv

notIndependent° : ¬ Independent Th° gs
notIndependent° ind = snd ind negGsDerivable

omegaBad° : OmegaBad Th° gs
omegaBad° = omega , gsUnderivable°

consistent° : Consistent Th°
consistent° s ds dns =
  false≢true (sym (cong not (sound° s ds)) ∙ sound° (ng s) dns)
