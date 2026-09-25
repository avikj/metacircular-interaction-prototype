{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
--  —  ,    
--
-- (the fiber was written; it was the census that could not see.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE QUEUE.
--
-- `interactive/Lopa_…hs` grades 1046 one-way edges in this corpus UNDECIDED:
-- no syntactic rule names a fiber.  But a fiber WRITTEN OUT is a Σ ending
-- in an equation into the index —
--
--     Fib n = Σ[ w ∈ Word ] (value w ≡ n)
--
-- — and 46 such definitions already exist in `formal/cubical` and
-- `fiber/src`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED.  Nothing is constructed; all four are `refl`.
--
--   `fiber f b` unfolds to `Σ[ a ] (f a ≡ b)`.  Where the written type
--   is literally that Σ for a map the census is holding, the two types
--   are equal on the nose and the identification costs one line.
--
-- §१  chargeOneFiber  ≡  fiber chargeOneProjector true   (queued edge)
-- §२  Fib n           ≡  fiber value n                   (queued edge)
-- §३  EvenQuery       ≡  fiber (sgn ∘ Ω) true            (COMPOSITE of
--     two queued edges, `Number ⟶ ℕ « Ω` and `ℕ ⟶ Bool « sgn`; the
--     composite is not itself a queue entry:
--     the queue does not contain the map
--     this fiber belongs to — it contains its two halves.)
-- §४  ThreeKernel     ≡  fiber triple (pos 0)            (NOT IN THE
--     QUEUE AT ALL, see below.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO EDGES THE CENSUS NEVER SAW.
--
-- `triple : ℤ → ℤ` (`S3IntegerRelativeCoordinates.agda:83`) and
-- `मात्रा : रूप → ℕ` (`fiber/src/…/Prastara_….agda:157`) are
-- top-level, total, non-injective maps whose fibers are written 12 and
-- 95 lines below them respectively.  NEITHER APPEARS among the 1046.
-- So the queue's number is not an upper bound on the corpus's one-way
-- edges.
--
------------------------------------------------------------------------

module TheFourWrittenFibersWereAlreadyTheQueuesOwnMapsAndTwoEdgesTheCensusNeverSaw where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Int using (ℤ ; pos)

open import ChenTwoChargeProjector using (Charge ; chargeOneProjector ; chargeOneFiber)
open import CarryFiber using (Word ; value ; Fib)
open import ParitySeparator using (Number ; Ω ; sgn)
open import OracleSeparation using (EvenQuery)
open import S3IntegerRelativeCoordinates using (triple ; ThreeKernel)

------------------------------------------------------------------------
-- द.  WHAT THESE SHAPES ARE NOT.
--
--   (i)  a NEGATED equation is not a fiber.  `fiber f b` is
--        `Σ[ a ] (f a ≡ b)`; `Σ[ a ] ¬ (f a ≡ b)` is its complement and
--        is a fiber of nothing.
--          · LawfulContinuationCore.AdmissibleModulus  (Σ[ q ∈ ℕ ] ¬ (L mod q ≡ zero))
--          · LawfulContinuationCore.BranchingFiber     (Σ left Σ right ¬ left ≡ right)
--          · OracleSeparation.Charged                  (Σ[ σ ∈ Signs ] ¬ (P σ ≡ P (flip σ)))
--        The middle one is named "…Fiber" and is not one; the name was
--        the whole of its evidence.
--
--   (ii) a FIXED-POINT type is not a fiber.  `Σ[ a ] (g a ≡ a)` is the
--        equalizer of g and the identity: the index varies with the
--        point, so there is no b for `fiber g b` to be taken over.
--          · RelationalTensorObstructionBridge.LoopStable  (Σ[ phase ∈ Bool ] subst … loop phase ≡ phase)
--          · S3ConjugacyObservation.Fixed                  (Σ[ x ∈ Fin3 ] g .fst x ≡ x)
--
--   (iii) right shape, WRONG MAP.  PingalaPrastara's `लघु-सङ्ख्या` counts
--        laghus; `Metre`'s equation is over `matraOf`, which sums morae.
--        Same two types, different map, no identification.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- १.  Charge ⟶ Bool « chargeOneProjector      (queue entry)
------------------------------------------------------------------------

chargeOneFiber-is-fiber : chargeOneFiber ≡ fiber chargeOneProjector true
chargeOneFiber-is-fiber = refl

------------------------------------------------------------------------
-- २.  Word ⟶ ℕ « value                        (queue entry)
--
-- This is the edge whose fiber the host module already proved is NOT of
-- constant cardinality — `Fib 1` contractible, `Fib 2` two points — so
-- the receipt for this lossy map is a named type that is provably not a
-- torsor.  Naming it as a fiber is what lets that statement be about the
-- map rather than about a coincidence of definitions.
------------------------------------------------------------------------

Fib-is-fiber : (n : ℕ) → Fib n ≡ fiber value n
Fib-is-fiber _ = refl

------------------------------------------------------------------------
-- ३.  Number ⟶ ℕ « Ω  then  ℕ ⟶ Bool « sgn    (two queue entries)
--
-- The queue holds the two halves; the written fiber belongs to the
-- composite.  A fiber of a composite is not a fiber of either factor,
-- and the identification below is therefore about a map the census is
-- not holding — which is a statement about the census's granularity.
------------------------------------------------------------------------

sgnΩ : Number → Bool
sgnΩ n = sgn (Ω n)

EvenQuery-is-fiber : EvenQuery ≡ fiber sgnΩ true
EvenQuery-is-fiber = refl

------------------------------------------------------------------------
-- ४.  ℤ ⟶ ℤ « triple                          (NOT a queue entry)
------------------------------------------------------------------------

ThreeKernel-is-fiber : ThreeKernel ≡ fiber triple (pos 0)
ThreeKernel-is-fiber = refl
