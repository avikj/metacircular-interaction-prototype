{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡â‡¶‡‡¶‡ø‡‡‡ü‡Æ‡ ‚î ‡Æ‡æ‡‡‡∞‡æ ‡‡ï‡æ‡ï‡ø‡®‡ ‡‡‡æ ‡® ‡‡µ‡‡ø, ‡Æ‡æ‡‡‡∞‡æ ‡‡ ‡‡‡µ-‡‡®‡‡‡-‡â‡¶‡‡¶‡ø‡‡‡ü‡‡® ‡‡ ‡‡‡æ ‡
--
-- (the pointed-at one: the mtr alone is not an address; the mtr
--  together with the rank inside its own fiber is one ‚î and the number
--  of ranks it must carry at weight n is Virahka's number.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS ALREADY PROVED, and not reproved here:
--
--   `PingalaPrastara.matrameruIso`  Metre (2+n) ‚â Metre (1+n) ‚ä Metre n
--   `PingalaPrastara.matraCount`    Metre n ‚â Fin (matra n)
--   `PingalaPrastara.matraRecurrence`  matra (2+n) ‚â° matra (1+n) + matra n
--   `Chandomudra_‚¶`                 fiber matraOf n ‚â° Metre n, on the nose
--   `Virahanka_‚¶`                   the same recurrence as an EQUIVALENCE
--                                   on `List Bool`, with both base cases
--                                   contractible and the loss theorem
--   `Bharavrtti_‚¶`                  the generic weighted-fiber split
--   `Pata_‚¶`                        ‡µ‡‡®‡Æ‡ (receipt, unconditional) and
--                                   ‡‡‡æ (address, iff identification)
--
-- What none of them states is the statement they jointly set up:
-- the exact repair of `Pata_‚¶`'s denial.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED HERE.
--
-- `Pata_‚¶` ¬ß‡ proves `¬ ‡‡‡æ ‡Æ‡æ‡‡‡∞‡æ`: the weight is a receipt and cannot
-- be an address, because ‡≤‡ò‡ ‡≤‡ò‡ and ‡ó‡‡∞‡ both weigh 2.  It stops
-- there.  It does not say what is missing, and "what is missing" is a
-- theorem, not a gloss:
--
--   ¬ß‡®  ‡‡Æ‡‡‡ü‡ø‡    Pattern ‚â Œ[ n ‚àà ‚ï ] Metre n
--                 ‚î carrying the whole fiber is ALWAYS an address, for
--                   the same reason the receipt is always free: the
--                   inner Œ is a `singl`.  No hypothesis on matraOf.
--
--   ¬ß‡©  ‡Æ‡æ‡‡‡∞‡ã‡¶‡‡¶‡ø‡‡‡ü‡Æ‡ Pattern ‚â Œ[ n ‚àà ‚ï ] Fin (matra n)
--                 ‚î and the fiber may be replaced by a NUMBER below
--                   Virahka's, via `matraCount`, whose proof is
--                   `matrameruIso`: the two-step recurrence is what
--                   supplies the in-fiber rank.
--
--   ¬ß‡  ‡µ‡ø‡‡‡‡æ‡∞‡    fst ‚àò fun ‡Æ‡æ‡‡‡∞‡ã‡¶‡‡¶‡ø‡‡‡ü‡Æ‡ ‚â° matraOf, definitionally
--                 ‚î this is why it is a REPAIR of matraOf and not merely
--                   some other bijection.  The address EXTENDS the
--                   receipt; its first component IS the weight.
--
--   ¬ß‡  ‡Æ‡æ‡‡‡∞‡æ-‡®-‡‡‡æ  ¬ ‡‡‡æ matraOf, and  ‡â‡¶‡‡¶‡ø‡‡‡ü-‡‡‡æ  ‡‡‡æ of the extended
--                 map.  The two stand side by side over one weight
--                 function, which is the whole arc: **the second
--                 component cannot be dropped, and with it nothing else
--                 is needed.**
--
--   ¬ß‡  ‡Æ‡‡≤‡‡Ø‡Æ‡     matra (2+n) ‚â° matra (1+n) + matra n
--                 ‚î the price, quoted from `matraRecurrence`.  The
--                   number of ranks the address must carry at weight n
--                   is exactly the fiber's cardinality, and that
--                   cardinality obeys Virahka's rule.  So the
--                   recurrence is not decoration on this statement; it
--                   is the size of the field that had to be added.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- SOURCES.
--
-- Pigala, ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ.‡®‡©‚ì‡©‡ (~300 BCE), the ‡‡‡∞‡‡‡Ø‡Ø‡æ‡: ‡‡‡∞‡‡‡‡æ‡∞ (lay the
-- table out by a rule, do not store it), ‡®‡‡‡ü (given a place, recover the
-- pattern), ‡â‡¶‡‡¶‡ø‡‡‡ü (given the pattern, recover its place, ‡Æ.‡®‡‚ì‡®‡), and
-- ‡‡ô‡‡ñ‡‡Ø‡æ (how many).  ‡Æ‡æ‡‡‡∞‡æ is his weight, ‡≤‡ò‡ = 1 and ‡ó‡‡∞‡ = 2.  The
-- two-step recurrence on ‡Æ‡æ‡‡‡∞‡æ-totals is Virahka, ‡µ‡‡‡‡‡‡æ‡‡ø‡‡Æ‡‡‡‡‡Ø,
-- c. 600‚ì800 CE (the range is H. D. Velankar's, from his 1962 edition).
-- The array is worked with in ‡‡≤‡æ‡Ø‡‡ß, ‡Æ‡‡‡‡û‡‡‡‡µ‡®‡, 10th c. CE.  The
-- recurrence is usually cited under Fibonacci's name (1202); that is a
-- restatement, named here after the source and as one.
--
-- SECOND-HAND.  Every citation above is carried from
-- `formal/cubical/PingalaPrastara.agda`,
-- `formal/cubical/Chandomudra_‚¶agda` and this repository's ledger
-- `.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt`
-- (row `Nasta|Uddista`, ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ.‡®‡‚ì‡®‡).
------------------------------------------------------------------------

module Uddista_TheReceiptBecomesAnAddressExactlyWhenTheFiberRankIsCarriedAndItsPriceIsVirahankasNumber where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; compIso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd ; Œ£PathP ; Œ£-cong-iso-snd)
open import Cubical.Relation.Nullary using (¬¨_)

open import PingalaPrastara
  using (Syllable ; laghu ; guru ; Pattern ; matraOf ; Metre
        ; matra ; matraCount ; matraRecurrence)

open import Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification
  using (‡§™‡§§‡§æ ; ‡§™‡§§‡§æ‚Üí‡§∏‡§Æ‡§§‡§æ ; ‡§™‡•Å‡§®‡§∞‡•Å‡§¶‡•ç‡§ß‡§æ‡§∞‡§É)

open Iso

------------------------------------------------------------------------
-- ‡ß ¬ The two things already known, restated in one place so the arc is
--     readable without opening four files.  Neither line is new.
--
--     `matraCount n` is `Metre n ‚â Fin (matra n)`, proved in
--     `PingalaPrastara` BY `matrameruIso` ‚î Virahka's argument on the
--     first syllable ‚î with the two contractible base cases.  That is
--     where the recurrence enters this module, and it enters as the
--     construction of the rank, not as a count quoted afterwards.
------------------------------------------------------------------------

‡§Ö‡§ô‡•ç‡§ï‡§®‡§Æ‡•ç : (n : ‚Ñï) ‚Üí Iso (Metre n) (Fin (matra n))
‡§Ö‡§ô‡•ç‡§ï‡§®‡§Æ‡•ç = matraCount

------------------------------------------------------------------------
-- ‡® ¬ ‡‡Æ‡‡‡ü‡ø‡ ‚î THE TOTAL SPACE.  Carrying the whole fiber is always an
--     address, with no hypothesis whatsoever on matraOf.
--
--     This is `Pata_‚¶` ¬ß‡®'s ‡µ‡‡®‡Æ‡ one step further along: there the
--     receipt was free because `Œ[ b ] (f a ‚â° b)` is contractible; here
--     the pattern is recovered from the pair because the pair still
--     CONTAINS it.  Trivial as a construction, and it is the exact
--     hinge ‚î the defect of a receipt is measured by its fiber and by
--     nothing else.
------------------------------------------------------------------------

‡§∏‡§Æ‡§∑‡•ç‡§ü‡§ø‡§É : Iso Pattern (Œ£[ n ‚àà ‚Ñï ] Metre n)
fun ‡§∏‡§Æ‡§∑‡•ç‡§ü‡§ø‡§É p = matraOf p , (p , refl)
inv ‡§∏‡§Æ‡§∑‡•ç‡§ü‡§ø‡§É (n , (p , e)) = p
leftInv ‡§∏‡§Æ‡§∑‡•ç‡§ü‡§ø‡§É p = refl
rightInv ‡§∏‡§Æ‡§∑‡•ç‡§ü‡§ø‡§É (n , (p , e)) =
  Œ£PathP (e , Œ£PathP (refl , Œª i j ‚Üí e (i ‚àß j)))

------------------------------------------------------------------------
-- ‡© ¬ ‡Æ‡æ‡‡‡∞‡ã‡¶‡‡¶‡ø‡‡‡ü‡Æ‡ ‚î the fiber replaced by a rank below Virahka's
--     number.  A prosodic pattern IS a weight together with a place in
--     the ‡Æ‡æ‡‡‡∞‡æ-‡‡‡∞‡‡‡‡æ‡∞ of that weight, and nothing has been lost.
------------------------------------------------------------------------

‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç : Iso Pattern (Œ£[ n ‚àà ‚Ñï ] Fin (matra n))
‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç = compIso ‡§∏‡§Æ‡§∑‡•ç‡§ü‡§ø‡§É (Œ£-cong-iso-snd ‡§Ö‡§ô‡•ç‡§ï‡§®‡§Æ‡•ç)

‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü-‡§∏‡§Æ‡§§‡§æ : Pattern ‚âÉ (Œ£[ n ‚àà ‚Ñï ] Fin (matra n))
‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü-‡§∏‡§Æ‡§§‡§æ = isoToEquiv ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç

------------------------------------------------------------------------
-- ‡ ¬ ‡µ‡ø‡‡‡‡æ‡∞‡ ‚î and it EXTENDS the receipt: the first component of the
--     address is the mtr itself, definitionally.
--
--     Without this line ¬ß‡© would only say that Pattern happens to be in
--     bijection with a graded family, which is a much weaker and much
--     less interesting statement.  With it, ¬ß‡© says that matraOf's
--     failure is repaired IN PLACE: keep the number you already had,
--     add the rank, stop.
------------------------------------------------------------------------

‡§µ‡§ø‡§∏‡•ç‡§§‡§æ‡§∞‡§É : (p : Pattern) ‚Üí fst (fun ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç p) ‚â° matraOf p
‡§µ‡§ø‡§∏‡•ç‡§§‡§æ‡§∞‡§É p = refl

-- and in the other direction: the mtr may be read off the address
-- without recovering the pattern at all.
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§™‡§†‡§®‡§Æ‡•ç : (a : Œ£[ n ‚àà ‚Ñï ] Fin (matra n))
             ‚Üí matraOf (inv ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç a) ‚â° fst a
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§™‡§†‡§®‡§Æ‡•ç a = cong fst (rightInv ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç a)

------------------------------------------------------------------------
-- ‡ ¬ The arc, both signs over one weight function.
--
--     `Pata_‚¶` proved the denial on its own copy of the alphabet.  It
--     is proved again here on `PingalaPrastara.Pattern`, three lines,
--     rather than moved across an identification nobody has written ‚î
--     the same choice `Avrtti_‚¶` ¬ß‡© made for `varna` against `length`,
--     and for the same reason.  What IS imported is the PREDICATE ‡‡‡æ,
--     so the two verdicts are verdicts about the same notion.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å : Pattern
‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å = laghu ‚à∑ laghu ‚à∑ []
‡§è‡§ï‡§ó‡•Å‡§∞‡•Å  = guru ‚à∑ []

‡§§‡•Å‡§≤‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ : matraOf ‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å ‚â° matraOf ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å
‡§§‡•Å‡§≤‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ = refl

‡§∂‡§ø‡§∞‡§É : Pattern ‚Üí Bool
‡§∂‡§ø‡§∞‡§É []          = true
‡§∂‡§ø‡§∞‡§É (laghu ‚à∑ _) = true
‡§∂‡§ø‡§∞‡§É (guru ‚à∑ _)  = false

‡§≠‡§ø‡§®‡•ç‡§®-‡§∞‡•Ç‡§™‡•á : ¬¨ (‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å ‚â° ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å)
‡§≠‡§ø‡§®‡•ç‡§®-‡§∞‡•Ç‡§™‡•á p = true‚â¢false (cong ‡§∂‡§ø‡§∞‡§É p)

-- THE DENIAL: the weight alone is a receipt and no more.
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§®-‡§™‡§§‡§æ : ¬¨ (‡§™‡§§‡§æ matraOf)
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§®-‡§™‡§§‡§æ q =
  ‡§≠‡§ø‡§®‡•ç‡§®-‡§∞‡•Ç‡§™‡•á (sym (‡§™‡•Å‡§®‡§∞‡•Å‡§¶‡•ç‡§ß‡§æ‡§∞‡§É matraOf q ‡§¶‡•ç‡§µ‡§ø‡§≤‡§ò‡•Å)
              ‚àô cong (fst q) ‡§§‡•Å‡§≤‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ
              ‚àô ‡§™‡•Å‡§®‡§∞‡•Å‡§¶‡•ç‡§ß‡§æ‡§∞‡§É matraOf q ‡§è‡§ï‡§ó‡•Å‡§∞‡•Å)

-- THE REPAIR: the weight together with the in-fiber rank is an address,
-- in exactly the sense denied of the weight alone.
‡§â‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü-‡§™‡§§‡§æ : ‡§™‡§§‡§æ (fun ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç)
‡§â‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü-‡§™‡§§‡§æ = inv ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç , leftInv ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç , rightInv ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç

-- and therefore the pattern may be DROPPED and recomputed from the pair,
-- which is what makes ‡‡‡∞‡‡‡‡æ‡∞ storage-free in the mtr lane too.
‡§™‡•Å‡§®‡§∞‡•ç‡§ó‡§£‡§®‡§æ : (p : Pattern) ‚Üí inv ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç (fun ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç p) ‚â° p
‡§™‡•Å‡§®‡§∞‡•ç‡§ó‡§£‡§®‡§æ = ‡§™‡•Å‡§®‡§∞‡•Å‡§¶‡•ç‡§ß‡§æ‡§∞‡§É (fun ‡§Æ‡§æ‡§§‡•ç‡§∞‡•ã‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç) ‡§â‡§¶‡•ç‡§¶‡§ø‡§∑‡•ç‡§ü-‡§™‡§§‡§æ

------------------------------------------------------------------------
-- ‡ ¬ ‡Æ‡‡≤‡‡Ø‡Æ‡ ‚î THE PRICE.  How many ranks the address must be able to
--     carry at weight n: exactly `matra n`, the cardinality of the fiber
--     ¬ß‡® showed to be the whole defect.  And that number obeys
--     Virahka's two-step rule, quoted from `PingalaPrastara`.
--
--     So the recurrence is not adjacent to this statement.  It is the
--     size of the field that had to be added to make the receipt an
--     address, and it is the reason the added field is small: a place in
--     matra n, not a pattern.
------------------------------------------------------------------------

‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç : (n : ‚Ñï) ‚Üí matra (suc (suc n)) ‚â° matra (suc n) + matra n
‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç = matraRecurrence
