{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Æ‡æ‡®‡Æ‡æ‡∞‡‡ó‡ ‚î the hand road and the transport road are ONE path.
--
-- WHAT THIS REPAIRS.  `LosslessReturn_TheHandProofWasUnnecessary‚¶agda` ¬ß5
-- asserts, in prose, that its transport-built path (‚ïó‚ï) ‚â° ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡
-- "is the same path the hand proof produced", giving as the reason:
-- "the two constructions have the same endpoints and there was only ever
-- one equivalence to have."  The lemma it then names `‡‡Æ‡æ‡®-‡Æ‡æ‡∞‡‡ó‡` proves
-- only  ‡â‡‡‡‡æ‡® (‡‡µ‡‡∞‡ x) ‚â° x  ‚î a round trip of the underlying map ‚î and
-- NOT the equality of the two universe-paths its own prose claims.  The
-- stated reason is moreover false as written: in HoTT two paths with the
-- same endpoints need not be equal (that is exactly the content of "a type
-- is not a set"), and a type in general carries many self-equivalences, so
-- "the same endpoints, one equivalence" does not, by itself, give one path.
--
-- The claim is nonetheless TRUE.  This module discharges it as a checked
-- term rather than a slogan, so the identification ¬ß5 wanted is present in
-- the machine and not only in its margin.
--
-- HOW.  `ua` is (one leg of) an equivalence, hence injective; so it is
-- enough to compare what sits under each road.  The hand road is
-- `isoToPath iso = ua (isoToEquiv iso)`, one `ua`.  The transport road is
-- `ua (Carrier‚â ‡Ø‡ã‡ó) ‚àô sym (ua ‡µ‡ø‡µ‡‡ï‚â‡µ‡æ‡‡ï‡)`, which `uaInvEquiv` and
-- `uaCompEquiv` fold back into a single `ua` of one composite equivalence.
-- Those two equivalences have JUDGMENTALLY equal underlying functions ‚î
-- the composite sends (s,l) to a record whose ‡‡‡∞‡Æ‡æ‡ field is `sym refl`,
-- the hand map to the same record with ‡‡‡∞‡Æ‡æ‡ = `refl`, and `sym refl` is
-- `refl` definitionally ‚î so `equivEq (funExt Œª _ ‚í refl)` closes it and
-- `cong ua` lifts it to the paths.  There was, indeed, only one
-- equivalence; the point is that "only one equivalence" is a THEOREM here
-- (equivEq on judgmentally-equal maps), not a reason one may state and skip.
--
-- WHAT IS NOT TOUCHED.  Neither `LosslessReturn_‚¶` nor `VivekaPramana_‚¶` is
-- edited (‡®‡Ø‡‡‡¶‡ ‡‡ô‡‡ï‡‡‡‡‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡ ‚î ¬ß7 of the ahis-stra: no collapsing
-- of a standpoint by deletion).  This is a new road laid beside theirs,
-- carrying the derivation their road only gestured at.
------------------------------------------------------------------------

module SamanaMarga_TheHandPathAndTheTransportPathAreOnePath where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; _‚àô‚Çë_ ; invEquiv ; equivEq)
open import Cubical.Foundations.Isomorphism using (isoToPath ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaCompEquiv ; uaInvEquiv)
open import Cubical.Data.Nat using (‚Ñï ; _+_)
open import Cubical.Data.Sigma using (_√ó_)

import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as V
import LosslessReturn_TheHandProofWasUnnecessaryAndTransportGivesIt as P

------------------------------------------------------------------------
-- ‡ß ¬ The two equivalences underneath the two roads are the same map.
--
-- The composite  Carrier‚â ‡Ø‡ã‡ó  then  invEquiv ‡µ‡ø‡µ‡‡ï‚â‡µ‡æ‡‡ï‡  equals, as an
-- equivalence, the hand-built  isoToEquiv iso‚ïó‚ï-‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡.  Their
-- forward functions are judgmentally equal (the only difference is
-- `sym refl` versus `refl` in the ‡‡‡∞‡Æ‡æ‡ component), so funext is refl.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡•Å‡§≤‡•ç‡§Ø‡§Æ‡•ç :
  (P.Carrier‚âÉ P.‡§Ø‡•ã‡§ó ‚àô‚Çë invEquiv P.‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É)
    ‚â° isoToEquiv V.iso‚Ñï√ó‚Ñï-‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡•Å‡§≤‡•ç‡§Ø‡§Æ‡•ç = equivEq (funExt Œª _ ‚Üí refl)

------------------------------------------------------------------------
-- ‡® ¬ Therefore the two roads are one path.
--
-- Reduce the transport road to a single `ua`, swap in the equal
-- equivalence, and land on the hand road ‚î every step a univalence lemma
-- or `cong ua` of ¬ß1.
------------------------------------------------------------------------

‡§∏‡§Æ‡§æ‡§®‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : V.‚Ñï√ó‚Ñï‚â°‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ‚â° P.‚Ñï√ó‚Ñï‚â°‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
‡§∏‡§Æ‡§æ‡§®‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É =
    V.‚Ñï√ó‚Ñï‚â°‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
  ‚â°‚ü® refl ‚ü©                                       -- isoToPath = ua ‚àò isoToEquiv
    ua (isoToEquiv V.iso‚Ñï√ó‚Ñï-‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£)
  ‚â°‚ü® cong ua (sym ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡•Å‡§≤‡•ç‡§Ø‡§Æ‡•ç) ‚ü©
    ua (P.Carrier‚âÉ P.‡§Ø‡•ã‡§ó ‚àô‚Çë invEquiv P.‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É)
  ‚â°‚ü® uaCompEquiv (P.Carrier‚âÉ P.‡§Ø‡•ã‡§ó) (invEquiv P.‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É) ‚ü©
    ua (P.Carrier‚âÉ P.‡§Ø‡•ã‡§ó) ‚àô ua (invEquiv P.‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É)
  ‚â°‚ü® cong (ua (P.Carrier‚âÉ P.‡§Ø‡•ã‡§ó) ‚àô_) (uaInvEquiv P.‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É) ‚ü©
    ua (P.Carrier‚âÉ P.‡§Ø‡•ã‡§ó) ‚àô sym (ua P.‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É)
  ‚àé
