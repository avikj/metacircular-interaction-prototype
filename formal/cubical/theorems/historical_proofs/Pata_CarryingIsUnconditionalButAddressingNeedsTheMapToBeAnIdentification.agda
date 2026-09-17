{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡æ ‚î ‡µ‡‡®‡ ‡®‡ø‡∞‡‡‡æ‡ß‡ø‡ï‡Æ‡, ‡‡ô‡‡ï‡®‡ ‡‡ ‡‡Æ‡‡æ‡Æ‡ ‡‡‡‡ï‡‡‡‡ ‡
--
-- (the address: carrying is unconditional, but addressing requires the
--  map to be an identification.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE DISTINCTION, which this corpus uses everywhere and states nowhere.
--
-- The carrier law gives `A ‚â Carrier f` for EVERY f, with no hypothesis:
-- a derived datum may always be kept alongside what it was derived from,
-- because the fibre `singl (f a)` is contractible.  That is a RECEIPT.
--
-- It does not follow that you may throw the base away.  For that you need
-- to get the base BACK from the datum, and `loss/‚¶/Prastara_‚¶`
-- is where the difference becomes a theorem rather than a caution.  Two
-- maps out of the same base behave oppositely:
--
--   ‡Æ‡æ‡‡‡∞‡æ : ‡∞‡‡ ‚í ‚ï    carriable, and the ‡∞‡‡ is NOT a function of it ‚î
--                      ‡≤‡ò‡ ‡≤‡ò‡ and ‡ó‡‡∞‡ both weigh 2.
--   ‡â‡¶‡‡¶‡ø‡‡‡ü : ‡∞‡‡ ‚í ‚ï    carriable, AND invertible by ‡®‡‡‡ü, so the reverse
--                      Carrier also exists and
--                          ‡‡‡∞‡‡‡‡æ‡∞ ‚â° ‡∞‡‡ ‚â° ‚ï ‚â° ‡‡‡∞‡‡ø‡‡‡∞‡‡‡‡æ‡∞.
--                      Base and carried may be EXCHANGED.
--
-- and that exchange is exactly what makes ‡®‡‡‡ü/‡â‡¶‡‡¶‡ø‡‡‡ü a storage-free
-- addressing scheme: keep the ‚ï, drop the ‡∞‡‡, recompute it when wanted,
-- and nothing has been lost.
--
-- So: RECEIPT is unconditional and ADDRESS is not, and the condition is
-- precisely that the map is an identification.  ¬ß‡® and ¬ß‡© are those two
-- statements; ¬ß‡ is Pigala's own counterexample, which is why the
-- distinction is a theorem here and not a style note.
--
-- WHY IT MATTERS OUTSIDE THE MATHEMATICS.  This machine is
-- content-addressed: `machine/Nama_‚¶` names a definition by a digest over
-- it AND its dependencies, and things are dropped and recomputed on that
-- basis.  Every such scheme is a bet that the naming map is an address
-- and not merely a receipt, and ¬ß‡ is the shape of the bet going wrong ‚î
-- two distinct objects under one name, recovered as neither.  Stating the
-- criterion does not audit any particular scheme and no such audit is
-- claimed here.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- SOURCES. Pigala, ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ.‡®‡©‚ì‡©‡ (~300 BCE) ‚î the ‡‡‡∞‡‡‡Ø‡Ø‡æ‡, of
-- which ‡®‡‡‡ü (given a place, recover the pattern) and ‡â‡¶‡‡¶‡ø‡‡‡ü (given the
-- pattern, recover its place) are the two directions, and ‡Æ‡æ‡‡‡∞‡æ (‡≤‡ò‡ = 1,
-- ‡ó‡‡∞‡ = 2) is the weight. Worked with the array in Halyudha, ‡Æ‡‡‡‡û‡‡‡‡µ‡®‡
-- (10th c. CE). What is claimed is that ‡Æ‡æ‡‡‡∞‡æ is the weight his enumeration
-- uses and that two distinct patterns share a weight, which ¬ß‡ exhibits
-- rather than asserts.  ‡‡‡æ is ordinary modern /Hindi for an address
-- and no text is claimed for it.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; isEquiv ; invEquiv ; equivFun)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd ; Œ£-contractSnd)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡ó‡‡∞‡æ‡ ‚î the graph, and its two readings.  Written with Œ directly
--     rather than as a record, because this lane has no general Carrier
--     type; the loss library packages the same Œ as one.
------------------------------------------------------------------------

‡§ó‡•ç‡§∞‡§æ‡§π : {A B : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí Type ‚Ñì
‡§ó‡•ç‡§∞‡§æ‡§π {A = A} {B = B} f = Œ£[ a ‚àà A ] Œ£[ b ‚àà B ] (f a ‚â° b)

------------------------------------------------------------------------
-- ‡® ¬ ‡µ‡‡®‡Æ‡ ‚î THE RECEIPT, unconditional.
--
--     The graph is the base.  No hypothesis on f whatsoever: the inner Œ
--     is `singl (f a)`, contractible, and contracts away.  This is the
--     whole of "carrying determined data is free", and the freeness is
--     what makes it a receipt rather than a bet.
------------------------------------------------------------------------

‡§µ‡§π‡§®‡§Æ‡•ç : {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí ‡§ó‡•ç‡§∞‡§æ‡§π f ‚âÉ A
‡§µ‡§π‡§®‡§Æ‡•ç {A = A} f = Œ£-contractSnd (Œª a ‚Üí isContrSingl (f a))

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡æ ‚î THE ADDRESS, and its exact condition.
--
--     To DROP the base and keep only the datum you need the base back,
--     which is a recovery map with both round trips.  That is precisely
--     an isomorphism, hence an identification ‚î so "may I store the datum
--     instead of the object?" is not a storage question, it is the
--     question whether f is an equivalence.
------------------------------------------------------------------------

‡§™‡§§‡§æ : {A B : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí Type ‚Ñì
‡§™‡§§‡§æ {A = A} {B = B} f =
  Œ£[ g ‚àà (B ‚Üí A) ] (((a : A) ‚Üí g (f a) ‚â° a) √ó ((b : B) ‚Üí f (g b) ‚â° b))

-- an address IS an identification
‡§™‡§§‡§æ‚Üí‡§∏‡§Æ‡§§‡§æ : {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí ‡§™‡§§‡§æ f ‚Üí A ‚âÉ B
‡§™‡§§‡§æ‚Üí‡§∏‡§Æ‡§§‡§æ f (g , ret , sec) = isoToEquiv (iso f g sec ret)

-- and the base is recoverable from the datum alone, which is the whole
-- operational content: the object may be dropped
‡§™‡•Å‡§®‡§∞‡•Å‡§¶‡•ç‡§ß‡§æ‡§∞‡§É : {A B : Type ‚Ñì} (f : A ‚Üí B) (p : ‡§™‡§§‡§æ f) ‚Üí (a : A) ‚Üí fst p (f a) ‚â° a
‡§™‡•Å‡§®‡§∞‡•Å‡§¶‡•ç‡§ß‡§æ‡§∞‡§É f (g , ret , _) = ret

------------------------------------------------------------------------
-- ‡ ¬ ‡Æ‡æ‡‡‡∞‡æ ‚î PIGALA'S COUNTEREXAMPLE: carriable, not addressable.
--
--     ‡‡ï‡‡‡∞ with ‡≤‡ò‡ weighing 1 and ‡ó‡‡∞‡ weighing 2.  `‡≤‡ò‡ ‚à ‡≤‡ò‡ ‚à []` and
--     `‡ó‡‡∞‡ ‚à []` are distinct patterns of equal weight, so no recovery
--     map can exist ‚î it would have to return both.  ¬ß‡® still applies to
--     ‡Æ‡æ‡‡‡∞‡æ with no hypothesis, which is exactly the point: the receipt
--     is free and the address is denied.
------------------------------------------------------------------------

data ‡§Ö‡§ï‡•ç‡§∑‡§∞ : Type‚ÇÄ where
  ‡§≤‡§ò‡•Å ‡§ó‡•Å‡§∞‡•Å : ‡§Ö‡§ï‡•ç‡§∑‡§∞

‡§∞‡•Ç‡§™ : Type‚ÇÄ
‡§∞‡•Ç‡§™ = List ‡§Ö‡§ï‡•ç‡§∑‡§∞

‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ : ‡§∞‡•Ç‡§™ ‚Üí ‚Ñï
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ []        = zero
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ (‡§≤‡§ò‡•Å ‚à∑ p) = suc (‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ p)
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ (‡§ó‡•Å‡§∞‡•Å ‚à∑ p) = suc (suc (‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ p))

-- the receipt exists, with no hypothesis
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§π‡§®‡§Æ‡•ç : ‡§ó‡•ç‡§∞‡§æ‡§π ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ ‚âÉ ‡§∞‡•Ç‡§™
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§π‡§®‡§Æ‡•ç = ‡§µ‡§π‡§®‡§Æ‡•ç ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ

-- two patterns, one weight
‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å : ‡§∞‡•Ç‡§™
‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å = ‡§≤‡§ò‡•Å ‚à∑ ‡§≤‡§ò‡•Å ‚à∑ []
‡§è‡§ï‡§ó‡•Å‡§∞‡•Å  = ‡§ó‡•Å‡§∞‡•Å ‚à∑ []

‡§§‡•Å‡§≤‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ : ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ ‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å ‚â° ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å
‡§§‡•Å‡§≤‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ = refl

-- and they are distinct: read the head
‡§∂‡§ø‡§∞‡§É : ‡§∞‡•Ç‡§™ ‚Üí Bool
‡§∂‡§ø‡§∞‡§É []        = true
‡§∂‡§ø‡§∞‡§É (‡§≤‡§ò‡•Å ‚à∑ _) = true
‡§∂‡§ø‡§∞‡§É (‡§ó‡•Å‡§∞‡•Å ‚à∑ _) = false

‡§≠‡§ø‡§®‡•ç‡§®-‡§∞‡•Ç‡§™‡•á : ¬¨ (‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å ‚â° ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å)
‡§≠‡§ø‡§®‡•ç‡§®-‡§∞‡•Ç‡§™‡•á p = true‚â¢false (cong ‡§∂‡§ø‡§∞‡§É p)

-- THE DENIAL.  A recovery map would have to send one weight back to two
-- different patterns, so there is none.
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§®-‡§™‡§§‡§æ : ¬¨ (‡§™‡§§‡§æ ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ)
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§®-‡§™‡§§‡§æ (g , ret , _) =
  ‡§≠‡§ø‡§®‡•ç‡§®-‡§∞‡•Ç‡§™‡•á (sym (ret ‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å) ‚àô cong g ‡§§‡•Å‡§≤‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ ‚àô ret ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å)

------------------------------------------------------------------------
-- ‡ ¬ What ¬ß‡ does and does not show.
--
--     It shows ‡Æ‡æ‡‡‡∞‡æ is not an address.  It does NOT show that the
--     ‡‡‡∞‡‡‡‡æ‡∞'s rank map fails to be one ‚î ‡â‡¶‡‡¶‡ø‡‡‡ü IS an address, and the
--     loss module proves it by exhibiting ‡®‡‡‡ü with both round
--     trips.  That direction is not reproved here and is not claimed;
--     what is claimed is only the contrast, which needs just one side to
--     be exhibited to be a distinction rather than a preference.
--
--     And it shows the two are independent properties of the SAME map
--     type, not two grades of one property: `‡Æ‡æ‡‡‡∞‡æ-‡µ‡‡®‡Æ‡` and
--     `‡Æ‡æ‡‡‡∞‡æ-‡®-‡‡‡æ` hold simultaneously of one f.
------------------------------------------------------------------------
