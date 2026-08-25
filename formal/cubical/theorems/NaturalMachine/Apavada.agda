{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Apavada
--
-- उत्सर्ग / अपवाद — the general rule and its exception, where the specific
-- blocks the general.  Third instance of one theorem.
--
-- THE PATTERN, and the school boundary that runs through it:
--
--   अनेकान्त      standpoints of an OBSERVER      Anekanta.agda   — JAIN
--   असिद्धत्व      standpoints of a RULE           Asiddha.agda    — PĀṆINIAN
--   अपवाद        standpoints of a RULE PAIR      here            — PĀṆINIAN
--
-- and in every case the same law: a collapse exists IFF every pair of
-- standpoints agrees (887641a7).  Not a dichotomy — disagreement is one
-- way to fail agreement, not the only one.
--
-- These are NOT three scales of one grammatical tradition.  Anekāntavāda
-- is Jain epistemology — a claim about how a thing is, made by logicians
-- the Naiyāyikas and the Buddhist pramāṇavādins argued against.
-- Asiddhatva and apavāda are the grammarians' own, about how a rule
-- behaves in a derivation.  The recurrence across them is real and worth
-- naming; the tradition attribution was not, and CLAUDE.md's rule is to
-- name the school before using the term.
--
-- A possible repair, unverified and marked as such: the tantrayukti lists
-- (Arthaśāstra 15.1; Caraka Siddhisthāna 12) are recalled to contain
-- ekānta and anekānta as COMPOSITION devices — a rule stated without
-- exceptions, or with them.  Read in that sense the row belongs with
-- apavāda after all, for a reason this header did not give.  No edition
-- has been consulted; see notes/TANTRAYUKTI_THE_TREATISE_THAT_DESCRIBES_ITS_OWN_DEVICES.md §4.
--
-- THE DISTINCTION THIS MODULE FORCES, and this corpus has been eliding it.
-- Two situations wear the same shape and are not the same:
--
--   * अपवाद proper — the rules DISAGREE on the exception's domain.  The
--     exception changes the output.  This is why exceptions exist, and
--     `disagreement-has-no-common-output` says no single value serves
--     both rules there.
--
--   * REFORMULATION — the rules AGREE everywhere.  Nothing about the
--     generated language changes.  What changes is लाघव and price.
--
-- `WalkFast` is the second kind and was described here as if it were the
-- first.  "next m is the least prime power above m" does not override
-- "least q with q ∤ cap m" — it *agrees* with it, everywhere, provably
-- (`next-characterised`).  The exchange is not an exception.  It is the
-- same rule said in fewer words and run at a fraction of the price, which
-- is precisely the quantity `notes/LAGHAVA_COST_IS_NOT_A_UNIVALENT_INVARIANT.md`
-- says univalence cannot see.
--
-- So the two kinds are separated by exactly the dichotomy: disagreement
-- is अपवाद and changes the language; agreement is reformulation and
-- changes only the cost.
--
-- ONE UNIVERSE REMARK, because it is not bookkeeping.  The exception's
-- domain विषय is a FAMILY OF TYPES, not a family of booleans: where a rule
-- applies is itself a proposition that may need proving, so `RulePair`
-- lands one universe up.  A grammar whose conditions were decidable
-- booleans would be a different (smaller) object, and the Aṣṭādhyāyī is
-- not that object — its conditions quantify over derivational context.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Apavada where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  A rule pair
------------------------------------------------------------------------

record RulePair (A : Type ℓ) (B : Type ℓ') : Type (ℓ-max (ℓ-suc ℓ) ℓ') where
  constructor rules
  field
    utsarga : A → B                        -- the general rule
    viṣaya  : A → Type ℓ                   -- the exception's domain
    apavāda : (a : A) → viṣaya a → B       -- the specific rule, there

open RulePair public

-- the two rules agree at a point of the exception's domain
Agrees : {A : Type ℓ} {B : Type ℓ'} (R : RulePair A B)
       → (a : A) → viṣaya R a → Type ℓ'
Agrees R a d = apavāda R a d ≡ utsarga R a

------------------------------------------------------------------------
-- 2.  The dichotomy, at the level of outputs
--
-- Same shape as `Anekanta.collapse-dichotomy`, now about values rather
-- than types: an output serving both rules exists exactly when they
-- agree.
------------------------------------------------------------------------

Serves : {A : Type ℓ} {B : Type ℓ'} (R : RulePair A B)
       → (a : A) → viṣaya R a → B → Type ℓ'
Serves R a d b = (b ≡ utsarga R a) × (b ≡ apavāda R a d)

agreement-permits-common-output :
  {A : Type ℓ} {B : Type ℓ'} (R : RulePair A B) (a : A) (d : viṣaya R a) →
  Agrees R a d → Σ[ b ∈ B ] Serves R a d b
agreement-permits-common-output R a d agree =
  utsarga R a , (refl , sym agree)

disagreement-has-no-common-output :
  {A : Type ℓ} {B : Type ℓ'} (R : RulePair A B) (a : A) (d : viṣaya R a) →
  ¬ (Agrees R a d) → (b : B) → ¬ (Serves R a d b)
disagreement-has-no-common-output R a d ¬agree b (p , q) =
  ¬agree (sym q ∙ p)

------------------------------------------------------------------------
-- 3.  The two kinds, separated
--
-- A pair is a REFORMULATION when the rules agree throughout the
-- exception's domain — the generated behaviour is untouched and only the
-- presentation differs.  It is अपवाद proper when they do not.
------------------------------------------------------------------------

Reformulation : {A : Type ℓ} {B : Type ℓ'} → RulePair A B → Type (ℓ-max ℓ ℓ')
Reformulation {A = A} R = (a : A) (d : viṣaya R a) → Agrees R a d

ApavādaProper : {A : Type ℓ} {B : Type ℓ'} → RulePair A B → Type (ℓ-max ℓ ℓ')
ApavādaProper {A = A} R = Σ[ a ∈ A ] Σ[ d ∈ viṣaya R a ] (¬ (Agrees R a d))

-- a reformulation cannot also be a proper exception, and conversely:
-- the two kinds are exclusive, which is what makes the distinction usable
-- rather than a matter of emphasis.
kinds-exclude :
  {A : Type ℓ} {B : Type ℓ'} (R : RulePair A B) →
  Reformulation R → ¬ (ApavādaProper R)
kinds-exclude R ref (a , d , ¬agree) = ¬agree (ref a d)

------------------------------------------------------------------------
-- 4.  Both kinds exist.  Smallest instances, so neither notion is empty.
------------------------------------------------------------------------

-- REFORMULATION: "double it" and "add it to itself" — the same rule twice
double : ℕ → ℕ
double n = 2 · n

selfSum : ℕ → ℕ
selfSum n = n + n

reform : RulePair ℕ ℕ
reform = rules double (λ _ → Unit) (λ n _ → selfSum n)

reform-is-reformulation : Reformulation reform
reform-is-reformulation n _ = sym (cong (n +_) (+-zero n))

-- अपवाद PROPER: the general rule is the identity, the exception sends
-- everything to zero.  They disagree at 1, so no output serves both.
zeroOut : RulePair ℕ ℕ
zeroOut = rules (λ n → n) (λ _ → Unit) (λ _ _ → 0)

zeroOut-is-proper : ApavādaProper zeroOut
zeroOut-is-proper = 1 , tt , znots

-- and therefore, by §3, it is not a reformulation: the exception really
-- does change what the grammar generates.
zeroOut-not-reformulation : ¬ (Reformulation zeroOut)
zeroOut-not-reformulation ref = kinds-exclude zeroOut ref zeroOut-is-proper

------------------------------------------------------------------------
-- 5.  What this settles about `WalkFast`.
--
-- `next-characterised` proves the two descriptions of the walk's step
-- agree everywhere.  By §3 that pair is a REFORMULATION and not an
-- exception: it changes nothing about the machine's behaviour and
-- everything about what the machine costs to run.
--
-- Which is the point.  In this tradition the general rule and its
-- reformulation generate the same language, and the grammarian's whole
-- craft is choosing the shorter one.  लाघव is not a stylistic preference
-- laid over a finished system — it is the only quantity that distinguishes
-- two systems that are otherwise identical, and it is exactly the
-- quantity a univalent account discards.
------------------------------------------------------------------------
