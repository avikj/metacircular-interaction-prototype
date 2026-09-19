{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AvaktavyaDoesNotFactor
--
-- Three things in this repository turn out to be one thing, and none of
-- the three files says so.
--
--   `Saptabhangi.no-single-vacana`  â” avaktavya: no single utterance
--       denotes the joint content (Akalaka, c. 720â“780; the fourth
--       bhaga of the sydvda).
--   `Laghava.laghava-is-not-semantic` â” à²à¾à˜àµ is not a function of the
--       denotation (Pini's criterion, and why it had to exist).
--   `TranscriptDescent.collisionObstructsDecoder` â” and
--       flagship open problem is `Â FactorsThrough`.
--
-- All three have the shape
--
--     Â Î[ decoder ] ((x : _) â’ decoder (coarse x) â‰¡ fine x)
--
-- and this file writes the first one in that shape, so the identification
-- is a term rather than a remark.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS SETTLES ABOUT AVAKTAVYA
--
-- The fourth bhaga is standardly read as the *inexpressible*, and it is
-- easy to hear that as a truth-value gap or as undecidability.
-- `Saptabhangi` already refutes the first â” `joint` is realised and
-- refuted, a genuine two-valued predicate â” and this file records the
-- second:
--
--     avaktavya-decidable : (Ï : Profile) â’ Dec (joint Ï â‰¡ true)
--
-- decidable, because `joint Ï` is a Boolean.  So avaktavya is neither a
-- gap nor an undecidability.  What it is, exactly, is a **failure to
-- factor through a single utterance** â” an expressiveness fact about the
-- medium of predication, not a defect in the object predicated of.
--
-- That is precisely `Laghava`'s situation one domain over: the quantity
-- is perfectly definite, and invisible at the level where you were
-- looking.  And it is precisely what
-- proves this lane cannot express a barrier in any stronger sense:
-- avaktavya was the corpus's best candidate for something genuinely
-- inexpressible, and it is exact.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module AvaktavyaDoesNotFactor where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _â‰Ÿ_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_ ; Dec)

open import SaptabhangiNaya using (Profile ; Vacana ; denotes ; joint ; no-single-vacana)

------------------------------------------------------------------------
-- 1.  Avaktavya is decidable â” it is a Boolean condition
------------------------------------------------------------------------

avaktavya-decidable : (Ï† : Profile) â†’ Dec (joint Ï† â‰¡ true)
avaktavya-decidable Ï† = joint Ï† â‰Ÿ true

------------------------------------------------------------------------
-- 2.  THE SHAPE.  It does not factor through a single utterance.
--
-- `Saptabhangi.no-single-vacana` gives, for each utterance, a profile
-- separating it from the joint content.  That is exactly the negation of
-- a factorisation, and here it is written as one.
------------------------------------------------------------------------

FactorsThroughOneUtterance : Typeâ‚€
FactorsThroughOneUtterance =
  Î£[ v âˆˆ Vacana ] ((Ï† : Profile) â†’ denotes v Ï† â‰¡ joint Ï†)

avaktavya-does-not-factor : Â¬ FactorsThroughOneUtterance
avaktavya-does-not-factor (v , agrees) =
  no-single-vacana v .snd (agrees (no-single-vacana v .fst))

------------------------------------------------------------------------
-- 3.  The three, side by side.
--
--   avaktavya   Â Î[ v ] (âˆ Ï â’ denotes v Ï â‰¡ joint Ï)          here
--   à²à¾à˜àµ        Â Î[ f ] (âˆ e â’ f (eval e) â‰¡ size e)            Laghava
--   the barrier Â Î[ d ] (âˆ x â’ d (blur x) â‰¡ observable x)      BARRIER.md B3
--
-- One shape, three traditions, and the middle one is the only place this
-- corpus had noticed it.  `TranscriptDescent.collisionObstructsDecoder`
-- records that it was independently reinvented four times here.  This is
-- the fifth site and the first outside mathematics proper.
--
-- The reading that follows, and it is a reading:  what a tradition calls
-- "inexpressible" is often not a claim about truth at all but about the
-- arity of its medium â” one utterance, one denotation, one blur value â”
-- and the formal content is always the same negation.  Avaktavya says so
-- about predication, à²à¾à˜àµ about meaning, and B3 about windowed
-- observation.
------------------------------------------------------------------------
