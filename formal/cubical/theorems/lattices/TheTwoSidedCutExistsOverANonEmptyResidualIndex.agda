{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoSidedCutExistsOverANonEmptyResidualIndex
--
-- ON THE NAME.  Min-plus residuation and Galois connections are
-- Birkhoff/Ore-era lattice theory and Lawvere 1973; no Indian source
-- term applies and none is invented.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile` built the left
-- adjoint for a matrix of burdens (`UpP`).
--
-- WHAT IS PROVED
--
--   _â‰¼p_        pointwise `â‰` on the RESIDUAL side.  It is NOT `_âŠp_`:
--               the burden side is ordered by reverse pointwise `â‰`
--               (more burden absorbed is lower)
--   dnNE        the right adjoint over a non-empty residual index:
--               componentwise `maxµ (bµâ¼ âˆ Ïˆµ)`, by structural
--               recursion on the row list â” no accumulator, so the
--               induction is the obvious one
--   goFwdNE     `Ï âŠp dnNE bs Ïˆ â’ UpP bs Ï â‰¼p Ïˆ`
--   goBwdNE     and back
--
-- **SO THE TWO-SIDED CUT EXISTS.**  `dnNE` takes the row list in `j âˆ js` form, so the type
-- itself records that a residual index must exist.
--
-- **WHAT MADE IT ROUTINE**: `maxP`'s three laws.
-- `maxP-âŠË¡`/`maxP-âŠÊ³` split a hypothesis about the fold into per-row
-- hypotheses, `maxP-least` reassembles the conclusion, and each row is
-- then the one-sided `goFwdV`/`goBwdV` unchanged.  The fold direction
-- never had to be chosen: structural recursion on `Rows` gives it.
------------------------------------------------------------------------

module TheTwoSidedCutExistsOverANonEmptyResidualIndex where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.Order using (_â‰¤_)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)

open import TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
  using (Profile ; _âŠ‘p_ ; âŠ‘p-trans)
open import TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
  using (upV ; dnV ; goFwdV ; goBwdV ; maxP ; maxP-âŠ‘Ë¡ ; maxP-âŠ‘Ê³ ; maxP-least
        ; Rows ; UpP)

------------------------------------------------------------------------
-- 1.  The residual side is ordered the OTHER way
------------------------------------------------------------------------

_â‰¼p_ : {js : List â„•} â†’ Profile js â†’ Profile js â†’ Type
_â‰¼p_ {[]}     _        _        = Unit
_â‰¼p_ {_ âˆ· js} (a , as) (b , bs) = (a â‰¤ b) Ã— (_â‰¼p_ {js} as bs)

------------------------------------------------------------------------
-- 2.  The right adjoint, over a non-empty residual index
------------------------------------------------------------------------

dnNE :
  (j : â„•) (js ks : List â„•)
  â†’ Rows (j âˆ· js) ks â†’ Profile (j âˆ· js) â†’ Profile ks
dnNE j []       ks (b , _)  (Ïˆ , _)  = dnV ks b Ïˆ
dnNE j (i âˆ· js) ks (b , bs) (Ïˆ , Ïˆs) =
  maxP ks (dnV ks b Ïˆ) (dnNE i js ks bs Ïˆs)

------------------------------------------------------------------------
-- 3.  â¦and it is adjoint to UpP
------------------------------------------------------------------------

goFwdNE :
  (j : â„•) (js ks : List â„•) (bs : Rows (j âˆ· js) ks)
  (Ï† : Profile ks) (Ïˆ : Profile (j âˆ· js))
  â†’ _âŠ‘p_ {ks} Ï† (dnNE j js ks bs Ïˆ)
  â†’ _â‰¼p_ {j âˆ· js} (UpP (j âˆ· js) ks bs Ï†) Ïˆ
goFwdNE j []       ks (b , _)  Ï† (Ïˆ , _)  h =
  goFwdV ks b Ï† Ïˆ h , tt
goFwdNE j (i âˆ· js) ks (b , bs) Ï† (Ïˆ , Ïˆs) h =
    goFwdV ks b Ï† Ïˆ
      (âŠ‘p-trans {ks} Ï† (maxP ks (dnV ks b Ïˆ) (dnNE i js ks bs Ïˆs)) (dnV ks b Ïˆ)
        h (maxP-âŠ‘Ë¡ ks (dnV ks b Ïˆ) (dnNE i js ks bs Ïˆs)))
  , goFwdNE i js ks bs Ï† Ïˆs
      (âŠ‘p-trans {ks} Ï† (maxP ks (dnV ks b Ïˆ) (dnNE i js ks bs Ïˆs))
        (dnNE i js ks bs Ïˆs)
        h (maxP-âŠ‘Ê³ ks (dnV ks b Ïˆ) (dnNE i js ks bs Ïˆs)))

goBwdNE :
  (j : â„•) (js ks : List â„•) (bs : Rows (j âˆ· js) ks)
  (Ï† : Profile ks) (Ïˆ : Profile (j âˆ· js))
  â†’ _â‰¼p_ {j âˆ· js} (UpP (j âˆ· js) ks bs Ï†) Ïˆ
  â†’ _âŠ‘p_ {ks} Ï† (dnNE j js ks bs Ïˆ)
goBwdNE j []       ks (b , _)  Ï† (Ïˆ , _)  (le , _) = goBwdV ks b Ï† Ïˆ le
goBwdNE j (i âˆ· js) ks (b , bs) Ï† (Ïˆ , Ïˆs) (le , rest) =
  maxP-least ks (dnV ks b Ïˆ) (dnNE i js ks bs Ïˆs) Ï†
    (goBwdV ks b Ï† Ïˆ le)
    (goBwdNE i js ks bs Ï† Ïˆs rest)

------------------------------------------------------------------------
-- The general case, over an ARBITRARY residual index list, is `dnAll`/
-- `goFwdAll`/`goBwdAll` in `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`.
------------------------------------------------------------------------
