{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Native specialization of the repository's actual SHA-256 program.
-- Source pin: e1112905e213b7512cf5e52d291132db6d2d75fa
-- STATUS: written from the inspected APIs; NOT typechecked in this session.
-- No new hashing implementation, probabilistic model, or external solver.
-- A header must already be correctly serialized. The caller must obtain the
-- allowed target from the chain's nBits rules; this module does not implement
-- chain validation, compact-target decoding, pool negotiation, or selection
-- of an as-yet-unknown successful candidate.

module BitcoinMiningOnTheWire where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Sha256 using (sha256 ; takeN ; dropN)
open import Sha256OnTheWire using (sha256P)
open import EkaKriya_TheCompletionIsAFoldOverCodeOneInductionRunsTheProgramKeepsTheTraceProjectsTheVisibleAndBuildsTheInverse
  using (Prog ; prim ; _⨾_ ; ⟦_⟧ ; Trace ; T⟦_⟧ ; R⟦_⟧ ; दृश्यम् ; हरणम्)

Bits : Type₀
Bits = List Bool

record Header80 : Type₀ where
  constructor header80
  field
    serialized : Bits
    exactly80Bytes : length serialized ≡ 640
open Header80 public

record Target256 : Type₀ where
  constructor target256
  field
    -- Bits ordered from the most significant numeric bit to the least.
    numericBE : Bits
    exactly256Bits : length numericBE ≡ 256
open Target256 public

-- SHA returns a byte stream in digest order, with each byte MSB first.
-- Bitcoin's numerical uint256 interpretation makes the LAST digest byte
-- most significant. Reverse BYTE order, NOT bit order within each byte.
-- n is the exact byte count for well-formed inputs (32 below).
reverseBytes : ℕ → Bits → Bits
reverseBytes zero    bs = []
reverseBytes (suc n) bs =
  reverseBytes n (dropN 8 bs) ++ takeN 8 bs

-- Lexicographic <= is numeric <= on equal-width MSB-first bit strings.
-- The empty/nonempty clauses make the helper total; the public operands
-- are both 256 bits by Target256 and the existing SHA length theorem.
leBE : Bits → Bits → Bool
leBE []           _            = true
leBE (_ ∷ _)      []           = false
leBE (false ∷ x)  (true ∷ y)   = true
leBE (true ∷ x)   (false ∷ y)  = false
leBE (false ∷ x)  (false ∷ y)  = leBE x y
leBE (true ∷ x)   (true ∷ y)   = leBE x y

underTarget : Target256 → Bits → Bool
underTarget target digest =
  leBE (reverseBytes 32 digest) (numericBE target)

-- The actual two applications, as code in the existing calculus.
sha256dP : Prog Bits Bits
sha256dP = sha256P ⨾ sha256P

miningP : Target256 → Prog Bits Bool
miningP target = sha256dP ⨾ prim (underTarget target)

-- Definitional identification with the specified bit-level predicate.
mining-agreement : (target : Target256) (bs : Bits)
  → ⟦ miningP target ⟧ bs
    ≡ underTarget target (sha256 (sha256 bs))
mining-agreement target bs = refl

Receipt : Target256 → Type₀
Receipt target = Bool × Trace (miningP target)

inspectHeader : (target : Target256) → Header80 → Receipt target
inspectHeader target h = T⟦ miningP target ⟧ (serialized h)

inspect-is-predicate : (target : Target256) (h : Header80)
  → fst (inspectHeader target h)
    ≡ underTarget target (sha256 (sha256 (serialized h)))
inspect-is-predicate target h =
  दृश्यम् (miningP target) (serialized h)
  ∙ mining-agreement target (serialized h)

receipt-retains-header : (target : Target256) (h : Header80)
  → R⟦ miningP target ⟧ (inspectHeader target h) ≡ serialized h
receipt-retains-header target h =
  हरणम् (miningP target) (serialized h)

-- A successful result includes the original legal-width header, not just
-- a truncated existence proposition. Non-PoW block validity remains the
-- supplying job's obligation.
record Hit (target : Target256) : Type₀ where
  constructor hit
  field
    winningHeader : Header80
    meetsTarget :
      underTarget target (sha256 (sha256 (serialized winningHeader))) ≡ true

receipt-to-hit : (target : Target256) (h : Header80)
  → fst (inspectHeader target h) ≡ true → Hit target
receipt-to-hit target h accepted =
  hit h (sym (inspect-is-predicate target h) ∙ accepted)
