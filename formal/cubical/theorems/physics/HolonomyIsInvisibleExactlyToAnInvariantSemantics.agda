{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HolonomyIsInvisibleExactlyToAnInvariantSemantics
--
--
--   "Even flat architectures can carry interface holonomy h : Z â‰ Z
--    around loops in architecture space â” harmless for boundary
--    semantics, load-bearing for caches, provenance, optimizer state,
--    proofs."
--
-- That sentence reports TWO observations.  They are one, and saying
-- which one needs the loop to be an actual PATH rather than a metaphor
-- â” which is the one place in this section where the cubical substrate
-- earns its keep rather than merely hosting the argument.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   invariantSemanticsIsUnmoved
--       a consumer `sem : Z â’ B` satisfying `sem âˆ˜ h â‰¡ sem` sees
--       nothing after transport along `ua h`.  This is the "harmless
--       for boundary semantics" half, and the hypothesis is exactly
--       what "boundary semantics" has to mean for it to hold.
--   nonTrivialHolonomyMovesTheRawInterface
--       a consumer that is the raw interface itself is moved wherever
--       `h` moves a point.  This is the "load-bearing for caches" half:
--       a cache keyed by `Z` is the identity consumer, and the identity
--       consumer is invariant only if `h` is.
--   notIsGenuineHolonomy / theCacheIsMoved
--       and non-trivial holonomy exists: `notEquiv` on `Bool`, where
--       `transport (ua notEquiv) true â‰ true`
--
-- **So the two halves of Â§36â“38's sentence are one theorem read at two
-- consumers.**  Holonomy is invisible exactly to consumers invariant
-- under it, and the list "caches, provenance, optimizer state, proofs"
-- is a list of consumers that are NOT â” they are keyed by the raw
-- interface, which is the identity consumer, and the identity consumer
-- is invariant only when the holonomy is trivial.  There is no separate
-- fact about caches to establish.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY UNIVALENCE IS DOING WORK HERE.  Without it, `h : Z â‰ Z` and a
-- loop in architecture space are different objects and the sentence
-- above is an analogy.  `ua` makes the loop a path, `uaÎ²` computes
-- transport along it back to `h`, and the two theorems are then about
-- the SAME `h` â” the invariance hypothesis and the transport are
-- connected rather than merely parallel.  `notEquiv` is the standard
-- witness that this content is not vacuous: a self-equivalence with no
-- fixed point at `true`.
--
-- NO NOVELTY WHATSOEVER.  `ua`, `uaÎ²` and the `not` automorphism of
-- `Bool` are the first examples in every cubical development, and
-- Voevodsky's univalence axiom is the substrate this repository already
-- runs on.  What is contributed is the identification of Â§36â“38's two
-- clauses as one statement.
--
-- Â§36â“38 says such a loop YIELDS, not what it is.  So this is a theorem
-- about interface holonomy taken as given, and the step from "loop in
-- architecture space" to "h : Z â‰ Z" is assumed, not built.  FLATNESS
-- is not used: nothing here needs the architecture to be flat, so this
-- says nothing about Â§36â“38's claim that flat architectures can still
-- carry holonomy â” only about what holonomy does once present.  No
-- claim that "boundary semantics" in Î” 28's sense IS invariant; that is
-- a hypothesis here and a modelling question there.  Nothing is said
-- about composing loops, so no group structure, no fundamental group,
-- and no claim that holonomies compose to a holonomy.
------------------------------------------------------------------------

module HolonomyIsInvisibleExactlyToAnInvariantSemantics where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaÎ²)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notEquiv ; trueâ‰¢false)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  Interface holonomy
------------------------------------------------------------------------

Holonomy : Type â†’ Type
Holonomy Z = Z â‰ƒ Z

------------------------------------------------------------------------
-- 2.  A consumer invariant under the holonomy sees nothing
------------------------------------------------------------------------

invariantSemanticsIsUnmoved :
  {Z B : Type} (h : Holonomy Z) (sem : Z â†’ B)
  â†’ ((z : Z) â†’ sem (equivFun h z) â‰¡ sem z)
  â†’ (z : Z) â†’ sem (transport (ua h) z) â‰¡ sem z
invariantSemanticsIsUnmoved h sem inv z =
  cong sem (uaÎ² h z) âˆ™ inv z

------------------------------------------------------------------------
-- 3.  A consumer keyed by the raw interface is moved
------------------------------------------------------------------------

nonTrivialHolonomyMovesTheRawInterface :
  {Z : Type} (h : Holonomy Z) (z : Z)
  â†’ Â¬ (equivFun h z â‰¡ z) â†’ Â¬ (transport (ua h) z â‰¡ z)
nonTrivialHolonomyMovesTheRawInterface h z moved e =
  moved (sym (uaÎ² h z) âˆ™ e)

------------------------------------------------------------------------
-- 4.  And non-trivial holonomy exists
------------------------------------------------------------------------

notIsGenuineHolonomy : Â¬ (equivFun notEquiv true â‰¡ true)
notIsGenuineHolonomy e = trueâ‰¢false (sym e)

theCacheIsMoved : Â¬ (transport (ua notEquiv) true â‰¡ true)
theCacheIsMoved =
  nonTrivialHolonomyMovesTheRawInterface notEquiv true notIsGenuineHolonomy

------------------------------------------------------------------------
-- 5.  One loop, two verdicts
------------------------------------------------------------------------

oneLoopTwoVerdicts :
  ((b : Bool) â†’ (Î» (_ : Bool) â†’ b) (transport (ua notEquiv) true)
              â‰¡ (Î» (_ : Bool) â†’ b) true)
  Ã— (Â¬ (transport (ua notEquiv) true â‰¡ true))
oneLoopTwoVerdicts =
  (Î» b â†’ invariantSemanticsIsUnmoved notEquiv (Î» _ â†’ b) (Î» _ â†’ refl) true)
  , theCacheIsMoved

------------------------------------------------------------------------
-- Â§2 proves invariant âŸ unmoved.  The converse â” unmoved
-- âŸ invariant â” is at the recording site,
-- `HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned`.  The
-- same holds of Â§3: `nonTrivialHolonomyMovesTheRawInterface` goes one
-- way only.
--
-- **AND BOTH CONVERSES COST NOTHING.**  `uaÎ² h z` is a PATH, so it may
-- be walked in either orientation; each backward direction is the
-- forward one composed with `sym`.  At the recording site:
-- `invisibleâ’invariant`, `invisibleExactlyWhenInvariant`, and â”
-- given `isSet B` â” `invisibleIsInvariantAsTypes`, an EQUIVALENCE of
-- the two conditions rather than a two-way implication.  `Invariant`
-- and `Invisible` are named there; `invariantâ’invisible` is
-- `invariantSemanticsIsUnmoved` REUSED, not restated.
------------------------------------------------------------------------
