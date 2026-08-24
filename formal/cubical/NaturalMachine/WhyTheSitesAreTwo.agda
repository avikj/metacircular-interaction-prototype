-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WhyTheSitesAreTwo
--
-- `WitnessNumberIsUnbounded` settled that there is no general ceiling —
-- witness number 3 exists — and left the sharper question open:
--
--     whether any absence arising from the MATHEMATICS here, rather
--     than constructed to order, exceeds 2.  Nothing found so far does.
--     This module cannot tell whether that is a fact about the
--     mathematics or about how the sites were chosen.
--
-- It is neither.  It is a fact about the DECODER SPACE, and here is the
-- theorem.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
--     collisionFree→notRefuting :
--       Discrete Y
--       → (no two points of the list collide with different values)
--       → ¬ Refutes (factorLaw q t) (x₀ ∷ xs)
--
-- Contrapositively: over an UNCONSTRAINED decoder space `Image q → T`,
-- a list can only refute by containing a collision.  And a collision is
-- already a refuting pair (`WitnessNumberIsTwo` §4).  So no refuting
-- list is ever essentially longer than 2 — the extra points are inert.
--
-- That is why every site in this corpus is 2, and it is not luck and
-- not a choice of examples: every one of them has a function space as
-- its decoders and a discrete Y (ℕ, Bool, lists of ℕ).  The three-way
-- example of `WitnessNumberIsUnbounded` escapes precisely because its
-- decoders are three atoms rather than all functions — the survivor it
-- relies on is a function the unconstrained space would have contained.
--
-- ────────────────────────────────────────────────────────────────────
-- HOW IT GOES
--
-- If the list has no collision, build the decoder by table lookup:
-- walk the list, return the first entry whose observation matches.
-- Collision-freeness says every matching entry has the same value, so
-- the table is consistent; discreteness of Y is what lets the walk
-- compare observations at all.  Then the table answers every point of
-- the list, so the list does not refute.
--
-- Discreteness is the only hypothesis and it is doing real work — it is
-- what makes "the first matching entry" a computation rather than a
-- choice.  Nothing is assumed about T beyond having the values the
-- table stores.
--
-- ────────────────────────────────────────────────────────────────────
-- FOR THE DEFLATIONARY THREAD
--
-- This is the strongest form of the deflation so far.  It is not that
-- the obstructions here happen to be cheap; over discrete observations
-- and unconstrained decoders they CANNOT be expensive.  Any barrier
-- stated in this shape is a two-point statement, and calling it a
-- barrier is the language exceeding the object — now with a theorem
-- saying by how much, rather than a survey saying "so far".
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.WhyTheSitesAreTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥ ; ⊥*)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import NaturalMachine.WitnessNumberIsTwo
  using (AllHold ; Refutes ; factorLaw ; collision→refutes)

private
  variable
    ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  Membership, level-polymorphic
------------------------------------------------------------------------

Mem : {A : Type ℓx} → A → List A → Type ℓx
Mem x []       = ⊥*
Mem x (y ∷ ys) = (x ≡ y) ⊎ Mem x ys

------------------------------------------------------------------------
-- 2.  A list with no collision
------------------------------------------------------------------------

CollisionFree : {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
              → (X → Y) → (X → T) → List X → Type (ℓ-max ℓx (ℓ-max ℓy ℓt))
CollisionFree {X = X} q t ys =
  (a b : X) → Mem a ys → Mem b ys → q a ≡ q b → t a ≡ t b

------------------------------------------------------------------------
-- 3.  The table, and that it is correct on the list
------------------------------------------------------------------------

module _ {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
         (dY : Discrete Y) (q : X → Y) (t : X → T) (fb : T) where

  table : Y → List X → T
  table y []       = fb
  table y (x ∷ xs) with dY (q x) y
  ... | yes _ = t x
  ... | no  _ = table y xs

  -- the walk returns the value of SOME matching entry; collision
  -- freeness makes that the value of the entry asked about
  table-correct :
    (ys : List X) → CollisionFree q t ys
    → (x : X) → Mem x ys → table (q x) ys ≡ t x
  table-correct []       cf x m = Empty.rec* m
  table-correct (y ∷ ys) cf x m with dY (q y) (q x)
  ... | yes e = cf y x (inl refl) m e
  ... | no ¬e = table-correct ys cf' x (later m)
    where
    cf' : CollisionFree q t ys
    cf' a b ma mb = cf a b (inr ma) (inr mb)

    later : Mem x (y ∷ ys) → Mem x ys
    later (inl x≡y) = Empty.rec (¬e (sym (cong q x≡y)))
    later (inr r)   = r

------------------------------------------------------------------------
-- 4.  THE THEOREM: without a collision, a list cannot refute
------------------------------------------------------------------------

module _ {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
         (dY : Discrete Y) (q : X → Y) (t : X → T) where

  collisionFree→notRefuting :
    (x₀ : X) (xs : List X)
    → CollisionFree q t (x₀ ∷ xs)
    → ¬ Refutes (factorLaw q t) (x₀ ∷ xs)
  collisionFree→notRefuting x₀ xs cf ref =
    ref decode (holds (x₀ ∷ xs) (λ _ m → m))
    where
    decode : Image q → T
    decode p = table dY q t (t x₀) (fst p) (x₀ ∷ xs)

    holds : (ys : List X) → ((x : X) → Mem x ys → Mem x (x₀ ∷ xs))
          → AllHold (factorLaw q t) decode ys
    holds []       _   = tt*
    holds (y ∷ ys) inc =
        table-correct dY q t (t x₀) (x₀ ∷ xs) cf y (inc y (inl refl))
      , holds ys (λ z m → inc z (inr m))

------------------------------------------------------------------------
-- 5.  So a refuting list is never essentially longer than two
--
-- A list refutes only by containing a collision, and a collision is
-- already a refuting pair.  Stated as the contrapositive it is
-- constructive; stated as "extract the pair" it would not be, because
-- `Refutes` is a negation and ¬∀ does not give ∃¬.  The theorem below
-- is the honest form: refutation and collision-freeness are
-- incompatible.
------------------------------------------------------------------------

  refuting-lists-collide :
    (x₀ : X) (xs : List X)
    → Refutes (factorLaw q t) (x₀ ∷ xs)
    → ¬ CollisionFree q t (x₀ ∷ xs)
  refuting-lists-collide x₀ xs ref cf = collisionFree→notRefuting x₀ xs cf ref

  -- and where the collision is in hand, two points are the whole list
  collision-is-enough :
    {x x' : X} → q x ≡ q x' → ¬ (t x ≡ t x')
    → Refutes (factorLaw q t) (x ∷ x' ∷ [])
  collision-is-enough = collision→refutes q t

------------------------------------------------------------------------
-- 6.  What this settles.
--
-- SETTLED.  The uniform 2 across this corpus is neither luck nor a
-- choice of examples.  Every site here has an unconstrained decoder
-- space `Image q → T` and a discrete Y, and under exactly those two
-- conditions a list refutes only by containing a collision — so the
-- witness number is 2 whenever it is finite at all.
--
-- The three-way example of `WitnessNumberIsUnbounded` is consistent
-- with this and shows where the hypothesis bites: its decoders are
-- three atoms, not all functions, so the table this module builds is
-- not among them.  Constrain the decoders and the number can rise;
-- leave them unconstrained over discrete observations and it cannot.
--
-- OPEN, named and not estimated.  Whether discreteness of Y can be
-- weakened — the table walk needs to compare observations, and nothing
-- here says a weaker comparison would not do.  Also: the same question
-- for decoder spaces that are constrained but still large, where
-- neither this theorem nor the three-atom example applies.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  THE FIRST OPEN ITEM IN §6 IS ANSWERED.
--
-- §6 asked whether discreteness of Y can be weakened and declined to
-- guess.  It can, and `NaturalMachine.LocatingIsEnough` gives exactly
-- how far: this proof never compares two arbitrary observations.  It
-- compares the LIST'S observations against an incoming one, and there
-- are finitely many of those.  The hypothesis it consumes is
--
--     Locates q []       = Unit
--     Locates q (x ∷ xs) = ((y : Y) → Dec (q x ≡ y)) × Locates q xs
--
-- and `collisionFree→notRefuting` above is the corollary at
-- `Discrete Y`, rederived there as `discrete-corollary`.
--
-- The shift is from an EQUALITY problem on the whole observation space
-- to a LOCATION problem on the witnesses: the decoder is handed an
-- observation and must find which listed point produced it.  That is
-- all it ever needed.  The measure was already local to the witnesses;
-- its hypothesis now is too.
--
-- So a site whose Y is not discrete is not automatically outside the
-- deflation — only one whose witnesses cannot be located, which is a
-- smaller class and a checkable condition.
--
-- Still open there, and unestimated: whether `Locates` is minimal, and
-- the constrained-but-large decoder case, which this does not touch.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  CORRECTION to §6, appended after the audit was actually done.
--
-- §6 says "Every site here has an unconstrained decoder space
-- `Image q → T` and a discrete Y, and under exactly those two
-- conditions … so the witness number is 2 whenever it is finite at all."
-- The second clause was asserted, not checked.  It is false.
--
-- `NaturalMachine.SiteAudit` enumerates the sites.  Two are not covered:
--
--   * `Laghava` observes into `Denotation = ℕ → ℕ`, which is neither
--     discrete nor (as far as anything here shows) locatable — so
--     neither this theorem nor `LocatingIsEnough` applies at the site
--     the whole लाघव thread is about;
--   * `AvaktavyaDoesNotFactor` has six atoms as its decoders, not a
--     function space.
--
-- Both are nonetheless exactly 2, proved individually — `Laghava` in
-- `SiteAudit` §3, avaktavya in `WitnessNumberIsTwo` §5.
--
-- The distinction the overstatement blurred is worth keeping:
--
--   achievability (≤ 2)  from an exhibited collision; no hypothesis;
--   the floor (≥ 2)      from the constant decoder; needs only that the
--                        decoder space contain constants;
--   the CEILING          this theorem; needs discreteness or
--                        locatability, and is what fails at `Laghava`.
--
-- So "2 was never contingent here" holds at the discrete sites and is
-- unproved at `Laghava`, where nothing rules out a costlier absence over
-- the same `eval`.
--
-- Also fixed there: two sites quantify over decoders on the WHOLE
-- codomain (`Denotation → ℕ`, `List Bool → Bool`) rather than over
-- `Image q → T`, so this theorem did not literally cover their shape.
-- `SiteAudit` §1 gives that variant, and it is simpler than this one.
------------------------------------------------------------------------
