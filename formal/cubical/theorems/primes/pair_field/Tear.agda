{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Tear
--
-- D0025 Â§16 and Â§18, D0016 Â§B and Â§C: the tear as an OBJECT, and Î“ as
-- the operation that makes the next stage's material out of it.
--
-- Â§16:  a separator "becomes a new object/cell in the theory graph".
-- Â§18:  "a failed gluing condition is exactly the tear that the next
--        Braid stage must repair."
-- D0016 Â§C:  Î“_Î : ğ’_Î â’ Cell(ğ’_{Î+1}), attached along âˆğ’_Î, with
--        âˆÎ“âŸ¨Î´â½â¿â¾âŸ© = Î´â½â¿âºÂâ¾, and Â§I: "the boundary is the womb of the
--        successor form".
--
-- This is the operation whose absence is the whole complaint in Â§27,
-- and the concrete form of it in `machine/MathMachine.hs` is that a
-- round refuted 9,001 conjectures and failed to prove 34,320 and
-- DELETED all 43,321, keeping 30 successes.  Every one of those was a
-- witnessed distinction.  A machine that keeps only what succeeded is
-- accumulating jewels; the material of the next stage is what tore.
--
-- WHAT IS PROVED HERE.  That this net actually tears -- not as a
-- possibility, as an exhibited term.  Each thread family carries an
-- invariant BY DEFINITION (a shared-centre thread is a proof that the
-- centres agree), and the composite of the two families carries
-- NEITHER.  Concrete jewels are given and the disagreement is proved,
-- not asserted.  Then Î“ takes a tear to a jewel, so the next stage's
-- material is produced by the failure rather than chosen from a menu --
-- which is the exact difference between this and the machine's `GROW`,
-- where running dry takes the next symbol off a hard-coded list.
--
------------------------------------------------------------------------

module Tear where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Properties
open import Cubical.Relation.Nullary
open import RootedNet
open import ThreadYoneda

------------------------------------------------------------------------
-- Â§1  What each thread family carries, and what it does not
--
-- These are not lemmas about the relations, they ARE the relations: a
-- `sharedCentre` thread is precisely a proof that the true centres
-- agree.  Writing them out is what makes the failure in Â§3 legible as a
-- failure of TRANSPORT rather than as an accident of two numbers.
------------------------------------------------------------------------

centreCarried : {i j : Jewel} â†’ Thread i j â†’ Type
centreCarried {i} {j} _ = trueCentre i â‰¡ trueCentre j

radiusCarried : {i j : Jewel} â†’ Thread i j â†’ Type
radiusCarried {i} {j} _ = radius i â‰¡ radius j

-- a shared-centre thread transports the centre, and nothing says it
-- transports the radius
centreThreadCarries : (i j : Jewel) (p : trueCentre i â‰¡ trueCentre j)
                    â†’ centreCarried {i} {j} (sharedCentre p)
centreThreadCarries _ _ p = p

radiusThreadCarries : (i j : Jewel) (p : radius i â‰¡ radius j)
                    â†’ radiusCarried {i} {j} (sharedRadius p)
radiusThreadCarries _ _ p = p

------------------------------------------------------------------------
-- Â§2  Three jewels and a mixed weave
--
--   i = (3,1)   true centre 4, radius 1
--   m = (2,2)   true centre 4, radius 2     -- shares i's centre
--   k = (5,2)   true centre 7, radius 2     -- shares m's radius
--
-- so i â’ m â’ k is a legitimate two-step weave, every step of it exact.
------------------------------------------------------------------------

iâ‚€ mâ‚€ kâ‚€ : Jewel
iâ‚€ = jewel 3 1
mâ‚€ = jewel 2 2
kâ‚€ = jewel 5 2

stepâ‚ : Thread iâ‚€ mâ‚€
stepâ‚ = sharedCentre refl

stepâ‚‚ : Thread mâ‚€ kâ‚€
stepâ‚‚ = sharedRadius refl

mixed : Weave iâ‚€ kâ‚€
mixed = stepâ‚ â—ƒ stepâ‚‚ â—ƒ idPath

------------------------------------------------------------------------
-- Â§3  The tear: neither invariant survives the composite
------------------------------------------------------------------------

4â‰¢7 : Â¬ (trueCentre iâ‚€ â‰¡ trueCentre kâ‚€)
4â‰¢7 p = znots (injSuc (injSuc (injSuc (injSuc p))))

1â‰¢2 : Â¬ (radius iâ‚€ â‰¡ radius kâ‚€)
1â‰¢2 p = znots (injSuc p)

------------------------------------------------------------------------
-- Â§4  The tear as an object
--
-- A tear is not the absence of a proof.  It is a POSITIVE datum: two
-- jewels, a weave that really connects them, an observable that really
-- disagrees, and the size of the disagreement.  That last field is what
-- makes it generative rather than merely a complaint -- D0016 Â§B's
-- defect Î´_Ï = ğ”_Ï âŠ– 1 is a difference, and a difference has a size.
--
-- The gap is written additively (`gapWitness`) so that no truncated
-- subtraction enters, the discipline `PairConic` fixed for this net.
------------------------------------------------------------------------

record Tear : Type where
  constructor tear
  field
    from    : Jewel
    to      : Jewel
    along   : Weave from to
    gap     : â„•
    -- the observable really disagrees ...
    parted  : Â¬ (trueCentre from â‰¡ trueCentre to)
    -- ... and this is by exactly `gap`
    gapWitness : trueCentre to â‰¡ trueCentre from + gap

open Tear public

-- and this net really does tear
centreTear : Tear
centreTear = tear iâ‚€ kâ‚€ mixed 3 4â‰¢7 refl

------------------------------------------------------------------------
-- Â§5  Î“: the successor form, born from the boundary
--
-- "ààà®à¾ = à‰àààà°à°ààààà¯ à¯à‹à¨à¿à."  Î“ sends a tear to a jewel of the next
-- stage: the one centred where the weave started, with the DEFECT as
-- its radius.  So the new material is a function of the failure and of
-- nothing else -- no menu, no list of symbols to widen to.
--
-- The equation below is `refl`.  It is stated anyway because it is the
-- one thing that has to be true of Î“ for the construction to mean what
-- Â§C says: the generated cell REMEMBERS the defect it came from
-- (âˆÎ“âŸ¨Î´âŸ© = Î´).  Its proof is nothing; its content is the definition.
------------------------------------------------------------------------

Î“ : Tear â†’ Jewel
Î“ t = jewel (centre (from t)) (gap t)

Î“-remembers : (t : Tear) â†’ radius (Î“ t) â‰¡ gap t
Î“-remembers t = refl

-- The generated jewel is a jewel of this same net, so the next stage is
-- reached without leaving the language -- which is what lets the
-- operation iterate at all.
Î“-of-the-tear : Î“ centreTear â‰¡ jewel 3 3
Î“-of-the-tear = refl

------------------------------------------------------------------------
-- Â§6  What this does not do
--
-- * It does not REPAIR.  Â§18 says the tear is what the next stage must
--   repair; Î“ here produces the successor material and says nothing
--   about gluing it back.  The repair is the coherence cell.
--
-- * The tear exhibited is one term, not a classification.  Which pairs
--   of jewels tear, and by how much, is an arithmetic question about
--   this net -- and it is the first question in this development whose
--   answer is not bookkeeping.
--
-- * Nothing iterates.  Î“ produces a jewel; a stage is a whole net; the
--   step from one to the other is D0016 Â§E's ğ”‰, and the thing that
--   makes ğ”‰ a Braid rather than a loop is ğ”‰_{Î+1} â‰ ğ”‰_Î.
------------------------------------------------------------------------
