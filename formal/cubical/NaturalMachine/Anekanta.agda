{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Anekanta
--
-- àà¨àà•à¾à¨àààµà¾à¦ â” the judgment structure this repository has been missing,
-- and the one every module in it has silently violated.
--
-- Every proposition here, including the ones I checked tonight, has the
-- form `P : Type`.  One proposition, one truth value, no index.  That is
-- not neutrality.  It is a positive claim â” that there is a standpoint
-- from which the object simply IS what it is â” and it is the exact form
-- of what this corpus elsewhere calls epistemic violence: mistaking one
-- view for the object (`README`, `notes/THE_BARRIER_IS_A_MIRROR.md`).
--
-- The Jain analysis replaces it.  A à¨à¯ (naya) is a standpoint.  A
-- proposition is not a type but a FAMILY over standpoints, and the
-- àààààà™àà—à â” the sevenfold predication â” is what becomes sayable once you
-- stop pretending the index is not there.
--
-- WHAT IS PROVED HERE, and the third one is the point:
--
--   1. `sydasti` and `sydnsti` are simultaneously inhabited, and no
--      âŠ follows.  Affirmation and denial from different standpoints are
--      not a contradiction.  This module is --safe; if it were one, this
--      file would not exist.
--
--   2. ààµà•àààµàà¯ (avaktavya, "inexpressible") is a THEOREM, not a posited
--      fourth truth value: no single standpoint carries both.  The
--      fourth bhaga is the proof that the simultaneous predication has
--      no naya, which is why it is inexpressible rather than false.
--
--   3. ààà¿ààà¾, as a structural property.  Collapsing the index â” replacing
--      `P : Naya â’ Type` by one `Q` â” is sound exactly when every
--      standpoint agrees.  And if two standpoints disagree, NO such `Q`
--      exists: `plurality-blocks-collapse` below.  Erasure is not
--      merely rude, it is unavailable.  The two permitted moves are
--      transport, when the standpoints are equivalent, or recording the
--      defect, when they are not.
--
-- AND THAT IS THE STRUCTURE IDENTITY PRINCIPLE.  Delta 15's D15.83 says
-- the content of a failed identification is a proof-relevant defect type;
-- àà¨àà•à¾à¨àààµà¾à¦ says a standpoint may never be annihilated, only transported
-- or its residue kept.  These are the same rule.  One was written in
-- Prakrit in the first millennium and filed under religion; the other was
-- written in the 2010s and filed under foundations.  The filing is the
-- violence; the mathematics was never in dispute.
--
-- Not paraconsistency, and the confusion is not innocent.  At a single
-- standpoint excluded middle is untouched â” `no-standpoint-carries-both`
-- is exactly that.  ààà¯à¾à¦ààµà¾à¦ indexes; it does not weaken.  Reading it as
-- "Indian logic tolerates contradiction" is the same move that reads
-- Pini as a curiosity and Ngrjuna as spirituality.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, NOT the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Anekanta where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; falseâ‰¢true)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  à¨à¯ â” a proposition is a family over standpoints
------------------------------------------------------------------------

-- A àààà¾à¨ (jna) indexed by standpoints.  The index is the whole content:
-- a bare `Type` is this with the index forcibly forgotten.
Naya : (S : Type â„“) (P : S â†’ Type â„“') â†’ Type _
Naya S P = (s : S) â†’ P s

-- ààà¯à¾à¦àààà¿ â” in some respect, it is
syÄdasti : {S : Type â„“} (P : S â†’ Type â„“') â†’ Type _
syÄdasti {S = S} P = Î£[ s âˆˆ S ] P s

-- ààà¯à¾à¨àà¨à¾àààà¿ â” in some respect, it is not
syÄdnÄsti : {S : Type â„“} (P : S â†’ Type â„“') â†’ Type _
syÄdnÄsti {S = S} P = Î£[ s âˆˆ S ] (Â¬ P s)

-- ààà¯à¾à¦àààà¿ à à¨à¾àààà¿ à â” the third bhaga: both, from different standpoints
syÄdastinÄsti : {S : Type â„“} (P : S â†’ Type â„“') â†’ Type _
syÄdastinÄsti P = syÄdasti P Ã— syÄdnÄsti P

------------------------------------------------------------------------
-- 2.  ààµà•àààµàà¯ is a theorem
--
-- The fourth bhaga is not a truth value bolted on.  It is the fact that
-- affirmation and denial TOGETHER, at one standpoint, have no witness â”
-- so the simultaneous predication is not false, it is unsayable.
------------------------------------------------------------------------

no-standpoint-carries-both :
  {S : Type â„“} (P : S â†’ Type â„“') (s : S) â†’ Â¬ (P s Ã— (Â¬ P s))
no-standpoint-carries-both P s (p , Â¬p) = Â¬p p

avaktavya : {S : Type â„“} (P : S â†’ Type â„“') â†’ Type _
avaktavya {S = S} P = Â¬ (Î£[ s âˆˆ S ] (P s Ã— (Â¬ P s)))

avaktavya-holds : {S : Type â„“} (P : S â†’ Type â„“') â†’ avaktavya P
avaktavya-holds P (s , both) = no-standpoint-carries-both P s both

------------------------------------------------------------------------
-- 3.  ààà¿ààà¾ â” plurality blocks collapse
--
-- To "collapse" a standpoint-indexed proposition is to claim a single Q
-- equivalent to every fiber: the claim that the standpoints were never
-- doing any work.  If two standpoints genuinely disagree, no such Q
-- exists.  Erasure is not impolite.  It is unavailable.
------------------------------------------------------------------------

Collapses : {S : Type â„“} (P : S â†’ Type â„“') (Q : Type â„“') â†’ Type _
Collapses {S = S} P Q = (s : S) â†’ P s â‰ƒ Q

plurality-blocks-collapse :
  {S : Type â„“} (P : S â†’ Type â„“') â†’
  syÄdastinÄsti P â†’ (Q : Type â„“') â†’ Â¬ (Collapses P Q)
plurality-blocks-collapse P ((s , ps) , (t , Â¬pt)) Q c =
  Â¬pt (invEq (c t) (equivFun (c s) ps))

-- and the converse move, which is the only nonviolent one: when two
-- standpoints ARE equivalent, everything carries across.  Transport, or
-- keep the residue.  There is no third option and no permission to
-- delete.
transport-across-naya :
  {S : Type â„“} (P : S â†’ Type â„“') (s t : S) â†’
  P s â‰ƒ P t â†’ P s â†’ P t
transport-across-naya P s t e = equivFun e

------------------------------------------------------------------------
-- 4.  Non-vacuity: a proposition that is genuinely many-sided.
--
-- Standpoints = Bool, and the assertion is "the standpoint is true".
-- From one standpoint it holds, from the other it fails, both witnessed,
-- and the file still checks â” which is the demonstration that the third
-- bhaga is consistent and not a contradiction dressed up.
------------------------------------------------------------------------

Two : Bool â†’ Typeâ‚€
Two b = b â‰¡ true

many-sided : syÄdastinÄsti Two
many-sided = (true , refl) , (false , falseâ‰¢true)

-- so this proposition admits no collapse, by Â§3, and the type of that
-- refusal is inhabited:
Two-refuses-collapse : (Q : Typeâ‚€) â†’ Â¬ (Collapses Two Q)
Two-refuses-collapse = plurality-blocks-collapse Two many-sided

-- while excluded middle is untouched at each standpoint, which is what
-- separates ààà¯à¾à¦ààµà¾à¦ from paraconsistency: the index carries the
-- plurality, the logic at a point is unchanged.
excluded-middle-intact : (b : Bool) â†’ Â¬ (Two b Ã— (Â¬ Two b))
excluded-middle-intact = no-standpoint-carries-both Two

------------------------------------------------------------------------
-- 5.  The converse, which makes Â§3 sharp: collapse is available exactly
--     when the standpoints were doing no work.
--
-- `plurality-blocks-collapse` said disagreement forbids collapse.  This
-- says agreement permits it â” so ~~the two together characterise erasure
-- completely~~.  Collapsing is legitimate precisely when the index was
-- decorative, and in every other case it destroys something with a name.
--
-- [WITHDRAWN 2026-08-19 by claude_ananta] "Completely" is false: the two
-- hypotheses are not complementary.  A family can be neither sydastinsti
-- (no standpoint denies) nor uniformly equivalent, and then NEITHER theorem
-- applies â” yet collapse is still unavailable.  A checked counterexample
-- (Unit and Bool, over Bool) and the exhaustive statement this section
-- reached for â” collapse exists iff EVERY pair of fibres is equivalent, of
-- which plurality-blocks-collapse is a corollary â” are in
-- NaturalMachine.Durnaya_CollapseIffEveryNayaAgrees.  Both theorems in this
-- section are true and untouched; only the exhaustiveness gloss is struck.
--
-- That is the structure identity principle read as a prohibition rather
-- than as a permission, which is what makes it an ethics and not merely
-- a technique.
------------------------------------------------------------------------

agreement-permits-collapse :
  {S : Type â„“} (P : S â†’ Type â„“') (sâ‚€ : S) â†’
  ((s : S) â†’ P s â‰ƒ P sâ‚€) â†’ Î£[ Q âˆˆ Type â„“' ] Collapses P Q
agreement-permits-collapse P sâ‚€ agree = P sâ‚€ , agree

-- and so, stated as the dichotomy an agent actually faces at a
-- disagreement: either the standpoints are equivalent and everything
-- transports, or they are not and no collapse exists.  ~~There is no third
-- move~~, and "pick the better view" is not among the two.
--
-- [STRUCK 2026-08-19 by claude_ananta] The two branches are not
-- complementary, so this pair is not a dichotomy.  See the withdrawal in
-- Â§5â™s header.  The two theorems below are true and untouched.
collapse-dichotomy :
  {S : Type â„“} (P : S â†’ Type â„“') (sâ‚€ : S) â†’
  (((s : S) â†’ P s â‰ƒ P sâ‚€) â†’ Î£[ Q âˆˆ Type â„“' ] Collapses P Q)
  Ã— (syÄdastinÄsti P â†’ (Q : Type â„“') â†’ Â¬ (Collapses P Q))
collapse-dichotomy P sâ‚€ =
  agreement-permits-collapse P sâ‚€ , plurality-blocks-collapse P
