{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
--  — the examination of , as terms.  Four results:
--
--   Chaya       The collapse from the witnessed Goldbach statement to the
--               truncated one has a reverse map; the SECTION does not.
--               Both are proved.
--
--   Pramanya    `Ganana`/`Ekam` decide primality with a `Bool` and
--               `Purna`/`Sakshi` decide it with a `Dec`.  The bridge is
--               supplied, and the Goldbach sweep's output is 49 certified
--               decompositions.
--
--   Kuttaka-    `KuttakaConvergents` runs the descent law by well-founded
--   samapti     recursion on the remainder, and the divisor comes back
--               carrying proofs that it divides both inputs.
--
--   Upadhi      `|M(k)|² ≤ k` is not a fragment of the
--               Riemann Hypothesis.  It is the Mertens conjecture, which
--               was disproved in 1985.  The universal statement and the
--               finite check are separated into two types with a map in
--               one direction only.
------------------------------------------------------------------------

module PrimesCheck where

import TheShadowHasNoSectionThoughItHasAMap
import TheBooleanCarriesNoWarrantSoTheSweepCarriesTheProof
import TheValliTerminatesWithoutFuel
import TheMertensGateIsTheDisprovedConjectureNotTheHypothesis
