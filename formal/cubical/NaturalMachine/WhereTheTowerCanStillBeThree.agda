{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WhereTheTowerCanStillBeThree
--
-- The other half of the deflationary test, and the one place it does
-- not go through.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT WAS LEFT OPEN
--
-- `NaturalMachine.TheAbsenceTowerIsThreeUnconditionally` settles the
-- absence side outright: every statement of the form `¬ A` is stable
-- for free, so no obstruction written as a negation can sit at the top
-- of a three-tall tower.  What that leaves is the AFFIRMATIONS — is
-- `FactorsThrough q t` itself stable, is answerability, are the
-- witness-number statements?  A survey would answer that badly.  There
-- is a theorem instead, and it separates the corpus's own two
-- quantities cleanly.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  stability is closed under Π, pointwise.  Three lines, no
--       hypothesis on the index type.
--
--   §2  hence `FiberConstant q t` — a Π₃ whose conclusion is a path in
--       T — is stable as soon as paths in T are, pointwise on the
--       pairs compared.
--
--   §3  and `FactorsThrough q t` is stable under the same hypothesis
--       plus `isSet T`, by transporting §2 along the corpus's own
--       equivalence.  Stability transports along any logical
--       equivalence; no univalence is needed for this step and none is
--       used.
--
--   §4  so under exactly the hypothesis §9 of `ExclusionRecovers-
--       GroundAtAPrice` already charges — stable paths in the target —
--       BOTH `FactorsThrough q t` and its negation are stable, and the
--       tower over the corpus's central affirmation is two tall.  That
--       is the deflationary conclusion, proved for this shape rather
--       than surveyed.
--
--   §5  and the place it stops.  `Answerable law = (x : X) → Σ[ d ] law
--       d x` is a Π OVER A Σ.  §1 carries the Π; the Σ is where the
--       argument ends, because `¬ ¬ (Σ …)` hands back no element.  §5
--       gives the positive replacement: a decidable Σ is stable, so the
--       floor's stability is exactly a SEARCH question, and the ceiling
--       and the floor of this corpus part company here for a reason
--       that is not about either of them being harder.
--
-- ────────────────────────────────────────────────────────────────────
-- SAID WITH ITS RESPECT, BECAUSE §5 IS EASY TO OVERSTATE
--
--   स्यात् — in the respect of Π-shaped statements with stable
--            conclusions, the tower is two tall (§1–§4);
--   स्यात् — in the respect of Σ-shaped statements, this file
--            establishes nothing either way (§5).
--
-- The second is an absence of proof and not a proof of absence — no
-- Σ is shown unstable anywhere below, and it would be a दुर्नय to
-- report §5 as "the floor is unstable".  What §5 shows is where the
-- argument stops, which is a different object from where the property
-- fails.  Naming the stopping place is the content; §5's decidability
-- clause says what would move it.  The four corners are not taken for
-- the Σ case, and saying so is the honest report: this file asserts
-- neither that Σ-statements are stable nor that they are not, and does
-- not reach the further two corners at all.
--
-- AND §5 IS NOT ABOUT SHAPE, WHICH THIS FILE ITSELF PROVES.  `Stable-↔`
-- (§1) says stability transports along a bare logical equivalence — no
-- univalence, no h-level, nothing about how the statement is written.
-- So a Σ-shaped statement logically equivalent to a Π-shaped one with
-- stable conclusion IS stable, and reading §5 as "Σ-statements are the
-- unstable ones" is refuted twelve lines above it.  §5 locates a
-- stopping point of one argument, and the argument is about the route,
-- not about the object.
--
-- That contrast is worth recording against the laghava thread, which
-- has been holding that cost is not a univalent invariant — it lives on
-- the presentation, which univalence discards.  Stability is the other
-- kind of thing: it does not live on the presentation at all, and
-- `Stable-↔` is the proof.  Two quantities this corpus has been
-- treating side by side turn out to sit on opposite sides of exactly
-- that line.
--
-- AND NOT A SAPTABHAṄGĪ.  Two syāt clauses in succession are क्रम, the
-- third bhaṅga.  The simultaneous position is not delivered here and is
-- not gestured at: in this corpus that position is a ¬ FactorsThrough,
-- an obstruction to any single decoder, and no such object is
-- constructed below.
--
-- NOT CLAIMED.  That any particular Σ in this corpus is or is not
-- stable; that answerability fails; that the barrier language is empty
-- (§4 deflates the TOWER over these statements, not the statements).
------------------------------------------------------------------------

module NaturalMachine.WhereTheTowerCanStillBeThree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Stable)
open import Cubical.Relation.Nullary.Properties using (Dec→Stable)

open import NaturalMachine.FiniteInformation
  using (FiberConstant ; FactorsThrough
        ; fiberConstant→factorsThrough ; factorsThrough→fiberConstant)

private
  variable
    ℓ ℓ' ℓd ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  Stability is closed under Π, and transports along ↔
------------------------------------------------------------------------

StableΠ : {A : Type ℓ} {B : A → Type ℓ'}
        → ((a : A) → Stable (B a)) → Stable ((a : A) → B a)
StableΠ st nn a = st a (λ nb → nn (λ f → nb (f a)))

-- stability is a property of a type up to logical equivalence only; no
-- univalence, no h-level hypothesis.
Stable-↔ : {A : Type ℓ} {B : Type ℓ'}
         → (A → B) → (B → A) → Stable A → Stable B
Stable-↔ f g st nnb = f (st (λ na → nnb (λ b → na (g b))))

------------------------------------------------------------------------
-- 2.  Fiber constancy is stable when the target's paths are
------------------------------------------------------------------------

stableFiberConstant :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T)
  → ((x x' : X) → Stable (t x ≡ t x'))
  → Stable (FiberConstant q t)
stableFiberConstant q t st =
  StableΠ (λ x → StableΠ (λ x' → StableΠ (λ _ → st x x')))

------------------------------------------------------------------------
-- 3.  Hence so is factoring
------------------------------------------------------------------------

stableFactorsThrough :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (t : X → T)
  → ((x x' : X) → Stable (t x ≡ t x'))
  → Stable (FactorsThrough q t)
stableFactorsThrough isSetT q t st =
  Stable-↔ (fiberConstant→factorsThrough isSetT q t)
           (factorsThrough→fiberConstant q t)
           (stableFiberConstant q t st)

------------------------------------------------------------------------
-- 4.  Both sides stable, so the tower over factoring is two tall
--
-- `¬ FactorsThrough q t` was already stable for free (the absence-tower
-- module).  §3 gives the affirmation under the readability hypothesis
-- that §9 of `ExclusionRecoversGroundAtAPrice` charges anyway.  So on
-- the corpus's central shape, under the corpus's own working
-- hypothesis, there is nothing at the third level on either side.
------------------------------------------------------------------------

bothSidesStable :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (t : X → T)
  → ((x x' : X) → Stable (t x ≡ t x'))
  → Stable (FactorsThrough q t) × Stable (¬ FactorsThrough q t)
bothSidesStable isSetT q t st =
  stableFactorsThrough isSetT q t st , λ nnn a → nnn (λ n → n a)

------------------------------------------------------------------------
-- 5.  Where the argument stops: the Σ
--
-- `Answerable law = (x : X) → Σ[ d ∈ D ] law d x`.  §1 carries the
-- outer Π without cost.  The inner Σ is a different matter: from
-- `¬ ¬ (Σ[ d ] P d)` there is no way to produce a `d`, and that is not
-- a gap in the proof but the reason the proof has no next line.
--
-- The positive replacement is exact.  A DECIDABLE Σ is stable — so the
-- question of whether the floor of this corpus admits a three-tall
-- tower is precisely the question of whether the witness can be found,
-- not a question about absence at all.  That is where the ceiling and
-- the floor part company: the ceiling is a Π into paths and stability
-- is free once the target is readable; the floor is a search.
------------------------------------------------------------------------

-- the outer Π of `Answerable` costs nothing, whatever the Σ does.
stableAnswerable-fromPointwise :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
  → ((x : X) → Stable (Σ[ d ∈ D ] law d x))
  → Stable ((x : X) → Σ[ d ∈ D ] law d x)
stableAnswerable-fromPointwise law st = StableΠ st

-- and a decidable search is stable, which is the only general way in.
stableΣ-fromDec :
  {D : Type ℓd} {P : D → Type ℓ}
  → Dec (Σ[ d ∈ D ] P d) → Stable (Σ[ d ∈ D ] P d)
stableΣ-fromDec = Dec→Stable

stableAnswerable-fromDecidableSearch :
  {D : Type ℓd} {X : Type ℓx} (law : D → X → Type ℓ)
  → ((x : X) → Dec (Σ[ d ∈ D ] law d x))
  → Stable ((x : X) → Σ[ d ∈ D ] law d x)
stableAnswerable-fromDecidableSearch law dec =
  StableΠ (λ x → Dec→Stable (dec x))

------------------------------------------------------------------------
-- ON THIS MODULE'S NAME — "tower", "three" — WHICH TRANSLATE NOTHING.
--
-- No source in this corpus's lineage states an absence hierarchy
-- measured by iteration depth.  The Nyāya–Vaiśeṣika classification of
-- अभाव is fourfold and sorts absences by KIND — prāgabhāva,
-- pradhvaṃsābhāva, atyantābhāva, anyonyābhāva — that is, by the
-- temporal and relational career of what is absent, not by how many
-- negations have been stacked on it.  `notes/ABHAVA.md` §2 carries that
-- table with a primary-text audit (`Tarkasaṅgraha` §§57, 80).
--
-- "The absence tower is three tall" is a statement about iterated `¬`
-- in a constructive type theory.  It is mine, it is proved, and it is
-- not a translation.  Naming the module after it, in a thread whose
-- whole discipline is to prefer the earliest statement over a later
-- restatement, dressed an imported notion in the tradition's clothes —
-- which is the same error `notes/ABHAVA.md` records four struck
-- equations for, one step further along: those at least mapped onto the
-- fourfold before being withdrawn.
--
-- The mathematics below is untouched by this.  What is withdrawn is any
-- suggestion that "the tower" or its height renders a Sanskrit term.
------------------------------------------------------------------------
