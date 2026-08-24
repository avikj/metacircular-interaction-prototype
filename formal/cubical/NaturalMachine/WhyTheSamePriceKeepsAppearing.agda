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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WhyTheSamePriceKeepsAppearing
--
-- Computing something downstream of a repetition, which is the only
-- thing that turns a repetition into a result.
--
-- ────────────────────────────────────────────────────────────────────
-- THE REPETITION
--
-- Over the last cycles this thread has found the same correction at
-- several sites: a hypothesis of `Dec` where the proof uses only
-- `¬ ¬ A → A`, or a target-side condition of `Discrete` where only
-- path-stability is used.  This corpus's own rule about such things is
-- that a pattern over n instances is a pattern over n instances until
-- something downstream of it is computed.  So here is the downstream
-- computation, and it is not another instance.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  the stable types are closed under exactly the connectives
--       these sites' conclusions are built from: `¬`, `→`, `Π`, `×`.
--       Four short proofs.  Together with `Stable-↔` from
--       `WhereTheTowerCanStillBeThree` — stability transports along a
--       bare logical equivalence — this is a closure statement about a
--       class of types, not a fact about any site.
--
--   §2  and there is no closure proof for `Σ` or `⊎`, for an exact
--       reason: `¬ ¬ (Σ …)` hands back no component, so there is
--       nothing to feed the pointwise stability with.
--
--   §3  which PREDICTS the split, and the prediction is checkable by
--       reading conclusions rather than proofs:
--
--         conclusion is Π/→/¬-shaped over stable atoms
--             ⇒ stability is free, no hypothesis needed;
--         conclusion is Σ-shaped
--             ⇒ stability must be assumed, and THAT is where a `Dec`
--               hypothesis gets written down by reflex.
--
--       Checked against the sites, by reading their signatures:
--
--         `WhereTheTowerCanStillBeThree.stableFiberConstant` —
--           conclusion `FiberConstant q t`, a Π₃ into a path.  Free,
--           given stable paths in the target.  Predicted, and so it is.
--
--         `ExclusionRecoversGroundAtAPrice.coExclude→coIdentify-stable`
--           — conclusion `CoIdentify q' q`, a Π into a path.  The
--           hypothesis it takes IS the atom-stability the schema asks
--           for, not an extra.  Predicted.
--
--         `HypothesesAssumedWhereTheyAreDerivable`'s site and
--         `TheDelimitorNeedsOnlyStability`'s site — conclusions
--           `FactorsThrough q' t` and `Collision q t`, both Σ.
--           Stability is not available and is assumed.  Predicted, and
--           both are exactly where a `Dec` was written where `Stable`
--           was used.
--
-- ────────────────────────────────────────────────────────────────────
-- THE BOUNDARY IS ONE-SIDED, AND THAT IS RECORDED, NOT EXPLAINED
--
-- §2 says no closure proof exists for `Σ`.  It does not say closure
-- fails: by `TheUnstableGroundCannotBeExhibited`, `¬ Stable A` is
-- refuted for every A, so no counterexample to Σ-closure can ever be
-- exhibited either.  The taxonomy is therefore confirmable and not
-- refutable — the same one-sidedness that closed the deflationary
-- test.
--
-- That is TWO occurrences of one-sidedness in this thread.  Nothing
-- downstream of the co-occurrence has been computed, so it is written
-- down and nothing is inferred from it.  The rule that produced this
-- module applies to this module.
--
-- ────────────────────────────────────────────────────────────────────
-- THE RESPECTS
--
--   स्यात् — in the respect of conclusion shape, the split is sharp and
--            §3 checks out at four sites;
--   स्यात् — in the respect of what a site actually needs, the schema
--            decides nothing: a Σ-shaped conclusion may still be
--            stable for reasons peculiar to it (`Stable-↔` alone makes
--            the shape non-decisive, since a Σ logically equivalent to
--            a stable Π is stable).  §3 is a heuristic that must be
--            discharged by reading, not a criterion that replaces it.
--
-- These do not collapse.  A schema that predicted a site's needs
-- without reading the site would be asserting a standpoint that denies
-- the site's own, and `Stable-↔` is the proof inside this thread that
-- shape does not determine the answer.
--
-- NOT CLAIMED.  That Σ-closure fails (it is not shown, and §2's
-- argument is about the absence of a route, not the presence of an
-- obstruction); that four sites are all the sites; that a shape check
-- can be automated here — §3 was carried out by reading four
-- signatures, which is four signatures.
------------------------------------------------------------------------

module NaturalMachine.WhyTheSamePriceKeepsAppearing where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_ ; Stable)

open import NaturalMachine.WhereTheTowerCanStillBeThree using (StableΠ ; Stable-↔)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  Closure, on the connectives the sites' conclusions use
------------------------------------------------------------------------

stable¬ : {A : Type ℓ} → Stable (¬ A)
stable¬ nnna a = nnna (λ na → na a)

stableΠ : {A : Type ℓ} {B : A → Type ℓ'}
        → ((a : A) → Stable (B a)) → Stable ((a : A) → B a)
stableΠ = StableΠ

stable→ : {A : Type ℓ} {B : Type ℓ'} → Stable B → Stable (A → B)
stable→ st = StableΠ (λ _ → st)

stable× : {A : Type ℓ} {B : Type ℓ'}
        → Stable A → Stable B → Stable (A × B)
stable× stA stB nn =
    stA (λ na → nn (λ p → na (fst p)))
  , stB (λ nb → nn (λ p → nb (snd p)))

-- and transport along a bare logical equivalence, restated here so the
-- closure list and its one non-structural member sit together.
stable-↔ : {A : Type ℓ} {B : Type ℓ'}
         → (A → B) → (B → A) → Stable A → Stable B
stable-↔ = Stable-↔

------------------------------------------------------------------------
-- 2.  Where the list stops
--
-- There is no entry for `Σ` and none for `⊎`.  The reason is visible
-- in what a proof would have to do: `¬ ¬ (Σ[ a ] B a)` must produce an
-- `a` before pointwise stability of `B` can be used, and it produces
-- nothing.  Recorded as a statement about the absence of a route.
--
-- What CAN be said positively about the Σ case is already in
-- `WhereTheTowerCanStillBeThree` §5: a decidable Σ is stable.  That is
-- a hypothesis about the Σ, not a closure property of the class.
------------------------------------------------------------------------

-- the closure that does hold for the dependent product of stables,
-- stated once more in the form §3 uses it: a conclusion that is a
-- nested Π into stable atoms is stable.
stableΠ₂ : {A : Type ℓ} {B : A → A → Type ℓ'}
         → ((a a' : A) → Stable (B a a')) → Stable ((a a' : A) → B a a')
stableΠ₂ st = StableΠ (λ a → StableΠ (λ a' → st a a'))

stableΠ₃ : {A : Type ℓ} {B : A → A → Type ℓ'} {C : Type ℓ'}
         → ((a a' : A) → B a a' → Stable C)
         → Stable ((a a' : A) → B a a' → C)
stableΠ₃ st = StableΠ (λ a → StableΠ (λ a' → StableΠ (λ b → st a a' b)))

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `NaturalMachine.DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `¬`, `→`, `×`, `Π`, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `⊎`,
-- `no-barrier-claim : ¬ (¬ (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `NaturalMachine.TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not — and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------
