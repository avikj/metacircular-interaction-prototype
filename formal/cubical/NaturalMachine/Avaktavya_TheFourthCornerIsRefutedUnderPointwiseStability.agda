{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheFourthCornerIsRefutedUnderPointwiseStability
--
-- Partial closure of an item I have carried open since
-- `SamayikaAndNityaAreIndependent`, which proved three of four corners
-- and said of the fourth:
--
--   "NOT PROVED and NOT ASSERTED: that the fourth corner is impossible
--    in the PLAIN negated forms.  `¬ सामयिक` does not constructively
--    yield an instance no remedy removes, so `¬ (¬ सामयिक bad × ¬ नित्य
--    bad)` is NOT proved here and is not asserted."
--
-- It is refuted under one named hypothesis, and the hypothesis is
-- exactly a stability, pointwise in the remedy:
--
--   fourthCornerRefutedUnderPointwiseStability :
--     ((r : R) → Stable (Σ[ i ∈ I ] bad i r))
--     → ¬ ((¬ सामयिक bad) × (¬ नित्य bad))
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THE CONSTRUCTIVE ARGUMENT STOPS, AND WHAT FILLS THE GAP
--
-- §2 is unconditional: if no single remedy clears every instance, then
-- for EVERY remedy some instance survives it — under a double negation.
-- That is a one-line contrapositive and needs nothing.
--
-- The double negation is the whole gap.  `नित्य` asks for the surviving
-- instance itself, and §2 delivers only `¬ ¬ Σ`.  §3 closes it with
-- stability of that Σ at each remedy — which `Dec` supplies, and which
-- is precisely the "positive pole is a search" side of the axis this
-- corpus keeps meeting.  §4 then refutes the fourth corner.
--
-- WHAT IS STILL NOT CLAIMED.  That the fourth corner is impossible
-- WITHOUT the hypothesis.  Nothing below shows the stability is
-- necessary, and I did not find a model realising the corner either; the
-- unconditional question stays open and is stated here as open rather
-- than quietly upgraded by §4.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Avaktavya_TheFourthCornerIsRefutedUnderPointwiseStability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import AnuktaAvaktavya using (सामयिक ; नित्य)
open import NaturalMachine.SamayikaAndNityaAreIndependent using (UniversalRemedy)

private
  variable
    ℓ : Level

Stable : Type ℓ → Type ℓ
Stable A = ¬ ¬ A → A

------------------------------------------------------------------------
-- 1.  A universal remedy is one that clears every instance
--
-- (the definition is `SamayikaAndNityaAreIndependent`'s; repeated here
-- only in words)
------------------------------------------------------------------------

-- if one exists, the temporary reading holds at every instance
universalRemedyGivesSamayika :
  {I R : Type} (bad : I → R → Type)
  → UniversalRemedy bad → सामयिक bad
universalRemedyGivesSamayika bad (r , clears) i = r , clears i

------------------------------------------------------------------------
-- 2.  No universal remedy ⇒ every remedy is survived, under ¬¬
------------------------------------------------------------------------

noUniversalRemedyGivesPointwiseDoubleNegation :
  {I R : Type} (bad : I → R → Type)
  → ¬ UniversalRemedy bad
  → (r : R) → ¬ ¬ (Σ[ i ∈ I ] bad i r)
noUniversalRemedyGivesPointwiseDoubleNegation bad noUR r nn =
  noUR (r , λ i b → nn (i , b))

------------------------------------------------------------------------
-- 3.  Pointwise stability turns that into नित्य
------------------------------------------------------------------------

pointwiseStabilityGivesNitya :
  {I R : Type} (bad : I → R → Type)
  → ((r : R) → Stable (Σ[ i ∈ I ] bad i r))
  → ¬ UniversalRemedy bad → नित्य bad
pointwiseStabilityGivesNitya bad stab noUR r =
  stab r (noUniversalRemedyGivesPointwiseDoubleNegation bad noUR r)

------------------------------------------------------------------------
-- 4.  Hence the fourth corner is refuted
--
-- `¬ सामयिक` kills any universal remedy (§1), §3 then produces `नित्य`,
-- and that contradicts `¬ नित्य`.
------------------------------------------------------------------------

fourthCornerRefutedUnderPointwiseStability :
  {I R : Type} (bad : I → R → Type)
  → ((r : R) → Stable (Σ[ i ∈ I ] bad i r))
  → ¬ ((¬ सामयिक bad) × (¬ नित्य bad))
fourthCornerRefutedUnderPointwiseStability bad stab (noSam , noNit) =
  noNit (pointwiseStabilityGivesNitya bad stab
          (λ ur → noSam (universalRemedyGivesSamayika bad ur)))

------------------------------------------------------------------------
-- 5.  What this settles and what it does not
--
-- SETTLED: with the Σ stable at each remedy — which a decision at each
-- remedy supplies — the four corners are three.  So the fourth corner,
-- if it exists at all, exists only where some `Σ[ i ] bad i r` is not
-- stable, i.e. where finding a surviving instance is a genuine search.
--
-- NOT SETTLED: whether it exists.  The hypothesis is not shown
-- necessary, and no model realising `¬ सामयिक × ¬ नित्य` is exhibited.
-- The unconditional question is where it was, and this narrows where to
-- look rather than answering it.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  §5's NOT SETTLED paragraph says the hypothesis "is not
-- shown necessary" and that this "narrows where to look rather than
-- answering it".  The narrowing is now much sharper, and by
-- DISCHARGING the hypothesis rather than weakening it:
--
--   `NaturalMachine.TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet`
--   (--safe, no postulates, no holes; container green under Agda 2.6.3
--    + cubical v0.5, NOT the declared pin — check.sh returns 1 and says
--    so)
--
--   Enumerated Ix = Σ[ xs ∈ List Ix ] ((i : Ix) → Any (_≡ i) xs)
--
-- — a list of instances plus a proof that nothing is outside it, with
-- no cardinality, no `Fin`, and no decidable equality on Ix.  Then
--
--   decΣOverEnumerated   Σ[ i ] P i is DECIDABLE
--   fourthCornerRefutedOverEnumerableDecidable
--                        so §4 applies with NOTHING assumed
--
-- §5 read the hypothesis as "finding a surviving instance is not a
-- genuine search".  Over an enumerable family with decidable badness it
-- is not a search, it is a scan.  So the fourth corner needs an
-- instance family that is not enumerable, OR a badness that is not
-- decidable — which is a much smaller place to look than "some Σ is
-- unstable".
--
-- STILL NOT SETTLED, exactly as §5 says: EXISTENCE.  The new module
-- gives a second SUFFICIENT condition, sharper and checkable, and no
-- necessary one; it exhibits no model of `¬ सामयिक × ¬ नित्य` either.
------------------------------------------------------------------------
