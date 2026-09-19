{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDeflationaryTestWasAlreadyRun
--
-- An audit of this thread's last several cycles against a module that
-- was in the corpus, and in the latch this thread typechecks every
-- cycle, the whole time.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT HAPPENED
--
-- "The deflationary test" has been a named live thread in every
-- heartbeat of this session.  `DeflationaryTest` has
-- been in `RootsThreadLatch` for longer than that.  It was never
-- opened.  Its Â§4 is
--
--     Î -stable, â’-stable, —-stable, Â-always-stable
--
-- and its Â§5 instantiates them at the corpus's obstruction shapes.
-- That is `WhyTheSamePriceKeepsAppearing` Â§1 and Â§3, written again.
--
-- The failure is not that a lemma got proved twice.  It is that the
-- thread name and the module name were the same word for many cycles
-- and no one grepped one against the other.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED HERE
--
-- Not new mathematics.  Â§1 makes the duplication CHECKED rather than
-- asserted: each of this thread's closure lemmas is `refl`-equal to the
-- prior module's, because they are the same term.  A rediscovery that
-- typechecks as `refl` against its own prior art is not a matter of
-- opinion about who said what.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE LEDGER, EACH LINE READ FROM BOTH FILES
--
-- REDISCOVERED â” prior art is `DeflationaryTest`:
--
--   `WhyTheSamePriceKeepsAppearing` Â§1  â  its Â§4, term for term (Â§1
--       below).
--   `WhyTheSamePriceKeepsAppearing` Â§3  â  its Â§5, which already
--       instantiates the closure lemmas at obstruction shapes.
--   `WhyTheSamePriceKeepsAppearing` Â§2  â  its Â§4 heading and Â§8: it
--       already states stability does not pass through `âŠ`.
--   `TheDomainThatIsAnAbsence`'s `ÂÂDec`  â  its `no-barrier-claim`,
--       `Â (BarrierClaim A)` with `BarrierClaim A = Â (Dec A)`.
--   `TheDeflationaryTestIsVacuous`'s central point  â  its Â§7: "the
--       stabilisation level measures nothing".  My Â§4 there â” that
--       `Stable âŠ` and `Stable Unit` both hold, so stability
--       discriminates nothing â” is a sharper form of the same claim and
--       not an independent one.
--
-- NOT IN THE PRIOR MODULE, checked by reading its signature list:
--
--   `tripleNegationâ‰` as an EQUIVALENCE.  `DeflationaryTest` proves the
--       two implications as a product; the equivalence needs `isPropÂ`
--       and is not there.
--   `noMiddleCollapse : Â ((Â A) â‰ (Â Â A))`.
--   `(A â‰ Â Â A) âŸº Stable A` for propositions.
--   `Stable-â”`, stability along a bare logical equivalence.
--   the whole ground/exclusion/shadow development
--       (`ExclusionRecoversGroundAtAPrice`), which shares no statement
--       with it.
--   `A â’ isContr (Â A â’ Y)` and `Â A â’ ((Â A â’ Y) â‰ Y)`.
--
-- CLOSELY RELATED, and I will not call it independent:
--   `Â Â Stable A` (`TheUnstableGroundCannotBeExhibited` Â§1) follows
--   from its `no-barrier-claim` in two lines, since `Dec A â’ Stable A`.
--   It was proved here without noticing that.
--
-- AND WHAT THE PRIOR MODULE HAS THAT THIS THREAD NEVER REACHED, which
-- belongs in the same ledger:
--   its Â§8 â” in a `--safe`, postulate-free development every inhabited
--   `âŠ` is a decision, since there is no way to write a term of `A âŠ B`
--   without producing `inl` or `inr`.  So the âŠ-sites close for a
--   reason about the SUBSTRATE, not about the types.  Nothing in this
--   thread's âŠ/Î discussion gets near that.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE MECHANISM, PROPOSED AND NOT BUILT
--
-- This corpus's standing answer to a repeated violation is a mechanism
-- that fires at the moment of the act, not a paragraph.  The check that
-- would have caught this is one line and needs no judgement:
--
--     before writing a module for thread T, grep the latch's import
--     list for T's own name.
--
-- It is not added to `.claude/hooks/source-coverage.sh` here, because
-- hook changes are the owner's to approve and a previous design of mine
-- was rejected for being built before it was agreed.  It is written
-- down as a proposal, at the site where its absence cost something.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- ONE THING THIS IS NOT
--
-- Not a claim that the rediscovered modules should be deleted.  They
-- are marked, and the marks point here.  A record that deletes its own
-- errors is not a record â” and the duplicated proofs are now the
-- evidence for Â§1, which is the only reason this file can prove
-- anything at all.
--
-- Nor is it a claim about which module is better.  There is no scale
-- here.  One was written earlier and one later, and the later one did
-- not read the earlier: that is a fact about the process, and the
-- process is what this file is about.
------------------------------------------------------------------------

module TheDeflationaryTestWasAlreadyRun where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; Stable)

open import DeflationaryTest
  using (Â¬-always-stable ; Î -stable ; â†’-stable ; Ã—-stable
        ; no-barrier-claim ; BarrierClaim)
open import WhyTheSamePriceKeepsAppearing
  using (stableÂ¬ ; stableÎ  ; stableâ†’ ; stableÃ—)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  The duplication, checked
--
-- Each pair is the same term.  `refl` is the whole proof, which is the
-- strongest available statement that nothing new was added.
------------------------------------------------------------------------

dup-Â¬ : {A : Type â„“} â†’ stableÂ¬ {â„“} {A} â‰¡ Â¬-always-stable A
dup-Â¬ = refl

dup-Î  : {A : Type â„“} {B : A â†’ Type â„“'}
      â†’ stableÎ  {â„“} {â„“'} {A} {B} â‰¡ Î -stable {â„“} {â„“'} {A} {B}
dup-Î  = refl

dup-â†’ : {A : Type â„“} {B : Type â„“'}
      â†’ stableâ†’ {â„“} {â„“'} {A} {B} â‰¡ â†’-stable {â„“} {â„“'} {A} {B}
dup-â†’ = refl

dup-Ã— : {A : Type â„“} {B : Type â„“'}
      â†’ stableÃ— {â„“} {â„“'} {A} {B} â‰¡ Ã—-stable {â„“} {â„“'} {A} {B}
dup-Ã— = refl

------------------------------------------------------------------------
-- 2.  And the one this thread proved without noticing it was a
--     two-line corollary of the prior module
--
-- `no-barrier-claim` says `Â (Â (Dec A))`.  Since a decision gives
-- stability, a refutation of stability refutes decidability, so
-- `Â Â Stable A` follows.  `TheUnstableGroundCannotBeExhibited` Â§1
-- proves it directly instead; the direct proof is not wrong, it is
-- unaware.
------------------------------------------------------------------------

Â¬Â¬Stable-fromPriorArt :
  {A : Type â„“} â†’ (Dec A â†’ Stable A) â†’ Â¬ Â¬ Stable A
Â¬Â¬Stable-fromPriorArt {A = A} dâ†’s ns =
  no-barrier-claim A (Î» dec â†’ ns (dâ†’s dec))
