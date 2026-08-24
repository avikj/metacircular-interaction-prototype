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
-- NaturalMachine.Anuvrtti
--
-- अनुवृत्ति — the continuation of material from a sūtra into the ones that
-- follow it, the Aṣṭādhyāyī's principal compression device.  A rule need
-- state only what its predecessor did not already supply.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS MODULE EXISTS
--
-- `TransportPrice` proves every ADDITIVE cost is the difference of a
-- potential — no route matters, no loop accumulates.  That result is a
-- constraint on what a cost can be, and the obvious next question is
-- where a non-trivial cost could still live.
--
-- Anuvṛtti is the answer, and it lives one level down from where
-- `Laghava` looked.  `Laghava` showed लाघव is not a function of the
-- DENOTATION.  Anuvṛtti shows it is not even a function of the SET OF
-- RULES:
--
--     anuvrtti-is-not-a-set-function :
--       ¬ Σ[ f ] ((rs : List Rule) → f (asSet rs) ≡ cost rs)
--
-- because reordering the same rules changes what each one has to state.
-- Checked witnesses: with A = {1,2}, B = {2}, C = {1},
--
--     cost [A,B,C] = 3        cost [C,A,B] = 2
--
-- and `asSet [A,B,C] ≡ asSet [C,A,B]` by `refl`.  Same rules, same
-- language generated, different लाघव, decided entirely by the order.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TOWER, NOW THREE TALL
--
--   denotation      what the rules mean         — coarsest
--   rule set        which rules are present
--   ordered text    the sūtrapāṭha itself       — finest
--
-- `Laghava.laghava-is-not-semantic` separates the first from the rest;
-- `anuvrtti-is-not-a-set-function` separates the second from the third.
-- Each step is a strict refinement, each is proved by exhibiting two
-- objects identified at the coarser level and separated at the finer one.
--
-- And this is why the Aṣṭādhyāyī is a *text in an order* and not a
-- collection: the order is carrying information that no set of rules
-- carries, and `vipratiṣedhe paraṁ kāryam` — "of two conflicting rules,
-- the later prevails" — is only sayable because the sequence is the
-- object.  A grammar handed to you as an unordered set has already lost
-- something measurable.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES NOT OVERTURN
--
-- `TransportPrice` still applies, with the standpoint taken to be the
-- ORDERED presentation: cost is still a potential there, so there is
-- still no path-dependence *between texts*.  What moves is the
-- standpoint, not the theorem.  The lesson is that the object had to be
-- the sequence all along, and any account that took the rule set as the
-- standpoint was working with a quotient that the measure does not
-- descend to.
--
-- WHAT IS NOT CLAIMED.  That two features and three rules model the
-- Aṣṭādhyāyī; that node/feature count is Pāṇini's measure (it is not —
-- his lāghava counts morae and rule-slots); or that anuvṛtti in the
-- Aṣṭādhyāyī reaches only the immediate predecessor (it does not; it
-- carries over long stretches, which makes the order-dependence stronger,
-- not weaker).  The theorem is that a measure sensitive to inheritance
-- cannot descend to the set, and one such measure is exhibited.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Anuvrtti where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; snotz ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; _or_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  Rules as feature sets, over two features
------------------------------------------------------------------------

Rule : Type
Rule = Bool × Bool

-- what a feature costs to state, given what was inherited: nothing if the
-- predecessor already carried it.  This IS anuvṛtti.
gain : Bool → Bool → ℕ
gain false true = 1
gain _     _    = 0

-- what a rule costs to state after its predecessor
diffR : Rule → Rule → ℕ
diffR (p₁ , p₂) (c₁ , c₂) = gain p₁ c₁ + gain p₂ c₂

-- the cost of a text: each rule stated against the one before it, the
-- first against nothing.
walkCost : Rule → List Rule → ℕ
walkCost _ []       = 0
walkCost p (r ∷ rs) = diffR p r + walkCost r rs

nothing' : Rule
nothing' = false , false

cost : List Rule → ℕ
cost = walkCost nothing'

------------------------------------------------------------------------
-- 2.  Which rules are present, forgetting the order
------------------------------------------------------------------------

eqB : Bool → Bool → Bool
eqB true  true  = true
eqB false false = true
eqB _     _     = false

eqR : Rule → Rule → Bool
eqR (a , b) (c , d) = eqB a c and eqB b d

memb : Rule → List Rule → Bool
memb _ []       = false
memb r (x ∷ xs) = eqR r x or memb r xs

-- the rule SET, as membership of each of the four possible rules
asSet : List Rule → Bool × Bool × Bool × Bool
asSet rs = memb (true  , true)  rs
         , memb (true  , false) rs
         , memb (false , true)  rs
         , memb (false , false) rs

------------------------------------------------------------------------
-- 3.  Two texts, one rule set, different लाघव
--
--   A = {1,2}   B = {2}   C = {1}
------------------------------------------------------------------------

A B C : Rule
A = true  , true
B = false , true
C = true  , false

abc cab : List Rule
abc = A ∷ B ∷ C ∷ []
cab = C ∷ A ∷ B ∷ []

cost-abc : cost abc ≡ 3
cost-abc = refl

cost-cab : cost cab ≡ 2
cost-cab = refl

-- and they present the SAME rules
same-rules : asSet abc ≡ asSet cab
same-rules = refl

------------------------------------------------------------------------
-- 4.  THE THEOREM.  No function of the rule set computes the cost.
------------------------------------------------------------------------

private
  3≢2 : ¬ (3 ≡ 2)
  3≢2 p = snotz (injSuc (injSuc p))

anuvrtti-is-not-a-set-function :
  ¬ (Σ[ f ∈ (Bool × Bool × Bool × Bool → ℕ) ]
       ((rs : List Rule) → f (asSet rs) ≡ cost rs))
anuvrtti-is-not-a-set-function (f , h) =
  3≢2 ( sym (h abc ∙ cost-abc)
      ∙ cong f same-rules
      ∙ (h cab ∙ cost-cab) )

-- for contrast, something that DOES descend to the set: whether a given
-- rule occurs at all.  So the failure is a property of the measure.
occurrence : List Rule → Bool
occurrence rs = memb A rs

occurrence-descends :
  Σ[ f ∈ (Bool × Bool × Bool × Bool → Bool) ]
    ((rs : List Rule) → f (asSet rs) ≡ occurrence rs)
occurrence-descends = (λ s → fst s) , (λ _ → refl)

------------------------------------------------------------------------
-- 5.  The sentence.
--
-- Inheritance makes the text, not the rule set, the standpoint.  Two
-- grammars with identical rules and identical output differ in लाघव by an
-- amount fixed entirely by their order, and no invariant of the set can
-- report it.
--
-- `TransportPrice` is unaffected and its lesson sharpens: costs are still
-- coboundaries, but on the sūtrapāṭha.  The object was always the ordered
-- text.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  PRIOR ART, and the same repair as `Laghava` §6.
--
-- §4's proof is `TranscriptDescent.collisionObstructsDecoder` inlined at
-- (q, t) = (asSet, cost), against `FiniteInformation.FactorsThrough`.
-- Three modules of this corpus now carry the same argument —
-- `CarryBorrowObservation.borrowCountDoesNotDecodeWord`, `Laghava` §3,
-- and §4 here — and only the first knew the general lemma existed.
--
-- The content is isolated below as a collision, which is all any of these
-- theorems ever is: two objects the coarse map identifies, that the fine
-- measure separates.
------------------------------------------------------------------------

anuvrtti-collision :
  Σ[ p ∈ List Rule ] Σ[ q ∈ List Rule ]
    ((asSet p ≡ asSet q) × (¬ (cost p ≡ cost q)))
anuvrtti-collision =
  abc , cab , same-rules ,
  (λ h → 3≢2 (sym cost-abc ∙ h ∙ cost-cab))

------------------------------------------------------------------------
-- Stated once, for the whole tower: every level of it is a collision.
--
--   Laghava   :  eval  identifies  short , long   ;  size separates them
--   Anuvrtti  :  asSet identifies  abc  , cab     ;  cost separates them
--
-- and `Pratyahara`'s obstruction is NOT of this shape — it is an
-- exhaustive impossibility, not a collision — which is why it was the one
-- thing in the thread that obstructed rather than deflated.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- THE REPAIR THIS MODULE ASKED FOR WAS MADE IN
-- `NaturalMachine.OneLemmaFiveSites`, which derives this module's
-- non-factoring theorem from `TranscriptDescent.collisionObstructsDecoder`
-- applied to the collision isolated above.
--
-- `NaturalMachine.TheTwoCollisionsAreOneInstantiation` adds a second
-- route, through `AnyonyaAbhava.anyonya→samsarga`, notes that the
-- isolated collision is already a term of the parametric type
-- `AnyonyaAbhava.Collision` at this module's own presentation type, and
-- proves the two routes equal — negations being propositions.
--
-- The private proof above is not removed.  It is the record of how the
-- result was first obtained.
------------------------------------------------------------------------
