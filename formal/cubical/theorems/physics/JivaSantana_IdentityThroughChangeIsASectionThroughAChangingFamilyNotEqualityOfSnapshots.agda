{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡µ-‡‡®‡‡‡æ‡® ‚î the thread of the living: identity through time is a
-- SECTION through a changing family of worlds, not equality of
-- snapshots.  The transitions need not be equalities; the worlds
-- themselves may change type (retyping, splitting, enrichment).  Yet
-- the biography is transportable: the section's value at any time is
-- generated from its origin by the transitions.  Change does not
-- annihilate continuity, and continuity does not forbid change.
-- (Owner's temporal-body message; the exact structure as a term.)
--
-- THE ZIGZAG.  Life having occurred means M‚ô ‚â† M‚ô‚ä‚.  The union is
-- wrong (a correction may RETYPE an earlier claim).  So a transition is
-- a span
--
--     M‚ô  ‚ê‚î  C‚ô  ‚î‚í  M‚ô‚ä‚
--
-- with C‚ô the conserved world that transports lawfully across the
-- change.  What cannot cross is not deleted ‚î its failed transport
-- becomes the transition fibre, and its FATE is recorded.  Here the
-- worlds are types W‚ô and the transition is a map œ‚ô : W‚ô ‚í W‚ô‚ä‚ (an
-- equivalence, a refinement, a restriction ‚î ANY map; W changes type),
-- which is one leg of the span with the conserved core as its domain.
--
-- THE JVA is a section j‚ô : W‚ô with œ‚ô(j‚ô) ‚â j‚ô‚ä‚ ‚î the coherence that
-- makes it ONE thread rather than a sequence of unrelated states.  œ‚ô
-- need not be equality; the ‚â° below is the coherence witness, and W‚ô,
-- W‚ô‚ä‚ may be genuinely different types.
--
-- THE BIOGRAPHY THEOREM (¬ß2).  For a jva, the value at time n is
-- EXACTLY what the transitions generate from the origin:
--
--     j‚ô  ‚â°  (œ‚ô‚ã‚ ‚àò ‚ãØ ‚àò œ‚)(j‚).
--
-- Identity through change is the recoverability of the whole biography
-- from the origin along the transitions ‚î "a coherent capacity to
-- transport its own biography", as a checked path.  Proof: induction
-- through the coherence, the œ^-index shape of `VanaSetu`.
--
-- THE FIVE FATES (¬ß3).  A single claim, under a transition, meets one
-- of five fates ‚î the owner's anatomy of a lossless correction.  They
-- are the constructors of the transition fibre; the datatype is their
-- codomain.  Classifying a SPECIFIC claim's fate needs the actual span
-- maps; this supplies the type a lossless correction must land in, so
-- that no claim silently vanishes.
------------------------------------------------------------------------

module JivaSantana_IdentityThroughChangeIsASectionThroughAChangingFamilyNotEqualityOfSnapshots where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï; zero; suc)
open import Cubical.Data.Sigma using (Œ£; Œ£-syntax; _,_; fst; snd)

private
  variable
    ‚Ñì : Level

-- a changing family of worlds, and the transitions between them.
module _ (W : ‚Ñï ‚Üí Type ‚Ñì) (œÑ : (n : ‚Ñï) ‚Üí W n ‚Üí W (suc n)) where

  -- THE JVA: a section with the coherence that makes it one thread.
  -- œ n (j n) ‚â° j (suc n) ‚î the transition carries this life's present
  -- to (a witness of) its next.  œ is an arbitrary map: the worlds may
  -- change type, and the ‚â° is the only thing making the thread single.
  Jiva : Type ‚Ñì
  Jiva = Œ£[ j ‚àà ((n : ‚Ñï) ‚Üí W n) ] ((n : ‚Ñï) ‚Üí œÑ n (j n) ‚â° j (suc n))

  -- the biography generated from an origin by the transitions.
  chase : (a‚ÇÄ : W 0) ‚Üí (n : ‚Ñï) ‚Üí W n
  chase a‚ÇÄ zero    = a‚ÇÄ
  chase a‚ÇÄ (suc n) = œÑ n (chase a‚ÇÄ n)

------------------------------------------------------------------------
-- ¬ß2 ¬ THE BIOGRAPHY THEOREM.  A jva's value at every time is exactly
-- what the transitions generate from its origin.  Identity through
-- change = transportability of the whole biography.

  biography : (J : Jiva) (n : ‚Ñï) ‚Üí chase (fst J 0) n ‚â° fst J n
  biography J zero    = refl
  biography J (suc n) =
    cong (œÑ n) (biography J n)   -- œÑ n (chase ‚Ä¶ n) ‚â° œÑ n (j n)
    ‚àô snd J n                    -- ‚â° j (suc n), by the coherence

------------------------------------------------------------------------
-- ¬ß3 ¬ THE FIVE FATES of a claim under a correction (the owner's
-- anatomy of a lossless transition).  A lossless correction is one
-- whose transition assigns EVERY old claim one of these ‚î nothing
-- silently vanishes.

data Fate : Type where
  transported : Fate   -- crossed unchanged (in the conserved core C‚Çô)
  restricted  : Fate   -- survived under a narrower hypothesis
  refuted     : Fate   -- a new distinction invalidated it
  split       : Fate   -- one fibre became several
  unresolved  : Fate   -- its transport is owed, not yet known

-- a correction is LOSSLESS when it assigns a fate to every claim: the
-- future can still answer "what did the old world assert, and what
-- became of it."  The type of such an accounting, over a world Claims:
Lossless : {‚Ñì' : Level} (Claims : Type ‚Ñì') ‚Üí Type ‚Ñì'
Lossless Claims = Claims ‚Üí Fate

-- the five fates are genuinely distinct (a Fate is not a Bool: a
-- boolean "survived?" would merge restricted/split/transported and
-- refuted/unresolved ‚î the durnaya the whole corpus refuses).  Witness:
open import Cubical.Data.Bool using (Bool; true; false; true‚â¢false)
open import Cubical.Data.Empty using (‚ä•)

transported‚â¢refuted : transported ‚â° refuted ‚Üí ‚ä•
transported‚â¢refuted p = true‚â¢false (cong tag p)
  where
  tag : Fate ‚Üí Bool
  tag transported = true
  tag _           = false
