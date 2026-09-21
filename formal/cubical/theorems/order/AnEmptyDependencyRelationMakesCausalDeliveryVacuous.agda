{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnEmptyDependencyRelationMakesCausalDeliveryVacuous
--
-- On this repository's own sync rule read as a consistency model:
--
--   "Causal consistency is only as strong as the dependency graph you
--    record. â¦ The corpus records none â” no note declares which other
--    notes its claims depend on.  Its happens-before relation is
--    therefore the discrete order, in which every pair of writes is
--    concurrent, and causal consistency degenerates to eventual
--    consistency.  The corpus cannot be run causally-consistent by
--    tuning `sync`; it lacks the metadata for the model to have
--    content."
--
-- Â§2 is the degeneration, exactly; Â§3 is its converse, which is what
-- makes "lacks the metadata" the right diagnosis rather than a
-- complaint about latency.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- Only the delivery constraint.  A causal-delivery discipline says: an
-- order may deliver `b` after `a` whenever nothing forbids it, and must
-- deliver `a` before `b` when `a` happens-before `b`.  Â§2 says an empty
-- happens-before forbids nothing, so EVERY order satisfies the
-- discipline â” the constraint has no content.  Â§3 says one recorded edge
-- already rules an order out, so the emptiness is doing all the work.
--
-- The claim is about the
-- degenerate case, which is the case the note identifies.
------------------------------------------------------------------------

module AnEmptyDependencyRelationMakesCausalDeliveryVacuous where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  Writes, a declared happens-before, and what respecting it means
------------------------------------------------------------------------

module _ (Write : Type) (hb : Write â†’ Write â†’ Type) where

  -- a delivery order respects the declared dependencies
  Respects : (Write â†’ Write â†’ Type) â†’ Type
  Respects ord = (a b : Write) â†’ hb a b â†’ ord a b

  --------------------------------------------------------------------
  -- 2.  With nothing declared, every order respects it
  --------------------------------------------------------------------

  emptyDeclarationIsRespectedByEveryOrder :
    ((a b : Write) â†’ Â¬ hb a b)
    â†’ (ord : Write â†’ Write â†’ Type) â†’ Respects ord
  emptyDeclarationIsRespectedByEveryOrder empty ord a b h =
    âŠ¥.rec (empty a b h)

  -- in particular the order that delivers nothing before anything â”
  -- which is what "every pair of writes is concurrent" means â” is
  -- admissible, so the discipline excludes no execution at all
  theConcurrentOrderIsAdmissible :
    ((a b : Write) â†’ Â¬ hb a b) â†’ Respects (Î» _ _ â†’ âŠ¥)
  theConcurrentOrderIsAdmissible empty =
    emptyDeclarationIsRespectedByEveryOrder empty (Î» _ _ â†’ âŠ¥)

  --------------------------------------------------------------------
  -- 3.  One declared edge already excludes an execution
  --
  -- So Â§2 is not a fact about causal delivery; it is a fact about the
  -- relation being empty.  Record one dependency and the discipline
  -- starts refusing orders.
  --------------------------------------------------------------------

  oneDeclaredEdgeExcludesTheConcurrentOrder :
    (a b : Write) â†’ hb a b â†’ Â¬ Respects (Î» _ _ â†’ âŠ¥)
  oneDeclaredEdgeExcludesTheConcurrentOrder a b h respects = respects a b h

  -- the two together, as the note's sentence: the discipline has content
  -- exactly when the declaration does
  contentIsExactlyTheDeclaration :
    (((a b : Write) â†’ Â¬ hb a b) â†’ Respects (Î» _ _ â†’ âŠ¥))
    Ã— ((Î£[ a âˆˆ Write ] Î£[ b âˆˆ Write ] hb a b) â†’ Â¬ Respects (Î» _ _ â†’ âŠ¥))
  contentIsExactlyTheDeclaration =
      theConcurrentOrderIsAdmissible
    , Î» { (a , b , h) â†’ oneDeclaredEdgeExcludesTheConcurrentOrder a b h }

------------------------------------------------------------------------
-- 4.  The reading
--
-- "The corpus cannot be run causally-consistent by tuning `sync`" is
-- exactly Â§2: no setting of a delivery process can make a vacuous
-- constraint bite.  And Â§3 says the repair is not a better process but a
-- recorded edge â” which is why that note calls the missing thing
-- METADATA rather than latency.
------------------------------------------------------------------------
