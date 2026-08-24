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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकाक्षर-सेतु — the single-letter ford.
--
--        Tally  ≃  π₀FinSet .
--
-- Two constructions of the natural numbers that the corpus already holds,
-- joined for the first time by a single named equivalence:
--
--   * `NaturalMachine.FreeMonoid.Tally = List Unit` — the free monoid on
--     ONE generator, i.e. words over a one-symbol alphabet (a tally: a
--     count kept as repeated identical marks).  `ℕ≃Tally` is proved there.
--   * `NaturalMachine.Decategorification.π₀FinSet = ∥ FinSet ℓ-zero ∥₂` —
--     the set-truncation (π₀) of the groupoid of finite sets, i.e. the
--     iso-classes of finite sets.  `ℕ≃π₀FinSet` is proved there.
--
-- Both are already identified with ℕ; NEITHER is identified with the
-- other in the corpus.  `Ankapasa` mints `छन्दस्≃π₀FinSet` and `Sthana`
-- mints `CanWord≡Tally`, so the tirtha graph's component 5 was reachable
-- transitively — but a reachable crossing is not a checked one, and this
-- particular bank (`Tally`) had no minted edge to `π₀FinSet`.  This file
-- is that edge, and nothing more: the two proved equivalences composed.
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
-- PROVENANCE / SCOPE.  एकाक्षर ("single-syllable / single-letter") names
-- `Tally` honestly: it is the set of words over a one-symbol alphabet,
-- which is exactly a tally of single marks.  सेतु ("ford / bridge") is
-- the tirtha-graph vocabulary `SetuYugma` established for this region.
-- The decategorification side (π₀ of finite sets, cardinality of a finite
-- set) is category-theoretic and is NOT claimed for any Indian source;
-- the compound एकाक्षर-सेतु is built here, 2026-08-22.  Naming `Tally`
-- एकाक्षर does not claim any source enumerated finite sets.
--
-- No sorry / postulate / axiom / hole; no Bool, no decision.
------------------------------------------------------------------------

module EkaksharaSetu_TheOneLetterTallyIsThePiZeroOfFinSet where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; compEquiv ; equivFun)

open import NaturalMachine.FreeMonoid using (Tally ; len ; ℕ≃Tally)
open import NaturalMachine.Decategorification
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
