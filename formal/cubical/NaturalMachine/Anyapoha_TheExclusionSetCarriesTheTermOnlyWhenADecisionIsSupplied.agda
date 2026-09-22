{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Anyapoha_TheExclusionSetCarriesTheTermOnlyWhenADecisionIsSupplied
--
-- àà¨àà¯à¾àà‹à Â anya-apoha â” exclusion-of-the-other.
--
-- SOURCES, AND THE GRADE OF EACH.
--
-- Bauddha side.  Dignga, *Pramasamuccaya* (c. 480â“540), chapter on
-- *apoha*: the content of a general term is the exclusion of what the
-- term is not, and not a shared positive universal.  Dharmakrti,
-- *Pramavrttika* (7th c.), develops apoha and answers the charge that
-- a negative definition is empty.  ntarakita, *Tattvasagraha*
-- (8th c.), with Kamalala's *Pajik*, carries the *abdrtha*
-- examination.
--
-- Naiyyika side, named as a rival school and not as part of one
-- toolkit.  Nyya holds that every absence (*abhva*) requires a
-- counterpositive (*pratiyogin*), and that the counterpositive is a
-- positive entity; Uddyotakara (*Nyyavrttika*, c. 6thâ“7th c.) and
-- Jayanta Bhaa (*Nyyamajar*, 9th c.) press against apoha the charge
-- that excluding non-cows presupposes cow, so the definition is circular
-- or else vacuous.
--
-- The modelling step â” reading a
-- term's *apoha* as the family of things it excludes, indexed by the
-- SAME domain the terms live in â” is what makes the
-- circularity charge expressible at all.  Â§7 says what each school would
-- say back.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   apoha-sound      S i j â’ SameExcl S i j          needs sym + trans
--   apoha-ÂÂ         SameExcl S i j â’ Â Â S i j      needs refl ALONE
--   apoha-complete   Dec S â’ SameExcl S i j â’ S i j  needs refl + a decision
--
--   apohaForEquivalencesâ’DNE
--       the completeness statement, asserted for every REFLEXIVE,
--       SYMMETRIC and TRANSITIVE relation, yields double negation
--       elimination.  So being an equivalence relation is not enough,
--       and the missing ingredient is exactly the decision.
--
--   decidingR-is-decidingP
--       deciding the counterexample relation on its TWO-ELEMENT carrier
--       is deciding the arbitrary proposition it was built from.  The
--       carrier is finite; the relation is not decidable; hand
--       computation of the cases IS the decision that is at issue.
--
--   soundnessFailsOnSoundings / transitivityFailsOnSoundings
--       on `Pythagoras_RatioIsTheInvariantAndLengthIsThePresentation`'s
--       `SameInterval` over â• — â•, cross-multiplication is not
--       transitive â” (1,0), (0,0), (0,1) â” and apoha SOUNDNESS fails
--       with it, while COMPLETENESS survives, because completeness never
--       used transitivity.
--
--   theIntervalIsFixedByItsExclusions
--       completeness, instantiated at `SameInterval` over all of â• — â•.
--
--   Â§6:  with the second string length made positive, sym, trans, sound
--        and complete all hold, so on `Soundingâº` the exclusion set IS
--        the interval, both directions.
--
-- PRIOR ART IN THIS REPOSITORY, cited rather than re-landed.
--   `Swarm.S04Apoha` / `Swarm.S04ApohaFiniteCompletion` â” witnessed
--     exclusion vs negated indistinguishability over an INDEXED
--     observable family; the gap there is exactly MP.
--   `NaturalMachine.FormationRelativeMinimality`, Â§3
--     `local-extractor-implies-DNE` â” the taboo technique (build a
--     control from an arbitrary P, read off DNE) is that module's;
--     only the object it is applied to here is new.
--   `ApohaParyaya_WhetherConceptualContentIsNegativeIsWhatTheTwoSchools-
--     ActuallyDispute` â” Bauddha against Jaina on standpoints.  The
--     dispute staged here is Bauddha against Naiyyika on negation, a
--     different pair and a different charge.
--   `RnaDhana_*`: over â• a sign condition is free, so a
--     richer carrier hides a condition rather than discharging it.  Â§6
--     below is the same shape and is flagged as such: moving from â• — â•
--     to a positive second coordinate does not discharge transitivity,
--     it supplies the cancellation that was missing.
------------------------------------------------------------------------

module NaturalMachine.Anyapoha_TheExclusionSetCarriesTheTermOnlyWhenADecisionIsSupplied where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _Â·_ ; snotz)
open import Cubical.Data.Nat.Properties using (discreteâ„• ; Â·-assoc ; Â·-comm ; inj-Â·sm)
open import Cubical.Data.Bool using (Bool ; false ; true ; falseâ‰¢true)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_âŠ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import NaturalMachine.Pythagoras_RatioIsTheInvariantAndLengthIsThePresentation
  using (Sounding ; SameInterval ; SameInterval-refl)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- 1.  The apoha of a term, and when two terms have the same apoha.
--
--     `Excl S i` is the family of things i excludes.  `SameExcl S i j`
--     is the statement that i and j exclude exactly the same things â”
--     the whole of what a Digngan account of the term has to offer,
--     with no positive universal anywhere in it.
--
--     The exclusion range is the SAME domain the terms live in.  That is
--     the modelling step, and it is the one the Naiyyika charge is
--     about: the account defines i by reference to the relation it is
--     itself an argument of.
------------------------------------------------------------------------

Excl : {A : Type â„“} â†’ (A â†’ A â†’ Type â„“) â†’ A â†’ A â†’ Type â„“
Excl S i k = Â¬ S i k

SameExcl : {A : Type â„“} â†’ (A â†’ A â†’ Type â„“) â†’ A â†’ A â†’ Type â„“
SameExcl {A = A} S i j =
  (k : A) â†’ (Excl S i k â†’ Excl S j k) Ã— (Excl S j k â†’ Excl S i k)

------------------------------------------------------------------------
-- 2.  Soundness: co-referring terms exclude alike.
--
--     This is the direction that needs the positive structure â” symmetry
--     and transitivity.  Nothing in it is free.
------------------------------------------------------------------------

apoha-sound :
  {A : Type â„“} (S : A â†’ A â†’ Type â„“)
  â†’ ((a b : A) â†’ S a b â†’ S b a)
  â†’ ((a b c : A) â†’ S a b â†’ S b c â†’ S a c)
  â†’ (i j : A) â†’ S i j â†’ SameExcl S i j
apoha-sound S symS transS i j sij k =
    (Î» ni sjk â†’ ni (transS i j k sij sjk))
  , (Î» nj sik â†’ nj (transS j i k (symS i j sij) sik))

------------------------------------------------------------------------
-- 3.  The negative definition, on its own, delivers exactly the double
--     negation â” and it needs only that nothing excludes itself.
--
--     This is the Bauddha's minimum and the Naiyyika's maximum in one
--     line.  Reflexivity is all the positive content the argument uses;
--     what it buys is Â Â S, not S.
------------------------------------------------------------------------

apoha-Â¬Â¬ :
  {A : Type â„“} (S : A â†’ A â†’ Type â„“)
  â†’ ((a : A) â†’ S a a)
  â†’ (i j : A) â†’ SameExcl S i j â†’ Â¬ Â¬ S i j
apoha-Â¬Â¬ S reflS i j se nij = fst (se j) nij (reflS j)

------------------------------------------------------------------------
-- 4.  Completeness, once a decision is supplied.
--
--     Reflexivity plus a decision procedure.  No symmetry, no
--     transitivity, no universal.
------------------------------------------------------------------------

apoha-complete :
  {A : Type â„“} (S : A â†’ A â†’ Type â„“)
  â†’ ((a : A) â†’ S a a)
  â†’ ((a b : A) â†’ Dec (S a b))
  â†’ (i j : A) â†’ SameExcl S i j â†’ S i j
apoha-complete S reflS decS i j se with decS i j
... | yes s = s
... | no  n = âŠ¥.rec (apoha-Â¬Â¬ S reflS i j se n)

------------------------------------------------------------------------
-- 5.  REFUTATION 1.
--
--     CLAIM A: `apoha-complete` needs
--     only that S is an equivalence relation, because exclusion sets are
--     then unions of classes and equal exclusion sets force equal
--     classes.
--
--     CLAIM A IS FALSE, and the kill is below.  The relation
--     `R a b = (a â‰¡ b) âŠ P` on Bool is reflexive, symmetric and
--     transitive for every P whatsoever.  If Claim A held, P would
--     follow from Â Â P for every P.
--
--     So the Naiyyika charge lands, in this exact form: the negative
--     account is complete only when something is supplied that is not in
--     it.  And the Bauddha reply also lands, in this exact form: what
--     has to be supplied is a DECISION, not a positive universal.
------------------------------------------------------------------------

module Taboo (P : Typeâ‚€) where

  R : Bool â†’ Bool â†’ Typeâ‚€
  R a b = (a â‰¡ b) âŠ P

  R-refl : (a : Bool) â†’ R a a
  R-refl a = inl refl

  R-sym : (a b : Bool) â†’ R a b â†’ R b a
  R-sym a b (inl p) = inl (sym p)
  R-sym a b (inr x) = inr x

  R-trans : (a b c : Bool) â†’ R a b â†’ R b c â†’ R a c
  R-trans a b c (inl p) (inl q) = inl (p âˆ™ q)
  R-trans a b c (inl p) (inr y) = inr y
  R-trans a b c (inr x) _       = inr x

  -- On the off-diagonal the path is absurd, so R IS P there.
  R-offâ†’P : R false true â†’ P
  R-offâ†’P (inl p) = âŠ¥.rec (falseâ‰¢true p)
  R-offâ†’P (inr x) = x

  -- Â Â P is already enough to equalise the two exclusion sets.
  Â¬Â¬Pâ†’sameExcl : Â¬ Â¬ P â†’ SameExcl R false true
  Â¬Â¬Pâ†’sameExcl nnp false =
      (Î» h â†’ âŠ¥.rec (h (inl refl)))
    , (Î» h â†’ âŠ¥.rec (nnp (Î» p â†’ h (inr p))))
  Â¬Â¬Pâ†’sameExcl nnp true  =
      (Î» h â†’ âŠ¥.rec (nnp (Î» p â†’ h (inr p))))
    , (Î» h â†’ âŠ¥.rec (h (inl refl)))

  -- THE GAUSS POINT, exact: the carrier has two elements, and deciding
  -- the relation on it is deciding P.  A hundred hand-computed cases
  -- cannot exhibit this counterexample, because computing a case IS
  -- deciding the relation, which is the very thing in dispute.
  decidingR-is-decidingP : ((a b : Bool) â†’ Dec (R a b)) â†’ Dec P
  decidingR-is-decidingP d with d false true
  ... | yes r = yes (R-offâ†’P r)
  ... | no  n = no (Î» p â†’ n (inr p))

ApohaCompleteForEquivalences : Typeâ‚
ApohaCompleteForEquivalences =
  (A : Typeâ‚€) (S : A â†’ A â†’ Typeâ‚€)
  â†’ ((a : A) â†’ S a a)
  â†’ ((a b : A) â†’ S a b â†’ S b a)
  â†’ ((a b c : A) â†’ S a b â†’ S b c â†’ S a c)
  â†’ (i j : A) â†’ SameExcl S i j â†’ S i j

-- CLAIM A, killed.
apohaForEquivalencesâ†’DNE :
  ApohaCompleteForEquivalences â†’ (P : Typeâ‚€) â†’ Â¬ Â¬ P â†’ P
apohaForEquivalencesâ†’DNE ac P nnp =
  Taboo.R-offâ†’P P
    (ac Bool (Taboo.R P) (Taboo.R-refl P) (Taboo.R-sym P) (Taboo.R-trans P)
       false true (Taboo.Â¬Â¬Pâ†’sameExcl P nnp))

------------------------------------------------------------------------
-- 6.  The drawn module, and REFUTATION 2.
--
--     CLAIM B: `SameInterval` over â• — â• is an
--     equivalence relation â” the drawn module proves reflexivity and
--     symmetry in its Â§4 and calls the interval "a genuine object" â” so
--     both apoha directions apply to it.
--
--     CLAIM B IS FALSE.  Cross-multiplication on â• — â• is NOT
--     transitive: a string of length zero sounds nothing, and
--     (1,0) ~ (0,0) ~ (0,1) while (1,0) â‰ (0,1).  Apoha SOUNDNESS fails
--     with it.  Completeness does not, because Â§4 never used
--     transitivity â” which is the inversion: on this carrier the
--     exclusion set determines the term, and the term does not determine
--     the exclusion set.
--
--     The drawn module states no transitivity and is not wrong; its Â§4
--     claim of "a genuine object" is what the counterexample bounds.
------------------------------------------------------------------------

decSameInterval : (i j : Sounding) â†’ Dec (SameInterval i j)
decSameInterval (a , b) (c , d) = discreteâ„• (a Â· d) (c Â· b)

-- Completeness holds on all of â• — â•.  Robinson's reduction, in one
-- line: the whole content of the theorem is the decision of the
-- diophantine equation aÂd = cÂb in four unknowns, and nothing else.
theIntervalIsFixedByItsExclusions :
  (i j : Sounding) â†’ SameExcl SameInterval i j â†’ SameInterval i j
theIntervalIsFixedByItsExclusions =
  apoha-complete SameInterval SameInterval-refl decSameInterval

transitivityFailsOnSoundings :
  Â¬ ((i j k : Sounding) â†’ SameInterval i j â†’ SameInterval j k â†’ SameInterval i k)
transitivityFailsOnSoundings h = snotz (h (1 , 0) (0 , 0) (0 , 1) refl refl)

soundnessFailsOnSoundings :
  Â¬ ((i j : Sounding) â†’ SameInterval i j â†’ SameExcl SameInterval i j)
soundnessFailsOnSoundings h =
  fst (h (1 , 0) (0 , 0) refl (0 , 1)) snotz refl

------------------------------------------------------------------------
-- 7.  The repair, and what it costs.
--
--     `Soundingâº` writes the second string length as `suc n`, so it is
--     never zero.  Transitivity then holds, by cancellation
--     (`inj-Âsm`), and both apoha directions hold.  Note what happened:
--     the richer carrier did not discharge a condition, it supplied the
--     cancellation the condition needed â” the `RnaDhana_*` finding,
--     arriving from the other side.
------------------------------------------------------------------------

Soundingâº : Typeâ‚€
Soundingâº = â„• Ã— â„•                       -- (a , n) denotes lengths (a , suc n)

SameIntervalâº : Soundingâº â†’ Soundingâº â†’ Typeâ‚€
SameIntervalâº (a , n) (c , m) = a Â· suc m â‰¡ c Â· suc n

private
  swapR : (x y z : â„•) â†’ (x Â· y) Â· z â‰¡ (x Â· z) Â· y
  swapR x y z =
      sym (Â·-assoc x y z)
    âˆ™ cong (x Â·_) (Â·-comm y z)
    âˆ™ Â·-assoc x z y

reflâº : (i : Soundingâº) â†’ SameIntervalâº i i
reflâº (a , n) = refl

symâº : (i j : Soundingâº) â†’ SameIntervalâº i j â†’ SameIntervalâº j i
symâº (a , n) (c , m) p = sym p

transâº : (i j k : Soundingâº)
       â†’ SameIntervalâº i j â†’ SameIntervalâº j k â†’ SameIntervalâº i k
transâº (a , n) (c , m) (e , r) p q =
  inj-Â·sm
    ( swapR a (suc r) (suc m)
    âˆ™ cong (_Â· suc r) p
    âˆ™ swapR c (suc n) (suc r)
    âˆ™ cong (_Â· suc n) q
    âˆ™ swapR e (suc m) (suc n) )

decâº : (i j : Soundingâº) â†’ Dec (SameIntervalâº i j)
decâº (a , n) (c , m) = discreteâ„• (a Â· suc m) (c Â· suc n)

theSoundingIsExactlyItsExclusions-sound :
  (i j : Soundingâº) â†’ SameIntervalâº i j â†’ SameExcl SameIntervalâº i j
theSoundingIsExactlyItsExclusions-sound = apoha-sound SameIntervalâº symâº transâº

theSoundingIsExactlyItsExclusions-complete :
  (i j : Soundingâº) â†’ SameExcl SameIntervalâº i j â†’ SameIntervalâº i j
theSoundingIsExactlyItsExclusions-complete = apoha-complete SameIntervalâº reflâº decâº

------------------------------------------------------------------------
-- 8.  What the two schools say back, kept as two voices and not merged.
--
-- The Naiyyika reads Â§5 as the *pratiyogin* returning under another
-- name.  Every *abhva* needs its counterpositive; `apoha-complete`
-- takes `Dec (S a b)` as a hypothesis and cannot be proved without it;
-- so on his reading the account is not self-standing, and what has to be
-- imported to make it stand is positive.
--
-- The Bauddha reads the same theorems as his own position, sharpened.
-- What Â§4 imports is a decision, not a universal.  A decision is a
-- cognitive act; it is not a *smnya* residing in particulars, whose
-- existence he denies.  And Â§3 is his floor: reflexivity â” a thing does
-- not exclude itself â” is the only positive premise, and it is not a
-- universal either.
--
-- What each would say to the other about Â§5, stated because the dispute
-- is the content and flattening it would be the mining move: the
-- Naiyyika says a hypothesis you cannot discharge is an ontological
-- commitment you have not admitted.  The Bauddha says a hypothesis
-- discharged by a procedure is not an entity.  The theorem does not
-- adjudicate.  It locates the disagreement exactly at whether
-- decidability is ontology or is cognition, and that is a different
-- question from the one either was arguing.
------------------------------------------------------------------------
