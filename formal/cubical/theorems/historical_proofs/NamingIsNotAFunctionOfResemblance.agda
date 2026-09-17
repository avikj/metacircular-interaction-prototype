{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NamingIsNotAFunctionOfResemblance
--
-- `machine/Upamana.hs` states an operative test and builds its whole
-- design on it.  The test's core is checkable, and this is it: no
-- invariant of the resemblance relation computes the naming.  So a
-- similarity cannot be DERIVED into a naming ‚î it has to come from
-- somewhere else, which is exactly why that module keeps its stated
-- similarities as INPUT and quarantines the derived ones.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE SCHOOLS, NAMED BEFORE THEIR TERMS, AND THE DISPUTE LEFT OPEN
--
-- NYYA (Gautama, *Nyyastra* 1.1.6; Vtsyyana's *Nyyabhya* on it,
-- c. 400‚ì450 CE) holds upamna ‚î knowledge from similarity to what is
-- already well known ‚î to be a separate prama, and Vtsyyana fixes
-- its result as *saj-saji-sambandha-pratipatti*: apprehension of
-- the relation between a NAME and its BEARER.  The argument for
-- irreducibility, sharpened by Gagea (*Tattvacintmai*,
-- upamna-khaa, c. 1325): to INFER "this is a gavaya" you would need
-- the pervasion "whatever resembles a cow thus is denoted by 'gavaya'",
-- which is precisely what is being learned ‚î the pervasion is the
-- conclusion and so cannot be the premise.
--
-- BUDDHIST (Dignga, *Pramasamuccaya* 1.2, c. 500: two pramas only;
-- Dharmakrti, *Pramavrttika*) DENIES the separateness and analyses
-- upamna into testimony, memory, perception and inference.  MMS
-- (abara; Kumrila, *lokavrttika*, upamna-pariccheda, c. 650)
-- accepts it but REVERSES it ‚î the new cognition is of the remembered
-- cow.  Vaieika and Skhya reduce it to anumna.
--
-- ‚ò WHAT ¬ß2 DOES AND DOES NOT SETTLE, and this is the whole point.
-- It shows the naming is not a function of the resemblance.  That is
-- what BOTH sides need and NEITHER side's conclusion.  The Naiyyika
-- reads it as: therefore a distinct instrument, sdya-jna, supplies
-- the naming.  Dignga reads it as: therefore the forester's SENTENCE
-- supplies it ‚î abda plus memory, no new prama.  The theorem is
-- neutral between them because it only says the naming comes from
-- OUTSIDE the resemblance, and both accounts agree on that and disagree
-- on what the outside is.  Agreement in verdict does not license
-- collapsing the grounds, so neither is adjudicated here.
--
-- SOURCING LIMIT, stated and not evaded.  The *Nyyastra*, the
-- *Nyyabhya*, the *Tattvacintmai*, the *Pramasamuccaya* and the
-- *lokavrttika* have NOT been opened by me.  Every attribution above
-- is carried from `machine/Upamana.hs`, which sources and dates them in
-- its ¬ß0 and which I read this cycle.  Verse-level sourcing OWED AND NOT
-- CLAIMED.
--
-- ¬ß6 empirical control (whether what it transports lies inside the
-- engine's enumeration reach); that is its measurement and its result,
-- untouched here.  Not that resemblance is useless: ¬ß2 says only that it
-- does not DETERMINE the naming.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NamingIsNotAFunctionOfResemblance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  A situation: what resembles the exemplar, and what the word names
------------------------------------------------------------------------

Pred : Type‚ÇÅ
Pred = Bool ‚Üí Type

record Situation : Type‚ÇÅ where
  constructor situation
  field
    resembles : Pred      -- sƒÅd·πõ≈õya: what looks like the well-known thing
    named     : Pred      -- sa·πÉj√±ƒÅ-sa·πÉj√±i: what the word denotes

open Situation public

-- the pervasion an inference would need, and the fact that having it IS
-- having the conclusion on the resemblance class: the derivation is the
-- identity, so it moves no information.  (Checked, so that "it is the
-- premise again" is a term and not a remark.)
Vyapti : Situation ‚Üí Type
Vyapti S = (x : Bool) ‚Üí resembles S x ‚Üí named S x

theDerivationIsTheIdentity :
  (S : Situation) (v : Vyapti S) ‚Üí (Œª x r ‚Üí v x r) ‚â° v
theDerivationIsTheIdentity S v = refl

------------------------------------------------------------------------
-- 2.  THE COLLISION.  Same resemblance, different naming.
--
-- Everything resembles the exemplar in both situations.  In the first
-- the word names everything; in the second it names nothing.  No
-- invariant of `resembles` can tell them apart, and `named` does.
------------------------------------------------------------------------

everything nothing : Pred
everything _ = Unit
nothing    _ = ‚ä•

allNamed allUnnamed : Situation
allNamed   = situation everything everything
allUnnamed = situation everything nothing

sameResemblance : resembles allNamed ‚â° resembles allUnnamed
sameResemblance = refl

differentNaming : ¬¨ (named allNamed ‚â° named allUnnamed)
differentNaming p = transport (funExt‚Åª p true) tt

namingCollision :
  Œ£[ S ‚àà Situation ] Œ£[ T ‚àà Situation ]
    ((resembles S ‚â° resembles T) √ó (¬¨ (named S ‚â° named T)))
namingCollision = allNamed , allUnnamed , sameResemblance , differentNaming

-- routed through the corpus's standing lemma rather than reargued:
-- eighth site of `TranscriptDescent.collisionObstructsDecoder`.
namingDoesNotFactorThroughResemblance :
  ¬¨ FactorsThrough resembles named
namingDoesNotFactorThroughResemblance =
  collisionObstructsDecoder resembles named {allNamed} {allUnnamed}
    sameResemblance differentNaming

------------------------------------------------------------------------
-- 3.  What this earns for `machine/Upamana.hs`
--
-- That module quarantines DERIVED similarities from STATED ones and says
-- the quarantine is what stops anumna being laundered as upamna.  ¬ß2
-- is why the quarantine is not bookkeeping: a naming is not recoverable
-- from resemblance data by any function whatever, so a derived
-- similarity cannot become a naming without something else being
-- supplied.  Whether that something is a distinct prama (Nyya) or
-- testimony plus memory (Dignga) is not decided here and ¬ß0 says why.
--
-- What ¬ß2 does NOT give that module: any evidence about its ¬ß6 control ‚î
-- whether what it transports already lies inside the engine's own
-- enumeration reach.  That is an empirical question about a particular
-- engine at particular knobs, and it is that module's to answer.
------------------------------------------------------------------------
