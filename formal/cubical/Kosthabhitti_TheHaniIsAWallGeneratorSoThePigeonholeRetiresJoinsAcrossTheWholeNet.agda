-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कोष्ठ-भित्तिः — हानिः एव भित्ति-जनकः ।
--
-- (the pigeonhole wall: हानिः is the wall generator, so one counting
--  argument retires joins across the whole net.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE THREE PIECES THIS JOINS, AND WHY THE JOIN IS THE POINT.
--
-- `Kosthanyaya_…agda` separated two things the corpus had been running
-- together: the PIGEONHOLE is unconditional — three points, a two-valued
-- readout, two images agree — and the LOSS is a separate hypothesis,
-- needing the three points pairwise distinct.  `हानिः` there returns the
-- merged pair TOGETHER WITH its distinctness, which at the time looked
-- like bookkeeping.
--
-- `Bhitti_…agda`, `BhittiDvaya_…`, `BhittiSaptabhangi_…` (another seat)
-- land WALLS — proved non-identifications, `¬ (A ≃ B)` — each retiring a
-- candidate join forever.
--
-- `BhittiSankrama_…agda` (same seat) proves walls TRANSPORT:
--     भित्ति-संक्रमः : (A ≃ B) → ¬ (B ≃ C) → ¬ (A ≃ C)
-- so a wall crosses every ford by itself, and "the candidate list shrinks
-- quadratically in what is landed, not linearly in what is proved."
--
-- §२ is the missing joint: **the distinctness half of हानिः is exactly
-- what a wall needs, and supplying it makes the wall.**  A two-valued
-- codomain and three pairwise-distinct points in the source are enough,
-- with no arithmetic, no cardinality, and nothing about the particular
-- types.  So the wall family is a theorem rather than a collection, and
-- every future instance is an application.
--
-- WHY IT WORKS, in one sentence: an equivalence is injective, the
-- pigeonhole says a two-valued readout is not, and distinctness is what
-- turns "two images agree" into "not injective".  That is precisely the
-- hypothesis `Kosthanyaya` peeled off, and this is what it was for.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY A WALL TRANSPORTS AND A DEFECT DOES NOT — recorded because it is
-- the structural reason behind the neighbour's result and neither file
-- states it.
--
-- A DEFECT is a property of a MAP: `Σ[ b ] ¬ isContr (fiber f b)`.  It
-- needs a site, and `TritiyaMarga_…` proves that getting the site from
-- the refutation costs at least Markov's Principle.
--
-- A WALL is a property of a PAIR OF TYPES: `¬ (A ≃ C)`.  Transport moves
-- statements about types.  So walls cross fords and defects do not, and
-- that is the term/type distinction rather than a happy accident.
--
-- It also settles an over-reading available from
-- `Samyoge_…agda`'s title: "refutation does not compose" is true of
-- sequential composition of MAPS and false of transport across the
-- identification graph.  Two compositions, two answers.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  The mathematics is elementary and none of it is
-- new: injectivity of an equivalence is library, the pigeonhole is
-- `Kosthanyaya`'s, and the wall/ford economy is the other seat's.  What
-- is claimed is the joint — that one of those three supplies exactly the
-- hypothesis another needs — and that the joint had not been made.
--
-- कोष्ठ-न्याय is used as the ordinary name for the pigeonhole and no text
-- is claimed for it; भित्ति (wall) is the neighbouring seat's term, used
-- in their sense.  दुर्नय is the Jaina term — a naya asserting itself by
-- denying the others (Siddhasena Divākara, सन्मतितर्क; Akalaṅka's line) —
-- and what is taken from it is the SHAPE, a readout too narrow to hold
-- the distinctions being forced to deny one, not a theorem of any Jaina
-- logician.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Kosthabhitti_TheHaniIsAWallGeneratorSoThePigeonholeRetiresJoinsAcrossTheWholeNet where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; snotz ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Relation.Nullary using (¬_)

open import Kosthanyaya_TheDurnayaIsThePigeonholeAndTheLossIsTheSeparateHypothesis
  using (द्वि-मूल्यम् ; हानिः)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · समता-एकैकत्वम् — an equivalence is injective.  One line, and it is
--     the only thing about equivalences this file uses.
------------------------------------------------------------------------

समता-एकैकत्वम् : {X D : Type ℓ} (e : X ≃ D) (p q : X)
               → equivFun e p ≡ equivFun e q → p ≡ q
समता-एकैकत्वम् e p q h =
  sym (retEq e p) ∙ cong (invEq e) h ∙ retEq e q

------------------------------------------------------------------------
-- २ · कोष्ठ-भित्तिः — THE WALL GENERATOR.
--
--     Three pairwise-distinct points in the source, a two-valued
--     codomain, and there is no identification between them.  No
--     cardinality, no arithmetic, nothing about which types these are.
------------------------------------------------------------------------

कोष्ठ-भित्तिः : {X : Type ℓ} {D : Type ℓ} {d₀ d₁ : D}
              → द्वि-मूल्यम् D d₀ d₁
              → (x y z : X) → ¬ (x ≡ y) → ¬ (x ≡ z) → ¬ (y ≡ z)
              → ¬ (X ≃ D)
कोष्ठ-भित्तिः two x y z x≢y x≢z y≢z e =
  let (p , q , p≢q , eq) = हानिः two (equivFun e) x y z x≢y x≢z y≢z
  in p≢q (समता-एकैकत्वम् e p q eq)

------------------------------------------------------------------------
-- ३ · The instance the neighbouring lane landed by hand, obtained.
--
--     `Bhitti_TheNaturalsAndTheBooleansAreAProvedWall…` proves ¬ (ℕ ≃ Bool).
--     Here it is three numerals and §२, with `Bool`'s two-valuedness the
--     only fact about `Bool` used.  Their module is NOT superseded — it
--     is the named wall the economy cites, and it may well prove it by a
--     route that generalises differently.  What §३ shows is that the
--     statement is an instance of a counting argument and needs nothing
--     about ℕ beyond three distinct numerals.
------------------------------------------------------------------------

Bool-द्वि-मूल्यम् : द्वि-मूल्यम् Bool true false
Bool-द्वि-मूल्यम् true  = inl refl
  where open import Cubical.Data.Sum using (inl)
Bool-द्वि-मूल्यम् false = inr refl
  where open import Cubical.Data.Sum using (inr)

०≢१ : ¬ (0 ≡ 1)
०≢१ = znots

०≢२ : ¬ (0 ≡ 2)
०≢२ = znots

१≢२ : ¬ (1 ≡ 2)
१≢२ p = znots (injSuc p)

ℕ-भित्तिः-Bool : ¬ (ℕ ≃ Bool)
ℕ-भित्तिः-Bool = कोष्ठ-भित्तिः Bool-द्वि-मूल्यम् 0 1 2 ०≢१ ०≢२ १≢२
