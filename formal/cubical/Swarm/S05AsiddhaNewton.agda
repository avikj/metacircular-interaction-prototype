{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- S05AsiddhaNewton
--
-- swarm-0814-05.  Companion prose:
-- collab/swarm/2026-08-14/swarm-0814-05-asiddha-newton.md
--
-- THE OBJECT.  The Newton–Hensel doubling map of the broadcast
-- collab/messages/workers/20260812T090836.491254Z--codex_arithmetic_life--0001.md
--
--     N a x = x · (2 - a · x)
--
-- is not an iteration whose limit is the inverse.  It is the inverse of
-- a bijection that is already there.  Everything Hensel lifting does
-- for units is FOUR polynomial identities in ℤ[a,x,y]; each identity is
-- exactly one of the four clauses of "truncation is a bijection on
-- solution sets".  Write ε = res a x = 1 - a·x.
--
--   (1) doubling  1 - a·N a x        ≡ ε²
--                 the lift lands one thickening deeper.
--   (2) stale     N a x - N a y      ≡ (x - y)·(ε_x + ε_y)
--                 ASIDDHA: the rule reads x only modulo I and is still
--                 well defined modulo I².  Two inputs that a stage-I
--                 observer cannot tell apart have outputs a stage-I²
--                 observer cannot tell apart.  Pāṇini 8.2.1: the later
--                 rule sees the earlier stage "as if not effected", and
--                 that is not sloppiness, it is a theorem.
--   (3) rigid     x - y              ≡ x·ε_y - y·ε_x
--                 uniqueness: two solutions at depth I² agree at depth
--                 I².  The truncation is injective; nothing is chosen.
--   (4) section   N a x - x          ≡ x·ε_x
--                 the lift is a section of the truncation.
--
-- Consequently the tower of solution sets is CONSTANT: there is no
-- convergence, no rate, no step count, and nothing to measure.  This is
-- the infinitesimal lifting criterion — the inversion locus is formally
-- étale over the base — stated with the ideal quantifiers made explicit
-- and no ∞-categorical machinery used (see the note, §5, on why the
-- higher-categorical restatement adds no arithmetic content here).
--
-- Nothing below is postulated and there are no holes.  §4 is a
-- self-contained exact computation over ℤ: the broadcast's boxed
-- 5⁻¹ ≡ 29 (mod 72), obtained by ONE application of N, with no
-- kuṭṭaka, no CRT gluing and no per-prime residue sensors.
------------------------------------------------------------------------

module Swarm.S05AsiddhaNewton where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The four identities, in an arbitrary commutative ring.
------------------------------------------------------------------------

module Core (R' : CommRing ℓ) where

  private
    R = ⟨ R' ⟩

  open CommRingStr (R' .snd)

  -- the residual, i.e. the defect of x from being an inverse of a
  res : R → R → R
  res a x = 1r - a · x

  -- the Newton–Hensel update
  N : R → R → R
  N a x = x · ((1r + 1r) - a · x)

  private
    lem-doubling : (a x : R)
                 → 1r - a · (x · ((1r + 1r) - a · x))
                   ≡ (1r - a · x) · (1r - a · x)
    lem-doubling = solve R'

    lem-stale : (a x y : R)
              → x · ((1r + 1r) - a · x) - y · ((1r + 1r) - a · y)
                ≡ (x - y) · ((1r - a · x) + (1r - a · y))
    lem-stale = solve R'

    lem-rigid : (a x y : R)
              → x - y ≡ x · (1r - a · y) - y · (1r - a · x)
    lem-rigid = solve R'

    lem-section : (a x : R)
                → x · ((1r + 1r) - a · x) - x ≡ x · (1r - a · x)
    lem-section = solve R'

  -- (1) one step squares the residual
  doubling : (a x : R) → res a (N a x) ≡ res a x · res a x
  doubling = lem-doubling

  -- (2) asiddha: the difference of outputs factors through the
  --     difference of inputs TIMES a sum of residuals
  stale : (a x y : R) → N a x - N a y ≡ (x - y) · (res a x + res a y)
  stale = lem-stale

  -- (3) rigidity: the difference of two candidates factors through
  --     their residuals
  rigid : (a x y : R) → x - y ≡ x · res a y - y · res a x
  rigid = lem-rigid

  -- (4) the update moves x by x times its own residual
  section : (a x : R) → N a x - x ≡ x · res a x
  section = lem-section

------------------------------------------------------------------------
-- §2  A thickening: an ideal I and an ideal K absorbing I·I.
--
-- K plays the role of I², but is only required to CONTAIN the products
-- of pairs from I.  Nothing here needs finite sums of products, because
-- identities (1)–(4) never produce more than one product at a time.
------------------------------------------------------------------------

record Thickening (R' : CommRing ℓ) : Type (ℓ-suc ℓ) where
  open CommRingStr (R' .snd)
  private
    R = ⟨ R' ⟩
  field
    I K : R → Type ℓ
    K⊆I : {r : R} → K r → I r
    I+  : {r s : R} → I r → I s → I (r + s)
    I·  : (t : R) {r : R} → I r → I (t · r)
    K−  : {r s : R} → K r → K s → K (r - s)
    K·  : (t : R) {r : R} → K r → K (t · r)
    I·I : {r s : R} → I r → I s → K (r · s)

------------------------------------------------------------------------
-- §3  Truncation of solution sets is a bijection, with explicit
--     inverse N.  Each clause is one identity of §1.
------------------------------------------------------------------------

module Tower (R' : CommRing ℓ) (T : Thickening R') where

  private
    R = ⟨ R' ⟩

  open CommRingStr (R' .snd)
  open Thickening T
  open Core R'

  -- solutions of a·x = 1 at the two depths
  SolI SolK : R → Type ℓ
  SolI a = Σ[ x ∈ R ] I (res a x)
  SolK a = Σ[ x ∈ R ] K (res a x)

  -- (1) ⇒ the lift lands at the deeper level
  lands : (a x : R) → I (res a x) → K (res a (N a x))
  lands a x i = subst K (sym (doubling a x)) (I·I i i)

  -- (2) ⇒ the lift is well defined on I-indistinguishable inputs:
  --       ASIDDHA.  This is the only clause with content beyond
  --       bookkeeping, and it is the clause that makes "the rule reads
  --       a stale stage" legitimate rather than an approximation.
  asiddha : (a x y : R) → I (res a x) → I (res a y)
          → I (x - y) → K (N a x - N a y)
  asiddha a x y ix iy d = subst K (sym (stale a x y)) (I·I d (I+ ix iy))

  -- (3) ⇒ the truncation is injective: any two deep solutions are
  --       already indistinguishable at the deep level
  unique : (a x y : R) → K (res a x) → K (res a y) → K (x - y)
  unique a x y kx ky =
    subst K (sym (rigid a x y)) (K− (K· x ky) (K· y kx))

  -- (4) ⇒ the lift is a section of the truncation
  over : (a x : R) → I (res a x) → I (N a x - x)
  over a x i = subst I (sym (section a x)) (I· x i)

  -- the two maps
  trunc : (a : R) → SolK a → SolI a
  trunc a (x , k) = x , K⊆I k

  newton : (a : R) → SolI a → SolK a
  newton a (x , i) = N a x , lands a x i

  -- round trip 1: newton ∘ trunc is the identity, at depth K
  newton-trunc : (a : R) (s : SolK a) → K (fst (newton a (trunc a s)) - fst s)
  newton-trunc a (x , k) = unique a (N a x) x (lands a x (K⊆I k)) k

  -- round trip 2: trunc ∘ newton is the identity, at depth I
  trunc-newton : (a : R) (s : SolI a) → I (fst (trunc a (newton a s)) - fst s)
  trunc-newton a (x , i) = over a x i

  -- and newton respects I-indistinguishability, so it descends
  newton-cong : (a : R) (s t : SolI a) → I (fst s - fst t)
              → K (fst (newton a s) - fst (newton a t))
  newton-cong a (x , ix) (y , iy) d = asiddha a x y ix iy d

------------------------------------------------------------------------
-- §4  The broadcast's example, recomputed as one Newton step.
--
-- The broadcast obtained 5⁻¹ ≡ 29 (mod 72) by lifting 5⁻¹ ≡ 5 (mod 8)
-- and 5⁻¹ ≡ 2 (mod 9) and gluing by kuṭṭaka/CRT.  But 5·5 = 25 = 1+24,
-- so x = 5 is already a solution at depth I = (24), and ONE application
-- of N lands at depth (24²) = (576) ⊇ (72).  No gluing, no per-prime
-- sensors, no shared-prime obstruction to check: the CRT step is not
-- doing arithmetic work here, it is doing bookkeeping that identity (1)
-- has already done.
--
-- All four statements are `refl`: exact integer computation, which the
-- repository protocol counts as proof rather than as measurement.
------------------------------------------------------------------------

open Core ℤCommRing using () renaming (N to Nℤ ; res to resℤ)

-- 1 - 5·5 = -24 : x = 5 solves 5·x = 1 at depth (24)
start : resℤ (pos 5) (pos 5) ≡ negsuc 23
start = refl

-- one step:  N 5 5 = 5·(2 - 25) = -115
step : Nℤ (pos 5) (pos 5) ≡ negsuc 114
step = refl

-- the new residual is 576 = 24², exactly as identity (1) predicts
deep : resℤ (pos 5) (Nℤ (pos 5) (pos 5)) ≡ pos 576
deep = refl

square : negsuc 23 · negsuc 23 ≡ pos 576
  where open CommRingStr (ℤCommRing .snd) using (_·_)
square = refl

-- 576 = 8·72, so the answer is already correct modulo 72:
--   -115 + 144 = 29, and 144 = 2·72
answer : negsuc 114 + pos 144 ≡ pos 29
  where open CommRingStr (ℤCommRing .snd) using (_+_)
answer = refl
