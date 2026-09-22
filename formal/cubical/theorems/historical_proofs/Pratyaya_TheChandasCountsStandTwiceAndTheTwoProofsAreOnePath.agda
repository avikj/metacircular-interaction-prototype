{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡∞‡‡‡Ø‡Ø‡ ‚î ‡‡®‡‡¶‡ã-‡ó‡‡®‡ ‡¶‡‡µ‡ø‡ ‡‡‡‡ø‡‡, ‡‡ï‡ ‡‡®‡‡‡æ‡ ‡
--
-- WHAT THIS MODULE IS FOR.  Two of Pigala's ‡‡‡∞‡‡‡Ø‡Ø results are proved twice
-- in this corpus, once in a Devanagari-named module and once in a
-- Latin-named one, with no import between the two:
--
--   (n : ‚ï) ‚í matra n ‚â° length (‡‡∞‡‡µ n)
--     PrastaraPankti.‡Æ‡æ‡‡‡∞‡æ-‡‡∞‡‡µ‡
--     MeruDiagonalIsVirahanka.matra-is-sarva
--
--   (p : Pattern) ‚í matraOf p ‚â° varna p + guruOf p
--     MatraVarnaGuru.‡Æ‡æ‡‡‡∞‡æ-‡µ‡∞‡‡-‡ó‡‡∞‡
--     DurationIsSyllablesPlusGuru.matra-split
--
-- In both pairs the two modules share the SAME definitions ‚î matra, Pattern,
-- matraOf, varna and guruOf all come from PingalaPrastara, and ‡‡∞‡‡µ from
-- Matramerus ‚î so the two types are one type and not merely two types that
-- print alike.  That has to be checked and not assumed: elsewhere in this
-- corpus the same printed type is two different types over two local
-- definitions, and there the honest move is an equivalence or a ‡‡‡, not an
-- identification.  Here it is an identification, and ¬ß3 gives it.
--
-- ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡ ¬ß‡ ¬ ‡¶‡‡µ‡ ‡Æ‡æ‡∞‡‡ó‡.  This is the first road, and the
-- carry is exact: the target of each of the four proofs is a path in ‚ï, and
-- ‚ï is a set, so any two proofs of one of these statements are themselves
-- equal.  Nothing between the two proofs is lost in identifying them because
-- there was nothing between them to lose.
--
-- THE ‡‡‡, which ¬ß4 writes out and which the identification cannot carry: the
-- two lanes are asking different questions and the coincidence of the
-- theorem does not make them one enquiry.  See ¬ß4.
--
-- ‚î the ‡‡‡∞‡‡‡Ø‡Ø‡æ‡, the six enumeration procedures on metrical patterns
-- (‡‡‡∞‡‡‡‡æ‡∞‡, ‡®‡‡‡ü‡Æ‡, ‡â‡¶‡‡¶‡ø‡‡‡ü‡Æ‡, ‡≤‡ò‡‡ï‡‡∞‡ø‡Ø‡æ, ‡‡ô‡‡ñ‡‡Ø‡æ, ‡‡ß‡‡µ‡Ø‡ã‡ó‡).  ‡Æ‡æ‡‡‡∞‡æ
-- (duration), ‡µ‡∞‡‡ (syllable count) and ‡ó‡‡∞‡ (heavy syllable) are his
-- categories; the relation ‡Æ‡æ‡‡‡∞‡æ = ‡µ‡∞‡‡ + ‡ó‡‡∞‡ is immediate in them, because
-- a ‡ó‡‡∞‡ is worth two ‡Æ‡æ‡‡‡∞‡æs and a ‡≤‡ò‡ one. ¬ ‡µ‡ø‡∞‡‡æ‡ô‡‡ï‡ (c. 700),
-- ‡µ‡‡‡‡‡‡æ‡‡ø‡‡Æ‡‡‡‡‡Ø‡ ‚î the count of patterns of a given ‡Æ‡æ‡‡‡∞‡æ total,
-- satisfying M(n+2) = M(n+1) + M(n); ‡‡≤‡æ‡Ø‡‡ß‡ (c. 10th c., ‡Æ‡‡‡‡û‡‡‡‡µ‡®‡) reads
-- the same numbers off the shallow diagonals of ‡‡ø‡ô‡‡ó‡≤'s ‡Æ‡‡∞‡-‡‡‡∞‡‡‡‡æ‡∞‡. ¬
-- Neither text states an Agda theorem; the two mechanised statements below
-- are their content, and this corpus proved each of them twice without noticing.
------------------------------------------------------------------------

module Pratyaya_TheChandasCountsStandTwiceAndTheTwoProofsAreOnePath where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; _+_)
open import Cubical.Data.Nat.Properties using (isSet‚Ñï)
open import Cubical.Data.List using (length)

open import PingalaPrastara using (matra ; Pattern ; matraOf ; varna ; guruOf)
open import Matramerus using (‡§∏‡§∞‡•ç‡§µ)

import PrastaraPankti
import MeruDiagonalIsVirahanka
import MatraVarnaGuru
import DurationIsSyllablesPlusGuru

------------------------------------------------------------------------
-- ¬ß1 ¬ ‡Æ‡æ‡‡‡∞‡æ-‡‡‡∞‡‡‡Ø‡Ø‡ ‚î Pigala's mtr count is Virahka's enumeration.
--
-- The statement, restated here once so the identification below has a named
-- centre rather than pointing one module at the other and thereby ranking
-- them.  It is deliberately proved by neither hand: it is quoted from the
-- Devanagari lane, and ¬ß2 shows the Latin lane's proof equals it, which is a
-- symmetric fact and is stated symmetrically in ¬ß2's last entry.
------------------------------------------------------------------------

‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§Ø‡§É : (n : ‚Ñï) ‚Üí matra n ‚â° length (‡§∏‡§∞‡•ç‡§µ n)
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§Ø‡§É = PrastaraPankti.‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§∏‡§∞‡•ç‡§µ‡§É

‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§Ø‡§É : (p : Pattern) ‚Üí matraOf p ‚â° varna p + guruOf p
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§Ø‡§É = MatraVarnaGuru.‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å

------------------------------------------------------------------------
-- ¬ß2 ¬ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡ ‚î the identification.
------------------------------------------------------------------------

-- Virahka's count: the two proofs are one path.
‡§∏‡§∞‡•ç‡§µ-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : (n : ‚Ñï)
  ‚Üí PrastaraPankti.‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§∏‡§∞‡•ç‡§µ‡§É n
  ‚â° MeruDiagonalIsVirahanka.matra-is-sarva n
‡§∏‡§∞‡•ç‡§µ-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç n = isSet‚Ñï _ _ _ _

-- Pigala's split of duration into syllables plus heavies: likewise.
‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : (p : Pattern)
  ‚Üí MatraVarnaGuru.‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å p
  ‚â° DurationIsSyllablesPlusGuru.matra-split p
‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç p = isSet‚Ñï _ _ _ _

-- Stated in the other direction as well, because "A equals B" and "B equals A"
-- are the same fact and writing only one of them installs an order between the
-- lanes that the mathematics does not have.
‡§∏‡§∞‡•ç‡§µ-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡•á‡§®
  : (n : ‚Ñï)
  ‚Üí MeruDiagonalIsVirahanka.matra-is-sarva n
  ‚â° PrastaraPankti.‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§∏‡§∞‡•ç‡§µ‡§É n
‡§∏‡§∞‡•ç‡§µ-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡•á‡§® n = sym (‡§∏‡§∞‡•ç‡§µ-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç n)

‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡•á‡§®
  : (p : Pattern)
  ‚Üí DurationIsSyllablesPlusGuru.matra-split p
  ‚â° MatraVarnaGuru.‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å p
‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡•á‡§® p = sym (‡§µ‡§∞‡•ç‡§£-‡§ó‡•Å‡§∞‡•Å-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç p)

------------------------------------------------------------------------
-- ¬ß3 ¬ What the identification is made of, stated so it is not mistaken for
-- more than it is.
--
-- isSet‚ï is doing all the work, and it is worth being explicit about how
-- little that means and how much.  It means: the four proofs live in identity
-- types of ‚ï, those are propositions, and a proposition has at most one
-- inhabitant up to a path.  It does NOT mean the four programs are the same
-- program ‚î they are visibly not; two recurse on n through Matramerus's
-- ‡‡∞‡‡µ-step lemma and two do not.  The h-level fact identifies the values, not
-- the derivations, and the derivations are exactly what ¬ß4 records.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ¬ß4 ¬ ‡‡‡‡ ‚î the remainder.
--
-- Both pairs are one theorem and two enquiries, and the second half does not
-- transport.
--
--   ¬ PrastaraPankti sits in the ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞ lane.  ‡Æ‡æ‡‡‡∞‡æ-‡‡∞‡‡µ‡ is a step
--     inside it, immediately consumed by ‡Æ‡æ‡‡‡∞‡æ-‡ï‡∞‡‡‡, which composes it with
--     MeruKarna.‡‡Æ‡‡æ-‡ï‡∞‡‡‡ to reach Halyudha's shallow diagonal.  The
--     question there is a question about Pigala's ‡Æ‡‡∞‡: do three different
--     ‡‡‡∞‡‡‡Ø‡Ø readings of the same array agree.
--   ¬ MeruDiagonalIsVirahanka sits in the machine lane.
--     matra-is-sarva is consumed by virahanka-is-the-diagonal, composed with
--     DiagonalIsMatra, and the question there is whether the
--     machine's antidiagonal construction computes what the prosody says.
--     One lane is asking about a text; the other is asking about a machine.
--   ¬ MatraVarnaGuru consumes ‡Æ‡æ‡‡‡∞‡æ-‡µ‡∞‡‡-‡ó‡‡∞‡ into ‡‡®‡‡¶‡ã-‡Æ‡æ‡‡‡∞‡æ, ‡Æ‡æ‡‡‡∞‡æ-‡‡ß‡
--     and a ‡≤‡ò‡-‡‡ô‡‡ñ‡‡Ø‡æ decomposition ‚î the arithmetic of the metre itself.
--   ¬ DurationIsSyllablesPlusGuru consumes matra-split into a
--     Œ-type factorisation and an Iso, i.e. into a statement about what a
--     duration determines: the module is about information, not about metre.
--
-- The theorem is one.  The four uses are four.  ¬ß‡ of the stra ‚î
-- ‡‡ô‡‡ï‡‡‡‡‡‡‡Ø ‡‡®‡‡‡≤‡‡‡ß‡ø‡ ‚î is exact about this case: where the ‡®‡Øs differ
-- there is no single object common to all threads to collapse onto, so the
-- collapse is not forbidden, it is UNAVAILABLE.  Consequently none of the
-- four declarations is deleted or rewritten to import this module.
--
-- WHAT THE DUPLICATION ACTUALLY COSTS, since "they are equal" makes it sound
-- free.  It cost the corpus the composite fact.  PrastaraPankti reached
-- Halyudha's diagonal from the count; MeruDiagonalIsVirahanka reached the
-- machine's antidiagonal from the same count; and because neither module
-- could see the other, nobody wrote down that the machine's antidiagonal IS
-- Halyudha's shallow diagonal, which follows in one step from the two
-- corollaries the two lanes already have.
------------------------------------------------------------------------
