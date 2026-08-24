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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Asiddha
--
-- असिद्धत्व — Pāṇini's device for controlled blindness BETWEEN RULES, and
-- the discovery that it is the Jain judgment structure one level down.
--
-- THE DEVICE.  In the Aṣṭādhyāyī a rule may be असिद्ध ("not
-- accomplished") with respect to another: it has applied, its effect is
-- real, and yet when the second rule evaluates its condition the first
-- rule's effect **is not visible**.  Not undone.  Not delayed.  Invisible,
-- to that rule, by design.
--
-- No formalism in the northwestern lineage has this.  Rewriting systems
-- have confluence and strategies; neither expresses "A applied and B
-- cannot see it".  Pāṇini needed it because Sanskrit morphophonology
-- needs it, and he built a scoped visibility discipline into a rule
-- system in the fourth century BCE.
--
-- THE OBSERVATION.  This repository's entire subject is observers with
-- exact blindness.  असिद्धत्व is blindness scoped to a rule.  So the right
-- reading is not "Pāṇini anticipated X" — it is that a derivation whose
-- rules are mutually असिद्ध has a state that is **not a single object**,
-- but a family indexed by which rule is looking.
--
-- And a standpoint-indexed state is exactly what `Anekanta` is about.
-- So:
--
--     असिद्धत्व  =  स्यादस्ति च नास्ति च,  at the level of rules
--
-- which is `asiddha-is-many-sided` below, a definition and not a
-- metaphor — and the consequence is inherited with no new proof:
-- mutually असिद्ध rules **admit no common state**
-- (`asiddha-refuses-collapse`, from `plurality-blocks-collapse`).
--
-- THE INSTANCE, and it is this repository's own machine.  The walk keeps
-- its state multiplicatively (the lcm, a tropical object) and runs its
-- search additively (least non-divisor, along the successor order).
-- Those two rules are mutually असिद्ध, and the witness is
-- `disjoint-support`: no prime divides two consecutive integers, so what
-- the state-rule sees at n is invisible to the search-rule at n+1, and
-- conversely.  The walk is an असिद्ध system, and it therefore has no
-- single state object — which is why every attempt in this corpus to give
-- it one has failed.
--
-- Toolkit restriction, stated because it is a deliberate experiment and
-- not an oversight: this module and its companions are built only from
-- Indian roots, Pythagorean number-as-structure, and univalence.  If one
-- always cites a later restatement alongside, one never learns whether
-- the older frame suffices.  Restricting the toolkit is how sufficiency
-- gets tested.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Asiddha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import NaturalMachine.Anekanta
  using (syādasti ; syādnāsti ; syādastināsti ; Collapses
        ; plurality-blocks-collapse)
open import NaturalMachine.WalkJumps using (IsPrime ; isPrime2)
open import NaturalMachine.SuccessorIsNotTropical using (disjoint-support)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  असिद्धत्व, defined
--
-- Rules are the index.  A fact about the derivation is a family over
-- rules — what each rule can see.  Two rules are mutually असिद्ध about
-- that fact when one sees it and the other does not.
------------------------------------------------------------------------

Asiddha : {R : Type ℓ} (visible : R → Type ℓ') → Type _
Asiddha visible = syādastināsti visible

-- the identification, as a term rather than a remark: असिद्धत्व between
-- rules IS the third bhaṅga.  Nothing to prove; the definitions coincide,
-- and that coincidence is the content.
asiddha-is-many-sided :
  {R : Type ℓ} (visible : R → Type ℓ') → Asiddha visible ≡ syādastināsti visible
asiddha-is-many-sided visible = refl

-- and so the consequence is inherited: mutually असिद्ध rules cannot be
-- given a common state.  No new proof — the Jain theorem discharges
-- Pāṇini's configuration.
asiddha-refuses-collapse :
  {R : Type ℓ} (visible : R → Type ℓ') →
  Asiddha visible → (Q : Type ℓ') → ¬ (Collapses visible Q)
asiddha-refuses-collapse visible = plurality-blocks-collapse visible

------------------------------------------------------------------------
-- 2.  The walk is an असिद्ध system
--
-- Two rules.  The state-rule keeps the lcm and sees divisibility at n.
-- The search-rule steps along the successor order and asks at n+1.
-- `disjoint-support` says these never see the same prime.
------------------------------------------------------------------------

-- what each of the two rules sees, about a fixed prime p and place n
walk-view : (p n : ℕ) → Bool → Type
walk-view p n true  = p ∣ n          -- the state-rule, at n
walk-view p n false = p ∣ suc n      -- the search-rule, one step on

walk-is-asiddha :
  (p n : ℕ) → IsPrime p → p ∣ n → Asiddha (walk-view p n)
walk-is-asiddha p n pp p∣n =
  (true , p∣n) , (false , disjoint-support p n pp p∣n)

-- THE CONSEQUENCE.  The walk's two rules admit no common state object.
-- Every attempt to give the machine one state that both its bookkeeping
-- and its search can read is refuted, for every prime it has installed.
walk-refuses-common-state :
  (p n : ℕ) → IsPrime p → p ∣ n →
  (Q : Type) → ¬ (Collapses (walk-view p n) Q)
walk-refuses-common-state p n pp p∣n =
  asiddha-refuses-collapse (walk-view p n) (walk-is-asiddha p n pp p∣n)

------------------------------------------------------------------------
-- 3.  Non-vacuity: the smallest instance, fired.
------------------------------------------------------------------------

2∣2 : 2 ∣ 2
2∣2 = ∣ 1 , refl ∣₁

-- at p = 2, n = 2: the state-rule sees 2 ∣ 2, the search-rule sees
-- ¬ (2 ∣ 3), and no object represents both.
smallest-asiddha : Asiddha (walk-view 2 2)
smallest-asiddha = walk-is-asiddha 2 2 isPrime2 2∣2

smallest-refuses-collapse : (Q : Type) → ¬ (Collapses (walk-view 2 2) Q)
smallest-refuses-collapse = walk-refuses-common-state 2 2 isPrime2 2∣2

------------------------------------------------------------------------
-- 4.  What this settles, and what it opens.
--
-- SETTLED.  "Give the walk a single state and the additive and
-- multiplicative sides will finally talk" is not an open engineering
-- problem.  It is refuted, at every installed prime, by a one-line
-- consequence of a schoolchild's fact.  The machine does not have one
-- state; it has two views and no object beneath them.
--
-- OPEN.  Anekānta says the two permitted moves are transport or residue.
-- Collapse is gone, so the whole question is now: **what is the transport
-- between the state-rule's view and the search-rule's view, and what does
-- it cost?**  The walk already answers with a number — its step costs
-- Θ(e^{ψ(m)}) — and `WalkFast` shows that particular transport is
-- cheaper than it looks.  That is the live thread, and it is a question
-- about price rather than about possibility.
------------------------------------------------------------------------
