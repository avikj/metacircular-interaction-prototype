{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnswerabilityIsFreeAtTheFactoringLaw
--
-- A hypothesis that is CORRECTLY assumed
-- in general and is a THEOREM at the site the generalisation came from.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO STATEMENTS
--
-- `WitnessDichotomy` proves, for an arbitrary law:
--
--     collision-witness-number-2
--       : (law : D → X → Type ℓ) → Answerable law → (x x' : X)
--       → ((d : D) → law d x → law d x' → ⊥) → WitnessNumberIs law 2
--
-- `TheFloorIsAnswerability` proves, for the corpus's
-- central law:
--
--     factorLaw-answerable q t x = (λ _ → t x) , refl
--
-- — a CONSTANT decoder, written down, not searched for.
--
-- So at `factorLaw q t` the first theorem's hypothesis is the second
-- theorem's conclusion.
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
-- THE FLOOR, IN TWO RESPECTS
--
-- "The floor is answerability" and §1 are two different claims:
--
--   स्यात् — in the respect of an arbitrary law, answerability is a
--            real hypothesis: `WitnessDichotomy` assumes it because
--            without it the witness number drops to 1, and
--            `TheFloorIsAnswerability` exhibits `lonelyLaw` where it
--            fails.
--   स्यात् — in the respect of the factoring law specifically, it is a
--            theorem, because the decoder space is a function space and
--            function spaces have constants.
--
-- A नय that is vacuously satisfied at a site is not thereby a wrong
-- नय, and collapsing "free here" into "unnecessary" would be exactly
-- the move aneknta blocks: the two respects disagree, so there is
-- plurality and no collapse is licensed.
--
------------------------------------------------------------------------

module AnswerabilityIsFreeAtTheFactoringLaw where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import WitnessNumberIsTwo using (factorLaw ; collision→refutes)
open import TheFloorIsAnswerability using (factorLaw-answerable)
open import WitnessDichotomy using (collision-witness-number-2)

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
