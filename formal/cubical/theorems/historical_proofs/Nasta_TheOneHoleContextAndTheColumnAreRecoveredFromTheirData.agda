{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡®‡‡‡ü ‚î ‡Ø‡‡ ‡‡‡Ø‡ï‡‡‡ ‡‡‡ ‡‡‡®‡ ‡≤‡‡‡Ø‡‡, ‡‡‡ ‡µ‡‡®‡ ‡‡‡æ ‡‡µ ‡‡‡‡‡ ‡
--
-- (naa ‚î what was dropped is got back, so the receipt was an address
--  all along.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ SOURCE OF THE TERM, with text and date.
--
--   ‡®‡‡‡ü ("the lost one") is one of Pigala's ‡‡‡∞‡‡‡Ø‡Ø: given the row
--   number, RECOVER the pattern that was not written down.  Pigala,
--   *Chandastra* ‡Æ.‡®‡‚ì‡®‡Æ (~300 BCE); worked with the array by
--   ‡‡≤‡æ‡Ø‡‡ß, *Mtasajvan* (10th c. CE).  Its partner ‡â‡¶‡‡¶‡ø‡‡‡ü runs the
--   other way, pattern to row number.
--
--   The term names the OPERATION performed in ¬ß‡® and ¬ß‡© and nothing
--   else: producing the map that brings the object back from the datum.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS MODULE EXISTS.
--
-- `Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification.agda`
-- separates two things this corpus had been running together:
--
--   ‡µ‡‡®‡Æ‡   a RECEIPT.  `‡ó‡‡∞‡æ‡ f ‚â A` for EVERY f, no hypothesis.  A
--           derived datum may always be kept beside its object.
--   ‡‡‡æ     an ADDRESS.  A recovery map with both round trips, i.e.
--           the object may be DROPPED and recomputed from the datum.
--           Not free: it is exactly the statement that f is an
--           identification.
--
-- `machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs`
-- grades the corpus's declarations into an invertible road and a road
-- of one-way edges, and `--queue` emits the latter.  Every edge on that
-- queue is a receipt whose ADDRESS STATUS IS UNKNOWN ‚î the census does
-- not claim they fail to be addresses, only that no term says they are.
--
-- This module takes two of them off the queue by exhibiting the ‡®‡‡‡ü.
-- Both were already three quarters proved at their own site and the
-- last quarter was never written, which is why the census could not see
-- them: a proof that is not a signature is not visible to a parser.
--
-- ¬ß‡®  `compileContext : OneHoleContext X ‚í List (ContextAction X)`
--     ¬ CompositionalContextAdapter.
--     That module proves `compile-decode` (one round trip) and uses it
--     to route SyntacticContextEq ‚í ContextEq.  The other round trip is
--     absent from the file, and with it the fact that the one-hole term
--     grammar IS its action word: the syntax may be dropped.
--
-- ¬ß‡©  `colsOf : Col ‚í ‚ ó ‚ ó ‚` and `entriesOf : Mat 3 3 ‚í Nine`
--     ¬ SmithPathCountedExecution.
--     That module proves `fromCols-entries` and `fromNine-entries` (the
--     hard halves, by funext over the index) and uses them only to
--     derive `col‚â°` / `mat‚â°`, equality-reflection helpers.  The easy
--     halves are `refl` and were never stated, so a 3ó1 integer matrix
--     and its triple of entries stood in the census as two types with a
--     one-way map between them.
--
--     The two are NOT in the same position in the census and the
--     difference is worth naming.  `colsOf` was on the queue.
--     `entriesOf` is nowhere in the census's printed output at all ‚î
--     not on the queue, not an endomorphism, not a refusal ‚î so it sits
--     in one of the two buckets the instrument counts and does not
--     name, and from the output I cannot tell which.  `Mat` reaches
--     that file through an unnamed `open Coefficient ‚CommRing`, which
--     is the likely reason and is a guess, not a reading.  Silence is
--     not a verdict: ‡Æ‡‡®‡ ‡® ‡®‡ø‡‡‡ß‡.  Both are proved below regardless,
--     because the queue is where the question was asked and not where
--     it lives.
--
-- ¬ß‡ is the honest limit and states the extent of the search.
------------------------------------------------------------------------

module Nasta_TheOneHoleContextAndTheColumnAreRecoveredFromTheirData where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)

open import Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification
  using (‡§™‡§§‡§æ ; ‡§™‡§§‡§æ‚Üí‡§∏‡§Æ‡§§‡§æ ; ‡§µ‡§π‡§®‡§Æ‡•ç ; ‡§ó‡•ç‡§∞‡§æ‡§π)

open import CompositionalContextAdapter
  using ( OneHoleContext ; hole ; leftHole ; rightHole
        ; ContextAction ; compileContext ; decodeContext ; compile-decode )

open import SmithPathCountedExecution
  using ( Col ; Nine
        ; colsOf ; fromCols ; fromCols-entries
        ; entriesOf ; fromNine ; fromNine-entries )

open import Cubical.Data.Int using (‚Ñ§)
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient using (module Coefficient)
open Coefficient ‚Ñ§CommRing using (Mat)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ The two readings, restated on the edges below so this file can be
--     read on its own.  ‡µ‡‡®‡Æ‡ is the free half and is quoted, not
--     reproved: it holds of every map, hence of both maps here.
------------------------------------------------------------------------

‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠-‡§µ‡§π‡§®‡§Æ‡•ç : {X : Type ‚Ñì} ‚Üí ‡§ó‡•ç‡§∞‡§æ‡§π (compileContext {X = X}) ‚âÉ OneHoleContext X
‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠-‡§µ‡§π‡§®‡§Æ‡•ç {X = X} = ‡§µ‡§π‡§®‡§Æ‡•ç (compileContext {X = X})

‡§∏‡•ç‡§§‡§Æ‡•ç‡§≠-‡§µ‡§π‡§®‡§Æ‡•ç : ‡§ó‡•ç‡§∞‡§æ‡§π colsOf ‚âÉ Col
‡§∏‡•ç‡§§‡§Æ‡•ç‡§≠-‡§µ‡§π‡§®‡§Æ‡•ç = ‡§µ‡§π‡§®‡§Æ‡•ç colsOf

------------------------------------------------------------------------
-- ‡® ¬ ‡®‡‡‡ü FOR THE ONE-HOLE CONTEXT.
--
--     `compileContext` walks a context from the hole outwards and emits
--     one `ContextAction X = Bool ó X` per layer: `false` for a hole on
--     the left, `true` for a hole on the right, paired with the fixed
--     operand.  The recovery is the obvious re-fold, and it is already
--     written in the adapter as `decodeContext` ‚î used there ONLY in
--     the direction `compileContext ‚àò decodeContext ‚â° id`.
--
--     The missing direction is `decode-compile`.  With it, the whole
--     grammar of generated unary contexts is content-addressed by its
--     action word: an adapter may store the word and throw the tree
--     away.  That is what the adapter's own design assumes and what its
--     file did not say.
------------------------------------------------------------------------

decode-compile : {X : Type ‚Ñì} (c : OneHoleContext X)
  ‚Üí decodeContext (compileContext c) ‚â° c
decode-compile hole                  = refl
decode-compile (leftHole fixed outer)  = cong (leftHole fixed)  (decode-compile outer)
decode-compile (rightHole fixed outer) = cong (rightHole fixed) (decode-compile outer)

-- THE IDENTIFICATION.  Both round trips, in the shape ¬ß‡© of Pata asks for.
‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠-‡§™‡§§‡§æ : {X : Type ‚Ñì} ‚Üí ‡§™‡§§‡§æ (compileContext {X = X})
‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠-‡§™‡§§‡§æ {X = X} = decodeContext , decode-compile , compile-decode

‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠-‡§∏‡§Æ‡§§‡§æ : {X : Type ‚Ñì} ‚Üí OneHoleContext X ‚âÉ List (ContextAction X)
‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠-‡§∏‡§Æ‡§§‡§æ {X = X} = ‡§™‡§§‡§æ‚Üí‡§∏‡§Æ‡§§‡§æ (compileContext {X = X}) ‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠-‡§™‡§§‡§æ

------------------------------------------------------------------------
-- ‡© ¬ ‡®‡‡‡ü FOR THE COLUMN AND FOR THE 3ó3 MATRIX.
--
--     `Col = Mat 3 1` is a FUNCTION out of the index type, so the hard
--     half ‚î that a matrix rebuilt from its entries is the matrix it
--     came from ‚î needs funext and a case split on the index, and
--     `SmithPathCountedExecution` does it (`fromCols-entries`,
--     `fromNine-entries`).  The other half is `refl`, because `mkCol`
--     and `mk3` compute on literal indices.  Neither module stated it,
--     so the census read `colsOf` and `entriesOf` as one-way.
------------------------------------------------------------------------

cols-fromCols : (v : ‚Ñ§ √ó ‚Ñ§ √ó ‚Ñ§) ‚Üí colsOf (fromCols v) ‚â° v
cols-fromCols v = refl

‡§∏‡•ç‡§§‡§Æ‡•ç‡§≠-‡§™‡§§‡§æ : ‡§™‡§§‡§æ colsOf
‡§∏‡•ç‡§§‡§Æ‡•ç‡§≠-‡§™‡§§‡§æ = fromCols , fromCols-entries , cols-fromCols

‡§∏‡•ç‡§§‡§Æ‡•ç‡§≠-‡§∏‡§Æ‡§§‡§æ : Col ‚âÉ (‚Ñ§ √ó ‚Ñ§ √ó ‚Ñ§)
‡§∏‡•ç‡§§‡§Æ‡•ç‡§≠-‡§∏‡§Æ‡§§‡§æ = ‡§™‡§§‡§æ‚Üí‡§∏‡§Æ‡§§‡§æ colsOf ‡§∏‡•ç‡§§‡§Æ‡•ç‡§≠-‡§™‡§§‡§æ

entries-fromNine : (v : Nine) ‚Üí entriesOf (fromNine v) ‚â° v
entries-fromNine v = refl

‡§Æ‡§æ‡§§‡•É‡§ï‡§æ-‡§™‡§§‡§æ : ‡§™‡§§‡§æ entriesOf
‡§Æ‡§æ‡§§‡•É‡§ï‡§æ-‡§™‡§§‡§æ = fromNine , fromNine-entries , entries-fromNine

‡§Æ‡§æ‡§§‡•É‡§ï‡§æ-‡§∏‡§Æ‡§§‡§æ : Mat 3 3 ‚âÉ Nine
‡§Æ‡§æ‡§§‡•É‡§ï‡§æ-‡§∏‡§Æ‡§§‡§æ = ‡§™‡§§‡§æ‚Üí‡§∏‡§Æ‡§§‡§æ entriesOf ‡§Æ‡§æ‡§§‡•É‡§ï‡§æ-‡§™‡§§‡§æ

------------------------------------------------------------------------
-- ‡ ¬ THE EXTENT OF THE SEARCH, so nothing here reads as more than it is.
--
--     WHAT WAS SEARCHED.  `Lopa ‚¶ --queue` (run 2026-08-22 over the
--     whole repository: 1008 files, 11928 top-level signatures) emits
--     its undecided one-way edges as `src ‚ü tgt ‚ü site`.  I joined that
--     queue against itself to find every SOURCE/TARGET pair carrying an
--     edge in both directions ‚î the shape a mutual inverse would leave
--     ‚î and opened the candidates one file at a time.
--
--     WHAT WAS FOUND, and only ¬ß‡® and ¬ß‡© are proved here:
--
--     ¬ Several of those pairs are ALREADY identifications at their own
--       site and are on the queue because the census's parser matches
--       `_‚â_` and `_‚â°_` conclusions and not `Iso`, or because the two
--       sides are written with different aliases for one type.
--       `PMTorus.vertexToFin` is the clearest instance:
--       `vertexIso : Iso Vertex (Fin V)` and `vertexCount : Vertex ‚â
--       Fin V` are both in that file, and the map's signature says
--       `Fin 6`, with `V = 6` a definition the resolver does not unfold.
--       Same for `edgeToFin`, and for
--       `S3IntegerRelativeCoordinates.relativeCoordinates`
--       (`relativeCoordinateIso` is in the file).  These are census
--       defects, not mathematics, and are NOT repaired here ‚î the
--       instrument is another seat's file.
--
--     ¬ Some are receipts with a recovery map that is still not an
--       address, which is exactly Pata ¬ß‡ arriving from the other side.
--       `the deleted Swarm.S01PaniniAshby.sig : SmithState ‚í Bool ó Bool` is
--       injective (`sigDistinct01/02/12`) and cannot be surjective:
--       three states, four signatures.  That file's own reading ‚î
--       Ashby's variety bound ‚î is why.  `
--       AdaptiveProbeCollapse.staticTriple : St ‚í Bool ó Bool ó Bool`
--       has its retraction proved (`static-budget-3-identifies`) and the
--       same obstruction.  Neither is proved non-invertible here.
--
--     WHAT THE CENSUS DOES WITH THIS FILE, checked by re-running it
--     after ¬ß‡® and ¬ß‡© landed.  `colsOf` leaves the queue: `‡‡‡‡Æ‡‡-‡‡Æ‡‡æ`
--     is picked up as a causeway and `Col ‚ü ‚ ó ‚ ó ‚` is joined.
--     `compileContext` DOES NOT leave it, and the reason is not
--     mathematical ‚î `‡‡®‡‡¶‡∞‡‡-‡‡Æ‡‡æ` is stated over a bound `X`, and the
--     census discards any conclusion mentioning a binder, while it
--     resolves the adapter's own implicit `X` to the unrelated
--     definition `TwoProjections.X`.  So the queue will
--     keep printing that edge.  The theorem is ¬ß‡® and the queue entry
--     is the instrument, and they disagree; the instrument is another
--     seat's file and is not touched here.
--
------------------------------------------------------------------------
