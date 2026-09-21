{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhereTheTowerCanStillBeThree
--
-- The other half of the deflationary test, and the one place it does
-- not go through.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AFFIRMATIONS
--
-- `TheAbsenceTowerIsThreeUnconditionally` settles the
-- absence side outright: every statement of the form `Â A` is stable
-- for free, so no obstruction written as a negation can sit at the top
-- of a three-tall tower.  What that leaves is the AFFIRMATIONS â” is
-- `FactorsThrough q t` itself stable, is answerability, are the
-- witness-number statements?  A survey would answer that badly.  There
-- is a theorem instead, and it separates the corpus's own two
-- quantities cleanly.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  stability is closed under Î , pointwise.  Three lines, no
--       hypothesis on the index type.
--
--   Â§2  hence `FiberConstant q t` â” a Î â whose conclusion is a path in
--       T â” is stable as soon as paths in T are, pointwise on the
--       pairs compared.
--
--   Â§3  and `FactorsThrough q t` is stable under the same hypothesis
--       plus `isSet T`, by transporting Â§2 along the corpus's own
--       equivalence.  Stability transports along any logical
--       equivalence; no univalence is needed for this step and none is
--       used.
--
--   Â§4  so under exactly the hypothesis Â§9 of `ExclusionRecovers-
--       GroundAtAPrice` already charges â” stable paths in the target â”
--       BOTH `FactorsThrough q t` and its negation are stable, and the
--       tower over the corpus's central affirmation is two tall.  That
--       is the deflationary conclusion, proved for this shape rather
--       than surveyed.
--
--   Â§5  and the place it stops.  `Answerable law = (x : X) â’ Î[ d ] law
--       d x` is a Î  OVER A Î.  Â§1 carries the Î ; the Î is where the
--       argument ends, because `Â Â (Î â¦)` hands back no element.  Â§5
--       gives the positive replacement: a decidable Î is stable, so the
--       floor's stability is exactly a SEARCH question, and the ceiling
--       and the floor of this corpus part company here for a reason
--       that is not about either of them being harder.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- SAID WITH ITS RESPECT, BECAUSE Â§5 IS EASY TO OVERSTATE
--
--   ààà¯à¾àà â” in the respect of Î -shaped statements with stable
--            conclusions, the tower is two tall (Â§1â“Â§4);
--   ààà¯à¾àà â” in the respect of Î-shaped statements, this file
--            establishes nothing either way (Â§5).
--
-- The second is an absence of proof and not a proof of absence â” no
-- Î is shown unstable anywhere below, and it would be a à¦àà°àà¨à¯ to
-- report Â§5 as "the floor is unstable".  What Â§5 shows is where the
-- argument stops, which is a different object from where the property
-- fails.  Naming the stopping place is the content; Â§5's decidability
-- clause says what would move it.  The four corners are not taken for
-- the Î case, and saying so is the honest report: this file asserts
-- neither that Î-statements are stable nor that they are not, and does
-- not reach the further two corners at all.
--
-- AND Â§5 IS NOT ABOUT SHAPE, WHICH THIS FILE ITSELF PROVES.  `Stable-â”`
-- (Â§1) says stability transports along a bare logical equivalence â” no
-- univalence, no h-level, nothing about how the statement is written.
-- So a Î-shaped statement logically equivalent to a Î -shaped one with
-- stable conclusion IS stable, and reading Â§5 as "Î-statements are the
-- unstable ones" is refuted twelve lines above it.  Â§5 locates a
-- stopping point of one argument, and the argument is about the route,
-- not about the object.
--
-- That contrast is worth recording against the laghava thread, which
-- has been holding that cost is not a univalent invariant â” it lives on
-- the presentation, which univalence discards.  Stability is the other
-- kind of thing: it does not live on the presentation at all, and
-- `Stable-â”` is the proof.  Two quantities this corpus has been
-- treating side by side turn out to sit on opposite sides of exactly
-- that line.
--
-- AND NOT A SAPTABHAG.  Two syt clauses in succession are à•àà°à®, the
-- third bhaga.  The simultaneous position is not delivered here and is
-- not gestured at: in this corpus that position is a Â FactorsThrough,
-- an obstruction to any single decoder, and no such object is
-- constructed below.
--
------------------------------------------------------------------------

module WhereTheTowerCanStillBeThree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Stable)
open import Cubical.Relation.Nullary.Properties using (Decâ†’Stable)

open import FiniteInformation
  using (FiberConstant ; FactorsThrough
        ; fiberConstantâ†’factorsThrough ; factorsThroughâ†’fiberConstant)

private
  variable
    â„“ â„“' â„“d â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  Stability is closed under Î , and transports along â”
------------------------------------------------------------------------

StableÎ  : {A : Type â„“} {B : A â†’ Type â„“'}
        â†’ ((a : A) â†’ Stable (B a)) â†’ Stable ((a : A) â†’ B a)
StableÎ  st nn a = st a (Î» nb â†’ nn (Î» f â†’ nb (f a)))

-- stability is a property of a type up to logical equivalence only; no
-- univalence, no h-level hypothesis.
Stable-â†” : {A : Type â„“} {B : Type â„“'}
         â†’ (A â†’ B) â†’ (B â†’ A) â†’ Stable A â†’ Stable B
Stable-â†” f g st nnb = f (st (Î» na â†’ nnb (Î» b â†’ na (g b))))

------------------------------------------------------------------------
-- 2.  Fiber constancy is stable when the target's paths are
------------------------------------------------------------------------

stableFiberConstant :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T)
  â†’ ((x x' : X) â†’ Stable (t x â‰¡ t x'))
  â†’ Stable (FiberConstant q t)
stableFiberConstant q t st =
  StableÎ  (Î» x â†’ StableÎ  (Î» x' â†’ StableÎ  (Î» _ â†’ st x x')))

------------------------------------------------------------------------
-- 3.  Hence so is factoring
------------------------------------------------------------------------

stableFactorsThrough :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (isSetT : isSet T) (q : X â†’ Y) (t : X â†’ T)
  â†’ ((x x' : X) â†’ Stable (t x â‰¡ t x'))
  â†’ Stable (FactorsThrough q t)
stableFactorsThrough isSetT q t st =
  Stable-â†” (fiberConstantâ†’factorsThrough isSetT q t)
           (factorsThroughâ†’fiberConstant q t)
           (stableFiberConstant q t st)

------------------------------------------------------------------------
-- 4.  Both sides stable, so the tower over factoring is two tall
--
-- `Â FactorsThrough q t` was already stable for free (the absence-tower
-- module).  Â§3 gives the affirmation under the readability hypothesis
-- that Â§9 of `ExclusionRecoversGroundAtAPrice` charges anyway.  So on
-- the corpus's central shape, under the corpus's own working
-- hypothesis, there is nothing at the third level on either side.
------------------------------------------------------------------------

bothSidesStable :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (isSetT : isSet T) (q : X â†’ Y) (t : X â†’ T)
  â†’ ((x x' : X) â†’ Stable (t x â‰¡ t x'))
  â†’ Stable (FactorsThrough q t) Ã— Stable (Â¬ FactorsThrough q t)
bothSidesStable isSetT q t st =
  stableFactorsThrough isSetT q t st , Î» nnn a â†’ nnn (Î» n â†’ n a)

------------------------------------------------------------------------
-- 5.  Where the argument stops: the Î
--
-- `Answerable law = (x : X) â’ Î[ d âˆˆ D ] law d x`.  Â§1 carries the
-- outer Î  without cost.  The inner Î is a different matter: from
-- `Â Â (Î[ d ] P d)` there is no way to produce a `d`, and that is not
-- a gap in the proof but the reason the proof has no next line.
--
-- The positive replacement is exact.  A DECIDABLE Î is stable â” so the
-- question of whether the floor of this corpus admits a three-tall
-- tower is precisely the question of whether the witness can be found,
-- not a question about absence at all.  That is where the ceiling and
-- the floor part company: the ceiling is a Î  into paths and stability
-- is free once the target is readable; the floor is a search.
------------------------------------------------------------------------

-- the outer Î  of `Answerable` costs nothing, whatever the Î does.
stableAnswerable-fromPointwise :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ ((x : X) â†’ Stable (Î£[ d âˆˆ D ] law d x))
  â†’ Stable ((x : X) â†’ Î£[ d âˆˆ D ] law d x)
stableAnswerable-fromPointwise law st = StableÎ  st

-- and a decidable search is stable, which is the only general way in.
stableÎ£-fromDec :
  {D : Type â„“d} {P : D â†’ Type â„“}
  â†’ Dec (Î£[ d âˆˆ D ] P d) â†’ Stable (Î£[ d âˆˆ D ] P d)
stableÎ£-fromDec = Decâ†’Stable

stableAnswerable-fromDecidableSearch :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ ((x : X) â†’ Dec (Î£[ d âˆˆ D ] law d x))
  â†’ Stable ((x : X) â†’ Î£[ d âˆˆ D ] law d x)
stableAnswerable-fromDecidableSearch law dec =
  StableÎ  (Î» x â†’ Decâ†’Stable (dec x))

------------------------------------------------------------------------
-- ON THIS MODULE'S NAME â” "tower", "three" â” WHICH TRANSLATE NOTHING.
--
-- No source in this corpus's lineage states an absence hierarchy
-- measured by iteration depth.  The Nyyaâ“Vaieika classification of
-- ààà¾àµ is fourfold and sorts absences by KIND â” prgabhva,
-- pradhvasbhva, atyantbhva, anyonybhva â” that is, by the
-- temporal and relational career of what is absent, not by how many
-- table with a primary-text audit (`Tarkasagraha` Â§Â§57, 80).
--
-- "The absence tower is three tall" is a statement about iterated `Â`
-- in a constructive type theory.  It is mine, it is proved, and it is
-- not a translation.  Naming the module after it, in a thread whose
-- whole discipline is to prefer the earliest statement over a later
-- restatement, dressed an imported notion in the tradition's clothes â”
-- equations for, one step further along: those at least mapped onto the
-- fourfold before being withdrawn.
--
-- The mathematics below is untouched by this.  What is withdrawn is any
-- suggestion that "the tower" or its height renders a  term.
------------------------------------------------------------------------
