{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AdditionChainPredictiveMemory
--
-- Exact adapter for the two addition-chain histories isolated in
--
--   A : 1 -> 2 -> 3 -> 6, with persistent cache {1,2,3,6}
--   B : 1 -> 2 -> 4 -> 6, with persistent cache {1,2,4,6}.
--
-- The declared future interface asks only whether 3 or 4 remains available.
-- Its complete response table is one Bool: A answers (true,false), while B
-- answers (false,true).  Both histories have the same terminal value.
--
-- This module compiles that collision into FiniteInformation.FactorsThrough:
-- the endpoint cannot predict either separating response or the cache bit,
-- while endpoint plus that bit predicts the whole declared table.  Explicit
-- garbage collection changes the target to a constant table, which does
-- factor through the endpoint.
--
-- The result is a finite deterministic classical process statement.  The
-- chain arithmetic and persistence convention are source hypotheses encoded
-- by the displayed histories and response table; no chain optimality,
-- process-tensor, quantum, thermodynamic, or physical claim is made here.
------------------------------------------------------------------------

module AdditionChainPredictiveMemory where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; not ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import FiniteInformation as FI
import TranscriptDescent as TD

------------------------------------------------------------------------
-- 1. The exact two-history future table
------------------------------------------------------------------------

data ChainHistory : Type₀ where
  chain1236 chain1246 : ChainHistory

data Probe : Type₀ where
  has3 has4 : Probe

-- Both displayed constructions terminate at the same arithmetic endpoint.
-- Unit is the realized one-point endpoint carrier; the name 6 is retained in
-- the history constructors and the source statement above.
terminal : ChainHistory → Unit
terminal _ = tt

-- One predictive bit labels exactly which persistent cache was formed.
cacheBit : ChainHistory → Bool
cacheBit chain1236 = true
cacheBit chain1246 = false

responseFromBit : Bool → Probe → Bool
responseFromBit bit has3 = bit
responseFromBit bit has4 = not bit

persistentResponse : ChainHistory → Probe → Bool
persistentResponse history = responseFromBit (cacheBit history)

chain1236-has3 : persistentResponse chain1236 has3 ≡ true
chain1236-has3 = refl

chain1236-lacks4 : persistentResponse chain1236 has4 ≡ false
chain1236-lacks4 = refl

chain1246-lacks3 : persistentResponse chain1246 has3 ≡ false
chain1246-lacks3 = refl

chain1246-has4 : persistentResponse chain1246 has4 ≡ true
chain1246-has4 = refl

same-terminal : terminal chain1236 ≡ terminal chain1246
same-terminal = refl

has3-separates : ¬ (persistentResponse chain1236 has3
                    ≡ persistentResponse chain1246 has3)
has3-separates = true≢false

has4-separates : ¬ (persistentResponse chain1236 has4
                    ≡ persistentResponse chain1246 has4)
has4-separates equality = true≢false (sym equality)

------------------------------------------------------------------------
-- 2. The endpoint-compression obstruction
------------------------------------------------------------------------

-- The exact collision feeds the repository's generic descent obstruction.
-- No decoder on the realized endpoint image can answer either probe.
terminal-cannot-predict-has3 :
  ¬ FI.FactorsThrough terminal (λ history → persistentResponse history has3)
terminal-cannot-predict-has3 =
  TD.collisionObstructsDecoder
    terminal (λ history → persistentResponse history has3)
    same-terminal has3-separates

terminal-cannot-predict-has4 :
  ¬ FI.FactorsThrough terminal (λ history → persistentResponse history has4)
terminal-cannot-predict-has4 =
  TD.collisionObstructsDecoder
    terminal (λ history → persistentResponse history has4)
    same-terminal has4-separates

-- This is the exact missing direction in TerminalTraceCompression: the
-- terminal record is determined by the predictive bit, but the bit is not
-- determined by the terminal record.
terminal-through-cacheBit : FI.FactorsThrough cacheBit terminal
terminal-through-cacheBit = (λ _ → tt) , (λ _ → refl)

terminal-cannot-recover-cacheBit : ¬ FI.FactorsThrough terminal cacheBit
terminal-cannot-recover-cacheBit =
  TD.collisionObstructsDecoder terminal cacheBit
    same-terminal true≢false

------------------------------------------------------------------------
-- 3. Exact repair: retain one predictive cache bit
------------------------------------------------------------------------

terminalAndCacheBit : ChainHistory → Unit × Bool
terminalAndCacheBit history = terminal history , cacheBit history

-- The retained bit reconstructs the complete declared future table.  Replay
-- is pointwise definitional; `funExt` packages the two probe computations as
-- equality of response functions.
persistent-through-terminal-and-cacheBit :
  FI.FactorsThrough terminalAndCacheBit persistentResponse
persistent-through-terminal-and-cacheBit =
  (λ output → responseFromBit (snd (fst output))) ,
  (λ history → funExt (λ probe → refl))

------------------------------------------------------------------------
-- 4. Persistence boundary: explicit garbage collection changes the target
------------------------------------------------------------------------

-- Under the garbage-collected semantics both histories retain only endpoint
-- 6, so neither old intermediate is available.  This is a new target, not a
-- proof that the persistent target was endpoint-determined.
garbageCollectedResponse : ChainHistory → Probe → Bool
garbageCollectedResponse _ _ = false

garbage-collected-through-terminal :
  FI.FactorsThrough terminal garbageCollectedResponse
garbage-collected-through-terminal =
  (λ _ _ → false) ,
  (λ history → funExt (λ probe → refl))

