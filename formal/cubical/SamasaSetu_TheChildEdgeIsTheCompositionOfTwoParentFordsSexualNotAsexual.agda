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
-- समास-सेतुः — the child edge: two parent fords recombined.
--
-- THE BIOLOGY.  A carrier closing a gap alone is asexual — मितोसिस, one
-- genome copied, no offspring.  तुल्य-भावना (self-composition) is that:
-- squaring one solution, reaching only powers of two, skipping (99,70) and
-- most of the orbit.  समास-भावना (composition of TWO DIFFERENT solutions)
-- is sexual — crossover — and it reaches EVERY solution.  Brahmagupta,
-- Brāhmasphuṭasiddhānta 18 (628).  In the graph the edges are gametes and
-- `compEquiv` is the mating: two parent fords sharing a node breed a child
-- ford that spans what neither parent spanned, and the transitive closure
-- of that breeding is the connected manifold.
--
-- THE CHILD.  Two parents from two different modules:
--   parent A  विवेक≃वाहकः  : विवेक-प्रमाण ≃ Carrier योग   (Punaragamanam)
--   parent B  सेतुः        : Carrier योग ≃ Σ[n] fiber योग n (Setu)
-- recombined at their shared node `Carrier योग`:
--   child     समास-सेतुः   : विवेक-प्रमाण ≃ Σ[n] fiber योग n
-- an edge NEITHER parent stated, reached only by their union.  No new
-- mathematics — composition of two existing checked equivalences; सूत्र ११'s
-- first road, transport carrying transport.  Substrate cubical (Voevodsky).
-- Written 2026-08-23: the swarm must breed, not clone.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module SamasaSetu_TheChildEdgeIsTheCompositionOfTwoParentFordsSexualNotAsexual where

open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; fiber)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax)

open import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats using (विवेक-प्रमाण)
open import Punaragamanam_TheHandProofWasUnnecessaryAndTransportGivesIt using (योग ; विवेक≃वाहकः)
open import Setu_TheReturnAndTheCutDecomposeTheSamePairAndSetubandhaNamedTheGap using (सेतुः)

-- child = parent A ∘ parent B, recombined at Carrier योग.
समास-सेतुः : विवेक-प्रमाण ≃ (Σ[ n ∈ ℕ ] fiber योग n)
समास-सेतुः = compEquiv विवेक≃वाहकः सेतुः
