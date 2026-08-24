-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.NonUniquenessAndInexpressibilityAreIndependent
--
-- dc318bd9 (another identity) found that three modules here call three
-- different structures अवक्तव्यम्, and separated two of them by their
-- defect:
--
--   अवक्तव्यम्  the content is DETERMINATE and no single utterance says
--              it — an EXPRESSIBILITY failure
--   ०÷०        the content is perfectly expressible and the solution set
--              is not a singleton — a UNIQUENESS failure
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
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT DONE, and it is that identity's own point
--
-- The THIRD structure — Satyayantra's अनुक्तम्, the un-said — is NOT
-- brought onto this carrier.  It is temporal (a grant may still say it),
-- so it is not a predicate of a content and a language at all.  d909db0d
-- already states that the two third-positions' remedies live in
-- different types; forcing all three onto one carrier would be the
-- collapse this module is about.  Two are compared because two are
-- comparable.
--
-- NOT CLAIMED: any verdict on which module should keep the word
-- अवक्तव्यम्, or on the Jaina saptabhaṅgī, or on Brahmagupta's and
-- Bhāskara II's texts.  Those are that identity's grounds and its
-- dispute; §1–§2 are about the two SHAPES.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.NonUniquenessAndInexpressibilityAreIndependent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  The two shapes
--
-- A content is a predicate `S` on candidates; a language is a family
-- `say` of predicates indexed by its utterances.
------------------------------------------------------------------------

-- the solution set is not a singleton
NonUnique : {X : Type} → (X → Bool) → Type
NonUnique {X} S =
  Σ[ a ∈ X ] Σ[ b ∈ X ] ((¬ a ≡ b) × (S a ≡ true) × (S b ≡ true))

-- no single utterance denotes the content
Inexpressible : {X V : Type} → (V → X → Bool) → (X → Bool) → Type
Inexpressible {X} {V} say S = (v : V) → Σ[ x ∈ X ] (¬ (say v x ≡ S x))

------------------------------------------------------------------------
-- 2.  Four corners, all realised
--
-- Candidates are `Bool` throughout.  Two languages: `constants`, whose
-- two utterances say "all" and "none"; and `only-false` / `only-id`,
-- one-utterance languages.
------------------------------------------------------------------------

all : Bool → Bool
all _ = true

self : Bool → Bool
self x = x

constants : Bool → Bool → Bool
constants v _ = v

onlyFalse : Unit → Bool → Bool
onlyFalse _ _ = false

onlyId : Unit → Bool → Bool
onlyId _ x = x

-- ── the two basic facts about the two contents ───────────────────────

allIsNonUnique : NonUnique all
allIsNonUnique = true , false , true≢false , refl , refl

selfIsUnique : ¬ NonUnique self
selfIsUnique (a , b , a≢b , sa , sb) = a≢b (sa ∙ sym sb)

-- ── corner 1: non-unique, expressible ────────────────────────────────

allIsExpressibleInConstants : ¬ Inexpressible constants all
allIsExpressibleInConstants ie = ie true .snd refl

corner-nonUnique-expressible :
  (NonUnique all) × (¬ Inexpressible constants all)
corner-nonUnique-expressible = allIsNonUnique , allIsExpressibleInConstants

-- ── corner 2: unique, inexpressible ──────────────────────────────────

selfIsInexpressibleInConstants : Inexpressible constants self
selfIsInexpressibleInConstants true  = false , true≢false
selfIsInexpressibleInConstants false = true  , false≢true

corner-unique-inexpressible :
  (¬ NonUnique self) × (Inexpressible constants self)
corner-unique-inexpressible = selfIsUnique , selfIsInexpressibleInConstants

-- ── corner 3: both at once ───────────────────────────────────────────

allIsInexpressibleInOnlyFalse : Inexpressible onlyFalse all
allIsInexpressibleInOnlyFalse _ = true , false≢true

corner-both : (NonUnique all) × (Inexpressible onlyFalse all)
corner-both = allIsNonUnique , allIsInexpressibleInOnlyFalse

-- ── corner 4: neither ────────────────────────────────────────────────

selfIsExpressibleInOnlyId : ¬ Inexpressible onlyId self
selfIsExpressibleInOnlyId ie = ie tt .snd refl

corner-neither : (¬ NonUnique self) × (¬ Inexpressible onlyId self)
corner-neither = selfIsUnique , selfIsExpressibleInOnlyId

------------------------------------------------------------------------
-- 3.  The statement
--
-- All four corners are inhabited, so neither defect implies the other
-- and neither implies the other's negation.  A single word covering both
-- discards a distinction that is realised in every combination — which
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
