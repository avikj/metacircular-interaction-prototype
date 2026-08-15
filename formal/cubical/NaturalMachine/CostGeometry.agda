{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- THE COST GEOMETRY OF REPRESENTATIONS
--
-- `TransportCost` measured one edge: transporting `+` along `ua ℕ≃CanWord`
-- computes, but quadratically, while native ripple-carry is flat.  That
-- measurement is not a wart and not a benchmark.  It is a WEIGHT ON AN EDGE
-- of a graph, and this module makes the graph an object.
--
-- The structure being formalised:
--
--   * a presentation of a task is a node;
--   * a checked equivalence is an edge;
--   * cost is a weight the equivalence does NOT carry -- paths transport
--     theorems, never complexity, which is exactly what `TransportCost`
--     measured -- so cost is a SEPARATE field riding alongside the path;
--   * a FAST ALGORITHM IS A DETOUR: a route out to another presentation,
--     work there, and back, whose total is less than working where you
--     stand.  FFT, Karatsuba, CRT multiplication and Montgomery form are
--     instances of one inequality.
--
-- The content is not that any particular algorithm is optimal.  It is that
-- the inequality DEFINING "speedup" is a triangle inequality failing in the
-- cheap direction, and it can be stated and proved inside type theory
-- rather than narrated in prose.
--
-- Deliberately weak: only +, ≤ and < are used, so every theorem holds for
-- any cost currency (steps, energy, proof length, bandwidth).  The geometry
-- does not depend on the unit.

module NaturalMachine.CostGeometry where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-assoc)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; ≤-trans ; ≤<-trans)

--------------------------------------------------------------------------
-- 1.  Cost: an abstract currency, concretely counted steps
--------------------------------------------------------------------------

-- ℕ is this repo's native unit: `CountedExecution.run` IS iteration over ℕ,
-- so a step count is the execution law's own coordinate.

Cost : Type₀
Cost = ℕ

--------------------------------------------------------------------------
-- 2.  Nodes and edges
--------------------------------------------------------------------------

-- A presentation is a carrier together with the operation AS IMPLEMENTED on
-- it.  Two presentations of "addition" are two programs, not two
-- descriptions of one program.

record Presentation : Type₁ where
  constructor pres
  field
    Carrier : Type₀
    op      : Carrier → Carrier → Carrier

open Presentation public

-- An edge is a translation together with what it costs to travel.  The maps
-- are the mathematics; the cost is the physics.  They are separate fields
-- BECAUSE a path does not determine a cost.  This record is the formal
-- statement of TransportCost's lesson.

record Edge (A B : Presentation) : Type₀ where
  constructor edge
  field
    move : Carrier A → Carrier B
    cost : Cost

open Edge public

-- The work of one application of a presentation's own operation.  A
-- property of the implementation, not derivable from the type -- so it is
-- supplied, exactly as a benchmark supplies it.

Work : Type₀
Work = Cost

--------------------------------------------------------------------------
-- 3.  Routes
--------------------------------------------------------------------------

-- Stay home and do the work.
direct : Work → Cost
direct w = w

-- Travel out (two arguments), work there, travel back (one result).  This
-- is precisely the shape of `transport (ua e) f = e⁻¹ ∘ f ∘ (e × e)`: the
-- transported term IS a detour, which is why it was slow -- it detoured
-- through unary ℕ.

detour : {A B : Presentation} → Edge A B → Edge B A → Work → Cost
detour out back w = (cost out + cost out) + (cost back + w)

--------------------------------------------------------------------------
-- 4.  The definition that was folklore
--------------------------------------------------------------------------

-- A speedup is a detour strictly cheaper than staying home.  One
-- inequality, stated once, for every fast algorithm.

Speedup : {A B : Presentation} → Edge A B → Edge B A → Work → Work → Type₀
Speedup out back wHere wThere = detour out back wThere < direct wHere

-- Flat geometry here: no detour through this neighbour pays.
NoSpeedup : {A B : Presentation} → Edge A B → Edge B A → Work → Work → Type₀
NoSpeedup out back wHere wThere = direct wHere ≤ detour out back wThere

--------------------------------------------------------------------------
-- 5.  Theorems
--------------------------------------------------------------------------

-- (T1)  THE TRANSPORT PENALTY IS A THEOREM, NOT AN ACCIDENT.
--
-- If the far presentation is no better at the work, the detour never wins,
-- whatever the translation costs.  Correctness transports along a path;
-- speed must be earned by a strictly better neighbour.
--
-- This is why `transport-+-is-⊕` is a certificate and NOT a compiler: the
-- transported term detours through ℕ, whose work is not smaller.

transport-is-never-free :
    {A B : Presentation} (out : Edge A B) (back : Edge B A)
    (wHere wThere : Work) → wHere ≤ wThere → NoSpeedup out back wHere wThere
transport-is-never-free out back wHere wThere wHere≤wThere =
  ≤-trans wHere≤wThere (≤-trans step₁ step₂)
  where
    step₁ : wThere ≤ (cost back + wThere)
    step₁ = cost back , refl

    step₂ : (cost back + wThere) ≤ ((cost out + cost out) + (cost back + wThere))
    step₂ = (cost out + cost out) , refl

-- (T2)  A SPEEDUP FORCES A STRICTLY BETTER NEIGHBOUR.
--
-- Contrapositive content of T1: if any detour wins, the far presentation is
-- strictly better at the work itself.  Hence "there is a fast algorithm"
-- IS "some representation does this job strictly cheaper" -- the search for
-- algorithms is the search for presentations.

speedup-forces-better-neighbour :
    {A B : Presentation} (out : Edge A B) (back : Edge B A)
    (wHere wThere : Work) → Speedup out back wHere wThere → wThere < wHere
speedup-forces-better-neighbour out back wHere wThere sp =
  ≤<-trans wThere≤detour sp
  where
    wThere≤detour : wThere ≤ detour out back wThere
    wThere≤detour =
      ((cost out + cost out) + cost back) ,
      sym (+-assoc (cost out + cost out) (cost back) wThere)

--------------------------------------------------------------------------
-- 6.  What this buys
--------------------------------------------------------------------------

-- T1 and T2 are small, and that is the evidence they are the right two:
-- with no analysis and no benchmark they say exactly what the 35.8-second
-- measurement said.  A path licenses a substitution; it never pays for one.
-- The weight is a separate coordinate, and the live mathematics -- which
-- presentations are cheap for which tasks, and where the triangle
-- inequality fails -- lives entirely in that coordinate.
--
-- Open, and the first real target: a CERTIFIED speedup.  Three
-- presentations of one task where the detour provably wins, edges checked,
-- weights honest.  If a known fast algorithm appears as the cheap route
-- without being told to, the geometry is real; if the graph is only a table
-- of measurements, it is a database and should be said so.

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
