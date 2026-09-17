{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BarrierIsTwoWitnesses
--
-- The witness thread has been measuring absences of its own choosing.
-- This applies it to the corpus's own headline open problem, and the fit
-- is not an analogy â” it is the same shape.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- **Proposition B3 (nonlinear closure).** *Any O = Î¦(Q_{wâ},â¦,Q_{w_r})
-- with arbitrary â” even non-computable â” post-processing Î¦ is a function
-- of r numbers each of which factors as in B1.  Hence the entire class
-- WL_d(L,r) factors through the blurred measure Ï_k * K_L.
-- Post-processing cannot recover information the windows did not pass.*
--
-- That is the PROBE structure of `TheCeilingIsAboutReading`, arrived at
-- independently and for analytic reasons: the decoders are exactly the
-- post-processings, and what they may read is exactly the blur.
--
-- And then, in the same note:
--
-- > **The barrier problem (precise).** Exhibit, or rule out, a pair of
-- > admissible zero configurations indistinguishable to all
-- > WL_d(L,poly) observables â¦ but with different pair-correlation
-- > statistics.
--
-- A PAIR.  The note reached the number 2 on its own, from the
-- mathematics, before any of this measure existed.  What the measure
-- adds is why it is 2 and not 1 and not more.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED HERE
--
-- Schematically, over abstract `Config`, `Blur`, `Stat` â” which is the
-- right generality, because B3's content is precisely that Î¦ is
-- arbitrary:
--
--     Recovers Î¦  =  (c : Config) â’ Î¦ (blur c) â‰¡ stat c
--     Barrier     =  Â Î[ Î¦ âˆˆ (Blur â’ Stat) ] Recovers Î¦
--
--   one-config-never-suffices : Â Refutes (FullLaw blur stat) (c âˆ [])
--   barrier-from-a-pair       : blur c â‰¡ blur c' â’ Â (stat c â‰¡ stat c')
--                             â’ Barrier
--   barrier-witness-number-2  : â¦and the witness number is exactly 2
--
-- The first is the methodological content and it holds with no
-- hypothesis whatever: **no single admissible configuration can
-- establish a barrier of this kind**, however extreme, because the
-- constant post-processing answers it.  A barrier here is irreducibly a
-- statement about two objects.
--
-- The second says the pair the note asks for is not merely sufficient
-- evidence â” it is the entire content.  Given it, every post-processing
-- dies at once, non-computable ones included, which is what B3's
-- "arbitrary Î¦" was for.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- Nothing analytic.  No claim that such a pair exists, that the zeros of
-- Î admit one, that the counting law and functional equation can be met,
-- is explicit that B1â“B3 do *not* establish a barrier against inferring
-- Î's correlations, and this module establishes strictly less than B3.
--
-- What it establishes is the SHAPE: that the open problem is a
-- two-witness problem, that one witness is provably never enough, and
-- that "exhibit a pair" is not a convenient route to the barrier but its
-- exact statement.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module BarrierIsTwoWitnesses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; Â¬-<-zero ; pred-â‰¤-pred)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Discrete)

open import WitnessNumberIsTwo using (Refutes ; refutesâ†’absent)
open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import WhyTheSitesAreTwo using (CollisionFree)
open import SiteAudit
  using (FullLaw ; full-singleton-never ; full-empty-never ; full-collisionâ†’refutes)
open import TheCeilingIsAboutReading using (tableZ-correct)

private
  variable
    â„“ â„“' â„“'' : Level

------------------------------------------------------------------------
-- 1.  B3's structure, taken at its word
------------------------------------------------------------------------

module Barrier
  {Config : Type â„“} {Blur : Type â„“'} {Stat : Type â„“''}
  (blur : Config â†’ Blur) (stat : Config â†’ Stat)
  where

  -- B3: an admissible observable is an arbitrary post-processing of the
  -- blurred measure.  No computability, no continuity, nothing.
  Observable : Type (â„“-max â„“' â„“'')
  Observable = Blur â†’ Stat

  Recovers : Observable â†’ Type (â„“-max â„“ â„“'')
  Recovers Î¦ = (c : Config) â†’ FullLaw blur stat Î¦ c

  BarrierHolds : Type (â„“-max â„“ (â„“-max â„“' â„“''))
  BarrierHolds = Â¬ (Î£[ Î¦ âˆˆ Observable ] Recovers Î¦)

  ----------------------------------------------------------------------
  -- 2.  ONE CONFIGURATION IS NEVER ENOUGH
  --
  -- Whatever a single admissible configuration does, the constant
  -- post-processing `Î» _ â’ stat c` answers it.  So no barrier of this
  -- kind is ever established by exhibiting one object.
  ----------------------------------------------------------------------

  one-config-never-suffices : (c : Config) â†’ Â¬ Refutes (FullLaw blur stat) (c âˆ· [])
  one-config-never-suffices = full-singleton-never blur stat

  no-config-never-suffices : (c : Config) â†’ Â¬ Refutes (FullLaw blur stat) []
  no-config-never-suffices = full-empty-never blur stat

  ----------------------------------------------------------------------
  -- 3.  A PAIR IS THE WHOLE CONTENT
  --
  -- Two configurations the blur identifies and the statistic separates
  -- kill every post-processing at once â” which is exactly what B3's
  -- "arbitrary, even non-computable Î¦" is there to make meaningful.
  ----------------------------------------------------------------------

  pair-refutes : {c c' : Config}
               â†’ blur c â‰¡ blur c' â†’ Â¬ (stat c â‰¡ stat c')
               â†’ Refutes (FullLaw blur stat) (c âˆ· c' âˆ· [])
  pair-refutes = full-collisionâ†’refutes blur stat

  barrier-from-a-pair : {c c' : Config}
                      â†’ blur c â‰¡ blur c' â†’ Â¬ (stat c â‰¡ stat c')
                      â†’ BarrierHolds
  barrier-from-a-pair {c} {c'} same differ =
    refutesâ†’absent (FullLaw blur stat) (c âˆ· c' âˆ· [])
      (pair-refutes {c} {c'} same differ)

  ----------------------------------------------------------------------
  -- 4.  AND THE WITNESS NUMBER IS EXACTLY 2
  ----------------------------------------------------------------------

  barrier-witness-number-2 :
    (c c' : Config) â†’ blur c â‰¡ blur c' â†’ Â¬ (stat c â‰¡ stat c')
    â†’ WitnessNumberIs (FullLaw blur stat) 2
  barrier-witness-number-2 c c' same differ =
      (c âˆ· c' âˆ· [] , refl , pair-refutes {c} {c'} same differ)
    , least
    where
    least : (ys : List Config) â†’ length ys < 2 â†’ Â¬ Refutes (FullLaw blur stat) ys
    least []           _  = no-config-never-suffices c
    least (a âˆ· [])     _  = one-config-never-suffices a
    least (a âˆ· b âˆ· ys) lt = Empty.rec (Â¬-<-zero (pred-â‰¤-pred (pred-â‰¤-pred lt)))

  ----------------------------------------------------------------------
  -- 5.  The converse, on any finite family of configurations
  --
  -- If a listed family contains NO such pair, a post-processing
  -- answering the whole family exists â” so on that family the barrier
  -- fails.  This needs the blur values to be comparable, which is the
  -- `Discrete Blur` of `TheCeilingIsAboutReading`, and it is a statement
  -- about the listed family only, not about all of `Config`.
  ----------------------------------------------------------------------

  no-pair-on-a-family :
    (dB : Discrete Blur) (câ‚€ : Config) (cs : List Config)
    â†’ CollisionFree blur stat (câ‚€ âˆ· cs)
    â†’ Â¬ Refutes (FullLaw blur stat) (câ‚€ âˆ· cs)
  no-pair-on-a-family dB câ‚€ cs cf ref =
    ref decode (holds (câ‚€ âˆ· cs) (Î» _ m â†’ m))
    where
    open import WhyTheSitesAreTwo using (Mem)
    open import WitnessNumberIsTwo using (AllHold)
    open import Cubical.Data.Unit using (tt*)
    open import Cubical.Data.Sum using (inl ; inr)
    open import TheCeilingIsAboutReading using (tableZ)

    decode : Blur â†’ Stat
    decode z = tableZ dB blur stat (stat câ‚€) z (câ‚€ âˆ· cs)

    holds : (ys : List Config) â†’ ((c : Config) â†’ Mem c ys â†’ Mem c (câ‚€ âˆ· cs))
          â†’ AllHold (FullLaw blur stat) decode ys
    holds []       _   = tt*
    holds (y âˆ· ys) inc =
        tableZ-correct dB blur stat (stat câ‚€) (câ‚€ âˆ· cs) cf y (inc y (inl refl))
      , holds ys (Î» z m â†’ inc z (inr m))

------------------------------------------------------------------------
-- 6.  What this does for the barrier programme.
--
-- It does not advance it by one inch analytically, and says so.  What it
-- already located correctly and without a reason:
--
--   * one configuration can never establish a barrier of this shape, no
--     matter how extreme â” the constant post-processing answers it.  So
--     any programme of the form "construct a single spectrum with
--     property P" is looking at the wrong kind of object;
--   * a pair with equal blur and different statistic is not evidence for
--     the barrier, it IS the barrier, killing arbitrary Î¦ at once;
--   * and on any finite family with no such pair, the barrier provably
--     fails â” so the search cannot be narrowed to a family that has been
--     checked pairwise.
--
-- The note's phrase "exhibit â¦ a pair" is therefore exact rather than
-- idiomatic, and its own honesty ledger â” that B1â“B3 do not establish
-- the barrier â” is confirmed from the other side: B3 gives the probe
-- structure, and the probe structure is what makes the cost exactly 2.
--
-- OPEN, and it is the note's own open problem, untouched here: whether
-- such a pair exists among admissible configurations.
------------------------------------------------------------------------
