{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhatTheSubstrateArgumentCovers
--
-- Building on the one thing `DeflationaryTest` has that
-- this thread never reached â” its Â§8 â” by locating exactly what its
-- argument ranges over.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ARGUMENT, QUOTED FROM THE FILE
--
--     "in a `--safe`, postulate-free development, every inhabited âŠ is
--      a decision, because it was constructed.  There is no way to
--      write a term of `A âŠ B` without producing `inl a` or `inr b`."
--
-- and its internal anchor there is the iso `A âŠ Â A â‰ Dec A`, proved in
-- four lines.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED HERE
--
--   Â§1  the argument does not depend on `âŠ`.  `A â’ Dec A` holds for
--       EVERY type by `yes`, so "every inhabited X is a decision" is a
--       statement about inhabitation, not about sums.  Instantiated at
--       `Î`, which is where this thread's floor-is-a-search finding
--       lives: an inhabited Î is a decision, one line, same as for âŠ.
--
--   Â§2  and the argument delivers something STRICTLY STRONGER than
--       stability, which is why it cannot be traded for it.  `Stable âŠ`
--       holds while `âŠ` is empty, so stability never yields
--       inhabitation.  Exhibited, not argued.
--
--   Â§3  so the two deflations have different ranges, and Â§3 states them
--       as such: the substrate argument ranges over what is PROVED and
--       gives inhabitation; the stability argument ranges over what is
--       ÂÂ-provable and gives no inhabitation.  Between them sits
--       exactly the class of statements that are ÂÂ-provable and not
--       proved â” which is where `WhereTheTowerCanStillBeThree` Â§5's Î
--       question lives, and which by
--       `TheUnstableGroundCannotBeExhibited` can never be populated by
--       an exhibited example.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- SAID WITH ITS RESPECT, BECAUSE Â§3 COULD BE MISREAD AS A COMPLAINT
--
-- `DeflationaryTest` Â§10 concludes "the deflation is therefore total".
-- Nothing here contradicts that, and Â§3 must not be read as narrowing
-- it:
--
--   ààà¯à¾àà â” in the respect of barrier claims of the form `Â (Dec A)`,
--            the deflation is total, and its own `no-barrier-claim`
--            proves it;
--   ààà¯à¾àà â” in the respect of Î-shaped statements under a double
--            negation, nothing can be exhibited either â” but for a
--            different reason, `Â Â Stable A`, which is about what can
--            be shown rather than about what was built.
--
-- Two totalities with two grounds.  Collapsing them into one â” "it is
-- all deflated, for one reason" â” is the move aneknta blocks: they
-- agree in verdict and disagree in ground, and a verdict-level
-- agreement does not license a ground-level collapse.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- ONE OBSERVATION ABOUT THE PRIOR MODULE, OFFERED NOT RANKED
--
-- Â§1 shows Â§8's sentence holds of every type, not only of sums.  That
-- is not a defect in Â§8: Â§8 was answering a question about the
-- âŠ-shaped sites specifically, and answering the question asked is not
-- an error.  The generalisation is recorded because this thread needed
-- it at `Î`, not as a verdict on where it was first written.
------------------------------------------------------------------------

module WhatTheSubstrateArgumentCovers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Data.Sum using (_âŠŽ_)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Stable)

open import DeflationaryTest using (sumâ†’dec)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  The substrate argument's internal shadow, and that âŠ plays no
--     part in it
------------------------------------------------------------------------

-- every inhabited type is a decision.  One constructor.
inhabited-is-a-decision : {A : Type â„“} â†’ A â†’ Dec A
inhabited-is-a-decision = yes

-- at Î, which is where this thread's floor question sits.  The proof is
-- the same one; nothing about Î is used, exactly as nothing about âŠ was.
inhabitedÎ£-is-a-decision :
  {A : Type â„“} {B : A â†’ Type â„“'}
  â†’ (Î£[ a âˆˆ A ] B a) â†’ Dec (Î£[ a âˆˆ A ] B a)
inhabitedÎ£-is-a-decision = inhabited-is-a-decision

-- and therefore stable, through the prior module's own route.
inhabitedÎ£-is-stable :
  {A : Type â„“} {B : A â†’ Type â„“'}
  â†’ (Î£[ a âˆˆ A ] B a) â†’ Stable (Î£[ a âˆˆ A ] B a)
inhabitedÎ£-is-stable s _ = s

------------------------------------------------------------------------
-- 2.  Inhabitation is strictly stronger than stability
--
-- Exhibited at âŠ: stable and empty.  So no amount of stability ever
-- returns what the substrate argument returns.
------------------------------------------------------------------------

stableButEmpty : Stable âŠ¥ Ã— (Â¬ âŠ¥)
stableButEmpty = (Î» nn â†’ âŠ¥.rec (nn (Î» ()))) , (Î» ())

-- stated as the separation it is: there is a type that is stable and
-- has no element, so `Stable A â’ A` is not available in general.
stability-does-not-inhabit : Î£[ A âˆˆ Type ] (Stable A Ã— (Â¬ A))
stability-does-not-inhabit = âŠ¥ , stableButEmpty

------------------------------------------------------------------------
-- 3.  The two ranges
--
-- Nothing to prove; the content is the pair of scopes, and the objects
-- above are what fix them.  `sumâ’dec` is imported and re-stated here so
-- the anchor this file builds on is visible in its own import list
-- rather than only in prose.
------------------------------------------------------------------------

anchor-forward : {A : Type â„“} â†’ A âŠŽ (Â¬ A) â†’ Dec A
anchor-forward = sumâ†’dec
