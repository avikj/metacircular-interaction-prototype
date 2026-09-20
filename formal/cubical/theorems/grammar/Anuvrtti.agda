{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Anuvrtti
--
-- ‡‡®‡‡µ‡‡‡‡‡ø ‚î the continuation of material from a stra into the ones that
-- follow it, the Adhyy's principal compression device.  A rule need
-- state only what its predecessor did not already supply.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS MODULE EXISTS
--
-- `TransportPrice` proves every ADDITIVE cost is the difference of a
-- potential ‚î no route matters, no loop accumulates.  That result is a
-- constraint on what a cost can be, and the obvious next question is
-- where a non-trivial cost could still live.
--
-- Anuvtti is the answer, and it lives one level down from where
-- `Laghava` looked.  `Laghava` showed ‡≤‡æ‡ò‡µ is not a function of the
-- DENOTATION.  Anuvtti shows it is not even a function of the SET OF
-- RULES:
--
--     anuvrtti-is-not-a-set-function :
--       ¬ Œ[ f ] ((rs : List Rule) ‚í f (asSet rs) ‚â° cost rs)
--
-- because reordering the same rules changes what each one has to state.
-- Checked witnesses: with A = {1,2}, B = {2}, C = {1},
--
--     cost [A,B,C] = 3        cost [C,A,B] = 2
--
-- and `asSet [A,B,C] ‚â° asSet [C,A,B]` by `refl`.  Same rules, same
-- language generated, different ‡≤‡æ‡ò‡µ, decided entirely by the order.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TOWER, NOW THREE TALL
--
--   denotation      what the rules mean         ‚î coarsest
--   rule set        which rules are present
--   ordered text    the strapha itself       ‚î finest
--
-- `Laghava.laghava-is-not-semantic` separates the first from the rest;
-- `anuvrtti-is-not-a-set-function` separates the second from the third.
-- Each step is a strict refinement, each is proved by exhibiting two
-- objects identified at the coarser level and separated at the finer one.
--
-- And this is why the Adhyy is a *text in an order* and not a
-- collection: the order is carrying information that no set of rules
-- carries, and `vipratiedhe para kryam` ‚î "of two conflicting rules,
-- the later prevails" ‚î is only sayable because the sequence is the
-- object.  A grammar handed to you as an unordered set has already lost
-- something measurable.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
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
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module Anuvrtti where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; snotz ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; _or_)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- 1.  Rules as feature sets, over two features
------------------------------------------------------------------------

Rule : Type
Rule = Bool √ó Bool

-- what a feature costs to state, given what was inherited: nothing if the
-- predecessor already carried it.  This IS anuvtti.
gain : Bool ‚Üí Bool ‚Üí ‚Ñï
gain false true = 1
gain _     _    = 0

-- what a rule costs to state after its predecessor
diffR : Rule ‚Üí Rule ‚Üí ‚Ñï
diffR (p‚ÇÅ , p‚ÇÇ) (c‚ÇÅ , c‚ÇÇ) = gain p‚ÇÅ c‚ÇÅ + gain p‚ÇÇ c‚ÇÇ

-- the cost of a text: each rule stated against the one before it, the
-- first against nothing.
walkCost : Rule ‚Üí List Rule ‚Üí ‚Ñï
walkCost _ []       = 0
walkCost p (r ‚à∑ rs) = diffR p r + walkCost r rs

nothing' : Rule
nothing' = false , false

cost : List Rule ‚Üí ‚Ñï
cost = walkCost nothing'

------------------------------------------------------------------------
-- 2.  Which rules are present, forgetting the order
------------------------------------------------------------------------

eqB : Bool ‚Üí Bool ‚Üí Bool
eqB true  true  = true
eqB false false = true
eqB _     _     = false

eqR : Rule ‚Üí Rule ‚Üí Bool
eqR (a , b) (c , d) = eqB a c and eqB b d

memb : Rule ‚Üí List Rule ‚Üí Bool
memb _ []       = false
memb r (x ‚à∑ xs) = eqR r x or memb r xs

-- the rule SET, as membership of each of the four possible rules
asSet : List Rule ‚Üí Bool √ó Bool √ó Bool √ó Bool
asSet rs = memb (true  , true)  rs
         , memb (true  , false) rs
         , memb (false , true)  rs
         , memb (false , false) rs

------------------------------------------------------------------------
-- 3.  Two texts, one rule set, different ‡≤‡æ‡ò‡µ
--
--   A = {1,2}   B = {2}   C = {1}
------------------------------------------------------------------------

A B C : Rule
A = true  , true
B = false , true
C = true  , false

abc cab : List Rule
abc = A ‚à∑ B ‚à∑ C ‚à∑ []
cab = C ‚à∑ A ‚à∑ B ‚à∑ []

cost-abc : cost abc ‚â° 3
cost-abc = refl

cost-cab : cost cab ‚â° 2
cost-cab = refl

-- and they present the SAME rules
same-rules : asSet abc ‚â° asSet cab
same-rules = refl

------------------------------------------------------------------------
-- 4.  THE THEOREM.  No function of the rule set computes the cost.
------------------------------------------------------------------------

private
  3‚â¢2 : ¬¨ (3 ‚â° 2)
  3‚â¢2 p = snotz (injSuc (injSuc p))

anuvrtti-is-not-a-set-function :
  ¬¨ (Œ£[ f ‚àà (Bool √ó Bool √ó Bool √ó Bool ‚Üí ‚Ñï) ]
       ((rs : List Rule) ‚Üí f (asSet rs) ‚â° cost rs))
anuvrtti-is-not-a-set-function (f , h) =
  3‚â¢2 ( sym (h abc ‚àô cost-abc)
      ‚àô cong f same-rules
      ‚àô (h cab ‚àô cost-cab) )

-- for contrast, something that DOES descend to the set: whether a given
-- rule occurs at all.  So the failure is a property of the measure.
occurrence : List Rule ‚Üí Bool
occurrence rs = memb A rs

occurrence-descends :
  Œ£[ f ‚àà (Bool √ó Bool √ó Bool √ó Bool ‚Üí Bool) ]
    ((rs : List Rule) ‚Üí f (asSet rs) ‚â° occurrence rs)
occurrence-descends = (Œª s ‚Üí fst s) , (Œª _ ‚Üí refl)

------------------------------------------------------------------------
-- 5.  The sentence.
--
-- Inheritance makes the text, not the rule set, the standpoint.  Two
-- grammars with identical rules and identical output differ in ‡≤‡æ‡ò‡µ by an
-- amount fixed entirely by their order, and no invariant of the set can
-- report it.
--
-- `TransportPrice` is unaffected and its lesson sharpens: costs are still
-- coboundaries, but on the strapha.  The object was always the ordered
-- text.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  PRIOR ART, and the same repair as `Laghava` ¬ß6.
--
-- ¬ß4's proof is `TranscriptDescent.collisionObstructsDecoder` inlined at
-- (q, t) = (asSet, cost), against `FiniteInformation.FactorsThrough`.
-- Three modules of this corpus now carry the same argument ‚î
-- `CarryBorrowObservation.borrowCountDoesNotDecodeWord`, `Laghava` ¬ß3,
-- and ¬ß4 here ‚î and only the first knew the general lemma existed.
--
-- The content is isolated below as a collision, which is all any of these
-- theorems ever is: two objects the coarse map identifies, that the fine
-- measure separates.
------------------------------------------------------------------------

anuvrtti-collision :
  Œ£[ p ‚àà List Rule ] Œ£[ q ‚àà List Rule ]
    ((asSet p ‚â° asSet q) √ó (¬¨ (cost p ‚â° cost q)))
anuvrtti-collision =
  abc , cab , same-rules ,
  (Œª h ‚Üí 3‚â¢2 (sym cost-abc ‚àô h ‚àô cost-cab))

------------------------------------------------------------------------
-- Stated once, for the whole tower: every level of it is a collision.
--
--   Laghava   :  eval  identifies  short , long   ;  size separates them
--   Anuvrtti  :  asSet identifies  abc  , cab     ;  cost separates them
--
-- and `Pratyahara`'s obstruction is NOT of this shape ‚î it is an
-- exhaustive impossibility, not a collision ‚î which is why it was the one
-- thing in the thread that obstructed rather than deflated.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- THE REPAIR THIS MODULE ASKED FOR WAS MADE IN
-- `OneLemmaFiveSites`, which derives this module's
-- non-factoring theorem from `TranscriptDescent.collisionObstructsDecoder`
-- applied to the collision isolated above.
--
-- `TheTwoCollisionsAreOneInstantiation` adds a second
-- route, through `AnyonyaAbhava.anyonya‚ísamsarga`, notes that the
-- isolated collision is already a term of the parametric type
-- `AnyonyaAbhava.Collision` at this module's own presentation type, and
-- proves the two routes equal ‚î negations being propositions.
--
-- The private proof above is not removed.  It is the record of how the
-- result was first obtained.
------------------------------------------------------------------------
