{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CostGeometryIndexed
--
-- THE REPAIR TWO AUDITS ASKED FOR, ON THE SAME DAY, FROM OPPOSITE SIDES.
--
-- `CostGeometry.Edge` carries `cost : Cost` -- one number per edge -- and
-- `Work` is one number too.  On 2026-08-15 that turned out to be the
-- defect in both of the places the geometry was applied:
--
--   * `CountedDigitsEdge.no-edge-carries-native-cost` proves NO edge can
--     carry the odometer's carry cost, because that cost is 1 at [] and 2
--     at the maximal word.  A scalar field cannot hold a function of the
--     state.  Its reading: `CostGeometry` prices TRANSLATIONS, and a carry
--     recursion is not a translation.
--
--   * the breaker pass on R0079 reached the same field from the other
--     end: quantifying over `c c'` in `TransportDivScale` quantifies over
--     CONSTANT weights only, so a threshold of the form
--     `4 + (2c + c′) ≤ length w` bounds the word by the weights rather
--     than the weights by the word -- and priced at the honest cost of
--     charting (`digits m` iterates the odometer m times) the headline
--     comparison reverses.
--
-- Both are the same sentence: cost is a function of the input, and the
-- record said it was a number.  Here it is a function.
--
-- WHAT THIS FILE DOES NOT DO.  It does not re-derive Γ↝ or the branch
-- calculus over the indexed geometry; those live in `Residual` and are
-- still scalar.  What it does is state the indexed geometry, prove that
-- the scalar one embeds in it faithfully (so nothing checked is lost),
-- and prove the two facts that made the repair necessary: a speedup here
-- is POINTWISE, and a pointwise speedup is strictly weaker than a uniform
-- one -- there is a bridge that wins at one input and loses at another,
-- which is precisely the configuration the scalar record cannot express.
------------------------------------------------------------------------

module CostGeometryIndexed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-assoc)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; zero-≤ ; suc-≤-suc ; ≤-refl ; ≤-trans ; ≤<-trans ; ¬m<m)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import CostGeometry as Scalar
  using (Cost ; Presentation ; pres ; Carrier ; op ; Edge ; edge ; move ; cost ; Work)

--------------------------------------------------------------------------
-- 1.  Work and cost as functions of the input
--------------------------------------------------------------------------

IWork : Presentation → Type₀
IWork A = Carrier A → Cost

record IEdge (A B : Presentation) : Type₀ where
  constructor iedge
  field
    imove : Carrier A → Carrier B
    icost : Carrier A → Cost     -- what THIS input costs to move

open IEdge public

-- The honest round trip: pay to leave at the input you have, work at the
-- image, pay to come back from the image.  The scalar version charged the
-- outbound edge twice; that was an artefact of having nowhere to put the
-- return's dependence on where you landed, and it disappears here.
idetour : {A B : Presentation}
        → IEdge A B → IEdge B A → IWork B → IWork A
idetour out back w a = icost out a + (w (imove out a) + icost back (imove out a))

ISpeedup : {A B : Presentation}
         → IEdge A B → IEdge B A → IWork A → IWork B → Carrier A → Type₀
ISpeedup out back wHere wThere a = idetour out back wThere a < wHere a

-- Uniform means: at every input.  The scalar geometry could only ever say
-- this, because it had no input to quantify over.
UniformSpeedup : {A B : Presentation}
               → IEdge A B → IEdge B A → IWork A → IWork B → Type₀
UniformSpeedup {A} out back wHere wThere =
  (a : Carrier A) → ISpeedup out back wHere wThere a

--------------------------------------------------------------------------
-- 2.  The scalar geometry embeds, faithfully
--------------------------------------------------------------------------

fromEdge : {A B : Presentation} → Edge A B → IEdge A B
fromEdge e = iedge (move e) (λ _ → cost e)

constWork : {A : Presentation} → Work → IWork A
constWork w _ = w

-- A constant-cost bridge has a constant detour, and it is the scalar
-- detour minus the duplicated outbound charge.  Stated as an equation so
-- the difference is visible rather than argued about.
idetour-const :
    {A B : Presentation} (out : Edge A B) (back : Edge B A) (w : Work)
    (a : Carrier A)
  → idetour (fromEdge out) (fromEdge back) (constWork {A = B} w) a
    ≡ cost out + (w + cost back)
idetour-const out back w a = refl

--------------------------------------------------------------------------
-- 3.  Why the repair was needed: a bridge that wins here and loses there
--
-- This is `CountedDigitsEdge.no-edge-carries-native-cost` in the abstract:
-- the two-point presentation with a cost of 0 at one point and 9 at the
-- other.  No scalar edge has this cost function, and the speedup it
-- induces holds at one input and fails at the other -- so `Speedup` as a
-- proposition about a bridge, with no input named, is not a proposition
-- about anything.
--------------------------------------------------------------------------

two : Presentation
two = pres Bool (λ x _ → x)

cheapAt : Bool → Cost
cheapAt true  = 0
cheapAt false = 9

there' : IEdge two two
there' = iedge (λ x → x) cheapAt

back' : IEdge two two
back' = iedge (λ x → x) (λ _ → 0)

homeWork : IWork two
homeWork _ = 5

farWork : IWork two
farWork _ = 1

-- at `true` the detour costs 0 + (1 + 0) = 1 < 5
wins-at-true : ISpeedup there' back' homeWork farWork true
wins-at-true = 3 , refl

-- at `false` it costs 9 + (1 + 0) = 10, and 10 < 5 is false
loses-at-false : ¬ ISpeedup there' back' homeWork farWork false
loses-at-false h = ¬m<m (≤<-trans h 5<11)
  where
    5<11 : 5 < 11
    5<11 = 5 , refl

-- and therefore the same bridge is not uniformly a speedup
not-uniform : ¬ UniformSpeedup there' back' homeWork farWork
not-uniform u = loses-at-false (u false)

-- POINTWISE IS STRICTLY WEAKER, exhibited.  This is the statement the
-- scalar record could not make, and the reason two independent audits
-- landed on the same field.
pointwise-is-weaker :
  Σ[ A ∈ Presentation ] Σ[ B ∈ Presentation ]
    Σ[ out ∈ IEdge A B ] Σ[ back ∈ IEdge B A ]
      Σ[ wH ∈ IWork A ] Σ[ wT ∈ IWork B ]
        Σ[ a ∈ Carrier A ] (ISpeedup out back wH wT a
                            × (¬ UniformSpeedup out back wH wT))
pointwise-is-weaker =
  two , two , there' , back' , homeWork , farWork , true ,
  wins-at-true , not-uniform

-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical, with the back-port in
-- notes/CUBICAL_PATCH.md), --cubical --safe, 2026-08-15.  No postulates,
-- no holes.  NOT verified against the pin (Agda 2.8.0, cubical v0.9).
