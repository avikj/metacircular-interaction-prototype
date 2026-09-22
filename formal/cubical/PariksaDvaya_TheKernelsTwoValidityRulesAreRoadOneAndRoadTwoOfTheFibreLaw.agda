{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡∞‡‡ï‡‡‡æ-‡¶‡‡µ‡Ø‡Æ‡ ‚î the two examinations.  The metacircular kernel's two
-- validity rules (kernel/nodes/002, 003) are road one and road two of the
-- fibre law, and their orthogonality (kernel/nodes/006) is a theorem about
-- the universal decomposition A ‚â Œ[b] fiber f b ‚î not prose in a markdown
-- node.
--
-- THE KERNEL, IN ITS OWN WORDS.  kernel/nodes/006-fork-discharged.md proves
-- the two candidate validity rules detect DISJOINT, EXHAUSTIVE error
-- classes, forced by node 001's content/gauge split:
--   002 ‚î validity by decidable check: catches derivation-internal error,
--         and STRUCTURALLY CANNOT catch a frame error ("a gauge is not
--         outside the [technique] library ‚î it is inside it, wearing the
--         right type").
--   003 ‚î validity by conservation across re-derivation: catches the frame
--         error (the well-typed gauge that froze a variable).
-- Node 006's result: "the two detect disjoint, exhaustive error classes ‚¶
-- orthogonality, not subsumption."
--
-- THE FIBRE LAW.  SarvavibhagaH: for every f : A ‚í B,
--   ‡‡∞‡‡µ‡µ‡ø‡‡æ‡ó‡ : A ‚â Œ[ b ‚àà B ] fiber f b     (the universal decomposition,
-- the totalEquiv; Return.Carrier f is its total space).  The SOURCE
-- projection is an equivalence for EVERY f.  The TARGET side ‚î whether each
-- fiber f b is contractible ‚î is `isEquiv f`, and a non-equivalence loses
-- there.
--
-- THE IDENTIFICATION.  The two are the same partition:
--   ROAD ONE  = 002's reach.  A ‚â Œ[b] fiber f b holds for all f: the
--     derivation is well-formed no matter what.  Node 001's "a gauge is
--     well-typed" is exactly this ‚î the decomposition always typechecks, so
--     road-one clearance says nothing about whether f lost anything.
--   ROAD TWO  = 003's invariant.  isEquiv f ‚î every fiber contractible ‚î is
--     whether the frame carried hidden loss.  It is INDEPENDENT of road one.
--
-- So node 006's orthogonality IS: road one holds for every f, road two does
-- not, and a map can be road-one-clear while road-two-failing.  That map is
-- the frame error 002 cannot see ‚î a non-equivalence whose source
-- decomposition still holds.  The frozen Œµ (001's forcing instance, a
-- well-typed statement that dropped a variable) has this exact shape.
------------------------------------------------------------------------

module PariksaDvaya_TheKernelsTwoValidityRulesAreRoadOneAndRoadTwoOfTheFibreLaw where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; _‚âÉ_ ; fiber ; equiv-proof)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import SarvavibhagaH_EveryMapIsTheSumOfItsFibresOverItsCodomainSoTheIsomorphismTheoremIsAnekanta
  using (‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É)

------------------------------------------------------------------------
-- ROAD ONE ‚î 002's reach.  For EVERY map the source decomposes as the sum
-- of its fibres: A ‚â Œ[b] fiber f b.  Always holds; says nothing of frame.
------------------------------------------------------------------------

road-one : {‚Ñì : Level} {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí A ‚âÉ (Œ£[ b ‚àà B ] fiber f b)
road-one f = ‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É f

------------------------------------------------------------------------
-- ROAD TWO ‚î 003's invariant.  Whether the frame lost anything: every
-- fibre contractible, i.e. f is an equivalence.  Independent of road one.
------------------------------------------------------------------------

road-two : {‚Ñì : Level} {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí Type ‚Ñì
road-two f = isEquiv f

------------------------------------------------------------------------
-- ORTHOGONALITY (kernel/nodes/006).  Road one holds for every f; road two
-- does not.  The constant map Bool ‚í Unit is the frame error: road-one
-- clear (its source decomposes, like any map), road-two failing (it
-- collapses two points, so its fibre over tt is Bool, not contractible).
-- A well-typed derivation that lost a degree of freedom ‚î exactly what 002
-- cannot see and 003 catches.
------------------------------------------------------------------------

collapse : Bool ‚Üí Unit
collapse _ = tt

collapse-road-one : Bool ‚âÉ (Œ£[ b ‚àà Unit ] fiber collapse b)
collapse-road-one = road-one collapse

collapse-road-two-fails : ¬¨ (road-two collapse)
collapse-road-two-fails eq =
  true‚â¢false (cong fst (isContr‚ÜíisProp (equiv-proof eq tt) (true , refl) (false , refl)))

-- the frame error, packaged: a single map that 002 clears (road one) and
-- 003 refuses (road two).  Node 006's disjointness, as a term.
frame-error : Œ£[ f ‚àà (Bool ‚Üí Unit) ] ((Bool ‚âÉ (Œ£[ b ‚àà Unit ] fiber f b)) √ó (¬¨ isEquiv f))
frame-error = collapse , collapse-road-one , collapse-road-two-fails
