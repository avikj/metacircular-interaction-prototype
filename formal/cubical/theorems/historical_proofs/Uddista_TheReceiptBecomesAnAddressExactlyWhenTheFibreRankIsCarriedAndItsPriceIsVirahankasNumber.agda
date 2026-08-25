{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- उद्दिष्टम् — मात्रा एकाकिनी पता न भवति, मात्रा सह स्व-तन्तु-उद्दिष्टेन तु पता ।
--
-- (the pointed-at one: the mātrā alone is not an address; the mātrā
--  together with the rank inside its own fibre is one — and the number
--  of ranks it must carry at weight n is Virahāṅka's number.)
--
-- ────────────────────────────────────────────────────────────────────
-- RECOGNITION FIRST, because this repository keeps rebuilding what it
-- already owns.  Everything this module needs was ALREADY PROVED here
-- and nothing of it is reproved:
--
--   `PingalaPrastara.matrameruIso`  Metre (2+n) ≃ Metre (1+n) ⊎ Metre n
--   `PingalaPrastara.matraCount`    Metre n ≃ Fin (matra n)
--   `PingalaPrastara.matraRecurrence`  matra (2+n) ≡ matra (1+n) + matra n
--   `Chandomudra_…`                 fiber matraOf n ≡ Metre n, on the nose
--   `Virahanka_…`                   the same recurrence as an EQUIVALENCE
--                                   on `List Bool`, with both base cases
--                                   contractible and the loss theorem
--   `Bharavrtti_…`                  the generic weighted-fibre split
--   `Pata_…`                        वहनम् (receipt, unconditional) and
--                                   पता (address, iff identification)
--
-- So "the mātrā fibre's recurrence, as an equivalence and not a count"
-- is DONE, twice, and was done before this file was opened.  What was
-- NOT anywhere is the statement those files jointly set up and none of
-- them makes: the exact repair of `Pata_…`'s refusal.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE.
--
-- `Pata_…` §४ proves `¬ पता मात्रा`: the weight is a receipt and refuses
-- to be an address, because लघु लघु and गुरु both weigh 2.  It stops
-- there.  It does not say what is missing, and "what is missing" is a
-- theorem, not a gloss:
--
--   §२  समष्टिः    Pattern ≅ Σ[ n ∈ ℕ ] Metre n
--                 — carrying the whole fibre is ALWAYS an address, for
--                   the same reason the receipt is always free: the
--                   inner Σ is a `singl`.  No hypothesis on matraOf.
--
--   §३  मात्रोद्दिष्टम् Pattern ≅ Σ[ n ∈ ℕ ] Fin (matra n)
--                 — and the fibre may be replaced by a NUMBER below
--                   Virahāṅka's, via `matraCount`, whose proof is
--                   `matrameruIso`: the two-step recurrence is what
--                   supplies the in-fibre rank.
--
--   §४  विस्तारः    fst ∘ fun मात्रोद्दिष्टम् ≡ matraOf, definitionally
--                 — this is why it is a REPAIR of matraOf and not merely
--                   some other bijection.  The address EXTENDS the
--                   receipt; its first component IS the weight.
--
--   §५  मात्रा-न-पता  ¬ पता matraOf, and  उद्दिष्ट-पता  पता of the extended
--                 map.  The two stand side by side over one weight
--                 function, which is the whole arc: **the second
--                 component cannot be dropped, and with it nothing else
--                 is needed.**
--
--   §६  मूल्यम्     matra (2+n) ≡ matra (1+n) + matra n
--                 — the price, quoted from `matraRecurrence`.  The
--                   number of ranks the address must carry at weight n
--                   is exactly the fibre's cardinality, and that
--                   cardinality obeys Virahāṅka's rule.  So the
--                   recurrence is not decoration on this statement; it
--                   is the size of the field that had to be added.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES, and what is NOT claimed of them.
--
-- Piṅgala, छन्दःशास्त्रम् ८.२३–३५ (~300 BCE), the प्रत्ययाः: प्रस्तार (lay the
-- table out by a rule, do not store it), नष्ट (given a place, recover the
-- pattern), उद्दिष्ट (given the pattern, recover its place, ८.२४–२५), and
-- सङ्ख्या (how many).  मात्रा is his weight, लघु = 1 and गुरु = 2.  The
-- two-step recurrence on मात्रा-totals is Virahāṅka, वृत्तजातिसमुच्चय,
-- c. 600–800 CE (the range is H. D. Velankar's, from his 1962 edition).
-- The array is worked with in हलायुध, मृतसञ्जीवनी, 10th c. CE.  The
-- recurrence is usually cited under Fibonacci's name (1202); that is a
-- restatement, named here after the source and as one.
--
-- SECOND-HAND, and marked as such.  None of these texts has been opened
-- by the author of this file.  Every citation above is carried from
-- `formal/cubical/PingalaPrastara.agda`,
-- `formal/cubical/Chandomudra_…agda` and this repository's ledger
-- `.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt`
-- (row `Nasta|Uddista`, छन्दःशास्त्रम् ८.२४–२५), and is owed at verse
-- level.
--
-- NOT CLAIMED.  Not that Piṅgala, Virahāṅka or Halāyudha stated a fibre,
-- a type, an equivalence, or a total space, and not that any of them
-- distinguished a receipt from an address.  What IS claimed is narrower
-- and checkable inside this lane: that उद्दिष्ट is a rank-within-a-family
-- procedure; that मात्रा is the weight Piṅगala's मात्रावृत्त enumeration
-- grades by; and that the family graded by मात्रा at total n is the fibre
-- `Metre n`, which is `PingalaPrastara`'s definition and not an
-- attribution.  The compound मात्रोद्दिष्ट is BUILT HERE from two of his
-- terms and is not claimed as attested; its two heads are sourced above.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Uddista_TheReceiptBecomesAnAddressExactlyWhenTheFibreRankIsCarriedAndItsPriceIsVirahankasNumber where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; compIso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; ΣPathP ; Σ-cong-iso-snd)
open import Cubical.Relation.Nullary using (¬_)

open import PingalaPrastara
  using (Syllable ; laghu ; guru ; Pattern ; matraOf ; Metre
        ; matra ; matraCount ; matraRecurrence)

open import Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification
  using (पता ; पता→समता ; पुनरुद्धारः)

open Iso

------------------------------------------------------------------------
-- १ · The two things already known, restated in one place so the arc is
--     readable without opening four files.  Neither line is new.
--
--     `matraCount n` is `Metre n ≅ Fin (matra n)`, proved in
--     `PingalaPrastara` BY `matrameruIso` — Virahāṅka's argument on the
--     first syllable — with the two contractible base cases.  That is
--     where the recurrence enters this module, and it enters as the
--     construction of the rank, not as a count quoted afterwards.
------------------------------------------------------------------------

अङ्कनम् : (n : ℕ) → Iso (Metre n) (Fin (matra n))
अङ्कनम् = matraCount

------------------------------------------------------------------------
-- २ · समष्टिः — THE TOTAL SPACE.  Carrying the whole fibre is always an
--     address, with no hypothesis whatsoever on matraOf.
--
--     This is `Pata_…` §२'s वहनम् one step further along: there the
--     receipt was free because `Σ[ b ] (f a ≡ b)` is contractible; here
--     the pattern is recovered from the pair because the pair still
--     CONTAINS it.  Trivial as a construction, and it is the exact
--     hinge — the defect of a receipt is measured by its fibre and by
--     nothing else.
------------------------------------------------------------------------

समष्टिः : Iso Pattern (Σ[ n ∈ ℕ ] Metre n)
fun समष्टिः p = matraOf p , (p , refl)
inv समष्टिः (n , (p , e)) = p
leftInv समष्टिः p = refl
rightInv समष्टिः (n , (p , e)) =
  ΣPathP (e , ΣPathP (refl , λ i j → e (i ∧ j)))

------------------------------------------------------------------------
-- ३ · मात्रोद्दिष्टम् — the fibre replaced by a rank below Virahāṅka's
--     number.  A prosodic pattern IS a weight together with a place in
--     the मात्रा-प्रस्तार of that weight, and nothing has been lost.
------------------------------------------------------------------------

मात्रोद्दिष्टम् : Iso Pattern (Σ[ n ∈ ℕ ] Fin (matra n))
मात्रोद्दिष्टम् = compIso समष्टिः (Σ-cong-iso-snd अङ्कनम्)

मात्रोद्दिष्ट-समता : Pattern ≃ (Σ[ n ∈ ℕ ] Fin (matra n))
मात्रोद्दिष्ट-समता = isoToEquiv मात्रोद्दिष्टम्

------------------------------------------------------------------------
-- ४ · विस्तारः — and it EXTENDS the receipt: the first component of the
--     address is the mātrā itself, definitionally.
--
--     Without this line §३ would only say that Pattern happens to be in
--     bijection with a graded family, which is a much weaker and much
--     less interesting statement.  With it, §३ says that matraOf's
--     failure is repaired IN PLACE: keep the number you already had,
--     add the rank, stop.
------------------------------------------------------------------------

विस्तारः : (p : Pattern) → fst (fun मात्रोद्दिष्टम् p) ≡ matraOf p
विस्तारः p = refl

-- and in the other direction: the mātrā may be read off the address
-- without recovering the pattern at all.
मात्रा-पठनम् : (a : Σ[ n ∈ ℕ ] Fin (matra n))
             → matraOf (inv मात्रोद्दिष्टम् a) ≡ fst a
मात्रा-पठनम् a = cong fst (rightInv मात्रोद्दिष्टम् a)

------------------------------------------------------------------------
-- ५ · The arc, both signs over one weight function.
--
--     `Pata_…` proved the refusal on its own copy of the alphabet.  It
--     is proved again here on `PingalaPrastara.Pattern`, three lines,
--     rather than moved across an identification nobody has written —
--     the same choice `Avrtti_…` §३ made for `varna` against `length`,
--     and for the same reason.  What IS imported is the PREDICATE पता,
--     so the two verdicts are verdicts about the same notion.
------------------------------------------------------------------------

द्विलघु एकगुरु : Pattern
द्विलघु = laghu ∷ laghu ∷ []
एकगुरु  = guru ∷ []

तुल्य-मात्रा : matraOf द्विलघु ≡ matraOf एकगुरु
तुल्य-मात्रा = refl

शिरः : Pattern → Bool
शिरः []          = true
शिरः (laghu ∷ _) = true
शिरः (guru ∷ _)  = false

भिन्न-रूपे : ¬ (द्विलघु ≡ एकगुरु)
भिन्न-रूपे p = true≢false (cong शिरः p)

-- THE REFUSAL: the weight alone is a receipt and no more.
मात्रा-न-पता : ¬ (पता matraOf)
मात्रा-न-पता q =
  भिन्न-रूपे (sym (पुनरुद्धारः matraOf q द्विलघु)
              ∙ cong (fst q) तुल्य-मात्रा
              ∙ पुनरुद्धारः matraOf q एकगुरु)

-- THE REPAIR: the weight together with the in-fibre rank is an address,
-- in exactly the sense the refusal denied of the weight alone.
उद्दिष्ट-पता : पता (fun मात्रोद्दिष्टम्)
उद्दिष्ट-पता = inv मात्रोद्दिष्टम् , leftInv मात्रोद्दिष्टम् , rightInv मात्रोद्दिष्टम्

-- and therefore the pattern may be DROPPED and recomputed from the pair,
-- which is what makes प्रस्तार storage-free in the mātrā lane too.
पुनर्गणना : (p : Pattern) → inv मात्रोद्दिष्टम् (fun मात्रोद्दिष्टम् p) ≡ p
पुनर्गणना = पुनरुद्धारः (fun मात्रोद्दिष्टम्) उद्दिष्ट-पता

------------------------------------------------------------------------
-- ६ · मूल्यम् — THE PRICE.  How many ranks the address must be able to
--     carry at weight n: exactly `matra n`, the cardinality of the fibre
--     §२ showed to be the whole defect.  And that number obeys
--     Virahāṅka's two-step rule, quoted from `PingalaPrastara`.
--
--     So the recurrence is not adjacent to this statement.  It is the
--     size of the field that had to be added to make the receipt an
--     address, and it is the reason the added field is small: a place in
--     matra n, not a pattern.
------------------------------------------------------------------------

मूल्यम् : (n : ℕ) → matra (suc (suc n)) ≡ matra (suc n) + matra n
मूल्यम् = matraRecurrence

------------------------------------------------------------------------
-- ७ · What is NOT shown, said rather than left to be assumed.
--
--     (a) No claim that this address is Piṅgala's own मात्रा-प्रस्तार
--         ORDER.  `matraCount` is built from `matrameruIso` and
--         `Fin+≅Fin⊎Fin`, so the rank it assigns is determined by that
--         composite and is a rank; whether it agrees row-for-row with
--         the order the tradition lays the मात्रा-प्रस्तार out in is a
--         separate question and is not answered here.  §४ pins only the
--         FIRST component.
--
--     (b) No claim of minimality beyond cardinality.  `matra n` is the
--         exact size of the fibre, so no smaller rank type can do; that
--         is `matraCount` and needs nothing further.  It is not a claim
--         about bits, encodings, or the cost of computing नष्ट.
--
--     (c) No closed form for `matra`, and none is wanted here.
--
--     (d) The general statement — that §२ holds for ANY map and so every
--         receipt is completed to an address by its own fibre — is true
--         and is one line, and is deliberately not stated as a lemma
--         here because `Pata_…` is where the general law belongs and
--         this file is the instance that shows what the general law
--         costs at Piṅgala's weight.
------------------------------------------------------------------------
