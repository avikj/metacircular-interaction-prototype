{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SiteAudit
--
-- CORRECTION TO `WhyTheSitesAreTwo` Â§6 AND TO
--
-- Both say: *"Every site in this corpus satisfies both hypotheses:
-- function-space decoders, and Y one of â•, Bool, lists of â•.  So 2 was
-- never contingent here."*
--
-- The second half of that is false.  The audit, done properly:
--
--   AdditionChainPredictiveMemory  FiniteInformation.FactorsThrough
--   PowModHasTheSameShape          FiniteInformation.FactorsThrough
--   FuelAdequacyIsACollision       FiniteInformation.FactorsThrough
--   ExhaustionIsSystematic         (three sites, same)
--   QuotientFiberLaw               Î[ g âˆˆ (List Bool â’ Bool) ] â¦
--   Laghava                        Î[ f âˆˆ (Denotation â’ â•) ] â¦
--   AvaktavyaDoesNotFactor         Î[ v âˆˆ Vacana ] â¦          six atoms
--
-- Two things went unchecked.
--
-- ONE.  `Laghava`'s observation space is `Denotation = â• â’ â•`.  That is
-- NOT discrete, and its witnesses are not locatable either â” equality of
-- functions â• â’ â• is not decidable.  So neither `WhyTheSitesAreTwo` nor
-- `LocatingIsEnough` applies at the site the whole à²à¾à˜àµ thread is about.
--
-- TWO.  `Laghava` and `QuotientFiberLaw` quantify over decoders on the
-- WHOLE CODOMAIN â” `Denotation â’ â•`, `List Bool â’ Bool` â” not over
-- `Image q â’ T`.  The ceiling theorem was stated for the image-restricted
-- space, so it did not literally cover them.  Â§1 below fixes that, and
-- the fix is simpler than the original, not harder.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT SURVIVES, AND ON WHAT GROUND
--
-- Every site is still exactly 2.  But the ground differs, and conflating
-- the two is what produced the overstatement:
--
--   ACHIEVABILITY (â‰ 2)  from an exhibited collision.  Holds at every
--                        site, needs no hypothesis, is what each module
--                        already proved.
--   THE FLOOR (â‰ 2)      from the constant decoder.  Needs only that the
--                        decoder space contain constants.  Holds at
--                        every site here including `Laghava`.
--   THE CEILING (â‰ 2 for
--   ANY absence of that
--   shape)               from `WhyTheSitesAreTwo`.  Needs discreteness
--                        or locatability.  Does NOT hold at `Laghava`.
--
-- So `Laghava` is 2 â” proved outright in Â§3 â” but not BECAUSE of the
-- ceiling theorem.  The claim "2 was never contingent here" is right at
-- the discrete sites and unproved at `Laghava`, where for all this
-- corpus knows some other absence over the same q could cost more.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ONE CONSTRAINED SITE
--
-- Exactly one: `AvaktavyaDoesNotFactor`, whose decoders are six atoms.
-- It is 2, proved by hand in `WitnessNumberIsTwo` Â§5.  So the audit's
-- real conclusion is narrower and cleaner than the sentence it replaces:
-- every site here is 2, one of them is constrained, one of them has a
-- non-discrete observation space, and each of those two was proved
-- individually rather than by the general theorem.
------------------------------------------------------------------------

module SiteAudit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; suc)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import WitnessNumberIsTwo using (AllHold ; Refutes)
open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import Laghava
  using (Expr ; Denotation ; eval ; size ; laghava-collision ; FactorsThroughMeaning)

private
  variable
    â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  Decoders on the whole codomain â” the shape two sites actually use
------------------------------------------------------------------------

FullLaw : {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
        â†’ (X â†’ Y) â†’ (X â†’ T) â†’ (Y â†’ T) â†’ X â†’ Type â„“t
FullLaw q t g x = g (q x) â‰¡ t x

-- the floor, as before: a constant decoder answers any single point
full-singleton-never :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) (x : X)
  â†’ Â¬ Refutes (FullLaw q t) (x âˆ· [])
full-singleton-never q t x ref = ref (Î» _ â†’ t x) (refl , tt*)

full-empty-never :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) (x : X)
  â†’ Â¬ Refutes (FullLaw q t) []
full-empty-never q t x ref = ref (Î» _ â†’ t x) tt*

-- achievability: a collision is a refuting pair, and here without even
-- the image-point lemma the `Image` version needed
full-collisionâ†’refutes :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) {x x' : X}
  â†’ q x â‰¡ q x' â†’ Â¬ (t x â‰¡ t x')
  â†’ Refutes (FullLaw q t) (x âˆ· x' âˆ· [])
full-collisionâ†’refutes q t same differ g (at-x , at-x' , _) =
  differ (sym at-x âˆ™ cong g same âˆ™ at-x')

------------------------------------------------------------------------
-- 2.  The shape really is `Laghava`'s, definitionally
------------------------------------------------------------------------

law-is-laghava :
  (Î£[ g âˆˆ (Denotation â†’ â„•) ] ((e : Expr) â†’ FullLaw eval size g e))
  â‰¡ FactorsThroughMeaning size
law-is-laghava = refl

------------------------------------------------------------------------
-- 3.  SO `Laghava`'s WITNESS NUMBER IS EXACTLY 2 â” on its own ground,
--     with no discreteness anywhere
------------------------------------------------------------------------

laghava-is-two : WitnessNumberIs (FullLaw eval size) 2
laghava-is-two =
    ( laghava-collision .fst âˆ· laghava-collision .snd .fst âˆ· []
    , refl
    , full-collisionâ†’refutes eval size
        {x = laghava-collision .fst} {x' = laghava-collision .snd .fst}
        (laghava-collision .snd .snd .fst)
        (laghava-collision .snd .snd .snd) )
  , least
  where
  eâ‚€ : Expr
  eâ‚€ = laghava-collision .fst

  least : (ys : List Expr) â†’ length ys < 2 â†’ Â¬ Refutes (FullLaw eval size) ys
  least []           _  = full-empty-never eval size eâ‚€
  least (a âˆ· [])     _  = full-singleton-never eval size a
  least (a âˆ· b âˆ· ys) lt = Empty.rec (Â¬-<-zero (pred-â‰¤-pred (pred-â‰¤-pred lt)))
    where
    open import Cubical.Data.Nat.Order using (Â¬-<-zero ; pred-â‰¤-pred)

------------------------------------------------------------------------
-- 4.  What the audit leaves.
--
-- SETTLED.  Every factorisation site in this corpus has witness number
-- exactly 2, and the list of sites is the one in the header.  Two of
-- them are not covered by the general ceiling theorem â” `Laghava`
-- because `Denotation = â• â’ â•` is neither discrete nor locatable, and
-- `AvaktavyaDoesNotFactor` because its decoders are six atoms â” and both
-- were proved individually, here and in `WitnessNumberIsTwo` Â§5
-- respectively.
--
-- CORRECTED.  "2 was never contingent here" is true at the discrete
-- sites and was asserted of all of them.  At `Laghava` the 2 is a fact
-- about the exhibited collision, not a consequence of any theorem, and
-- nothing in this corpus rules out a costlier absence over the same
-- `eval`.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5.  THE CEILING AT `Laghava`, and where the hypothesis relocates.
--
-- `TheCeilingIsAboutReading` settles the useful half.  The
-- ceiling was never about discreteness of the OBSERVATIONS; it is about
-- the decoders having something discrete to READ.  Give them a probe
-- `p : Y â’ Z` with Z discrete and restrict them to `Z â’ T`, and the
-- ceiling returns with no hypothesis on Y at all â” the table is built
-- over Z, and Y is never compared with anything.
--
-- At `Laghava` one evaluation point does it: `probe1 d = d 1`, Z = â•.
-- The à²à¾à˜àµ pair survives probing, since `short` and `long` share a
-- denotation and so agree at 1, and
--
--     laghava-probe-is-two :
--       WitnessNumberIs (ProbeLaw eval size probe1) 2
--
-- So over the probed decoders EVERY absence at `Laghava` costs 2.
-- Probing only removes decoders, so the probed statement is weaker and
-- `Laghava`'s own theorem implies it.
--
-- A decoder in the
-- full space `Denotation â’ â•` must recognise an arbitrary `d : â• â’ â•` as
-- a listed denotation, which is a decision of function equality.  This
-- lane builds no such decision and refutes none; the type contains what
-- it contains.
------------------------------------------------------------------------
