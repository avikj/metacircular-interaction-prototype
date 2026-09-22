{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero
--
-- ON THE NAME.  Min-plus residuation is Birkhoff/Ore-era lattice
-- theory and Lawvere 1973; no Indian source term applies and none is
-- invented.
--
-- ────────────────────────────────────────────────────────────────────
-- THE POINT.
--
-- The burden side is ordered by `_⊑p_`, REVERSE≤
-- pointwise `≤` — more burden absorbed is lower.  The right adjoint
-- must produce the `⊑p`-GREATEST profile satisfying a vacuous
-- constraint; `⊑p`-greatest is `≤`-LEAST, and ℕ's least element is
-- `0`.  The empty meet is not `∞`.  It is zero, and ℕ has it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   zeroProfile        the all-zero burden profile
--   belowEverything    `φ ⊑p zeroProfile ks` for every φ — the empty
--                      meet, in one induction on `zero-≤`
--   dnAll              the right adjoint over an ARBITRARY residual
--                      index list, empty included: `zeroProfile` at
--                      `[]`, `maxP` of the row's `dnV` with the rest at
--                      a cons
--   goFwdAll / goBwdAll
--                      the adjunction, unrestricted
--
-- So the two-sided profile cut exists over ℕ with no restriction on
-- the residual index and no `∞` anywhere.
-- `dnAll [] ks _ _` is `zeroProfile ks` and everything goes through.
------------------------------------------------------------------------

module TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (zero-≤)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
  using (Profile ; _⊑p_ ; ⊑p-trans)
open import TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
  using (dnV ; goFwdV ; goBwdV ; maxP ; maxP-⊑ˡ ; maxP-⊑ʳ ; maxP-least
        ; Rows ; UpP)
open import TheTwoSidedCutExistsOverANonEmptyResidualIndex
  using (_≼p_)

------------------------------------------------------------------------
-- 1.  The empty meet
------------------------------------------------------------------------

zeroProfile : (ks : List ℕ) → Profile ks
zeroProfile []       = tt
zeroProfile (_ ∷ ks) = 0 , zeroProfile ks

belowEverything :
  (ks : List ℕ) (φ : Profile ks) → _⊑p_ {ks} φ (zeroProfile ks)
belowEverything []       _        = tt
belowEverything (k ∷ ks) (a , as) = zero-≤ , belowEverything ks as

------------------------------------------------------------------------
-- 2.  The right adjoint, over an arbitrary residual index
------------------------------------------------------------------------

dnAll :
  (js ks : List ℕ) → Rows js ks → Profile js → Profile ks
dnAll []       ks _        _        = zeroProfile ks
dnAll (j ∷ js) ks (b , bs) (ψ , ψs) =
  maxP ks (dnV ks b ψ) (dnAll js ks bs ψs)

goFwdAll :
  (js ks : List ℕ) (bs : Rows js ks) (φ : Profile ks) (ψ : Profile js)
  → _⊑p_ {ks} φ (dnAll js ks bs ψ)
  → _≼p_ {js} (UpP js ks bs φ) ψ
goFwdAll []       ks _        φ _        _ = tt
goFwdAll (j ∷ js) ks (b , bs) φ (ψ , ψs) h =
    goFwdV ks b φ ψ
      (⊑p-trans {ks} φ (maxP ks (dnV ks b ψ) (dnAll js ks bs ψs)) (dnV ks b ψ)
        h (maxP-⊑ˡ ks (dnV ks b ψ) (dnAll js ks bs ψs)))
  , goFwdAll js ks bs φ ψs
      (⊑p-trans {ks} φ (maxP ks (dnV ks b ψ) (dnAll js ks bs ψs))
        (dnAll js ks bs ψs)
        h (maxP-⊑ʳ ks (dnV ks b ψ) (dnAll js ks bs ψs)))

goBwdAll :
  (js ks : List ℕ) (bs : Rows js ks) (φ : Profile ks) (ψ : Profile js)
  → _≼p_ {js} (UpP js ks bs φ) ψ
  → _⊑p_ {ks} φ (dnAll js ks bs ψ)
goBwdAll []       ks _        φ _        _           = belowEverything ks φ
goBwdAll (j ∷ js) ks (b , bs) φ (ψ , ψs) (le , rest) =
  maxP-least ks (dnV ks b ψ) (dnAll js ks bs ψs) φ
    (goBwdV ks b φ ψ le)
    (goBwdAll js ks bs φ ψs rest)
