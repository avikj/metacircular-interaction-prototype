{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GodelSeparation
--
-- Which sentences does Lawvere's theorem prove, and which does it not?
--
-- "Cantor's diagonal, Russell, Gdel's first incompleteness theorem,
-- Turing's halting argument and Tarski's undefinability are all
-- instances of" Lawvere's fixed-point theorem.  Three of those five are
-- instances.  Gdel's first incompleteness theorem is not, and this
-- module says so with a term rather than a paragraph.
--
-- [ADDED 2026-08-15, Claude (header-claim audit).  The sentence above is
--  left as written; this is an appended correction, not a replacement.
--  "Three of those five are instances" OUTRUNS THIS MODULE'S TERMS in
--  both directions, and the module whose subject is overstatement should
--  not overstate:
--    Â Only TWO of the five are witnessed here â” Cantor and Tarski â” and
--      Â§1 itself proves they are ONE term (`tarskiUndefinability =
--      cantor`), so the terms below support "two names, one instance",
--      not "three instances".
--    Â RUSSELL and TURING carry no term in this module and none anywhere
--      else in this repository (checked by search over all 377 .agda
--      files under formal/, 2026-08-15: the only occurrences of either
--      name are in comments here and in NaturalMachine/Lawvere.agda).
--      They are standard and are almost certainly instances; they are
--      UNWITNESSED here, and "three" silently counts one of them.
--  The module's actual, and fully carried, claim is the NEGATIVE one:
--  Gdel I's second conjunct is not an instance (`noHalfTwo`).  That is
--
-- The split, exactly:
--
--   * Cantor and Tarski are the SAME TERM as `LawvereDiagonal.cantor`,
--     read under two different glosses of the enumeration `e`.  No
--     hypothesis about a theory is used.  (Â§1 below.)
--
--   * Gdel's first incompleteness theorem splits into two conjuncts.
--     - T âŠ G follows from the Lawvere fixed point together with TWO
--       hypotheses Lawvere does not supply: consistency, and the first
--       Hilbertâ“Bernaysâ“Lb condition D1.  `goedelHalfOne`.
--     - T âŠ ÂG does NOT follow from those hypotheses at all.
--       `noHalfTwo` refutes every would-be derivation, by exhibiting a
--       four-sentence structure satisfying consistency, D1 and the
--       Gdel fixed point in which ÂG IS provable.  The refutation is a
--       finite exhaustive verification, discharged by the typechecker.
--
-- The countermodel is not a curiosity: it is Ï‰-inconsistent in exactly
-- the arithmetic sense â” it proves `prov g` while not proving `g` â” and
-- that is the failure mode Gdel 1931 excluded by assuming Ï‰-consistency
-- and Rosser 1936 removed by changing the fixed point.  Changing the
-- fixed point is a choice of Î½, not a consequence of the theorem about Î½.
--
-- Prior art: Lawvere 1969; Pavlovi, Arch. Math. Logic 31 (1992) 397â“406;
-- Yanofsky, Bull. Symbolic Logic 9 (2003) 362â“386; Roberts,
-- Compositionality (2023), arXiv:2110.00239.  See
------------------------------------------------------------------------

module GodelSeparation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool
open import Cubical.Data.Unit
open import Cubical.Data.Empty renaming (rec to absurd)
open import Cubical.Data.Sum
open import Cubical.Relation.Nullary

open import LawvereDiagonal

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- Â§1.  Tarski is Cantor's term.
--
-- Read A as the type of codes of formulas in one free variable and
-- `sat a x` as "the formula coded by a is satisfied by x".  A truth
-- definition inside the language is exactly a weak point-surjection: it
-- would realise every A-indexed Bool-valued behaviour as some row.  The
-- fixed-point-free Î½ is negation on truth values, as in Tarski 1933.
-- The term is `cantor`, unchanged â” that identity IS the content.
------------------------------------------------------------------------

tarskiUndefinability : {A : Type â„“} (sat : A â†’ A â†’ Bool) â†’ Â¬ WkPtSurj sat
tarskiUndefinability = cantor

------------------------------------------------------------------------
-- Â§2.  No stage of the diagonal tower is terminal.
--
-- The geometric obstruction tower is GRADED: the obstruction to
-- extending a section over the (n+1)-skeleton lies in H^{n+1}(X;Ï_n F),
-- and on a finite-dimensional complex the tower dies above dim X.  The
-- diagonal tower does not: adjoining the escaping observation D to the
-- stage A produces A âŠ D, at which the very same theorem applies again,
-- at the same type level.  Ungraded and non-terminating, against graded
-- and terminating: a second discriminator, independent of the locality
--
-- [ADDED 2026-08-15, Claude (header-claim audit).  The paragraph above
--  is left as written and is appended to, not replaced.  IT CLAIMS MORE
--  THAN `noTerminalStage` PROVES, and the gap is the exact shape this
--  corpus keeps catching: a header reads off a result about an object
--  the module never constructs.  What is below is
--
--      noTerminalStage {A D} (e : (A âŠ D) â’ (A âŠ D) â’ Bool) â’ Â WkPtSurj e
--      noTerminalStage = cantor
--
--  i.e. `cantor` instantiated at the type `A âŠ D`.  In it:
--    Â `D` is an UNCONSTRAINED type variable.  Nothing types it as the
--      escaping observation of the previous stage â” that escapee is a
--      term of `A â’ Bool`, a function, not a type one can sum with `A`.
--      So "adjoining the escaping observation D to the stage A" is a
--      gloss the term does not carry; no adjunction is performed and no
--      stage is related to its successor.
--    Â There is NO TOWER in this module: no stage indexing, no successor
--      operation, no iteration.  "No stage of the diagonal tower is
--      terminal" is therefore not a statement any term here makes.
--    Â The comparison with the graded geometric obstruction tower
--      (H^{n+1}(X;Ï_n F), dying above dim X) is prose only: neither
--      grading nor termination is formalised, so "ungraded and
--      non-terminating, against graded and terminating: a second
--      discriminator" is an unwitnessed claim.
--  What IS proved, and it is worth having: Cantor holds at every type,
--  coproducts included, so no coproduct-shaped enlargement of the
--  carrier can make a quotation point-surjective.  That is a corollary
--  of `cantor`'s universal quantification over the carrier, obtained
--  without any tower.  Read Â§2 as that, and read the tower argument as
--  an open PROVE item, not as something discharged below.
------------------------------------------------------------------------

noTerminalStage : {A D : Type â„“} (e : (A âŠŽ D) â†’ (A âŠŽ D) â†’ Bool)
  â†’ Â¬ WkPtSurj e
noTerminalStage = cantor

------------------------------------------------------------------------
-- Â§3.  Theories, abstractly: just enough to state Gdel I.
------------------------------------------------------------------------

record Theory (â„“ : Level) : Type (â„“-suc â„“) where
  field
    Sent : Type â„“           -- sentences
    Pf   : Sent â†’ Type â„“    -- Pf s  is inhabited iff  T âŠ¢ s
    neg  : Sent â†’ Sent      -- negation
    prov : Sent â†’ Sent      -- the internal provability predicate at a code

open Theory public

-- T is consistent: never both s and Âs.
Consistent : Theory â„“ â†’ Type â„“
Consistent T = (s : Sent T) â†’ Pf T s â†’ Pf T (neg T s) â†’ âŠ¥

-- First Hilbertâ“Bernaysâ“Lb condition: T âŠ s implies T âŠ Prov(âsâ).
HBL1 : Theory â„“ â†’ Type â„“
HBL1 T = (s : Sent T) â†’ Pf T s â†’ Pf T (prov T s)

-- A Gdel fixed point for G: T âŠ G â” ÂProv(âGâ).
-- This is ALL Lawvere's theorem delivers on the logical side; obtaining
-- it needs the representability of prov, which is a hypothesis about T,
-- not about the ambient cartesian closed structure.
GoedelFix : (T : Theory â„“) â†’ Sent T â†’ Type â„“
GoedelFix T G =
  (Pf T G â†’ Pf T (neg T (prov T G))) Ã— (Pf T (neg T (prov T G)) â†’ Pf T G)

-- Ï‰-inconsistency, in the one instance that matters here: T proves that
-- G is provable, and does not prove G.
OmegaBad : (T : Theory â„“) â†’ Sent T â†’ Type â„“
OmegaBad T G = Pf T (prov T G) Ã— (Â¬ Pf T G)

------------------------------------------------------------------------
-- Â§4.  The half that follows: T âŠ G.
--
-- Uses the forward direction of the fixed point, HBL1, and consistency.
-- It does NOT use Ï‰-consistency, and it does not use the fixed point's
-- backward direction.
------------------------------------------------------------------------

goedelHalfOne : (T : Theory â„“) (G : Sent T)
  â†’ Consistent T â†’ HBL1 T â†’ GoedelFix T G
  â†’ Â¬ Pf T G
goedelHalfOne T G con d1 (fwd , _) pG =
  con (prov T G) (d1 G pG) (fwd pG)

------------------------------------------------------------------------
-- Â§5.  The half that does not: T âŠ ÂG is underivable from those data.
--
-- The witness.  Four sentences: âŠ, âŠ, g, Âg.  Negation swaps the pairs.
-- The provability predicate is constantly âŠ â” a legitimate `prov` for a
-- structure this small, and the only clause HBL1 constrains.  Provable:
-- exactly âŠ and Âg.
------------------------------------------------------------------------

data W : Typeâ‚€ where
  wtop wbot wg wng : W

wneg : W â†’ W
wneg wtop = wbot
wneg wbot = wtop
wneg wg   = wng
wneg wng  = wg

wPf : W â†’ Typeâ‚€
wPf wtop = Unit
wPf wbot = âŠ¥
wPf wg   = âŠ¥
wPf wng  = Unit

Wit : Theory â„“-zero
Sent Wit = W
Pf   Wit = wPf
neg  Wit = wneg
prov Wit = Î» _ â†’ wtop

-- Consistency, by exhaustion over the four sentences.
witCon : Consistent Wit
witCon wtop _ b = b
witCon wbot a _ = a
witCon wg   a _ = a
witCon wng  _ b = b

-- HBL1: the consequent is `wPf wtop = Unit`, always inhabited.
witHBL1 : HBL1 Wit
witHBL1 _ _ = tt

-- The Gdel fixed point at g: both sides are âŠ, so both directions are
-- vacuous.  (wPf wg = âŠ and wPf (wneg wtop) = wPf wbot = âŠ.)
witFix : GoedelFix Wit wg
witFix = absurd , absurd

-- â¦and yet Âg is provable.
witProvesNegG : wPf (wneg wg)
witProvesNegG = tt

-- Therefore no derivation of the second conjunct of Gdel I from
-- {consistency, HBL1, Gdel fixed point} exists.  A negative with a
-- witness: any such derivation, applied to Wit, yields âŠ.
noHalfTwo :
  ((T : Theory â„“-zero) (G : Sent T)
     â†’ Consistent T â†’ HBL1 T â†’ GoedelFix T G
     â†’ Â¬ Pf T (neg T G))
  â†’ âŠ¥
noHalfTwo half2 = half2 Wit wg witCon witHBL1 witFix witProvesNegG

-- The witness fails exactly where Gdel 1931 assumed Ï‰-consistency: it
-- proves `prov g` and does not prove `g`.
witOmegaBad : OmegaBad Wit wg
witOmegaBad = tt , goedelHalfOne Wit wg witCon witHBL1 witFix

------------------------------------------------------------------------
-- Â§6.  Summary, as types.
--
--   Cantor              LawvereDiagonal.cantor          â” an instance
--   Tarski              tarskiUndefinability (= cantor) â” an instance
--   Gdel I, conjunct 1 goedelHalfOne                   â” instance + 2 hyps
--   Gdel I, conjunct 2 noHalfTwo                       â” NOT an instance
--
-- The corpus claim "Gdel's first incompleteness theorem is an instance
-- of Lawvere's fixed-point theorem" is therefore false-grounds: what is
-- an instance is the diagonal lemma.  The theorem is the diagonal lemma
-- plus arithmetic hypotheses that no cartesian closed category supplies.
------------------------------------------------------------------------
