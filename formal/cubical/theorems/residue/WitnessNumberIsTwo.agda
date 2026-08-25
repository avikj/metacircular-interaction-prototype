{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessNumberIsTwo
--
-- CORRECTION TO `TwoProfilesSuffice`, one commit old.
--
-- That module concluded: "the invariant is the NUMBER OF WITNESSES:
-- 1 for लाघव, अनुवृत्ति, carry/borrow and the fuel obstructions; 2 for
-- अवक्तव्य."  That counts in two different units.  A collision is ONE
-- PAIR, and a pair is TWO POINTS.  Under a single measure the two sites
-- do not differ at all.
--
-- ────────────────────────────────────────────────────────────────────
-- ONE MEASURE
--
-- An absence of the form `¬ Σ[ d ∈ D ] ((x : X) → law d x)` is refuted
-- by a finite list of X-points when no decoder survives all of them:
--
--     AllHold law d xs   every point in xs is answered correctly by d
--     Refutes law xs  =  (d : D) → ¬ AllHold law d xs
--
-- `Refutes` on any list gives the absence (§2).  The question is the
-- least length that does, and it is the same everywhere in this corpus:
--
--   §3  ONE IS NEVER ENOUGH, for any `FactorsThrough` obstruction, with
--       no hypotheses at all.  The constant decoder `λ _ → t x` answers
--       x correctly, so `{x}` never refutes.  One line.
--
--   §4  A COLLISION IS EXACTLY A REFUTING PAIR.  So every collision site
--       has witness number exactly 2.
--
--   §5  AND SO DOES THE अवक्तव्य SITE, whose decoder space is six atoms
--       rather than a function space: `every-profile-is-said` gives the
--       lower bound and `pair-separates` the upper.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS SETTLES
--
-- The collision/exhaustion distinction dissolves, but not the way the
-- last two commits said in either direction.  It is not "1 versus 2";
-- it is 2 versus 2.  What actually differed was the ROUTE to the pair —
-- construct it from a collision, or find it by looking — and that is a
-- fact about how the witness is obtained, not about the absence.
--
-- Six was never a measurement of anything.  Nor, it turns out, was the
-- distinction that replaced it.  The stable quantity is 2, and §3 says
-- why the floor cannot be 1: a single point is always fittable, because
-- a decoder is only constrained where you constrain it.
--
-- ────────────────────────────────────────────────────────────────────
-- FOR THE DEFLATIONARY THREAD
--
-- Every absence in this corpus that has been made exact is exact by two
-- witnesses.  That is a much flatter landscape than "barrier" language
-- suggests, and it is now measured rather than asserted: the absences
-- are not merely decidable, they are uniformly CHEAP, and the cost is
-- the same at a function space as at a six-atom language.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module WitnessNumberIsTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import FiniteInformation
  using (FactorsThrough ; sameObservation→samePoint)

open import SaptabhangiNaya using (Profile ; Vacana)
open import TwoProfilesSuffice
  using (Says ; φ₁ ; φ₂ ; pair-separates ; every-profile-is-said)

private
  variable
    ℓd ℓx ℓy ℓt ℓ : Level

------------------------------------------------------------------------
-- 1.  The measure
------------------------------------------------------------------------

AllHold : {D : Type ℓd} {X : Type ℓx}
        → (D → X → Type ℓ) → D → List X → Type ℓ
AllHold law d []       = Unit*
AllHold law d (x ∷ xs) = law d x × AllHold law d xs

Refutes : {D : Type ℓd} {X : Type ℓx}
        → (D → X → Type ℓ) → List X → Type (ℓ-max ℓd ℓ)
Refutes {D = D} law xs = (d : D) → ¬ AllHold law d xs

------------------------------------------------------------------------
-- 2.  A refuting list gives the absence
------------------------------------------------------------------------

everywhere : {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
           → (d : D) → ((x : X) → law d x) → (xs : List X) → AllHold law d xs
everywhere law d full []       = tt*
everywhere law d full (x ∷ xs) = full x , everywhere law d full xs

refutes→absent : {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
               → (xs : List X) → Refutes law xs
               → ¬ (Σ[ d ∈ D ] ((x : X) → law d x))
refutes→absent law xs ref (d , full) = ref d (everywhere law d full xs)

------------------------------------------------------------------------
-- 3.  ONE POINT IS NEVER ENOUGH — for any factorisation obstruction
--
-- `FactorsThrough q t` is exactly `Σ[ d ] ((x : X) → factorLaw q t d x)`,
-- so this measure applies to it verbatim.  And the constant decoder
-- answers any single point, with no hypotheses on q, t, X, Y or T.
------------------------------------------------------------------------

factorLaw : {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
          → (q : X → Y) (t : X → T) → (Image q → T) → X → Type ℓt
factorLaw q t d x = d (restrictToImage q x) ≡ t x

law-is-factoring : {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
                 → (q : X → Y) (t : X → T)
                 → (Σ[ d ∈ (Image q → T) ] ((x : X) → factorLaw q t d x))
                 ≡ FactorsThrough q t
law-is-factoring q t = refl

singleton-never-refutes :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) (x : X)
  → ¬ Refutes (factorLaw q t) (x ∷ [])
singleton-never-refutes q t x ref = ref (λ _ → t x) (refl , tt*)

------------------------------------------------------------------------
-- 4.  A COLLISION IS EXACTLY A REFUTING PAIR
------------------------------------------------------------------------

collision→refutes :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) {x x' : X}
  → q x ≡ q x' → ¬ (t x ≡ t x')
  → Refutes (factorLaw q t) (x ∷ x' ∷ [])
collision→refutes q t {x} {x'} same differ d (at-x , at-x' , _) =
  differ (sym at-x ∙ cong d (sameObservation→samePoint q same) ∙ at-x')

-- so the witness number at any collision site is exactly 2:
-- 2 suffices (above) and 1 does not (§3)
collision-witness-number-2 :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) {x x' : X}
  → q x ≡ q x' → ¬ (t x ≡ t x')
  → Refutes (factorLaw q t) (x ∷ x' ∷ [])
   × ((z : X) → ¬ Refutes (factorLaw q t) (z ∷ []))
collision-witness-number-2 q t same differ =
  collision→refutes q t same differ , singleton-never-refutes q t

------------------------------------------------------------------------
-- 5.  THE अवक्तव्य SITE IS ALSO 2 — with a six-atom decoder space
--
-- Its decoders are not a function space, so §3 does not apply to it and
-- the lower bound has to come from `every-profile-is-said`.  It does,
-- and the answer is the same.
------------------------------------------------------------------------

vacanaLaw : Vacana → Profile → Type₀
vacanaLaw v φ = Says v φ

avaktavya-two-suffice : Refutes vacanaLaw (φ₁ ∷ φ₂ ∷ [])
avaktavya-two-suffice v (at-1 , at-2 , _) = pick (pair-separates v)
  where
  pick : ((¬ Says v φ₁) ⊎ (¬ Says v φ₂)) → ⊥
  pick (inl bad) = bad at-1
  pick (inr bad) = bad at-2

avaktavya-one-never : (φ : Profile) → ¬ Refutes vacanaLaw (φ ∷ [])
avaktavya-one-never φ ref =
  ref (every-profile-is-said φ .fst) (every-profile-is-said φ .snd , tt*)

avaktavya-witness-number-2 :
  Refutes vacanaLaw (φ₁ ∷ φ₂ ∷ [])
  × ((φ : Profile) → ¬ Refutes vacanaLaw (φ ∷ []))
avaktavya-witness-number-2 = avaktavya-two-suffice , avaktavya-one-never

------------------------------------------------------------------------
-- 6.  Two corrections in two commits, and what they have in common.
--
--   `OneLemmaFiveSites`  asserted a LOWER bound (no pair suffices) by
--                        reading an UPPER bound off a finite type.
--   `TwoProfilesSuffice` fixed that, then compared a count of PAIRS
--                        with a count of POINTS and reported 1 versus 2.
--
-- Both errors are the same error: a quantity was named before a measure
-- was fixed.  Once the measure is fixed — least refuting list, one
-- definition for every site — there is nothing left to compare, because
-- the answer is 2 everywhere and §3 explains the floor.
--
-- OPEN, named and not estimated: whether any absence in this corpus has
-- witness number above 2.  §3 gives a general floor and nothing here
-- gives a general ceiling.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  THE OPEN ITEM IN §6 IS SETTLED, negatively.
--
-- §6 asked "whether any absence in this corpus has witness number above
-- 2" and noted a general floor with no general ceiling.  There is no
-- general ceiling: `WitnessNumberIsUnbounded` realises
-- witness number exactly 3, with three standpoints each wrong at
-- exactly one of three points.  Every pair leaves a survivor; the nine
-- cases are the pigeonhole written out.
--
-- So the uniform 2 across this corpus is a property of ITS SITES, not
-- of the notion of absence.  That is what having a measure buys, and it
-- could not be said before one was fixed.
--
-- Still open there, and narrower: whether any absence arising from the
-- MATHEMATICS here — rather than constructed to order — exceeds 2.
-- Nothing found so far does.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  CORRECTION to §3's description, appended 2026-08-18.
--
-- §3 is headed "ONE POINT IS NEVER ENOUGH — for any factorisation
-- obstruction" and says the constant decoder answers a single point
-- "with no hypotheses on q, t, X, Y or T".  The theorem is right and the
-- description hides a hypothesis.
--
-- `TheFloorIsAnswerability` names it:
--
--     Answerable law = (x : X) → Σ[ d ∈ D ] law d x
--
-- The floor is answerability, not constancy.  A function space into an
-- inhabited type is answerable — `factorLaw-answerable` is the one line
-- that four modules were each re-deriving by hand — but answerability
-- can fail, and where it fails the floor drops to 1
-- (`lonely-witness-number-1`).
--
-- So the thread's two bounds are both properties of the DECODER SPACE
-- and neither is a property of the mathematics obstructed:
--
--     floor   ≥ 2   the decoders ANSWER every point
--     ceiling ≤ 2   the decoders READ a discrete probe
--
-- and the capacities are independent: the three-standpoint system of
-- `WitnessNumberIsUnbounded` answers but does not read, which is why its
-- number is 3 rather than 1.
------------------------------------------------------------------------
