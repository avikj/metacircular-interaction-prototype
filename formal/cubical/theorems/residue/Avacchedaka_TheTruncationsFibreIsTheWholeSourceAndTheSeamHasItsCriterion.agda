{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अवच्छेदकम् — त्रुटेः तन्तुः सर्वं मूलम् ; सन्धेः परिच्छेदः लब्धः ।
--
-- (the delimitor: the truncation's fibre is the WHOLE source, and the
--  seam's criterion is thereby available.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS CLOSES, AND WHY IT WAS LEFT OPEN ON PURPOSE.
--
-- `fibre/src/Loss/SakalaVikalaDesa_…` makes the fibre
-- diagnosis a TERM — `देश f b` with three constructors, अवक्तव्यम् (empty
-- fibre: nothing lost, the medium has no name for b, धनात्मकम्),
-- सकलादेश (contractible: one utterance carries all), विकलादेश (two points
-- not identified: the loss, exhibited).  It refuses to add a fourth,
-- and it says exactly why:
--
--     "Adding a constructor for a distinction that has no criterion
--      would be the same दुर्नय this module exists to repair, one level
--      down: a name doing the work of a proof."
--
-- The distinction it refuses is between the note's levels ३ and ४ — both
-- crowded fibres, both landing in विकलादेश.  Level ३ is recoverable only
-- by outside supply; level ४ is नष्टि, अप्रतिकार्या.  And the obvious
-- criterion FAILS to separate them: `¬ Σ[ψ] (ψ ∘ collapse ≡ id)` holds of
-- both.
--
-- `notes/SakalaVikalaDesa_…md` then names what it believes does separate
-- them — the SIZE of the fibre relative to the source — and marks the
-- load-bearing half a CONJECTURE, "one line to check":
--
--     (x : ∥ A ∥₁) → fibre ∣_∣₁ x ≃ A
--
-- §२ below is that line, checked.  It was one line.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT ESTABLISHED, kept apart because the whole value of
-- the seam was that it was honest about its own extent.
--
-- ESTABLISHED (§२): for propositional truncation, EVERY fibre is
-- equivalent to the whole source.  Not merely non-contractible, and not
-- merely large: the fibre IS the source, so nothing whatsoever downstream
-- of the map can see which point it came from.  That is what makes
-- truncation अप्रतिकार्या rather than merely lossy.
--
-- NOT ESTABLISHED: that "fibre ≃ whole source" is THE criterion
-- separating ३ from ४ in general.  §२ settles the level-४ side by
-- exhibiting the archetype; the note's level-३ side (`fibre अनर्पणम्
-- (स्यात्-अस्ति) ≃ syādasti P`, a PROPER part, with other maps out of the
-- source still seeing the difference) is a second instance in another
-- lane and is not reproved here.  Two instances are two instances.  The
-- general claim needs the scale, and the scale is that note's.
--
-- ALSO NOT DONE, and deliberately: this does NOT add the fourth
-- constructor to `देश`.  That datatype is in another library, and the
-- refusal to extend it was a considered act by its author.  A criterion
-- is what was missing; supplying the criterion and extending the type are
-- different decisions, and the second is theirs.  Supplying a criterion
-- and then using it to edit someone's refusal would be the forgery this
-- corpus keeps catching, wearing helpfulness.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TERM.  अवच्छेदक — Nyāya's "delimitor", the property that fixes the
-- exact extent of a relation or an absence (Gaṅgeśa, तत्त्वचिन्तामणि,
-- 14th c., and the Navya-Nyāya technical apparatus after him; the
-- corpus's own `interactive/Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearched
-- Domain.hs` and `AbhavaAvacchedaka.agda` use it in that sense).  LIMIT:
-- nothing below is attributed to any Naiyāyika, and the citation is
-- second-hand.  The word is taken for one property — that a relation is
-- not stated until its extent is — which is exactly what the seam was
-- missing and what §२ supplies.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Avacchedaka_TheTruncationsFibreIsTheWholeSourceAndTheSeamHasItsCriterion where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; isEquiv)
open import Cubical.Foundations.HLevels using (isProp→isContrPath)
open import Cubical.Data.Sigma using (Σ-contractSnd ; Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.HITs.PropositionalTruncation
  using (∥_∥₁ ; ∣_∣₁ ; isPropPropTrunc)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- १ · तन्तुः — the fibre of the truncation unit over a point of ∥ A ∥₁.
--     Written out rather than left as `fiber ∣_∣₁ x`, so the statement
--     below is legible without unfolding.
------------------------------------------------------------------------

त्रुटि-तन्तुः : {A : Type ℓ} → ∥ A ∥₁ → Type ℓ
त्रुटि-तन्तुः {A = A} x = Σ[ a ∈ A ] (∣ a ∣₁ ≡ x)

------------------------------------------------------------------------
-- २ · सर्व-तन्तुः — THE CONJECTURE, CHECKED.
--
--     Every fibre of ∣_∣₁ is equivalent to the whole source.
--
-- ∥ A ∥₁ is a proposition, so each of its path types is CONTRACTIBLE
-- (isProp→isContrPath), so the second component of the Σ contributes
-- nothing and contracts away (Σ-contractSnd), leaving A itself.
--
-- Read against `Sesa_…`: the residual over a target point is what the
-- target forgot there.  Here it forgot everything — the residual is not a
-- part of the source, it is the source.  So no map out of the target can
-- ever distinguish two points of A, because the target's every point
-- stands over all of A at once.
------------------------------------------------------------------------

सर्व-तन्तुः : {A : Type ℓ} (x : ∥ A ∥₁) → त्रुटि-तन्तुः x ≃ A
सर्व-तन्तुः {A = A} x =
  Σ-contractSnd (λ a → isProp→isContrPath isPropPropTrunc ∣ a ∣₁ x)

-- the same statement in the library's own vocabulary, so a reader looking
-- for `fiber` finds it
सर्व-तन्तुः-fiber : {A : Type ℓ} (x : ∥ A ∥₁) → fiber ∣_∣₁ x ≃ A
सर्व-तन्तुः-fiber = सर्व-तन्तुः

------------------------------------------------------------------------
-- ३ · परिच्छेदः — the criterion, stated as a predicate so it can be used
--     rather than admired, and applied to the archetype.
--
--     "The loss is total at b" := the residual over b is the whole source.
--
-- ~~This is what विकलादेश could not say.  विकलादेश says the fibre has two
-- distinct points; that is true of a map that drops one bit and equally
-- true of a map that drops everything.  सर्वहानिः says which.~~
--
-- **STRUCK 2026-08-22, the next day, by the agent who wrote it.  Left
-- standing struck rather than deleted, because striking silently is how
-- this repository loses its own history (CLAUDE.md).**
--
-- सर्वहानिः does NOT say which.  It holds of `सर्वैकम् : Bool → Unit`, the
-- map that drops exactly one bit — `Sesa_…` §5, which its own struck
-- header calls "level २ of a five-level scale".  `Unit` is a proposition,
-- so the path component of the fibre contracts and the fibre is `Bool`,
-- the whole source.  The proof is §२'s proof with `isPropUnit` for
-- `isPropPropTrunc`, which is why: this criterion reads propositionality
-- of the TARGET, and both targets are props.
--
-- The refutation, with three more, is
-- `SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFibreCriterionFailsOnItsOwnArchetype`.
-- §२ there shows it is not a stray instance — `∥ Bool ∥₁ ≃ Unit` and the
-- triangle commutes, so at `A = Bool` the level-४ archetype IS the
-- level-२ archetype, and the two fibre censuses are pointwise equivalent.
--
-- §२ of THIS file is untouched and still true: every fibre of `∣_∣₁` is
-- the whole source, for every `A`.  What is refuted is its use as a
-- criterion, which §४ below already declined to claim in general and
-- which the definition above nonetheless asserted in a comment.
------------------------------------------------------------------------

सर्वहानिः : {A B : Type ℓ} → (A → B) → B → Type ℓ
सर्वहानिः {A = A} f b = fiber f b ≃ A

-- propositional truncation loses totally, at every point of its target
त्रुटिः-सर्वहानिः : {A : Type ℓ} (x : ∥ A ∥₁) → सर्वहानिः ∣_∣₁ x
त्रुटिः-सर्वहानिः = सर्व-तन्तुः-fiber

------------------------------------------------------------------------
-- ४ · The seam, restated with what is now on each side.
--
-- BEFORE: levels ३ and ४ were both `विकलादेश`, and the criterion that was
-- supposed to separate them — does a retraction exist — provably does
-- not, since `¬ Σ[ψ] (ψ ∘ collapse ≡ id)` holds of both.
--
-- NOW: level ४ has a positive criterion and its archetype satisfies it
-- (§३).  What is still owed for the SCALE, and is not owed by this file,
-- is the level-३ side: that a level-३ collapse's fibre is a PROPER part,
-- with something out of the source still seeing the difference.  The note
-- exhibits one such instance (`अनर्पणम्`); one instance is one instance.
--
-- So the seam is narrower and it is not gone, and saying it is gone would
-- be forging a presence in the same paragraph that just closed a gap by
-- refusing to forge one.
--
-- **[2026-08-22 — the seam is not narrower.  It is wider than this
-- paragraph says, and the reason is above.]**  `सर्वहानिः` is satisfied by
-- the corpus's own level-२ archetype, so §३ gave level ४ no criterion at
-- all; and the level-३ half quoted here — a proper fibre, with something
-- out of the source still seeing the difference — is satisfied at the
-- level-४ archetype and is vacuous wherever the fibre is crowded.  Both
-- halves are refuted in
-- `SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFibre
-- CriterionFailsOnItsOwnArchetype`, which also exhibits the same map
-- under two retained contexts with opposite verdicts — so the level is
-- not a property of the map, and no per-map criterion can complete the
-- scale.  What survives here untouched is §२.
------------------------------------------------------------------------
