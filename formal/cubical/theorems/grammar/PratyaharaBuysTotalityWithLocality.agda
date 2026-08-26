{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PratyaharaBuysTotalityWithLocality
--
-- CORRECTION TO `AnuvrttiIsTheSameTrade`.
--
-- That module classified Pāṇini's four devices two and two, LOCAL
-- against NON-LOCAL, and put प्रत्याहार in the local column with the
-- remark that "for the local pair there is nothing to prove — no extra
-- argument appears, so none must be eliminated".  It then named as open
-- "whether the local pair is local UNCONDITIONALLY", guessing the
-- difficulty was locality.
--
-- The difficulty is not locality, and प्रत्याहार is not in that column.
--
-- ────────────────────────────────────────────────────────────────────
-- TWO COSTS, NOT ONE
--
-- A naming scheme can fail in two independent ways:
--
--   TOTALITY   some needed set has no name at all;
--   LOCALITY   some name denotes more than one set, so the name does not
--              determine what it names.
--
-- `Pratyahara` studies totality and only totality:
-- `no-order-makes-all-intervals` says a three-letter order always leaves
-- one pair unnameable, and `one-repetition-suffices` says `x y z x`
-- repairs it.  Neither statement is about locality, and the earlier
-- classification silently assumed the repair was free.
--
-- It is not.  **The repetition that buys totality destroys locality.**
--
-- ────────────────────────────────────────────────────────────────────
-- THE COLLISION, WHICH IS THE अण् PROBLEM
--
-- A प्रत्याहार is named by its first letter and its अनुबन्ध.  In
-- `x y z x` the letter `x` occurs twice, so the name `(x , x)` is borne
-- by two different runs:
--
--     the run [x] at position 0        denoting  {x}
--     the run [x,y,z,x] positions 0–3  denoting  {x,y,z}
--
-- Same name, different sets.  So
--
--     pratyahara-naming-does-not-factor : ¬ FactorsThrough nameOf setOf
--
-- This is the smallest instance of the ambiguity the commentators argue
-- about at अण्, whose ण् is an अनुबन्ध in both the first शिवसूत्र
-- (अ इ उ ण्) and the sixth (ल ण्), so that अण् denotes three vowels in
-- some rules and vowels-plus-semivowels in others.  The ambiguity is not
-- a blemish on an otherwise clean scheme; it is what the scheme paid for
-- being able to name everything.
--
-- ────────────────────────────────────────────────────────────────────
-- SO THE SPLIT IS THREE–ONE, NOT TWO–TWO
--
--     अपवाद       local, total                       nothing to buy
--     प्रत्याहार    total at the cost of locality       §3
--     अनुवृत्ति     non-local, buys brevity            AnuvrttiIsTheSameTrade
--     असिद्धत्व     non-local, buys a distinction      AsiddhatvaBreaksFactoring
--
-- Three of the four devices are non-local and each pays for something
-- different.  Only अपवाद is free, and it is the only one of the four
-- that adds no expressive power — it selects between rules that were
-- already there.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT CLAIMED
--
-- CLAIMED: at three letters, a repetition-free order is not total
-- (`Pratyahara`) and the repeating order `x y z x` is not local (§3).
--
-- NOT CLAIMED: that no scheme achieves both.  That would need a search
-- over orders and naming conventions this module does not run, and
-- Pāṇini's own answer is a CONVENTION (which run is meant is fixed by
-- other sūtras), not a better order — which is itself evidence the trade
-- is real, since a grammar of लाघव would have taken a better order if
-- one existed.  Named, not estimated.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module PratyaharaBuysTotalityWithLocality where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import FiniteInformation using (FactorsThrough)
open import AnyonyaAbhava using (Anyonya ; anyonya→samsarga)
open import Pratyahara using (L ; x ; y ; z ; Set₃)

------------------------------------------------------------------------
-- 1.  The runs of the repeating order `x y z x`
--
-- Only the two that collide are needed; the rest are the same idea and
-- would add cases without adding evidence.
------------------------------------------------------------------------

data Run : Type₀ where
  atZero : Run          -- [x]            positions 0–0
  whole  : Run          -- [x, y, z, x]   positions 0–3

-- what a run is called: its first letter and its अनुबन्ध (its last)
nameOf : Run → L × L
nameOf atZero = x , x
nameOf whole  = x , x

-- what a run denotes
setOf : Run → Set₃
setOf atZero x = true
setOf atZero y = false
setOf atZero z = false
setOf whole  _ = true

------------------------------------------------------------------------
-- 2.  The two runs are named alike and denote differently
------------------------------------------------------------------------

same-name : nameOf atZero ≡ nameOf whole
same-name = refl

-- they differ at `y`: the singleton excludes it, the whole run has it
different-set : Anyonya (setOf atZero) (setOf whole)
different-set e = false≢true (cong (λ s → s y) e)

------------------------------------------------------------------------
-- 3.  SO NAMING DOES NOT FACTOR — locality fails
------------------------------------------------------------------------

pratyahara-naming-does-not-factor : ¬ FactorsThrough nameOf setOf
pratyahara-naming-does-not-factor =
  anyonya→samsarga nameOf setOf
    {x = atZero} {x' = whole}
    same-name
    different-set

------------------------------------------------------------------------
-- 4.  And the totality failure it repairs is `Pratyahara`'s own
--
-- Imported rather than restated, so the trade is between two checked
-- facts in two modules and not between a fact and a paraphrase.
------------------------------------------------------------------------

open import Pratyahara
  using (Ord ; Pair ; isInterval ; no-order-makes-all-intervals)

-- every repetition-free three-letter order leaves some pair unnameable
totality-fails-without-repetition :
  (o : Ord) → Σ[ p ∈ Pair ] (isInterval o p ≡ false)
totality-fails-without-repetition = no-order-makes-all-intervals

------------------------------------------------------------------------
-- 5.  The trade, as two facts
--
--   without repetition:  local, not total   (§4)
--   with repetition:     total, not local   (§3)
--
-- Pāṇini takes the second and pays with a convention.  That choice is
-- the evidence that the trade is real: a grammar built for लाघव does not
-- accept an ambiguity it could order its way out of.
------------------------------------------------------------------------

the-trade :
    ((o : Ord) → Σ[ p ∈ Pair ] (isInterval o p ≡ false))
  × (¬ FactorsThrough nameOf setOf)
the-trade = totality-fails-without-repetition , pratyahara-naming-does-not-factor

------------------------------------------------------------------------
-- 6.  What this does to the standing लाघव thread.
--
-- `AnuvrttiIsTheSameTrade` concluded that a measure on presentations is
-- stable under the local devices and not under अनुवृत्ति.  With
-- प्रत्याहार moved out of the local column, the conclusion sharpens and
-- shrinks: the only device a measure is stable under is अपवाद, and
-- अपवाद is the only one that buys nothing.
--
-- That is close to saying the standing thread's question answers itself.
-- A measure stable under every device that changes the presentation is a
-- measure that cannot see what the devices are for.  The three that do
-- something are exactly the three it cannot survive.
--
-- OPEN, named and not estimated: whether some order and naming
-- convention achieves totality and locality together at three letters.
-- §5 does not settle it and Pāṇini's recourse to convention is evidence
-- rather than proof.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  THE अण् CLAIM IS NOW CHECKED, appended 2026-08-18.
--
-- §"THE COLLISION" above asserts from memory that the toy order
-- `x y z x` models the ambiguity at अण्, "whose ण् is an अनुबन्ध in both
-- the first शिवसूत्र and the sixth".
--
-- `TheSecondNaIsTheCollision` encodes the first six
-- सूत्राणि and computes both readings:
--
--     collect 0 sivasutra6 ≡ a i u                                 refl
--     collect 1 sivasutra6 ≡ a i u ṛ ḷ e o ai au h y v r l          refl
--
-- and `aṆ-does-not-factor` is the collision, at the actual list rather
-- than at a three-letter model.  So the toy was faithful — worth knowing,
-- since a toy that models nothing is only a toy.
--
-- Found on the way, and not a defect: `Sivasutra.upto` stops at the
-- first matching अनुबन्ध, which is exactly right for the four सूत्राणि
-- that file encodes and silently selects the narrow reading past them.
-- A convention invisible at the scope where it is introduced — the same
-- shape as everything else in this thread.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  PRIOR ART NOT SEARCHED, recorded on reading
--
-- §5 above names as open: "whether some order and naming convention
-- achieves totality and locality together at three letters", and adds
-- that Pāṇini's recourse to convention is evidence rather than proof.
--
-- There is a theorem in this neighbourhood and I did not look for it:
--
--   Petersen 2004, *A Mathematical Analysis of Pāṇini's Śivasūtras*,
--   Journal of Logic, Language and Information 13:471–489 — proves the
--   OPTIMALITY of Pāṇini's ordering for his family, from the Hasse
--   diagram of the intersection-closure alone, with no phonological
--   input.
--
-- this page that is already a proved statement of the kind this repo
-- demands", and that map was in the repository before I wrote either
-- pratyāhāra module.
--
-- Whether Petersen settles §5's open item I do not know: his theorem is
-- about optimality of an ordering for a given family, and §5 asks about
-- the totality/locality trade-off, which is a different quantity.  The
-- paper is not reachable from this container.  But the item should have
-- been posed against the citation from the start rather than as though
-- the ground were clear, and CLAUDE.md's rule is that prior art is
-- searched BEFORE the write-up.
--
-- The §3 collision stands: it is a computation about `x y z x`, and
-- `TheSecondNaIsTheCollision` realises it at the actual शिवसूत्राणि.
-- What is corrected is the framing of the open item, not a theorem.
------------------------------------------------------------------------
