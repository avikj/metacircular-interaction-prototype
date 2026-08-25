{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सर्वस्थानम् — सर्वेषु स्थानेषु योगः शून्यम् ; अनन्त-स्थानं तुला-पदम् ।
--
-- (all the places: the total over every place is zero, and the
--  archimedean entry is the one that balances the books.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  The corpus prices things at FINITE places and has never
-- had an archimedean one.  `Pairfield/Apavartana_…lean` is the local half:
-- for an explicit Smith form it computes `rankAt p` and proves `bad_iff` —
-- the rank drops exactly at the primes dividing the elementary divisors,
-- so the ramified points on Spec ℤ are named.  (It is a worked INSTANCE,
-- divisors [2,12], det 24 — not a general formula, and this module does
-- not assume more of it than that.)
--
-- What was missing is the entry at ∞, and with it the reason the local
-- prices are not a list of unrelated losses: THEY SUM TO ZERO.  A defect
-- at one place is not an absolute loss; it is compensated, and the
-- compensating term lives at a place the local method cannot see.  §२ is
-- that, and §४ says what kind of object it is in this corpus's terms.
--
-- WHY THERE ARE NO REAL NUMBERS HERE.  The classical statement multiplies
-- absolute values and needs |·|_∞.  Taken additively it needs only
-- WEIGHTS: write w p for the weight of the place p (classically log p),
-- leave w abstract, and the whole content survives in ℤ.  Abstracting w
-- is not a weakening — it is the honest form, because nothing below
-- depends on what the weights are, only on the two entries being taken
-- with opposite sign.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS **NOT** CLAIMED.  This is not the product formula for ℚˣ.  It
-- does not say the finite places are the primes, that w p is log p, or
-- that a divisor determines a rational number — that last needs unique
-- factorisation, which is exactly the work this module does not do.  What
-- IS proved is the accounting skeleton those facts sit on: for any
-- assignment of exponents to places and any weights, the finite entries
-- and the archimedean entry cancel identically.  Stating the skeleton
-- separately is the point — it shows which part of "∑_v log|x|_v = 0" is
-- arithmetic and which part is bookkeeping, and it is the bookkeeping
-- half that carries the interpretation.
--
-- TERMS.  स्थान (place, position) and सर्व (all) in their plain senses.
-- तुला is the balance-scale — the ordinary word, and the sign of Libra in
-- Indian astronomy; used here for the entry that makes the scale rest.
-- अनन्त (endless) is used for the archimedean place; in Jaina mathematics
-- अनन्त is a technical term with its own orders, distinguished from
-- असंख्यात (Anuyogadvāra, Ṣaṭkhaṇḍāgama tradition), and NO connection to
-- that classification is claimed — the word is borrowed for the place at
-- infinity and nothing of the Jaina theory of the infinite is used.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Sarvasthana_TheTotalOverEveryPlaceIsZeroAndTheArchimedeanEntryIsTheBalancingOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; -_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing using (CommRingStr)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

------------------------------------------------------------------------
-- १ · विभागः — a divisor: an exponent at each of finitely many places.
--     The place is an index; nothing below needs it to be prime.
------------------------------------------------------------------------

विभागः : Type₀
विभागः = List (ℕ × ℤ)

-- w assigns a weight to each place.  Classically w p = log p; left
-- abstract, because nothing here depends on which weights they are.
भारः : Type₀
भारः = ℕ → ℤ

------------------------------------------------------------------------
-- २ · सान्त-योगः — the finite entry.  |x|_p is p^(−v_p x), so the finite
--     place contributes MINUS the exponent times the weight.
------------------------------------------------------------------------

सान्त : भारः → विभागः → ℤ
सान्त w []            = pos 0
सान्त w ((p , e) ∷ r) = (- e) · w p + सान्त w r

------------------------------------------------------------------------
-- ३ · अनन्त-योगः — the archimedean entry.  |x|_∞ is the size itself, so
--     it contributes PLUS the exponent times the weight.  This is a
--     separate definition, not `- सान्त`: if it were defined as the
--     negation the theorem below would be true by unfolding and would say
--     nothing.  It is defined independently and the cancellation is
--     PROVED.
------------------------------------------------------------------------

अनन्त : भारः → विभागः → ℤ
अनन्त w []            = pos 0
अनन्त w ((p , e) ∷ r) = e · w p + अनन्त w r

------------------------------------------------------------------------
-- ४ · तुला — THE BOOKS BALANCE, for every divisor and every weighting.
--
--     This is the whole law: a defect priced at one place is never an
--     absolute loss, because the entries over all places sum to zero.
--     Loss is local; the total was always nothing.
------------------------------------------------------------------------

तुला : (w : भारः) (D : विभागः) → सान्त w D + अनन्त w D ≡ pos 0
तुला w []            = refl
तुला w ((p , e) ∷ r) =
  पुनर्विन्यासः e (w p) (सान्त w r) (अनन्त w r)
  ∙ cong (pos 0 +_) (तुला w r)
  where
  -- the two weight terms are negatives of each other, and that is the
  -- ONLY reason this holds -- सान्त takes (- e), अनन्त takes e.  The
  -- lemma is stated with the exponent visible so that is on the page.
  पुनर्विन्यासः : (e wp b d : ℤ)
               → ((- e) · wp + b) + (e · wp + d) ≡ pos 0 + (b + d)
  पुनर्विन्यासः e wp b d = solve! ℤCommRing

------------------------------------------------------------------------
-- ५ · तन्तुः — WHAT KIND OF OBJECT THE CONSERVATION LAW IS.
--
--     §४ says the total observable is CONSTANT.  Read through this
--     corpus's own criterion — which side of `f a ≡ b` is bound — that
--     settles its whole fibre structure at once, and it comes out with
--     all three counts and no fourth:
--
--       बहु    over pos 0 : the fibre is EVERY divisor (§५.१)
--       रिक्तम् over anything else : no divisor at all (§५.२)
--       एकम्   nowhere.
--
--     So "the books balance" is not a coincidence about the entries; it
--     is the statement that the observable which totals them cannot
--     distinguish one divisor from another.  Its blindness is total, and
--     that blindness IS the conservation law.  A quantity that separated
--     divisors would not be conserved.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; iso)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Int using (isSetℤ)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (Σ-syntax ; ΣPathP)

योगः : भारः → विभागः → ℤ
योगः w D = सान्त w D + अनन्त w D

-- ५.१ · बहु — the fibre over zero is everything.
सर्व-तन्तुः : (w : भारः) → fiber (योगः w) (pos 0) ≃ विभागः
सर्व-तन्तुः w = isoToEquiv (iso fst प्रति (λ _ → refl) निवृत्ति)
  where
  प्रति : विभागः → fiber (योगः w) (pos 0)
  प्रति D = D , तुला w D
  निवृत्ति : (x : fiber (योगः w) (pos 0)) → प्रति (fst x) ≡ x
  निवृत्ति (D , p) i = D , isSetℤ (योगः w D) (pos 0) (तुला w D) p i

-- ५.२ · रिक्तम् — over any other value the fibre is empty.
अन्य-रिक्तम् : (w : भारः) (k : ℤ) → ¬ (pos 0 ≡ k) → ¬ (fiber (योगः w) k)
अन्य-रिक्तम् w k ne (D , p) = ne (sym (तुला w D) ∙ p)
