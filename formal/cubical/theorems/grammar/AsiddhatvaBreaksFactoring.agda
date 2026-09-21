{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AsiddhatvaBreaksFactoring
--
-- ‡‡‡ø‡¶‡‡ß‡‡‡µ, and what it is FOR.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE STRA
--
--     ‡‡‡∞‡‡µ‡‡‡∞‡æ‡‡ø‡¶‡‡ß‡Æ‡  ‚î  Adhyy 8.2.1
--
-- Everything from 8.2.1 to the end (the ‡‡‡∞‡ø‡‡æ‡¶‡, the last three
-- quarters) is *asiddha* ‚î "not accomplished" ‚î with respect to what
-- precedes.  A rule in that section applies as though the earlier rule
-- had not fired: it sees the form as it was, not as it now is.
--
-- The standard reading treats this as bookkeeping ‚î a way of ordering
-- rules, an ancestor of the rule-ordering debates in later phonology.
-- That reading cannot answer the obvious question: why would a grammar
-- built for ‡≤‡æ‡ò‡µ, for economy above all, spend a ‡‡‡‡‡∞ on it?
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IT IS, EXACTLY
--
-- ‡‡‡ø‡¶‡‡ß‡‡‡µ is the deliberate construction of an ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ.  It is a
-- device for making the output NOT a function of the current form.
--
--     siddha   rules read the current form.  Their output factors
--              through it, by construction (¬ß3).
--     asiddha  rules read the earlier form.  Their output provably does
--              NOT factor through the current one (¬ß4), and the
--              obstruction is a collision in exactly the corpus's sense.
--
-- So 8.2.1 is not an ordering convention.  It is an information-
-- retention device: it buys the grammar access to a distinction that
-- the current form has already destroyed, and it pays for that access
-- with the one thing a grammar of ‡≤‡æ‡ò‡µ would otherwise never give up ‚î
-- statelessness of its later rules.
--
-- The witness here is the standard one.  8.2.30 ‡‡ã‡ ‡ï‡‡ turns a palatal
-- into a velar; a form that HAD a palatal and a form that always had a
-- velar are indistinguishable afterwards.  Any rule needing to tell them
-- apart must be asiddha, and no rule reading only the output can.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß3  the siddha variant factors, with the decoder written out;
--   ¬ß4  the asiddha variant does not, by the corpus's collision lemma;
--   ¬ß5  and the two agree on every form where the earlier rule is
--       vacuous ‚î so the difference is created entirely by the earlier
--       rule's erasure, which is the content of the stra.
--
-- The alphabet is three letters and the rule is one substitution.  That
-- is deliberate: the claim is about the SHAPE of asiddhatva, and a
-- larger fragment would add grammar without adding evidence.
------------------------------------------------------------------------

module AsiddhatvaBreaksFactoring where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false ; _or_)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)
open import AnyonyaAbhava using (Anyonya ; anyonya‚Üísamsarga)

------------------------------------------------------------------------
-- 1.  Three letters, and the earlier rule
--
--   `cu` a palatal, `ku` a velar, `a` a vowel that never changes.
--   `kutva` is 8.2.30 ‡‡ã‡ ‡ï‡‡, in miniature: every palatal becomes velar.
------------------------------------------------------------------------

data Letter : Type‚ÇÄ where
  cu ku a : Letter

Form : Type‚ÇÄ
Form = List Letter

kutva : Form ‚Üí Form
kutva []       = []
kutva (cu ‚à∑ s) = ku ‚à∑ kutva s
kutva (ku ‚à∑ s) = ku ‚à∑ kutva s
kutva (a  ‚à∑ s) = a  ‚à∑ kutva s

-- the condition a later rule wants to test: is there a palatal?
hasPalatal : Form ‚Üí Bool
hasPalatal []       = false
hasPalatal (cu ‚à∑ _) = true
hasPalatal (ku ‚à∑ s) = hasPalatal s
hasPalatal (a  ‚à∑ s) = hasPalatal s

------------------------------------------------------------------------
-- 2.  The same later rule, read the two ways
--
--   ‡‡ø‡¶‡‡ß:   test the form as it now is ‚î after kutva.
--   ‡‡‡ø‡¶‡‡ß:  test the form as it was ‚î before kutva, per 8.2.1.
------------------------------------------------------------------------

firesSiddha : Form ‚Üí Bool
firesSiddha s = hasPalatal (kutva s)

firesAsiddha : Form ‚Üí Bool
firesAsiddha s = hasPalatal s

------------------------------------------------------------------------
-- 3.  THE SIDDHA RULE FACTORS, and its decoder is the rule itself
------------------------------------------------------------------------

siddha-factors : FactorsThrough kutva firesSiddha
siddha-factors = decode , law
  where
  decode : Image kutva ‚Üí Bool
  decode (y , _) = hasPalatal y

  law : (s : Form) ‚Üí decode (restrictToImage kutva s) ‚â° firesSiddha s
  law s = refl

------------------------------------------------------------------------
-- 4.  THE ASIDDHA RULE DOES NOT
--
-- A form that had a palatal and a form that never did are the same form
-- after kutva.  The asiddha rule tells them apart; nothing reading the
-- output can.
------------------------------------------------------------------------

hadPalatal : Form
hadPalatal = cu ‚à∑ []

neverDid : Form
neverDid = ku ‚à∑ []

-- 8.2.30 has already erased the difference
kutva-identifies : kutva hadPalatal ‚â° kutva neverDid
kutva-identifies = refl

-- but the asiddha rule still sees it: an ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ of the two verdicts
verdicts-differ : Anyonya (firesAsiddha hadPalatal) (firesAsiddha neverDid)
verdicts-differ = true‚â¢false

-- so, by the free direction of ¬ß3 of `AnyonyaAbhava`
asiddha-does-not-factor : ¬¨ FactorsThrough kutva firesAsiddha
asiddha-does-not-factor =
  anyonya‚Üísamsarga kutva firesAsiddha
    {x = hadPalatal} {x' = neverDid}
    kutva-identifies
    verdicts-differ

------------------------------------------------------------------------
-- 5.  And where the earlier rule is vacuous, the two readings agree
--
-- On forms with no palatal, kutva changes nothing and siddha and
-- asiddha give the same verdict.  So the whole difference is created by
-- the earlier rule's erasure ‚î which is what 8.2.1 is a response to.
------------------------------------------------------------------------

agree-without-palatals : (s : Form) ‚Üí hasPalatal s ‚â° false
                       ‚Üí firesSiddha s ‚â° firesAsiddha s
agree-without-palatals []       p = refl
agree-without-palatals (cu ‚à∑ s) p = Empty.rec (true‚â¢false p)
agree-without-palatals (ku ‚à∑ s) p = agree-without-palatals s p
agree-without-palatals (a  ‚à∑ s) p = agree-without-palatals s p

-- e.g. on `a ‚à ku ‚à []`
agree-example : firesSiddha (a ‚à∑ ku ‚à∑ []) ‚â° firesAsiddha (a ‚à∑ ku ‚à∑ [])
agree-example = refl

------------------------------------------------------------------------
-- 6.  What this says.
--
-- ‡‡‡ø‡¶‡‡ß‡‡‡µ has an exact characterisation: it is the regime in which a
-- rule's verdict does not factor through the form the previous rules
-- produced.  ¬ß3 and ¬ß4 are the same rule under the two readings, and
-- one factors and the other provably cannot.
--
-- That answers the question the bookkeeping reading cannot.  A grammar
-- organised around ‡≤‡æ‡ò‡µ does not spend a ‡‡‡‡‡∞ on an ordering
-- convention; it spends one on an information-retention device, because
-- the alternative is losing a distinction its own earlier rule has
-- destroyed.  8.2.1 buys back exactly what 8.2.30 spends.
--
-- In this corpus's vocabulary: ‡‡‡ø‡¶‡‡ß‡‡‡µ introduces an ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ
-- deliberately, and `AnyonyaAbhava` ¬ß3 converts it into the ‡‡‡‡∞‡‡ó‡æ‡‡æ‡µ
-- ¬ß4 states.  The grammar and the machine are running the same argument.
--
-- Whether the ‡‡‡∞‡ø‡‡æ‡¶‡'s asiddhatva is
-- MINIMAL ‚î whether Pini takes only the distinctions he needs
-- is a question about the actual stras and this fragment cannot reach
-- it; it would need the rule set, not a model of its shape.
------------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- THE THEOREM STANDS; THE STRA NUMBER DOES NOT.
--
-- This module's header reads 8.2.1 as: "A rule in that section applies as
-- though the earlier rule had not fired: it sees the form as it was, not
-- as it now is."  That is a real Pinian device and it is not 8.2.1.  It
-- is 6.4.22.
--
--   8.2.1  ‡‡‡∞‡‡µ‡‡‡∞‡æ‡‡ø‡¶‡‡ß‡Æ‡  ‚î any SUBSEQUENT rule is asiddha with respect to
--          any rule that PRECEDES it, so the tripd applies strictly in
--          the order enumerated.  The later is invisible to the earlier.
--          The direction is one-way and backwards.
--
--   6.4.22 ‡‡‡ø‡¶‡‡ß‡µ‡¶‡‡‡∞‡æ‡‡æ‡‡ ‚î the change a stem undergoes by any rule from
--          6.4.22 to 6.4.129 counts as NOT HAVING TAKEN EFFECT when
--          applying any OTHER rule of that same section.  Mutual
--          invisibility inside a bounded block; the rules apply AS IF
--          SIMULTANEOUSLY.  That is "sees the form as it was", exactly.
--
-- The witness this file uses fits 6.4.22 and not 8.2.1: a rule reading the
-- pre-kutva form while kutva has already applied is a rule inside a block
-- whose members are asiddhavat to each other, not a rule in a strictly
-- ordered sequence.
--
-- Nothing about ¬ß3‚ì¬ß5 changes.  siddha factors, asiddha does not, and the
-- obstruction is a collision -- all of that is about the SHAPE of the
-- device and is independent of which stra licenses it.  What changes is
-- the citation, and this repository's rule is that a citation naming the
-- wrong source is an error of the same kind as a fitted constant.
--
-- AND THE TWO DEVICES SIT AT THE TWO POLES OF ONE DISTINCTION.  The corpus
-- already has that distinction under its Jain name:
--
--   `Saptabhangi.‡ï‡‡∞‡Æ-‡‡-‡‡‡¶‡`  krama (successive) and saha (simultaneous)
--        arpaa produce DIFFERENT positions; simultaneity is not
--        sequential both-ness.
--
--   `Asiddhatva.agda` (8.2.1, successive)  the ordered strata TERMINATE a
--        rewriting system for which no strict order exists at all --
--        8.2.39 sends k to g, 8.4.56 sends g back to k, and only the
--        refusal of the earlier rule to see the later output stops it.
--
--   this file (6.4.22, simultaneous)  the mutually-invisible block RETAINS
--        INFORMATION the current form has destroyed.
--
-- So: succession buys termination; simultaneity buys information.  Pini
-- spends a stra on each, and they are not variants of one device.  That
-- reading is offered, not proved; what is established here is only the
-- correction of the number, which is sourced.
--
-- SOURCES for the correction: 8.2.1
-- is an adhikra running to the end of the text, making an operation in
-- 8.2-8.4 invalid when any preceding rule is to be applied; 6.4.22 heads the
-- asiddhavat section through 6.4.129 in which rules are asiddha with respect
-- to EACH OTHER and apply as if simultaneously. Pini, Adhyy, c. 500
-- BCE.
-- ---------------------------------------------------------------------
