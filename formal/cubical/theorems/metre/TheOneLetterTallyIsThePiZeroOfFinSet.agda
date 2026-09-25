{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकाक्षर-सेतु — the single-letter ford.
--
--        Tally  ≃  π₀FinSet .
--
-- Two constructions of the natural numbers that the corpus already holds,
-- joined for the first time by a single named equivalence:
--
--   * `FreeMonoid.Tally = List Unit` — the free monoid on
--     ONE generator, i.e. words over a one-symbol alphabet (a tally: a
--     count kept as repeated identical marks).  `ℕ≃Tally` is proved there.
--   * `Decategorification.π₀FinSet = ∥ FinSet ℓ-zero ∥₂` —
--     the set-truncation (π₀) of the groupoid of finite sets, i.e. the
--     iso-classes of finite sets.  `ℕ≃π₀FinSet` is proved there.
--
-- This file composes the two proved equivalences into one edge.
--
-- WHY `≃` AND NOT `≡`.  `Tally : Type₀` and `π₀FinSet : Type₁` sit in
-- different universes, so there is no path `Tally ≡ π₀FinSet` to write;
-- `compEquiv`, never `_∙_`.  This is the same universe gap `Ankapasa`
-- records for `छन्दस्≃π₀FinSet`.
--
-- COUNT AGREEMENT.  The ford is not an arbitrary bijection between two
-- countable sets: it is the COUNTING ford.  `count-agrees` checks, using
-- the corpus's own `len` and `cardπ₀`, that the finite set a tally word
-- is sent to has cardinality equal to the length of the word.
--
-- PROVENANCE.  एकाक्षर ("single-syllable / single-letter") names
-- `Tally` honestly: it is the set of words over a one-symbol alphabet,
-- which is exactly a tally of single marks.  सेतु ("ford / bridge") is
-- the tirtha-graph vocabulary `SetuYugma` established for this region.
-- The decategorification side (π₀ of finite sets, cardinality of a finite
-- set) is category-theoretic;
-- t−he compound संरक्षकसमूहसंरक्षकसमूह- is built here.
--
-- No sorry / postulate / axiom / hole; no Bool, no decision.
------------------------------------------------------------------------

module TheOneLetterTallyIsThePiZeroOfFinSet where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; compEquiv ; equivFun)

open import FreeMonoid using (Tally ; len ; ℕ≃Tally)
open import Decategorification
  using (π₀FinSet ; cardπ₀ ; card-Fin ; ℕ≃π₀FinSet)

------------------------------------------------------------------------
-- The ford: two checked equivalences, composed through ℕ.
------------------------------------------------------------------------

Tally≃π₀FinSet : Tally ≃ π₀FinSet
Tally≃π₀FinSet = compEquiv (invEquiv ℕ≃Tally) ℕ≃π₀FinSet

------------------------------------------------------------------------
-- It is the counting ford: the finite set a tally is carried to has
-- cardinality equal to the length of the tally word.
------------------------------------------------------------------------

count-agrees : (w : Tally) → cardπ₀ (equivFun Tally≃π₀FinSet w) ≡ len w
count-agrees w = card-Fin (len w)
