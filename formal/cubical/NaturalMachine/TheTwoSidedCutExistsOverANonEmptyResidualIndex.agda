{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheTwoSidedCutExistsOverANonEmptyResidualIndex
--
-- ON THE NAME.  Min-plus residuation and Galois connections are
-- Birkhoff/Ore-era lattice theory and Lawvere 1973; no Indian source
-- term applies and none is invented, per CLAUDE.md's naming guard.
-- Checked the priority ledger and the frame file before naming.
--
-- ────────────────────────────────────────────────────────────────────
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile` built the left
-- adjoint for a matrix of burdens (`UpP`) and located the obstruction
-- to the right adjoint: with NO rows the constraint is vacuous and the
-- required meet is `∞`.  It named the remaining step — fold `maxP`
-- over a non-empty row list and prove the two halves.  Done here.
--
-- WHAT IS PROVED
--
--   _≼p_        pointwise `≤` on the RESIDUAL side.  It is NOT `_⊑p_`:
--               the burden side is ordered by reverse pointwise `≤`
--               (more burden absorbed is lower), and writing both sides
--               with the same symbol is exactly how the sign error on
--               this line happened once before
--   dnNE        the right adjoint over a non-empty residual index:
--               componentwise `maxᵢ (bᵢⱼ ∸ ψᵢ)`, by structural
--               recursion on the row list — no accumulator, so the
--               induction is the obvious one
--   goFwdNE     `φ ⊑p dnNE bs ψ → UpP bs φ ≼p ψ`
--   goBwdNE     and back
--
-- **SO THE TWO-SIDED CUT EXISTS, AND THE EMPTY CASE IS THE ONLY THING
-- MISSING.**  `dnNE` takes the row list in `j ∷ js` form, so the type
-- itself records that a residual index must exist; over `ℕ ⊎ ∞` the
-- empty case would be `∞` and the restriction would lift.  Nothing
-- here adjoins `∞`.
--
-- **WHAT MADE IT ROUTINE**: `maxP`'s three laws, proved last cycle.
-- `maxP-⊑ˡ`/`maxP-⊑ʳ` split a hypothesis about the fold into per-row
-- hypotheses, `maxP-least` reassembles the conclusion, and each row is
-- then the one-sided `goFwdV`/`goBwdV` unchanged.  The fold direction
-- never had to be chosen: structural recursion on `Rows` gives it.
--
-- WHAT IS NOT CLAIMED.  No `∞`.  CONVOLUTION still does not appear, so
-- nothing here speaks to Δ 28's COMPOSITION step — the cut is a
-- residuation, not a product.  Nothing is packaged through the
-- `Galois` module: that module's signature takes one carrier per side
-- and both sides here are profiles over different index lists, so the
-- packaging would need a second copy of it, which is not worth a
-- definition until something consumes it.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheTwoSidedCutExistsOverANonEmptyResidualIndex where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import NaturalMachine.TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
  using (Profile ; _⊑p_ ; ⊑p-trans)
open import NaturalMachine.TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
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
-- CORRECTION APPENDED 2026-08-19, by the same identity, at the end,
-- altering no line above.  Recording site: commit 8f3acebb,
-- `NaturalMachine.TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`.
--
-- **THE NON-EMPTINESS HYPOTHESIS THIS MODULE PUTS IN ITS SIGNATURES IS
-- NOT NEEDED.**  `dnNE`, `goFwdNE`, `goBwdNE` take their rows as
-- `Rows (j ∷ js) ks` because the module it was built on claimed the
-- empty meet was `∞`.  That claim is false: `_⊑p_` is reverse pointwise
-- `≤`, so the `⊑p`-greatest profile under a vacuous constraint is the
-- `≤`-least, i.e. all zeros, which ℕ has.  `dnAll`/`goFwdAll`/
-- `goBwdAll` at the recording site are the same adjunction over an
-- ARBITRARY residual index list.
--
-- The irony is exact and is worth leaving in place: method shape (lxix)
-- — "when a restriction is real, put it in the SIGNATURE, not in a
-- comment" — was applied correctly to a restriction that was not real.
-- Encoding a hypothesis in a type makes it unforgettable; it does not
-- make it true.  The shape stands; what it needed alongside it was a
-- check that the restriction was an obstruction and not a sign error.
--
-- NOTHING HERE IS RETRACTED.  Every proof in this module is true; they
-- are the special case of the unrestricted ones, and they are left
-- unaltered so the recording site has something to be the general case
-- OF.
------------------------------------------------------------------------
