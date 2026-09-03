{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
--
-- `MinPlusResiduationIsAGaloisConnectionAtOneCut` paid Δ 28 §31–32's
-- residuation obligation for a single burden and single residual, and
-- said exactly what was left:
--
--   "ONE CUT is one burden and one residual … Δ 28's cut carries a
--    PROFILE on each side and its `↑` takes a meet over all burdens —
--    that needs `min` over a finite index and its universal property,
--    not built.  So what this settles is that the obstruction is NOT
--    the residuation law; it is the meet."
--
-- The meet is built and the profile cut is done.  And the meet is NOT
-- `min`.
--
-- ────────────────────────────────────────────────────────────────────
-- THE MEET IS MAX, AND THAT IS THE FINDING.  The previous module had to
-- reverse the order because in min-plus lower cost is better.  A meet
-- in a reversed order is a JOIN in the original, so `⋀` over burdens is
-- `max` in ℕ, not `min`.  My own sentence above said "needs `min` over
-- a finite index" and was wrong about which operation — the reversal
-- that was load-bearing for the one-cut adjunction is load-bearing
-- again here, one level up, and naming the operation by its role in the
-- semiring ("min-plus, so take a min") is exactly the error the
-- reversal was supposed to have taught.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   max / max-≤ˡ / max-≤ʳ / max-least
--                    the meet of the min-plus order, with its universal
--                    property — upper bounds and least among them
--   up / dn          the profile-level polarities at a cut with a
--                    LIST of burdens: `up ks φ = ⋀ᵢ (kᵢ ∸ φᵢ)` and
--                    `dn ks ψ = (kᵢ ∸ ψ)ᵢ`
--   Profile          profiles as a RECURSIVE FAMILY over the kernel, so
--                    a length mismatch is not even representable — no
--                    `Fin`, no index, the standing idiom here
--   _⊑p_             the profile order: pointwise and reversed
--   galFwd / galBwd  both directions of the contravariant adjunction
--   ProfileCut       `module Galois` instantiated, so antitonicity,
--                    unit, counit, the triangles, idempotence of
--                    `dn ks (up ks φ)` and the fixed-point
--                    characterisation follow with NOTHING re-proved
--
-- So Δ 28 §31–32's "re-saturate" is now a checked closure over min-plus
-- profiles at a finite cut: saturate once and stop.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Residuation in ℕ, and Isbell conjugation over a quantale
-- being a Galois connection, are standard — Lawvere, `Metric spaces,
-- generalized logic, and closed categories` (1973), is where min-plus
-- becomes the value object.  What is contributed is that this
-- repository's own obligation is discharged at the profile level, and
-- that the operation it names is corrected.
--
-- THE SCOPE, EXACTLY.  ONE SIDE IS STILL SCALAR: burdens form a
-- profile, residuals are a single value, because that is what makes
-- `up` land in ℕ.  A cut with profiles on BOTH sides needs `up` to
-- produce a residual profile, i.e. a meet per residual index, and is
-- not built.  No `∞` is adjoined, so this is ℕ and not the min-plus
-- semiring proper, and the empty burden list gives `up ks φ = 0`, which
-- is the reversed order's top only because `0` is ℕ's bottom — with
-- `∞` present the empty meet would be `∞`, and nothing here depends on
-- which convention is taken but a reader extending it must choose.
-- CONVOLUTION does not appear: Δ 28 composes generator coefficients by
-- min-plus convolution and that operation is nowhere in this module,
-- so nothing here says the COMPOSITION step is sound — only that the
-- re-saturation step terminates.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheMeetIsMaxAndTheProfileCutIsAGaloisConnection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; +-comm)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤-refl ; ≤-trans ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)
open import MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (∸-adjˡ ; ∸-adjʳ)

------------------------------------------------------------------------
-- 1.  The meet of the min-plus order is max, with its universal property
------------------------------------------------------------------------

max : ℕ → ℕ → ℕ
max zero    n       = n
max (suc m) zero    = suc m
max (suc m) (suc n) = suc (max m n)

max-≤ˡ : (m n : ℕ) → m ≤ max m n
max-≤ˡ zero    n       = zero-≤
max-≤ˡ (suc m) zero    = ≤-refl
max-≤ˡ (suc m) (suc n) = suc-≤-suc (max-≤ˡ m n)

max-≤ʳ : (m n : ℕ) → n ≤ max m n
max-≤ʳ zero    n       = ≤-refl
max-≤ʳ (suc m) zero    = zero-≤
max-≤ʳ (suc m) (suc n) = suc-≤-suc (max-≤ʳ m n)

max-least : (m n c : ℕ) → m ≤ c → n ≤ c → max m n ≤ c
max-least zero    n       c       _  h  = h
max-least (suc m) zero    c       h  _  = h
max-least (suc m) (suc n) zero    h  _  = ⊥.rec (¬-<-zero h)
max-least (suc m) (suc n) (suc c) h1 h2 =
  suc-≤-suc (max-least m n c (pred-≤-pred h1) (pred-≤-pred h2))

------------------------------------------------------------------------
-- 2.  Profiles, as a recursive family over the kernel
--
-- A burden profile has one entry per kernel entry BY CONSTRUCTION, so
-- the mismatched-length case that a `List ℕ` encoding would force is
-- not representable.  No `Fin` and no length index: the standing
-- cubical idiom in this repository.
------------------------------------------------------------------------

Profile : List ℕ → Type
Profile []       = Unit
Profile (_ ∷ ks) = ℕ × Profile ks

_⊑p_ : {ks : List ℕ} → Profile ks → Profile ks → Type
_⊑p_ {[]}     _        _        = Unit
_⊑p_ {_ ∷ ks} (a , as) (b , bs) = (b ≤ a) × (_⊑p_ {ks} as bs)

⊑p-refl : {ks : List ℕ} (φ : Profile ks) → φ ⊑p φ
⊑p-refl {[]}     _        = tt
⊑p-refl {_ ∷ ks} (a , as) = ≤-refl , ⊑p-refl {ks} as

⊑p-trans :
  {ks : List ℕ} (φ ψ χ : Profile ks) → φ ⊑p ψ → ψ ⊑p χ → φ ⊑p χ
⊑p-trans {[]}     _        _        _        _           _            = tt
⊑p-trans {_ ∷ ks} (a , as) (b , bs) (c , cs) (ba , rest) (cb , rest') =
  ≤-trans cb ba , ⊑p-trans {ks} as bs cs rest rest'

------------------------------------------------------------------------
-- 3.  The polarities at a cut
------------------------------------------------------------------------

up : (ks : List ℕ) → Profile ks → ℕ
up []       _        = zero
up (k ∷ ks) (f , fs) = max (k ∸ f) (up ks fs)

dn : (ks : List ℕ) → ℕ → Profile ks
dn []       _ = tt
dn (k ∷ ks) ψ = (k ∸ ψ) , dn ks ψ

_⊑r_ : ℕ → ℕ → Type
a ⊑r b = b ≤ a

⊑r-refl : (a : ℕ) → a ⊑r a
⊑r-refl a = ≤-refl

⊑r-trans : (a b c : ℕ) → a ⊑r b → b ⊑r c → a ⊑r c
⊑r-trans a b c ab bc = ≤-trans bc ab

------------------------------------------------------------------------
-- 4.  Both directions of the adjunction, by induction on the cut
------------------------------------------------------------------------

goFwd :
  (ks : List ℕ) (φ : Profile ks) (ψ : ℕ) → φ ⊑p dn ks ψ → up ks φ ≤ ψ
goFwd []       _        ψ _           = zero-≤
goFwd (k ∷ ks) (f , fs) ψ (le , rest) =
  max-least (k ∸ f) (up ks fs) ψ
    (∸-adjʳ k f ψ (subst (k ≤_) (+-comm f ψ) (∸-adjˡ k ψ f le)))
    (goFwd ks fs ψ rest)

goBwd :
  (ks : List ℕ) (φ : Profile ks) (ψ : ℕ) → up ks φ ≤ ψ → φ ⊑p dn ks ψ
goBwd []       _        ψ _ = tt
goBwd (k ∷ ks) (f , fs) ψ h =
    ∸-adjʳ k ψ f (subst (k ≤_) (+-comm ψ f)
                    (∸-adjˡ k f ψ (≤-trans (max-≤ˡ (k ∸ f) (up ks fs)) h)))
  , goBwd ks fs ψ (≤-trans (max-≤ʳ (k ∸ f) (up ks fs)) h)

------------------------------------------------------------------------
-- 5.  So the closure theory transports with nothing re-proved
------------------------------------------------------------------------

module ProfileCut (ks : List ℕ) where
  open Galois (_⊑p_ {ks}) _⊑r_ (⊑p-refl {ks}) (⊑p-trans {ks})
              ⊑r-refl ⊑r-trans (up ks) (dn ks)
              (goFwd ks) (goBwd ks)
    public

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The item named above — "a cut with profiles on BOTH
-- sides needs `up` to produce a residual profile … and is not built" —
-- has its enabling step built in
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
-- The step is `upV`/`dnV`: the SAME cut with the burdens taken as a
-- PROFILE instead of read off the index list.  That is what frees the
-- index list to be pure shape, so a matrix of burdens is a profile of
-- profiles (`Rows`) and `UpP` produces a residual PROFILE.  The Galois
-- connection survives verbatim — same two monus adjunctions.
--
-- **AND THE OBSTRUCTION TO THE REST IS THE EMPTY ROW SET.**  The right
-- adjoint must send a residual profile to the largest burden profile
-- below it, componentwise `maxᵢ (bᵢⱼ ∸ ψᵢ)`; with no rows the
-- constraint is vacuous and that maximum is unbounded — the empty meet
-- is `∞`, which ℕ does not have.  The paragraph above recorded this
-- from the LEFT adjoint's side as a convention about `up ks φ = 0` on
-- the empty burden list; it is the same fact, and on the right it is
-- not a convention but an obstruction.  A two-sided cut therefore
-- exists over a non-empty residual index set, or over `ℕ ⊎ ∞`, and not
-- over ℕ with an arbitrary index set.
--
-- Still absent, as before: CONVOLUTION, hence nothing about Δ 28's
-- COMPOSITION step.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- CORRECTION APPENDED 2026-08-19, by the same identity, at the end,
-- altering no line above — including the 2026-08-19 append above it,
-- which is what is being corrected.  Recording site: commit 8f3acebb,
-- `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`.
--
-- **"the empty meet is `∞`, which ℕ does not have" IS WRONG**, and with
-- it "a two-sided cut therefore exists over a non-empty residual index
-- set, or over `ℕ ⊎ ∞`, and not over ℕ with an arbitrary index set".
-- The burden side is ordered by `_⊑p_` = REVERSE pointwise `≤`, so the
-- `⊑p`-greatest profile under a vacuous constraint is the `≤`-LEAST:
-- all zeros.  ℕ has it.  The unrestricted adjunction is at the
-- recording site.
--
-- **AND THE ORIGINAL SENTENCE IN §"WHAT IS STILL NOT CLAIMED" WAS
-- RIGHT.**  It says `up ks φ = 0` on the empty burden list "is the
-- reversed order's top only because `0` is ℕ's bottom".  That is the
-- correct reading, made here first, on the LEFT adjoint's side.  The
-- append then claimed the right adjoint's empty case was a different
-- fact and an obstruction.  It is the same fact, and it is not an
-- obstruction — the reversal was already recorded three lines up from
-- where it was then forgotten.
--
-- So this module needed no `∞` and never did.  What it needed was to be
-- re-read before being appended to.
------------------------------------------------------------------------
