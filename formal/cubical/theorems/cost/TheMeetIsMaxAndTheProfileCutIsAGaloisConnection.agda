{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
--
-- `MinPlusResiduationIsAGaloisConnectionAtOneCut` paid Î” 28 Â§31â“32's
-- residuation obligation for a single burden and single residual, and
-- said exactly what was left:
--
--   "ONE CUT is one burden and one residual â¦ Î” 28's cut carries a
--    PROFILE on each side and its `â` takes a meet over all burdens â”
--    that needs `min` over a finite index and its universal property,
--    not built.  So what this settles is that the obstruction is NOT
--    the residuation law; it is the meet."
--
-- The meet is built and the profile cut is done.  And the meet is NOT
-- `min`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE MEET IS MAX, AND THAT IS THE FINDING.  The previous module had to
-- reverse the order because in min-plus lower cost is better.  A meet
-- in a reversed order is a JOIN in the original, so `â‹` over burdens is
-- `max` in â•, not `min`.  My own sentence above said "needs `min` over
-- a finite index" and was wrong about which operation â” the reversal
-- that was load-bearing for the one-cut adjunction is load-bearing
-- again here, one level up, and naming the operation by its role in the
-- semiring ("min-plus, so take a min") is exactly the error the
-- reversal was supposed to have taught.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   max / max-â‰Ë¡ / max-â‰Ê³ / max-least
--                    the meet of the min-plus order, with its universal
--                    property â” upper bounds and least among them
--   up / dn          the profile-level polarities at a cut with a
--                    LIST of burdens: `up ks Ï = â‹µ (kµ âˆ Ïµ)` and
--                    `dn ks Ïˆ = (kµ âˆ Ïˆ)µ`
--   Profile          profiles as a RECURSIVE FAMILY over the kernel, so
--                    a length mismatch is not even representable â” no
--                    `Fin`, no index, the standing idiom here
--   _âŠp_             the profile order: pointwise and reversed
--   galFwd / galBwd  both directions of the contravariant adjunction
--   ProfileCut       `module Galois` instantiated, so antitonicity,
--                    unit, counit, the triangles, idempotence of
--                    `dn ks (up ks Ï)` and the fixed-point
--                    characterisation follow with NOTHING re-proved
--
-- So Î” 28 Â§31â“32's "re-saturate" is now a checked closure over min-plus
-- profiles at a finite cut: saturate once and stop.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Residuation in â•, and Isbell conjugation over a quantale
-- being a Galois connection, are standard â” Lawvere, `Metric spaces,
-- generalized logic, and closed categories` (1973), is where min-plus
-- becomes the value object.  What is contributed is that this
-- repository's own obligation is discharged at the profile level, and
-- that the operation it names is corrected.
------------------------------------------------------------------------

module TheMeetIsMaxAndTheProfileCutIsAGaloisConnection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _âˆ¸_ ; +-comm)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; â‰¤-refl ; â‰¤-trans ; zero-â‰¤ ; suc-â‰¤-suc ; pred-â‰¤-pred ; Â¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)
open import MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (âˆ¸-adjË¡ ; âˆ¸-adjÊ³)

------------------------------------------------------------------------
-- 1.  The meet of the min-plus order is max, with its universal property
------------------------------------------------------------------------

max : â„• â†’ â„• â†’ â„•
max zero    n       = n
max (suc m) zero    = suc m
max (suc m) (suc n) = suc (max m n)

max-â‰¤Ë¡ : (m n : â„•) â†’ m â‰¤ max m n
max-â‰¤Ë¡ zero    n       = zero-â‰¤
max-â‰¤Ë¡ (suc m) zero    = â‰¤-refl
max-â‰¤Ë¡ (suc m) (suc n) = suc-â‰¤-suc (max-â‰¤Ë¡ m n)

max-â‰¤Ê³ : (m n : â„•) â†’ n â‰¤ max m n
max-â‰¤Ê³ zero    n       = â‰¤-refl
max-â‰¤Ê³ (suc m) zero    = zero-â‰¤
max-â‰¤Ê³ (suc m) (suc n) = suc-â‰¤-suc (max-â‰¤Ê³ m n)

max-least : (m n c : â„•) â†’ m â‰¤ c â†’ n â‰¤ c â†’ max m n â‰¤ c
max-least zero    n       c       _  h  = h
max-least (suc m) zero    c       h  _  = h
max-least (suc m) (suc n) zero    h  _  = âŠ¥.rec (Â¬-<-zero h)
max-least (suc m) (suc n) (suc c) h1 h2 =
  suc-â‰¤-suc (max-least m n c (pred-â‰¤-pred h1) (pred-â‰¤-pred h2))

------------------------------------------------------------------------
-- 2.  Profiles, as a recursive family over the kernel
--
-- A burden profile has one entry per kernel entry BY CONSTRUCTION, so
-- the mismatched-length case that a `List â•` encoding would force is
-- not representable.  No `Fin` and no length index: the standing
-- cubical idiom in this repository.
------------------------------------------------------------------------

Profile : List â„• â†’ Type
Profile []       = Unit
Profile (_ âˆ· ks) = â„• Ã— Profile ks

_âŠ‘p_ : {ks : List â„•} â†’ Profile ks â†’ Profile ks â†’ Type
_âŠ‘p_ {[]}     _        _        = Unit
_âŠ‘p_ {_ âˆ· ks} (a , as) (b , bs) = (b â‰¤ a) Ã— (_âŠ‘p_ {ks} as bs)

âŠ‘p-refl : {ks : List â„•} (Ï† : Profile ks) â†’ Ï† âŠ‘p Ï†
âŠ‘p-refl {[]}     _        = tt
âŠ‘p-refl {_ âˆ· ks} (a , as) = â‰¤-refl , âŠ‘p-refl {ks} as

âŠ‘p-trans :
  {ks : List â„•} (Ï† Ïˆ Ï‡ : Profile ks) â†’ Ï† âŠ‘p Ïˆ â†’ Ïˆ âŠ‘p Ï‡ â†’ Ï† âŠ‘p Ï‡
âŠ‘p-trans {[]}     _        _        _        _           _            = tt
âŠ‘p-trans {_ âˆ· ks} (a , as) (b , bs) (c , cs) (ba , rest) (cb , rest') =
  â‰¤-trans cb ba , âŠ‘p-trans {ks} as bs cs rest rest'

------------------------------------------------------------------------
-- 3.  The polarities at a cut
------------------------------------------------------------------------

up : (ks : List â„•) â†’ Profile ks â†’ â„•
up []       _        = zero
up (k âˆ· ks) (f , fs) = max (k âˆ¸ f) (up ks fs)

dn : (ks : List â„•) â†’ â„• â†’ Profile ks
dn []       _ = tt
dn (k âˆ· ks) Ïˆ = (k âˆ¸ Ïˆ) , dn ks Ïˆ

_âŠ‘r_ : â„• â†’ â„• â†’ Type
a âŠ‘r b = b â‰¤ a

âŠ‘r-refl : (a : â„•) â†’ a âŠ‘r a
âŠ‘r-refl a = â‰¤-refl

âŠ‘r-trans : (a b c : â„•) â†’ a âŠ‘r b â†’ b âŠ‘r c â†’ a âŠ‘r c
âŠ‘r-trans a b c ab bc = â‰¤-trans bc ab

------------------------------------------------------------------------
-- 4.  Both directions of the adjunction, by induction on the cut
------------------------------------------------------------------------

goFwd :
  (ks : List â„•) (Ï† : Profile ks) (Ïˆ : â„•) â†’ Ï† âŠ‘p dn ks Ïˆ â†’ up ks Ï† â‰¤ Ïˆ
goFwd []       _        Ïˆ _           = zero-â‰¤
goFwd (k âˆ· ks) (f , fs) Ïˆ (le , rest) =
  max-least (k âˆ¸ f) (up ks fs) Ïˆ
    (âˆ¸-adjÊ³ k f Ïˆ (subst (k â‰¤_) (+-comm f Ïˆ) (âˆ¸-adjË¡ k Ïˆ f le)))
    (goFwd ks fs Ïˆ rest)

goBwd :
  (ks : List â„•) (Ï† : Profile ks) (Ïˆ : â„•) â†’ up ks Ï† â‰¤ Ïˆ â†’ Ï† âŠ‘p dn ks Ïˆ
goBwd []       _        Ïˆ _ = tt
goBwd (k âˆ· ks) (f , fs) Ïˆ h =
    âˆ¸-adjÊ³ k Ïˆ f (subst (k â‰¤_) (+-comm Ïˆ f)
                    (âˆ¸-adjË¡ k f Ïˆ (â‰¤-trans (max-â‰¤Ë¡ (k âˆ¸ f) (up ks fs)) h)))
  , goBwd ks fs Ïˆ (â‰¤-trans (max-â‰¤Ê³ (k âˆ¸ f) (up ks fs)) h)

------------------------------------------------------------------------
-- 5.  So the closure theory transports with nothing re-proved
------------------------------------------------------------------------

module ProfileCut (ks : List â„•) where
  open Galois (_âŠ‘p_ {ks}) _âŠ‘r_ (âŠ‘p-refl {ks}) (âŠ‘p-trans {ks})
              âŠ‘r-refl âŠ‘r-trans (up ks) (dn ks)
              (goFwd ks) (goBwd ks)
    public

------------------------------------------------------------------------
-- A cut with profiles on BOTH sides, with `up` producing a residual
-- profile, is built in
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile`.
--
-- The step is `upV`/`dnV`: the SAME cut with the burdens taken as a
-- PROFILE instead of read off the index list.  That is what frees the
-- index list to be pure shape, so a matrix of burdens is a profile of
-- profiles (`Rows`) and `UpP` produces a residual PROFILE.  The Galois
-- connection survives verbatim â” same two monus adjunctions.
--
-- The empty row set is not an obstruction, and no `âˆž` is needed.
-- The burden side is ordered by `_âŠp_` = REVERSE pointwise `â‰`, so the
-- `âŠp`-greatest profile under a vacuous constraint is the `â‰`-LEAST:
-- all zeros.  â• has it.  The unrestricted adjunction is at the
-- recording site, `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`.
------------------------------------------------------------------------
