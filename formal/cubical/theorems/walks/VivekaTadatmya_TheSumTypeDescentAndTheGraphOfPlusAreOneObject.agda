{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡ø‡µ‡‡ï-‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡ ‚î the sum-type descent-record and the graph-of-plus
-- record are ONE object.
--
-- Two modules carry a ‡µ‡ø‡µ‡‡ï, and until now nothing joined them:
--
--   ‚ LosslessReturn.‡µ‡ø‡µ‡‡ï ‚î a DATA type (‡‡Æ d | ‡µ‡æ‡Æ d k | ‡¶‡ï‡‡‡ø‡ d k), the
--     lossless descent-record of ryabhaa's kuaka reading, which its
--     own file proved satisfies  (‚ï ó ‚ï) ‚â° ‡µ‡ø‡µ‡‡ï  (‡Ø‡‡ó‡‡Æ‚â°‡µ‡ø‡µ‡‡ï), by an
--     Iso whose two faces are ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ and ‡‡µ‡‡∞‡-‡â‡‡‡‡æ‡®.
--
--   ‚ VivekaPramana_TheRemainderIsLawfulAndTheNetBeats.‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ ‚î a
--     RECORD (‡‡Æ ‡µ‡æ‡Æ ‡¶‡ï‡‡‡ø‡ : ‚ï) with the law ‡¶‡ï‡‡‡ø‡ ‚â° ‡‡Æ + ‡µ‡æ‡Æ, i.e. the
--     graph of +, which its own file proved satisfies
--     (‚ï ó ‚ï) ‚â° ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡  (‚ïó‚ï‚â°‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡), a graph being a family
--     of singletons.
--
-- Both banks are the SAME pair of naturals seen two ways ‚î one as a data
-- constructor recording which side outlasted, one as a record whose third
-- field is pinned to the sum of the first two.  So the causeway is exactly
-- the composite
--
--     ‡µ‡ø‡µ‡‡ï  ‚â°  (‚ï ó ‚ï)  ‚â°  ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ ,
--
-- the first path reversed from LosslessReturn, the second taken from
-- VivekaPramana.  This is ‡‡‡‡‡∞ ‡Æ (an identification, never an estimate)
-- and ‡‡‡‡‡∞ ‡ß‡ß's first road (the equivalence exists, so transport carries
-- it; no hand proof is written here, none is needed).
--
-- NO NEW MATHEMATICS.  Both halves are the source modules' own theorems,
-- consumed not reproved.  The `‚ï ó ‚ï` of each module reduces to the same
-- Œ ‚ï (Œª _ ‚í ‚ï), so the two paths compose on the nose ‚î the kernel is the
-- witness, not this comment.
--
-- WHAT THIS DOES AND DOES NOT CLAIM.  It claims a path of TYPES between
-- the two ‡µ‡ø‡µ‡‡ï encodings, obtained by composing the two univalence
-- bridges.  It does NOT claim the two descent encodings agree
-- coordinate-for-coordinate (they read ‚ï ó ‚ï differently ‚î one as
-- min-and-overhang, one as the two summands); it claims only that as
-- types they are one, which is all a naya-join asserts.
--
-- TERM.  ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø ‚î essential identity, sameness of tattva; a technical
-- term of Indian philosophy (Nyya-Vaieika, and Advaita's ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø-
-- ‡‡Æ‡‡‡®‡‡ß).  LosslessReturn already uses ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡ for the ‡‡Æ / equal case
-- (a = b = d).  The compound ‡µ‡ø‡µ‡‡ï-‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø is built here, 2026-08-22; no
-- historical source is claimed to have stated this theorem.  Substrate
-- cubical (Voevodsky).
--
-- CHECKED: Agda + agda/cubical, --cubical --safe, no postulates, no
-- holes, no sorry.
------------------------------------------------------------------------

module VivekaTadatmya_TheSumTypeDescentAndTheGraphOfPlusAreOneObject where

open import Cubical.Foundations.Prelude using (_‚â°_ ; sym ; _‚àô_)

import LosslessReturn as P
import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as R

-- ‡µ‡ø‡µ‡‡ï (sum type)  ‚â°  (‚ï ó ‚ï)  ‚â°  ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ (record), composed.
‡§µ‡§ø‡§µ‡•á‡§ï-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : P.‡§µ‡§ø‡§µ‡•á‡§ï ‚â° R.‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
‡§µ‡§ø‡§µ‡•á‡§ï-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç = sym P.‡§Ø‡•Å‡§ó‡•ç‡§Æ‚â°‡§µ‡§ø‡§µ‡•á‡§ï ‚àô R.‚Ñï√ó‚Ñï‚â°‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
