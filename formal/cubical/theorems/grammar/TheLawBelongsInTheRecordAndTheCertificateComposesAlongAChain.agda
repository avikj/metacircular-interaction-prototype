{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheLawBelongsInTheRecordAndTheCertificateComposesAlongAChain
--
-- `ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem` closed
-- with its own next step named and deliberately not taken:
--
--   "THIS MODULE IS NOT AMENDED.  The four-component Î above is
--    unchanged and `composeCertified` still composes a bare function;
--    adding the law to the record is this module's own next step and is
--    deliberately not taken in the same cycle that discovered the gap."
--
-- The step is taken here, in a new module, leaving that one's Î
-- untouched.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   LCertified d e      FIVE components: boundary semantics preserved,
--                       cost strictly improved, a migration, THE LAW
--                       that the migration preserves the observation,
--                       provenance
--   composeLCertified   the five-component certificate composes
--   Chain d e           a NON-EMPTY sequence of certified rewrites
--   chainCertified      a whole chain is one certificate â” so the five
--                       components compose along an arbitrary rewrite
--                       sequence, not only across two steps
--   chainMovesNoObservation
--                       after ANY chain, the migrated state is observed
--                       exactly as the original was
--   chainTransportsEveryInvariant
--                       and so is every function of the observation
--   chainImproves       a chain strictly improves the cost
--   noSelfChain         hence no chain returns to its start
--   theLawIsIndependentOfTheOtherFour
--                       a pair that satisfies ALL FOUR of the earlier
--                       module's components and FAILS the law
--
-- **THE LAST ONE IS WHY THIS IS A STRENGTHENING AND NOT A
-- REPACKAGING.**  `MigrationNeedsALawAndTheLawIsNotFree` showed that
-- SOME function fails the law â” which leaves open the cheap reading
-- that the other four components already force it, so that adding it
-- costs nothing.  They do not: the witness below is a genuine element
-- of the earlier `Certified` (its semantics path is `refl`, its cost
-- strictly improves, it migrates, it carries provenance) whose
-- migration is `not`.  So the four-component record admits certificates
-- whose migration destroys every observation, and the fifth component
-- is a real constraint on which rewrites are certifiable.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- ON `Chain` BEING NON-EMPTY, which is a structural fact and not an
-- oversight.  `noSelfChain` says no chain runs from a system to itself.
-- If `Chain` had an empty constructor that would be false â” the empty
-- chain at `d` is a `Chain d d` â” so certified rewrites form a
-- SEMICATEGORY, not a category: composition is associative and total,
-- and there is no identity.  Strict cost improvement is exactly what
-- removes the identities.  (Associativity is not proved here; nothing
-- downstream uses it.)
--
-- NO NOVELTY.  Simulation/refinement squares, their composition, and
-- the fact that a strict order has no loops are all standard; the
-- content is again only the count â” the law is the component that does
-- NOT come for free and does NOT follow from the others.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheLawBelongsInTheRecordAndTheCertificateComposesAlongAChain where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order using (zero-â‰¤ ; Â¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; _++_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; falseâ‰¢true)
open import Cubical.Relation.Nullary using (Â¬_)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates)
open import ANonEmptyArchiveHasANonEmptyStratum
  using (âŠ-irrefl ; âŠ-trans)
open import MigrationNeedsALawAndTheLawIsNotFree
  using (Lawful ; composeLawful)
open import ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem
  using (Certified)

------------------------------------------------------------------------
-- 1.  The five-component certificate
------------------------------------------------------------------------

module _ {Sys B O Prov : Type}
         (sem  : Sys â†’ B)
         (cost : Sys â†’ List â„•)
         (M    : Sys â†’ Type)
         (obs  : (d : Sys) â†’ M d â†’ O)
  where

  LCertified : Sys â†’ Sys â†’ Type
  LCertified d e =
    Î£[ mg âˆˆ (M d â†’ M e) ]
        (sem e â‰¡ sem d)
      Ã— (StrictlyDominates (cost d) (cost e))
      Ã— (Lawful M obs d e mg)
      Ã— (List Prov)

  mig : {d e : Sys} â†’ LCertified d e â†’ (M d â†’ M e)
  mig c = fst c

  improves : {d e : Sys} â†’ LCertified d e â†’ StrictlyDominates (cost d) (cost e)
  improves c = fst (snd (snd c))

  law : {d e : Sys} (c : LCertified d e) â†’ Lawful M obs d e (mig c)
  law c = fst (snd (snd (snd c)))

  composeLCertified :
    (d e f : Sys) â†’ LCertified d e â†’ LCertified e f â†’ LCertified d f
  composeLCertified d e f (mgâ‚ , sde , impâ‚ , lawâ‚ , provâ‚)
                          (mgâ‚‚ , sef , impâ‚‚ , lawâ‚‚ , provâ‚‚) =
      (Î» m â†’ mgâ‚‚ (mgâ‚ m))
    , sef âˆ™ sde
    , âŠ-trans (cost d) (cost e) (cost f) impâ‚ impâ‚‚
    , composeLawful M obs d e f mgâ‚ mgâ‚‚ lawâ‚ lawâ‚‚
    , provâ‚ ++ provâ‚‚

  ------------------------------------------------------------------
  -- 2.  A non-empty chain of rewrites is one certificate
  ------------------------------------------------------------------

  data Chain : Sys â†’ Sys â†’ Type where
    one : {d e : Sys} â†’ LCertified d e â†’ Chain d e
    _â—…_ : {d e f : Sys} â†’ LCertified d e â†’ Chain e f â†’ Chain d f

  chainCertified : {d e : Sys} â†’ Chain d e â†’ LCertified d e
  chainCertified (one c)  = c
  chainCertified (c â—… cs) = composeLCertified _ _ _ c (chainCertified cs)

  chainMovesNoObservation :
    {d e : Sys} (c : Chain d e) (m : M d)
    â†’ obs e (mig (chainCertified c) m) â‰¡ obs d m
  chainMovesNoObservation c m = law (chainCertified c) m

  chainTransportsEveryInvariant :
    {C : Type} (g : O â†’ C) {d e : Sys} (c : Chain d e) (m : M d)
    â†’ g (obs e (mig (chainCertified c) m)) â‰¡ g (obs d m)
  chainTransportsEveryInvariant g c m = cong g (chainMovesNoObservation c m)

  chainImproves :
    {d e : Sys} (c : Chain d e) â†’ StrictlyDominates (cost d) (cost e)
  chainImproves c = improves (chainCertified c)

  noSelfChain : (d : Sys) â†’ Â¬ Chain d d
  noSelfChain d c = âŠ-irrefl (cost d) (chainImproves c)

------------------------------------------------------------------------
-- 3.  The law does not follow from the other four
--
-- Two systems, both with state space `Bool`, observed by the identity,
-- with a constant boundary semantics and a strictly improving cost.
-- `not` migrates the state and satisfies every component of the earlier
-- `Certified`; it destroys the observation.
------------------------------------------------------------------------

semB : Bool â†’ Unit
semB _ = tt

costB : Bool â†’ List â„•
costB true  = 0 âˆ· []
costB false = 1 âˆ· []

stateB : Bool â†’ Type
stateB _ = Bool

obsB : (d : Bool) â†’ stateB d â†’ Bool
obsB _ b = b

costImproves : StrictlyDominates (costB true) (costB false)
costImproves = (zero-â‰¤ , tt) , Î» z â†’ Â¬-<-zero (fst z)

anUnlawfulFourComponentCertificate : Certified {Prov = â„•} semB costB stateB true false
anUnlawfulFourComponentCertificate = refl , costImproves , not , []

theLawIsIndependentOfTheOtherFour :
  Â¬ (Lawful stateB obsB true false not)
theLawIsIndependentOfTheOtherFour l = falseâ‰¢true (l true)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  `LCertified` is unchanged and this module is not
-- amended.  Recorded here only because this record is the one the
-- later work compares against:
--
-- `TheReachableLawDoesNotComposeWithoutPreservation`
-- shows that relativising the fifth component to reachable states
-- costs its free composition, and
-- `TheSixthComponentIsFreeToCarryAndIsWhatMakesTheFifthCompose`
-- adds the sixth component that buys it back â” with
-- `aFullFiveComponentCertificateThatDoesNotPreserveTheInvariant`, an
-- element of the `LCertified` DEFINED ABOVE that fails only the new
-- component.  So this five-component record still admits certificates
-- whose migration leaves the invariant, exactly as the four-component
-- one admits certificates whose migration destroys the observation.
--
-- The chain construction above is NOT repeated there: the same
-- induction goes through verbatim with `composeRCertified` in place of
-- `composeLCertified`.
------------------------------------------------------------------------
