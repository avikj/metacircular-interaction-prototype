{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HolonomyIsInvisibleExactlyToAnInvariantSemantics
--
--
--   "Even flat architectures can carry interface holonomy h : Z ≃ Z
--    around loops in architecture space — harmless for boundary
--    semantics, load-bearing for caches, provenance, optimizer state,
--    proofs."
--
-- That sentence reports TWO observations.  They are one, and saying
-- which one needs the loop to be an actual PATH rather than a metaphor
-- — which is the one place in this section where the cubical substrate
-- earns its keep rather than merely hosting the argument.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   invariantSemanticsIsUnmoved
--       a consumer `sem : Z → B` satisfying `sem ∘ h ≡ sem` sees
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
--       `transport (ua notEquiv) true ≢ true`
--
-- **So the two halves of §36–38's sentence are one theorem read at two
-- consumers.**  Holonomy is invisible exactly to consumers invariant
-- under it, and the list "caches, provenance, optimizer state, proofs"
-- is a list of consumers that are NOT — they are keyed by the raw
-- interface, which is the identity consumer, and the identity consumer
-- is invariant only when the holonomy is trivial.  There is no separate
-- fact about caches to establish.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY UNIVALENCE IS DOING WORK HERE.  Without it, `h : Z ≃ Z` and a
-- loop in architecture space are different objects and the sentence
-- above is an analogy.  `ua` makes the loop a path, `uaβ` computes
-- transport along it back to `h`, and the two theorems are then about
-- the SAME `h` — the invariance hypothesis and the transport are
-- connected rather than merely parallel.  `notEquiv` is the standard
-- witness that this content is not vacuous: a self-equivalence with no
-- fixed point at `true`.
--
-- NO NOVELTY WHATSOEVER.  `ua`, `uaβ` and the `not` automorphism of
-- `Bool` are the first examples in every cubical development, and
-- Voevodsky's univalence axiom is the substrate this repository already
-- runs on.  What is contributed is the identification of §36–38's two
-- clauses as one statement.
--
-- WHAT IS NOT CLAIMED.  ARCHITECTURE SPACE IS NOT MODELLED.  There is
-- no type of architectures here and no loop in one — `h` is given
-- directly as a self-equivalence of the interface, which is what
-- §36–38 says such a loop YIELDS, not what it is.  So this is a theorem
-- about interface holonomy taken as given, and the step from "loop in
-- architecture space" to "h : Z ≃ Z" is assumed, not built.  FLATNESS
-- is not used: nothing here needs the architecture to be flat, so this
-- says nothing about §36–38's claim that flat architectures can still
-- carry holonomy — only about what holonomy does once present.  No
-- claim that "boundary semantics" in Δ 28's sense IS invariant; that is
-- a hypothesis here and a modelling question there.  Nothing is said
-- about composing loops, so no group structure, no fundamental group,
-- and no claim that holonomies compose to a holonomy.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module HolonomyIsInvisibleExactlyToAnInvariantSemantics where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notEquiv ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  Interface holonomy
------------------------------------------------------------------------

Holonomy : Type → Type
Holonomy Z = Z ≃ Z

------------------------------------------------------------------------
-- 2.  A consumer invariant under the holonomy sees nothing
------------------------------------------------------------------------

invariantSemanticsIsUnmoved :
  {Z B : Type} (h : Holonomy Z) (sem : Z → B)
  → ((z : Z) → sem (equivFun h z) ≡ sem z)
  → (z : Z) → sem (transport (ua h) z) ≡ sem z
invariantSemanticsIsUnmoved h sem inv z =
  cong sem (uaβ h z) ∙ inv z

------------------------------------------------------------------------
-- 3.  A consumer keyed by the raw interface is moved
------------------------------------------------------------------------

nonTrivialHolonomyMovesTheRawInterface :
  {Z : Type} (h : Holonomy Z) (z : Z)
  → ¬ (equivFun h z ≡ z) → ¬ (transport (ua h) z ≡ z)
nonTrivialHolonomyMovesTheRawInterface h z moved e =
  moved (sym (uaβ h z) ∙ e)

------------------------------------------------------------------------
-- 4.  And non-trivial holonomy exists
------------------------------------------------------------------------

notIsGenuineHolonomy : ¬ (equivFun notEquiv true ≡ true)
notIsGenuineHolonomy e = true≢false (sym e)

theCacheIsMoved : ¬ (transport (ua notEquiv) true ≡ true)
theCacheIsMoved =
  nonTrivialHolonomyMovesTheRawInterface notEquiv true notIsGenuineHolonomy

------------------------------------------------------------------------
-- 5.  One loop, two verdicts
------------------------------------------------------------------------

oneLoopTwoVerdicts :
  ((b : Bool) → (λ (_ : Bool) → b) (transport (ua notEquiv) true)
              ≡ (λ (_ : Bool) → b) true)
  × (¬ (transport (ua notEquiv) true ≡ true))
oneLoopTwoVerdicts =
  (λ b → invariantSemanticsIsUnmoved notEquiv (λ _ → b) (λ _ → refl) true)
  , theCacheIsMoved

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  Recording site: commit ecb432c2,
-- `HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
-- **THE WORD `EXACTLY` IS IN THIS MODULE'S NAME AND WAS IN NONE OF ITS
-- THEOREMS.**  §2 proves invariant ⟹ unmoved.  The converse — unmoved
-- ⟹ invariant — is not here, and §"WHAT IS NOT CLAIMED" above, which
-- does list architecture space, flatness, boundary semantics, loop
-- composition and the fundamental group, does not list it either.  The
-- same holds of §3: `nonTrivialHolonomyMovesTheRawInterface` goes one
-- way only.
--
-- **AND BOTH CONVERSES COST NOTHING.**  `uaβ h z` is a PATH, so it may
-- be walked in either orientation; each backward direction is the
-- forward one composed with `sym`.  At the recording site:
-- `invisible→invariant`, `invisibleExactlyWhenInvariant`, and —
-- given `isSet B` — `invisibleIsInvariantAsTypes`, an EQUIVALENCE of
-- the two conditions rather than a two-way implication.  `Invariant`
-- and `Invisible` are named there; `invariant→invisible` is
-- `invariantSemanticsIsUnmoved` REUSED, not restated.
--
-- **WHY THIS WAS WORTH A CYCLE RATHER THAN A ONE-LINE FIX.**  One cycle
-- earlier the same audit found a missing converse in
-- `FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt`
-- (53a06cc9), and THERE the two directions were genuinely asymmetric:
-- one a congruence, the other a search paying `Enumerated K` +
-- `Discrete O`.  Here there is no asymmetry, and the difference is
-- structural rather than luck.  In that module the two sides are joined
-- by an IMPLICATION ASSUMED (`FullyAbstract`); here by a PATH GIVEN
-- (`uaβ`).  A path has an inverse; an implication does not.  So the
-- question "is the converse free?" has an answer readable off the shape
-- of what joins the two sides, and this module is the case where it is
-- free.
--
-- NOTHING ABOVE IS RETRACTED.  Every theorem in this file is true as
-- stated, and §5's `oneLoopTwoVerdicts` is unaffected.  What was wrong
-- was a title asserting a biconditional the file did not contain, and
-- an inventory of omissions that did not name the omission.
--
-- The name is NOT changed: renaming would break importers and would
-- also erase the record of the error, which is the more useful object.
------------------------------------------------------------------------
