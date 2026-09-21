{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ï‡ã‡‡‡†-‡®‡‡Ø‡æ‡Ø‡ ‚î ‡¶‡‡∞‡‡®‡Ø‡ ‡ï‡ã‡‡‡†-‡®‡‡Ø‡æ‡Ø‡ ‡‡µ ; ‡‡æ‡®‡ø‡‡‡‡ ‡‡‡‡ï‡ ‡â‡‡æ‡ß‡ø‡ ‡
--
-- (the pigeonhole: the durnaya IS the pigeonhole, and the LOSS is a
--  separate hypothesis.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS EXISTS.  The same pigeonhole is proved by hand in at least
-- three places in this corpus, over three different carriers, and none of
-- them is the theorem:
--
--   ¬ `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` ‚î over ‡‡‡‡‡‡ô‡‡ó‡, three seeds into ‡¶‡‡µ‡ø‡‡¶, by
--     `with` on six cases.
--   ¬ `loss/‚¶/Adharmin_‚¶.‡‡‡‡∞‡-‡¶‡‡∞‡‡®‡Ø‡` ‚î over a four-name type
--     into Bool, by explicit exhaustion, and its header says the bridge
--     to ‡¶‡‡∞‡‡®‡Ø‡ "needs one toolchain that can see both, which this
--     container does not have".
--   ¬ `Durnaya_TheThreeIntoTwoLemmaStandsFourTimesAndOneTransportMakes
--     ThemOne` ‚î which already found the repetition and joined four
--     instances by transport.
--
-- ¬ß‡ß below is the statement none of them makes: it quantifies over the
-- CARRIER and over the two-valued codomain, so ‡‡‡‡‡‡ô‡‡ó‡, ‡‡‡‡‡‡ï‡Æ‡ and
-- anything else are instances rather than subjects.
--
-- AND THE POINT IS NOT DEDUPLICATION.  Reading `‡¶‡‡∞‡‡®‡Ø‡` closely, it uses
-- NOTHING about the sevenfold ‚î not ‡‡∞‡‡‡‡Æ‡, not ‡‡®‡‡‡∞‡‡‡æ‡µ, not ‡ï‡‡∞‡Æ-‡‡-‡‡‡¶‡,
-- not even that the three seeds are distinct.  Stating it over ‡‡‡‡‡‡ô‡‡ó‡
-- makes it look like a theorem about the sevenfold.  **It is a theorem
-- about counting, and the sevenfold is where it bites.**  ¬ß‡ß and ¬ß‡©
-- separate those, which is the whole content of this file:
--
--   ¬ß‡ß ‡ï‡ã‡‡‡†-‡®‡‡Ø‡æ‡Ø‡ ‚î UNCONDITIONAL.  Three points, a two-valued readout,
--       two of the images agree.  No distinctness, no h-level, nothing.
--   ¬ß‡© ‡‡æ‡®‡ø‡      ‚î the LOSS.  That the agreement is a genuine merge
--       needs the three points to be pairwise DISTINCT, and that
--       hypothesis is doing work that the pigeonhole is not.
--
-- Keeping them apart matters because the corpus's own use has run them
-- together: "a boolean verdict collapses something" is two claims ‚î that
-- two values coincide (always) and that the coincidence destroys a
-- distinction (only when there was one).  A three-valued readout over
-- three points that are secretly equal collapses nothing.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ¬ß‡ recovers `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` exactly, by instantiation, because
-- that module is in THIS lane.  `‡‡‡‡∞‡-‡¶‡‡∞‡‡®‡Ø‡` lives in the loss
-- library, whose agda-lib this tree does not include, so ¬ß‡ RESTATES its
-- four-name case as an instance rather than importing it.  Two statements
-- that agree is the channel; an import would be a different claim and is
-- not made.
------------------------------------------------------------------------

module Kosthanyaya_TheDurnayaIsThePigeonholeAndTheLossIsTheSeparateHypothesis where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_)
open import Cubical.Relation.Nullary using (¬¨_)

open import Saptabhangi using (‡§∏‡§™‡•ç‡§§‡§≠‡§ô‡•ç‡§ó‡•Ä ; ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ; ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø ; ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç
                              ; ‡§¶‡•ç‡§µ‡§ø‡§™‡§¶ ; ‡§∏‡§§‡•ç ; ‡§Ö‡§∏‡§§‡•ç ; ‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø‡§É)

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡ï‡ã‡‡‡†-‡®‡‡Ø‡æ‡Ø‡ ‚î the pigeonhole, unconditional.
--
--     A codomain is TWO-VALUED when every element is one of two named
--     points.  That is the only hypothesis, and it is about the READOUT,
--     never about the carrier.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç : (D : Type ‚Ñì') ‚Üí D ‚Üí D ‚Üí Type ‚Ñì'
‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç D d‚ÇÄ d‚ÇÅ = (d : D) ‚Üí (d ‚â° d‚ÇÄ) ‚äé (d ‚â° d‚ÇÅ)

‡§ï‡•ã‡§∑‡•ç‡§†-‡§®‡•ç‡§Ø‡§æ‡§Ø‡§É : {X : Type ‚Ñì} {D : Type ‚Ñì'} {d‚ÇÄ d‚ÇÅ : D}
             ‚Üí ‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç D d‚ÇÄ d‚ÇÅ
             ‚Üí (v : X ‚Üí D) (x y z : X)
             ‚Üí (v x ‚â° v y) ‚äé ((v x ‚â° v z) ‚äé (v y ‚â° v z))
‡§ï‡•ã‡§∑‡•ç‡§†-‡§®‡•ç‡§Ø‡§æ‡§Ø‡§É two v x y z with two (v x) | two (v y) | two (v z)
... | inl px | inl py | _      = inl (px ‚àô sym py)
... | inr px | inr py | _      = inl (px ‚àô sym py)
... | inl px | inr _  | inl pz = inr (inl (px ‚àô sym pz))
... | inr px | inl _  | inr pz = inr (inl (px ‚àô sym pz))
... | inl _  | inr py | inr pz = inr (inr (py ‚àô sym pz))
... | inr _  | inl py | inl pz = inr (inr (py ‚àô sym pz))

------------------------------------------------------------------------
-- ‡® ¬ ‡¶‡‡µ‡ø‡‡¶ is two-valued, which is all `‡¶‡‡∞‡‡®‡Ø‡` ever used of it.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§™‡§¶-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç : ‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç ‡§¶‡•ç‡§µ‡§ø‡§™‡§¶ ‡§∏‡§§‡•ç ‡§Ö‡§∏‡§§‡•ç
‡§¶‡•ç‡§µ‡§ø‡§™‡§¶-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç ‡§∏‡§§‡•ç  = inl refl
‡§¶‡•ç‡§µ‡§ø‡§™‡§¶-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç ‡§Ö‡§∏‡§§‡•ç = inr refl

------------------------------------------------------------------------
-- ‡© ¬ ‡‡æ‡®‡ø‡ ‚î THE LOSS, which is a different statement.
--
--     The pigeonhole says two images agree.  It does NOT say anything was
--     destroyed: if the three points were secretly equal, a two-valued
--     readout loses nothing.  The loss needs the points pairwise
--     distinct, and then the merged pair is exhibited WITH its
--     distinctness ‚î which is what makes it a written defect rather than
--     a complaint.
------------------------------------------------------------------------

‡§π‡§æ‡§®‡§ø‡§É : {X : Type ‚Ñì} {D : Type ‚Ñì'} {d‚ÇÄ d‚ÇÅ : D}
      ‚Üí ‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç D d‚ÇÄ d‚ÇÅ
      ‚Üí (v : X ‚Üí D) (x y z : X)
      ‚Üí ¬¨ (x ‚â° y) ‚Üí ¬¨ (x ‚â° z) ‚Üí ¬¨ (y ‚â° z)
      ‚Üí Œ£[ p ‚àà X ] Œ£[ q ‚àà X ] ((¬¨ (p ‚â° q)) √ó (v p ‚â° v q))
‡§π‡§æ‡§®‡§ø‡§É two v x y z x‚â¢y x‚â¢z y‚â¢z with ‡§ï‡•ã‡§∑‡•ç‡§†-‡§®‡•ç‡§Ø‡§æ‡§Ø‡§É two v x y z
... | inl e        = x , y , x‚â¢y , e
... | inr (inl e)  = x , z , x‚â¢z , e
... | inr (inr e)  = y , z , y‚â¢z , e

------------------------------------------------------------------------
-- ‡ ¬ `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` RECOVERED, by instantiation and nothing else.
--
--     Same type, same three seeds, and the proof is now one application.
--     This is the half of `Adharmin_‚¶`'s missing bridge that this tree
--     can build, because Saptabhangi is in this lane.
------------------------------------------------------------------------

‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø‡§É-‡§ï‡•ã‡§∑‡•ç‡§†‡§æ‡§§‡•ç : (f : ‡§∏‡§™‡•ç‡§§‡§≠‡§ô‡•ç‡§ó‡•Ä ‚Üí ‡§¶‡•ç‡§µ‡§ø‡§™‡§¶)
                ‚Üí  (f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ‚â° f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø)
                ‚äé ((f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ‚â° f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç)
                ‚äé  (f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø ‚â° f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç))
‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø‡§É-‡§ï‡•ã‡§∑‡•ç‡§†‡§æ‡§§‡•ç f =
  ‡§ï‡•ã‡§∑‡•ç‡§†-‡§®‡•ç‡§Ø‡§æ‡§Ø‡§É ‡§¶‡•ç‡§µ‡§ø‡§™‡§¶-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç

-- and the two agree, which is the honest form of "this subsumes that":
-- both inhabit the same type, and the claim is exactly that and no more.
‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø‡§É-‡§∏‡§Æ‡§æ‡§®‡§Æ‡•ç : (f : ‡§∏‡§™‡•ç‡§§‡§≠‡§ô‡•ç‡§ó‡•Ä ‚Üí ‡§¶‡•ç‡§µ‡§ø‡§™‡§¶)
              ‚Üí (f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ‚â° f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø)
              ‚äé ((f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ‚â° f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç)
              ‚äé  (f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø ‚â° f ‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç))
‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø‡§É-‡§∏‡§Æ‡§æ‡§®‡§Æ‡•ç = ‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø‡§É
