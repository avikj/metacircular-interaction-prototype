{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तृतीयो मार्गो न विद्यते — there is no third road.
--
-- The corpus's §6 doctrine — every answer is a saṃkramaṇa or a
-- doṣa-lekha, and there is no third road — holds of the universal
-- machine at the step level AS A CONSTRUCTION, witness in hand:
--
--   `no-third-road` — for every machine, either the addressed
--   transition exists (the successor, WITH the receipt that the table
--   prescribes it: the saṃkramaṇa) or the table is silent (the
--   equation in Maybe: the written absence).  The disjunction is
--   produced by computing the lookup, not by excluded middle; the
--   witness rides in the sum, and no boolean stands in for it.
--
--   `each-depth-is-decided` — hence at every finite depth n the
--   halting observation is decided, again with witnesses: asti with
--   its silence-equation, or nāsti with the transition that refutes
--   it.  Every finite question to the machine has a bivalent,
--   evidence-carrying answer.
--
--   The LIMIT is different in kind.  Divergence is the refutation of
--   halting at every depth — a Π over the profile, a proposition
--   (`divergence-is-a-proposition`), exclusive with halting
--   (`asti-nasti-exclusive`) — but it is not one more depth: no
--   finite observation asserts it, and this development does not
--   pretend to decide it.  The machine's finite speech is bivalent;
--   its infinite silence is a different grammatical category, held as
--   a proposition and never collapsed into a bit.  That the fourth
--   position is not manufactured from the finite three is the
--   machine's own syādvāda: each naya (each depth) speaks with
--   evidence, and the totality is not a naya.
------------------------------------------------------------------------

module TrtiyoMargoNaVidyate_EachStepIsATransportOrASilenceWithItsWitnessAndTheLimitIsNoThirdRoad where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Relation.Nullary.Properties using (isProp¬)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; ¬just≡nothing)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Empty as Empty using (⊥)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import AnulomaViloma_TheTraceComposesTheCompletedRunRunsBackwardsByReflAndWhenTheMachineHaltsIsAProposition
  using (HaltsAt ; isPropHalted)

------------------------------------------------------------------------
-- §1  One step: a transport with its receipt, or a written silence.
------------------------------------------------------------------------

no-third-road : (mc : Machine) →
  (Σ[ c' ∈ Conf ] δ (fst mc) (snd mc) ≡ just c') ⊎ Halted mc
no-third-road (M , c) = go (δ M c) refl
  where
  go : (m : Maybe Conf) → δ M c ≡ m →
       (Σ[ c' ∈ Conf ] δ M c ≡ just c') ⊎ (δ M c ≡ nothing)
  go (just c') p = inl (c' , p)
  go nothing   p = inr p

------------------------------------------------------------------------
-- §2  Every finite depth is decided, with evidence either way.
------------------------------------------------------------------------

each-depth-is-decided : (n : ℕ) (mc : Machine) →
  HaltsAt n mc ⊎ (¬ HaltsAt n mc)
each-depth-is-decided n mc = go (no-third-road (run n mc))
  where
  go : (Σ[ c' ∈ Conf ] δ (fst (run n mc)) (snd (run n mc)) ≡ just c')
         ⊎ Halted (run n mc) →
       HaltsAt n mc ⊎ (¬ HaltsAt n mc)
  go (inl (c' , p)) = inr (λ h → ¬just≡nothing (sym p ∙ lemma h))
    where
    lemma : Halted (run n mc) →
            δ (fst (run n mc)) (snd (run n mc)) ≡ nothing
    lemma h = h
  go (inr h) = inl h

------------------------------------------------------------------------
-- §3  The limit is a different grammatical category.
------------------------------------------------------------------------

-- Divergence: the refutation of halting at every depth.  A
-- proposition — one content, however arrived at.
divergence-is-a-proposition : (mc : Machine) → isProp (Diverges mc)
divergence-is-a-proposition mc =
  isPropΠ (λ n → isProp¬ (HaltsAt n mc))

-- Asti and the total nāsti exclude one another: a machine does not
-- halt and diverge.
asti-nasti-exclusive : (mc : Machine) →
  Σ[ n ∈ ℕ ] HaltsAt n mc → Diverges mc → ⊥
asti-nasti-exclusive mc (n , h) d = d n h
