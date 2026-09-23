{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ï‡‡‡∞-‡¶‡‡µ‡ø‡ó‡‡‡ ‚î ‡‡ø‡ô‡‡ó‡≤‡‡‡Ø ‡µ‡∞‡‡-‡‡‡∞‡‡‡‡æ‡∞‡‡‡Ø ‡¶‡‡µ‡ø‡ó‡‡‡®‡Æ‡, ‡µ‡‡‡‡-‡‡‡‡∞‡ (‡® ‡ï‡‡µ‡≤‡ ‡ó‡‡®‡) ‡
--
-- ‡‡ø‡ô‡‡ó‡≤‡‡‡Ø ‡‡‡ñ‡‡Ø‡æ-‡‡‡∞‡‡‡Ø‡Ø‡ : n-‡‡ï‡‡‡∞-‡‡®‡‡¶‡æ‡‡‡ø 2‚ø (count (suc n) = count n +
-- count n) ‚î ‡ï‡ø‡®‡‡‡ ‡‡‡æ ‡‡µ‡‡‡‡‡ø‡ ‡ï‡‡µ‡≤‡ ‡ó‡‡®‡æ ‡  ‡ï‡ø‡Æ‡∞‡‡‡ ‡¶‡‡µ‡ø‡ó‡‡‡Æ‡ ?  ‡Ø‡‡ ‡‡‡∞‡‡ø
-- (suc n)-‡‡ï‡‡‡∞-‡‡®‡‡¶‡ ‡¶‡‡µ‡Ø‡ã‡ ‡‡ï‡Æ‡ : ‡‡¶‡ ‡≤‡ò‡‡, ‡‡‡ n-‡‡ï‡‡‡∞-‡‡®‡‡¶‡ ; ‡‡‡µ‡æ ‡‡¶‡ ‡ó‡‡∞‡‡,
-- ‡‡‡ n-‡‡ï‡‡‡∞-‡‡®‡‡¶‡ ‡  ‡‡‡‡ ‡µ‡‡‡‡-‡‡‡‡∞‡‡Ø‡ ‡‡‡≤‡‡Ø‡‡æ-‡∞‡‡‡Æ‡ :
--     Vak (suc n) ‚â Vak n ‚ä Vak n
-- (‡‡¶‡ø-‡‡ï‡‡‡∞‡‡ ‡µ‡ø‡‡æ‡ó‡) ‚î ‡‡¶‡Æ‡ ‡‡µ ‡‡‡ñ‡‡Ø‡æ-‡¶‡‡µ‡ø‡ó‡‡‡‡‡Ø ‡Æ‡‡≤-‡‡‡‡‡, ‡® ‡‡‡‡ï‡ ‡ó‡‡®‡æ ‡
-- ‡Æ‡æ‡‡‡∞‡æ-‡µ‡‡‡‡‡ matrameruIso (Metre) ‡‡‡‡‡ø ; ‡‡‡‡∞ ‡µ‡∞‡‡-‡µ‡‡‡‡‡ (Vak) ‡‡‡ ‡‡æ‡ß‡ø‡‡Æ‡ ‡
--
-- (Pigala's sakhy pratyaya says n-syllable metres number 2‚ø, encoded as
--  count(suc n) = count n + count n ‚î but that recurrence only COUNTS.
--  Why does it double?  Because every (n+1)-syllable metre is exactly one of
--  two things: a laghu followed by an n-metre, or a guru followed by one ‚î
--  a type equivalence Vak (suc n) ‚â Vak n ‚ä Vak n, split by the first
--  syllable.  This is the OBJECT-level root of the doubling, from which the
--  count follows, not a separate arithmetic fact.  The mtr-vtta already had
--  matrameruIso for Metre; this supplies the vara-vtta (Vak) analogue.)
--
-- ‡‡‡∞‡ã‡‡æ‡‡‡ø : ‡‡ø‡ô‡‡ó‡≤‡, ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ (‡‡‡∞‡‡‡‡æ‡∞‡, ‡‡‡ñ‡‡Ø‡æ) ; ‡‡≤‡æ‡Ø‡‡ß‡ (‡Æ‡‡∞‡-‡µ‡‡Ø‡æ‡ñ‡‡Ø‡æ) ‡
------------------------------------------------------------------------

module AksaraDviguna where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; injSuc ; znots)
open import Cubical.Data.Nat.Properties using (isSet‚Ñï)
open import Cubical.Data.List using (_‚à∑_ ; [])
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; Œ£‚â°Prop)
open import Cubical.Data.Empty using (rec)
open import PingalaPrastara using (Syllable ; laghu ; guru ; Pattern ; varna ; Vak)

------------------------------------------------------------------------
-- ‡‡ó‡‡∞‡ ‚î ‡‡¶‡ø-‡‡ï‡‡‡∞‡‡ ‡µ‡ø‡‡æ‡ó‡ : ‡≤‡ò‡‡ ‚í ‡µ‡æ‡Æ‡Æ‡ (inl), ‡ó‡‡∞‡‡ ‚í ‡¶‡ï‡‡‡ø‡‡Æ‡ (inr) ‡
-- ‡∞‡ø‡ï‡‡‡ ‡‡‡Æ‡‡‡µ‡ (varna [] = 0 ‚â suc n) ‡
------------------------------------------------------------------------

‡§Ö‡§ó‡•ç‡§∞‡•á : (n : ‚Ñï) ‚Üí Vak (suc n) ‚Üí Vak n ‚äé Vak n
‡§Ö‡§ó‡•ç‡§∞‡•á n ([]         , e) = rec (znots e)
‡§Ö‡§ó‡•ç‡§∞‡•á n (laghu ‚à∑ p  , e) = inl (p , injSuc e)
‡§Ö‡§ó‡•ç‡§∞‡•á n (guru  ‚à∑ p  , e) = inr (p , injSuc e)

------------------------------------------------------------------------
-- ‡‡‡‡‡æ‡‡ ‚î ‡‡¶‡ø-‡‡ï‡‡‡∞-‡‡‡∞‡ï‡‡‡‡‡ : ‡µ‡æ‡Æ‡ ‡≤‡ò‡‡, ‡¶‡ï‡‡‡ø‡‡ ‡ó‡‡∞‡‡ ‡‡‡∞‡‡ ‡Ø‡ã‡‡‡Ø‡‡ ‡
------------------------------------------------------------------------

‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç : (n : ‚Ñï) ‚Üí Vak n ‚äé Vak n ‚Üí Vak (suc n)
‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n (inl (p , e)) = (laghu ‚à∑ p , cong suc e)
‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n (inr (p , e)) = (guru  ‚à∑ p , cong suc e)

------------------------------------------------------------------------
-- ‡‡∞‡ø‡µ‡‡‡‡‡ ‚î ‡â‡‡ ‡‡‡∞‡‡ø‡≤‡ã‡Æ‡ ; ‡‡ï‡‡‡∞-‡‡‡‡ refl, ‡Æ‡æ‡®-‡‡‡‡ ‡‡‡∞‡Æ‡æ‡-‡∞‡‡‡‡ (isSet‚ï) ‡
------------------------------------------------------------------------

‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç-‡§Ö‡§ó‡•ç‡§∞‡•á : (n : ‚Ñï) (x : Vak (suc n)) ‚Üí ‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n (‡§Ö‡§ó‡•ç‡§∞‡•á n x) ‚â° x
‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç-‡§Ö‡§ó‡•ç‡§∞‡•á n ([]        , e) = rec (znots e)
‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç-‡§Ö‡§ó‡•ç‡§∞‡•á n (laghu ‚à∑ p , e) = Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl
‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç-‡§Ö‡§ó‡•ç‡§∞‡•á n (guru  ‚à∑ p , e) = Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl

‡§Ö‡§ó‡•ç‡§∞‡•á-‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç : (n : ‚Ñï) (y : Vak n ‚äé Vak n) ‚Üí ‡§Ö‡§ó‡•ç‡§∞‡•á n (‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n y) ‚â° y
‡§Ö‡§ó‡•ç‡§∞‡•á-‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n (inl (p , e)) = cong inl (Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl)
‡§Ö‡§ó‡•ç‡§∞‡•á-‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n (inr (p , e)) = cong inr (Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl)

------------------------------------------------------------------------
-- ‡¶‡‡µ‡ø‡ó‡‡-‡µ‡æ‡ï‡ ‚î ‡Æ‡‡ñ‡‡Ø-‡‡≤‡Æ‡ : Vak (suc n) ‚â Vak n ‚ä Vak n (‡‡‡ñ‡‡Ø‡æ-‡¶‡‡µ‡ø‡ó‡‡‡‡‡Ø ‡Æ‡‡≤‡Æ‡) ‡
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£-Iso : (n : ‚Ñï) ‚Üí Iso (Vak (suc n)) (Vak n ‚äé Vak n)
‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£-Iso n = iso (‡§Ö‡§ó‡•ç‡§∞‡•á n) (‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n) (‡§Ö‡§ó‡•ç‡§∞‡•á-‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç n) (‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç-‡§Ö‡§ó‡•ç‡§∞‡•á n)

‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£-‡§µ‡§æ‡§ï‡•ç : (n : ‚Ñï) ‚Üí Vak (suc n) ‚âÉ (Vak n ‚äé Vak n)
‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£-‡§µ‡§æ‡§ï‡•ç n = isoToEquiv (‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£-Iso n)
