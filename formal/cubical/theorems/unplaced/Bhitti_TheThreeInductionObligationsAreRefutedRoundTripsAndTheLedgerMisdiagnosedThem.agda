{-# OPTIONS --cubical --safe #-}

-- Bhitti_TheThreeInductionObligationsAreRefutedRoundTripsAndTheLedgerMisdiagnosedThem
--
-- ‡‡ø‡‡‡‡ø‡ ‚î a WALL: a proved ¬(round trip), which retires a candidate
-- permanently (the term and the economy are BhittiSnapshot.tsv's, this
-- corpus; no external source claimed).
--
-- The ledger lists 12 real obligations, THREE of them grouped
-- under the move "induction on List":
--
--     OptionSpread      : ones ‚ sum
--     IntegerHullMultiplicity    : Xs  ‚ hull
--     IntegerHullMultiplicity    : Qs  ‚ hull
--
-- with ‡∞‡æ‡‡‡∞‡ø‡ stuck at rung ‡ (induction) on each.  The ledger's
-- diagnosis is wrong, and this module proves it wrong: the reverse
-- round trips are FALSE, so no induction can ever close them.  ones
-- returns only all-ones lists (its two clauses build nothing else);
-- hull returns only its own five-beat pattern 0‚à0‚à0‚à0‚à1‚à‚¶; a single
-- list outside the image refutes each ‚à-statement.  The failing goals
-- quoted in the ledger ‚î `w‚ ‚à ones (sum w‚) != ones (w‚ + sum w‚)` ‚î
-- are the counterexample shape ITSELF, met mid-induction and read as
-- an obstacle instead of an answer.  ‡∞‡æ‡‡‡∞‡ø‡ proposes and the kernel
-- decides; neither asks whether the statement is true.
--
-- The forward trips (sum (ones m) ‚â° m and the hull sections the host
-- modules DO prove) are untouched here.  The honest
-- close of each obligation is this wall, filed in the ledger's own
-- economy: a ford creates crossings, a wall retires a merge, both are
-- receipts.  ‡Æ‡‡®‡ ‡® ‡®‡ø‡‡‡ß‡ ‚î and a stuck induction is not a ‡®‡ø‡‡‡ß
-- either; only a counterexample is.

module Bhitti_TheThreeInductionObligationsAreRefutedRoundTripsAndTheLedgerMisdiagnosedThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

import OptionSpread as S13

-- IntegerHullMultiplicity does not import under this container's cubical
-- v0.5 (it uses solve‚ï!, a later library's tactic ‚î the version-skew
-- fault interactive/dosa.lekha's newest entries measure).  So its three
-- functions are REDEFINED here verbatim, each duplicate named, per the
-- corpus's self-contained-by-redefinition discipline: Config, Xs, Qs
-- from IntegerHullMultiplicity.agda lines 87‚ì104 and hull from lines
-- 260‚ì262, copied character for character.
open import Cubical.Data.Nat using (_+_ ; _¬∑_)

Config : Type
Config = List ‚Ñï

Xs : Config ‚Üí ‚Ñï
Xs []       = 0
Xs (x ‚à∑ xs) = x + Xs xs

Qs : Config ‚Üí ‚Ñï
Qs []       = 0
Qs (x ‚à∑ xs) = x ¬∑ x + Qs xs

hull : ‚Ñï ‚Üí Config
hull zero    = []
hull (suc t) = 0 ‚à∑ 0 ‚à∑ 0 ‚à∑ 0 ‚à∑ 1 ‚à∑ hull t

-- the discriminator: total head, 0 at the empty list
‡§Æ‡•Å‡§ñ‡§Æ‡•ç : List ‚Ñï ‚Üí ‚Ñï
‡§Æ‡•Å‡§ñ‡§Æ‡•ç []      = zero
‡§Æ‡•Å‡§ñ‡§Æ‡•ç (a ‚à∑ _) = a

-- ‚î‚î wall 1 ¬ ones ‚àò sum is not the identity ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ones (sum (2 ‚à [])) = ones 2 = 1 ‚à 1 ‚à [], whose head is 1, not 2.

‡§è‡§ï-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É : ¬¨ ((w : List ‚Ñï) ‚Üí S13.ones (S13.sum w) ‚â° w)
‡§è‡§ï-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É h = znots (cong pred‚ÇÇ (cong ‡§Æ‡•Å‡§ñ‡§Æ‡•ç (h (2 ‚à∑ []))))
  where
    -- 1 ‚â° 2 ‚í 0 ‚â° 1, then znots
    pred‚ÇÇ : ‚Ñï ‚Üí ‚Ñï
    pred‚ÇÇ zero    = zero
    pred‚ÇÇ (suc m) = m

-- ‚î‚î the hull's mouth is always zero ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î

‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç : (t : ‚Ñï) ‚Üí ‡§Æ‡•Å‡§ñ‡§Æ‡•ç (hull t) ‚â° zero
‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç zero    = refl
‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç (suc t) = refl

-- ‚î‚î wall 2 ¬ hull ‚àò Xs is not the identity ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î

‡§ó‡•Ç‡§¢-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É-X : ¬¨ ((w : Config) ‚Üí hull (Xs w) ‚â° w)
‡§ó‡•Ç‡§¢-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É-X h =
  znots (sym (‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç (Xs (1 ‚à∑ []))) ‚àô cong ‡§Æ‡•Å‡§ñ‡§Æ‡•ç (h (1 ‚à∑ [])))

-- ‚î‚î wall 3 ¬ hull ‚àò Qs is not the identity ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î

‡§ó‡•Ç‡§¢-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É-Q : ¬¨ ((w : Config) ‚Üí hull (Qs w) ‚â° w)
‡§ó‡•Ç‡§¢-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É-Q h =
  znots (sym (‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç (Qs (1 ‚à∑ []))) ‚àô cong ‡§Æ‡•Å‡§ñ‡§Æ‡•ç (h (1 ‚à∑ [])))
