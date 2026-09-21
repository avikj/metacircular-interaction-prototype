{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ PROVENANCE OF THE NAME.
--
-- ‡ï‡‡∞‡Æ ¬ ‡®‡æ‡‡‡‡ø ‚î two terms, one from each half of the ‡‡‡‡‡‡ô‡‡ó‡ apparatus.
--
--   ‡‡‡Ø‡æ‡®‡‡®‡æ‡‡‡‡ø, the second ‡‡ô‡‡ó: in some respect, it is not.  **Samantabhadra,
--   *ptamms* 14-24 (~6th c. CE); Akalaka, *Laghyastraya* (~8th c.);
--   rooted in Umsvti, *Tattvrthastra* 5.31-32 (~2nd-5th c.).**
--
--   ‡ï‡‡∞‡Æ‡æ‡∞‡‡‡ versus ‡‡‡æ‡∞‡‡‡ ‚î presentation in SUCCESSION versus SIMULTANEOUSLY.
--   **Akalaka, *Laghyastraya* (~8th c.); Vidynandin,
--   *Tattvrthalokavrttika* (~9th c.).**  This is the load-bearing one:
--   ‡‡‡‡‡ø and ‡®‡æ‡‡‡‡ø asserted in succession give the third ‡‡ô‡‡ó and are
--   expressible; asserted together they give ‡‡µ‡ï‡‡‡µ‡‡Ø, the fourth, which is
--   neither unknown nor undefined nor empty but a positive fourth position.
--   The distinction is what makes seven positions and not four.
--
-- The sevenfold division and the ‡ï‡‡∞‡Æ/‡‡ distinction are
-- theirs, stated as doctrine; the theorems here are about what the fourth
-- corner can and cannot be over particular index types in cubical type
-- theory, and they are this repository's.
--
------------------------------------------------------------------------
-- TheFourthCornerIsRefutedUnderPointwiseStability
--
-- `SamayikaAndNityaAreIndependent` proved three of four corners.
-- The fourth is refuted under one named hypothesis, and the hypothesis is
-- exactly a stability, pointwise in the remedy:
--
--   fourthCornerRefutedUnderPointwiseStability :
--     ((r : R) ‚í Stable (Œ[ i ‚àà I ] bad i r))
--     ‚í ¬ ((¬ ‡‡æ‡Æ‡Ø‡ø‡ï bad) ó (¬ ‡®‡ø‡‡‡Ø bad))
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHERE THE CONSTRUCTIVE ARGUMENT STOPS, AND WHAT FILLS THE GAP
--
-- ¬ß2 is unconditional: if no single remedy clears every instance, then
-- for EVERY remedy some instance survives it ‚î under a double negation.
-- That is a one-line contrapositive and needs nothing.
--
-- The double negation is the whole gap.  `‡®‡ø‡‡‡Ø` asks for the surviving
-- instance itself, and ¬ß2 delivers only `¬ ¬ Œ`.  ¬ß3 closes it with
-- stability of that Œ at each remedy ‚î which `Dec` supplies, and which
-- is precisely the "positive pole is a search" side of the axis this
-- corpus keeps meeting.  ¬ß4 then refutes the fourth corner.
------------------------------------------------------------------------

module KramaAstiNasti_TheFourthCornerIsRefutedUnderPointwiseStability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import AnuktaAvaktavya using (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ; ‡§®‡§ø‡§§‡•ç‡§Ø)
open import SamayikaAndNityaAreIndependent using (UniversalRemedy)

private
  variable
    ‚Ñì : Level

Stable : Type ‚Ñì ‚Üí Type ‚Ñì
Stable A = ¬¨ ¬¨ A ‚Üí A

------------------------------------------------------------------------
-- 1.  A universal remedy is one that clears every instance
--
-- (the definition is `SamayikaAndNityaAreIndependent`'s; repeated here
-- only in words)
------------------------------------------------------------------------

-- if one exists, the temporary reading holds at every instance
universalRemedyGivesSamayika :
  {I R : Type} (bad : I ‚Üí R ‚Üí Type)
  ‚Üí UniversalRemedy bad ‚Üí ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï bad
universalRemedyGivesSamayika bad (r , clears) i = r , clears i

------------------------------------------------------------------------
-- 2.  No universal remedy ‚í every remedy is survived, under ¬¬
------------------------------------------------------------------------

noUniversalRemedyGivesPointwiseDoubleNegation :
  {I R : Type} (bad : I ‚Üí R ‚Üí Type)
  ‚Üí ¬¨ UniversalRemedy bad
  ‚Üí (r : R) ‚Üí ¬¨ ¬¨ (Œ£[ i ‚àà I ] bad i r)
noUniversalRemedyGivesPointwiseDoubleNegation bad noUR r nn =
  noUR (r , Œª i b ‚Üí nn (i , b))

------------------------------------------------------------------------
-- 3.  Pointwise stability turns that into ‡®‡ø‡‡‡Ø
------------------------------------------------------------------------

pointwiseStabilityGivesNitya :
  {I R : Type} (bad : I ‚Üí R ‚Üí Type)
  ‚Üí ((r : R) ‚Üí Stable (Œ£[ i ‚àà I ] bad i r))
  ‚Üí ¬¨ UniversalRemedy bad ‚Üí ‡§®‡§ø‡§§‡•ç‡§Ø bad
pointwiseStabilityGivesNitya bad stab noUR r =
  stab r (noUniversalRemedyGivesPointwiseDoubleNegation bad noUR r)

------------------------------------------------------------------------
-- 4.  Hence the fourth corner is refuted
--
-- `¬ ‡‡æ‡Æ‡Ø‡ø‡ï` kills any universal remedy (¬ß1), ¬ß3 then produces `‡®‡ø‡‡‡Ø`,
-- and that contradicts `¬ ‡®‡ø‡‡‡Ø`.
------------------------------------------------------------------------

fourthCornerRefutedUnderPointwiseStability :
  {I R : Type} (bad : I ‚Üí R ‚Üí Type)
  ‚Üí ((r : R) ‚Üí Stable (Œ£[ i ‚àà I ] bad i r))
  ‚Üí ¬¨ ((¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï bad) √ó (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø bad))
fourthCornerRefutedUnderPointwiseStability bad stab (noSam , noNit) =
  noNit (pointwiseStabilityGivesNitya bad stab
          (Œª ur ‚Üí noSam (universalRemedyGivesSamayika bad ur)))

------------------------------------------------------------------------
-- 5.  What this settles
--
-- SETTLED: with the Œ stable at each remedy ‚î which a decision at each
-- remedy supplies ‚î the four corners are three.  So the fourth corner,
-- if it exists at all, exists only where some `Œ[ i ] bad i r` is not
-- stable, i.e. where finding a surviving instance is a genuine search.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- The hypothesis is DISCHARGED, not weakened, in
--   `TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet`:
--
--   Enumerated Ix = Œ[ xs ‚àà List Ix ] ((i : Ix) ‚í Any (_‚â° i) xs)
--
-- ‚î a list of instances plus a proof that nothing is outside it, with
-- no cardinality, no `Fin`, and no decidable equality on Ix.  Then
--
--   decŒOverEnumerated   Œ[ i ] P i is DECIDABLE
--   fourthCornerRefutedOverEnumerableDecidable
--                        so ¬ß4 applies with NOTHING assumed
--
-- ¬ß5 read the hypothesis as "finding a surviving instance is not a
-- genuine search".  Over an enumerable family with decidable badness it
-- is not a search, it is a scan.  So the fourth corner needs an
-- instance family that is not enumerable, OR a badness that is not
-- decidable ‚î which is a much smaller place to look than "some Œ is
-- unstable".
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ON THE NAME.
-- `KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition` proves
-- this line's "fourth corner" is a product of two independent
-- negations and that simultaneous refusal collapses into the
-- sequential pair, so the position is the THIRD bhaga ‚î
-- ‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø, asserted ‡ï‡‡∞‡Æ‡‡ ‚î and not avaktavya.
------------------------------------------------------------------------
