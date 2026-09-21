{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡‡-‡‡‡∞‡Ø‡Æ‡ ‚î ‡‡ï‡‡‡Æ‡ø‡®‡ ‡‡≤‡ ‡‡‡∞‡Ø‡‡‡‡®‡‡‡µ‡ ‡
--
-- (three fibres over one codomain.)
--
-- ¬ß‡ß ¬ THE THREE VERDICTS, EXHIBITED AT THE SMALLEST SCALE.  Three maps
-- into ONE codomain, `Unit`, with fibres ‡∞‡ø‡ï‡‡‡Æ‡ / ‡‡ï‡Æ‡ / ‡‡‡.  A boolean
-- verdict -- "is this an equivalence?" -- answers NO to the first and the
-- third alike, and ¬ß‡ß.‡ proves those two are not the same situation.
-- That is `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡`'s pigeonhole at the minimum instance, and
-- it is what `interactive/Lopa_‚¶hs` withholds a verdict for rather than guess.
--
-- ¬ß‡® ¬ TWO LOSSY EDGES COMPOSING LOSSLESSLY.  `Unit ‚í Bool ‚í Unit`: the
-- second factor loses a bit (¬ß‡ß.‡©), and the composite loses nothing.  So
-- loss does not accumulate along composition -- the alignment term
-- `rank(AB) = rank(B) ‚àí dim(im B ‚à© ker A)` at its smallest, and the
-- Knill‚ìLaflamme condition `im B ‚à© ker A = 0` exhibited: the first edge's
-- image dodges the second edge's collapse.  README movement 2 names
-- `Unit‚íBool‚íUnit` as the checked cancellation; this is that term.
--
-- RELATION TO `Parampara_...agda`.
-- That module also finds that losses do not add along a
-- chain, by a DIFFERENT mechanism -- an ABSENCE sitting in the middle fibre
-- -- over three maps rather than two.  Section 2 here is the other mechanism
-- at minimum scale: the first edge's image DODGES the second edge's collapse,
-- with nothing empty anywhere.  Two distinct ways for the alignment term to
-- vanish, and the corpus now carries both.
------------------------------------------------------------------------

module Tantutrayam_ThreeMapsIntoOneCodomainExhibitTheThreeVerdictsAndTwoLossyEdgesComposeLosslessly where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; fiber ; idIsEquiv)
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd ; _√ó_)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡∞‡Ø‡ã ‡®‡ø‡∞‡‡‡Ø‡æ‡ ‚î three maps into Unit, three fibres.
------------------------------------------------------------------------

-- ‡ß.‡ß ‡∞‡ø‡ï‡‡‡Æ‡ ‚î the empty fibre.  No answer exists.
‡§∞‡§ø‡§ï‡•ç‡§§-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : ‚ä• ‚Üí Unit
‡§∞‡§ø‡§ï‡•ç‡§§-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É ()

‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç : ¬¨ (fiber ‡§∞‡§ø‡§ï‡•ç‡§§-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt)
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç (x , _) = Empty.rec x

-- ‡ß.‡® ‡‡ï‡Æ‡ ‚î the singleton fibre.  Free: the identity loses nothing.
‡§è‡§ï-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : Unit ‚Üí Unit
‡§è‡§ï-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É u = u

‡§è‡§ï‡§Æ‡•ç : isEquiv ‡§è‡§ï-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É
‡§è‡§ï‡§Æ‡•ç = idIsEquiv Unit

-- ‡ß.‡© ‡‡‡ ‚î the many fibre.  One bit destroyed, and the two witnesses
--      of that destruction are distinct.
‡§¨‡§π‡•Å-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : Bool ‚Üí Unit
‡§¨‡§π‡•Å-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É _ = tt

‡§∏‡§§‡•ç ‡§Ö‡§∏‡§§‡•ç : fiber ‡§¨‡§π‡•Å-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt
‡§∏‡§§‡•ç  = true  , refl
‡§Ö‡§∏‡§§‡•ç = false , refl

‡§¨‡§π‡•Å : ¬¨ (isContr (fiber ‡§¨‡§π‡•Å-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt))
‡§¨‡§π‡•Å c = false‚â¢true (cong fst (sym (c .snd ‡§Ö‡§∏‡§§‡•ç) ‚àô c .snd ‡§∏‡§§‡•ç))

-- ‡ß.‡ ‡¶‡‡∞‡‡®‡Ø‡ ‚î AND THE BOOLEAN MERGES THE FIRST AND THE THIRD.
--
-- Both ‡∞‡ø‡ï‡‡-‡Æ‡æ‡∞‡‡ó‡ and ‡‡‡-‡Æ‡æ‡∞‡‡ó‡ fail to be equivalences, so a two-valued
-- verdict returns the same answer for both.  They are not the same
-- situation: one fibre is uninhabited and the other is inhabited, and
-- that difference is exactly what the boolean destroys.
‡§≠‡•á‡§¶‡§É : (¬¨ (fiber ‡§∞‡§ø‡§ï‡•ç‡§§-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt)) √ó (fiber ‡§¨‡§π‡•Å-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt)
‡§≠‡•á‡§¶‡§É = ‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç , ‡§∏‡§§‡•ç

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡Ø‡ã‡ó‡ ‡‡‡‡ ‡ï‡‡‡‡Ø‡‡ ‚î loss does not accumulate.
--
-- `‡‡‡-‡Æ‡æ‡∞‡‡ó‡` destroys a bit.  Precompose it with a map whose image
-- dodges the collapse and the composite destroys nothing.
------------------------------------------------------------------------

‡§â‡§§‡•ç‡§•‡§æ‡§®‡§Æ‡•ç : Unit ‚Üí Bool
‡§â‡§§‡•ç‡§•‡§æ‡§®‡§Æ‡•ç _ = true

‡§∏‡§Ç‡§Ø‡•ã‡§ó‡§É : Unit ‚Üí Unit
‡§∏‡§Ç‡§Ø‡•ã‡§ó‡§É u = ‡§¨‡§π‡•Å-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É (‡§â‡§§‡•ç‡§•‡§æ‡§®‡§Æ‡•ç u)

-- the composite is an equivalence, though its second factor is not
‡§∏‡§Ç‡§Ø‡•ã‡§ó‡§É-‡§Ö‡§ï‡•ç‡§∑‡§Ø‡§É : isEquiv ‡§∏‡§Ç‡§Ø‡•ã‡§ó‡§É
‡§∏‡§Ç‡§Ø‡•ã‡§ó‡§É-‡§Ö‡§ï‡•ç‡§∑‡§Ø‡§É = idIsEquiv Unit

-- and the second factor still is not, so the cancellation is real
‡§Æ‡§ß‡•ç‡§Ø‡§Æ‡§É-‡§ï‡•ç‡§∑‡§Ø‡•Ä : ¬¨ (isContr (fiber ‡§¨‡§π‡•Å-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt))
‡§Æ‡§ß‡•ç‡§Ø‡§Æ‡§É-‡§ï‡•ç‡§∑‡§Ø‡•Ä = ‡§¨‡§π‡•Å
