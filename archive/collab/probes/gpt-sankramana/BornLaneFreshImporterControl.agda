{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BornLaneFreshImporterControl
--
-- A producer load can report no interaction goals while exported implicit
-- metas remain.  A committed file can also differ from the working tree that
-- was loaded.  This module is therefore deliberately content-free: its whole
-- theorem is that the three newly landed interfaces can be imported together
-- from the committed stream.
--
-- It imports:
--   * dependent inner/outer/nested enumeration-independence;
--   * independence from the chosen reversible encoder;
--   * reversible dependent flattening and exact branch fibres.
--
-- A green load here is the consumer half of all three receipts.  A producer
-- load or a green `goals` response in the producer is not a substitute.
------------------------------------------------------------------------

module BornLaneFreshImporterControl where

import ShakhitaNairapeksya_TheNestedTotalIsIndifferentToInnerOuterAndSimultaneousReEnumeration
import PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder
import ShakhaSetu_TheMicroSpaceFlattensReversiblyAndTheFibreOverEachCoarseOutcomeIsItsBranch
