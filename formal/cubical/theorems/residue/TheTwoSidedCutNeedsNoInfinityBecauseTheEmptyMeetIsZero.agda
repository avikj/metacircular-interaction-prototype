{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero
--
-- ON THE NAME.  Min-plus residuation is Birkhoff/Ore-era lattice
-- theory and Lawvere 1973; no Indian source term applies and none is
-- invented.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE POINT.
--
-- The burden side is ordered by `_âŠp_`, REVERSE
-- pointwise `â‰` â” more burden absorbed is lower.  The right adjoint
-- must produce the `âŠp`-GREATEST profile satisfying a vacuous
-- constraint; `âŠp`-greatest is `â‰`-LEAST, and â•'s least element is
-- `0`.  The empty meet is not `âˆž`.  It is zero, and â• has it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   zeroProfile        the all-zero burden profile
--   belowEverything    `Ï âŠp zeroProfile ks` for every Ï â” the empty
--                      meet, in one induction on `zero-â‰`
--   dnAll              the right adjoint over an ARBITRARY residual
--                      index list, empty included: `zeroProfile` at
--                      `[]`, `maxP` of the row's `dnV` with the rest at
--                      a cons
--   goFwdAll / goBwdAll
--                      the adjunction, unrestricted
--
-- So the two-sided profile cut exists over â• with no restriction on
-- the residual index and no `âˆž` anywhere.
-- `dnAll [] ks _ _` is `zeroProfile ks` and everything goes through.
------------------------------------------------------------------------

module TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.Order using (zero-â‰¤)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)

open import TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
  using (Profile ; _âŠ‘p_ ; âŠ‘p-trans)
open import TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
  using (dnV ; goFwdV ; goBwdV ; maxP ; maxP-âŠ‘Ë¡ ; maxP-âŠ‘Ê³ ; maxP-least
        ; Rows ; UpP)
open import TheTwoSidedCutExistsOverANonEmptyResidualIndex
  using (_â‰¼p_)

------------------------------------------------------------------------
-- 1.  The empty meet
------------------------------------------------------------------------

zeroProfile : (ks : List â„•) â†’ Profile ks
zeroProfile []       = tt
zeroProfile (_ âˆ· ks) = 0 , zeroProfile ks

belowEverything :
  (ks : List â„•) (Ï† : Profile ks) â†’ _âŠ‘p_ {ks} Ï† (zeroProfile ks)
belowEverything []       _        = tt
belowEverything (k âˆ· ks) (a , as) = zero-â‰¤ , belowEverything ks as

------------------------------------------------------------------------
-- 2.  The right adjoint, over an arbitrary residual index
------------------------------------------------------------------------

dnAll :
  (js ks : List â„•) â†’ Rows js ks â†’ Profile js â†’ Profile ks
dnAll []       ks _        _        = zeroProfile ks
dnAll (j âˆ· js) ks (b , bs) (Ïˆ , Ïˆs) =
  maxP ks (dnV ks b Ïˆ) (dnAll js ks bs Ïˆs)

goFwdAll :
  (js ks : List â„•) (bs : Rows js ks) (Ï† : Profile ks) (Ïˆ : Profile js)
  â†’ _âŠ‘p_ {ks} Ï† (dnAll js ks bs Ïˆ)
  â†’ _â‰¼p_ {js} (UpP js ks bs Ï†) Ïˆ
goFwdAll []       ks _        Ï† _        _ = tt
goFwdAll (j âˆ· js) ks (b , bs) Ï† (Ïˆ , Ïˆs) h =
    goFwdV ks b Ï† Ïˆ
      (âŠ‘p-trans {ks} Ï† (maxP ks (dnV ks b Ïˆ) (dnAll js ks bs Ïˆs)) (dnV ks b Ïˆ)
        h (maxP-âŠ‘Ë¡ ks (dnV ks b Ïˆ) (dnAll js ks bs Ïˆs)))
  , goFwdAll js ks bs Ï† Ïˆs
      (âŠ‘p-trans {ks} Ï† (maxP ks (dnV ks b Ïˆ) (dnAll js ks bs Ïˆs))
        (dnAll js ks bs Ïˆs)
        h (maxP-âŠ‘Ê³ ks (dnV ks b Ïˆ) (dnAll js ks bs Ïˆs)))

goBwdAll :
  (js ks : List â„•) (bs : Rows js ks) (Ï† : Profile ks) (Ïˆ : Profile js)
  â†’ _â‰¼p_ {js} (UpP js ks bs Ï†) Ïˆ
  â†’ _âŠ‘p_ {ks} Ï† (dnAll js ks bs Ïˆ)
goBwdAll []       ks _        Ï† _        _           = belowEverything ks Ï†
goBwdAll (j âˆ· js) ks (b , bs) Ï† (Ïˆ , Ïˆs) (le , rest) =
  maxP-least ks (dnV ks b Ïˆ) (dnAll js ks bs Ïˆs) Ï†
    (goBwdV ks b Ï† Ïˆ le)
    (goBwdAll js ks bs Ï† Ïˆs rest)
