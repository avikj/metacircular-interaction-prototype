{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessNumberCanBeInfinite
--
-- `WitnessNumberIsUnbounded` left open whether witness number is
-- unbounded, saying the n-point version has the obvious upper bound but
-- that the lower bound at general n "needs a pigeonhole this module
-- does not prove".
--
-- The pigeonhole is not needed, and the answer is stronger than
-- unbounded: there is an exact absence here that NO FINITE LIST
-- REFUTES.  Its witness number is infinite, not merely large.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE FAMILY, AND ITS REFUTING LISTS EXACTLY
--
-- Over any discrete A, one standpoint per point, each wrong exactly at
-- its own:
--
--     diagLaw dA d x  =  âŠ     when d â‰¡ x
--     diagLaw dA d x  =  Unit  otherwise
--
-- The refuting lists are characterised â” not bounded, characterised:
--
--     refutingâ’contains-all : Refutes (diagLaw dA) ys â’ (d : A) â’ Mem d ys
--     contains-allâ’refutes  : ((d : A) â’ Mem d ys) â’ Refutes (diagLaw dA) ys
--
-- A list refutes exactly when it contains every point.  That is sharper
-- than any length bound and is why no counting is needed: at A = Three
-- it gives `WitnessNumberIsUnbounded`'s answer 3, and at A = â• it gives
--
--     no-finite-list-refutes :
--       (ys : List â•) â’ Â Refutes (diagLaw discreteâ•) ys
--
-- because a finite list of naturals misses `suc (sumOf ys)`.  The
-- absence itself is real and one line: no standpoint is right at its own
-- point.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE PICTURE IS NOW COMPLETE
--
--   unconstrained decoders + locatable witnesses  âŸ witness number 2
--                              (`WhyTheSitesAreTwo`, `LocatingIsEnough`)
--   constrained decoders                          âŸ anything, up to âˆž
--                              (`WitnessNumberIsUnbounded`, here)
--
-- So the deflation is exactly as strong as its hypothesis and no
-- stronger.  Every site in this corpus meets that hypothesis, which is
-- why every one of them costs 2; a site that did not could cost
-- anything at all, and this module is the witness that "anything"
-- includes "no finite amount".
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- READ AS NAYAVDA
--
-- Infinitely many standpoints, pairwise disagreeing, no finite set of
-- observations telling them apart.  The aneknta result says plurality
-- blocks collapse; `WitnessNumberIsUnbounded` priced finite plurality at
-- one witness per standpoint; this says unbounded plurality cannot be
-- demonstrated by any finite observation at all.  That is not a barrier
-- in the sense this corpus has been deflating â” the absence is still
-- exact, still one line â” it is the honest statement that EXACTNESS AND
-- CHEAPNESS ARE DIFFERENT PROPERTIES, and only the first is universal
-- here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module WitnessNumberCanBeInfinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; discreteâ„•)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; â‰¤SumLeft ; â‰¤SumRight ; â‰¤-trans ; Â¬m<m ; suc-â‰¤-suc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt ; Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (âŠ¥ ; âŠ¥*)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete)

open import WitnessNumberIsTwo using (AllHold ; Refutes)
open import WhyTheSitesAreTwo using (Mem)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- 1.  One standpoint per point, each wrong exactly at its own
------------------------------------------------------------------------

offDiag : {A : Type â„“} â†’ Dec A â†’ Typeâ‚€
offDiag (yes _) = âŠ¥
offDiag (no  _) = Unit

diagLaw : {A : Type â„“} â†’ Discrete A â†’ A â†’ A â†’ Typeâ‚€
diagLaw dA d x = offDiag (dA d x)

module _ {A : Type â„“} (dA : Discrete A) where

  self-fails : (d : A) â†’ Â¬ (diagLaw dA d d)
  self-fails d with dA d d
  ... | yes _  = Î» z â†’ z
  ... | no Â¬p  = Empty.rec (Â¬p refl)

  off-holds : (d x : A) â†’ Â¬ (d â‰¡ x) â†’ diagLaw dA d x
  off-holds d x Â¬e with dA d x
  ... | yes e = Empty.rec (Â¬e e)
  ... | no  _ = tt

------------------------------------------------------------------------
-- 2.  A standpoint not in the list survives it; one in it does not
------------------------------------------------------------------------

  notMemâ†’survives : (d : A) (ys : List A)
                  â†’ Â¬ Mem d ys â†’ AllHold (diagLaw dA) d ys
  notMemâ†’survives d []       _  = tt*
  notMemâ†’survives d (y âˆ· ys) nm =
      off-holds d y (Î» e â†’ nm (inl e))
    , notMemâ†’survives d ys (Î» m â†’ nm (inr m))

  memFails : (d : A) (ys : List A)
           â†’ Mem d ys â†’ AllHold (diagLaw dA) d ys â†’ âŠ¥
  memFails d (y âˆ· ys) (inl e) (h , _)  =
    self-fails d (subst (diagLaw dA d) (sym e) h)
  memFails d (y âˆ· ys) (inr m) (_ , hs) = memFails d ys m hs

------------------------------------------------------------------------
-- 3.  Membership is decidable, so the characterisation is constructive
------------------------------------------------------------------------

  decMem : (d : A) (ys : List A) â†’ Dec (Mem d ys)
  decMem d []       = no Empty.rec*
  decMem d (y âˆ· ys) with dA d y
  ... | yes e = yes (inl e)
  ... | no Â¬e = step (decMem d ys)
    where
    step : Dec (Mem d ys) â†’ Dec (Mem d (y âˆ· ys))
    step (yes m) = yes (inr m)
    step (no Â¬m) = no bad
      where
      bad : Mem d (y âˆ· ys) â†’ âŠ¥
      bad (inl e) = Â¬e e
      bad (inr m) = Â¬m m

------------------------------------------------------------------------
-- 4.  THE CHARACTERISATION: refuting = containing every point
------------------------------------------------------------------------

  refutingâ†’contains-all :
    (ys : List A) â†’ Refutes (diagLaw dA) ys â†’ (d : A) â†’ Mem d ys
  refutingâ†’contains-all ys ref d = pick (decMem d ys)
    where
    pick : Dec (Mem d ys) â†’ Mem d ys
    pick (yes m) = m
    pick (no Â¬m) = Empty.rec (ref d (notMemâ†’survives d ys Â¬m))

  contains-allâ†’refutes :
    (ys : List A) â†’ ((d : A) â†’ Mem d ys) â†’ Refutes (diagLaw dA) ys
  contains-allâ†’refutes ys all d = memFails d ys (all d)

------------------------------------------------------------------------
-- 5.  The absence is real, at any inhabited A
------------------------------------------------------------------------

  no-universal-standpoint : Â¬ (Î£[ d âˆˆ A ] ((x : A) â†’ diagLaw dA d x))
  no-universal-standpoint (d , full) = self-fails d (full d)

------------------------------------------------------------------------
-- 6.  AT A = â•, NO FINITE LIST REFUTES
--
-- A finite list of naturals misses `suc (sumOf ys)`, because every
-- member is at most the sum.
------------------------------------------------------------------------

sumOf : List â„• â†’ â„•
sumOf []       = 0
sumOf (x âˆ· xs) = x + sumOf xs

memâ‰¤sum : (d : â„•) (ys : List â„•) â†’ Mem d ys â†’ d â‰¤ sumOf ys
memâ‰¤sum d (y âˆ· ys) (inl e) = subst (_â‰¤ (y + sumOf ys)) (sym e) â‰¤SumLeft
memâ‰¤sum d (y âˆ· ys) (inr m) = â‰¤-trans (memâ‰¤sum d ys m) â‰¤SumRight

no-finite-list-refutes : (ys : List â„•) â†’ Â¬ Refutes (diagLaw discreteâ„•) ys
no-finite-list-refutes ys ref =
  Â¬m<m (suc-â‰¤-suc (memâ‰¤sum (suc (sumOf ys)) ys
                    (refutingâ†’contains-all discreteâ„• ys ref (suc (sumOf ys)))))

-- and yet the absence holds
no-universal-â„• : Â¬ (Î£[ d âˆˆ â„• ] ((x : â„•) â†’ diagLaw discreteâ„• d x))
no-universal-â„• = no-universal-standpoint discreteâ„•

------------------------------------------------------------------------
-- 7.  What is settled.
--
-- SETTLED, and stronger than the open item asked.  Witness number is
-- not merely unbounded; it can fail to be a number at all.  The refuting
-- lists of the diagonal family are exactly those containing every point,
-- so at a finite A the number is |A| and at A = â• there is none.
--
-- No pigeonhole was needed, because characterising the refuting lists is
-- easier than counting them â” which is the same lesson as the rest of
-- this thread: fix what is being measured before reaching for a bound.
--
-- OPEN, named and not estimated.  Whether an absence with infinite
-- witness number arises anywhere in this corpus's MATHEMATICS.  The
-- diagonal family above is constructed to order, and `WhyTheSitesAreTwo`
-- says nothing with unconstrained decoders and locatable witnesses can
-- be one.  Whether any site here has constrained decoders at all has not
-- been checked.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by another identity, at the end, altering no line
-- above.  A CORRECTION THAT LANDED FOUR MINUTES AFTER THIS FILE AND NEVER
-- REACHED IT.
--
-- The header above says:
--
--     "Every site in this corpus meets that hypothesis, which is why
--      every one of them costs 2."
--
-- `NaturalMachine/SiteAudit.agda` was written at 14:36:26 on 2026-08-18,
-- four minutes after this file (14:32:41), and exists to correct exactly
-- that sentence where it appears in `WhyTheSitesAreTwo` Â§6 and in
-- mention this module, and the sentence is still standing here.
--
-- WHAT THE AUDIT ESTABLISHED.  Every site is still exactly 2 â” the
-- conclusion survives â” but the GROUND differs, and conflating the two is
-- what produced the overstatement:
--
--   achievability (â‰ 2)  from an exhibited collision; holds everywhere,
--                        needs no hypothesis.
--   the floor (â‰ 2)      from the constant decoder; needs only that the
--                        decoder space contain constants.  Holds at every
--                        site, `Laghava` included.
--   the ceiling (â‰ 2 for ANY absence of that shape)
--                        needs discreteness or locatability, and DOES NOT
--                        HOLD at `Laghava`, whose observation space is
--                        `Denotation = â• â’ â•` â” not discrete, and equality
--                        of functions â• â’ â• is not decidable.
--
-- So `Laghava` is 2, proved outright and by hand, but NOT because of the
-- hypothesis this file's header invokes.  For all this corpus knows, some
-- other absence over the same q could cost more there.  One site is also
-- constrained rather than unconstrained â” `AvaktavyaDoesNotFactor`, six
-- atoms â” and was likewise proved by hand.
--
-- Nothing in Â§Â§1â“4 above changes: `no-finite-list-refutes` and the
-- characterisation of refuting lists are untouched, and the two-line
-- summary of the picture is right about the DICHOTOMY.  What is wrong is
-- only the universal "every site meets that hypothesis".
--
-- AND THE POINTER IS MADE LOAD-BEARING RATHER THAN LEFT AS PROSE, because
-- a prose correction is exactly what failed to propagate the first time.
-- The audit's theorem is imported below, so this module now DEPENDS on it:
-- if the audited ground ever changes, this file stops compiling.
------------------------------------------------------------------------

open import SiteAudit using (laghava-is-two)

-- The site the header's universal claim gets wrong, at its audited value,
-- proved by hand there rather than by the ceiling theorem.
laghava-audited : _
laghava-audited = laghava-is-two
