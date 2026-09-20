{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡ø‡∞‡‡ß‡æ‡∞‡ø‡ ‚î the sum field does NOT determine the state, and the host
-- module knew: its own header exhibits caches {1,2,4,5} and {1,2,3,6}
-- with one scalar summary.  The probe's open obligation "ones ‚ sum"
-- (notes/SADHYA_OPEN_OBLIGATIONS.md, rung ‡, blocked on induction on
-- List) was never going to close as a green: ones (sum w) ‚â° w is FALSE,
-- and the honest landing is road two, the separating pair.  Discharged
-- by hand, smallest witnesses: [2] and [1,1] share the fibre of sum at
-- 2, and ones routes the summary to [1,1], missing [2] forever.
--
-- This closes the Swarm.S13OptionSpread : ones ‚ sum row of the queue
-- as ‡¶‡ã‡‡≤‡‡ñ ‚î written defect, not defeat: the fibre of sum IS the
-- module's subject (its ¬ß3), and this term pins the smallest instance.
------------------------------------------------------------------------

module Ratri.Anirdharita_S13OptionSpread_OnesSum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.List using (List; []; _‚à∑_)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Swarm.S13OptionSpread using (sum; ones)

-- The two inhabitants of one fibre of the summary.
state‚ÇÅ state‚ÇÇ : List ‚Ñï
state‚ÇÅ = 2 ‚à∑ []
state‚ÇÇ = 1 ‚à∑ 1 ‚à∑ []

sameSummary : sum state‚ÇÅ ‚â° sum state‚ÇÇ
sameSummary = refl

-- ones reconstructs the second from the shared summary ‚¶
onesLands : ones (sum state‚ÇÅ) ‚â° state‚ÇÇ
onesLands = refl

-- ‚¶ and the two states are distinct: heads 2 ‚â 1.
head‚â¢ : (2 ‚à∑ []) ‚â° (1 ‚à∑ (1 ‚à∑ [])) ‚Üí ‚ä•
head‚â¢ p = snotz (injSuc (cong headOr0 p))
  where
  headOr0 : List ‚Ñï ‚Üí ‚Ñï
  headOr0 []      = 0
  headOr0 (a ‚à∑ _) = a

-- THE VERDICT.  Green here means the field is NOT determined:
-- ones ‚àò sum is not the identity, witnessed at the smallest fibre.
NOT-DETERMINED : ones (sum state‚ÇÅ) ‚â° state‚ÇÅ ‚Üí ‚ä•
NOT-DETERMINED p = head‚â¢ (sym p)
