{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
--
-- ON THE NAME.  Min-plus residuation and Galois connections are
-- Birkhoff/Ore-era lattice theory and Lawvere 1973; there is no Indian
-- source term for this object and none is invented, per CLAUDE.md's
-- naming guard.  Checked `.claude/hooks/priority-ledger.txt` and
-- `.claude/hooks/european-frame.txt` before naming; no row applies and
-- the frame check does not fire on a module with no Indian material.
--
-- ────────────────────────────────────────────────────────────────────
-- `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection` closed with:
--
--   "ONE SIDE IS STILL SCALAR: burdens form a profile, residuals are a
--    single value, because that is what makes `up` land in ℕ.  A cut
--    with profiles on BOTH sides needs `up` to produce a residual
--    profile, i.e. a meet per residual index, and is not built."
--
-- The enabling step is built here, and the obstruction to the rest is
-- located exactly.
--
-- WHAT IS PROVED
--
--   upV / dnV        the one-sided cut with the BURDENS TAKEN AS A
--                    PROFILE rather than read off the index list —
--                    `upV ks b φ = maxⱼ (bⱼ ∸ φⱼ)`, `dnV ks b ψ =
--                    (bⱼ ∸ ψ)ⱼ`
--   goFwdV / goBwdV  and it is still a Galois connection, by the same
--                    two monus adjunctions
--   VProfileCut      packaged through the existing `Galois` module
--   maxP + three laws
--                    componentwise max on profiles, with `⊑p`'s two
--                    bounds and leastness
--   Rows / UpP       a matrix of burdens as a profile of profiles, and
--                    the residual PROFILE it produces
--
-- **WHY `upV` IS THE STEP THAT MATTERS.**  In the one-sided module the
-- burdens are the ℕ payloads of the index list, so a second residual
-- index would need a second index list carrying different payloads —
-- there is no room for a matrix.  Taking the burdens as a profile frees
-- the index list to be pure shape, and then a matrix is just a profile
-- of profiles (`Rows`), which is what `UpP` consumes.
--
-- **AND THE OBSTRUCTION IS THE EMPTY ROW SET, PRECISELY.**  The right
-- adjoint must send a residual profile ψ to the LARGEST burden profile
-- φ with `UpP bs φ ⊑p ψ`; componentwise that is `maxᵢ (bᵢⱼ ∸ ψᵢ)`.
-- With no rows the constraint is vacuous, so the largest such φ is
-- unbounded — **the empty meet is `∞`, which ℕ does not have.**  The
-- one-sided module recorded this from the other side ("the empty
-- burden list gives `up ks φ = 0` … with `∞` present the empty meet
-- would be `∞`"); here it is the same fact obstructing the right
-- adjoint rather than a convention about the left one.  So a two-sided
-- cut exists over a NON-EMPTY residual index set or over `ℕ ⊎ ∞`, and
-- not over ℕ with an arbitrary index set.
--
-- WHAT IS NOT CLAIMED.  The non-empty-row right adjoint is NOT built
-- here — `maxP` and its laws are the pieces it needs, and assembling
-- them with a fold is the next step on this line, not attempted this
-- cycle.  CONVOLUTION still does not appear: Δ 28 composes generator
-- coefficients by min-plus convolution, no operation here is that, and
-- nothing here says the COMPOSITION step is sound.  No `∞` is
-- adjoined.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheTwoSidedProfileCutNeedsTheBurdensAsAProfile where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; +-comm)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; ≤-trans ; zero-≤)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import NaturalMachine.TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)
open import NaturalMachine.MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (∸-adjˡ ; ∸-adjʳ)
open import NaturalMachine.TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
  using (max ; max-≤ˡ ; max-≤ʳ ; max-least
        ; Profile ; _⊑p_ ; ⊑p-refl ; ⊑p-trans ; _⊑r_ ; ⊑r-refl ; ⊑r-trans)

------------------------------------------------------------------------
-- 1.  The cut with the burdens as a profile
------------------------------------------------------------------------

upV : (ks : List ℕ) → Profile ks → Profile ks → ℕ
upV []       _        _        = zero
upV (k ∷ ks) (b , bs) (f , fs) = max (b ∸ f) (upV ks bs fs)

dnV : (ks : List ℕ) → Profile ks → ℕ → Profile ks
dnV []       _        _ = tt
dnV (k ∷ ks) (b , bs) ψ = (b ∸ ψ) , dnV ks bs ψ

goFwdV :
  (ks : List ℕ) (b φ : Profile ks) (ψ : ℕ)
  → _⊑p_ {ks} φ (dnV ks b ψ) → upV ks b φ ≤ ψ
goFwdV []       _        _        ψ _           = zero-≤
goFwdV (k ∷ ks) (b , bs) (f , fs) ψ (le , rest) =
  max-least (b ∸ f) (upV ks bs fs) ψ
    (∸-adjʳ b f ψ (subst (b ≤_) (+-comm f ψ) (∸-adjˡ b ψ f le)))
    (goFwdV ks bs fs ψ rest)

goBwdV :
  (ks : List ℕ) (b φ : Profile ks) (ψ : ℕ)
  → upV ks b φ ≤ ψ → _⊑p_ {ks} φ (dnV ks b ψ)
goBwdV []       _        _        ψ _ = tt
goBwdV (k ∷ ks) (b , bs) (f , fs) ψ h =
    ∸-adjʳ b ψ f (subst (b ≤_) (+-comm ψ f)
                    (∸-adjˡ b f ψ (≤-trans (max-≤ˡ (b ∸ f) (upV ks bs fs)) h)))
  , goBwdV ks bs fs ψ (≤-trans (max-≤ʳ (b ∸ f) (upV ks bs fs)) h)

module VProfileCut (ks : List ℕ) (b : Profile ks) where
  open Galois (_⊑p_ {ks}) _⊑r_ (⊑p-refl {ks}) (⊑p-trans {ks})
              ⊑r-refl ⊑r-trans (upV ks b) (dnV ks b)
              (goFwdV ks b) (goBwdV ks b)
    public

------------------------------------------------------------------------
-- 2.  Componentwise max, the meet the right adjoint would need
------------------------------------------------------------------------

maxP : (ks : List ℕ) → Profile ks → Profile ks → Profile ks
maxP []       _        _        = tt
maxP (k ∷ ks) (a , as) (b , bs) = max a b , maxP ks as bs

maxP-⊑ˡ : (ks : List ℕ) (φ ψ : Profile ks) → _⊑p_ {ks} (maxP ks φ ψ) φ
maxP-⊑ˡ []       _        _        = tt
maxP-⊑ˡ (k ∷ ks) (a , as) (b , bs) = max-≤ˡ a b , maxP-⊑ˡ ks as bs

maxP-⊑ʳ : (ks : List ℕ) (φ ψ : Profile ks) → _⊑p_ {ks} (maxP ks φ ψ) ψ
maxP-⊑ʳ []       _        _        = tt
maxP-⊑ʳ (k ∷ ks) (a , as) (b , bs) = max-≤ʳ a b , maxP-⊑ʳ ks as bs

maxP-least :
  (ks : List ℕ) (φ ψ χ : Profile ks)
  → _⊑p_ {ks} χ φ → _⊑p_ {ks} χ ψ → _⊑p_ {ks} χ (maxP ks φ ψ)
maxP-least []       _        _        _        _            _            = tt
maxP-least (k ∷ ks) (a , as) (b , bs) (c , cs) (ac , rest) (bc , rest') =
  max-least a b c ac bc , maxP-least ks as bs cs rest rest'

------------------------------------------------------------------------
-- 3.  A matrix of burdens, and the residual PROFILE it produces
------------------------------------------------------------------------

Rows : List ℕ → List ℕ → Type
Rows []       ks = Unit
Rows (_ ∷ js) ks = Profile ks × Rows js ks

UpP : (js ks : List ℕ) → Rows js ks → Profile ks → Profile js
UpP []       ks _        φ = tt
UpP (j ∷ js) ks (b , bs) φ = upV ks b φ , UpP js ks bs φ

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The step named above — "assemble the non-empty-row right
-- adjoint: fold `maxP` over `Rows (j ∷ js)` and prove the two halves
-- against `UpP`" — is done in
-- `NaturalMachine.TheTwoSidedCutExistsOverANonEmptyResidualIndex`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin): `dnNE`, `goFwdNE`, `goBwdNE`.
--
-- Three things that cycle settled and this one could not:
--
--   * The residual side needs its OWN order, `_≼p_`, pointwise `≤` —
--     NOT `_⊑p_`, which is reverse pointwise `≤` because more burden
--     absorbed is lower.  Writing both with one symbol is how the sign
--     error on this line happened once before.
--   * No accumulator is needed: structural recursion on `Rows` gives
--     the fold, and with it the obvious induction.
--   * `maxP`'s three laws do all the work — the two bounds split a
--     hypothesis about the fold into per-row hypotheses, leastness
--     reassembles the conclusion, and each row is `goFwdV`/`goBwdV`
--     unchanged.
--
-- The empty residual index remains the only gap, and it is a type-level
-- one: `dnNE` takes its rows in `j ∷ js` form, so the restriction is
-- recorded in the signature rather than in a comment.  Over `ℕ ⊎ ∞` it
-- would lift.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- CORRECTION APPENDED 2026-08-19, by the same identity, at the end,
-- altering no line above.  Recording site: commit 8f3acebb,
-- `NaturalMachine.TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
-- **THE PARAGRAPH ABOVE IS WRONG, AND SO IS THE ONE IN §"WHAT IS STILL
-- NOT CLAIMED".**  Both say: with no rows the constraint is vacuous and
-- the maximum is unbounded, so "the empty meet is `∞`, which ℕ does not
-- have", and a two-sided cut therefore exists only over a NON-EMPTY
-- residual index set or over `ℕ ⊎ ∞`.
--
-- The burden side is ordered by `_⊑p_`, which is REVERSE pointwise `≤`.
-- The right adjoint must return the `⊑p`-GREATEST burden profile
-- satisfying the constraint; `⊑p`-greatest is `≤`-LEAST; ℕ's least
-- element is `0`.  The empty meet is `zeroProfile`, and ℕ has it.  No
-- `∞`, no `ℕ ⊎ ∞`, and no restriction on the residual index: `dnAll`,
-- `goFwdAll`, `goBwdAll` at the recording site are the unrestricted
-- adjunction.
--
-- This is a sign error made in PROSE, one cycle after writing "when two
-- sides of an adjunction have opposite orders, give them different
-- symbols" into my own standing rules.  The typechecker never saw the
-- claim, because a comment is not a type.
--
-- WHAT SURVIVES UNCHANGED.  Every definition and every proof in this
-- module.  `upV`, `dnV`, `goFwdV`, `goBwdV`, `maxP` and its three laws,
-- `Rows`, `UpP` are exactly what the unrestricted adjunction is built
-- from.  Only the obstruction claim was false.
--
-- STILL ABSENT, as before: CONVOLUTION, hence nothing about Δ 28's
-- COMPOSITION step.
------------------------------------------------------------------------
