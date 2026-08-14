{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PMGaugeCohomology
--
-- The finite Cech/H1 carrier behind the Peres--Mermin incidence twist.
-- Edge signs are identified under context (vertex) gauge.  Cycle parity
-- descends to the quotient, so locating the odd sign on ZZ is only a choice
-- of representative: every gauge translate has the same checked odd class.
------------------------------------------------------------------------

module NaturalMachine.PMGaugeCohomology where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; _⊕_ ; ⊕-assoc ; ⊕-comm ; isSetBool)
open import Cubical.Data.Sigma using (Σ-syntax)
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/ ; squash/)

import NaturalMachine.PMTorus as Torus
import NaturalMachine.PMCokernel as PM
import NaturalMachine.PauliWeyl as Weyl
import NaturalMachine.PMMonodromyDerivationNoGo as NoGo

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
chain-step a b c =
  sym (⊕-assoc (a ⊕ b) b c)
  ∙ cong (_⊕ c) (Torus.⊕-cancel a b)

closed-six : (a b c d e f : Bool)
  → Torus.sum3 (a ⊕ b) (c ⊕ b) (c ⊕ d)
      ⊕ Torus.sum3 (e ⊕ d) (e ⊕ f) (a ⊕ f)
    ≡ false
closed-six a b c d e f =
  -- First reassociate the two triples into one left-associated walk.
  sym (⊕-assoc (Torus.sum3 (a ⊕ b) (c ⊕ b) (c ⊕ d))
               ((e ⊕ d) ⊕ (e ⊕ f)) (a ⊕ f))
  ∙ cong (_⊕ (a ⊕ f))
      (sym (⊕-assoc (Torus.sum3 (a ⊕ b) (c ⊕ b) (c ⊕ d))
                    (e ⊕ d) (e ⊕ f)))
  -- Orient the three backwards-traversed incidence edges.
  ∙ cong (λ z → (((((a ⊕ b) ⊕ z) ⊕ (c ⊕ d)) ⊕ (e ⊕ d))
                    ⊕ (e ⊕ f)) ⊕ (a ⊕ f)) (⊕-comm c b)
  ∙ cong (λ z → ((((z ⊕ (c ⊕ d)) ⊕ (e ⊕ d)) ⊕ (e ⊕ f))
                    ⊕ (a ⊕ f))) (chain-step a b c)
  ∙ cong (λ z → (((z ⊕ (e ⊕ d)) ⊕ (e ⊕ f)) ⊕ (a ⊕ f)))
      (chain-step a c d)
  ∙ cong (λ z → (((a ⊕ d) ⊕ z) ⊕ (e ⊕ f)) ⊕ (a ⊕ f))
      (⊕-comm e d)
  ∙ cong (λ z → (z ⊕ (e ⊕ f)) ⊕ (a ⊕ f)) (chain-step a d e)
  ∙ cong (_⊕ (a ⊕ f)) (chain-step a e f)
  ∙ cong ((a ⊕ f) ⊕_) (⊕-comm a f)
  ∙ chain-step a f a
  ∙ Torus.⊕-self a

gauge-cycle-zero : (gauge : ContextGauge) → cycleParity (δ₀ gauge) ≡ false
gauge-cycle-zero gauge =
  closed-six (gauge Torus.R0) (gauge Torus.C0)
             (gauge Torus.R1) (gauge Torus.C1)
             (gauge Torus.R2) (gauge Torus.C2)

cycle-gauge-invariant : (signs : EdgeSign) (gauge : ContextGauge)
  → cycleParity (signs ⋆ gauge) ≡ cycleParity signs
cycle-gauge-invariant signs gauge =
  cycle-additive signs (δ₀ gauge)
  ∙ cong (cycleParity signs ⊕_) (gauge-cycle-zero gauge)

------------------------------------------------------------------------
-- Gauge quotient and its descended invariant
------------------------------------------------------------------------

GaugeStep : EdgeSign → EdgeSign → Type₀
GaugeStep x y =
  Σ[ gauge ∈ ContextGauge ] ((observable : Torus.Obs) → (x ⋆ gauge) observable ≡ y observable)

H¹PM : Type₀
H¹PM = EdgeSign / GaugeStep

cycleClass : H¹PM → Bool
cycleClass = SQ.rec isSetBool cycleParity respectsGauge
  where
  respectsGauge : (x y : EdgeSign) → GaugeStep x y → cycleParity x ≡ cycleParity y
  respectsGauge x y (gauge , equality) =
    sym (cycle-gauge-invariant x gauge)
    ∙ cong cycleParity (funExt equality)

gauge-path : (signs : EdgeSign) (gauge : ContextGauge)
  → [ signs ] ≡ [ signs ⋆ gauge ]
gauge-path signs gauge = eq/ _ _ (gauge , λ _ → refl)

zz-class-is-odd : cycleClass [ NoGo.zzRepresentative ] ≡ true
zz-class-is-odd = refl

every-zz-gauge-translate-is-odd : (gauge : ContextGauge)
  → cycleClass [ NoGo.zzRepresentative ⋆ gauge ] ≡ true
every-zz-gauge-translate-is-odd gauge =
  sym (cong cycleClass (gauge-path NoGo.zzRepresentative gauge))
  ∙ zz-class-is-odd

-- The quotient invariant is exactly the PauliWeyl-derived PM total sign.
zz-class-is-derived-total :
  cycleClass [ NoGo.zzRepresentative ] ≡ PM.total Weyl.derived-s
zz-class-is-derived-total =
  zz-class-is-odd ∙ sym NoGo.derived-total-is-odd

every-gauge-translate-is-derived-total : (gauge : ContextGauge)
  → cycleClass [ NoGo.zzRepresentative ⋆ gauge ] ≡ PM.total Weyl.derived-s
every-gauge-translate-is-derived-total gauge =
  every-zz-gauge-translate-is-odd gauge
  ∙ sym NoGo.derived-total-is-odd

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
