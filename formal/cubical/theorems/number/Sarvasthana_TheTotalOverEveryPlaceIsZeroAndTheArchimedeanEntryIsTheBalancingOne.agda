{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡∞‡‡µ‡‡‡‡æ‡®‡Æ‡ ‚î ‡‡∞‡‡µ‡‡‡ ‡‡‡‡æ‡®‡‡‡ ‡Ø‡ã‡ó‡ ‡‡‡®‡‡Ø‡Æ‡ ; ‡‡®‡®‡‡-‡‡‡‡æ‡®‡ ‡‡‡≤‡æ-‡‡¶‡Æ‡ ‡
--
-- (all the places: the total over every place is zero, and the
--  archimedean entry is the one that balances the books.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  The corpus prices things at FINITE places and has never
-- had an archimedean one.  `Pairfield/Apavartana_‚¶lean` is the local half:
-- for an explicit Smith form it computes `rankAt p` and proves `bad_iff` ‚î
-- the rank drops exactly at the primes dividing the elementary divisors,
-- so the ramified points on Spec ‚ are named.  (It is a worked INSTANCE,
-- divisors [2,12], det 24 ‚î not a general formula, and this module does
-- not assume more of it than that.)
--
-- What was missing is the entry at ‚àû, and with it the reason the local
-- prices are not a list of unrelated losses: THEY SUM TO ZERO.  A defect
-- at one place is not an absolute loss; it is compensated, and the
-- compensating term lives at a place the local method cannot see.  ¬ß‡® is
-- that, and ¬ß‡ says what kind of object it is in this corpus's terms.
--
-- WHY THERE ARE NO REAL NUMBERS HERE.  The classical statement multiplies
-- absolute values and needs |¬|_‚àû.  Taken additively it needs only
-- WEIGHTS: write w p for the weight of the place p (classically log p),
-- leave w abstract, and the whole content survives in ‚.  Abstracting w
-- is not a weakening ‚î it is the honest form, because nothing below
-- depends on what the weights are, only on the two entries being taken
-- with opposite sign.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- TERMS.  ‡‡‡‡æ‡® (place, position) and ‡‡∞‡‡µ (all) in their plain senses.
-- ‡‡‡≤‡æ is the balance-scale ‚î the ordinary word, and the sign of Libra in
-- Indian astronomy; used here for the entry that makes the scale rest.
-- ‡‡®‡®‡‡ (endless) is used for the archimedean place; in Jaina mathematics
-- ‡‡®‡®‡‡ is a technical term with its own orders, distinguished from
-- ‡‡‡‡ñ‡‡Ø‡æ‡ (Anuyogadvra, akhagama tradition), and NO connection to
-- that classification is claimed ‚î the word is borrowed for the place at
-- infinity and nothing of the Jaina theory of the infinite is used.
------------------------------------------------------------------------

module Sarvasthana_TheTotalOverEveryPlaceIsZeroAndTheArchimedeanEntryIsTheBalancingOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _¬∑_ ; -_)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Algebra.CommRing using (CommRingStr)
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡ø‡‡æ‡ó‡ ‚î a divisor: an exponent at each of finitely many places.
--     The place is an index; nothing below needs it to be prime.
------------------------------------------------------------------------

‡§µ‡§ø‡§≠‡§æ‡§ó‡§É : Type‚ÇÄ
‡§µ‡§ø‡§≠‡§æ‡§ó‡§É = List (‚Ñï √ó ‚Ñ§)

-- w assigns a weight to each place.  Classically w p = log p; left
-- abstract, because nothing here depends on which weights they are.
‡§≠‡§æ‡§∞‡§É : Type‚ÇÄ
‡§≠‡§æ‡§∞‡§É = ‚Ñï ‚Üí ‚Ñ§

------------------------------------------------------------------------
-- ‡® ¬ ‡‡æ‡®‡‡-‡Ø‡ã‡ó‡ ‚î the finite entry.  |x|_p is p^(‚àív_p x), so the finite
--     place contributes MINUS the exponent times the weight.
------------------------------------------------------------------------

‡§∏‡§æ‡§®‡•ç‡§§ : ‡§≠‡§æ‡§∞‡§É ‚Üí ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É ‚Üí ‚Ñ§
‡§∏‡§æ‡§®‡•ç‡§§ w []            = pos 0
‡§∏‡§æ‡§®‡•ç‡§§ w ((p , e) ‚à∑ r) = (- e) ¬∑ w p + ‡§∏‡§æ‡§®‡•ç‡§§ w r

------------------------------------------------------------------------
-- ‡© ¬ ‡‡®‡®‡‡-‡Ø‡ã‡ó‡ ‚î the archimedean entry.  |x|_‚àû is the size itself, so
--     it contributes PLUS the exponent times the weight.  This is a
--     separate definition, not `- ‡‡æ‡®‡‡`: if it were defined as the
--     negation the theorem below would be true by unfolding and would say
--     nothing.  It is defined independently and the cancellation is
--     PROVED.
------------------------------------------------------------------------

‡§Ö‡§®‡§®‡•ç‡§§ : ‡§≠‡§æ‡§∞‡§É ‚Üí ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É ‚Üí ‚Ñ§
‡§Ö‡§®‡§®‡•ç‡§§ w []            = pos 0
‡§Ö‡§®‡§®‡•ç‡§§ w ((p , e) ‚à∑ r) = e ¬∑ w p + ‡§Ö‡§®‡§®‡•ç‡§§ w r

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡≤‡æ ‚î THE BOOKS BALANCE, for every divisor and every weighting.
--
--     This is the whole law: a defect priced at one place is never an
--     absolute loss, because the entries over all places sum to zero.
--     Loss is local; the total was always nothing.
------------------------------------------------------------------------

‡§§‡•Å‡§≤‡§æ : (w : ‡§≠‡§æ‡§∞‡§É) (D : ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É) ‚Üí ‡§∏‡§æ‡§®‡•ç‡§§ w D + ‡§Ö‡§®‡§®‡•ç‡§§ w D ‚â° pos 0
‡§§‡•Å‡§≤‡§æ w []            = refl
‡§§‡•Å‡§≤‡§æ w ((p , e) ‚à∑ r) =
  ‡§™‡•Å‡§®‡§∞‡•ç‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‡§É e (w p) (‡§∏‡§æ‡§®‡•ç‡§§ w r) (‡§Ö‡§®‡§®‡•ç‡§§ w r)
  ‚àô cong (pos 0 +_) (‡§§‡•Å‡§≤‡§æ w r)
  where
  -- the two weight terms are negatives of each other, and that is the
  -- ONLY reason this holds -- ‡‡æ‡®‡‡ takes (- e), ‡‡®‡®‡‡ takes e.  The
  -- lemma is stated with the exponent visible so that is on the page.
  ‡§™‡•Å‡§®‡§∞‡•ç‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‡§É : (e wp b d : ‚Ñ§)
               ‚Üí ((- e) ¬∑ wp + b) + (e ¬∑ wp + d) ‚â° pos 0 + (b + d)
  ‡§™‡•Å‡§®‡§∞‡•ç‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‡§É e wp b d = solve! ‚Ñ§CommRing

------------------------------------------------------------------------
-- ‡ ¬ ‡‡®‡‡‡‡ ‚î WHAT KIND OF OBJECT THE CONSERVATION LAW IS.
--
--     ¬ß‡ says the total observable is CONSTANT.  Read through this
--     corpus's own criterion ‚î which side of `f a ‚â° b` is bound ‚î that
--     settles its whole fibre structure at once, and it comes out with
--     all three counts and no fourth:
--
--       ‡‡‡    over pos 0 : the fibre is EVERY divisor (¬ß‡.‡ß)
--       ‡∞‡ø‡ï‡‡‡Æ‡ over anything else : no divisor at all (¬ß‡.‡®)
--       ‡‡ï‡Æ‡   nowhere.
--
--     So "the books balance" is not a coincidence about the entries; it
--     is the statement that the observable which totals them cannot
--     distinguish one divisor from another.  Its blindness is total, and
--     that blindness IS the conservation law.  A quantity that separated
--     divisors would not be conserved.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; iso)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Data.Int using (isSet‚Ñ§)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Sigma using (Œ£-syntax ; Œ£PathP)

‡§Ø‡•ã‡§ó‡§É : ‡§≠‡§æ‡§∞‡§É ‚Üí ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É ‚Üí ‚Ñ§
‡§Ø‡•ã‡§ó‡§É w D = ‡§∏‡§æ‡§®‡•ç‡§§ w D + ‡§Ö‡§®‡§®‡•ç‡§§ w D

-- ‡.‡ß ¬ ‡‡‡ ‚î the fibre over zero is everything.
‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É : (w : ‡§≠‡§æ‡§∞‡§É) ‚Üí fiber (‡§Ø‡•ã‡§ó‡§É w) (pos 0) ‚âÉ ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É
‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É w = isoToEquiv (iso fst ‡§™‡•ç‡§∞‡§§‡§ø (Œª _ ‚Üí refl) ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø)
  where
  ‡§™‡•ç‡§∞‡§§‡§ø : ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É ‚Üí fiber (‡§Ø‡•ã‡§ó‡§É w) (pos 0)
  ‡§™‡•ç‡§∞‡§§‡§ø D = D , ‡§§‡•Å‡§≤‡§æ w D
  ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø : (x : fiber (‡§Ø‡•ã‡§ó‡§É w) (pos 0)) ‚Üí ‡§™‡•ç‡§∞‡§§‡§ø (fst x) ‚â° x
  ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø (D , p) i = D , isSet‚Ñ§ (‡§Ø‡•ã‡§ó‡§É w D) (pos 0) (‡§§‡•Å‡§≤‡§æ w D) p i

-- ‡.‡® ¬ ‡∞‡ø‡ï‡‡‡Æ‡ ‚î over any other value the fibre is empty.
‡§Ö‡§®‡•ç‡§Ø-‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç : (w : ‡§≠‡§æ‡§∞‡§É) (k : ‚Ñ§) ‚Üí ¬¨ (pos 0 ‚â° k) ‚Üí ¬¨ (fiber (‡§Ø‡•ã‡§ó‡§É w) k)
‡§Ö‡§®‡•ç‡§Ø-‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç w k ne (D , p) = ne (sym (‡§§‡•Å‡§≤‡§æ w D) ‚àô p)
