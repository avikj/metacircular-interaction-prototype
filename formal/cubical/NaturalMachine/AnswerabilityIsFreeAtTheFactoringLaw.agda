-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AnswerabilityIsFreeAtTheFactoringLaw
--
-- The live question continued: a hypothesis that is CORRECTLY assumed
-- in general and is a THEOREM at the site the generalisation came from.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO STATEMENTS, READ RATHER THAN RECALLED
--
-- `NaturalMachine.WitnessDichotomy` proves, for an arbitrary law:
--
--     collision-witness-number-2
--       : (law : D → X → Type ℓ) → Answerable law → (x x' : X)
--       → ((d : D) → law d x → law d x' → ⊥) → WitnessNumberIs law 2
--
-- `NaturalMachine.TheFloorIsAnswerability` proves, for the corpus's
-- central law:
--
--     factorLaw-answerable q t x = (λ _ → t x) , refl
--
-- — a CONSTANT decoder, written down, not searched for.
--
-- So at `factorLaw q t` the first theorem's hypothesis is the second
-- theorem's conclusion, and the composition is not in the corpus.
-- That last is a SEARCH RESULT, not a classification: two greps over
-- `formal/cubical/NaturalMachine` on 2026-08-19, one for uses of
-- `collision-witness-number-2` outside its two home modules and one
-- for any statement of the form `WitnessNumberIs (factorLaw …)`, both
-- empty.  A differently-phrased equivalent could exist and neither
-- grep would see it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  the composite: from a collision alone — `q x ≡ q x'` and
--       `¬ (t x ≡ t x')` — the full `WitnessNumberIs (factorLaw q t) 2`,
--       with `Answerable` supplied internally and no longer appearing
--       in the statement.
--
--   §2  and the discharge isolated as its own object, so that the next
--       site needing it does not re-derive it.
--
-- The content is the removal.  At the central law, the whole of
-- witness-number-2 is the collision: answerability contributes a
-- hypothesis that a function space satisfies because it has constants.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES AND DOES NOT SAY ABOUT THE FLOOR
--
-- This thread has carried "the floor is answerability" as a standing
-- result.  §1 does not overturn it and must not be read as doing so.
-- Two different claims:
--
--   स्यात् — in the respect of an arbitrary law, answerability is a
--            real hypothesis: `WitnessDichotomy` assumes it because
--            without it the witness number drops to 1, and
--            `TheFloorIsAnswerability` exhibits `lonelyLaw` where it
--            fails.  Verified by reading both.
--   स्यात् — in the respect of the factoring law specifically, it is a
--            theorem, because the decoder space is a function space and
--            function spaces have constants.
--
-- A नय that is vacuously satisfied at a site is not thereby a wrong
-- नय, and collapsing "free here" into "unnecessary" would be exactly
-- the move anekānta blocks: the two respects disagree, so there is
-- plurality and no collapse is licensed.  What §1 establishes is
-- narrower than either reading — that at ONE site the composition was
-- available and unmade.
--
-- NOT CLAIMED.  That answerability is free at any other law (it is not
-- free at `lonelyLaw`, which is the corpus's own counterexample); that
-- the two source statements were wrong (neither is); that this is the
-- last such composition in the corpus — one was found by reading two
-- files, which is two files.
------------------------------------------------------------------------

module NaturalMachine.AnswerabilityIsFreeAtTheFactoringLaw where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import NaturalMachine.WitnessNumberIsThePotential using (WitnessNumberIs)
open import NaturalMachine.WitnessNumberIsTwo using (factorLaw ; collision→refutes)
open import NaturalMachine.TheFloorIsAnswerability using (factorLaw-answerable)
open import NaturalMachine.WitnessDichotomy using (collision-witness-number-2)

private
  variable
    ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  The composite, with `Answerable` gone from the statement
------------------------------------------------------------------------

factoring-witness-number-2 :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) {x x' : X}
  → q x ≡ q x' → ¬ (t x ≡ t x')
  → WitnessNumberIs (factorLaw q t) 2
factoring-witness-number-2 q t {x} {x'} same differ =
  collision-witness-number-2 (factorLaw q t)
    (factorLaw-answerable q t) x x' kills
  where
  kills : (d : Image q → _) → factorLaw q t d x → factorLaw q t d x' → ⊥
  kills d ax ax' = collision→refutes q t same differ d (ax , ax' , tt*)

------------------------------------------------------------------------
-- 2.  The discharge on its own, so the next site does not redo it
------------------------------------------------------------------------

answerabilityDischarged :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T)
  → (x : X) → Σ[ d ∈ (Image q → T) ] factorLaw q t d x
answerabilityDischarged q t = factorLaw-answerable q t
