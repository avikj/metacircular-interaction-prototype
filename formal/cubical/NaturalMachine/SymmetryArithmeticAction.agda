{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SymmetryArithmeticAction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)

open import NaturalMachine.PathIsSymmetry using (pathToEquiv-∙)

-- A permutation acts on a register assignment by precomposition.  This is
-- the action data forgotten by the cardinality equation |Aut(Fin n)| = n!.
permuteRegisters : {n : ℕ} → (Fin n ≃ Fin n) → (Fin n → ℕ) → Fin n → ℕ
permuteRegisters e registers port = registers (equivFun e port)

-- Composition of symmetries is executable composition on registers.
permuteRegisters-comp : {n : ℕ} (e f : Fin n ≃ Fin n)
                      → (registers : Fin n → ℕ)
                      → permuteRegisters (compEquiv e f) registers
                       ≡ permuteRegisters f (permuteRegisters e registers)
permuteRegisters-comp e f registers = refl

-- Cubical loops act through their checked permutation, not through n!.
loopRegisters : {n : ℕ} → (Fin n ≡ Fin n) → (Fin n → ℕ) → Fin n → ℕ
loopRegisters p = permuteRegisters (pathToEquiv p)

-- Path composition is sent to the same executable composition law.
loopRegisters-comp : {n : ℕ} (p q : Fin n ≡ Fin n)
                   → (registers : Fin n → ℕ)
                   → loopRegisters (p ∙ q) registers
                    ≡ loopRegisters q (loopRegisters p registers)
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
