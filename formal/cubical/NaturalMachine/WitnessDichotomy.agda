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
-- NaturalMachine.WitnessDichotomy
--
-- The closing statement of the witness thread, and a correction to the
-- case analysis in `TheFloorIsAnswerability` §4.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CORRECTION FIRST
--
-- That §4 lists "the four cases" as
--
--     answering ✓ reading ✓  ⟹ 2
--     answering ✓ reading ✗  ⟹ 3
--     answering ✓ reading ✗  ⟹ ∞
--     answering ✗            ⟹ 1
--
-- and calls them exhaustive.  They are not four cases of two binary
-- capacities: the third row repeats the second's hypotheses, and
-- (answering ✗, reading ✓) is missing.  The reason it is missing is that
-- it does not matter, and that is a theorem rather than an oversight:
--
--     unanswerable→one : ¬ (Σ[ d ∈ D ] law d x) → Refutes law (x ∷ [])
--
-- One unanswerable point refutes on its own, whatever else the decoders
-- can read.  So answerability is not one of two independent axes — it is
-- a GATE.  Fail it and the number is 1; pass it and reading decides
-- between 2 and everything above.
--
-- ────────────────────────────────────────────────────────────────────
-- SO THE PICTURE IS A CHAIN, NOT A SQUARE
--
--     ¬ answerable                      ⟹ 1        §1
--     answerable, readable              ⟹ 2        §2, ceiling elsewhere
--     answerable, not readable          ⟹ ≥ 2, and 3 and ∞ both occur
--
-- and the middle line is the one every site in this corpus sits on.
--
-- ────────────────────────────────────────────────────────────────────
-- AND ONE PIECE OF DUPLICATION REMOVED
--
-- `laghava-probe-is-two`, `barrier-witness-number-2` and
-- `laghava-is-two` each assemble "a collision plus the floor gives
-- exactly 2" by hand, with the same length bookkeeping three times.
-- §2 does it once.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.WitnessDichotomy where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; ¬-<-zero ; pred-≤-pred)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.WitnessNumberIsTwo using (AllHold ; Refutes)
open import NaturalMachine.WitnessNumberIsThePotential using (WitnessNumberIs)
open import NaturalMachine.TheFloorIsAnswerability
  using (Answerable ; answerable→no-singleton ; answerable→no-empty)

private
  variable
    ℓd ℓx ℓ : Level

------------------------------------------------------------------------
-- 1.  ANSWERABILITY IS A GATE, NOT AN AXIS
------------------------------------------------------------------------

unanswerable→one :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ) (x : X)
  → ¬ (Σ[ d ∈ D ] law d x)
  → Refutes law (x ∷ [])
unanswerable→one law x un d (h , _) = un (d , h)

-- exactly 1, given only that there is some decoder at all (else the
-- empty list would already refute)
unanswerable-witness-number-1 :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
  → D → (x : X) → ¬ (Σ[ d ∈ D ] law d x)
  → WitnessNumberIs law 1
unanswerable-witness-number-1 law d₀ x un =
    (x ∷ [] , refl , unanswerable→one law x un)
  , least
  where
  least : (ys : List _) → length ys < 1 → ¬ Refutes law ys
  least []       _  = λ ref → ref d₀ tt*
  least (y ∷ ys) lt = Empty.rec (¬-<-zero (pred-≤-pred lt))

------------------------------------------------------------------------
-- 2.  PAST THE GATE: a collision plus the floor is exactly 2, once
--
-- Stated for an arbitrary law with an arbitrary separating pair, so that
-- the three sites which assembled this by hand can point here instead.
------------------------------------------------------------------------

collision-witness-number-2 :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
  → Answerable law
  → (x x' : X)
  → ((d : D) → law d x → law d x' → ⊥)
  → WitnessNumberIs law 2
collision-witness-number-2 law ans x x' kills =
    (x ∷ x' ∷ [] , refl , pair)
  , least
  where
  pair : Refutes law (x ∷ x' ∷ [])
  pair d (at-x , at-x' , _) = kills d at-x at-x'

  least : (ys : List _) → length ys < 2 → ¬ Refutes law ys
  least []           _  = answerable→no-empty law ans x
  least (a ∷ [])     _  = answerable→no-singleton law ans a
  least (a ∷ b ∷ ys) lt = Empty.rec (¬-<-zero (pred-≤-pred (pred-≤-pred lt)))

------------------------------------------------------------------------
-- 3.  The two hypotheses of §2, side by side with what they exclude
--
-- `Answerable` excludes the degenerate 1; the "kills" hypothesis is what
-- a collision supplies, and is exactly the negative half of the
-- factorisation obstruction.  Neither mentions Y, T, discreteness, or
-- any structure of the mathematics being obstructed — which is the
-- thread's conclusion in its smallest form.
------------------------------------------------------------------------

-- the collision hypothesis, in the shape every site produces it
collisionKills :
  {D : Type ℓd} {X : Type ℓx} {W : Type ℓ} {V : Type ℓ}
  (obs : X → W) (val : X → V)
  (read : D → W → V)
  (x x' : X) → obs x ≡ obs x' → ¬ (val x ≡ val x')
  → (d : D) → (read d (obs x) ≡ val x) → (read d (obs x') ≡ val x') → ⊥
collisionKills obs val read x x' same differ d at-x at-x' =
  differ (sym at-x ∙ cong (read d) same ∙ at-x')

------------------------------------------------------------------------
-- 4.  What the thread now says, entire.
--
--   The cost of an absence of factorisation shape is fixed by two
--   capacities of its DECODERS and by nothing about the mathematics
--   obstructed:
--
--     answering   every point is answered by some decoder.  Fail it and
--                 the cost is 1 and the absence is degenerate — one
--                 unreachable point, not two confused ones.
--     reading     the decoders see a discrete probe.  Given answering,
--                 pass it and the cost is exactly 2; fail it and 3 and ∞
--                 both occur.
--
--   Every site in this corpus passes both, which is why every site costs
--   2, and `notes/BARRIER.md`'s open problem is on the same line.
--
-- OPEN, named and not estimated.  Whether "reading" admits a converse:
-- these modules show a discrete probe SUFFICES for the ceiling and that
-- its absence permits 3 and ∞, but not that some readability condition
-- is NECESSARY.  A decoder space with no discrete probe and ceiling 2
-- would settle it and none is known here.
------------------------------------------------------------------------
