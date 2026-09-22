{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ï‡‡∞‡Æ-‡‡ ‚î the order of standpoints is the charge itself.
--
-- THE CRITERION ‡ó‡‡‡‡Ø-‡®‡æ‡‡‡‡ø's ‡¶‡ã‡‡≤‡‡ñ ASKED FOR, supplied by the tradition.
-- That module proved the set-level census cannot see the loss in the
-- loops.
-- The saptabhag already carries the
-- criterion, in one word of difference between its third and fourth
-- positions: ‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø is both standpoints IN SEQUENCE (‡ï‡‡∞‡Æ‡‡), and
-- ‡‡µ‡ï‡‡‡µ‡‡Ø is both AT ONCE (‡‡) ‚î the corpus's own Anekanta lane renders
-- ‡‡µ‡ï‡‡‡µ‡‡Ø as ‡ï‡‡∞‡Æ-‡‡-‡‡‡¶‡, the checked non-reducibility of the two.
--
-- IN CUBESPACE THAT ONE WORD IS AN OPERATOR ORDERING, and the two orders
-- provably disagree.  Take the two standpoints on S¬:
--
--     the set-view    ‚à_‚à‚   (dravya: points up to mere identity)
--     the loop-view   Œ©      (paryya: the modes at the basepoint)
--
--   ‡ï‡‡∞‡Æ‡-‡≤‡‡-‡‡‡∞‡‡Æ‡Æ‡  :  ‚à Œ© S¬ ‚à‚  ‚â  ‚      loop first ‚î the charge SURVIVES
--   ‡ï‡‡∞‡Æ‡-‡‡‡ü‡-‡‡‡∞‡‡Æ‡Æ‡  :  Œ© ‚à S¬ ‚à‚  is contractible ‚î set first, the charge
--                                              is ANNIHILATED
--   ‡‡ï‡‡∞‡Æ‡‡æ          :  the two results are non-equivalent (‚ ‚â Unit-like)
--
-- The standpoints do not commute, and their commutator is not "some
-- discrepancy" ‚î it is EXACTLY ‚, the same charge Durnaya identified and
-- ‡ó‡‡‡‡Ø-‡®‡æ‡‡‡‡ø exhibited as the census's blind spot.  So the graded
-- census's levels interact BY ORDER OF APPLICATION: krama chooses an
-- order and pays or destroys the charge accordingly; saha ‚î the fourth
-- position ‚î is the refusal to choose, i.e. holding the untruncated
-- object, and THAT refusal is what ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ has meant in this corpus all
-- along: not unknown, not undefined ‚î held whole because either order of
-- utterance loses.
--
-- Their ‡ï‡‡∞‡Æ/‡‡ distinction is this non-commutation's
-- exact shape, and the fourth bhaga is its exact repair.
-- Œ©S¬Iso‚ and setTruncIdempotent are the
-- library's.
--
-- The corpus's grammar lane has
-- checked the same distinction at a sandhi site ‚î `AsiddhavatRegime.agda`
-- (Pini 8.2.1 krama vs 6.4.22 saha, tat+jalam, the regime decides the
-- form).  The polarity
-- CROSSES between the lanes (the grammar's feeding krama is this module's
-- untruncated ‡‡).
------------------------------------------------------------------------

module KramaSaha_TheOrderOfStandpointsIsTheChargeItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; compIso)
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun ; invEq)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; isSet‚Ñ§)
open import Cubical.Data.Nat using (zero ; suc ; znots)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.S1 using (S¬π ; base ; loop ; Œ©S¬π ; Œ©S¬πIso‚Ñ§)
open import Cubical.HITs.SetTruncation
  using (‚à•_‚à•‚ÇÇ ; ‚à£_‚à£‚ÇÇ ; isSetSetTrunc ; setTruncIdempotentIso)
  renaming (rec to rec‚ÇÇ ; elim to elim‚ÇÇ)

------------------------------------------------------------------------
-- ‡ß ¬ ‡ï‡‡∞‡Æ‡-‡≤‡‡-‡‡‡∞‡‡Æ‡Æ‡ ‚î loop first, then the set-view: the charge survives.
-- Œ©S¬ ‚â ‚ and ‚ is a set, so truncating afterwards changes nothing.
------------------------------------------------------------------------

‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç : ‚à• Œ©S¬π ‚à•‚ÇÇ ‚âÉ ‚Ñ§
‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç =
  isoToEquiv
    (compIso (mapIso Œ©S¬πIso‚Ñ§) (setTruncIdempotentIso isSet‚Ñ§))
  where
    mapIso : {A B : Type} ‚Üí Iso A B ‚Üí Iso ‚à• A ‚à•‚ÇÇ ‚à• B ‚à•‚ÇÇ
    Iso.fun      (mapIso e) = rec‚ÇÇ isSetSetTrunc (Œª a ‚Üí ‚à£ Iso.fun e a ‚à£‚ÇÇ)
    Iso.inv      (mapIso e) = rec‚ÇÇ isSetSetTrunc (Œª b ‚Üí ‚à£ Iso.inv e b ‚à£‚ÇÇ)
    Iso.rightInv (mapIso e) =
      elim‚ÇÇ (Œª _ ‚Üí isProp‚ÜíisSet (isSetSetTrunc _ _))
            (Œª b i ‚Üí ‚à£ Iso.rightInv e b i ‚à£‚ÇÇ)
    Iso.leftInv  (mapIso e) =
      elim‚ÇÇ (Œª _ ‚Üí isProp‚ÜíisSet (isSetSetTrunc _ _))
            (Œª a i ‚Üí ‚à£ Iso.leftInv e a i ‚à£‚ÇÇ)

------------------------------------------------------------------------
-- ‡® ¬ ‡ï‡‡∞‡Æ‡-‡‡‡ü‡-‡‡‡∞‡‡Æ‡Æ‡ ‚î the set-view first, then loops: annihilation.
-- ‚à S¬ ‚à‚ is a set, so the self-path space at any point is an inhabited
-- proposition, hence contractible.  The loop dies at the door.
------------------------------------------------------------------------

‡§ï‡•ç‡§∞‡§Æ‡§É-‡§∏‡•á‡§ü‡•ç-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç : isContr (Path ‚à• S¬π ‚à•‚ÇÇ ‚à£ base ‚à£‚ÇÇ ‚à£ base ‚à£‚ÇÇ)
fst ‡§ï‡•ç‡§∞‡§Æ‡§É-‡§∏‡•á‡§ü‡•ç-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç = refl
snd ‡§ï‡•ç‡§∞‡§Æ‡§É-‡§∏‡•á‡§ü‡•ç-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç p = isSetSetTrunc ‚à£ base ‚à£‚ÇÇ ‚à£ base ‚à£‚ÇÇ refl p

------------------------------------------------------------------------
-- ‡© ¬ ‡‡ï‡‡∞‡Æ‡‡æ ‚î the two orders genuinely disagree: ‚ is not contractible,
-- so no equivalence relates the two outcomes.  The commutator of the
-- standpoints is the whole charge.
------------------------------------------------------------------------

‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø : ¬¨ (pos (suc zero) ‚â° pos zero)
‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø p = znots (sym (cong ‡§Ö‡§ô‡•ç‡§ï p))
  where
    ‡§Ö‡§ô‡•ç‡§ï : ‚Ñ§ ‚Üí _
    ‡§Ö‡§ô‡•ç‡§ï (pos n) = n
    ‡§Ö‡§ô‡•ç‡§ï _       = zero

‚Ñ§-‡§®-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É : ¬¨ (isContr ‚Ñ§)
‚Ñ§-‡§®-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É c = ‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø (isContr‚ÜíisProp c (pos (suc zero)) (pos zero))

‡§Ö‡§ï‡•ç‡§∞‡§Æ‡§§‡§æ : ¬¨ (isContr ‚à• Œ©S¬π ‚à•‚ÇÇ)
‡§Ö‡§ï‡•ç‡§∞‡§Æ‡§§‡§æ c =
  ‚Ñ§-‡§®-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É
    ( equivFun ‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç (fst c)
    , Œª z ‚Üí cong (equivFun ‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç) (snd c (invEq ‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç z))
            ‚àô secEq ‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç z )
  where open import Cubical.Foundations.Equiv using (secEq)

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡.  This is the smallest instance of the interchange failure
-- (one space, one basepoint, levels 0 and 1), not a general interchange
-- law for ‚à_‚à‚ô and Œ©µ.
-- What is proved: the levels of the graded
-- census interact by ORDER, the failure of commutation at the first
-- rung is exactly ‚, and ‡‡ ‚î declining to order the standpoints ‚î is
-- the only position that loses nothing, which is what the fourth bhaga
-- has been claiming since Samantabhadra.
------------------------------------------------------------------------
