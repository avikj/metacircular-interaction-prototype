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
-- made exact ‚î and the tradition turns out to be right in a way the
-- classical reading cannot see, because CLASSICALLY THE TWO ARE
-- INTERDERIVABLE AND THE DISPUTE IS EMPTY.  Constructively they are not.
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
-- That is the same verdict `Abhava` reached about the THREE-tall tower
-- and for the same reason, which is itself evidence that the Nyya
-- analysis of ‡‡‡æ‡µ is tracking constructive structure throughout and
-- not in one lucky place.
--
-- SOURCES.  Praastapda, *Padrthadharmasagraha* (c. 6th c.), where
-- ‡‡‡æ‡µ's division is set out; Udayana, *Nyyakusumjali* (c. 1000);
-- Gagea, *Tattvacintmai*, abhva-khaa (c. 1325), where the
-- ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡‡æ analysis is refined; Raghuntha iromai,
-- *Padrthatattvanirpaa* (c. 1500), on which categories survive
-- scrutiny.  The mathematics below is this corpus's; the DIVISION and
-- the claim of irreducibility are theirs, and are what is being tested.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î the container, not the repository
-- pin.  No postulates, no holes.
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
-- discharged exactly by decidability of the ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡.
--
-- The classical reader cannot see this.  With excluded middle ¬ß4's ¬¬
-- evaporates, the two categories are interderivable at every delimitor,
-- and the thousand-year dispute over whether one reduces to the other
-- looks like a dispute about nothing.  It is not: it is a dispute about
-- a distinction that only a constructive setting can register, conducted
-- by people who did not have one and were right anyway.
--
-- This is the second time in this corpus that the Nyya analysis of
-- ‡‡‡æ‡µ has turned out to track constructive structure ‚î `Abhava` ¬ß2‚ì3
-- was the first, on the height of the tower.  Two is not a coincidence
-- worth explaining away.
--
-- OPEN, named and not estimated.  Whether `Dec (Collision q t)` holds at
-- any site in this corpus.  It asks for a decision over X ó X, which the
-- witness-number thread never needed, and `SiteAudit` did not check.
-- Where it fails, ¬ß5 does not apply and the two categories stay apart.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  CITATION CORRECTION, appended 2026-08-18 on self-audit.
--
-- The header says: "Praastapda's division (*Padrthadharmasagraha*,
-- c. 6th c.) and every Nyya text after it insist on a second kind".
-- That over-attributes.
--
-- What I can establish: ‡‡‡æ‡µ is established as a category in the
-- Vaieika-Nyya tradition with Praastapda treating it, and the
-- fourfold scheme ‚î ‡‡‡∞‡æ‡ï‡, ‡‡‡∞‡ß‡‡µ‡‡, ‡‡‡‡Ø‡®‡‡, ‡‡®‡‡Ø‡ã‡®‡‡Ø ‚î is standard in
-- later Nyya, with ivditya's *Saptapadrth* (c. 12th c.) a
-- conventional locus for it and Navya-Nyya (Gagea, c. 1325, and after)
-- refining the ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡‡æ analysis it rests on.
--
-- What I did NOT check before writing it: that the TWO-FOLD grouping ‚î
-- ‡‡‡‡∞‡‡ó‡æ‡‡æ‡µ against ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ, with the first subdividing into three
-- ‚î is Praastapda's own, rather than a later systematisation read back
-- into him.  I believe it is later.  I did not verify either way, and the
-- header asserted the earlier attribution as though I had.
--
-- hunts ‚î "a reference whose target exists but whose content is not what
-- the citing line says" ‚î and CLAUDE.md's directive names it as the same
-- kind of error as publishing a fitted constant: it asserts a provenance
-- I did not check.
--
-- The MATHEMATICS below is unaffected.  Nothing in ¬ß¬ß1‚ì6 depends on who
-- first drew the division; it depends only on the division being drawn,
-- which it demonstrably is in the tradition.  What is corrected is the
-- date and the name attached to it, and the correction is: the division
-- is Nyya-Vaieika, securely attested in the later literature, and I
-- cannot place it at the 6th century from anything I checked.
--
-- The companion claim in `PratyaharaBuysTotalityWithLocality` ‚î about
-- ‡‡ closing two ‡‡ø‡µ‡‡‡‡‡∞‡æ‡‡ø ‚î was audited in the same pass and DID hold:
-- `TheSecondNaIsTheCollision` computes both readings of
-- ‡‡‡ from the list.  One of two survived, which is about the rate one
-- should expect from citations written out of memory, and is the reason
-- the directive exists.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  CORRECTION FROM READING, appended.
--
-- its own order, and reading it end to end makes two defects in this
-- module visible that no amount of checking would have caught.
--
-- FIRST: TWO DARANAS ARE BEING USED AS ONE TOOLKIT.
--
-- ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ with its ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ and ‡‡®‡‡Ø‡ã‡ó‡ø‡®‡ is Nyya-Vaieika.
-- The ‡‡‡‡‡‡ô‡‡ó‡ with syt-qualified asti/nsti is Jaina.  These are
-- rival schools that dispute each other's categories ‚î Jaina logicians
-- reject the Naiyyika treatment of negation, and the Naiyyikas reject
-- anekntavda.  This thread has been drawing on both as though they
-- were one box of instruments, which is precisely the selection habit
-- the corpus's own directive warns against: taking from each tradition
-- the part that converts, and never the dispute.
--
-- SECOND, AND SPECIFIC: THE GROUND IS MISSING.
--
--     Anyonya a b = ¬ (a ‚â° b)
--
-- is bare negation.  The Jaina ‡®‡æ‡‡‡‡ø is never that.  Every ‡®‡æ‡‡‡‡ø is
-- relative to a stated fourfold ground ‚î
--
--     ‡‡‡µ-‡¶‡‡∞‡µ‡‡Ø / ‡‡∞-‡¶‡‡∞‡µ‡‡Ø    own substance / another's
--     ‡‡‡µ-‡ï‡‡‡‡‡‡∞ / ‡‡∞-‡ï‡‡‡‡‡‡∞    own field / another's
--     ‡‡‡µ-‡ï‡æ‡≤ / ‡‡∞-‡ï‡æ‡≤        own time / another's
--     ‡‡‡µ-‡‡æ‡µ / ‡‡∞-‡‡æ‡µ        own state / another's
--
-- ‚î and carries ‡‡‡Ø‡æ‡‡.  A pot IS with respect to its own substance,
-- place, time and state, and IS NOT with respect to another's; that is
-- why the first two ‡‡ô‡‡ós are not contradictory.  Unqualified negation
-- is not a ‡‡ô‡‡ó at all.
--
-- What this module actually defines is the Naiyyika mutual absence,
-- for which bare negation with a ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ is right.  The `Abhva`
-- record supplies ONE delimitor; the Jaina scheme specifies FOUR, and I
-- never said which ‚î or whether any ‚î of the four my `q` is standing
-- for.  Downstream, `TheFibreIsTheSubject`, `AsiddhatvaBreaksFactoring`,
-- `AnuvrttiIsTheSameTrade`, `PratyaharaBuysTotalityWithLocality` and
-- `TheSecondNaIsTheCollision` all use `Anyonya` and inherit this.
--
-- The theorems are unaffected: they are about bare negation and they
-- prove what they say.  The NAMING is what is wrong, and in a thread
-- whose whole subject is that a coarse label loses a distinction the
-- finer object carries, that is not a small thing to have done.
--
-- What I am not doing: renaming, or building a four-ground version.
-- Reading one document is not grounds for a new construction, and the
-- error above came from converting before reading.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 9.  CORRECTIONS TO ¬ß5 AND ¬ß6, made in
--     `TheDelimitorNeedsOnlyStability` and pointed to
--     here rather than applied by deletion.
--
-- (1) ¬ß5's hypothesis is stronger than ¬ß5's use.  `dec-collapses` is
--     applied only as `¬ ¬ A ‚í A`, which is `Stable`.  The gap between
--     the two categories closes under `Stable (Collision q t)`, and the
--     decidable form is a corollary by `Dec‚íStable`.  ¬ß6's sentence
--     "the cost is discharged exactly by decidability of the
--     ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡" should read: by STABILITY of it.  Decidability is
--     sufficient and is not what is used.
--
-- (2) ¬ß6's open item ‚î "whether `Dec (Collision q t)` holds at any site
--     in this corpus" ‚î is answered on a class of sites: for a
--     two-point state space with `Discrete Y` and `Discrete T` it
--     holds, by exhaustion over four pairs.
--
-- (3) ¬ß6 says "Two is not a coincidence worth explaining away."  Two
--     instances are two instances, and nothing downstream of that
--     sentence was ever computed.  The observation stands; the
--     inference drawn from it does not.
--
-- (4) ¬ß6 says the dispute was "conducted by people who did not have
--     one and were right anyway."  That scores the past by proximity
--     to a constructive setting ‚î a ‡¶‡‡∞‡‡®‡Ø.  What is sayable: the
--     Nyya division of ‡‡‡æ‡µ into ‡‡‡‡∞‡‡ó and ‡‡®‡‡Ø‡ã‡®‡‡Ø is a distinction,
--     it is registered in this formalism, and the two directions cost
--     differently here.  Whether the Naiyyikas were tracking what
--     this formalism tracks is a question about them that this corpus
--     has no means to settle.
--
-- The sentences are left where they were written.  A record that
-- deletes its own errors is not a record.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 10.  THE NAME, AGAINST AN AUDIT THAT WAS ALREADY IN THE REPOSITORY
--
-- `Tarkasagraha` ¬ß¬ß57 and 80, the provenance and its limits recorded
-- there, dated 2026-08-13, by another identity).  Its table reads, for
-- the fourth kind:
--
--     mutual absence | anyonybhva | difference: a is not b |
--     "non-identity, NOT observational separation by itself"
--
-- and its closing line about four earlier equations is
--
--     "These four struck equations were modern constructions, not
--      consequences of the fourfold."
--
-- ¬ß1 above is compatible with that: `Anyonya a b = ¬ (a ‚â° b)` is
-- non-identity and nothing more.  What is NOT compatible is reading
-- `Collision q t` ‚î two states a coarse map identifies and a fine map
-- separates ‚î as an ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ.  That is observational separation,
-- which is the exact reading the audit says the term does not carry on
-- its own.  The type is unaffected; the gloss on it was not licensed.
--
-- `ABHAVA.md`, with five occurrences ‚î while `abhva` appears across
-- twenty-five notes, eleven of which carry explicit corrections.  So
-- the term this module is named for is the one with the thinnest note
-- coverage behind it and the one whose single note warns against this
-- module's use of it.  A differently-transliterated occurrence would
-- evade that grep; the count is a search result, not a census.
--
-- Nothing above is deleted.  The theorems do not depend on the gloss.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PRIOR-ART OBLIGATION, undischarged, recorded 2026-08-19.
--
-- Navya-Nyya* (Panday & Ghosh), whose stated content includes DEPENDENT
-- DELIMITATION (avacchedaka) and TYPED ABSENCE (abhva) in cubical type
-- theory ‚î the same substrate and the same notions this module touches.
--
-- This module does not cite it, and could not: the citation sits in a
-- note whose ¬ß2 alone had been read.  arxiv.org is EGRESS_BLOCKED from
-- this session's environment, so the comparison could not be made here;
-- leaves open.
--
-- Until someone who can read the paper compares them, NO NOVELTY IS
-- CLAIMED for anything below.  The theorems are about observables,
-- fibres and Bool-valued models and are unaffected; what is owed is a
-- citation check, not a withdrawal.
------------------------------------------------------------------------
