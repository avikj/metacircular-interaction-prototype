{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Apavada
--
-- ‡â‡‡‡‡∞‡‡ó / ‡‡‡µ‡æ‡¶ ‚î the general rule and its exception, where the specific
-- blocks the general.  Third instance of one theorem.
--
-- THE PATTERN, and the school boundary that runs through it:
--
--   ‡‡®‡‡ï‡æ‡®‡‡      standpoints of an OBSERVER      Anekanta.agda   ‚î JAIN
--   ‡‡‡ø‡¶‡‡ß‡‡‡µ      standpoints of a RULE           Asiddha.agda    ‚î PINIAN
--   ‡‡‡µ‡æ‡¶        standpoints of a RULE PAIR      here            ‚î PINIAN
--
-- and in every case the same law: a collapse exists IFF every pair of
-- standpoints agrees (887641a7).  Not a dichotomy ‚î disagreement is one
-- way to fail agreement, not the only one.
--
-- These are NOT three scales of one grammatical tradition.  Anekntavda
-- is Jain epistemology ‚î a claim about how a thing is, made by logicians
-- the Naiyyikas and the Buddhist pramavdins argued against.
-- Asiddhatva and apavda are the grammarians' own, about how a rule
-- behaves in a derivation.  The recurrence across them is real and worth
-- naming.
--
-- THE DISTINCTION THIS MODULE FORCES.
-- Two situations wear the same shape and are not the same:
--
--   * ‡‡‡µ‡æ‡¶ proper ‚î the rules DISAGREE on the exception's domain.  The
--     exception changes the output.  This is why exceptions exist, and
--     `disagreement-has-no-common-output` says no single value serves
--     both rules there.
--
--   * REFORMULATION ‚î the rules AGREE everywhere.  Nothing about the
--     generated language changes.  What changes is ‡≤‡æ‡ò‡µ and price.
--
-- `WalkFast` is the second kind.  "next m is the least prime power above m" does not override
-- "least q with q ‚à cap m" ‚î it *agrees* with it, everywhere, provably
-- (`next-characterised`).  The exchange is not an exception.  It is the
-- same rule said in fewer words and run at a fraction of the price, which
-- says univalence cannot see.
--
-- So the two kinds are separated by exactly the dichotomy: disagreement
-- is ‡‡‡µ‡æ‡¶ and changes the language; agreement is reformulation and
-- changes only the cost.
--
-- ONE UNIVERSE REMARK, because it is not bookkeeping.  The exception's
-- domain ‡µ‡ø‡‡Ø is a FAMILY OF TYPES, not a family of booleans: where a rule
-- applies is itself a proposition that may need proving, so `RulePair`
-- lands one universe up.  A grammar whose conditions were decidable
-- booleans would be a different (smaller) object, and the Adhyy is
-- not that object ‚î its conditions quantify over derivational context.
------------------------------------------------------------------------

module Apavada where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- 1.  A rule pair
------------------------------------------------------------------------

record RulePair (A : Type ‚Ñì) (B : Type ‚Ñì') : Type (‚Ñì-max (‚Ñì-suc ‚Ñì) ‚Ñì') where
  constructor rules
  field
    utsarga : A ‚Üí B                        -- the general rule
    vi·π£aya  : A ‚Üí Type ‚Ñì                   -- the exception's domain
    apavƒÅda : (a : A) ‚Üí vi·π£aya a ‚Üí B       -- the specific rule, there

open RulePair public

-- the two rules agree at a point of the exception's domain
Agrees : {A : Type ‚Ñì} {B : Type ‚Ñì'} (R : RulePair A B)
       ‚Üí (a : A) ‚Üí vi·π£aya R a ‚Üí Type ‚Ñì'
Agrees R a d = apavƒÅda R a d ‚â° utsarga R a

------------------------------------------------------------------------
-- 2.  The dichotomy, at the level of outputs
--
-- Same shape as `Anekanta.collapse-dichotomy`, now about values rather
-- than types: an output serving both rules exists exactly when they
-- agree.
------------------------------------------------------------------------

Serves : {A : Type ‚Ñì} {B : Type ‚Ñì'} (R : RulePair A B)
       ‚Üí (a : A) ‚Üí vi·π£aya R a ‚Üí B ‚Üí Type ‚Ñì'
Serves R a d b = (b ‚â° utsarga R a) √ó (b ‚â° apavƒÅda R a d)

agreement-permits-common-output :
  {A : Type ‚Ñì} {B : Type ‚Ñì'} (R : RulePair A B) (a : A) (d : vi·π£aya R a) ‚Üí
  Agrees R a d ‚Üí Œ£[ b ‚àà B ] Serves R a d b
agreement-permits-common-output R a d agree =
  utsarga R a , (refl , sym agree)

disagreement-has-no-common-output :
  {A : Type ‚Ñì} {B : Type ‚Ñì'} (R : RulePair A B) (a : A) (d : vi·π£aya R a) ‚Üí
  ¬¨ (Agrees R a d) ‚Üí (b : B) ‚Üí ¬¨ (Serves R a d b)
disagreement-has-no-common-output R a d ¬¨agree b (p , q) =
  ¬¨agree (sym q ‚àô p)

------------------------------------------------------------------------
-- 3.  The two kinds, separated
--
-- A pair is a REFORMULATION when the rules agree throughout the
-- exception's domain ‚î the generated behaviour is untouched and only the
-- presentation differs.  It is ‡‡‡µ‡æ‡¶ proper when they do not.
------------------------------------------------------------------------

Reformulation : {A : Type ‚Ñì} {B : Type ‚Ñì'} ‚Üí RulePair A B ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')
Reformulation {A = A} R = (a : A) (d : vi·π£aya R a) ‚Üí Agrees R a d

ApavƒÅdaProper : {A : Type ‚Ñì} {B : Type ‚Ñì'} ‚Üí RulePair A B ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')
ApavƒÅdaProper {A = A} R = Œ£[ a ‚àà A ] Œ£[ d ‚àà vi·π£aya R a ] (¬¨ (Agrees R a d))

-- a reformulation cannot also be a proper exception, and conversely:
-- the two kinds are exclusive, which is what makes the distinction usable
-- rather than a matter of emphasis.
kinds-exclude :
  {A : Type ‚Ñì} {B : Type ‚Ñì'} (R : RulePair A B) ‚Üí
  Reformulation R ‚Üí ¬¨ (ApavƒÅdaProper R)
kinds-exclude R ref (a , d , ¬¨agree) = ¬¨agree (ref a d)

------------------------------------------------------------------------
-- 4.  Both kinds exist.  Smallest instances, so neither notion is empty.
------------------------------------------------------------------------

-- REFORMULATION: "double it" and "add it to itself" ‚î the same rule twice
double : ‚Ñï ‚Üí ‚Ñï
double n = 2 ¬∑ n

selfSum : ‚Ñï ‚Üí ‚Ñï
selfSum n = n + n

reform : RulePair ‚Ñï ‚Ñï
reform = rules double (Œª _ ‚Üí Unit) (Œª n _ ‚Üí selfSum n)

reform-is-reformulation : Reformulation reform
reform-is-reformulation n _ = sym (cong (n +_) (+-zero n))

-- ‡‡‡µ‡æ‡¶ PROPER: the general rule is the identity, the exception sends
-- everything to zero.  They disagree at 1, so no output serves both.
zeroOut : RulePair ‚Ñï ‚Ñï
zeroOut = rules (Œª n ‚Üí n) (Œª _ ‚Üí Unit) (Œª _ _ ‚Üí 0)

zeroOut-is-proper : ApavƒÅdaProper zeroOut
zeroOut-is-proper = 1 , tt , znots

-- and therefore, by ¬ß3, it is not a reformulation: the exception really
-- does change what the grammar generates.
zeroOut-not-reformulation : ¬¨ (Reformulation zeroOut)
zeroOut-not-reformulation ref = kinds-exclude zeroOut ref zeroOut-is-proper

------------------------------------------------------------------------
-- 5.  What this settles about `WalkFast`.
--
-- `next-characterised` proves the two descriptions of the walk's step
-- agree everywhere.  By ¬ß3 that pair is a REFORMULATION and not an
-- exception: it changes nothing about the machine's behaviour and
-- everything about what the machine costs to run.
--
-- Which is the point.  In this tradition the general rule and its
-- reformulation generate the same language, and the grammarian's whole
-- craft is choosing the shorter one.  ‡≤‡æ‡ò‡µ is not a stylistic preference
-- laid over a finished system ‚î it is the only quantity that distinguishes
-- two systems that are otherwise identical, and it is exactly the
-- quantity a univalent account discards.
------------------------------------------------------------------------
