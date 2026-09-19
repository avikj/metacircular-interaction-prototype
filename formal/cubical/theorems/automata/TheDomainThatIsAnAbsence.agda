{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDomainThatIsAnAbsence
--
-- ààà¾àµ used as a DOMAIN â” what it buys, and what this type theory can
-- and cannot host.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STEP BEING EXPLOITED
--
-- `ExclusionRecoversGroundAtAPrice` Â§8b proves its necessity result by
-- forming the SHADOW of an observable: for `q : Bool â’ Y`, put
-- `Excl := Â (q true â‰¡ q false)` and take
--
--     shadow q : Bool â’ (Excl â’ Y)      shadow q b = Î» _ â’ q b .
--
-- That module named the step it rests on â” the construction forms
-- functions OUT OF an absence â” and said it was not neutral ground,
-- because Vaieika counts ààà¾àµ among the àà¦à¾à°ààs while the Buddhist
-- position denies there is any such entity.  It then left the matter
-- there.  This file does the work instead of naming it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  if the affirmation holds, the absence-indexed type is
--       CONTRACTIBLE â” `A â’ isContr (Â A â’ Y)`, for every Y whatever,
--       inhabited or not.  There is nothing there to quantify over and
--       the whole type shrinks to a point.
--
--   Â§2  if the absence holds, the same type IS Y â” `Â A â’ ((Â A â’ Y) â‰
--       Y)`, because an inhabited proposition is contractible and
--       evaluation at its centre is an equivalence.
--
--   Â§3  so the shadow's codomain is a type whose identity is settled
--       only by settling A, and Â§3 shows that settling is not optional
--       twice over: `Â Â Dec A` holds for every A â” the "neither"
--       position is refuted outright â” and `Â (A — Â A)` â” the "both"
--       position is refuted outright.  Of the four naive positions two
--       are impossible and the remaining two are each underivable in
--       general.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT EACH SCHOOL GETS, AND WHY THE TWO ARE NOT INTERCHANGEABLE
--
--   VAIEIKA (Praastapda's *Padrthadharmasagraha*, and the Nyya
--   development after it).  ààà¾àµ is a àà¦à¾à°àà: absence is a category of
--   the real, with an àà§à¿à•à°à, a locus where it resides, and a
--   ààà°àà¿à¯à‹à—à¿à¨à it is the absence of.  Â§1 and Â§2 say the locus has a
--   determinate structure â” and say exactly which â” but only once the
--   affirmation or the absence is settled.  So the school's demand that
--   an absence be individuated is met here in a precise form, and the
--   price of meeting it is visible.
--
--   BUDDHIST (Madhyamaka).  The reading is the opposite one and it is
--   equally supported by Â§1â“Â§2: `Â A â’ Y` is neither `Unit` nor `Y` in
--   itself.  Which it is depends entirely on how A goes, and there is
--   no third answer it has on its own.  A type with no identity apart
--   from its relations is what à¨à¿ààààµàà¾àµ describes.  The Naiyyika
--   reply is available and is not answered here: dependence on A is not
--   the same as having no nature, and Â§1 and Â§2 are themselves precise
--   statements OF a nature.
--
--   The two schools reject each other's categories, and this file takes
--   neither side.  What it refuses is the third option of drawing on
--   both vocabularies as one toolkit: the same two theorems are read
--   twice, incompatibly, and both readings are recorded.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- A WARNING ABOUT THE CATUKOI, WHICH THIS FILE OWES
--
-- This thread has invoked the àààààà•à‹àŸà¿ as a checking lens for many
-- cycles.  Â§3 says something uncomfortable about that: in this type
-- theory the fourth position, read naively as `Â A — Â Â A`, is
-- absurd, and the third, read as `A — Â A`, is absurd.  Anyone
-- modelling the fourfold here as those four formulas has already lost
-- two of them before starting.
--
-- That is a fact about the naive reading and is NOT a refutation of
-- Madhyamaka.  The fourfold is stated in the *Mlamadhyamakakrik*
-- and what its positions ARE is contested among its readers â”
-- whether they are four assertions to be evaluated, four theses all of
-- which are rejected, or a ààà°àà™àà— device that asserts nothing and
-- proceeds only by drawing consequences from an opponent's own
-- commitments.  On the last reading Â§3 is not even addressed to it.
-- Recording the tension is the point; resolving it is not something a
-- module of Agda is positioned to do, and this one does not try.
--
------------------------------------------------------------------------

module TheDomainThatIsAnAbsence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_â‰ƒ_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)
open import Cubical.Relation.Nullary.Properties using (isPropÂ¬)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  The affirmation empties the domain
--
-- Nothing about Y is used.  If A holds there is no absence to quantify
-- over, and every function out of it is the same function.
------------------------------------------------------------------------

affirmation-contracts :
  {A : Type â„“} {Y : Type â„“'} â†’ A â†’ isContr (Â¬ A â†’ Y)
affirmation-contracts a =
  (Î» na â†’ âŠ¥.rec (na a)) , Î» f â†’ funExt (Î» na â†’ âŠ¥.rec (na a))

------------------------------------------------------------------------
-- 2.  The absence makes the domain a single point, so the type is Y
--
-- `Â A` is a proposition; an inhabited proposition is contractible;
-- evaluation at the inhabitant is then an equivalence.
------------------------------------------------------------------------

absence-evaluates :
  {A : Type â„“} {Y : Type â„“'} â†’ (na : Â¬ A) â†’ (Â¬ A â†’ Y) â‰ƒ Y
absence-evaluates {A = A} na = isoToEquiv (iso (Î» f â†’ f na) (Î» y _ â†’ y)
  (Î» _ â†’ refl)
  (Î» f i na' â†’ f (isPropÂ¬ A na na' i)))

------------------------------------------------------------------------
-- 3.  Two of the four naive positions are impossible here
--
-- Neither: `Â A — Â Â A` cannot hold, and the sharper form is that
-- `Dec A` cannot be refuted at all.  Both: immediate.
------------------------------------------------------------------------

Â¬Â¬Dec : {A : Type â„“} â†’ Â¬ Â¬ (Dec A)
Â¬Â¬Dec k = k (no (Î» a â†’ k (yes a)))

neither-is-absurd : {A : Type â„“} â†’ Â¬ ((Â¬ A) Ã— (Â¬ Â¬ A))
neither-is-absurd (na , nna) = nna na

both-is-absurd : {A : Type â„“} â†’ Â¬ (A Ã— (Â¬ A))
both-is-absurd (a , na) = na a

-- The two impossibility results above are UNCONDITIONAL.  The
-- disjunction below is not: it needs `Dec A`, which `ÂÂDec` says can
-- never be refuted and which is not thereby available.  So the honest
-- statement is that the shadow's codomain is `Unit`-like or `Y`-like
-- ONCE A IS SETTLED, that settling it is never ruled out, and that
-- nothing here settles it.  `Dec A` below is a hypothesis of the
-- theorem and not a claim about types.
shadowCodomain-dichotomy :
  {A : Type â„“} {Y : Type â„“'}
  â†’ Dec A â†’ (isContr (Â¬ A â†’ Y)) âŠŽ ((Â¬ A â†’ Y) â‰ƒ Y)
shadowCodomain-dichotomy (yes a)  = inl (affirmation-contracts a)
shadowCodomain-dichotomy (no  na) = inr (absence-evaluates na)

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `Â`, `â’`, `—`, `Î `, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `âŠ`,
-- `no-barrier-claim : Â (Â (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not â” and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PRIOR-ART OBLIGATION, undischarged, recorded 2026-08-19.
--
-- Navya-Nyya* (Panday & Ghosh), whose stated content includes DEPENDENT
-- DELIMITATION (avacchedaka) and TYPED ABSENCE (abhva) in cubical type
-- theory â” the same substrate and the same notions this module touches.
--
-- This module does not cite it, and could not: the citation sits in a
-- note whose Â§2 alone had been read.  arxiv.org is EGRESS_BLOCKED from
-- this session's environment, so the comparison could not be made here;
-- leaves open.
--
-- Until someone who can read the paper compares them, NO NOVELTY IS
-- CLAIMED for anything below.  The theorems are about observables,
-- fibres and Bool-valued models and are unaffected; what is owed is a
-- citation check, not a withdrawal.
------------------------------------------------------------------------
