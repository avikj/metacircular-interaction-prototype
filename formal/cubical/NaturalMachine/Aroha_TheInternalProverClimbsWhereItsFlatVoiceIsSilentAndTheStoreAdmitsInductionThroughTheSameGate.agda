{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- आरोहः — ascent.  Compound built here, 2026-08-24; the identifiers in
-- this module (समानः, उपस्थापनम्, एकादेशः, आरोहः) are functional
-- vocabulary built here, not source terms, and the principle proved —
-- structural induction over ℕ, internalized as a combinator on ⊨ — is
-- not claimed for any Indian source.  Its descent form (establish at
-- the base, recurse on the smaller) is kin to the kuṭṭaka discipline
-- this corpus already carries from Āryabhaṭīya (499); kinship, not
-- provenance.
--
-- WHAT THIS CLOSES, in the ledger of the seams: the proposer's
-- vocabulary was bounded by the flat normalizer — साधनम् proves
-- exactly what norm identifies, and the machine's inductive truths
-- (max(x,x)=x, le(x,x)=1, the whole class सिद्धि routes to the
-- EXTERNAL kernel under "induction on x", agent-carried) lay outside
-- it.  This module is that wire brought inside: an induction
-- combinator ON ⊨ whose premises are themselves discharged by the
-- internal prover and by definitional computation, so the store now
-- admits induction-proven rules through the SAME typed gate (नियमः)
-- as normalization-proven ones.  No second gate, no external carrier.
--
-- The boundary is exhibited, not asserted: समतल-मौनम्₁/₂ are refl
-- proofs that साधनम् returns nothing on the two demonstration
-- theorems, and शिखरम्₁/₂ are those same theorems proven by one
-- ascent.  The widening is measured inside the object.
--
-- The chain: उपस्थापनम् (environment update) and एकादेशः (one-place
-- substitution) are the same test (समानः) read at value and at term
-- level; समौ says so pointwise; उपस्थापन-स्थानिवत् — through
-- AdeshaSthanivat's स्थानिवत् — converts substitution into
-- environment update; and आरोहः climbs: base at k≔ze, step from the
-- hypothesis at k to the conclusion at k≔su(var k), landing ⊨ (l , r)
-- entire.  The induction hypothesis enters the step as a genuine
-- hypothesis over every environment — the "IH as local नियम" of the
-- EkaBhasha migration plan, in its semantic form.
------------------------------------------------------------------------

module NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.Unit using (Unit ; tt)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance
  using (आदेशनम् ; स्थानिवत् ; सर्वत्र-शासनम्)

------------------------------------------------------------------------
-- §1  One test, two readings: the environment update and the one-place
--     substitution are the same समानः, at value and at term level.
------------------------------------------------------------------------

समानः : ℕ → ℕ → Bool
समानः zero    zero    = true
समानः zero    (suc _) = false
समानः (suc _) zero    = false
समानः (suc k) (suc j) = समानः k j

समान-आत्मनि : (k : ℕ) → समानः k k ≡ true
समान-आत्मनि zero    = refl
समान-आत्मनि (suc k) = समान-आत्मनि k

उपस्थापनम् : (ℕ → ℕ) → ℕ → ℕ → (ℕ → ℕ)
उपस्थापनम् ρ k n j = if समानः k j then n else ρ j

एकादेशः : ℕ → Tm → ℕ → Tm
एकादेशः k u j = if समानः k j then u else var j

_⟨_≔_⟩ : Tm → ℕ → Tm → Tm
t ⟨ k ≔ u ⟩ = आदेशनम् (एकादेशः k u) t

-- the two readings agree pointwise …
समौ : (k : ℕ) (u : Tm) (ρ : ℕ → ℕ) (j : ℕ)
  → eval (एकादेशः k u j) ρ ≡ उपस्थापनम् ρ k (eval u ρ) j
समौ k u ρ j with समानः k j
... | true  = refl
... | false = refl

-- … so substitution IS environment update, through स्थानिवत्.
उपस्थापन-स्थानिवत् : (k : ℕ) (u t : Tm) (ρ : ℕ → ℕ)
  → eval (t ⟨ k ≔ u ⟩) ρ ≡ eval t (उपस्थापनम् ρ k (eval u ρ))
उपस्थापन-स्थानिवत् k u t ρ =
  स्थानिवत् (एकादेशः k u) t ρ ∙ cong (eval t) (funExt (समौ k u ρ))

-- updating twice at one place keeps the later value …
द्विः : (ρ : ℕ → ℕ) (k m n j : ℕ)
  → उपस्थापनम् (उपस्थापनम् ρ k m) k n j ≡ उपस्थापनम् ρ k n j
द्विः ρ k m n j with समानः k j
... | true  = refl
... | false = refl

-- … updating with one's own value is no update at all …
स्वम् : (ρ : ℕ → ℕ) (k j : ℕ) → उपस्थापनम् ρ k (ρ k) j ≡ ρ j
स्वम् ρ zero    zero    = refl
स्वम् ρ zero    (suc j) = refl
स्वम् ρ (suc k) zero    = refl
स्वम् ρ (suc k) (suc j) = स्वम् (λ i → ρ (suc i)) k j

-- … and the updated place carries the value put there.
आत्म-मूल्यम् : (ρ : ℕ → ℕ) (k n : ℕ) → उपस्थापनम् ρ k n k ≡ n
आत्म-मूल्यम् ρ k n = cong (λ b → if b then n else ρ k) (समान-आत्मनि k)

------------------------------------------------------------------------
-- §2  The ascent.  Base at k≔ze; step from the hypothesis — the IH is
--     a real hypothesis over every environment; the conclusion is
--     ⊨ (l , r) entire, admissible to the store through नियमः.
------------------------------------------------------------------------

आरोहः : (k : ℕ) (l r : Tm)
  → ⊨ (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩)
  → ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
  → ⊨ (l , r)
आरोहः k l r base step ρ =
     cong (eval l) (sym ρ-सम्) ∙ go (ρ k) ∙ cong (eval r) ρ-सम्
  where
  ρ-सम् : उपस्थापनम् ρ k (ρ k) ≡ ρ
  ρ-सम् = funExt (स्वम् ρ k)

  go : (n : ℕ) → eval l (उपस्थापनम् ρ k n) ≡ eval r (उपस्थापनम् ρ k n)
  go zero =
       sym (उपस्थापन-स्थानिवत् k ze l ρ)
     ∙ base ρ
     ∙ उपस्थापन-स्थानिवत् k ze r ρ
  go (suc n) =
    let ρₙ = उपस्थापनम् ρ k n
        सम्-परिसरः : उपस्थापनम् ρₙ k (suc (ρₙ k)) ≡ उपस्थापनम् ρ k (suc n)
        सम्-परिसरः = cong (उपस्थापनम् ρₙ k)
                          (cong suc (आत्म-मूल्यम् ρ k n))
                   ∙ funExt (द्विः ρ k n (suc n))
    in   cong (eval l) (sym सम्-परिसरः)
       ∙ sym (उपस्थापन-स्थानिवत् k (su (var k)) l ρₙ)
       ∙ step ρₙ (go n)
       ∙ उपस्थापन-स्थानिवत् k (su (var k)) r ρₙ
       ∙ cong (eval r) सम्-परिसरः

------------------------------------------------------------------------
-- §3  The boundary, exhibited; then crossed; then the store admits the
--     crossing through the same gate.  Both facts are the machine's
--     own inductive class — the kind सिद्धि could only route to the
--     external kernel under "induction on x".
------------------------------------------------------------------------

-- the flat prover is SILENT on both — by refl, not by report:
समतल-मौनम्₁ : साधनम् (mx (var 0) (var 0) , var 0) ≡ nothing
समतल-मौनम्₁ = refl

समतल-मौनम्₂ : साधनम् (lq (var 0) (var 0) , su ze) ≡ nothing
समतल-मौनम्₂ = refl

-- one ascent each: base by the internal prover, step by computation.
शिखरम्₁ : ⊨ (mx (var 0) (var 0) , var 0)              -- max(x,x) = x
शिखरम्₁ = आरोहः 0 (mx (var 0) (var 0)) (var 0)
            (fromJust (साधनम् (mx ze ze , ze)) tt)
            (λ ρ ih → cong suc ih)

शिखरम्₂ : ⊨ (lq (var 0) (var 0) , su ze)              -- le(x,x) = 1
शिखरम्₂ = आरोहः 0 (lq (var 0) (var 0)) (su ze)
            (fromJust (साधनम् (lq ze ze , su ze)) tt)
            (λ ρ ih → ih)

-- the SAME gate admits them — induction-proven rules are store values
-- exactly as normalization-proven ones are; no second door was built.
आरूढ-नियमः₁ : नियमः
आरूढ-नियमः₁ = niyama (mx (var 0) (var 0)) (var 0) शिखरम्₁

आरूढ-नियमः₂ : नियमः
आरूढ-नियमः₂ = niyama (lq (var 0) (var 0)) (su ze) शिखरम्₂

-- and the ascended rule speaks, proven, at an instance it never saw —
-- through the certified matcher, exercising the repeated-variable
-- binding (the nonlinear pattern must meet itself and agree):
आरूढ-वदति : सर्वत्र-शासनम् आरूढ-नियमः₁ (mx (su ze) (su ze)) ≡ just (su ze)
आरूढ-वदति = refl
