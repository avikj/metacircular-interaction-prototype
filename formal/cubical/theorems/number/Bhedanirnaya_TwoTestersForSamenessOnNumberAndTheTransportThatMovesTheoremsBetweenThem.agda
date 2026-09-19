{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡¶-‡®‡ø‡∞‡‡‡Ø‡ ‚î ‡¶‡‡µ‡ ‡‡∞‡‡ï‡‡‡ï‡, ‡‡ï‡ ‡‡‡ï‡‡∞‡Æ‡ ‡
--
-- WHAT THIS MODULE IS FOR, AND WHY IT IS DIFFERENT FROM THE OTHER TWO.
-- The corpus audit found seventeen statements standing twice or more with no
-- member module reaching any other.  Two of those groups are handled in
-- MadhyaVinimaya_‚¶ and Pratyaya_‚¶, and in both the duplicated declarations
-- had literally the same type, so the identification was immediate.
--
-- This group is not like that, and the difference is the whole point:
--
--   ResidueGlue.eq‚ï-sound        : (m n : ‚ï) ‚í eq‚ï m n ‚â° true ‚í m ‚â° n
--   ObstructionSubstrate.eq‚ï‚í‚â° : (m n : ‚ï) ‚í eq‚ï m n ‚â° true ‚í m ‚â° n
--
-- The two types PRINT alike and are NOT the same type.  Each module defines
-- its own `eq‚ï`, by the same four clauses, and two definitions with the same
-- clauses are two functions: `ResidueGlue.eq‚ï m n` and
-- `ObstructionSubstrate.eq‚ï m n` do not reduce to a common form at
-- variable m and n, so nothing identifies the two statements definitionally.
-- A tool that compares printed types cannot see this; it reports a lead, and
-- the lead has to be opened by hand.  It is opened here.
--
-- ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡ ¬ß‡ ¬ ‡¶‡‡µ‡ ‡Æ‡æ‡∞‡‡ó‡.  This is the first road in its full
-- form and not a degenerate case of it: an equivalence has to be exhibited
-- (¬ß1), it has to be turned into a path (¬ß2), and only then does transport
-- carry a theorem across (¬ß3).  Nothing is lost in the carry ‚î that is what
-- ¬ß‡ asserts and what ¬ß4 checks by landing the transported theorem exactly on
-- the other module's own proof.
--
-- AND THE CARRY PAYS.  ¬ß5 is the reason this is worth doing rather than
-- merely tidy.  The two modules do not hold the same theorems.  Obstruction
-- proved COMPLETENESS of its tester (m ‚â n ‚í eq‚ï m n ‚â° false); ResidueGlue
-- never did, and has gone without it.  The path of ¬ß2 carries that theorem
-- backwards, and ResidueGlue's tester acquires a property it was never
-- given, with no new induction.  A duplication that has been identified is
-- not merely tidier ‚î it is a channel, and theorems flow both ways along it.
--
-- ¬ß‡'s two roads, and ¬ß‡'s ‡‡ô‡‡ï‡‡‡‡‡‡‡Ø ‡‡®‡‡‡≤‡‡‡ß‡ø‡, which is why ¬ß5's remainder
-- is written out instead of the two modules being merged.
------------------------------------------------------------------------

module Bhedanirnaya_TwoTestersForSamenessOnNumberAndTheTransportThatMovesTheoremsBetweenThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Nat.Properties using (isSet‚Ñï)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)

import ResidueGlue
import ObstructionSubstrate

------------------------------------------------------------------------
-- ¬ß1 ¬ ‡‡Æ‡‡æ ‚î the two testers agree, pointwise.
--
-- By induction on both arguments, which is the only work in this module and
-- is four lines.  Everything after ¬ß1 is transport.
------------------------------------------------------------------------

‡§∏‡§Æ‡§§‡§æ : (m n : ‚Ñï) ‚Üí ResidueGlue.eq‚Ñï m n ‚â° ObstructionSubstrate.eq‚Ñï m n
‡§∏‡§Æ‡§§‡§æ zero    zero    = refl
‡§∏‡§Æ‡§§‡§æ zero    (suc _) = refl
‡§∏‡§Æ‡§§‡§æ (suc _) zero    = refl
‡§∏‡§Æ‡§§‡§æ (suc m) (suc n) = ‡§∏‡§Æ‡§§‡§æ m n

------------------------------------------------------------------------
-- ¬ß2 ¬ ‡‡ï‡‡‡æ‡µ‡ ‚î pointwise agreement made into a path between the functions.
--
-- Written as a direct cubical abstraction rather than through funExt, so the
-- path is visibly the one whose i-th slice is ‡‡Æ‡‡æ's i-th slice: there is no
-- step here in which anything could go missing.
------------------------------------------------------------------------

‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É : ResidueGlue.eq‚Ñï ‚â° ObstructionSubstrate.eq‚Ñï
‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É i m n = ‡§∏‡§Æ‡§§‡§æ m n i

------------------------------------------------------------------------
-- ¬ß3 ¬ ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ ‚î the transport, forwards.
--
-- ResidueGlue's soundness theorem, carried along ‡‡ï‡‡‡æ‡µ‡, becomes a
-- soundness theorem for Obstruction's tester.  No induction is repeated.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§∏‡•å‡§∑‡•ç‡§†‡§µ‡§Æ‡•ç : (m n : ‚Ñï) ‚Üí ObstructionSubstrate.eq‚Ñï m n ‚â° true ‚Üí m ‚â° n
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§∏‡•å‡§∑‡•ç‡§†‡§µ‡§Æ‡•ç =
  transport (Œª i ‚Üí (m n : ‚Ñï) ‚Üí ‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É i m n ‚â° true ‚Üí m ‚â° n)
            ResidueGlue.eq‚Ñï-sound

------------------------------------------------------------------------
-- ¬ß4 ¬ ‡‡≤‡ã‡‡ ‚î and it lands on the nose.
--
-- The transported theorem is the theorem Obstruction proved for itself.  This
-- is the content of ¬ß‡'s "‡‡‡ï‡‡∞‡Æ‡‡ ‡® ‡ï‡ø‡û‡‡‡ø‡®‡ ‡®‡‡‡Ø‡‡ø" made checkable at this
-- instance: the carry did not produce a second, parallel proof living beside
-- the first ‚î it produced the first.
--
-- The identification is available because the target m ‚â° n is a path in ‚ï and
-- ‚ï is a set, so the whole Œ†-type is a proposition.  Stated that way rather
-- than left as an unexplained isSet‚ï, because it is the reason and the reason
-- is the interesting part: the theorem transports uniquely precisely because
-- there was never room for two answers.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§∏‡•å‡§∑‡•ç‡§†‡§µ‡§Æ‡•ç ‚â° ObstructionSubstrate.eq‚Ñï‚Üí‚â°
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç =
  funExt Œª m ‚Üí funExt Œª n ‚Üí funExt Œª _ ‚Üí isSet‚Ñï m n _ _

------------------------------------------------------------------------
-- ¬ß5 ¬ What each holds that the other does not ‚î and what the channel pays.
--
-- The two modules are NOT the same object under examination, and this is the
-- part the identification does not carry.
--
--   ¬ Obstruction holds COMPLETENESS, ‚â‚íeq‚ï-false, and uses
--     the tester for membership in a list of seen states (`memb`).  Its
--     question is about an obstruction to a machine's progress; it needs to
--     know that a NEGATIVE answer from the tester is trustworthy, which is
--     exactly why it proved completeness and ResidueGlue did not.
--   ¬ ResidueGlue holds the Fin layer ‚î eqFin, eqFin-sound,
--     eqFin-complete ‚î and uses the tester through `compatible?` to glue two
--     residue systems.  Its question is about agreement of two projections;
--     it needs the tester lifted along to‚ï, which Obstruction never needed.
--
-- Two questions, one tester, and each module proved the half its own question
-- required.  ¬ß‡, ‡‡ô‡‡ï‡‡‡‡‡‡‡Ø ‡‡®‡‡‡≤‡‡‡ß‡ø‡: where the ‡®‡Øs differ there is no one
-- object common to both threads, so neither module is deleted or rewritten.
--
-- BUT THE HALVES ARE NOW TRANSFERABLE, and that is the payoff.  Below,
-- ResidueGlue's tester acquires Obstruction's completeness by transport
-- backwards along the same path ‚î a theorem it did not have, obtained with no
-- new induction and no edit to either module.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ : (m n : ‚Ñï) ‚Üí ¬¨ m ‚â° n ‚Üí ResidueGlue.eq‚Ñï m n ‚â° false
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ =
  transport (Œª i ‚Üí (m n : ‚Ñï) ‚Üí ¬¨ m ‚â° n ‚Üí ‡§è‡§ï‡•Ä‡§≠‡§æ‡§µ‡§É (~ i) m n ‚â° false)
            ObstructionSubstrate.‚â¢‚Üíeq‚Ñï-false

-- The same, one level up: ResidueGlue's own eqFin now has a decision
-- procedure that is trustworthy on both answers, because its underlying eq‚ï
-- is.  Stated at ‚ï; the Fin lift is ResidueGlue's own eqFin-sound /
-- eqFin-complete pair and is not restated here.
‡§™‡•Ç‡§∞‡•ç‡§£-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É
  : (m n : ‚Ñï)
  ‚Üí (ResidueGlue.eq‚Ñï m n ‚â° true ‚Üí m ‚â° n)
  √ó (¬¨ m ‚â° n ‚Üí ResidueGlue.eq‚Ñï m n ‚â° false)
‡§™‡•Ç‡§∞‡•ç‡§£-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É m n = ResidueGlue.eq‚Ñï-sound m n , ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§æ‡§®‡•ç‡§§-‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ m n

------------------------------------------------------------------------
-- ¬ß6 ¬ ‡‡‡‡ ‚î the remainder that stays a remainder.
--
-- WHAT IS NOT DONE HERE, stated because leaving it unsaid would be the
-- sanitised version of this module.
--
--   ¬ Neither `eq‚ï` should exist.  `Cubical.Relation.Nullary.Discrete` and
--     `Cubical.Data.Nat.Properties.discrete‚ï` give decidable equality on ‚ï
--     with soundness and completeness together, in the library, checked, and
--     both modules wrote their own instead.  This module identifies the two
--     copies with each other; it does not identify either with the library's,
--     and until that is done the corpus still carries a third statement of
--     the same fact that it did not write and cannot see.
--   ¬ The transport in ¬ß5 gives ResidueGlue's tester completeness at ‚ï.
--     It does NOT thereby give the Fin layer anything: eqFin-complete already
--     existed and is a different statement (x ‚â° y ‚í eqFin x y ‚â° true, the
--     positive direction), and the negative direction at Fin ‚î x ‚â y ‚í
--     eqFin x y ‚â° false ‚î needs to‚ï-injectivity in the other direction and is
--     not proved here.
--   ¬ The pattern generalises and is not generalised.  Any two structurally
--     identical definitions in two modules admit exactly this treatment: one
--     induction to agree pointwise, one abstraction to a path, and then every
--     theorem either module holds is available to the other.  Whether the
--     corpus has more instances of it is a question for the audit tool, which
--     currently reports only same-PRINTED-type groups and would miss a pair
--     whose definitions agree under different names.
------------------------------------------------------------------------
