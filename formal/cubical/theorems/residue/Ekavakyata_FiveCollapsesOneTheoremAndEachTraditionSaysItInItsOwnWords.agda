{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ï‡µ‡æ‡ï‡‡Ø‡‡æ ‚î five collapses, one theorem, and each tradition says it in
-- its own words.
--
-- TERM.  ekavkyat, "the state of being one sentence": the Mms
-- device by which utterances standing apart in a text are shown to
-- constitute a single sentence, so that none of them is complete alone.
-- Prva-Mms ‚î Jaimini's stras with abara's bhya, developed by
-- Kumrila and Prabhkara.
--
-- LIMIT ON THE CITATION, stated rather than glossed: I have not opened
-- the stras and give no stra number.  The term is standard and its
-- school is named; a number I did not check would be a fabricated
-- provenance, which is the error this apparatus exists to stop.
--
-- WHY AGDA AND NOT PROSE.  Every claim below is a LIVE DEPENDENCY.  The
-- five theorems are imported, not described.  If one is renamed, or
-- weakened, or its module stops checking, THIS FILE GOES RED.  A document
-- that cannot go red is a document nobody has to keep true.
--
------------------------------------------------------------------------
-- THE ONE SENTENCE
--
--   A rule, an observer, a sieve, or a score is blind exactly to what its
--   own collapse identifies.  The blindness is FORCED by the collapse: it
--   is not a choice, not an approximation, and not a resolution limit.
--   The invisible quantity is not small ‚î it is complementary ‚î and it is
--   recoverable only by changing place, never by refining the instrument.
--
-- Each section below is that sentence in the vocabulary of a tradition
-- that reached it without reference to the other four.
------------------------------------------------------------------------

module Ekavakyata_FiveCollapsesOneTheoremAndEachTraditionSaysItInItsOwnWords where

------------------------------------------------------------------------
-- I.  VYKARAA ‚î Pini, Adhyy, c. 500 BCE.
--
--   8.2.1  ‡‡‡∞‡‡µ‡‡‡∞‡æ‡‡ø‡¶‡‡ß‡Æ‡ ‚î from this stra to the end of the text a rule is
--          asiddha, "as if not having taken effect", with respect to
--          everything preceding it.
--   8.2.39 ‡‡≤‡æ‡ ‡‡‡ã‡Ω‡®‡‡‡ ; 8.4.56 ‡µ‡æ‡Ω‡µ‡‡æ‡®‡ ‚î the operational stras at issue.
--
-- THE COLLAPSE: 8.4.56 sends two forms that DISAGREE about 8.2.39's
--   applicability to one and the same form.
-- WHAT GOES BLIND: that applicability itself.
--
-- `‡‡µ‡∞‡ã‡‡‡æ‡‡æ‡µ‡` ‚î there is NO Bool-valued function on the later forms
-- agreeing with it.  Not "a different answer there": no value there.
-- Asiddhatva is therefore not a device against looping ‚î that is
-- `Asiddhatva.agda`, proved separately ‚î it registers that an earlier
-- rule's condition is a function on a fibre which the later rule's
-- collapse destroys.  8.2.1 IS A DESCENT CONDITION.
--
-- `‡‡®‡‡‡‡‡‡¶‡` exhibits the two points of that fibre, so the fibre is not a
-- figure of speech for the invisible part: it is that set.
------------------------------------------------------------------------

open import Purvatrasiddham_TheLaterRulesFibreIsExactlyWhatTheEarlierRuleCannotSeeAndTheBlindnessIsForcedByCollapse
  using (‡§Ö‡§µ‡§∞‡•ã‡§π‡§£‡§æ‡§≠‡§æ‡§µ‡§É ; ‡§§‡§®‡•ç‡§§‡•Å‡§≠‡•á‡§¶‡§É)

------------------------------------------------------------------------
-- II.  GAUGE THEORY / LOOP QUANTUM GRAVITY.
--
-- THE COLLAPSE: an observable invariant under the holonomy.
-- WHAT GOES BLIND: the holonomy ‚î exactly, and in both directions.
--
-- `invisibleExactlyWhenInvariant` ‚î a semantics is unmoved by transport
-- along `ua h` IFF it is invariant under h.  Invisibility and invariance
-- are one condition read from two sides, not two facts about the
-- observable.  `invisibleIsInvariantAsTypes` upgrades it, when the value
-- type is a set, to an EQUIVALENCE of the two conditions.
--
-- The converse cost nothing, and the reason outlives this file: the two
-- sides are joined by `uaŒ≤`, which is a PATH, walkable in either
-- orientation.  Elsewhere a converse costs
-- `Enumerated K` + `Discrete O`, because there the sides were joined by an
-- implication assumed.  A PATH HAS AN INVERSE; AN IMPLICATION DOES NOT ‚î
-- so "is the converse free?" is answerable from the shape of what
-- connects the two sides, before either direction is attempted.
------------------------------------------------------------------------

open import HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned
  using (invisibleExactlyWhenInvariant ; invisibleIsInvariantAsTypes)

------------------------------------------------------------------------
-- III.  ANALYTIC NUMBER THEORY ‚î the parity barrier, with no sieve in it.
--
-- THE COLLAPSE: idempotence.  Knowing something twice is knowing it once,
--   so ANY state law that accumulates ‚î observations, constraints,
--   standpoints, congruences, installed primes ‚î is idempotent.  That is
--   not a fact about lcm and not a fact about divisibility.
-- WHAT GOES BLIND: sign.
--
-- `sign-is-not-accumulable` ‚î there is no accumulative law and no
-- multiplicative f into ‚ taking the value ‚àí1.  Ever.  Not "hard to
-- accumulate."  Over ‚ the units are ¬1, so this rules out Œª everywhere
-- and Œº off the squares, FOR EVERY ACCUMULATIVE LAW AT ONCE, with no
-- domain hypothesis and no arithmetic in the proof.
--
-- Whatever carries sign, it is not accumulation.  Accumulation and
-- cancellation are incompatible, exactly.
------------------------------------------------------------------------

open import SignIsNotAccumulable
  using (sign-is-not-accumulable ; Accumulative)

------------------------------------------------------------------------
-- IV.  THE KERNEL'S SEMANTICS ‚î and the statement about reward.
--
-- ‡‡ô‡‡ï‡‡æ‡, akapa, "the net of digits", is Bhskara II's Llvat
-- section on permutations (~1150): the ARRANGEMENT, as against the count
-- of arrangements.  No verse number: editions differ in numbering there.
--
-- THE COLLAPSE: `eval : Tm ‚í Env ‚í ‚ï`, a readout into a set.
-- WHAT GOES BLIND: a transposition ‚î one ‚/2 of holonomy.
--
-- `no-counting-criterion-separates` ‚î for ANY type C at ANY level and ANY
-- function œ of the counting meaning, œ cannot distinguish performing the
-- commutation from doing nothing.  Universally quantified over every
-- possible readout, not over the ones anyone has tried.
--
-- `comm-loop-is-a-nontrivial-loop-in-the-universe` ‚î and the categorified
-- semantics DOES see it: the path is not refl, proved through `uaŒ≤`, i.e.
-- by univalence's Œ≤-rule COMPUTING.  Calculated, not asserted.
--
-- THE MACHINE-LEARNING FORM.  `install` makes a proved theorem a
-- next-move, so an operation library is a learned policy.  A policy
-- scored by any function of a numerical readout provably cannot represent
-- WHICH ARRANGEMENT produced the number.  Order information is not an
-- inefficiency of a bag-of-counts score; it is provably absent from it.
------------------------------------------------------------------------

open import TheCountingSemanticsIsADecategorificationAndTheBitItDropsIsASymmetry
  using (no-counting-criterion-separates ; comm-loop-is-a-nontrivial-loop-in-the-universe)

------------------------------------------------------------------------
-- V.  THE KERNEL AS A DISTRIBUTED SYSTEM ‚î the same law as a capability.
--
-- THE COLLAPSE: `derivation-sound` lands in an identity type of ‚ï, and ‚ï
--   is a set, so that type is a PROPOSITION.
-- WHAT GOES BLIND: which route was taken.
--
-- `two-nodes-cannot-disagree` ‚î any two derivations between the same
-- terms have EQUAL meanings.  Not compatible, not both acceptable: equal,
-- as terms.  A consensus protocol over meaning would range over a
-- proposition, and a proposition has no second position to elect.
-- CONSENSUS ON MEANING IS NOT FORBIDDEN HERE.  IT IS VACUOUS.
--
-- `merge-is-idempotent` ‚î and the library join is grow-only, commutative
-- and idempotent with no failure mode: `merge` has no `Maybe`, because a
-- NativeOperation cannot be constructed without a checked derivation, so
-- a merge has nothing to validate.  Validity is local and travels with
-- the operation.
--
-- READ WITH III THIS IS ONE OBJECT AND NOT AN ANALOGY.  The library merge
-- is an accumulative law in exactly `SignIsNotAccumulable`'s sense, so
-- the parity barrier applies to it verbatim: A CRDT CANNOT CARRY SIGN.
-- The sieve's blindness and the replicated library's freedom from
-- conflict are one idempotence, priced once as a loss and once as a
-- guarantee.
------------------------------------------------------------------------

open import TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFreeSoConsensusOnMeaningIsVacuous
  using (two-nodes-cannot-disagree ; merge-is-idempotent)

------------------------------------------------------------------------
--
-- * NOT that the five are instances of one formal statement in this file.
--   They are not: their types differ, their ambient structures differ,
--   and no functor between them is constructed here.  What is exhibited
--   is that each is the same SENTENCE about collapse and blindness, and
--   that two of them (III and V) are literally about one object.
-- * NOT that Pini, Bhskara II, Jaimini or any Mmsaka proved,
--   stated or anticipated any of this.  ¬ßI quotes stras; the fibre
--   reading is not Pini's.
-- * NOT anything about physical spacetime, quantum states, Hilbert
--   spaces or SU(2).  ¬ßII is about a semantics and an equivalence.
-- * NOT that ¬ßIV's machine-learning reading is a theorem about any
--   deployed system.  The theorem is about functions of a count-valued
--   semantics; that a reward model is such a function is an
--   interpretation, and is stated as one.
--
-- WHAT IS CLAIMED: the named terms exist, are checked, say what is
-- written above them, and are imported here ‚î so this file is false the
-- moment any of them is.
------------------------------------------------------------------------
