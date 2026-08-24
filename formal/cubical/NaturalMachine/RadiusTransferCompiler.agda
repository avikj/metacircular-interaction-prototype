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

module NaturalMachine.RadiusTransferCompiler where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-trans ; <-trans)
open import Cubical.Data.Fin using (Fin ; toℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)

------------------------------------------------------------------------
-- Bounded-gap-to-radius-one interface already published on main
------------------------------------------------------------------------

-- The prime-pair predicate is a parameter.  This surface proves the transfer
-- compiler, not a new prime theorem and not an inhabitant of any edge.
module _ (PP : ℕ → ℕ → Type₀) where

  Unbounded : ℕ → Type₀
  Unbounded radius =
    (threshold : ℕ) → Σ[ center ∈ ℕ ] (threshold < center) × PP center radius

  record BoundedEdge (source target : ℕ) : Type₀ where
    field
      bound : ℕ → ℕ
      advances : (center : ℕ) → PP center source
        → Σ[ later ∈ ℕ ]
            (center < later) × (later ≤ bound center) × PP later target

  open BoundedEdge

  -- Factory III, Theorem 41: a bounded edge transports recurrence.  The
  -- finite window is retained in the edge even though unboundedness itself
  -- only consumes strict forward progress.
  edge-transports-unbounded : {source target : ℕ}
    → BoundedEdge source target → Unbounded source → Unbounded target
  edge-transports-unbounded edge recurrent threshold =
    later , <-trans threshold<center center<later , target-pair
    where
      source-witness = recurrent threshold
      center = fst source-witness
      threshold<center = fst (snd source-witness)
      source-pair = snd (snd source-witness)

      transferred = advances edge center source-pair
      later = fst transferred
      center<later = fst (snd transferred)
      target-pair = snd (snd (snd transferred))

  -- A path is proof-relevant: every hop contains its independently checked
  -- bound and arithmetic transfer theorem.
  data TransferPath : ℕ → ℕ → Type₀ where
    at-target : {radius : ℕ} → TransferPath radius radius
    _then_ : {source middle target : ℕ}
      → BoundedEdge source middle
      → TransferPath middle target
      → TransferPath source target

  infixr 20 _then_

  path-transports-unbounded : {source target : ℕ}
    → TransferPath source target → Unbounded source → Unbounded target
  path-transports-unbounded at-target recurrent = recurrent
  path-transports-unbounded (edge then rest) recurrent =
    path-transports-unbounded rest
      (edge-transports-unbounded edge recurrent)

  -- Published bounded gaps is consumed only through this exact interface:
  -- some recurrent radius in the closed band 1..123.  No particular seed
  -- radius is assumed or selected by the compiler.
  BoundedGapSeed₁₂₃ : Type₀
  BoundedGapSeed₁₂₃ =
    Σ[ radius ∈ ℕ ] (1 ≤ radius) × (radius ≤ 123) × Unbounded radius

  -- The nontrivial Theta-fiber: not reachability as a Boolean, but an actual
  -- bounded proof path from every admissible seed radius to radius one.
  RadiusTransferFabric₁₂₃ : Type₀
  RadiusTransferFabric₁₂₃ =
    (radius : ℕ) → 1 ≤ radius → radius ≤ 123
    → TransferPath radius 1

  -- Factory III, Theorems 42 and 48.  Once the bounded-gap seed and the
  -- proof-relevant fabric are supplied, the compiler produces recurrence of
  -- radius one.  With PP instantiated as prime-pair witnesses, this is the
  -- twin-prime consequence.  This file supplies neither input.
  compile-radius-transfer :
    BoundedGapSeed₁₂₃ → RadiusTransferFabric₁₂₃ → Unbounded 1
  compile-radius-transfer (radius , lower , upper , recurrent) fabric =
    path-transports-unbounded (fabric radius lower upper) recurrent

------------------------------------------------------------------------
-- Later stranded refinement: compositional and ranked generic compiler
------------------------------------------------------------------------

module Compiler (PP : ℕ → ℕ → Type₀) where

  record ColumnAbove (radius threshold : ℕ) : Type₀ where
    constructor column
    field
      center : ℕ
      threshold<center : threshold < center
      pp : PP center radius

  open ColumnAbove public

  record UnboundedColumn (radius : ℕ) : Type₀ where
    constructor unbounded
    field
      generateAbove : (lower : ℕ) → ColumnAbove radius lower

  open UnboundedColumn public

  Recurrence : ℕ → Type₀
  Recurrence = UnboundedColumn

  record TransferOutput (target input bound : ℕ) : Type₀ where
    constructor output
    field
      output-center : ℕ
      input<output : input < output-center
      output≤bound : output-center ≤ bound
      output-pp : PP output-center target

  open TransferOutput public

  record Edge (source target : ℕ) : Type₀ where
    constructor edge
    field
      β : ℕ → ℕ
      β-forward : (w : ℕ) → w < β w
      β-monotone : {w v : ℕ} → w ≤ v → β w ≤ β v
      transfer : (w : ℕ) → PP w source
               → TransferOutput target w (β w)

  open Edge public

  edge-recurrence : {source target : ℕ}
                  → Edge source target
                  → Recurrence source
                  → Recurrence target
  edge-recurrence e recurrent =
    unbounded λ threshold → moved threshold
    where
    moved : (threshold : ℕ) → ColumnAbove _ threshold
    moved threshold with generateAbove recurrent threshold
    ... | column w threshold<w witness with transfer e w witness
    ... | output w′ w<w′ w′≤βw witness′ =
      column w′ (<-trans threshold<w w<w′) witness′

  compose-edge : {r s t : ℕ} → Edge r s → Edge s t → Edge r t
  compose-edge e₁ e₂ = edge composite-β forward monotone moved
    where
    composite-β : ℕ → ℕ
    composite-β w = β e₂ (β e₁ w)

    forward : (w : ℕ) → w < composite-β w
    forward w = <-trans (β-forward e₁ w) (β-forward e₂ (β e₁ w))

    monotone : {w v : ℕ} → w ≤ v → composite-β w ≤ composite-β v
    monotone w≤v = β-monotone e₂ (β-monotone e₁ w≤v)

    moved : (w : ℕ) → PP w _ → TransferOutput _ w (composite-β w)
    moved w witness with transfer e₁ w witness
    ... | output w₁ w<w₁ w₁≤β₁w witness₁ with transfer e₂ w₁ witness₁
    ... | output w₂ w₁<w₂ w₂≤β₂w₁ witness₂ =
      output w₂
        (<-trans w<w₁ w₁<w₂)
        (≤-trans w₂≤β₂w₁ (β-monotone e₂ w₁≤β₁w))
        witness₂

  data ComposedPath : ℕ → ℕ → Type₀ where
    finish : {r s : ℕ} → r ≡ s → ComposedPath r s
    follow : {r s t : ℕ} → Edge r s → ComposedPath s t
           → ComposedPath r t

  path-recurrence : {r s : ℕ} → ComposedPath r s
                  → Recurrence r → Recurrence s
  path-recurrence (finish p) recurrent = subst Recurrence p recurrent
  path-recurrence (follow e p) recurrent =
    path-recurrence p (edge-recurrence e recurrent)

  compose-path : {r s t : ℕ}
               → ComposedPath r s → ComposedPath s t → ComposedPath r t
  compose-path (finish p) q =
    subst (λ radius → ComposedPath radius _) (sym p) q
  compose-path (follow e p) q = follow e (compose-path p q)

  Θ : ℕ → ℕ → Type₀
  Θ = ComposedPath

  record BG (radius : ℕ) : Type₀ where
    constructor bg
    field
      seed-generator : Recurrence radius

  open BG public

  TargetPairGenerator : ℕ → Type₀
  TargetPairGenerator = Recurrence

  compile-BG×Θ : {source target : ℕ}
               → BG source × Θ source target
               → TargetPairGenerator target
  compile-BG×Θ (seed , route) =
    path-recurrence route (seed-generator seed)

  data RankedDescent {n : ℕ}
       (radius : Fin n → ℕ) (target : Fin n) : Fin n → Type₀ where
    at-target : {i : Fin n} → i ≡ target
              → RankedDescent radius target i
    descend : {i j : Fin n}
            → Edge (radius i) (radius j)
            → toℕ j < toℕ i
            → RankedDescent radius target j
            → RankedDescent radius target i

  ranked-path : {n : ℕ} {radius : Fin n → ℕ} {target i : Fin n}
              → RankedDescent radius target i
              → ComposedPath (radius i) (radius target)
  ranked-path (at-target p) = finish (cong _ p)
  ranked-path (descend e rank< route) = follow e (ranked-path route)

  record RankedArchitecture (n : ℕ) : Type₀ where
    constructor ranked-architecture
    field
      radius : Fin n → ℕ
      target : Fin n
      terminates : (i : Fin n) → RankedDescent radius target i

  open RankedArchitecture public

  architecture-Θ : {n : ℕ} (A : RankedArchitecture n) (i : Fin n)
                 → Θ (radius A i) (radius A (target A))
  architecture-Θ A i = ranked-path (terminates A i)

  compile-ranked : {n : ℕ} (A : RankedArchitecture n) (i : Fin n)
                 → BG (radius A i)
                 → TargetPairGenerator (radius A (target A))
  compile-ranked A i seed =
    compile-BG×Θ (seed , architecture-Θ A i)

  DirectToTarget : ℕ → ℕ → Type₀
  DirectToTarget source target = Recurrence source → Recurrence target

  Θ-direct : {source target : ℕ}
           → Θ source target → DirectToTarget source target
  Θ-direct = path-recurrence

  honesty-direct+seed : {source target : ℕ}
                      → DirectToTarget source target
                      → BG source
                      → Recurrence target
  honesty-direct+seed direct seed = direct (seed-generator seed)

  honesty-target→direct : {source target : ℕ}
                        → Recurrence target
                        → DirectToTarget source target
  honesty-target→direct target-recurrence source-recurrence =
    target-recurrence
