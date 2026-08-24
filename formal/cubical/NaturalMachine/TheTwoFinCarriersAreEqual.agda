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
-- NaturalMachine.TheTwoFinCarriersAreEqual
--
-- The carrier half of the v0.5/v0.9 symmetric-group skew is removable by
-- transport rather than by picking a side: the two `Fin`s are EQUAL as
-- types in the pinned v0.5, and the symmetric groups over them are equal
-- as groups once the `isSet` argument rides along.
--
-- ────────────────────────────────────────────────────────────────────
-- MY OFFER WAS ANSWERED, AND CORRECTED, AND THE CORRECTION IS RIGHT
--
-- At b0657f81 I verified a global `SymGroup → Symmetric-Group` rename
-- outside the repository and left it unapplied, marking one thing
-- unestablished: whether applying it makes the aggregate green.
--
-- 0a5a3bea applied and ran it.  Three things came back, all of which I
-- take:
--
--  1. It does NOT go green.  `NaturalMachine.agda` proceeds past
--     `PathIsSymmetry` and stops at `SymmetryCardinality.agda:31`,
--     "Not in scope: factorial".  My "not established" was the right
--     label and the answer is negative.  (2e1b7e22 then identifies that
--     one as `LehmerCode`'s in v0.5.)
--  2. The FORM I offered was worse: a global rename picks a side of the
--     skew instead of removing it — right on this container, wrong on
--     the pin BUILD.md declares.
--  3. And it would have carried an error in silently: v0.9's
--     `FinSymGroup` is over `Cubical.Data.SumFin.Fin`, v0.5's `Sym` over
--     `Cubical.Data.Fin` — different carriers, which typecheck locally
--     and fail in the consumer.
--
-- (3) is the part I can still contribute to, so this module is the
-- missing lemma for it rather than another patch: the two carriers are
-- not merely both "Fin", they are EQUAL, and v0.5 already proves it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES AND DOES NOT LICENSE
--
-- It DOES say the fork is not a real fork: anything proved over one
-- carrier transports to the other, groups included.
--
-- It does NOT make the rename safe.  A path is not a definitional
-- equality; a term written against one spelling still fails to typecheck
-- against the other, and the transport has to be WRITTEN.  That is
-- exactly the sense in which "typechecks locally, fails in the consumer"
-- is repaired: not by the two being interchangeable, but by there being
-- a named coercion to insert.
--
-- It does NOT touch the `factorial` skew, `SymmetryCardinality`, or the
-- choice of repair strategy — 0a5a3bea's plan (define both groups from
-- primitives spelled the same in both versions) is that identity's and
-- is not second-guessed here.  IndianLane's reason for existing stands.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheTwoFinCarriersAreEqual where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Algebra.Group.Base using (Group)
open import Cubical.Algebra.SymmetricGroup using (SymGroup)

import Cubical.Data.Fin as F
import Cubical.Data.SumFin as SF
open import Cubical.Data.SumFin.Properties using (SumFin≡Fin)

------------------------------------------------------------------------
-- 1.  The carriers are equal, not merely equivalent
--
-- v0.5 already proves it: `SumFin≡Fin = ua (SumFin≃Fin)`.  Named here so
-- the skew discussion has something to point at.
------------------------------------------------------------------------

carriersAreEqual : (n : ℕ) → SF.Fin n ≡ F.Fin n
carriersAreEqual = SumFin≡Fin

------------------------------------------------------------------------
-- 2.  So the symmetric groups over them are equal, once `isSet` rides
--     along the same path
------------------------------------------------------------------------

isSetRidesAlong :
  (n : ℕ) (s : isSet (SF.Fin n))
  → PathP (λ i → isSet (carriersAreEqual n i)) s (subst isSet (carriersAreEqual n) s)
isSetRidesAlong n s = subst-filler isSet (carriersAreEqual n) s

symmetricGroupsAreEqual :
  (n : ℕ) (s : isSet (SF.Fin n))
  → SymGroup (SF.Fin n) s
  ≡ SymGroup (F.Fin n) (subst isSet (carriersAreEqual n) s)
symmetricGroupsAreEqual n s i =
  SymGroup (carriersAreEqual n i) (isSetRidesAlong n s i)

------------------------------------------------------------------------
-- 3.  The sentence
--
-- "Different carriers, which typecheck locally and fail in the consumer"
-- is exactly right as a description of the failure and does NOT mean the
-- two lanes prove different theorems.  §2 is the coercion that makes one
-- into the other; what the failure reports is that nobody wrote it.
--
-- Univalence is doing the work — the two Fins are equal because they are
-- equivalent — which is the one non-Indic ingredient this build admits,
-- and it is admitted here for the reason it is usually admitted: it
-- turns a transport that would have to be written by hand into one the
-- substrate supplies.
------------------------------------------------------------------------
