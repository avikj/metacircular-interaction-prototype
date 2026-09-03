{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module WitSatisfiesEveryHypothesisButOmegaConsistency where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
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
-- — contraposition, double-negation elimination, transitivity — plus
-- ω-consistency.  `RepresentabilityIsNotEnoughForIndependence` showed
-- the first three are satisfied by a model where independence fails.
-- This checks the three internal rules in that same model.
--
-- All three hold.  So `Wit` satisfies EVERY hypothesis of that
-- derivation except ω-consistency, and fails independence.
-- ω-consistency is therefore not "the remaining candidate" by
-- elimination in prose: it is the single hypothesis whose removal
-- breaks the derivation, witnessed by a model satisfying all the
-- others.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THE THREE HOLD, WHICH IS NOT AN ACCIDENT OF THE MODEL
--
-- `wPf (wimp a b)` is inhabited exactly when provability of `a` entails
-- provability of `b` (§1, both directions).  `wneg` is an involution
-- and `wPf (wneg s)` is inhabited exactly when `wPf s` is not (§2).  So
-- the four sentences carry a two-valued classical propositional
-- semantics, and the three rules are its standard validities.  A model
-- built to be ω-inconsistent is not thereby built to be
-- propositionally deviant, and it is not.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SCOPE, EXACTLY
--
-- That ω-consistency SUFFICES for any theory of interest.  §4 says only
-- that dropping it from the six is what the derivation cannot survive
-- in this model; adding it back to `Wit` is impossible, since `Wit` is
-- ω-inconsistent, so nothing here exhibits the positive case.
--
-- That the six hypotheses are independent of each other.  Only one
-- separation is exhibited — ω-consistency from the rest — and no claim
-- is made about any other pair.
--
-- That `Form = Unit` in `witHasDiagonal` is adequate to arithmetisation.
-- It is not, and the previous module says so; §4 inherits that limit
-- unchanged.
--
-- PRIOR ART, by the conclusion type: a grep of `formal/cubical` for
-- `OmegaBad` finds `GodelSeparation` (definition, `witOmegaBad`) and
-- this thread's modules only; nothing states a separation of it from
-- the other hypotheses.  A version phrased as ω-consistency of a
-- different theory would evade that grep.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  `wimp` is exactly entailment of provability
--
-- One direction is `wmp`.  The other is by exhaustion; the two
-- unprovable antecedents are uniform, so ten clauses suffice.
------------------------------------------------------------------------

impIntro : (a b : W) → (wPf a → wPf b) → wPf (wimp a b)
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

wnegInvol : (s : W) → wneg (wneg s) ≡ s
wnegInvol wtop = refl
wnegInvol wbot = refl
wnegInvol wg   = refl
wnegInvol wng  = refl

negPf→ : (s : W) → wPf (wneg s) → ¬ wPf s
negPf→ wtop p  = λ _ → p
negPf→ wbot _  = λ q → q
negPf→ wg   _  = λ q → q
negPf→ wng  p  = λ _ → p

→negPf : (s : W) → (¬ wPf s) → wPf (wneg s)
→negPf wtop h = Empty.rec (h tt)
→negPf wbot _ = tt
→negPf wg   _ = tt
→negPf wng  h = Empty.rec (h tt)

------------------------------------------------------------------------
-- 3.  The three internal rules, in `Wit`
------------------------------------------------------------------------

witTrans : (a b c : Sent Wit)
         → Pf Wit (imp witHasDiagonal a b)
         → Pf Wit (imp witHasDiagonal b c)
         → Pf Wit (imp witHasDiagonal a c)
witTrans a b c hab hbc =
  impIntro a c (λ pa → wmp b c hbc (wmp a b hab pa))

witContra : (a b : Sent Wit)
          → Pf Wit (imp witHasDiagonal a b)
          → Pf Wit (imp witHasDiagonal (neg Wit b) (neg Wit a))
witContra a b hab =
  impIntro (wneg b) (wneg a)
    (λ pnb → →negPf a (λ pa → negPf→ b pnb (wmp a b hab pa)))

witDne : (a : Sent Wit)
       → Pf Wit (imp witHasDiagonal (neg Wit (neg Wit a)) a)
witDne a =
  impIntro (wneg (wneg a)) a (λ p → subst wPf (wnegInvol a) p)

------------------------------------------------------------------------
-- 4.  So ω-consistency is the one hypothesis the derivation needs and
--     this model does not have
------------------------------------------------------------------------

omegaConsistencyIsTheSeparatingHypothesis :
  ( (T : Theory ℓ-zero) (D : HasDiagonal T)
    → Consistent T → HBL1 T
    → ((a b : Sent T) → Pf T (imp D a b)
                      → Pf T (imp D (neg T b) (neg T a)))
    → ((a : Sent T) → Pf T (imp D (neg T (neg T a)) a))
    → ((a b c : Sent T) → Pf T (imp D a b) → Pf T (imp D b c)
                        → Pf T (imp D a c))
    → Independent T (goedelSentence T D) )
  → ⊥
omegaConsistencyIsTheSeparatingHypothesis f =
  witNotIndependent
    (f Wit witHasDiagonal witCon witHBL1 witContra witDne witTrans)

-- and the hypothesis that is absent, as a term rather than as prose
theAbsentHypothesis : OmegaBad Wit wg
theAbsentHypothesis = witOmegaBad

------------------------------------------------------------------------
-- CORRECTION, made in
-- `AProvabilityDeterminedImplicationForbidsIndependence`
-- and recorded here rather than by deletion.
--
-- §4 above is unaffected as a statement: the derivation of independence
-- does require ω-consistency, and `Wit` is a counterexample when it is
-- dropped.
--
-- What is withdrawn is the reading offered in this module's header and
-- in its commit message — that ω-consistency is thereby "the one
-- hypothesis doing the work", "witnessed by a model satisfying all the
-- others".  That other module proves: ANY theory whose internal
-- implication is provability-determined (`impIntro` here) and which has
-- contraposition and an unprovable sentence with provable negation has
-- NO independent sentence at all, whatever its ω-status.  `Wit` is in
-- that class — by `impIntro` and `witContra`, both proved above.
--
-- So `Wit` fails independence for two unrelated reasons, and a witness
-- that fails twice attests to neither.  §4 remains a correct
-- separation; it is not evidence about which hypothesis is load-bearing.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- THE MISSING EVIDENCE NOW EXISTS, elsewhere.
--
-- The correction above says this module's witness is overdetermined and
-- therefore does not show that ω-consistency is the load-bearing
-- hypothesis.  That remains true of `Wit`.
--
-- The evidence it said was absent is now in the corpus, as a PAIR of
-- concrete calculi differing in exactly that hypothesis:
--
--   `TheInternalRulesPreserveIndependenceInThisCalculus` — ω-consistency
--   HOLDS (`pv gs` is underivable) and `gs` is independent;
--
--   `TheOmegaInconsistentExtensionDerivesTheNegation` — the same
--   calculus plus double-negation introduction and the axiom `pv gs`;
--   ω-consistency FAILS, the first conjunct still holds, and `ng gs` is
--   DERIVED in three steps.
--
-- Same connectives, same diagonal pair, same first conjunct; the second
-- conjunct changes with ω-consistency and with nothing else that was
-- varied.  That is a separation this module's single witness could not
-- provide, and it is recorded here rather than claimed above.
------------------------------------------------------------------------
