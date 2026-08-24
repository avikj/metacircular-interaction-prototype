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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition
--
-- क्रम / सह (युगपद्) — krama, in sequence; saha or yugapad, at once.
-- The distinction is the Jaina one, from the saptabhaṅgī literature
-- (Umāsvāti, *Tattvārthasūtra*; Samantabhadra; Akalaṅka; Siddhasena
-- Divākara), and in this repository it is `Saptabhangi` /
-- `SaptabhangiNaya` — ANOTHER IDENTITY'S modules, written in
-- Devanagari — that prove the theorem being used here as a lens:
--
--   स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम्
--
-- sequential assertion of asti and nāsti is NOT the simultaneous
-- position; avaktavya is a fourth, irreducibly distinct bhaṅga.  That
-- result is theirs.  Nothing here restates or reproves it, and nothing
-- here is a claim about their construction.  What is done here is to
-- turn it on MY OWN objects, which is what a lens is for.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FINDING, AND IT IS AGAINST MY OWN NAMING OF ONE CYCLE AGO.
--
-- My "fourth corner" is, by its definition,
--
--   (¬ सामयिक (one Q)) × (¬ नित्य (one Q))
--
-- a PRODUCT of two negations.  Three things are checked below:
--
--   1. the two conjuncts are INDEPENDENT — each is satisfiable while
--      the other fails, so the pair is genuinely "one, and also the
--      other", which is krama;
--   2. **the simultaneous refusal collapses to the sequential pair**:
--      `¬ (A ⊎ B) → (¬ A) × (¬ B)` and back, constructively, with no
--      hypothesis — so in this formalism "refusing both at once" IS
--      "refusing one and refusing the other", and there is no room
--      between them;
--   3. hence my formalism, as it stands, cannot express avaktavya at
--      all: every position it can name is reachable sequentially.
--
-- **So the name I applied in the previous two cycles is very likely
-- wrong.**  `Avaktavya_*` was put on four files on the grounds that the
-- fourth corner is the fourth bhaṅga.  By the theorem those modules'
-- author proved, the fourth bhaṅga is exactly what a sequential
-- position is not — and mine is a product, which is sequential.  On
-- present evidence my corner sits at the THIRD bhaṅga,
-- स्यात्-अस्ति-नास्ति, the krama position.
--
-- **THE RENAME IS NOT DONE IN THIS CYCLE**, by the standing rule that
-- a record is not amended in the cycle that finds the gap in it.  It is
-- the next cycle's named step, and the honest replacement is a term for
-- the sequential position, not silence.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES NOT SHOW.  It does NOT show that avaktavya is
-- inexpressible in cubical type theory — only that THIS encoding, a
-- product of negations over an instance family, is not it, because De
-- Morgan's one constructively valid direction runs the wrong way for
-- me.  Finding an encoding with a genuine saha position is open, and
-- it is exactly what `Saptabhangi`'s `आर्पण` (krama / saha as a
-- DATATYPE, an argument to the predication rather than a shape of it)
-- already does — which is the structural lesson: simultaneity has to
-- be a parameter, not an inferred property of a formula.  Whether that
-- can be transported onto my `सामयिक`/`नित्य` instance family is open
-- and is NOT attempted here.
--
-- Nothing here touches `AnuktaAvaktavya`, `Saptabhangi` or
-- `SaptabhangiNaya`; `सामयिक` and `नित्य` are imported as instances, as
-- they have been on this line throughout.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import AnuktaAvaktavya using (सामयिक ; नित्य)
open import NaturalMachine.KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
  using (one)

------------------------------------------------------------------------
-- 1.  Simultaneous refusal collapses to sequential refusal
------------------------------------------------------------------------

sahaToKrama : {A B : Type} → ¬ (A ⊎ B) → (¬ A) × (¬ B)
sahaToKrama h = (λ a → h (inl a)) , (λ b → h (inr b))

kramaToSaha : {A B : Type} → (¬ A) × (¬ B) → ¬ (A ⊎ B)
kramaToSaha (na , nb) (inl a) = na a
kramaToSaha (na , nb) (inr b) = nb b

------------------------------------------------------------------------
-- 2.  …and the corner is exactly that collapse, at my objects
------------------------------------------------------------------------

Corner : {R : Type} → (R → Type) → Type
Corner Q = (¬ सामयिक (one Q)) × (¬ नित्य (one Q))

cornerIsRefusingBothAtOnce :
  {R : Type} (Q : R → Type)
  → (¬ (सामयिक (one Q) ⊎ नित्य (one Q)) → Corner Q)
  × (Corner Q → ¬ (सामयिक (one Q) ⊎ नित्य (one Q)))
cornerIsRefusingBothAtOnce Q = sahaToKrama , kramaToSaha

------------------------------------------------------------------------
-- 3.  The two conjuncts are independent
--
-- `¬ सामयिक (one Q)` is pointwise non-refutability and
-- `¬ नित्य (one Q)` is the absence of a uniform proof.  Each holds
-- while the other fails, so the corner really is a conjunction of two
-- separately assertible positions.
------------------------------------------------------------------------

trivial : Unit → Type
trivial _ = Unit

firstAloneHolds : ¬ सामयिक (one trivial)
firstAloneHolds f = snd (f tt) tt

secondFailsThere : ¬ (¬ नित्य (one trivial))
secondFailsThere k = k (λ r → tt , tt)

alwaysFalse : Unit → Type
alwaysFalse _ = ⊥

secondAloneHolds : ¬ नित्य (one alwaysFalse)
secondAloneHolds f = snd (f tt)

firstFailsThere : ¬ (¬ सामयिक (one alwaysFalse))
firstFailsThere k = k (λ _ → tt , (λ e → e))

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  **THE CONCLUSION ABOVE IS TOO STRONG AND IS CORRECTED
-- HERE.**  The block above says "this formalism, as it stands, cannot
-- express avaktavya at all: every position it can name is reachable
-- sequentially."  What is actually proved above is narrower: REFUSING
-- BOTH collapses, because `¬ (A ⊎ B)` and `(¬ A) × (¬ B)` are
-- interderivable.
--
-- The other De Morgan law runs only one way constructively, and I did
-- not check it.  `NaturalMachine.Yugapat_TheRefusalOfJointAssertionDoesNotDecompose`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin) gives the position I said did not
-- exist: `¬ (सामयिक × नित्य)` — the refusal of the JOINT assertion,
-- which says the two cannot hold together without saying which fails.
-- `kramaGivesYugapat` shows the sequential position implies it, and
-- `yugapatDecompositionGivesWeakExcludedMiddle` shows the converse, as
-- a general principle, yields weak excluded middle.  So the gap is a
-- named constructive taboo, not an accident of encoding.
--
-- That module also imports their `आर्पण` rather than rebuilding it, and
-- states plainly what is NOT claimed: that this position IS avaktavya,
-- or that it matches what `Saptabhangi` proves.  It is a position of my
-- family that no product of refusals reaches; the comparison with their
-- construction remains an OFFER, not a result.
------------------------------------------------------------------------
