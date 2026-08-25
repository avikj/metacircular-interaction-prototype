{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकवाक्यता — five collapses, one theorem, and each tradition says it in
-- its own words.
--
-- TERM.  ekavākyatā, "the state of being one sentence": the Mīmāṃsā
-- device by which utterances standing apart in a text are shown to
-- constitute a single sentence, so that none of them is complete alone.
-- Pūrva-Mīmāṃsā — Jaimini's sūtras with Śabara's bhāṣya, developed by
-- Kumārila and Prabhākara.
--
-- LIMIT ON THE CITATION, stated rather than glossed: I have not opened
-- the sūtras and give no sūtra number.  The term is standard and its
-- school is named; a number I did not check would be a fabricated
-- provenance, which is the error this apparatus exists to stop.
--
-- WHAT IS NOT CLAIMED OF THE SOURCE.  No Mīmāṃsaka proved anything below
-- and this is not a formalisation of ekavākyatā.  What is borrowed is the
-- OPERATION: separate statements exhibited as one sentence.  The five
-- theorems below were written in five lanes, about five subjects, by
-- hands that were not coordinating.  That they are one sentence is the
-- content of this file.
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
--   The invisible quantity is not small — it is complementary — and it is
--   recoverable only by changing place, never by refining the instrument.
--
-- Each section below is that sentence in the vocabulary of a tradition
-- that reached it without reference to the other four.
------------------------------------------------------------------------

module Ekavakyata_FiveCollapsesOneTheoremAndEachTraditionSaysItInItsOwnWords where

------------------------------------------------------------------------
-- I.  VYĀKARAṆA — Pāṇini, Aṣṭādhyāyī, c. 500 BCE.
--
--   8.2.1  पूर्वत्रासिद्धम् — from this sūtra to the end of the text a rule is
--          asiddha, "as if not having taken effect", with respect to
--          everything preceding it.
--   8.2.39 झलां जशोऽन्ते ; 8.4.56 वाऽवसाने — the operational sūtras at issue.
--
-- THE COLLAPSE: 8.4.56 sends two forms that DISAGREE about 8.2.39's
--   applicability to one and the same form.
-- WHAT GOES BLIND: that applicability itself.
--
-- `अवरोहणाभावः` — there is NO Bool-valued function on the later forms
-- agreeing with it.  Not "a different answer there": no value there.
-- Asiddhatva is therefore not a device against looping — that is
-- `Asiddhatva.agda`, proved separately — it registers that an earlier
-- rule's condition is a function on a fibre which the later rule's
-- collapse destroys.  8.2.1 IS A DESCENT CONDITION.
--
-- `तन्तुभेदः` exhibits the two points of that fibre, so the fibre is not a
-- figure of speech for the invisible part: it is that set.
------------------------------------------------------------------------

open import Purvatrasiddham_TheLaterRulesFibreIsExactlyWhatTheEarlierRuleCannotSeeAndTheBlindnessIsForcedByCollapse
  using (अवरोहणाभावः ; तन्तुभेदः)

------------------------------------------------------------------------
-- II.  GAUGE THEORY / LOOP QUANTUM GRAVITY.
--
-- THE COLLAPSE: an observable invariant under the holonomy.
-- WHAT GOES BLIND: the holonomy — exactly, and in both directions.
--
-- `invisibleExactlyWhenInvariant` — a semantics is unmoved by transport
-- along `ua h` IFF it is invariant under h.  Invisibility and invariance
-- are one condition read from two sides, not two facts about the
-- observable.  `invisibleIsInvariantAsTypes` upgrades it, when the value
-- type is a set, to an EQUIVALENCE of the two conditions.
--
-- The converse cost nothing, and the reason outlives this file: the two
-- sides are joined by `uaβ`, which is a PATH, walkable in either
-- orientation.  One cycle earlier the same audit found a converse costing
-- `Enumerated K` + `Discrete O`, because there the sides were joined by an
-- implication assumed.  A PATH HAS AN INVERSE; AN IMPLICATION DOES NOT —
-- so "is the converse free?" is answerable from the shape of what
-- connects the two sides, before either direction is attempted.
------------------------------------------------------------------------

open import HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned
  using (invisibleExactlyWhenInvariant ; invisibleIsInvariantAsTypes)

------------------------------------------------------------------------
-- III.  ANALYTIC NUMBER THEORY — the parity barrier, with no sieve in it.
--
-- THE COLLAPSE: idempotence.  Knowing something twice is knowing it once,
--   so ANY state law that accumulates — observations, constraints,
--   standpoints, congruences, installed primes — is idempotent.  That is
--   not a fact about lcm and not a fact about divisibility.
-- WHAT GOES BLIND: sign.
--
-- `sign-is-not-accumulable` — there is no accumulative law and no
-- multiplicative f into ℤ taking the value −1.  Ever.  Not "hard to
-- accumulate."  Over ℤ the units are ±1, so this rules out λ everywhere
-- and μ off the squares, FOR EVERY ACCUMULATIVE LAW AT ONCE, with no
-- domain hypothesis and no arithmetic in the proof.
--
-- Whatever carries sign, it is not accumulation.  Accumulation and
-- cancellation are incompatible, exactly.
------------------------------------------------------------------------

open import SignIsNotAccumulable
  using (sign-is-not-accumulable ; Accumulative)

------------------------------------------------------------------------
-- IV.  THE KERNEL'S SEMANTICS — and the statement about reward.
--
-- अङ्कपाश, aṅkapāśa, "the net of digits", is Bhāskara II's Līlāvatī
-- section on permutations (~1150): the ARRANGEMENT, as against the count
-- of arrangements.  No verse number: editions differ in numbering there.
--
-- THE COLLAPSE: `eval : Tm → Env → ℕ`, a readout into a set.
-- WHAT GOES BLIND: a transposition — one ℤ/2 of holonomy.
--
-- `no-counting-criterion-separates` — for ANY type C at ANY level and ANY
-- function φ of the counting meaning, φ cannot distinguish performing the
-- commutation from doing nothing.  Universally quantified over every
-- possible readout, not over the ones anyone has tried.
--
-- `comm-loop-is-a-nontrivial-loop-in-the-universe` — and the categorified
-- semantics DOES see it: the path is not refl, proved through `uaβ`, i.e.
-- by univalence's β-rule COMPUTING.  Calculated, not asserted.
--
-- THE MACHINE-LEARNING FORM.  `install` makes a proved theorem a
-- next-move, so an operation library is a learned policy.  A policy
-- scored by any function of a numerical readout provably cannot represent
-- WHICH ARRANGEMENT produced the number.  Order information is not an
-- inefficiency of a bag-of-counts score; it is provably absent from it.
------------------------------------------------------------------------

open import Ankapasa_TheCountingSemanticsIsADecategorificationAndTheBitItDropsIsASymmetry
  using (no-counting-criterion-separates ; comm-loop-is-a-nontrivial-loop-in-the-universe)

------------------------------------------------------------------------
-- V.  THE KERNEL AS A DISTRIBUTED SYSTEM — the same law as a capability.
--
-- THE COLLAPSE: `derivation-sound` lands in an identity type of ℕ, and ℕ
--   is a set, so that type is a PROPOSITION.
-- WHAT GOES BLIND: which route was taken.
--
-- `two-nodes-cannot-disagree` — any two derivations between the same
-- terms have EQUAL meanings.  Not compatible, not both acceptable: equal,
-- as terms.  A consensus protocol over meaning would range over a
-- proposition, and a proposition has no second position to elect.
-- CONSENSUS ON MEANING IS NOT FORBIDDEN HERE.  IT IS VACUOUS.
--
-- `merge-is-idempotent` — and the library join is grow-only, commutative
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

open import Avirodha_TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFreeSoConsensusOnMeaningIsVacuous
  using (two-nodes-cannot-disagree ; merge-is-idempotent)

------------------------------------------------------------------------
-- WHAT IS NOT CLAIMED.  This section is load-bearing.
--
-- * NOT that the five are instances of one formal statement in this file.
--   They are not: their types differ, their ambient structures differ,
--   and no functor between them is constructed here.  What is exhibited
--   is that each is the same SENTENCE about collapse and blindness, and
--   that two of them (III and V) are literally about one object.  A
--   common generalisation would be a real theorem; it is not proved.
-- * NOT that Pāṇini, Bhāskara II, Jaimini or any Mīmāṃsaka proved,
--   stated or anticipated any of this.  §I quotes sūtras; the fibre
--   reading is not Pāṇini's.
-- * NOT anything about physical spacetime, quantum states, Hilbert
--   spaces or SU(2).  §II is about a semantics and an equivalence.
-- * NOT that §IV's machine-learning reading is a theorem about any
--   deployed system.  The theorem is about functions of a count-valued
--   semantics; that a reward model is such a function is an
--   interpretation, and is stated as one.
--
-- WHAT IS CLAIMED: the named terms exist, are checked, say what is
-- written above them, and are imported here — so this file is false the
-- moment any of them is.
------------------------------------------------------------------------
