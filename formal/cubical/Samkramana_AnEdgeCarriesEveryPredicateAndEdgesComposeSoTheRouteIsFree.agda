-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- संक्रमण — एकः सेतुः सर्वं वहति, सेतवश्च संयुज्यन्ते ।
--
-- (one bridge carries everything, and bridges compose.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE ECONOMIC CLAIM OF THIS CORPUS, AS TERMS.  README's LAW section says
-- proof-of-transport "spends compute for an edge everybody uses forever",
-- and movement 55 says import IS identity, so one landed bridge amortizes
-- across every theorem of both banks.  Both sentences are exactly two
-- library facts standing together, and they are worth standing under one
-- name because the pair is the economics and neither alone is.
--
-- §१ · वहनम् — a landed equivalence carries EVERY predicate.  There is no
-- hypothesis on `P`: not a set, not a prop, not decidable, not finite.
-- That absence is the non-rivalry: whatever anyone ever proves on one
-- bank crosses, including things nobody has stated yet.
--
-- §२ · संयोगः — edges compose, and the composite is an edge.  So a route
-- is an edge, and a route of routes is an edge, and the toll of a
-- road-one route is zero at any length (which is `notes/Sulka_…md`'s
-- point about `Marga` calling a proof-length a toll).
--
-- §३ · पुनरागमनम् — and an edge inverts, so transport is two-way and the
-- round trip returns.  Road one is closed under composition and inverse.
--
-- WHAT IS NOT CLAIMED.  Nothing here is new: `subst`, `ua`, `compEquiv`
-- and `invEquiv` are library.  What is claimed is that these four ARE the
-- transport economy, that the economics has no content beyond them, and
-- that the absence of any hypothesis on `P` in §१ is the whole of why a
-- receipt is non-rival.  No claim about cost models, networks, or money;
-- those readings are in the notes and are marked MINE there.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Samkramana_AnEdgeCarriesEveryPredicateAndEdgesComposeSoTheRouteIsFree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; invEquiv ; idEquiv)
open import Cubical.Foundations.Univalence using (ua)

private variable ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · वहनम् — one edge carries every predicate, with no hypothesis on it.
------------------------------------------------------------------------

वहनम् : {A B : Type ℓ} (P : Type ℓ → Type ℓ') → A ≃ B → P A → P B
वहनम् P e = subst P (ua e)

-- and back, because the edge inverts
प्रतिवहनम् : {A B : Type ℓ} (P : Type ℓ → Type ℓ') → A ≃ B → P B → P A
प्रतिवहनम् P e = subst P (sym (ua e))

------------------------------------------------------------------------
-- २ · संयोगः — a route is an edge.  Composition stays on road one, so
--     length costs nothing.
------------------------------------------------------------------------

मार्गः : {A B C : Type ℓ} → A ≃ B → B ≃ C → A ≃ C
मार्गः = compEquiv

-- a route of any length is still one edge: three, and the pattern is
-- visibly unbounded
त्रिमार्गः : {A B C D : Type ℓ} → A ≃ B → B ≃ C → C ≃ D → A ≃ D
त्रिमार्गः e f g = मार्गः (मार्गः e f) g

------------------------------------------------------------------------
-- ३ · पुनरागमनम् — and the road is two-way, with the trivial edge at
--     every node.  Road one is closed under identity, composition and
--     inverse: it is a groupoid, and that is why routing on it is total.
------------------------------------------------------------------------

व्यत्ययः : {A B : Type ℓ} → A ≃ B → B ≃ A
व्यत्ययः = invEquiv

स्थानम् : (A : Type ℓ) → A ≃ A
स्थानम् = idEquiv

-- the round trip is an edge from a node to itself
पुनरागमनम् : {A B : Type ℓ} → A ≃ B → A ≃ A
पुनरागमनम् e = मार्गः e (व्यत्ययः e)
