-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तन्तुसन्धि — तन्तुः लिखितः, गणना तु अन्धा ।
--
-- (the fibre was written; it was the census that could not see.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE METHOD, and its false-positive rate, which is the point.
--
-- `machine/Lopa_…hs` grades 1046 one-way edges in this corpus UNDECIDED:
-- no syntactic rule names a fibre.  But a fibre WRITTEN OUT is a Σ ending
-- in an equation into the index —
--
--     Fib n = Σ[ w ∈ Word ] (value w ≡ n)
--
-- — and 46 such definitions already exist in `formal/cubical` and
-- `punaragamana/src`.  Joining their SOURCE TYPES against the queue's
-- gives leads.  A source-type match is a LEAD AND NOT A VERDICT: eleven
-- leads were examined and SIX DIED on inspection.  They are listed by
-- name in §० below, because a method's false-positive rate is what
-- decides whether to run it on the other 238 source types, and a report
-- that prints only its hits has measured nothing.
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
--     composite is not itself a queue entry, and this is stated rather
--     than smoothed over, because the queue does not contain the map
--     this fibre belongs to — it contains its two halves.)
-- §४  ThreeKernel     ≡  fiber triple (pos 0)            (NOT IN THE
--     QUEUE AT ALL, see below.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO EDGES THE CENSUS NEVER SAW, which is the finding.
--
-- `triple : ℤ → ℤ` (`S3IntegerRelativeCoordinates.agda:83`) and
-- `मात्रा : रूप → ℕ` (`punaragamana/src/…/Prastara_….agda:157`) are
-- top-level, total, non-injective maps whose fibres are written 12 and
-- 95 lines below them respectively.  NEITHER APPEARS among the 1046.
-- So the queue's number is not an upper bound on the corpus's one-way
-- edges and was being read as one.  The reason the parse drops them is
-- not established here and is left open rather than guessed; a verdict
-- guessed is worse than a verdict withheld, which is the census's own
-- standing line about itself.
--
-- The मात्रा closure is NOT carried in this module: `Punaragamana.…` is a
-- separate library root and importing it here would change what
-- `formal/check.sh` builds.  It is `refl` in exactly the same way, and
-- belongs in that root.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED.  No source text is claimed for the compound तन्तुसन्धि; it
-- is built here from ordinary Sanskrit — तन्तु, thread/fibre, and सन्धि,
-- junction, the term पाणिनि uses in the अष्टाध्यायी (~500 BCE) for the
-- joining of two elements at a boundary.  Nothing about that usage is
-- asserted of type-theoretic fibres.  No arithmetic, oracle-separation
-- or S₃ theorem is proved or reproved here; the four theorems say only
-- that a type already in the corpus is the type `fiber` already means.
--
-- CHECKED: --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Tantusandhi_TheFourWrittenFibresWereAlreadyTheQueuesOwnMapsAndTwoEdgesTheCensusNeverSaw where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Int using (ℤ ; pos)

open import NaturalMachine.ChenTwoChargeProjector using (Charge ; chargeOneProjector ; chargeOneFiber)
open import Swarm.S03CarryFiber using (Word ; value ; Fib)
open import NaturalMachine.ParitySeparator using (Number ; Ω ; sgn)
open import NaturalMachine.OracleSeparation using (EvenQuery)
open import NaturalMachine.S3IntegerRelativeCoordinates using (triple ; ThreeKernel)

------------------------------------------------------------------------
-- ०.  THE SIX THAT DIED, named, with the reason each died.
--
-- Every one of the six is a Σ over a source type that the queue does
-- carry.  The type-level shape is what kills them, and the shape is
-- worth stating because it is a REPAIR to the join, not an excuse:
--
--   (i)  a NEGATED equation is not a fibre.  `fiber f b` is
--        `Σ[ a ] (f a ≡ b)`; `Σ[ a ] ¬ (f a ≡ b)` is its complement and
--        is a fibre of nothing.
--          · LawfulContinuationCore.AdmissibleModulus  (Σ[ q ∈ ℕ ] ¬ (L mod q ≡ zero))
--          · LawfulContinuationCore.BranchingFiber     (Σ left Σ right ¬ left ≡ right)
--          · OracleSeparation.Charged                  (Σ[ σ ∈ Signs ] ¬ (P σ ≡ P (flip σ)))
--        The middle one is named "…Fiber" and is not one; the name was
--        the whole of its evidence.
--
--   (ii) a FIXED-POINT type is not a fibre.  `Σ[ a ] (g a ≡ a)` is the
--        equalizer of g and the identity: the index varies with the
--        point, so there is no b for `fiber g b` to be taken over.
--          · RelationalTensorObstructionBridge.LoopStable  (Σ[ phase ∈ Bool ] subst … loop phase ≡ phase)
--          · S3ConjugacyObservation.Fixed                  (Σ[ x ∈ Fin3 ] g .fst x ≡ x)
--        LoopStable additionally occurs in the queue as a TARGET, never
--        as a source, so the join matched it on the wrong end.
--
--   (iii) right shape, WRONG MAP.  PingalaPrastara's `लघु-सङ्ख्या` counts
--        laghus; `Metre`'s equation is over `matraOf`, which sums morae.
--        Same two types, different map, no identification.  (Checked and
--        reported in the previous pass; the `matraOf` fibres themselves
--        did close, in `Chandomudra_…agda`.)
--
-- FOUR of eleven leads closed; SIX died; one closed only after the
-- source-type match was replaced by a map-level one.  So the join on
-- source types alone runs at roughly 55% false positives, and the two
-- cheap filters that would remove most of them — reject a negated
-- equation, reject an equation whose right side mentions the bound
-- variable — are stated above as text because they are one grep each.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- १.  Charge ⟶ Bool « chargeOneProjector      (queue entry)
------------------------------------------------------------------------

chargeOneFiber-is-fibre : chargeOneFiber ≡ fiber chargeOneProjector true
chargeOneFiber-is-fibre = refl

------------------------------------------------------------------------
-- २.  Word ⟶ ℕ « value                        (queue entry)
--
-- This is the edge whose fibre the host module already proved is NOT of
-- constant cardinality — `Fib 1` contractible, `Fib 2` two points — so
-- the receipt for this lossy map is a named type that is provably not a
-- torsor.  Naming it as a fibre is what lets that statement be about the
-- map rather than about a coincidence of definitions.
------------------------------------------------------------------------

Fib-is-fibre : (n : ℕ) → Fib n ≡ fiber value n
Fib-is-fibre _ = refl

------------------------------------------------------------------------
-- ३.  Number ⟶ ℕ « Ω  then  ℕ ⟶ Bool « sgn    (two queue entries)
--
-- The queue holds the two halves; the written fibre belongs to the
-- composite.  A fibre of a composite is not a fibre of either factor,
-- and the identification below is therefore about a map the census is
-- not holding — which is a statement about the census's granularity and
-- is recorded as one.
------------------------------------------------------------------------

sgnΩ : Number → Bool
sgnΩ n = sgn (Ω n)

EvenQuery-is-fibre : EvenQuery ≡ fiber sgnΩ true
EvenQuery-is-fibre = refl

------------------------------------------------------------------------
-- ४.  ℤ ⟶ ℤ « triple                          (NOT a queue entry)
------------------------------------------------------------------------

ThreeKernel-is-fibre : ThreeKernel ≡ fiber triple (pos 0)
ThreeKernel-is-fibre = refl
