{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ PROVENANCE OF THE NAME, AND A WARNING ABOUT IT.
--
-- **The mathematics in this module originates in cubical type theory, not in
-- an Indian source, and the name should not be read as claiming otherwise.**
-- `transport`, `ua` and `uaŒ≤` are Voevodsky's univalence as realised in
-- cubical type theory ‚î the substrate this repository is checked in, and the
-- one exception CLAUDE.md grants ("all respects paid to Indians only, plus
-- Voevodsky").  Nothing below is a theorem of any  text.
--
-- ‡‡‡ï‡‡∞‡Æ‡ ¬ sakrama IS a technical term, and it does not mean this.  In
-- Jaina karma theory it is the transition of one karma-prakti into another
-- ‚î *akhagama* with Vrasena's *Dhaval* (~816 CE); ivaarmasri,
-- *Karmaprakti*.  In jyotia, sakrnti is the sun's passage into a sign.
-- **Neither is what this module proves**, and welding the Jaina term onto a
-- path-transport would be the error CLAUDE.md's second naming condition
-- names: "a fabricated term is the mirror image of the scrubbing this rule
-- corrects: it asserts a provenance nobody checked."
--
-- What the name legitimately carries is the READING, from
-- ‡®‡‡‡Ø‡‡ø ‚î which is this repository's own gloss of two paths and no third,
-- and which is what the module makes precise.  A reading is not a citation.
--
------------------------------------------------------------------------
-- ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ ‚î transport as the machine's ONLY identification primitive.
--
-- ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡ ¬ß ‡ (‡¶‡‡µ‡ ‡Æ‡æ‡∞‡‡ó‡) ‡‡‡‡ ‡µ‡¶‡‡ø :
--     ‡‡‡ï‡‡∞‡Æ‡‡ ‡‡‡∞‡‡®‡æ ‡µ‡‡‡ø ‡ ‡‡‡ï‡‡∞‡Æ‡‡ ‡® ‡ï‡ø‡û‡‡‡ø‡®‡ ‡®‡‡‡Ø‡‡ø ‡
--     ‡‡®‡‡Ø‡ã ‡Æ‡æ‡∞‡‡ó‡ã ‡¶‡ã‡‡≤‡‡ñ‡ ‡ ‡‡‡‡‡Ø‡ã ‡Æ‡æ‡∞‡‡ó‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡ ‡
-- ‡‡‡‡∞ ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ ‡â‡ï‡‡‡Æ‡, ‡® ‡‡æ‡ß‡ø‡‡Æ‡ ‡  ‡‡‡‡∞ ‡‡æ‡ß‡‡Ø‡‡ ‡
--
-- (The stra states, in ¬ß6, that in transport the structure is carried and
-- nothing perishes; that the only other move is to WRITE THE DEFECT; and
-- that there is no third road.  ¬ß6 wrote down `‡‡‡ï‡‡∞‡Æ‡‡Æ‡ e = transport (ua e)`
-- and `‡‡≤‡ã‡‡ = uaŒ≤` and stopped there.  Those two lines are the DEFINITION
-- and its COMPUTATION RULE.  Neither of them is the claim.  This module
-- proves the claim.)
--
--
-- WHAT WAS ACTUALLY MISSING, and why the gap was invisible
--
-- `uaŒ≤ e a : transport (ua e) a ‚â° equivFun e a` says that transporting a
-- POINT computes.  It says nothing whatever about STRUCTURE ‚î about what
-- happens to an operation, a predicate, a law, when it is carried across.
-- A reader who has `uaŒ≤` in hand and reads "‡‡‡ï‡‡∞‡Æ‡‡ ‡‡‡∞‡‡®‡æ ‡µ‡‡‡ø" will believe
-- the sentence is discharged.  It is not: uaŒ≤ is a statement about
-- elements of A, and "the structure is carried" is a statement about
-- elements of S A for arbitrary S.  The gap is one quantifier wide and it
-- is exactly the gap between a definition and a theorem.
--
-- Worse, and recorded here because it is the more instructive half:
-- as committed, `Nasti_ShabdeJivahVartante.agda` ‚î the module that IS ¬ß6
-- in this corpus ‚î DID NOT TYPECHECK (uaŒ≤ used, never imported), and no
-- module in `formal/cubical/` imported it, so nothing would ever have run
-- it.  See the dated correction in that file's header.  The section
-- asserting that nothing perishes was itself built by nothing.
--
--
-- WHAT IS PROVED HERE
--
--  ‡ß ¬ ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ is an equivalence, and the return trip is exhibited.
--       Not "invertible in principle": the inverse is a term, and
--       ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ computes the round trip to `refl`-level identity.
--
--  ‡® ¬ ‡‡‡∞‡‡®‡æ ‡µ‡‡‡ø ‚î THE THEOREM.  For an operation of any arity, the
--       carried operation is the conjugate, and `e` is a HOMOMORPHISM for
--       it.  For a predicate, the carried predicate at `e a` is `P a`.
--       This is what "nothing is lost" means when said about structure
--       rather than about points, and it is the form the machine cites:
--       an identification licenses moving the WHOLE object, laws included.
--
--  ‡© ¬ The contrast with ‚à_‚à‚, as ONE statement rather than two.
--       ‚à_‚à‚ IS an identification ‚î is a ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ ‚î EXACTLY WHEN `A` is a
--       proposition, i.e. exactly when there was nothing to lose.  So
--       transport and truncation are not two unrelated moves: truncation
--       is what transport degenerates to at the one h-level where the
--       question "which?" has no answer to destroy.  Everywhere else
--       (¬ isProp A) the retraction does not merely fail to be found ‚î
--       it does not exist.
--
--       Asked as `isEquiv ‚à_‚à‚`, NOT as `hasRetract ‚à_‚à‚`.  The retraction
--       form, at every h-level n and with the retraction type shown
--       contractible, is another lane's and is strictly stronger:
--       `Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.agda`.
--       My first draft of ¬ß3 proved the n = 1 retraction case; on finding
--       theirs I CUT MINE rather than ship a weaker twin, and ¬ß3 below
--       records the cut.  `SetTruncationDescentBoundary.agda` is the
--       ‚à_‚à‚/isSet member of the same family.  Three lanes, one fact,
--       indexed by h-level.
--
--  ‡ ¬ ‡‡‡‡‡‡Ø‡ ‚î there is no third road, in the one form that is a
--       theorem rather than a syntactic remark about a datatype: ANY map
--       that is lossless in both directions IS a transport, and its
--       equivalence is produced AS DATA.  So a lossless move cannot
--       decline to exhibit its identification; if it is lossless the
--       identification is recoverable from it, constructively.
--       The machine cites this one to justify demanding evidence: the
--       demand costs the caller nothing it did not already have.
--
--
-- ‡‡‡∞‡ã‡‡æ‡‡‡ø :
--   ‡â‡Æ‡æ‡‡‡µ‡æ‡‡ø, ‡‡‡‡‡‡µ‡æ‡∞‡‡‡‡‡‡‡∞ ‡.‡Æ / ‡.‡ß‡© (c. 2nd‚ì5th c. CE) ‚î ‡‡‡∞‡Æ‡‡‡‡Ø‡ã‡ó‡æ‡‡
--     ‡‡‡∞‡æ‡‡µ‡‡Ø‡‡∞‡ã‡‡‡ ‡‡ø‡‡‡æ ; ‡‡∞‡‡‡‡∞‡ã‡‡ó‡‡∞‡‡ã ‡‡‡µ‡æ‡®‡æ‡Æ‡ ‡  ‡‡ø‡‡‡æ is analysed there as
--     an act on a ‡‡‡µ, and the ‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞'s move is to read ‡‡ô‡‡ï‡‡‡‡ ‚î the
--     collapse of many determinations into one ‚î as that act.  The reading
--     is the ‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞'s; the ‡‡‡‡‡∞ is Umsvti's.
--   ‡‡ø‡¶‡‡ß‡‡‡® ‡¶‡ø‡µ‡æ‡ï‡∞, ‡‡®‡‡Æ‡‡ø‡‡∞‡‡ï (c. 5th c. CE) ‚î ‡®‡Ø‡µ‡æ‡¶ : a ‡®‡Ø which asserts
--     itself whole becomes ‡¶‡‡∞‡‡®‡Ø.  This is the reason the DEFECT LOG is a
--     legitimate move and silence is not.
--   Vladimir Voevodsky, univalence (2009‚ì2013); `ua`, `uaŒ≤`, `uaŒ`,
--     `transportUAop‚/‚` as in agda/cubical v0.9 ‚î CITED, NOT RE-DERIVED.
--     The corpus rule is that re-deriving what the library has is the
--     failure mode; every library lemma used below is used by name.
--   Nasti_ShabdeJivahVartante.agda ‚î ¬ß‡, ¬ß‡, ¬ß‡ of the ‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞.
--   Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.agda and
--     SetTruncationDescentBoundary.agda ‚î the retraction-form and the
--     ‚à_‚à‚/isSet members of the family ¬ß3 belongs to.  Concurrent lanes,
--     read before ¬ß3 was cut down; see ¬ß3.
--   machine/Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs ‚î the
--     operational lane, another agent's, which ¬ß5 is the Agda side of.
------------------------------------------------------------------------

module Samkramana_TransportCarriesStructureAndTruncationIsTransportExactlyWhenNothingWasThereToLose where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_‚âÉ_ ; equivFun ; invEq ; retEq ; secEq ; invEquiv ; isEquiv
        ; isPropIsEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence
  using (ua ; uaŒ≤ ; ua‚Üí ; isEquivTransport ; transportUAop‚ÇÅ ; transportUAop‚ÇÇ)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.HITs.PropositionalTruncation
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; squash‚ÇÅ ; rec)
open import Cubical.Relation.Nullary using (¬¨_)

open import Nasti_ShabdeJivahVartante
  using (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç ; ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É)

private variable
  ‚Ñì ‚Ñì‚Ä≤ : Level
  A B : Type ‚Ñì

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ ‚î the return.  ‡® ‡ï‡ø‡û‡‡‡ø‡®‡ ‡®‡‡‡Ø‡‡ø, ‡‡æ‡ß‡ø‡‡Æ‡ ‡
--
-- ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ is an equivalence for EVERY e, with no hypothesis on A or B,
-- and the round trip is a term one can run, not an existence claim.
------------------------------------------------------------------------

-- ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ is an equivalence.  (isEquivTransport, cited.)
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ : (e : A ‚âÉ B) ‚Üí isEquiv (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e)
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ e = isEquivTransport (ua e)

-- The return trip, forwards then back, is the identity ‚î pointwise,
-- computed through uaŒ≤ at both steps.
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç : (e : A ‚âÉ B) (a : A) ‚Üí ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç (invEquiv e) (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e a) ‚â° a
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç e a =
    ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É (invEquiv e) (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e a)
  ‚àô cong (invEq e) (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É e a)
  ‚àô retEq e a

-- ‚¶and back then forwards.  Both sides, because a retraction alone is
-- half of losslessness and the ‡‡‡‡‡∞ claims the whole of it.
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Ä≤ : (e : A ‚âÉ B) (b : B) ‚Üí ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç (invEquiv e) b) ‚â° b
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç‚Ä≤ e b =
    ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É e (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç (invEquiv e) b)
  ‚àô cong (equivFun e) (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É (invEquiv e) b)
  ‚àô secEq e b

-- The form the machine cites: every ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ comes with its retraction,
-- as data, unconditionally.  Compare ‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ in ¬ß‡.
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§∏‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç
  : (e : A ‚âÉ B) ‚Üí Œ£[ g ‚àà (B ‚Üí A) ] ((a : A) ‚Üí g (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e a) ‚â° a)
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§∏‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç e = ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç (invEquiv e) , ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç e

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡∞‡‡®‡æ ‡µ‡‡‡ø ‚î the structure is carried.
--
-- ‡µ‡‡®‡Æ‡ S e carries an S-structure across the identification.  The
-- theorems below say WHAT it carries it to: the conjugate, with `e` a
-- homomorphism.  That is the whole content of "nothing is lost", said
-- about structure instead of about points.
------------------------------------------------------------------------

‡§µ‡§π‡§®‡§Æ‡•ç : (S : Type ‚Ñì ‚Üí Type ‚Ñì‚Ä≤) (e : A ‚âÉ B) ‚Üí S A ‚Üí S B
‡§µ‡§π‡§®‡§Æ‡•ç S e = subst S (ua e)

-- Unary operations.  e is a homomorphism from (A, f) to (B, ‡µ‡‡®‡Æ‡ f).
‡§∏‡§Ç‡§∞‡§ö‡§®‡§æ-‡§µ‡§π‡§§‡§ø‚ÇÅ
  : (e : A ‚âÉ B) (f : A ‚Üí A) (a : A)
  ‚Üí equivFun e (f a) ‚â° ‡§µ‡§π‡§®‡§Æ‡•ç (Œª X ‚Üí X ‚Üí X) e f (equivFun e a)
‡§∏‡§Ç‡§∞‡§ö‡§®‡§æ-‡§µ‡§π‡§§‡§ø‚ÇÅ e f a =
  sym ( transportUAop‚ÇÅ e f (equivFun e a)
      ‚àô cong (Œª x ‚Üí equivFun e (f x)) (retEq e a) )

-- Binary operations ‚î the composition-law case, which is the one the
-- machine actually meets (a vocabulary carries an operation, and an
-- identification of vocabularies must carry the operation with it).
‡§∏‡§Ç‡§∞‡§ö‡§®‡§æ-‡§µ‡§π‡§§‡§ø‚ÇÇ
  : {A B : Type ‚Ñì} (e : A ‚âÉ B) (op : A ‚Üí A ‚Üí A) (a a‚Ä≤ : A)
  ‚Üí equivFun e (op a a‚Ä≤)
    ‚â° ‡§µ‡§π‡§®‡§Æ‡•ç (Œª X ‚Üí X ‚Üí X ‚Üí X) e op (equivFun e a) (equivFun e a‚Ä≤)
‡§∏‡§Ç‡§∞‡§ö‡§®‡§æ-‡§µ‡§π‡§§‡§ø‚ÇÇ e op a a‚Ä≤ =
  sym ( transportUAop‚ÇÇ e op (equivFun e a) (equivFun e a‚Ä≤)
      ‚àô cong‚ÇÇ (Œª x y ‚Üí equivFun e (op x y)) (retEq e a) (retEq e a‚Ä≤) )

-- Predicates.  A property of A becomes a property of B, and it is the
-- SAME property: reading the carried predicate at `e a` returns `P a`
-- on the nose (up to a path that is itself exhibited).
--
-- This is the case the machine needs most and the one uaŒ≤ says least
-- about: "these two objects are identified" must license transferring
-- every PROPERTY, not merely relabelling points.
‡§ß‡§∞‡•ç‡§Æ-‡§µ‡§π‡§§‡§ø
  : (e : A ‚âÉ B) (P : A ‚Üí Type ‚Ñì‚Ä≤)
  ‚Üí PathP (Œª i ‚Üí ua e i ‚Üí Type ‚Ñì‚Ä≤) P (Œª b ‚Üí P (invEq e b))
‡§ß‡§∞‡•ç‡§Æ-‡§µ‡§π‡§§‡§ø e P = ua‚Üí (Œª a ‚Üí cong P (sym (retEq e a)))

‡§ß‡§∞‡•ç‡§Æ-‡§Ö‡§≤‡•ã‡§™‡§É
  : (e : A ‚âÉ B) (P : A ‚Üí Type ‚Ñì‚Ä≤) (a : A)
  ‚Üí transport (Œª i ‚Üí ua e i ‚Üí Type ‚Ñì‚Ä≤) P (equivFun e a) ‚â° P a
‡§ß‡§∞‡•ç‡§Æ-‡§Ö‡§≤‡•ã‡§™‡§É e P a =
    funExt‚Åª (fromPathP (‡§ß‡§∞‡•ç‡§Æ-‡§µ‡§π‡§§‡§ø e P)) (equivFun e a)
  ‚àô cong P (retEq e a)

------------------------------------------------------------------------
-- ‡© ¬ ‡®‡‡‡ü‡ø‡ ‚î the other side, and it is the same statement.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚îê
-- ‚î DUPLICATION FOUND AND CUT, 2026-08-20, same day, same repository.‚î
-- ‚îî‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚îò
--
-- This section as first written defined `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‚ A` (the type of ways
-- back from ‚à A ‚à‚), proved `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‚ A ‚í isProp A` and its converse,
-- and derived "no retraction where there is a difference".  All of that
-- is SUBSUMED ‚î and at strictly greater generality ‚î by
--
--     Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.agda ¬ß3‚ì¬ß4
--
-- written concurrently in another lane, which proves
-- `‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ n A ‚â isOfHLevel n A` for EVERY h-level n, shows the
-- retraction type is CONTRACTIBLE when A is an n-type (so nothing is
-- chosen), and recovers the stra's Bool statement as a corollary.  n = 1
-- is my case.  I deleted mine rather than keep a weaker twin: the corpus
-- names re-derivation as its most frequent failure, and a second proof of
-- a special case is that failure even when both are green.
--
-- WHAT IS KEPT is the one statement of the pair that is NOT theirs, and
-- it is not theirs because it is asked in the transport lane's vocabulary
-- rather than the retraction lane's:
--
--     they ask  ‚î does ‚à_‚à‚ have a way BACK?          (hasRetract)
--     this asks ‚î is ‚à_‚à‚ ITSELF a ‡‡‡ï‡‡∞‡Æ‡‡Æ‡?           (isEquiv)
--
-- These are different questions with the same answer, and having both
-- answers is the point: it says the transport/truncation contrast is not
-- an opposition between two moves at all.  ‚à_‚à‚ is a transport EXACTLY
-- when A is a proposition ‚î so truncation is what transport degenerates
-- to at the one h-level where the question "which?" has no answer left to
-- destroy, and everywhere else it is the other road entirely.
--
-- SetTruncationDescentBoundary.agda is the ‚à_‚à‚ / isSet member of the
-- same family, written earlier by a third lane.  Three modules, one fact,
-- indexed by h-level; recorded here so a reader meets it as a family and
-- not as three coincidences.
------------------------------------------------------------------------

-- THE CONTRAST, as one biimplication.  ‚à_‚à‚ is an equivalence ‚î that is,
-- the truncation move IS an identification, and so a ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ via ua ‚î
-- exactly when A is a proposition.
--
-- ‡‡µ‡‡‡‡ã ‡®‡æ‡‡‡‡ø ‡Ø‡¶‡æ ‡®‡‡‡ü‡ ‡ï‡ø‡Æ‡‡ø ‡®‡æ‡‡‡‡ø ‡
‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç‚Üî‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ : isEquiv (‚à£_‚à£‚ÇÅ {A = A}) ‚Üí isProp A
‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç‚Üî‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ {A = A} ie x y =
    sym (retEq (‚à£_‚à£‚ÇÅ , ie) x)
  ‚àô cong (invEq (‚à£_‚à£‚ÇÅ , ie)) (squash‚ÇÅ ‚à£ x ‚à£‚ÇÅ ‚à£ y ‚à£‚ÇÅ)
  ‚àô retEq (‚à£_‚à£‚ÇÅ , ie) y

‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ‚Üî‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : isProp A ‚Üí isEquiv (‚à£_‚à£‚ÇÅ {A = A})
‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ‚Üî‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç {A = A} p =
  snd (isoToEquiv (iso ‚à£_‚à£‚ÇÅ (rec p (Œª a ‚Üí a))
                       (Œª t ‚Üí squash‚ÇÅ ‚à£ rec p (Œª a ‚Üí a) t ‚à£‚ÇÅ t)
                       (Œª _ ‚Üí refl)))

-- Both sides are propositions, so the biimplication is an equivalence and
-- not merely a pair of maps: the two facts are literally one datum.
‡§®‡§∑‡•ç‡§ü‡§ø‡§É‚âÉ‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ : (isEquiv (‚à£_‚à£‚ÇÅ {A = A})) ‚âÉ (isProp A)
‡§®‡§∑‡•ç‡§ü‡§ø‡§É‚âÉ‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ {A = A} =
  isoToEquiv (iso ‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç‚Üî‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ ‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ‚Üî‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
                  (Œª q ‚Üí isPropIsProp _ q)
                  (Œª q ‚Üí isPropIsEquiv ‚à£_‚à£‚ÇÅ _ q))

-- The consequence, in the transport lane's own terms: where there IS a
-- difference, ‚à_‚à‚ is not an identification at all, so ¬ß‡'s first road is
-- CLOSED and only the defect log remains.  ‡®‡‡‡ü‡ø‡∞‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ ‡
-- (The corresponding statement about retractions is
--  Apratikaryatva‚¶¬ß4 `‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡-‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡`; not restated here.)
‡§≠‡•á‡§¶‡•á-‡§®-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç : ¬¨ (isProp A) ‚Üí ¬¨ (isEquiv (‚à£_‚à£‚ÇÅ {A = A}))
‡§≠‡•á‡§¶‡•á-‡§®-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç ¬¨p ie = ¬¨p (‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç‚Üî‡§®‡§ø‡§∞‡•ç‡§ß‡§∞‡•ç‡§Æ‡§§‡§æ ie)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡‡‡Ø‡ ‚î no third road, in its provable form.
--
-- The stra says ‡‡‡‡‡Ø‡ã ‡Æ‡æ‡∞‡‡ó‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡.  Read as a claim about datatypes
-- that is unprovable and uninteresting.  Read as a claim about LOSSLESS
-- moves it is a theorem: a map lossless in both directions cannot be
-- anything but a transport, and its identification is extracted from it
-- constructively.  So "exhibit your equivalence" is never an extra
-- burden ‚î the caller who was lossless already had it.
--
-- THE OTHER HALF, and it is another lane's, written the same day:
--   TritiyaMarga_TheNoThirdPathClaimIsExcludedMiddle.agda
-- proves that the DISJUNCTIVE reading of ‡‡‡‡‡Ø‡ã ‡Æ‡æ‡∞‡‡ó‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡ ‚î every map
-- is either an identification or has a nameable defect ‚î is exactly
-- excluded middle, i.e. classical, not constructive.
--
-- The two results are not in tension and the pair is worth more than
-- either.  Theirs bounds what the sentence can mean: you may not
-- CLASSIFY an arbitrary map into two roads without assuming LEM.  Mine
-- says what survives that bound: you never needed to classify.  A move
-- that IS lossless hands you its identification whether or not anyone can
-- decide, for an arbitrary move, which road it took.  So the machine's
-- discipline ‚î "produce your equivalence or write your defect" ‚î is
-- constructively legitimate as an OBLIGATION ON THE ACTOR, and would be
-- classical only if imposed as a VERDICT ON A STRANGER.
-- ‡‡‡Ø‡æ‡¶‡ ‡‡‡‡‡ø ‡ ‡®‡æ‡‡‡‡ø ‡ : both, under different ‡‡∞‡‡‡.
------------------------------------------------------------------------

‡§Ö‡§§‡•É‡§§‡•Ä‡§Ø‡§É
  : (f : A ‚Üí B) (g : B ‚Üí A)
  ‚Üí (ret : (a : A) ‚Üí g (f a) ‚â° a)
  ‚Üí (sec : (b : B) ‚Üí f (g b) ‚â° b)
  ‚Üí Œ£[ e ‚àà A ‚âÉ B ] ((a : A) ‚Üí ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e a ‚â° f a)
‡§Ö‡§§‡•É‡§§‡•Ä‡§Ø‡§É f g ret sec =
    isoToEquiv (iso f g sec ret)
  , Œª a ‚Üí ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É (isoToEquiv (iso f g sec ret)) a

------------------------------------------------------------------------
-- ‡ ¬ ‡ó‡‡ø ‚î the machine's move, as a type.
--
-- Two constructors.  This is a datatype declaration, NOT a theorem that
-- the world has two moves; see "SYT ‚î THE CLAIM, EXACTLY" above.  What it buys
-- is that a move cannot be performed without producing one of two things:
-- an equivalence, or a written defect.  Silence is not a constructor.
--
-- ‡¶‡ã‡‡≤‡‡ñ carries the map AND the proof that it is not an identification.
-- ‡≤‡ø‡ñ‡ø‡‡ã ‡¶‡ã‡‡ã ‡‡‡µ‡‡ø ‡ ‡‡≤‡ø‡ñ‡ø‡‡ã ‡¶‡ã‡‡ã ‡‡ø‡‡‡æ ‡
--
-- THIS IS THE CHECKED COUNTERPART OF A HASKELL TYPE ANOTHER LANE IS
-- BUILDING RIGHT NOW: `machine/Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs`,
-- whose `Uttara` has these same two constructors, whose `Tulyata` is the
-- exhibited identification, and whose `uVahita` is the carried structure.
-- ¬ß2 above is the theorem that record is entitled to cite: given the
-- equivalence, the carried operations ARE the conjugates and the
-- identification IS a homomorphism, so `uVahita` is not a claim about
-- what travelled ‚î it is determined.  I am NOT reimplementing that
-- module; the operational lane is theirs and this is the Agda side of it.
------------------------------------------------------------------------

data ‡§ó‡§§‡§ø (A B : Type ‚Ñì) : Type (‚Ñì-suc ‚Ñì) where
  ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§ó‡§§‡§ø‡§É : (e : A ‚âÉ B) ‚Üí ‡§ó‡§§‡§ø A B
  ‡§¶‡•ã‡§∑‡§≤‡•á‡§ñ-‡§ó‡§§‡§ø‡§É  : (f : A ‚Üí B) (‡§¶‡•ã‡§∑‡§É : ¬¨ (isEquiv f)) ‚Üí ‡§ó‡§§‡§ø A B

-- Every move denotes a function; the defect log does not block the work,
-- it accompanies it.  (¬ß‡: the second road is a road, not a refusal.)
‡§ö‡§æ‡§≤‡§®‡§Æ‡•ç : ‡§ó‡§§‡§ø A B ‚Üí (A ‚Üí B)
‡§ö‡§æ‡§≤‡§®‡§Æ‡•ç (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§ó‡§§‡§ø‡§É e) = ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e
‡§ö‡§æ‡§≤‡§®‡§Æ‡•ç (‡§¶‡•ã‡§∑‡§≤‡•á‡§ñ-‡§ó‡§§‡§ø‡§É f _) = f

-- ‚¶and only the first road has a return.
‡§ó‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç
  : (e : A ‚âÉ B) ‚Üí Œ£[ g ‚àà (B ‚Üí A) ] ((a : A) ‚Üí g (‡§ö‡§æ‡§≤‡§®‡§Æ‡•ç (‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§ó‡§§‡§ø‡§É e) a) ‚â° a)
‡§ó‡§§‡§ø-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç e = ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§∏‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç e

------------------------------------------------------------------------
-- ‡‡‡ø‡‡‡æ ‡  ‡‡‡ï‡‡∞‡Æ‡‡ ‡® ‡ï‡ø‡û‡‡‡ø‡®‡ ‡®‡‡‡Ø‡‡ø ‚î ‡‡¶‡æ‡®‡‡ ‡‡æ‡ß‡ø‡‡Æ‡, ‡® ‡â‡ï‡‡‡Æ‡æ‡‡‡∞‡Æ‡ ‡
------------------------------------------------------------------------
