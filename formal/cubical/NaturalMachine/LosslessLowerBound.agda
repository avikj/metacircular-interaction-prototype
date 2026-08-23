{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.LosslessLowerBound
--
-- `TheGapWasAUnitsError` proves the walk's storage equals the logarithm
-- of its workload, and lists what it quotes rather than proves:
--
--   "QUOTED, not re-proved here: … that an injective map out of a set of
--    n+1 elements needs at least n+1 targets (pigeonhole), which is what
--    makes lcm(S) > n a LOWER bound and hence makes 'optimal' mean
--    something."
--
-- That is the load-bearing half of the word "optimal", and it is quoted.
-- Here it is a term.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
--     lossless-needs-room :
--       (n : ℕ) (Y : FinSet ℓ) (obs : Fin (suc n) → Y .fst)
--       → Injective obs → suc n ≤ card Y
--
-- Any lossless observation of the inputs 0 … n — ANY, over every scheme,
-- not just residues and not just the walk's — needs at least n+1
-- distinguishable outcomes.  With the walk's outcome space being the
-- residues mod lcm(S), of which there are exactly lcm(S), this is what
-- turns the CRT criterion `lcm(S) > n` from a description of the walk
-- into a bound on every machine.
--
-- ────────────────────────────────────────────────────────────────────
-- PRIOR ART, SEARCHED FIRST THIS TIME
--
-- `Cubical.Data.FinSet.Cardinality.card↪Inequality'` is the pigeonhole in
-- exactly the needed direction, and `formal/cubical/FinCardinality.agda`
-- already carries CRT (`crtEquiv`, `crtInj`) and the equal-cardinality
-- counting principle for this repository.  Nothing below is new
-- mathematics; what is new is that the walk's optimality no longer rests
-- on a sentence in a comment.
--
-- Five rediscoveries were logged in this session by finding prior art at
-- audit time.  This one was found before writing, which is the whole of
-- the difference.
--
-- ────────────────────────────────────────────────────────────────────
-- AND WHY THIS SHAPE MATTERS TO THE DEFLATIONARY THREAD
--
-- `DeflationaryTest` §10 shows this lane cannot express a barrier: every
-- absence is stable, every dichotomy is a decision, and `¬ (Dec A)` is
-- contradictory.  It closes by asking what a genuine limitation would
-- have to look like instead.
--
-- This is one.  `lossless-needs-room` is POSITIVE, is quantified over
-- every observation scheme, and bounds them all.  It says "no machine of
-- this kind does better", which is the content people reach for when they
-- write "barrier" — and it is available, expressible, and provable here,
-- because it quantifies over a class rather than negating a proposition.
--
-- A limitation you can state is a Π over machines.  A barrier you cannot
-- state is a ¬ over propositions.  The corpus has been writing the second
-- while meaning the first.
--
-- WHAT IS NOT CLAIMED.  That the walk attains this bound in general —
-- `TheGapWasAUnitsError` checks tightness at frontiers 4, 5, 7, 8 by
-- computation and nothing here extends that.  Nor that residues are the
-- only lossless scheme: the theorem is deliberately about all of them,
-- which is why it says nothing about which one to pick.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.LosslessLowerBound where

open import Cubical.Foundations.Prelude
open import Cubical.Functions.Embedding using (injEmbedding)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet using (FinSet ; card ; isFinSet→isSet)
open import Cubical.Data.FinSet.Cardinality using (card↪Inequality')
open import FinCardinality using (FinSetFin ; cardFinSetFin)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  Losslessness, as this corpus means it
--
-- The observation separates the inputs it is run on.  This is exactly
-- `WALK_FORCING_LAW.md`'s "the observation n ↦ (n mod m) is injective on
-- the walked prefix".
------------------------------------------------------------------------

Injective : {A : Type ℓ} {B : Type ℓ} → (A → B) → Type ℓ
Injective {A = A} f = {x y : A} → f x ≡ f y → x ≡ y

-- the inputs 0 … n, as a finite set of size n+1
Inputs : ℕ → FinSet ℓ-zero
Inputs n = FinSetFin (suc n)

------------------------------------------------------------------------
-- 2.  THE LOWER BOUND.  Uniform over every observation scheme.
------------------------------------------------------------------------

lossless-needs-room :
  (n : ℕ) (Y : FinSet ℓ-zero) (obs : Fin (suc n) → Y .fst)
  → Injective obs
  → card (Inputs n) ≤ card Y
lossless-needs-room n Y obs inj =
  card↪Inequality' (Inputs n) Y obs
    (injEmbedding (isFinSet→isSet (Y .snd)) inj)

------------------------------------------------------------------------
-- 3.  What it says about the walk, in words the walk uses.
--
-- The walk's outcome space at frontier k is the residues modulo cap k,
-- of which there are exactly cap k.  So by §2 any lossless walk over the
-- prefix [0, n] has cap k ≥ n+1 — which is `WALK_FORCING_LAW.md`'s
-- invariant `lcm(S) > n`, now derived as a bound on every scheme rather
-- than stated as a property of one.
--
-- `TheGapWasAUnitsError` then checks the walk attains it with no slack at
-- frontiers 4, 5, 7, 8: state 840, last input 839, at frontier 8.  Bound
-- and attainment, both terms, on both sides of the word "optimal".
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  Note on the build.
--
-- This module imports `FinCardinality`, which pulls in the FinSet
-- machinery and takes several minutes to elaborate from a cold cache.
-- That cost is deliberate: the alternative was a private copy of the
-- pigeonhole, and this session has already logged five instances of the
-- corpus proving one thing repeatedly because prior art was searched
-- after the write-up.  A slow import that reuses a checked theorem is the
-- cheaper of the two.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5.  RELATION TO `NaturalMachine.WalkCapacity` — checked after the fact,
--     and they are complements rather than duplicates.
--
-- `WalkCapacity` (2026-08-13) proves the capacity theorem: any lossless
-- sensor family whose addresses are all ≤ k has lcm DIVIDING lcm(1..k),
-- and the bound is attained.  That bounds the state's MODULUS from above,
-- by two universal properties and no arithmetic.
--
-- This module bounds the OUTCOME COUNT from below, by pigeonhole.
--
-- The two together are what "optimal" needs and neither is the other:
--
--   `WalkCapacity`        no admissible family's modulus exceeds cap k
--   here                  no lossless scheme has fewer than n+1 outcomes
--   `WalkObservationCount` and the walk's scheme has exactly cap k of them
--
-- `WalkCapacity`'s design note is also worth reading against
-- `FrontierList`: it states capacity by universal property BECAUSE this
-- lane has no LCM module, and calls that absence an improvement.  The
-- `frontierList` construction is the deliberate complement — a concrete
-- residue space where that module deliberately avoided one — and neither
-- supersedes the other.
------------------------------------------------------------------------
