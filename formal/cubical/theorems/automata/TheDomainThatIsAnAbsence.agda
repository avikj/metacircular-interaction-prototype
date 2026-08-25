{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDomainThatIsAnAbsence
--
-- अभाव used as a DOMAIN — what it buys, and what this type theory can
-- and cannot host.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STEP BEING EXPLOITED
--
-- `ExclusionRecoversGroundAtAPrice` §8b proves its necessity result by
-- forming the SHADOW of an observable: for `q : Bool → Y`, put
-- `Excl := ¬ (q true ≡ q false)` and take
--
--     shadow q : Bool → (Excl → Y)      shadow q b = λ _ → q b .
--
-- That module named the step it rests on — the construction forms
-- functions OUT OF an absence — and said it was not neutral ground,
-- because Vaiśeṣika counts अभाव among the पदार्थs while the Buddhist
-- position denies there is any such entity.  It then left the matter
-- there.  This file does the work instead of naming it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  if the affirmation holds, the absence-indexed type is
--       CONTRACTIBLE — `A → isContr (¬ A → Y)`, for every Y whatever,
--       inhabited or not.  There is nothing there to quantify over and
--       the whole type shrinks to a point.
--
--   §2  if the absence holds, the same type IS Y — `¬ A → ((¬ A → Y) ≃
--       Y)`, because an inhabited proposition is contractible and
--       evaluation at its centre is an equivalence.
--
--   §3  so the shadow's codomain is a type whose identity is settled
--       only by settling A, and §3 shows that settling is not optional
--       twice over: `¬ ¬ Dec A` holds for every A — the "neither"
--       position is refuted outright — and `¬ (A × ¬ A)` — the "both"
--       position is refuted outright.  Of the four naive positions two
--       are impossible and the remaining two are each underivable in
--       general.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT EACH SCHOOL GETS, AND WHY THE TWO ARE NOT INTERCHANGEABLE
--
--   VAIŚEṢIKA (Praśastapāda's *Padārthadharmasaṃgraha*, and the Nyāya
--   development after it).  अभाव is a पदार्थ: absence is a category of
--   the real, with an अधिकरण, a locus where it resides, and a
--   प्रतियोगिन् it is the absence of.  §1 and §2 say the locus has a
--   determinate structure — and say exactly which — but only once the
--   affirmation or the absence is settled.  So the school's demand that
--   an absence be individuated is met here in a precise form, and the
--   price of meeting it is visible.
--
--   BUDDHIST (Madhyamaka).  The reading is the opposite one and it is
--   equally supported by §1–§2: `¬ A → Y` is neither `Unit` nor `Y` in
--   itself.  Which it is depends entirely on how A goes, and there is
--   no third answer it has on its own.  A type with no identity apart
--   from its relations is what निःस्वभाव describes.  The Naiyāyika
--   reply is available and is not answered here: dependence on A is not
--   the same as having no nature, and §1 and §2 are themselves precise
--   statements OF a nature.
--
--   The two schools reject each other's categories, and this file takes
--   neither side.  What it refuses is the third option of drawing on
--   both vocabularies as one toolkit: the same two theorems are read
--   twice, incompatibly, and both readings are recorded.
--
-- ────────────────────────────────────────────────────────────────────
-- A WARNING ABOUT THE CATUṢKOṬI, WHICH THIS FILE OWES
--
-- This thread has invoked the चतुष्कोटि as a checking lens for many
-- cycles.  §3 says something uncomfortable about that: in this type
-- theory the fourth position, read naively as `¬ A × ¬ ¬ A`, is
-- absurd, and the third, read as `A × ¬ A`, is absurd.  Anyone
-- modelling the fourfold here as those four formulas has already lost
-- two of them before starting.
--
-- That is a fact about the naive reading and is NOT a refutation of
-- Madhyamaka.  The fourfold is stated in the *Mūlamadhyamakakārikā*
-- and what its positions ARE is contested among its readers —
-- whether they are four assertions to be evaluated, four theses all of
-- which are rejected, or a प्रसङ्ग device that asserts nothing and
-- proceeds only by drawing consequences from an opponent's own
-- commitments.  On the last reading §3 is not even addressed to it.
-- Recording the tension is the point; resolving it is not something a
-- module of Agda is positioned to do, and this one does not try.
--
-- NOT CLAIMED.  Any reading of any Madhyamaka text beyond the
-- existence of the fourfold and the fact that its logical form is
-- disputed; that `¬ A → Y` is the right formal counterpart of an
-- अधिकरण; that the shadow construction is legitimate on any school's
-- terms — §1–§3 say what it does, not that it is permitted.
------------------------------------------------------------------------

module TheDomainThatIsAnAbsence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Relation.Nullary.Properties using (isProp¬)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  The affirmation empties the domain
--
-- Nothing about Y is used.  If A holds there is no absence to quantify
-- over, and every function out of it is the same function.
------------------------------------------------------------------------

affirmation-contracts :
  {A : Type ℓ} {Y : Type ℓ'} → A → isContr (¬ A → Y)
affirmation-contracts a =
  (λ na → ⊥.rec (na a)) , λ f → funExt (λ na → ⊥.rec (na a))

------------------------------------------------------------------------
-- 2.  The absence makes the domain a single point, so the type is Y
--
-- `¬ A` is a proposition; an inhabited proposition is contractible;
-- evaluation at the inhabitant is then an equivalence.
------------------------------------------------------------------------

absence-evaluates :
  {A : Type ℓ} {Y : Type ℓ'} → (na : ¬ A) → (¬ A → Y) ≃ Y
absence-evaluates {A = A} na = isoToEquiv (iso (λ f → f na) (λ y _ → y)
  (λ _ → refl)
  (λ f i na' → f (isProp¬ A na na' i)))

------------------------------------------------------------------------
-- 3.  Two of the four naive positions are impossible here
--
-- Neither: `¬ A × ¬ ¬ A` cannot hold, and the sharper form is that
-- `Dec A` cannot be refuted at all.  Both: immediate.
------------------------------------------------------------------------

¬¬Dec : {A : Type ℓ} → ¬ ¬ (Dec A)
¬¬Dec k = k (no (λ a → k (yes a)))

neither-is-absurd : {A : Type ℓ} → ¬ ((¬ A) × (¬ ¬ A))
neither-is-absurd (na , nna) = nna na

both-is-absurd : {A : Type ℓ} → ¬ (A × (¬ A))
both-is-absurd (a , na) = na a

-- The two impossibility results above are UNCONDITIONAL.  The
-- disjunction below is not: it needs `Dec A`, which `¬¬Dec` says can
-- never be refuted and which is not thereby available.  So the honest
-- statement is that the shadow's codomain is `Unit`-like or `Y`-like
-- ONCE A IS SETTLED, that settling it is never ruled out, and that
-- nothing here settles it.  `Dec A` below is a hypothesis of the
-- theorem and not a claim about types.
shadowCodomain-dichotomy :
  {A : Type ℓ} {Y : Type ℓ'}
  → Dec A → (isContr (¬ A → Y)) ⊎ ((¬ A → Y) ≃ Y)
shadowCodomain-dichotomy (yes a)  = inl (affirmation-contracts a)
shadowCodomain-dichotomy (no  na) = inr (absence-evaluates na)

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `¬`, `→`, `×`, `Π`, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `⊎`,
-- `no-barrier-claim : ¬ (¬ (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not — and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PRIOR-ART OBLIGATION, undischarged, recorded 2026-08-19.
--
-- Navya-Nyāya* (Panday & Ghosh), whose stated content includes DEPENDENT
-- DELIMITATION (avacchedaka) and TYPED ABSENCE (abhāva) in cubical type
-- theory — the same substrate and the same notions this module touches.
--
-- This module does not cite it, and could not: the citation sits in a
-- note whose §2 alone had been read.  arxiv.org is EGRESS_BLOCKED from
-- this session's environment, so the comparison could not be made here;
-- leaves open.
--
-- Until someone who can read the paper compares them, NO NOVELTY IS
-- CLAIMED for anything below.  The theorems are about observables,
-- fibres and Bool-valued models and are unaffected; what is owed is a
-- citation check, not a withdrawal.
------------------------------------------------------------------------
