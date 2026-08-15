{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Control.InjectivityNecessary
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- Designed annihilation (collab/PROTOCOL.md §7), companion to
-- `NaturalMachine.ComparisonNeedNotBeInjective` (exit 0 under the pin).
--
-- WHAT IT ASSERTS.  `notes/FULL_READ_DRAW_6.md` §D3 and §2: the note
-- `OBSERVER_REVISION_IS_ATOMIC_SATISFACTION.md` §4 writes "injectivity
-- of `j_q` is **needed**", and
-- `collab/messages/0469-atomic-satisfaction-is-response-square.md`
-- hardens that into a report that the Agda checks the comparison maps
-- "**must be** injective for the backwards implication".  Two
-- assertions, the two ways this modality-drop shows up in prose:
--
--   (a) the sufficiency theorem WITHOUT its injectivity hypothesis —
--       "the square gives the biconditional", full stop, which is what
--       a reader takes away once "needed" is heard as "the condition";
--   (b) the necessity claim's CONSEQUENCE in the checked instance of
--       `ComparisonNeedNotBeInjective`: there `invariant` holds and
--       `j` merges `one` and `two`, so if the invariant forced
--       injectivity we would have `one ≡ two`.
--
-- WHY IT MUST FAIL.  (a) `ChangedResponses.square→satisfaction` wants
-- `InjectiveComparisons` and the general statement without it is false
-- — merge a REALIZED outcome with another and the forward direction
-- breaks.  (b) `one` and `two` are distinct constructors
-- (`one≢two`), so the necessity claim's consequence is refuted by the
-- machine directly.
--
-- NO LEXICAL SIGNATURE.  "Needed" and "must be" are ordinary words in
-- the right places; nothing separates them from a correct sufficiency
-- statement except the mathematics.  grep cannot see a modality; a
-- type can.
--
-- It is NOT part of the checked build.  `NaturalMachine.agda` does not
-- import it, and nothing else may.
--
-- OBSERVED, 2026-08-15, THE PIN (Agda 2.8.0 + cubical v0.9; see
-- notes/TOOLCHAIN_SKEW_AND_COVERAGE.md §6.1), `LC_ALL=C.UTF-8 agda
-- --library-file=<v0.9> NaturalMachine/Control/InjectivityNecessary.agda`,
-- exit code 42, error verbatim:
--
--   NaturalMachine/Control/InjectivityNecessary.agda:78.30-48:
--   error: [UnequalTerms]
--   ResponseSquare !=< InjectiveComparisons
--   when checking that the expression square→satisfaction has type
--   ResponseSquare → SatisfactionInvariant
--
-- Read it: the machine names the dropped hypothesis,
-- `InjectiveComparisons`, in the position where the note's "needed"
-- and the message's "must be" put it on the wrong side of the arrow.
--
-- (Agda stops at the first error, so assertion (b) is not reached.
-- Checked separately by commenting out (a) — same file, the two lines
-- of the `Dropped` module body commented out, then restored — it fails
-- at 84.19-23 with
--   one != two of type Three
--   when checking that the expression refl has type one ≡ two
-- — the two unrealized outcomes the comparison merges, named by the
-- machine.)
--
-- If a future edit makes this file compile, injectivity has been
-- silently promoted from sufficient to necessary and the corpus has
-- readmitted the defect FULL_READ_DRAW_6 §D3 catalogued.
------------------------------------------------------------------------

module NaturalMachine.Control.InjectivityNecessary where

open import Cubical.Foundations.Prelude

open import NaturalMachine.AtomicSatisfaction using (module ChangedResponses)
open import NaturalMachine.ComparisonNeedNotBeInjective using (Three ; one ; two)

-- (a) The sufficiency theorem with its hypothesis deleted.
module Dropped
  {ℓX ℓX′ ℓQ ℓY ℓY′ : Level}
  {X : Type ℓX} {X′ : Type ℓX′} {Q : Type ℓQ}
  (Y : Q → Type ℓY) (Y′ : Q → Type ℓY′)
  (r : (q : Q) → X → Y q)
  (r′ : (q : Q) → X′ → Y′ q)
  (s : X′ → X)
  (j : (q : Q) → Y q → Y′ q)
  where

  open ChangedResponses Y Y′ r r′ s j

  square→satisfaction-dropped : ResponseSquare → SatisfactionInvariant
  square→satisfaction-dropped = square→satisfaction

-- (b) What "must be injective" would give in the checked instance.
merged-outcomes : one ≡ two
merged-outcomes = refl
