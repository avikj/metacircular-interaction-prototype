{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡∞‡‡Ø‡æ‡Ø‡‡‡‡¶‡ ‚î TWO NAMES FOR ONE PARITY SECTOR, AND THE CARRY.
--
-- THE TERM, ITS TEXT AND ITS DATE.  ‡‡∞‡‡Ø‡æ‡Ø‡‡‡‡¶ (paryya-abda) is the
-- ordinary grammatical/lexicographical term for words that denote ONE
-- and the same object ‚î synonyms with a common referent.  The whole of
-- Amarasiha's *Nmalignusana* (the Amarakoa, ~6th c. CE) is built
-- as a thesaurus of paryya, grouping co-referential names; the Nyya
-- and Vykaraa traditions use the term in the same plain sense.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TWO ENCODINGS.  This corpus encodes the ‚/2 PARITY SUPERSELECTION
-- SECTOR ‚î the "charge mod 2" whose neutral half is the parity barrier ‚î
-- TWICE, in two modules that never meet:
--
--   ParitySeparator.sgn  : ‚ï ‚í Bool   (the sieve barrier)
--       sgn zero = true ; sgn (suc n) = not (sgn n)
--       group operation `_¬_` : true ¬ b = b ; false ¬ b = not b
--
--   ChargeGrading.parity : ‚ï ‚í Bool   (the charge grading)
--       parity zero = true ; parity 1 = false ; parity (2+n) = parity n
--       group operation `xor` : xor true b = b ; xor false b = not b
--
-- These are ‡‡∞‡‡Ø‡æ‡Ø‡‡‡‡¶‡: two names, one object ‚î the parity character
-- (-1)^n and the group {¬1} = ‚/2 it lands in.  But they are two
-- DISTINCT terms: the recursions differ (one-step vs two-step), so
-- `sgn m` and `parity m` do not reduce to a common form at a variable
-- m, and the two `_¬_`/`xor` are two functions.  Nothing in the
-- repository joined them, and ‚î exactly as in
-- `Bhedanirnaya_‚¶` ‚î the two modules do NOT hold the same theorems:
--
--   * ChargeGrading proved the CHARACTER LAW (T15.27, `parity-shift`):
--         parity (m + n) ‚â° xor (parity m) (parity n).
--   * ParitySeparator names its `sgn` a "completely multiplicative ¬1
--     function" in prose (its header, ¬ßTHE STATEMENT) but never proved
--     the additive form  sgn (m + n) ‚â° sgn m ¬ sgn n  about `sgn`
--     itself; it proves only `flip-law` about the gauge ACTION.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED HERE.
--
-- ¬ß‡ß  the two names are one function:  sgn ‚â° parity  (a path, `A ‚â° B`).
-- ¬ß‡®  the two group operations are one:  _¬_ ‚â° xor.
-- ¬ß‡©  ‡‡ô‡‡ï‡‡∞‡Æ‡ ‚î the CARRY.  Packaging the character law as a predicate
--     `char-law f op`, ChargeGrading's `parity-shift` IS `char-law
--     parity xor`, and `subst2` transports it along ¬ß‡ß and ¬ß‡® to give
--         char-law sgn _¬_ ,  i.e.  sgn (m + n) ‚â° sgn m ¬ sgn n
--     ‚î the multiplicativity ParitySeparator asserted in prose and never
--     proved, obtained with NO new induction.  The carry pays (Ahis
--     ¬ß‡: an identification is a channel; theorems flow along it).
------------------------------------------------------------------------

module Paryayasabda_TwoNamesForTheParitySectorAndTheCharacterLawCarriesAcrossBetweenThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)

import ParitySeparator as PS
import ChargeGrading   as CG

------------------------------------------------------------------------
-- ‡¶ ‚î‚î notnot, the one library fact used pointwise.
------------------------------------------------------------------------

notnot : (b : Bool) ‚Üí not (not b) ‚â° b
notnot true  = refl
notnot false = refl

------------------------------------------------------------------------
-- ‡ß ‚î‚î ‡‡∞‡‡Ø‡æ‡Ø‡‡‡‡¶‡ ‚î THE TWO NAMES ARE ONE FUNCTION.
--
-- `parity` steps by two, `sgn` by one; joining them needs the one-step
-- law of `parity`, which ChargeGrading uses internally but never states.
------------------------------------------------------------------------

-- the one-step law of the two-step `parity`.
parity-suc : (n : ‚Ñï) ‚Üí CG.parity (suc n) ‚â° not (CG.parity n)
parity-suc zero          = refl
parity-suc (suc zero)    = refl
parity-suc (suc (suc n)) = parity-suc n

-- pointwise, then as a path between the two names.
sgn‚â°parity-pt : (n : ‚Ñï) ‚Üí PS.sgn n ‚â° CG.parity n
sgn‚â°parity-pt zero    = refl
sgn‚â°parity-pt (suc n) =
  cong not (sgn‚â°parity-pt n) ‚àô sym (parity-suc n)

‡§®‡§æ‡§Æ‡•à‡§ï‡•ç‡§Ø‡§Æ‡•ç : PS.sgn ‚â° CG.parity
‡§®‡§æ‡§Æ‡•à‡§ï‡•ç‡§Ø‡§Æ‡•ç = funExt sgn‚â°parity-pt

------------------------------------------------------------------------
-- ‡® ‚î‚î THE TWO GROUP OPERATIONS ARE ONE.
--
-- Both case on the first argument with identical clauses, so equality is
-- by two `refl`s under funext.
------------------------------------------------------------------------

¬∑‚â°xor-pt : (a b : Bool) ‚Üí PS._¬∑_ a b ‚â° CG.xor a b
¬∑‚â°xor-pt true  b = refl
¬∑‚â°xor-pt false b = refl

‡§ï‡•ç‡§∞‡§ø‡§Ø‡•à‡§ï‡•ç‡§Ø‡§Æ‡•ç : PS._¬∑_ ‚â° CG.xor
‡§ï‡•ç‡§∞‡§ø‡§Ø‡•à‡§ï‡•ç‡§Ø‡§Æ‡•ç = funExt (Œª a ‚Üí funExt (Œª b ‚Üí ¬∑‚â°xor-pt a b))

------------------------------------------------------------------------
-- ‡© ‚î‚î ‡‡ô‡‡ï‡‡∞‡Æ‡ ‚î THE CARRY.
--
-- The character law as a predicate on a name and its group operation.
------------------------------------------------------------------------

char-law : (‚Ñï ‚Üí Bool) ‚Üí (Bool ‚Üí Bool ‚Üí Bool) ‚Üí Type
char-law f op = (m n : ‚Ñï) ‚Üí f (m + n) ‚â° op (f m) (f n)

-- ChargeGrading's T15.27 IS `char-law parity xor`, verbatim.
parity-is-char : char-law CG.parity CG.xor
parity-is-char = CG.parity-shift

-- transport it along ¬ß‡ß and ¬ß‡® onto `sgn` and `_¬_`.  No new induction.
sgn-is-char : char-law PS.sgn PS._¬∑_
sgn-is-char = subst2 char-law (sym ‡§®‡§æ‡§Æ‡•à‡§ï‡•ç‡§Ø‡§Æ‡•ç) (sym ‡§ï‡•ç‡§∞‡§ø‡§Ø‡•à‡§ï‡•ç‡§Ø‡§Æ‡•ç) parity-is-char

-- the theorem ParitySeparator asserted in prose and never proved, now
-- standing about its own `sgn` and its own `_¬_`:
‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£-‡§ó‡•Å‡§£‡§®‡§Æ‡•ç : (m n : ‚Ñï) ‚Üí PS.sgn (m + n) ‚â° PS._¬∑_ (PS.sgn m) (PS.sgn n)
‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£-‡§ó‡•Å‡§£‡§®‡§Æ‡•ç = sgn-is-char
