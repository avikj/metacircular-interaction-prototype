{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.FiniteGraphCohomology
--
-- A small graph-cochain interface over F2.  It deliberately stops before a
-- general homology development: the exact reusable object needed downstream
-- is a cycle evaluation, i.e. an additive functional on edge cochains which
-- kills every vertex coboundary.  Such a functional is gauge invariant and
-- therefore descends to the generated quotient of C1 by C0 gauge moves.
------------------------------------------------------------------------

module NaturalMachine.FiniteGraphCohomology where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; _⊕_ ; ⊕-identityʳ ; isSetBool)
open import Cubical.Data.Sigma using (Σ-syntax)
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/)

module Graph
  (Vertex Edge : Type₀)
  (source target : Edge → Vertex)
  where

  C⁰ C¹ : Type₀
  C⁰ = Vertex → Bool
  C¹ = Edge → Bool

  δ⁰ : C⁰ → C¹
  δ⁰ gauge edge = gauge (source edge) ⊕ gauge (target edge)

  _+¹_ : C¹ → C¹ → C¹
  (x +¹ y) edge = x edge ⊕ y edge

  gaugeTranslate : C¹ → C⁰ → C¹
  gaugeTranslate signs gauge = signs +¹ δ⁰ gauge

  -- This is the algebraic content of an F2 cycle pairing.  Concrete finite
  -- graphs may construct it from a closed edge walk, a cycle vector, or any
  -- equivalent checked presentation.
  record CycleEvaluation : Type₀ where
    field
      evaluate : C¹ → Bool
      additive : (x y : C¹)
        → evaluate (x +¹ y) ≡ evaluate x ⊕ evaluate y
      closed : (gauge : C⁰) → evaluate (δ⁰ gauge) ≡ false

  open CycleEvaluation public

  gaugeInvariant : (cycle : CycleEvaluation) (signs : C¹) (gauge : C⁰)
    → evaluate cycle (gaugeTranslate signs gauge) ≡ evaluate cycle signs
  gaugeInvariant cycle signs gauge =
    additive cycle signs (δ⁰ gauge)
    ∙ cong (λ z → evaluate cycle signs ⊕ z) (closed cycle gauge)
    ∙ ⊕-identityʳ (evaluate cycle signs)

  GaugeStep : C¹ → C¹ → Type₀
  GaugeStep x y =
    Σ[ gauge ∈ C⁰ ]
      ((edge : Edge) → gaugeTranslate x gauge edge ≡ y edge)

  H¹ : Type₀
  H¹ = C¹ / GaugeStep

  classOf : C¹ → H¹
  classOf = [_]

  descendedEvaluation : CycleEvaluation → H¹ → Bool
  descendedEvaluation cycle =
    SQ.rec isSetBool (evaluate cycle) respectsGauge
    where
    respectsGauge : (x y : C¹) → GaugeStep x y
      → evaluate cycle x ≡ evaluate cycle y
    respectsGauge x y (gauge , equality) =
      sym (gaugeInvariant cycle x gauge)
      ∙ cong (evaluate cycle) (funExt equality)

  gaugePath : (signs : C¹) (gauge : C⁰)
    → classOf signs ≡ classOf (gaugeTranslate signs gauge)
  gaugePath signs gauge =
    eq/ signs (gaugeTranslate signs gauge)
      (gauge , λ _ → refl)

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked generically: C0 acts on C1 by endpoint coboundaries; every additive
-- cycle evaluation killing coboundaries is invariant and descends to H1.
-- Not claimed: enumeration of cycles, exactness at further chain degrees, or
-- a computation of the whole quotient for an arbitrary graph.
------------------------------------------------------------------------
