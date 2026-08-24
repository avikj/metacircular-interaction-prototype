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
-- NaturalMachine.TheEmptyListWasNeverCheckedAndItRefutesExactlyWhenTheDecoderSpaceIsEmpty
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The audited module belongs to the standing लाघव (lāghava) thread and
-- names its sites अवक्तव्य (avaktavya), अनुवृत्ति (anuvṛtti),
-- प्रत्याहार (pratyāhāra), अपवाद (apavāda) — Jaina and Pāṇinian terms
-- respectively, and **the school is named before the term** as the
-- naming rule requires.  This module touches none of that material: its
-- subject is the LIST-LENGTH bookkeeping of a measure defined in that
-- module, for which no tradition term exists and inventing one would
-- assert a provenance nobody checked.  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; `formal/` and `notes/` grepped
-- first.  **No claim whatever is made about avaktavya, anuvṛtti,
-- pratyāhāra or apavāda.**
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  `NaturalMachine.WitnessNumberIsTwo` defines a measure —
-- the least list of points on which no decoder survives — and concludes
--
--   "so the witness number at any collision site is **exactly 2**:
--    2 suffices (above) and 1 does not (§3)"
--
-- with `collision-witness-number-2` pairing `Refutes … (x ∷ x' ∷ [])`
-- against `(z : X) → ¬ Refutes … (z ∷ [])`.
--
-- **A LEAST OVER LIST LENGTHS HAS THREE CASES BELOW 3, AND ONLY TWO
-- WERE CHECKED.**  Lengths 2 and 1 are settled; **length 0 is not
-- mentioned anywhere on the line.**  That is not pedantry, because the
-- definition does not make it vacuous:
--
--     AllHold law d []  =  Unit*
--     Refutes law []    =  (d : D) → ¬ Unit*
--
-- so `Refutes law []` is `¬ D` up to the unit — **the empty list
-- refutes exactly when the DECODER SPACE IS EMPTY.**  §1 proves both
-- directions; §3 exhibits an inhabited instance at `D = ⊥`, where the
-- witness number is 0 and not 2.
--
-- WHAT IS PROVED
--
--   nilRefutesGivesNoDecoder / noDecoderGivesNilRefutes
--        the two directions.  Neither needs anything of `law`, `X` or
--        the universes — `law` is not even applied, which is the point:
--        at length 0 the measure stops seeing the law at all
--   aDecoderKeepsTheEmptyListSilent
--        the usable form: any `d : D` refutes the refutation
--   factorLawEmptyNeverRefutes
--        and at the audited module's own `factorLaw`, ONE point of `X`
--        supplies the decoder (`λ _ → t x`), exactly as
--        `singleton-never-refutes` does — so on that line the gap is
--        closable, and closing it is this
--   collisionWitnessNumberIsTwoAtAllThreeLengths
--        the audited conclusion with its third case attached
--   witnessNumberZeroIsAttained
--        at `D = ⊥` the empty list refutes for EVERY law, so "the
--        answer is 2 everywhere" is a statement about lines with
--        inhabited decoder spaces, and that hypothesis was silent
--
-- **WHAT THIS SAYS ABOUT THE MEASURE, AND IT IS THE FINDING.**  The
-- audited module's own §6 diagnoses its two predecessors: *"a quantity
-- was named before a measure was fixed."*  The measure IS fixed here,
-- and the residue is subtler — **a minimum was reported without its
-- whole range being examined.**  Length 0 is where the measure degrades
-- from a fact about the obstruction to a fact about the decoder space,
-- which is precisely the distinction that module's own closing lines
-- draw ("both bounds are properties of the DECODER SPACE and neither is
-- a property of the mathematics obstructed").  The omitted case is the
-- extreme point of the distinction it had already found.
--
-- WHAT IS NOT CLAIMED.  **`WitnessNumberIsTwo` is NOT amended and NOT
-- retracted** — every theorem in it is true as written, `Refutes` and
-- `factorLaw` are imported unchanged, and the conclusion "exactly 2"
-- SURVIVES for every site whose decoder space is inhabited, which
-- includes all of its own.  Nothing is claimed about
-- `WitnessNumberIsInvariant`, `WitnessNumberIsThePotential`,
-- `WitnessNumberIsUnbounded` or `TheFloorIsAnswerability`, none of
-- which is imported.  No least list is CONSTRUCTED for any site; this
-- only completes a lower bound.  Nothing here concerns whether the
-- least refuting list is unique.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheEmptyListWasNeverCheckedAndItRefutesExactlyWhenTheDecoderSpaceIsEmpty where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.WitnessNumberIsTwo
  using (AllHold ; Refutes ; factorLaw ; singleton-never-refutes
        ; collision→refutes)

private
  variable
    ℓ ℓd ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  At length 0 the measure sees the decoder space and nothing else
------------------------------------------------------------------------

nilRefutesGivesNoDecoder :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
  → Refutes law [] → ¬ D
nilRefutesGivesNoDecoder law ref d = ref d tt*

noDecoderGivesNilRefutes :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
  → ¬ D → Refutes law []
noDecoderGivesNilRefutes law noD d = ⊥.rec (noD d)

aDecoderKeepsTheEmptyListSilent :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
  → D → ¬ Refutes law []
aDecoderKeepsTheEmptyListSilent law d ref = ref d tt*

------------------------------------------------------------------------
-- 2.  On the audited line the gap closes, from one point of X
------------------------------------------------------------------------

factorLawEmptyNeverRefutes :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) (x : X)
  → ¬ Refutes (factorLaw q t) []
factorLawEmptyNeverRefutes q t x =
  aDecoderKeepsTheEmptyListSilent (factorLaw q t) (λ _ → t x)

collisionWitnessNumberIsTwoAtAllThreeLengths :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) {x x' : X}
  → q x ≡ q x' → ¬ (t x ≡ t x')
  → Refutes (factorLaw q t) (x ∷ x' ∷ [])
  × ((z : X) → ¬ Refutes (factorLaw q t) (z ∷ []))
  × (¬ Refutes (factorLaw q t) [])
collisionWitnessNumberIsTwoAtAllThreeLengths q t {x = x} same differ =
    collision→refutes q t same differ
  , singleton-never-refutes q t
  , factorLawEmptyNeverRefutes q t x

------------------------------------------------------------------------
-- 3.  …and the omitted case is inhabited, so the hypothesis was real
------------------------------------------------------------------------

witnessNumberZeroIsAttained :
  {X : Type ℓx} (law : ⊥ → X → Type ℓ) → Refutes law []
witnessNumberZeroIsAttained law = noDecoderGivesNilRefutes law (λ e → e)
