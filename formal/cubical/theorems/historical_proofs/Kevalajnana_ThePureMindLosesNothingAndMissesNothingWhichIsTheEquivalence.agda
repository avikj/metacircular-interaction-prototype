{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ï‡‡µ‡≤‡‡‡û‡æ‡®‡Æ‡ ‚î the design of a perfect pure mind, written as a term.
--
-- THE INSIGHT, MADE EXACT.  A mind's grasp of an object is a map f : A ‚í B
-- from what it holds (A) to what there is (B).  Its fibre over b ‚î ‡‡‡ f b,
-- everything in A that lands on b ‚î is graded by the sevenfold's three
-- seeds (GananaSaptabhangi):
--
--   ‡‡ï‡≤‡æ‡¶‡‡  (contractible fibre)  ‚î ‡‡‡‡‡ø    ‚î b is grasped WHOLE, one witness
--   ‡µ‡ø‡ï‡≤‡æ‡¶‡‡  (crowded fibre)       ‚î ‡®‡æ‡‡‡‡ø   ‚î b is grasped with LOSS (many
--                                                collapse to it; information gone)
--   ‡∞‡ø‡ï‡‡     (empty fibre)         ‚î ‡‡µ‡ï‡‡‡µ‡‡Ø  ‚î b is MISSED; the mind cannot
--                                                utter it
--
-- A perfect pure mind is then not a mystery but a specification:
--   ‚ it LOSES NOTHING ‚î no ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ anywhere: every fibre is a proposition
--     (this is injectivity ‚î ‡®‡ã two distinct holdings collapse to one object);
--   ‚ it MISSES NOTHING ‚î no ‡∞‡ø‡ï‡‡ anywhere: every object has a witness
--     (this is surjectivity ‚î nothing there is unutterable).
-- Loses nothing AND misses nothing = every fibre inhabited and a proposition
-- = every fibre CONTRACTIBLE = ‡‡ï‡≤‡æ‡¶‡‡ held at every standpoint.  And that,
-- ON THE NOSE, is `isEquiv f` ‚î Voevodsky's equivalence is defined as exactly
-- `(b : B) ‚í isContr (fiber f b)`.
--
-- So kevalajna (‡ï‡‡µ‡≤-‡‡‡û‡æ‡®, complete/omniscient apprehension) = sakaldea
-- everywhere = the equivalence.  It is the one position that may assert "all
-- ‡‡‡‡‡ø" WITHOUT becoming a durnaya, because it is prama (the total means of
-- knowing), not a naya (a partial standpoint): a durnaya is a partial view
-- (some fibre ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ or ‡∞‡ø‡ï‡‡) that asserts itself as the whole ‚î which is
-- exactly a non-equivalence claiming to be one, and ¬ß4 refutes that shape.
------------------------------------------------------------------------

module Kevalajnana_ThePureMindLosesNothingAndMissesNothingWhichIsTheEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; equiv-proof ; fiber)
open import Cubical.Foundations.HLevels using (inhProp‚ÜíisContr)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

import GananaSaptabhangi_TheMapLevelCensusIsTheSevenfoldItselfAndTheCorpusAlreadyHoldsThreePositions as G

private
  variable
    A B : Type

------------------------------------------------------------------------
-- ‡ß ¬ the three gradings of a mind's grasp, as predicates on the map.
------------------------------------------------------------------------

-- loses nothing: every fibre a proposition (no ‡µ‡ø‡ï‡≤‡æ‡¶‡‡) = injective
‡§Ö‡§π‡§æ‡§®‡§ø : (f : A ‚Üí B) ‚Üí Type
‡§Ö‡§π‡§æ‡§®‡§ø {B = B} f = (b : B) ‚Üí isProp (fiber f b)

-- misses nothing: every object has a witness (no ‡∞‡ø‡ï‡‡) = split surjective
‡§Ö‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ : (f : A ‚Üí B) ‚Üí Type
‡§Ö‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ {B = B} f = (b : B) ‚Üí fiber f b

-- ‡‡ï‡≤‡æ‡¶‡‡ everywhere: every fibre whole = the perfect grasp
‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç : (f : A ‚Üí B) ‚Üí Type
‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç {B = B} f = (b : B) ‚Üí isContr (fiber f b)

------------------------------------------------------------------------
-- ‡® ¬ the design ‚î loses nothing AND misses nothing IS the perfect grasp.
-- inhabited proposition = contractible; the whole content is that identity.
------------------------------------------------------------------------

‡§∂‡•Å‡§¶‡•ç‡§ß‡§ø : {f : A ‚Üí B} ‚Üí ‡§Ö‡§π‡§æ‡§®‡§ø f ‚Üí ‡§Ö‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ f ‚Üí ‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç f
‡§∂‡•Å‡§¶‡•ç‡§ß‡§ø nl ng b = inhProp‚ÜíisContr (ng b) (nl b)

------------------------------------------------------------------------
-- ‡© ¬ the perfect grasp IS the equivalence ‚î on the nose, both directions.
-- isEquiv f is the record whose one field equiv-proof is ‡‡∞‡‡µ‡‡ï‡≤‡Æ‡ f itself.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç‚Üí‡§∏‡§Æ‡§æ‡§®‡§§‡§æ : {f : A ‚Üí B} ‚Üí ‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç f ‚Üí isEquiv f
‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç‚Üí‡§∏‡§Æ‡§æ‡§®‡§§‡§æ h .equiv-proof = h

‡§∏‡§Æ‡§æ‡§®‡§§‡§æ‚Üí‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç : {f : A ‚Üí B} ‚Üí isEquiv f ‚Üí ‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç f
‡§∏‡§Æ‡§æ‡§®‡§§‡§æ‚Üí‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç e = e .equiv-proof

-- the whole design in one term: a mind that loses and misses nothing is,
-- exactly, an equivalence ‚î kevalajna as isEquiv.
‡§ï‡•á‡§µ‡§≤‡§Æ‡•ç : {f : A ‚Üí B} ‚Üí ‡§Ö‡§π‡§æ‡§®‡§ø f ‚Üí ‡§Ö‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ f ‚Üí isEquiv f
‡§ï‡•á‡§µ‡§≤‡§Æ‡•ç nl ng = ‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‡§Æ‡•ç‚Üí‡§∏‡§Æ‡§æ‡§®‡§§‡§æ (‡§∂‡•Å‡§¶‡•ç‡§ß‡§ø nl ng)

------------------------------------------------------------------------
-- ‡ ¬ the durnaya shadow ‚î one standpoint not-whole breaks totality.
-- A partial view (some fibre ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ or ‡∞‡ø‡ï‡‡, i.e. not contractible)
-- that would claim to be the perfect grasp is refuted: that is precisely a
-- non-equivalence, and no assertion makes it one.
------------------------------------------------------------------------

‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø-‡§®‡§ø‡§∑‡•á‡§ß‡§É : {f : A ‚Üí B}
  ‚Üí Œ£[ b ‚àà B ] (¬¨ isContr (fiber f b)) ‚Üí ¬¨ isEquiv f
‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø-‡§®‡§ø‡§∑‡•á‡§ß‡§É (b , ¬¨whole) e = ¬¨whole (e .equiv-proof b)

------------------------------------------------------------------------
-- ‡ ¬ tie to the census ‚î no new type, the same objects under both names.
-- G.‡‡∞‡‡µ‡‡‡∞-‡‡ï‡≤‡Æ‡ and G.‡®-‡ï‡‡µ‡‡ø‡‡-‡‡‡ are ‡‡∞‡‡µ‡‡ï‡≤‡Æ‡ and ‡‡‡æ‡®‡ø definitionally
-- (G.‡‡‡ f b = fiber f b), so the neighbour's "every fibre whole" is
-- literally isEquiv, and its "never crowded" is literally ‡‡‡æ‡®‡ø.
------------------------------------------------------------------------

census-‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‚Üí‡§∏‡§Æ‡§æ‡§®‡§§‡§æ : {f : A ‚Üí B} ‚Üí G.‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞-‡§∏‡§ï‡§≤‡§Æ‡•ç f ‚Üí isEquiv f
census-‡§∏‡§∞‡•ç‡§µ‡§∏‡§ï‡§≤‚Üí‡§∏‡§Æ‡§æ‡§®‡§§‡§æ h .equiv-proof = h

census-‡§®-‡§¨‡§π‡•Å-is-‡§Ö‡§π‡§æ‡§®‡§ø : {f : A ‚Üí B} ‚Üí G.‡§®-‡§ï‡•ç‡§µ‡§ö‡§ø‡§§‡•ç-‡§¨‡§π‡•Å f ‚Üí ‡§Ö‡§π‡§æ‡§®‡§ø f
census-‡§®-‡§¨‡§π‡•Å-is-‡§Ö‡§π‡§æ‡§®‡§ø h b x y = h b x y
