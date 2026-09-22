{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoSidedCutExistsOverANonEmptyResidualIndex
--
-- ON THE NAME.  Min-plus residuation and Galois connections are
-- Birkhoff/Ore-era lattice theory and Lawvere 1973; no Indian source
-- term applies and none is invented.
--
-- ────────────────────────────────────────────────────────────────────
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile` built the left
-- adjoint for a matrix of burdens (`UpP`).
--
-- WHAT IS PROVED
--
--   _≼p_        pointwise `≤` on the RESIDUAL side.  It is NOT `_⊑p_`:
--               the burden side is ordered by reverse pointwise `≤`
--               (more burden absorbed is lower)
--   dnNE        the right adjoint over a non-empty residual index:
--               componentwise `maxᵢ (bᵢⱼ ∸ ψᵢ)`, by structural
--               recursion on the row list — no accumulator, so the
--               induction is the obvious one
--   goFwdNE     `φ ⊑p dnNE bs ψ → UpP bs φ ≼p ψ`
--   goBwdNE     and back
--
-- **SO THE TWO-SIDED CUT EXISTS.**  `dnNE` takes the row list in `j � js` form, so the type
-- itself records that a residual index must exist.
--
-- **WHAT MADE IT ROUTINE**: `maxP`'s three laws.
-- `maxP-⊑ˡ`/`maxP-⊑ʳ` split a hypothesis about the fold into per-row
-- hypotheses, `maxP-least` reassembles the conclusion, and each row is
-- then the one-sided `goFwdV`/`goBwdV` unchanged.  The fold direction
-- never had to be chosen: structural recursion on `Rows` gives it.
------------------------------------------------------------------------

module TheTwoSidedCutExistsOverANonEmptyResidualIndex where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
  using (Profile ; _⊑p_ ; ⊑p-trans)
open import TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
  using (upV ; dnV ; goFwdV ; goBwdV ; maxP ; maxP-⊑ˡ ; maxP-⊑ʳ ; maxP-least
        ; Rows ; UpP)

------------------------------------------------------------------------
-- 1.  The residual side is ordered the OTHER way
------------------------------------------------------------------------

_≼p_ : {js : List ℕ} → Profile js → Profile js → Type
_≼p_ {[]}     _        _        = Unit
_≼p_ {_ ∷ js} (a , as) (b , bs) = (a ≤ b) × (_≼p_ {js} as bs)

------------------------------------------------------------------------
-- 2.  The right adjoint, over a non-empty residual index
------------------------------------------------------------------------

dnNE :
  (j : ℕ) (js ks : List ℕ)
  → Rows (j ∷ js) ks → Profile (j ∷ js) → Profile ks
dnNE j []       ks (b , _)  (ψ , _)  = dnV ks b ψ
dnNE j (i ∷ js) ks (b , bs) (ψ , ψs) =
  maxP ks (dnV ks b ψ) (dnNE i js ks bs ψs)

------------------------------------------------------------------------
-- 3.  …and it is adjoint to UpP
------------------------------------------------------------------------

goFwdNE :
  (j : ℕ) (js ks : List ℕ) (bs : Rows (j ∷ js) ks)
  (φ : Profile ks) (ψ : Profile (j ∷ js))
  → _⊑p_ {ks} φ (dnNE j js ks bs ψ)
  → _≼p_ {j ∷ js} (UpP (j ∷ js) ks bs φ) ψ
goFwdNE j []       ks (b , _)  φ (ψ , _)  h =
  goFwdV ks b φ ψ h , tt
goFwdNE j (i ∷ js) ks (b , bs) φ (ψ , ψs) h =
    goFwdV ks b φ ψ
      (⊑p-trans {ks} φ (maxP ks (dnV ks b ψ) (dnNE i js ks bs ψs)) (dnV ks b ψ)
        h (maxP-⊑ˡ ks (dnV ks b ψ) (dnNE i js ks bs ψs)))
  , goFwdNE i js ks bs φ ψs
      (⊑p-trans {ks} φ (maxP ks (dnV ks b ψ) (dnNE i js ks bs ψs))
        (dnNE i js ks bs ψs)
        h (maxP-⊑ʳ ks (dnV ks b ψ) (dnNE i js ks bs ψs)))

goBwdNE :
  (j : ℕ) (js ks : List ℕ) (bs : Rows (j ∷ js) ks)
  (φ : Profile ks) (ψ : Profile (j ∷ js))
  → _≼p_ {j ∷ js} (UpP (j ∷ js) ks bs φ) ψ
  → _⊑p_ {ks} φ (dnNE j js ks bs ψ)
goBwdNE j []       ks (b , _)  φ (ψ , _)  (le , _) = goBwdV ks b φ ψ le
goBwdNE j (i ∷ js) ks (b , bs) φ (ψ , ψs) (le , rest) =
  maxP-least ks (dnV ks b ψ) (dnNE i js ks bs ψs) φ
    (goBwdV ks b φ ψ le)
    (goBwdNE i js ks bs φ ψs rest)

------------------------------------------------------------------------
-- The general case, over an ARBITRARY residual index list, is `dnAll`/
-- `goFwdAll`/`goBwdAll` in `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`.
------------------------------------------------------------------------
