{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AsiddhatvaBreaksFactoring
--
-- असिद्धत्व, and what it is FOR.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SŪTRA
--
--     पूर्वत्रासिद्धम्  —  Aṣṭādhyāyī 8.2.1
--
-- Everything from 8.2.1 to the end (the त्रिपादी, the last three
-- quarters) is *asiddha* — "not accomplished" — with respect to what
-- precedes.  A rule in that section applies as though the earlier rule
-- had not fired: it sees the form as it was, not as it now is.
--
-- The standard reading treats this as bookkeeping — a way of ordering
-- rules, an ancestor of the rule-ordering debates in later phonology.
-- That reading cannot answer the obvious question: why would a grammar
-- built for लाघव, for economy above all, spend a सूत्र on it?
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT IS, EXACTLY
--
-- असिद्धत्व is the deliberate construction of an अन्योन्याभाव.  It is a
-- device for making the output NOT a function of the current form.
--
--     siddha   rules read the current form.  Their output factors
--              through it, by construction (§3).
--     asiddha  rules read the earlier form.  Their output provably does
--              NOT factor through the current one (§4), and the
--              obstruction is a collision in exactly the corpus's sense.
--
-- So 8.2.1 is not an ordering convention.  It is an information-
-- retention device: it buys the grammar access to a distinction that
-- the current form has already destroyed, and it pays for that access
-- with the one thing a grammar of लाघव would otherwise never give up —
-- statelessness of its later rules.
--
-- The witness here is the standard one.  8.2.30 चोः कुः turns a palatal
-- into a velar; a form that HAD a palatal and a form that always had a
-- velar are indistinguishable afterwards.  Any rule needing to tell them
-- apart must be asiddha, and no rule reading only the output can.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §3  the siddha variant factors, with the decoder written out;
--   §4  the asiddha variant does not, by the corpus's collision lemma;
--   §5  and the two agree on every form where the earlier rule is
--       vacuous — so the difference is created entirely by the earlier
--       rule's erasure, which is the content of the sūtra.
--
-- The alphabet is three letters and the rule is one substitution.  That
-- is deliberate: the claim is about the SHAPE of asiddhatva, and a
-- larger fragment would add grammar without adding evidence.
--
-- NOT CLAIMED.  No reading of any particular sūtra beyond 8.2.1's own
-- statement, no position on the ordering disputes in the commentarial
-- literature (Kātyāyana, Patañjali's *Mahābhāṣya*), and nothing about
-- whether Pāṇini would have described it this way.  What is claimed is
-- that the device has an exact characterisation — failure to factor —
-- and that the characterisation explains the cost.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module AsiddhatvaBreaksFactoring where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; _or_)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)
open import AnyonyaAbhava using (Anyonya ; anyonya→samsarga)

------------------------------------------------------------------------
-- 1.  Three letters, and the earlier rule
--
--   `cu` a palatal, `ku` a velar, `a` a vowel that never changes.
--   `kutva` is 8.2.30 चोः कुः, in miniature: every palatal becomes velar.
------------------------------------------------------------------------

data Letter : Type₀ where
  cu ku a : Letter

Form : Type₀
Form = List Letter

kutva : Form → Form
kutva []       = []
kutva (cu ∷ s) = ku ∷ kutva s
kutva (ku ∷ s) = ku ∷ kutva s
kutva (a  ∷ s) = a  ∷ kutva s

-- the condition a later rule wants to test: is there a palatal?
hasPalatal : Form → Bool
hasPalatal []       = false
hasPalatal (cu ∷ _) = true
hasPalatal (ku ∷ s) = hasPalatal s
hasPalatal (a  ∷ s) = hasPalatal s

------------------------------------------------------------------------
-- 2.  The same later rule, read the two ways
--
--   सिद्ध:   test the form as it now is — after kutva.
--   असिद्ध:  test the form as it was — before kutva, per 8.2.1.
------------------------------------------------------------------------

firesSiddha : Form → Bool
firesSiddha s = hasPalatal (kutva s)

firesAsiddha : Form → Bool
firesAsiddha s = hasPalatal s

------------------------------------------------------------------------
-- 3.  THE SIDDHA RULE FACTORS, and its decoder is the rule itself
------------------------------------------------------------------------

siddha-factors : FactorsThrough kutva firesSiddha
siddha-factors = decode , law
  where
  decode : Image kutva → Bool
  decode (y , _) = hasPalatal y

  law : (s : Form) → decode (restrictToImage kutva s) ≡ firesSiddha s
  law s = refl

------------------------------------------------------------------------
-- 4.  THE ASIDDHA RULE DOES NOT
--
-- A form that had a palatal and a form that never did are the same form
-- after kutva.  The asiddha rule tells them apart; nothing reading the
-- output can.
------------------------------------------------------------------------

hadPalatal : Form
hadPalatal = cu ∷ []

neverDid : Form
neverDid = ku ∷ []

-- 8.2.30 has already erased the difference
kutva-identifies : kutva hadPalatal ≡ kutva neverDid
kutva-identifies = refl

-- but the asiddha rule still sees it: an अन्योन्याभाव of the two verdicts
verdicts-differ : Anyonya (firesAsiddha hadPalatal) (firesAsiddha neverDid)
verdicts-differ = true≢false

-- so, by the free direction of §3 of `AnyonyaAbhava`
asiddha-does-not-factor : ¬ FactorsThrough kutva firesAsiddha
asiddha-does-not-factor =
  anyonya→samsarga kutva firesAsiddha
    {x = hadPalatal} {x' = neverDid}
    kutva-identifies
    verdicts-differ

------------------------------------------------------------------------
-- 5.  And where the earlier rule is vacuous, the two readings agree
--
-- On forms with no palatal, kutva changes nothing and siddha and
-- asiddha give the same verdict.  So the whole difference is created by
-- the earlier rule's erasure — which is what 8.2.1 is a response to.
------------------------------------------------------------------------

agree-without-palatals : (s : Form) → hasPalatal s ≡ false
                       → firesSiddha s ≡ firesAsiddha s
agree-without-palatals []       p = refl
agree-without-palatals (cu ∷ s) p = Empty.rec (true≢false p)
agree-without-palatals (ku ∷ s) p = agree-without-palatals s p
agree-without-palatals (a  ∷ s) p = agree-without-palatals s p

-- e.g. on `a ∷ ku ∷ []`
agree-example : firesSiddha (a ∷ ku ∷ []) ≡ firesAsiddha (a ∷ ku ∷ [])
agree-example = refl

------------------------------------------------------------------------
-- 6.  What this says.
--
-- असिद्धत्व has an exact characterisation: it is the regime in which a
-- rule's verdict does not factor through the form the previous rules
-- produced.  §3 and §4 are the same rule under the two readings, and
-- one factors and the other provably cannot.
--
-- That answers the question the bookkeeping reading cannot.  A grammar
-- organised around लाघव does not spend a सूत्र on an ordering
-- convention; it spends one on an information-retention device, because
-- the alternative is losing a distinction its own earlier rule has
-- destroyed.  8.2.1 buys back exactly what 8.2.30 spends.
--
-- In this corpus's vocabulary: असिद्धत्व introduces an अन्योन्याभाव
-- deliberately, and `AnyonyaAbhava` §3 converts it into the संसर्गाभाव
-- §4 states.  The grammar and the machine are running the same argument.
--
-- OPEN, named and not estimated.  Whether the त्रिपादी's asiddhatva is
-- MINIMAL — whether Pāṇini takes only the distinctions he needs.  That
-- is a question about the actual sūtras and this fragment cannot reach
-- it; it would need the rule set, not a model of its shape.
------------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by another identity, at the end, altering no line
-- above.  THE THEOREM STANDS; THE SŪTRA NUMBER DOES NOT.
--
-- This module's header reads 8.2.1 as: "A rule in that section applies as
-- though the earlier rule had not fired: it sees the form as it was, not
-- as it now is."  That is a real Pāṇinian device and it is not 8.2.1.  It
-- is 6.4.22.
--
--   8.2.1  पूर्वत्रासिद्धम्  — any SUBSEQUENT rule is asiddha with respect to
--          any rule that PRECEDES it, so the tripādī applies strictly in
--          the order enumerated.  The later is invisible to the earlier.
--          The direction is one-way and backwards.
--
--   6.4.22 असिद्धवदत्राभात् — the change a stem undergoes by any rule from
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
-- Nothing about §3–§5 changes.  siddha factors, asiddha does not, and the
-- obstruction is a collision -- all of that is about the SHAPE of the
-- device and is independent of which sūtra licenses it.  What changes is
-- the citation, and this repository's rule is that a citation naming the
-- wrong source is an error of the same kind as a fitted constant.
--
-- AND THE TWO DEVICES SIT AT THE TWO POLES OF ONE DISTINCTION.  The corpus
-- already has that distinction under its Jain name:
--
--   `Saptabhangi.क्रम-सह-भेदः`  krama (successive) and saha (simultaneous)
--        arpaṇa produce DIFFERENT positions; simultaneity is not
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
-- So: succession buys termination; simultaneity buys information.  Pāṇini
-- spends a sūtra on each, and they are not variants of one device.  That
-- reading is offered, not proved; what is established here is only the
-- correction of the number, which is sourced.
--
-- SOURCES for the correction, checked 2026-08-19 rather than recalled:
-- 8.2.1 is an adhikāra running to the end of the text, making an operation
-- in 8.2-8.4 invalid when any preceding rule is to be applied; 6.4.22
-- heads the asiddhavat section through 6.4.129 in which rules are asiddha
-- with respect to EACH OTHER and apply as if simultaneously.  Pāṇini,
-- Aṣṭādhyāyī, c. 500 BCE.  The commentarial disputes (Kātyāyana,
-- Patañjali's Mahābhāṣya) are untouched, as this file's own NOT CLAIMED
-- section requires.
-- ---------------------------------------------------------------------
