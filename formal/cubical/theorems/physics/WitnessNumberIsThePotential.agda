{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessNumberIsThePotential
--
-- `TransportPrice` closed the aneknta thread with a theorem and a
-- deflation:
--
--     cocycleâ’coboundary : c p q â‰¡ c b q âˆ’ c b p
--
-- every additive transport price is the difference of a potential, so
-- there is no path-dependence, no cheapest route, no holonomy â” "all
-- the content is in the potential, a number attached to each standpoint
-- on its own".
--
-- That theorem says where to look and does not say what to find.  This
-- module supplies a potential: the witness number.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE NUMBER, AND THAT TRANSPORT DOES NOT MOVE IT
--
--     WitnessNumberIs law n  =  some length-n list refutes
--                             — no shorter list does
--
--     witness-invariant  : isSurjection f
--                        â’ WitnessNumberIs law n
--                        â’ WitnessNumberIs (reindex f law) n
--     witness-invariant' : the converse, same hypothesis
--
-- So along any surjective reindexing of the decoder space the number is
-- unchanged: its transport price is identically zero.  That is what a
-- potential looks like when you have one â” the price between two nayas
-- related by a reindexing is 0, and every nonzero price is between
-- systems no reindexing connects.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE THREE THREADS, MET
--
--   aneknta      collapse is settled; the remaining question was price
--                 (`Anekanta`, `TransportPrice`)
--   deflation     every absence here is exact, and now measured
--                 (`WitnessNumberIsTwo`, `WhyTheSitesAreTwo`)
--   à²à¾à˜àµ          is there a measure stable under reformulation
--                 (`Laghava`: not on presentations)
--
-- The witness number answers the third affirmatively for absences, is
-- the second's measure, and has the first's price identically zero.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NOT A COINCIDENCE, AND NOT A TRIUMPH
--
-- The price is zero because the number is defined by âˆ over the decoder
-- space, and reindexing does not change what is quantified over.  A
-- potential with identically zero price is the DEGENERATE case of
-- `TransportPrice`'s theorem, not a rich instance of it: it says the
-- nayas related by reindexing are all at one height.  The theorem's
-- content â” that no additive price can do better than a potential â” is
-- what makes that unimprovable rather than disappointing.
------------------------------------------------------------------------

module WitnessNumberIsThePotential where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; Â¬-<-zero ; pred-â‰¤-pred)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Functions.Surjection using (isSurjection)

open import WitnessNumberIsTwo using (Refutes)
open import WitnessNumberIsInvariant
  using (reindex ; refutes-reindex ; refutes-reflect)
open import WitnessNumberIsUnbounded
  using ( Three ; t0 ; t1 ; t2 ; law ; triple ; three-refute
        ; no-pair-refutes ; no-single-refutes ; no-empty-refutes )

private
  variable
    â„“d â„“d' â„“x â„“ : Level

------------------------------------------------------------------------
-- 1.  The number
------------------------------------------------------------------------

WitnessNumberIs : {D : Type â„“d} {X : Type â„“x}
                â†’ (D â†’ X â†’ Type â„“) â†’ â„• â†’ Type (â„“-max â„“x (â„“-max â„“d â„“))
WitnessNumberIs {X = X} law n =
    (Î£[ xs âˆˆ List X ] ((length xs â‰¡ n) Ã— Refutes law xs))
  Ã— ((ys : List X) â†’ length ys < n â†’ Â¬ Refutes law ys)

------------------------------------------------------------------------
-- 2.  TRANSPORT DOES NOT MOVE IT
--
-- The lists live in X, which the reindexing does not touch, so both
-- halves transport directly: the exhibited list by preservation, the
-- minimality by reflection.
------------------------------------------------------------------------

witness-invariant :
  {D : Type â„“d} {D' : Type â„“d'} {X : Type â„“x}
  (f : D' â†’ D) â†’ isSurjection f
  â†’ (law : D â†’ X â†’ Type â„“) (n : â„•)
  â†’ WitnessNumberIs law n â†’ WitnessNumberIs (reindex f law) n
witness-invariant f surj law n ((xs , len , ref) , least) =
    (xs , len , refutes-reindex f law xs ref)
  , (Î» ys short r â†’ least ys short (refutes-reflect f surj law ys r))

witness-invariant' :
  {D : Type â„“d} {D' : Type â„“d'} {X : Type â„“x}
  (f : D' â†’ D) â†’ isSurjection f
  â†’ (law : D â†’ X â†’ Type â„“) (n : â„•)
  â†’ WitnessNumberIs (reindex f law) n â†’ WitnessNumberIs law n
witness-invariant' f surj law n ((xs , len , ref) , least) =
    (xs , len , refutes-reflect f surj law xs ref)
  , (Î» ys short r â†’ least ys short (refutes-reindex f law ys r))

------------------------------------------------------------------------
-- 3.  So the transport price of the witness number is zero
--
-- Stated as the thing `TransportPrice` would call a price: along a
-- surjective reindexing, the number on one side is the number on the
-- other, in both directions.  There is nothing left for a price to
-- measure.
------------------------------------------------------------------------

price-is-zero :
  {D : Type â„“d} {D' : Type â„“d'} {X : Type â„“x}
  (f : D' â†’ D) â†’ isSurjection f
  â†’ (law : D â†’ X â†’ Type â„“) (n : â„•)
  â†’ (WitnessNumberIs law n â†’ WitnessNumberIs (reindex f law) n)
  Ã— (WitnessNumberIs (reindex f law) n â†’ WitnessNumberIs law n)
price-is-zero f surj law n =
  witness-invariant f surj law n , witness-invariant' f surj law n

------------------------------------------------------------------------
-- 4.  The number is realised: the three-standpoint system is exactly 3
--
-- `WitnessNumberIsUnbounded` gave the four facts; here they are
-- assembled into the definition, with the length bookkeeping done.
------------------------------------------------------------------------

three-is-three : WitnessNumberIs law 3
three-is-three = (triple , refl , three-refute) , least
  where
  least : (ys : List Three) â†’ length ys < 3 â†’ Â¬ Refutes law ys
  least []                 _  = no-empty-refutes
  least (a âˆ· [])           _  = no-single-refutes a
  least (a âˆ· b âˆ· [])       _  = no-pair-refutes a b
  least (a âˆ· b âˆ· c âˆ· ys)   lt =
    Empty.rec (Â¬-<-zero (pred-â‰¤-pred (pred-â‰¤-pred (pred-â‰¤-pred lt))))

------------------------------------------------------------------------
-- 5.  The price along reindexings, and between unrelated systems.
--
-- The aneknta thread asked what a transport between two nayas
-- costs.  `TransportPrice` proved every additive answer is a difference
-- of a potential; this exhibits a potential and shows its price is
-- identically zero along every surjective reindexing.  Between nayas so
-- related there is nothing to pay, and that is a theorem rather than an
-- observation.
--
-- Two decoder systems
-- NOT related by a reindexing can have different witness numbers â” 2
-- and 3 both occur â” so the potential is not constant, and the price
-- between such systems is not zero.
------------------------------------------------------------------------
