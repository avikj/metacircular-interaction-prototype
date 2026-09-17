{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCeilingIsAboutReading
--
-- `SiteAudit` Â§4 left this open, and it is the last item of the witness
-- thread that had a name:
--
--     whether the ceiling holds at `Laghava` â” i.e. whether every
--     absence over `eval : Expr â’ (â• â’ â•)` costs 2.  Equality of
--     functions â• â’ â• is not decidable, but locating finitely many
--     SPECIFIC denotations against an arbitrary one is a weaker demand,
--     and this module does not settle whether it can be met.
--
-- It cannot be met by any construction available here, and the reason is
-- not incidental: a decoder `Denotation â’ â•` that answers a listed
-- denotation correctly must first recognise it, and recognising an
-- arbitrary `d : â• â’ â•` as a particular one is exactly a decision of
-- function equality.  Nothing in this lane builds that, and nothing in
-- this lane refutes its existence either â” the type `Denotation â’ â•`
-- contains whatever it contains.
--
-- So the honest result is not a verdict on that decoder space.  It is a
-- characterisation of exactly which decoder spaces DO get the ceiling,
-- and `Laghava`'s is the boundary case.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE THEOREM
--
-- Give the observations a discrete PROBE `p : Y â’ Z` and restrict
-- decoders to those that read the probe only:
--
--     ProbeLaw q t p g x  =  g (p (q x)) â‰¡ t x        g : Z â’ T
--
-- Then the ceiling comes back with no hypothesis on Y at all:
--
--     probe-ceiling : Discrete Z
--                   â’ CollisionFree (p âˆ˜ q) t (xâ âˆ xs)
--                   â’ Â Refutes (ProbeLaw q t p) (xâ âˆ xs)
--
-- because the table is now built over Z, where comparison is available.
-- Y never has to be compared with anything.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AT LAGHAVA
--
-- One probe suffices: `p d = d 1`, so Z = â•.  The à²à¾à˜àµ pair survives it
-- â” `short` and `long` have the same denotation, hence the same value at
-- 1, and different sizes â” so it is still a collision after probing, and
--
--     laghava-probe-is-two : WitnessNumberIs (ProbeLaw eval size probe1) 2
--
-- Over the probed decoders, EVERY absence at `Laghava` costs 2, the
-- à²à¾à˜àµ one included.  And probing only removes decoders
-- (`probeFactorsâ’meaningFactors`), so the probed absence is the weaker
-- statement: `Laghava`'s own theorem implies it and not conversely.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- SETTLED.  The ceiling is not about discreteness of the OBSERVATIONS.
-- It is about the decoders having something discrete to read.  Restrict
-- them to any discrete probe, however coarse, and the ceiling returns â”
-- at `Laghava`, at a single evaluation point.
--
-- NOT SETTLED, and now sharply: the ceiling over the FULL space
-- `Denotation â’ â•`.  That space is not reachable by a probe, and
-- deciding membership in it is deciding equality of functions â• â’ â•.
-- This is the one place in the witness thread where an open item is
-- open for a REASON rather than for want of an argument, and naming the
-- reason is the result.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module TheCeilingIsAboutReading where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; suc ; discreteâ„•)
open import Cubical.Data.Nat.Order using (_<_ ; Â¬-<-zero ; pred-â‰¤-pred)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (âŠ¥ ; âŠ¥*)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete)

open import WitnessNumberIsTwo using (AllHold ; Refutes)
open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import WhyTheSitesAreTwo using (Mem ; CollisionFree)
open import Laghava
  using (Expr ; Denotation ; eval ; size ; laghava-collision ; FactorsThroughMeaning)

private
  variable
    â„“x â„“y â„“z â„“t : Level

------------------------------------------------------------------------
-- 1.  The ceiling for decoders on a whole discrete codomain
--
-- The table is over Z, so this is the `LocatingIsEnough` argument with
-- the image machinery removed.  It is shorter, not longer.
------------------------------------------------------------------------

module _ {X : Type â„“x} {Z : Type â„“z} {T : Type â„“t}
         (dZ : Discrete Z) (r : X â†’ Z) (t : X â†’ T) (fb : T) where

  tableZ : Z â†’ List X â†’ T
  tableZ z []       = fb
  tableZ z (x âˆ· xs) with dZ (r x) z
  ... | yes _ = t x
  ... | no  _ = tableZ z xs

  tableZ-correct :
    (ys : List X) â†’ CollisionFree r t ys
    â†’ (x : X) â†’ Mem x ys â†’ tableZ (r x) ys â‰¡ t x
  tableZ-correct []       cf x m = Empty.rec* m
  tableZ-correct (y âˆ· ys) cf x m with dZ (r y) (r x)
  ... | yes e = cf y x (inl refl) m e
  ... | no Â¬e = tableZ-correct ys cf' x (later m)
    where
    cf' : CollisionFree r t ys
    cf' a b ma mb = cf a b (inr ma) (inr mb)

    later : Mem x (y âˆ· ys) â†’ Mem x ys
    later (inl xâ‰¡y) = Empty.rec (Â¬e (sym (cong r xâ‰¡y)))
    later (inr l)   = l

------------------------------------------------------------------------
-- 2.  THE PROBED LAW, and its ceiling
------------------------------------------------------------------------

ProbeLaw : {X : Type â„“x} {Y : Type â„“y} {Z : Type â„“z} {T : Type â„“t}
         â†’ (X â†’ Y) â†’ (X â†’ T) â†’ (Y â†’ Z) â†’ (Z â†’ T) â†’ X â†’ Type â„“t
ProbeLaw q t p g x = g (p (q x)) â‰¡ t x

module _ {X : Type â„“x} {Y : Type â„“y} {Z : Type â„“z} {T : Type â„“t}
         (dZ : Discrete Z) (q : X â†’ Y) (t : X â†’ T) (p : Y â†’ Z) where

  probe-ceiling :
    (xâ‚€ : X) (xs : List X)
    â†’ CollisionFree (Î» x â†’ p (q x)) t (xâ‚€ âˆ· xs)
    â†’ Â¬ Refutes (ProbeLaw q t p) (xâ‚€ âˆ· xs)
  probe-ceiling xâ‚€ xs cf ref = ref decode (holds (xâ‚€ âˆ· xs) (Î» _ m â†’ m))
    where
    decode : Z â†’ T
    decode z = tableZ dZ (Î» x â†’ p (q x)) t (t xâ‚€) z (xâ‚€ âˆ· xs)

    holds : (ys : List X) â†’ ((x : X) â†’ Mem x ys â†’ Mem x (xâ‚€ âˆ· xs))
          â†’ AllHold (ProbeLaw q t p) decode ys
    holds []       _   = tt*
    holds (y âˆ· ys) inc =
        tableZ-correct dZ (Î» x â†’ p (q x)) t (t xâ‚€) (xâ‚€ âˆ· xs) cf y (inc y (inl refl))
      , holds ys (Î» z m â†’ inc z (inr m))

  -- the floor is unchanged: a constant decoder answers one point
  probe-singleton-never : (x : X) â†’ Â¬ Refutes (ProbeLaw q t p) (x âˆ· [])
  probe-singleton-never x ref = ref (Î» _ â†’ t x) (refl , tt*)

  probe-empty-never : (x : X) â†’ Â¬ Refutes (ProbeLaw q t p) []
  probe-empty-never x ref = ref (Î» _ â†’ t x) tt*

  -- and a probed collision is a refuting pair
  probe-collisionâ†’refutes :
    {x x' : X} â†’ p (q x) â‰¡ p (q x') â†’ Â¬ (t x â‰¡ t x')
    â†’ Refutes (ProbeLaw q t p) (x âˆ· x' âˆ· [])
  probe-collisionâ†’refutes same differ g (at-x , at-x' , _) =
    differ (sym at-x âˆ™ cong g same âˆ™ at-x')

------------------------------------------------------------------------
-- 3.  AT LAGHAVA: one evaluation point is enough
------------------------------------------------------------------------

probe1 : Denotation â†’ â„•
probe1 d = d 1

-- probing only removes decoders, so the probed statement is the weaker
-- one and `Laghava`'s theorem implies it
probeFactorsâ†’meaningFactors :
  Î£[ g âˆˆ (â„• â†’ â„•) ] ((e : Expr) â†’ ProbeLaw eval size probe1 g e)
  â†’ FactorsThroughMeaning size
probeFactorsâ†’meaningFactors (g , law) = (Î» d â†’ g (probe1 d)) , law

-- the à²à¾à˜àµ pair survives probing: same denotation, hence same value at 1
laghava-probe-collision :
  probe1 (eval (laghava-collision .fst))
  â‰¡ probe1 (eval (laghava-collision .snd .fst))
laghava-probe-collision = cong probe1 (laghava-collision .snd .snd .fst)

laghava-probe-is-two : WitnessNumberIs (ProbeLaw eval size probe1) 2
laghava-probe-is-two =
    ( laghava-collision .fst âˆ· laghava-collision .snd .fst âˆ· []
    , refl
    , probe-collisionâ†’refutes discreteâ„• eval size probe1
        {x = laghava-collision .fst} {x' = laghava-collision .snd .fst}
        laghava-probe-collision
        (laghava-collision .snd .snd .snd) )
  , least
  where
  eâ‚€ : Expr
  eâ‚€ = laghava-collision .fst

  least : (ys : List Expr) â†’ length ys < 2 â†’ Â¬ Refutes (ProbeLaw eval size probe1) ys
  least []           _  = probe-empty-never discreteâ„• eval size probe1 eâ‚€
  least (a âˆ· [])     _  = probe-singleton-never discreteâ„• eval size probe1 a
  least (a âˆ· b âˆ· ys) lt = Empty.rec (Â¬-<-zero (pred-â‰¤-pred (pred-â‰¤-pred lt)))

------------------------------------------------------------------------
-- 4.  What this settles, and the one thing it deliberately does not.
--
-- SETTLED.  The ceiling was never about discreteness of the
-- OBSERVATIONS.  It is about the decoders having something discrete to
-- read.  Give them any probe into a discrete type â” at `Laghava`, a
-- single evaluation point â” and the ceiling returns in full: over the
-- probed decoders every absence there costs 2, with the à²à¾à˜àµ pair still
-- doing the work.
--
-- That reframes the whole `WhyTheSitesAreTwo` / `LocatingIsEnough` line.
-- `Discrete Y` was the crudest sufficient condition; `Locates` narrowed
-- it to the witnesses; this drops it from Y entirely and puts it where
-- it belongs, on what the decoder is allowed to see.
--
-- NOT SETTLED, and now for a stated reason rather than for want of an
-- argument: the ceiling over the FULL space `Denotation â’ â•`.  A decoder
-- there must recognise an arbitrary `d : â• â’ â•` as a listed denotation,
-- which is a decision of function equality.  This lane builds no such
-- decision and refutes no such decision; the type contains what it
-- contains.  That is the only open item in this thread whose openness is
-- itself a fact rather than a gap, and saying so is the result.
------------------------------------------------------------------------
