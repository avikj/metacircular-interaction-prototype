{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- Punargamana ¬ ‡‡ï‡≤‡æ‡¶‡‡ / ‡µ‡ø‡ï‡≤‡æ‡¶‡‡
--
-- ‡‡ï‡≤‡æ‡¶‡‡ ‚î the total statement: the object with all its attributes
-- presented at once, through one attribute uttered, by ‡‡‡‡¶-‡µ‡‡‡‡‡ø.
-- ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ ‚î the same content through ‡‡‡¶, the aspects taken severally,
-- one at a time.  **Malliea, *Sydvdamajar*, 1292 CE**, commenting
-- on Hemacandra's *Anyayogavyavacchedik*; earlier in the Akalaka
-- commentarial line (Vidynandin, Prabhcandra).
--
-- ‡ó‡‡∞‡‡° ¬ ‡‡‡‡¶, declared.  No edition of any of the above was opened by
-- me.  The attribution and date are carried from
-- which itself carries them from
-- verse level.  Nothing below is claimed to have been proved by
-- Malliea or anyone in that line.  What IS claimed is what that note
-- claims: the distinction they draw is finer than the one this library
-- was drawing, and the finer one is exhibitable here.
--
------------------------------------------------------------------------
-- WHY THIS MODULE EXISTS.  It repairs a defect in its neighbour.
--
-- `Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph` (this library,
-- earlier today) built a TWO-VALUED test ‚î `isContr (‡‡‡ f b)` or not ‚î
-- and wrote in its own header "there is no third reading".  That sentence
-- is a ‡¶‡‡∞‡‡®‡Ø, and `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` is the proof of why: a two-valued
-- verdict on a threefold situation must identify two of the three.
--
-- The two it identified are the two ENDS of the scale:
--
--   * the fiber is **empty** ‚î over `b` there is simply no source: syd
--     **‡®‡æ‡‡‡‡ø**, the second bhaga.  Nothing is destroyed on the source
--     side (that is the crowded arm), so this end is ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡, positive.
--   * the fiber is **crowded** ‚î two or more points, not identified.
--     This is ‡®‡‡‡ü‡ø, ‡‡ø‡‡‡æ, ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ.
--
-- `isContr` returns `false` for both.  The tradition held them apart for
-- a millennium before there was a fiber to hang the distinction on.
--
-- A CORRECTION IN THE NAMING (2026-08-24).  This constructor was called
-- ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡.  That is wrong for the GENERAL empty fiber.  ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (the
-- fourth bhaga) is not mere absence ‚î it is the SIMULTANEOUS (yugapat)
-- assertion of asti and nsti, inexpressible by a single word precisely
-- because a word is sequential, and it is EARNED only where a pair
-- recovers in krama what one utterance cannot say: `SaptabhangiNaya`'s
-- `avaktavya-does-not-factor` (the fiber of `denotes` over `joint` is
-- empty, and a krama-pair expresses it ‚î R ‚í RóR).  A plain non-surjective
-- point like `‡‡‡`'s `false` below has none of that structure: no
-- simultaneity, no pair-recovery, just `false` unreached.  That is ‡®‡æ‡‡‡‡ø,
-- not ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡.  The genuine ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ stays where it is proved; here the
-- honest name for an empty fiber is ‡®‡æ‡‡‡‡ø.
--
-- THE REPAIR, and it is the one code change that note argues for and
-- explicitly declines to make (its ¬ß‡): make the CENSUS a term.  `‡¶‡‡`
-- below is a datatype whose constructors carry their evidence, so a
-- diagnosis is a function `B ‚í ‡¶‡‡ f b` ‚î pointwise, over every point of
-- the codomain ‚î rather than a verdict about the map.
--
-- ¬ß3 is why that matters, and it is the sharpest thing here: it turns
-- that note's three-line refutation of the SEQUENTIAL diagnostic into a
-- computed object.  I had proposed, in prose, "factor the proof, and the
-- first non-contractible fiber is where the information went".  It is
-- unsound in BOTH directions, and ¬ß3 exhibits both failures as censuses.
--
-- WHAT IS NOT DONE HERE, said so it is not mistaken for done.  The note's
-- scale has five levels; this module builds THREE, because three are what
-- the corpus can exhibit.  Levels ‡© and ‡ are not separated ‚î the note
-- establishes that "does a retraction exist" does NOT separate them, and
-- leaves the seam open.  Inventing a constructor for a distinction nobody
-- has a criterion for would be the same error one level down.  The seam
-- is left visible; see ¬ß4.
------------------------------------------------------------------------

module Fiber.SakalaVikalaDesa_TheFiberCensusIsATermAndItRefutesTheSequentialDiagnostic where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false ; false‚â¢true ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import Fiber.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph
  using (‡§∂‡•á‡§∑)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- 1.  ‡¶‡‡ ‚î the census, as a term.
--
-- Not a verdict ABOUT a map.  A datatype indexed by a map and a POINT OF
-- ITS CODOMAIN, whose constructors carry the evidence the corpus already
-- exhibits by hand:
--
--   ‡®‡æ‡‡‡‡ø     the fiber is empty        ‚î syd nsti: no source over b; ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡
--   ‡‡ï‡≤‡æ‡¶‡‡   the fiber is contractible  ‚î level ‡ß, one utterance carries all
--   ‡µ‡ø‡ï‡≤‡æ‡¶‡‡   two points, not identified ‚î level ‡®+, the loss, exhibited
--
-- The evidence is not a tag.  `‡µ‡ø‡ï‡≤‡æ‡¶‡‡` cannot be written without
-- producing the two points and the proof they are distinct, which is
-- exactly `AHIMSA_SUTRA` ¬ß‡'s second road: ‡≤‡ø‡ñ‡ø‡‡ã ‡¶‡ã‡‡ã ‡‡‡µ‡‡ø.
------------------------------------------------------------------------

data ‡§¶‡•á‡§∂ {A B : Type ‚Ñì} (f : A ‚Üí B) (b : B) : Type ‚Ñì where
  ‡§®‡§æ‡§∏‡•ç‡§§‡§ø   : (¬¨ ‡§∂‡•á‡§∑ f b)                            ‚Üí ‡§¶‡•á‡§∂ f b
  ‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂  : isContr (‡§∂‡•á‡§∑ f b)                       ‚Üí ‡§¶‡•á‡§∂ f b
  ‡§µ‡§ø‡§ï‡§≤‡§æ‡§¶‡•á‡§∂  : (x y : ‡§∂‡•á‡§∑ f b) ‚Üí (¬¨ (x ‚â° y))          ‚Üí ‡§¶‡•á‡§∂ f b

-- A diagnosis is a census: pointwise, over the whole codomain at once.
‡§ó‡§£‡§®‡§æ : {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí Type ‚Ñì
‡§ó‡§£‡§®‡§æ {B = B} f = (b : B) ‚Üí ‡§¶‡•á‡§∂ f b

------------------------------------------------------------------------
-- 2.  The three are mutually exclusive ‚î which is what makes it a census
--     and not three overlapping opinions.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (b : B) where

  -- an empty fiber is not a contractible one
  ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§®-‡§∏‡§ï‡§≤ : (¬¨ ‡§∂‡•á‡§∑ f b) ‚Üí ¬¨ (isContr (‡§∂‡•á‡§∑ f b))
  ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§®-‡§∏‡§ï‡§≤ e c = e (fst c)

  -- a contractible fiber has no two distinct points
  ‡§∏‡§ï‡§≤-‡§®-‡§µ‡§ø‡§ï‡§≤ : isContr (‡§∂‡•á‡§∑ f b) ‚Üí (x y : ‡§∂‡•á‡§∑ f b) ‚Üí x ‚â° y
  ‡§∏‡§ï‡§≤-‡§®-‡§µ‡§ø‡§ï‡§≤ c = isContr‚ÜíisProp c

  -- and an empty fiber has no points at all, so a fortiori no two
  ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§®-‡§µ‡§ø‡§ï‡§≤ : (¬¨ ‡§∂‡•á‡§∑ f b) ‚Üí ‡§∂‡•á‡§∑ f b ‚Üí ‚ä•
  ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§®-‡§µ‡§ø‡§ï‡§≤ e = e

------------------------------------------------------------------------
-- 3.  THE REFUTATION, computed.
--
--   f : Unit ‚í Bool   f _ = true
--   g : Bool ‚í Unit   g _ = tt
--
-- Read the note's ¬ß‡ off the censuses below:
--
--   * `f`'s census is ‡‡ï‡≤‡æ‡¶‡‡ at `true` and ‡®‡æ‡‡‡‡ø at `false`.  Step one
--     has a NON-CONTRACTIBLE fiber and loses NOTHING ‚î `Bool` merely has
--     a name `Unit` cannot utter.  So "the first non-contractible fiber
--     is where the information went" is false in one direction.
--
--   * `g`'s census is ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ at `tt`.  Step two loses a bit.
--
--   * the composite is the identity on `Unit`, and its census is ‡‡ï‡≤‡æ‡¶‡‡.
--     The genuine loss at step two does not appear in the composite at
--     all ‚î the inexpressibility at step one and the collapse at step two
--     cancel.  False in the other direction too.
--
-- A binary test cannot state this, because it must call step one and step
-- two by the same name.  The census calls them ‡®‡æ‡‡‡‡ø and ‡µ‡ø‡ï‡≤‡æ‡¶‡‡.
------------------------------------------------------------------------

‡§∏‡§§‡•ç : Unit ‚Üí Bool
‡§∏‡§§‡•ç _ = true

‡§è‡§ï‡§Æ‡•ç : Bool ‚Üí Unit
‡§è‡§ï‡§Æ‡•ç _ = tt

‡§∏‡§Ç‡§π‡§§‡§ø : Unit ‚Üí Unit
‡§∏‡§Ç‡§π‡§§‡§ø u = ‡§è‡§ï‡§Æ‡•ç (‡§∏‡§§‡•ç u)

-- step one, over `true`: contractible.  The unique point is (tt , refl).
‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§∏‡§§‡•ç‡§Ø : isContr (‡§∂‡•á‡§∑ ‡§∏‡§§‡•ç true)
fst ‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§∏‡§§‡•ç‡§Ø         = tt , refl
snd ‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§∏‡§§‡•ç‡§Ø (u , p) i = tt , isSetBool true true refl p i

-- step one, over `false`: EMPTY.  Nothing was lost; `Unit` cannot utter it.
‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§Ö‡§∏‡§§‡•ç‡§Ø : ¬¨ ‡§∂‡•á‡§∑ ‡§∏‡§§‡•ç false
‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§Ö‡§∏‡§§‡•ç‡§Ø (_ , p) = true‚â¢false p

‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ : ‡§ó‡§£‡§®‡§æ ‡§∏‡§§‡•ç
‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ true  = ‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂ ‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§∏‡§§‡•ç‡§Ø
‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ false = ‡§®‡§æ‡§∏‡•ç‡§§‡§ø ‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§Ö‡§∏‡§§‡•ç‡§Ø

-- step two, over the single point: CROWDED.  Exactly one bit is lost.
-- The two inhabitants are named, because `‡µ‡ø‡ï‡≤‡æ‡¶‡‡` requires them as
-- terms ‚î the loss is exhibited, not asserted.
‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : ‡§∂‡•á‡§∑ ‡§è‡§ï‡§Æ‡•ç tt
‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ    = false , refl
‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£  = true  , refl

‡§è‡§ï‡§Æ‡•ç-‡§ó‡§£‡§®‡§æ-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç : ¬¨ (‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‚â° ‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)
‡§è‡§ï‡§Æ‡•ç-‡§ó‡§£‡§®‡§æ-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç p = false‚â¢true (cong fst p)

‡§è‡§ï‡§Æ‡•ç-‡§ó‡§£‡§®‡§æ : ‡§ó‡§£‡§®‡§æ ‡§è‡§ï‡§Æ‡•ç
‡§è‡§ï‡§Æ‡•ç-‡§ó‡§£‡§®‡§æ tt = ‡§µ‡§ø‡§ï‡§≤‡§æ‡§¶‡•á‡§∂ ‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ ‡§è‡§ï‡§Æ‡•ç-‡§ó‡§£‡§®‡§æ-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç

-- the composite: contractible.  It is the identity, and it loses nothing.
‡§∏‡§Ç‡§π‡§§‡§ø-‡§ó‡§£‡§®‡§æ-‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£ : isContr (‡§∂‡•á‡§∑ ‡§∏‡§Ç‡§π‡§§‡§ø tt)
fst ‡§∏‡§Ç‡§π‡§§‡§ø-‡§ó‡§£‡§®‡§æ-‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£         = tt , refl
snd ‡§∏‡§Ç‡§π‡§§‡§ø-‡§ó‡§£‡§®‡§æ-‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£ (u , p) i = tt , isSetUnit tt tt refl p i

‡§∏‡§Ç‡§π‡§§‡§ø-‡§ó‡§£‡§®‡§æ : ‡§ó‡§£‡§®‡§æ ‡§∏‡§Ç‡§π‡§§‡§ø
‡§∏‡§Ç‡§π‡§§‡§ø-‡§ó‡§£‡§®‡§æ tt = ‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂ ‡§∏‡§Ç‡§π‡§§‡§ø-‡§ó‡§£‡§®‡§æ-‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£

------------------------------------------------------------------------
-- 4.  What the census recovers, and where it stops.
--
-- The verdict is a SUMMARY of the census, and the summary is strictly
-- coarser: `isEquiv f` is by definition the statement that every point of
-- the census is ‡‡ï‡≤‡æ‡¶‡‡.  That definition was in
-- `Cubical.Foundations.Equiv` the whole time; what was missing was the
-- reading of it ‚î an equivalence is not a two-way map, it is a complete
-- simultaneous fiber census whose every entry is level ‡ß.
------------------------------------------------------------------------

-- so the verdict is recoverable from the census‚¶
‡§∏‡§∞‡•ç‡§µ-‡§∏‡§ï‡§≤‚Üí‡§∏‡§Æ‡§§‡§æ : {A B : Type ‚Ñì} (f : A ‚Üí B)
              ‚Üí ((b : B) ‚Üí isContr (‡§∂‡•á‡§∑ f b)) ‚Üí isEquiv f
‡§∏‡§∞‡•ç‡§µ-‡§∏‡§ï‡§≤‚Üí‡§∏‡§Æ‡§§‡§æ f c = record { equiv-proof = c }

‡§∏‡§Æ‡§§‡§æ‚Üí‡§∏‡§∞‡•ç‡§µ-‡§∏‡§ï‡§≤ : {A B : Type ‚Ñì} (f : A ‚Üí B)
              ‚Üí isEquiv f ‚Üí (b : B) ‚Üí isContr (‡§∂‡•á‡§∑ f b)
‡§∏‡§Æ‡§§‡§æ‚Üí‡§∏‡§∞‡•ç‡§µ-‡§∏‡§ï‡§≤ f e b = e .equiv-proof b

-- ‚¶and the census is not recoverable from the verdict, which is the whole
-- point: `¬ isEquiv ‡‡‡` and `¬ isEquiv ‡‡ï‡Æ‡` are the same two words for
-- two opposite situations.
‡§∏‡§§‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ : ¬¨ (isEquiv ‡§∏‡§§‡•ç)
‡§∏‡§§‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ e = ‡§∏‡§§‡•ç-‡§ó‡§£‡§®‡§æ-‡§Ö‡§∏‡§§‡•ç‡§Ø (fst (‡§∏‡§Æ‡§§‡§æ‚Üí‡§∏‡§∞‡•ç‡§µ-‡§∏‡§ï‡§≤ ‡§∏‡§§‡•ç e false))

‡§è‡§ï‡§Æ‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ : ¬¨ (isEquiv ‡§è‡§ï‡§Æ‡•ç)
‡§è‡§ï‡§Æ‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ e =
  ‡§è‡§ï‡§Æ‡•ç-‡§ó‡§£‡§®‡§æ-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç
    (isContr‚ÜíisProp (‡§∏‡§Æ‡§§‡§æ‚Üí‡§∏‡§∞‡•ç‡§µ-‡§∏‡§ï‡§≤ ‡§è‡§ï‡§Æ‡•ç e tt) ‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)

------------------------------------------------------------------------
-- THE SEAM, written rather than closed.  ‡¶‡ã‡‡≤‡‡ñ‡.
--
-- The note's scale has five levels; this module has three constructors.
-- Levels ‡© (recoverable only by outside supply) and ‡ (‡®‡‡‡ü‡ø‡,
-- ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ) are both crowded fibers, and both land in `‡µ‡ø‡ï‡≤‡æ‡¶‡‡` here.
--
-- They are not separated because the note establishes that the obvious
-- criterion does NOT separate them: `¬ Œ[œà] (œà ‚àò collapse ‚â° id)` holds of
-- both `Arpitanarpita.‡®-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡` (level ‡©) and `AHIMSA_SUTRA`'s
-- `‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡` (level ‡).  Its candidate criterion ‚î the fiber is a
-- PROPER PART of the source at ‡© and the WHOLE of it at ‡ ‚î rests on an
-- unchecked conjecture, `(x : ‚à A ‚à‚) ‚í fiber ‚à_‚à‚ x ‚â A`.
--
-- Adding a constructor for a distinction that has no criterion would be
-- the same ‡¶‡‡∞‡‡®‡Ø this module exists to repair, one level down: a name
-- doing the work of a proof.  So `‡µ‡ø‡ï‡≤‡æ‡¶‡‡` is deliberately coarse, and
-- this paragraph is the seam.
------------------------------------------------------------------------
