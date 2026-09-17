{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ó‡‡‡‡Ø-‡®‡æ‡‡‡‡ø ‚î the concealed loss: it can hide in the loops, and the
-- set-level census cannot see it.
--
-- THE LIMIT OF EVERYTHING LANDED TODAY, exhibited from inside cubespace.
-- `SakalaVikalaDesa`'s trichotomy ‚î and my own `‡ó‡‡®‡æ-‡‡‡‡‡‡ô‡‡ó‡` ‚î grade a
-- fibre by its POINTS: empty (‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡), one up to path (‡‡ï‡≤‡æ‡¶‡‡), or two
-- exhibitably distinct (‡µ‡ø‡ï‡≤‡æ‡¶‡‡).  In cubespace there is a fourth
-- condition of a fibre, and it defeats all three detectors at once:
--
--     the fibre of  ‡‡ø‡®‡‡¶‡ : S¬ ‚í Unit  at tt  is S¬ itself, and S¬ is
--
--       inhabited                     ‚î ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ cannot fire;
--       merely connected: any two
--       points are ‚à¬‚à‚-equal          ‚î ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ cannot fire, because no
--                                        exhibitably distinct pair EXISTS;
--       yet not a proposition, hence
--       not contractible               ‚î ‡‡ï‡≤‡æ‡¶‡‡ cannot fire either.
--
-- The crowding is real and it is INVISIBLE AT POINTS: it lives one
-- dimension up, in the loops, and it is not "some loss" ‚î it is exactly
-- ‚ (`winding`, Œ©S¬Iso‚), the same charge `Durnaya_‚¶` identified as what
-- every set-valued carrier-observable destroys.  The concealed ‡®‡æ‡‡‡‡ø of
-- this fibre IS the gauge charge.
--
-- WHAT THIS MEANS FOR THE CENSUS, said exactly.  The trichotomy's
-- exhaustiveness was a SET-LEVEL theorem: for fibres that are sets, the
-- three verdicts cover.  For higher fibres the sevenfold does not
-- disappear ‚î it RESTRATIFIES: at each h-level the same three seeds
-- reappear (here: œ‚-‡‡ï‡≤, œ‚-‡‡‡ with charge ‚).  Sydvda is graded by
-- dimension; a census that stops at points is a durnaya one storey up,
-- and this module is its checked counterexample.
--
-- No claim that any Jain author graded predication by h-level.  The
-- claim is that their refusal to let one standpoint exhaust the object
-- is, in cubespace, a THEOREM about which fibres a pointwise census can
-- classify.  ‡ó‡‡‡‡Ø-‡®‡æ‡‡‡‡ø is built here, 2026-08-23.
------------------------------------------------------------------------

module GuhyaNasti_TheLossCanHideInTheLoopsAndTheSetLevelCensusCannotSeeIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd ; Œ£‚â°Prop)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; suc‚Ñ§)
open import Cubical.Data.Nat using (zero ; suc ; znots)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Foundations.GroupoidLaws using (rUnit)
open import Cubical.HITs.PropositionalTruncation using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; map ; rec ; isPropPropTrunc)
open import Cubical.HITs.S1
  using (S¬π ; base ; loop ; Œ©S¬π ; winding ; intLoop ; winding‚Ñ§Loop ; isConnectedS¬π)

------------------------------------------------------------------------
-- ‡ß ¬ the map, and its fibre identified: ‡‡‡ ‡‡ø‡®‡‡¶‡ tt ‚â S¬.
------------------------------------------------------------------------

‡§¨‡§ø‡§®‡•ç‡§¶‡•Å : S¬π ‚Üí Unit
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å _ = tt

‡§∂‡•á‡§∑ : Unit ‚Üí Type
‡§∂‡•á‡§∑ u = Œ£[ s ‚àà S¬π ] (‡§¨‡§ø‡§®‡•ç‡§¶‡•Å s ‚â° u)

‡§∂‡•á‡§∑‚âÉS¬π : ‡§∂‡•á‡§∑ tt ‚âÉ S¬π
‡§∂‡•á‡§∑‚âÉS¬π = isoToEquiv (iso fst (Œª s ‚Üí s , refl)
                         (Œª _ ‚Üí refl)
                         (Œª (s , p) i ‚Üí s , isSetUnit tt tt refl p i))

------------------------------------------------------------------------
-- ‡® ¬ ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ cannot fire: the fibre is inhabited.
------------------------------------------------------------------------

‡§∏‡§§‡•ç‡§§‡•ç‡§µ‡§Æ‡•ç : ‡§∂‡•á‡§∑ tt
‡§∏‡§§‡•ç‡§§‡•ç‡§µ‡§Æ‡•ç = base , refl

------------------------------------------------------------------------
-- ‡© ¬ ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ cannot fire: any two points of the fibre are MERELY equal ‚î
-- no exhibitably distinct pair exists to name.
------------------------------------------------------------------------

‡§Æ‡•Å‡§ï‡•ç‡§§-‡§∏‡§Æ‡•ç‡§¨‡§®‡•ç‡§ß‡§É : (x y : ‡§∂‡•á‡§∑ tt) ‚Üí ‚à• x ‚â° y ‚à•‚ÇÅ
‡§Æ‡•Å‡§ï‡•ç‡§§-‡§∏‡§Æ‡•ç‡§¨‡§®‡•ç‡§ß‡§É (x , p) (y , q) =
  map (Œª (r : x ‚â° y) ‚Üí Œ£‚â°Prop (Œª s ‚Üí isSetUnit (‡§¨‡§ø‡§®‡•ç‡§¶‡•Å s) tt) r)
      (‡§∏‡§Æ‡•ç‡§¨‡§¶‡•ç‡§ß‡§Æ‡•ç x y)
  where
    ‡§∏‡§Æ‡•ç‡§¨‡§¶‡•ç‡§ß‡§Æ‡•ç : (x y : S¬π) ‚Üí ‚à• x ‚â° y ‚à•‚ÇÅ
    ‡§∏‡§Æ‡•ç‡§¨‡§¶‡•ç‡§ß‡§Æ‡•ç x y =
      rec isPropPropTrunc
        (Œª (px : base ‚â° x) ‚Üí
          map (Œª (py : base ‚â° y) ‚Üí sym px ‚àô py) (isConnectedS¬π y))
        (isConnectedS¬π x)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡ï‡≤‡æ‡¶‡‡ cannot fire either: the fibre is NOT a proposition.  If every
-- two points were (exhibitably) equal, transporting along ‡‡‡‚âS¬ would make
-- S¬ a proposition, forcing loop ‚â° refl ‚î and winding refutes that with the
-- charge: 1 ‚â 0 in ‚.
------------------------------------------------------------------------

‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø : ¬¨ (pos (suc zero) ‚â° pos zero)
‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø p = znots (sym (cong ‡§Ö‡§ô‡•ç‡§ï p))
  where
    ‡§Ö‡§ô‡•ç‡§ï : ‚Ñ§ ‚Üí _
    ‡§Ö‡§ô‡•ç‡§ï (pos n) = n
    ‡§Ö‡§ô‡•ç‡§ï _       = zero

‡§µ‡§ï‡•ç‡§∞-‡§Ö‡§®‡§ø‡§µ‡§æ‡§∞‡•ç‡§Ø‡§Æ‡•ç : ¬¨ (loop ‚â° refl)
‡§µ‡§ï‡•ç‡§∞-‡§Ö‡§®‡§ø‡§µ‡§æ‡§∞‡•ç‡§Ø‡§Æ‡•ç p =
  ‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø (sym (winding‚Ñ§Loop (pos (suc zero))) ‚àô cong winding lem ‚àô refl)
  where
    -- intLoop 1 = refl ‚àô loop; with p : loop ‚â° refl its winding is 0.
    lem : intLoop (pos (suc zero)) ‚â° refl
    lem = (Œª i ‚Üí intLoop (pos zero) ‚àô p i) ‚àô sym (rUnit refl)

‡§®-‡§™‡•ç‡§∞‡•ã‡§™‡•ç : ¬¨ ((x y : ‡§∂‡•á‡§∑ tt) ‚Üí x ‚â° y)
‡§®-‡§™‡•ç‡§∞‡•ã‡§™‡•ç h = ‡§µ‡§ï‡•ç‡§∞-‡§Ö‡§®‡§ø‡§µ‡§æ‡§∞‡•ç‡§Ø‡§Æ‡•ç loop‚â°refl
  where
    -- a prop that is inhabited is contractible; contract S¬ through ‡‡‡‚âS¬
    prS¬π : (x y : S¬π) ‚Üí x ‚â° y
    prS¬π x y i = fst (h (x , refl) (y , refl) i)
    loop‚â°refl : loop ‚â° refl
    loop‚â°refl i j =
      hcomp (Œª k ‚Üí Œª { (i = i0) ‚Üí prS¬π base (loop j) k
                     ; (i = i1) ‚Üí prS¬π base base k
                     ; (j = i0) ‚Üí prS¬π base base k
                     ; (j = i1) ‚Üí prS¬π base base k })
            base

------------------------------------------------------------------------
-- ‡ ¬ the concealed charge is exactly ‚: what the pointwise census cannot
-- see is not "some crowding" but the winding ‚î identified, not bounded.
-- (The library's Œ©S¬Iso‚ is the identification; re-exported here as the
-- fibre's own loop charge through ‡‡‡‚âS¬'s base point.)
------------------------------------------------------------------------

‡§ó‡•Å‡§π‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É : (‡§∏‡§§‡•ç‡§§‡•ç‡§µ‡§Æ‡•ç ‚â° ‡§∏‡§§‡•ç‡§§‡•ç‡§µ‡§Æ‡•ç) ‚Üí ‚Ñ§
‡§ó‡•Å‡§π‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É p = winding (Œª i ‚Üí fst (p i))

‡§ó‡•Å‡§π‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É : Œ£[ p ‚àà (‡§∏‡§§‡•ç‡§§‡•ç‡§µ‡§Æ‡•ç ‚â° ‡§∏‡§§‡•ç‡§§‡•ç‡§µ‡§Æ‡•ç) ] (¬¨ (‡§ó‡•Å‡§π‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É p ‚â° pos zero))
‡§ó‡•Å‡§π‡•ç‡§Ø-‡§≠‡§æ‡§∞‡§É-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É =
  (Œª i ‚Üí loop i , refl) ,
  Œª q ‚Üí ‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø (sym (winding‚Ñ§Loop (pos (suc zero)))
                  ‚àô cong winding (sym (rUnit loop)) ‚àô q)

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡.  This does not overturn the set-level census ‚î for fibres
-- that are sets its trichotomy is exhaustive and everything landed today
-- stands.  What it proves is the census's own SCOPE: h-level is a
-- hypothesis, not a formality, and above it the seeds restratify.  The
-- graded census (one sevenfold per dimension) is named here and NOT
-- built; building it without a criterion for how the levels interact
-- would be the durnaya this corpus keeps catching, one storey up.
------------------------------------------------------------------------
