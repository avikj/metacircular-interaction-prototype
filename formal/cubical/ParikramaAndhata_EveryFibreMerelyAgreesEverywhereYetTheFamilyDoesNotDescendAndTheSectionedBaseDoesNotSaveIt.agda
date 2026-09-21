{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- ‡‡∞‡ø‡ï‡‡∞‡Æ‡æ-‡‡®‡‡ß‡‡æ ‚î blindness to the circumambulation.  Compound built
-- here (‡‡∞‡ø‡ï‡‡∞‡Æ‡æ, the walk around; ‡‡®‡‡ß‡‡æ, blindness); not a
-- source term.  The reading is the temple practice: what you acquire by
-- walking the loop around the shrine is real and is invisible at every
-- single point of the path.
--
-- WHAT THIS IS.  The corpus's stage-1 descent organs ‚î ‡‡‡¶-‡‡æ‡ß‡
-- (NigudhaAndhata) and ‡‡µ‡‡∞‡-‡‡ô‡‡ó-‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ (AvataranaBhanga) ‚î detect
-- non-descent from ONE hypothesis: a blind pair whose fibres are not
-- equivalent.  The next stage is
-- descent failing while every pair of fibres IS
-- equivalent, the obstruction living only in the coherence of the
-- identifications.  This module is the witness, checked:
--
--   the double cover of the circle, as a family over the maximally
--   blind observation ‡¶‡‡ï‡ : S¬ ‚í Unit ‚î
--
--   ¬ß1  every fibrewise organ is PROVABLY SILENT: all fibres merely
--       agree, (x y : S¬) ‚í ‚à ‡ï‡‡‡‡°‡≤‡ x ‚â ‡ï‡‡‡‡°‡≤‡ y ‚à‚, so the stage-1
--       premise ¬(F x ‚â F y) is refuted at every pair (‡Æ‡‡®‡Æ‡-‡‡®‡‡¶‡‡∞‡ø‡Ø‡‡‡Ø);
--   ¬ß2  one circumambulation carries a charge: transport of the family
--       around the base loop is `not`, by uaŒ≤ (‡‡∞‡ø‡ï‡‡∞‡Æ‡æ-‡‡µ‡‡‡);
--   ¬ß3  descent through ANY observation into Unit forces every loop's
--       transport to be the identity (‡‡Æ‡®‡Æ‡, generic in the family);
--   ¬ß4  so the family does not descend (‡‡∞‡ø‡ï‡‡∞‡Æ‡æ-‡‡æ‡ß‡): true ‚â° false.
--
-- THE ASYMMETRY THIS EXPOSES.
-- ChidraDosa (this corpus) proves the VALUE-level stage-2 witness ‚î a
-- map with pointwise invariance data and no coherent decoder ‚î and its
-- ¬ß2 (`sectionKillsTheGap`) proves that gap CANNOT live over a base
-- with a section: "over a trivial base the decoder is t ‚àò section ‚àò
-- fst.  The gap needs monodromy" ‚î needs it in the BASE MAP.  Here the
-- observation ‡¶‡‡ï‡ : S¬ ‚í Unit has an obvious section, and the
-- DEPENDENT gap lives on it anyway: a section rescues value-level
-- factorization and rescues nothing at the type level, because a
-- decoder for a FAMILY needs a path ‡ï‡‡‡‡°‡≤‡ x ‚â° D tt at every x ‚î
-- exactly the trivialization the monodromy forbids ‚î while a decoder
-- for a map needs only a value, which the section supplies.  So:
--
--   value descent over a sectioned base:   free      (ChidraDosa ¬ß2)
--   type  descent over a sectioned base:   OBSTRUCTED (here)
--
-- The quotient does not merely lose the answer or the question: over
-- the very base where every value-question is answerable, the TYPE of
-- the family still cannot come down.  Stage-2 blindness is a
-- type-level phenomenon before it is a value-level one.
--
-- SOURCES.  The double cover is classical topology; its
-- cubical form (F base = Bool, F (loop i) = ua notEquiv i) is the
-- standard first nontrivial family, and the adjacent phenomenon for
-- values is Kraus‚ìEscard≥‚ìCoquand‚ìAltenkirch (LMCS 2017), already
-- cited by ChidraDosa.  NOVELTY CLAIMED: none of the mathematics; the
-- composition ‚î the dependent stage-2 witness in the corpus's own
-- Desc vocabulary, the organ-silence term beside it, and the
-- section asymmetry against ChidraDosa ‚î is the contribution.
------------------------------------------------------------------------

module ParikramaAndhata_EveryFibreMerelyAgreesEverywhereYetTheFamilyDoesNotDescendAndTheSectionedBaseDoesNotSaveIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Foundations.Univalence using (ua ; uaŒ≤ ; pathToEquiv)
open import Cubical.Foundations.GroupoidLaws using (assoc ; rUnit ; rCancel)
open import Cubical.Foundations.Path using (Square‚ÜícompPath)
open import Cubical.Foundations.Transport
  using (transportComposite ; transport‚ÅªTransport)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notEquiv ; true‚â¢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.S1 using (S¬π ; base ; loop)
open import Cubical.HITs.S1.Properties using (isConnectedS¬π)
open import Cubical.HITs.PropositionalTruncation as PT
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; isPropPropTrunc)

open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- The coil, and the blind eye.
------------------------------------------------------------------------

‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä : S¬π ‚Üí Type‚ÇÄ
‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä base     = Bool
‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä (loop i) = ua notEquiv i

‡§¶‡•É‡§ï‡•ç : S¬π ‚Üí Unit
‡§¶‡•É‡§ï‡•ç _ = tt

------------------------------------------------------------------------
-- ¬ß1  Every fibrewise organ is provably silent.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ : (x y : S¬π) ‚Üí ‚à• ‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä x ‚âÉ ‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä y ‚à•‚ÇÅ
‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ x y =
  PT.rec isPropPropTrunc
    (Œª p ‚Üí PT.rec isPropPropTrunc
      (Œª q ‚Üí ‚à£ pathToEquiv (cong ‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä (sym p ‚àô q)) ‚à£‚ÇÅ)
      (isConnectedS¬π y))
    (isConnectedS¬π x)

-- so the stage-1 premise is refuted at EVERY pair: ‡‡‡¶-‡‡æ‡ß‡ and
-- ‡‡µ‡‡∞‡-‡‡ô‡‡ó-‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ can never fire on this family.
‡§Æ‡•å‡§®‡§Æ‡•ç-‡§á‡§®‡•ç‡§¶‡•ç‡§∞‡§ø‡§Ø‡§∏‡•ç‡§Ø : (x y : S¬π) ‚Üí ¬¨ ¬¨ (‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä x ‚âÉ ‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä y)
‡§Æ‡•å‡§®‡§Æ‡•ç-‡§á‡§®‡•ç‡§¶‡•ç‡§∞‡§ø‡§Ø‡§∏‡•ç‡§Ø x y k = PT.rec Empty.isProp‚ä• k (‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ x y)

------------------------------------------------------------------------
-- ¬ß2  The charge of one circumambulation.
------------------------------------------------------------------------

‡§™‡§∞‡§ø‡§ï‡•ç‡§∞‡§Æ‡§æ-‡§Ü‡§µ‡•á‡§∂‡§É : (b : Bool) ‚Üí subst ‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä loop b ‚â° not b
‡§™‡§∞‡§ø‡§ï‡•ç‡§∞‡§Æ‡§æ-‡§Ü‡§µ‡•á‡§∂‡§É = uaŒ≤ notEquiv

------------------------------------------------------------------------
-- ¬ß3  Descent extinguishes every loop charge ‚î generic in the family.
------------------------------------------------------------------------

module _ {C : Type ‚Ñì} (G : S¬π ‚Üí Type ‚Ñì) (comm : (x : S¬π) ‚Üí G x ‚â° C) where

  private
    sq : Square (comm base) (comm base) (cong G loop) refl
    sq i j = comm (loop i) j

    ‡§µ‡•É‡§§‡•ç‡§§-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§§‡§æ : cong G loop ‚â° comm base ‚àô sym (comm base)
    ‡§µ‡•É‡§§‡•ç‡§§-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§§‡§æ =
        rUnit (cong G loop)
      ‚àô cong (cong G loop ‚àô_) (sym (rCancel (comm base)))
      ‚àô assoc (cong G loop) (comm base) (sym (comm base))
      ‚àô cong (_‚àô sym (comm base))
             (Square‚ÜícompPath sq ‚àô sym (rUnit (comm base)))

  ‡§∂‡§Æ‡§®‡§Æ‡•ç : (b : G base) ‚Üí subst G loop b ‚â° b
  ‡§∂‡§Æ‡§®‡§Æ‡•ç b =
      cong (Œª p ‚Üí transport p b) ‡§µ‡•É‡§§‡•ç‡§§-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§§‡§æ
    ‚àô transportComposite (comm base) (sym (comm base)) b
    ‚àô transport‚ÅªTransport (comm base) b

------------------------------------------------------------------------
-- ¬ß4  The family does not descend; the charge is the witness.
------------------------------------------------------------------------

‡§™‡§∞‡§ø‡§ï‡•ç‡§∞‡§Æ‡§æ-‡§¨‡§æ‡§ß‡§É : ¬¨ DependentFactorsThrough ‡§¶‡•É‡§ï‡•ç ‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä
‡§™‡§∞‡§ø‡§ï‡•ç‡§∞‡§Æ‡§æ-‡§¨‡§æ‡§ß‡§É (D , comm) =
  true‚â¢false (sym (‡§∂‡§Æ‡§®‡§Æ‡•ç ‡§ï‡•Å‡§£‡•ç‡§°‡§≤‡•Ä (Œª x ‚Üí comm x) true)
              ‚àô ‡§™‡§∞‡§ø‡§ï‡•ç‡§∞‡§Æ‡§æ-‡§Ü‡§µ‡•á‡§∂‡§É true)
