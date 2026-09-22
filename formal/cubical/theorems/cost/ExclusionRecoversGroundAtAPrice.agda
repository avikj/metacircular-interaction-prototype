{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExclusionRecoversGroundAtAPrice
--
-- What a standpoint IS, when the only thing that can be said about it
-- is what it fails to distinguish.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TWO POSITIONS, AND THAT THEY ARE OPPOSED
--
-- This module is written across a live disagreement between two
-- schools, and the disagreement is the content.  Naming only one of
-- them, or drawing on both as if they were one box of instruments,
-- would take from each the part that converts and discard the dispute.
--
--   BUDDHIST (Dignga, Pramasamuccaya V; Dharmakrti, Pramavrttika
--   svrthnumna).  ‡‡‡ã‡ / ‡‡®‡‡Ø‡æ‡‡ã‡: a general term has no positive
--   referent.  "Cow" means not-non-cow.  A universal is an EXCLUSION,
--   and there is no further positive ground standing behind it.
--
--   NYYA‚ìVAIEIKA (Uddyotakara, Nyyavrttika; and from the Mms
--   side Kumrila, lokavrttika Apohavda).  The objection is
--   circularity, and it is put in the school's own technical terms: an
--   ‡‡‡æ‡µ is never bare.  Every absence carries a ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡, the
--   counterpositive ‚î the very thing whose absence it is ‚î and an
--   ‡‡µ‡‡‡‡‡¶‡ï delimiting it.  So "not-non-cow" already presupposes cow.
--   Exclusion cannot be the ground because exclusion needs a ground.
--
-- These are rivals.  The Naiyyika does not accept apoha; the Buddhist
-- does not accept the realist universal the pratiyogin is taken to be.
-- Nothing below settles that, and nothing below should be read as one
-- side winning.  What is proved is narrower and, exactly because it is
-- narrower, it is something both sides can be located against:
--
--     exclusion recovers ground, and the recovery has a PRICE,
--     and the price can be paid in either of two places.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE SETTING, WHICH IS ALREADY IN THIS CORPUS
--
-- A standpoint here is an observable `q : X ‚í Y` ‚î not an entry in an
-- enumeration of standpoints (that would assert the standpoints are
-- countable, which Sanmatitarka 1.28 denies), but a parameter.  Its
-- GROUND is the relation it identifies by,
--
--     Ground q x x'  =  q x ‚â° q x'
--
-- and its EXCLUSION is the negation of that,
--
--     Excludes q x x'  =  ¬ (q x ‚â° q x') .
--
-- `FiniteInformation` already proves that a target `t`
-- factors through `q` exactly when `t` is constant on the ground.  So
-- the ground is the whole of what the standpoint does ‚î and the
-- question apoha asks, in this corpus's vocabulary, is whether the
-- EXCLUSION is also the whole of it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß2  ground ‚ü exclusion, free.  If q' identifies everything q does,
--       then q excludes everything q' does.  No hypothesis.
--
--   ¬ß3  ground transfers factoring.  Co-identification carries
--       FiberConstant, hence (T a set) FactorsThrough.
--
--   ¬ß4  ground is EXACTLY what transfers ‚î the converse of ¬ß3, with no
--       counterexample needed and no classical principle: transfer for
--       every set-valued target is *equivalent* to co-identification.
--       Instantiate the target at `q` itself.
--
--   ¬ß5  PRICE, PAID AT THE COUNTERPOSITIVE.  Exclusion recovers ground
--       when `Ground q` is decidable.  ¬ß5 also says why this is NOT a
--       formalisation of the Naiyyika condition on ‡‡‡æ‡µ, which is a
--       condition on the specification of the absence and not on what
--       can be settled about it.
--
--   ¬ß6  PRICE, PAID AT THE TARGET.  Exclusion transfers factoring with
--       NO condition on Y at all, when the target T is discrete.  The
--       counterpositive may be wholly indeterminate; what is required
--       instead is that the thing being decoded can be READ.
--
--   ¬ß7  the two prices, and what each school gets to say about them.
--
------------------------------------------------------------------------

module ExclusionRecoversGroundAtAPrice where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬¨_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)

open import FiniteInformation
  using (FiberConstant ; FactorsThrough
        ; fiberConstant‚ÜífactorsThrough ; factorsThrough‚ÜífiberConstant)

private
  variable
    ‚Ñìx ‚Ñìy ‚Ñìy' ‚Ñìt : Level

------------------------------------------------------------------------
-- 1.  Ground and exclusion
------------------------------------------------------------------------

-- What the standpoint identifies by.
Ground : {X : Type ‚Ñìx} {Y : Type ‚Ñìy} ‚Üí (X ‚Üí Y) ‚Üí X ‚Üí X ‚Üí Type ‚Ñìy
Ground q x x' = q x ‚â° q x'

-- What it keeps apart.  The absence is not bare: its counterpositive is
-- written into it, as the path type `q x ‚â° q x'`.
Excludes : {X : Type ‚Ñìx} {Y : Type ‚Ñìy} ‚Üí (X ‚Üí Y) ‚Üí X ‚Üí X ‚Üí Type ‚Ñìy
Excludes q x x' = ¬¨ (Ground q x x')

-- q' identifies at least as much as q does.
CoIdentify : {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'}
           ‚Üí (X ‚Üí Y) ‚Üí (X ‚Üí Y') ‚Üí Type (‚Ñì-max ‚Ñìx (‚Ñì-max ‚Ñìy ‚Ñìy'))
CoIdentify {X = X} q q' = (x x' : X) ‚Üí Ground q x x' ‚Üí Ground q' x x'

-- q' excludes at least as much as q does.
CoExclude : {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'}
          ‚Üí (X ‚Üí Y) ‚Üí (X ‚Üí Y') ‚Üí Type (‚Ñì-max ‚Ñìx (‚Ñì-max ‚Ñìy ‚Ñìy'))
CoExclude {X = X} q q' = (x x' : X) ‚Üí Excludes q x x' ‚Üí Excludes q' x x'

------------------------------------------------------------------------
-- 2.  Ground determines exclusion, free
--
-- Contraposition, nothing more.  Note the direction reverses: it is
-- q' identifying MORE that makes q exclude more.
------------------------------------------------------------------------

coIdentify‚ÜícoExclude :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} (q : X ‚Üí Y) (q' : X ‚Üí Y')
  ‚Üí CoIdentify q' q ‚Üí CoExclude q q'
coIdentify‚ÜícoExclude q q' h x x' nq g' = nq (h x x' g')

------------------------------------------------------------------------
-- 3.  Ground transfers factoring
------------------------------------------------------------------------

fiberConstant-transfer :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí CoIdentify q' q ‚Üí FiberConstant q t ‚Üí FiberConstant q' t
fiberConstant-transfer q q' t h fc x x' g' = fc x x' (h x x' g')

factorsThrough-transfer :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (isSetT : isSet T) (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí CoIdentify q' q ‚Üí FactorsThrough q t ‚Üí FactorsThrough q' t
factorsThrough-transfer isSetT q q' t h ft =
  fiberConstant‚ÜífactorsThrough isSetT q' t
    (fiberConstant-transfer q q' t h (factorsThrough‚ÜífiberConstant q t ft))

------------------------------------------------------------------------
-- 4.  Ground is EXACTLY what transfers
--
-- The converse of ¬ß3, and the reason no counterexample is needed
-- anywhere in this module.  If transfer holds for every set-valued
-- target, take the target to be `q` itself ‚î for which fiber constancy
-- is `refl` ‚î and read off co-identification.
--
-- So a standpoint's ground is not merely sufficient for what it lets
-- descend: it is recoverable from it.  Two standpoints let exactly the
-- same targets descend iff they identify exactly the same states.
------------------------------------------------------------------------

TransfersAllTargets :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'}
  ‚Üí (X ‚Üí Y) ‚Üí (X ‚Üí Y') ‚Üí Type (‚Ñì-max (‚Ñì-max ‚Ñìx (‚Ñì-suc ‚Ñìy)) ‚Ñìy')
TransfersAllTargets {‚Ñìy = ‚Ñìy} {X = X} q q' =
  (T : Type ‚Ñìy) ‚Üí isSet T ‚Üí (t : X ‚Üí T)
  ‚Üí FiberConstant q t ‚Üí FiberConstant q' t

transferAll‚ÜícoIdentify :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} (q : X ‚Üí Y) (q' : X ‚Üí Y')
  ‚Üí isSet Y ‚Üí TransfersAllTargets q q' ‚Üí CoIdentify q' q
transferAll‚ÜícoIdentify q q' isSetY tr = tr _ isSetY q (Œª _ _ p ‚Üí p)

coIdentify‚ÜítransferAll :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} (q : X ‚Üí Y) (q' : X ‚Üí Y')
  ‚Üí CoIdentify q' q ‚Üí TransfersAllTargets q q'
coIdentify‚ÜítransferAll q q' h T _ t fc = fiberConstant-transfer q q' t h fc

------------------------------------------------------------------------
-- 5.  The price, paid at the counterpositive
--
-- Exclusion recovers ground exactly when the ground is decidable ‚î i.e.
-- when, of every pair, it is settled whether the standpoint identifies
-- them.  The hypothesis is on `q` ‚î the standpoint whose ground is
-- being RECOVERED ‚î and without it the implication is not available in
-- this type theory.
--
-- ¬ß5 does not formalise the pratiyogin requirement.  It occupies the
-- same position in the argument ‚î the point where reasoning from an
-- absence needs something more than the absence itself ‚î and the two
-- schools' dispute is over whether anything belongs there at all.
------------------------------------------------------------------------

coExclude‚ÜícoIdentify :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} (q : X ‚Üí Y) (q' : X ‚Üí Y')
  ‚Üí ((x x' : X) ‚Üí Dec (Ground q x x'))
  ‚Üí CoExclude q q' ‚Üí CoIdentify q' q
coExclude‚ÜícoIdentify q q' dec ce x x' g' with dec x x'
... | yes p = p
... | no  n = ‚ä•.rec (ce x x' n g')

-- and then ¬ß3 applies unchanged.
factorsThrough-transfer-from-exclusion :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (isSetT : isSet T) (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí ((x x' : X) ‚Üí Dec (Ground q x x'))
  ‚Üí CoExclude q q' ‚Üí FactorsThrough q t ‚Üí FactorsThrough q' t
factorsThrough-transfer-from-exclusion isSetT q q' t dec ce =
  factorsThrough-transfer isSetT q q' t (coExclude‚ÜícoIdentify q q' dec ce)

------------------------------------------------------------------------
-- 6.  The price, paid at the target instead
--
-- The counterpositive may be wholly indeterminate ‚î no decidability on
-- Y or Y' anywhere ‚î and exclusion still transfers factoring, provided
-- the TARGET is discrete.
--
-- The proof is the whole point: to show `t x ‚â° t x'`, decide it in T.
-- If it fails, then `q` cannot identify x and x' either (fiber
-- constancy would have forced the equality), so co-exclusion says `q'`
-- does not identify them, contradicting the hypothesis.  The decision
-- that ¬ß5 demanded of the ground is manufactured, for the one pair that
-- matters, out of a decision about what is being read.
--
-- This is the corpus's own ceiling condition ‚î a decoder needs a
-- discrete probe to read ‚î arriving here as the price of an apoha step.
------------------------------------------------------------------------

fiberConstant-transfer-discreteTarget :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (discT : Discrete T) (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí CoExclude q q' ‚Üí FiberConstant q t ‚Üí FiberConstant q' t
fiberConstant-transfer-discreteTarget discT q q' t ce fc x x' g'
  with discT (t x) (t x')
... | yes p = p
... | no  n = ‚ä•.rec (ce x x' (Œª g ‚Üí n (fc x x' g)) g')

-- REDUNDANT HYPOTHESIS, recorded rather than removed: `isSet T` here is
-- derivable from `Discrete T` by `Discrete‚íisSet`.  The lean form is
-- `HypothesesAssumedWhereTheyAreDerivable`
-- `factorsThrough-transfer-discreteTarget‚≤`.  This statement is kept
-- because it is true and because importers depend on it; it is simply
-- weaker than it needed to be.
factorsThrough-transfer-discreteTarget :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (isSetT : isSet T) (discT : Discrete T)
  (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí CoExclude q q' ‚Üí FactorsThrough q t ‚Üí FactorsThrough q' t
factorsThrough-transfer-discreteTarget isSetT discT q q' t ce ft =
  fiberConstant‚ÜífactorsThrough isSetT q' t
    (fiberConstant-transfer-discreteTarget discT q q' t ce
      (factorsThrough‚ÜífiberConstant q t ft))

------------------------------------------------------------------------
-- 7.  What each school gets to say
--
-- ¬ß2 is free and ¬ß5‚ì¬ß6 are priced.  That asymmetry is the whole result,
-- and it is not a verdict on the dispute; it is a place to stand while
-- reading it.
--
-- The Naiyyika reading of ¬ß5. The recovery of the positive ground from the
-- exclusions is not free: something must be supplied at the absence before it
-- will argue. Nothing here shows the ground is dispensable, and ¬ß4 sharpens
-- the realist side: the ground is not one description among several, it is
-- recoverable from the descent behaviour itself.
--
--   The Buddhist reading of ¬ß6.  The condition in ¬ß5 was never the only
--   one available.  ¬ß6 pays nothing at the counterpositive ‚î the
--   identification relation on Y may be as undecidable as one likes ‚î
--   and still gets every discrete target to descend.  For anything that
--   can actually be READ, the exclusions suffice: no positive ground is
--   supplied, appealed to, or reconstructed anywhere in that proof.
--   Whether ‡‡®‡‡Ø‡æ‡‡ã‡ asserted this, more than this, or something the
--   present setting cannot state is not decided here ‚î the texts are
--   arguing about universals and reference, and ¬ß6 is a statement about
--   observables.
--
--   What neither gets.  ¬ß4 says co-identification is EXACTLY transfer
--   for all set targets; ¬ß6 gives transfer only for DISCRETE ones.  So
--   the exclusions determine the standpoint on the readable part and
--   are, on this evidence, silent beyond it.  Whether that residue is a
--   real object or an artefact of the formulation is not settled by
--   anything in this file, and stating it as settled in either
--   direction would be a ‡¶‡‡∞‡‡®‡Ø ‚î a standpoint asserting itself by
--   denying the other.
--
--   The syd form, stated with the bhaga named correctly, since this
--   corpus has already proved that the two are not interchangeable
--   (`SaptabhangiNaya` ‚î the top-level module, whose `yugapat-empty`
--   proves `¬ Œ[ n ] (P n ó ¬ P n)` and whose `krama‚íyugapat-fails`
--   proves `¬ (Krama ‚í Yugapat)`; the citation in an earlier draft of
--   this file named a `` module that does not exist and
--   summarised it as "krama ‚â† sah", which is not what is proved
--   there):
--
--     ‡‡‡Ø‡æ‡¶‡‡‡‡ø ‚î in the respect of discrete targets, exclusion is
--                 ground (¬ß6);
--     ‡‡‡Ø‡æ‡®‡‡®‡æ‡‡‡‡ø ‚î in the respect of arbitrary set targets, it is not
--                 shown to be (¬ß4 characterises transfer by ground
--                 alone, and ¬ß6 does not reach that far);
--     and asserting these two IN SUCCESSION, which is what the two
--     lines above do, is ‡ï‡‡∞‡Æ ‚î the third bhaga.  It is not ‡Ø‡‡ó‡‡‡.
--
--   The ‡Ø‡‡ó‡‡‡ position would be a single assertion, not indexed to a
--   respect, holding both at once; in this setting that is precisely a
--   target that no one decoder expresses, i.e. a `¬ FactorsThrough`.
--   This file does not construct one.  Saying "the two respects differ"
--   is the successive reading wearing the simultaneous one's name, and
--   the fourth bhaga is not delivered by relabelling the third.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  The price named exactly: it is stability, and it is NECESSARY
--
-- ¬ß5 bought the recovery with decidability of the ground.  That was too
-- much, and ‚î worse for a module whose subject is what an absence can
-- be argued from ‚î it was the wrong shape.  What the proof of ¬ß5 used
-- was only this: from `¬ ¬ (q x ‚â° q x')` conclude `q x ‚â° q x'`.  That
-- is `Stable`, and `Dec‚íStable` shows ¬ß5 is a corollary.
--
-- ¬ß8b then shows stability is not merely sufficient but NECESSARY, with
-- no counterexample, no classical principle and no undecidable
-- proposition assumed.  The witness is built from `q` itself.
--
--     Given q : Bool ‚í Y, put A := ¬ (q true ‚â° q false) ‚î the exclusion
--     of the one pair that can be excluded ‚î and define the SHADOW
--
--         shadow q : Bool ‚í (A ‚í Y)     shadow q b = Œª _ ‚í q b .
--
--     By funext, `Ground (shadow q) true false` is `A ‚í Ground q true
--     false`: the shadow identifies exactly when the exclusion would
--     force the identification.  The shadow co-excludes with q (¬ß8b,
--     `coExclude-shadow`) ‚î on the diagonal vacuously, off it because
--     an inhabitant of A refutes any `A ‚í Ground q`.
--
--     So if co-exclusion gave co-identification unpriced, we would have
--     `(¬ G ‚í G) ‚í G`, and that is interderivable with `¬ ¬ G ‚í G`
--     (¬ß8b, both directions).  The unpriced implication IS stability.
--
-- Read against ¬ß7: the Naiyyika insistence that an absence does not
-- argue by itself is not answered by making the counterpositive
-- decidable ‚î nothing here needs that ‚î and the Buddhist ¬ß6 route does
-- not touch this at all, since it never recovers the ground.  What is
-- exhibited is the exact quantity that separates the two routes.
--
-- ONE THING THE CONSTRUCTION ASSUMES, AND WHICH IS DISPUTED.  `shadow`
-- uses `Excl` as a DOMAIN: it forms functions out of an absence.  That
-- is available here because in this type theory `¬ G` is a type like
-- any other.  It is not neutral ground.  Vaieika counts ‡‡‡æ‡µ among
-- the ‡‡¶‡æ‡∞‡‡s ‚î absence is a category of the real, with its own
-- perceptual ‡Æ‡æ‡® ‚î while the Buddhist position denies there is any such
-- entity, absence being at most a construction of thought.  The type
-- theory sides with neither by argument; it simply builds the object,
-- and ¬ß8b shows that once you may quantify over an absence you can
-- extract from it exactly the stability that reasoning from absences
-- was going to need.  A reader who rejects the first step is entitled
-- to reject ¬ß8b, and should say so at the step rather than at the
-- theorem.
------------------------------------------------------------------------

open import Cubical.Relation.Nullary.Properties using (Dec‚ÜíStable)
open import Cubical.Relation.Nullary using (Stable)
open import Cubical.Data.Bool using (Bool ; true ; false)

-- 8a.  Sufficiency, with the hypothesis weakened from Dec to Stable.

coExclude‚ÜícoIdentify-stable :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} (q : X ‚Üí Y) (q' : X ‚Üí Y')
  ‚Üí ((x x' : X) ‚Üí Stable (Ground q x x'))
  ‚Üí CoExclude q q' ‚Üí CoIdentify q' q
coExclude‚ÜícoIdentify-stable q q' st ce x x' g' =
  st x x' (Œª n ‚Üí ce x x' n g')

-- and ¬ß5 is now a corollary, not an independent statement.
coExclude‚ÜícoIdentify-fromDec :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} (q : X ‚Üí Y) (q' : X ‚Üí Y')
  ‚Üí ((x x' : X) ‚Üí Dec (Ground q x x'))
  ‚Üí CoExclude q q' ‚Üí CoIdentify q' q
coExclude‚ÜícoIdentify-fromDec q q' dec =
  coExclude‚ÜícoIdentify-stable q q' (Œª x x' ‚Üí Dec‚ÜíStable (dec x x'))

-- 8b.  Necessity.  The shadow of an observable on two states.

module _ {Y : Type ‚Ñìy} (q : Bool ‚Üí Y) where

  Excl : Type ‚Ñìy
  Excl = Excludes q true false

  shadow : Bool ‚Üí (Excl ‚Üí Y)
  shadow b = Œª _ ‚Üí q b

  -- The shadow identifies a pair exactly when the exclusion of the
  -- distinguishable pair would force that identification.
  shadowGround‚Üí : (x x' : Bool)
                ‚Üí Ground shadow x x' ‚Üí (Excl ‚Üí Ground q x x')
  shadowGround‚Üí x x' p a i = p i a

  shadowGround‚Üê : (x x' : Bool)
                ‚Üí (Excl ‚Üí Ground q x x') ‚Üí Ground shadow x x'
  shadowGround‚Üê x x' f i a = f a i

  -- Co-exclusion holds outright: no hypothesis on Y, none on q.  On the
  -- diagonal the hypothesis is already absurd; off it, the hypothesis IS
  -- the exclusion the shadow is built from (up to `sym`).
  coExclude-shadow : CoExclude q shadow
  coExclude-shadow true  true  n p = ‚ä•.rec (n refl)
  coExclude-shadow false false n p = ‚ä•.rec (n refl)
  coExclude-shadow true  false n p = n (shadowGround‚Üí true false p n)
  coExclude-shadow false true  n p =
    n (shadowGround‚Üí false true p (Œª g ‚Üí n (sym g)))

  -- Hence the unpriced implication delivers exactly stability ‚¶
  shadowCoIdentify‚Üístable :
    CoIdentify shadow q ‚Üí Stable (Ground q true false)
  shadowCoIdentify‚Üístable ci nn =
    ci true false (shadowGround‚Üê true false (Œª a ‚Üí ‚ä•.rec (nn a)))

  -- ‚¶ and stability delivers it back, so the two are interderivable.
  stable‚ÜíshadowCoIdentify :
    ((x x' : Bool) ‚Üí Stable (Ground q x x')) ‚Üí CoIdentify shadow q
  stable‚ÜíshadowCoIdentify st =
    coExclude‚ÜícoIdentify-stable q shadow st coExclude-shadow

------------------------------------------------------------------------
-- 9.  The other price is the SAME price
--
-- ¬ß6 bought transfer at the target with `Discrete T`.  ¬ß8 showed the
-- price at the counterpositive was `Stable`, not `Dec`.  The same
-- correction applies here, and the consequence is not bookkeeping.
--
--   9a  ¬ß6 needs only that PATHS IN THE TARGET BE STABLE ‚î pointwise,
--       for the pairs actually compared.  `Discrete‚íSeparated` makes ¬ß6
--       a corollary.
--
--   9b  and stability of the target is NECESSARY, by the same shadow,
--       with the observable taken to be the target itself.  Put
--       `q := t`.  Then `FiberConstant t t` is the identity, and
--       transfer along `shadow t` says exactly `(¬ G ‚í G) ‚í G` for
--       `G = (t true ‚â° t false)`.
--
-- So the two prices of this module are ONE PROPERTY AT TWO OBJECTS:
--
--       recover the ground        ‚î  Stable (paths in the observable)
--       transfer without it       ‚î  Stable (paths in the target)
--
-- and neither is decidability.  That is what live thread (1) ‚î
-- transport PRICE, not possibility ‚î asks for at this site: the
-- transport between the two nayas is always available, and what it
-- costs is one double-negation elimination, charged either to what is
-- being observed or to what is being read.
--
-- SAYING THIS CAREFULLY, BECAUSE THE CARELESS VERSION IS A COLLAPSE.
-- "One quantity in two locations" would assert that the two
-- hypotheses are the same thing, and aneknta is precise about when
-- that move is licensed: a collapse exists iff every pair agrees, and
-- plurality is one way to fail that (887641a7).  Here there is plurality.  `Stable` applied to the ground of `q`
-- and `Stable` applied to the paths of `t` are two different
-- hypotheses about two different objects; a target can be separated
-- while the observable is not, and nothing in this file derives either
-- from the other.  What recurs is the SHAPE ‚î the same schema, and the
-- same shadow refuting the unpriced form of each.  A price with an
-- own-nature, one object appearing twice, is not what was found; a
-- pattern that recurs is.
--
-- IT ALSO DEFLATES SOMETHING.  Thread (2), the deflationary test, says:
-- if every absence in this corpus is decidable then nothing here lives
-- above the second level and the barrier language is stronger than the
-- objects warrant.  ¬ß8‚ì¬ß9 sharpen the test rather than answering it.
-- The relevant hypothesis is not decidability but stability, which is
-- strictly weaker, so the level is set lower than the test assumed ‚î
-- and `Stable` is exactly the property under which an absence and its
-- counterpositive collapse into each other.  A corpus whose absences
-- are all stable has no third level, whether or not they are decidable.
------------------------------------------------------------------------

open import Cubical.Relation.Nullary.Properties using (Discrete‚ÜíSeparated)

-- 9a.  Sufficiency, with `Discrete` weakened to pointwise stability.

fiberConstant-transfer-stableTarget :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí ((x x' : X) ‚Üí Stable (t x ‚â° t x'))
  ‚Üí CoExclude q q' ‚Üí FiberConstant q t ‚Üí FiberConstant q' t
fiberConstant-transfer-stableTarget q q' t st ce fc x x' g' =
  st x x' (Œª n ‚Üí ce x x' (Œª g ‚Üí n (fc x x' g)) g')

-- ¬ß6 is a corollary: a discrete type is separated.
fiberConstant-transfer-fromDiscrete :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (discT : Discrete T) (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí CoExclude q q' ‚Üí FiberConstant q t ‚Üí FiberConstant q' t
fiberConstant-transfer-fromDiscrete discT q q' t =
  fiberConstant-transfer-stableTarget q q' t
    (Œª x x' ‚Üí Discrete‚ÜíSeparated discT (t x) (t x'))

factorsThrough-transfer-stableTarget :
  {X : Type ‚Ñìx} {Y : Type ‚Ñìy} {Y' : Type ‚Ñìy'} {T : Type ‚Ñìt}
  (isSetT : isSet T) (q : X ‚Üí Y) (q' : X ‚Üí Y') (t : X ‚Üí T)
  ‚Üí ((x x' : X) ‚Üí Stable (t x ‚â° t x'))
  ‚Üí CoExclude q q' ‚Üí FactorsThrough q t ‚Üí FactorsThrough q' t
factorsThrough-transfer-stableTarget isSetT q q' t st ce ft =
  fiberConstant‚ÜífactorsThrough isSetT q' t
    (fiberConstant-transfer-stableTarget q q' t st ce
      (factorsThrough‚ÜífiberConstant q t ft))

-- 9b.  Necessity, by the shadow of the target on itself.

module _ {T : Type ‚Ñìt} (t : Bool ‚Üí T) where

  -- fiber constancy of a map along ITSELF is the identity
  selfFiberConstant : FiberConstant t t
  selfFiberConstant _ _ p = p

  -- so transfer along `shadow t` is exactly the stability of the one
  -- path the two states can disagree on.
  shadowTransfer‚ÜístableTarget :
    (FiberConstant t t ‚Üí FiberConstant (shadow t) t)
    ‚Üí Stable (t true ‚â° t false)
  shadowTransfer‚ÜístableTarget tr nn =
    tr selfFiberConstant true false
       (shadowGround‚Üê t true false (Œª a ‚Üí ‚ä•.rec (nn a)))

  stableTarget‚ÜíshadowTransfer :
    ((x x' : Bool) ‚Üí Stable (t x ‚â° t x'))
    ‚Üí FiberConstant t t ‚Üí FiberConstant (shadow t) t
  stableTarget‚ÜíshadowTransfer st =
    fiberConstant-transfer-stableTarget t (shadow t) t st (coExclude-shadow t)

------------------------------------------------------------------------
-- 11.  THE APOHA GLOSS IS DEFEATED BY A NOTE THAT WAS ALREADY HERE.
--
-- written, states the finding:
--
--     "Apoha is not Boolean complementation.  The popular gloss is
--      double negation ‚î 'cow' = not-(non-cow) ‚î and that gloss is what
--      Dignga's own scope analysis DEFEATS: a Boolean complement is
--      taken in a fixed universe with a fixed partition, and
--      Pramasamuccaya V.25cd‚ì38 says the exclusion class varies with
--      the term's position in a taxonomy."
--
-- `Excludes q x x' = ¬ (q x ‚â° q x')` is a negation in a fixed universe
-- with a fixed partition ‚î `Y` is given, `q` is given, the partition is
-- the fibres of `q`.  It is the defeated gloss, exactly.
------------------------------------------------------------------------
