{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PMGaugeCohomology
--
-- The finite Cech/H1 carrier behind the Peres--Mermin incidence twist.
-- Edge signs are identified under context (vertex) gauge.  Cycle parity
-- descends to the quotient, so locating the odd sign on ZZ is only a choice
-- of representative: every gauge translate has the same checked odd class.
------------------------------------------------------------------------

module PMGaugeCohomology where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; _⊕_ ; ⊕-assoc ; ⊕-comm ; ⊕-identityʳ ; isSetBool)
open import Cubical.Data.Sigma using (Σ-syntax)
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/ ; squash/)

import PMTorus as Torus
import PMCokernel as PM
import PauliWeyl as Weyl
import PMMonodromyDerivationNoGo as NoGo
import FiniteGraphCohomology as Generic

pmSource pmTarget : Torus.Obs → Torus.Ctx
pmSource observable = fst (Torus.pmContexts observable)
pmTarget observable = snd (Torus.pmContexts observable)

module PMGraph = Generic.Graph Torus.Ctx Torus.Obs pmSource pmTarget

EdgeSign : Type₀
EdgeSign = Torus.Obs → Bool

ContextGauge : Type₀
ContextGauge = Torus.Ctx → Bool

-- The Cech coboundary: an overlap sees the sum of its two endpoint gauges.
δ₀ : ContextGauge → EdgeSign
δ₀ gauge observable =
  gauge (fst (Torus.pmContexts observable))
  ⊕ gauge (snd (Torus.pmContexts observable))

_⋆_ : EdgeSign → ContextGauge → EdgeSign
(signs ⋆ gauge) observable = signs observable ⊕ δ₀ gauge observable

-- We group the six terms in two triples.  This is the same F₂ cycle parity
-- as any other parenthesization.
cycleParity : EdgeSign → Bool
cycleParity signs =
  Torus.sum3 (signs Torus.XI) (signs Torus.IY) (signs Torus.YI)
  ⊕ Torus.sum3 (signs Torus.YX) (signs Torus.ZZ) (signs Torus.XX)

cycle-additive : (x y : EdgeSign)
  → cycleParity (λ observable → x observable ⊕ y observable)
  ≡ cycleParity x ⊕ cycleParity y
cycle-additive x y =
  cong₂ _⊕_
    (Torus.sum3-add (x Torus.XI) (x Torus.IY) (x Torus.YI)
                    (y Torus.XI) (y Torus.IY) (y Torus.YI))
    (Torus.sum3-add (x Torus.YX) (x Torus.ZZ) (x Torus.XX)
                    (y Torus.YX) (y Torus.ZZ) (y Torus.XX))
  ∙ Torus.⊕-inter
      (Torus.sum3 (x Torus.XI) (x Torus.IY) (x Torus.YI))
      (Torus.sum3 (y Torus.XI) (y Torus.IY) (y Torus.YI))
      (Torus.sum3 (x Torus.YX) (x Torus.ZZ) (x Torus.XX))
      (Torus.sum3 (y Torus.YX) (y Torus.ZZ) (y Torus.XX))

-- Successively erase the repeated vertices of a closed walk.
chain-step : (a b c : Bool) → (a ⊕ b) ⊕ (b ⊕ c) ≡ a ⊕ c
chain-step false false false = refl
chain-step false false true  = refl
chain-step false true  false = refl
chain-step false true  true  = refl
chain-step true  false false = refl
chain-step true  false true  = refl
chain-step true  true  false = refl
chain-step true  true  true  = refl

closed-six : (a b c d e f : Bool)
  → Torus.sum3 (a ⊕ b) (c ⊕ b) (c ⊕ d)
      ⊕ Torus.sum3 (e ⊕ d) (e ⊕ f) (a ⊕ f)
    ≡ false
closed-six false false false false false false = refl
closed-six false false false false false true  = refl
closed-six false false false false true  false = refl
closed-six false false false false true  true  = refl
closed-six false false false true  false false = refl
closed-six false false false true  false true  = refl
closed-six false false false true  true  false = refl
closed-six false false false true  true  true  = refl
closed-six false false true  false false false = refl
closed-six false false true  false false true  = refl
closed-six false false true  false true  false = refl
closed-six false false true  false true  true  = refl
closed-six false false true  true  false false = refl
closed-six false false true  true  false true  = refl
closed-six false false true  true  true  false = refl
closed-six false false true  true  true  true  = refl
closed-six false true  false false false false = refl
closed-six false true  false false false true  = refl
closed-six false true  false false true  false = refl
closed-six false true  false false true  true  = refl
closed-six false true  false true  false false = refl
closed-six false true  false true  false true  = refl
closed-six false true  false true  true  false = refl
closed-six false true  false true  true  true  = refl
closed-six false true  true  false false false = refl
closed-six false true  true  false false true  = refl
closed-six false true  true  false true  false = refl
closed-six false true  true  false true  true  = refl
closed-six false true  true  true  false false = refl
closed-six false true  true  true  false true  = refl
closed-six false true  true  true  true  false = refl
closed-six false true  true  true  true  true  = refl
closed-six true  false false false false false = refl
closed-six true  false false false false true  = refl
closed-six true  false false false true  false = refl
closed-six true  false false false true  true  = refl
closed-six true  false false true  false false = refl
closed-six true  false false true  false true  = refl
closed-six true  false false true  true  false = refl
closed-six true  false false true  true  true  = refl
closed-six true  false true  false false false = refl
closed-six true  false true  false false true  = refl
closed-six true  false true  false true  false = refl
closed-six true  false true  false true  true  = refl
closed-six true  false true  true  false false = refl
closed-six true  false true  true  false true  = refl
closed-six true  false true  true  true  false = refl
closed-six true  false true  true  true  true  = refl
closed-six true  true  false false false false = refl
closed-six true  true  false false false true  = refl
closed-six true  true  false false true  false = refl
closed-six true  true  false false true  true  = refl
closed-six true  true  false true  false false = refl
closed-six true  true  false true  false true  = refl
closed-six true  true  false true  true  false = refl
closed-six true  true  false true  true  true  = refl
closed-six true  true  true  false false false = refl
closed-six true  true  true  false false true  = refl
closed-six true  true  true  false true  false = refl
closed-six true  true  true  false true  true  = refl
closed-six true  true  true  true  false false = refl
closed-six true  true  true  true  false true  = refl
closed-six true  true  true  true  true  false = refl
closed-six true  true  true  true  true  true  = refl

gauge-cycle-zero : (gauge : ContextGauge) → cycleParity (δ₀ gauge) ≡ false
gauge-cycle-zero gauge =
  closed-six (gauge Torus.R0) (gauge Torus.C0)
             (gauge Torus.R1) (gauge Torus.C1)
             (gauge Torus.R2) (gauge Torus.C2)

-- The named PM cycle is an instance of the generic graph-cochain interface.
pmCycleEvaluation : PMGraph.CycleEvaluation
pmCycleEvaluation = record
  { evaluate = cycleParity
  ; additive = cycle-additive
  ; closed = gauge-cycle-zero
  }

cycle-gauge-invariant : (signs : EdgeSign) (gauge : ContextGauge)
  → cycleParity (signs ⋆ gauge) ≡ cycleParity signs
cycle-gauge-invariant signs gauge =
  cycle-additive signs (δ₀ gauge)
  ∙ cong (λ z → cycleParity signs ⊕ z) (gauge-cycle-zero gauge)
  ∙ ⊕-identityʳ (cycleParity signs)

------------------------------------------------------------------------
-- Gauge quotient and its descended invariant
------------------------------------------------------------------------

GaugeStep : EdgeSign → EdgeSign → Type₀
GaugeStep x y =
  Σ[ gauge ∈ ContextGauge ] ((observable : Torus.Obs) → (x ⋆ gauge) observable ≡ y observable)

H¹PM : Type₀
H¹PM = EdgeSign / GaugeStep

classOf : EdgeSign → H¹PM
classOf = [_]

gauge-witness : (signs : EdgeSign) (gauge : ContextGauge)
  → GaugeStep signs (signs ⋆ gauge)
gauge-witness signs gauge = gauge , λ _ → refl

cycleClass : H¹PM → Bool
cycleClass = SQ.rec isSetBool cycleParity respectsGauge
  where
  respectsGauge : (x y : EdgeSign) → GaugeStep x y → cycleParity x ≡ cycleParity y
  respectsGauge x y (gauge , equality) =
    sym (cycle-gauge-invariant x gauge)
    ∙ cong cycleParity (funExt equality)

gauge-path : (signs : EdgeSign) (gauge : ContextGauge)
  → classOf signs ≡ classOf (signs ⋆ gauge)
gauge-path signs gauge =
  eq/ signs (signs ⋆ gauge)
    (gauge-witness signs gauge)

zz-class-is-odd : cycleClass (classOf NoGo.zzRepresentative) ≡ true
zz-class-is-odd = refl

every-zz-gauge-translate-is-odd : (gauge : ContextGauge)
  → cycleClass (classOf (NoGo.zzRepresentative ⋆ gauge)) ≡ true
every-zz-gauge-translate-is-odd gauge =
  sym (cong cycleClass (gauge-path NoGo.zzRepresentative gauge))
  ∙ zz-class-is-odd

-- The quotient invariant is exactly the PauliWeyl-derived PM total sign.
zz-class-is-derived-total :
  cycleClass (classOf NoGo.zzRepresentative) ≡ PM.total Weyl.derived-s
zz-class-is-derived-total =
  zz-class-is-odd ∙ sym NoGo.derived-total-is-odd

every-gauge-translate-is-derived-total : (gauge : ContextGauge)
  → cycleClass (classOf (NoGo.zzRepresentative ⋆ gauge)) ≡ PM.total Weyl.derived-s
every-gauge-translate-is-derived-total gauge =
  every-zz-gauge-translate-is-odd gauge
  ∙ sym NoGo.derived-total-is-odd

-- Recovery through the generic quotient, rather than the local presentation
-- above: the descended generic evaluation computes the same derived odd sign.
generic-pm-class-is-derived-total :
  PMGraph.descendedEvaluation pmCycleEvaluation
    (PMGraph.classOf NoGo.zzRepresentative)
  ≡ PM.total Weyl.derived-s
generic-pm-class-is-derived-total =
  refl ∙ sym NoGo.derived-total-is-odd

generic-pm-gauge-translate-is-derived-total : (gauge : PMGraph.C⁰)
  → PMGraph.descendedEvaluation pmCycleEvaluation
      (PMGraph.classOf
        (PMGraph.gaugeTranslate NoGo.zzRepresentative gauge))
    ≡ PM.total Weyl.derived-s
generic-pm-gauge-translate-is-derived-total gauge =
  sym (cong (PMGraph.descendedEvaluation pmCycleEvaluation)
        (PMGraph.gaugePath NoGo.zzRepresentative gauge))
  ∙ generic-pm-class-is-derived-total

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: the six-cycle parity kills every vertex coboundary, descends to
-- the generated gauge quotient, and sends the ZZ representative and every
-- gauge translate to the same odd value derived from PauliWeyl.
--
-- Not claimed: a calculation of every H1 class of K3,3, a full valuation
-- sheaf, or a Hilbert-space realization.  H¹PM is exactly the finite quotient
-- needed for this obstruction line; cycleClass is one descended functional.
------------------------------------------------------------------------
