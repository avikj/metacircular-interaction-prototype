{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Ø‡Æ‡‡ ‚î ‡‡‡‡‡Ø‡ ‡‡∞‡‡ï‡‡‡ï‡ ‡ó‡‡®‡Ø‡æ ‡≤‡‡‡ß‡ ; ‡‡‡‡‡®‡æ ‡‡‡®‡∞‡æ‡µ‡‡‡‡‡ø‡ ‡‡‡∞‡‡‡‡æ ‡ ‡¶‡‡Ø‡‡‡ ‡
--
-- (twins: a third tester, found by census, and the channel pays it
--  reflexivity and completeness.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS, AND IT IS SOMEONE ELSE'S METHOD APPLIED TO A PAIR THEY
-- COULD NOT FIND.
--
-- `Bhedanirnaya_TwoTestersForSamenessOnNumberAndTheTransportThatMoves
-- TheoremsBetweenThem.agda` identified `ResidueGlue.eq‚ï` with
-- `Obstruction.eq‚ï` ‚î two modules that had each written
-- the same four clauses, whose theorems PRINT alike and are NOT the same
-- type, since the two `eq‚ï` do not reduce to a common form at variable
-- arguments.  Its sentence is the reason to do this at all:
--
--     "A duplication that has been identified is not merely tidier ‚î it is
--      a CHANNEL, and theorems flow both ways along it."
--
-- And its ¬ß‡ says what it could not do: "the pattern generalises and is
-- not generalised‚¶ a question for the audit tool, which currently reports
-- only same-PRINTED-type groups and would miss a pair whose definitions
-- agree under different names."
--
-- That audit now exists ‚î `interactive/Pratyaksa_‚¶hs --twins`, which erases
-- each declaration's own module prefix from its KERNEL-ELABORATED type and
-- groups ‚î and the first thing it returned was a THIRD `eq‚ï`:
--
--     Alopa_TheEngineNeverTouchesTheMeaning.eq‚ï-sound
--     Obstruction.eq‚ï‚í‚â°
--
-- neither of which Bhedanirnaya mentions.  This is that pair, opened.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THE CHANNEL PAYS, and the ledger was lopsided exactly as
-- Bhedanirnaya predicted ‚î each module proved the half its own question
-- required and no more:
--
--   Alopa       holds  eq‚ï-sound.                   And nothing else.
--   Obstruction holds  eq‚ï-refl, eq‚ï‚í‚â°, ‚â‚íeq‚ï-false.
--
-- Alopa's engine tests names for equality while rewriting; it never needed
-- to trust a NEGATIVE answer, so it never proved completeness.  ¬ß‡© and ¬ß‡
-- hand it both missing theorems by transport, with no new induction and no
-- edit to either module.
--
-- THE ONLY WORK IS ¬ß‡ß, four lines, and everything after it is transport.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS NOT DONE, said so silence is not read as denial.
--
--   ¬ The triangle is not closed here.  Bhedanirnaya identifies
--     ResidueGlue with Obstruction and this identifies Alopa with
--     Obstruction, so Alopa ‚â° ResidueGlue follows by composing the two
--     paths ‚î and is NOT stated below, because ResidueGlue is not
--     imported here and importing it to state a corollary that costs one
--     `‚àô` is not worth the dependency.  Named as available, not claimed.
--   ¬ NONE of the three should exist.  `Cubical.Relation.Nullary.Discrete`
--     and `Cubical.Data.Nat.Properties.discrete‚ï` give decidable equality
--     on ‚ï with both halves, in the library, checked ‚î which Bhedanirnaya
--     ¬ß‡ already says of two copies and now says of three.  This module
--     identifies copies with each other and identifies NONE of them with
--     the library's, so the corpus still carries a fourth statement of the
--     fact that it did not write and cannot see.
--   ¬ No claim that the twins report is a proof of anything.  A hit is a
--     CANDIDATE: two statements normalising alike does not mean two
--     definitions agree, and ¬ß‡ß is exactly the work the report cannot do.
--     Here they did agree.  Elsewhere a hit may be a genuine near-miss.
--
-- TERM.  ‡Ø‡Æ‡ ‚î twin-born; the ordinary  word, used for the
-- relation the census reports and NOT taken from any technical source.
-- No text is claimed for anything below, and the mathematics ‚î path,
-- transport, `ua` ‚î is cubical type theory, Voevodsky's, this
-- repository's one admitted non-Indian substrate.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Yamaja_TheThirdTesterWasFoundByCensusAndTheChannelPaysReflexivityAndCompleteness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Relation.Nullary using (¬¨_)

import Alopa_TheEngineNeverTouchesTheMeaning as A
import ObstructionSubstrate as O

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡Æ‡‡æ ‚î the two testers agree, pointwise.  Induction on both
--     arguments, four lines, and it is the only work in this file.
------------------------------------------------------------------------

‡§∏‡§Æ‡§§‡§æ : (m n : ‚Ñï) ‚Üí A.eq‚Ñï m n ‚â° O.eq‚Ñï m n
‡§∏‡§Æ‡§§‡§æ zero    zero    = refl
‡§∏‡§Æ‡§§‡§æ zero    (suc _) = refl
‡§∏‡§Æ‡§§‡§æ (suc _) zero    = refl
‡§∏‡§Æ‡§§‡§æ (suc m) (suc n) = ‡§∏‡§Æ‡§§‡§æ m n

------------------------------------------------------------------------
-- ‡® ¬ ‡‡ï‡‡‡æ‡µ‡ ‚î pointwise agreement made a path between the functions,
--     written as a direct cubical abstraction so the path's i-th slice IS
--     ¬ß‡ß's i-th slice and there is no step where anything could go
--     missing.
------------------------------------------------------------------------

‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É : A.eq‚Ñï ‚â° O.eq‚Ñï
‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É i m n = ‡§∏‡§Æ‡§§‡§æ m n i

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡‡‡‡æ ‚î COMPLETENESS, carried BACKWARDS to Alopa.
--
--     Obstruction proved it because its question needed a trustworthy
--     NEGATIVE answer ‚î it tests membership in a list of seen states.
--     Alopa's engine never needed that and never proved it.  It has it
--     now, and no induction was repeated.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ : (m n : ‚Ñï) ‚Üí ¬¨ (m ‚â° n) ‚Üí A.eq‚Ñï m n ‚â° false
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ =
  transport (Œª i ‚Üí (m n : ‚Ñï) ‚Üí ¬¨ (m ‚â° n) ‚Üí ‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É (~ i) m n ‚â° false)
            O.‚â¢‚Üíeq‚Ñï-false

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡®‡∞‡æ‡µ‡‡‡‡‡ø‡ ‚î and reflexivity, the same way.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (n : ‚Ñï) ‚Üí A.eq‚Ñï n n ‚â° true
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É =
  transport (Œª i ‚Üí (n : ‚Ñï) ‚Üí ‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É (~ i) n n ‚â° true) O.eq‚Ñï-refl

------------------------------------------------------------------------
-- ‡ ¬ The tester Alopa now has, both answers trustworthy, in one place.
--     Soundness is its own; completeness came across ¬ß‡©.
------------------------------------------------------------------------

open import Cubical.Data.Sigma using (_√ó_ ; _,_)

‡§™‡•Ç‡§∞‡•ç‡§£-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É
  : (m n : ‚Ñï)
  ‚Üí (A.eq‚Ñï m n ‚â° true ‚Üí m ‚â° n)
  √ó (¬¨ (m ‚â° n) ‚Üí A.eq‚Ñï m n ‚â° false)
‡§™‡•Ç‡§∞‡•ç‡§£-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É m n = A.eq‚Ñï-sound m n , ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ m n

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡ï‡‡∞‡Æ‡-‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡ ‚î and the carry lands ON THE NOSE.
--
--     The transported soundness IS Alopa's own proof.  ‚ï is a set and the
--     target is a path in ‚ï, so the whole Œ†-type is a proposition: the
--     theorem transports uniquely precisely because there was never room
--     for two answers.  Bhedanirnaya ¬ß‡'s point, at this pair.
------------------------------------------------------------------------

open import Cubical.Data.Nat.Properties using (isSet‚Ñï)

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§∏‡•å‡§∑‡•ç‡§†‡§µ‡§Æ‡•ç : (m n : ‚Ñï) ‚Üí A.eq‚Ñï m n ‚â° true ‚Üí m ‚â° n
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§∏‡•å‡§∑‡•ç‡§†‡§µ‡§Æ‡•ç =
  transport (Œª i ‚Üí (m n : ‚Ñï) ‚Üí ‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É (~ i) m n ‚â° true ‚Üí m ‚â° n) O.eq‚Ñï‚Üí‚â°

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§∏‡•å‡§∑‡•ç‡§†‡§µ‡§Æ‡•ç ‚â° A.eq‚Ñï-sound
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç =
  funExt Œª m ‚Üí funExt Œª n ‚Üí funExt Œª _ ‚Üí isSet‚Ñï m n _ _
