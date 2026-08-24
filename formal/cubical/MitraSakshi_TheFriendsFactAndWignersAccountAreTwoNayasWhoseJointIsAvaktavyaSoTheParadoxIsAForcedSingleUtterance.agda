-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate.  This file is one naya, true
-- and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- मित्र-साक्षिन् — the friend's fact and Wigner's account are two nayas
-- whose joint is avaktavya; the "paradox" is a forced single utterance.
--
-- ON THE NAME.  mitra (मित्र), friend; sākṣin (साक्षिन्), witness.  The
-- compound is built here for Wigner's friend; no source text is claimed
-- for it.  The physics is cited to its own origins: E. Wigner, "Remarks
-- on the Mind-Body Question" (1961); C. Rovelli, "Relational Quantum
-- Mechanics", Int. J. Theor. Phys. 35 (1996) — facts are relative to the
-- observer, and comparison is itself a physical interaction; D.
-- Frauchiger & R. Renner, Nat. Commun. 9, 3711 (2018) — the no-go for
-- combining agents' facts into one absolute valuation.  The logic is the
-- Jaina sevenfold, whose sources the बीज names; the restatement direction
-- is: the ācāryas first, the physicists' structure named as convergent.
--
-- THE OBSERVATION THIS MODULE MAKES, and it is a reading of terms that
-- ALREADY CHECK, not new physics: `SaptabhangiNaya` holds two observers —
-- the machine's rewriter and the kernel's definitional equality — with a
-- genuine realised disagreement (its §: `x · 0 ≡ 0` is asti for the
-- rewriter and nāsti for kernel-refl).  That is the exact fact-structure
-- of Wigner's friend: the friend (inside, having interacted) holds a
-- definite outcome; Wigner (outside, describing unitarily) holds its
-- denial; both are correct relative to their standpoint.  And the three
-- theorems the paradox needs are ALREADY PROVED there:
--
--   * the joint content of the two relative facts is well-defined,
--     decidable, and realised (`joint`, `joint-realised`) — RQM's
--     "both accounts are correct" is not a truth-value gap;
--   * NO single standpointed utterance denotes that joint on all
--     profiles (`no-single-vacana`) — the Frauchiger–Renner step of
--     promoting a relative fact to an absolute one usable by every agent
--     is, structurally, the demand for exactly such an utterance, and it
--     is refuted, not merely unavailable;
--   * the joint IS recovered by two utterances in succession
--     (`krama-expresses`) — Rovelli's resolution, that comparison is a
--     further physical interaction performed in sequence, at theorem
--     grade: krama succeeds precisely where yugapat is inexpressible.
--
-- So a machine-checked model of RQM's fact-architecture has been running
-- in this repository since the two provers first disagreed and their
-- joint was landed as avaktavya — a Wigner's-friend pair made of a
-- rewriter and a kernel, with the paradox's resolution checked before
-- the connection was noticed.  This module makes the identification a
-- named object so it can be used, cited, and refuted.
--
-- WHAT IS **NOT** CLAIMED.  No Hilbert space, no unitarity, no Born rule,
-- no probability appears below; nothing here derives quantum mechanics.
-- The claim is STRUCTURAL and exact: the verdict-architecture of
-- observer-relative facts (relativity of the verdict, impossibility of
-- one absolute utterance, recovery by successive comparison) is the
-- checked architecture of `SaptabhangiNaya`, instantiated — every theorem
-- below is that module's, specialised and re-read; the two thin wrappers
-- are labelled as wrappers.  Whether physical agents ARE nayas in this
-- sense is an interpretation, made in this header and in no term.
------------------------------------------------------------------------

module MitraSakshi_TheFriendsFactAndWignersAccountAreTwoNayasWhoseJointIsAvaktavyaSoTheParadoxIsAForcedSingleUtterance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; not)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import SaptabhangiNaya

------------------------------------------------------------------------
-- §1  The cast, named.  The friend is the standpoint that interacted and
-- holds the outcome: the rewriter.  Wigner is the standpoint that did
-- not, and holds the denial: kernel-refl.  (Wrappers, labelled.)
------------------------------------------------------------------------

मित्रम् : Naya
मित्रम् = rewriter

विग्नरः : Naya
विग्नरः = kernel-refl

-- the two are genuinely distinct observers (SaptabhangiNaya's theorem)
मित्र-विग्नर-भेदः : ¬ (मित्रम् ≡ विग्नरः)
मित्र-विग्नर-भेदः = rewriter≢refl

------------------------------------------------------------------------
-- §2  The friend has a fact and Wigner has its denial, and the JOINT of
-- the two relative facts is realised: the Wigner situation exists.
------------------------------------------------------------------------

विग्नर-अवस्था : Σ[ φ ∈ Profile ] (joint φ ≡ true)
विग्नर-अवस्था = joint-realised

------------------------------------------------------------------------
-- §3  THE NO-GO, as the sevenfold already holds it: no single
-- standpointed utterance denotes the joint on all profiles.  Promoting
-- either agent's relative fact to an absolute one — the step every
-- Wigner's-friend contradiction runs through — demands such an
-- utterance.  There is none; the demand, not the relativity, is the
-- defect.
------------------------------------------------------------------------

निरपेक्ष-निषेधः : (v : Vacana)
              → Σ[ φ ∈ Profile ] (¬ (denotes v φ ≡ joint φ))
निरपेक्ष-निषेधः = no-single-vacana

------------------------------------------------------------------------
-- §4  THE RESOLUTION, as the sevenfold already holds it: two utterances
-- in succession denote the joint exactly.  Comparison is a further
-- interaction, performed in krama — and it loses nothing.
------------------------------------------------------------------------

सम्प्रेषण-क्रमः : (φ : Profile)
  → joint φ ≡ (denotes (asti-from मित्रम्) φ and denotes (nasti-from विग्नरः) φ)
सम्प्रेषण-क्रमः = krama-expresses
