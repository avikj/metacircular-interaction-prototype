{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SymmetryArithmeticAction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)

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

identity-fixed-value : actObservation (idEquiv ℕ) successorRegister zero ≡ 1
identity-fixed-value = refl

swap-fixed-value : actObservation swap01-Equiv successorRegister zero ≡ 2
swap-fixed-value = refl

swap-transported-value : transportObservation swap01-Equiv
                                              successorRegister zero ≡ 1
swap-transported-value =
  transportObservation-invariant swap01-Equiv successorRegister zero
