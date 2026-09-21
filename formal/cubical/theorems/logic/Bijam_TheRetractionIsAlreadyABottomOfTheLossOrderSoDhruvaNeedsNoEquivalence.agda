{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡Æ‡ ‚î ‡‡ï‡Æ‡ ‡‡µ ‡‡‡‡ ‡‡‡‡∞‡‡‡ ‡‡ø‡¶‡‡ß‡æ‡®‡‡‡‡‡ ; ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ ‡‡µ ‡‡ß‡‡‡‡‡æ‡®‡, ‡® ‡‡Æ‡‡æ ‡
--
-- (one seed in four theorems; and a RETRACTION already puts a map at the
--  bottom of the loss order ‚î an equivalence is more than is needed.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE SEED.  Four theorems in this corpus are the SAME TERM:
--
--   Vyapti.‡‡‡∞‡ï‡‡‡ï-‡µ‡‡¶‡‡ß‡ø‡   (h , p) cons a  = p _  ‚àô cong h (cons a) ‚àô sym (p a)
--   Vyapti.‡‡®‡‡‡-‡µ‡‡¶‡‡ß‡ø‡      (h , p) a (x,q) = p x  ‚àô cong h q        ‚àô sym (p a)
--   Vyapti.‡‡Æ‡‡æ-‡µ‡‡¶‡‡ß‡ø‡      (h , p) a a' q  = p a  ‚àô cong h q        ‚àô sym (p a')
--   Bahupratyanayana.‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡-‡‡®‡‡
--        (r , ret) b (a‚,p‚) (a‚,p‚)  = sym (ret a‚) ‚àô cong r (p‚ ‚àô sym p‚) ‚àô ret a‚
--
-- `Œ ‚àô cong k Œ≤ ‚àô sym Œ≥` ‚î conjugate a path by a coherence.  Each is
-- proved directly in its own module; none is derived from another; and
-- the shape is not remarked anywhere.  ¬ß‡® names it once.
--
-- AND NAMING IT SHOWS A HYPOTHESIS IS TOO STRONG.  Read the fourth in the
-- vocabulary of the first three: with `g = idfun A` and `k = r`, the
-- coherence `p : (a : A) ‚í g a ‚â° k (f a)` IS `a ‚â° r (f a)` ‚î which is
-- exactly a retraction, reversed.  So
--
--     a RETRACTION of f is a ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø-witness that f is at the BOTTOM
--     of the loss order  (¬ß‡©).
--
-- `Vyapti.‡‡Æ‡‡‡µ‡Æ‡-‡‡ß‡‡‡‡‡Æ‡` puts an EQUIVALENCE at the bottom, using
-- `invEq`/`retEq`.  Only the retraction half is used.  ¬ß‡ therefore
-- weakens `Dhruva`'s theorem ‚î and `Vyapti`'s one-line reproof of it ‚î
-- from `isEquiv f` to `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ f`:
--
--     ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶ ‚í (a : A) ‚í Œ¶ a ‚â° a
--
-- No loss, no motion ‚î and "no loss" needs only that the map can be
-- UNDONE, not that it is an identification.  A retraction is strictly
-- weaker: `Unit ‚í S¬` has one and is not an equivalence, and
-- `Bahupratyanayana` ¬ß‡ is that example.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- No claim that the seed is the ONLY shape in the corpus, nor that every
-- theorem of this form is an instance of ¬ß‡® ‚î `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡-‡‡®‡‡`'s inner
-- path is `p‚ ‚àô sym p‚`, built from the two fibre witnesses, and ¬ß‡® takes
-- that path as given rather than constructing it.  The seed is the
-- conjugation, not the whole proof.
--
-- ‡‡‡ (seed) in its plain sense; no text is claimed.  The mathematics is
-- cubical type theory.
------------------------------------------------------------------------

module Bijam_TheRetractionIsAlreadyABottomOfTheLossOrderSoDhruvaNeedsNoEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)

open import Vyapti_TheLossOrderIsCoarseningAndTheSymmetryMonoidGrowsMonotonicallyAlongIt
  using (_‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø_ ; ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§ï-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É)
open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡‡Æ‡ ‚î the seed, once.  A coherence carries an identification.
--     This is `‡‡Æ‡‡æ-‡µ‡‡¶‡‡ß‡ø‡` with the factorisation unpacked, written to
--     be the thing the other three instantiate rather than a fifth copy.
------------------------------------------------------------------------

‡§¨‡•Ä‡§ú‡§Æ‡•ç : {A B C : Type ‚Ñì} {f : A ‚Üí B} {g : A ‚Üí C}
      ‚Üí (k : B ‚Üí C) ‚Üí ((a : A) ‚Üí g a ‚â° k (f a))
      ‚Üí {a a' : A} ‚Üí f a ‚â° f a' ‚Üí g a ‚â° g a'
‡§¨‡•Ä‡§ú‡§Æ‡•ç k p {a} {a'} q = p a ‚àô cong k q ‚àô sym (p a')

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ IS a bottom-witness.  A retraction of f factors the
--     identity through f ‚î which is what `‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø` asks for ‚î so f
--     lies at the bottom of the loss order with no equivalence anywhere.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç : {A : Type ‚Ñì} {B : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí Type ‚Ñì
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç {A = A} {B = B} f = Œ£[ r ‚àà (B ‚Üí A) ] ((a : A) ‚Üí r (f a) ‚â° a)

‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç : {A B : Type ‚Ñì} (f : A ‚Üí B)
                   ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç f ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun A)
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f (r , ret) = r , Œª a ‚Üí sym (ret a)

------------------------------------------------------------------------
-- ‡ ¬ ‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡, from a retraction alone.
--
--     Dhruva ¬ß‡® and Vyapti's reproof both take `isEquiv f`.  Only the
--     retraction is used.  The conclusion is unchanged; the hypothesis
--     is strictly weaker, and `Unit ‚í S¬` is a map that HAS a retraction
--     and is NOT an equivalence.
------------------------------------------------------------------------

‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•á‡§® :
    {A B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
  ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•á‡§® {f = f} ret =
  ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§ï-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f ret)

------------------------------------------------------------------------
-- ‡ ¬ THE STRONGEST FORM, and it names no external notion at all.
--
--     ¬ß‡ was written as "Dhruva with a weaker hypothesis", which is the
--     wrong way round: a weaker hypothesis is a STRONGER THEOREM ‚î same
--     conclusion, strictly larger domain.  And the hypothesis it actually
--     consumes is neither `isEquiv` nor `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡`.  It is
--
--         f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø (idfun A)
--
--     ‚î f is at the BOTTOM of the loss order ‚î and that is the whole of
--     it.  Both `isEquiv f` (Vyapti.‡‡Æ‡‡‡µ‡Æ‡-‡‡ß‡‡‡‡‡Æ‡) and `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ f`
--     (¬ß‡©) are ways of EXHIBITING bottom-ness, and neither is the
--     hypothesis.  Stated this way the law is internal: it mentions only
--     the order and conservation, and nothing from outside.
--
--     So the reading of `‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡` is not "an equivalence
--     admits only the trivial symmetry".  It is:
--
--         AT THE BOTTOM OF THE LOSS ORDER, CONSERVATION IS TRIVIALITY.
--
--     which is what Vyapti already said about the order's ends and did
--     not say about this theorem.
------------------------------------------------------------------------

‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Ç-‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç :
    {A B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
  ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun A) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Ç-‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç = ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§ï-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É

-- and the two named hypotheses are corollaries, not the law
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§æ‡§§‡•ç : {A B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
              ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§æ‡§§‡•ç {f = f} r = ‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Ç-‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f r)

------------------------------------------------------------------------
-- ‡ ¬ THE BOTTOM IS CLOSED UNDER COMPOSITION, and this strengthens
--     `Samyoge` ¬ß‡® the same way ¬ß‡ strengthens Dhruva.
--
--     `Samyoge_‚¶agda` ¬ß‡® says "lossless composes" and proves it with
--     `compEquiv` ‚î two EQUIVALENCES.  What composes is bottom-ness, and
--     the proof is the seed with its first component `refl`:
--
--         p a ‚àô cong h (q (f a))
--
--     So a route every step of which can merely BE UNDONE is itself
--     undoable, at any length.  That is the version the machine actually
--     needs: it demands receipts, and a receipt in the operative sense is
--     a way back, not an identification.
--
--     And with ¬ß‡ this is one statement: certification composes because
--     THE BOTTOM OF THE ORDER IS A SUBMONOID, and conservation is trivial
--     there.  Vyapti proved the conserving flows form a submonoid at a
--     fixed observation; this is the other axis.
------------------------------------------------------------------------

‡§Ö‡§ß‡§É‡§∏‡•ç‡§•-‡§∏‡§®‡•ç‡§ß‡§ø‡§É : {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C)
              ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun A) ‚Üí g ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun B)
              ‚Üí (Œª a ‚Üí g (f a)) ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun A)
‡§Ö‡§ß‡§É‡§∏‡•ç‡§•-‡§∏‡§®‡•ç‡§ß‡§ø‡§É f g (h , p) (k , q) =
  (Œª c ‚Üí h (k c)) , Œª a ‚Üí p a ‚àô cong h (q (f a))

-- the same for the named form, since that is what callers hold
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®-‡§∏‡§®‡•ç‡§ß‡§ø‡§É : {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C)
                  ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç f ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç g
                  ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç (Œª a ‚Üí g (f a))
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®-‡§∏‡§®‡•ç‡§ß‡§ø‡§É f g (r , ret) (s , sec) =
  (Œª c ‚Üí r (s c)) , Œª a ‚Üí cong r (sec (f a)) ‚àô ret a

------------------------------------------------------------------------
-- ‡ ¬ THE BOTTOM IS A SUBMONOID AND IT IS NOT SATURATED.
--
--     ¬ß‡ closes the bottom under composition.  The converse FAILS, and
--     that is `Samyoge` ¬ß‡© restated where it belongs ‚î in the order's own
--     vocabulary rather than as a remark about pipelines:
--
--         `g ‚àò f` at the bottom does NOT imply `f` or `g` is.
--
--     Witness, and both halves are already in the corpus:
--       ‡‡‡ : Unit ‚í Bool, tt ‚¶ true ‚î HAS a retraction (Unit is the
--         target of one trivially), so ‡‡‡ IS at the bottom.
--       ‡‡ï‡Æ‡ : Bool ‚í Unit ‚î has NO retraction (¬ß‡ of Bahupratyanayana,
--         and ¬ß‡ below reproves it in one line), so ‡‡ï‡Æ‡ is NOT.
--       ‡‡ï‡Æ‡ ‚àò ‡‡‡ : Unit ‚í Unit is the identity, which is the bottom.
--
--     So the composite lies at the bottom while its second factor does
--     not.  A submonoid that is not saturated: membership propagates
--     FORWARD along composition and not BACKWARD.
--
--     That is the exact content of "certification composes, refutation
--     does not", with no pipeline and no metaphor: you may conclude the
--     whole is undoable from the parts, and you may NOT conclude a part is
--     not undoable from the whole.
------------------------------------------------------------------------

open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬¨_)

‡§∏‡§§‡•ç : Unit ‚Üí Bool
‡§∏‡§§‡•ç _ = true

‡§è‡§ï‡§Æ‡•ç : Bool ‚Üí Unit
‡§è‡§ï‡§Æ‡•ç _ = tt

-- ‡‡‡ is at the bottom: anything into Unit retracts it
‡§∏‡§§‡•ç-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç : ‡§∏‡§§‡•ç ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun Unit)
‡§∏‡§§‡•ç-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç = (Œª _ ‚Üí tt) , (Œª { tt ‚Üí refl })

-- ‡‡ï‡Æ‡ is not: two distinct sources over the one target
‡§è‡§ï‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§Æ‡•ç : ¬¨ (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç ‡§è‡§ï‡§Æ‡•ç)
‡§è‡§ï‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§Æ‡•ç (r , ret) =
  false‚â¢true (sym (ret false) ‚àô ret true)

-- and the composite is the identity, hence at the bottom
‡§∏‡§®‡•ç‡§ß‡§ø‡§É-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§É : (Œª (u : Unit) ‚Üí ‡§è‡§ï‡§Æ‡•ç (‡§∏‡§§‡•ç u)) ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun Unit)
‡§∏‡§®‡•ç‡§ß‡§ø‡§É-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§É = (Œª _ ‚Üí tt) , (Œª { tt ‚Üí refl })

------------------------------------------------------------------------
-- ‡Æ ¬ FOUR STATEMENTS OF ONE THEOREM, three of them over `isEquiv`.
--
--   Dhruva.‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡          isEquiv, via a contractible FIBRE
--   Vyapti.‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡-‡µ‡‡Ø‡æ‡‡‡‡‡Ø‡æ  isEquiv, via the ORDER
--   SvaFiberVasa.‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡             isEquiv, via contractibility of
--                                      the whole FLOW SPACE
--   ¬ß‡ here                            f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø (idfun A) ‚î the bottom
--
-- Same conclusion, four routes, and the fourth needs none of the other
-- three's machinery: no fibre, no flow space, no equivalence.  ¬ß‡Æ derives
-- the isEquiv form from ¬ß‡ so the containment is a term and not a remark.
--
-- AND ONE OF THAT FILE'S TWO IS SHARP, which is the distinction worth
-- keeping.  `SvaFiberVasa.‡ß‡‡∞‡‡µ-‡‡ø‡®‡‡¶‡‡ : isEquiv f ‚í isContr (Œ[Œ¶] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶)`
-- CANNOT weaken: the flow space is `Œ†[a] fiber f (f a)` (its own ‡µ‡æ‡‡),
-- contractible exactly when every fibre is ‚î which IS `isEquiv f`.  So in
-- one module one theorem needs the equivalence essentially and the other
-- does not, and only the second is over-hypothesised.
--
-- This is the corpus's characteristic shape rather than a defect: it
-- proves things several times, and each proof knows something the others
-- do not.  `Kosthanyaya` found the pigeonhole at five sites; `Yamaja`
-- found the third `eq‚ï`; this is the fourth Dhruva.  The value is not in
-- deleting copies ‚î it is that the copies disagree about what is needed.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (isEquiv ; invEq ; retEq)

-- an equivalence is at the bottom (Vyapti's ‡‡Æ‡‡‡µ‡Æ‡-‡‡ß‡‡‡‡‡Æ‡, restated so
-- ¬ß‡Æ is self-contained), and then the isEquiv form is one application
‡§∏‡§Æ‡§§‡§æ-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç : {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí isEquiv f ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun A)
‡§∏‡§Æ‡§§‡§æ-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f e = invEq (f , e) , Œª a ‚Üí sym (retEq (f , e) a)

‡§∏‡§Æ‡§§‡§æ‡§Ø‡§æ‡§É : {A B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
        ‚Üí isEquiv f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
‡§∏‡§Æ‡§§‡§æ‡§Ø‡§æ‡§É {f = f} e = ‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Ç-‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç (‡§∏‡§Æ‡§§‡§æ-‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡§Æ‡•ç f e)

------------------------------------------------------------------------
-- ‡Ø ¬ THE ORBIT COLLAPSES AT THE BOTTOM TOO ‚î the fifth site.
--
--   `Kaksya_‚¶.‡®‡‡‡ü‡æ‡‡æ‡µ‡-‡ï‡ï‡‡‡‡Ø‡æ-‡‡ï‡‡¶‡æ : isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶ ‚í
--    (n : ‚ï) (a : A) ‚í ‡ï‡ï‡‡‡‡Ø‡æ f Œ¶ n a ‚â° a`
--
--   ‚î the whole orbit collapses to its basepoint ‚î is proved by calling
--   `Dhruva.‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡` once per step, so it inherits ¬ß‡'s
--   hypothesis immediately: bottom-ness suffices, and the induction is the
--   seed again, `cong Œ¶ (IH) ‚àô (one step)`.
--
--   The iterate is defined here rather than imported, because that module
--   carries it inside a parametrised block; it is the same function and
--   the duplication is named, not hidden.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)

‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : {A : Type ‚Ñì} ‚Üí (A ‚Üí A) ‚Üí ‚Ñï ‚Üí A ‚Üí A
‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É Œ¶ zero    a = a
‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É Œ¶ (suc n) a = Œ¶ (‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É Œ¶ n a)

‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ :
    {A B : Type ‚Ñì} {f : A ‚Üí B} {Œ¶ : A ‚Üí A}
  ‚Üí f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø (idfun A) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶
  ‚Üí (n : ‚Ñï) (a : A) ‚Üí ‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É Œ¶ n a ‚â° a
‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ b cons zero    a = refl
‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ {Œ¶ = Œ¶} b cons (suc n) a =
  cong Œ¶ (‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§è‡§ï‡§™‡§¶‡§æ b cons n a)
  ‚àô ‡§Ö‡§ß‡§É‡§∏‡•ç‡§•‡•á-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Ç-‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç b cons a

------------------------------------------------------------------------
-- ‡ß‡¶ ¬ WHAT THE LIGHT DID NOT WEAKEN, and this half is the point.
--
--   Asking every declaration in the lane "is `isEquiv` a hypothesis where
--   bottom-ness would do" returns sites that are SHARP, and a blanket
--   sweep would have been wrong about them:
--
--     SvaFiberVasa.‡ß‡‡∞‡‡µ-‡‡ø‡®‡‡¶‡‡ ‚î the flow space is `Œ†[a] fiber f (f a)`,
--       contractible exactly when every fibre is, which IS `isEquiv f`.
--     NastoddistaPariksa.‡‡Æ‡‡æ-‡‡ï‡‡∞‡Æ‡ / ‡‡Æ‡‡æ‚í‡‡∞‡‡ï‡‡‡æ ‚î stated as an
--       equivalence in both directions; `isEquiv` is the content.
--     Kevalajnana.‡‡Æ‡æ‡®‡‡æ‚í‡‡∞‡‡µ‡‡ï‡≤‡Æ‡ ‚î ‡ï‡‡µ‡≤‡‡‡û‡æ‡® read as losing nothing AND
--       missing nothing.  An equivalence is exactly both halves, and the
--       doctrine is both halves; weakening it would break the reading, not
--       improve the theorem.
--
--   So the finding is not "isEquiv is usually too strong".  It is that
--   two theorems in ONE module can differ on this, and only opening each
--   says which ‚î SvaFiberVasa's pair is exactly that case.
------------------------------------------------------------------------
