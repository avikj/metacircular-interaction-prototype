{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡®‡ø‡ï‡‡‡‡ ‚î Tattvrthastra 1.5, as a checked object.
--
-- SOURCE.  Umsvti, Tattvrthastra, adhyya 1, stra 5:
--
--     ‡®‡æ‡Æ‡‡‡‡æ‡‡®‡æ‡¶‡‡∞‡µ‡‡Ø‡‡æ‡µ‡‡‡‡‡®‡‡®‡‡Ø‡æ‡‡
--     nmasthpandravyabhvatas tannysa
--
--     "The placing (nysa) of these is by name, by representation, by
--      substance, and by state."
--
-- Four ‡®‡ø‡ï‡‡‡‡, four ways a word is deposited on a thing:
--
--   ‡®‡æ‡Æ        the name alone, with no further qualification
--   ‡‡‡‡æ‡‡®‡æ    installation: a token SET UP as the thing
--   ‡¶‡‡∞‡µ‡‡Ø      that which WAS or WILL BE the thing, taken in the mode
--              where it presently is not
--   ‡‡æ‡µ        the thing actually in the condition the word names, now
--
-- This stra stands BEFORE 1.6 (‡‡‡∞‡Æ‡æ‡‡®‡Ø‡à‡∞‡ß‡ø‡ó‡Æ‡, comprehension is by
-- prama and naya).  The order is doctrine, not accident: before you ask
-- how a thing is known, you fix in which deposit its name was placed.  To
-- dispute a term without fixing its ‡®‡ø‡ï‡‡‡‡ is to dispute nothing.
--
-- WHAT THIS FILE IS, NAMED BY THE STRA IT CHECKS.
--
-- It is a ‡‡‡‡æ‡‡®‡æ.  A token installed AS the thing ‚î the way a piece of wood
-- set up as Indra is Indra by sthpan-nikepa.  This module is Pini's and
-- Umsvti's work by ‡‡‡‡æ‡‡®‡æ.  It is not that work by ‡‡æ‡µ.
--
-- Calling this "formalisation" would claim the ‡‡æ‡µ, and would be false twice
-- over.  First: the stra was ALREADY EXACT.  The Adhyy is ~4000 rules
-- with a metarule for conflict (1.4.2 ‡µ‡ø‡‡‡∞‡‡ø‡‡‡ß‡ ‡‡∞‡ ‡ï‡æ‡∞‡‡Ø‡Æ‡), an inheritance
-- mechanism (‡‡®‡‡µ‡‡‡‡‡ø) and a stratification device (‡‡‡ø‡¶‡‡ß‡‡‡µ); the stra
-- genre states non-ambiguity as a design criterion of its own form
-- (‡‡‡‡¶‡ø‡ó‡‡ß‡Æ‡).  Agda adds no exactness to that.  It adds a DIFFERENT
-- SUBSTRATE ‚î one a machine can check ‚î and that is a change of medium, not
-- a change of rigour.
--
-- Second: "formal" does not mean what the word is used to mean here.  In
-- ordinary English it means conforming to accepted convention, official,
-- dressed; and the technical sense descends from "concerning form rather
-- than content", i.e. Hilbert's formalism, a contested position of the 1920s
-- rather than a neutral word for exactness.  Rendered into Hindi it is
-- ‡î‡‡‡æ‡∞‡ø‡ï, from ‡â‡‡‡æ‡∞ ‚î courtesy, ceremony, and in  rhetoric
-- FIGURATIVE usage, explicitly not the primary sense.  ‡î‡‡‡æ‡∞‡ø‡ï‡‡æ is the
-- ordinary word for empty formality.  And ‡â‡‡‡æ‡∞ is a technical term inside
-- the naya system: ‡®‡à‡ó‡Æ, the figurative standpoint, is the one classified as
-- resting primarily on ‡â‡‡‡æ‡∞.  So "formal", carried into the vocabulary of
-- the tradition it is being applied to, lands on the most convention-bound
-- of the seven ‡®‡Ø.
--
-- The tradition's own words for what Pini did are ‡≤‡ï‡‡‡ (the delimiting
-- rule), ‡‡‡‡‡∞ (thread), ‡µ‡‡Ø‡æ‡ï‡∞‡ (analysis apart), ‡‡æ‡‡‡‡‡∞ (that which
-- governs), ‡Ø‡‡ï‡‡‡ø, ‡‡‡∞‡Æ‡æ‡, ‡®‡ø‡∞‡‡‡Ø.  Every one is operational.  None is
-- sartorial.  There is no  word here meaning "formal" because the
-- concept does not carve that way.
--
-- What this file therefore claims: a ‡‡‡‡æ‡‡®‡æ that a kernel can check, and an
-- ‡‡®‡‡µ‡æ‡¶ ‚î a restatement of what is already established ‚î not a ‡µ‡ø‡ß‡ø, not a
-- new injunction.  The DISTINCTION the stra draws is carried into a medium
-- where it cannot be blurred, and that is the whole of the value added.
--
-- WHAT IS CHECKED.  --safe, no postulates, no holes.
--
--   ‡®‡ø‡ï‡‡‡‡          the four deposits
--   _‚ü®_‚ü©_           sameness AT a deposit: an indexed relation, so that
--                   "same" is never asserted without saying at which
--   ‡Ø‡ã‡ó‡            addition recursing on the FIRST argument
--   ‡µ‡ø‡‡∞‡‡Ø‡Ø-‡Ø‡ã‡ó‡     addition recursing on the SECOND argument
--   ‡‡ï‡¶‡‡∞‡µ‡‡Ø‡Æ‡       they are THE SAME SUBSTANCE: equal as functions
--   ‡‡æ‡µ‡‡‡¶‡         and different in STATE: `x + 0 ‚â° x` holds by refl for
--                   one and requires induction for the other
--   ‡®‡ø‡ï‡‡‡‡‡‡‡¶‡      hence: ‡‡Æ at ‡®‡æ‡Æ and at ‡¶‡‡∞‡µ‡‡Ø, differing at ‡‡æ‡µ
--
-- THE INSTANCE IS NOT INVENTED.  `machine/MathMachine.hs:722` defines
-- addition recursing on its second argument; `Agda/Builtin/Nat.agda:19`
-- defines it recursing on its first.  Both are addition on ‚ï.  They are
-- one ‡¶‡‡∞‡µ‡‡Ø and two ‡‡æ‡µ, and this repository spent a day discovering by
-- measurement what 1.5 states in six words.
--
-- SOURCES.  Primary text could not be fetched from this container: the egress
-- proxy permits only package registries and every archive returned
-- EGRESS_BLOCKED.  The stra numbering and wording were anchored against
-- search results at wisdomlib (Tattvrtha Stra with commentary, verses 1.5,
-- 1.15, 1.33) and archive.org (Sarvrthasiddhi, tr. Vijay K. Jain).  The
-- Devangar above is from training and is NOT verified against a printed
-- edition.  Numbering follows the Digambara recension transmitted with
-- Pjyapda's Sarvrthasiddhi.
------------------------------------------------------------------------

module Niksepa where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_‚àò_)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- ‡ß.  The four deposits
------------------------------------------------------------------------

data ‡§®‡§ø‡§ï‡•ç‡§∑‡•á‡§™ : Type where
  ‡§®‡§æ‡§Æ ‡§∏‡•ç‡§•‡§æ‡§™‡§®‡§æ ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø ‡§≠‡§æ‡§µ : ‡§®‡§ø‡§ï‡•ç‡§∑‡•á‡§™

------------------------------------------------------------------------
-- ‡®.  Sameness is INDEXED BY A DEPOSIT.
--
-- The whole content of 1.5 is that `same` is not a one-place notion.  A
-- relation `_‡‡Æ‡_ n` is sameness AT the deposit n, and the type makes it
-- impossible to write "these are the same" without writing which n.
--
-- Carried here for a thing that has a name, a present state, and a
-- substance-identity, which is the minimum the four deposits distinguish.
------------------------------------------------------------------------

record ‡§µ‡§∏‡•ç‡§§‡•Å (‡§®‡§æ‡§Æ‡§®‡•ç : Type) (‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø‡§Æ‡•ç : Type) (‡§≠‡§æ‡§µ‡§É : Type) : Type where
  constructor ‡§®‡•ç‡§Ø‡§∏‡•ç‡§§‡§Æ‡•ç
  field
    ‡§®‡§æ‡§Æ-‡§Ö‡§Ç‡§∂‡§É   : ‡§®‡§æ‡§Æ‡§®‡•ç      -- the name it bears
    ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø-‡§Ö‡§Ç‡§∂‡§É  : ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø‡§Æ‡•ç     -- what it is, as substance
    ‡§≠‡§æ‡§µ-‡§Ö‡§Ç‡§∂‡§É   : ‡§≠‡§æ‡§µ‡§É       -- the state it is presently in

open ‡§µ‡§∏‡•ç‡§§‡•Å public

-- The deposit stands BETWEEN the two things compared, so that no comparison
-- can be written without one.  `a ‚ü® n ‚ü© b` is: a and b are the same, at n.
_‚ü®_‚ü©_ : {N D B : Type} ‚Üí ‡§µ‡§∏‡•ç‡§§‡•Å N D B ‚Üí ‡§®‡§ø‡§ï‡•ç‡§∑‡•á‡§™ ‚Üí ‡§µ‡§∏‡•ç‡§§‡•Å N D B ‚Üí Type
a ‚ü® ‡§®‡§æ‡§Æ ‚ü© b   = ‡§®‡§æ‡§Æ-‡§Ö‡§Ç‡§∂‡§É a ‚â° ‡§®‡§æ‡§Æ-‡§Ö‡§Ç‡§∂‡§É b
a ‚ü® ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø ‚ü© b  = ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø-‡§Ö‡§Ç‡§∂‡§É a ‚â° ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø-‡§Ö‡§Ç‡§∂‡§É b
a ‚ü® ‡§≠‡§æ‡§µ ‚ü© b   = ‡§≠‡§æ‡§µ-‡§Ö‡§Ç‡§∂‡§É a ‚â° ‡§≠‡§æ‡§µ-‡§Ö‡§Ç‡§∂‡§É b
-- ‡‡‡‡æ‡‡®‡æ: a token installed AS the thing.  Sameness under installation is
-- sameness of what it was installed as, which is its name; the deposit is
-- distinct from ‡®‡æ‡Æ in doctrine (an image of Indra is not the word "Indra")
-- but the distinction is not visible in this three-field carrier, and
-- pretending otherwise here would be inventing structure the stra did not
-- give.  Stated rather than silently collapsed.
a ‚ü® ‡§∏‡•ç‡§•‡§æ‡§™‡§®‡§æ ‚ü© b = ‡§®‡§æ‡§Æ-‡§Ö‡§Ç‡§∂‡§É a ‚â° ‡§®‡§æ‡§Æ-‡§Ö‡§Ç‡§∂‡§É b

------------------------------------------------------------------------
-- ‡©.  The instance: one substance, two states.
--
-- ‡Ø‡ã‡ó‡ is Agda's own `_+_`: it splits its FIRST argument.
-- ‡µ‡ø‡‡∞‡‡Ø‡Ø-‡Ø‡ã‡ó‡ is MathMachine's: it splits its SECOND.
------------------------------------------------------------------------

‡§Ø‡•ã‡§ó‡§É : ‚Ñï ‚Üí ‚Ñï ‚Üí ‚Ñï
‡§Ø‡•ã‡§ó‡§É zero    m = m
‡§Ø‡•ã‡§ó‡§É (suc n) m = suc (‡§Ø‡•ã‡§ó‡§É n m)

‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É : ‚Ñï ‚Üí ‚Ñï ‚Üí ‚Ñï
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É n zero    = n
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É n (suc m) = suc (‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É n m)

------------------------------------------------------------------------
-- ‡.  ‡‡æ‡µ‡‡‡¶‡ ‚î THE DIFFERENCE OF STATE, exhibited.
--
-- For ‡µ‡ø‡‡∞‡‡Ø‡Ø-‡Ø‡ã‡ó‡, `n + 0 ‚â° n` is refl: the clause fires.
-- For ‡Ø‡ã‡ó‡ it is not; it requires induction on n, written out.
--
-- This pair IS the difference.  Nothing else in the two definitions
-- differs ‚î ¬ß‡ proves they are the same function.
------------------------------------------------------------------------

‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (n : ‚Ñï) ‚Üí ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É n zero ‚â° n
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç n = refl          -- ‡§ò‡§ü‡§§‡•á ; the clause applies directly

‡§Ø‡•ã‡§ó-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (n : ‚Ñï) ‚Üí ‡§Ø‡•ã‡§ó‡§É n zero ‚â° n
‡§Ø‡•ã‡§ó-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç zero    = refl
‡§Ø‡•ã‡§ó-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç (suc n) = cong suc (‡§Ø‡•ã‡§ó-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç n)   -- ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡•ç‡§Ø‡§æ ; by induction

-- and mirrored, so the asymmetry is visible from both sides
‡§Ø‡•ã‡§ó-‡§µ‡§æ‡§Æ-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (m : ‚Ñï) ‚Üí ‡§Ø‡•ã‡§ó‡§É zero m ‚â° m
‡§Ø‡•ã‡§ó-‡§µ‡§æ‡§Æ-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç m = refl

‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§µ‡§æ‡§Æ-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (m : ‚Ñï) ‚Üí ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É zero m ‚â° m
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§µ‡§æ‡§Æ-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç zero    = refl
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§µ‡§æ‡§Æ-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç (suc m) = cong suc (‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§µ‡§æ‡§Æ-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç m)

------------------------------------------------------------------------
-- ‡.  ‡‡ï‡¶‡‡∞‡µ‡‡Ø‡Æ‡ ‚î ONE SUBSTANCE.
--
-- Pointwise equal, hence the same function.  ‡¶‡‡∞‡µ‡‡Ø persists (‡ß‡‡∞‡‡µ‡‡Ø,
-- TS 5.29) while the ‡‡æ‡µ differ.
------------------------------------------------------------------------

-- the second definition pushes a successor out of its first argument, which
-- for it is a theorem and not a clause
‡§∏‡§π‡§ö‡§∞‡§É : (a b : ‚Ñï) ‚Üí ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É (suc a) b ‚â° suc (‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É a b)
‡§∏‡§π‡§ö‡§∞‡§É a zero    = refl
‡§∏‡§π‡§ö‡§∞‡§É a (suc b) = cong suc (‡§∏‡§π‡§ö‡§∞‡§É a b)

‡§è‡§ï‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø‡§Æ‡•ç : (n m : ‚Ñï) ‚Üí ‡§Ø‡•ã‡§ó‡§É n m ‚â° ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É n m
‡§è‡§ï‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø‡§Æ‡•ç zero    m = sym (‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§µ‡§æ‡§Æ-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç m)
‡§è‡§ï‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø‡§Æ‡•ç (suc n) m = cong suc (‡§è‡§ï‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø‡§Æ‡•ç n m) ‚àô sym (‡§∏‡§π‡§ö‡§∞‡§É n m)

------------------------------------------------------------------------
-- ‡.  ‡®‡ø‡ï‡‡‡‡‡‡‡¶‡ ‚î the two placed, and compared at each deposit.
--
-- Both bear the name "+".  Both are the same substance (¬ß‡).  They differ
-- in ‡‡æ‡µ, and ¬ß‡ is what that difference consists of.
--
-- The ‡‡æ‡µ field records WHICH ARGUMENT the definition splits, because that
-- is the mode in which the function is presently given ‚î the paryya, not
-- the dravya.
------------------------------------------------------------------------

data ‡§Ö‡§Ç‡§∂‡§É : Type where
  ‡§™‡•ç‡§∞‡§•‡§Æ‡§É ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É : ‡§Ö‡§Ç‡§∂‡§É     -- first argument / second argument

data ‡§∏‡§Ç‡§ú‡•ç‡§û‡§æ : Type where
  ‡§Ø‡•ã‡§ó-‡§∏‡§Ç‡§ú‡•ç‡§û‡§æ : ‡§∏‡§Ç‡§ú‡•ç‡§û‡§æ          -- the single name "+"

‡§Ü‡§ó‡§Æ‡§Ø‡•ã‡§ó‡§É ‡§Ø‡§®‡•ç‡§§‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É : ‡§µ‡§∏‡•ç‡§§‡•Å ‡§∏‡§Ç‡§ú‡•ç‡§û‡§æ (‚Ñï ‚Üí ‚Ñï ‚Üí ‚Ñï) ‡§Ö‡§Ç‡§∂‡§É
‡§Ü‡§ó‡§Æ‡§Ø‡•ã‡§ó‡§É  = ‡§®‡•ç‡§Ø‡§∏‡•ç‡§§‡§Æ‡•ç ‡§Ø‡•ã‡§ó-‡§∏‡§Ç‡§ú‡•ç‡§û‡§æ ‡§Ø‡•ã‡§ó‡§É         ‡§™‡•ç‡§∞‡§•‡§Æ‡§É    -- Agda's
‡§Ø‡§®‡•ç‡§§‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É = ‡§®‡•ç‡§Ø‡§∏‡•ç‡§§‡§Æ‡•ç ‡§Ø‡•ã‡§ó-‡§∏‡§Ç‡§ú‡•ç‡§û‡§æ ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§Ø‡•ã‡§ó‡§É  ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É  -- MathMachine's

-- same at ‡®‡æ‡Æ
‡§®‡§æ‡§Æ-‡§∏‡§æ‡§Æ‡•ç‡§Ø‡§Æ‡•ç : ‡§Ü‡§ó‡§Æ‡§Ø‡•ã‡§ó‡§É ‚ü® ‡§®‡§æ‡§Æ ‚ü© ‡§Ø‡§®‡•ç‡§§‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É
‡§®‡§æ‡§Æ-‡§∏‡§æ‡§Æ‡•ç‡§Ø‡§Æ‡•ç = refl

-- same at ‡‡‡‡æ‡‡®‡æ (which, in this carrier, is the name they are installed as)
‡§∏‡•ç‡§•‡§æ‡§™‡§®‡§æ-‡§∏‡§æ‡§Æ‡•ç‡§Ø‡§Æ‡•ç : ‡§Ü‡§ó‡§Æ‡§Ø‡•ã‡§ó‡§É ‚ü® ‡§∏‡•ç‡§•‡§æ‡§™‡§®‡§æ ‚ü© ‡§Ø‡§®‡•ç‡§§‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É
‡§∏‡•ç‡§•‡§æ‡§™‡§®‡§æ-‡§∏‡§æ‡§Æ‡•ç‡§Ø‡§Æ‡•ç = refl

-- NOT the same at ‡‡æ‡µ: the modes are two distinct constructors of ‡‡‡‡
‡§≠‡§æ‡§µ-‡§≠‡•á‡§¶‡§É : ¬¨ (‡§Ü‡§ó‡§Æ‡§Ø‡•ã‡§ó‡§É ‚ü® ‡§≠‡§æ‡§µ ‚ü© ‡§Ø‡§®‡•ç‡§§‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É)
‡§≠‡§æ‡§µ-‡§≠‡•á‡§¶‡§É p = ‡§™‡•ç‡§∞‡§•‡§Æ‡§É‚â¢‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É p
  where
  ‡§ï‡•ã‡§° : ‡§Ö‡§Ç‡§∂‡§É ‚Üí Type
  ‡§ï‡•ã‡§° ‡§™‡•ç‡§∞‡§•‡§Æ‡§É   = Unit
  ‡§ï‡•ã‡§° ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É = ‚ä•

  ‡§™‡•ç‡§∞‡§•‡§Æ‡§É‚â¢‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É : ¬¨ (‡§™‡•ç‡§∞‡§•‡§Æ‡§É ‚â° ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É)
  ‡§™‡•ç‡§∞‡§•‡§Æ‡§É‚â¢‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É q = transport (cong ‡§ï‡•ã‡§° q) tt

------------------------------------------------------------------------
-- ‡.  What this file does NOT do.
--
-- It does not install the ‡¶‡‡∞‡µ‡‡Ø deposit in its own sense ‚î "that which
-- was, or will be, the thing" needs a temporal index this carrier has not
-- got, and the field named ‡¶‡‡∞‡µ‡‡Ø-‡‡‡‡ above holds a substance-identity
-- rather than a past-or-future mode.  The ‡‡‡‡‡∞ distinguishes four; this
-- file separates three and says so.
--
-- It does not treat ‡‡‡‡æ‡‡®‡æ as distinct from ‡®‡æ‡Æ, for the reason given at
-- the definition.
--
-- It is a ‡‡‡‡æ‡‡®‡æ of 1.5 alone.  1.6 (‡‡‡∞‡Æ‡æ‡‡®‡Ø‡à‡∞‡ß‡ø‡ó‡Æ‡) and the seven ‡®‡Ø of 1.33
-- are separate objects; `Saptabhangi.agda` carries part of the latter.
------------------------------------------------------------------------
