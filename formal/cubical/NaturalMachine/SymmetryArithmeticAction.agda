{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SymmetryArithmeticAction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.PathIsSymmetry
  using (pathToEquiv-∙ ; swap01-Equiv)

-- A permutation acts on a register assignment by precomposition.  This is
-- the action data forgotten by the cardinality equation |Aut(Fin n)| = n!.
permuteRegisters : {n : ℕ} → (Fin n ≃ Fin n) → (Fin n → ℕ) → Fin n → ℕ
permuteRegisters e registers port = registers (equivFun e port)

-- Composition of symmetries is executable composition on registers.
permuteRegisters-comp : {n : ℕ} (e f : Fin n ≃ Fin n)
                      → (registers : Fin n → ℕ)
                      → permuteRegisters (compEquiv e f) registers
                       ≡ permuteRegisters e (permuteRegisters f registers)
permuteRegisters-comp e f registers = refl

-- Cubical loops act through their checked permutation, not through n!.
loopRegisters : {n : ℕ} → (Fin n ≡ Fin n) → (Fin n → ℕ) → Fin n → ℕ
loopRegisters p = permuteRegisters (pathToEquiv p)

-- Path composition is sent to the same executable composition law.
loopRegisters-comp : {n : ℕ} (p q : Fin n ≡ Fin n)
                   → (registers : Fin n → ℕ)
                   → loopRegisters (p ∙ q) registers
                    ≡ loopRegisters p (loopRegisters q registers)
loopRegisters-comp p q registers =
  cong (λ e → permuteRegisters e registers) (pathToEquiv-∙ p q)
  ∙ permuteRegisters-comp (pathToEquiv p) (pathToEquiv q) registers

-- A fixed external port reads the register moved into that named position.
fixedPortRead : {n : ℕ} → (Fin n ≃ Fin n) → (Fin n → ℕ) → Fin n → ℕ
fixedPortRead e registers port = permuteRegisters e registers port

-- A transported port moves oppositely to register precomposition and reads
-- the original register again.  The policy distinction is checked, not prose.
transportedPortRead : {n : ℕ} → (Fin n ≃ Fin n) → (Fin n → ℕ) → Fin n → ℕ
transportedPortRead e registers port =
  permuteRegisters e registers (invEq e port)

transportedPortRead-invariant : {n : ℕ} (e : Fin n ≃ Fin n)
                              → (registers : Fin n → ℕ) (port : Fin n)
                              → transportedPortRead e registers port
                               ≡ registers port
transportedPortRead-invariant e registers port =
  cong registers (secEq e port)

loopFixedPortRead : {n : ℕ} → (Fin n ≡ Fin n) → (Fin n → ℕ) → Fin n → ℕ
loopFixedPortRead p = fixedPortRead (pathToEquiv p)

loopTransportedPortRead : {n : ℕ} → (Fin n ≡ Fin n) → (Fin n → ℕ) → Fin n → ℕ
loopTransportedPortRead p = transportedPortRead (pathToEquiv p)

loopTransportedPortRead-invariant : {n : ℕ} (p : Fin n ≡ Fin n)
                                  → (registers : Fin n → ℕ) (port : Fin n)
                                  → loopTransportedPortRead p registers port
                                   ≡ registers port
loopTransportedPortRead-invariant p =
  transportedPortRead-invariant (pathToEquiv p)

-- Under the transported-port policy the whole loop carrier collapses to one
-- observable behavior. Distinct paths can require distinct actions while
-- still representing the same predictive state for this declared interface.
loopTransportedBehavior-collapse : {n : ℕ} (p q : Fin n ≡ Fin n)
                                  → (registers : Fin n → ℕ)
                                  → loopTransportedPortRead p registers
                                   ≡ loopTransportedPortRead q registers
loopTransportedBehavior-collapse p q registers =
  funExt λ port →
    loopTransportedPortRead-invariant p registers port
    ∙ sym (loopTransportedPortRead-invariant q registers port)

pointwiseProduct : {n : ℕ} → (Fin n → ℕ) → (Fin n → ℕ) → Fin n → ℕ
pointwiseProduct weights registers port = weights port · registers port

-- Moving both fields by the same precomposition merely relabels their
-- pointwise product. A permutation-invariant aggregator then erases the path.
pointwiseProduct-covariant : {n : ℕ} (e : Fin n ≃ Fin n)
                           → (weights registers : Fin n → ℕ)
                           → pointwiseProduct (permuteRegisters e weights)
                                              (permuteRegisters e registers)
                            ≡ permuteRegisters e
                                (pointwiseProduct weights registers)
pointwiseProduct-covariant e weights registers = refl

-- The action law is not inherently finite.  This generic form lets the
-- already-checked swap of 0 and 1 on ℕ supply a fully internal executable
-- witness without a second implementation language.
actObservation : {X : Type₀} → (X ≃ X) → (X → ℕ) → X → ℕ
actObservation e observation x = observation (equivFun e x)

transportObservation : {X : Type₀} → (X ≃ X) → (X → ℕ) → X → ℕ
transportObservation e observation x =
  actObservation e observation (invEq e x)

transportObservation-invariant : {X : Type₀} (e : X ≃ X)
                               → (observation : X → ℕ) (x : X)
                               → transportObservation e observation x
                                ≡ observation x
transportObservation-invariant e observation x =
  cong observation (secEq e x)

successorRegister : ℕ → ℕ
successorRegister n = suc n

-- Worked example, definitional only (`refl` on literals).
identity-fixed-value : actObservation (idEquiv ℕ) successorRegister zero ≡ 1
identity-fixed-value = refl

swap-fixed-value : actObservation swap01-Equiv successorRegister zero ≡ 2
swap-fixed-value = refl

swap-transported-value : transportObservation swap01-Equiv
                                              successorRegister zero ≡ 1
swap-transported-value =
  transportObservation-invariant swap01-Equiv successorRegister zero

-- The observational stabilizer is the exact kernel of a consumer: these are
-- the symmetries it cannot see.  Unlike n!, this predicate retains action.
Stabilizes : {X : Type₀} → (X → ℕ) → (X ≃ X) → Type₀
Stabilizes observation e = actObservation e observation ≡ observation

stabilizes-id : {X : Type₀} (observation : X → ℕ)
              → Stabilizes observation (idEquiv X)
stabilizes-id observation = refl

stabilizes-comp : {X : Type₀} (observation : X → ℕ) (e f : X ≃ X)
                → Stabilizes observation e
                → Stabilizes observation f
                → Stabilizes observation (compEquiv e f)
stabilizes-comp observation e f he hf =
  cong (actObservation e) hf ∙ he

stabilizes-inv : {X : Type₀} (observation : X → ℕ) (e : X ≃ X)
               → Stabilizes observation e
               → Stabilizes observation (invEquiv e)
stabilizes-inv observation e h = funExt λ x →
  sym (funExt⁻ h (invEq e x)) ∙ cong observation (secEq e x)

-- Equality of response functions is the observational quotient relation.
_≈[_]_ : {X : Type₀} → (X ≃ X) → (X → ℕ) → (X ≃ X) → Type₀
e ≈[ observation ] f = actObservation e observation ≡ actObservation f observation

observational-refl : {X : Type₀} (observation : X → ℕ) (e : X ≃ X)
                   → e ≈[ observation ] e
observational-refl observation e = refl

observational-sym : {X : Type₀} (observation : X → ℕ) (e f : X ≃ X)
                  → e ≈[ observation ] f → f ≈[ observation ] e
observational-sym observation e f = sym

observational-trans : {X : Type₀} (observation : X → ℕ) (e f g : X ≃ X)
                    → e ≈[ observation ] f → f ≈[ observation ] g
                    → e ≈[ observation ] g
observational-trans observation e f g p q = p ∙ q

swap-not-in-successor-stabilizer : ¬ Stabilizes successorRegister swap01-Equiv
swap-not-in-successor-stabilizer h = znots (sym (injSuc (funExt⁻ h zero)))
