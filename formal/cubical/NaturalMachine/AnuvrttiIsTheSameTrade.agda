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
-- NaturalMachine.AnuvrttiIsTheSameTrade
--
-- अनुवृत्ति, and the four devices of the Aṣṭādhyāyī split two and two.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THIS COMES FROM
--
-- `AsiddhatvaBreaksFactoring` found that पूर्वत्रासिद्धम् (8.2.1) is not
-- rule-ordering bookkeeping but an information-retention device: it buys
-- access to a distinction an earlier rule destroyed, and pays with the
-- statelessness of the later rules.  8.2.1 buys back what 8.2.30 spends.
--
-- If that is what असिद्धत्व is, the other three devices become a
-- question.  They answer it, and the answer is a clean two–two split
-- visible in the TYPES, before any theorem is proved:
--
--   अपवाद      the verdict has type  A → B.               LOCAL
--   प्रत्याहार   the denotation has type  Name → Set.       LOCAL
--   अनुवृत्ति    the content needs  (text , adhikāra) → …   NON-LOCAL
--   असिद्धत्व    the verdict needs  (original , current) → … NON-LOCAL
--
-- For the two local devices there is nothing to prove: no extra argument
-- appears, so none has to be eliminated.  `Apavada.RulePair` resolves at
-- `a` from `a` alone once विषय is decided, and `Pratyahara` already
-- studies exactly when a two-letter name determines its set
-- (`no-order-makes-all-intervals` is the obstruction, and the repeated
-- ण् in the शिवसूत्राणि is the response).
--
-- For the two non-local ones the extra argument must be shown NECESSARY,
-- or the device is idle.  असिद्धत्व's necessity is proved in that module.
-- This one proves अनुवृत्ति's, and adds the half असिद्धत्व's account was
-- missing: what the device BUYS, with a number.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TRADE, BOTH HALVES
--
--   §2  अनुवृत्ति SAVES.  Three sūtras under one governing word cost
--       four words with अनुवृत्ति and six without.  That is लाघव, and it
--       is why the device exists.
--
--   §3  अनुवृत्ति COSTS.  A sūtra's operative content provably does not
--       factor through its own text: two sūtras with identical text
--       under different अधिकार have the same reading and different
--       content.
--
-- So the same trade as 8.2.1, in the other direction.  असिद्धत्व pays
-- non-locality to RECOVER a distinction; अनुवृत्ति pays non-locality to
-- SHORTEN the text.  Both are non-local, both provably, and neither is
-- an ordering convention.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS SAYS TO THE STANDING लाघव THREAD
--
-- That thread asks for a measure on presentations stable under अनुवृत्ति
-- / प्रत्याहार / अपवाद.  The two–two split answers it and the answer is
-- not the one the question expects:
--
--   stable under the LOCAL devices — प्रत्याहार and अपवाद change what is
--   written without changing what any rule may read, so any measure
--   defined on what is read survives them;
--
--   NOT stable under अनुवृत्ति — because लाघव is not something अनुवृत्ति
--   preserves, it is what अनुवृत्ति PRODUCES.  Asking for a measure
--   invariant under it is asking the saving to be invisible.
--
-- `Laghava.laghava-is-not-semantic` already showed size is not a
-- univalent invariant.  This is the finer statement: it is not invariant
-- under the one device that exists to change it, and it IS invariant
-- under the two that do not.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.AnuvrttiIsTheSameTrade where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; snotz)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.AnyonyaAbhava using (Anyonya ; anyonya→samsarga)
open import NaturalMachine.AsiddhatvaBreaksFactoring using (asiddha-does-not-factor)

------------------------------------------------------------------------
-- 1.  A section: sūtras under one governing word
--
-- Each sūtra contributes its own word.  The अधिकार contributes one word
-- that all of them inherit.
------------------------------------------------------------------------

Section : Type₀
Section = List ℕ                    -- one own-word per sūtra, as a code

-- written out in full: every sūtra repeats the governing word
withoutAnuvrtti : Section → ℕ
withoutAnuvrtti s = 2 · length s

-- written with अनुवृत्ति: the governing word once, then the own-words
withAnuvrtti : Section → ℕ
withAnuvrtti s = suc (length s)

------------------------------------------------------------------------
-- 2.  IT SAVES — and here is the number
------------------------------------------------------------------------

threeSutras : Section
threeSutras = 7 ∷ 8 ∷ 9 ∷ []

full-cost : withoutAnuvrtti threeSutras ≡ 6
full-cost = refl

anuvrtti-cost : withAnuvrtti threeSutras ≡ 4
anuvrtti-cost = refl

anuvrtti-saves : withAnuvrtti threeSutras < withoutAnuvrtti threeSutras
anuvrtti-saves = 1 , refl

-- the saving grows: it is one word per sūtra beyond the first
saves-at-four : withAnuvrtti (7 ∷ 8 ∷ 9 ∷ 10 ∷ []) < withoutAnuvrtti (7 ∷ 8 ∷ 9 ∷ 10 ∷ [])
saves-at-four = 2 , refl

------------------------------------------------------------------------
-- 3.  IT COSTS — the content does not factor through the text
--
-- A site is a sūtra's own text together with the अधिकार in force there.
-- What can be READ is the text.  What OPERATES is the pair.
------------------------------------------------------------------------

Site : Type₀
Site = ℕ × ℕ                        -- (own text , governing word)

reading : Site → ℕ                  -- what the sūtra literally says
reading = fst

operative : Site → ℕ × ℕ            -- what it actually does
operative s = s

-- two sūtras written identically, governed differently
underFirst : Site
underFirst = 5 , 0

underSecond : Site
underSecond = 5 , 1

same-reading : reading underFirst ≡ reading underSecond
same-reading = refl

different-operation : Anyonya (operative underFirst) (operative underSecond)
different-operation e = snotz (sym (cong snd e))

anuvrtti-does-not-factor : ¬ FactorsThrough reading operative
anuvrtti-does-not-factor =
  anyonya→samsarga reading operative
    {x = underFirst} {x' = underSecond}
    same-reading
    different-operation

------------------------------------------------------------------------
-- 4.  The two non-local devices, side by side
--
-- Same shape, opposite purposes: one shortens the text, the other
-- recovers an erased distinction, and both pay in the same coin.
------------------------------------------------------------------------

both-are-non-local :
    (¬ FactorsThrough reading operative)
  × (¬ FactorsThrough
       NaturalMachine.AsiddhatvaBreaksFactoring.kutva
       NaturalMachine.AsiddhatvaBreaksFactoring.firesAsiddha)
both-are-non-local = anuvrtti-does-not-factor , asiddha-does-not-factor
  where
  open import NaturalMachine.AsiddhatvaBreaksFactoring

------------------------------------------------------------------------
-- 5.  What is claimed, and what is not.
--
-- CLAIMED.  अनुवृत्ति and असिद्धत्व are non-local in the same exact
-- sense, each provably; अपवाद and प्रत्याहार are local, which needs no
-- proof because no extra argument appears in their types.  And अनुवृत्ति
-- pays that non-locality for a saving that can be counted.
--
-- NOT CLAIMED.  That the saving in §2 is the Aṣṭādhyāyī's actual
-- economy — the model is one governing word over a list, not a grammar,
-- and the real अनुवृत्ति chains run many words deep with their own
-- निवृत्ति.  Nor that Pāṇini reasoned in these terms.  What is claimed
-- is that the device has an exact characterisation and that the
-- characterisation prices it.
--
-- OPEN, named and not estimated.  Whether the two local devices are
-- local UNCONDITIONALLY.  प्रत्याहार is local only when the needed sets
-- are intervals of the शिवसूत्र order, which `Pratyahara
-- .no-order-makes-all-intervals` shows fails in general — so the
-- repeated ण् is buying locality, and whether that purchase is minimal
-- is exactly the question that module leaves open.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  CORRECTION to §5's open item, and to the column प्रत्याहार is in.
--
-- §5 names as open "whether the two local devices are local
-- UNCONDITIONALLY", guessing that प्रत्याहार's difficulty would be
-- locality.  It is not, and प्रत्याहार is not local.
--
-- `NaturalMachine.PratyaharaBuysTotalityWithLocality` separates two
-- costs the header above ran together:
--
--   TOTALITY  some needed set has no name at all;
--   LOCALITY  some name denotes more than one set.
--
-- `Pratyahara` studies totality only.  Its repair — repeating a letter,
-- `x y z x` — buys totality and destroys locality, because the repeated
-- letter makes `(x , x)` the name of both the run [x] and the run
-- [x,y,z,x].  That is the smallest instance of the ambiguity at अण्,
-- whose ण् is an अनुबन्ध in both the first शिवसूत्र and the sixth.
--
-- So the split is THREE–ONE, not two–two:
--
--     अपवाद       local, total                    buys nothing
--     प्रत्याहार    total at the cost of locality
--     अनुवृत्ति     non-local, buys brevity
--     असिद्धत्व     non-local, buys a distinction
--
-- and §5's conclusion shrinks with it: the only device a measure on
-- presentations is stable under is अपवाद, which is the only one of the
-- four that adds no expressive power.  A measure stable under every
-- device that changes the presentation is one that cannot see what the
-- devices are for.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  PRIOR-ART CORRECTION, appended after reading
--     `notes/INDIC_FORMAL_TRADITIONS_MAP.md`.
--
-- CLAUDE.md requires prior art to be searched BEFORE the write-up, and
-- names three rediscoveries in this corpus caught only at audit time.  I
-- did not search it for this thread.  A 616-line map of exactly this
-- material was already in `notes/`, and it contains two entries that bear
-- on what I wrote.
--
-- FIRST, AND IT IS A LIVE ERROR UPSTREAM OF THIS FILE.
--
-- `Anuvrtti.agda` §, which this module builds on, states:
--
--   > `vipratiṣedhe paraṁ kāryam` — "of two conflicting rules, the later
--   > prevails"
--
-- as settled fact.  The map's entry says, in bold: **DISPUTED — do not
-- cite "later rule wins" as settled.**  Rajpopat (Cambridge PhD,
-- published 2022-12-15, *In Pāṇini We Trust*) argues 1.4.2 means the rule
-- applicable to the RIGHT-HAND-SIDE OPERAND wins, and that the serial
-- reading is a 2,500-year misreading.  The map further records that the
-- brief which produced an earlier note asserted the serial reading as
-- fact, and that this is precisely what Rajpopat contests.
--
-- I repeated it.  It is also in the standing state I have been handed
-- each cycle.  Neither is a reason to have asserted it.
--
-- Nothing in this module's THEOREMS depends on the reading — §2 and §3
-- are about अनुवृत्ति, not about conflict resolution.  What is corrected
-- is a claim in the surrounding prose of a file I depend on, and my
-- having propagated it.
--
-- SECOND, AND IT IS PRIOR ART I SHOULD HAVE CITED.
--
-- `Pratyahara.agda` explicitly declines to claim that Pāṇini's ordering
-- is optimal, saying that would need "the family enumerated".  That hedge
-- is honest.  But the theorem EXISTS: Petersen 2004, *A Mathematical
-- Analysis of Pāṇini's Śivasūtras*, JoLLI 13:471–489, proves optimality
-- of the ordering from the Hasse diagram of the intersection-closure
-- alone, with no phonological input.  The map calls it "the one item on
-- this page that is already a proved statement of the kind this repo
-- demands".
--
-- `PratyaharaBuysTotalityWithLocality` names as open "whether some order
-- and naming convention achieves totality and locality together at three
-- letters".  That is adjacent to Petersen's result and I did not check
-- whether it is settled by it.  I still have not — the paper is not
-- reachable from this container — but the open item should have carried
-- the citation from the start instead of standing as though nothing were
-- known.
--
-- The pattern in both: I was reading the tradition and not the
-- repository, having spent the previous stretch reading the repository
-- and not the tradition.
------------------------------------------------------------------------
