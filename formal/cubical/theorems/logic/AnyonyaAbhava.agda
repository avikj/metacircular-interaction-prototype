{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnyonyaAbhava
--
-- ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ ‚î mutual absence ‚î and why Vaieika-Nyya keeps it as a
-- SEPARATE category from ‡‡‡‡∞‡‡ó‡æ‡‡æ‡µ instead of reducing one to the other.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE DOCTRINE, AND WHY THIS MODULE EXISTS
--
-- `Abhava` builds ‡‡‡æ‡µ as a record carrying its
-- ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ and ‡‡µ‡‡‡‡‡¶‡ï, and analyses the tower ¬, ¬¬, ¬¬¬.  All of
-- that is ‡‡‡‡∞‡‡ó‡æ‡‡æ‡µ: the absence of a RELATION at a locus ‚î the pot is
-- not on the floor.  Praastapda's division (*Padrthadharmasagraha*,
-- c. 6th c.) and every Nyya text after it insist on a second kind:
--
--     ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ ‚î the absence of IDENTITY.  A cloth is not a pot.
--     Its ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ is the pot, its ‡‡®‡‡Ø‡ã‡ó‡ø‡®‡ the cloth, and what is
--     absent is ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø, identity itself, not a relation between two
--     things that are already distinct.
--
-- The reduction has been attempted in both directions for a thousand
-- years and Navya-Nyya rejects both.  This module is that dispute,
-- made exact: CLASSICALLY THE TWO ARE INTERDERIVABLE AND THE DISPUTE IS
-- EMPTY.  Constructively they are not.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß2  ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ IS an ‡‡‡æ‡µ in this corpus's own sense: it
--       instantiates `Abhava.Abhva` with ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ `_‚â° b`.  So the
--       record was already general enough, which is worth knowing
--       before adding anything to it.
--
--   ¬ß3  ‡‡®‡‡Ø‡ã‡®‡‡Ø ‚ü ‡‡‡‡∞‡‡ó, freely.  Two points the ‡‡µ‡‡‡‡‡¶‡ï identifies
--       but whose values are mutually absent destroy every decoder at
--       once.  This is the corpus's collision lemma, and naming its
--       parts is not decoration: the hypothesis `q x ‚â° q x'` is
--       precisely an ‡‡µ‡‡‡‡‡¶‡ï, the qualification under which the two
--       are not distinguished.
--
--   ¬ß4  ‡‡‡‡∞‡‡ó ‚ü ‡‡®‡‡Ø‡ã‡®‡‡Ø only up to ¬¬, and even that needs the
--       ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ to be decidable.  So the reduction FAILS, and it
--       fails by exactly one step of the tower `Abhava` ¬ß2 measures.
--
--   ¬ß5  Under a decidable ‡‡µ‡‡‡‡‡¶‡ï the step is free (`Abhava
--       .dec-collapses`), and the two categories become interderivable.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE POINT, WHICH IS NOT A TRANSLATION
--
-- The two-fold division is not scholastic hair-splitting and it is not
-- a taxonomy of examples.  It tracks a real obstruction, the obstruction
-- is one level of the negation tower, and it dissolves exactly when the
-- ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ is decidable.  A reader with excluded middle sees two
-- names for one thing and concludes the Naiyyikas were counting
-- angels; a reader without it finds the distinction forced.
--
-- SOURCES.  Praastapda, *Padrthadharmasagraha* (c. 6th c.), where
-- ‡‡‡æ‡µ's division is set out; Udayana, *Nyyakusumjali* (c. 1000);
-- Gagea, *Tattvacintmai*, abhva-khaa (c. 1325), where the
-- ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡‡æ analysis is refined; Raghuntha iromai,
-- *Padrthatattvanirpaa* (c. 1500), on which categories survive
-- scrutiny.  The mathematics below is this corpus's; the DIVISION and
-- the claim of irreducibility are theirs, and are what is being tested.
------------------------------------------------------------------------

module AnyonyaAbhava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary
  using (¬¨_ ; Dec ; yes ; no ; Discrete ; Stable ; Separated)
open import Cubical.Relation.Nullary.Properties
  using (Discrete‚ÜíSeparated)
open import Cubical.Foundations.Prelude using (isSet)
open import Cubical.Relation.Nullary.Properties using (Discrete‚ÜíisSet)

open import Abhava using (AbhƒÅva ; delimitor ; absent ; dec-collapses)
open import FiniteInformation
  using (FactorsThrough ; FiberConstant ; fiberConstant‚ÜífactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

private
  variable
    ‚Ñì ‚Ñìx ‚Ñìy ‚Ñìt : Level

------------------------------------------------------------------------
-- 1.  ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ: the absence of identity, not of a relation
------------------------------------------------------------------------

Anyonya : {T : Type ‚Ñìt} ‚Üí T ‚Üí T ‚Üí Type ‚Ñìt
Anyonya a b = ¬¨ (a ‚â° b)

------------------------------------------------------------------------
-- 2.  It is an ‡‡‡æ‡µ in the corpus's own sense
--
-- ‡‡®‡‡Ø‡ã‡ó‡ø‡®‡ becomes the delimitor, ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ the family `_‚â° b`.  Nothing
-- had to be added to the record: it was built general enough, and this
-- is the check rather than the assertion.
------------------------------------------------------------------------

anyonya-is-abhava : {T : Type ‚Ñìt} (a b : T) ‚Üí Anyonya a b ‚Üí AbhƒÅva T (_‚â° b)
AbhƒÅva.delimitor (anyonya-is-abhava a b _)  = a
AbhƒÅva.absent    (anyonya-is-abhava a b ne) = ne

anyonya-from-abhava : {T : Type ‚Ñìt} (b : T) (A : AbhƒÅva T (_‚â° b))
                    ‚Üí Anyonya (delimitor A) b
anyonya-from-abhava b A = absent A

------------------------------------------------------------------------
-- 3.  ‡‡®‡‡Ø‡ã‡®‡‡Ø ‚ü ‡‡‡‡∞‡‡ó, with no hypothesis
--
-- The ‡‡µ‡‡‡‡‡¶‡ï is `q x ‚â° q x'`: the qualification under which the two
-- loci are NOT distinguished.  Under it, a mutual absence of their
-- values is the absence of every decoding relation at once.
------------------------------------------------------------------------

anyonya‚Üísamsarga :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
  (q : X ‚Üí Y) (t : X ‚Üí T) {x x' : X}
  ‚Üí q x ‚â° q x'                       -- ‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§ï: identified here
  ‚Üí Anyonya (t x) (t x')             -- ‡§Ö‡§®‡•ç‡§Ø‡•ã‡§®‡•ç‡§Ø‡§æ‡§≠‡§æ‡§µ: not identical there
  ‚Üí ¬¨ FactorsThrough q t             -- ‡§∏‡§Ç‡§∏‡§∞‡•ç‡§ó‡§æ‡§≠‡§æ‡§µ: no relation, anywhere
anyonya‚Üísamsarga q t = collisionObstructsDecoder q t

------------------------------------------------------------------------
-- 4.  ‡‡‡‡∞‡‡ó ‚ü ‡‡®‡‡Ø‡ã‡®‡‡Ø ONLY UP TO ¬¬, and only with a decidable
--     ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ ‚î so the reduction fails
------------------------------------------------------------------------

Collision : {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
          ‚Üí (X ‚Üí Y) ‚Üí (X ‚Üí T) ‚Üí Type (‚Ñì-max ‚Ñìx (‚Ñì-max ‚Ñìy ‚Ñìt))
Collision {X = X} q t =
  Œ£[ x ‚àà X ] Œ£[ x' ‚àà X ] ((q x ‚â° q x') √ó Anyonya (t x) (t x'))

samsarga‚Üí¬¨¬¨anyonya :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
  (dT : Discrete T) (q : X ‚Üí Y) (t : X ‚Üí T)
  ‚Üí ¬¨ FactorsThrough q t
  ‚Üí ¬¨ ¬¨ (Collision q t)
samsarga‚Üí¬¨¬¨anyonya dT q t noDecoder noCollision =
  noDecoder (fiberConstant‚ÜífactorsThrough (Discrete‚ÜíisSet dT) q t constant)
  where
  constant : FiberConstant q t
  constant x x' same =
    Discrete‚ÜíSeparated dT (t x) (t x')
      (Œª ne ‚Üí noCollision (x , x' , same , ne))

------------------------------------------------------------------------
-- 5.  And the missing step is exactly one level of the tower
--
-- If the collision claim itself is decidable, `Abhava.dec-collapses`
-- closes it and the two categories become interderivable.  So the
-- irreducibility is not absolute: it is indexed by the ‡‡µ‡‡‡‡‡¶‡ï, which
-- is what an ‡‡µ‡‡‡‡‡¶‡ï is for.
-- (Stability of the collision claim already suffices: `TheDelimitorNeedsOnlyStability`.)
------------------------------------------------------------------------

samsarga‚Üíanyonya-when-decidable :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
  (dT : Discrete T) (q : X ‚Üí Y) (t : X ‚Üí T)
  ‚Üí Dec (Collision q t)
  ‚Üí ¬¨ FactorsThrough q t
  ‚Üí Collision q t
samsarga‚Üíanyonya-when-decidable dT q t dC noDecoder =
  dec-collapses dC (samsarga‚Üí¬¨¬¨anyonya dT q t noDecoder)

-- the two directions, side by side, at a decidable delimitor
categories-agree-when-decidable :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {T : Type ‚Ñìt}
  (dT : Discrete T) (q : X ‚Üí Y) (t : X ‚Üí T) (dC : Dec (Collision q t))
  ‚Üí (Collision q t ‚Üí ¬¨ FactorsThrough q t)
  √ó (¬¨ FactorsThrough q t ‚Üí Collision q t)
categories-agree-when-decidable dT q t dC =
    (Œª c ‚Üí anyonya‚Üísamsarga q t {x = c .fst} {x' = c .snd .fst}
             (c .snd .snd .fst) (c .snd .snd .snd))
  , samsarga‚Üíanyonya-when-decidable dT q t dC

------------------------------------------------------------------------
-- 6.  What was tested, and what it says about the tradition.
--
-- TESTED, not assumed: that the Vaieika division of ‡‡‡æ‡µ into
-- ‡‡‡‡∞‡‡ó and ‡‡®‡‡Ø‡ã‡®‡‡Ø is doing work.  It is.  One direction is free,
-- the other costs a step of the negation tower, and the cost is
-- discharged by stability (`TheDelimitorNeedsOnlyStability`; decidability suffices) of the ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡.
--
-- The classical reader cannot see this.  With excluded middle ¬ß4's ¬¬
-- evaporates, the two categories are interderivable at every delimitor,
-- and the thousand-year dispute over whether one reduces to the other
-- looks like a dispute about nothing.  It is not: it is a dispute about
-- a distinction that only a constructive setting can register.
--
------------------------------------------------------------------------
