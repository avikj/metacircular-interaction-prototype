{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ó‡‡®‡æ-asNat ‚î the indicator's full census, pricing the busiest unpriced
-- edge the organism itself asked for.
--
-- THE MAP: `FiniteOccupancyChannelNoGo.asNat` (false‚¶0, true‚¶1).
-- One receipt prices the indicator shape itself.
--
-- THE RECEIPT, an identification per point of the codomain (never a
-- bound), in SakalaVikalaDesa's three-verdict vocabulary:
--
--   fibre over 0        : contractible  ‚î ‡‡ï‡≤‡æ‡¶‡‡  (exactly false)
--   fibre over 1        : contractible  ‚î ‡‡ï‡≤‡æ‡¶‡‡  (exactly true)
--   fibre over suc(suc n): empty        ‚î ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (nothing lost: ‚ï merely
--                                         has names Bool cannot utter)
--
-- So asNat is INJECTIVE but not an equivalence, and its entire defect is
-- ‡‡µ‡ï‡‡‡µ‡‡Ø ‚î the empty kind, ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡, no information destroyed.  The map
-- was never lossy; it is merely partial on names.  By ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡-‡‡ô‡‡ò‡æ‡‡
-- this is the best case for routing: on its image the edge is invertible,
-- so every composite THROUGH asNat prices as the other factor alone.
------------------------------------------------------------------------

module GananaAsNat_TheIndicatorsFullCensusPricesTheBusiestUnpricedEdge where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv)
open isEquiv
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots ; snotz ; injSuc)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; isSetBool ; true‚â¢false ; false‚â¢true)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Relation.Nullary using (¬¨_)
open import FiniteOccupancyChannelNoGo using (asNat)

-- asNat is IMPORTED from its home, not redefined: the receipt must attach
-- to the original declaration.

‡§∂‡•á‡§∑ : ‚Ñï ‚Üí Type
‡§∂‡•á‡§∑ n = Œ£[ b ‚àà Bool ] (asNat b ‚â° n)

------------------------------------------------------------------------
-- ‡ß ¬ over zero: exactly false.
------------------------------------------------------------------------

‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§∏‡§ï‡§≤ : isContr (‡§∂‡•á‡§∑ 0)
fst ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§∏‡§ï‡§≤ = false , refl
snd ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§∏‡§ï‡§≤ (false , p) i = false , isSet‚Ñï 0 0 refl p i
  where open import Cubical.Data.Nat using (isSet‚Ñï)
snd ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§∏‡§ï‡§≤ (true  , p) = ‚ä•-rec (snotz p)

------------------------------------------------------------------------
-- ‡® ¬ over one: exactly true.
------------------------------------------------------------------------

‡§è‡§ï-‡§∏‡§ï‡§≤ : isContr (‡§∂‡•á‡§∑ 1)
fst ‡§è‡§ï-‡§∏‡§ï‡§≤ = true , refl
snd ‡§è‡§ï-‡§∏‡§ï‡§≤ (true  , p) i = true , isSet‚Ñï 1 1 refl p i
  where open import Cubical.Data.Nat using (isSet‚Ñï)
snd ‡§è‡§ï-‡§∏‡§ï‡§≤ (false , p) = ‚ä•-rec (znots p)

------------------------------------------------------------------------
-- ‡© ¬ above one: empty.  ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ ‚î the names Bool cannot utter.
------------------------------------------------------------------------

‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ-‡§∞‡§ø‡§ï‡•ç‡§§ : (n : ‚Ñï) ‚Üí ¬¨ ‡§∂‡•á‡§∑ (suc (suc n))
‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ-‡§∞‡§ø‡§ï‡•ç‡§§ n (false , p) = snotz (sym p)
‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ-‡§∞‡§ø‡§ï‡•ç‡§§ n (true  , p) = snotz (injSuc (sym p))

------------------------------------------------------------------------
-- ‡ ¬ the consequences the router reads off the census.
------------------------------------------------------------------------

-- injective: the collision of any two booleans under asNat is refuted or
-- resolved by the censuses above ‚î direct proof by cases.
‡§Ö‡§≠‡•á‡§¶-asNat : (a b : Bool) ‚Üí asNat a ‚â° asNat b ‚Üí a ‚â° b
‡§Ö‡§≠‡•á‡§¶-asNat false false _ = refl
‡§Ö‡§≠‡•á‡§¶-asNat true  true  _ = refl
‡§Ö‡§≠‡•á‡§¶-asNat false true  p = ‚ä•-rec (znots p)
‡§Ö‡§≠‡•á‡§¶-asNat true  false p = ‚ä•-rec (snotz p)

-- not an equivalence: the point 2 has an empty fibre.
‡§®-‡§∏‡§Æ‡§§‡§æ : ¬¨ (isEquiv asNat)
‡§®-‡§∏‡§Æ‡§§‡§æ e = ‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ-‡§∞‡§ø‡§ï‡•ç‡§§ 0 (fst (e .equiv-proof 2))
