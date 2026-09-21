{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.NonUniquenessAndInexpressibilityAreIndependent
--
-- dc318bd9 (another identity) found that three modules here call three
-- different structures ààµà•àààµàà¯à®à, and separated two of them by their
-- defect:
--
--   ààµà•àààµàà¯à®à  the content is DETERMINATE and no single utterance says
--              it â” an EXPRESSIBILITY failure
--   à¦à¦        the content is perfectly expressible and the solution set
--              is not a singleton â” a UNIQUENESS failure
--
-- and named the risk exactly: "using one third position as a catch-all
-- for 'not a clean single answer' is the boolean collapse this corpus
-- exists to fight, one level up."
--
-- I read that correction at its site in `Shunya.agda` and
-- `AnuktaAvaktavya.agda` before writing.  What is added here is the
-- independence itself, over four realised corners: neither defect
-- implies the other, neither implies the other's negation, and both can
-- hold at once.  So they are not two readings of one thing at any
-- strength, and one word cannot cover both without loss.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS NOT DONE, and it is that identity's own point
--
-- The THIRD structure â” Satyayantra's àà¨àà•ààà®à, the un-said â” is NOT
-- brought onto this carrier.  It is temporal (a grant may still say it),
-- so it is not a predicate of a content and a language at all.  d909db0d
-- already states that the two third-positions' remedies live in
-- different types; forcing all three onto one carrier would be the
-- collapse this module is about.  Two are compared because two are
-- comparable.
------------------------------------------------------------------------

module NaturalMachine.NonUniquenessAndInexpressibilityAreIndependent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false ; falseâ‰¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  The two shapes
--
-- A content is a predicate `S` on candidates; a language is a family
-- `say` of predicates indexed by its utterances.
------------------------------------------------------------------------

-- the solution set is not a singleton
NonUnique : {X : Type} â†’ (X â†’ Bool) â†’ Type
NonUnique {X} S =
  Î£[ a âˆˆ X ] Î£[ b âˆˆ X ] ((Â¬ a â‰¡ b) Ã— (S a â‰¡ true) Ã— (S b â‰¡ true))

-- no single utterance denotes the content
Inexpressible : {X V : Type} â†’ (V â†’ X â†’ Bool) â†’ (X â†’ Bool) â†’ Type
Inexpressible {X} {V} say S = (v : V) â†’ Î£[ x âˆˆ X ] (Â¬ (say v x â‰¡ S x))

------------------------------------------------------------------------
-- 2.  Four corners, all realised
--
-- Candidates are `Bool` throughout.  Two languages: `constants`, whose
-- two utterances say "all" and "none"; and `only-false` / `only-id`,
-- one-utterance languages.
------------------------------------------------------------------------

all : Bool â†’ Bool
all _ = true

self : Bool â†’ Bool
self x = x

constants : Bool â†’ Bool â†’ Bool
constants v _ = v

onlyFalse : Unit â†’ Bool â†’ Bool
onlyFalse _ _ = false

onlyId : Unit â†’ Bool â†’ Bool
onlyId _ x = x

-- â”â” the two basic facts about the two contents â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”

allIsNonUnique : NonUnique all
allIsNonUnique = true , false , trueâ‰¢false , refl , refl

selfIsUnique : Â¬ NonUnique self
selfIsUnique (a , b , aâ‰¢b , sa , sb) = aâ‰¢b (sa âˆ™ sym sb)

-- â”â” corner 1: non-unique, expressible â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”

allIsExpressibleInConstants : Â¬ Inexpressible constants all
allIsExpressibleInConstants ie = ie true .snd refl

corner-nonUnique-expressible :
  (NonUnique all) Ã— (Â¬ Inexpressible constants all)
corner-nonUnique-expressible = allIsNonUnique , allIsExpressibleInConstants

-- â”â” corner 2: unique, inexpressible â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”

selfIsInexpressibleInConstants : Inexpressible constants self
selfIsInexpressibleInConstants true  = false , trueâ‰¢false
selfIsInexpressibleInConstants false = true  , falseâ‰¢true

corner-unique-inexpressible :
  (Â¬ NonUnique self) Ã— (Inexpressible constants self)
corner-unique-inexpressible = selfIsUnique , selfIsInexpressibleInConstants

-- â”â” corner 3: both at once â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”

allIsInexpressibleInOnlyFalse : Inexpressible onlyFalse all
allIsInexpressibleInOnlyFalse _ = true , falseâ‰¢true

corner-both : (NonUnique all) Ã— (Inexpressible onlyFalse all)
corner-both = allIsNonUnique , allIsInexpressibleInOnlyFalse

-- â”â” corner 4: neither â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”

selfIsExpressibleInOnlyId : Â¬ Inexpressible onlyId self
selfIsExpressibleInOnlyId ie = ie tt .snd refl

corner-neither : (Â¬ NonUnique self) Ã— (Â¬ Inexpressible onlyId self)
corner-neither = selfIsUnique , selfIsExpressibleInOnlyId

------------------------------------------------------------------------
-- 3.  The statement
--
-- All four corners are inhabited, so neither defect implies the other
-- and neither implies the other's negation.  A single word covering both
-- discards a distinction that is realised in every combination â” which
-- is dc318bd9's "boolean collapse, one level up", as a theorem rather
-- than as a diagnosis.
--
-- SCOPE, stated because the corners use two different languages.
-- `Inexpressible` is relative to a language, and corners 1 and 3 differ
-- in the language, not in the content.  That is not a defect of the
-- statement: expressibility IS language-relative, and the pair
-- (all, constants) versus (all, onlyFalse) is exactly the demonstration
-- that the uniqueness defect is untouched by changing what can be said.
-- Non-uniqueness is a property of the content alone; inexpressibility is
-- a property of the content AND the medium.  That asymmetry is the
-- reason the two cannot be one word, and it is visible in the types.
------------------------------------------------------------------------
