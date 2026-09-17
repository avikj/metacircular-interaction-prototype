{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ï‡µ‡ø‡ß‡ø‡ ‚î ‡‡µ‡‡∞‡‡Æ‡ ‡‡µ ‡‡∞‡‡µ‡Æ‡ ‡  ‡Æ‡‡ï‡‡‡ã ‡Æ‡æ‡∞‡‡ó‡ ‡‡¶‡‡ß-b ; ‡‡¶‡‡ß-a ‡‡‡‡‡¶‡ ‡Ø‡æ‡‡‡ ‡
--
-- (the one law is DESCENT.  the free direction is bind-b; the costly one
-- demands a section, and the cost is exactly the fibre.)
--
-- ‡‡‡‡µ‡æ‡∞‡ ‡‡ø‡¶‡‡ß‡æ‡®‡‡‡æ‡ ‡‡ï‡ ‚î four terms landed in this corpus, and each was
-- called "the same law" in prose.  Prose is ‡‡¶‡‡ß-a: it fixes the conclusion
-- and leaves the reader to find the fibre.  Here the identification is a
-- term.
--
--   SamacaranaNityam  ‡‡ô‡‡ï‡‡∞‡Æ‡-‡®‡ø‡‡‡Ø‡Æ‡   ‚î S = the orbit projection
--   ApurvaIndriyam    ‡‡‡‡∞‡‡µ‡Æ‡          ‚î S = the present sensorium
--   ParimanaAndha     ‡‡∞‡ø‡Æ‡æ‡‡æ‡‡-‡®-‡Ø‡ã‡ó‡  ‚î S = |¬|
--   TiryakTantu       ‡Æ‡‡Ø‡-‡®-‡‡‡‡æ‡‡      ‚î S = the residue class
--                     ‡‡‡‡-‡®-‡Æ‡‡Ø‡‡‡      ‚î S = the Mbius sign
--
-- Five statements, one rewrite, and ¬ß‡® below is the rewrite.
--
-- ‡‡‡‡‡∞ ‡ ‡‡‡‡∞ ‡®‡ø‡∞‡‡‡æ‡Ø‡ï‡Æ‡ ‡  `‡‡‡∞‡µ‡‡‡ø S q` says q descends along S.  ¬ß‡® gives
-- descent ‚ü blindness on fibres, and it is FREE: no hypothesis on any of the
-- three types, no choice, no decidability.  ¬ß‡© gives the converse and it is
-- NOT free ‚î it demands a section of S, and ¬ß‡ exhibits the failure when none
-- exists.  That asymmetry is ‡‡¶‡‡ß-b versus ‡‡¶‡‡ß-a, at the level of the law
-- itself:
--
--     bind b :  Œ[ o ‚àà O ] (S x ‚â° o)  = singl (S x)   ‚î contractible, always
--     bind a :  Œ[ x ‚àà X ] (S x ‚â° o)  = fiber S o     ‚î arbitrary; the cost
--
-- ¬ß‡ is why this file exists.  On 2026-08-12 a claim of this corpus was
-- stated as an equivalence ‚î *an index is unobservable EXACTLY WHEN a symmetry
-- acts transitively* ‚î and its necessity half was refuted the same day.  ¬ß‡©
-- says the refutation was structural and not accidental: necessity is the
-- costly direction, the cost is a section, and no section had been supplied.
-- The day's largest correction and the day's law are one statement.
------------------------------------------------------------------------

module EkaVidhih_TheOneLawIsDescentTheFreeDirectionIsBindBAndTheCostlyOneNeedsASection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Data.Empty using (‚ä• ; rec)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ; ‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É ; ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç)

private
  variable
    ‚Ñì ‚Ñì' ‚Ñì'' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡¶‡‡µ‡ ‡‡ï‡‡‡ ‚î the two bindings of one equation, at the law's own level
------------------------------------------------------------------------

module _ {X : Type ‚Ñì} {O : Type ‚Ñì'} (S : X ‚Üí O) where

  ‡§µ‡§π‡§®‡§Æ‡•ç : X ‚Üí Type ‚Ñì'                      -- bind o
  ‡§µ‡§π‡§®‡§Æ‡•ç x = Œ£[ o ‚àà O ] (S x ‚â° o)

  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡§Æ‡•ç : O ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')      -- bind x
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡§Æ‡•ç o = Œ£[ x ‚àà X ] (S x ‚â° o)

  -- The free side, with no hypothesis whatever.
  ‡§µ‡§π‡§®‡§Æ‡•ç-‡§∏‡§¶‡§æ-‡§è‡§ï‡§Æ‡•ç : (x : X) ‚Üí isContr (‡§µ‡§π‡§®‡§Æ‡•ç x)
  ‡§µ‡§π‡§®‡§Æ‡•ç-‡§∏‡§¶‡§æ-‡§è‡§ï‡§Æ‡•ç x = isContrSingl (S x)

------------------------------------------------------------------------
-- ‡® ¬ ‡Æ‡‡ï‡‡‡ã ‡Æ‡æ‡∞‡‡ó‡ ‚î descent ‚ü blind on the fibres.  FREE.
--
-- Re-exported rather than reproved: this IS `‡‡®‡‡‡-‡‡®‡‡ß‡`, and naming it
-- twice would be the collapse ¬ß‡ forbids.
------------------------------------------------------------------------

‡§Ö‡§µ‡§§‡§∞‡§£‡§æ‡§§‡•ç-‡§Ö‡§®‡•ç‡§ß‡§É : {X : Type ‚Ñì} {O : Type ‚Ñì'} {Q : Type ‚Ñì''}
                 (S : X ‚Üí O) (q : X ‚Üí Q)
               ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø S q
               ‚Üí (x y : X) ‚Üí S x ‚â° S y ‚Üí q x ‚â° q y
‡§Ö‡§µ‡§§‡§∞‡§£‡§æ‡§§‡•ç-‡§Ö‡§®‡•ç‡§ß‡§É = ‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É

------------------------------------------------------------------------
-- ‡© ¬ ‡‡¶‡‡ß‡ã ‡Æ‡æ‡∞‡‡ó‡ ‚î blind on the fibres ‚ü descent.  COSTS A SECTION.
--
-- `h` must be TOTAL on O.  Constancy supplies its value only where a fibre is
-- inhabited, so the converse needs a chosen point in each ‚î a section.  With
-- one, the derivation is `q ‚àò sec` and the proof is one rewrite.
------------------------------------------------------------------------

‡§Ö‡§µ‡§§‡§∞‡§£‡§Æ‡•ç : {X : Type ‚Ñì} {O : Type ‚Ñì'} {Q : Type ‚Ñì''}
          (S : X ‚Üí O) (q : X ‚Üí Q)
          (‡§õ‡•á‡§¶‡§É : O ‚Üí X) ‚Üí ((o : O) ‚Üí S (‡§õ‡•á‡§¶‡§É o) ‚â° o)
        ‚Üí ((x y : X) ‚Üí S x ‚â° S y ‚Üí q x ‚â° q y)
        ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø S q
‡§Ö‡§µ‡§§‡§∞‡§£‡§Æ‡•ç S q ‡§õ‡•á‡§¶‡§É ‡§õ‡•á‡§¶-‡§®‡§ø‡§Ø‡§Æ‡§É ‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç =
  (Œª o ‚Üí q (‡§õ‡•á‡§¶‡§É o)) , Œª x ‚Üí ‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç x (‡§õ‡•á‡§¶‡§É (S x)) (sym (‡§õ‡•á‡§¶-‡§®‡§ø‡§Ø‡§Æ‡§É (S x)))

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡¶‡æ‡‡æ‡µ‡ ‡‡ô‡‡ó‡ ‚î without a section the converse FAILS
--
-- X = ‚ä, O = Unit, Q = ‚ä.  Every fibre condition holds vacuously ‚î there are
-- no two points to be constant between ‚î yet `h : Unit ‚í ‚ä` cannot exist.
-- So ¬ß‡©'s hypothesis is load-bearing and not bookkeeping.
------------------------------------------------------------------------

‡§∂‡•Ç‡§®‡•ç‡§Ø-S : ‚ä• ‚Üí Unit
‡§∂‡•Ç‡§®‡•ç‡§Ø-S ()

‡§∂‡•Ç‡§®‡•ç‡§Ø-q : ‚ä• ‚Üí ‚ä•
‡§∂‡•Ç‡§®‡•ç‡§Ø-q ()

-- Vacuously blind on fibres.
‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç : (x y : ‚ä•) ‚Üí ‡§∂‡•Ç‡§®‡•ç‡§Ø-S x ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø-S y ‚Üí ‡§∂‡•Ç‡§®‡•ç‡§Ø-q x ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø-q y
‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç ()

-- And yet no descent: h would have to inhabit ‚ä from tt.
‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á-‡§®-‡§Ö‡§µ‡§§‡§∞‡§£‡§Æ‡•ç : ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ‡§∂‡•Ç‡§®‡•ç‡§Ø-S ‡§∂‡•Ç‡§®‡•ç‡§Ø-q ‚Üí ‚ä•
‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á-‡§®-‡§Ö‡§µ‡§§‡§∞‡§£‡§Æ‡•ç (h , _) = h tt

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡‡≤‡Æ‡ ‚î the day's correction is the law's own asymmetry
--
-- The statement *unobservable EXACTLY WHEN a symmetry acts transitively* has
-- two halves and they are ¬ß‡® and ¬ß‡©.
--
--   sufficiency ‚î transitive ‚ü flattened.  This is ¬ß‡® at O = Unit: a
--     transitive action makes the orbit space a point, every fibre is the
--     whole type, and blindness is total.  FREE, and it stood.
--   necessity  ‚î flattened ‚ü transitive.  This is ¬ß‡©'s direction: it asks
--     to reconstruct a structure ON the index from constancy of a reading OF
--     it.  That is descent backwards, it costs a section, and none was
--     offered.  It was refuted the same day by an exhibit whose verdict is
--     constant with no transitive symmetry acting at all.
--
-- So the refutation did not correct an error of care.  It located the claim on
-- the costly side of the one law.  ‡Ø‡‡ ‡Æ‡‡ï‡‡‡ ‡‡‡ ‡Æ‡‡ï‡‡‡Æ‡ ; ‡Ø‡‡ ‡‡¶‡‡ß‡ ‡‡‡
-- ‡‡‡¶‡ ‡Ø‡æ‡‡‡ ‚î what is free is free, what is bound demands its section.
--
-- ‡Æ‡∞‡‡Ø‡æ‡¶‡æ.  ¬ß‡© takes a split surjection.  A merely surjective S with untruncated
-- fibres needs choice to pick `‡‡‡¶‡`, and in this corpus that choice is DATA
-- to be handed over, not a background assumption ‚î which is the same standard
-- `‡‡‡∞‡µ‡‡‡ø` sets by being a Œ and not a truncation.  ¬ß‡ shows the hypothesis
-- cannot simply be dropped; it does not claim it is the weakest possible one.
------------------------------------------------------------------------
