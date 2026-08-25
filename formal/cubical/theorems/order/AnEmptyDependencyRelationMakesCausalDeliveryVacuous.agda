{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnEmptyDependencyRelationMakesCausalDeliveryVacuous
--
-- about this repository's own sync rule read as a consistency model:
--
--   "Causal consistency is only as strong as the dependency graph you
--    record. … The corpus records none — no note declares which other
--    notes its claims depend on.  Its happens-before relation is
--    therefore the discrete order, in which every pair of writes is
--    concurrent, and causal consistency degenerates to eventual
--    consistency.  The corpus cannot be run causally-consistent by
--    tuning `sync`; it lacks the metadata for the model to have
--    content."
--
-- §2 is the degeneration, exactly; §3 is its converse, which is what
-- makes "lacks the metadata" the right diagnosis rather than a
-- complaint about latency.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT BEING FORMALISED
--
-- Only the delivery constraint.  A causal-delivery discipline says: an
-- order may deliver `b` after `a` whenever nothing forbids it, and must
-- deliver `a` before `b` when `a` happens-before `b`.  §2 says an empty
-- happens-before forbids nothing, so EVERY order satisfies the
-- discipline — the constraint has no content.  §3 says one recorded edge
-- already rules an order out, so the emptiness is doing all the work.
--
-- NOT formalised: CRDTs, G-Sets, strong eventual convergence, FLP, the
-- 60-second period, or the staleness bound — all of which that note
-- treats and none of which appears below.  NOT claimed: that eventual
-- and causal consistency are the same in general; the claim is about the
-- degenerate case, which is the case the note identifies.
--
-- DATE CHECKED BEFORE ANY COMMENT ON THE CLAIM.
-- `git log --diff-filter=A --format='%h %ad' --date=short` gives
-- `6e9fffd8  2026-08-14` for that note.  Its "the corpus records none"
-- was written five days ago, and it is one of the two premises here.
-- One thing HAS changed since, and it is small and must not be
-- overstated: this session added 26 pointer edges — appended
-- back-references from a corrected file to its corrector.  By §3 an
-- inhabited relation is no longer vacuous, so those edges DO constrain
-- some orders.  That is all they do.  Twenty-six edges are not a
-- happens-before relation for the corpus, no note yet declares its
-- claim-level dependencies, and §3 says nothing about how many edges
-- would suffice for anything.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module AnEmptyDependencyRelationMakesCausalDeliveryVacuous where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  Writes, a declared happens-before, and what respecting it means
------------------------------------------------------------------------

module _ (Write : Type) (hb : Write → Write → Type) where

  -- a delivery order respects the declared dependencies
  Respects : (Write → Write → Type) → Type
  Respects ord = (a b : Write) → hb a b → ord a b

  --------------------------------------------------------------------
  -- 2.  With nothing declared, every order respects it
  --------------------------------------------------------------------

  emptyDeclarationIsRespectedByEveryOrder :
    ((a b : Write) → ¬ hb a b)
    → (ord : Write → Write → Type) → Respects ord
  emptyDeclarationIsRespectedByEveryOrder empty ord a b h =
    ⊥.rec (empty a b h)

  -- in particular the order that delivers nothing before anything —
  -- which is what "every pair of writes is concurrent" means — is
  -- admissible, so the discipline excludes no execution at all
  theConcurrentOrderIsAdmissible :
    ((a b : Write) → ¬ hb a b) → Respects (λ _ _ → ⊥)
  theConcurrentOrderIsAdmissible empty =
    emptyDeclarationIsRespectedByEveryOrder empty (λ _ _ → ⊥)

  --------------------------------------------------------------------
  -- 3.  One declared edge already excludes an execution
  --
  -- So §2 is not a fact about causal delivery; it is a fact about the
  -- relation being empty.  Record one dependency and the discipline
  -- starts refusing orders.
  --------------------------------------------------------------------

  oneDeclaredEdgeExcludesTheConcurrentOrder :
    (a b : Write) → hb a b → ¬ Respects (λ _ _ → ⊥)
  oneDeclaredEdgeExcludesTheConcurrentOrder a b h respects = respects a b h

  -- the two together, as the note's sentence: the discipline has content
  -- exactly when the declaration does
  contentIsExactlyTheDeclaration :
    (((a b : Write) → ¬ hb a b) → Respects (λ _ _ → ⊥))
    × ((Σ[ a ∈ Write ] Σ[ b ∈ Write ] hb a b) → ¬ Respects (λ _ _ → ⊥))
  contentIsExactlyTheDeclaration =
      theConcurrentOrderIsAdmissible
    , λ { (a , b , h) → oneDeclaredEdgeExcludesTheConcurrentOrder a b h }

------------------------------------------------------------------------
-- 4.  The reading
--
-- "The corpus cannot be run causally-consistent by tuning `sync`" is
-- exactly §2: no setting of a delivery process can make a vacuous
-- constraint bite.  And §3 says the repair is not a better process but a
-- recorded edge — which is why that note calls the missing thing
-- METADATA rather than latency.
--
-- KEPT SEPARATE, deliberately.  This session has a distinct finding
-- about back-references not reaching the files that carry a corrected
-- claim.  That was about REACHABILITY for a human reader.  This is about
-- a delivery ORDER for concurrent writers, and the two coincide only in
-- that both are repaired by writing an edge down.  Neither derives the
-- other and they are not merged.
------------------------------------------------------------------------
