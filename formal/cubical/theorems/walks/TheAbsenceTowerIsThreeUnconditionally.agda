{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheAbsenceTowerIsThreeUnconditionally
--
-- ààà¾àµ, and how tall it can get.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CLAIM
--
-- The absence hierarchy stabilises at three, and decidability of the
-- counterpositive does not set the level.  Nothing sets the level.  The
-- tower over any type is
-- three tall, unconditionally, with no hypothesis whatever â” and the
-- one thing a hypothesis can do is collapse it the rest of the way, in
-- a single step, to two.  There is no intermediate outcome to be set.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  Â Â Â A â‰ Â A, for every type A, with no hypothesis.  Not
--       "stabilises" as an implication â” an EQUIVALENCE, because Â A is
--       a proposition and the two implications are inverse by
--       propositionality.  So the tower
--
--           A ,  Â A ,  Â Â A ,  Â Â Â A , â¦
--
--       has at most three distinct entries, and the fourth IS the
--       second, on the nose after univalence.
--
--   Â§2  the collapse to two is EXACTLY stability: for a proposition A,
--       (A â‰ Â Â A) âŸº Stable A.  Both directions.  So the only question
--       a hypothesis can settle is three-or-two, and `Stable` settles
--       it.  `Decâ’Stable` is one-way, so decidability was never the
--       operative property; it was a sufficient condition for the one
--       that is.
--
--   Â§2b the dichotomy is not rhetoric.  `Â ((Â A) â‰ (Â Â A))` â” the
--       middle collapse is IMPOSSIBLE, for every A, with no hypothesis.
--       So three-or-two really is the whole of it: the second and third
--       entries can never merge, and the only merge available is the
--       one Â§2 characterises.
--
--   Â§3  and the consequence for absences stated as negations: Â§1 at
--       `Â A` gives `Â Â (Â A) â‰ Â A` outright, so such a statement is
--       already at the fixed point and can never be the top of a
--       three-tall tower.
--
--       HOW MUCH OF THIS CORPUS THAT COVERS IS A COUNT, NOT A LAW.  A
--       grep of `formal/cubical/NaturalMachine` on 2026-08-19: 396
--       modules, of which 235 have a `Â` somewhere in a top-level
--       signature and 20 mention `Â FactorsThrough`.  That is a count
--       produced by pattern-matching on text.  It is not a
--       classification of the corpus's obstructions, it does not
--       establish that the obstruction of any particular module has
--       negation form, and no claim below rests on it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE DICHOTOMY IS THE ONE ANEKNTA NAMES
--
-- Three unconditionally; two exactly when stable; nothing else.  That
-- is a collapse-dichotomy of the shape this thread has been carrying:
-- agreement â” here, A agreeing with its own double absence â” permits
-- the collapse, and plurality blocks it.  Â§2b is what makes this a
-- dichotomy rather than a manner of speaking: the agreement cannot be
-- approached by degrees, because the only other merge one could
-- imagine is refuted outright.
--
-- The four corners, taken seriously rather than gestured at.  Is the
-- tower collapsed?  ASSERTED â” Â§2, exactly when A is stable.  DENIED â”
-- Â§2 again, in the same breath, since it is an iff.  BOTH â” that would
-- need A â‰ Â Â A to hold and fail, which is âŠ.  NEITHER â” that would
-- need some third outcome, a merge somewhere else in the tower, and
-- Â§2b refutes the only candidate.  The catukoi is exhausted here,
-- which is worth saying because it usually is not.
--
-- AND THIS TOWER IS NOT THE SAPTABHAG.  The seven bhagas are not
-- iterated negations and reading them as one is a flattening this
-- module would make easy.  ààà¯à¾à¨àà¨à¾àààà¿ is an assertion in a respect,
-- not Â(ààà¯à¾à¦àààà¿); ààµà•àààµàà¯ is not ÂÂ anything; and the whole point of
-- the fourth bhaga is that it arises from SIMULTANEOUS assertion
-- (à¯àà—ààà), where every entry of the tower above is reached by
-- succession (à•àà°à®) â” one Â after another.  A structure that can only
-- iterate cannot express the simultaneous position.  Nothing in this
-- file is a model of saptabhag and it should not be cited as one.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- It is tempting to read Â§1 as answering the Naiyyika regress
-- objection to ààà‹à â” Uddyotakara's and Kumrila's charge that if "cow"
-- means not-non-cow then the exclusion needs a further exclusion and
-- the analysis never terminates.  Â§1 does show a regress terminating,
-- and terminating immediately.  It is not the same regress.
--
-- The objection is about MEANING: what a general term refers to, and
-- whether the account is circular because the excluded class must
-- already be given.  Â§1 is about the identity of two TYPES.  A regress
-- of definitions is not stopped by the observation that Â Â Â A and
-- Â A are equivalent, because the Naiyyika complaint is precisely that
-- you were not entitled to write the innermost A down.  So the two
-- schools' dispute stands untouched here.  What the theorem does is
-- remove ONE thing that could have been used on either side of it: no
-- new content is available by iterating exclusion, so nobody may claim
-- an unbounded hierarchy of exclusions as either resource or defect.
--
------------------------------------------------------------------------

module TheAbsenceTowerIsThreeUnconditionally where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; propBiimplâ†’Equiv ; invEq ; equivFun)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; Stable ; NonEmpty)
open import Cubical.Relation.Nullary.Properties using (isPropÂ¬ ; Decâ†’Stable)

open import FiniteInformation using (FactorsThrough)

private
  variable
    â„“ â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  The tower is three tall, with no hypothesis at all
------------------------------------------------------------------------

-- the two implications.  Only the first has any content, and it is one
-- application of the term to itself.
Â¬â†’Â¬Â¬Â¬ : {A : Type â„“} â†’ Â¬ A â†’ Â¬ Â¬ Â¬ A
Â¬â†’Â¬Â¬Â¬ na nna = nna na

Â¬Â¬Â¬â†’Â¬ : {A : Type â„“} â†’ Â¬ Â¬ Â¬ A â†’ Â¬ A
Â¬Â¬Â¬â†’Â¬ nnna a = nnna (Î» na â†’ na a)

-- and they are inverse, because both sides are propositions.  This is
-- the statement that the tower has a fixed point at height one, not
-- merely that it has one somewhere.
tripleNegationâ‰ƒ : (A : Type â„“) â†’ (Â¬ Â¬ Â¬ A) â‰ƒ (Â¬ A)
tripleNegationâ‰ƒ A =
  propBiimplâ†’Equiv (isPropÂ¬ (Â¬ Â¬ A)) (isPropÂ¬ A) Â¬Â¬Â¬â†’Â¬ Â¬â†’Â¬Â¬Â¬

-- so every higher entry is the second entry: nothing above Â Â A is new.
fourthâ‰¡second : (A : Type â„“) â†’ (Â¬ Â¬ Â¬ A) â‰ƒ (Â¬ A)
fourthâ‰¡second = tripleNegationâ‰ƒ

------------------------------------------------------------------------
-- 2.  The collapse from three to two is EXACTLY stability
------------------------------------------------------------------------

-- A proposition agrees with its own double absence exactly when it is
-- stable.  Nothing weaker will do and nothing stronger is needed.
stableâ†’doubleNegationâ‰ƒ :
  {A : Type â„“} â†’ isProp A â†’ Stable A â†’ A â‰ƒ (Â¬ Â¬ A)
stableâ†’doubleNegationâ‰ƒ pA st =
  propBiimplâ†’Equiv pA (isPropÂ¬ (Â¬ _)) (Î» a na â†’ na a) st

doubleNegationâ‰ƒâ†’stable :
  {A : Type â„“} â†’ A â‰ƒ (Â¬ Â¬ A) â†’ Stable A
doubleNegationâ‰ƒâ†’stable e = invEq e

------------------------------------------------------------------------
-- 2b.  The middle collapse is impossible, so three-or-two is the whole
--      of it.  No hypothesis: `Â A â‰ Â Â A` is refuted for every A.
--
--      The argument is short enough to read off the equivalence.  From
--      the forward map, any `na : Â A` yields `e na : Â Â A` and hence
--      `e na na : âŠ` â” so `Â A` is itself empty, i.e. `Â Â A` holds.
--      Transport that back along the equivalence to get a `Â A`, and
--      feed it to the emptiness just established.
------------------------------------------------------------------------

noMiddleCollapse : {A : Type â„“} â†’ Â¬ ((Â¬ A) â‰ƒ (Â¬ Â¬ A))
noMiddleCollapse e = nna (invEq e nna)
  where
    nna : Â¬ Â¬ _
    nna na = equivFun e na na

-- decidability is sufficient for the collapse and is not the property
-- that governs it.
decâ†’doubleNegationâ‰ƒ :
  {A : Type â„“} â†’ isProp A â†’ Dec A â†’ A â‰ƒ (Â¬ Â¬ A)
decâ†’doubleNegationâ‰ƒ pA d = stableâ†’doubleNegationâ‰ƒ pA (Decâ†’Stable d)

------------------------------------------------------------------------
-- 3.  Every absence in this corpus is already at the fixed point
--
-- The obstructions here are negations: `Â FactorsThrough q t`, the
-- collision lemmas, the refutation clauses of the witness-number
-- results.  Â§1 instantiated at `Â A` says the tower over ANY of them is
-- two tall â” its double absence is itself, by an equivalence.
--
-- Note what this does and does not deflate.  It does not say the
-- obstruction is weak; a `Â FactorsThrough` is exactly as strong as it
-- was.  It says there is no hierarchy of obstructions above it to be
-- appealed to, and therefore no room for barrier language that trades
-- on iterated absence.
------------------------------------------------------------------------

absenceIsItsOwnDoubleAbsence : (A : Type â„“) â†’ (Â¬ Â¬ (Â¬ A)) â‰ƒ (Â¬ A)
absenceIsItsOwnDoubleAbsence = tripleNegationâ‰ƒ

-- the corpus's own obstruction shape, with nothing assumed about it.
obstructionTowerIsTwoTall :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T)
  â†’ (Â¬ Â¬ (Â¬ FactorsThrough q t)) â‰ƒ (Â¬ FactorsThrough q t)
obstructionTowerIsTwoTall q t =
  absenceIsItsOwnDoubleAbsence (FactorsThrough q t)

-- and an obstruction is stable for free, which is the same fact said in
-- the vocabulary the price theorems use.
obstructionIsStable :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) â†’ Stable (Â¬ FactorsThrough q t)
obstructionIsStable q t = Â¬Â¬Â¬â†’Â¬

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
-- not a translation; neither "the tower" nor its height renders a
-- Sanskrit term.
------------------------------------------------------------------------
