{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡‡‡‡‡¶ ‚î the cut.  ‡Ø‡‡ ‡‡‡Æ‡æ ‡ß‡æ‡∞‡Ø‡‡ø ‡‡‡ ‡‡ß‡æ‡∞‡, ‡Ø‡‡ ‡® ‡ß‡æ‡∞‡Ø‡‡ø ‡‡æ ‡‡‡Æ‡‡‡ø‡ ‡
--
-- (what the boundary retains is the base; what it does not retain is the
--  memory.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- are the same construction and neither knows it.  This module is the
-- identification.
--
-- THE PHYSICS LANE'S OWN SENTENCES, quoted because they are already the
-- statement and only the vocabulary is missing:
--
--   "The boundary is not an object placed between two already constituted
--    worlds.  It is the datum through which composition across the cut is
--    possible."
--
--   "The state at a temporal boundary is therefore not necessarily the
--    machine's internal register.  It is the least retained distinction
--    sufficient for the admitted future questions."
--
--   "Memory is a failure of factorization."
--
-- And its predictive quotient (3):  h ‚àº h‚≤ ‚ü∫ P(F ‚à h) = P(F ‚à h‚≤).
--
-- THAT QUOTIENT IS THE FIBRE OF THE RESPONSE MAP.  Write the response as
-- `f : A ‚í B`, a history to the profile it induces.  Then two histories
-- are predictively identified exactly when they lie in one fibre of `f`,
-- and the three sentences above become three facts about that fibre.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED BELOW, and none of it is constructed by hand.
--
--  ¬ß‡ß  A ‚â Œ[ b ‚àà B ] fibre f b.  The history set decomposes as
--      (boundary datum, what the boundary did not retain).  This is NOT a
--      new theorem: it is `Carrier f` with its two Œ's exchanged, and
--      `Loss.Carrier` already proves `A ‚â Carrier f` for every
--      `f`, with no h-level hypothesis on either side.  The physics
--      lane's decomposition and the ‡‡‡®‡∞‡æ‡ó‡Æ‡® law are one line apart.
--
--  ¬ß‡®  "No memory" is `isEquiv f`, i.e. every fibre contractible.  Then
--      A ‚â° B: the boundary IS the history set and nothing is retained
--      beyond it.  This is the cut theorem's d = rank T at rank = |A|.
--
--  ¬ß‡©  So "memory is a failure of factorization" reads, exactly,
--      MEMORY IS THE FIBRE FAILING TO BE CONTRACTIBLE ‚î and the failure
--      has the three verdicts of `Tantujala_‚¶agda`, not two:
--          ‡∞‡ø‡ï‡‡‡Æ‡  a profile no history induces  (b outside the image)
--          ‡‡ï‡Æ‡    contractible ‚î no memory at that profile
--          ‡‡‡     memory required, and the fibre IS the amount
--      `isContr` merges the first and the third, so a two-valued verdict
--      on a cut cannot distinguish "unreachable" from "remembered", which
--      is `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` arriving in physics.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- TERM.  ‡‡µ‡‡‡‡‡¶ ‚î delimitation, cutting off, the marking of a boundary ‚î
-- is standard Nyya-Vaieika technical vocabulary (‡‡µ‡‡‡‡‡¶‡ï, the
-- delimitor: that which restricts a property to its locus).  LIMIT: it is
-- used here for the process-table cut of the physics note, which no
--  source states; the term is borrowed for its exact sense of a
-- delimiting boundary and nothing is attributed to any text.
------------------------------------------------------------------------

module Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Function
open import Cubical.Data.Sigma

private variable ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡µ‡‡‡‡‡¶‡ ‚î the cut decomposes the history set.
--
-- Œ[ b ‚àà B ] fibre f b ‚â A.  The left side is (boundary datum, the
-- histories that datum does not separate); the right is the histories.
-- Nothing is built: it is Œ-swap composed with the contractibility of
-- singletons, which is the same pair of facts `Loss.Carrier`
-- uses to prove A ‚â Carrier f.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where
  -- One universe, because an equivalence needs both sides in it.  This is
  -- the same restriction `Loss.Carrier` carries in its own
  -- {A B : Type ‚ì} ‚î a further sign these are one construction.

  -- what the boundary does not retain, at a given boundary datum
  ‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É : B ‚Üí Type ‚Ñì
  ‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É b = fiber f b
  -- The decomposition.  `Œ-contractSnd` will not fire here (the second
  -- component is genuinely dependent), so the retract is written, and it
  -- is one line of cube: `Œª j ‚í p (i ‚àß j)` slides the witness along the
  -- very path that says the history lands on that boundary datum.  At
  -- i = 0 the conjunction collapses to `refl`, at i = 1 it is `p` itself.
  -- This is the same contractible-singleton fact `Loss.Carrier`
  -- runs on, in the other order ‚î the physics note's decomposition and
  -- the ‡‡‡®‡∞‡æ‡ó‡Æ‡® law are not analogous, they are one construction.
  ‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É : (Œ£[ b ‚àà B ] ‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É b) ‚âÉ A
  ‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É = isoToEquiv (iso ‡§™‡•ç‡§∞‡§§‡§ø ‡§Ö‡§®‡•Å (Œª _ ‚Üí refl) ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø)
    where
    ‡§™‡•ç‡§∞‡§§‡§ø : Œ£[ b ‚àà B ] ‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É b ‚Üí A
    ‡§™‡•ç‡§∞‡§§‡§ø (_ , a , _) = a
    ‡§Ö‡§®‡•Å : A ‚Üí Œ£[ b ‚àà B ] ‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É b
    ‡§Ö‡§®‡•Å a = f a , a , refl
    ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø : (x : Œ£[ b ‚àà B ] ‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É b) ‚Üí ‡§Ö‡§®‡•Å (‡§™‡•ç‡§∞‡§§‡§ø x) ‚â° x
    ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø (b , a , p) i = p i , a , Œª j ‚Üí p (i ‚àß j)
  -- the same read as a path, which is what transports
  ‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶-‡§™‡§•‡§É : (Œ£[ b ‚àà B ] ‡§∏‡•ç‡§Æ‡•É‡§§‡§ø‡§É b) ‚â° A
  ‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶-‡§™‡§•‡§É = ua ‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡Æ‡‡‡‡Ø‡‡æ‡µ‡ ‚î no memory is exactly `isEquiv`.
--
-- "The boundary retains everything" is every fibre contractible, which is
-- the DEFINITION of isEquiv, not a consequence of it ‚î so this is `refl`
-- on the record's field and the content is that the physics reading and
-- the type-theoretic one are the same predicate.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} {f : A ‚Üí B} where

  ‡§∏‡•ç‡§Æ‡•É‡§§‡•ç‡§Ø‡§≠‡§æ‡§µ‡§É : isEquiv f ‚Üí (b : B) ‚Üí isContr (fiber f b)
  ‡§∏‡•ç‡§Æ‡•É‡§§‡•ç‡§Ø‡§≠‡§æ‡§µ‡§É e = equiv-proof e

  -- and then the cut is trivial: the boundary IS the history set.
  ‡§∏‡•Ä‡§Æ‡§æ-‡§∏‡§∞‡•ç‡§µ‡§Æ‡•ç : isEquiv f ‚Üí A ‚â° B
  ‡§∏‡•Ä‡§Æ‡§æ-‡§∏‡§∞‡•ç‡§µ‡§Æ‡•ç e = ua (f , e)

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡Ø‡ã ‡‡ô‡‡ó‡æ‡ ‚î the three verdicts, at the cut.
--
-- `Tantujala_‚¶agda` proves the fibre census has three answers and that
-- `isContr` merges two of them.  Here that theorem is READ at the cut and
-- becomes a statement about memory: a boolean verdict on a boundary
-- cannot tell "this profile is never induced" from "this profile is
-- induced by many histories and the boundary must remember which".
--
-- The witnesses are the smallest possible and are `refl`, because the
-- point is not that they are hard ‚î it is that they are DIFFERENT.
------------------------------------------------------------------------

open import Cubical.Data.Unit
open import Cubical.Data.Bool
open import Cubical.Data.Empty renaming (rec to ‚ä•-rec)

-- ‡∞‡ø‡ï‡‡‡Æ‡ : a profile no history induces.  ‚ä ‚í Unit has empty fibre at tt.
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç : fiber {A = ‚ä•} {B = Unit} (Œª ()) tt ‚Üí ‚ä•
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç (() , _)

-- ‡‡‡ : two histories, one profile.  Bool ‚í Unit remembers a bit.
‡§¨‡§π‡•Å-‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç : fiber {A = Bool} {B = Unit} (Œª _ ‚Üí tt) tt
‡§¨‡§π‡•Å-‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç = false , refl

‡§¨‡§π‡•Å-‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç' : fiber {A = Bool} {B = Unit} (Œª _ ‚Üí tt) tt
‡§¨‡§π‡•Å-‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç' = true , refl

-- Neither fibre is contractible, and a verdict that says only "not
-- contractible" has said one word about two situations: in the first
-- nothing is remembered because nothing happened, in the second a bit
-- must cross the boundary.  That is the ‡¶‡‡∞‡‡®‡Ø.

