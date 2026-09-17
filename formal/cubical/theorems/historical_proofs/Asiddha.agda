{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Asiddha
--
-- ‡‡‡ø‡¶‡‡ß‡‡‡µ ‚î Pini's device for controlled blindness BETWEEN RULES, and
-- the discovery that it is the Jain judgment structure one level down.
--
-- THE DEVICE.  In the Adhyy a rule may be ‡‡‡ø‡¶‡‡ß ("not
-- accomplished") with respect to another: it has applied, its effect is
-- real, and yet when the second rule evaluates its condition the first
-- rule's effect **is not visible**.  Not undone.  Not delayed.  Invisible,
-- to that rule, by design.
--
-- No formalism in the northwestern lineage has this.  Rewriting systems
-- have confluence and strategies; neither expresses "A applied and B
-- cannot see it".  Pini needed it because  morphophonology
-- needs it, and he built a scoped visibility discipline into a rule
-- system in the fourth century BCE.
--
-- THE OBSERVATION.  This repository's entire subject is observers with
-- exact blindness.  ‡‡‡ø‡¶‡‡ß‡‡‡µ is blindness scoped to a rule.  So the right
-- reading is not "Pini anticipated X" ‚î it is that a derivation whose
-- rules are mutually ‡‡‡ø‡¶‡‡ß has a state that is **not a single object**,
-- but a family indexed by which rule is looking.
--
-- And a standpoint-indexed state is exactly what `Anekanta` is about.
-- So:
--
--     ‡‡‡ø‡¶‡‡ß‡‡‡µ  =  ‡‡‡Ø‡æ‡¶‡‡‡‡ø ‡ ‡®‡æ‡‡‡‡ø ‡,  at the level of rules
--
-- which is `asiddha-is-many-sided` below, a definition and not a
-- metaphor ‚î and the consequence is inherited with no new proof:
-- mutually ‡‡‡ø‡¶‡‡ß rules **admit no common state**
-- (`asiddha-denies-collapse`, from `plurality-blocks-collapse`).
--
-- THE INSTANCE, and it is this repository's own machine.  The walk keeps
-- its state multiplicatively (the lcm, a tropical object) and runs its
-- search additively (least non-divisor, along the successor order).
-- Those two rules are mutually ‡‡‡ø‡¶‡‡ß, and the witness is
-- `disjoint-support`: no prime divides two consecutive integers, so what
-- the state-rule sees at n is invisible to the search-rule at n+1, and
-- conversely.  The walk is an ‡‡‡ø‡¶‡‡ß system, and it therefore has no
-- single state object ‚î which is why every attempt in this corpus to give
-- it one has failed.
--
-- Toolkit restriction, stated because it is a deliberate experiment and
-- not an oversight: this module and its companions are built only from
-- Indian roots, Pythagorean number-as-structure, and univalence.  If one
-- always cites a later restatement alongside, one never learns whether
-- the older frame suffices.  Restricting the toolkit is how sufficiency
-- gets tested.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module Asiddha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.PropositionalTruncation using (‚à£_‚à£‚ÇÅ)

open import Anekanta
  using (syƒÅdasti ; syƒÅdnƒÅsti ; syƒÅdastinƒÅsti ; Collapses
        ; plurality-blocks-collapse)
open import WalkJumps using (IsPrime ; isPrime2)
open import SuccessorIsNotTropical using (disjoint-support)

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- 1.  ‡‡‡ø‡¶‡‡ß‡‡‡µ, defined
--
-- Rules are the index.  A fact about the derivation is a family over
-- rules ‚î what each rule can see.  Two rules are mutually ‡‡‡ø‡¶‡‡ß about
-- that fact when one sees it and the other does not.
------------------------------------------------------------------------

Asiddha : {R : Type ‚Ñì} (visible : R ‚Üí Type ‚Ñì') ‚Üí Type _
Asiddha visible = syƒÅdastinƒÅsti visible

-- the identification, as a term rather than a remark: ‡‡‡ø‡¶‡‡ß‡‡‡µ between
-- rules IS the third bhaga.  Nothing to prove; the definitions coincide,
-- and that coincidence is the content.
asiddha-is-many-sided :
  {R : Type ‚Ñì} (visible : R ‚Üí Type ‚Ñì') ‚Üí Asiddha visible ‚â° syƒÅdastinƒÅsti visible
asiddha-is-many-sided visible = refl

-- and so the consequence is inherited: mutually ‡‡‡ø‡¶‡‡ß rules cannot be
-- given a common state.  No new proof ‚î the Jain theorem discharges
-- Pini's configuration.
asiddha-denies-collapse :
  {R : Type ‚Ñì} (visible : R ‚Üí Type ‚Ñì') ‚Üí
  Asiddha visible ‚Üí (Q : Type ‚Ñì') ‚Üí ¬¨ (Collapses visible Q)
asiddha-denies-collapse visible = plurality-blocks-collapse visible

------------------------------------------------------------------------
-- 2.  The walk is an ‡‡‡ø‡¶‡‡ß system
--
-- Two rules.  The state-rule keeps the lcm and sees divisibility at n.
-- The search-rule steps along the successor order and asks at n+1.
-- `disjoint-support` says these never see the same prime.
------------------------------------------------------------------------

-- what each of the two rules sees, about a fixed prime p and place n
walk-view : (p n : ‚Ñï) ‚Üí Bool ‚Üí Type
walk-view p n true  = p ‚à£ n          -- the state-rule, at n
walk-view p n false = p ‚à£ suc n      -- the search-rule, one step on

walk-is-asiddha :
  (p n : ‚Ñï) ‚Üí IsPrime p ‚Üí p ‚à£ n ‚Üí Asiddha (walk-view p n)
walk-is-asiddha p n pp p‚à£n =
  (true , p‚à£n) , (false , disjoint-support p n pp p‚à£n)

-- THE CONSEQUENCE.  The walk's two rules admit no common state object.
-- Every attempt to give the machine one state that both its bookkeeping
-- and its search can read is refuted, for every prime it has installed.
walk-denies-common-state :
  (p n : ‚Ñï) ‚Üí IsPrime p ‚Üí p ‚à£ n ‚Üí
  (Q : Type) ‚Üí ¬¨ (Collapses (walk-view p n) Q)
walk-denies-common-state p n pp p‚à£n =
  asiddha-denies-collapse (walk-view p n) (walk-is-asiddha p n pp p‚à£n)

------------------------------------------------------------------------
-- 3.  Non-vacuity: the smallest instance, fired.
------------------------------------------------------------------------

2‚à£2 : 2 ‚à£ 2
2‚à£2 = ‚à£ 1 , refl ‚à£‚ÇÅ

-- at p = 2, n = 2: the state-rule sees 2 ‚à 2, the search-rule sees
-- ¬ (2 ‚à 3), and no object represents both.
smallest-asiddha : Asiddha (walk-view 2 2)
smallest-asiddha = walk-is-asiddha 2 2 isPrime2 2‚à£2

smallest-denies-collapse : (Q : Type) ‚Üí ¬¨ (Collapses (walk-view 2 2) Q)
smallest-denies-collapse = walk-denies-common-state 2 2 isPrime2 2‚à£2

------------------------------------------------------------------------
-- 4.  What this settles, and what it opens.
--
-- SETTLED.  "Give the walk a single state and the additive and
-- multiplicative sides will finally talk" is not an open engineering
-- problem.  It is refuted, at every installed prime, by a one-line
-- consequence of a schoolchild's fact.  The machine does not have one
-- state; it has two views and no object beneath them.
--
-- OPEN.  Aneknta says the two permitted moves are transport or residue.
-- Collapse is gone, so the whole question is now: **what is the transport
-- between the state-rule's view and the search-rule's view, and what does
-- it cost?**  The walk already answers with a number ‚î its step costs
-- Œò(e^{œà(m)}) ‚î and `WalkFast` shows that particular transport is
-- cheaper than it looks.  That is the live thread, and it is a question
-- about price rather than about possibility.
------------------------------------------------------------------------
