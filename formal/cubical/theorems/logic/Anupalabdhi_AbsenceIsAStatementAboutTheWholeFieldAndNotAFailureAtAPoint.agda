{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡‡≤‡‡‡ß‡ø ‚î ‡‡‡æ‡µ‡ ‡ï‡‡‡‡‡‡∞‡‡‡Ø ‡µ‡‡®‡Æ‡, ‡® ‡‡ ‡‡‡‡æ‡®‡ ‡‡‡ø‡¶‡‡ß‡ø‡ ‡
--
-- (absence is a statement about the field, not a failure at a point.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE ASYMMETRY THIS FILE IS ABOUT.  Every other verdict in this corpus
-- is witnessed by EXHIBITING something: ‡‡‡ by two points of a fibre,
-- ‡‡ï‡Æ‡ by a centre, an edge by an equivalence, a receipt by an
-- identification.  ‡∞‡ø‡ï‡‡‡Æ‡ is the one that cannot be.  There is no
-- element of an empty fibre to show, so the witness has to be of a
-- different kind ‚î and ¬ß‡ß says which kind, exactly.
--
-- ¬ß‡ß ¬ ‡‡‡æ‡µ‡ ‡‡∞‡‡Ø‡æ‡‡‡‡ø‡ ‚î "nothing in the field has this property" IS
-- "every member of the field lacks it".  The equivalence is free, both
-- directions, no hypothesis.  So a claim of absence is a Œ† over the WHOLE
-- domain, and cannot be less than that.
--
-- ¬ß‡® ¬ WHICH IS THE ‡Ø‡ã‡ó‡‡Ø‡‡æ CONDITION, and why the invalid form of
-- anupalabdhi is not merely weak but INEXPRESSIBLE.  Kumrila's
-- yogynupalabdhi requires non-perception OF WHAT WOULD HAVE BEEN
-- PERCEIVED HAD IT BEEN PRESENT (lokavrttika, abhva-pariccheda,
-- c. 7th c.): you know the pot is absent because you would have seen it;
-- you do not know a ghost is absent by not seeing one.  ¬ß‡ß is that
-- condition as a type ‚î the Œ† ranges over the whole field, so producing
-- it IS having covered the field.  And the invalid form, "I searched and
-- did not find", has no internal statement at all: it is a fact about a
-- search, not about the domain, which is precisely why it licenses
-- nothing.
--
-- `interactive/Nirdharana_‚¶hs` reaches the same wall from the engineering
-- side and says so: EMPTY "is a case this instrument cannot certify at
-- all".  It cannot, because certifying it is ¬ß‡ß's Œ† and a census only
-- visits points.  `interactive/Lopa_‚¶hs` therefore reports UNDECIDED by count
-- rather than guessing, on the stated ground that a verdict guessed is
-- worse than a verdict withheld.
------------------------------------------------------------------------

module Anupalabdhi_AbsenceIsAStatementAboutTheWholeFieldAndNotAFailureAtAPoint where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

private variable ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡æ‡µ‡ ‡‡∞‡‡Ø‡æ‡‡‡‡ø‡ ‚î absence is exactly universal lack.
--
-- Forward: if nothing in the field has P, then each member lacks it.
-- Backward: if each member lacks it, nothing in the field has it.
-- Both free.  The point is the SHAPE of the right-hand side: a Œ† over the
-- whole domain.  There is no smaller statement that means absence.
------------------------------------------------------------------------

‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§µ‡§ö‡§®‡§Æ‡•ç : {A : Type ‚Ñì} (P : A ‚Üí Type ‚Ñì')
             ‚Üí Iso (¬¨ (Œ£[ a ‚àà A ] P a)) ((a : A) ‚Üí ¬¨ P a)
Iso.fun      (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§µ‡§ö‡§®‡§Æ‡•ç P) ¬¨œÉ a p = ¬¨œÉ (a , p)
Iso.inv      (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§µ‡§ö‡§®‡§Æ‡•ç P) f  œÉ   = f (œÉ .fst) (œÉ .snd)
Iso.rightInv (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§µ‡§ö‡§®‡§Æ‡•ç P) _      = refl
Iso.leftInv  (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§µ‡§ö‡§®‡§Æ‡•ç P) _      = refl

‡§Ö‡§≠‡§æ‡§µ‡§É‚âÉ‡§™‡§∞‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø‡§É : {A : Type ‚Ñì} (P : A ‚Üí Type ‚Ñì')
                 ‚Üí (¬¨ (Œ£[ a ‚àà A ] P a)) ‚âÉ ((a : A) ‚Üí ¬¨ P a)
‡§Ö‡§≠‡§æ‡§µ‡§É‚âÉ‡§™‡§∞‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø‡§É P = isoToEquiv (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§µ‡§ö‡§®‡§Æ‡•ç P)

------------------------------------------------------------------------
-- ‡® ¬ ‡∞‡ø‡ï‡‡‡Æ‡ has no exhibiting witness ‚î read off ¬ß‡ß at a fibre.
--
-- A claim that the fibre over `b` is empty is, exactly, a rule covering
-- every point of the domain.  Not a point, not a finite check, not a
-- search that came back empty: a statement about the whole field.
------------------------------------------------------------------------

‡§∞‡§ø‡§ï‡•ç‡§§-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç : {A B : Type ‚Ñì} (f : A ‚Üí B) (b : B)
              ‚Üí (¬¨ (fiber f b)) ‚âÉ ((a : A) ‚Üí ¬¨ (f a ‚â° b))
‡§∞‡§ø‡§ï‡•ç‡§§-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç f b = ‡§Ö‡§≠‡§æ‡§µ‡§É‚âÉ‡§™‡§∞‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø‡§É (Œª a ‚Üí f a ‚â° b)

------------------------------------------------------------------------
-- ‡© ¬ and the contrast, so the asymmetry is on the page.
--
-- ‡‡‡ and ‡‡ï‡Æ‡ are witnessed by handing over inhabitants.  ‡∞‡ø‡ï‡‡‡Æ‡ cannot
-- be, and ¬ß‡® says what stands in its place.
------------------------------------------------------------------------

‡§â‡§™‡§≤‡§¨‡•ç‡§ß‡§ø‡§É : {A B : Type ‚Ñì} (f : A ‚Üí B) (a : A) ‚Üí fiber f (f a)
‡§â‡§™‡§≤‡§¨‡•ç‡§ß‡§ø‡§É f a = a , refl        -- a verdict you can hand someone

-- the empty fibre offers nothing to hand over, by construction
‡§Ö‡§®‡•Å‡§™‡§≤‡§¨‡•ç‡§ß‡§ø‡§É : (b : Unit) ‚Üí ¬¨ (fiber (Œª (x : ‚ä•) ‚Üí tt) b)
‡§Ö‡§®‡•Å‡§™‡§≤‡§¨‡•ç‡§ß‡§ø‡§É _ (x , _) = Empty.rec x
