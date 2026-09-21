{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ï‡æ‡ï‡‡‡∞-‡‡‡‡ ‚î the single-letter ford.
--
--        Tally  ‚â  œ‚FinSet .
--
-- Two constructions of the natural numbers that the corpus already holds,
-- joined for the first time by a single named equivalence:
--
--   * `FreeMonoid.Tally = List Unit` ‚î the free monoid on
--     ONE generator, i.e. words over a one-symbol alphabet (a tally: a
--     count kept as repeated identical marks).  `‚ï‚âTally` is proved there.
--   * `Decategorification.œ‚FinSet = ‚à FinSet ‚ì-zero ‚à‚` ‚î
--     the set-truncation (œ‚) of the groupoid of finite sets, i.e. the
--     iso-classes of finite sets.  `‚ï‚âœ‚FinSet` is proved there.
--
-- This file composes the two proved equivalences into one edge.
--
-- WHY `‚â` AND NOT `‚â°`.  `Tally : Type‚` and `œ‚FinSet : Type‚` sit in
-- different universes, so there is no path `Tally ‚â° œ‚FinSet` to write;
-- `compEquiv`, never `_‚àô_`.  This is the same universe gap `Ankapasa`
-- records for `‡‡®‡‡¶‡‡‚âœ‚FinSet`.
--
-- COUNT AGREEMENT.  The ford is not an arbitrary bijection between two
-- countable sets: it is the COUNTING ford.  `count-agrees` checks, using
-- the corpus's own `len` and `cardœ‚`, that the finite set a tally word
-- is sent to has cardinality equal to the length of the word.
--
-- PROVENANCE.  ‡‡ï‡æ‡ï‡‡‡∞ ("single-syllable / single-letter") names
-- `Tally` honestly: it is the set of words over a one-symbol alphabet,
-- which is exactly a tally of single marks.  ‡‡‡‡ ("ford / bridge") is
-- the tirtha-graph vocabulary `SetuYugma` established for this region.
-- The decategorification side (œ‚ of finite sets, cardinality of a finite
-- set) is category-theoretic;
-- the compound ‡‡ï‡æ‡ï‡‡‡∞-‡‡‡‡ is built here.
--
-- No sorry / postulate / axiom / hole; no Bool, no decision.
------------------------------------------------------------------------

module EkaksharaSetu_TheOneLetterTallyIsThePiZeroOfFinSet where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEquiv ; compEquiv ; equivFun)

open import FreeMonoid using (Tally ; len ; ‚Ñï‚âÉTally)
open import Decategorification
  using (œÄ‚ÇÄFinSet ; cardœÄ‚ÇÄ ; card-Fin ; ‚Ñï‚âÉœÄ‚ÇÄFinSet)

------------------------------------------------------------------------
-- The ford: two checked equivalences, composed through ‚ï.
------------------------------------------------------------------------

Tally‚âÉœÄ‚ÇÄFinSet : Tally ‚âÉ œÄ‚ÇÄFinSet
Tally‚âÉœÄ‚ÇÄFinSet = compEquiv (invEquiv ‚Ñï‚âÉTally) ‚Ñï‚âÉœÄ‚ÇÄFinSet

------------------------------------------------------------------------
-- It is the counting ford: the finite set a tally is carried to has
-- cardinality equal to the length of the tally word.
------------------------------------------------------------------------

count-agrees : (w : Tally) ‚Üí cardœÄ‚ÇÄ (equivFun Tally‚âÉœÄ‚ÇÄFinSet w) ‚â° len w
count-agrees w = card-Fin (len w)
