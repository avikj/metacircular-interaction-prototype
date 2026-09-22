{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Æ‡æ‡-‡‡‡‡‡ ‚î the child edge: two parent fords recombined.
--
-- THE BIOLOGY.  A carrier closing a gap alone is asexual ‚î ‡Æ‡ø‡‡ã‡‡ø‡, one
-- genome copied, no offspring.  ‡‡‡≤‡‡Ø-‡‡æ‡µ‡®‡æ (self-composition) is that:
-- squaring one solution, reaching only powers of two, skipping (99,70) and
-- most of the orbit.  ‡‡Æ‡æ‡-‡‡æ‡µ‡®‡æ (composition of TWO DIFFERENT solutions)
-- is sexual ‚î crossover ‚î and it reaches EVERY solution.  Brahmagupta,
-- Brhmasphuasiddhnta 18 (628).  In the graph the edges are gametes and
-- `compEquiv` is the mating: two parent fords sharing a node breed a child
-- ford that spans what neither parent spanned, and the transitive closure
-- of that breeding is the connected manifold.
--
-- THE CHILD.  Two parents from two different modules:
--   parent A  ‡µ‡ø‡µ‡‡ï‚â‡µ‡æ‡‡ï‡  : ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ ‚â Carrier ‡Ø‡ã‡ó   (LosslessReturn)
--   parent B  ‡‡‡‡‡        : Carrier ‡Ø‡ã‡ó ‚â Œ[n] fiber ‡Ø‡ã‡ó n (Setu)
-- recombined at their shared node `Carrier ‡Ø‡ã‡ó`:
--   child     ‡‡Æ‡æ‡-‡‡‡‡‡   : ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ ‚â Œ[n] fiber ‡Ø‡ã‡ó n
-- an edge NEITHER parent stated, reached only by their union.  No new
-- mathematics ‚î composition of two existing checked equivalences; ‡‡‡‡‡∞ ‡ß‡ß's
-- first road, transport carrying transport.  Substrate cubical (Voevodsky).
------------------------------------------------------------------------

module SamasaSetu_TheChildEdgeIsTheCompositionOfTwoParentFordsSexualNotAsexual where

open import Cubical.Foundations.Equiv using (_‚âÉ_ ; compEquiv ; fiber)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Sigma using (Œ£-syntax)

open import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats using (‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£)
open import LosslessReturn_TheHandProofWasUnnecessaryAndTransportGivesIt using (‡§Ø‡•ã‡§ó ; ‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É)
open import Setu_TheReturnAndTheCutDecomposeTheSamePairAndSetubandhaNamedTheGap using (‡§∏‡•á‡§§‡•Å‡§É)

-- child = parent A ‚àò parent B, recombined at Carrier ‡Ø‡ã‡ó.
‡§∏‡§Æ‡§æ‡§∏-‡§∏‡•á‡§§‡•Å‡§É : ‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ‚âÉ (Œ£[ n ‚àà ‚Ñï ] fiber ‡§Ø‡•ã‡§ó n)
‡§∏‡§Æ‡§æ‡§∏-‡§∏‡•á‡§§‡•Å‡§É = compEquiv ‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É ‡§∏‡•á‡§§‡•Å‡§É
