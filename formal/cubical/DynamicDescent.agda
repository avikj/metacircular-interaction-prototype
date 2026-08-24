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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DynamicDescent — the failure mode our descent law did not have
--
-- `DescentLaw.agda` says: an observable either factors through the
-- carrier or splits a fiber.  A visiting logician's objection stands:
-- at set level every equivalence relation is effective, so that
-- dichotomy cannot fail, and a law that cannot fail cannot organize.
--
-- Delta 19 (owner, 2026-08-13) supplies the missing failure mode, and
-- it is not a repair of the statement but a correction of its LEVEL.
-- Descent through an INSTANTANEOUS observation is not descent through
-- a DYNAMICS.  Quotienting by ker P discards distinctions that later
-- become visible; the only safe quotient is by
--
--     N_obs = ⋂_{n≥0} ker (P ∘ Tⁿ)
--
-- the distinctions invisible FOREVER.  Everything in between returns —
-- as memory.
--
-- PRIOR ART, IN THIS REPOSITORY, LANDED WHILE THIS WAS BEING WRITTEN:
-- `NaturalMachine/ExcursionReturn.agda` (cf-archivist, Delta 18 T18.4)
-- proves the general identity over an abstract ring with an arbitrary
-- time type:  K_t K_s − K_{t+s} = − P T_t Q T_s i.  That is the theorem;
-- this module is not it, and does not claim it.
--
-- What is added here is the part a general identity does not carry: a
-- numeric WITNESS that closure actually fails (`excursionObstruction`),
-- the converse direction (`closureIff` — an exact one-step summary
-- FORCES the excursion to vanish), and the asymmetry
-- (`pureLeakageIsFree` — leaving costs nothing, only returning does).
-- Two sessions proved the same criterion within the hour, from Delta 18
-- and Delta 19 independently; that duplication is itself the evidence
-- for the sync rule, and is recorded in msg 0466.
--
-- Here is that gap, exactly, at the smallest size where it exists.
-- Split a two-dimensional state into an observed coordinate and a
-- hidden one:  P = (1 0 / 0 0),  Q = I − P.  For any step operator
-- T = (a b / c d):
--
--   twoStepDefect :  (PTP)² − PT²P  ≡  − (PTQTP)      [T19.1/§19.0]
--
-- and that quantity is the single number bc.  So:
--
--   closure holds  ⟺  bc = 0  ⟺  b = 0 or c = 0
--
-- which is C19.10 made exact: an eliminated distinction matters only
-- if there is BOTH a channel into it and a channel back.  Pure leakage
-- is harmless; return is memory.  `excursionObstruction` below is the
-- witness that a one-step Markovian summary cannot reproduce two-step
-- behaviour — the smallest possible instance of T19.20, and the first
-- statement in this repository where descent genuinely FAILS.
------------------------------------------------------------------------

module DynamicDescent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Int using (pos)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul)
open import M2Unimodular using (det)

open CommRingStr (ℤCommRing .snd)

-- the observed sector, and its complement -----------------------------

P Q : M
P = (1r , 0r , 0r , 0r)
Q = (0r , 0r , 0r , 1r)

sub : M → M → M
sub (a , b , c , d) (a' , b' , c' , d') = (a - a' , b - b' , c - c' , d - d')

neg : M → M
neg (a , b , c , d) = (- a , - b , - c , - d)

-- THE DEFECT ----------------------------------------------------------
--
-- For these P and Q the blocks ARE the entries: writing T = (a b / c d),
-- the observed block A = a, the crossing blocks B = b and C = c, and
-- the hidden block D = d.  So the operator statements of Delta 19 are
-- scalar statements here, and nothing is lost by saying them that way.

markovSquare : R → R
markovSquare a = a · a            -- (P T P)² , the naive one-step summary

trueTwoStep : R → R → R → R
trueTwoStep a b c = a · a + b · c -- P T² P , what actually happens

excursion : R → R → R
excursion b c = b · c             -- P T Q T P : out of sector, and back

-- T19.1 at n = 2, exactly.  The naive Markovian square differs from the
-- true two-step dynamics by precisely minus the excursion.  No
-- approximation, no asymptotics: an identity.
twoStepDefect : (a b c : R)
              → markovSquare a - trueTwoStep a b c ≡ - (excursion b c)
twoStepDefect _ _ _ = solve! ℤCommRing

-- C19.10, exact: the eliminated coordinate matters iff there is BOTH a
-- channel into it (b) and a channel back (c).
-- C19.10, exact: an exact one-step summary forces the excursion to
-- vanish — the eliminated coordinate matters iff there is BOTH a
-- channel into it (b) and a channel back (c).
closureIff : (a b c : R)
           → markovSquare a ≡ trueTwoStep a b c
           → excursion b c ≡ 0r
closureIff a b c h = sym (cancel a (b · c)) ∙ cong (λ w → w - a · a) (sym h)
                     ∙ selfSub (a · a)
  where
  cancel : (a e : R) → (a · a + e) - a · a ≡ e
  cancel _ _ = solve! ℤCommRing
  selfSub : (x : R) → x - x ≡ 0r
  selfSub _ = solve! ℤCommRing

-- T19.20 at its smallest: with b = c = 1 the defect is 1, so NO one-step
-- operator on the observed sector reproduces two-step behaviour.  The
-- hidden coordinate is entered and returned from, and the memory shows
-- up at step two.  This is the first statement in this repository where
-- descent genuinely FAILS, with a witness.
excursionObstruction : excursion 1r 1r ≡ 1r
excursionObstruction = ·IdR 1r

-- and the honest negative: leakage without return costs nothing.
pureLeakageIsFree : (b : R) → excursion b 0r ≡ 0r
pureLeakageIsFree b = ·Comm b 0r
