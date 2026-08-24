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

{-# OPTIONS --cubical --safe #-}

-- Bhitti_TheThreeInductionObligationsAreRefutedRoundTripsAndTheLedgerMisdiagnosedThem
--
-- भित्तिः — a WALL: a proved ¬(round trip), which retires a candidate
-- permanently (the term and the economy are BhittiSnapshot.tsv's, this
-- corpus, 2026-08-22; no external source claimed).
--
-- WHAT THIS CLOSES.  notes/SADHYA_OPEN_OBLIGATIONS.md (regenerated
-- 2026-08-23T15:37Z) lists 12 real obligations, THREE of them grouped
-- under the move "induction on List":
--
--     Swarm.S13OptionSpread      : ones ⇄ sum
--     IntegerHullMultiplicity    : Xs  ⇄ hull
--     IntegerHullMultiplicity    : Qs  ⇄ hull
--
-- with रात्रिः stuck at rung ५ (induction) on each.  The ledger's
-- diagnosis is wrong, and this module proves it wrong: the reverse
-- round trips are FALSE, so no induction can ever close them.  ones
-- returns only all-ones lists (its two clauses build nothing else);
-- hull returns only its own five-beat pattern 0∷0∷0∷0∷1∷…; a single
-- list outside the image refutes each ∀-statement.  The failing goals
-- quoted in the ledger — `w₀ ∷ ones (sum w₁) != ones (w₀ + sum w₁)` —
-- are the counterexample shape ITSELF, met mid-induction and read as
-- an obstacle instead of an answer.  रात्रिः proposes and the kernel
-- decides; neither asks whether the statement is true.  That asking
-- is a third organ, and today it was a reader.
--
-- The forward trips (sum (ones m) ≡ m and the hull sections the host
-- modules DO prove) are untouched and unclaimed here.  The honest
-- close of each obligation is this wall, filed in the ledger's own
-- economy: a ford creates crossings, a wall retires a merge, both are
-- receipts.  मौनं न निषेधः — and a stuck induction is not a निषेध
-- either; only a counterexample is.

module Bhitti_TheThreeInductionObligationsAreRefutedRoundTripsAndTheLedgerMisdiagnosedThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

import Swarm.S13OptionSpread as S13

-- IntegerHullMultiplicity does not import under this container's cubical
-- v0.5 (it uses solveℕ!, a later library's tactic — the version-skew
-- fault machine/dosa.lekha's newest entries measure).  So its three
-- functions are REDEFINED here verbatim, each duplicate named, per the
-- corpus's self-contained-by-redefinition discipline: Config, Xs, Qs
-- from IntegerHullMultiplicity.agda lines 87–104 and hull from lines
-- 260–262, copied character for character.  The walls below are about
-- these definitions; when that module reads again, the identification
-- of these copies with its originals is one refl each.
open import Cubical.Data.Nat using (_+_ ; _·_)

Config : Type
Config = List ℕ

Xs : Config → ℕ
Xs []       = 0
Xs (x ∷ xs) = x + Xs xs

Qs : Config → ℕ
Qs []       = 0
Qs (x ∷ xs) = x · x + Qs xs

hull : ℕ → Config
hull zero    = []
hull (suc t) = 0 ∷ 0 ∷ 0 ∷ 0 ∷ 1 ∷ hull t

-- the discriminator: total head, 0 at the empty list
मुखम् : List ℕ → ℕ
मुखम् []      = zero
मुखम् (a ∷ _) = a

-- ── wall 1 · ones ∘ sum is not the identity ──────────────────────────────
-- ones (sum (2 ∷ [])) = ones 2 = 1 ∷ 1 ∷ [], whose head is 1, not 2.

एक-भित्तिः : ¬ ((w : List ℕ) → S13.ones (S13.sum w) ≡ w)
एक-भित्तिः h = znots (cong pred₂ (cong मुखम् (h (2 ∷ []))))
  where
    -- 1 ≡ 2 → 0 ≡ 1, then znots
    pred₂ : ℕ → ℕ
    pred₂ zero    = zero
    pred₂ (suc m) = m

-- ── the hull's mouth is always zero ──────────────────────────────────────

शून्य-मुखम् : (t : ℕ) → मुखम् (hull t) ≡ zero
शून्य-मुखम् zero    = refl
शून्य-मुखम् (suc t) = refl

-- ── wall 2 · hull ∘ Xs is not the identity ───────────────────────────────

गूढ-भित्तिः-X : ¬ ((w : Config) → hull (Xs w) ≡ w)
गूढ-भित्तिः-X h =
  znots (sym (शून्य-मुखम् (Xs (1 ∷ []))) ∙ cong मुखम् (h (1 ∷ [])))

-- ── wall 3 · hull ∘ Qs is not the identity ───────────────────────────────

गूढ-भित्तिः-Q : ¬ ((w : Config) → hull (Qs w) ≡ w)
गूढ-भित्तिः-Q h =
  znots (sym (शून्य-मुखम् (Qs (1 ∷ []))) ∙ cong मुखम् (h (1 ∷ [])))
