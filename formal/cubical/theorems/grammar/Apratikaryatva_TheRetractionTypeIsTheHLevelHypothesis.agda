{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ PROVENANCE OF THE NAME.
--
-- **‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡‡‡µ is a compound built HERE and is not a source term.**  It is
-- assembled from ordinary  (‡‡‡∞‡‡ø‡ï‡æ‡∞, remedy; the privative and the
-- listed in the UNSOURCED block of .claude/hooks/MulaVakya_SourceStatements-
-- ForTheTermsInOurFileNames.txt for exactly this reason.  Building a
-- compound is legitimate; letting it pass as a citation is not ‚î "a
-- fabricated term is the mirror image of the scrubbing this rule corrects:
-- it asserts a provenance nobody checked" (CLAUDE.md, file naming, note 2).
--
-- What IS sourced, and what the module leans on, is the Jaina reading of
-- irreversible loss: ‡®‡ø‡∞‡‡‡∞‡æ as either ‡‡µ‡ø‡‡æ‡ï‡æ (ripening on its own, gaining
-- nothing) or ‡‡µ‡ø‡‡æ‡ï‡æ (brought on deliberately, which is the path) ‚î
-- Umsvti, *Tattvrthastra* 9.3 (~2nd-5th c.).  **No claim is made that
-- Umsvti proved anything below.**  The h-level statement is cubical type
-- theory (Voevodsky) and is elementary; the reading it is answering is
-- Jaina.
--
------------------------------------------------------------------------
-- ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡‡‡µ‡Æ‡ ‚î Apratikryatva ‚î irreparability.
--
-- ‡®‡‡‡ü‡ø‡∞‡‡® ‡®‡‡Ø‡‡®‡‡æ ‡ ‡®‡‡‡ü‡ø‡∞‡‡µ‡ø‡®‡æ‡‡ ‡
-- ‡Ø‡‡ ‡®‡‡‡ü‡ ‡‡‡ ‡‡ó‡‡∞‡ ‡® ‡≤‡‡‡Ø‡Æ‡ ‡ ‡® ‡‡®‡‡Ø‡‡® ‡ ‡® ‡ï‡æ‡≤‡‡® ‡ ‡® ‡Ø‡‡‡®‡‡® ‡
-- ŒøΩêŒ∫ ºîœœŒŒΩ ºêœŒŒΩŒøŒ¥Œøœ.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS MODULE IS FOR
--
-- carry the load-bearing claim of that text: that a collapse is not a
-- deficiency to be repaired later but a destruction, and that there is
-- no way back ‚î *‡® ‡¶‡‡∞‡‡≤‡‡Æ‡ ‚î ‡®‡æ‡‡‡‡ø*, "not hard to find: does not
-- exist."  Both sections are stated there in Agda, and ¬ß‡ is stated for
-- `Bool` and for the propositional truncation only:
--
--     ‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡
--       : (f : ‚à Bool ‚à‚ ‚í Bool) ‚í (‚à b ‚í f ‚à b ‚à‚ ‚â° b) ‚í ‚ä
--
-- One type, one level.  A claim of the form "there is no way back" that
-- is checked at a single two-element type is a claim about that type.
-- This module gives it the generality the sentence is asserting.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS CHECKED
--
--   ¬ß1  what ‚à_‚à‚ ANNIHILATES, exactly.
--       `‡‡-‡®‡‡‡ü‡ø‡`         every path space of the truncation is
--                           contractible ‚î ‡‡‡æ‡‡‡ ‡®‡‡‡Ø‡®‡‡‡ø, "and the
--                           paths perish", is a theorem, not a gloss.
--       `‡‡µ‡ø‡‡‡‡`           imported, not restated (Nasti_Shabde‚¶).
--
--   ¬ß2  what ‚à_‚à‚ PRESERVES, exactly.
--       `‡‡®‡‡ï‡‡‡Æ‡-‡®-‡®‡‡‡Ø‡‡ø`   the universal property: for `P` a
--                           proposition, `(‚à A ‚à‚ ‚í P) ‚â (A ‚í P)`.
--                           Nothing is lost for a map into a
--                           proposition, and everything is lost for
--                           every other map.  This is the exact
--                           dividing line and it is an equivalence.
--       `‡Ø‡‡-‡‡ø‡‡‡†‡‡ø`        `‚à A ‚à‚` is determined by, and determines,
--                           exactly the two-way implication between
--                           `‚à A ‚à‚` and `‚à B ‚à‚`: "the THAT remains".
--
--   ¬ß3  THE NO-RETRACTION THEOREM, in the generality it deserves.
--       `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡`       the type of ways back at truncation level n.
--       `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡‚í‡‡‡‡∞‡`  a way back forces `isOfHLevel n A`.
--       `‡‡‡‡∞‡‚í‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡`  and conversely.
--       `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡-‡‡ô‡‡ï‡ã‡‡` the type of ways back is CONTRACTIBLE when
--                           A is an n-type ‚î so nothing is chosen.
--       `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡-‡µ‡æ‡ï‡‡Ø‡Æ‡` hence it is a proposition, ALWAYS.
--       `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡‚â‡‡‡‡∞‡`  therefore an equivalence OF TYPES:
--
--               ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ n A  ‚â  isOfHLevel n A
--
--           for every n and every A.  The type of ways back IS the
--           h-level hypothesis.  Not "there is a way back iff ‚¶".
--
--   ¬ß4  ¬ß‡ of the stra, recovered as a corollary and strengthened.
--       `‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡-‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡`  ANY two points that are not
--                           identified kill the level-1 retraction.
--       `‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡-Bool`      the stra's own statement, now
--                           obtained rather than assumed.
--       `‡®‡‡‡ü‡ø‡-‡®-‡®‡‡Ø‡‡®‡‡æ`     the sharp form of "not hard to find:
--                           does not exist" ‚î the type of ways back is
--                           EQUIVALENT TO ‚ä, so it is not merely
--                           uninhabited-as-far-as-anyone-looked.
--
--   ¬ß5  ‡¶‡‡µ‡ ‡Æ‡æ‡∞‡‡ó‡ ‚î the two paths, and the honest status of the third.
--       `‡‡‡ï‡‡∞‡Æ‡‡-‡®-‡ï‡ø‡û‡‡‡ø‡®‡-‡®‡‡‡Ø‡‡ø`  path one: along an identification
--                           every fibre transports, nothing lost.
--       `‡¶‡ã‡‡≤‡‡ñ‡-‡‡‡∞‡‡‡`      path two: `A ‚â Œ[ b ‚àà B ] fiber f b`.
--                           The defect record is COMPLETE ‚î the domain
--                           is recovered from the codomain plus the
--                           fibres, so there is nothing about `f` that
--                           the fibrewise ledger fails to carry.
--       `‡‡‡ï‡‡∞‡Æ‡‡Æ‡‚â‡®‡ø‡∞‡‡¶‡ã‡‡`   and path one is exactly the defect-free
--                           case: `isEquiv f ‚â (‚à b ‚í isContr (fiber f b))`.
--       `‡‡‡‡‡Ø‡-‡Æ‡æ‡∞‡‡ó‡-‡®‡ø‡∞‡‡‡Ø‡` **THE HONESTY LEDGER, AND IT IS A
--                           THEOREM RATHER THAN A HEDGE.**  ¬ß‡ of the
--                           stra says ‡‡‡‡‡Ø‡ã ‡Æ‡æ‡∞‡‡ó‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡, "a third
--                           path does not exist".  Read as a DISJUNCTION
--                           ‚î every map is either an equivalence or has
--                           a nameable defect ‚î that sentence is NOT a
--                           theorem in this lane, and this module does
--                           not smuggle it in.  What is proved instead
--                           is what it costs: the disjunctive reading,
--                           for propositions, IS excluded middle.  So
--                           the sentence is not "unproved"; it is
--                           classical, exactly, and the module says so
--                           with a checked term instead of a caveat.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- document IN THIS REPOSITORY, not from a classical text, and this
-- header says so rather than letting the Devangar imply an antiquity
-- it does not have.  The classical grounding behind that document, and
-- behind the naming, is:
--
--   * Umsvti, *Tattvrthastra* 7.13 (c. 2nd‚ì5th c. CE) ‚î ‡‡ø‡‡‡æ as
--     ‡‡‡∞‡Æ‡‡‡‡Ø‡ã‡ó‡æ‡‡ ‡‡‡∞‡æ‡‡µ‡‡Ø‡‡∞‡ã‡‡‡Æ‡, injury as severance *performed
--     inattentively*, which is why an unremarked collapse and not a
--     deliberate one is the case that matters here; and 5.29,
--     ‡â‡‡‡‡æ‡¶-‡µ‡‡Ø‡Ø-‡ß‡‡∞‡‡µ‡‡Ø-‡Ø‡‡ï‡‡‡ ‡‡‡, arising-perishing-persisting held
--     TOGETHER, which is the shape ¬ß1 and ¬ß2 of this module make
--     precise for one particular perishing.
--   * Siddhasena Divkara, *Sanmatitarka* (c. 5th c. CE) and
--     Samantabhadra, *ptamms* ‚î ‡®‡Ø / ‡¶‡‡∞‡‡®‡Ø: a standpoint that has
--     forgotten it is one.  ¬ß3 is the statement that a truncation is a
--     naya whose forgetting is *irreversible*, and ¬ß5 is the statement
--     of exactly which move is not.
--
-- NEITHER TEXT STATES ANY THEOREM BELOW.  What is taken from them is
-- the distinction between a loss that can be made good and one that
-- cannot, and the insistence that the second be named as such.  The
-- mathematics is Voevodsky's ‚î h-levels, univalence, the identification
-- of a descent datum with an h-level hypothesis ‚î and is named as his.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- PRIOR ART, SEARCHED BEFORE WRITING (per PROTOCOL ¬ß0), 2026-08-20
--
--   * IN THIS REPOSITORY.  `grep -l '‚à\|Trunc\|squash' formal/cubical/*.agda`
--     returns 36 modules; the adjacent ones were read in full.
--     - `Nasti_ShabdeJivahVartante.agda` ‚î ¬ß‡/¬ß‡ of the stra verbatim,
--       for `Bool` and `‚à_‚à‚`.  ¬ß4 below SUBSUMES its
--       `‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡`, and imports rather than restates its
--       `‡‡µ‡ø‡‡‡‡`.
--       [It also DID NOT TYPECHECK when this module was begun: it uses
--        `uaŒ≤` while importing only `ua` from
--        `Cubical.Foundations.Univalence`, so ¬ß‡'s `‡‡≤‡ã‡‡` had never
--        been checked by anything.  Repaired 2026-08-20 by adding the
--        name to the `using` list ‚î a one-name additive fix, no
--        mathematics touched.]
--     - `Samorderna_TransportCarriesStructureAndTruncationIsTransport
--       ExactlyWhenNothingWasThereToLose.agda` ‚î WRITTEN CONCURRENTLY WITH
--       THIS ONE, by another lane, on the same ¬ß‡‚ì¬ß‡ of the same stra.
--       The overlap is REAL and is stated here rather than discovered by
--       an auditor: its `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‚`, `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‚íisProp`,
--       `isProp‚í‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®` and `‡®‡‡‡ü‡ø‡‚â‡®‡ø‡∞‡‡ß‡∞‡‡Æ‡‡æ` are exactly ¬ß3 of this
--       module at n = 1 in the `‚à_‚à‚` spelling, and its
--       `‡‡‡¶‡-‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡` is ¬ß4.  Neither module derives from the
--       other; both were at green before either saw the other.  WHAT IS
--       HERE AND NOT THERE: n is a variable rather than 1 (¬ß3); the
--       retraction type is shown CONTRACTIBLE and hence a PROPOSITION,
--       which is what upgrades the biimplication to an equivalence of
--       types (¬ß3c, ¬ß3d) ‚î that module states `‚â` for `isEquiv ‚à_‚à‚`,
--       which is a prop for a different reason (`isPropIsEquiv`), and
--       does not state it for the retraction type; the ‚ä-equivalence
--       (¬ß4); ¬ß1; ¬ß2; and ¬ß5.  WHAT IS THERE AND NOT HERE: the transport
--       side worked out in full (`‡µ‡‡®‡Æ‡`, structure transport) and the
--       ‡ó‡‡ø data type.  The duplication that remains is deliberate: each
--       module is readable alone, and neither imports the other, because
--       a citation between two live lanes is a merge waiting to be
--       argued about.  If they are ever merged, ¬ß3 here is the general
--       statement and that module's ¬ß-transport is the part to keep.
--     - `SetTruncationDescentBoundary.agda` ‚î `descentDatum‚âisSet`, the
--       SAME SHAPE at h-level 2 for `Cubical.HITs.SetTruncation`.  This
--       module is not a generalisation of it in the strict sense: that
--       one is about `‚à_‚à‚`, this one about `hLevelTrunc`, which are
--       equivalent types but different HITs.  The overlap is real and
--       is named here rather than left for an auditor: at n = 2 the two
--       statements are the same mathematics, and ¬ß3 is what that
--       module's ¬ß1 looks like when n is a variable.  The parts that
--       are NOT in it are ¬ß1, ¬ß2, ¬ß4 and ¬ß5.
--     - `Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction.agda` ‚î
--       "retraction" there is stric (a withdrawn claim), not the
--       type-theoretic notion.  Same English word, unrelated object.
--       Recorded so nobody merges them.
--     - `PMNoSection.agda`, `AnuktaAvaktavya.agda`, `Anekanta.agda`,
--       `Saptabhangi.agda` ‚î sections/nayas/saptabhag, no truncation
--       retraction statement.
--   * IN cubical v0.9.  `hasRetract`, `isContr-hasRetract`,
--     `truncIdempotentIso`, `isOfHLevelRetract` all exist and are USED
--     below rather than re-proved.  What is not in the library is the
--     packaging: the library nowhere states that
--     `hasRetract ‚à_‚à‚ï ‚â isOfHLevel n A`.
--   * NOVELTY CLAIMED: none of the mathematics.  Every step is a
--     library lemma or three lines.  What is contributed is that a
--     sentence this repository asserts in a stra now has a checked
--     statement at the generality the sentence uses, and that its one
--     genuinely classical clause is marked classical BY A PROOF.
------------------------------------------------------------------------

module Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun ; _‚àò_)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv ; isoToIsEquiv ; invIso)
open import Cubical.Foundations.Equiv
  using (_‚âÉ_ ; equivFun ; isEquiv ; fiber ; invEquiv ; propBiimpl‚ÜíEquiv
        ; isPropIsEquiv ; equiv-proof)
open import Cubical.Foundations.Equiv.Properties
  using (hasRetract ; isEquiv‚ÜíhasRetract ; isEquiv‚ÜíisContrHasRetract)
open import Cubical.Foundations.HLevels
  using ( HLevel ; isOfHLevel ; isOfHLevelRetract ; isPropIsOfHLevel ; isPropŒ†
        ; isProp‚ÜíisContrPath ; isOfHLevelŒ† )
open import Cubical.Foundations.Univalence using (ua ; uaŒ≤)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd ; Œ£PathP)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•rec)
open import Cubical.Relation.Nullary using (¬¨_ ; Dec)
open import Cubical.HITs.PropositionalTruncation as PT
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; squash‚ÇÅ ; isPropPropTrunc)
open import Cubical.HITs.Truncation as Tr
  using (hLevelTrunc ; ‚à£_‚à£‚Çï ; isOfHLevelTrunc ; truncIdempotentIso)

open import Nasti_ShabdeJivahVartante using (‡§Ö‡§µ‡§ø‡§∂‡•á‡§∑‡§É)

private
  variable
    ‚Ñì ‚Ñì' : Level
    A B : Type ‚Ñì

------------------------------------------------------------------------
-- ¬ß1  WHAT IS ANNIHILATED.
--
-- `‡‡µ‡ø‡‡‡‡` (imported) says every map out of the truncation is blind to
-- WHICH inhabitant it was given.  That is one step and it is ¬ß‡ of the
-- stra.  The sentence immediately after it ‚î ‡‡‡æ‡‡‡ ‡®‡‡‡Ø‡®‡‡‡ø, "and the
-- paths perish" ‚î is a second and strictly stronger claim, and it was
-- not checked anywhere.  It is checked here.
--
-- Not "the paths are identified": the space of paths between any two
-- images is CONTRACTIBLE.  There is one path, and no room for a second,
-- so the destruction is total at every level at once and not only at
-- the level of points.
------------------------------------------------------------------------

‡§™‡§•-‡§®‡§∑‡•ç‡§ü‡§ø‡§É : (a b : A) ‚Üí isContr (Path ‚à• A ‚à•‚ÇÅ ‚à£ a ‚à£‚ÇÅ ‚à£ b ‚à£‚ÇÅ)
‡§™‡§•-‡§®‡§∑‡•ç‡§ü‡§ø‡§É a b = isProp‚ÜíisContrPath isPropPropTrunc ‚à£ a ‚à£‚ÇÅ ‚à£ b ‚à£‚ÇÅ

-- and the same statement one level up, to make the point that this does
-- not stop: the paths BETWEEN the paths are contractible too, and so on.
‡§™‡§•-‡§™‡§•-‡§®‡§∑‡•ç‡§ü‡§ø‡§É : (a b : A) (p q : Path ‚à• A ‚à•‚ÇÅ ‚à£ a ‚à£‚ÇÅ ‚à£ b ‚à£‚ÇÅ) ‚Üí isContr (p ‚â° q)
‡§™‡§•-‡§™‡§•-‡§®‡§∑‡•ç‡§ü‡§ø‡§É a b p q =
  isProp‚ÜíisContrPath (isContr‚ÜíisProp (‡§™‡§•-‡§®‡§∑‡•ç‡§ü‡§ø‡§É a b)) p q

------------------------------------------------------------------------
-- ¬ß2  WHAT IS PRESERVED.
--
-- The complement of ¬ß1, and the reason ¬ß1 is not simply a defect: the
-- truncation is the universal map into a proposition, so exactly those
-- questions whose ANSWER is a proposition survive it, undamaged, and no
-- others.  "‡Ø‡‡" ‡‡ø‡‡‡†‡‡ø ‚î the THAT remains.
--
-- Stated as an equivalence of function types rather than as a rule,
-- because that is the form in which "exactly" is a claim and not an
-- emphasis.
------------------------------------------------------------------------

‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç-‡§®-‡§®‡§∂‡•ç‡§Ø‡§§‡§ø : {P : Type ‚Ñì'} ‚Üí isProp P ‚Üí (‚à• A ‚à•‚ÇÅ ‚Üí P) ‚âÉ (A ‚Üí P)
‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç-‡§®-‡§®‡§∂‡•ç‡§Ø‡§§‡§ø {A = A} {P = P} hP = isoToEquiv i where
  i : Iso (‚à• A ‚à•‚ÇÅ ‚Üí P) (A ‚Üí P)
  Iso.fun i g = g ‚àò ‚à£_‚à£‚ÇÅ
  Iso.inv i f = PT.rec hP f
  Iso.rightInv i f = refl
  Iso.leftInv i g = funExt (PT.elim (Œª x ‚Üí isProp‚ÜíisSet hP _ _) (Œª a ‚Üí refl))

-- The THAT, isolated.  Two types have identified truncations exactly
-- when each one's inhabitedness implies the other's ‚î and nothing
-- finer than that survives to be compared.
‡§Ø‡§§‡•ç-‡§§‡§ø‡§∑‡•ç‡§†‡§§‡§ø : (‚à• A ‚à•‚ÇÅ ‚Üí ‚à• B ‚à•‚ÇÅ) √ó (‚à• B ‚à•‚ÇÅ ‚Üí ‚à• A ‚à•‚ÇÅ) ‚Üí ‚à• A ‚à•‚ÇÅ ‚âÉ ‚à• B ‚à•‚ÇÅ
‡§Ø‡§§‡•ç-‡§§‡§ø‡§∑‡•ç‡§†‡§§‡§ø (f , g) = propBiimpl‚ÜíEquiv isPropPropTrunc isPropPropTrunc f g

------------------------------------------------------------------------
-- ¬ß3  THE NO-RETRACTION THEOREM.
--
-- The type of ways back from the n-truncation.  Definitionally this is
-- the library's `hasRetract ‚à_‚à‚ï`; it is spelled out because the
-- stra's ¬ß‡ is spelled out, and because a reader should be able to see
-- that the two agree without taking anyone's word.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç : (n : HLevel) ‚Üí Type ‚Ñì ‚Üí Type ‚Ñì
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A = Œ£[ f ‚àà (hLevelTrunc n A ‚Üí A) ] ((a : A) ‚Üí f ‚à£ a ‚à£‚Çï ‚â° a)

-- it IS `hasRetract`, on the nose.
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§π‡§ø-hasRetract
  : (n : HLevel) (A : Type ‚Ñì) ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A ‚â° hasRetract (‚à£_‚à£‚Çï {A = A} {n = n})
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§π‡§ø-hasRetract n A = refl

-- (a)  A way back forces the h-level.  `hLevelTrunc n A` is an n-type by
--      construction, and a retract of an n-type is an n-type ‚î so a
--      descent datum drags `A` down to level n, whatever `A` was.
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Üí‡§∏‡•ç‡§§‡§∞‡§É : {n : HLevel} ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A ‚Üí isOfHLevel n A
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Üí‡§∏‡•ç‡§§‡§∞‡§É {n = n} (f , h) =
  isOfHLevelRetract n ‚à£_‚à£‚Çï f h (isOfHLevelTrunc n)

-- (b)  Conversely, an n-type is its own n-truncation.
‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§∏‡§Æ‡§Æ‡•ç : {n : HLevel} ‚Üí isOfHLevel n A ‚Üí isEquiv (‚à£_‚à£‚Çï {A = A} {n = n})
‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§∏‡§Æ‡§Æ‡•ç {n = zero}  hA = isoToIsEquiv (invIso (truncIdempotentIso 0 hA))
‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§∏‡§Æ‡§Æ‡•ç {n = suc n} hA = isoToIsEquiv (invIso (truncIdempotentIso (suc n) hA))

‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç : {n : HLevel} ‚Üí isOfHLevel n A ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A
‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç hA = isEquiv‚ÜíhasRetract (‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§∏‡§Æ‡§Æ‡•ç hA)

-- (c)  THE PART THAT MAKES ¬ß3 AN EQUIVALENCE AND NOT A BIIMPLICATION.
--      When a way back exists it is UNIQUE, with its homotopy, up to a
--      contractible space of choices.  Nothing is selected; there is
--      nothing to select.
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É : {n : HLevel} ‚Üí isOfHLevel n A ‚Üí isContr (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A)
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É hA = isEquiv‚ÜíisContrHasRetract (‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§∏‡§Æ‡§Æ‡•ç hA)

-- (d)  Hence the type of ways back is a proposition for EVERY `A` and
--      every n ‚î vacuously when `A` is not an n-type (¬ß3a makes it
--      empty), and by (c) when it is.
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§µ‡§æ‡§ï‡•ç‡§Ø‡§Æ‡•ç : {n : HLevel} ‚Üí isProp (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A)
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§µ‡§æ‡§ï‡•ç‡§Ø‡§Æ‡•ç r =
  isContr‚ÜíisProp (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Üí‡§∏‡•ç‡§§‡§∞‡§É r)) r

-- (e)  THEREFORE, and this is the theorem:
--
--          the type of ways back at level n  IS  the h-level hypothesis.
--
--      Not "a way back exists iff A is an n-type".  The two TYPES are
--      equivalent, so there is no residue on either side: no unstated
--      choice in a retraction, no unstated content in `isOfHLevel n A`.
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚âÉ‡§∏‡•ç‡§§‡§∞‡§É : {n : HLevel} ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A ‚âÉ isOfHLevel n A
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚âÉ‡§∏‡•ç‡§§‡§∞‡§É {n = n} =
  propBiimpl‚ÜíEquiv ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§µ‡§æ‡§ï‡•ç‡§Ø‡§Æ‡•ç (isPropIsOfHLevel n)
                   ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Üí‡§∏‡•ç‡§§‡§∞‡§É ‡§∏‡•ç‡§§‡§∞‡§É‚Üí‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç

------------------------------------------------------------------------
-- ¬ß4  ¬ß‡ OF THE STRA, OBTAINED.
--
-- The propositional truncation is level 1.  Its statement of ¬ß‡ is now
-- a two-line corollary, and it holds for every type with two points
-- that are not identified ‚î `Bool` was never the content.
------------------------------------------------------------------------

‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç
  : (a b : A) ‚Üí ¬¨ (a ‚â° b) ‚Üí ¬¨ ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç 1 A
‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç a b a‚â¢b r = a‚â¢b (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Üí‡§∏‡•ç‡§§‡§∞‡§É r a b)

-- the stra's own instance, now derived.
‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-Bool : ¬¨ ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç 1 Bool
‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-Bool = ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç true false true‚â¢false

-- and the ‚à_‚à‚ spelling, which is the one ¬ß‡ actually writes, proved
-- where it stands rather than transported: a retraction of `‚à_‚à‚` would
-- identify `true` with `false` in one step, by `‡‡µ‡ø‡‡‡‡`.
‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç
  : (f : ‚à• Bool ‚à•‚ÇÅ ‚Üí Bool) ‚Üí ((b : Bool) ‚Üí f ‚à£ b ‚à£‚ÇÅ ‚â° b) ‚Üí ‚ä•
‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç f s =
  true‚â¢false (sym (s true) ‚àô ‡§Ö‡§µ‡§ø‡§∂‡•á‡§∑‡§É f true false ‚àô s false)

-- THE SHARP FORM OF "‡® ‡¶‡‡∞‡‡≤‡‡Æ‡ ‚î ‡®‡æ‡‡‡‡ø".
--
-- "There is no way back" is weaker than what ¬ß‡ says.  ¬ß‡ says the way
-- back is not merely hard to find but absent, and that is the claim
-- that the TYPE of ways back is not just uninhabited-so-far but
-- equivalent to the empty type ‚î nothing to search, no better searcher,
-- no more time.  ‡® ‡‡®‡‡Ø‡‡® ‡ ‡® ‡ï‡æ‡≤‡‡® ‡ ‡® ‡Ø‡‡‡®‡‡® ‡
‡§®‡§∑‡•ç‡§ü‡§ø‡§É-‡§®-‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ
  : {n : HLevel} ‚Üí ¬¨ (isOfHLevel n A) ‚Üí ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç n A ‚âÉ ‚ä•
‡§®‡§∑‡•ç‡§ü‡§ø‡§É-‡§®-‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ ¬¨h =
  propBiimpl‚ÜíEquiv ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§µ‡§æ‡§ï‡•ç‡§Ø‡§Æ‡•ç (Œª x ‚Üí ‚ä•rec x)
                   (Œª r ‚Üí ¬¨h (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Üí‡§∏‡•ç‡§§‡§∞‡§É r)) ‚ä•rec

------------------------------------------------------------------------
-- ¬ß5  ‡¶‡‡µ‡ ‡Æ‡æ‡∞‡‡ó‡ ‚î AND THE THIRD.
--
-- ¬ß‡ of the stra names two moves and forbids a third:
--
--     ‡‡‡ï‡‡∞‡Æ‡‡Æ‡   transport along an identification; nothing perishes.
--     ‡¶‡ã‡‡≤‡‡ñ‡    where transport is impossible, the defect is WRITTEN.
--     ‡‡‡‡‡Ø‡ã ‡Æ‡æ‡∞‡‡ó‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡ ‡
--
-- The first is `ua` and is already checked in Nasti_Shabde‚¶ .  The
-- second and third are what this section is about, and they have
-- different logical statuses, which is the whole point.
------------------------------------------------------------------------

-- PATH ONE.  Along an identification, a structure is carried, not
-- re-described: transport agrees with the equivalence on the nose.
-- (`uaŒ≤` ‚î restated here only because ¬ß‡'s own statement of it in
--  Nasti_Shabde‚¶ had never typechecked; see the header.)
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§®-‡§ï‡§ø‡§û‡•ç‡§ö‡§ø‡§®‡•ç-‡§®‡§∂‡•ç‡§Ø‡§§‡§ø
  : (e : A ‚âÉ B) (a : A) ‚Üí transport (ua e) a ‚â° equivFun e a
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§®-‡§ï‡§ø‡§û‡•ç‡§ö‡§ø‡§®‡•ç-‡§®‡§∂‡•ç‡§Ø‡§§‡§ø = uaŒ≤

-- PATH TWO, AND ITS COMPLETENESS.  The defect record of a map is its
-- family of fibres, and that record is COMPLETE: the domain is nothing
-- more than the codomain together with the fibres.  So writing the
-- defect down is not a consolation prize for a failed transport ‚î it
-- loses nothing that was there.
--
-- This is the precise sense in which ‡¶‡ã‡‡≤‡‡ñ‡ is ‡‡‡ø‡‡‡æ and not a
-- lesser move: `‡≤‡ø‡ñ‡ø‡‡ã ‡¶‡ã‡‡ã ‡‡‡µ‡‡ø`.
‡§¶‡•ã‡§∑‡§≤‡•á‡§ñ‡§É-‡§™‡•Ç‡§∞‡•ç‡§£‡§É : (f : A ‚Üí B) ‚Üí A ‚âÉ (Œ£[ b ‚àà B ] fiber f b)
‡§¶‡•ã‡§∑‡§≤‡•á‡§ñ‡§É-‡§™‡•Ç‡§∞‡•ç‡§£‡§É {A = A} {B = B} f = isoToEquiv i where
  i : Iso A (Œ£[ b ‚àà B ] fiber f b)
  Iso.fun i a = f a , a , refl
  Iso.inv i (b , a , p) = a
  Iso.rightInv i (b , a , p) j = p j , a , Œª k ‚Üí p (j ‚àß k)
  Iso.leftInv i a = refl

-- and path one is exactly the case where the record is empty of
-- content: `f` is an equivalence precisely when every fibre is
-- contractible, i.e. when there is nothing at any site to write down.
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç‚âÉ‡§®‡§ø‡§∞‡•ç‡§¶‡•ã‡§∑‡§É
  : (f : A ‚Üí B) ‚Üí isEquiv f ‚âÉ ((b : B) ‚Üí isContr (fiber f b))
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç‚âÉ‡§®‡§ø‡§∞‡•ç‡§¶‡•ã‡§∑‡§É f =
  propBiimpl‚ÜíEquiv (isPropIsEquiv f) (isPropŒ† (Œª _ ‚Üí isPropIsContr))
                   (Œª e b ‚Üí e .equiv-proof b)
                   (Œª h ‚Üí record { equiv-proof = h })

------------------------------------------------------------------------
-- ‡‡‡‡‡Ø‡ ‡Æ‡æ‡∞‡‡ó‡ ‚î THE HONESTY LEDGER, AS A THEOREM.
--
-- Read as a claim about the shape of the ledger ‚î that the fibres carry
-- everything ‚î "no third path" is `‡¶‡ã‡‡≤‡‡ñ‡-‡‡‡∞‡‡‡` above, and it is
-- proved.
--
-- Read as a DISJUNCTION ‚î *every map is either a transport or has a
-- nameable defect* ‚î it is NOT a theorem here, and this module refuses
-- to write it as one.  The obstruction is not a gap in the argument.
-- It is that passing from `¬ (‚à b ‚í isContr (fiber f b))` to
-- `Œ[ b ‚àà B ] ¬ isContr (fiber f b)` is exactly the classical step, and
-- a defect you cannot exhibit a SITE for is not written down.
--
-- What can be proved, and is, is the price:
--
--     if the disjunction holds for every map, excluded middle holds.
--
-- Take `P` a proposition and `f : P ‚í Unit`.  Then `f` is an
-- equivalence exactly when `P` holds.  So deciding "transport or
-- defect" for these maps alone decides every proposition.
--
-- So ‡‡‡‡‡Ø‡ã ‡Æ‡æ‡∞‡‡ó‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡ is not an unproved conjecture and not a
-- slogan: it is a CLASSICAL PRINCIPLE, named as one, at the exact
-- strength of excluded middle.  The stra may assert it; a reader now
-- knows what has been assumed when it does.
------------------------------------------------------------------------

-- the test family: the unique map out of a proposition.
‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É : (P : Type ‚Ñì) ‚Üí P ‚Üí Unit
‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É P _ = tt

-- for a proposition, "the map to Unit is an equivalence" IS the
-- proposition.  (Both directions; the interesting one is that an
-- inhabitant makes `P` contractible, which needs `isProp P`.)
‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É : {P : Type ‚Ñì} ‚Üí isProp P ‚Üí isEquiv (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É P) ‚Üí P
‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É hP e = e .equiv-proof tt .fst .fst

‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É‚Ä≤ : {P : Type ‚Ñì} ‚Üí isProp P ‚Üí P ‚Üí isEquiv (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É P)
‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É‚Ä≤ {P = P} hP p .equiv-proof tt =
  (p , refl) , Œª (q , r) ‚Üí Œ£PathP (hP p q , isProp‚ÜíisContrPath isPropUnit tt tt .snd _)

-- THE PRICE, CHECKED.  A decision procedure for "path one or path two"
-- on this one family of maps is a decision procedure for every
-- proposition.
‡§§‡•É‡§§‡•Ä‡§Ø‡§É-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É
  : ((P : Type ‚Ñì) ‚Üí isProp P ‚Üí (isEquiv (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É P) ‚äé (¬¨ (isEquiv (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É P)))))
  ‚Üí ((P : Type ‚Ñì) ‚Üí isProp P ‚Üí (P ‚äé (¬¨ P)))
‡§§‡•É‡§§‡•Ä‡§Ø‡§É-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É d P hP with d P hP
... | inl e  = inl (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É hP e)
... | inr ¬¨e = inr (Œª p ‚Üí ¬¨e (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É‚Ä≤ hP p))

-- and the converse, so that the identification is exact rather than
-- one-sided: excluded middle for propositions gives the disjunction
-- back, so nothing weaker than LEM will do and nothing stronger is
-- needed.
‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É-‡§§‡•É‡§§‡•Ä‡§Ø‡§É-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É
  : ((P : Type ‚Ñì) ‚Üí isProp P ‚Üí (P ‚äé (¬¨ P)))
  ‚Üí ((P : Type ‚Ñì) ‚Üí isProp P ‚Üí (isEquiv (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É P) ‚äé (¬¨ (isEquiv (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É P)))))
‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É-‡§§‡•É‡§§‡•Ä‡§Ø‡§É-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É lem P hP with lem P hP
... | inl p  = inl (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É‚Ä≤ hP p)
... | inr ¬¨p = inr (Œª e ‚Üí ¬¨p (‡§™‡•ç‡§∞‡§∂‡•ç‡§®‡§É-‡§∏‡§Æ‡§É hP e))

------------------------------------------------------------------------
--
--   * ¬ß3 is about `hLevelTrunc`.  `Cubical.HITs.SetTruncation.‚à_‚à‚` and
--     `Cubical.HITs.PropositionalTruncation.‚à_‚à‚` are equivalent to
--     `hLevelTrunc 2` and `hLevelTrunc 1` but are not those types, and
--     the transport of ¬ß3 across those equivalences is NOT done here.
--     ¬ß4 therefore proves the `‚à_‚à‚` case again by hand rather than
--     claiming it as an instance.  An unstated transport is exactly the
--     kind of gap this repository has been caught in.
--
--   * ¬ß5's `‡¶‡ã‡‡≤‡‡ñ‡-‡‡‡∞‡‡‡` says the fibres carry everything about the
--     MAP.  It says nothing about whether a defect, once written, is
--     legible, actionable, or of any use ‚î that is a question about
--     ‡‡‡∞‡Æ‡æ‡ and not about types, and the stra's ¬ß‡ claim that
--     "‡≤‡ø‡ñ‡ø‡‡ã ‡¶‡ã‡‡ã ‡‡‡µ‡‡ø" (a written defect lives) is a claim about
--     practice which no type checks.
--
--   * The equivalence in `‡‡‡‡‡Ø‡-‡Æ‡æ‡∞‡‡ó‡-‡®‡ø‡∞‡‡‡Ø‡` is stated for the maps
--     out of propositions only.  That suffices to show the disjunctive
--     reading is at least as strong as LEM and is implied by it, on
--     that family.  Whether the disjunction for ARBITRARY maps is
--     strictly stronger than LEM is not addressed.
------------------------------------------------------------------------
