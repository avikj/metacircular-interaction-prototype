{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhatTheSubstrateArgumentCovers
--
-- Building on the one thing `DeflationaryTest` has that
-- this thread never reached — its §8 — by locating exactly what its
-- argument ranges over.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ARGUMENT, QUOTED FROM THE FILE
--
--     "in a `--safe`, postulate-free development, every inhabited ⊎ is
--      a decision, because it was constructed.  There is no way to
--      write a term of `A ⊎ B` without producing `inl a` or `inr b`."
--
-- and its internal anchor there is the iso `A ⊎ ¬ A ≅ Dec A`, proved in
-- four lines.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE
--
--   §1  the argument does not depend on `⊎`.  `A → Dec A` holds for
--       EVERY type by `yes`, so "every inhabited X is a decision" is a
--       statement about inhabitation, not about sums.  Instantiated at
--       `Σ`, which is where this thread's floor-is-a-search finding
--       lives: an inhabited Σ is a decision, one line, same as for ⊎.
--
--   §2  and the argument delivers something STRICTLY STRONGER than
--       stability, which is why it cannot be traded for it.  `Stable ⊥`
--       holds while `⊥` is empty, so stability never yields
--       inhabitation.  Exhibited, not argued.
--
--   §3  so the two deflations have different ranges, and §3 states them
--       as such: the substrate argument ranges over what is PROVED and
--       gives inhabitation; the stability argument ranges over what is
--       ¬¬-provable and gives no inhabitation.  Between them sits
--       exactly the class of statements that are ¬¬-provable and not
--       proved — which is where `WhereTheTowerCanStillBeThree` §5's Σ
--       question lives, and which by
--       `TheUnstableGroundCannotBeExhibited` can never be populated by
--       an exhibited example.
--
-- ────────────────────────────────────────────────────────────────────
-- SAID WITH ITS RESPECT, BECAUSE §3 COULD BE MISREAD AS A COMPLAINT
--
-- `DeflationaryTest` §10 concludes "the deflation is therefore total".
-- Nothing here contradicts that, and §3 must not be read as narrowing
-- it:
--
--   स्यात् — in the respect of barrier claims of the form `¬ (Dec A)`,
--            the deflation is total, and its own `no-barrier-claim`
--            proves it;
--   स्यात् — in the respect of Σ-shaped statements under a double
--            negation, nothing can be exhibited either — but for a
--            different reason, `¬ ¬ Stable A`, which is about what can
--            be shown rather than about what was built.
--
-- Two totalities with two grounds.  Collapsing them into one — "it is
-- all deflated, for one reason" — is the move anekānta blocks: they
-- agree in verdict and disagree in ground, and a verdict-level
-- agreement does not license a ground-level collapse.
--
-- ────────────────────────────────────────────────────────────────────
-- ONE OBSERVATION ABOUT THE PRIOR MODULE, OFFERED NOT RANKED
--
-- §1 shows §8's sentence holds of every type, not only of sums.  That
-- is not a defect in §8: §8 was answering a question about the
-- ⊎-shaped sites specifically, and answering the question asked is not
-- an error.  The generalisation is recorded because this thread needed
-- it at `Σ`, not as a verdict on where it was first written.
--
-- Also: §8 cites "an audit of all 434 `.agda` files … 74 such
-- signatures".  Counts are dated.  That one is not rechecked here and
-- nothing below depends on it — and §8 itself says the audit "was not
-- needed", which is the part §1 confirms.
--
-- NOT CLAIMED.  That the substrate argument is internal — it is not,
-- and §1 gives only its internal shadow; that anything in this corpus
-- is ¬¬-provable and unproved (no such statement is exhibited, and by
-- `TheUnstableGroundCannotBeExhibited` none can be); that `Stable`
-- and inhabitation are the only two notions in play.
------------------------------------------------------------------------

module WhatTheSubstrateArgumentCovers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Stable)

open import DeflationaryTest using (sum→dec)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  The substrate argument's internal shadow, and that ⊎ plays no
--     part in it
------------------------------------------------------------------------

-- every inhabited type is a decision.  One constructor.
inhabited-is-a-decision : {A : Type ℓ} → A → Dec A
inhabited-is-a-decision = yes

-- at Σ, which is where this thread's floor question sits.  The proof is
-- the same one; nothing about Σ is used, exactly as nothing about ⊎ was.
inhabitedΣ-is-a-decision :
  {A : Type ℓ} {B : A → Type ℓ'}
  → (Σ[ a ∈ A ] B a) → Dec (Σ[ a ∈ A ] B a)
inhabitedΣ-is-a-decision = inhabited-is-a-decision

-- and therefore stable, through the prior module's own route.
inhabitedΣ-is-stable :
  {A : Type ℓ} {B : A → Type ℓ'}
  → (Σ[ a ∈ A ] B a) → Stable (Σ[ a ∈ A ] B a)
inhabitedΣ-is-stable s _ = s

------------------------------------------------------------------------
-- 2.  Inhabitation is strictly stronger than stability
--
-- Exhibited at ⊥: stable and empty.  So no amount of stability ever
-- returns what the substrate argument returns.
------------------------------------------------------------------------

stableButEmpty : Stable ⊥ × (¬ ⊥)
stableButEmpty = (λ nn → ⊥.rec (nn (λ ()))) , (λ ())

-- stated as the separation it is: there is a type that is stable and
-- has no element, so `Stable A → A` is not available in general.
stability-does-not-inhabit : Σ[ A ∈ Type ] (Stable A × (¬ A))
stability-does-not-inhabit = ⊥ , stableButEmpty

------------------------------------------------------------------------
-- 3.  The two ranges
--
-- Nothing to prove; the content is the pair of scopes, and the objects
-- above are what fix them.  `sum→dec` is imported and re-stated here so
-- the anchor this file builds on is visible in its own import list
-- rather than only in prose.
------------------------------------------------------------------------

anchor-forward : {A : Type ℓ} → A ⊎ (¬ A) → Dec A
anchor-forward = sum→dec
