-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रत्ययः — छन्दो-गणने द्विः स्थिते, एकः पन्थाः ।
--
-- WHAT THIS MODULE IS FOR.  Two of Piṅgala's प्रत्यय results are proved twice
-- in this corpus, once in a Devanagari-named module and once in a
-- Latin-named one, with no import between the two:
--
--   (n : ℕ) → matra n ≡ length (सर्व n)
--     PrastaraPankti.मात्रा-सर्वः
--     NaturalMachine.MeruDiagonalIsVirahanka.matra-is-sarva
--
--   (p : Pattern) → matraOf p ≡ varna p + guruOf p
--     MatraVarnaGuru.मात्रा-वर्ण-गुरु
--     NaturalMachine.DurationIsSyllablesPlusGuru.matra-split
--
-- In both pairs the two modules share the SAME definitions — matra, Pattern,
-- matraOf, varna and guruOf all come from PingalaPrastara, and सर्व from
-- Matramerus — so the two types are one type and not merely two types that
-- print alike.  That has to be checked and not assumed: elsewhere in this
-- corpus the same printed type is two different types over two local
-- definitions, and there the honest move is an equivalence or a शेष, not an
-- identification.  Here it is an identification, and §3 gives it.
--
-- अहिंसा-सूत्र-विस्तारः §६ · द्वौ मार्गौ.  This is the first road, and the
-- carry is exact: the target of each of the four proofs is a path in ℕ, and
-- ℕ is a set, so any two proofs of one of these statements are themselves
-- equal.  Nothing between the two proofs is lost in identifying them because
-- there was nothing between them to lose.
--
-- THE शेष, which §4 writes out and which the identification cannot carry: the
-- two lanes are asking different questions and the coincidence of the
-- theorem does not make them one enquiry.  See §4.
--
-- SOURCES, AND WHAT IS AND IS NOT CLAIMED OF THEM.
--   · पिङ्गलः, छन्दःशास्त्रम् (c. 300 BCE) — the प्रत्ययाः, the six
--     enumeration procedures on metrical patterns (प्रस्तारः, नष्टम्,
--     उद्दिष्टम्, लघुक्रिया, सङ्ख्या, अध्वयोगः).  मात्रा (duration), वर्ण
--     (syllable count) and गुरु (heavy syllable) are his categories; the
--     relation मात्रा = वर्ण + गुरु is immediate in them, because a गुरु is
--     worth two मात्राs and a लघु one.
--   · विरहाङ्कः (c. 700), वृत्तजातिसमुच्चयः — the count of patterns of a given
--     मात्रा total, satisfying M(n+2) = M(n+1) + M(n); हलायुधः (c. 10th c.,
--     मृतसञ्जीवनी) reads the same numbers off the shallow diagonals of
--     पिङ्गल's मेरु-प्रस्तारः.
--   · Neither text states an Agda theorem, and neither is claimed to.  What is
--     claimed is that the two mechanised statements below are their content,
--     and that this corpus proved each of them twice without noticing.
------------------------------------------------------------------------

module Pratyaya_TheChandasCountsStandTwiceAndTheTwoProofsAreOnePath where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_)
open import Cubical.Data.Nat.Properties using (isSetℕ)
open import Cubical.Data.List using (length)

open import PingalaPrastara using (matra ; Pattern ; matraOf ; varna ; guruOf)
open import Matramerus using (सर्व)

import PrastaraPankti
import NaturalMachine.MeruDiagonalIsVirahanka
import MatraVarnaGuru
import NaturalMachine.DurationIsSyllablesPlusGuru

------------------------------------------------------------------------
-- §1 · मात्रा-प्रत्ययः — Piṅgala's mātrā count is Virahāṅka's enumeration.
--
-- The statement, restated here once so the identification below has a named
-- centre rather than pointing one module at the other and thereby ranking
-- them.  It is deliberately proved by neither hand: it is quoted from the
-- Devanagari lane, and §2 shows the Latin lane's proof equals it, which is a
-- symmetric fact and is stated symmetrically in §2's last entry.
------------------------------------------------------------------------

मात्रा-प्रत्ययः : (n : ℕ) → matra n ≡ length (सर्व n)
मात्रा-प्रत्ययः = PrastaraPankti.मात्रा-सर्वः

मात्रा-वर्ण-गुरु-प्रत्ययः : (p : Pattern) → matraOf p ≡ varna p + guruOf p
मात्रा-वर्ण-गुरु-प्रत्ययः = MatraVarnaGuru.मात्रा-वर्ण-गुरु

------------------------------------------------------------------------
-- §2 · तादात्म्यम् — the identification.
------------------------------------------------------------------------

-- Virahāṅka's count: the two proofs are one path.
सर्व-तादात्म्यम्
  : (n : ℕ)
  → PrastaraPankti.मात्रा-सर्वः n
  ≡ NaturalMachine.MeruDiagonalIsVirahanka.matra-is-sarva n
सर्व-तादात्म्यम् n = isSetℕ _ _ _ _

-- Piṅgala's split of duration into syllables plus heavies: likewise.
वर्ण-गुरु-तादात्म्यम्
  : (p : Pattern)
  → MatraVarnaGuru.मात्रा-वर्ण-गुरु p
  ≡ NaturalMachine.DurationIsSyllablesPlusGuru.matra-split p
वर्ण-गुरु-तादात्म्यम् p = isSetℕ _ _ _ _

-- Stated in the other direction as well, because "A equals B" and "B equals A"
-- are the same fact and writing only one of them installs an order between the
-- lanes that the mathematics does not have.
सर्व-तादात्म्यम्-व्यत्ययेन
  : (n : ℕ)
  → NaturalMachine.MeruDiagonalIsVirahanka.matra-is-sarva n
  ≡ PrastaraPankti.मात्रा-सर्वः n
सर्व-तादात्म्यम्-व्यत्ययेन n = sym (सर्व-तादात्म्यम् n)

वर्ण-गुरु-तादात्म्यम्-व्यत्ययेन
  : (p : Pattern)
  → NaturalMachine.DurationIsSyllablesPlusGuru.matra-split p
  ≡ MatraVarnaGuru.मात्रा-वर्ण-गुरु p
वर्ण-गुरु-तादात्म्यम्-व्यत्ययेन p = sym (वर्ण-गुरु-तादात्म्यम् p)

------------------------------------------------------------------------
-- §3 · What the identification is made of, stated so it is not mistaken for
-- more than it is.
--
-- isSetℕ is doing all the work, and it is worth being explicit about how
-- little that means and how much.  It means: the four proofs live in identity
-- types of ℕ, those are propositions, and a proposition has at most one
-- inhabitant up to a path.  It does NOT mean the four programs are the same
-- program — they are visibly not; two recurse on n through Matramerus's
-- सर्व-step lemma and two do not.  The h-level fact identifies the values, not
-- the derivations, and the derivations are exactly what §4 records.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- §4 · शेषः — the remainder.
--
-- Both pairs are one theorem and two enquiries, and the second half does not
-- transport.
--
--   · PrastaraPankti sits in the छन्दःशास्त्र lane.  मात्रा-सर्वः is a step
--     inside it, immediately consumed by मात्रा-कर्णः, which composes it with
--     MeruKarna.समता-कर्णः to reach Halāyudha's shallow diagonal.  The
--     question there is a question about Piṅgala's मेरु: do three different
--     प्रत्यय readings of the same array agree.
--   · NaturalMachine.MeruDiagonalIsVirahanka sits in the machine lane.
--     matra-is-sarva is consumed by virahanka-is-the-diagonal, composed with
--     NaturalMachine.DiagonalIsMatra, and the question there is whether the
--     machine's antidiagonal construction computes what the prosody says.
--     One lane is asking about a text; the other is asking about a machine.
--   · MatraVarnaGuru consumes मात्रा-वर्ण-गुरु into छन्दो-मात्रा, मात्रा-अधः
--     and a लघु-सङ्ख्या decomposition — the arithmetic of the metre itself.
--   · NaturalMachine.DurationIsSyllablesPlusGuru consumes matra-split into a
--     Σ-type factorisation and an Iso, i.e. into a statement about what a
--     duration determines: the module is about information, not about metre.
--
-- The theorem is one.  The four uses are four.  §७ of the sūtra —
-- सङ्क्षेपस्य अनुपलब्धिः — is exact about this case: where the नयs differ
-- there is no single object common to all threads to collapse onto, so the
-- collapse is not forbidden, it is UNAVAILABLE.  Consequently none of the
-- four declarations is deleted or rewritten to import this module.
--
-- WHAT THE DUPLICATION ACTUALLY COSTS, since "they are equal" makes it sound
-- free.  It cost the corpus the composite fact.  PrastaraPankti reached
-- Halāyudha's diagonal from the count; MeruDiagonalIsVirahanka reached the
-- machine's antidiagonal from the same count; and because neither module
-- could see the other, nobody wrote down that the machine's antidiagonal IS
-- Halāyudha's shallow diagonal, which follows in one step from the two
-- corollaries the two lanes already have.  That composite is stated as open
-- here rather than proved, because closing it means deciding which lane owns
-- the resulting name, and that is not a decision this module should make
-- alone.
------------------------------------------------------------------------
