{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पर्यायशब्दौ — TWO NAMES FOR ONE PARITY SECTOR, AND THE CARRY.
--
-- THE TERM, ITS TEXT AND ITS DATE.  पर्यायशब्द (paryāya-śabda) is the
-- ordinary grammatical/lexicographical term for words that denote ONE
-- and the same object — synonyms with a common referent.  The whole of
-- Amarasiṃha's *Nāmaliṅgānuśāsana* (the Amarakośa, ~6th c. CE) is built
-- as a thesaurus of paryāya, grouping co-referential names; the Nyāya
-- and Vyākaraṇa traditions use the term in the same plain sense.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  पर्यायशब्द is used here ONLY
-- in that plain sense — two distinct names, one referent — and is NOT
-- offered as a source term for any theorem below.  No lexicographer or
-- grammarian proved anything here, and nothing here interprets the
-- Amarakośa.  The mathematics is cubical type theory (Voevodsky's
-- univalence — this repository's one admitted non-Indian substrate);
-- the two functions and the theorem carried between them are the
-- agda/cubical library's and this corpus's own modules'.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT WAS OPEN.  This corpus encodes the ℤ/2 PARITY SUPERSELECTION
-- SECTOR — the "charge mod 2" whose neutral half is the parity barrier —
-- TWICE, in two modules that never meet:
--
--   ParitySeparator.sgn  : ℕ → Bool   (the sieve barrier)
--       sgn zero = true ; sgn (suc n) = not (sgn n)
--       group operation `_·_` : true · b = b ; false · b = not b
--
--   ChargeGrading.parity : ℕ → Bool   (the charge grading)
--       parity zero = true ; parity 1 = false ; parity (2+n) = parity n
--       group operation `xor` : xor true b = b ; xor false b = not b
--
-- These are पर्यायशब्दौ: two names, one object — the parity character
-- (-1)^n and the group {±1} = ℤ/2 it lands in.  But they are two
-- DISTINCT terms: the recursions differ (one-step vs two-step), so
-- `sgn m` and `parity m` do not reduce to a common form at a variable
-- m, and the two `_·_`/`xor` are two functions.  Nothing in the
-- repository joined them, and — exactly as in
-- `Bhedanirnaya_…` — the two modules do NOT hold the same theorems:
--
--   * ChargeGrading proved the CHARACTER LAW (T15.27, `parity-shift`):
--         parity (m + n) ≡ xor (parity m) (parity n).
--   * ParitySeparator names its `sgn` a "completely multiplicative ±1
--     function" in prose (its header, §THE STATEMENT) but never proved
--     the additive form  sgn (m + n) ≡ sgn m · sgn n  about `sgn`
--     itself; it proves only `flip-law` about the gauge ACTION.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE.
--
-- §१  the two names are one function:  sgn ≡ parity  (a path, `A ≡ B`).
-- §२  the two group operations are one:  _·_ ≡ xor.
-- §३  सङ्क्रमः — the CARRY.  Packaging the character law as a predicate
--     `char-law f op`, ChargeGrading's `parity-shift` IS `char-law
--     parity xor`, and `subst2` transports it along §१ and §२ to give
--         char-law sgn _·_ ,  i.e.  sgn (m + n) ≡ sgn m · sgn n
--     — the multiplicativity ParitySeparator asserted in prose and never
--     proved, obtained with NO new induction.  The carry pays (Ahiṃsā
--     §६: an identification is a channel; theorems flow along it).
--
-- WHAT IS NOT PROVED.  Nothing about sieves, Goldbach, twin primes,
-- winding, or gauge theory beyond what the two imported modules already
-- hold.  Not claimed: that `sgn`/`parity` is novel, or that the ℤ→ℤ/2
-- projection framing (ChargeGrading D15.26) originates here.  What is
-- new is only the JOIN and the carried theorem.
--
-- CHECKED: Agda 2.6.3+ / agda/cubical, --cubical --safe, no postulates,
-- no holes, no sorry.  Written 2026-08-22.
------------------------------------------------------------------------

module Paryayasabda_TwoNamesForTheParitySectorAndTheCharacterLawCarriesAcrossBetweenThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)

import ParitySeparator as PS
import ChargeGrading   as CG

------------------------------------------------------------------------
-- ० ── notnot, the one library fact used pointwise.
------------------------------------------------------------------------

notnot : (b : Bool) → not (not b) ≡ b
notnot true  = refl
notnot false = refl

------------------------------------------------------------------------
-- १ ── पर्यायशब्दौ — THE TWO NAMES ARE ONE FUNCTION.
--
-- `parity` steps by two, `sgn` by one; joining them needs the one-step
-- law of `parity`, which ChargeGrading uses internally but never states.
------------------------------------------------------------------------

-- the one-step law of the two-step `parity`.
parity-suc : (n : ℕ) → CG.parity (suc n) ≡ not (CG.parity n)
parity-suc zero          = refl
parity-suc (suc zero)    = refl
parity-suc (suc (suc n)) = parity-suc n

-- pointwise, then as a path between the two names.
sgn≡parity-pt : (n : ℕ) → PS.sgn n ≡ CG.parity n
sgn≡parity-pt zero    = refl
sgn≡parity-pt (suc n) =
  cong not (sgn≡parity-pt n) ∙ sym (parity-suc n)

नामैक्यम् : PS.sgn ≡ CG.parity
नामैक्यम् = funExt sgn≡parity-pt

------------------------------------------------------------------------
-- २ ── THE TWO GROUP OPERATIONS ARE ONE.
--
-- Both case on the first argument with identical clauses, so equality is
-- by two `refl`s under funext.
------------------------------------------------------------------------

·≡xor-pt : (a b : Bool) → PS._·_ a b ≡ CG.xor a b
·≡xor-pt true  b = refl
·≡xor-pt false b = refl

क्रियैक्यम् : PS._·_ ≡ CG.xor
क्रियैक्यम् = funExt (λ a → funExt (λ b → ·≡xor-pt a b))

------------------------------------------------------------------------
-- ३ ── सङ्क्रमः — THE CARRY.
--
-- The character law as a predicate on a name and its group operation.
------------------------------------------------------------------------

char-law : (ℕ → Bool) → (Bool → Bool → Bool) → Type
char-law f op = (m n : ℕ) → f (m + n) ≡ op (f m) (f n)

-- ChargeGrading's T15.27 IS `char-law parity xor`, verbatim.
parity-is-char : char-law CG.parity CG.xor
parity-is-char = CG.parity-shift

-- transport it along §१ and §२ onto `sgn` and `_·_`.  No new induction.
sgn-is-char : char-law PS.sgn PS._·_
sgn-is-char = subst2 char-law (sym नामैक्यम्) (sym क्रियैक्यम्) parity-is-char

-- the theorem ParitySeparator asserted in prose and never proved, now
-- standing about its own `sgn` and its own `_·_`:
सम्पूर्ण-गुणनम् : (m n : ℕ) → PS.sgn (m + n) ≡ PS._·_ (PS.sgn m) (PS.sgn n)
सम्पूर्ण-गुणनम् = sgn-is-char
